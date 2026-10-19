if(NOT "gfx1201" IN_LIST CMAKE_HIP_ARCHITECTURES AND
   NOT "gfx1100" IN_LIST CMAKE_HIP_ARCHITECTURES AND
   NOT "gfx950" IN_LIST CMAKE_HIP_ARCHITECTURES)
    return()
endif()

find_package(hip REQUIRED CONFIG)
get_filename_component(guitar_hero_llvm_bin "${CMAKE_HIP_COMPILER}" DIRECTORY)
find_program(GUITAR_HERO_LLD NAMES ld.lld
    PATHS "${guitar_hero_llvm_bin}" NO_DEFAULT_PATH REQUIRED)

if("gfx1201" IN_LIST CMAKE_HIP_ARCHITECTURES)
    # Keep each assembler invocation in its strict wave mode. Mixed-wave
    # parsing rejects some sparse-WMMA index_key operands in the current SDK.
    # Both entries and their metadata are linked into one code object.
    add_custom_command(
        OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/guitar_hero_rdna4.hsaco"
        BYPRODUCTS "${CMAKE_CURRENT_BINARY_DIR}/guitar_hero_rdna4_wave32.o"
            "${CMAKE_CURRENT_BINARY_DIR}/guitar_hero_rdna4_wave64.o"
        COMMAND "${CMAKE_HIP_COMPILER}" -target amdgcn-amd-amdhsa -mcpu=gfx1201
            -mno-wavefrontsize64 -Wa,-defsym,GUITAR_HERO_WAVE_SIZE=32 -x assembler
            -c "${CMAKE_CURRENT_SOURCE_DIR}/guitar_hero_rdna4/guitar_hero_rdna4.s"
            -o "${CMAKE_CURRENT_BINARY_DIR}/guitar_hero_rdna4_wave32.o"
        COMMAND "${CMAKE_HIP_COMPILER}" -target amdgcn-amd-amdhsa -mcpu=gfx1201
            -mwavefrontsize64 -Wa,-defsym,GUITAR_HERO_WAVE_SIZE=64 -x assembler
            -c "${CMAKE_CURRENT_SOURCE_DIR}/guitar_hero_rdna4/guitar_hero_rdna4.s"
            -o "${CMAKE_CURRENT_BINARY_DIR}/guitar_hero_rdna4_wave64.o"
        COMMAND "${GUITAR_HERO_LLD}" -shared
            "${CMAKE_CURRENT_BINARY_DIR}/guitar_hero_rdna4_wave32.o"
            "${CMAKE_CURRENT_BINARY_DIR}/guitar_hero_rdna4_wave64.o"
            -o "${CMAKE_CURRENT_BINARY_DIR}/guitar_hero_rdna4.hsaco"
        DEPENDS guitar_hero_rdna4/guitar_hero_rdna4.s
        VERBATIM
    )
    add_custom_target(guitar_hero_rdna4_code_object
        DEPENDS "${CMAKE_CURRENT_BINARY_DIR}/guitar_hero_rdna4.hsaco")
endif()

if("gfx1100" IN_LIST CMAKE_HIP_ARCHITECTURES)
    add_custom_command(
        OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/guitar_hero_rdna3.hsaco"
        BYPRODUCTS "${CMAKE_CURRENT_BINARY_DIR}/guitar_hero_rdna3.o"
        COMMAND "${CMAKE_HIP_COMPILER}" -target amdgcn-amd-amdhsa -mcpu=gfx1100
            -mno-wavefrontsize64 -x assembler -c "${CMAKE_CURRENT_SOURCE_DIR}/guitar_hero_rdna3/guitar_hero_rdna3.s"
            -o "${CMAKE_CURRENT_BINARY_DIR}/guitar_hero_rdna3.o"
        COMMAND "${GUITAR_HERO_LLD}" -shared
            "${CMAKE_CURRENT_BINARY_DIR}/guitar_hero_rdna3.o"
            -o "${CMAKE_CURRENT_BINARY_DIR}/guitar_hero_rdna3.hsaco"
        DEPENDS guitar_hero_rdna3/guitar_hero_rdna3.s
        VERBATIM
    )
    add_custom_target(guitar_hero_rdna3_code_object
        DEPENDS "${CMAKE_CURRENT_BINARY_DIR}/guitar_hero_rdna3.hsaco")
endif()

if("gfx950" IN_LIST CMAKE_HIP_ARCHITECTURES)
    add_custom_command(
        OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/guitar_hero_cdna4.hsaco"
        BYPRODUCTS "${CMAKE_CURRENT_BINARY_DIR}/guitar_hero_cdna4.o"
        COMMAND "${CMAKE_HIP_COMPILER}" -target amdgcn-amd-amdhsa -mcpu=gfx950
            -mwavefrontsize64 -x assembler -c "${CMAKE_CURRENT_SOURCE_DIR}/guitar_hero_cdna4/guitar_hero_cdna4.s"
            -o "${CMAKE_CURRENT_BINARY_DIR}/guitar_hero_cdna4.o"
        COMMAND "${GUITAR_HERO_LLD}" -shared
            "${CMAKE_CURRENT_BINARY_DIR}/guitar_hero_cdna4.o"
            -o "${CMAKE_CURRENT_BINARY_DIR}/guitar_hero_cdna4.hsaco"
        DEPENDS guitar_hero_cdna4/guitar_hero_cdna4.s
        VERBATIM
    )
    add_custom_target(guitar_hero_cdna4_code_object
        DEPENDS "${CMAKE_CURRENT_BINARY_DIR}/guitar_hero_cdna4.hsaco")
endif()

function(add_guitar_hero case_name case_directory target code_object_target)
    if(NOT "${target}" IN_LIST CMAKE_HIP_ARCHITECTURES)
        return()
    endif()
    add_executable(${case_name} ${case_directory}/runner.cpp)
    target_include_directories(${case_name} PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}")
    target_compile_features(${case_name} PRIVATE cxx_std_17)
    target_link_libraries(${case_name} PRIVATE hip::host)
    add_dependencies(${case_name} ${code_object_target})
endfunction()

add_guitar_hero(guitar_hero guitar_hero_rdna4/guitar_hero_wave32 gfx1201 guitar_hero_rdna4_code_object)
add_guitar_hero(guitar_hero_wave64 guitar_hero_rdna4/guitar_hero_wave64 gfx1201 guitar_hero_rdna4_code_object)
add_guitar_hero(guitar_hero_rdna3 guitar_hero_rdna3 gfx1100 guitar_hero_rdna3_code_object)

add_guitar_hero(guitar_hero_cdna4 guitar_hero_cdna4 gfx950 guitar_hero_cdna4_code_object)
