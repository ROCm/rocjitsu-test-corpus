if(NOT DEFINED ROCFUZZ_RUNNER)
    message(FATAL_ERROR "ROCFUZZ_RUNNER is required")
endif()
if(NOT DEFINED ROCFUZZ_EXPECT_PASS)
    message(FATAL_ERROR "ROCFUZZ_EXPECT_PASS is required")
endif()

if(DEFINED ROCFUZZ_LD_LIBRARY_PATH)
    set(ENV{LD_LIBRARY_PATH} "${ROCFUZZ_LD_LIBRARY_PATH}")
endif()

execute_process(
    COMMAND "${ROCFUZZ_RUNNER}" --validate
    RESULT_VARIABLE run_result
)

if(ROCFUZZ_EXPECT_PASS)
    if(NOT run_result EQUAL 0)
        message(FATAL_ERROR "expected validation to pass, got exit code ${run_result}")
    endif()
    message(STATUS "validation passed as expected")
else()
    if(run_result EQUAL 0)
        message(FATAL_ERROR "expected validation to fail, but it passed")
    endif()
    message(STATUS "validation failed as expected")
endif()
