#pragma once

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Winline-asm"

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
