// Purpose: Report WGP identity for cu_mask_switch; one work-item per group.
// Kernargs use the common output/markers/seed/iterations/token layout; only
// output, markers and token are used. Mask out wave/SIMD scheduling fields.
// gfx1250 obtains SE/AID from a message, not HW_ID1.
// Public encoding reference (CheckCuMaskIsa):
// https://github.com/ROCm/rocm-systems/blob/fa643819f9139a3af5223e57686d07df1c560b64/projects/rocr-runtime/libhsakmt/tests/kfdtest/src/ShaderStore.cpp
kernel void cts_work(global uint* output, global uint* markers, uint seed, uint iterations,
                         uint token) {
  uint identity, se_aid;
  __asm__ volatile("s_getreg_b32 %0, hwreg(HW_REG_HW_ID1)" : "=s"(identity));

#if defined(__gfx1250__)
  __asm__ volatile(
      "s_sendmsg_rtn_b32 %0, sendmsg(MSG_RTN_GET_SE_AID_ID)\n\t"
      "s_wait_kmcnt 0"
      : "=s"(se_aid));
#else
  se_aid = 0;
#endif
  uint group = __builtin_amdgcn_workgroup_id_x();
#if defined(__gfx1250__)
  output[group * 2] = identity & ((15u << 10) | (1u << 16));
#else
  output[group * 2] = identity & ((15u << 10) | (1u << 16) | (7u << 18));
#endif
  output[group * 2 + 1] = se_aid;
  markers[group] = token;
}
