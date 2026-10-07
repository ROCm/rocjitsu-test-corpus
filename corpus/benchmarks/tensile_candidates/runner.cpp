// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT
#include "host_reference.hpp"
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
        const int scaleFormat = solution->problemType.mxScaleFormat;
        if (mx) {
            const int expectedFormat = fp4 ? 2 : 1;
            if (scaleFormat != expectedFormat || solution->problemType.swizzleTensorA
                || solution->problemType.swizzleTensorB || !transA || transB)
                throw std::runtime_error("unsupported fixed MX operand/scale layout");
            problem.setMXScaleA(Type::E8,32,{},scaleFormat == 1);
            problem.setMXScaleB(Type::E8,32,{},scaleFormat == 1);
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
        candidate::HostReference host(variant,m,n,k,scaleFormat);
        const size_t aBytes=host.a.size(), bBytes=host.b.size(), outBytes=host.c.size();
        std::vector<uint8_t> d(outBytes);
        if (mx && (host.scaleA.size()!=problem.mxsa().totalAllocatedBytes()
                   || host.scaleB.size()!=problem.mxsb().totalAllocatedBytes()))
            throw std::runtime_error("packed MX scales do not match solution descriptors");
        Buffer da(aBytes),db(bBytes),dc(outBytes),dd(outBytes),workspace(workspaceBytes),synchronizer(syncBytes);
        Buffer scaleA(host.scaleA.size()),scaleB(host.scaleB.size());
        check(hipMemcpy(da.data,host.a.data(),aBytes,hipMemcpyHostToDevice));
        check(hipMemcpy(db.data,host.b.data(),bBytes,hipMemcpyHostToDevice));
        check(hipMemcpy(dc.data,host.c.data(),outBytes,hipMemcpyHostToDevice));
        if(mx) {
            check(hipMemcpy(scaleA.data,host.scaleA.data(),host.scaleA.size(),hipMemcpyHostToDevice));
            check(hipMemcpy(scaleB.data,host.scaleB.data(),host.scaleB.size(),hipMemcpyHostToDevice));
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
            host.validate(d);
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
           <<",\"input_pattern\":"<<std::quoted(host.pattern())
           <<",\"timings_ns\":[";
        for(size_t i=0;i<times.size();++i) {if(i) out<<',';out<<times[i];}
        out<<"]}\n";
        out.close();
        if(!out) throw std::runtime_error("cannot write native samples");
        return 0;
    } catch(const std::exception& error) {std::cerr<<"Tensile candidate: "<<error.what()<<'\n';return 1;}
}
