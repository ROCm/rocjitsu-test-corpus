fpsan_add_hip_test(fpsan_wmma_gfx11_test wmma_gfx11_test.cpp)

fpsan_add_hip_test(fpsan_wmma_gfx11_w64_test wmma_gfx11_test.cpp)
target_compile_definitions(fpsan_wmma_gfx11_w64_test PRIVATE FPSAN_TEST_GFX11_WAVE64=1)
target_compile_options(fpsan_wmma_gfx11_w64_test PRIVATE
    $<$<COMPILE_LANGUAGE:HIP>:-mwavefrontsize64>)

fpsan_add_hip_test(fpsan_xlane_w64_test ../general/xlane_test.cpp)
target_compile_options(fpsan_xlane_w64_test PRIVATE
    $<$<COMPILE_LANGUAGE:HIP>:-mwavefrontsize64>)

fpsan_add_hip_test(fpsan_classify_w64_test ../general/classify_test.cpp)
target_compile_options(fpsan_classify_w64_test PRIVATE
    $<$<COMPILE_LANGUAGE:HIP>:-mwavefrontsize64>)

fpsan_add_hip_test(fpsan_wave_gfx11_w64_test ../general/wave_test.cpp)
target_compile_definitions(fpsan_wave_gfx11_w64_test PRIVATE
    FPSAN_TEST_ENABLE_WAVE_F64=1
    FPSAN_TEST_SKIP_FLOAT_WAVE_REDUCE=1)
target_compile_options(fpsan_wave_gfx11_w64_test PRIVATE
    $<$<COMPILE_LANGUAGE:HIP>:-mwavefrontsize64>)
