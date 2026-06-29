cmake_minimum_required(VERSION 3.28)

project(rocfuzz_corpus LANGUAGES C CXX)

option(ROCFUZZ_ENABLE_ALL "Build all ROCfuzz corpus cases by default" ON)
option(ROCFUZZ_ENABLE_HIP_STREAMK "Build HIP Stream-K case" ${ROCFUZZ_ENABLE_ALL})
option(ROCFUZZ_ENABLE_LLAMA_HIP "Compile extracted llama.cpp GGML HIP/CUDA kernel sources" ${ROCFUZZ_ENABLE_ALL})
option(ROCFUZZ_ENABLE_HIP_MATMUL "Build nod-ai hip-matmul cases" ${ROCFUZZ_ENABLE_ALL})
option(ROCFUZZ_ENABLE_HIPKITTENS "Build HipKittens GEMM cases" ${ROCFUZZ_ENABLE_ALL})

include(cmake/RocfuzzHip.cmake)

if(ROCFUZZ_ENABLE_HIP_STREAMK OR ROCFUZZ_ENABLE_LLAMA_HIP OR ROCFUZZ_ENABLE_HIP_MATMUL OR ROCFUZZ_ENABLE_HIPKITTENS)
    rocfuzz_enable_hip()
endif()

if(ROCFUZZ_ENABLE_HIP_STREAMK)
    add_subdirectory(cases/hip-stream-k)
endif()

if(ROCFUZZ_ENABLE_LLAMA_HIP)
    add_subdirectory(cases/llama.cpp)
endif()

if(ROCFUZZ_ENABLE_HIP_MATMUL)
    add_subdirectory(cases/hip-matmul)
endif()

if(ROCFUZZ_ENABLE_HIPKITTENS)
    add_subdirectory(cases/hipkittens)
endif()
