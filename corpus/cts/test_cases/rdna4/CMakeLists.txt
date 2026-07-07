fpsan_add_hip_test(fpsan_global_load_tr_gfx12_w64_test ../general/global_load_tr_test.cpp)
target_compile_definitions(fpsan_global_load_tr_gfx12_w64_test PRIVATE
    FPSAN_TEST_GLOBAL_LOAD_TR_W64=1
    FPSAN_TEST_FORCE_WAVE_SIZE=64)
target_compile_options(fpsan_global_load_tr_gfx12_w64_test PRIVATE
    $<$<COMPILE_LANGUAGE:HIP>:-mwavefrontsize64>)

fpsan_add_hip_test(fpsan_wmma_gfx12_test wmma_gfx12_test.cpp)

fpsan_add_hip_test(fpsan_wmma_gfx12_w64_test wmma_gfx12_test.cpp)
target_compile_definitions(fpsan_wmma_gfx12_w64_test PRIVATE
    FPSAN_TEST_GFX12_WAVE64=1
    FPSAN_TEST_FORCE_WAVE_SIZE=64)
target_compile_options(fpsan_wmma_gfx12_w64_test PRIVATE
    $<$<COMPILE_LANGUAGE:HIP>:-mwavefrontsize64>)

fpsan_add_hip_test(fpsan_swmmac_gfx12_test swmmac_gfx12_test.cpp)

fpsan_add_hip_test(fpsan_swmmac_gfx12_w64_test swmmac_gfx12_w64_test.cpp)
target_compile_definitions(fpsan_swmmac_gfx12_w64_test PRIVATE FPSAN_TEST_FORCE_WAVE_SIZE=64)
target_compile_options(fpsan_swmmac_gfx12_w64_test PRIVATE
    $<$<COMPILE_LANGUAGE:HIP>:-mwavefrontsize64>)

fpsan_add_hip_test(fpsan_xlane_gfx12_w64_test ../general/xlane_test.cpp)
target_compile_definitions(fpsan_xlane_gfx12_w64_test PRIVATE FPSAN_TEST_FORCE_WAVE_SIZE=64)
target_compile_options(fpsan_xlane_gfx12_w64_test PRIVATE
    $<$<COMPILE_LANGUAGE:HIP>:-mwavefrontsize64>)

fpsan_add_hip_test(fpsan_classify_gfx12_w64_test ../general/classify_test.cpp)
target_compile_definitions(fpsan_classify_gfx12_w64_test PRIVATE FPSAN_TEST_FORCE_WAVE_SIZE=64)
target_compile_options(fpsan_classify_gfx12_w64_test PRIVATE
    $<$<COMPILE_LANGUAGE:HIP>:-mwavefrontsize64>)

fpsan_add_hip_test(fpsan_wave_gfx12_w64_test ../general/wave_test.cpp)
target_compile_definitions(fpsan_wave_gfx12_w64_test PRIVATE
    FPSAN_TEST_FORCE_WAVE_SIZE=64)
target_compile_options(fpsan_wave_gfx12_w64_test PRIVATE
    $<$<COMPILE_LANGUAGE:HIP>:-mwavefrontsize64>)
