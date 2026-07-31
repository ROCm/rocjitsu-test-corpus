cmake_minimum_required(VERSION 3.28)

project(kernel_corpus LANGUAGES C CXX)

option(KERNEL_CORPUS_ENABLE_ALL "Build all kernel corpus cases by default" ON)
option(KERNEL_CORPUS_ENABLE_HIP_STREAMK "Build HIP Stream-K case" ${KERNEL_CORPUS_ENABLE_ALL})
option(KERNEL_CORPUS_ENABLE_HIP_MATMUL "Build nod-ai hip-matmul cases" ${KERNEL_CORPUS_ENABLE_ALL})
option(KERNEL_CORPUS_ENABLE_HIPKITTENS "Build HipKittens GEMM cases" ${KERNEL_CORPUS_ENABLE_ALL})
option(KERNEL_CORPUS_ENABLE_ROCBLAS "Build rocBLAS cases" ${KERNEL_CORPUS_ENABLE_ALL})

include(cmake/KernelCorpusHip.cmake)

if(KERNEL_CORPUS_ENABLE_HIP_STREAMK OR KERNEL_CORPUS_ENABLE_HIP_MATMUL OR KERNEL_CORPUS_ENABLE_HIPKITTENS OR KERNEL_CORPUS_ENABLE_ROCBLAS)
    kernel_corpus_enable_hip()
endif()

if(KERNEL_CORPUS_ENABLE_HIP_STREAMK)
    add_subdirectory(cases/hip-stream-k)
endif()

if(KERNEL_CORPUS_ENABLE_HIP_MATMUL)
    add_subdirectory(cases/hip-matmul)
endif()

if(KERNEL_CORPUS_ENABLE_HIPKITTENS)
    add_subdirectory(cases/hipkittens)
endif()

if(KERNEL_CORPUS_ENABLE_ROCBLAS)
    add_subdirectory(cases/rocblas)
endif()
