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

set(override_root)
if(DEFINED ROCFUZZ_OVERRIDE_ROOT)
    set(override_root "${ROCFUZZ_OVERRIDE_ROOT}")
endif()
if(override_root AND NOT EXISTS "${override_root}")
    message(FATAL_ERROR "ROCFUZZ_OVERRIDE_ROOT does not exist: ${override_root}")
endif()

file(REMOVE_RECURSE "${ROCFUZZ_OUTPUT_ROOT}")
file(MAKE_DIRECTORY "${ROCFUZZ_OUTPUT_ROOT}")

file(GLOB_RECURSE vendored_entries LIST_DIRECTORIES true RELATIVE "${ROCFUZZ_VENDOR_ROOT}" "${ROCFUZZ_VENDOR_ROOT}/*")

set(linked 0)
foreach(rel_path IN LISTS vendored_entries)
    set(src_path "${ROCFUZZ_VENDOR_ROOT}/${rel_path}")
    set(out_path "${ROCFUZZ_OUTPUT_ROOT}/${rel_path}")

    if(IS_DIRECTORY "${src_path}")
        file(MAKE_DIRECTORY "${out_path}")
    else()
        get_filename_component(out_dir "${out_path}" DIRECTORY)
        file(MAKE_DIRECTORY "${out_dir}")
        file(CREATE_LINK "${src_path}" "${out_path}" SYMBOLIC)
        math(EXPR linked "${linked} + 1")
    endif()
endforeach()

set(overridden 0)
if(override_root)
    file(GLOB_RECURSE override_entries LIST_DIRECTORIES false RELATIVE "${override_root}" "${override_root}/*")
    foreach(rel_path IN LISTS override_entries)
        set(src_path "${override_root}/${rel_path}")
        set(out_path "${ROCFUZZ_OUTPUT_ROOT}/${rel_path}")
        get_filename_component(out_dir "${out_path}" DIRECTORY)
        file(MAKE_DIRECTORY "${out_dir}")
        file(REMOVE "${out_path}")
        configure_file("${src_path}" "${out_path}" COPYONLY)
        math(EXPR overridden "${overridden} + 1")
    endforeach()
endif()

file(WRITE "${ROCFUZZ_STAMP_FILE}"
    "vendor=${ROCFUZZ_VENDOR_ROOT}\n"
    "override=${override_root}\n"
    "linked=${linked}\n"
    "overridden=${overridden}\n"
)

message(STATUS "created overlay ${ROCFUZZ_OUTPUT_ROOT}: linked=${linked} overridden=${overridden}")
