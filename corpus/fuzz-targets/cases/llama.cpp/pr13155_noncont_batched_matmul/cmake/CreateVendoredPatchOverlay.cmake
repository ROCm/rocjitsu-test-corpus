cmake_policy(SET CMP0057 NEW)

if(NOT DEFINED ROCFUZZ_VENDOR_ROOT)
    message(FATAL_ERROR "ROCFUZZ_VENDOR_ROOT is required")
endif()
if(NOT DEFINED ROCFUZZ_OUTPUT_ROOT)
    message(FATAL_ERROR "ROCFUZZ_OUTPUT_ROOT is required")
endif()
if(NOT DEFINED ROCFUZZ_STAMP_FILE)
    message(FATAL_ERROR "ROCFUZZ_STAMP_FILE is required")
endif()

if(NOT EXISTS "${ROCFUZZ_VENDOR_ROOT}")
    message(FATAL_ERROR "ROCFUZZ_VENDOR_ROOT does not exist: ${ROCFUZZ_VENDOR_ROOT}")
endif()

set(copy_files)
if(DEFINED ROCFUZZ_COPY_FILES)
    set(copy_files ${ROCFUZZ_COPY_FILES})
endif()

file(REMOVE_RECURSE "${ROCFUZZ_OUTPUT_ROOT}")
file(MAKE_DIRECTORY "${ROCFUZZ_OUTPUT_ROOT}")

file(GLOB_RECURSE vendored_entries LIST_DIRECTORIES true RELATIVE "${ROCFUZZ_VENDOR_ROOT}" "${ROCFUZZ_VENDOR_ROOT}/*")

set(linked 0)
set(copied 0)
foreach(rel_path IN LISTS vendored_entries)
    set(src_path "${ROCFUZZ_VENDOR_ROOT}/${rel_path}")
    set(out_path "${ROCFUZZ_OUTPUT_ROOT}/${rel_path}")

    if(IS_DIRECTORY "${src_path}")
        file(MAKE_DIRECTORY "${out_path}")
    else()
        get_filename_component(out_dir "${out_path}" DIRECTORY)
        file(MAKE_DIRECTORY "${out_dir}")

        if(rel_path IN_LIST copy_files)
            configure_file("${src_path}" "${out_path}" COPYONLY)
            math(EXPR copied "${copied} + 1")
        else()
            file(CREATE_LINK "${src_path}" "${out_path}" SYMBOLIC)
            math(EXPR linked "${linked} + 1")
        endif()
    endif()
endforeach()

if(DEFINED ROCFUZZ_PATCH_FILE AND NOT "${ROCFUZZ_PATCH_FILE}" STREQUAL "")
    if(NOT DEFINED PATCH_EXECUTABLE OR "${PATCH_EXECUTABLE}" STREQUAL "")
        find_program(PATCH_EXECUTABLE patch REQUIRED)
    endif()

    execute_process(
        COMMAND "${CMAKE_COMMAND}" -E chdir "${ROCFUZZ_OUTPUT_ROOT}" "${PATCH_EXECUTABLE}" -p0 --forward -i "${ROCFUZZ_PATCH_FILE}"
        RESULT_VARIABLE patch_result
        OUTPUT_VARIABLE patch_stdout
        ERROR_VARIABLE patch_stderr
    )
    if(NOT patch_result EQUAL 0)
        message(FATAL_ERROR "failed to apply ${ROCFUZZ_PATCH_FILE}\n${patch_stdout}\n${patch_stderr}")
    endif()
endif()

file(WRITE "${ROCFUZZ_STAMP_FILE}"
    "vendor=${ROCFUZZ_VENDOR_ROOT}\n"
    "linked=${linked}\n"
    "copied=${copied}\n"
    "copy_files=${copy_files}\n"
)

message(STATUS "created overlay ${ROCFUZZ_OUTPUT_ROOT}: linked=${linked} copied=${copied}")
