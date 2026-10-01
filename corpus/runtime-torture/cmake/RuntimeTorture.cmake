# Build helpers contain no case selection or skip policy.
function(torture_test name source)
  add_executable(${name}_${arch} ${source} ${ARGN})
  target_include_directories(${name}_${arch} PRIVATE ${kernel_dir})
  target_link_libraries(${name}_${arch} PRIVATE kfd_support_${arch})
endfunction()

function(torture_kernel name)
  file(MAKE_DIRECTORY ${kernel_dir})
  set(embed_options)
  if(name STREQUAL "scratch")
    set(embed_options --allow-scratch)
  endif()
  add_custom_command(OUTPUT ${kernel_dir}/${name}_kernel.inc
    COMMAND ${AMDGPU_LLVM_BIN}/clang -x cl --target=amdgcn-amd-amdhsa
      -mcpu=${arch} -mno-wavefrontsize64 -nogpulib -O2 ${ARGN} -c
      ${CMAKE_CURRENT_SOURCE_DIR}/kernels/${name}.cl -o ${kernel_dir}/${name}.o
    COMMAND ${AMDGPU_LLVM_BIN}/ld.lld -shared --build-id=none
      ${kernel_dir}/${name}.o -o ${kernel_dir}/${name}.co
    COMMAND ${Python3_EXECUTABLE} ${PROJECT_SOURCE_DIR}/common/embed_kernel.py
      ${kernel_dir}/${name}.co ${kernel_dir}/${name}_kernel.inc ${embed_options}
    DEPENDS kernels/${name}.cl ${PROJECT_SOURCE_DIR}/common/embed_kernel.py VERBATIM)
endfunction()

function(torture_inventory)
  # Query actual targets so even a plain add_executable cannot evade coverage checks.
  get_property(targets DIRECTORY PROPERTY BUILDSYSTEM_TARGETS)
  set(binaries "")
  foreach(target IN LISTS targets)
    get_target_property(kind ${target} TYPE)
    if(kind STREQUAL "EXECUTABLE")
      string(APPEND binaries "$<TARGET_FILE_NAME:${target}>\n")
    endif()
  endforeach()
  file(GENERATE OUTPUT "${CMAKE_BINARY_DIR}/runtime-torture-${arch}-targets.txt"
    CONTENT "${binaries}")
endfunction()
