set(HIP_STREAMK_ROOT "${PROJECT_SOURCE_DIR}/third_party/hip-stream-k")

if(NOT EXISTS "${HIP_STREAMK_ROOT}/include/streamk/simple_streamk.hpp")
    message(FATAL_ERROR
        "KERNEL_CORPUS_ENABLE_HIP_STREAMK=ON requires extracted hip-stream-k sources at "
        "${HIP_STREAMK_ROOT}")
endif()

find_package(hip REQUIRED CONFIG)
find_package(rocthrust REQUIRED CONFIG)

function(add_hip_streamk_runner target_name case_name run_comment)
    set(runner_source "${CMAKE_CURRENT_SOURCE_DIR}/${case_name}/runner.cpp")
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
    target_compile_definitions(${target_name} PRIVATE
        __HIP_PLATFORM_AMD__
    )
    target_include_directories(${target_name} PRIVATE
        "${HIP_STREAMK_ROOT}/include"
        "${HIP_STREAMK_ROOT}/benchmarks"
        "${ROCM_PATH}/include"
    )
    target_link_libraries(${target_name} PRIVATE
        hip::device
        roc::rocthrust
    )

    add_custom_target(run_${target_name}
        COMMAND ${target_name}
        DEPENDS ${target_name}
        WORKING_DIRECTORY "${CMAKE_BINARY_DIR}"
        COMMENT "${run_comment}"
        VERBATIM
    )
endfunction()

add_hip_streamk_runner(hip_streamk_simple simple_streamk "Run HIP Stream-K simple GEMM example")
add_hip_streamk_runner(hip_streamk_two_tile two_tile_streamk "Run HIP Stream-K two-tile GEMM example")

add_custom_target(hip_streamk_runners ALL
    DEPENDS hip_streamk_simple hip_streamk_two_tile
    COMMENT "Build HIP Stream-K example runners"
)
