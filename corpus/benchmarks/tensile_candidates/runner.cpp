// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT
#include <Tensile/ContractionLibrary.hpp>
#include <Tensile/DataTypes.hpp>
#include <Tensile/ContractionProblem.hpp>
#include <Tensile/ContractionSolution.hpp>
#include <Tensile/MasterSolutionLibrary.hpp>
#include <Tensile/hip/HipHardware.hpp>
#include <Tensile/hip/HipSolutionAdapter.hpp>
#include <hip/hip_runtime.h>
#include <algorithm>
#include <chrono>
#include <cmath>
#include <cstring>
#include <filesystem>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <limits>
#include <vector>

namespace {
void check(hipError_t result) {
    if (result != hipSuccess) throw std::runtime_error(hipGetErrorString(result));
}
struct Buffer {
    void* data = nullptr;
    explicit Buffer(size_t bytes) { if (bytes) check(hipMalloc(&data, bytes)); }
    ~Buffer() { if (data) (void)hipFree(data); }
    Buffer(const Buffer&) = delete;
    Buffer& operator=(const Buffer&) = delete;
};
uint16_t bf16(float value) {
    uint32_t bits;
    std::memcpy(&bits, &value, sizeof(bits));
    return (bits + 0x7fff + ((bits >> 16) & 1)) >> 16;
}
float fp32(uint16_t value) {
    uint32_t bits = uint32_t(value) << 16;
    float result;
    std::memcpy(&result, &bits, sizeof(result));
    return result;
}
int positive(const char* value, bool zero = false) {
    size_t end;
    const auto parsed = std::stoll(value, &end);
    if (value[end] || parsed < (zero ? 0 : 1) || parsed > 65536)
        throw std::invalid_argument("invalid integer argument");
    return int(parsed);
}
}

int main(int argc, char** argv) {
    try {
        if (argc != 10) throw std::invalid_argument("expected artifact-dir variant target m n k warmups samples output");
        const std::filesystem::path root(argv[1]);
        const std::string variant(argv[2]), target(argv[3]);
        const bool mx = variant == "mxfp8_subtile" || variant == "mxfp4_streamk";
        const bool fp4 = variant == "mxfp4_streamk";
        const bool transA = variant != "bf16_streamk", transB = !transA;
        if (!mx && variant != "bf16_subtile" && variant != "bf16_streamk")
            throw std::invalid_argument("unknown native candidate");
        const int m=positive(argv[4]), n=positive(argv[5]), k=positive(argv[6]);
        const int warmups=positive(argv[7],true), samples=positive(argv[8]);
        hipDeviceProp_t properties{};
        int device;
        check(hipGetDevice(&device));
        check(hipGetDeviceProperties(&properties,device));
        const std::string actual(properties.gcnArchName);
        if (actual != target && actual.rfind(target+":",0) != 0)
            throw std::runtime_error("HIP target mismatch");
        auto hardware = TensileLite::hip::GetCurrentDevice();
        auto library = std::dynamic_pointer_cast<TensileLite::MasterContractionLibrary>(
            TensileLite::LoadLibraryFile<TensileLite::ContractionProblemGemm>((root/"TensileLibrary.yaml").string()));
        if (!library || library->solutions.size()!=1)
            throw std::runtime_error("candidate requires exactly one fixed Tensile solution");
        auto solution=library->solutions.begin()->second;
        TensileLite::hip::SolutionAdapter adapter;
        // Let Tensile choose a compatible helper object (including xnack), and
        // initialize its reload paths before loading the assembly object.
        std::cout<<"phase=artifact_load target="<<target<<std::endl;
        check(adapter.initializeLazyLoading(target,root.string()));
        for (const auto& entry : std::filesystem::directory_iterator(root)) {
            const auto ext=entry.path().extension();
            if (ext==".co") check(adapter.loadCodeObjectFile(entry.path().string()));
        }
        using Type=rocisa::DataType;
        using Tensor=TensileLite::TensorDescriptor;
        const Type inputType = mx ? (fp4 ? Type::Float4 : Type::Float8) : Type::BFloat16;
        const Type outputType = fp4 ? Type::Float : Type::BFloat16;
        const Tensor aDesc("A", inputType, {size_t(transA ? k : m),size_t(transA ? m : k),1});
        const Tensor bDesc("B", inputType, {size_t(transB ? n : k),size_t(transB ? k : n),1});
        const Tensor cDesc("C", outputType, {size_t(m),size_t(n),1});
        const float beta = (variant == "bf16_streamk" || fp4) ? 1.0f : 0.0f;
        auto problem=TensileLite::ContractionProblemGemm::GEMM(transA,transB,aDesc,{},bDesc,{},cDesc,{},cDesc,{},beta);
        problem.setCEqualsD(false);
        problem.setComputeInputTypeA(inputType);
        problem.setComputeInputTypeB(inputType);
        problem.setHighPrecisionAccumulate(true);
        problem.setActivationComputeType(Type::Float);
        problem.setUseDeviceUserArguments(true);
        if (mx) {
            problem.setMXScaleA(Type::E8,32);
            problem.setMXScaleB(Type::E8,32);
        }
        problem.setAlphaType(Type::Float);
        problem.setBetaType(Type::Float);
        problem.setWorkspaceSize(std::numeric_limits<size_t>::max());
        const size_t workspaceBytes=solution->requiredWorkspaceSize(problem,*hardware);
        const auto reduction=solution->getSKReduction(problem,*hardware);
        const auto grid=solution->getSKGrid(problem,*hardware,problem.getNumTiles(solution->sizeMapping,1),reduction);
        const size_t syncBytes=std::max(grid*sizeof(uint32_t),solution->requiredSynchronizerSize(problem,*hardware));
        problem.setWorkspaceSize(workspaceBytes);
        if (!(*solution->hardwarePredicate)(*hardware) || !(*solution->problemPredicate)(problem)) {
            solution->problemPredicate->debugEval(problem,std::cerr);
            throw std::runtime_error("fixed solution does not support candidate");
        }
        const size_t aBytes = size_t(m)*k*(mx ? 1 : 2)/(fp4 ? 2 : 1);
        const size_t bBytes = size_t(n)*k*(mx ? 1 : 2)/(fp4 ? 2 : 1);
        const size_t outBytes = size_t(m)*n*(fp4 ? 4 : 2);
        std::vector<uint8_t> a(aBytes),b(bBytes),c(outBytes),d(outBytes);
        auto putBF16=[](std::vector<uint8_t>& data,size_t index,float value) {
            const auto packed=bf16(value);
            std::memcpy(data.data()+index*2,&packed,2);
        };
        auto getOutput=[&](const std::vector<uint8_t>& data,size_t index) {
            if(fp4) {float value;std::memcpy(&value,data.data()+index*4,4);return value;}
            uint16_t value;std::memcpy(&value,data.data()+index*2,2);return fp32(value);
        };
        // BF16 inputs vary in both axes; the separable integer patterns allow
        // an exact linear-time full-output reference. MX inputs use exact unit
        // values and unit E8 scales, which are unchanged by upstream swizzles.
        double sum=0;
        if(mx) {
            const auto packed4=TensileLite::Float4x2(1.0f,1.0f);
            const auto packed8=TensileLite::Float8(1.0f);
            uint8_t unit8;
            static_assert(sizeof(packed8)==1);
            std::memcpy(&unit8,&packed8,1);
            const uint8_t unit=fp4 ? packed4.data : unit8;
            std::fill(a.begin(),a.end(),unit);
            std::fill(b.begin(),b.end(),unit);
        } else {
            for (int l=0;l<k;++l) {
                sum+=(l%7-3)*(l%5-2)/256.0;
                for(int i=0;i<m;++i) putBF16(a,transA ? size_t(i)*k+l : size_t(l)*m+i,(i%13-6)*(l%7-3)/16.0f);
                for(int j=0;j<n;++j) putBF16(b,transB ? size_t(l)*n+j : size_t(j)*k+l,(j%11-5)*(l%5-2)/16.0f);
            }
        }
        for(size_t i=0;i<size_t(m)*n;++i) {
            const float value=(int(i%7)-3)/16.0f;
            if(fp4) std::memcpy(c.data()+i*4,&value,4);
            else putBF16(c,i,value);
        }
        Buffer da(aBytes),db(bBytes),dc(outBytes),dd(outBytes),workspace(workspaceBytes),synchronizer(syncBytes);
        Buffer scaleA(mx ? problem.mxsa().totalAllocatedBytes() : 0),scaleB(mx ? problem.mxsb().totalAllocatedBytes() : 0);
        check(hipMemcpy(da.data,a.data(),aBytes,hipMemcpyHostToDevice));
        check(hipMemcpy(db.data,b.data(),bBytes,hipMemcpyHostToDevice));
        check(hipMemcpy(dc.data,c.data(),outBytes,hipMemcpyHostToDevice));
        if(mx) {
            check(hipMemset(scaleA.data,TensileLite::E8(1.0f).data,problem.mxsa().totalAllocatedBytes()));
            check(hipMemset(scaleB.data,TensileLite::E8(1.0f).data,problem.mxsb().totalAllocatedBytes()));
        }
        TensileLite::ContractionInputs inputs;
        inputs.a=da.data;inputs.b=db.data;inputs.c=dc.data;inputs.d=dd.data;
        inputs.alpha=1.0f;inputs.beta=beta;inputs.ws=workspace.data;
        inputs.mxsa=scaleA.data;inputs.mxsb=scaleB.data;
        inputs.Synchronizer=synchronizer.data;inputs.workspaceSize=workspaceBytes;inputs.gpu=true;
        const auto kernels=solution->solve(problem,inputs,*hardware);
        std::cout<<"kernel="<<solution->kernelName<<" invocations="<<kernels.size()<<" workspace="<<workspaceBytes<<" synchronizer="<<syncBytes<<std::endl;
        if(kernels.size()!=1) throw std::runtime_error("candidate is a multi-launch operation, not a single kernel");
        check(adapter.initKernel(kernels[0].kernelName));
        auto prepare=[&] {
            if(workspaceBytes) check(hipMemsetAsync(workspace.data,0,workspaceBytes,nullptr));
            if(syncBytes) check(hipMemsetAsync(synchronizer.data,0,syncBytes,nullptr));
            check(hipMemsetAsync(dd.data,0xff,outBytes,nullptr));
            check(hipDeviceSynchronize());
        };
        auto launch=[&] {check(adapter.launchKernels(kernels));check(hipDeviceSynchronize());};
        auto validate=[&] {
            check(hipMemcpy(d.data(),dd.data,outBytes,hipMemcpyDeviceToHost));
            for(int j=0;j<n;++j) for(int i=0;i<m;++i) {
                const size_t index=size_t(j)*m+i;
                const float reference=(mx ? float(k) : float((i%13-6)*(j%11-5)*sum))+beta*getOutput(c,index);
                const float expected=fp4 ? reference : fp32(bf16(reference));
                const float actual=getOutput(d,index);
                const float tolerance=mx ? 0.005f : 0.002f+0.008f*std::abs(expected);
                if(!std::isfinite(actual) || std::abs(actual-expected)>tolerance)
                    throw std::runtime_error("GEMM mismatch at "+std::to_string(index)+": expected "+std::to_string(expected)+", actual "+std::to_string(actual));
            }
        };
        for(int r=0;r<warmups;++r) {
            std::cout<<"phase=warmup index="<<r<<std::endl;
            prepare();launch();validate();
        }
        std::vector<long long> times;
        for(int r=0;r<samples;++r) {
            std::cout<<"phase=sample index="<<r<<std::endl;
            prepare();
            const auto start=std::chrono::steady_clock::now();
            launch();
            const auto stop=std::chrono::steady_clock::now();
            times.push_back(std::chrono::duration_cast<std::chrono::nanoseconds>(stop-start).count());
            validate();
            std::cout<<"phase=sample_complete index="<<r<<" duration_ns="<<times.back()<<std::endl;
        }
        std::ofstream out(argv[9]);
        out<<"{\"invocations\":1,\"correctness\":\"passed\",\"kernel_name\":"
           <<std::quoted(solution->kernelName)<<",\"solution_index\":"<<library->solutions.begin()->first
           <<",\"input_pattern\":"<<std::quoted(mx ? "uniform_unit_mx" : "separable_periodic_bf16")
           <<",\"timings_ns\":[";
        for(size_t i=0;i<times.size();++i) {if(i) out<<',';out<<times[i];}
        out<<"]}\n";
        out.close();
        if(!out) throw std::runtime_error("cannot write native samples");
        return 0;
    } catch(const std::exception& error) {std::cerr<<"Tensile candidate: "<<error.what()<<'\n';return 1;}
}
