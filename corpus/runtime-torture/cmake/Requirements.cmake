# Fail during configuration rather than midway through the suite build.
function(torture_requirements)
  if(NOT AMDGPU_LLVM_BIN)
    message(FATAL_ERROR "AMDGPU_LLVM_BIN is required: set it to an AMDGPU clang/ld.lld directory")
  endif()
  if(NOT EXISTS "${AMDGPU_LLVM_BIN}/clang" OR NOT EXISTS "${AMDGPU_LLVM_BIN}/ld.lld")
    message(FATAL_ERROR "AMDGPU_LLVM_BIN must contain both clang and ld.lld: ${AMDGPU_LLVM_BIN}")
  endif()

  include(CheckCXXSourceCompiles)
  # Recheck when reconfiguring after compiler/header/environment changes.
  unset(TORTURE_HOST_API_AVAILABLE CACHE)
  check_cxx_source_compiles([=[
    #include <linux/kfd_ioctl.h>
    #include <spawn.h>
    #include <sys/eventfd.h>
    #include <sys/prctl.h>
    #include <sys/mman.h>
    #include <thread>
    #include <string_view>
    static_assert(sizeof(void*) == 8);
    int main() {
      kfd_ioctl_runtime_enable_args runtime{};
      runtime.mode_mask = KFD_RUNTIME_ENABLE_MODE_ENABLE_MASK;
      kfd_ioctl_create_queue_args queue{};
      queue.ctx_save_restore_size = 0;
      kfd_ioctl_import_dmabuf_args import{};
      return runtime.mode_mask == 0 || queue.ctx_save_restore_size || import.gpu_id;
    }
  ]=] TORTURE_HOST_API_AVAILABLE)
  if(NOT TORTURE_HOST_API_AVAILABLE)
    message(FATAL_ERROR "Requires a 64-bit C++17 compiler and Linux KFD headers with runtime-enable and DMA-BUF APIs")
  endif()
endfunction()

function(torture_check_command description)
  execute_process(COMMAND ${ARGN} RESULT_VARIABLE result
    OUTPUT_VARIABLE output ERROR_VARIABLE error TIMEOUT 30)
  if(NOT "${result}" STREQUAL "0")
    message(FATAL_ERROR "${description} failed (${result}):\n${output}${error}")
  endif()
endfunction()

function(torture_check_kernel_toolchain arch kernel)
  # Compile, link and embed a real suite kernel; gfx1250 also checks metadata preload flags.
  set(probe_dir "${CMAKE_BINARY_DIR}/CMakeFiles/runtime-torture-${arch}-check")
  file(MAKE_DIRECTORY "${probe_dir}")
  torture_check_command("AMDGPU clang support for ${arch}"
    "${AMDGPU_LLVM_BIN}/clang" -x cl --target=amdgcn-amd-amdhsa
    -mcpu=${arch} ${kernel_wave_option} -nogpulib -O2 ${ARGN} -c
    "${PROJECT_SOURCE_DIR}/aql/kernels/${kernel}.cl" -o "${probe_dir}/kernel.o")
  torture_check_command("AMDGPU ld.lld support for ${arch}"
    "${AMDGPU_LLVM_BIN}/ld.lld" -shared --build-id=none
    "${probe_dir}/kernel.o" -o "${probe_dir}/kernel.co")
  torture_check_command("AMDGPU kernel embedding for ${arch}"
    "${Python3_EXECUTABLE}" "${PROJECT_SOURCE_DIR}/common/embed_kernel.py"
    "${probe_dir}/kernel.co" "${probe_dir}/kernel.inc")
  message(STATUS "Runtime torture ${arch} compiler, linker and kernel embedding checked")
endfunction()
