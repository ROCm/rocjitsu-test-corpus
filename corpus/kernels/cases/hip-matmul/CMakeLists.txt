set(HIP_MATMUL_ROOT "${PROJECT_SOURCE_DIR}/third_party/hip-matmul")

if(NOT EXISTS "${HIP_MATMUL_ROOT}/matmul.hip")
    message(FATAL_ERROR
        "KERNEL_CORPUS_ENABLE_HIP_MATMUL=ON requires extracted hip-matmul sources at "
        "${HIP_MATMUL_ROOT}")
endif()

find_package(hip REQUIRED CONFIG)

function(add_hip_matmul_runner target_name case_name run_comment)
    set(runner_source "${CMAKE_CURRENT_SOURCE_DIR}/${case_name}/runner.hip")
    add_executable(${target_name}
        "${runner_source}"
    )
    set_source_files_properties("${runner_source}" PROPERTIES LANGUAGE HIP)
    target_compile_features(${target_name} PRIVATE cxx_std_20)
    set_target_properties(${target_name} PROPERTIES
        CXX_STANDARD 20
        CXX_STANDARD_REQUIRED ON
        CXX_EXTENSIONS OFF
        HIP_STANDARD 20
        HIP_STANDARD_REQUIRED ON
        HIP_EXTENSIONS OFF
    )
    target_link_libraries(${target_name} PRIVATE
        hip::device
    )

    add_custom_target(run_${target_name}
        COMMAND ${target_name}
        DEPENDS ${target_name}
        WORKING_DIRECTORY "${CMAKE_BINARY_DIR}"
        COMMENT "${run_comment}"
        VERBATIM
    )
endfunction()

set(hip_matmul_runner_targets)

add_hip_matmul_runner(hip_matmul_matvec matvec "Run nod-ai hip-matmul matvec runner")
target_compile_definitions(hip_matmul_matvec PRIVATE
    KERNEL_CORPUS_HIP_MATMUL_WARP_SIZE=64
)
target_compile_options(hip_matmul_matvec PRIVATE
    $<$<COMPILE_LANGUAGE:HIP>:-mwavefrontsize64>
)
list(APPEND hip_matmul_runner_targets hip_matmul_matvec)

set(hip_matmul_supports_mfma OFF)
foreach(hip_arch IN LISTS CMAKE_HIP_ARCHITECTURES)
    if(hip_arch MATCHES "^gfx9")
        set(hip_matmul_supports_mfma ON)
    endif()
endforeach()

if(hip_matmul_supports_mfma)
    add_hip_matmul_runner(hip_matmul_matmul matmul "Run nod-ai hip-matmul matmul runner")
    list(APPEND hip_matmul_runner_targets hip_matmul_matmul)
    add_hip_matmul_runner(
        hip_matmul_matmul_hazard
        matmul_hazard
        "Run nod-ai hip-matmul matmul hazard runner"
    )
    list(APPEND hip_matmul_runner_targets hip_matmul_matmul_hazard)
else()
    message(STATUS "Skipping hip_matmul_matmul: upstream MFMA kernels require a gfx9-family target")
endif()

add_custom_target(hip_matmul_runners ALL
    DEPENDS ${hip_matmul_runner_targets}
    COMMENT "Build nod-ai hip-matmul runners"
)
