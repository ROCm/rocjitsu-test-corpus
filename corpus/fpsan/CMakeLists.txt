cmake_minimum_required(VERSION 3.28)

project(fpsan_tests LANGUAGES CXX)

option(FPSAN_TESTS_BUILD "Build FPSan tests" ON)

include(cmake/FpsanTests.cmake)

if(FPSAN_TESTS_BUILD)
    enable_testing()
    add_subdirectory(tests)
endif()
