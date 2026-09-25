// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT
#include "artifacts.hpp"
#include "benchmark.hpp"
#include <Tensile/ContractionLibrary.hpp>
#include <Tensile/ContractionProblem.hpp>
#include <Tensile/ContractionSolution.hpp>
#include <Tensile/MasterSolutionLibrary.hpp>
#include <Tensile/hip/HipHardware.hpp>
#include <Tensile/hip/HipSolutionAdapter.hpp>
#include <llvm/Support/MemoryBuffer.h>
#include <llvm/Support/SHA256.h>
#include <algorithm>
#include <cmath>
#include <iomanip>
#include <limits>
#include <sstream>

namespace {
using corpus_benchmark::check;
struct DeviceBuffer {
    void* data = nullptr;
    explicit DeviceBuffer(size_t bytes) { if (bytes) check(hipMalloc(&data, bytes)); }
    ~DeviceBuffer() { if (data) (void)hipFree(data); }
    DeviceBuffer(const DeviceBuffer&) = delete;
    DeviceBuffer& operator=(const DeviceBuffer&) = delete;
};
void verify_artifacts() {
    std::cout << "TensileLite source revision: " << source_revision << '\n';
    for (const auto& [filename, expected] : artifact_hashes) {
        auto contents = llvm::MemoryBuffer::getFile(std::string(artifact_directory) + '/' + filename);
        if (!contents) throw std::runtime_error("cannot read artifact " + std::string(filename));
        auto bytes = (*contents)->getBuffer();
        const auto digest = llvm::SHA256::hash(llvm::ArrayRef<uint8_t>(
            reinterpret_cast<const uint8_t*>(bytes.data()), bytes.size()));
        std::ostringstream hex;
        for (auto byte : digest) hex << std::hex << std::setw(2) << std::setfill('0') << unsigned(byte);
        if (hex.str() != expected) throw std::runtime_error("artifact hash mismatch: " + std::string(filename));
        std::cout << filename << " sha256=" << expected << '\n';
    }
}
std::array<int, 3> shape(const std::vector<char*>& args) {
    std::array<int, 3> sizes{};
    {
        for (size_t i = 1; i < args.size(); i += 2) {
            std::string flag(args[i]);
            int index = flag == "--m" ? 0 : flag == "--n" ? 1 : flag == "--k" ? 2 : -1;
            if (index < 0 || i + 1 == args.size() || sizes[index])
                throw std::invalid_argument("expected --m M --n N --k K");
            sizes[index] = corpus_benchmark::integer(args[i + 1], 1);
        }
    }
    for (auto size : sizes) if (size < 127 || size > 129)
        throw std::invalid_argument("packaged SGEMM benchmarks support dimensions 127..129");
    return sizes;
}
} // namespace

int main(int argc, char** argv) {
    try {
        auto options = corpus_benchmark::parse(argc, argv);
        const auto [m,n,k] = shape(options.remaining);
        if (!options.enabled) options.target = "gfx1250";
        if (options.target != "gfx1250") throw std::invalid_argument("Tensile artifacts require gfx1250");
        verify_artifacts();
        corpus_benchmark::check_target(options);
        auto hardware = TensileLite::hip::GetCurrentDevice();
        auto library = std::dynamic_pointer_cast<TensileLite::MasterContractionLibrary>(
            TensileLite::LoadLibraryFile<TensileLite::ContractionProblemGemm>(
                std::string(artifact_directory) + "/TensileLibrary.yaml"));
        if (!library || library->solutions.size() != 2)
            throw std::runtime_error("expected packaged two-solution Tensile library");
        auto solution = library->solutions.at(TENSILE_SOLUTION_INDEX);
        if (!solution || solution->kernelName != kernel_names[TENSILE_SOLUTION_INDEX])
            throw std::runtime_error("Tensile solution/kernel identity mismatch");
        std::cout << "solution=" << TENSILE_SOLUTION_INDEX << " kernel=" << solution->kernelName << '\n';
        TensileLite::hip::SolutionAdapter adapter;
        check(adapter.loadCodeObjectFile(std::string(artifact_directory) + "/Kernels.so-000-gfx1250.hsaco"));
        check(adapter.loadCodeObjectFile(std::string(artifact_directory) + "/TensileLibrary_gfx1250.co"));
        // Tensile uses column-major tensors: A[i,l], B[j,l], C[i,j], D[i,j].
        auto problem = TensileLite::ContractionProblemGemm::GEMM(false, true, m,n,k,m,n,m,1.0,false,1);
        problem.setCEqualsD(false);
        problem.setComputeInputTypeA(rocisa::DataType::Float);
        problem.setComputeInputTypeB(rocisa::DataType::Float);
        problem.setWorkspaceSize(std::numeric_limits<size_t>::max());
        const size_t workspace_size = solution->requiredWorkspaceSize(problem, *hardware);
        const auto reduction = solution->getSKReduction(problem, *hardware);
        const auto grid = solution->getSKGrid(problem, *hardware,
            problem.getNumTiles(solution->sizeMapping, 1), reduction);
        // StreamK tree reduction uses one flag per workgroup, independently of GSU.
        const size_t synchronizer_size = std::max(grid * sizeof(uint32_t),
            solution->requiredSynchronizerSize(problem, *hardware));
        problem.setWorkspaceSize(workspace_size);
        if (!(*solution->hardwarePredicate)(*hardware) || !(*solution->problemPredicate)(problem)) {
            solution->problemPredicate->debugEval(problem, std::cerr);
            throw std::runtime_error("fixed Tensile solution does not support this problem/device");
        }
        std::vector<float> a(m*k), b(n*k), c(m*n), d(m*n);
        for (size_t i=0; i<a.size(); ++i) a[i] = (int(i % 13) - 6) / 16.0f;
        for (size_t i=0; i<b.size(); ++i) b[i] = (int(i % 11) - 5) / 16.0f;
        for (size_t i=0; i<c.size(); ++i) c[i] = (int(i % 7) - 3) / 16.0f;
        DeviceBuffer da(a.size()*sizeof(float)), db(b.size()*sizeof(float)),
                     dc(c.size()*sizeof(float)), dd(d.size()*sizeof(float)),
                     workspace(workspace_size), synchronizer(synchronizer_size);
        check(hipMemcpy(da.data,a.data(),a.size()*sizeof(float),hipMemcpyHostToDevice));
        check(hipMemcpy(db.data,b.data(),b.size()*sizeof(float),hipMemcpyHostToDevice));
        check(hipMemcpy(dc.data,c.data(),c.size()*sizeof(float),hipMemcpyHostToDevice));
        TensileLite::ContractionInputs inputs;
        inputs.a=da.data; inputs.b=db.data; inputs.c=dc.data; inputs.d=dd.data;
        inputs.alpha=1.0f; inputs.beta=1.0f; inputs.ws=workspace.data;
        inputs.Synchronizer=synchronizer.data; inputs.workspaceSize=workspace_size; inputs.gpu=true;
        const auto kernels = solution->solve(problem, inputs, *hardware);
        if (kernels.empty()) throw std::runtime_error("Tensile solution produced no invocations");
        for (const auto& kernel : kernels) check(adapter.initKernel(kernel.kernelName));
        std::cout << "invocations=" << kernels.size() << " workspace_bytes=" << workspace_size
                  << " synchronizer_bytes=" << synchronizer_size << '\n';
        auto launch = [&] {
            // StreamK flags share workspace; reset before every complete operation.
            if (workspace_size) check(hipMemsetAsync(workspace.data,0,workspace_size,nullptr));
            if (synchronizer_size) check(hipMemsetAsync(synchronizer.data,0,synchronizer_size,nullptr));
            check(adapter.launchKernels(kernels));
        };
        if (options.enabled) {
            corpus_benchmark::run(options,m,n,k,launch);
        } else {
            // Repeat validation to exercise the same workspace reset used by sampling.
            for (int repetition = 0; repetition < 3; ++repetition) {
                launch(); check(hipDeviceSynchronize());
                check(hipMemcpy(d.data(),dd.data,d.size()*sizeof(float),hipMemcpyDeviceToHost));
                for (int j=0; j<n; ++j) for (int i=0; i<m; ++i) {
                    double expected=c[i+j*m];
                    for (int l=0; l<k; ++l) expected += double(a[i+l*m])*b[j+l*n];
                    if (!std::isfinite(d[i+j*m]) || std::abs(d[i+j*m]-expected)>1e-4+1e-4*std::abs(expected))
                        throw std::runtime_error("SGEMM mismatch at (" + std::to_string(i) + "," +
                            std::to_string(j) + "): expected " + std::to_string(expected) +
                            ", got " + std::to_string(d[i+j*m]));
                }
            }
            std::cout << "PASS: validated " << d.size() << " SGEMM outputs on three launches\n";
        }
        return 0;
    } catch (const std::exception& error) {
        std::cerr << "Tensile benchmark: " << error.what() << '\n';
        return 1;
    }
}
