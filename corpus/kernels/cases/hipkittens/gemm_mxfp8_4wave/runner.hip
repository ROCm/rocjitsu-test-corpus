#define SIZE 256
#define ROCFUZZ_HIPKITTENS_WARMUP_ITERS 1
#define ROCFUZZ_HIPKITTENS_TIMING_ITERS 1

#define main rocfuzz_hipkittens_upstream_main
#include "../../../third_party/hipkittens/kernels/gemm/mxfp8/MXFP8_4wave/4_wave.cu"
#undef main

#include "../shape_args.hpp"

int main(int argc, char **argv) {
    HipKittensShape shape = parse_hipkittens_shape_args(argc, argv, {SIZE, SIZE, SIZE});
    require_hipkittens_compiled_shape(shape, {SIZE, SIZE, SIZE});
    return rocfuzz_hipkittens_upstream_main();
}
