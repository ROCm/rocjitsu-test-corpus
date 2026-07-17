find_package(hip REQUIRED CONFIG)
find_package(rocblas REQUIRED CONFIG)

find_package(GTest QUIET)
if(NOT TARGET GTest::gtest)
    include(FetchContent)
    set(INSTALL_GTEST OFF CACHE BOOL "" FORCE)
    set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
    FetchContent_Declare(
        googletest
        GIT_REPOSITORY https://github.com/google/googletest.git
        GIT_TAG v1.15.2
        GIT_SHALLOW TRUE
    )
    FetchContent_MakeAvailable(googletest)
endif()

set(rocblas_sgemm_source "${CMAKE_CURRENT_SOURCE_DIR}/sgemm/hip_gemm_test.cpp")

add_executable(rocblas_sgemm
    "${rocblas_sgemm_source}"
)
set_source_files_properties("${rocblas_sgemm_source}" PROPERTIES LANGUAGE HIP)
target_compile_features(rocblas_sgemm PRIVATE cxx_std_17)
set_target_properties(rocblas_sgemm PROPERTIES
    CXX_STANDARD 17
    CXX_STANDARD_REQUIRED ON
    CXX_EXTENSIONS OFF
    HIP_STANDARD 17
    HIP_STANDARD_REQUIRED ON
    HIP_EXTENSIONS OFF
)
target_link_libraries(rocblas_sgemm PRIVATE
    hip::device
    roc::rocblas
    GTest::gtest
)

add_custom_target(rocblas_runners ALL
    DEPENDS rocblas_sgemm
    COMMENT "Build rocBLAS kernel corpus runners"
)
