#define SIZE 256
#define ROCFUZZ_HIPKITTENS_WARMUP_ITERS 1
#define ROCFUZZ_HIPKITTENS_TIMING_ITERS 1

#define main rocfuzz_hipkittens_upstream_main
#include "../../../third_party/hipkittens/kernels/gemm/fp8fp32/FP8_4wave/4_wave.cu"
#undef main

#include "../shape_args.hpp"

int main(int argc, char **argv) {
    HipKittensShape shape{SIZE, SIZE, SIZE};
    int rotating_buffer_count = DEFAULT_ROTATING_BUFFER_COUNT;
    for (int i = 1; i < argc; ++i) {
        const char *arg = argv[i];
        const char *value = nullptr;
        int *field = nullptr;
        if (std::strcmp(arg, "-m") == 0 || std::strcmp(arg, "--m") == 0) {
            field = &shape.m;
        } else if (std::strncmp(arg, "--m=", 4) == 0) {
            field = &shape.m;
            value = arg + 4;
        } else if (std::strcmp(arg, "-n") == 0 || std::strcmp(arg, "--n") == 0) {
            field = &shape.n;
        } else if (std::strncmp(arg, "--n=", 4) == 0) {
            field = &shape.n;
            value = arg + 4;
        } else if (std::strcmp(arg, "-k") == 0 || std::strcmp(arg, "--k") == 0) {
            field = &shape.k;
        } else if (std::strncmp(arg, "--k=", 4) == 0) {
            field = &shape.k;
            value = arg + 4;
        } else if (std::strcmp(arg, "--rotating-buffer-count") == 0) {
            field = &rotating_buffer_count;
        } else if (std::strncmp(arg, "--rotating-buffer-count=", 24) == 0) {
            field = &rotating_buffer_count;
            value = arg + 24;
        } else {
            std::fprintf(stderr,
                "unknown argument: %s\n"
                "usage: %s [-m M|--m M] [-n N|--n N] [-k K|--k K] [--rotating-buffer-count COUNT]\n",
                arg, argv[0]);
            std::exit(1);
        }

        int parsed = 0;
        value = take_value(argc, argv, i, arg, value);
        if (!parse_positive_int(value, parsed)) {
            std::fprintf(stderr, "invalid %s value: %s\n", arg, value);
            std::exit(1);
        }
        *field = parsed;
    }
    require_hipkittens_compiled_shape(shape, {SIZE, SIZE, SIZE});
    set_rotating_buffer_count(rotating_buffer_count);
    return rocfuzz_hipkittens_upstream_main();
}
