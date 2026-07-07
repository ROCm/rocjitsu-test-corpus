set(ROCM_PATH "" CACHE PATH "ROCm SDK root")

macro(kernel_corpus_enable_hip)
    if(NOT CMAKE_HIP_ARCHITECTURES)
        message(FATAL_ERROR
            "HIP cases require -DCMAKE_HIP_ARCHITECTURES=<gfx target>, "
            "for example -DCMAKE_HIP_ARCHITECTURES=gfx1200")
    endif()

    if(NOT ROCM_PATH AND DEFINED ENV{ROCM_PATH})
        set(ROCM_PATH "$ENV{ROCM_PATH}" CACHE PATH "ROCm SDK root" FORCE)
    endif()
    if(NOT ROCM_PATH)
        find_program(KERNEL_CORPUS_ROCM_SDK_EXECUTABLE rocm-sdk)
        if(KERNEL_CORPUS_ROCM_SDK_EXECUTABLE)
            execute_process(
                COMMAND "${KERNEL_CORPUS_ROCM_SDK_EXECUTABLE}" path --root
                RESULT_VARIABLE kernel_corpus_rocm_sdk_result
                OUTPUT_VARIABLE kernel_corpus_rocm_sdk_root
                OUTPUT_STRIP_TRAILING_WHITESPACE
                ERROR_QUIET
            )
            if(kernel_corpus_rocm_sdk_result EQUAL 0 AND kernel_corpus_rocm_sdk_root)
                set(ROCM_PATH "${kernel_corpus_rocm_sdk_root}" CACHE PATH "ROCm SDK root" FORCE)
            endif()
        endif()
    endif()
    if(NOT ROCM_PATH OR NOT EXISTS "${ROCM_PATH}/lib/cmake/hip/hip-config.cmake")
        message(FATAL_ERROR
            "HIP cases require ROCM_PATH to point at a ROCm SDK root containing "
            "lib/cmake/hip/hip-config.cmake. Set ROCM_PATH or provide rocm-sdk in PATH.")
    endif()

    set(ENV{ROCM_PATH} "${ROCM_PATH}")
    set(ENV{HIP_PATH} "${ROCM_PATH}")
    set(CMAKE_HIP_COMPILER_ROCM_ROOT "${ROCM_PATH}" CACHE PATH "ROCm root for the HIP compiler" FORCE)
    list(APPEND CMAKE_PREFIX_PATH
        "${ROCM_PATH}"
        "${ROCM_PATH}/lib/cmake"
        "${ROCM_PATH}/lib64/cmake"
    )
    list(APPEND CMAKE_BUILD_RPATH
        "${ROCM_PATH}/lib"
        "${ROCM_PATH}/lib64"
    )
    if(NOT CMAKE_HIP_COMPILER)
        find_program(KERNEL_CORPUS_HIP_COMPILER
            NAMES amdclang++
            PATHS
                "${ROCM_PATH}/lib/llvm/bin"
                "${ROCM_PATH}/bin"
                "${ROCM_PATH}/llvm/bin"
            NO_DEFAULT_PATH
        )
        if(NOT KERNEL_CORPUS_HIP_COMPILER)
            find_program(KERNEL_CORPUS_HIP_COMPILER NAMES amdclang++)
        endif()
        if(KERNEL_CORPUS_HIP_COMPILER)
            set(CMAKE_HIP_COMPILER "${KERNEL_CORPUS_HIP_COMPILER}" CACHE FILEPATH "HIP compiler" FORCE)
        endif()
    endif()

    enable_language(HIP)
endmacro()
