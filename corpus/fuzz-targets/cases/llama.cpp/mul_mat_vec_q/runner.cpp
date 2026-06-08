// Exercises llama.cpp GGML's ggml_mul_mat path with a Q4_0 matrix and F32 vector.
// Inputs are deterministic small values: matrix entries repeat
// 0.125 * [-3, -2, -1, 0, 1, 2, 3] before Q4_0 quantization, and vector entries
// repeat 0.25 * [1, 2, 3, 4, 5].

#include "../../../third_party/llama.cpp/ggml/include/ggml-alloc.h"
#include "../../../third_party/llama.cpp/ggml/include/ggml-backend.h"
#include "../../../third_party/llama.cpp/ggml/include/ggml.h"

#include <cstddef>
#include <cstdint>
#include <cmath>
#include <cstdio>
#include <cstring>
#include <vector>

namespace {

constexpr int64_t n_embd = 128;
constexpr int64_t n_tokens = 1;
constexpr float validation_abs_tolerance = 1.0e-2f;

bool parse_validate_arg(int argc, char ** argv, bool & validate) {
    validate = false;
    for (int i = 1; i < argc; ++i) {
        if (std::strcmp(argv[i], "--validate") == 0 || std::strcmp(argv[i], "--validate=true") == 0) {
            validate = true;
        } else if (std::strcmp(argv[i], "--validate=false") == 0) {
            validate = false;
        } else {
            std::fprintf(stderr, "unknown argument: %s\n", argv[i]);
            std::fprintf(stderr, "usage: %s [--validate|--validate=true|--validate=false]\n", argv[0]);
            return false;
        }
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

bool run_mul_mat(
        ggml_backend_t backend,
        const std::vector<unsigned char> & matrix_data,
        const std::vector<float> & vector_data,
        std::vector<float> & output_data) {
    ggml_init_params params = {};
    params.mem_size = 16u * 1024u * 1024u;
    params.mem_buffer = nullptr;
    params.no_alloc = true;

    ggml_context * ctx = ggml_init(params);
    if (ctx == nullptr) {
        return 1;
    }

    ggml_tensor * quantized_matrix =
        ggml_new_tensor_2d(ctx, GGML_TYPE_Q4_0, n_embd, n_embd);
    ggml_tensor * vector =
        ggml_new_tensor_2d(ctx, GGML_TYPE_F32, n_embd, n_tokens);
    ggml_tensor * output = ggml_mul_mat(ctx, quantized_matrix, vector);

    ggml_cgraph * graph = ggml_new_graph(ctx);
    ggml_build_forward_expand(graph, output);

    ggml_backend_buffer_t buffer = ggml_backend_alloc_ctx_tensors(ctx, backend);
    if (buffer == nullptr) {
        std::fprintf(stderr, "failed to allocate GGML tensors on backend\n");
        ggml_free(ctx);
        return false;
    }

    ggml_backend_tensor_set(quantized_matrix, matrix_data.data(), 0, matrix_data.size());
    ggml_backend_tensor_set(vector, vector_data.data(), 0, vector_data.size() * sizeof(float));

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

bool validate_against_cpu(const std::vector<float> & gpu_output,
        const std::vector<unsigned char> & matrix_data,
        const std::vector<float> & vector_data) {
    ggml_backend_t cpu_backend = ggml_backend_init_by_type(GGML_BACKEND_DEVICE_TYPE_CPU, nullptr);
    if (cpu_backend == nullptr) {
        std::fprintf(stderr, "failed to initialize GGML CPU backend\n");
        return false;
    }

    std::vector<float> cpu_output;
    const bool cpu_ok = run_mul_mat(cpu_backend, matrix_data, vector_data, cpu_output);
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
    if (!parse_validate_arg(argc, argv, validate)) {
        return 1;
    }

    ggml_backend_load_all();
    ggml_backend_t backend = init_gpu_backend();
    if (backend == nullptr) {
        std::fprintf(stderr, "failed to initialize GGML GPU/IGPU backend\n");
        return 1;
    }

    std::vector<float> matrix_values(n_embd * n_embd);
    for (size_t i = 0; i < matrix_values.size(); ++i) {
        matrix_values[i] = 0.125f * static_cast<float>(static_cast<int>(i % 7) - 3);
    }

    const size_t q4_0_block_size = ggml_blck_size(GGML_TYPE_Q4_0);
    const size_t q4_0_type_size = ggml_type_size(GGML_TYPE_Q4_0);
    std::vector<unsigned char> matrix_data(
        static_cast<size_t>(n_embd * n_embd / q4_0_block_size) * q4_0_type_size);
    const size_t quantized_size = ggml_quantize_chunk(
        GGML_TYPE_Q4_0, matrix_values.data(), matrix_data.data(), 0, n_embd, n_embd, nullptr);
    if (quantized_size != matrix_data.size()) {
        std::fprintf(stderr, "failed to quantize Q4_0 matrix\n");
        ggml_backend_free(backend);
        return 1;
    }

    std::vector<float> vector_data(n_embd * n_tokens);
    for (size_t i = 0; i < vector_data.size(); ++i) {
        vector_data[i] = 0.25f * static_cast<float>((i % 5) + 1);
    }

    std::vector<float> output_data;
    if (!run_mul_mat(backend, matrix_data, vector_data, output_data)) {
        ggml_backend_free(backend);
        return 1;
    }

    std::printf("llama.cpp ggml_mul_mat quantized matvec ran, output[0]=%g\n",
        output_data.empty() ? 0.0f : output_data[0]);

    if (validate && !validate_against_cpu(output_data, matrix_data, vector_data)) {
        ggml_backend_free(backend);
        return 1;
    }

    ggml_backend_free(backend);
    return 0;
}
