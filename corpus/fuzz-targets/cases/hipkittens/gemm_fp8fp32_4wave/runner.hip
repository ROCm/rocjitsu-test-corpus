#define SIZE 256
#define ROCFUZZ_HIPKITTENS_WARMUP_ITERS 1
#define ROCFUZZ_HIPKITTENS_TIMING_ITERS 1

#include "../../../third_party/hipkittens/kernels/gemm/fp8fp32/FP8_4wave/4_wave.cu"
