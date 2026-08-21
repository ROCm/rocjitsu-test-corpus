#!/usr/bin/env bash
set -euo pipefail

source /home/amily/rocjitsu/venvs/default/bin/activate

export ROCM_PATH="$(rocm-sdk path --root)"
export LD_LIBRARY_PATH="${ROCM_PATH}/lib:${LD_LIBRARY_PATH}"

root_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
rocjitsu=/tmp/tmp.RqN3NKsZuD/rocjitsu-build/tools/rocjitsu/rocjitsu
config=/tmp/tmp.RqN3NKsZuD/rocm-systems/emulation/rocjitsu/configs/gfx1250_mi455x.json
validate="$root_dir/validate-kernel-case.sh"

names=(
  bf16_activation
  f16_activation
  f8f8s_gfx1250
  f8bs_gfx1250
  i8i8s_gfx1250
  spmm_f8bs_sb
)

dirs=(
  #bf16_activation
  /home/amily/rocjitsu/tasks/gfx1250-test/rocjitsu-test-corpus/corpus/tensilelite/candidates/gfx1250-fail/bf16_activation/gemms/Cijk_Ailk_Bljk_BBS_BH_Bias_FDMN_SPAML0_A_S_SAV_UserArgs_00/00_Final/3ff39e66fdb5/
  #f16_activation
  /home/amily/rocjitsu/tasks/gfx1250-test/rocjitsu-test-corpus/corpus/tensilelite/candidates/gfx1250-fail/f16_activation/gemms/Cijk_Ailk_Bljk_HHS_BH_Bias_FDMN_SPAML0_A_S_SAV_UserArgs_00/00_Final/3ff39e66fdb5/
  #f8f8s_gfx1250
  /home/amily/rocjitsu/tasks/gfx1250-test/rocjitsu-test-corpus/corpus/tensilelite/candidates/gfx1250-fail/f8b8ss_gfx1250/gemms/Cijk_Ailk_Bjlk_F8B8SS_BH_UserArgs_00/00_Final/714193145f90/
  #f8bs_gfx1250
  /home/amily/rocjitsu/tasks/gfx1250-test/rocjitsu-test-corpus/corpus/tensilelite/candidates/gfx1250-fail/fp8_gfx1250/gemms/Cijk_Ailk_Bjlk_F8SS_BH_UserArgs_00/00_Final/1a116a5805d5/
  #i8i8s_gfx1250
  /home/amily/rocjitsu/tasks/gfx1250-test/rocjitsu-test-corpus/corpus/tensilelite/candidates/gfx1250-fail/i8ii_gfx1250/gemms/Cijk_Ailk_Bjlk_I8II_BH_HA_I_SAV_UserArgs_00/00_Final/da07757f2c9a/
  #spmm_f8bs_sb
  /home/amily/rocjitsu/tasks/gfx1250-test/rocjitsu-test-corpus/corpus/tensilelite/candidates/gfx1250-fail/spmm_f8bs_sb/gemms/Cijk_Ailk_Bljk_F8BS_BH_Bias_FDMN_SPBML0_A_S_SAV_UserArgs_00/00_Final/0b2e78b8a3d8/
)

for i in "${!dirs[@]}"; do
  echo "${names[$i]}"
  "$rocjitsu" --config "$config" -- \
    "$validate" --solution-index 0 "${dirs[$i]}"
done
