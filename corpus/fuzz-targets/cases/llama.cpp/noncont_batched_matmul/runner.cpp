// Exercises llama.cpp GGML batched F16 x F32 mul_mat with a non-contiguous
// F32 src1 view. This passes when the backend respects src1 view strides.

#if __has_include("ggml-alloc.h")
#include "ggml-alloc.h"
#include "ggml-backend.h"
#include "ggml.h"
#else
#include "../../../third_party/llama.cpp/ggml/include/ggml-alloc.h"
#include "../../../third_party/llama.cpp/ggml/include/ggml-backend.h"
#include "../../../third_party/llama.cpp/ggml/include/ggml.h"
#endif

#include <cmath>
#include <cstddef>
#include <cstdint>
#include <cstdio>
#include <cstring>
#include <fstream>
#include <string>
#include <unordered_map>
#include <vector>

namespace {

constexpr int64_t k_dim = 64;
constexpr int64_t output_rows = 32;
constexpr int64_t src1_view_cols = 17;
constexpr int64_t src1_noncont_parent_cols = 32;
constexpr int64_t src1_batches = 2;

constexpr float validation_abs_tolerance = 1.0e-3f;
constexpr size_t bug_signal_index = output_rows * src1_view_cols;

enum class Src1Layout {
    Contiguous,
    Noncontiguous,
};

const char * src1_layout_name(Src1Layout layout) {
    return layout == Src1Layout::Contiguous ? "contiguous" : "noncontiguous";
}

bool parse_src1_layout(const char * value, Src1Layout & layout) {
    if (std::strcmp(value, "contiguous") == 0) {
        layout = Src1Layout::Contiguous;
        return true;
    }
    if (std::strcmp(value, "noncontiguous") == 0) {
        layout = Src1Layout::Noncontiguous;
        return true;
    }
    return false;
}

int64_t src1_parent_cols_for_layout(Src1Layout layout) {
    return layout == Src1Layout::Contiguous ? src1_view_cols : src1_noncont_parent_cols;
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
        Src1Layout & src1_layout,
        std::unordered_map<std::string, std::string> & inputs,
        std::string & output_path) {
    validate = false;
    src1_layout = Src1Layout::Noncontiguous;
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
        } else if (std::strcmp(argv[i], "--src1-layout") == 0 || std::strncmp(argv[i], "--src1-layout=", 14) == 0) {
            const char * layout_value = nullptr;
            if (std::strncmp(argv[i], "--src1-layout=", 14) == 0) {
                layout_value = argv[i] + 14;
                ++i;
            } else {
                if (i + 1 >= argc) {
                    std::fprintf(stderr, "--src1-layout requires contiguous or noncontiguous\n");
                    return false;
                }
                layout_value = argv[i + 1];
                i += 2;
            }
            if (!parse_src1_layout(layout_value, src1_layout)) {
                std::fprintf(stderr, "invalid --src1-layout value: %s\n", layout_value);
                return false;
            }
        } else {
            std::fprintf(stderr, "unknown argument: %s\n", argv[i]);
            std::fprintf(
                stderr,
                "usage: %s [--input name=path ...] [--output path|--output=path] "
                "[--src1-layout contiguous|noncontiguous] "
                "[--validate|--validate=true|--validate=false]\n",
                argv[0]);
            return false;
        }
    }
    return true;
}

ggml_backend_t init_gpu_backend() {
    return ggml_backend_init_by_type(GGML_BACKEND_DEVICE_TYPE_GPU, nullptr);
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

bool read_f16_file(const std::string & path, size_t expected_elements, std::vector<ggml_fp16_t> & data) {
    static_assert(sizeof(ggml_fp16_t) == 2, "ggml_fp16_t must be 16-bit");
    std::ifstream file(path, std::ios::binary);
    if (!file) {
        std::fprintf(stderr, "failed to open input file: %s\n", path.c_str());
        return false;
    }
    data.resize(expected_elements);
    file.read(reinterpret_cast<char *>(data.data()), static_cast<std::streamsize>(expected_elements * sizeof(ggml_fp16_t)));
    if (!file || file.gcount() != static_cast<std::streamsize>(expected_elements * sizeof(ggml_fp16_t))) {
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

std::vector<ggml_fp16_t> make_default_src0_data() {
    std::vector<ggml_fp16_t> data(static_cast<size_t>(k_dim * output_rows));
    for (int64_t row = 0; row < output_rows; ++row) {
        for (int64_t col = 0; col < k_dim; ++col) {
            const float value = col == row ? 1.0f : 0.0f;
            data[static_cast<size_t>(col + k_dim * row)] = ggml_fp32_to_fp16(value);
        }
    }
    return data;
}

std::vector<float> make_default_src1_parent_data(Src1Layout src1_layout) {
    const int64_t src1_parent_cols = src1_parent_cols_for_layout(src1_layout);
    std::vector<float> data(static_cast<size_t>(k_dim * src1_parent_cols * src1_batches));
    for (int64_t batch = 0; batch < src1_batches; ++batch) {
        for (int64_t row = 0; row < src1_parent_cols; ++row) {
            for (int64_t col = 0; col < k_dim; ++col) {
                const size_t index = static_cast<size_t>(col + k_dim * (row + src1_parent_cols * batch));
                data[index] = 0.25f * static_cast<float>(col)
                    + 10.0f * static_cast<float>(row)
                    + 100.0f * static_cast<float>(batch);
            }
        }
    }
    return data;
}

bool run_noncont_batched_matmul_case(
        ggml_backend_t backend,
        const std::vector<ggml_fp16_t> & src0_data,
        const std::vector<float> & src1_parent_data,
        Src1Layout src1_layout,
        std::vector<float> & output_data) {
    ggml_init_params params = {};
    params.mem_size = 32u * 1024u * 1024u;
    params.mem_buffer = nullptr;
    params.no_alloc = true;

    ggml_context * ctx = ggml_init(params);
    if (ctx == nullptr) {
        std::fprintf(stderr, "failed to initialize GGML context\n");
        return false;
    }

    ggml_tensor * src0 = ggml_new_tensor_2d(ctx, GGML_TYPE_F16, k_dim, output_rows);
    const int64_t src1_parent_cols = src1_parent_cols_for_layout(src1_layout);
    ggml_tensor * src1_parent =
        ggml_new_tensor_4d(ctx, GGML_TYPE_F32, k_dim, src1_parent_cols, src1_batches, 1);
    ggml_tensor * src1_view = src1_parent;
    if (src1_layout == Src1Layout::Noncontiguous) {
        const size_t src1_nb1 = k_dim * sizeof(float);
        const size_t src1_nb2 = src1_parent_cols * src1_nb1;
        const size_t src1_nb3 = src1_batches * src1_nb2;
        const size_t src1_view_offset = src1_nb1;
        src1_view = ggml_view_4d(
            ctx,
            src1_parent,
            k_dim,
            src1_view_cols,
            src1_batches,
            1,
            src1_nb1,
            src1_nb2,
            src1_nb3,
            src1_view_offset);
    }
    ggml_tensor * output = ggml_mul_mat(ctx, src0, src1_view);

    ggml_cgraph * graph = ggml_new_graph(ctx);
    ggml_build_forward_expand(graph, output);

    ggml_backend_buffer_t buffer = ggml_backend_alloc_ctx_tensors(ctx, backend);
    if (buffer == nullptr) {
        std::fprintf(stderr, "failed to allocate GGML tensors on backend\n");
        ggml_free(ctx);
        return false;
    }

    ggml_backend_tensor_set(src0, src0_data.data(), 0, src0_data.size() * sizeof(ggml_fp16_t));
    ggml_backend_tensor_set(src1_parent, src1_parent_data.data(), 0, src1_parent_data.size() * sizeof(float));

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
        const std::vector<ggml_fp16_t> & src0_data,
        const std::vector<float> & src1_parent_data,
        Src1Layout src1_layout) {
    ggml_backend_t cpu_backend = ggml_backend_init_by_type(GGML_BACKEND_DEVICE_TYPE_CPU, nullptr);
    if (cpu_backend == nullptr) {
        std::fprintf(stderr, "failed to initialize GGML CPU backend\n");
        return false;
    }

    std::vector<float> cpu_output;
    const bool cpu_ok = run_noncont_batched_matmul_case(
        cpu_backend, src0_data, src1_parent_data, src1_layout, cpu_output);
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
    Src1Layout src1_layout = Src1Layout::Noncontiguous;
    std::unordered_map<std::string, std::string> inputs;
    std::string output_path;
    if (!parse_args(argc, argv, validate, src1_layout, inputs, output_path)) {
        return 1;
    }

    ggml_backend_load_all();
    ggml_backend_t backend = init_gpu_backend();
    if (backend == nullptr) {
        std::fprintf(stderr, "failed to initialize GGML GPU/IGPU backend\n");
        return 1;
    }

    std::vector<ggml_fp16_t> src0_data;
    const auto src0_input = inputs.find("src0");
    if (src0_input != inputs.end()) {
        if (!read_f16_file(src0_input->second, static_cast<size_t>(k_dim * output_rows), src0_data)) {
            ggml_backend_free(backend);
            return 1;
        }
    } else {
        src0_data = make_default_src0_data();
    }

    std::vector<float> src1_parent_data;
    const int64_t src1_parent_cols = src1_parent_cols_for_layout(src1_layout);
    const auto src1_parent_input = inputs.find("src1_parent");
    if (src1_parent_input != inputs.end()) {
        if (!read_f32_file(src1_parent_input->second, static_cast<size_t>(k_dim * src1_parent_cols * src1_batches), src1_parent_data)) {
            ggml_backend_free(backend);
            return 1;
        }
    } else {
        src1_parent_data = make_default_src1_parent_data(src1_layout);
    }

    std::vector<float> output_data;
    if (!run_noncont_batched_matmul_case(backend, src0_data, src1_parent_data, src1_layout, output_data)) {
        ggml_backend_free(backend);
        return 1;
    }
    const float signal = bug_signal_index < output_data.size() ? output_data[bug_signal_index] : 0.0f;
    std::printf("llama.cpp batched matmul ran with %s src1, output[%zu]=%g\n",
        src1_layout_name(src1_layout), bug_signal_index, signal);

    if (validate) {
        if (!validate_against_cpu(output_data, src0_data, src1_parent_data, src1_layout)) {
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
            const bool cpu_ok = run_noncont_batched_matmul_case(
                cpu_backend, src0_data, src1_parent_data, src1_layout, cpu_output);
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
