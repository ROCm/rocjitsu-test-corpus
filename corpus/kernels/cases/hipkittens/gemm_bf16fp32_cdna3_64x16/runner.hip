#define KERNEL_CORPUS_HIPKITTENS_STANDALONE
#define KERNEL_CORPUS_HIPKITTENS_M 256
#define KERNEL_CORPUS_HIPKITTENS_N 256
#define KERNEL_CORPUS_HIPKITTENS_K 256
#include "../../../third_party/hipkittens/cdna3/include/kittens.cuh"
#ifndef KERNEL_CORPUS_HIPKITTENS_STANDALONE
#include "../../../third_party/hipkittens/cdna3/include/pyutils/pyutils.cuh"
#endif
using namespace kittens;

constexpr int BLOCK_SIZE       = 256;
constexpr int K_STEP           = 64;
constexpr int REG_BLOCK        = BLOCK_SIZE / 4;
constexpr int DOT_SLICE        = 16;

#define NUM_WARPS 8
#define NUM_THREADS (kittens::WARP_THREADS * NUM_WARPS)

#ifndef M
#ifdef KERNEL_CORPUS_HIPKITTENS_M
#define M KERNEL_CORPUS_HIPKITTENS_M
#else
#define M 8192
#endif
#endif
#ifndef K
#ifdef KERNEL_CORPUS_HIPKITTENS_K
#define K KERNEL_CORPUS_HIPKITTENS_K
#else
#define K 8192
#endif
#endif
#ifndef N
#ifdef KERNEL_CORPUS_HIPKITTENS_N
#define N KERNEL_CORPUS_HIPKITTENS_N
#else
#define N 8192
#endif
#endif

using _gl_A = gl<bf16, -1, -1, -1, -1>;
using _gl_B = gl<bf16, -1, -1, -1, -1>;
using _gl_C = gl<bf16, -1, -1, -1, -1>;

using G = kittens::group<NUM_WARPS>;


struct micro_globals {
    _gl_A a;
    _gl_B b;
    _gl_C c;
    hipStream_t stream;
    dim3 grid()  { return dim3((N / BLOCK_SIZE) * (M / BLOCK_SIZE)); }
    dim3 block() { return dim3(NUM_THREADS); }
    size_t dynamic_shared_memory() { return 65536; }
};

__global__ __launch_bounds__(NUM_THREADS, 2)
void micro_tk(const micro_globals g) {
    extern __shared__ alignment_dummy __shm[];
    shared_allocator al((int*)&__shm[0]);
    st_bf<BLOCK_SIZE, K_STEP> (&As) = al.allocate<st_bf<BLOCK_SIZE, K_STEP>>();
    st_bf<BLOCK_SIZE, K_STEP> (&Bs) = al.allocate<st_bf<BLOCK_SIZE, K_STEP>>();

    rt_bf<REG_BLOCK, DOT_SLICE> tiles[8];
    rt_fl<REG_BLOCK, REG_BLOCK, ducks::rt_layout::col> C_accum[2];
    for (int i = 0; i < 2; i++) { zero(C_accum[i]); }

    // Get original WGID.
    int wgid = (blockIdx.y * gridDim.x) + blockIdx.x;
    const int NUM_WGS = gridDim.x * gridDim.y;
    constexpr int WGM = 4;
    // Swizzle chiplet so that wgids are in the same XCD.
    wgid = chiplet_transform_chunked(wgid, NUM_WGS, NUM_XCDS, WGM*WGM);
    // Swizzle for better L2 within the same XCD. Use separate M/N tiling sizes
    // so rectangular grids don't generate out-of-bounds columns.
    const int num_pid_m = ceil_div(M, BLOCK_SIZE);
    const int num_pid_n = ceil_div(N, BLOCK_SIZE);
    int num_wgid_in_group = WGM * num_pid_n;
    int group_id = wgid / num_wgid_in_group;
    int first_pid_m = group_id * WGM;
    int group_size_m = min(num_pid_m - first_pid_m, WGM);
    int pid_m = first_pid_m + ((wgid % num_wgid_in_group) % group_size_m);
    int pid_n = (wgid % num_wgid_in_group) / group_size_m;
    // Assign the tile's row/column based on the pid_m and pid_n.
    const int row = pid_m;
    const int col = pid_n;


    const int warp_id = kittens::warpid();
    const int warp_row = warp_id / 4;
    const int warp_col = warp_id % 4;

    const int num_tiles = K / K_STEP;

    // Load first tile into shared memory
    G::load(As, g.a, {0, 0, row, 0});
    G::load(Bs, g.b, {0, 0, col, 0});
    __builtin_amdgcn_s_barrier();

    if (warp_row == 1) {
        __builtin_amdgcn_s_barrier();
    }

    #pragma unroll
    for (int tile = 0; tile < num_tiles - 1; ++tile) {

        // Small register buffers for pipelining
        // This is used instead of register tiles to enable the use of maximally coalesced global loads.
        constexpr int BUFFER_SIZE = (BLOCK_SIZE * K_STEP) / NUM_THREADS;
        float4 a_buffer_next[BUFFER_SIZE * sizeof(bf16) / sizeof(float4)];
        float4 b_buffer_next[BUFFER_SIZE * sizeof(bf16) / sizeof(float4)];

        // Cluster 0
        load_global_to_register_buffer<2, false, NUM_THREADS>(a_buffer_next, BUFFER_SIZE, g.a, {0, 0, row, tile + 1}, As);
        load(tiles[1], subtile_inplace<REG_BLOCK, DOT_SLICE>(As, {warp_row, 0}));
        load(tiles[2], subtile_inplace<REG_BLOCK, DOT_SLICE>(As, {warp_row + 2, 0}));
        load(tiles[0], subtile_inplace<REG_BLOCK, DOT_SLICE>(Bs, {warp_col, 0}));
        __builtin_amdgcn_s_barrier();
        __builtin_amdgcn_sched_barrier(0);

        // Cluster 1
        asm volatile("s_waitcnt lgkmcnt(0)");
        __builtin_amdgcn_s_setprio(1);
        mma_ABt(C_accum[0], tiles[1], tiles[0], C_accum[0]);
        mma_ABt(C_accum[1], tiles[2], tiles[0], C_accum[1]);
        __builtin_amdgcn_s_setprio(0);
        __builtin_amdgcn_s_barrier();
        __builtin_amdgcn_sched_barrier(0);

        // Cluster 2
        load(tiles[3], subtile_inplace<REG_BLOCK, DOT_SLICE>(Bs, {warp_col, 1}));
        load(tiles[4], subtile_inplace<REG_BLOCK, DOT_SLICE>(As, {warp_row, 1}));
        load(tiles[5], subtile_inplace<REG_BLOCK, DOT_SLICE>(As, {warp_row + 2, 1}));
        load(tiles[0], subtile_inplace<REG_BLOCK, DOT_SLICE>(Bs, {warp_col, 2}));
        load(tiles[1], subtile_inplace<REG_BLOCK, DOT_SLICE>(As, {warp_row, 2}));
        __builtin_amdgcn_s_barrier();
        __builtin_amdgcn_sched_barrier(0);

        // Cluster 3
        asm volatile("s_waitcnt lgkmcnt(0)");
        __builtin_amdgcn_s_setprio(1);
        mma_ABt(C_accum[0], tiles[4], tiles[3], C_accum[0]);
        mma_ABt(C_accum[1], tiles[5], tiles[3], C_accum[1]);
        __builtin_amdgcn_s_setprio(0);
        __builtin_amdgcn_s_barrier();
        __builtin_amdgcn_sched_barrier(0);

        // Cluster 4
        load_global_to_register_buffer<2, false, NUM_THREADS>(b_buffer_next, BUFFER_SIZE, g.b, {0, 0, col, tile + 1}, Bs);
        load(tiles[2], subtile_inplace<REG_BLOCK, DOT_SLICE>(As, {warp_row + 2, 2}));
        load(tiles[6], subtile_inplace<REG_BLOCK, DOT_SLICE>(Bs, {warp_col, 3}));
        load(tiles[7], subtile_inplace<REG_BLOCK, DOT_SLICE>(As, {warp_row, 3}));
        load(tiles[5], subtile_inplace<REG_BLOCK, DOT_SLICE>(As, {warp_row + 2, 3}));
        __builtin_amdgcn_s_barrier();
        __builtin_amdgcn_sched_barrier(0);

        // Cluster 5
        __builtin_amdgcn_s_setprio(1);
        mma_ABt(C_accum[0], tiles[1], tiles[0], C_accum[0]);
        mma_ABt(C_accum[1], tiles[2], tiles[0], C_accum[1]);
        __builtin_amdgcn_s_setprio(0);
        __builtin_amdgcn_s_barrier();
        __builtin_amdgcn_sched_barrier(0);

        // Cluster 6
        asm volatile("s_waitcnt lgkmcnt(0)");
        store_register_buffer_to_shared<NUM_THREADS>(As, a_buffer_next);
        store_register_buffer_to_shared<NUM_THREADS>(Bs, b_buffer_next);
        __builtin_amdgcn_s_barrier();
        __builtin_amdgcn_sched_barrier(0);

        // Cluster 7
        __builtin_amdgcn_s_setprio(1);
        mma_ABt(C_accum[0], tiles[7], tiles[6], C_accum[0]);
        mma_ABt(C_accum[1], tiles[5], tiles[6], C_accum[1]);
        __builtin_amdgcn_s_setprio(0);
        __builtin_amdgcn_s_barrier();
        __builtin_amdgcn_sched_barrier(0);

    }

    // Epilogue
    // Cluster 0
    __builtin_amdgcn_sched_barrier(0);
    load(tiles[0], subtile_inplace<REG_BLOCK, DOT_SLICE>(Bs, {warp_col, 0}));
    load(tiles[1], subtile_inplace<REG_BLOCK, DOT_SLICE>(As, {warp_row, 0}));
    load(tiles[2], subtile_inplace<REG_BLOCK, DOT_SLICE>(As, {warp_row + 2, 0}));
    asm volatile("s_waitcnt lgkmcnt(0)");
    __builtin_amdgcn_s_barrier();
    __builtin_amdgcn_sched_barrier(0);


    // Cluster 1
    __builtin_amdgcn_s_setprio(1);
    mma_ABt(C_accum[0], tiles[1], tiles[0], C_accum[0]);
    mma_ABt(C_accum[1], tiles[2], tiles[0], C_accum[1]);
    __builtin_amdgcn_s_setprio(0);
    __builtin_amdgcn_s_barrier();
    __builtin_amdgcn_sched_barrier(0);

    // Cluster 2
    load(tiles[3], subtile_inplace<REG_BLOCK, DOT_SLICE>(Bs, {warp_col, 1}));
    load(tiles[4], subtile_inplace<REG_BLOCK, DOT_SLICE>(As, {warp_row, 1}));
    load(tiles[5], subtile_inplace<REG_BLOCK, DOT_SLICE>(As, {warp_row + 2, 1}));
    asm volatile("s_waitcnt lgkmcnt(0)");
    __builtin_amdgcn_s_barrier();
    __builtin_amdgcn_sched_barrier(0);

    // Cluster 3
    __builtin_amdgcn_s_setprio(1);
    mma_ABt(C_accum[0], tiles[4], tiles[3], C_accum[0]);
    mma_ABt(C_accum[1], tiles[5], tiles[3], C_accum[1]);
    __builtin_amdgcn_s_setprio(0);
    __builtin_amdgcn_s_barrier();
    __builtin_amdgcn_sched_barrier(0);

    // Cluster 4
    load(tiles[0], subtile_inplace<REG_BLOCK, DOT_SLICE>(Bs, {warp_col, 2}));
    load(tiles[1], subtile_inplace<REG_BLOCK, DOT_SLICE>(As, {warp_row, 2}));
    load(tiles[2], subtile_inplace<REG_BLOCK, DOT_SLICE>(As, {warp_row + 2, 2}));
    load(tiles[3], subtile_inplace<REG_BLOCK, DOT_SLICE>(Bs, {warp_col, 3}));
    load(tiles[4], subtile_inplace<REG_BLOCK, DOT_SLICE>(As, {warp_row, 3}));
    load(tiles[5], subtile_inplace<REG_BLOCK, DOT_SLICE>(As, {warp_row + 2, 3}));
    asm volatile("s_waitcnt lgkmcnt(0)");
    __builtin_amdgcn_s_barrier();
    __builtin_amdgcn_sched_barrier(0);

    // Cluster 5
    __builtin_amdgcn_s_setprio(1);
    mma_ABt(C_accum[0], tiles[1], tiles[0], C_accum[0]);
    mma_ABt(C_accum[1], tiles[2], tiles[0], C_accum[1]);
    __builtin_amdgcn_s_setprio(0);
    __builtin_amdgcn_s_barrier();
    __builtin_amdgcn_sched_barrier(0);

    // Cluster 7
    __builtin_amdgcn_s_setprio(1);
    mma_ABt(C_accum[0], tiles[4], tiles[3], C_accum[0]);
    mma_ABt(C_accum[1], tiles[5], tiles[3], C_accum[1]);
    __builtin_amdgcn_s_setprio(0);
    __builtin_amdgcn_s_barrier();
    __builtin_amdgcn_sched_barrier(0);

    if (warp_row == 0) {
        __builtin_amdgcn_s_barrier();
    }

    store(g.c, C_accum[0], {0, 0, row * 4 + warp_row, col * 4 + warp_col});
    store(g.c, C_accum[1], {0, 0, row * 4 + warp_row + 2, col * 4 + warp_col});
}

void dispatch_micro(micro_globals g) {
    unsigned long mem_size = g.dynamic_shared_memory();
    hipFuncSetAttribute((void*)micro_tk, hipFuncAttributeMaxDynamicSharedMemorySize, mem_size);
    micro_tk<<<g.grid(), g.block(), mem_size, g.stream>>>(g);
}

#ifndef KERNEL_CORPUS_HIPKITTENS_STANDALONE
PYBIND11_MODULE(tk_kernel, m) {
    m.doc() = "tk_kernel python module";
    py::bind_kernel<micro_tk>(m, "micro_tk", &micro_globals::a, &micro_globals::b, &micro_globals::c);
    py::bind_function<dispatch_micro>(m, "dispatch_micro", &micro_globals::a, &micro_globals::b, &micro_globals::c);
}
#endif

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

#define KERNEL_CORPUS_HIP_CHECK(expr) hip_check((expr), #expr, __FILE__, __LINE__)

kittens::bf16 to_bf16(float value) {
    return __float2bfloat16(value);
}

float to_float(kittens::bf16 value) {
    return __bfloat162float(value);
}

} // namespace

int main(int argc, char **argv) {
    HipKittensShape shape = parse_hipkittens_shape_args(
        argc, argv, {KERNEL_CORPUS_HIPKITTENS_M, KERNEL_CORPUS_HIPKITTENS_N, KERNEL_CORPUS_HIPKITTENS_K});
    require_hipkittens_compiled_shape(
        shape, {KERNEL_CORPUS_HIPKITTENS_M, KERNEL_CORPUS_HIPKITTENS_N, KERNEL_CORPUS_HIPKITTENS_K});

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
    KERNEL_CORPUS_HIP_CHECK(hipMalloc(&d_a, a_host.size() * sizeof(kittens::bf16)));
    KERNEL_CORPUS_HIP_CHECK(hipMalloc(&d_b, b_host.size() * sizeof(kittens::bf16)));
    KERNEL_CORPUS_HIP_CHECK(hipMalloc(&d_c, c_host.size() * sizeof(kittens::bf16)));
    KERNEL_CORPUS_HIP_CHECK(hipMemcpy(d_a, a_host.data(), a_host.size() * sizeof(kittens::bf16), hipMemcpyHostToDevice));
    KERNEL_CORPUS_HIP_CHECK(hipMemcpy(d_b, b_host.data(), b_host.size() * sizeof(kittens::bf16), hipMemcpyHostToDevice));
    KERNEL_CORPUS_HIP_CHECK(hipMemset(d_c, 0, c_host.size() * sizeof(kittens::bf16)));

    _gl_A a_gl(d_a, 1, 1, M, K);
    _gl_B b_gl(d_b, 1, 1, N, K);
    _gl_C c_gl(d_c, 1, 1, M, N);
    micro_globals globals{a_gl, b_gl, c_gl, hipStreamDefault};
    dispatch_micro(globals);
    KERNEL_CORPUS_HIP_CHECK(hipGetLastError());
    KERNEL_CORPUS_HIP_CHECK(hipDeviceSynchronize());

    KERNEL_CORPUS_HIP_CHECK(hipMemcpy(c_host.data(), d_c, c_host.size() * sizeof(kittens::bf16), hipMemcpyDeviceToHost));

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

    KERNEL_CORPUS_HIP_CHECK(hipFree(d_a));
    KERNEL_CORPUS_HIP_CHECK(hipFree(d_b));
    KERNEL_CORPUS_HIP_CHECK(hipFree(d_c));

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
