#define main kernel_corpus_hip_matmul_upstream_main
#define MmtKernel_256t_MSxNS_amdgcn_mfma_f32_16x16x4f32_shared_Kx4_doublebuffer_take2 \
  MmtKernel_256t_MSxNS_amdgcn_mfma_f32_16x16x4f32_shared_Kx4_doublebuffer_take2_hazard_original
#include "../../../third_party/hip-matmul/matmul.hip"
#undef MmtKernel_256t_MSxNS_amdgcn_mfma_f32_16x16x4f32_shared_Kx4_doublebuffer_take2
#undef main

template <int MS, int NS>
class
    MmtKernel_256t_MSxNS_amdgcn_mfma_f32_16x16x4f32_shared_Kx4_doublebuffer_take2
    : public MmtKernel {
  static_assert(MS >= 4 && !(MS % 4));
  static_assert(NS >= 4 && !(NS % 4));
  virtual Type A_type() const override { return Type::FP32; }
  virtual Type B_type() const override { return Type::FP32; }
  virtual Type C_type() const override { return Type::FP32; }
  virtual int M_tile() const override { return MS * 16; }
  virtual int N_tile() const override { return NS * 16; }
  virtual int K_tile() const override { return 16; }
  virtual tile_layout_func_t A_tile_layout() const override {
    return [](int m, int k) {
      int mi = m % 16;
      int mo = m / 16;
      return k / 4 + 4 * (64 * mo + 16 * (k % 4) + mi);
    };
  }
  virtual tile_layout_func_t B_tile_layout() const override {
    return [](int n, int k) {
      int ni = n % 16;
      int no = n / 16;
      return k / 4 + 4 * (64 * no + 16 * (k % 4) + ni);
    };
  }
  virtual tile_layout_func_t C_tile_layout() const override {
    return [](int m, int n) {
      int mi = m % 16;
      int mo = m / 16;
      int ni = n % 16;
      int no = n / 16;
      return NS * 256 * mo + 256 * no + 64 * (mi / 4) + 4 * ni + (mi % 4);
    };
  }
  virtual int num_threads() const override { return 256; }
  virtual mmt_func_t mmt_func() const override { return run; };
  __global__ __launch_bounds__(256) static void run(
      const void *A_data, const void *B_data, void *C_data, void * /*aux_data*/,
      int /*M_outer*/, int N_outer, int K_outer) {
    using floatx4_t = __attribute__((__vector_size__(4 * sizeof(float)))) float;
    floatx4_t acc[MS][NS / 4] = {{0}};

    int m_outer = blockIdx.x;
    int n_outer = blockIdx.y;
    int tid = threadIdx.x;

    constexpr int A_tile_size_in_vec4 = MS * 16 * 4;
    constexpr int B_tile_size_in_vec4 = NS * 16 * 4;

    const floatx4_t *A_global = static_cast<const floatx4_t *>(A_data) +
                                m_outer * K_outer * A_tile_size_in_vec4;
    const floatx4_t *B_global = static_cast<const floatx4_t *>(B_data) +
                                n_outer * K_outer * B_tile_size_in_vec4;
    const floatx4_t *A_global_ptr = A_global + tid;
    const floatx4_t *B_global_ptr = B_global + tid;

    __shared__ floatx4_t A_shared[2][A_tile_size_in_vec4];
    __shared__ floatx4_t B_shared[2][B_tile_size_in_vec4];

    auto load_shared_from_global = [&](int buffer_id) {
      for (int i = 0; i < A_tile_size_in_vec4; i += 256) {
        A_shared[buffer_id][i + tid] = A_global_ptr[i];
      }
      for (int j = 0; j < B_tile_size_in_vec4; j += 256) {
        B_shared[buffer_id][j + tid] = B_global_ptr[j];
      }
      A_global_ptr += A_tile_size_in_vec4;
      B_global_ptr += B_tile_size_in_vec4;
    };

    auto mfma = [&](int buffer_id) {
      for (int k = 0; k < 4; ++k) {
        for (int i = 0; i < MS; ++i) {
          for (int j = 0; j < NS / 4; ++j) {
            acc[i][j] = __builtin_amdgcn_mfma_f32_16x16x4f32(
                A_shared[buffer_id][64 * i + (tid % 64)][k],
                B_shared[buffer_id][256 * j + tid][k], acc[i][j], 0, 0, 0);
          }
        }
      }
    };

    load_shared_from_global(0);

    while (K_outer >= 3) {
      load_shared_from_global(1);
      __syncthreads();
      mfma(0);
      __syncthreads();
      load_shared_from_global(0);
      mfma(1);
      __syncthreads();
      K_outer -= 2;
    }

    if (K_outer == 2) {
      load_shared_from_global(1);
      __syncthreads();
      mfma(0);
      mfma(1);
    } else {
      __syncthreads();
      mfma(0);
    }

    floatx4_t *C_ptr = static_cast<floatx4_t *>(C_data) +
                       MS * NS * 16 * 4 * (N_outer * m_outer + n_outer);
    for (int i = 0; i < MS; ++i) {
      for (int j = 0; j < NS / 4; ++j) {
        C_ptr[256 * (NS / 4 * i + j) + tid] = acc[i][j];
      }
    }
  }
};

int main(int argc, char **argv) {
  applyMNKArgs(argc, argv);

  std::printf("Kernel corpus selected hip-matmul kernels:\n\n");
  test(MmtKernel_256t_MSxNS_amdgcn_mfma_i32_16x16x32i8_shared_Kx2_pipeline_v3<
       8, 8>());
  test(MmtKernel_256t_MSxNS_amdgcn_mfma_f32_16x16x16f16_shared_Kx2<8, 8>());
  test(
      MmtKernel_256t_MSxNS_amdgcn_mfma_f32_16x16x4f32_shared_Kx4_doublebuffer_take2<
          8, 8>());
  return 0;
}
