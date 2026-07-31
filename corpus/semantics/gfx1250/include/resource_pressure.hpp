#pragma once

#define CORPUS_DETAIL_STRINGIFY_IMPL(value) #value
#define CORPUS_DETAIL_STRINGIFY(value) CORPUS_DETAIL_STRINGIFY_IMPL(value)

// VGPR preconditions: launch one fully active wave32, do not diverge through
// the asm, and keep no compiler-managed VGPR value live across the block.
// SGPR: SAVE, INIT, target, BEGIN_CHECK, restore intentional outputs to
// sentinels, ACCUMULATE_ALL, RESTORE. VGPR: INIT saves v0's work-item ID; after
// the target, account for v0:v253 and v255, then CHECK_AND_RESTORE_LANE compares
// it with the mbcnt lane ID. Use the clobber fragments below and add fixed input
// staging or late-read output registers. Local -Winline-asm suppression permits
// the high clobbers that force .amdhsa_next_free_vgpr checks in cases.toml.

#define CORPUS_SGPR_PRESSURE_CLOBBERS "s101", "v103", "v155"
#define CORPUS_VGPR_PRESSURE_CLOBBERS                                        \
  "s20", "s21", "v250", "v254", "v255"

#define CORPUS_SGPR_PRESSURE_SAVE                                               \
  "v_mov_b32 v102, v0\n\t"                                                      \
  ".set pressure_sgpr, 0\n\t"                                                   \
  ".rept 102\n\t"                                                               \
  "v_mov_b32 v[pressure_sgpr], s[pressure_sgpr]\n\t"                            \
  ".set pressure_sgpr, pressure_sgpr + 1\n\t"                                   \
  ".endr\n\t"

#define CORPUS_SGPR_PRESSURE_INIT                                               \
  ".set pressure_sgpr, 0\n\t"                                                   \
  ".rept 102\n\t"                                                               \
  "s_mov_b32 s[pressure_sgpr], pressure_sgpr\n\t"                               \
  ".set pressure_sgpr, pressure_sgpr + 1\n\t"                                   \
  ".endr\n\t"

#define CORPUS_SGPR_PRESSURE_BEGIN_CHECK "v_mov_b32 v103, 0\n\t"

#define CORPUS_SGPR_PRESSURE_ACCUMULATE_ALL                                     \
  ".set pressure_sgpr, 0\n\t"                                                   \
  ".rept 102\n\t"                                                               \
  "v_mov_b32 v104, s[pressure_sgpr]\n\t"                                        \
  "v_xor_b32 v104, pressure_sgpr, v104\n\t"                                     \
  "v_or_b32 v103, v103, v104\n\t"                                               \
  ".set pressure_sgpr, pressure_sgpr + 1\n\t"                                   \
  ".endr\n\t"

#define CORPUS_SGPR_PRESSURE_RESTORE                                            \
  ".set pressure_sgpr, 0\n\t"                                                   \
  ".rept 102\n\t"                                                               \
  "v_readfirstlane_b32 s[pressure_sgpr], v[pressure_sgpr]\n\t"                  \
  ".set pressure_sgpr, pressure_sgpr + 1\n\t"                                   \
  ".endr\n\t"

#define CORPUS_VGPR_PRESSURE_INIT                                               \
  "v_mov_b32 v254, v0\n\t"                                                      \
  ".set pressure_vgpr, 0\n\t"                                                   \
  ".rept 254\n\t"                                                               \
  "v_mov_b32 v[pressure_vgpr], pressure_vgpr\n\t"                               \
  ".set pressure_vgpr, pressure_vgpr + 1\n\t"                                   \
  ".endr\n\t"                                                                   \
  "v_mov_b32 v255, 255\n\t"

#define CORPUS_VGPR_PRESSURE_BEGIN_CHECK "s_mov_b32 s20, 0\n\t"

#define CORPUS_VGPR_PRESSURE_CHECK_SENTINEL_RANGE(first, count)                 \
  ".set pressure_vgpr, " CORPUS_DETAIL_STRINGIFY(first) "\n\t"                  \
  ".rept " CORPUS_DETAIL_STRINGIFY(count) "\n\t"                                \
  "v_cmp_ne_u32 s21, pressure_vgpr, v[pressure_vgpr]\n\t"                       \
  "s_or_b32 s20, s20, s21\n\t"                                                  \
  ".set pressure_vgpr, pressure_vgpr + 1\n\t"                                   \
  ".endr\n\t"

#define CORPUS_VGPR_PRESSURE_CHECK_CONSTANT_RANGE(first, count, value)          \
  ".set pressure_vgpr, " CORPUS_DETAIL_STRINGIFY(first) "\n\t"                  \
  ".rept " CORPUS_DETAIL_STRINGIFY(count) "\n\t"                                \
  "v_cmp_ne_u32 s21, " CORPUS_DETAIL_STRINGIFY(value)                           \
  ", v[pressure_vgpr]\n\t"                                                       \
  "s_or_b32 s20, s20, s21\n\t"                                                  \
  ".set pressure_vgpr, pressure_vgpr + 1\n\t"                                   \
  ".endr\n\t"

#define CORPUS_VGPR_PRESSURE_CHECK_AND_RESTORE_LANE                             \
  "v_mbcnt_lo_u32_b32 v250, -1, 0\n\t"                                          \
  "v_mbcnt_hi_u32_b32 v250, -1, v250\n\t"                                       \
  "v_cmp_ne_u32 s21, v250, v254\n\t"                                            \
  "s_or_b32 s20, s20, s21\n\t"                                                  \
  "v_mov_b32 v254, v250\n\t"
