// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT
#include "host.hpp"
#include <Tensile/ContractionLibrary.hpp>
#include <Tensile/ContractionProblem.hpp>
#include <Tensile/ContractionSolution.hpp>
#include <Tensile/MasterSolutionLibrary.hpp>
#include <Tensile/hip/HipHardware.hpp>
#include <Tensile/hip/HipSolutionAdapter.hpp>
#include <hip/hip_runtime.h>
#include <chrono>
#include <filesystem>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <limits>

namespace {
void check(hipError_t result) {
    if(result != hipSuccess) throw std::runtime_error(hipGetErrorString(result));
}
struct Buffer {
    void* data=nullptr;
    explicit Buffer(size_t bytes) { if(bytes) check(hipMalloc(&data,bytes)); }
    ~Buffer() { if(data) (void)hipFree(data); }
    Buffer(const Buffer&)=delete;
    Buffer& operator=(const Buffer&)=delete;
};
int number(const char* text, bool zero=false, int high=65536) {
    size_t end=0; auto value=std::stoll(text,&end);
    if(text[end] || value<(zero?0:1) || value>high) throw std::invalid_argument("invalid integer");
    return int(value);
}
void upload(Buffer& dst, const std::vector<float>& src) {
    check(hipMemcpy(dst.data,src.data(),src.size()*sizeof(float),hipMemcpyHostToDevice));
}
void pointers(Buffer& dst, Buffer& backing, size_t stride, int batches) {
    std::vector<float*> ptrs;
    for(int b=0;b<batches;b++) ptrs.push_back(static_cast<float*>(backing.data)+stride*b);
    check(hipMemcpy(dst.data,ptrs.data(),ptrs.size()*sizeof(float*),hipMemcpyHostToDevice));
}
}
int main(int argc,char** argv) {
    try {
        if(argc!=13) throw std::invalid_argument("expected root variant target m n k l batch beta warmups samples output");
        const std::filesystem::path root(argv[1]);
        const std::string variant(argv[2]), target(argv[3]);
        const bool tensor=variant=="tensor", pointer=variant=="pointer", split=variant=="splitk";
        if((!tensor && !pointer && !split && variant!="valu") || (target!="gfx1100" && target!="gfx1201"))
            throw std::invalid_argument("unsupported variant/target");
        int m=number(argv[4]), n=number(argv[5]), k=number(argv[6]), l=number(argv[7]);
        int batches=number(argv[8]), beta=number(argv[9],true);
        int warmups=number(argv[10],true,std::numeric_limits<int>::max());
        int samples=number(argv[11],false,std::numeric_limits<int>::max());
        if((!pointer && batches!=1) || (!tensor && l!=1) || beta!=(variant=="valu"?0:1))
            throw std::invalid_argument("invalid fixed contraction layout");
        full_tensile::Host host(m,n,k,l,batches,beta,tensor);
        hipDeviceProp_t props{}; int device;
        check(hipGetDevice(&device)); check(hipGetDeviceProperties(&props,device));
        const std::string actual(props.gcnArchName);
        if(actual!=target && actual.rfind(target+":",0)!=0) throw std::runtime_error("HIP target mismatch");
        auto hardware=Tensile::hip::GetCurrentDevice();
        auto library=std::dynamic_pointer_cast<Tensile::MasterContractionLibrary>(
            Tensile::LoadLibraryFile<Tensile::ContractionProblem>((root/"TensileLibrary.dat").string()));
        if(!library || library->solutions.size()!=1) throw std::runtime_error("expected exactly one fixed full Tensile solution");
        auto solution=library->solutions.begin()->second;
        std::string operation=tensor?"Contraction_kl_Akil_Bkjl_Cij_Dij":
                              pointer?"Contraction_l_Ailk_Bljk_Cijk_Dijk":"Contraction_k_Aik_Bkj_Cij_Dij";
        std::vector<size_t> sizes, as, bs, cs;
        if(tensor) {
            sizes={size_t(m),size_t(n),size_t(k),size_t(l)};
            as={1,size_t(k),size_t(k)*m}; bs={1,size_t(k),size_t(k)*n}; cs={1,size_t(m)};
        } else if(pointer) {
            sizes={size_t(m),size_t(n),size_t(batches),size_t(k)};
            as={1,size_t(m),size_t(m)*k}; bs={1,size_t(k),size_t(k)*n}; cs={1,size_t(m),size_t(m)*n};
        } else {
            sizes={size_t(m),size_t(n),size_t(k)};
            as={1,size_t(m)}; bs={1,size_t(k)}; cs={1,size_t(m)};
        }
        auto type=Tensile::DataType::Float;
        auto problem=Tensile::ContractionProblem::FromIndexSizes(operation,sizes,type,as,type,bs,type,cs,type,cs,beta);
        problem.setStridedBatched(!pointer); problem.setCEqualsD(false);
        if(solution->sizeMapping.globalSplitU!=(split?3:1) || solution->sizeMapping.globalAccumulation!=0
           || solution->sizeMapping.packSummationDims!=0)
            throw std::runtime_error("unexpected solution mechanism");
        if(solution->requiredWorkspaceSize(problem,*hardware)!=0)
            throw std::runtime_error("fixed solution unexpectedly requires workspace");
        if(!(*solution->hardwarePredicate)(*hardware) || !(*solution->problemPredicate)(problem)) {
            solution->problemPredicate->debugEval(problem,std::cerr);
            throw std::runtime_error("fixed full Tensile solution is ineligible");
        }
        const auto bytes=host.c.size()*sizeof(float);
        Buffer da(host.a.size()*sizeof(float)), db(host.b.size()*sizeof(float)), dc(bytes), dd(bytes);
        upload(da,host.a); upload(db,host.b); upload(dc,host.c);
        Buffer pa(pointer?batches*sizeof(float*):0), pb(pointer?batches*sizeof(float*):0),
               pc(pointer?batches*sizeof(float*):0), pd(pointer?batches*sizeof(float*):0);
        Tensile::TypedContractionInputs<float> inputs;
        inputs.a=static_cast<float*>(da.data); inputs.b=static_cast<float*>(db.data);
        inputs.c=static_cast<float*>(dc.data); inputs.d=static_cast<float*>(dd.data);
        inputs.alpha=1.f; inputs.beta=float(beta);
        if(pointer) {
            pointers(pa,da,size_t(m)*k,batches); pointers(pb,db,size_t(n)*k,batches);
            pointers(pc,dc,size_t(m)*n,batches); pointers(pd,dd,size_t(m)*n,batches);
            inputs.batchA=static_cast<const float* const*>(pa.data);
            inputs.batchB=static_cast<const float* const*>(pb.data);
            inputs.batchC=static_cast<const float* const*>(pc.data);
            inputs.batchD=static_cast<float* const*>(pd.data);
        }
        Tensile::hip::SolutionAdapter adapter;
        for(const auto& entry:std::filesystem::directory_iterator(root)) {
            auto ext=entry.path().extension();
            if(ext==".co" || ext==".hsaco") check(adapter.loadCodeObjectFile(entry.path().string()));
        }
        const auto kernels=solution->solve(problem,inputs,*hardware);
        if(kernels.size()!=size_t(split?2:1)) throw std::runtime_error("unexpected whole-solution invocation count");
        for(const auto& kernel:kernels) check(adapter.initKernel(kernel.kernelName));
        // solve, code-object loading and kernel lookup are all outside all samples.
        std::vector<float> output(host.c.size());
        auto reset=[&] {check(hipMemsetAsync(dd.data,0xff,bytes,nullptr)); check(hipDeviceSynchronize());};
        auto launch=[&] {check(adapter.launchKernels(kernels)); check(hipDeviceSynchronize());};
        auto validate=[&] {check(hipMemcpy(output.data(),dd.data,bytes,hipMemcpyDeviceToHost));host.validate(output);};
        auto clock=[] {return std::chrono::duration_cast<std::chrono::nanoseconds>(
            std::chrono::steady_clock::now().time_since_epoch()).count();};
        auto timings=full_tensile::measure(warmups,samples,reset,launch,validate,clock);
        std::ofstream out(argv[12]);
        out << "{\"correctness\":\"passed\",\"invocations\":" << kernels.size()
            << ",\"kernel_name\":" << std::quoted(solution->kernelName)
            << ",\"solution_index\":" << library->solutions.begin()->first
            << ",\"input_pattern\":\"signed_integer_periodic_v1\",\"timings_ns\":[";
        for(size_t i=0;i<timings.size();i++) out << (i?",":"") << timings[i];
        out << "]}\n";
        if(!out) throw std::runtime_error("cannot write native result");
    } catch(const std::exception& error) {std::cerr<<error.what()<<'\n';return 1;}
}
