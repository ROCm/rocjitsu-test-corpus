add_subdirectory(compile_fail)
add_subdirectory(general)

if(FPSAN_TESTS_HAS_RDNA3)
    add_subdirectory(gfx11)
endif()

if(FPSAN_TESTS_HAS_GFX1250)
    add_subdirectory(gfx1250)
endif()

if(FPSAN_TESTS_HAS_CDNA4)
    add_subdirectory(gfx950)
endif()

if(FPSAN_TESTS_HAS_CDNA3)
    add_subdirectory(cdna3)
endif()

if(FPSAN_TESTS_HAS_RDNA4)
    add_subdirectory(rdna4)
endif()
