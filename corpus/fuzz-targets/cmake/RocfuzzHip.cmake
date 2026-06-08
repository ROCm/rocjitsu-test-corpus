set(ROCFUZZ_THEROCK_ROCM_PATH "" CACHE PATH "TheRock ROCm dist prefix, for example <therock-build>/dist/rocm")

macro(rocfuzz_enable_hip)
    if(NOT CMAKE_HIP_ARCHITECTURES)
        message(FATAL_ERROR
            "HIP cases require -DCMAKE_HIP_ARCHITECTURES=<gfx target>, "
            "for example -DCMAKE_HIP_ARCHITECTURES=gfx1200")
    endif()

    if(NOT ROCFUZZ_THEROCK_ROCM_PATH AND DEFINED ENV{ROCFUZZ_THEROCK_ROCM_PATH})
        set(ROCFUZZ_THEROCK_ROCM_PATH "$ENV{ROCFUZZ_THEROCK_ROCM_PATH}" CACHE PATH
            "TheRock ROCm dist prefix, for example <therock-build>/dist/rocm" FORCE)
    endif()
    if(NOT ROCFUZZ_THEROCK_ROCM_PATH AND DEFINED ENV{ROCM_PATH})
        set(ROCFUZZ_THEROCK_ROCM_PATH "$ENV{ROCM_PATH}" CACHE PATH
            "TheRock ROCm dist prefix, for example <therock-build>/dist/rocm" FORCE)
    endif()
    if(NOT ROCFUZZ_THEROCK_ROCM_PATH OR NOT EXISTS "${ROCFUZZ_THEROCK_ROCM_PATH}/lib/cmake/hip/hip-config.cmake")
        message(FATAL_ERROR
            "HIP cases require ROCFUZZ_THEROCK_ROCM_PATH to point at a TheRock "
            "ROCm dist tree containing lib/cmake/hip/hip-config.cmake")
    endif()

    set(ENV{ROCM_PATH} "${ROCFUZZ_THEROCK_ROCM_PATH}")
    set(ENV{HIP_PATH} "${ROCFUZZ_THEROCK_ROCM_PATH}")
    set(CMAKE_HIP_COMPILER_ROCM_ROOT "${ROCFUZZ_THEROCK_ROCM_PATH}" CACHE PATH "ROCm root for the HIP compiler" FORCE)
    list(APPEND CMAKE_PREFIX_PATH
        "${ROCFUZZ_THEROCK_ROCM_PATH}"
        "${ROCFUZZ_THEROCK_ROCM_PATH}/lib/cmake"
        "${ROCFUZZ_THEROCK_ROCM_PATH}/lib64/cmake"
    )
    list(APPEND CMAKE_BUILD_RPATH
        "${ROCFUZZ_THEROCK_ROCM_PATH}/lib"
        "${ROCFUZZ_THEROCK_ROCM_PATH}/lib64"
    )
    if(NOT CMAKE_HIP_COMPILER)
        if(EXISTS "${ROCFUZZ_THEROCK_ROCM_PATH}/bin/amdclang++")
            set(CMAKE_HIP_COMPILER "${ROCFUZZ_THEROCK_ROCM_PATH}/bin/amdclang++" CACHE FILEPATH "HIP compiler" FORCE)
        elseif(EXISTS "${ROCFUZZ_THEROCK_ROCM_PATH}/bin/clang++")
            set(CMAKE_HIP_COMPILER "${ROCFUZZ_THEROCK_ROCM_PATH}/bin/clang++" CACHE FILEPATH "HIP compiler" FORCE)
        elseif(EXISTS "${ROCFUZZ_THEROCK_ROCM_PATH}/llvm/bin/clang++")
            set(CMAKE_HIP_COMPILER "${ROCFUZZ_THEROCK_ROCM_PATH}/llvm/bin/clang++" CACHE FILEPATH "HIP compiler" FORCE)
        endif()
    endif()

    enable_language(HIP)
endmacro()
