// Purpose: Report WGP identity for cu_mask_switch; one work-item per group.
// Kernargs use the common output/markers/seed/iterations/token layout; only
// output, markers and token are used. Mask out wave/SIMD scheduling fields.
// Public encoding reference (CheckCuMaskIsa):
// https://github.com/ROCm/rocm-systems/blob/fa643819f9139a3af5223e57686d07df1c560b64/projects/rocr-runtime/libhsakmt/tests/kfdtest/src/ShaderStore.cpp
kernel void torture_work(global uint* output, global uint* markers, uint seed, uint iterations,
                         uint token) {
  uint identity;
  __asm__ volatile("s_getreg_b32 %0, hwreg(HW_REG_HW_ID1)" : "=s"(identity));

  uint group = __builtin_amdgcn_workgroup_id_x();
  output[group] = identity & ((15u << 10) | (1u << 16) | (7u << 18));
  markers[group] = token;
}
