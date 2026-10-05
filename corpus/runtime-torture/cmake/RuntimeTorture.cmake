# Build helpers contain no case selection or skip policy.
function(torture_test name source)
  add_executable(${suite}_${name}_${arch} ${source} ${ARGN})
  string(REGEX REPLACE "^${suite}_" "" binary_name ${name})
  set_target_properties(${suite}_${name}_${arch} PROPERTIES
    OUTPUT_NAME ${suite}_${binary_name}_${arch})
  target_include_directories(${suite}_${name}_${arch} PRIVATE ${kernel_dir})
  target_link_libraries(${suite}_${name}_${arch} PRIVATE kfd_support_${suite}_${arch})
  foreach(input IN LISTS ARGN)
    get_filename_component(filename ${input} NAME)
    if(filename MATCHES "^(.*)_kernel.inc$")
      add_dependencies(${suite}_${name}_${arch} kernel_${CMAKE_MATCH_1}_${arch})
    endif()
  endforeach()
endfunction()

function(torture_kernel name)
  file(MAKE_DIRECTORY ${kernel_dir})
  set(embed_options)
  if(name STREQUAL "scratch")
    set(embed_options --allow-scratch)
  endif()
  add_custom_command(OUTPUT ${kernel_dir}/${name}_kernel.inc
    COMMAND ${AMDGPU_LLVM_BIN}/clang -x cl --target=amdgcn-amd-amdhsa
      -mcpu=${arch} ${kernel_wave_option} -nogpulib -O2 ${ARGN} -c
      ${PROJECT_SOURCE_DIR}/aql/kernels/${name}.cl -o ${kernel_dir}/${name}.o
    COMMAND ${AMDGPU_LLVM_BIN}/ld.lld -shared --build-id=none
      ${kernel_dir}/${name}.o -o ${kernel_dir}/${name}.co
    COMMAND ${Python3_EXECUTABLE} ${PROJECT_SOURCE_DIR}/common/embed_kernel.py
      ${kernel_dir}/${name}.co ${kernel_dir}/${name}_kernel.inc ${embed_options}
    DEPENDS ${PROJECT_SOURCE_DIR}/aql/kernels/${name}.cl ${PROJECT_SOURCE_DIR}/common/embed_kernel.py VERBATIM)
  add_custom_target(kernel_${name}_${arch} DEPENDS ${kernel_dir}/${name}_kernel.inc)
endfunction()

function(torture_inventory suite)
  # Query actual targets so even a plain add_executable cannot evade coverage checks.
  get_property(targets DIRECTORY PROPERTY BUILDSYSTEM_TARGETS)
  set(binaries "")
  foreach(target IN LISTS targets)
    get_target_property(kind ${target} TYPE)
    if(kind STREQUAL "EXECUTABLE")
      string(APPEND binaries "$<TARGET_FILE_NAME:${target}>\n")
    endif()
  endforeach()
  file(GENERATE OUTPUT "${CMAKE_BINARY_DIR}/${suite}-${arch}-targets.txt"
    CONTENT "${binaries}")
endfunction()
