#define ROCFUZZ_HIPKITTENS_STANDALONE
#define ROCFUZZ_HIPKITTENS_M 256
#define ROCFUZZ_HIPKITTENS_N 256
#define ROCFUZZ_HIPKITTENS_K 256
#include "../../../third_party/hipkittens/kernels/gemm/bf16fp32/mi325x/8192_256_256_64_16/256_256_64_16.cpp"

#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <vector>

#include "../shape_args.hpp"

namespace {

constexpr float validation_abs_tolerance = 1.0e-1f;

void hip_check(hipError_t error, const char * expression, const char * file, int line) {
    if (error != hipSuccess) {
        std::fprintf(stderr, "HIP error at %s:%d from `%s`: %s\n",
            file, line, expression, hipGetErrorString(error));
        std::exit(1);
    }
}

#define ROCFUZZ_HIP_CHECK(expr) hip_check((expr), #expr, __FILE__, __LINE__)

kittens::bf16 to_bf16(float value) {
    return __float2bfloat16(value);
}

float to_float(kittens::bf16 value) {
    return __bfloat162float(value);
}

} // namespace

int main(int argc, char **argv) {
    HipKittensShape shape = parse_hipkittens_shape_args(
        argc, argv, {ROCFUZZ_HIPKITTENS_M, ROCFUZZ_HIPKITTENS_N, ROCFUZZ_HIPKITTENS_K});
    require_hipkittens_compiled_shape(
        shape, {ROCFUZZ_HIPKITTENS_M, ROCFUZZ_HIPKITTENS_N, ROCFUZZ_HIPKITTENS_K});

    std::vector<kittens::bf16> a_host(M * K);
    std::vector<kittens::bf16> b_host(N * K);
    std::vector<kittens::bf16> c_host(M * N, to_bf16(0.0f));
    std::vector<float> c_ref(M * N, 0.0f);

    for (int i = 0; i < M * K; ++i) {
        a_host[i] = to_bf16(0.0625f * static_cast<float>((i % 9) - 4));
    }
    for (int i = 0; i < N * K; ++i) {
        b_host[i] = to_bf16(0.03125f * static_cast<float>((i % 11) - 5));
    }

    kittens::bf16 * d_a = nullptr;
    kittens::bf16 * d_b = nullptr;
    kittens::bf16 * d_c = nullptr;
    ROCFUZZ_HIP_CHECK(hipMalloc(&d_a, a_host.size() * sizeof(kittens::bf16)));
    ROCFUZZ_HIP_CHECK(hipMalloc(&d_b, b_host.size() * sizeof(kittens::bf16)));
    ROCFUZZ_HIP_CHECK(hipMalloc(&d_c, c_host.size() * sizeof(kittens::bf16)));
    ROCFUZZ_HIP_CHECK(hipMemcpy(d_a, a_host.data(), a_host.size() * sizeof(kittens::bf16), hipMemcpyHostToDevice));
    ROCFUZZ_HIP_CHECK(hipMemcpy(d_b, b_host.data(), b_host.size() * sizeof(kittens::bf16), hipMemcpyHostToDevice));
    ROCFUZZ_HIP_CHECK(hipMemset(d_c, 0, c_host.size() * sizeof(kittens::bf16)));

    _gl_A a_gl(d_a, 1, 1, M, K);
    _gl_B b_gl(d_b, 1, 1, N, K);
    _gl_C c_gl(d_c, 1, 1, M, N);
    micro_globals globals{a_gl, b_gl, c_gl, hipStreamDefault};
    dispatch_micro(globals);
    ROCFUZZ_HIP_CHECK(hipGetLastError());
    ROCFUZZ_HIP_CHECK(hipDeviceSynchronize());

    ROCFUZZ_HIP_CHECK(hipMemcpy(c_host.data(), d_c, c_host.size() * sizeof(kittens::bf16), hipMemcpyDeviceToHost));

    for (int row = 0; row < M; ++row) {
        for (int col = 0; col < N; ++col) {
            float acc = 0.0f;
            for (int k = 0; k < K; ++k) {
                acc += to_float(a_host[row * K + k]) * to_float(b_host[col * K + k]);
            }
            c_ref[row * N + col] = acc;
        }
    }

    float max_abs_diff = 0.0f;
    int max_abs_diff_index = 0;
    for (int i = 0; i < M * N; ++i) {
        const float abs_diff = std::fabs(to_float(c_host[i]) - c_ref[i]);
        if (abs_diff > max_abs_diff) {
            max_abs_diff = abs_diff;
            max_abs_diff_index = i;
        }
    }

    ROCFUZZ_HIP_CHECK(hipFree(d_a));
    ROCFUZZ_HIP_CHECK(hipFree(d_b));
    ROCFUZZ_HIP_CHECK(hipFree(d_c));

    if (max_abs_diff > validation_abs_tolerance) {
        std::fprintf(stderr,
            "validation failed: max_abs_diff=%g at index %d, gpu=%g cpu=%g tolerance=%g\n",
            max_abs_diff, max_abs_diff_index, to_float(c_host[max_abs_diff_index]),
            c_ref[max_abs_diff_index], validation_abs_tolerance);
        return 1;
    }

    std::printf("HipKittens CDNA3 BF16 GEMM validation passed: max_abs_diff=%g tolerance=%g\n",
        max_abs_diff, validation_abs_tolerance);
    return 0;
}
