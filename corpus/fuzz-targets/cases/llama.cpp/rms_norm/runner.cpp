// Exercises llama.cpp GGML's ggml_rms_norm path on an F32 activation vector.
// Inputs are deterministic small values: activation entries repeat
// 0.125 * [-4, -3, -2, -1, 0, 1, 2, 3, 4].

#include "../../../third_party/llama.cpp/ggml/include/ggml-alloc.h"
#include "../../../third_party/llama.cpp/ggml/include/ggml-backend.h"
#include "../../../third_party/llama.cpp/ggml/include/ggml.h"

#include <cstddef>
#include <cstdint>
#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <fstream>
#include <limits>
#include <string>
#include <unordered_map>
#include <vector>

namespace {

struct RunShape {
    int64_t n_embd = 128;
    int64_t n_tokens = 1;
};

constexpr float rms_norm_epsilon = std::numeric_limits<float>::epsilon();
constexpr float validation_abs_tolerance = 1.0e-5f;

bool parse_positive_i64(const char * value, int64_t & result) {
    char * end = nullptr;
    const long long parsed = std::strtoll(value, &end, 10);
    if (end == value || *end != '\0' || parsed <= 0) {
        return false;
    }
    result = static_cast<int64_t>(parsed);
    return true;
}

bool parse_input_assignment(const char * arg, std::string & name, std::string & path) {
    const char * equals = std::strchr(arg, '=');
    if (equals == nullptr || equals == arg || *(equals + 1) == '\0') {
        return false;
    }
    name.assign(arg, static_cast<size_t>(equals - arg));
    path.assign(equals + 1);
    return true;
}

bool parse_args(
        int argc,
        char ** argv,
        bool & validate,
        RunShape & shape,
        std::unordered_map<std::string, std::string> & inputs,
        std::string & output_path) {
    validate = false;
    for (int i = 1; i < argc;) {
        if (std::strcmp(argv[i], "--validate") == 0 || std::strcmp(argv[i], "--validate=true") == 0) {
            validate = true;
            ++i;
        } else if (std::strcmp(argv[i], "--validate=false") == 0) {
            validate = false;
            ++i;
        } else if (std::strcmp(argv[i], "--input") == 0) {
            if (i + 1 >= argc) {
                std::fprintf(stderr, "--input requires name=path\n");
                return false;
            }
            std::string name;
            std::string path;
            if (!parse_input_assignment(argv[i + 1], name, path)) {
                std::fprintf(stderr, "invalid --input value: %s\n", argv[i + 1]);
                return false;
            }
            inputs[name] = path;
            i += 2;
        } else if (std::strcmp(argv[i], "--output") == 0 || std::strncmp(argv[i], "--output=", 9) == 0) {
            if (std::strncmp(argv[i], "--output=", 9) == 0) {
                output_path = argv[i] + 9;
                if (output_path.empty()) {
                    std::fprintf(stderr, "--output= requires a file path\n");
                    return false;
                }
                ++i;
                continue;
            }
            if (i + 1 >= argc) {
                std::fprintf(stderr, "--output requires a file path\n");
                return false;
            }
            output_path = argv[i + 1];
            i += 2;
        } else if (std::strcmp(argv[i], "--n-embd") == 0 || std::strncmp(argv[i], "--n-embd=", 9) == 0) {
            const char * value = nullptr;
            if (std::strncmp(argv[i], "--n-embd=", 9) == 0) {
                value = argv[i] + 9;
                ++i;
            } else {
                if (i + 1 >= argc) {
                    std::fprintf(stderr, "--n-embd requires a positive integer\n");
                    return false;
                }
                value = argv[i + 1];
                i += 2;
            }
            if (!parse_positive_i64(value, shape.n_embd)) {
                std::fprintf(stderr, "invalid --n-embd value: %s\n", value);
                return false;
            }
        } else if (std::strcmp(argv[i], "--n-tokens") == 0 || std::strncmp(argv[i], "--n-tokens=", 11) == 0) {
            const char * value = nullptr;
            if (std::strncmp(argv[i], "--n-tokens=", 11) == 0) {
                value = argv[i] + 11;
                ++i;
            } else {
                if (i + 1 >= argc) {
                    std::fprintf(stderr, "--n-tokens requires a positive integer\n");
                    return false;
                }
                value = argv[i + 1];
                i += 2;
            }
            if (!parse_positive_i64(value, shape.n_tokens)) {
                std::fprintf(stderr, "invalid --n-tokens value: %s\n", value);
                return false;
            }
        } else {
            std::fprintf(stderr, "unknown argument: %s\n", argv[i]);
            std::fprintf(
                stderr,
                "usage: %s [--n-embd N] [--n-tokens N] [--input name=path ...] [--output path|--output=path] "
                "[--validate|--validate=true|--validate=false]\n",
                argv[0]);
            return false;
        }
    }
    return true;
}

std::vector<float> make_default_activation_data(const RunShape & shape) {
    std::vector<float> data(static_cast<size_t>(shape.n_embd * shape.n_tokens));
    for (size_t i = 0; i < data.size(); ++i) {
        data[i] = 0.125f * static_cast<float>((static_cast<int>(i % 9) - 4));
    }
    return data;
}

bool read_f32_file(const std::string & path, size_t expected_elements, std::vector<float> & data) {
    std::ifstream file(path, std::ios::binary);
    if (!file) {
        std::fprintf(stderr, "failed to open input file: %s\n", path.c_str());
        return false;
    }
    data.resize(expected_elements);
    file.read(reinterpret_cast<char *>(data.data()), static_cast<std::streamsize>(expected_elements * sizeof(float)));
    if (!file || file.gcount() != static_cast<std::streamsize>(expected_elements * sizeof(float))) {
        std::fprintf(stderr, "input file has unexpected size: %s\n", path.c_str());
        return false;
    }
    char trailing = '\0';
    file.read(&trailing, 1);
    if (file.gcount() != 0) {
        std::fprintf(stderr, "input file has trailing bytes: %s\n", path.c_str());
        return false;
    }
    return true;
}

bool write_f32_file(const std::string & path, const std::vector<float> & data) {
    std::ofstream file(path, std::ios::binary);
    if (!file) {
        std::fprintf(stderr, "failed to open output file: %s\n", path.c_str());
        return false;
    }
    file.write(reinterpret_cast<const char *>(data.data()), static_cast<std::streamsize>(data.size() * sizeof(float)));
    if (!file) {
        std::fprintf(stderr, "failed to write output file: %s\n", path.c_str());
        return false;
    }
    return true;
}

ggml_backend_t init_gpu_backend() {
    ggml_backend_t backend = ggml_backend_init_by_type(GGML_BACKEND_DEVICE_TYPE_GPU, nullptr);
    if (backend == nullptr) {
        backend = ggml_backend_init_by_type(GGML_BACKEND_DEVICE_TYPE_IGPU, nullptr);
    }
    return backend;
}

bool run_rms_norm(
        ggml_backend_t backend,
        const RunShape & shape,
        const std::vector<float> & activation_data,
        std::vector<float> & output_data) {
    ggml_init_params params = {};
    params.mem_size = 16u * 1024u * 1024u;
    params.mem_buffer = nullptr;
    params.no_alloc = true;

    ggml_context * ctx = ggml_init(params);
    if (ctx == nullptr) {
        return 1;
    }

    ggml_tensor * activations =
        ggml_new_tensor_2d(ctx, GGML_TYPE_F32, shape.n_embd, shape.n_tokens);
    ggml_tensor * output = ggml_rms_norm(ctx, activations, rms_norm_epsilon);

    ggml_cgraph * graph = ggml_new_graph(ctx);
    ggml_build_forward_expand(graph, output);

    ggml_backend_buffer_t buffer = ggml_backend_alloc_ctx_tensors(ctx, backend);
    if (buffer == nullptr) {
        std::fprintf(stderr, "failed to allocate GGML tensors on backend\n");
        ggml_free(ctx);
        return false;
    }

    ggml_backend_tensor_set(activations, activation_data.data(), 0, activation_data.size() * sizeof(float));

    const ggml_status status = ggml_backend_graph_compute(backend, graph);
    if (status != GGML_STATUS_SUCCESS) {
        std::fprintf(stderr, "ggml_backend_graph_compute failed: %s\n", ggml_status_to_string(status));
        ggml_backend_buffer_free(buffer);
        ggml_free(ctx);
        return false;
    }

    output_data.resize(ggml_nelements(output));
    ggml_backend_tensor_get(output, output_data.data(), 0, output_data.size() * sizeof(float));

    ggml_backend_buffer_free(buffer);
    ggml_free(ctx);
    return true;
}

bool validate_against_cpu(
        const std::vector<float> & gpu_output,
        const RunShape & shape,
        const std::vector<float> & activation_data) {
    ggml_backend_t cpu_backend = ggml_backend_init_by_type(GGML_BACKEND_DEVICE_TYPE_CPU, nullptr);
    if (cpu_backend == nullptr) {
        std::fprintf(stderr, "failed to initialize GGML CPU backend\n");
        return false;
    }

    std::vector<float> cpu_output;
    const bool cpu_ok = run_rms_norm(cpu_backend, shape, activation_data, cpu_output);
    ggml_backend_free(cpu_backend);
    if (!cpu_ok) {
        return false;
    }

    if (gpu_output.size() != cpu_output.size()) {
        std::fprintf(stderr, "validation failed: output size mismatch, gpu=%zu cpu=%zu\n",
            gpu_output.size(), cpu_output.size());
        return false;
    }

    float max_abs_diff = 0.0f;
    size_t max_abs_diff_index = 0;
    for (size_t i = 0; i < gpu_output.size(); ++i) {
        const float abs_diff = std::fabs(gpu_output[i] - cpu_output[i]);
        if (abs_diff > max_abs_diff) {
            max_abs_diff = abs_diff;
            max_abs_diff_index = i;
        }
    }

    if (max_abs_diff > validation_abs_tolerance) {
        std::fprintf(stderr,
            "validation failed: max_abs_diff=%g at index %zu, gpu=%g cpu=%g tolerance=%g\n",
            max_abs_diff, max_abs_diff_index, gpu_output[max_abs_diff_index],
            cpu_output[max_abs_diff_index], validation_abs_tolerance);
        return false;
    }

    std::printf("validation passed: max_abs_diff=%g tolerance=%g\n",
        max_abs_diff, validation_abs_tolerance);
    return true;
}

} // namespace

int main(int argc, char ** argv) {
    bool validate = false;
    RunShape shape;
    std::unordered_map<std::string, std::string> inputs;
    std::string output_path;
    if (!parse_args(argc, argv, validate, shape, inputs, output_path)) {
        return 1;
    }

    ggml_backend_load_all();
    ggml_backend_t backend = init_gpu_backend();
    if (backend == nullptr) {
        std::fprintf(stderr, "failed to initialize GGML GPU/IGPU backend\n");
        return 1;
    }

    std::vector<float> activation_data;
    const auto activations_input = inputs.find("activations");
    if (activations_input != inputs.end()) {
        if (!read_f32_file(activations_input->second, static_cast<size_t>(shape.n_embd * shape.n_tokens), activation_data)) {
            ggml_backend_free(backend);
            return 1;
        }
    } else {
        activation_data = make_default_activation_data(shape);
    }

    std::vector<float> output_data;
    if (!run_rms_norm(backend, shape, activation_data, output_data)) {
        ggml_backend_free(backend);
        return 1;
    }
    std::printf("llama.cpp ggml_rms_norm ran with n_embd=%lld n_tokens=%lld, output[0]=%g\n",
        static_cast<long long>(shape.n_embd), static_cast<long long>(shape.n_tokens),
        output_data.empty() ? 0.0f : output_data[0]);

    if (validate) {
        if (!validate_against_cpu(output_data, shape, activation_data)) {
            ggml_backend_free(backend);
            return 1;
        }
        if (!output_path.empty()) {
            ggml_backend_t cpu_backend = ggml_backend_init_by_type(GGML_BACKEND_DEVICE_TYPE_CPU, nullptr);
            if (cpu_backend == nullptr) {
                std::fprintf(stderr, "failed to initialize GGML CPU backend\n");
                ggml_backend_free(backend);
                return 1;
            }
            std::vector<float> cpu_output;
            const bool cpu_ok = run_rms_norm(cpu_backend, shape, activation_data, cpu_output);
            ggml_backend_free(cpu_backend);
            if (!cpu_ok || !write_f32_file(output_path, cpu_output)) {
                ggml_backend_free(backend);
                return 1;
            }
        }
    } else if (!output_path.empty() && !write_f32_file(output_path, output_data)) {
        ggml_backend_free(backend);
        return 1;
    }

    ggml_backend_free(backend);
    return 0;
}
