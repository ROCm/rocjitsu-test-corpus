
/******************************************/
/* Begin Kernel                           */
/******************************************/
/* STINKY_TOTAL_INST_BYTES: 24184 */
.amdgcn_target "amdgcn-amd-amdhsa--gfx1250"
.text
.protected Cijk_Ailk_Bjlk_F8F8S_BH_UserArgs_MT32x16x64_MI16x16x1_SN_LDSB1_AFC0_AG0_AGGSUA0_AGNTAB0_AFEM2_AFEM1_ASEM32_BL1_BS1_CD1_1_CLR0_CLS0_CADS0_DTLA0_DTLB0_DTLM0_DTVA0_DTVB0_DTVMXSA0_DTVMXSB0_DTVSM0_DPLB0_EPS0_ELFLR0_EMLLn1_FDSI0_GRPM1_GRVWA1_GRVWB1_GSUAMB_GLS0_HPLR0_ISA1250_ICIW1_IU1_K1_LDSTI0_LBSPPA512_LBSPPB256_LBSPPMXSA0_LBSPPMXSB0_LBSPPM0_LPA16_LPB16_LPMXSA0_LPMXSB0_LPM0_LRVW16_LWPMn1_MIAV1_MIWT1_1_MXLIBL_MXSFNS_MO40_MGRIPM1_NTn1_NTA0_NTB0_NTC0_NTD0_NTE0_NTMXSA0_NTMXSB0_NTM0_NTWS0_NVn1_NVA0_NVB0_NVC0_NVD0_NVE0_NVMXSA0_NVMXSB0_NVM0_NVWS0_NEPBS0_NLCA1_NLCB1_ONLL1_PAP0_PGL0_PGR2_PLR0_PKA1_SGROB0_SIA3_SS0_SPO0_SRVW0_SSO0_SVW8_SK0_SKFTR0_SKFDPO0_SKWS0_SKXCCM0_SNLL0_SIP1_SGRO0_TDMI0_TDMIM0_TDMLWS0_TDMS0_TIN0_THn1_THA0_THB0_THC0_THD0_THE0_THMXSA0_THMXSB0_THM0_THWS0_TLDS0_TLDSMn1_ULSGRO0_USL1_USLMX0_UDFMAC0_UIOFGRO0_UPLRP0_USFGROn1_USI0_VSn1_VWA1_VWB1_WSGRA0_WSGRB0_WS32_WG32_2_1_WGMXCC1
.globl Cijk_Ailk_Bjlk_F8F8S_BH_UserArgs_MT32x16x64_MI16x16x1_SN_LDSB1_AFC0_AG0_AGGSUA0_AGNTAB0_AFEM2_AFEM1_ASEM32_BL1_BS1_CD1_1_CLR0_CLS0_CADS0_DTLA0_DTLB0_DTLM0_DTVA0_DTVB0_DTVMXSA0_DTVMXSB0_DTVSM0_DPLB0_EPS0_ELFLR0_EMLLn1_FDSI0_GRPM1_GRVWA1_GRVWB1_GSUAMB_GLS0_HPLR0_ISA1250_ICIW1_IU1_K1_LDSTI0_LBSPPA512_LBSPPB256_LBSPPMXSA0_LBSPPMXSB0_LBSPPM0_LPA16_LPB16_LPMXSA0_LPMXSB0_LPM0_LRVW16_LWPMn1_MIAV1_MIWT1_1_MXLIBL_MXSFNS_MO40_MGRIPM1_NTn1_NTA0_NTB0_NTC0_NTD0_NTE0_NTMXSA0_NTMXSB0_NTM0_NTWS0_NVn1_NVA0_NVB0_NVC0_NVD0_NVE0_NVMXSA0_NVMXSB0_NVM0_NVWS0_NEPBS0_NLCA1_NLCB1_ONLL1_PAP0_PGL0_PGR2_PLR0_PKA1_SGROB0_SIA3_SS0_SPO0_SRVW0_SSO0_SVW8_SK0_SKFTR0_SKFDPO0_SKWS0_SKXCCM0_SNLL0_SIP1_SGRO0_TDMI0_TDMIM0_TDMLWS0_TDMS0_TIN0_THn1_THA0_THB0_THC0_THD0_THE0_THMXSA0_THMXSB0_THM0_THWS0_TLDS0_TLDSMn1_ULSGRO0_USL1_USLMX0_UDFMAC0_UIOFGRO0_UPLRP0_USFGROn1_USI0_VSn1_VWA1_VWB1_WSGRA0_WSGRB0_WS32_WG32_2_1_WGMXCC1
.p2align 8
.type Cijk_Ailk_Bjlk_F8F8S_BH_UserArgs_MT32x16x64_MI16x16x1_SN_LDSB1_AFC0_AG0_AGGSUA0_AGNTAB0_AFEM2_AFEM1_ASEM32_BL1_BS1_CD1_1_CLR0_CLS0_CADS0_DTLA0_DTLB0_DTLM0_DTVA0_DTVB0_DTVMXSA0_DTVMXSB0_DTVSM0_DPLB0_EPS0_ELFLR0_EMLLn1_FDSI0_GRPM1_GRVWA1_GRVWB1_GSUAMB_GLS0_HPLR0_ISA1250_ICIW1_IU1_K1_LDSTI0_LBSPPA512_LBSPPB256_LBSPPMXSA0_LBSPPMXSB0_LBSPPM0_LPA16_LPB16_LPMXSA0_LPMXSB0_LPM0_LRVW16_LWPMn1_MIAV1_MIWT1_1_MXLIBL_MXSFNS_MO40_MGRIPM1_NTn1_NTA0_NTB0_NTC0_NTD0_NTE0_NTMXSA0_NTMXSB0_NTM0_NTWS0_NVn1_NVA0_NVB0_NVC0_NVD0_NVE0_NVMXSA0_NVMXSB0_NVM0_NVWS0_NEPBS0_NLCA1_NLCB1_ONLL1_PAP0_PGL0_PGR2_PLR0_PKA1_SGROB0_SIA3_SS0_SPO0_SRVW0_SSO0_SVW8_SK0_SKFTR0_SKFDPO0_SKWS0_SKXCCM0_SNLL0_SIP1_SGRO0_TDMI0_TDMIM0_TDMLWS0_TDMS0_TIN0_THn1_THA0_THB0_THC0_THD0_THE0_THMXSA0_THMXSB0_THM0_THWS0_TLDS0_TLDSMn1_ULSGRO0_USL1_USLMX0_UDFMAC0_UIOFGRO0_UPLRP0_USFGROn1_USI0_VSn1_VWA1_VWB1_WSGRA0_WSGRB0_WS32_WG32_2_1_WGMXCC1,@function
.section .rodata,#alloc
.p2align 6
.amdhsa_kernel Cijk_Ailk_Bjlk_F8F8S_BH_UserArgs_MT32x16x64_MI16x16x1_SN_LDSB1_AFC0_AG0_AGGSUA0_AGNTAB0_AFEM2_AFEM1_ASEM32_BL1_BS1_CD1_1_CLR0_CLS0_CADS0_DTLA0_DTLB0_DTLM0_DTVA0_DTVB0_DTVMXSA0_DTVMXSB0_DTVSM0_DPLB0_EPS0_ELFLR0_EMLLn1_FDSI0_GRPM1_GRVWA1_GRVWB1_GSUAMB_GLS0_HPLR0_ISA1250_ICIW1_IU1_K1_LDSTI0_LBSPPA512_LBSPPB256_LBSPPMXSA0_LBSPPMXSB0_LBSPPM0_LPA16_LPB16_LPMXSA0_LPMXSB0_LPM0_LRVW16_LWPMn1_MIAV1_MIWT1_1_MXLIBL_MXSFNS_MO40_MGRIPM1_NTn1_NTA0_NTB0_NTC0_NTD0_NTE0_NTMXSA0_NTMXSB0_NTM0_NTWS0_NVn1_NVA0_NVB0_NVC0_NVD0_NVE0_NVMXSA0_NVMXSB0_NVM0_NVWS0_NEPBS0_NLCA1_NLCB1_ONLL1_PAP0_PGL0_PGR2_PLR0_PKA1_SGROB0_SIA3_SS0_SPO0_SRVW0_SSO0_SVW8_SK0_SKFTR0_SKFDPO0_SKWS0_SKXCCM0_SNLL0_SIP1_SGRO0_TDMI0_TDMIM0_TDMLWS0_TDMS0_TIN0_THn1_THA0_THB0_THC0_THD0_THE0_THMXSA0_THMXSB0_THM0_THWS0_TLDS0_TLDSMn1_ULSGRO0_USL1_USLMX0_UDFMAC0_UIOFGRO0_UPLRP0_USFGROn1_USI0_VSn1_VWA1_VWB1_WSGRA0_WSGRB0_WS32_WG32_2_1_WGMXCC1
  .amdhsa_user_sgpr_kernarg_segment_ptr 1
  .amdhsa_next_free_vgpr 254 // vgprs
  .amdhsa_next_free_sgpr 70 // sgprs
  .amdhsa_group_segment_fixed_size 8192 // lds bytes
  .amdhsa_wavefront_size32 1 // 32-thread wavefronts
  .amdhsa_private_segment_fixed_size 0
  .amdhsa_system_sgpr_workgroup_id_x 1
  .amdhsa_system_sgpr_workgroup_id_y 1
  .amdhsa_system_sgpr_workgroup_id_z 1
  .amdhsa_system_vgpr_workitem_id 0
  .amdhsa_float_denorm_mode_32 3
  .amdhsa_float_denorm_mode_16_64 3
  .amdhsa_inst_pref_size 188
  .amdhsa_user_sgpr_count 28
  .amdhsa_user_sgpr_kernarg_preload_length 26
  .amdhsa_user_sgpr_kernarg_preload_offset 0
.end_amdhsa_kernel
.text
/* Num VGPR   =254 */
/* Num AccVGPR=0 */
/* Num SGPR   =70 */

/******************************************/
/* Optimizations and Config:              */
/******************************************/
/* ThreadTile= 8 x 1 */
/* SubGroup= 4 x 16 */
/* VectorWidthA=1 */
/* VectorWidthB=1 */
/* GlobalReadVectorWidthA=1, GlobalReadVectorWidthB=1 */
/* DirectToLdsA=False */
/* DirectToLdsB=False */
/* UseSgprForGRO=False */
.amdgpu_metadata
---
custom.config:
  InternalSupportParams:
    KernArgsVersion: 2
amdhsa.version:
  - 1
  - 1
amdhsa.kernels:
  - .name: Cijk_Ailk_Bjlk_F8F8S_BH_UserArgs_MT32x16x64_MI16x16x1_SN_LDSB1_AFC0_AG0_AGGSUA0_AGNTAB0_AFEM2_AFEM1_ASEM32_BL1_BS1_CD1_1_CLR0_CLS0_CADS0_DTLA0_DTLB0_DTLM0_DTVA0_DTVB0_DTVMXSA0_DTVMXSB0_DTVSM0_DPLB0_EPS0_ELFLR0_EMLLn1_FDSI0_GRPM1_GRVWA1_GRVWB1_GSUAMB_GLS0_HPLR0_ISA1250_ICIW1_IU1_K1_LDSTI0_LBSPPA512_LBSPPB256_LBSPPMXSA0_LBSPPMXSB0_LBSPPM0_LPA16_LPB16_LPMXSA0_LPMXSB0_LPM0_LRVW16_LWPMn1_MIAV1_MIWT1_1_MXLIBL_MXSFNS_MO40_MGRIPM1_NTn1_NTA0_NTB0_NTC0_NTD0_NTE0_NTMXSA0_NTMXSB0_NTM0_NTWS0_NVn1_NVA0_NVB0_NVC0_NVD0_NVE0_NVMXSA0_NVMXSB0_NVM0_NVWS0_NEPBS0_NLCA1_NLCB1_ONLL1_PAP0_PGL0_PGR2_PLR0_PKA1_SGROB0_SIA3_SS0_SPO0_SRVW0_SSO0_SVW8_SK0_SKFTR0_SKFDPO0_SKWS0_SKXCCM0_SNLL0_SIP1_SGRO0_TDMI0_TDMIM0_TDMLWS0_TDMS0_TIN0_THn1_THA0_THB0_THC0_THD0_THE0_THMXSA0_THMXSB0_THM0_THWS0_TLDS0_TLDSMn1_ULSGRO0_USL1_USLMX0_UDFMAC0_UIOFGRO0_UPLRP0_USFGROn1_USI0_VSn1_VWA1_VWB1_WSGRA0_WSGRB0_WS32_WG32_2_1_WGMXCC1
    .symbol: 'Cijk_Ailk_Bjlk_F8F8S_BH_UserArgs_MT32x16x64_MI16x16x1_SN_LDSB1_AFC0_AG0_AGGSUA0_AGNTAB0_AFEM2_AFEM1_ASEM32_BL1_BS1_CD1_1_CLR0_CLS0_CADS0_DTLA0_DTLB0_DTLM0_DTVA0_DTVB0_DTVMXSA0_DTVMXSB0_DTVSM0_DPLB0_EPS0_ELFLR0_EMLLn1_FDSI0_GRPM1_GRVWA1_GRVWB1_GSUAMB_GLS0_HPLR0_ISA1250_ICIW1_IU1_K1_LDSTI0_LBSPPA512_LBSPPB256_LBSPPMXSA0_LBSPPMXSB0_LBSPPM0_LPA16_LPB16_LPMXSA0_LPMXSB0_LPM0_LRVW16_LWPMn1_MIAV1_MIWT1_1_MXLIBL_MXSFNS_MO40_MGRIPM1_NTn1_NTA0_NTB0_NTC0_NTD0_NTE0_NTMXSA0_NTMXSB0_NTM0_NTWS0_NVn1_NVA0_NVB0_NVC0_NVD0_NVE0_NVMXSA0_NVMXSB0_NVM0_NVWS0_NEPBS0_NLCA1_NLCB1_ONLL1_PAP0_PGL0_PGR2_PLR0_PKA1_SGROB0_SIA3_SS0_SPO0_SRVW0_SSO0_SVW8_SK0_SKFTR0_SKFDPO0_SKWS0_SKXCCM0_SNLL0_SIP1_SGRO0_TDMI0_TDMIM0_TDMLWS0_TDMS0_TIN0_THn1_THA0_THB0_THC0_THD0_THE0_THMXSA0_THMXSB0_THM0_THWS0_TLDS0_TLDSMn1_ULSGRO0_USL1_USLMX0_UDFMAC0_UIOFGRO0_UPLRP0_USFGROn1_USI0_VSn1_VWA1_VWB1_WSGRA0_WSGRB0_WS32_WG32_2_1_WGMXCC1.kd'
    .language:                   OpenCL C
    .language_version:
      - 2
      - 0
    .args:
      - .name:            Gemm info
        .size:            4
        .offset:          0
        .value_kind:      by_value
        .value_type:      u32
      - .name:            kernel info0
        .size:            4
        .offset:          4
        .value_kind:      by_value
        .value_type:      u32
      - .name:            kernel info1
        .size:            4
        .offset:          8
        .value_kind:      by_value
        .value_type:      u32
      - .name:            numWG
        .size:            4
        .offset:          12
        .value_kind:      by_value
        .value_type:      u32
      - .name:            SizesFree0
        .size:            4
        .offset:          16
        .value_kind:      by_value
        .value_type:      u32
      - .name:            SizesFree1
        .size:            4
        .offset:          20
        .value_kind:      by_value
        .value_type:      u32
      - .name:            SizesFree2
        .size:            4
        .offset:          24
        .value_kind:      by_value
        .value_type:      u32
      - .name:            SizesSum0
        .size:            4
        .offset:          28
        .value_kind:      by_value
        .value_type:      u32
      - .name:            D
        .size:            8
        .offset:          32
        .value_kind:      global_buffer
        .value_type:      fp8
        .address_space:   generic
      - .name:            C
        .size:            8
        .offset:          40
        .value_kind:      global_buffer
        .value_type:      fp8
        .address_space:   generic
      - .name:            A
        .size:            8
        .offset:          48
        .value_kind:      global_buffer
        .value_type:      fp8
        .address_space:   generic
      - .name:            B
        .size:            8
        .offset:          56
        .value_kind:      global_buffer
        .value_type:      fp8
        .address_space:   generic
      - .name:            strideD0
        .size:            4
        .offset:          64
        .value_kind:      by_value
        .value_type:      u32
      - .name:            strideD1
        .size:            4
        .offset:          68
        .value_kind:      by_value
        .value_type:      u32
      - .name:            strideC0
        .size:            4
        .offset:          72
        .value_kind:      by_value
        .value_type:      u32
      - .name:            strideC1
        .size:            4
        .offset:          76
        .value_kind:      by_value
        .value_type:      u32
      - .name:            strideA0
        .size:            4
        .offset:          80
        .value_kind:      by_value
        .value_type:      u32
      - .name:            strideA1
        .size:            4
        .offset:          84
        .value_kind:      by_value
        .value_type:      u32
      - .name:            strideB0
        .size:            4
        .offset:          88
        .value_kind:      by_value
        .value_type:      u32
      - .name:            strideB1
        .size:            4
        .offset:          92
        .value_kind:      by_value
        .value_type:      u32
      - .name:            alpha
        .size:            4
        .offset:          96
        .value_kind:      by_value
        .value_type:      f32
      - .name:            beta
        .size:            4
        .offset:          100
        .value_kind:      by_value
        .value_type:      f32
      - .name:            batchOffsetD
        .size:            8
        .offset:          104
        .value_kind:      by_value
        .value_type:      u64
      - .name:            batchOffsetC
        .size:            8
        .offset:          112
        .value_kind:      by_value
        .value_type:      u64
      - .name:            batchOffsetA
        .size:            8
        .offset:          120
        .value_kind:      by_value
        .value_type:      u64
      - .name:            batchOffsetB
        .size:            8
        .offset:          128
        .value_kind:      by_value
        .value_type:      u64
    .group_segment_fixed_size:   8192
    .kernarg_segment_align:      8
    .kernarg_segment_size:       136
    .max_flat_workgroup_size:    64
    .private_segment_fixed_size: 0
    .sgpr_count:                 70
    .sgpr_spill_count:           0
    .vgpr_count:                 254
    .vgpr_spill_count:           0
    .wavefront_size:             32
...
.end_amdgpu_metadata
Cijk_Ailk_Bjlk_F8F8S_BH_UserArgs_MT32x16x64_MI16x16x1_SN_LDSB1_AFC0_AG0_AGGSUA0_AGNTAB0_AFEM2_AFEM1_ASEM32_BL1_BS1_CD1_1_CLR0_CLS0_CADS0_DTLA0_DTLB0_DTLM0_DTVA0_DTVB0_DTVMXSA0_DTVMXSB0_DTVSM0_DPLB0_EPS0_ELFLR0_EMLLn1_FDSI0_GRPM1_GRVWA1_GRVWB1_GSUAMB_GLS0_HPLR0_ISA1250_ICIW1_IU1_K1_LDSTI0_LBSPPA512_LBSPPB256_LBSPPMXSA0_LBSPPMXSB0_LBSPPM0_LPA16_LPB16_LPMXSA0_LPMXSB0_LPM0_LRVW16_LWPMn1_MIAV1_MIWT1_1_MXLIBL_MXSFNS_MO40_MGRIPM1_NTn1_NTA0_NTB0_NTC0_NTD0_NTE0_NTMXSA0_NTMXSB0_NTM0_NTWS0_NVn1_NVA0_NVB0_NVC0_NVD0_NVE0_NVMXSA0_NVMXSB0_NVM0_NVWS0_NEPBS0_NLCA1_NLCB1_ONLL1_PAP0_PGL0_PGR2_PLR0_PKA1_SGROB0_SIA3_SS0_SPO0_SRVW0_SSO0_SVW8_SK0_SKFTR0_SKFDPO0_SKWS0_SKXCCM0_SNLL0_SIP1_SGRO0_TDMI0_TDMIM0_TDMLWS0_TDMS0_TIN0_THn1_THA0_THB0_THC0_THD0_THE0_THMXSA0_THMXSB0_THM0_THWS0_TLDS0_TLDSMn1_ULSGRO0_USL1_USLMX0_UDFMAC0_UIOFGRO0_UPLRP0_USFGROn1_USI0_VSn1_VWA1_VWB1_WSGRA0_WSGRB0_WS32_WG32_2_1_WGMXCC1:
label_ASM_Start:  /// Main body of the asm kernel
global_prefetch_b8 v0, s[0:1] th:TH_LOAD_RT scope:SCOPE_SE
v_nop
s_setreg_IMM32_b32 hwreg(26,0,2), 2

/******************************************/
/* VGPR Assignments for MX                */
/******************************************/
.set vgprMXSBase, 0

/******************************************/
/* VGPR Macro Assignments for MX          */
/******************************************/

/******************************************/
/* VGPR Assignments                       */
/******************************************/
/* ValuC range: [0-8), serializedStore enabled */
.set vgprValuC, 0
/* ValuA/B   Xn=PLR buffer idx,  In=InnerUnroll idx */
.set vgprBase, 60
.set vgprLocalWriteAddrA, 56
.set vgprLocalWriteAddrB, 57
.set vgprGlobalReadOffsetA, 8
.set vgprGlobalReadOffsetB, 40
.set vgprLocalReadAddrA, 58
.set vgprLocalReadAddrB, 59
.set vgprSerial, 224

/******************************************/
/* VGPR Macro Assignments                 */
/******************************************/
.set vgprValuA_X0_I0_BASE, vgprBase+0
.set vgprValuA_X0_I0_D0_PACK, vgprBase+8
.set vgprValuB_X0_I0_BASE, vgprBase+34
.set vgprValuB_X0_I0_D0_PACK, vgprBase+42
.set vgprG2LA_BASE, vgprBase+68
.set vgprG2LB_BASE, vgprBase+132
.set vgprPackTemp, vgprBase+66
.set vgprValuA_X0_I0, vgprValuA_X0_I0_BASE+0
.set vgprValuB_X0_I0, vgprValuB_X0_I0_BASE+0
.set vgprValuA_X0_I0_D1, vgprValuA_X0_I0_D0_PACK+0
.set vgprValuA_X0_I0_D2, vgprValuA_X0_I0_D0_PACK+8
.set vgprValuA_X0_I0_D3, vgprValuA_X0_I0_D0_PACK+16
.set vgprValuB_X0_I0_D1, vgprValuB_X0_I0_D0_PACK+0
.set vgprValuB_X0_I0_D2, vgprValuB_X0_I0_D0_PACK+8
.set vgprValuB_X0_I0_D3, vgprValuB_X0_I0_D0_PACK+16
.set vgprG2LA, vgprG2LA_BASE+0
.set vgprG2LB, vgprG2LB_BASE+0

/******************************************/
/* SGPR Assignments                       */
/******************************************/
.set sgprKernArgAddress, 0
.set sgprWorkGroup0, 2
.set sgprWorkGroup1, 3
.set sgprWorkGroup2, 4
.set sgprArgType, 5
.set sgprGSUSumIdx, 6
.set sgprGSULog2BpeC, 8
.set sgprGSULog2BpeD, 9
.set sgprStaggerU, 10
.set sgprWGM, 11
.set sgprLoopCounterL, 12
.set sgprOrigLoopCounter, 13
.set sgprSrdD, 16
.set sgprSrdC, 20
.set sgprNumWorkGroups0, 14
.set sgprNumWorkGroups1, 15
.set sgprSizesFree, 32
.set sgprSizesSum, 35
.set sgprAddressD, 36
.set sgprAddressC, 38
.set sgprAddressA, 40
.set sgprAddressB, 42
.set sgprStridesD, 44
.set sgprStridesC, 46
.set sgprStridesA, 48
.set sgprStridesB, 50
.set sgprAlpha, 52
.set sgprBeta, 53
.set sgprGSU, 54

/* Size Assignments */
.set sgprSizeI, sgprSizesFree+0
.set sgprSizeJ, sgprSizesFree+1
.set sgprSizeK, sgprSizesFree+2
.set sgprSizeL, sgprSizesSum+0

/* Stride Assignments */
.set constStrideD0I, 1
.set sgprStrideD1J, sgprStridesD+0
.set sgprStrideDK, sgprStridesD+1
.set constStrideC0I, 1
.set sgprStrideC1J, sgprStridesC+0
.set sgprStrideCK, sgprStridesC+1
.set constStrideA0I, 1
.set sgprStrideAL, sgprStridesA+0
.set sgprStrideAK, sgprStridesA+1
.set constStrideB1J, 1
.set sgprStrideBL, sgprStridesB+0
.set sgprStrideBK, sgprStridesB+1

.set MT0, 32
.set MT1, 16
.set DepthU, 64
/* Number of elements to shift-left SRD */
.set SrdShiftLeftA, 1
.set SrdShiftLeftB, 1
/* 2GB limit - set offsets to -1 to exceed this and clamp */
.set BufferLimit, 0xffffffff
.set BufferOOB, 0xfffff000

/******************************************/
/* Bits 127:96 of SRD.                    */
/* hex: 0x0                               */
/* num_records_upper (6b): 0              */
/* reserved (6b): 0                       */
/* stride (14b): 0                        */
/* stride_scale (2b): 0                   */
/* swizzle_enable (1b): 0                 */
/* oob_select (1b): 0                     */
/* type (2b): 0                           */
/******************************************/
.set Srd127_96, 0x0

/* Global Offset A */

/* Global Offset B */

/******************************************/
/* Allocate Resources                     */
/******************************************/
label_Preload_Offset_Start:
s_setreg_IMM32_b32 hwreg(26,0,2), 2
s_and_b32 s55, 0x3fffffff, s2                      // Get nums of gemm
s_lshr_b32 s56, s2, 0x1e                           // Get arg type
s_mov_b32 s57, s3                                  // Preload internal args
s_cmp_eq_u32 s56, 3                                // Is kernel argType == 3
s_cbranch_scc1 label_Bypass_ArgType3_to_ArgType0_Instance2
s_cmp_eq_u32 s56, 0                                // Is kernel args
s_cbranch_scc0 label_Preload_HBMArgs
label_Bypass_ArgType3_to_ArgType0_Instance2:
s_add_u32 s[sgprKernArgAddress], s[sgprKernArgAddress], 0x10 // Shift common args
s_addc_u32 s[sgprKernArgAddress+1], s[sgprKernArgAddress+1], 0

/* Load Kernel Args */
s_mov_b64 s[32:33], s[6:7]                         // move preload data to correct sgpr
s_mov_b64 s[34:35], s[8:9]                         // move preload data to correct sgpr
s_mov_b64 s[36:37], s[10:11]                       // move preload data to correct sgpr
s_mov_b64 s[38:39], s[12:13]                       // move preload data to correct sgpr
s_mov_b64 s[40:41], s[14:15]                       // move preload data to correct sgpr
s_mov_b64 s[42:43], s[16:17]                       // move preload data to correct sgpr
s_mov_b64 s[44:45], s[18:19]                       // move preload data to correct sgpr
s_mov_b64 s[46:47], s[20:21]                       // move preload data to correct sgpr
s_mov_b64 s[48:49], s[22:23]                       // move preload data to correct sgpr
s_mov_b64 s[50:51], s[24:25]                       // move preload data to correct sgpr
s_mov_b64 s[52:53], s[26:27]                       // move preload data to correct sgpr
s_branch label_Preload_LoadArgsEnd
label_Preload_HBMArgs:
s_mov_b64 s[sgprKernArgAddress:sgprKernArgAddress+1], s[6:7] // Load address of kernel arguments
label_Preload_LoadArgsEnd:
s_mov_b32 s[sgprWGM], s4                           // Preload internal args2
s_mov_b32 s58, s5                                  // Load num of WGs
s_and_b32 s[sgprStaggerU], s57, 0xffff0000         // Restore StaggerU related vars
s_lshr_b32 s[sgprStaggerU], s[sgprStaggerU], 0x10
s_and_b32 s[sgprGSU], s57, 0xffff                  // Restore GSUConfig and GSU
s_mov_b32 s[sgprArgType], s56
s_mov_b32 m0, 0x2000                               // LDS clamp at 8192 bytes
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v[vgprSerial], v0                        // thread serial id
s_mov_b32 vcc_hi, 0                                // Ensure hi bits are zero

/* Init workgroup id from ttmp */
s_mov_b32 s[sgprWorkGroup0], ttmp9
s_and_b32 s[sgprWorkGroup1], 0xffff, ttmp7
s_lshr_b32 s[sgprWorkGroup2], ttmp7, 0x10

/* remap workgroup to XCCs */
s_lshr_b32 s64, s[sgprWGM], 0x10                   // Get WGMXCC
s_ff1_i32_b32 s64, s64                             // Get log(WGMXCC)
s_lshr_b32 s65, s[sgprWGM], 0x16                   // Get CU_Count
/* remap WGs if WGMXCC > 1 ( log(WGMXCC) > 0 ) */
s_cmp_gt_i32 s64, 0
s_cbranch_scc0 label_skip_WGMXCC
/* only remap WGs in the range */
s_lshr_b32 s61, s58, s64
s_lshl_b32 s61, s61, s64
s_cmp_ge_u32 s[sgprWorkGroup0], s61
s_cbranch_scc1 label_skip_WGMXCC
s_cmp_eq_u32 s65, 0                                // CU_Count == 0 ?
s_cbranch_scc0 label_XCCG_nonzero
s_lshr_b32 s61, s[sgprWorkGroup0], s64
s_bfm_b32 s62, s64, 0
s_and_b32 s62, s[sgprWorkGroup0], s62
s_lshr_b32 s63, s58, s64
s_mul_i32 s62, s62, s63
s_add_u32 s[sgprWorkGroup0], s61, s62
s_branch label_skip_WGMXCC
label_XCCG_nonzero:
/* temp0 = (wg//CU_Count)*CU_Count */
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cvt_f64_u32 v[60:61], s65                        // s61 = s[sgprWorkGroup0] / s65
v_rcp_f64 v[60:61], v[60:61]                       // s61 = s[sgprWorkGroup0] / s65
v_cvt_f64_u32 v[62:63], s[sgprWorkGroup0]          // s61 = s[sgprWorkGroup0] / s65
v_mul_f64 v[60:61], v[60:61], v[62:63]             // s61 = s[sgprWorkGroup0] / s65
v_cvt_u32_f64 v60, v[60:61]                        // s61 = s[sgprWorkGroup0] / s65
v_mul_lo_u32 v61, v60, s65                         // s61 = s[sgprWorkGroup0] / s65
v_sub_nc_u32 v62, s[sgprWorkGroup0], v61           // s61 = s[sgprWorkGroup0] / s65
v_cmp_ge_u32 vcc_lo, v62, s65                      // s61 = s[sgprWorkGroup0] / s65
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, vcc_lo                          // s61 = s[sgprWorkGroup0] / s65
v_add_nc_u32 v60, v60, 1                           // s61 = s[sgprWorkGroup0] / s65
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, -1                              // Reset exec
v_mul_lo_u32 v61, v60, s65                         // s61 = s[sgprWorkGroup0] / s65
v_sub_nc_u32 v62, s[sgprWorkGroup0], v61           // s61 = s[sgprWorkGroup0] / s65
v_readfirstlane_b32 s61, v60                       // quotient
v_readfirstlane_b32 s62, v62                       // remainder
s_mul_i32 s61, s61, s65
/* temp1 = (wg%CU_Count)//WGMXCC */
s_lshr_b32 s62, s62, s64
/* temp0 = temp0 + temp1 */
s_add_u32 s61, s61, s62
/* temp1 = (wg%WGMXCC) * ((WGs - (WGs//CU_Count) * CU_Count) if (wg > (WGs//CU_Count) * CU_Count) else CU_Count)//WGMXCC */
v_cvt_f64_u32 v[60:61], s65                        // s62 = s58 / s65
v_rcp_f64 v[60:61], v[60:61]                       // s62 = s58 / s65
v_cvt_f64_u32 v[62:63], s58                        // s62 = s58 / s65
v_mul_f64 v[60:61], v[60:61], v[62:63]             // s62 = s58 / s65
v_cvt_u32_f64 v60, v[60:61]                        // s62 = s58 / s65
v_mul_lo_u32 v61, v60, s65                         // s62 = s58 / s65
v_sub_nc_u32 v62, s58, v61                         // s62 = s58 / s65
v_cmp_ge_u32 vcc_lo, v62, s65                      // s62 = s58 / s65
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, vcc_lo                          // s62 = s58 / s65
v_add_nc_u32 v60, v60, 1                           // s62 = s58 / s65
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, -1                              // Reset exec
v_readfirstlane_b32 s62, v60                       // quotient
s_mul_i32 s62, s62, s65
s_sub_u32 s63, s58, s62
s_cmp_gt_u32 s[sgprWorkGroup0], s62
s_cselect_b32 s62, s63, s65
s_lshr_b32 s62, s62, s64
s_bfm_b32 s63, s64, 0
s_and_b32 s63, s[sgprWorkGroup0], s63
s_mul_i32 s62, s62, s63
/* WorkGroup0 = temp0 + temp1 */
s_add_u32 s[sgprWorkGroup0], s61, s62
label_skip_WGMXCC:  /// skip WGMXCC if no enough WGs to remap
s_cmp_eq_u32 s56, 3
s_cbranch_scc1 label_ArgType3_Routed_To_ArgType0
s_cmp_eq_u32 s56, 0
s_cbranch_scc0 label_MultiGemm
label_ArgType3_Routed_To_ArgType0:
/* init: add vgpr [60...187) to pool */
/* init: add vgpr [0...8) to pool */
/* init: add agpr [0...0) to pool */

/******************************************/
/* Local Read Addresses                   */
/******************************************/

/* local read addresses: tile assignments a/b */
/* lr0I */
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_and_b32 v1, 31, v[vgprSerial]                    // 0. thread id in wave: wtid = tid % wavelength(32)
v_and_b32 v0, 15, v1                               // 1. N offset: nIdx = wtid % MI_N(16)
                                                   // 1. N offset: nOffset = nIdx * nStride(1) (multiplier is 1, do nothing)
/* Skip. 2. block offset: bnOffset = 0 when num1DBlocks = 1 */
                                                   // 4. apply VectorWidth: bnOffset = bnOffset * vw(1) (multiplier is 1, do nothing)
v_lshrrev_b32 v1, 4, v1                            // 5. K offset: kIdx = wtid / (MIN(16) * MIBB(1))
v_lshl_add_u32 v0, v1, 9, v0                       // 5. K offset: lrKOffset = kIdx * mStride(512); 6. offset in wave: lrOffset = bnOffset + lrKOffset
v_lshrrev_b32 v4, 5, v[vgprSerial]                 // 7. wave offset in N dimen: wtid = tid / dividedForWaveId(32)
v_and_b32 v4, 1, v4                                // 7. wave offset in M dimen: wtid0 = wtid / num1DWaves(2)
v_lshl_add_u32 v0, v4, 4, v0                       // 7. wave offset in M dimen: wOffset = wtid0 * W0Stride(16); 7. final local read offset: flrOffset = lrOffset + WOffset
/* lr1J */
v_and_b32 v2, 31, v[vgprSerial]                    // 0. thread id in wave: wtid = tid % wavelength(32)
v_and_b32 v1, 15, v2                               // 1. N offset: nIdx = wtid % MI_N(16)
                                                   // 1. N offset: nOffset = nIdx * nStride(1) (multiplier is 1, do nothing)
/* Skip. 2. block offset: bnOffset = 0 when num1DBlocks = 1 */
                                                   // 4. apply VectorWidth: bnOffset = bnOffset * vw(1) (multiplier is 1, do nothing)
v_lshrrev_b32 v2, 4, v2                            // 5. K offset: kIdx = wtid / (MIN(16) * MIBB(1))
v_lshl_add_u32 v1, v2, 8, v1                       // 5. K offset: lrKOffset = kIdx * mStride(256); 6. offset in wave: lrOffset = bnOffset + lrKOffset

/* local read addresses: final offsets a */
v_lshrrev_b32 v2, 5, v[vgprSerial]                 // 2 = Serial / 32
v_lshrrev_b32 v2, 1, v2                            // LSU offset: Get LSU wave_id
s_mov_b32 s16, 2048                                // LSU offset: stride = lsuStride(64)*(MT0(32) + PAD0(0))
v_mul_lo_u32 v2, s16, v2                           // LSU offset: lsuoffset = wave_id*lsuStride*(MT0+PAD)
v_add_nc_u32 v[vgprLocalReadAddrA], v2, v0         // Final Offset: offset = (lro0+lsuoffset)*bpeDS
                                                   //  (bpe is 1, do nothing)
v_lshrrev_b32 v3, 9, v[vgprLocalReadAddrA]         // Final Offset: padding 16 per block 512
v_lshl_add_u32 v[vgprLocalReadAddrA], v3, 4, v[vgprLocalReadAddrA] // Final Offset: padding 16 per block 512

/* local read addresses: final offsets b */
v_lshrrev_b32 v0, 5, v[vgprSerial]                 // 0 = Serial / 32
v_lshrrev_b32 v0, 1, v0                            // LSU offset: Get LSU wave_id
s_mov_b32 s16, 1024                                // LSU offset: stride = lsuStride(64)*(MT1(16) + PAD1(0))
v_mul_lo_u32 v0, s16, v0                           // LSU offset: lsuoffset = wave_id*lsuStride*(MT1+PAD)
v_add_nc_u32 v[vgprLocalReadAddrB], v0, v1         // Final Offset: offset = (lro1+lsuoffset)*bpeDS
                                                   //  (bpe is 1, do nothing)
v_lshrrev_b32 v2, 8, v[vgprLocalReadAddrB]         // Final Offset: padding 16 per block 256
v_lshl_add_u32 v[vgprLocalReadAddrB], v2, 4, v[vgprLocalReadAddrB] // Final Offset: padding 16 per block 256

/* local read addresses: declare addresses a */

/* local read addresses: declare addresses b */
v_add_co_u32 v[vgprLocalReadAddrB+0], vcc_lo, 0x900, v[vgprLocalReadAddrB+0] //  += LdsOffsetB (lower)

/******************************************/
/* Local Write Addresses                  */
/******************************************/
/* LVCA = 32 */
/* v1 = A-unroll = serial/LVCA */
v_lshrrev_b32 v1, 5, v[vgprSerial]                 // 1 = Serial / 32
v_and_b32 v0, 31, v[vgprSerial]                    // 0 = Serial % 32
v_mov_b32 v4, v1                                   // copy for GlobalSplitU
/* LVCB = 16 */
/* v3 = B-unroll = serial/LVCB */
v_lshrrev_b32 v3, 4, v[vgprSerial]                 // 3 = Serial / 16
v_and_b32 v2, 15, v[vgprSerial]                    // 2 = Serial % 16
v_mov_b32 v5, v3                                   // copy for GlobalSplitU
/* lwaUnrollAssignmentA = v4 */
/* lwaUnrollAssignmentB = v5 */

/* local write addresses: first offset a */
v_mul_u32_u24 v[vgprLocalWriteAddrA], 0x20, v4     // lwAL**(MTA + PAD)
v_add_nc_u32 v[vgprLocalWriteAddrA], v0, v[vgprLocalWriteAddrA] // lwFOA = (lwAA + lwAL*(MT0I+PAD))
                                                   //  (bpe is 1, do nothing)
v_lshrrev_b32 v6, 9, v[vgprLocalWriteAddrA]        // padding 16 per block 512
v_lshl_add_u32 v[vgprLocalWriteAddrA], v6, 4, v[vgprLocalWriteAddrA] // padding 16 per block 512

/* local write addresses: first offset b */
v_mul_u32_u24 v[vgprLocalWriteAddrB], 0x10, v5     // lwBL**(MTB + PAD)
v_add_nc_u32 v[vgprLocalWriteAddrB], v2, v[vgprLocalWriteAddrB] // lwFOB = (lwBB + lwBL*(MT1J+PAD))
                                                   //  (bpe is 1, do nothing)
v_lshrrev_b32 v6, 8, v[vgprLocalWriteAddrB]        // padding 16 per block 256
v_lshl_add_u32 v[vgprLocalWriteAddrB], v6, 4, v[vgprLocalWriteAddrB] // padding 16 per block 256
v_add_co_u32 v[vgprLocalWriteAddrB], vcc_lo, 0x900, v[vgprLocalWriteAddrB] // lwFOB = lw1J + lwL*MT1J + LDS_OFFSET_B=2304
v_mov_b32 v62, MT0                                 // set MT0 into sgpr
v_mov_b32 v61, s[sgprSizesFree+0]                  // set Free0 size
v_cvt_f32_u32 v60, v62                             // v60 = ceil(v61 / v62)
v_rcp_iflag_f32 v60, v60                           // v60 = ceil(v61 / v62)
v_cvt_f32_u32 v63, v61                             // v60 = ceil(v61 / v62)
v_mul_f32 v60, v60, v63                            // v60 = ceil(v61 / v62)
v_cvt_u32_f32 v60, v60                             // v60 = ceil(v61 / v62)
v_mul_u32_u24 v63, v60, v62                        // v60 = ceil(v61 / v62)
v_sub_nc_u32 v63, v61, v63                         // v60 = ceil(v61 / v62)
v_cmp_ne_u32 vcc_lo, v63, 0                        // v60 = ceil(v61 / v62)
v_add_co_ci_u32 v60, vcc_lo, v60, 0, vcc_lo        // ceil
v_mov_b32 v62, MT1                                 // set MT1 into sgpr
v_mov_b32 v61, s[sgprSizesFree+1]                  // set Free1 size
v_readfirstlane_b32 s[sgprNumWorkGroups0], v60     // set back to numWorkGroup0
v_cvt_f32_u32 v60, v62                             // v60 = ceil(v61 / v62)
v_rcp_iflag_f32 v60, v60                           // v60 = ceil(v61 / v62)
v_cvt_f32_u32 v63, v61                             // v60 = ceil(v61 / v62)
v_mul_f32 v60, v60, v63                            // v60 = ceil(v61 / v62)
v_cvt_u32_f32 v60, v60                             // v60 = ceil(v61 / v62)
v_mul_u32_u24 v63, v60, v62                        // v60 = ceil(v61 / v62)
v_sub_nc_u32 v63, v61, v63                         // v60 = ceil(v61 / v62)
v_cmp_ne_u32 vcc_lo, v63, 0                        // v60 = ceil(v61 / v62)
v_add_co_ci_u32 v60, vcc_lo, v60, 0, vcc_lo        // ceil
s_nop 0                                            // 1 wait states
v_readfirstlane_b32 s[sgprNumWorkGroups1], v60     // set back to numWorkGroup1
s_wait_kmcnt 0                                     // wait for -16/0 bytes of kern args

/* remap wg from 1D(idxWG012) to 3D(wg2,wg1,wg0) */
/* wg2 = idxWG012 * smallMagicNumber(1/(numWG0*numWG1)) */
s_mul_i32 s16, s[sgprNumWorkGroups0], s[sgprNumWorkGroups1]
s_and_b32 s17, s[sgprGSU], 0x3fff                  // Restore GSU
s_mul_i32 s16, s16, s17
v_cvt_f32_u32 v6, s16                              // s16 = s[sgprWorkGroup0] / s16
v_rcp_iflag_f32 v6, v6                             // s16 = s[sgprWorkGroup0] / s16
v_cvt_f32_u32 v7, s[sgprWorkGroup0]                // s16 = s[sgprWorkGroup0] / s16
v_mul_f32 v6, v6, v7                               // s16 = s[sgprWorkGroup0] / s16
v_cvt_u32_f32 v6, v6                               // s16 = s[sgprWorkGroup0] / s16
v_mul_u32_u24 v7, v6, s16                          // s16 = s[sgprWorkGroup0] / s16
v_sub_nc_u32 v7, s[sgprWorkGroup0], v7             // s16 = s[sgprWorkGroup0] / s16
v_cmp_eq_u32 vcc_lo, v7, s16                       // s16 = s[sgprWorkGroup0] / s16
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, vcc_lo                          // s16 = s[sgprWorkGroup0] / s16
v_add_nc_u32 v6, 1, v6                             // s16 = s[sgprWorkGroup0] / s16
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, -1                              // Reset exec
v_cmp_gt_u32 vcc_lo, v7, s16                       // overflow happened in remainder
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, vcc_lo                          // overflow happened in remainder
v_sub_nc_u32 v6, v6, 1                             // quotient - 1
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, -1                              // Reset exec
v_readfirstlane_b32 s16, v6                        // quotient
s_mov_b32 s[sgprWorkGroup2], s16
/* idxWG01 = idxWG012 - wg2 * numWG0 * numWG1 */
s_mul_i32 s16, s[sgprNumWorkGroups1], s[sgprNumWorkGroups0]
s_mul_i32 s16, s16, s[sgprWorkGroup2]
s_mul_i32 s16, s16, s17
s_sub_u32 s[sgprWorkGroup0], s[sgprWorkGroup0], s16
/* wg1 = idxWG01 * smallMagicNumber(1/numWG0) */
v_cvt_f32_u32 v6, s[sgprNumWorkGroups0]            // s16 = s[sgprWorkGroup0] / s[sgprNumWorkGroups0]
v_rcp_iflag_f32 v6, v6                             // s16 = s[sgprWorkGroup0] / s[sgprNumWorkGroups0]
v_cvt_f32_u32 v7, s[sgprWorkGroup0]                // s16 = s[sgprWorkGroup0] / s[sgprNumWorkGroups0]
v_mul_f32 v6, v6, v7                               // s16 = s[sgprWorkGroup0] / s[sgprNumWorkGroups0]
v_cvt_u32_f32 v6, v6                               // s16 = s[sgprWorkGroup0] / s[sgprNumWorkGroups0]
v_mul_u32_u24 v7, v6, s[sgprNumWorkGroups0]        // s16 = s[sgprWorkGroup0] / s[sgprNumWorkGroups0]
v_sub_nc_u32 v7, s[sgprWorkGroup0], v7             // s16 = s[sgprWorkGroup0] / s[sgprNumWorkGroups0]
v_cmp_eq_u32 vcc_lo, v7, s[sgprNumWorkGroups0]     // s16 = s[sgprWorkGroup0] / s[sgprNumWorkGroups0]
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, vcc_lo                          // s16 = s[sgprWorkGroup0] / s[sgprNumWorkGroups0]
v_add_nc_u32 v6, 1, v6                             // s16 = s[sgprWorkGroup0] / s[sgprNumWorkGroups0]
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, -1                              // Reset exec
v_cmp_gt_u32 vcc_lo, v7, s[sgprNumWorkGroups0]     // overflow happened in remainder
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, vcc_lo                          // overflow happened in remainder
v_sub_nc_u32 v6, v6, 1                             // quotient - 1
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, -1                              // Reset exec
v_readfirstlane_b32 s16, v6                        // quotient
s_mov_b32 s[sgprWorkGroup1], s16
/* wg0 = idxWG01 - wg1 * numWG0 */
s_mul_i32 s16, s[sgprWorkGroup1], s[sgprNumWorkGroups0]
s_sub_u32 s[sgprWorkGroup0], s[sgprWorkGroup0], s16
s_branch label_MultiGemmEnd
label_MultiGemm:

/* Check if custom structure pointer is null */
s_cmp_eq_u32 s[sgprArgType], 2                     // ArgType == 2 ?
s_cbranch_scc1 label_IsExternalValid               // branch if ArgType == 2
s_mov_b32 s15, 88                                  // KernArgAddressOffset
s_mul_i32 s22, s55, 4
s_mov_b64 s[16:17], s[sgprKernArgAddress:sgprKernArgAddress+1]
s_branch label_IsExternalValidEnd
label_IsExternalValid:
s_mov_b32 s15, 228
s_mov_b32 s22, 0
s_mov_b64 s[16:17], s[sgprKernArgAddress:sgprKernArgAddress+1]
label_IsExternalValidEnd:

/* Grouped Gemm:: prefetch 1 arg load */
s_mov_b32 s14, 1
s_mov_b32 s23, 0
s_load_b128 s[32:35], s[16:17], s22
s_mov_b32 s24, 1
s_cmp_eq_u32 s55, s24                              // if gemm_count is 1?
s_cbranch_scc1 label_wgTable_noLoadLoop

/* Grouped Gemm:: accumulate numTiles for each gemm */
/* Grouped Gemm:: loop start */
label_Loop_GemmCount:
s_wait_kmcnt 0
s_lshr_b32 s20, s32, 5                             // s20 = s32 / 32
s_and_b32 s18, 31, s32                             // s18 = s32 % 32
s_addc_u32 s20, s20, 0
s_lshr_b32 s21, s33, 4                             // s21 = s33 / 16
s_and_b32 s18, 15, s33                             // s18 = s33 % 16
s_addc_u32 s21, s21, 0
s_mul_i32 s20, s20, s21
s_mul_i32 s20, s20, s34
s_and_b32 s21, s[sgprGSU], 0x3fff                  // Restore GSU
s_mul_i32 s20, s20, s21
s_add_u32 s23, s23, s20
s_cmp_lt_u32 s[sgprWorkGroup0], s23
s_cbranch_scc1 label_FOUND
s_add_u32 s22, s22, s15
s_load_b128 s[32:35], s[16:17], s22
s_add_u32 s14, s14, 1
s_cmp_lt_u32 s14, s55
s_cbranch_scc1 label_Loop_GemmCount

/* Grouped Gemm:: noLoadLoop */
label_wgTable_noLoadLoop:
s_wait_kmcnt 0
s_lshr_b32 s20, s32, 5                             // s20 = s32 / 32
s_and_b32 s18, 31, s32                             // s18 = s32 % 32
s_addc_u32 s20, s20, 0
s_lshr_b32 s21, s33, 4                             // s21 = s33 / 16
s_and_b32 s18, 15, s33                             // s18 = s33 % 16
s_addc_u32 s21, s21, 0
s_mul_i32 s20, s20, s21
s_mul_i32 s20, s20, s34
s_and_b32 s16, s[sgprGSU], 0x3fff                  // Restore GSU
s_mul_i32 s20, s20, s16
s_add_u32 s23, s23, s20

/* Grouped Gemm:: gemmIndex found */
label_FOUND:
s_sub_u32 s17, s14, 1
s_sub_u32 s16, s23, s20
s_sub_u32 s[sgprWorkGroup0], s[sgprWorkGroup0], s16
/* Check if custom structure pointer is null */
s_cmp_eq_u32 s[sgprArgType], 2                     // ArgType == 2 ?
s_cbranch_scc1 label_LoadExternalStruct            // branch if ArgType == 2

/* Grouped Gemm: offset argument address to gemm */
/* Grouped Gemm: offset address from wg_table_start to args_start */
s_lshl2_add_u32 s[sgprKernArgAddress], s55, s[sgprKernArgAddress]
s_addc_u32 s[sgprKernArgAddress+1], s[sgprKernArgAddress+1], 0
/* Grouped Gemm: offset address from args_start to gemm_start */
s_mul_i32 s17, s17, 88                             // KernArgAddressOffset
s_add_u32 s[sgprKernArgAddress], s[sgprKernArgAddress], s17
s_addc_u32 s[sgprKernArgAddress+1], s[sgprKernArgAddress+1], 0

/* Load Kernel Args */
s_load_b512 s[36:51], s[sgprKernArgAddress:sgprKernArgAddress+1], 16 // 16
s_load_b64 s[52:53], s[sgprKernArgAddress:sgprKernArgAddress+1], 80 // 80
s_branch label_LoadExternalStructEnd
label_LoadExternalStruct:
/* Grouped Gemm: offset address from args_start to gemm_start */
s_mul_i32 s17, s17, 228
s_add_u32 s[sgprKernArgAddress], s[sgprKernArgAddress], s17
s_addc_u32 s[sgprKernArgAddress+1], s[sgprKernArgAddress+1], 0
s_load_b512 s[36:51], s[sgprKernArgAddress:sgprKernArgAddress+1], 16 // 16
s_load_b32 s52, s[sgprKernArgAddress:sgprKernArgAddress+1], 80 // 80
// Read Beta
s_load_b32 s53, s[sgprKernArgAddress:sgprKernArgAddress+1], 96 // 96
label_LoadExternalStructEnd:
/* init: add vgpr [60...187) to pool */
/* init: add vgpr [0...8) to pool */
/* init: add agpr [0...0) to pool */

/******************************************/
/* Local Read Addresses                   */
/******************************************/

/* local read addresses: tile assignments a/b */
/* lr0I */
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_and_b32 v1, 31, v[vgprSerial]                    // 0. thread id in wave: wtid = tid % wavelength(32)
v_and_b32 v0, 15, v1                               // 1. N offset: nIdx = wtid % MI_N(16)
                                                   // 1. N offset: nOffset = nIdx * nStride(1) (multiplier is 1, do nothing)
/* Skip. 2. block offset: bnOffset = 0 when num1DBlocks = 1 */
                                                   // 4. apply VectorWidth: bnOffset = bnOffset * vw(1) (multiplier is 1, do nothing)
v_lshrrev_b32 v1, 4, v1                            // 5. K offset: kIdx = wtid / (MIN(16) * MIBB(1))
v_lshl_add_u32 v0, v1, 9, v0                       // 5. K offset: lrKOffset = kIdx * mStride(512); 6. offset in wave: lrOffset = bnOffset + lrKOffset
v_lshrrev_b32 v4, 5, v[vgprSerial]                 // 7. wave offset in N dimen: wtid = tid / dividedForWaveId(32)
v_and_b32 v4, 1, v4                                // 7. wave offset in M dimen: wtid0 = wtid / num1DWaves(2)
v_lshl_add_u32 v0, v4, 4, v0                       // 7. wave offset in M dimen: wOffset = wtid0 * W0Stride(16); 7. final local read offset: flrOffset = lrOffset + WOffset
/* lr1J */
v_and_b32 v2, 31, v[vgprSerial]                    // 0. thread id in wave: wtid = tid % wavelength(32)
v_and_b32 v1, 15, v2                               // 1. N offset: nIdx = wtid % MI_N(16)
                                                   // 1. N offset: nOffset = nIdx * nStride(1) (multiplier is 1, do nothing)
/* Skip. 2. block offset: bnOffset = 0 when num1DBlocks = 1 */
                                                   // 4. apply VectorWidth: bnOffset = bnOffset * vw(1) (multiplier is 1, do nothing)
v_lshrrev_b32 v2, 4, v2                            // 5. K offset: kIdx = wtid / (MIN(16) * MIBB(1))
v_lshl_add_u32 v1, v2, 8, v1                       // 5. K offset: lrKOffset = kIdx * mStride(256); 6. offset in wave: lrOffset = bnOffset + lrKOffset

/* local read addresses: final offsets a */
v_lshrrev_b32 v2, 5, v[vgprSerial]                 // 2 = Serial / 32
v_lshrrev_b32 v2, 1, v2                            // LSU offset: Get LSU wave_id
s_mov_b32 s16, 2048                                // LSU offset: stride = lsuStride(64)*(MT0(32) + PAD0(0))
v_mul_lo_u32 v2, s16, v2                           // LSU offset: lsuoffset = wave_id*lsuStride*(MT0+PAD)
v_add_nc_u32 v[vgprLocalReadAddrA], v2, v0         // Final Offset: offset = (lro0+lsuoffset)*bpeDS
                                                   //  (bpe is 1, do nothing)
v_lshrrev_b32 v3, 9, v[vgprLocalReadAddrA]         // Final Offset: padding 16 per block 512
v_lshl_add_u32 v[vgprLocalReadAddrA], v3, 4, v[vgprLocalReadAddrA] // Final Offset: padding 16 per block 512

/* local read addresses: final offsets b */
v_lshrrev_b32 v0, 5, v[vgprSerial]                 // 0 = Serial / 32
v_lshrrev_b32 v0, 1, v0                            // LSU offset: Get LSU wave_id
s_mov_b32 s16, 1024                                // LSU offset: stride = lsuStride(64)*(MT1(16) + PAD1(0))
v_mul_lo_u32 v0, s16, v0                           // LSU offset: lsuoffset = wave_id*lsuStride*(MT1+PAD)
v_add_nc_u32 v[vgprLocalReadAddrB], v0, v1         // Final Offset: offset = (lro1+lsuoffset)*bpeDS
                                                   //  (bpe is 1, do nothing)
v_lshrrev_b32 v2, 8, v[vgprLocalReadAddrB]         // Final Offset: padding 16 per block 256
v_lshl_add_u32 v[vgprLocalReadAddrB], v2, 4, v[vgprLocalReadAddrB] // Final Offset: padding 16 per block 256

/* local read addresses: declare addresses a */

/* local read addresses: declare addresses b */
v_add_co_u32 v[vgprLocalReadAddrB+0], vcc_lo, 0x900, v[vgprLocalReadAddrB+0] //  += LdsOffsetB (lower)

/******************************************/
/* Local Write Addresses                  */
/******************************************/
/* LVCA = 32 */
/* v1 = A-unroll = serial/LVCA */
v_lshrrev_b32 v1, 5, v[vgprSerial]                 // 1 = Serial / 32
v_and_b32 v0, 31, v[vgprSerial]                    // 0 = Serial % 32
v_mov_b32 v4, v1                                   // copy for GlobalSplitU
/* LVCB = 16 */
/* v3 = B-unroll = serial/LVCB */
v_lshrrev_b32 v3, 4, v[vgprSerial]                 // 3 = Serial / 16
v_and_b32 v2, 15, v[vgprSerial]                    // 2 = Serial % 16
v_mov_b32 v5, v3                                   // copy for GlobalSplitU
/* lwaUnrollAssignmentA = v4 */
/* lwaUnrollAssignmentB = v5 */

/* local write addresses: first offset a */
v_mul_u32_u24 v[vgprLocalWriteAddrA], 0x20, v4     // lwAL**(MTA + PAD)
v_add_nc_u32 v[vgprLocalWriteAddrA], v0, v[vgprLocalWriteAddrA] // lwFOA = (lwAA + lwAL*(MT0I+PAD))
                                                   //  (bpe is 1, do nothing)
v_lshrrev_b32 v6, 9, v[vgprLocalWriteAddrA]        // padding 16 per block 512
v_lshl_add_u32 v[vgprLocalWriteAddrA], v6, 4, v[vgprLocalWriteAddrA] // padding 16 per block 512

/* local write addresses: first offset b */
v_mul_u32_u24 v[vgprLocalWriteAddrB], 0x10, v5     // lwBL**(MTB + PAD)
v_add_nc_u32 v[vgprLocalWriteAddrB], v2, v[vgprLocalWriteAddrB] // lwFOB = (lwBB + lwBL*(MT1J+PAD))
                                                   //  (bpe is 1, do nothing)
v_lshrrev_b32 v6, 8, v[vgprLocalWriteAddrB]        // padding 16 per block 256
v_lshl_add_u32 v[vgprLocalWriteAddrB], v6, 4, v[vgprLocalWriteAddrB] // padding 16 per block 256
v_add_co_u32 v[vgprLocalWriteAddrB], vcc_lo, 0x900, v[vgprLocalWriteAddrB] // lwFOB = lw1J + lwL*MT1J + LDS_OFFSET_B=2304
v_mov_b32 v62, MT0                                 // set MT0 into sgpr
v_mov_b32 v61, s[sgprSizesFree+0]                  // set Free0 size
v_cvt_f32_u32 v60, v62                             // v60 = ceil(v61 / v62)
v_rcp_iflag_f32 v60, v60                           // v60 = ceil(v61 / v62)
v_cvt_f32_u32 v63, v61                             // v60 = ceil(v61 / v62)
v_mul_f32 v60, v60, v63                            // v60 = ceil(v61 / v62)
v_cvt_u32_f32 v60, v60                             // v60 = ceil(v61 / v62)
v_mul_u32_u24 v63, v60, v62                        // v60 = ceil(v61 / v62)
v_sub_nc_u32 v63, v61, v63                         // v60 = ceil(v61 / v62)
v_cmp_ne_u32 vcc_lo, v63, 0                        // v60 = ceil(v61 / v62)
v_add_co_ci_u32 v60, vcc_lo, v60, 0, vcc_lo        // ceil
v_mov_b32 v62, MT1                                 // set MT1 into sgpr
v_mov_b32 v61, s[sgprSizesFree+1]                  // set Free1 size
v_readfirstlane_b32 s[sgprNumWorkGroups0], v60     // set back to numWorkGroup0
v_cvt_f32_u32 v60, v62                             // v60 = ceil(v61 / v62)
v_rcp_iflag_f32 v60, v60                           // v60 = ceil(v61 / v62)
v_cvt_f32_u32 v63, v61                             // v60 = ceil(v61 / v62)
v_mul_f32 v60, v60, v63                            // v60 = ceil(v61 / v62)
v_cvt_u32_f32 v60, v60                             // v60 = ceil(v61 / v62)
v_mul_u32_u24 v63, v60, v62                        // v60 = ceil(v61 / v62)
v_sub_nc_u32 v63, v61, v63                         // v60 = ceil(v61 / v62)
v_cmp_ne_u32 vcc_lo, v63, 0                        // v60 = ceil(v61 / v62)
v_add_co_ci_u32 v60, vcc_lo, v60, 0, vcc_lo        // ceil
s_nop 0                                            // 1 wait states
v_readfirstlane_b32 s[sgprNumWorkGroups1], v60     // set back to numWorkGroup1
s_wait_kmcnt 0                                     // wait for -16/0 bytes of kern args

/* Early stop if N(SizeFreeJ) == 0 */
s_cmp_eq_u32 s[sgprSizeJ], 0
s_cbranch_scc0 label_NoEarlyStop_N0
label_EarlyStop_if_N_is_0:
s_endpgm
label_NoEarlyStop_N0:

/* remap wg from 1D(idxWG012) to 3D(wg2,wg1,wg0) */
/* wg2 = idxWG012 * smallMagicNumber(1/(numWG0*numWG1)) */
s_mul_i32 s16, s[sgprNumWorkGroups0], s[sgprNumWorkGroups1]
s_and_b32 s17, s[sgprGSU], 0x3fff                  // Restore GSU
s_mul_i32 s16, s16, s17
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cvt_f32_u32 v6, s16                              // s16 = s[sgprWorkGroup0] / s16
v_rcp_iflag_f32 v6, v6                             // s16 = s[sgprWorkGroup0] / s16
v_cvt_f32_u32 v7, s[sgprWorkGroup0]                // s16 = s[sgprWorkGroup0] / s16
v_mul_f32 v6, v6, v7                               // s16 = s[sgprWorkGroup0] / s16
v_cvt_u32_f32 v6, v6                               // s16 = s[sgprWorkGroup0] / s16
v_mul_u32_u24 v7, v6, s16                          // s16 = s[sgprWorkGroup0] / s16
v_sub_nc_u32 v7, s[sgprWorkGroup0], v7             // s16 = s[sgprWorkGroup0] / s16
v_cmp_eq_u32 vcc_lo, v7, s16                       // s16 = s[sgprWorkGroup0] / s16
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, vcc_lo                          // s16 = s[sgprWorkGroup0] / s16
v_add_nc_u32 v6, 1, v6                             // s16 = s[sgprWorkGroup0] / s16
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, -1                              // Reset exec
v_cmp_gt_u32 vcc_lo, v7, s16                       // overflow happened in remainder
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, vcc_lo                          // overflow happened in remainder
v_sub_nc_u32 v6, v6, 1                             // quotient - 1
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, -1                              // Reset exec
v_readfirstlane_b32 s16, v6                        // quotient
s_mov_b32 s[sgprWorkGroup2], s16
/* idxWG01 = idxWG012 - wg2 * numWG0 * numWG1 */
s_mul_i32 s16, s[sgprNumWorkGroups1], s[sgprNumWorkGroups0]
s_mul_i32 s16, s16, s[sgprWorkGroup2]
s_mul_i32 s16, s16, s17
s_sub_u32 s[sgprWorkGroup0], s[sgprWorkGroup0], s16
/* wg1 = idxWG01 * smallMagicNumber(1/numWG0) */
v_cvt_f32_u32 v6, s[sgprNumWorkGroups0]            // s16 = s[sgprWorkGroup0] / s[sgprNumWorkGroups0]
v_rcp_iflag_f32 v6, v6                             // s16 = s[sgprWorkGroup0] / s[sgprNumWorkGroups0]
v_cvt_f32_u32 v7, s[sgprWorkGroup0]                // s16 = s[sgprWorkGroup0] / s[sgprNumWorkGroups0]
v_mul_f32 v6, v6, v7                               // s16 = s[sgprWorkGroup0] / s[sgprNumWorkGroups0]
v_cvt_u32_f32 v6, v6                               // s16 = s[sgprWorkGroup0] / s[sgprNumWorkGroups0]
v_mul_u32_u24 v7, v6, s[sgprNumWorkGroups0]        // s16 = s[sgprWorkGroup0] / s[sgprNumWorkGroups0]
v_sub_nc_u32 v7, s[sgprWorkGroup0], v7             // s16 = s[sgprWorkGroup0] / s[sgprNumWorkGroups0]
v_cmp_eq_u32 vcc_lo, v7, s[sgprNumWorkGroups0]     // s16 = s[sgprWorkGroup0] / s[sgprNumWorkGroups0]
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, vcc_lo                          // s16 = s[sgprWorkGroup0] / s[sgprNumWorkGroups0]
v_add_nc_u32 v6, 1, v6                             // s16 = s[sgprWorkGroup0] / s[sgprNumWorkGroups0]
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, -1                              // Reset exec
v_cmp_gt_u32 vcc_lo, v7, s[sgprNumWorkGroups0]     // overflow happened in remainder
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, vcc_lo                          // overflow happened in remainder
v_sub_nc_u32 v6, v6, 1                             // quotient - 1
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, -1                              // Reset exec
v_readfirstlane_b32 s16, v6                        // quotient
s_mov_b32 s[sgprWorkGroup1], s16
/* wg0 = idxWG01 - wg1 * numWG0 */
s_mul_i32 s16, s[sgprWorkGroup1], s[sgprNumWorkGroups0]
s_sub_u32 s[sgprWorkGroup0], s[sgprWorkGroup0], s16

/* Early stop if wg exceed */
s_cmp_ge_u32 s[sgprWorkGroup2], s[sgprSizesFree+2]
s_cbranch_scc0 label_NoEarlyStop_wgExceed
label_EarlyStop_if_wg_exceed:
s_endpgm
label_NoEarlyStop_wgExceed:

label_MultiGemmEnd:
.set sgprSrdA, 24
.set sgprSrdB, 28
.set sgprShadowLimitA, 56
.set sgprShadowLimitB, 58
.set sgprStaggerUIter, 55
.set sgprWrapUA, 60
.set sgprWrapUB, 62
.set sgprGlobalReadIncsA, 64
.set sgprGlobalReadIncsB, 65
s_cmp_eq_u32 s[sgprArgType], 3                     // ArgType == 3 for General Batched GEMM
s_cbranch_scc1 label_Skip_Address_Prepad_For_Pointer_Array
s_sub_u32 s[sgprAddressA+0], s[sgprAddressA+0], 1  // pre-pad to make room for possible pointer shift
s_subb_u32 s[sgprAddressA+1], s[sgprAddressA+1], 0 // pre-pad to make room for possible pointer shift
s_sub_u32 s[sgprAddressB+0], s[sgprAddressB+0], 1  // pre-pad to make room for possible pointer shift
s_subb_u32 s[sgprAddressB+1], s[sgprAddressB+1], 0 // pre-pad to make room for possible pointer shift
label_Skip_Address_Prepad_For_Pointer_Array:  /// Skip pre-padding of address for pointer array case

/* Short circuit condition if Alpha == 0, then sumDims=0 */
v_cmp_eq_f32 vcc_lo, s[sgprAlpha], 0.0             // s[Alpha] == 0.0f ?
s_cbranch_vccz label_AlphaNonZero                  // branch if s[Alpha] != 0
s_mov_b32 s[sgprSizesSum+0], 0                     // Set summation dim=0 if Alpha == 0
label_AlphaNonZero:
s_setreg_IMM32_b32 hwreg(26,4,1), 1                // Disable WMMA arb stall

/******************************************/
/* Begin setupNewTile                     */
/******************************************/

/* global read addresses: work-group */
/* graWorkGroup mapping */
s_and_b32 s16, s[sgprGSU], 0x3fff                  // Restore GSU
s_cmp_eq_u32 s16, 1                                // GSU == 1 ?
s_cbranch_scc1 label_GSU                           // branch if GSU == 1
// GSU-not-WGMapRR :nwg1 = (size1J + MT1J - 1) / MT1J;
s_and_b32 s16, s[sgprGSU], 0x4000                  // SCC = (GSUWGMRR == 1) ?
s_cbranch_scc1 label_GSUWGMRR                      // branch if GSUWGMRR == 1
s_and_b32 s16, s[sgprGSU], 0x3fff                  // Restore GSU
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cvt_f32_u32 v6, s16                              // s[sgprWorkGroup1] = s[sgprWorkGroup1] / s16
v_rcp_iflag_f32 v6, v6                             // s[sgprWorkGroup1] = s[sgprWorkGroup1] / s16
v_cvt_f32_u32 v7, s[sgprWorkGroup1]                // s[sgprWorkGroup1] = s[sgprWorkGroup1] / s16
v_mul_f32 v6, v6, v7                               // s[sgprWorkGroup1] = s[sgprWorkGroup1] / s16
v_cvt_u32_f32 v6, v6                               // s[sgprWorkGroup1] = s[sgprWorkGroup1] / s16
v_mul_u32_u24 v7, v6, s16                          // s[sgprWorkGroup1] = s[sgprWorkGroup1] / s16
v_sub_nc_u32 v7, s[sgprWorkGroup1], v7             // s[sgprWorkGroup1] = s[sgprWorkGroup1] / s16
v_cmp_eq_u32 vcc_lo, v7, s16                       // s[sgprWorkGroup1] = s[sgprWorkGroup1] / s16
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, vcc_lo                          // s[sgprWorkGroup1] = s[sgprWorkGroup1] / s16
v_add_nc_u32 v6, 1, v6                             // s[sgprWorkGroup1] = s[sgprWorkGroup1] / s16
v_mov_b32 v7, 0                                    // s[sgprGSUSumIdx] = s[sgprWorkGroup1] % s16
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, -1                              // Reset exec
v_cmp_gt_u32 vcc_lo, v7, s16                       // overflow happened in remainder
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, vcc_lo                          // overflow happened in remainder
v_sub_nc_u32 v6, v6, 1                             // quotient - 1
v_mul_u32_u24 v7, v6, s16                          // re-calculate remainder
v_sub_nc_u32 v7, s[sgprWorkGroup1], v7             // re-calculate remainder
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, -1                              // Reset exec
v_readfirstlane_b32 s[sgprWorkGroup1], v6          // quotient
v_readfirstlane_b32 s[sgprGSUSumIdx], v7           // remainder
s_branch label_GSUWGMRR_End
label_GSUWGMRR:
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cvt_f32_u32 v6, s[sgprNumWorkGroups1]            // s[sgprGSUSumIdx] = s[sgprWorkGroup1] / s[sgprNumWorkGroups1]
v_rcp_iflag_f32 v6, v6                             // s[sgprGSUSumIdx] = s[sgprWorkGroup1] / s[sgprNumWorkGroups1]
v_cvt_f32_u32 v7, s[sgprWorkGroup1]                // s[sgprGSUSumIdx] = s[sgprWorkGroup1] / s[sgprNumWorkGroups1]
v_mul_f32 v6, v6, v7                               // s[sgprGSUSumIdx] = s[sgprWorkGroup1] / s[sgprNumWorkGroups1]
v_cvt_u32_f32 v6, v6                               // s[sgprGSUSumIdx] = s[sgprWorkGroup1] / s[sgprNumWorkGroups1]
v_mul_u32_u24 v7, v6, s[sgprNumWorkGroups1]        // s[sgprGSUSumIdx] = s[sgprWorkGroup1] / s[sgprNumWorkGroups1]
v_sub_nc_u32 v7, s[sgprWorkGroup1], v7             // s[sgprGSUSumIdx] = s[sgprWorkGroup1] / s[sgprNumWorkGroups1]
v_cmp_eq_u32 vcc_lo, v7, s[sgprNumWorkGroups1]     // s[sgprGSUSumIdx] = s[sgprWorkGroup1] / s[sgprNumWorkGroups1]
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, vcc_lo                          // s[sgprGSUSumIdx] = s[sgprWorkGroup1] / s[sgprNumWorkGroups1]
v_add_nc_u32 v6, 1, v6                             // s[sgprGSUSumIdx] = s[sgprWorkGroup1] / s[sgprNumWorkGroups1]
v_mov_b32 v7, 0                                    // s[sgprWorkGroup1] = s[sgprWorkGroup1] % s[sgprNumWorkGroups1]
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, -1                              // Reset exec
v_cmp_gt_u32 vcc_lo, v7, s[sgprNumWorkGroups1]     // overflow happened in remainder
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, vcc_lo                          // overflow happened in remainder
v_sub_nc_u32 v6, v6, 1                             // quotient - 1
v_mul_u32_u24 v7, v6, s[sgprNumWorkGroups1]        // re-calculate remainder
v_sub_nc_u32 v7, s[sgprWorkGroup1], v7             // re-calculate remainder
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, -1                              // Reset exec
v_readfirstlane_b32 s[sgprGSUSumIdx], v6           // quotient
v_readfirstlane_b32 s[sgprWorkGroup1], v7          // remainder
label_GSUWGMRR_End:
s_mov_b32 s[sgprGSULog2BpeC], 0
s_mov_b32 s[sgprGSULog2BpeD], 2
s_branch label_GSU_End
label_GSU:
s_mov_b64 s[sgprGSUSumIdx:sgprGSUSumIdx+1], 0      // Set GSUSumIdx to 0
s_mov_b32 s[sgprGSULog2BpeC], 0
s_mov_b32 s[sgprGSULog2BpeD], 0
label_GSU_End:
/* WGM Calculation */
s_mov_b32 s16, s[sgprWGM]                          // Restore WGM
s_sext_i32_i16 s16, s16                            // Restore WGM
s_cmp_gt_i32 s16, 1                                // WGM > 1 ?
s_cbranch_scc1 label_WGMPositive                   // branch if WGM > 1
s_cmp_ge_i32 s16, 0                                // WGM >= 0 ?
s_cbranch_scc1 label_WGM                           // branch if WGM >= 0
s_abs_i32 s16, s16                                 // abs(WGM)
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cvt_f64_u32 v[60:61], s16                        // s17 = s[sgprWorkGroup0] / s16
v_rcp_f64 v[60:61], v[60:61]                       // s17 = s[sgprWorkGroup0] / s16
v_cvt_f64_u32 v[62:63], s[sgprWorkGroup0]          // s17 = s[sgprWorkGroup0] / s16
v_mul_f64 v[60:61], v[60:61], v[62:63]             // s17 = s[sgprWorkGroup0] / s16
v_cvt_u32_f64 v60, v[60:61]                        // s17 = s[sgprWorkGroup0] / s16
v_mul_lo_u32 v61, v60, s16                         // s17 = s[sgprWorkGroup0] / s16
v_sub_nc_u32 v62, s[sgprWorkGroup0], v61           // s17 = s[sgprWorkGroup0] / s16
v_cmp_ge_u32 vcc_lo, v62, s16                      // s17 = s[sgprWorkGroup0] / s16
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, vcc_lo                          // s17 = s[sgprWorkGroup0] / s16
v_add_nc_u32 v60, v60, 1                           // s17 = s[sgprWorkGroup0] / s16
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, -1                              // Reset exec
v_readfirstlane_b32 s17, v60                       // quotient
s_mul_i32 s20, s17, s16                            // quotient * non-magic divisor
s_sub_u32 s20, s[sgprWorkGroup0], s20              // WorkGroup0=remainder
s_mul_i32 s20, s20, s[sgprNumWorkGroups1]          // (wg1 % WGM)*NumWorkGroups1
s_add_u32 s20, s20, s[sgprWorkGroup1]              // wgSerial = wg0 + (wg1 % WGM)*NumWorkGroups1
v_cvt_f64_u32 v[60:61], s16                        // s18 = s[sgprNumWorkGroups0] / s16
v_rcp_f64 v[60:61], v[60:61]                       // s18 = s[sgprNumWorkGroups0] / s16
v_cvt_f64_u32 v[62:63], s[sgprNumWorkGroups0]      // s18 = s[sgprNumWorkGroups0] / s16
v_mul_f64 v[60:61], v[60:61], v[62:63]             // s18 = s[sgprNumWorkGroups0] / s16
v_cvt_u32_f64 v60, v[60:61]                        // s18 = s[sgprNumWorkGroups0] / s16
v_mul_lo_u32 v61, v60, s16                         // s18 = s[sgprNumWorkGroups0] / s16
v_sub_nc_u32 v62, s[sgprNumWorkGroups0], v61       // s18 = s[sgprNumWorkGroups0] / s16
v_cmp_ge_u32 vcc_lo, v62, s16                      // s18 = s[sgprNumWorkGroups0] / s16
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, vcc_lo                          // s18 = s[sgprNumWorkGroups0] / s16
v_add_nc_u32 v60, v60, 1                           // s18 = s[sgprNumWorkGroups0] / s16
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, -1                              // Reset exec
v_readfirstlane_b32 s18, v60                       // quotient
s_mul_i32 s19, s16, s18                            // quotient * non-magic divisor
s_sub_u32 s19, s[sgprNumWorkGroups0], s19          // NumWorkGroups0=remainder
s_cmp_eq_u32 s19, 0                                // remainder == 0 ?
s_cmov_b32 s19, s16                                // remainder = WGM if remainder == 0
s_cmp_ge_u32 s17, s18                              // blockId >= numFullBlocks ?
s_cselect_b32 s18, s19, s16
v_cvt_f64_u32 v[60:61], s18                        // s[sgprWorkGroup1] = s20 / s18
v_rcp_f64 v[60:61], v[60:61]                       // s[sgprWorkGroup1] = s20 / s18
v_cvt_f64_u32 v[62:63], s20                        // s[sgprWorkGroup1] = s20 / s18
v_mul_f64 v[60:61], v[60:61], v[62:63]             // s[sgprWorkGroup1] = s20 / s18
v_cvt_u32_f64 v60, v[60:61]                        // s[sgprWorkGroup1] = s20 / s18
v_mul_lo_u32 v61, v60, s18                         // s[sgprWorkGroup1] = s20 / s18
v_sub_nc_u32 v62, s20, v61                         // s[sgprWorkGroup1] = s20 / s18
v_cmp_ge_u32 vcc_lo, v62, s18                      // s[sgprWorkGroup1] = s20 / s18
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, vcc_lo                          // s[sgprWorkGroup1] = s20 / s18
v_add_nc_u32 v60, v60, 1                           // s[sgprWorkGroup1] = s20 / s18
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, -1                              // Reset exec
v_mul_lo_u32 v61, v60, s18                         // s[sgprWorkGroup1] = s20 / s18
v_sub_nc_u32 v62, s20, v61                         // s[sgprWorkGroup1] = s20 / s18
v_readfirstlane_b32 s[sgprWorkGroup1], v60         // quotient
v_readfirstlane_b32 s[sgprWorkGroup0], v62         // remainder
s_mul_i32 s[sgprWorkGroup0], s[sgprWorkGroup1], s18 // quotient * non-magic divisor
s_sub_u32 s[sgprWorkGroup0], s20, s[sgprWorkGroup0] // WorkGroup0=remainder
s_mul_i32 s17, s17, s16                            // blockId * WGM
s_add_u32 s[sgprWorkGroup0], s[sgprWorkGroup0], s17 // wg1 += blockId * WGM
s_branch label_WGM
label_WGMPositive:
s_mov_b32 s16, s16                                 // WGM
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cvt_f64_u32 v[60:61], s16                        // s17 = s[sgprWorkGroup1] / s16
v_rcp_f64 v[60:61], v[60:61]                       // s17 = s[sgprWorkGroup1] / s16
v_cvt_f64_u32 v[62:63], s[sgprWorkGroup1]          // s17 = s[sgprWorkGroup1] / s16
v_mul_f64 v[60:61], v[60:61], v[62:63]             // s17 = s[sgprWorkGroup1] / s16
v_cvt_u32_f64 v60, v[60:61]                        // s17 = s[sgprWorkGroup1] / s16
v_mul_lo_u32 v61, v60, s16                         // s17 = s[sgprWorkGroup1] / s16
v_sub_nc_u32 v62, s[sgprWorkGroup1], v61           // s17 = s[sgprWorkGroup1] / s16
v_cmp_ge_u32 vcc_lo, v62, s16                      // s17 = s[sgprWorkGroup1] / s16
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, vcc_lo                          // s17 = s[sgprWorkGroup1] / s16
v_add_nc_u32 v60, v60, 1                           // s17 = s[sgprWorkGroup1] / s16
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, -1                              // Reset exec
v_readfirstlane_b32 s17, v60                       // quotient
s_mul_i32 s20, s17, s16                            // quotient * non-magic divisor
s_sub_u32 s20, s[sgprWorkGroup1], s20              // WorkGroup1=remainder
s_mul_i32 s20, s20, s[sgprNumWorkGroups0]          // (wg1 % WGM)*NumWorkGroups0
s_add_u32 s20, s20, s[sgprWorkGroup0]              // wgSerial = wg0 + (wg1 % WGM)*NumWorkGroups0
v_cvt_f64_u32 v[60:61], s16                        // s18 = s[sgprNumWorkGroups1] / s16
v_rcp_f64 v[60:61], v[60:61]                       // s18 = s[sgprNumWorkGroups1] / s16
v_cvt_f64_u32 v[62:63], s[sgprNumWorkGroups1]      // s18 = s[sgprNumWorkGroups1] / s16
v_mul_f64 v[60:61], v[60:61], v[62:63]             // s18 = s[sgprNumWorkGroups1] / s16
v_cvt_u32_f64 v60, v[60:61]                        // s18 = s[sgprNumWorkGroups1] / s16
v_mul_lo_u32 v61, v60, s16                         // s18 = s[sgprNumWorkGroups1] / s16
v_sub_nc_u32 v62, s[sgprNumWorkGroups1], v61       // s18 = s[sgprNumWorkGroups1] / s16
v_cmp_ge_u32 vcc_lo, v62, s16                      // s18 = s[sgprNumWorkGroups1] / s16
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, vcc_lo                          // s18 = s[sgprNumWorkGroups1] / s16
v_add_nc_u32 v60, v60, 1                           // s18 = s[sgprNumWorkGroups1] / s16
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, -1                              // Reset exec
v_readfirstlane_b32 s18, v60                       // quotient
s_mul_i32 s19, s16, s18                            // quotient * non-magic divisor
s_sub_u32 s19, s[sgprNumWorkGroups1], s19          // NumWorkGroups1=remainder
s_cmp_eq_u32 s19, 0                                // remainder == 0 ?
s_cmov_b32 s19, s16                                // remainder = WGM if remainder == 0
s_cmp_ge_u32 s17, s18                              // blockId >= numFullBlocks ?
s_cselect_b32 s18, s19, s16
v_cvt_f64_u32 v[60:61], s18                        // s[sgprWorkGroup0] = s20 / s18
v_rcp_f64 v[60:61], v[60:61]                       // s[sgprWorkGroup0] = s20 / s18
v_cvt_f64_u32 v[62:63], s20                        // s[sgprWorkGroup0] = s20 / s18
v_mul_f64 v[60:61], v[60:61], v[62:63]             // s[sgprWorkGroup0] = s20 / s18
v_cvt_u32_f64 v60, v[60:61]                        // s[sgprWorkGroup0] = s20 / s18
v_mul_lo_u32 v61, v60, s18                         // s[sgprWorkGroup0] = s20 / s18
v_sub_nc_u32 v62, s20, v61                         // s[sgprWorkGroup0] = s20 / s18
v_cmp_ge_u32 vcc_lo, v62, s18                      // s[sgprWorkGroup0] = s20 / s18
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, vcc_lo                          // s[sgprWorkGroup0] = s20 / s18
v_add_nc_u32 v60, v60, 1                           // s[sgprWorkGroup0] = s20 / s18
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, -1                              // Reset exec
v_mul_lo_u32 v61, v60, s18                         // s[sgprWorkGroup0] = s20 / s18
v_sub_nc_u32 v62, s20, v61                         // s[sgprWorkGroup0] = s20 / s18
v_readfirstlane_b32 s[sgprWorkGroup0], v60         // quotient
v_readfirstlane_b32 s[sgprWorkGroup1], v62         // remainder
s_mul_i32 s[sgprWorkGroup1], s[sgprWorkGroup0], s18 // quotient * non-magic divisor
s_sub_u32 s[sgprWorkGroup1], s20, s[sgprWorkGroup1] // WorkGroup1=remainder
s_mul_i32 s17, s17, s16                            // blockId * WGM
s_add_u32 s[sgprWorkGroup1], s[sgprWorkGroup1], s17 // wg1 += blockId * WGM
label_WGM:

/* global read addresses: tile offset assignment a */
/* graTileAssignmentA = v0 */

/* global read addresses: tile offset assignment b */
/* graTileAssignmentB = v2 */

/* global read addresses: unroll assignment a */
/* v1 */

/* global read addresses: unroll assignment b */
/* v3 */

/* global read addresses: other free assignments */
/* s[sgprWorkGroup2] */

/* global read addresses: tile offsets a */
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v6, v0                                   // groA0I_0

/* global read addresses: tile offsets b */
v_mov_b32 v7, v2                                   // groB1J_0

/* global read addresses: unroll offsets a */
v_mov_b32 v60, v1                                  // groAL_0
v_add_co_u32 v61, vcc_lo, 2, v60                   // groAL_1 + LSPA
v_add_co_u32 v62, vcc_lo, 2, v61                   // groAL_2 + LSPA
v_add_co_u32 v63, vcc_lo, 2, v62                   // groAL_3 + LSPA
v_add_co_u32 v64, vcc_lo, 2, v63                   // groAL_4 + LSPA
v_add_co_u32 v65, vcc_lo, 2, v64                   // groAL_5 + LSPA
v_add_co_u32 v66, vcc_lo, 2, v65                   // groAL_6 + LSPA
v_add_co_u32 v67, vcc_lo, 2, v66                   // groAL_7 + LSPA
v_add_co_u32 v68, vcc_lo, 2, v67                   // groAL_8 + LSPA
v_add_co_u32 v69, vcc_lo, 2, v68                   // groAL_9 + LSPA
v_add_co_u32 v70, vcc_lo, 2, v69                   // groAL_10 + LSPA
v_add_co_u32 v71, vcc_lo, 2, v70                   // groAL_11 + LSPA
v_add_co_u32 v72, vcc_lo, 2, v71                   // groAL_12 + LSPA
v_add_co_u32 v73, vcc_lo, 2, v72                   // groAL_13 + LSPA
v_add_co_u32 v74, vcc_lo, 2, v73                   // groAL_14 + LSPA
v_add_co_u32 v75, vcc_lo, 2, v74                   // groAL_15 + LSPA
v_add_co_u32 v76, vcc_lo, 2, v75                   // groAL_16 + LSPA
v_add_co_u32 v77, vcc_lo, 2, v76                   // groAL_17 + LSPA
v_add_co_u32 v78, vcc_lo, 2, v77                   // groAL_18 + LSPA
v_add_co_u32 v79, vcc_lo, 2, v78                   // groAL_19 + LSPA
v_add_co_u32 v80, vcc_lo, 2, v79                   // groAL_20 + LSPA
v_add_co_u32 v81, vcc_lo, 2, v80                   // groAL_21 + LSPA
v_add_co_u32 v82, vcc_lo, 2, v81                   // groAL_22 + LSPA
v_add_co_u32 v83, vcc_lo, 2, v82                   // groAL_23 + LSPA
v_add_co_u32 v84, vcc_lo, 2, v83                   // groAL_24 + LSPA
v_add_co_u32 v85, vcc_lo, 2, v84                   // groAL_25 + LSPA
v_add_co_u32 v86, vcc_lo, 2, v85                   // groAL_26 + LSPA
v_add_co_u32 v87, vcc_lo, 2, v86                   // groAL_27 + LSPA
v_add_co_u32 v88, vcc_lo, 2, v87                   // groAL_28 + LSPA
v_add_co_u32 v89, vcc_lo, 2, v88                   // groAL_29 + LSPA
v_add_co_u32 v90, vcc_lo, 2, v89                   // groAL_30 + LSPA
v_add_co_u32 v91, vcc_lo, 2, v90                   // groAL_31 + LSPA

/* global read addresses: unroll offsets b */
v_mov_b32 v92, v3                                  // groBL_0
v_add_co_u32 v93, vcc_lo, 4, v92                   // groBL_1 + LSPB
v_add_co_u32 v94, vcc_lo, 4, v93                   // groBL_2 + LSPB
v_add_co_u32 v95, vcc_lo, 4, v94                   // groBL_3 + LSPB
v_add_co_u32 v96, vcc_lo, 4, v95                   // groBL_4 + LSPB
v_add_co_u32 v97, vcc_lo, 4, v96                   // groBL_5 + LSPB
v_add_co_u32 v98, vcc_lo, 4, v97                   // groBL_6 + LSPB
v_add_co_u32 v99, vcc_lo, 4, v98                   // groBL_7 + LSPB
v_add_co_u32 v100, vcc_lo, 4, v99                  // groBL_8 + LSPB
v_add_co_u32 v101, vcc_lo, 4, v100                 // groBL_9 + LSPB
v_add_co_u32 v102, vcc_lo, 4, v101                 // groBL_10 + LSPB
v_add_co_u32 v103, vcc_lo, 4, v102                 // groBL_11 + LSPB
v_add_co_u32 v104, vcc_lo, 4, v103                 // groBL_12 + LSPB
v_add_co_u32 v105, vcc_lo, 4, v104                 // groBL_13 + LSPB
v_add_co_u32 v106, vcc_lo, 4, v105                 // groBL_14 + LSPB
v_add_co_u32 v107, vcc_lo, 4, v106                 // groBL_15 + LSPB

/* global read addresses: addresses a */
/* max read offset = size[n] * stride[n-1] */
s_mul_hi_u32 s19, s[sgprWorkGroup0], 32            // WorkGroup[01] * MT
s_mul_i32 s18, s[sgprWorkGroup0], 32               // WorkGroup[01] * MT
s_and_b32 s16, s[sgprGSU], 0x8000                  // SCC = (GSUC == 1) ?
s_cbranch_scc1 label_GSUC_A                        // branch if GSUC == 1
s_mul_hi_u32 s17, 64, s[sgprGSUSumIdx]             // gsuOffset = DepthU*GSUSumIdx
s_mul_i32 s16, 64, s[sgprGSUSumIdx]                // gsuOffset = DepthU*GSUSumIdx
s_branch label_GSUC_A_End
label_GSUC_A:
s_lshr_b32 s[sgprLoopCounterL], s[sgprSizesSum], 6 // s[LoopCounterL] = s[sgprSizesSum] / 64
s_and_b32 s[sgprGSUSumIdx+1], s[sgprGSU], 0x3fff   // Restore GSU
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cvt_f32_u32 v108, s[sgprGSUSumIdx+1]             // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
v_rcp_iflag_f32 v108, v108                         // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
v_cvt_f32_u32 v109, s[sgprLoopCounterL]            // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
v_mul_f32 v108, v108, v109                         // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
v_cvt_u32_f32 v108, v108                           // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
v_mul_u32_u24 v109, v108, s[sgprGSUSumIdx+1]       // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
v_sub_nc_u32 v109, s[sgprLoopCounterL], v109       // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
v_cmp_eq_u32 vcc_lo, v109, s[sgprGSUSumIdx+1]      // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, vcc_lo                          // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
v_add_nc_u32 v108, 1, v108                         // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
v_mov_b32 v109, 0                                  // s[sgprGSUSumIdx+1] = s[sgprLoopCounterL] % s[sgprGSUSumIdx+1]
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, -1                              // Reset exec
v_cmp_gt_u32 vcc_lo, v109, s[sgprGSUSumIdx+1]      // overflow happened in remainder
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, vcc_lo                          // overflow happened in remainder
v_sub_nc_u32 v108, v108, 1                         // quotient - 1
v_mul_u32_u24 v109, v108, s[sgprGSUSumIdx+1]       // re-calculate remainder
v_sub_nc_u32 v109, s[sgprLoopCounterL], v109       // re-calculate remainder
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, -1                              // Reset exec
v_readfirstlane_b32 s[sgprLoopCounterL], v108      // quotient
v_readfirstlane_b32 s[sgprGSUSumIdx+1], v109       // remainder
s_mul_i32 s17, s[sgprLoopCounterL], s[sgprGSUSumIdx] // quotient*GSUSumIdx
s_add_u32 s16, 1, s[sgprLoopCounterL]              // quotient+1
s_add_u32 s17, s17, s[sgprGSUSumIdx+1]             // quotient*GSUSumIdx+remainder
s_mul_i32 s16, s16, s[sgprGSUSumIdx]               // (quotient+1)*GSUSumIdx
s_cmp_lt_u32 s[sgprGSUSumIdx], s[sgprGSUSumIdx+1]  // gsuSumIdx < numIterPerWgRemainder
s_cselect_b32 s16, s16, s17                        // (quotient+1)*GSUSumIdx if needed
s_mul_hi_u32 s17, s16, 64                          // gsuOffset = DepthU*accumulatedNumOfLoopCounterL
s_mul_i32 s16, s16, 64                             // gsuOffset = DepthU*accumulatedNumOfLoopCounterL
label_GSUC_A_End:
s_mul_hi_u32 s17, s16, s[sgprStrideAL]             // tlu=1, scaled unroll-offset by stride
s_mul_i32 s16, s16, s[sgprStrideAL]                // tlu=1, scaled unroll-offset by stride
s_add_u32 s18, s18, s16                            // accum GsuOffset term to tilestart
s_addc_u32 s19, s19, s17                           // accum GsuOffset term to tilestart
s_mov_b64 s[sgprShadowLimitA+0:sgprShadowLimitA+0+1], 1 // Init tensor size
s_sub_u32 s16, s[sgprSizeI], 1                     // (size-1)
s_mul_hi_u32 s17, constStrideA0I, s16              // stride x (size-1)
s_mul_i32 s16, constStrideA0I, s16                 // stride x (size-1)
s_add_u32 s[sgprShadowLimitA+0], s[sgprShadowLimitA+0], s16 // sum tensor size
s_addc_u32 s[sgprShadowLimitA+1], s[sgprShadowLimitA+1], s17 // sum tensor size
s_sub_u32 s16, s[sgprSizeL], 1                     // (size-1)
s_mul_hi_u32 s17, s[sgprStrideAL], s16             // stride x (size-1)
s_mul_i32 s16, s[sgprStrideAL], s16                // stride x (size-1)
s_add_u32 s[sgprShadowLimitA+0], s[sgprShadowLimitA+0], s16 // sum tensor size
s_addc_u32 s[sgprShadowLimitA+1], s[sgprShadowLimitA+1], s17 // sum tensor size
s_sub_u32 s[sgprShadowLimitA+0], s[sgprShadowLimitA+0], s18 // sub tileStart
s_subb_u32 s[sgprShadowLimitA+1], s[sgprShadowLimitA+1], s19 // sub tileStart
                                                   // Set limit to use bytes (bpe is 1, do nothing)
s_add_u32 s[sgprShadowLimitA+0], s[sgprShadowLimitA+0], 1 // extend limit for pre-pad
s_addc_u32 s[sgprShadowLimitA+1], s[sgprShadowLimitA+1], 0 // extend limit for pre-pad
s_cmp_eq_u32 s[sgprShadowLimitA+1], 0              // are we within 2^32?
s_cselect_b32 s[sgprSrdA+2], s[sgprShadowLimitA+0], BufferLimit // Move shadow to real if we are within 2^32
s_cmp_eq_u32 s[sgprArgType], 3                     // ArgType == 3 for General Batched GEMM
s_cbranch_scc0 label_StridedBatchedGemmLoadA
s_mul_i32 s16, 8, s[sgprWorkGroup2]                // Compute Offset into Pointer Array
s_cmp_eq_u32 s[sgprSizesSum], 0x0                  // Don't dereference Pointer array if SizesSum == 0
s_cbranch_scc1 label_StridedBatchedGemmLoadA_End
s_add_u32 s16, s16, s[sgprAddressA+0]              // Offsetting to the location [Lower half of address]
s_addc_u32 s17, s[sgprAddressA+1], 0               // Offsetting to the location [Higher half of address]
s_load_b64 s[sgprSrdA:sgprSrdA+1], s[16:17], 0     // Load the Matrix Address in the Pointer Array
s_wait_kmcnt 0                                     // Wait for the Matrix Address Load from the Pointer Array
s_sub_u32 s[sgprSrdA+0], s[sgprSrdA+0], 1          // pre-pad to make room for possible pointer shift
s_subb_u32 s[sgprSrdA+1], s[sgprSrdA+1], 0         // pre-pad to make room for possible pointer shift
                                                   // tileStart (bpe is 1, do nothing)
s_add_u32 s[sgprSrdA+0], s18, s[sgprSrdA+0]        // SRD base = Address+ tileStart0
s_addc_u32 s[sgprSrdA+1], s19, s[sgprSrdA+1]       // SRD base = Address+ tileStart1
s_branch label_StridedBatchedGemmLoadA_End
label_StridedBatchedGemmLoadA:  /// Computing the Batch Matrix's base address for Strided Batched GEMM
s_mul_hi_u32 s17, s[sgprStrideAK], s[sgprWorkGroup2] // Stride*WG
s_mul_i32 s16, s[sgprStrideAK], s[sgprWorkGroup2]  // Stride*WG
s_add_u32 s18, s18, s16                            // accum wg term to tilestart
s_addc_u32 s19, s19, s17                           // accum wg term to tilestart
                                                   // tileStart (bpe is 1, do nothing)
s_add_u32 s[sgprSrdA+0], s[sgprAddressA+0], s18    // SRD base = Address+ tileStart0
s_addc_u32 s[sgprSrdA+1], s[sgprAddressA+1], s19   // SRD base = Address+ tileStart1
label_StridedBatchedGemmLoadA_End:  /// End Computing the Batch Matrix's base address for Strided Batched
s_mov_b32 s[sgprSrdA+3], Srd127_96                 // Set bits 127_96 in SRD
// Shift num records for gfx125x
s_and_b32 s16, s[sgprSrdA+2], 127
s_lshl_b32 s16, s16, 25
s_and_b32 s[sgprSrdA+1], s[sgprSrdA+1], 33554431
s_or_b32 s[sgprSrdA+1], s[sgprSrdA+1], s16
s_lshr_b32 s[sgprSrdA+2], s[sgprSrdA+2], 7

/* global read addresses: addresses b */
/* max read offset = size[n] * stride[n-1] */
s_mul_hi_u32 s19, s[sgprWorkGroup1], 16            // WorkGroup[01] * MT
s_mul_i32 s18, s[sgprWorkGroup1], 16               // WorkGroup[01] * MT
s_and_b32 s16, s[sgprGSU], 0x8000                  // SCC = (GSUC == 1) ?
s_cbranch_scc1 label_GSUC_B                        // branch if GSUC == 1
s_mul_hi_u32 s17, 64, s[sgprGSUSumIdx]             // gsuOffset = DepthU*GSUSumIdx
s_mul_i32 s16, 64, s[sgprGSUSumIdx]                // gsuOffset = DepthU*GSUSumIdx
s_branch label_GSUC_B_End
label_GSUC_B:
s_lshr_b32 s[sgprLoopCounterL], s[sgprSizesSum], 6 // s[LoopCounterL] = s[sgprSizesSum] / 64
s_and_b32 s[sgprGSUSumIdx+1], s[sgprGSU], 0x3fff   // Restore GSU
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cvt_f32_u32 v108, s[sgprGSUSumIdx+1]             // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
v_rcp_iflag_f32 v108, v108                         // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
v_cvt_f32_u32 v109, s[sgprLoopCounterL]            // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
v_mul_f32 v108, v108, v109                         // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
v_cvt_u32_f32 v108, v108                           // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
v_mul_u32_u24 v109, v108, s[sgprGSUSumIdx+1]       // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
v_sub_nc_u32 v109, s[sgprLoopCounterL], v109       // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
v_cmp_eq_u32 vcc_lo, v109, s[sgprGSUSumIdx+1]      // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, vcc_lo                          // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
v_add_nc_u32 v108, 1, v108                         // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
v_mov_b32 v109, 0                                  // s[sgprGSUSumIdx+1] = s[sgprLoopCounterL] % s[sgprGSUSumIdx+1]
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, -1                              // Reset exec
v_cmp_gt_u32 vcc_lo, v109, s[sgprGSUSumIdx+1]      // overflow happened in remainder
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, vcc_lo                          // overflow happened in remainder
v_sub_nc_u32 v108, v108, 1                         // quotient - 1
v_mul_u32_u24 v109, v108, s[sgprGSUSumIdx+1]       // re-calculate remainder
v_sub_nc_u32 v109, s[sgprLoopCounterL], v109       // re-calculate remainder
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, -1                              // Reset exec
v_readfirstlane_b32 s[sgprLoopCounterL], v108      // quotient
v_readfirstlane_b32 s[sgprGSUSumIdx+1], v109       // remainder
s_mul_i32 s17, s[sgprLoopCounterL], s[sgprGSUSumIdx] // quotient*GSUSumIdx
s_add_u32 s16, 1, s[sgprLoopCounterL]              // quotient+1
s_add_u32 s17, s17, s[sgprGSUSumIdx+1]             // quotient*GSUSumIdx+remainder
s_mul_i32 s16, s16, s[sgprGSUSumIdx]               // (quotient+1)*GSUSumIdx
s_cmp_lt_u32 s[sgprGSUSumIdx], s[sgprGSUSumIdx+1]  // gsuSumIdx < numIterPerWgRemainder
s_cselect_b32 s16, s16, s17                        // (quotient+1)*GSUSumIdx if needed
s_mul_hi_u32 s17, s16, 64                          // gsuOffset = DepthU*accumulatedNumOfLoopCounterL
s_mul_i32 s16, s16, 64                             // gsuOffset = DepthU*accumulatedNumOfLoopCounterL
label_GSUC_B_End:
s_mul_hi_u32 s17, s16, s[sgprStrideBL]             // tlu=1, scaled unroll-offset by stride
s_mul_i32 s16, s16, s[sgprStrideBL]                // tlu=1, scaled unroll-offset by stride
s_add_u32 s18, s18, s16                            // accum GsuOffset term to tilestart
s_addc_u32 s19, s19, s17                           // accum GsuOffset term to tilestart
s_mov_b64 s[sgprShadowLimitB+0:sgprShadowLimitB+0+1], 1 // Init tensor size
s_sub_u32 s16, s[sgprSizeJ], 1                     // (size-1)
s_mul_hi_u32 s17, constStrideB1J, s16              // stride x (size-1)
s_mul_i32 s16, constStrideB1J, s16                 // stride x (size-1)
s_add_u32 s[sgprShadowLimitB+0], s[sgprShadowLimitB+0], s16 // sum tensor size
s_addc_u32 s[sgprShadowLimitB+1], s[sgprShadowLimitB+1], s17 // sum tensor size
s_sub_u32 s16, s[sgprSizeL], 1                     // (size-1)
s_mul_hi_u32 s17, s[sgprStrideBL], s16             // stride x (size-1)
s_mul_i32 s16, s[sgprStrideBL], s16                // stride x (size-1)
s_add_u32 s[sgprShadowLimitB+0], s[sgprShadowLimitB+0], s16 // sum tensor size
s_addc_u32 s[sgprShadowLimitB+1], s[sgprShadowLimitB+1], s17 // sum tensor size
s_sub_u32 s[sgprShadowLimitB+0], s[sgprShadowLimitB+0], s18 // sub tileStart
s_subb_u32 s[sgprShadowLimitB+1], s[sgprShadowLimitB+1], s19 // sub tileStart
                                                   // Set limit to use bytes (bpe is 1, do nothing)
s_add_u32 s[sgprShadowLimitB+0], s[sgprShadowLimitB+0], 1 // extend limit for pre-pad
s_addc_u32 s[sgprShadowLimitB+1], s[sgprShadowLimitB+1], 0 // extend limit for pre-pad
s_cmp_eq_u32 s[sgprShadowLimitB+1], 0              // are we within 2^32?
s_cselect_b32 s[sgprSrdB+2], s[sgprShadowLimitB+0], BufferLimit // Move shadow to real if we are within 2^32
s_cmp_eq_u32 s[sgprArgType], 3                     // ArgType == 3 for General Batched GEMM
s_cbranch_scc0 label_StridedBatchedGemmLoadB
s_mul_i32 s16, 8, s[sgprWorkGroup2]                // Compute Offset into Pointer Array
s_cmp_eq_u32 s[sgprSizesSum], 0x0                  // Don't dereference Pointer array if SizesSum == 0
s_cbranch_scc1 label_StridedBatchedGemmLoadB_End
s_add_u32 s16, s16, s[sgprAddressB+0]              // Offsetting to the location [Lower half of address]
s_addc_u32 s17, s[sgprAddressB+1], 0               // Offsetting to the location [Higher half of address]
s_load_b64 s[sgprSrdB:sgprSrdB+1], s[16:17], 0     // Load the Matrix Address in the Pointer Array
s_wait_kmcnt 0                                     // Wait for the Matrix Address Load from the Pointer Array
s_sub_u32 s[sgprSrdB+0], s[sgprSrdB+0], 1          // pre-pad to make room for possible pointer shift
s_subb_u32 s[sgprSrdB+1], s[sgprSrdB+1], 0         // pre-pad to make room for possible pointer shift
                                                   // tileStart (bpe is 1, do nothing)
s_add_u32 s[sgprSrdB+0], s18, s[sgprSrdB+0]        // SRD base = Address+ tileStart0
s_addc_u32 s[sgprSrdB+1], s19, s[sgprSrdB+1]       // SRD base = Address+ tileStart1
s_branch label_StridedBatchedGemmLoadB_End
label_StridedBatchedGemmLoadB:  /// Computing the Batch Matrix's base address for Strided Batched GEMM
s_mul_hi_u32 s17, s[sgprStrideBK], s[sgprWorkGroup2] // Stride*WG
s_mul_i32 s16, s[sgprStrideBK], s[sgprWorkGroup2]  // Stride*WG
s_add_u32 s18, s18, s16                            // accum wg term to tilestart
s_addc_u32 s19, s19, s17                           // accum wg term to tilestart
                                                   // tileStart (bpe is 1, do nothing)
s_add_u32 s[sgprSrdB+0], s[sgprAddressB+0], s18    // SRD base = Address+ tileStart0
s_addc_u32 s[sgprSrdB+1], s[sgprAddressB+1], s19   // SRD base = Address+ tileStart1
label_StridedBatchedGemmLoadB_End:  /// End Computing the Batch Matrix's base address for Strided Batched
s_mov_b32 s[sgprSrdB+3], Srd127_96                 // Set bits 127_96 in SRD
// Shift num records for gfx125x
s_and_b32 s16, s[sgprSrdB+2], 127
s_lshl_b32 s16, s16, 25
s_and_b32 s[sgprSrdB+1], s[sgprSrdB+1], 33554431
s_or_b32 s[sgprSrdB+1], s[sgprSrdB+1], s16
s_lshr_b32 s[sgprSrdB+2], s[sgprSrdB+2], 7

/* global read addresses: final offsets a */
/* ============================================================= */

/* Global Offset A */
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mul_lo_u32 v108, s[sgprStrideAL], v60            // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetA+0], vcc_lo, v6, v108 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetA+0], 0x1, v[vgprGlobalReadOffsetA+0] // add prepad for pointer shift

/* Global Offset A (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset A */
v_mul_lo_u32 v108, s[sgprStrideAL], v61            // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetA+1], vcc_lo, v6, v108 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetA+1], 0x1, v[vgprGlobalReadOffsetA+1] // add prepad for pointer shift

/* Global Offset A (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset A */
v_mul_lo_u32 v108, s[sgprStrideAL], v62            // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetA+2], vcc_lo, v6, v108 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetA+2], 0x1, v[vgprGlobalReadOffsetA+2] // add prepad for pointer shift

/* Global Offset A (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset A */
v_mul_lo_u32 v108, s[sgprStrideAL], v63            // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetA+3], vcc_lo, v6, v108 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetA+3], 0x1, v[vgprGlobalReadOffsetA+3] // add prepad for pointer shift

/* Global Offset A (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset A */
v_mul_lo_u32 v108, s[sgprStrideAL], v64            // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetA+4], vcc_lo, v6, v108 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetA+4], 0x1, v[vgprGlobalReadOffsetA+4] // add prepad for pointer shift

/* Global Offset A (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset A */
v_mul_lo_u32 v108, s[sgprStrideAL], v65            // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetA+5], vcc_lo, v6, v108 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetA+5], 0x1, v[vgprGlobalReadOffsetA+5] // add prepad for pointer shift

/* Global Offset A (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset A */
v_mul_lo_u32 v108, s[sgprStrideAL], v66            // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetA+6], vcc_lo, v6, v108 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetA+6], 0x1, v[vgprGlobalReadOffsetA+6] // add prepad for pointer shift

/* Global Offset A (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset A */
v_mul_lo_u32 v108, s[sgprStrideAL], v67            // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetA+7], vcc_lo, v6, v108 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetA+7], 0x1, v[vgprGlobalReadOffsetA+7] // add prepad for pointer shift

/* Global Offset A (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset A */
v_mul_lo_u32 v108, s[sgprStrideAL], v68            // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetA+8], vcc_lo, v6, v108 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetA+8], 0x1, v[vgprGlobalReadOffsetA+8] // add prepad for pointer shift

/* Global Offset A (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset A */
v_mul_lo_u32 v108, s[sgprStrideAL], v69            // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetA+9], vcc_lo, v6, v108 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetA+9], 0x1, v[vgprGlobalReadOffsetA+9] // add prepad for pointer shift

/* Global Offset A (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset A */
v_mul_lo_u32 v108, s[sgprStrideAL], v70            // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetA+10], vcc_lo, v6, v108 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetA+10], 0x1, v[vgprGlobalReadOffsetA+10] // add prepad for pointer shift

/* Global Offset A (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset A */
v_mul_lo_u32 v108, s[sgprStrideAL], v71            // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetA+11], vcc_lo, v6, v108 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetA+11], 0x1, v[vgprGlobalReadOffsetA+11] // add prepad for pointer shift

/* Global Offset A (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset A */
v_mul_lo_u32 v108, s[sgprStrideAL], v72            // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetA+12], vcc_lo, v6, v108 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetA+12], 0x1, v[vgprGlobalReadOffsetA+12] // add prepad for pointer shift

/* Global Offset A (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset A */
v_mul_lo_u32 v108, s[sgprStrideAL], v73            // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetA+13], vcc_lo, v6, v108 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetA+13], 0x1, v[vgprGlobalReadOffsetA+13] // add prepad for pointer shift

/* Global Offset A (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset A */
v_mul_lo_u32 v108, s[sgprStrideAL], v74            // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetA+14], vcc_lo, v6, v108 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetA+14], 0x1, v[vgprGlobalReadOffsetA+14] // add prepad for pointer shift

/* Global Offset A (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset A */
v_mul_lo_u32 v108, s[sgprStrideAL], v75            // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetA+15], vcc_lo, v6, v108 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetA+15], 0x1, v[vgprGlobalReadOffsetA+15] // add prepad for pointer shift

/* Global Offset A (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset A */
v_mul_lo_u32 v108, s[sgprStrideAL], v76            // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetA+16], vcc_lo, v6, v108 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetA+16], 0x1, v[vgprGlobalReadOffsetA+16] // add prepad for pointer shift

/* Global Offset A (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset A */
v_mul_lo_u32 v108, s[sgprStrideAL], v77            // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetA+17], vcc_lo, v6, v108 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetA+17], 0x1, v[vgprGlobalReadOffsetA+17] // add prepad for pointer shift

/* Global Offset A (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset A */
v_mul_lo_u32 v108, s[sgprStrideAL], v78            // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetA+18], vcc_lo, v6, v108 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetA+18], 0x1, v[vgprGlobalReadOffsetA+18] // add prepad for pointer shift

/* Global Offset A (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset A */
v_mul_lo_u32 v108, s[sgprStrideAL], v79            // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetA+19], vcc_lo, v6, v108 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetA+19], 0x1, v[vgprGlobalReadOffsetA+19] // add prepad for pointer shift

/* Global Offset A (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset A */
v_mul_lo_u32 v108, s[sgprStrideAL], v80            // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetA+20], vcc_lo, v6, v108 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetA+20], 0x1, v[vgprGlobalReadOffsetA+20] // add prepad for pointer shift

/* Global Offset A (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset A */
v_mul_lo_u32 v108, s[sgprStrideAL], v81            // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetA+21], vcc_lo, v6, v108 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetA+21], 0x1, v[vgprGlobalReadOffsetA+21] // add prepad for pointer shift

/* Global Offset A (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset A */
v_mul_lo_u32 v108, s[sgprStrideAL], v82            // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetA+22], vcc_lo, v6, v108 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetA+22], 0x1, v[vgprGlobalReadOffsetA+22] // add prepad for pointer shift

/* Global Offset A (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset A */
v_mul_lo_u32 v108, s[sgprStrideAL], v83            // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetA+23], vcc_lo, v6, v108 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetA+23], 0x1, v[vgprGlobalReadOffsetA+23] // add prepad for pointer shift

/* Global Offset A (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset A */
v_mul_lo_u32 v108, s[sgprStrideAL], v84            // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetA+24], vcc_lo, v6, v108 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetA+24], 0x1, v[vgprGlobalReadOffsetA+24] // add prepad for pointer shift

/* Global Offset A (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset A */
v_mul_lo_u32 v108, s[sgprStrideAL], v85            // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetA+25], vcc_lo, v6, v108 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetA+25], 0x1, v[vgprGlobalReadOffsetA+25] // add prepad for pointer shift

/* Global Offset A (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset A */
v_mul_lo_u32 v108, s[sgprStrideAL], v86            // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetA+26], vcc_lo, v6, v108 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetA+26], 0x1, v[vgprGlobalReadOffsetA+26] // add prepad for pointer shift

/* Global Offset A (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset A */
v_mul_lo_u32 v108, s[sgprStrideAL], v87            // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetA+27], vcc_lo, v6, v108 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetA+27], 0x1, v[vgprGlobalReadOffsetA+27] // add prepad for pointer shift

/* Global Offset A (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset A */
v_mul_lo_u32 v108, s[sgprStrideAL], v88            // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetA+28], vcc_lo, v6, v108 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetA+28], 0x1, v[vgprGlobalReadOffsetA+28] // add prepad for pointer shift

/* Global Offset A (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset A */
v_mul_lo_u32 v108, s[sgprStrideAL], v89            // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetA+29], vcc_lo, v6, v108 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetA+29], 0x1, v[vgprGlobalReadOffsetA+29] // add prepad for pointer shift

/* Global Offset A (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset A */
v_mul_lo_u32 v108, s[sgprStrideAL], v90            // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetA+30], vcc_lo, v6, v108 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetA+30], 0x1, v[vgprGlobalReadOffsetA+30] // add prepad for pointer shift

/* Global Offset A (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset A */
v_mul_lo_u32 v108, s[sgprStrideAL], v91            // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetA+31], vcc_lo, v6, v108 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetA+31], 0x1, v[vgprGlobalReadOffsetA+31] // add prepad for pointer shift

/* Global Offset A (end) */
                                                   //  (bpe is 1, do nothing)
/* ============================================================= */

/* global read addresses: final offsets b */
/* ============================================================= */

/* Global Offset B */
v_mul_lo_u32 v60, s[sgprStrideBL], v92             // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetB+0], vcc_lo, v7, v60 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+0], 0x1, v[vgprGlobalReadOffsetB+0] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset B */
v_mul_lo_u32 v60, s[sgprStrideBL], v93             // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetB+1], vcc_lo, v7, v60 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+1], 0x1, v[vgprGlobalReadOffsetB+1] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset B */
v_mul_lo_u32 v60, s[sgprStrideBL], v94             // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetB+2], vcc_lo, v7, v60 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+2], 0x1, v[vgprGlobalReadOffsetB+2] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset B */
v_mul_lo_u32 v60, s[sgprStrideBL], v95             // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetB+3], vcc_lo, v7, v60 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+3], 0x1, v[vgprGlobalReadOffsetB+3] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset B */
v_mul_lo_u32 v60, s[sgprStrideBL], v96             // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetB+4], vcc_lo, v7, v60 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+4], 0x1, v[vgprGlobalReadOffsetB+4] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset B */
v_mul_lo_u32 v60, s[sgprStrideBL], v97             // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetB+5], vcc_lo, v7, v60 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+5], 0x1, v[vgprGlobalReadOffsetB+5] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset B */
v_mul_lo_u32 v60, s[sgprStrideBL], v98             // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetB+6], vcc_lo, v7, v60 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+6], 0x1, v[vgprGlobalReadOffsetB+6] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset B */
v_mul_lo_u32 v60, s[sgprStrideBL], v99             // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetB+7], vcc_lo, v7, v60 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+7], 0x1, v[vgprGlobalReadOffsetB+7] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset B */
v_mul_lo_u32 v60, s[sgprStrideBL], v100            // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetB+8], vcc_lo, v7, v60 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+8], 0x1, v[vgprGlobalReadOffsetB+8] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset B */
v_mul_lo_u32 v60, s[sgprStrideBL], v101            // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetB+9], vcc_lo, v7, v60 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+9], 0x1, v[vgprGlobalReadOffsetB+9] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset B */
v_mul_lo_u32 v60, s[sgprStrideBL], v102            // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetB+10], vcc_lo, v7, v60 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+10], 0x1, v[vgprGlobalReadOffsetB+10] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset B */
v_mul_lo_u32 v60, s[sgprStrideBL], v103            // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetB+11], vcc_lo, v7, v60 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+11], 0x1, v[vgprGlobalReadOffsetB+11] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset B */
v_mul_lo_u32 v60, s[sgprStrideBL], v104            // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetB+12], vcc_lo, v7, v60 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+12], 0x1, v[vgprGlobalReadOffsetB+12] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset B */
v_mul_lo_u32 v60, s[sgprStrideBL], v105            // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetB+13], vcc_lo, v7, v60 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+13], 0x1, v[vgprGlobalReadOffsetB+13] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset B */
v_mul_lo_u32 v60, s[sgprStrideBL], v106            // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetB+14], vcc_lo, v7, v60 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+14], 0x1, v[vgprGlobalReadOffsetB+14] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset B */
v_mul_lo_u32 v60, s[sgprStrideBL], v107            // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetB+15], vcc_lo, v7, v60 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+15], 0x1, v[vgprGlobalReadOffsetB+15] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)
/* ============================================================= */

/* global read addresses: increments a */
s_and_b32 s17, s[sgprGSU], 0x3fff                  // Restore GSU
s_mov_b32 s[sgprGlobalReadIncsA+0], 64             // GSU*DepthU*Bpe*MI_dim(1)
s_mul_i32 s17, s17, s[sgprGlobalReadIncsA+0]       // GSU*DepthU*Bpe*MI_dim(1)
s_and_b32 s16, s[sgprGSU], 0x8000                  // SCC = (GSUC == 1) ?
s_cmov_b32 s17, 64                                 // DepthU*Bpe if GSUC = 1
s_mul_i32 s[sgprGlobalReadIncsA+0], s17, s[sgprStrideAL] // incrA unrollIdx)

/* global read addresses: increments b */
s_and_b32 s17, s[sgprGSU], 0x3fff                  // Restore GSU
s_mov_b32 s[sgprGlobalReadIncsB+0], 64             // GSU*DepthU*Bpe*MI_dim(1)
s_mul_i32 s17, s17, s[sgprGlobalReadIncsB+0]       // GSU*DepthU*Bpe*MI_dim(1)
s_and_b32 s16, s[sgprGSU], 0x8000                  // SCC = (GSUC == 1) ?
s_cmov_b32 s17, 64                                 // DepthU*Bpe if GSUC = 1
s_mul_i32 s[sgprGlobalReadIncsB+0], s17, s[sgprStrideBL] // incrB unrollIdx)
/* declare loop num iterations */
s_lshr_b32 s[sgprLoopCounterL], s[sgprSizesSum+0], 6 // s[sgprLoopCounterL] = s[sgprSizesSum+0] / 64
s_and_b32 s16, s[sgprGSU], 0x3fff                  // Restore GSU
s_cmp_eq_u32 s16, 1                                // GSU == 1 ?
s_cbranch_scc1 label_GSU_1                         // branch if GSU == 1
s_and_b32 s[sgprGSUSumIdx+1], s[sgprGSU], 0x3fff   // Restore GSU
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cvt_f32_u32 v0, s[sgprGSUSumIdx+1]               // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
v_rcp_iflag_f32 v0, v0                             // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
v_cvt_f32_u32 v1, s[sgprLoopCounterL]              // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
v_mul_f32 v0, v0, v1                               // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
v_cvt_u32_f32 v0, v0                               // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
v_mul_u32_u24 v1, v0, s[sgprGSUSumIdx+1]           // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
v_sub_nc_u32 v1, s[sgprLoopCounterL], v1           // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
v_cmp_eq_u32 vcc_lo, v1, s[sgprGSUSumIdx+1]        // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, vcc_lo                          // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
v_add_nc_u32 v0, 1, v0                             // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
v_mov_b32 v1, 0                                    // s[sgprGSUSumIdx+1] = s[sgprLoopCounterL] % s[sgprGSUSumIdx+1]
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, -1                              // Reset exec
v_cmp_gt_u32 vcc_lo, v1, s[sgprGSUSumIdx+1]        // overflow happened in remainder
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, vcc_lo                          // overflow happened in remainder
v_sub_nc_u32 v0, v0, 1                             // quotient - 1
v_mul_u32_u24 v1, v0, s[sgprGSUSumIdx+1]           // re-calculate remainder
v_sub_nc_u32 v1, s[sgprLoopCounterL], v1           // re-calculate remainder
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, -1                              // Reset exec
v_readfirstlane_b32 s[sgprLoopCounterL], v0        // quotient
v_readfirstlane_b32 s[sgprGSUSumIdx+1], v1         // remainder
s_add_u32 s16, 1, s[sgprLoopCounterL]              // tmp<-numIterMyWg+1
s_cmp_lt_u32 s[sgprGSUSumIdx], s[sgprGSUSumIdx+1]  // gsuSumIdx < numIterPerWgRemainder
s_cmov_b32 s[sgprLoopCounterL], s16                // numIterMyWg++ if needed
label_GSU_1:
s_mov_b32 s[sgprOrigLoopCounter], s[sgprLoopCounterL] // copy loop counter
s_and_b32 s18, s[sgprStaggerU], 0x1f00
s_lshr_b32 s18, s18, 0x8
s_and_b32 s19, s[sgprStaggerU], 0xe000
s_and_b32 s[sgprStaggerU], s[sgprStaggerU], 0xff
s_mov_b32 s16, s[sgprStaggerU]                     // init staggerU
label_beginStaggerUIter:
s_lshl_b32 s17, s16, s18                           // shift by StaggerUStride
s_cmp_ge_u32 s[sgprOrigLoopCounter], s17           // loopCount >= current shift Count
s_cbranch_scc1 label_endStaggerUIter               // jump to end
s_lshr_b32 s16, s16, 1                             // step down to smaller stagger
s_branch label_beginStaggerUIter                   // jump to begin
label_endStaggerUIter:
s_sub_u32 s17, s16, 1                              // staggerU mask
s_cmp_ge_u32 s16, 1                                // if current staggerU >= 1
s_cselect_b32 s[sgprStaggerUIter], s17, 0          // set Mask
s_cmp_eq_u32 s19, 0x0
s_cbranch_scc0 label_StaggerUMapping
s_mov_b32 s16, s[sgprWorkGroup0]
s_branch label_staggerInputEnd
label_StaggerUMapping:
s_cmp_eq_u32 s19, 0x2000
s_cbranch_scc0 label_StaggerUMapping_1
s_mov_b32 s16, s[sgprWorkGroup1]
s_branch label_staggerInputEnd
label_StaggerUMapping_1:
s_cmp_eq_u32 s19, 0x4000
s_cbranch_scc0 label_StaggerUMapping_2
s_mov_b32 s16, -0x1
s_branch label_staggerInputEnd
label_StaggerUMapping_2:
s_cmp_eq_u32 s19, 0x6000
s_cbranch_scc0 label_StaggerUMapping_3
s_mul_i32 s17, s[sgprNumWorkGroups0], s[sgprWorkGroup1]
s_add_u32 s16, s16, s17
s_add_u32 s16, s16, s[sgprWorkGroup0]
s_branch label_staggerInputEnd
label_StaggerUMapping_3:
s_cmp_eq_u32 s19, 0x8000
s_cbranch_scc0 label_staggerInputEnd
s_mov_b32 s16, -0x1
s_branch label_staggerInputEnd
label_staggerInputEnd:
s_and_b32 s[sgprStaggerUIter], s[sgprStaggerUIter], s16 // Compute actual stagger start for this tile
s_lshl_b32 s[sgprStaggerUIter], s[sgprStaggerUIter], s18 // shift by StaggerUStride

/* addr += (StaggerUIter) * GlobalReadIncsA+0 */
s_mul_hi_i32 s17, s[sgprStaggerUIter], s[sgprGlobalReadIncsA+0] //  stagger byte offset
s_mul_i32 s16, s[sgprStaggerUIter], s[sgprGlobalReadIncsA+0] //  stagger byte offset
s_mul_hi_i32 s[sgprWrapUA+1], s[sgprLoopCounterL], s[sgprGlobalReadIncsA+0] // Number of bytes accessed by the unroll loop
s_mul_i32 s[sgprWrapUA+0], s[sgprLoopCounterL], s[sgprGlobalReadIncsA+0] // Number of bytes accessed by the unroll loop
s_mov_b32 s20, s[sgprGlobalReadIncsA+0]
s_mov_b32 s21, 0
s_sub_u64 s[sgprWrapUA:sgprWrapUA+1], s[20:21], s[sgprWrapUA:sgprWrapUA+1] // increment-WrapU
s_add_u32 s[sgprSrdA+0], s[sgprSrdA+0], s16        // gra SRD += inc(lower)
s_addc_u32 s[sgprSrdA+1], s[sgprSrdA+1], s17       // gra SRD += inc(upper)
s_sub_u32 s[sgprShadowLimitA+0], s[sgprShadowLimitA+0], s16 // limit -= inc)
s_subb_u32 s[sgprShadowLimitA+1], s[sgprShadowLimitA+1], s17 // limit -= inc)
s_cmp_eq_u32 s[sgprShadowLimitA+1], 0              // are we within 2^32?
s_cselect_b32 s[sgprSrdA+2], s[sgprShadowLimitA+0], BufferLimit // Move shadow to real if we are within 2^32
// Shift num records for gfx125x
s_and_b32 s19, s[sgprSrdA+2], 127
s_lshl_b32 s19, s19, 25
s_and_b32 s[sgprSrdA+1], s[sgprSrdA+1], 33554431
s_or_b32 s[sgprSrdA+1], s[sgprSrdA+1], s19
s_lshr_b32 s[sgprSrdA+2], s[sgprSrdA+2], 7

/* addr += (StaggerUIter) * GlobalReadIncsB+0 */
s_mul_hi_i32 s17, s[sgprStaggerUIter], s[sgprGlobalReadIncsB+0] //  stagger byte offset
s_mul_i32 s16, s[sgprStaggerUIter], s[sgprGlobalReadIncsB+0] //  stagger byte offset
s_mul_hi_i32 s[sgprWrapUB+1], s[sgprLoopCounterL], s[sgprGlobalReadIncsB+0] // Number of bytes accessed by the unroll loop
s_mul_i32 s[sgprWrapUB+0], s[sgprLoopCounterL], s[sgprGlobalReadIncsB+0] // Number of bytes accessed by the unroll loop
s_mov_b32 s20, s[sgprGlobalReadIncsB+0]
s_sub_u64 s[sgprWrapUB:sgprWrapUB+1], s[20:21], s[sgprWrapUB:sgprWrapUB+1] // increment-WrapU
s_add_u32 s[sgprSrdB+0], s[sgprSrdB+0], s16        // gra SRD += inc(lower)
s_addc_u32 s[sgprSrdB+1], s[sgprSrdB+1], s17       // gra SRD += inc(upper)
s_sub_u32 s[sgprShadowLimitB+0], s[sgprShadowLimitB+0], s16 // limit -= inc)
s_subb_u32 s[sgprShadowLimitB+1], s[sgprShadowLimitB+1], s17 // limit -= inc)
s_cmp_eq_u32 s[sgprShadowLimitB+1], 0              // are we within 2^32?
s_cselect_b32 s[sgprSrdB+2], s[sgprShadowLimitB+0], BufferLimit // Move shadow to real if we are within 2^32
// Shift num records for gfx125x
s_and_b32 s19, s[sgprSrdB+2], 127
s_lshl_b32 s19, s19, 25
s_and_b32 s[sgprSrdB+1], s[sgprSrdB+1], 33554431
s_or_b32 s[sgprSrdB+1], s[sgprSrdB+1], s19
s_lshr_b32 s[sgprSrdB+2], s[sgprSrdB+2], 7
s_add_u32 s[sgprStaggerUIter], s[sgprStaggerUIter], 2 // Subtract (PGR-1); StaggerUIter now contains target iteration to wrap
/* local read addresses: init pointers a */

/* localReadInitPointers */
/* local read addresses: init pointers b */

/* localReadInitPointers */

/* prefetch: global -> local */
s_cmp_eq_u32 s[sgprLoopCounterL], 0                // at last iteration?
s_cbranch_scc1 label_ShadowInitStart               // skip to ShadowInitStart iter b/c numIter==0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
s_wait_alu depctr_va_vdst(14)
buffer_load_d16_u8 v[vgprG2LA+0], v[vgprGlobalReadOffsetA+0], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_0_0
buffer_load_d16_u8 v[vgprG2LA+16], v[vgprGlobalReadOffsetA+1], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_1_0
buffer_load_d16_u8 v[vgprG2LA+32], v[vgprGlobalReadOffsetA+2], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_2_0
buffer_load_d16_u8 v[vgprG2LA+48], v[vgprGlobalReadOffsetA+3], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_3_0
buffer_load_d16_u8 v[vgprG2LA+1], v[vgprGlobalReadOffsetA+4], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_4_0
buffer_load_d16_u8 v[vgprG2LA+17], v[vgprGlobalReadOffsetA+5], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_5_0
buffer_load_d16_u8 v[vgprG2LA+33], v[vgprGlobalReadOffsetA+6], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_6_0
buffer_load_d16_u8 v[vgprG2LA+49], v[vgprGlobalReadOffsetA+7], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_7_0
buffer_load_d16_u8 v[vgprG2LA+2], v[vgprGlobalReadOffsetA+8], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_8_0
buffer_load_d16_u8 v[vgprG2LA+18], v[vgprGlobalReadOffsetA+9], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_9_0
buffer_load_d16_u8 v[vgprG2LA+34], v[vgprGlobalReadOffsetA+10], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_10_0
buffer_load_d16_u8 v[vgprG2LA+50], v[vgprGlobalReadOffsetA+11], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_11_0
buffer_load_d16_u8 v[vgprG2LA+3], v[vgprGlobalReadOffsetA+12], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_12_0
buffer_load_d16_u8 v[vgprG2LA+19], v[vgprGlobalReadOffsetA+13], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_13_0
buffer_load_d16_u8 v[vgprG2LA+35], v[vgprGlobalReadOffsetA+14], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_14_0
buffer_load_d16_u8 v[vgprG2LA+51], v[vgprGlobalReadOffsetA+15], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_15_0
buffer_load_d16_u8 v[vgprG2LA+4], v[vgprGlobalReadOffsetA+16], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_16_0
buffer_load_d16_u8 v[vgprG2LA+20], v[vgprGlobalReadOffsetA+17], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_17_0
buffer_load_d16_u8 v[vgprG2LA+36], v[vgprGlobalReadOffsetA+18], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_18_0
buffer_load_d16_u8 v[vgprG2LA+52], v[vgprGlobalReadOffsetA+19], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_19_0
buffer_load_d16_u8 v[vgprG2LA+5], v[vgprGlobalReadOffsetA+20], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_20_0
buffer_load_d16_u8 v[vgprG2LA+21], v[vgprGlobalReadOffsetA+21], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_21_0
buffer_load_d16_u8 v[vgprG2LA+37], v[vgprGlobalReadOffsetA+22], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_22_0
buffer_load_d16_u8 v[vgprG2LA+53], v[vgprGlobalReadOffsetA+23], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_23_0
buffer_load_d16_u8 v[vgprG2LA+6], v[vgprGlobalReadOffsetA+24], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_24_0
buffer_load_d16_u8 v[vgprG2LA+22], v[vgprGlobalReadOffsetA+25], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_25_0
buffer_load_d16_u8 v[vgprG2LA+38], v[vgprGlobalReadOffsetA+26], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_26_0
buffer_load_d16_u8 v[vgprG2LA+54], v[vgprGlobalReadOffsetA+27], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_27_0
buffer_load_d16_u8 v[vgprG2LA+7], v[vgprGlobalReadOffsetA+28], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_28_0
buffer_load_d16_u8 v[vgprG2LA+23], v[vgprGlobalReadOffsetA+29], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_29_0
buffer_load_d16_u8 v[vgprG2LA+39], v[vgprGlobalReadOffsetA+30], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_30_0
buffer_load_d16_u8 v[vgprG2LA+55], v[vgprGlobalReadOffsetA+31], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_31_0
buffer_load_d16_u8 v[vgprG2LB+0], v[vgprGlobalReadOffsetB+0], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_0_0
buffer_load_d16_u8 v[vgprG2LB+8], v[vgprGlobalReadOffsetB+1], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_1_0
buffer_load_d16_u8 v[vgprG2LB+16], v[vgprGlobalReadOffsetB+2], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_2_0
buffer_load_d16_u8 v[vgprG2LB+24], v[vgprGlobalReadOffsetB+3], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_3_0
buffer_load_d16_u8 v[vgprG2LB+1], v[vgprGlobalReadOffsetB+4], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_4_0
buffer_load_d16_u8 v[vgprG2LB+9], v[vgprGlobalReadOffsetB+5], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_5_0
buffer_load_d16_u8 v[vgprG2LB+17], v[vgprGlobalReadOffsetB+6], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_6_0
buffer_load_d16_u8 v[vgprG2LB+25], v[vgprGlobalReadOffsetB+7], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_7_0
buffer_load_d16_u8 v[vgprG2LB+2], v[vgprGlobalReadOffsetB+8], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_8_0
buffer_load_d16_u8 v[vgprG2LB+10], v[vgprGlobalReadOffsetB+9], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_9_0
buffer_load_d16_u8 v[vgprG2LB+18], v[vgprGlobalReadOffsetB+10], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_10_0
s_wait_alu depctr_va_vdst(12)
buffer_load_d16_u8 v[vgprG2LB+26], v[vgprGlobalReadOffsetB+11], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_11_0
s_wait_alu depctr_va_vdst(9)
buffer_load_d16_u8 v[vgprG2LB+3], v[vgprGlobalReadOffsetB+12], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_12_0
s_wait_alu depctr_va_vdst(6)
buffer_load_d16_u8 v[vgprG2LB+11], v[vgprGlobalReadOffsetB+13], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_13_0
s_wait_alu depctr_va_vdst(3)
buffer_load_d16_u8 v[vgprG2LB+19], v[vgprGlobalReadOffsetB+14], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_14_0
s_wait_alu depctr_va_vdst(0)
buffer_load_d16_u8 v[vgprG2LB+27], v[vgprGlobalReadOffsetB+15], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_15_0

/* global read inc A loopL */
s_add_u32 s18, s[sgprLoopCounterL], 1              // remove pf(1)
s_cmp_eq_u32 s[sgprStaggerUIter], s18              // Is this wrapIter? (pf)
s_cselect_b32 s16, s[sgprWrapUA+0], s[sgprGlobalReadIncsA+0] // incLower <- ?
s_cselect_b32 s17, s[sgprWrapUA+1], 0              // incUpper <- ?
s_add_u32 s[sgprSrdA+0], s[sgprSrdA+0], s16        // gra SRD += inc(lower)
s_addc_u32 s[sgprSrdA+1], s[sgprSrdA+1], s17       // gra SRD += inc(upper)
s_sub_u32 s[sgprShadowLimitA+0], s[sgprShadowLimitA+0], s16 // limit -= inc)
s_subb_u32 s[sgprShadowLimitA+1], s[sgprShadowLimitA+1], s17 // limit -= inc)
s_cmp_eq_u32 s[sgprShadowLimitA+1], 0              // are we within 2^32?
s_cselect_b32 s[sgprSrdA+2], s[sgprShadowLimitA+0], BufferLimit // Move shadow to real if we are within 2^32
// Shift num records for gfx125x
s_and_b32 s20, s[sgprSrdA+2], 127
s_lshl_b32 s20, s20, 25
s_and_b32 s[sgprSrdA+1], s[sgprSrdA+1], 33554431
s_or_b32 s[sgprSrdA+1], s[sgprSrdA+1], s20
s_lshr_b32 s[sgprSrdA+2], s[sgprSrdA+2], 7

/* global read inc B loopL */
s_add_u32 s18, s[sgprLoopCounterL], 1              // remove pf(1)
s_cmp_eq_u32 s[sgprStaggerUIter], s18              // Is this wrapIter? (pf)
s_cselect_b32 s16, s[sgprWrapUB+0], s[sgprGlobalReadIncsB+0] // incLower <- ?
s_cselect_b32 s17, s[sgprWrapUB+1], 0              // incUpper <- ?
s_add_u32 s[sgprSrdB+0], s[sgprSrdB+0], s16        // gra SRD += inc(lower)
s_addc_u32 s[sgprSrdB+1], s[sgprSrdB+1], s17       // gra SRD += inc(upper)
s_sub_u32 s[sgprShadowLimitB+0], s[sgprShadowLimitB+0], s16 // limit -= inc)
s_subb_u32 s[sgprShadowLimitB+1], s[sgprShadowLimitB+1], s17 // limit -= inc)
s_cmp_eq_u32 s[sgprShadowLimitB+1], 0              // are we within 2^32?
s_cselect_b32 s[sgprSrdB+2], s[sgprShadowLimitB+0], BufferLimit // Move shadow to real if we are within 2^32
// Shift num records for gfx125x
s_and_b32 s20, s[sgprSrdB+2], 127
s_lshl_b32 s20, s20, 25
s_and_b32 s[sgprSrdB+1], s[sgprSrdB+1], 33554431
s_or_b32 s[sgprSrdB+1], s[sgprSrdB+1], s20
s_lshr_b32 s[sgprSrdB+2], s[sgprSrdB+2], 7

/******************************************/
/* End setupNewTile                       */
/******************************************/
label_ShadowInitStart:
s_and_b32 s66, s[sgprGSU], 0x3fff                  // Restore GSU
s_cmp_eq_u32 s66, 1                                // GSU == 1 ?
s_cbranch_scc1 label_ArgTypeCheckD                 // Handling General Batched GEMM SRD initialization
s_mov_b64 s[sgprSrdD+0:sgprSrdD+0+1], s[sgprAddressD+0:sgprAddressD+0+1] // init SRD base address
s_branch label_GeneralBatchedGemmSrdInitiationD_End // End of handling General Batched GEMM SRD initialization
label_ArgTypeCheckD:  /// Check if ArgType is for General Batched GEMM for D
s_cmp_eq_u32 s[sgprArgType], 3                     // ArgType == 3 for General Batched GEMM
s_cbranch_scc0 label_RegularSrdInitializationD
s_branch label_GeneralBatchedGemmSrdInitiationD    // General Batched GEMM, Srd initialized to 0
label_RegularSrdInitializationD:  /// Regular SRD initialization for non-General Batched GEMM for D
s_mov_b64 s[sgprSrdD+0:sgprSrdD+0+1], s[sgprAddressD+0:sgprAddressD+0+1] // init SRD base address
s_branch label_GeneralBatchedGemmSrdInitiationD_End
label_GeneralBatchedGemmSrdInitiationD:  /// Handling General Batched GEMM SRD initialization
s_mov_b64 s[sgprSrdD+0:sgprSrdD+0+1], 0            // init SRD to 0
label_GeneralBatchedGemmSrdInitiationD_End:  /// End of handling General Batched GEMM SRD initialization
s_mov_b32 s[sgprSrdD+2], BufferOOB
s_mov_b32 s[sgprSrdD+3], Srd127_96                 // Set bits 127_96 in post-loop SRD
// Shift num records for gfx125x
s_and_b32 s66, s[sgprSrdD+2], 127
s_lshl_b32 s66, s66, 25
s_and_b32 s[sgprSrdD+1], s[sgprSrdD+1], 33554431
s_or_b32 s[sgprSrdD+1], s[sgprSrdD+1], s66
s_lshr_b32 s[sgprSrdD+2], s[sgprSrdD+2], 7

s_and_b32 s66, s[sgprGSU], 0x3fff                  // Restore GSU
s_cmp_eq_u32 s66, 1                                // GSU == 1 ?
s_cbranch_scc1 label_ArgTypeCheckC                 // Handling General Batched GEMM SRD initialization
s_mov_b64 s[sgprSrdC+0:sgprSrdC+0+1], s[sgprAddressC+0:sgprAddressC+0+1] // init SRD base address
s_branch label_GeneralBatchedGemmSrdInitiationC_End // End of handling General Batched GEMM SRD initialization
label_ArgTypeCheckC:  /// Check if ArgType is for General Batched GEMM for C
s_cmp_eq_u32 s[sgprArgType], 3                     // ArgType == 3 for General Batched GEMM
s_cbranch_scc0 label_RegularSrdInitializationC
s_branch label_GeneralBatchedGemmSrdInitiationC    // General Batched GEMM, Srd initialized to 0
label_RegularSrdInitializationC:  /// Regular SRD initialization for non-General Batched GEMM for C
s_mov_b64 s[sgprSrdC+0:sgprSrdC+0+1], s[sgprAddressC+0:sgprAddressC+0+1] // init SRD base address
s_branch label_GeneralBatchedGemmSrdInitiationC_End
label_GeneralBatchedGemmSrdInitiationC:  /// Handling General Batched GEMM SRD initialization
s_mov_b64 s[sgprSrdC+0:sgprSrdC+0+1], 0            // init SRD to 0
label_GeneralBatchedGemmSrdInitiationC_End:  /// End of handling General Batched GEMM SRD initialization
s_mov_b32 s[sgprSrdC+2], BufferOOB
s_mov_b32 s[sgprSrdC+3], Srd127_96                 // Set bits 127_96 in post-loop SRD
// Shift num records for gfx125x
s_and_b32 s66, s[sgprSrdC+2], 127
s_lshl_b32 s66, s66, 25
s_and_b32 s[sgprSrdC+1], s[sgprSrdC+1], 33554431
s_or_b32 s[sgprSrdC+1], s[sgprSrdC+1], s66
s_lshr_b32 s[sgprSrdC+2], s[sgprSrdC+2], 7


s_mul_i32 s68, MT1, s[sgprWorkGroup1]              // <- wg1*MT1
s_and_b32 s67, s[sgprGSU], 0x3fff                  // Restore GSU
s_mul_hi_u32 s67, s68, s[sgprStrideC1J]            // ScaleC s68 by Stride
s_mul_i32 s66, s68, s[sgprStrideC1J]               // ScaleC s68 by Stride
s_lshl_b64 s[66:67], s[66:67], s[sgprGSULog2BpeC]  // scale by bpe
s_add_u32 s[sgprSrdC+0], s[sgprSrdC+0], s66        // add lo to SRD
s_addc_u32 s[sgprSrdC+1], s[sgprSrdC+1], s67       // add hi to SRD
s_and_b32 s67, s[sgprGSU], 0x3fff                  // Restore GSU
s_mul_hi_u32 s67, s68, s[sgprStrideD1J]            // ScaleD s68 by Stride
s_mul_i32 s66, s68, s[sgprStrideD1J]               // ScaleD s68 by Stride
s_lshl_b64 s[66:67], s[66:67], s[sgprGSULog2BpeD]  // scale by bpe
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s66        // add lo to SRD
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], s67       // add hi to SRD

s_and_b32 s67, s[sgprGSU], 0x3fff                  // Restore GSU
s_cmp_eq_u32 s67, 1                                // GSU == 1 ?
s_cbranch_scc0 label_StridedBatchedGemmLoadC
s_cmp_eq_u32 s[sgprArgType], 3                     // ArgType == 3 for General Batched GEMM
s_cbranch_scc1 label_GeneralBatchedGemmLoadC
label_StridedBatchedGemmLoadC:  /// Computing the Batch Matrix's base address for Strided Batched GEMM
s_mul_hi_u32 s67, s[sgprWorkGroup2], s[sgprStrideCK] // ScaleC s[sgprWorkGroup2] by Stride
s_mul_i32 s66, s[sgprWorkGroup2], s[sgprStrideCK]  // ScaleC s[sgprWorkGroup2] by Stride
s_lshl_b64 s[66:67], s[66:67], s[sgprGSULog2BpeC]  // scale by bpe
s_add_u32 s[sgprSrdC+0], s[sgprSrdC+0], s66        // add lo to SRD
s_addc_u32 s[sgprSrdC+1], s[sgprSrdC+1], s67       // add hi to SRD
s_branch label_GeneralBatchedGemmLoadC_End
label_GeneralBatchedGemmLoadC:  /// Computing the Batch Matrix's base address for General Batched GEMM
s_mul_i32 s66, 8, s[sgprWorkGroup2]                // Compute stride in bytes into Pointer Array
s_add_u32 s66, s66, s[sgprAddressC+0]              // Offsetting to the location [Lower half of address]
s_addc_u32 s67, s[sgprAddressC+1], 0               // Offsetting to the location [Higher half of address]
s_load_b64 s[68:69], s[66:67], 0                   // Load the Matrix Address in the Pointer Array
s_wait_kmcnt 0                                     // Wait for the Matrix Address Load from the Pointer Array
s_add_u32 s[sgprSrdC+0], s[sgprSrdC+0], s68        // Offsetting within the Batch Matrix [Lower half of address]
s_addc_u32 s[sgprSrdC+1], s[sgprSrdC+1], s69       // Offsetting within the Batch Matrix [Higher half of address]
label_GeneralBatchedGemmLoadC_End:  /// End of label GeneralBatchedGemmLoadC
s_and_b32 s67, s[sgprGSU], 0x3fff                  // Restore GSU
s_cmp_eq_u32 s67, 1                                // GSU == 1 ?
s_cbranch_scc0 label_StridedBatchedGemmLoadD
s_cmp_eq_u32 s[sgprArgType], 3                     // ArgType == 3 for General Batched GEMM
s_cbranch_scc1 label_GeneralBatchedGemmLoadD
label_StridedBatchedGemmLoadD:  /// Computing the Batch Matrix's base address for Strided Batched GEMM
s_mul_hi_u32 s67, s[sgprWorkGroup2], s[sgprStrideDK] // ScaleD s[sgprWorkGroup2] by Stride
s_mul_i32 s66, s[sgprWorkGroup2], s[sgprStrideDK]  // ScaleD s[sgprWorkGroup2] by Stride
s_lshl_b64 s[66:67], s[66:67], s[sgprGSULog2BpeD]  // scale by bpe
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s66        // add lo to SRD
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], s67       // add hi to SRD
s_branch label_GeneralBatchedGemmLoadD_End
label_GeneralBatchedGemmLoadD:  /// Computing the Batch Matrix's base address for General Batched GEMM
s_mul_i32 s66, 8, s[sgprWorkGroup2]                // Compute stride in bytes into Pointer Array
s_add_u32 s66, s66, s[sgprAddressD+0]              // Offsetting to the location [Lower half of address]
s_addc_u32 s67, s[sgprAddressD+1], 0               // Offsetting to the location [Higher half of address]
s_load_b64 s[68:69], s[66:67], 0                   // Load the Matrix Address in the Pointer Array
s_wait_kmcnt 0                                     // Wait for the Matrix Address Load from the Pointer Array
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s68        // Offsetting within the Batch Matrix [Lower half of address]
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], s69       // Offsetting within the Batch Matrix [Higher half of address]
label_GeneralBatchedGemmLoadD_End:  /// End of label GeneralBatchedGemmLoadD

s_and_b32 s66, s[sgprGSU], 0x3fff                  // Restore GSU
s_cmp_eq_u32 s66, 1                                // GSU == 1 ?
s_cbranch_scc1 label_GSU_2                         // branch if GSU == 1
// GSU Output Buffer offset: Free0 + (Free1-1)*StrideC1J + (Free2-1)*StrideCK * GSUIdx * bpe%s
s_mul_hi_u32 s67, s[sgprSizesFree+0], s[sgprGSUSumIdx] // Free0
s_mul_i32 s66, s[sgprSizesFree+0], s[sgprGSUSumIdx] // Free0
s_sub_u32 s68, s[sgprSizesFree+1], 1               // Free1
s_mul_i32 s68, s68, s[sgprGSUSumIdx]               // Free1
s_mul_hi_u32 s69, s68, s[sgprStrideC1J]            // Free1
s_mul_i32 s68, s68, s[sgprStrideC1J]               // Free1
s_add_u32 s66, s66, s68                            // Free1
s_addc_u32 s67, s67, s69                           // Free1
s_sub_u32 s68, s[sgprSizesFree+2], 1               // Free2
s_mul_i32 s68, s68, s[sgprGSUSumIdx]               // Free2
s_mul_hi_u32 s69, s68, s[sgprStrideCK]             // Free2
s_mul_i32 s68, s68, s[sgprStrideCK]                // Free2
s_add_u32 s66, s66, s68                            // Free2
s_addc_u32 s67, s67, s69                           // Free2
s_lshl_b64 s[66:67], s[66:67], 2                   // scale by bpe
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s66        // add lo GSU offset to SRD
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], s67       // add hi GSU offset to SRD
label_GSU_2:
.set sgprGSULog2BpeC, UNDEF
.set sgprAddressC, UNDEF
s_cmp_le_u32 s[sgprLoopCounterL], 0x2              // LoopCounterL < EndCounter
s_cbranch_scc0 label_skipInitCVmov                 // skip v_mov initC (WMMA initC will run in main loop)

/* initC: remove ValuC vgpr buffer [0...8) from pool */

/* initC: remove acc vgpr buffer [0...0) from pool */

/* initC: remove ValuA/B vgpr buffer [60...127) from pool */
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v[vgprValuC+0], 0                        // initC
v_mov_b32 v[vgprValuC+1], 0                        // initC
v_mov_b32 v[vgprValuC+2], 0                        // initC
v_mov_b32 v[vgprValuC+3], 0                        // initC
v_mov_b32 v[vgprValuC+4], 0                        // initC
v_mov_b32 v[vgprValuC+5], 0                        // initC
v_mov_b32 v[vgprValuC+6], 0                        // initC
v_mov_b32 v[vgprValuC+7], 0                        // initC
label_skipInitCVmov:
s_cmp_eq_u32 s[sgprLoopCounterL], 0                // at last iteration?

/* after InitC, skip to end of prefetch last iter if numIter==0 */

/* label_PrefetchGlobalLastIterEnd */
s_cbranch_scc0 label_NoBranch_POQXZF4NTNDW3IWC     // Only branch on scc1
s_getpc_b64 s[66:67]                               // addr of next instr
s_add_i32 s68, label_PrefetchGlobalLastIterEnd, 4  // target branch offset
s_add_u32 s66, s66, s68                            // add target branch offset
s_addc_u32 s67, s67, 0                             // add high and carry
s_setpc_b64 s[66:67]                               // branch to label_PrefetchGlobalLastIterEnd
label_NoBranch_POQXZF4NTNDW3IWC:
s_wait_loadcnt 0                                   // wait for global read

/* local write a */
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+0] offset:0 // lwoA_0_0_0_0 = (0*LSCA) + (0*LSPA)(*MT0I+PAD) = 0 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+16] offset:64 // lwoA_0_0_1_0 = (0*LSCA) + (1*LSPA)(*MT0I+PAD) = 64 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+32] offset:128 // lwoA_0_0_2_0 = (0*LSCA) + (2*LSPA)(*MT0I+PAD) = 128 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+48] offset:192 // lwoA_0_0_3_0 = (0*LSCA) + (3*LSPA)(*MT0I+PAD) = 192 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+1] offset:256 // lwoA_0_0_4_0 = (0*LSCA) + (4*LSPA)(*MT0I+PAD) = 256 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+17] offset:320 // lwoA_0_0_5_0 = (0*LSCA) + (5*LSPA)(*MT0I+PAD) = 320 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+33] offset:384 // lwoA_0_0_6_0 = (0*LSCA) + (6*LSPA)(*MT0I+PAD) = 384 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+49] offset:448 // lwoA_0_0_7_0 = (0*LSCA) + (7*LSPA)(*MT0I+PAD) = 448 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+2] offset:528 // lwoA_0_0_8_0 = (0*LSCA) + (8*LSPA)(*MT0I+PAD) = 528 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+18] offset:592 // lwoA_0_0_9_0 = (0*LSCA) + (9*LSPA)(*MT0I+PAD) = 592 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+34] offset:656 // lwoA_0_0_10_0 = (0*LSCA) + (10*LSPA)(*MT0I+PAD) = 656 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+50] offset:720 // lwoA_0_0_11_0 = (0*LSCA) + (11*LSPA)(*MT0I+PAD) = 720 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+3] offset:784 // lwoA_0_0_12_0 = (0*LSCA) + (12*LSPA)(*MT0I+PAD) = 784 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+19] offset:848 // lwoA_0_0_13_0 = (0*LSCA) + (13*LSPA)(*MT0I+PAD) = 848 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+35] offset:912 // lwoA_0_0_14_0 = (0*LSCA) + (14*LSPA)(*MT0I+PAD) = 912 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+51] offset:976 // lwoA_0_0_15_0 = (0*LSCA) + (15*LSPA)(*MT0I+PAD) = 976 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+4] offset:1056 // lwoA_0_0_16_0 = (0*LSCA) + (16*LSPA)(*MT0I+PAD) = 1056 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+20] offset:1120 // lwoA_0_0_17_0 = (0*LSCA) + (17*LSPA)(*MT0I+PAD) = 1120 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+36] offset:1184 // lwoA_0_0_18_0 = (0*LSCA) + (18*LSPA)(*MT0I+PAD) = 1184 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+52] offset:1248 // lwoA_0_0_19_0 = (0*LSCA) + (19*LSPA)(*MT0I+PAD) = 1248 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+5] offset:1312 // lwoA_0_0_20_0 = (0*LSCA) + (20*LSPA)(*MT0I+PAD) = 1312 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+21] offset:1376 // lwoA_0_0_21_0 = (0*LSCA) + (21*LSPA)(*MT0I+PAD) = 1376 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+37] offset:1440 // lwoA_0_0_22_0 = (0*LSCA) + (22*LSPA)(*MT0I+PAD) = 1440 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+53] offset:1504 // lwoA_0_0_23_0 = (0*LSCA) + (23*LSPA)(*MT0I+PAD) = 1504 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+6] offset:1584 // lwoA_0_0_24_0 = (0*LSCA) + (24*LSPA)(*MT0I+PAD) = 1584 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+22] offset:1648 // lwoA_0_0_25_0 = (0*LSCA) + (25*LSPA)(*MT0I+PAD) = 1648 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+38] offset:1712 // lwoA_0_0_26_0 = (0*LSCA) + (26*LSPA)(*MT0I+PAD) = 1712 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+54] offset:1776 // lwoA_0_0_27_0 = (0*LSCA) + (27*LSPA)(*MT0I+PAD) = 1776 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+7] offset:1840 // lwoA_0_0_28_0 = (0*LSCA) + (28*LSPA)(*MT0I+PAD) = 1840 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+23] offset:1904 // lwoA_0_0_29_0 = (0*LSCA) + (29*LSPA)(*MT0I+PAD) = 1904 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+39] offset:1968 // lwoA_0_0_30_0 = (0*LSCA) + (30*LSPA)(*MT0I+PAD) = 1968 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+55] offset:2032 // lwoA_0_0_31_0 = (0*LSCA) + (31*LSPA)(*MT0I+PAD) = 2032 sync LDS0

/* local write b */
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+0] offset:0 // lwoB_0_0_0_0 = (0*LSCB) + (0*LSPB)(*MT1J+PAD) = 0 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+8] offset:64 // lwoB_0_0_1_0 = (0*LSCB) + (1*LSPB)(*MT1J+PAD) = 64 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+16] offset:128 // lwoB_0_0_2_0 = (0*LSCB) + (2*LSPB)(*MT1J+PAD) = 128 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+24] offset:192 // lwoB_0_0_3_0 = (0*LSCB) + (3*LSPB)(*MT1J+PAD) = 192 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+1] offset:272 // lwoB_0_0_4_0 = (0*LSCB) + (4*LSPB)(*MT1J+PAD) = 272 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+9] offset:336 // lwoB_0_0_5_0 = (0*LSCB) + (5*LSPB)(*MT1J+PAD) = 336 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+17] offset:400 // lwoB_0_0_6_0 = (0*LSCB) + (6*LSPB)(*MT1J+PAD) = 400 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+25] offset:464 // lwoB_0_0_7_0 = (0*LSCB) + (7*LSPB)(*MT1J+PAD) = 464 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+2] offset:544 // lwoB_0_0_8_0 = (0*LSCB) + (8*LSPB)(*MT1J+PAD) = 544 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+10] offset:608 // lwoB_0_0_9_0 = (0*LSCB) + (9*LSPB)(*MT1J+PAD) = 608 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+18] offset:672 // lwoB_0_0_10_0 = (0*LSCB) + (10*LSPB)(*MT1J+PAD) = 672 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+26] offset:736 // lwoB_0_0_11_0 = (0*LSCB) + (11*LSPB)(*MT1J+PAD) = 736 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+3] offset:816 // lwoB_0_0_12_0 = (0*LSCB) + (12*LSPB)(*MT1J+PAD) = 816 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+11] offset:880 // lwoB_0_0_13_0 = (0*LSCB) + (13*LSPB)(*MT1J+PAD) = 880 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+19] offset:944 // lwoB_0_0_14_0 = (0*LSCB) + (14*LSPB)(*MT1J+PAD) = 944 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+27] offset:1008 // lwoB_0_0_15_0 = (0*LSCB) + (15*LSPB)(*MT1J+PAD) = 1008 sync LDS0

/* local write swap a */

/* local write swap b */
s_cmp_eq_u32 s[sgprLoopCounterL], 0x1              // PGR=2 but only 1 loop
s_cbranch_scc1 label_skipPGR2_1                    // PGR=2 but only 1 loop
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
s_wait_alu depctr_va_vdst(14) depctr_vm_vsrc(6)
buffer_load_d16_u8 v[vgprG2LA+0], v[vgprGlobalReadOffsetA+0], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_0_0
buffer_load_d16_u8 v[vgprG2LA+16], v[vgprGlobalReadOffsetA+1], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_1_0
buffer_load_d16_u8 v[vgprG2LA+32], v[vgprGlobalReadOffsetA+2], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_2_0
buffer_load_d16_u8 v[vgprG2LA+48], v[vgprGlobalReadOffsetA+3], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_3_0
buffer_load_d16_u8 v[vgprG2LA+1], v[vgprGlobalReadOffsetA+4], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_4_0
buffer_load_d16_u8 v[vgprG2LA+17], v[vgprGlobalReadOffsetA+5], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_5_0
buffer_load_d16_u8 v[vgprG2LA+33], v[vgprGlobalReadOffsetA+6], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_6_0
buffer_load_d16_u8 v[vgprG2LA+49], v[vgprGlobalReadOffsetA+7], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_7_0
buffer_load_d16_u8 v[vgprG2LA+2], v[vgprGlobalReadOffsetA+8], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_8_0
buffer_load_d16_u8 v[vgprG2LA+18], v[vgprGlobalReadOffsetA+9], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_9_0
buffer_load_d16_u8 v[vgprG2LA+34], v[vgprGlobalReadOffsetA+10], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_10_0
buffer_load_d16_u8 v[vgprG2LA+50], v[vgprGlobalReadOffsetA+11], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_11_0
buffer_load_d16_u8 v[vgprG2LA+3], v[vgprGlobalReadOffsetA+12], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_12_0
buffer_load_d16_u8 v[vgprG2LA+19], v[vgprGlobalReadOffsetA+13], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_13_0
buffer_load_d16_u8 v[vgprG2LA+35], v[vgprGlobalReadOffsetA+14], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_14_0
buffer_load_d16_u8 v[vgprG2LA+51], v[vgprGlobalReadOffsetA+15], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_15_0
buffer_load_d16_u8 v[vgprG2LA+4], v[vgprGlobalReadOffsetA+16], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_16_0
buffer_load_d16_u8 v[vgprG2LA+20], v[vgprGlobalReadOffsetA+17], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_17_0
buffer_load_d16_u8 v[vgprG2LA+36], v[vgprGlobalReadOffsetA+18], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_18_0
buffer_load_d16_u8 v[vgprG2LA+52], v[vgprGlobalReadOffsetA+19], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_19_0
buffer_load_d16_u8 v[vgprG2LA+5], v[vgprGlobalReadOffsetA+20], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_20_0
buffer_load_d16_u8 v[vgprG2LA+21], v[vgprGlobalReadOffsetA+21], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_21_0
buffer_load_d16_u8 v[vgprG2LA+37], v[vgprGlobalReadOffsetA+22], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_22_0
buffer_load_d16_u8 v[vgprG2LA+53], v[vgprGlobalReadOffsetA+23], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_23_0
buffer_load_d16_u8 v[vgprG2LA+6], v[vgprGlobalReadOffsetA+24], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_24_0
buffer_load_d16_u8 v[vgprG2LA+22], v[vgprGlobalReadOffsetA+25], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_25_0
buffer_load_d16_u8 v[vgprG2LA+38], v[vgprGlobalReadOffsetA+26], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_26_0
buffer_load_d16_u8 v[vgprG2LA+54], v[vgprGlobalReadOffsetA+27], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_27_0
buffer_load_d16_u8 v[vgprG2LA+7], v[vgprGlobalReadOffsetA+28], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_28_0
buffer_load_d16_u8 v[vgprG2LA+23], v[vgprGlobalReadOffsetA+29], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_29_0
buffer_load_d16_u8 v[vgprG2LA+39], v[vgprGlobalReadOffsetA+30], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_30_0
buffer_load_d16_u8 v[vgprG2LA+55], v[vgprGlobalReadOffsetA+31], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_31_0
buffer_load_d16_u8 v[vgprG2LB+0], v[vgprGlobalReadOffsetB+0], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_0_0
buffer_load_d16_u8 v[vgprG2LB+8], v[vgprGlobalReadOffsetB+1], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_1_0
buffer_load_d16_u8 v[vgprG2LB+16], v[vgprGlobalReadOffsetB+2], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_2_0
buffer_load_d16_u8 v[vgprG2LB+24], v[vgprGlobalReadOffsetB+3], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_3_0
buffer_load_d16_u8 v[vgprG2LB+1], v[vgprGlobalReadOffsetB+4], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_4_0
buffer_load_d16_u8 v[vgprG2LB+9], v[vgprGlobalReadOffsetB+5], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_5_0
buffer_load_d16_u8 v[vgprG2LB+17], v[vgprGlobalReadOffsetB+6], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_6_0
buffer_load_d16_u8 v[vgprG2LB+25], v[vgprGlobalReadOffsetB+7], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_7_0
buffer_load_d16_u8 v[vgprG2LB+2], v[vgprGlobalReadOffsetB+8], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_8_0
buffer_load_d16_u8 v[vgprG2LB+10], v[vgprGlobalReadOffsetB+9], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_9_0
s_wait_alu depctr_vm_vsrc(5)
buffer_load_d16_u8 v[vgprG2LB+18], v[vgprGlobalReadOffsetB+10], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_10_0
s_wait_alu depctr_va_vdst(12) depctr_vm_vsrc(4)
buffer_load_d16_u8 v[vgprG2LB+26], v[vgprGlobalReadOffsetB+11], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_11_0
s_wait_alu depctr_va_vdst(9) depctr_vm_vsrc(3)
buffer_load_d16_u8 v[vgprG2LB+3], v[vgprGlobalReadOffsetB+12], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_12_0
s_wait_alu depctr_va_vdst(6) depctr_vm_vsrc(2)
buffer_load_d16_u8 v[vgprG2LB+11], v[vgprGlobalReadOffsetB+13], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_13_0
s_wait_alu depctr_va_vdst(3) depctr_vm_vsrc(1)
buffer_load_d16_u8 v[vgprG2LB+19], v[vgprGlobalReadOffsetB+14], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_14_0
s_wait_alu depctr_va_vdst(0) depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+27], v[vgprGlobalReadOffsetB+15], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_15_0
s_branch label_skipPGR2_2                          // jump to PGR=2 label
label_skipPGR2_1:
label_skipPGR2_2:

/******************************************/
/* Unrolled Loop(s) - Begin               */
/******************************************/
label_openLoopL:
s_cmp_eq_u32 s[sgprLoopCounterL], 0x1              // LoopCounterL == 1 (PGR>=2, not Suppress: single-loop -> toPGR1)
s_cbranch_scc1 label_toPGR1                        // PGR=2 but only 1 loop, toPGR1
s_cmp_le_u32 s[sgprLoopCounterL], 0x2              // LoopCounterL < EndCounter
s_cbranch_scc1 label_LoopEndL                      // do not enter LoopL
label_InitCIterWmma_label_LoopBeginL_0:
s_wait_dscnt 0                                     // 1wait for local write
s_barrier_signal -1
s_barrier_wait -1                                  // 4sync for global read, PGR->LW needs sync
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
s_wait_alu depctr_va_vdst(2)
ds_load_u8 v[vgprValuA_X0_I0+0], v[vgprLocalReadAddrA+0] offset:0 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D1+0], v[vgprLocalReadAddrA+0] offset:32 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D2+0], v[vgprLocalReadAddrA+0] offset:64 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=2 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D3+0], v[vgprLocalReadAddrA+0] offset:96 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=3 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0+1], v[vgprLocalReadAddrA+0] offset:128 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=4 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D1+1], v[vgprLocalReadAddrA+0] offset:160 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=5 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D2+1], v[vgprLocalReadAddrA+0] offset:192 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=6 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D3+1], v[vgprLocalReadAddrA+0] offset:224 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=7 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0+2], v[vgprLocalReadAddrA+0] offset:256 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=8 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D1+2], v[vgprLocalReadAddrA+0] offset:288 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=9 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D2+2], v[vgprLocalReadAddrA+0] offset:320 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=10 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D3+2], v[vgprLocalReadAddrA+0] offset:352 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=11 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0+3], v[vgprLocalReadAddrA+0] offset:384 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=12 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D1+3], v[vgprLocalReadAddrA+0] offset:416 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=13 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D2+3], v[vgprLocalReadAddrA+0] offset:448 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=14 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D3+3], v[vgprLocalReadAddrA+0] offset:480 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=15 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0+4], v[vgprLocalReadAddrA+0] offset:1056 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=16 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D1+4], v[vgprLocalReadAddrA+0] offset:1088 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=17 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D2+4], v[vgprLocalReadAddrA+0] offset:1120 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=18 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D3+4], v[vgprLocalReadAddrA+0] offset:1152 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=19 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0+5], v[vgprLocalReadAddrA+0] offset:1184 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=20 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D1+5], v[vgprLocalReadAddrA+0] offset:1216 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=21 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D2+5], v[vgprLocalReadAddrA+0] offset:1248 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=22 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D3+5], v[vgprLocalReadAddrA+0] offset:1280 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=23 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0+6], v[vgprLocalReadAddrA+0] offset:1312 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=24 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D1+6], v[vgprLocalReadAddrA+0] offset:1344 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=25 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D2+6], v[vgprLocalReadAddrA+0] offset:1376 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=26 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D3+6], v[vgprLocalReadAddrA+0] offset:1408 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=27 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0+7], v[vgprLocalReadAddrA+0] offset:1440 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=28 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D1+7], v[vgprLocalReadAddrA+0] offset:1472 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=29 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D2+7], v[vgprLocalReadAddrA+0] offset:1504 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=30 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D3+7], v[vgprLocalReadAddrA+0] offset:1536 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=31 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0+0], v[vgprLocalReadAddrB+0] offset:0 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D1+0], v[vgprLocalReadAddrB+0] offset:16 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D2+0], v[vgprLocalReadAddrB+0] offset:32 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=2 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D3+0], v[vgprLocalReadAddrB+0] offset:48 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=3 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0+1], v[vgprLocalReadAddrB+0] offset:64 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=4 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D1+1], v[vgprLocalReadAddrB+0] offset:80 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=5 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D2+1], v[vgprLocalReadAddrB+0] offset:96 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=6 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D3+1], v[vgprLocalReadAddrB+0] offset:112 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=7 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0+2], v[vgprLocalReadAddrB+0] offset:128 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=8 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D1+2], v[vgprLocalReadAddrB+0] offset:144 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=9 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D2+2], v[vgprLocalReadAddrB+0] offset:160 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=10 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D3+2], v[vgprLocalReadAddrB+0] offset:176 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=11 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0+3], v[vgprLocalReadAddrB+0] offset:192 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=12 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D1+3], v[vgprLocalReadAddrB+0] offset:208 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=13 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D2+3], v[vgprLocalReadAddrB+0] offset:224 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=14 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D3+3], v[vgprLocalReadAddrB+0] offset:240 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=15 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0+4], v[vgprLocalReadAddrB+0] offset:544 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=16 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D1+4], v[vgprLocalReadAddrB+0] offset:560 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=17 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D2+4], v[vgprLocalReadAddrB+0] offset:576 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=18 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D3+4], v[vgprLocalReadAddrB+0] offset:592 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=19 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0+5], v[vgprLocalReadAddrB+0] offset:608 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=20 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D1+5], v[vgprLocalReadAddrB+0] offset:624 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=21 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D2+5], v[vgprLocalReadAddrB+0] offset:640 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=22 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D3+5], v[vgprLocalReadAddrB+0] offset:656 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=23 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0+6], v[vgprLocalReadAddrB+0] offset:672 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=24 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D1+6], v[vgprLocalReadAddrB+0] offset:688 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=25 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D2+6], v[vgprLocalReadAddrB+0] offset:704 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=26 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D3+6], v[vgprLocalReadAddrB+0] offset:720 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=27 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0+7], v[vgprLocalReadAddrB+0] offset:736 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=28 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D1+7], v[vgprLocalReadAddrB+0] offset:752 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=29 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D2+7], v[vgprLocalReadAddrB+0] offset:768 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=30 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D3+7], v[vgprLocalReadAddrB+0] offset:784 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=31 oIdx=0 buffer=0 iui=0 sync LDS0
s_cmp_eq_u32 s[sgprLoopCounterL], s[sgprStaggerUIter] // Is this the wrapIter?
s_cselect_b32 s66, s[sgprWrapUA+0], s[sgprGlobalReadIncsA+0] // incLower <- ?
s_cselect_b32 s67, s[sgprWrapUA+1], 0              // incUpper <- ?
s_add_u32 s[sgprSrdA+0], s[sgprSrdA+0], s66        // gra SRD += inc(lower)
s_addc_u32 s[sgprSrdA+1], s[sgprSrdA+1], s67       // gra SRD += inc(upper)
s_sub_u32 s[sgprShadowLimitA+0], s[sgprShadowLimitA+0], s66 // limit -= inc)
s_subb_u32 s[sgprShadowLimitA+1], s[sgprShadowLimitA+1], s67 // limit -= inc)
s_cmp_eq_u32 s[sgprShadowLimitA+1], 0              // are we within 2^32?
s_cselect_b32 s[sgprSrdA+2], s[sgprShadowLimitA+0], BufferLimit // Move shadow to real if we are within 2^32
s_and_b32 s8, s[sgprSrdA+2], 127
s_lshl_b32 s8, s8, 25
s_and_b32 s[sgprSrdA+1], s[sgprSrdA+1], 33554431
s_or_b32 s[sgprSrdA+1], s[sgprSrdA+1], s8
s_lshr_b32 s[sgprSrdA+2], s[sgprSrdA+2], 7
s_cmp_eq_u32 s[sgprLoopCounterL], s[sgprStaggerUIter] // Is this the wrapIter?
s_cselect_b32 s66, s[sgprWrapUB+0], s[sgprGlobalReadIncsB+0] // incLower <- ?
s_cselect_b32 s67, s[sgprWrapUB+1], 0              // incUpper <- ?
s_add_u32 s[sgprSrdB+0], s[sgprSrdB+0], s66        // gra SRD += inc(lower)
s_addc_u32 s[sgprSrdB+1], s[sgprSrdB+1], s67       // gra SRD += inc(upper)
s_sub_u32 s[sgprShadowLimitB+0], s[sgprShadowLimitB+0], s66 // limit -= inc)
s_subb_u32 s[sgprShadowLimitB+1], s[sgprShadowLimitB+1], s67 // limit -= inc)
s_cmp_eq_u32 s[sgprShadowLimitB+1], 0              // are we within 2^32?
s_cselect_b32 s[sgprSrdB+2], s[sgprShadowLimitB+0], BufferLimit // Move shadow to real if we are within 2^32
s_and_b32 s8, s[sgprSrdB+2], 127
s_lshl_b32 s8, s8, 25
s_and_b32 s[sgprSrdB+1], s[sgprSrdB+1], 33554431
s_or_b32 s[sgprSrdB+1], s[sgprSrdB+1], s8
s_lshr_b32 s[sgprSrdB+2], s[sgprSrdB+2], 7
s_wait_dscnt 0
s_barrier_signal -1
s_barrier_wait -1
s_wait_loadcnt 47                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+0] offset:0 // lwoA_0_0_0_0 = (0*LSCA) + (0*LSPA)(*MT0I+PAD) = 0 sync LDS0
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LA+0], v[vgprGlobalReadOffsetA+0], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_0_0
s_wait_loadcnt 47                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+16] offset:64 // lwoA_0_0_1_0 = (0*LSCA) + (1*LSPA)(*MT0I+PAD) = 64 sync LDS0
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LA+16], v[vgprGlobalReadOffsetA+1], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_1_0
s_wait_loadcnt 47                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+32] offset:128 // lwoA_0_0_2_0 = (0*LSCA) + (2*LSPA)(*MT0I+PAD) = 128 sync LDS0
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LA+32], v[vgprGlobalReadOffsetA+2], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_2_0
s_wait_loadcnt 47                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+48] offset:192 // lwoA_0_0_3_0 = (0*LSCA) + (3*LSPA)(*MT0I+PAD) = 192 sync LDS0
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LA+48], v[vgprGlobalReadOffsetA+3], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_3_0
s_wait_loadcnt 47                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+1] offset:256 // lwoA_0_0_4_0 = (0*LSCA) + (4*LSPA)(*MT0I+PAD) = 256 sync LDS0
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LA+1], v[vgprGlobalReadOffsetA+4], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_4_0
s_wait_loadcnt 47                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+17] offset:320 // lwoA_0_0_5_0 = (0*LSCA) + (5*LSPA)(*MT0I+PAD) = 320 sync LDS0
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LA+17], v[vgprGlobalReadOffsetA+5], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_5_0
s_wait_loadcnt 47                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+33] offset:384 // lwoA_0_0_6_0 = (0*LSCA) + (6*LSPA)(*MT0I+PAD) = 384 sync LDS0
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LA+33], v[vgprGlobalReadOffsetA+6], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_6_0
s_wait_loadcnt 47                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+49] offset:448 // lwoA_0_0_7_0 = (0*LSCA) + (7*LSPA)(*MT0I+PAD) = 448 sync LDS0
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LA+49], v[vgprGlobalReadOffsetA+7], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_7_0
s_wait_loadcnt 47                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+2] offset:528 // lwoA_0_0_8_0 = (0*LSCA) + (8*LSPA)(*MT0I+PAD) = 528 sync LDS0
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LA+2], v[vgprGlobalReadOffsetA+8], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_8_0
s_wait_loadcnt 47                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+18] offset:592 // lwoA_0_0_9_0 = (0*LSCA) + (9*LSPA)(*MT0I+PAD) = 592 sync LDS0
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LA+18], v[vgprGlobalReadOffsetA+9], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_9_0
s_wait_loadcnt 47                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+34] offset:656 // lwoA_0_0_10_0 = (0*LSCA) + (10*LSPA)(*MT0I+PAD) = 656 sync LDS0
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LA+34], v[vgprGlobalReadOffsetA+10], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_10_0
s_wait_loadcnt 47                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+50] offset:720 // lwoA_0_0_11_0 = (0*LSCA) + (11*LSPA)(*MT0I+PAD) = 720 sync LDS0
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LA+50], v[vgprGlobalReadOffsetA+11], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_11_0
s_wait_loadcnt 47                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+3] offset:784 // lwoA_0_0_12_0 = (0*LSCA) + (12*LSPA)(*MT0I+PAD) = 784 sync LDS0
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LA+3], v[vgprGlobalReadOffsetA+12], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_12_0
s_wait_loadcnt 47                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+19] offset:848 // lwoA_0_0_13_0 = (0*LSCA) + (13*LSPA)(*MT0I+PAD) = 848 sync LDS0
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LA+19], v[vgprGlobalReadOffsetA+13], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_13_0
s_wait_loadcnt 47                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+35] offset:912 // lwoA_0_0_14_0 = (0*LSCA) + (14*LSPA)(*MT0I+PAD) = 912 sync LDS0
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LA+35], v[vgprGlobalReadOffsetA+14], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_14_0
s_wait_loadcnt 47                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+51] offset:976 // lwoA_0_0_15_0 = (0*LSCA) + (15*LSPA)(*MT0I+PAD) = 976 sync LDS0
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LA+51], v[vgprGlobalReadOffsetA+15], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_15_0
s_wait_loadcnt 47                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+4] offset:1056 // lwoA_0_0_16_0 = (0*LSCA) + (16*LSPA)(*MT0I+PAD) = 1056 sync LDS0
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LA+4], v[vgprGlobalReadOffsetA+16], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_16_0
s_wait_loadcnt 47                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+20] offset:1120 // lwoA_0_0_17_0 = (0*LSCA) + (17*LSPA)(*MT0I+PAD) = 1120 sync LDS0
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LA+20], v[vgprGlobalReadOffsetA+17], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_17_0
s_wait_loadcnt 47                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+36] offset:1184 // lwoA_0_0_18_0 = (0*LSCA) + (18*LSPA)(*MT0I+PAD) = 1184 sync LDS0
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LA+36], v[vgprGlobalReadOffsetA+18], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_18_0
s_wait_loadcnt 47                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+52] offset:1248 // lwoA_0_0_19_0 = (0*LSCA) + (19*LSPA)(*MT0I+PAD) = 1248 sync LDS0
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LA+52], v[vgprGlobalReadOffsetA+19], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_19_0
s_wait_loadcnt 47                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+5] offset:1312 // lwoA_0_0_20_0 = (0*LSCA) + (20*LSPA)(*MT0I+PAD) = 1312 sync LDS0
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LA+5], v[vgprGlobalReadOffsetA+20], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_20_0
s_wait_loadcnt 47                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+21] offset:1376 // lwoA_0_0_21_0 = (0*LSCA) + (21*LSPA)(*MT0I+PAD) = 1376 sync LDS0
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LA+21], v[vgprGlobalReadOffsetA+21], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_21_0
s_wait_loadcnt 47                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+37] offset:1440 // lwoA_0_0_22_0 = (0*LSCA) + (22*LSPA)(*MT0I+PAD) = 1440 sync LDS0
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LA+37], v[vgprGlobalReadOffsetA+22], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_22_0
s_wait_loadcnt 47                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+53] offset:1504 // lwoA_0_0_23_0 = (0*LSCA) + (23*LSPA)(*MT0I+PAD) = 1504 sync LDS0
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LA+53], v[vgprGlobalReadOffsetA+23], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_23_0
s_wait_loadcnt 47                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+6] offset:1584 // lwoA_0_0_24_0 = (0*LSCA) + (24*LSPA)(*MT0I+PAD) = 1584 sync LDS0
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LA+6], v[vgprGlobalReadOffsetA+24], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_24_0
s_wait_loadcnt 47                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+22] offset:1648 // lwoA_0_0_25_0 = (0*LSCA) + (25*LSPA)(*MT0I+PAD) = 1648 sync LDS0
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LA+22], v[vgprGlobalReadOffsetA+25], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_25_0
s_wait_loadcnt 47                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+38] offset:1712 // lwoA_0_0_26_0 = (0*LSCA) + (26*LSPA)(*MT0I+PAD) = 1712 sync LDS0
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LA+38], v[vgprGlobalReadOffsetA+26], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_26_0
s_wait_loadcnt 47                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+54] offset:1776 // lwoA_0_0_27_0 = (0*LSCA) + (27*LSPA)(*MT0I+PAD) = 1776 sync LDS0
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LA+54], v[vgprGlobalReadOffsetA+27], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_27_0
s_wait_loadcnt 47                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+7] offset:1840 // lwoA_0_0_28_0 = (0*LSCA) + (28*LSPA)(*MT0I+PAD) = 1840 sync LDS0
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LA+7], v[vgprGlobalReadOffsetA+28], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_28_0
s_wait_loadcnt 47                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+23] offset:1904 // lwoA_0_0_29_0 = (0*LSCA) + (29*LSPA)(*MT0I+PAD) = 1904 sync LDS0
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LA+23], v[vgprGlobalReadOffsetA+29], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_29_0
s_wait_loadcnt 47                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+39] offset:1968 // lwoA_0_0_30_0 = (0*LSCA) + (30*LSPA)(*MT0I+PAD) = 1968 sync LDS0
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LA+39], v[vgprGlobalReadOffsetA+30], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_30_0
s_wait_loadcnt 47                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+55] offset:2032 // lwoA_0_0_31_0 = (0*LSCA) + (31*LSPA)(*MT0I+PAD) = 2032 sync LDS0
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LA+55], v[vgprGlobalReadOffsetA+31], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_31_0
s_wait_loadcnt 47                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+0] offset:0 // lwoB_0_0_0_0 = (0*LSCB) + (0*LSPB)(*MT1J+PAD) = 0 sync LDS0
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+0], v[vgprGlobalReadOffsetB+0], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_0_0
s_wait_loadcnt 47                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+8] offset:64 // lwoB_0_0_1_0 = (0*LSCB) + (1*LSPB)(*MT1J+PAD) = 64 sync LDS0
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+8], v[vgprGlobalReadOffsetB+1], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_1_0
s_wait_loadcnt 47                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+16] offset:128 // lwoB_0_0_2_0 = (0*LSCB) + (2*LSPB)(*MT1J+PAD) = 128 sync LDS0
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+16], v[vgprGlobalReadOffsetB+2], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_2_0
s_wait_loadcnt 47                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+24] offset:192 // lwoB_0_0_3_0 = (0*LSCB) + (3*LSPB)(*MT1J+PAD) = 192 sync LDS0
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+24], v[vgprGlobalReadOffsetB+3], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_3_0
s_wait_loadcnt 47                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+1] offset:272 // lwoB_0_0_4_0 = (0*LSCB) + (4*LSPB)(*MT1J+PAD) = 272 sync LDS0
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+1], v[vgprGlobalReadOffsetB+4], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_4_0
s_wait_loadcnt 47                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+9] offset:336 // lwoB_0_0_5_0 = (0*LSCB) + (5*LSPB)(*MT1J+PAD) = 336 sync LDS0
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+9], v[vgprGlobalReadOffsetB+5], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_5_0
s_wait_loadcnt 47                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+17] offset:400 // lwoB_0_0_6_0 = (0*LSCB) + (6*LSPB)(*MT1J+PAD) = 400 sync LDS0
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+17], v[vgprGlobalReadOffsetB+6], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_6_0
s_wait_loadcnt 47                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+25] offset:464 // lwoB_0_0_7_0 = (0*LSCB) + (7*LSPB)(*MT1J+PAD) = 464 sync LDS0
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+25], v[vgprGlobalReadOffsetB+7], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_7_0
s_wait_loadcnt 47                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+2] offset:544 // lwoB_0_0_8_0 = (0*LSCB) + (8*LSPB)(*MT1J+PAD) = 544 sync LDS0
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+2], v[vgprGlobalReadOffsetB+8], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_8_0
s_wait_loadcnt 47                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+10] offset:608 // lwoB_0_0_9_0 = (0*LSCB) + (9*LSPB)(*MT1J+PAD) = 608 sync LDS0
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+10], v[vgprGlobalReadOffsetB+9], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_9_0
s_wait_loadcnt 47                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+18] offset:672 // lwoB_0_0_10_0 = (0*LSCB) + (10*LSPB)(*MT1J+PAD) = 672 sync LDS0
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+18], v[vgprGlobalReadOffsetB+10], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_10_0
s_wait_loadcnt 47                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+26] offset:736 // lwoB_0_0_11_0 = (0*LSCB) + (11*LSPB)(*MT1J+PAD) = 736 sync LDS0
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+26], v[vgprGlobalReadOffsetB+11], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_11_0
s_wait_loadcnt 47                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+3] offset:816 // lwoB_0_0_12_0 = (0*LSCB) + (12*LSPB)(*MT1J+PAD) = 816 sync LDS0
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+3], v[vgprGlobalReadOffsetB+12], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_12_0
s_wait_loadcnt 47                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+11] offset:880 // lwoB_0_0_13_0 = (0*LSCB) + (13*LSPB)(*MT1J+PAD) = 880 sync LDS0
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+11], v[vgprGlobalReadOffsetB+13], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_13_0
s_wait_loadcnt 47                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+19] offset:944 // lwoB_0_0_14_0 = (0*LSCB) + (14*LSPB)(*MT1J+PAD) = 944 sync LDS0
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+19], v[vgprGlobalReadOffsetB+14], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_14_0
s_wait_loadcnt 47                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+27] offset:1008 // lwoB_0_0_15_0 = (0*LSCB) + (15*LSPB)(*MT1J+PAD) = 1008 sync LDS0
s_wait_alu depctr_va_vdst(0) depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+27], v[vgprGlobalReadOffsetB+15], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_15_0
v_lshl_or_b32 v[vgprValuA_X0_I0+0], v[vgprValuA_X0_I0_D1+0], 8, v[vgprValuA_X0_I0+0] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+0], v[vgprValuA_X0_I0_D3+0], 8, v[vgprValuA_X0_I0_D2+0] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+0], v[vgprValuA_X0_I0_D2+0], 0x10, v[vgprValuA_X0_I0+0] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+1], v[vgprValuA_X0_I0_D1+1], 8, v[vgprValuA_X0_I0+1] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+1], v[vgprValuA_X0_I0_D3+1], 8, v[vgprValuA_X0_I0_D2+1] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+1], v[vgprValuA_X0_I0_D2+1], 0x10, v[vgprValuA_X0_I0+1] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+2], v[vgprValuA_X0_I0_D1+2], 8, v[vgprValuA_X0_I0+2] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+2], v[vgprValuA_X0_I0_D3+2], 8, v[vgprValuA_X0_I0_D2+2] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+2], v[vgprValuA_X0_I0_D2+2], 0x10, v[vgprValuA_X0_I0+2] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+3], v[vgprValuA_X0_I0_D1+3], 8, v[vgprValuA_X0_I0+3] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+3], v[vgprValuA_X0_I0_D3+3], 8, v[vgprValuA_X0_I0_D2+3] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+3], v[vgprValuA_X0_I0_D2+3], 0x10, v[vgprValuA_X0_I0+3] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+4], v[vgprValuA_X0_I0_D1+4], 8, v[vgprValuA_X0_I0+4] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+4], v[vgprValuA_X0_I0_D3+4], 8, v[vgprValuA_X0_I0_D2+4] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+4], v[vgprValuA_X0_I0_D2+4], 0x10, v[vgprValuA_X0_I0+4] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+5], v[vgprValuA_X0_I0_D1+5], 8, v[vgprValuA_X0_I0+5] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+5], v[vgprValuA_X0_I0_D3+5], 8, v[vgprValuA_X0_I0_D2+5] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+5], v[vgprValuA_X0_I0_D2+5], 0x10, v[vgprValuA_X0_I0+5] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+6], v[vgprValuA_X0_I0_D1+6], 8, v[vgprValuA_X0_I0+6] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+6], v[vgprValuA_X0_I0_D3+6], 8, v[vgprValuA_X0_I0_D2+6] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+6], v[vgprValuA_X0_I0_D2+6], 0x10, v[vgprValuA_X0_I0+6] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+7], v[vgprValuA_X0_I0_D1+7], 8, v[vgprValuA_X0_I0+7] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+7], v[vgprValuA_X0_I0_D3+7], 8, v[vgprValuA_X0_I0_D2+7] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+7], v[vgprValuA_X0_I0_D2+7], 0x10, v[vgprValuA_X0_I0+7] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+0], v[vgprValuB_X0_I0_D1+0], 8, v[vgprValuB_X0_I0+0] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0_D2+0], v[vgprValuB_X0_I0_D3+0], 8, v[vgprValuB_X0_I0_D2+0] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+0], v[vgprValuB_X0_I0_D2+0], 0x10, v[vgprValuB_X0_I0+0] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+1], v[vgprValuB_X0_I0_D1+1], 8, v[vgprValuB_X0_I0+1] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0_D2+1], v[vgprValuB_X0_I0_D3+1], 8, v[vgprValuB_X0_I0_D2+1] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+1], v[vgprValuB_X0_I0_D2+1], 0x10, v[vgprValuB_X0_I0+1] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+2], v[vgprValuB_X0_I0_D1+2], 8, v[vgprValuB_X0_I0+2] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0_D2+2], v[vgprValuB_X0_I0_D3+2], 8, v[vgprValuB_X0_I0_D2+2] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+2], v[vgprValuB_X0_I0_D2+2], 0x10, v[vgprValuB_X0_I0+2] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+3], v[vgprValuB_X0_I0_D1+3], 8, v[vgprValuB_X0_I0+3] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0_D2+3], v[vgprValuB_X0_I0_D3+3], 8, v[vgprValuB_X0_I0_D2+3] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+3], v[vgprValuB_X0_I0_D2+3], 0x10, v[vgprValuB_X0_I0+3] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+4], v[vgprValuB_X0_I0_D1+4], 8, v[vgprValuB_X0_I0+4] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0_D2+4], v[vgprValuB_X0_I0_D3+4], 8, v[vgprValuB_X0_I0_D2+4] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+4], v[vgprValuB_X0_I0_D2+4], 0x10, v[vgprValuB_X0_I0+4] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+5], v[vgprValuB_X0_I0_D1+5], 8, v[vgprValuB_X0_I0+5] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0_D2+5], v[vgprValuB_X0_I0_D3+5], 8, v[vgprValuB_X0_I0_D2+5] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+5], v[vgprValuB_X0_I0_D2+5], 0x10, v[vgprValuB_X0_I0+5] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+6], v[vgprValuB_X0_I0_D1+6], 8, v[vgprValuB_X0_I0+6] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0_D2+6], v[vgprValuB_X0_I0_D3+6], 8, v[vgprValuB_X0_I0_D2+6] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+6], v[vgprValuB_X0_I0_D2+6], 0x10, v[vgprValuB_X0_I0+6] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+7], v[vgprValuB_X0_I0_D1+7], 8, v[vgprValuB_X0_I0+7] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0_D2+7], v[vgprValuB_X0_I0_D3+7], 8, v[vgprValuB_X0_I0_D2+7] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+7], v[vgprValuB_X0_I0_D2+7], 0x10, v[vgprValuB_X0_I0+7] // pack two half Vgpr to one Vgpr
s_nop 1                                            // VALU packing writes to be consumed by matrix instruction
v_wmma_f32_16x16x64_fp8_fp8 v[vgprValuC+0:vgprValuC+0+7], v[vgprValuA_X0_I0+0+0+0:vgprValuA_X0_I0+0+0+0+7], v[vgprValuB_X0_I0+0+0+0:vgprValuB_X0_I0+0+0+0+7], 0 matrix_a_reuse matrix_b_reuse // left value = v[0+0:7+0]
s_branch label_InitCIterWmma_target_0
.align 16
label_LoopBeginL:

/******************************************/
/* Unrolled Loop 1/1 - Begin              */
/******************************************/
s_wait_dscnt 0                                     // 1wait for local write <This is 1-cycle>
// Skip force waitcnt0
s_barrier_signal -1                                // <This is 2-cycle>
s_barrier_wait -1                                  // 4sync for global read, PGR->LW needs sync <This is 12-cycle>

/* Begin Each Unroll: Check VGPR.checkin for INT8 LW */

/* iter 0 (reset local read pointers iteration)  (swap and reset local write pointers iteration)  (swap local read pointers iteration)  */
/*  grEndMfmaIndex:0, lwStartMfmaIndex:0, lwEndMfmaIndex:0  */
/*  numMfmaForLR:0, syncPlrMfmaIndex:0 , sync1LdsMfmaIndex:0 */
/*  mfmaIndex:0  */
/* schedule remaining localreads for one buffer scheduling */
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0 <This is 13-cycle>
s_wait_alu depctr_va_vdst(14)                      // <This is 14-cycle>
ds_load_u8 v[vgprValuA_X0_I0+0], v[vgprLocalReadAddrA+0] offset:0 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 15-cycle>
ds_load_u8 v[vgprValuA_X0_I0_D1+0], v[vgprLocalReadAddrA+0] offset:32 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 17-cycle>
ds_load_u8 v[vgprValuA_X0_I0_D2+0], v[vgprLocalReadAddrA+0] offset:64 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=2 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 19-cycle>
ds_load_u8 v[vgprValuA_X0_I0_D3+0], v[vgprLocalReadAddrA+0] offset:96 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=3 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 21-cycle>
ds_load_u8 v[vgprValuA_X0_I0+1], v[vgprLocalReadAddrA+0] offset:128 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=4 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 23-cycle>
ds_load_u8 v[vgprValuA_X0_I0_D1+1], v[vgprLocalReadAddrA+0] offset:160 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=5 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 25-cycle>
ds_load_u8 v[vgprValuA_X0_I0_D2+1], v[vgprLocalReadAddrA+0] offset:192 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=6 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 27-cycle>
ds_load_u8 v[vgprValuA_X0_I0_D3+1], v[vgprLocalReadAddrA+0] offset:224 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=7 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 29-cycle>
ds_load_u8 v[vgprValuA_X0_I0+2], v[vgprLocalReadAddrA+0] offset:256 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=8 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 31-cycle>
ds_load_u8 v[vgprValuA_X0_I0_D1+2], v[vgprLocalReadAddrA+0] offset:288 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=9 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 33-cycle>
ds_load_u8 v[vgprValuA_X0_I0_D2+2], v[vgprLocalReadAddrA+0] offset:320 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=10 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 35-cycle>
ds_load_u8 v[vgprValuA_X0_I0_D3+2], v[vgprLocalReadAddrA+0] offset:352 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=11 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 37-cycle>
ds_load_u8 v[vgprValuA_X0_I0+3], v[vgprLocalReadAddrA+0] offset:384 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=12 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 39-cycle>
ds_load_u8 v[vgprValuA_X0_I0_D1+3], v[vgprLocalReadAddrA+0] offset:416 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=13 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 41-cycle>
ds_load_u8 v[vgprValuA_X0_I0_D2+3], v[vgprLocalReadAddrA+0] offset:448 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=14 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 43-cycle>
ds_load_u8 v[vgprValuA_X0_I0_D3+3], v[vgprLocalReadAddrA+0] offset:480 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=15 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 45-cycle>
ds_load_u8 v[vgprValuA_X0_I0+4], v[vgprLocalReadAddrA+0] offset:1056 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=16 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 47-cycle>
ds_load_u8 v[vgprValuA_X0_I0_D1+4], v[vgprLocalReadAddrA+0] offset:1088 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=17 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 49-cycle>
ds_load_u8 v[vgprValuA_X0_I0_D2+4], v[vgprLocalReadAddrA+0] offset:1120 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=18 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 51-cycle>
ds_load_u8 v[vgprValuA_X0_I0_D3+4], v[vgprLocalReadAddrA+0] offset:1152 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=19 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 53-cycle>
ds_load_u8 v[vgprValuA_X0_I0+5], v[vgprLocalReadAddrA+0] offset:1184 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=20 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 55-cycle>
ds_load_u8 v[vgprValuA_X0_I0_D1+5], v[vgprLocalReadAddrA+0] offset:1216 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=21 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 57-cycle>
ds_load_u8 v[vgprValuA_X0_I0_D2+5], v[vgprLocalReadAddrA+0] offset:1248 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=22 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 59-cycle>
ds_load_u8 v[vgprValuA_X0_I0_D3+5], v[vgprLocalReadAddrA+0] offset:1280 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=23 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 61-cycle>
ds_load_u8 v[vgprValuA_X0_I0+6], v[vgprLocalReadAddrA+0] offset:1312 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=24 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 63-cycle>
ds_load_u8 v[vgprValuA_X0_I0_D1+6], v[vgprLocalReadAddrA+0] offset:1344 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=25 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 65-cycle>
ds_load_u8 v[vgprValuA_X0_I0_D2+6], v[vgprLocalReadAddrA+0] offset:1376 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=26 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 67-cycle>
ds_load_u8 v[vgprValuA_X0_I0_D3+6], v[vgprLocalReadAddrA+0] offset:1408 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=27 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 69-cycle>
ds_load_u8 v[vgprValuA_X0_I0+7], v[vgprLocalReadAddrA+0] offset:1440 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=28 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 71-cycle>
ds_load_u8 v[vgprValuA_X0_I0_D1+7], v[vgprLocalReadAddrA+0] offset:1472 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=29 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 73-cycle>
ds_load_u8 v[vgprValuA_X0_I0_D2+7], v[vgprLocalReadAddrA+0] offset:1504 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=30 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 75-cycle>
ds_load_u8 v[vgprValuA_X0_I0_D3+7], v[vgprLocalReadAddrA+0] offset:1536 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=31 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 77-cycle>
ds_load_u8 v[vgprValuB_X0_I0+0], v[vgprLocalReadAddrB+0] offset:0 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 79-cycle>
ds_load_u8 v[vgprValuB_X0_I0_D1+0], v[vgprLocalReadAddrB+0] offset:16 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 81-cycle>
ds_load_u8 v[vgprValuB_X0_I0_D2+0], v[vgprLocalReadAddrB+0] offset:32 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=2 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 83-cycle>
ds_load_u8 v[vgprValuB_X0_I0_D3+0], v[vgprLocalReadAddrB+0] offset:48 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=3 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 85-cycle>
ds_load_u8 v[vgprValuB_X0_I0+1], v[vgprLocalReadAddrB+0] offset:64 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=4 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 87-cycle>
ds_load_u8 v[vgprValuB_X0_I0_D1+1], v[vgprLocalReadAddrB+0] offset:80 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=5 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 89-cycle>
ds_load_u8 v[vgprValuB_X0_I0_D2+1], v[vgprLocalReadAddrB+0] offset:96 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=6 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 91-cycle>
ds_load_u8 v[vgprValuB_X0_I0_D3+1], v[vgprLocalReadAddrB+0] offset:112 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=7 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 93-cycle>
ds_load_u8 v[vgprValuB_X0_I0+2], v[vgprLocalReadAddrB+0] offset:128 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=8 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 95-cycle>
ds_load_u8 v[vgprValuB_X0_I0_D1+2], v[vgprLocalReadAddrB+0] offset:144 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=9 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 97-cycle>
ds_load_u8 v[vgprValuB_X0_I0_D2+2], v[vgprLocalReadAddrB+0] offset:160 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=10 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 99-cycle>
ds_load_u8 v[vgprValuB_X0_I0_D3+2], v[vgprLocalReadAddrB+0] offset:176 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=11 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 101-cycle>
s_wait_alu depctr_va_vdst(12)                      // <This is 102-cycle>
ds_load_u8 v[vgprValuB_X0_I0+3], v[vgprLocalReadAddrB+0] offset:192 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=12 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 103-cycle>
ds_load_u8 v[vgprValuB_X0_I0_D1+3], v[vgprLocalReadAddrB+0] offset:208 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=13 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 105-cycle>
ds_load_u8 v[vgprValuB_X0_I0_D2+3], v[vgprLocalReadAddrB+0] offset:224 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=14 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 107-cycle>
ds_load_u8 v[vgprValuB_X0_I0_D3+3], v[vgprLocalReadAddrB+0] offset:240 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=15 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 109-cycle>
s_wait_alu depctr_va_vdst(9)                       // <This is 110-cycle>
ds_load_u8 v[vgprValuB_X0_I0+4], v[vgprLocalReadAddrB+0] offset:544 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=16 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 111-cycle>
ds_load_u8 v[vgprValuB_X0_I0_D1+4], v[vgprLocalReadAddrB+0] offset:560 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=17 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 113-cycle>
ds_load_u8 v[vgprValuB_X0_I0_D2+4], v[vgprLocalReadAddrB+0] offset:576 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=18 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 115-cycle>
ds_load_u8 v[vgprValuB_X0_I0_D3+4], v[vgprLocalReadAddrB+0] offset:592 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=19 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 117-cycle>
s_wait_alu depctr_va_vdst(6)                       // <This is 118-cycle>
ds_load_u8 v[vgprValuB_X0_I0+5], v[vgprLocalReadAddrB+0] offset:608 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=20 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 119-cycle>
ds_load_u8 v[vgprValuB_X0_I0_D1+5], v[vgprLocalReadAddrB+0] offset:624 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=21 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 121-cycle>
ds_load_u8 v[vgprValuB_X0_I0_D2+5], v[vgprLocalReadAddrB+0] offset:640 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=22 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 123-cycle>
ds_load_u8 v[vgprValuB_X0_I0_D3+5], v[vgprLocalReadAddrB+0] offset:656 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=23 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 125-cycle>
s_wait_alu depctr_va_vdst(3)                       // <This is 126-cycle>
ds_load_u8 v[vgprValuB_X0_I0+6], v[vgprLocalReadAddrB+0] offset:672 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=24 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 127-cycle>
ds_load_u8 v[vgprValuB_X0_I0_D1+6], v[vgprLocalReadAddrB+0] offset:688 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=25 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 129-cycle>
ds_load_u8 v[vgprValuB_X0_I0_D2+6], v[vgprLocalReadAddrB+0] offset:704 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=26 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 131-cycle>
ds_load_u8 v[vgprValuB_X0_I0_D3+6], v[vgprLocalReadAddrB+0] offset:720 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=27 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 133-cycle>
s_wait_alu depctr_va_vdst(0)                       // <This is 134-cycle>
ds_load_u8 v[vgprValuB_X0_I0+7], v[vgprLocalReadAddrB+0] offset:736 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=28 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 135-cycle>
ds_load_u8 v[vgprValuB_X0_I0_D1+7], v[vgprLocalReadAddrB+0] offset:752 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=29 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 137-cycle>
ds_load_u8 v[vgprValuB_X0_I0_D2+7], v[vgprLocalReadAddrB+0] offset:768 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=30 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 139-cycle>
ds_load_u8 v[vgprValuB_X0_I0_D3+7], v[vgprLocalReadAddrB+0] offset:784 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=31 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 141-cycle>

/* global read inc A loopL */
s_cmp_eq_u32 s[sgprLoopCounterL], s[sgprStaggerUIter] // Is this the wrapIter? <This is 142-cycle>
s_cselect_b32 s66, s[sgprWrapUA+0], s[sgprGlobalReadIncsA+0] // incLower <- ? <This is 143-cycle>
s_cselect_b32 s67, s[sgprWrapUA+1], 0              // incUpper <- ? <This is 144-cycle>
s_add_u32 s[sgprSrdA+0], s[sgprSrdA+0], s66        // gra SRD += inc(lower) <This is 145-cycle>
s_addc_u32 s[sgprSrdA+1], s[sgprSrdA+1], s67       // gra SRD += inc(upper) <This is 146-cycle>
s_sub_u32 s[sgprShadowLimitA+0], s[sgprShadowLimitA+0], s66 // limit -= inc) <This is 147-cycle>
s_subb_u32 s[sgprShadowLimitA+1], s[sgprShadowLimitA+1], s67 // limit -= inc) <This is 148-cycle>
s_cmp_eq_u32 s[sgprShadowLimitA+1], 0              // are we within 2^32? <This is 149-cycle>
s_cselect_b32 s[sgprSrdA+2], s[sgprShadowLimitA+0], BufferLimit // Move shadow to real if we are within 2^32 <This is 150-cycle>
// Shift num records for gfx125x
s_and_b32 s8, s[sgprSrdA+2], 127                   // <This is 151-cycle>
s_lshl_b32 s8, s8, 25                              // <This is 152-cycle>
s_and_b32 s[sgprSrdA+1], s[sgprSrdA+1], 33554431   // <This is 153-cycle>
s_or_b32 s[sgprSrdA+1], s[sgprSrdA+1], s8          // <This is 154-cycle>
s_lshr_b32 s[sgprSrdA+2], s[sgprSrdA+2], 7         // <This is 155-cycle>

/* global read inc B loopL */
s_cmp_eq_u32 s[sgprLoopCounterL], s[sgprStaggerUIter] // Is this the wrapIter? <This is 156-cycle>
s_cselect_b32 s66, s[sgprWrapUB+0], s[sgprGlobalReadIncsB+0] // incLower <- ? <This is 157-cycle>
s_cselect_b32 s67, s[sgprWrapUB+1], 0              // incUpper <- ? <This is 158-cycle>
s_add_u32 s[sgprSrdB+0], s[sgprSrdB+0], s66        // gra SRD += inc(lower) <This is 159-cycle>
s_addc_u32 s[sgprSrdB+1], s[sgprSrdB+1], s67       // gra SRD += inc(upper) <This is 160-cycle>
s_sub_u32 s[sgprShadowLimitB+0], s[sgprShadowLimitB+0], s66 // limit -= inc) <This is 161-cycle>
s_subb_u32 s[sgprShadowLimitB+1], s[sgprShadowLimitB+1], s67 // limit -= inc) <This is 162-cycle>
s_cmp_eq_u32 s[sgprShadowLimitB+1], 0              // are we within 2^32? <This is 163-cycle>
s_cselect_b32 s[sgprSrdB+2], s[sgprShadowLimitB+0], BufferLimit // Move shadow to real if we are within 2^32 <This is 164-cycle>
// Shift num records for gfx125x
s_and_b32 s8, s[sgprSrdB+2], 127                   // <This is 165-cycle>
s_lshl_b32 s8, s8, 25                              // <This is 166-cycle>
s_and_b32 s[sgprSrdB+1], s[sgprSrdB+1], 33554431   // <This is 167-cycle>
s_or_b32 s[sgprSrdB+1], s[sgprSrdB+1], s8          // <This is 168-cycle>
s_lshr_b32 s[sgprSrdB+2], s[sgprSrdB+2], 7         // <This is 169-cycle>
/* 1 LDS buffer: read-sync-write */
s_wait_dscnt 0                                     // <This is 170-cycle>
s_barrier_signal -1                                // <This is 171-cycle>
s_barrier_wait -1                                  // <This is 181-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 47                                  // wait for global read before writing to local <This is 182-cycle>
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+0] offset:0 // lwoA_0_0_0_0 = (0*LSCA) + (0*LSPA)(*MT0I+PAD) = 0 sync LDS0 <This is 182-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 183-cycle>
buffer_load_d16_u8 v[vgprG2LA+0], v[vgprGlobalReadOffsetA+0], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_0_0 <This is 196-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 47                                  // wait for global read before writing to local <This is 197-cycle>
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+16] offset:64 // lwoA_0_0_1_0 = (0*LSCA) + (1*LSPA)(*MT0I+PAD) = 64 sync LDS0 <This is 197-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 198-cycle>
buffer_load_d16_u8 v[vgprG2LA+16], v[vgprGlobalReadOffsetA+1], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_1_0 <This is 211-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 47                                  // wait for global read before writing to local <This is 212-cycle>
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+32] offset:128 // lwoA_0_0_2_0 = (0*LSCA) + (2*LSPA)(*MT0I+PAD) = 128 sync LDS0 <This is 212-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 213-cycle>
buffer_load_d16_u8 v[vgprG2LA+32], v[vgprGlobalReadOffsetA+2], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_2_0 <This is 226-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 47                                  // wait for global read before writing to local <This is 227-cycle>
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+48] offset:192 // lwoA_0_0_3_0 = (0*LSCA) + (3*LSPA)(*MT0I+PAD) = 192 sync LDS0 <This is 227-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 228-cycle>
buffer_load_d16_u8 v[vgprG2LA+48], v[vgprGlobalReadOffsetA+3], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_3_0 <This is 241-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 47                                  // wait for global read before writing to local <This is 242-cycle>
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+1] offset:256 // lwoA_0_0_4_0 = (0*LSCA) + (4*LSPA)(*MT0I+PAD) = 256 sync LDS0 <This is 242-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 243-cycle>
buffer_load_d16_u8 v[vgprG2LA+1], v[vgprGlobalReadOffsetA+4], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_4_0 <This is 256-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 47                                  // wait for global read before writing to local <This is 257-cycle>
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+17] offset:320 // lwoA_0_0_5_0 = (0*LSCA) + (5*LSPA)(*MT0I+PAD) = 320 sync LDS0 <This is 257-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 258-cycle>
buffer_load_d16_u8 v[vgprG2LA+17], v[vgprGlobalReadOffsetA+5], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_5_0 <This is 271-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 47                                  // wait for global read before writing to local <This is 272-cycle>
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+33] offset:384 // lwoA_0_0_6_0 = (0*LSCA) + (6*LSPA)(*MT0I+PAD) = 384 sync LDS0 <This is 272-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 273-cycle>
buffer_load_d16_u8 v[vgprG2LA+33], v[vgprGlobalReadOffsetA+6], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_6_0 <This is 286-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 47                                  // wait for global read before writing to local <This is 287-cycle>
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+49] offset:448 // lwoA_0_0_7_0 = (0*LSCA) + (7*LSPA)(*MT0I+PAD) = 448 sync LDS0 <This is 287-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 288-cycle>
buffer_load_d16_u8 v[vgprG2LA+49], v[vgprGlobalReadOffsetA+7], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_7_0 <This is 301-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 47                                  // wait for global read before writing to local <This is 302-cycle>
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+2] offset:528 // lwoA_0_0_8_0 = (0*LSCA) + (8*LSPA)(*MT0I+PAD) = 528 sync LDS0 <This is 302-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 303-cycle>
buffer_load_d16_u8 v[vgprG2LA+2], v[vgprGlobalReadOffsetA+8], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_8_0 <This is 316-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 47                                  // wait for global read before writing to local <This is 317-cycle>
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+18] offset:592 // lwoA_0_0_9_0 = (0*LSCA) + (9*LSPA)(*MT0I+PAD) = 592 sync LDS0 <This is 317-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 318-cycle>
buffer_load_d16_u8 v[vgprG2LA+18], v[vgprGlobalReadOffsetA+9], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_9_0 <This is 331-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 47                                  // wait for global read before writing to local <This is 332-cycle>
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+34] offset:656 // lwoA_0_0_10_0 = (0*LSCA) + (10*LSPA)(*MT0I+PAD) = 656 sync LDS0 <This is 332-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 333-cycle>
buffer_load_d16_u8 v[vgprG2LA+34], v[vgprGlobalReadOffsetA+10], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_10_0 <This is 346-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 47                                  // wait for global read before writing to local <This is 347-cycle>
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+50] offset:720 // lwoA_0_0_11_0 = (0*LSCA) + (11*LSPA)(*MT0I+PAD) = 720 sync LDS0 <This is 347-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 348-cycle>
buffer_load_d16_u8 v[vgprG2LA+50], v[vgprGlobalReadOffsetA+11], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_11_0 <This is 361-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 47                                  // wait for global read before writing to local <This is 362-cycle>
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+3] offset:784 // lwoA_0_0_12_0 = (0*LSCA) + (12*LSPA)(*MT0I+PAD) = 784 sync LDS0 <This is 362-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 363-cycle>
buffer_load_d16_u8 v[vgprG2LA+3], v[vgprGlobalReadOffsetA+12], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_12_0 <This is 376-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 47                                  // wait for global read before writing to local <This is 377-cycle>
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+19] offset:848 // lwoA_0_0_13_0 = (0*LSCA) + (13*LSPA)(*MT0I+PAD) = 848 sync LDS0 <This is 377-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 378-cycle>
buffer_load_d16_u8 v[vgprG2LA+19], v[vgprGlobalReadOffsetA+13], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_13_0 <This is 391-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 47                                  // wait for global read before writing to local <This is 392-cycle>
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+35] offset:912 // lwoA_0_0_14_0 = (0*LSCA) + (14*LSPA)(*MT0I+PAD) = 912 sync LDS0 <This is 392-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 393-cycle>
buffer_load_d16_u8 v[vgprG2LA+35], v[vgprGlobalReadOffsetA+14], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_14_0 <This is 406-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 47                                  // wait for global read before writing to local <This is 407-cycle>
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+51] offset:976 // lwoA_0_0_15_0 = (0*LSCA) + (15*LSPA)(*MT0I+PAD) = 976 sync LDS0 <This is 407-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 408-cycle>
buffer_load_d16_u8 v[vgprG2LA+51], v[vgprGlobalReadOffsetA+15], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_15_0 <This is 421-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 47                                  // wait for global read before writing to local <This is 422-cycle>
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+4] offset:1056 // lwoA_0_0_16_0 = (0*LSCA) + (16*LSPA)(*MT0I+PAD) = 1056 sync LDS0 <This is 422-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 423-cycle>
buffer_load_d16_u8 v[vgprG2LA+4], v[vgprGlobalReadOffsetA+16], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_16_0 <This is 436-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 47                                  // wait for global read before writing to local <This is 437-cycle>
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+20] offset:1120 // lwoA_0_0_17_0 = (0*LSCA) + (17*LSPA)(*MT0I+PAD) = 1120 sync LDS0 <This is 437-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 438-cycle>
buffer_load_d16_u8 v[vgprG2LA+20], v[vgprGlobalReadOffsetA+17], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_17_0 <This is 451-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 47                                  // wait for global read before writing to local <This is 452-cycle>
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+36] offset:1184 // lwoA_0_0_18_0 = (0*LSCA) + (18*LSPA)(*MT0I+PAD) = 1184 sync LDS0 <This is 452-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 453-cycle>
buffer_load_d16_u8 v[vgprG2LA+36], v[vgprGlobalReadOffsetA+18], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_18_0 <This is 466-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 47                                  // wait for global read before writing to local <This is 467-cycle>
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+52] offset:1248 // lwoA_0_0_19_0 = (0*LSCA) + (19*LSPA)(*MT0I+PAD) = 1248 sync LDS0 <This is 467-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 468-cycle>
buffer_load_d16_u8 v[vgprG2LA+52], v[vgprGlobalReadOffsetA+19], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_19_0 <This is 481-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 47                                  // wait for global read before writing to local <This is 482-cycle>
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+5] offset:1312 // lwoA_0_0_20_0 = (0*LSCA) + (20*LSPA)(*MT0I+PAD) = 1312 sync LDS0 <This is 482-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 483-cycle>
buffer_load_d16_u8 v[vgprG2LA+5], v[vgprGlobalReadOffsetA+20], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_20_0 <This is 496-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 47                                  // wait for global read before writing to local <This is 497-cycle>
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+21] offset:1376 // lwoA_0_0_21_0 = (0*LSCA) + (21*LSPA)(*MT0I+PAD) = 1376 sync LDS0 <This is 497-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 498-cycle>
buffer_load_d16_u8 v[vgprG2LA+21], v[vgprGlobalReadOffsetA+21], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_21_0 <This is 511-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 47                                  // wait for global read before writing to local <This is 512-cycle>
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+37] offset:1440 // lwoA_0_0_22_0 = (0*LSCA) + (22*LSPA)(*MT0I+PAD) = 1440 sync LDS0 <This is 512-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 513-cycle>
buffer_load_d16_u8 v[vgprG2LA+37], v[vgprGlobalReadOffsetA+22], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_22_0 <This is 526-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 47                                  // wait for global read before writing to local <This is 527-cycle>
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+53] offset:1504 // lwoA_0_0_23_0 = (0*LSCA) + (23*LSPA)(*MT0I+PAD) = 1504 sync LDS0 <This is 527-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 528-cycle>
buffer_load_d16_u8 v[vgprG2LA+53], v[vgprGlobalReadOffsetA+23], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_23_0 <This is 541-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 47                                  // wait for global read before writing to local <This is 542-cycle>
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+6] offset:1584 // lwoA_0_0_24_0 = (0*LSCA) + (24*LSPA)(*MT0I+PAD) = 1584 sync LDS0 <This is 542-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 543-cycle>
buffer_load_d16_u8 v[vgprG2LA+6], v[vgprGlobalReadOffsetA+24], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_24_0 <This is 556-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 47                                  // wait for global read before writing to local <This is 557-cycle>
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+22] offset:1648 // lwoA_0_0_25_0 = (0*LSCA) + (25*LSPA)(*MT0I+PAD) = 1648 sync LDS0 <This is 557-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 558-cycle>
buffer_load_d16_u8 v[vgprG2LA+22], v[vgprGlobalReadOffsetA+25], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_25_0 <This is 571-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 47                                  // wait for global read before writing to local <This is 572-cycle>
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+38] offset:1712 // lwoA_0_0_26_0 = (0*LSCA) + (26*LSPA)(*MT0I+PAD) = 1712 sync LDS0 <This is 572-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 573-cycle>
buffer_load_d16_u8 v[vgprG2LA+38], v[vgprGlobalReadOffsetA+26], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_26_0 <This is 586-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 47                                  // wait for global read before writing to local <This is 587-cycle>
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+54] offset:1776 // lwoA_0_0_27_0 = (0*LSCA) + (27*LSPA)(*MT0I+PAD) = 1776 sync LDS0 <This is 587-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 588-cycle>
buffer_load_d16_u8 v[vgprG2LA+54], v[vgprGlobalReadOffsetA+27], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_27_0 <This is 601-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 47                                  // wait for global read before writing to local <This is 602-cycle>
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+7] offset:1840 // lwoA_0_0_28_0 = (0*LSCA) + (28*LSPA)(*MT0I+PAD) = 1840 sync LDS0 <This is 602-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 603-cycle>
buffer_load_d16_u8 v[vgprG2LA+7], v[vgprGlobalReadOffsetA+28], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_28_0 <This is 616-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 47                                  // wait for global read before writing to local <This is 617-cycle>
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+23] offset:1904 // lwoA_0_0_29_0 = (0*LSCA) + (29*LSPA)(*MT0I+PAD) = 1904 sync LDS0 <This is 617-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 618-cycle>
buffer_load_d16_u8 v[vgprG2LA+23], v[vgprGlobalReadOffsetA+29], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_29_0 <This is 631-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 47                                  // wait for global read before writing to local <This is 632-cycle>
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+39] offset:1968 // lwoA_0_0_30_0 = (0*LSCA) + (30*LSPA)(*MT0I+PAD) = 1968 sync LDS0 <This is 632-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 633-cycle>
buffer_load_d16_u8 v[vgprG2LA+39], v[vgprGlobalReadOffsetA+30], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_30_0 <This is 646-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 47                                  // wait for global read before writing to local <This is 647-cycle>
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+55] offset:2032 // lwoA_0_0_31_0 = (0*LSCA) + (31*LSPA)(*MT0I+PAD) = 2032 sync LDS0 <This is 647-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 648-cycle>
buffer_load_d16_u8 v[vgprG2LA+55], v[vgprGlobalReadOffsetA+31], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_31_0 <This is 661-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 47                                  // wait for global read before writing to local <This is 662-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+0] offset:0 // lwoB_0_0_0_0 = (0*LSCB) + (0*LSPB)(*MT1J+PAD) = 0 sync LDS0 <This is 662-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 663-cycle>
buffer_load_d16_u8 v[vgprG2LB+0], v[vgprGlobalReadOffsetB+0], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_0_0 <This is 676-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 47                                  // wait for global read before writing to local <This is 677-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+8] offset:64 // lwoB_0_0_1_0 = (0*LSCB) + (1*LSPB)(*MT1J+PAD) = 64 sync LDS0 <This is 677-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 678-cycle>
buffer_load_d16_u8 v[vgprG2LB+8], v[vgprGlobalReadOffsetB+1], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_1_0 <This is 691-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 47                                  // wait for global read before writing to local <This is 692-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+16] offset:128 // lwoB_0_0_2_0 = (0*LSCB) + (2*LSPB)(*MT1J+PAD) = 128 sync LDS0 <This is 692-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 693-cycle>
buffer_load_d16_u8 v[vgprG2LB+16], v[vgprGlobalReadOffsetB+2], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_2_0 <This is 706-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 47                                  // wait for global read before writing to local <This is 707-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+24] offset:192 // lwoB_0_0_3_0 = (0*LSCB) + (3*LSPB)(*MT1J+PAD) = 192 sync LDS0 <This is 707-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 708-cycle>
buffer_load_d16_u8 v[vgprG2LB+24], v[vgprGlobalReadOffsetB+3], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_3_0 <This is 721-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 47                                  // wait for global read before writing to local <This is 722-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+1] offset:272 // lwoB_0_0_4_0 = (0*LSCB) + (4*LSPB)(*MT1J+PAD) = 272 sync LDS0 <This is 722-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 723-cycle>
buffer_load_d16_u8 v[vgprG2LB+1], v[vgprGlobalReadOffsetB+4], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_4_0 <This is 736-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 47                                  // wait for global read before writing to local <This is 737-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+9] offset:336 // lwoB_0_0_5_0 = (0*LSCB) + (5*LSPB)(*MT1J+PAD) = 336 sync LDS0 <This is 737-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 738-cycle>
buffer_load_d16_u8 v[vgprG2LB+9], v[vgprGlobalReadOffsetB+5], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_5_0 <This is 751-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 47                                  // wait for global read before writing to local <This is 752-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+17] offset:400 // lwoB_0_0_6_0 = (0*LSCB) + (6*LSPB)(*MT1J+PAD) = 400 sync LDS0 <This is 752-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 753-cycle>
buffer_load_d16_u8 v[vgprG2LB+17], v[vgprGlobalReadOffsetB+6], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_6_0 <This is 766-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 47                                  // wait for global read before writing to local <This is 767-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+25] offset:464 // lwoB_0_0_7_0 = (0*LSCB) + (7*LSPB)(*MT1J+PAD) = 464 sync LDS0 <This is 767-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 768-cycle>
buffer_load_d16_u8 v[vgprG2LB+25], v[vgprGlobalReadOffsetB+7], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_7_0 <This is 781-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 47                                  // wait for global read before writing to local <This is 782-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+2] offset:544 // lwoB_0_0_8_0 = (0*LSCB) + (8*LSPB)(*MT1J+PAD) = 544 sync LDS0 <This is 782-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 783-cycle>
buffer_load_d16_u8 v[vgprG2LB+2], v[vgprGlobalReadOffsetB+8], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_8_0 <This is 796-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 47                                  // wait for global read before writing to local <This is 797-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+10] offset:608 // lwoB_0_0_9_0 = (0*LSCB) + (9*LSPB)(*MT1J+PAD) = 608 sync LDS0 <This is 797-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 798-cycle>
buffer_load_d16_u8 v[vgprG2LB+10], v[vgprGlobalReadOffsetB+9], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_9_0 <This is 811-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 47                                  // wait for global read before writing to local <This is 812-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+18] offset:672 // lwoB_0_0_10_0 = (0*LSCB) + (10*LSPB)(*MT1J+PAD) = 672 sync LDS0 <This is 812-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 813-cycle>
buffer_load_d16_u8 v[vgprG2LB+18], v[vgprGlobalReadOffsetB+10], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_10_0 <This is 826-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 47                                  // wait for global read before writing to local <This is 827-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+26] offset:736 // lwoB_0_0_11_0 = (0*LSCB) + (11*LSPB)(*MT1J+PAD) = 736 sync LDS0 <This is 827-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 828-cycle>
buffer_load_d16_u8 v[vgprG2LB+26], v[vgprGlobalReadOffsetB+11], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_11_0 <This is 841-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 47                                  // wait for global read before writing to local <This is 842-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+3] offset:816 // lwoB_0_0_12_0 = (0*LSCB) + (12*LSPB)(*MT1J+PAD) = 816 sync LDS0 <This is 842-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 843-cycle>
buffer_load_d16_u8 v[vgprG2LB+3], v[vgprGlobalReadOffsetB+12], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_12_0 <This is 856-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 47                                  // wait for global read before writing to local <This is 857-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+11] offset:880 // lwoB_0_0_13_0 = (0*LSCB) + (13*LSPB)(*MT1J+PAD) = 880 sync LDS0 <This is 857-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 858-cycle>
buffer_load_d16_u8 v[vgprG2LB+11], v[vgprGlobalReadOffsetB+13], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_13_0 <This is 871-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 47                                  // wait for global read before writing to local <This is 872-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+19] offset:944 // lwoB_0_0_14_0 = (0*LSCB) + (14*LSPB)(*MT1J+PAD) = 944 sync LDS0 <This is 872-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 873-cycle>
buffer_load_d16_u8 v[vgprG2LB+19], v[vgprGlobalReadOffsetB+14], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_14_0 <This is 886-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 47                                  // wait for global read before writing to local <This is 887-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+27] offset:1008 // lwoB_0_0_15_0 = (0*LSCB) + (15*LSPB)(*MT1J+PAD) = 1008 sync LDS0 <This is 887-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 888-cycle>
buffer_load_d16_u8 v[vgprG2LB+27], v[vgprGlobalReadOffsetB+15], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_15_0 <This is 901-cycle>

/* local write swap offsets a */

/* local write swap offsets b */

/* local read swap offsets a */

/* local read swap offsets b */

/* local read init pointers a */

/* localReadInitPointers */

/* local read init pointers b */

/* localReadInitPointers */
/* pack scheduling: packAIdx:24, packBIdx:24 */
v_lshl_or_b32 v[vgprValuA_X0_I0+0], v[vgprValuA_X0_I0_D1+0], 8, v[vgprValuA_X0_I0+0] // pack two int8 Vgpr to one half Vgpr <This is 902-cycle>
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+0], v[vgprValuA_X0_I0_D3+0], 8, v[vgprValuA_X0_I0_D2+0] // pack two int8 Vgpr to one half Vgpr <This is 903-cycle>
v_lshl_or_b32 v[vgprValuA_X0_I0+0], v[vgprValuA_X0_I0_D2+0], 0x10, v[vgprValuA_X0_I0+0] // pack two half Vgpr to one Vgpr <This is 904-cycle>
v_lshl_or_b32 v[vgprValuA_X0_I0+1], v[vgprValuA_X0_I0_D1+1], 8, v[vgprValuA_X0_I0+1] // pack two int8 Vgpr to one half Vgpr <This is 905-cycle>
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+1], v[vgprValuA_X0_I0_D3+1], 8, v[vgprValuA_X0_I0_D2+1] // pack two int8 Vgpr to one half Vgpr <This is 906-cycle>
v_lshl_or_b32 v[vgprValuA_X0_I0+1], v[vgprValuA_X0_I0_D2+1], 0x10, v[vgprValuA_X0_I0+1] // pack two half Vgpr to one Vgpr <This is 907-cycle>
v_lshl_or_b32 v[vgprValuA_X0_I0+2], v[vgprValuA_X0_I0_D1+2], 8, v[vgprValuA_X0_I0+2] // pack two int8 Vgpr to one half Vgpr <This is 908-cycle>
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+2], v[vgprValuA_X0_I0_D3+2], 8, v[vgprValuA_X0_I0_D2+2] // pack two int8 Vgpr to one half Vgpr <This is 909-cycle>
v_lshl_or_b32 v[vgprValuA_X0_I0+2], v[vgprValuA_X0_I0_D2+2], 0x10, v[vgprValuA_X0_I0+2] // pack two half Vgpr to one Vgpr <This is 910-cycle>
v_lshl_or_b32 v[vgprValuA_X0_I0+3], v[vgprValuA_X0_I0_D1+3], 8, v[vgprValuA_X0_I0+3] // pack two int8 Vgpr to one half Vgpr <This is 911-cycle>
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+3], v[vgprValuA_X0_I0_D3+3], 8, v[vgprValuA_X0_I0_D2+3] // pack two int8 Vgpr to one half Vgpr <This is 912-cycle>
v_lshl_or_b32 v[vgprValuA_X0_I0+3], v[vgprValuA_X0_I0_D2+3], 0x10, v[vgprValuA_X0_I0+3] // pack two half Vgpr to one Vgpr <This is 913-cycle>
v_lshl_or_b32 v[vgprValuA_X0_I0+4], v[vgprValuA_X0_I0_D1+4], 8, v[vgprValuA_X0_I0+4] // pack two int8 Vgpr to one half Vgpr <This is 914-cycle>
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+4], v[vgprValuA_X0_I0_D3+4], 8, v[vgprValuA_X0_I0_D2+4] // pack two int8 Vgpr to one half Vgpr <This is 915-cycle>
v_lshl_or_b32 v[vgprValuA_X0_I0+4], v[vgprValuA_X0_I0_D2+4], 0x10, v[vgprValuA_X0_I0+4] // pack two half Vgpr to one Vgpr <This is 916-cycle>
v_lshl_or_b32 v[vgprValuA_X0_I0+5], v[vgprValuA_X0_I0_D1+5], 8, v[vgprValuA_X0_I0+5] // pack two int8 Vgpr to one half Vgpr <This is 917-cycle>
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+5], v[vgprValuA_X0_I0_D3+5], 8, v[vgprValuA_X0_I0_D2+5] // pack two int8 Vgpr to one half Vgpr <This is 918-cycle>
v_lshl_or_b32 v[vgprValuA_X0_I0+5], v[vgprValuA_X0_I0_D2+5], 0x10, v[vgprValuA_X0_I0+5] // pack two half Vgpr to one Vgpr <This is 919-cycle>
v_lshl_or_b32 v[vgprValuA_X0_I0+6], v[vgprValuA_X0_I0_D1+6], 8, v[vgprValuA_X0_I0+6] // pack two int8 Vgpr to one half Vgpr <This is 920-cycle>
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+6], v[vgprValuA_X0_I0_D3+6], 8, v[vgprValuA_X0_I0_D2+6] // pack two int8 Vgpr to one half Vgpr <This is 921-cycle>
v_lshl_or_b32 v[vgprValuA_X0_I0+6], v[vgprValuA_X0_I0_D2+6], 0x10, v[vgprValuA_X0_I0+6] // pack two half Vgpr to one Vgpr <This is 922-cycle>
v_lshl_or_b32 v[vgprValuA_X0_I0+7], v[vgprValuA_X0_I0_D1+7], 8, v[vgprValuA_X0_I0+7] // pack two int8 Vgpr to one half Vgpr <This is 923-cycle>
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+7], v[vgprValuA_X0_I0_D3+7], 8, v[vgprValuA_X0_I0_D2+7] // pack two int8 Vgpr to one half Vgpr <This is 924-cycle>
v_lshl_or_b32 v[vgprValuA_X0_I0+7], v[vgprValuA_X0_I0_D2+7], 0x10, v[vgprValuA_X0_I0+7] // pack two half Vgpr to one Vgpr <This is 925-cycle>
v_lshl_or_b32 v[vgprValuB_X0_I0+0], v[vgprValuB_X0_I0_D1+0], 8, v[vgprValuB_X0_I0+0] // pack two int8 Vgpr to one half Vgpr <This is 926-cycle>
v_lshl_or_b32 v[vgprValuB_X0_I0_D2+0], v[vgprValuB_X0_I0_D3+0], 8, v[vgprValuB_X0_I0_D2+0] // pack two int8 Vgpr to one half Vgpr <This is 927-cycle>
v_lshl_or_b32 v[vgprValuB_X0_I0+0], v[vgprValuB_X0_I0_D2+0], 0x10, v[vgprValuB_X0_I0+0] // pack two half Vgpr to one Vgpr <This is 928-cycle>
v_lshl_or_b32 v[vgprValuB_X0_I0+1], v[vgprValuB_X0_I0_D1+1], 8, v[vgprValuB_X0_I0+1] // pack two int8 Vgpr to one half Vgpr <This is 929-cycle>
v_lshl_or_b32 v[vgprValuB_X0_I0_D2+1], v[vgprValuB_X0_I0_D3+1], 8, v[vgprValuB_X0_I0_D2+1] // pack two int8 Vgpr to one half Vgpr <This is 930-cycle>
v_lshl_or_b32 v[vgprValuB_X0_I0+1], v[vgprValuB_X0_I0_D2+1], 0x10, v[vgprValuB_X0_I0+1] // pack two half Vgpr to one Vgpr <This is 931-cycle>
v_lshl_or_b32 v[vgprValuB_X0_I0+2], v[vgprValuB_X0_I0_D1+2], 8, v[vgprValuB_X0_I0+2] // pack two int8 Vgpr to one half Vgpr <This is 932-cycle>
v_lshl_or_b32 v[vgprValuB_X0_I0_D2+2], v[vgprValuB_X0_I0_D3+2], 8, v[vgprValuB_X0_I0_D2+2] // pack two int8 Vgpr to one half Vgpr <This is 933-cycle>
v_lshl_or_b32 v[vgprValuB_X0_I0+2], v[vgprValuB_X0_I0_D2+2], 0x10, v[vgprValuB_X0_I0+2] // pack two half Vgpr to one Vgpr <This is 934-cycle>
v_lshl_or_b32 v[vgprValuB_X0_I0+3], v[vgprValuB_X0_I0_D1+3], 8, v[vgprValuB_X0_I0+3] // pack two int8 Vgpr to one half Vgpr <This is 935-cycle>
v_lshl_or_b32 v[vgprValuB_X0_I0_D2+3], v[vgprValuB_X0_I0_D3+3], 8, v[vgprValuB_X0_I0_D2+3] // pack two int8 Vgpr to one half Vgpr <This is 936-cycle>
v_lshl_or_b32 v[vgprValuB_X0_I0+3], v[vgprValuB_X0_I0_D2+3], 0x10, v[vgprValuB_X0_I0+3] // pack two half Vgpr to one Vgpr <This is 937-cycle>
v_lshl_or_b32 v[vgprValuB_X0_I0+4], v[vgprValuB_X0_I0_D1+4], 8, v[vgprValuB_X0_I0+4] // pack two int8 Vgpr to one half Vgpr <This is 938-cycle>
v_lshl_or_b32 v[vgprValuB_X0_I0_D2+4], v[vgprValuB_X0_I0_D3+4], 8, v[vgprValuB_X0_I0_D2+4] // pack two int8 Vgpr to one half Vgpr <This is 939-cycle>
v_lshl_or_b32 v[vgprValuB_X0_I0+4], v[vgprValuB_X0_I0_D2+4], 0x10, v[vgprValuB_X0_I0+4] // pack two half Vgpr to one Vgpr <This is 940-cycle>
v_lshl_or_b32 v[vgprValuB_X0_I0+5], v[vgprValuB_X0_I0_D1+5], 8, v[vgprValuB_X0_I0+5] // pack two int8 Vgpr to one half Vgpr <This is 941-cycle>
v_lshl_or_b32 v[vgprValuB_X0_I0_D2+5], v[vgprValuB_X0_I0_D3+5], 8, v[vgprValuB_X0_I0_D2+5] // pack two int8 Vgpr to one half Vgpr <This is 942-cycle>
v_lshl_or_b32 v[vgprValuB_X0_I0+5], v[vgprValuB_X0_I0_D2+5], 0x10, v[vgprValuB_X0_I0+5] // pack two half Vgpr to one Vgpr <This is 943-cycle>
v_lshl_or_b32 v[vgprValuB_X0_I0+6], v[vgprValuB_X0_I0_D1+6], 8, v[vgprValuB_X0_I0+6] // pack two int8 Vgpr to one half Vgpr <This is 944-cycle>
v_lshl_or_b32 v[vgprValuB_X0_I0_D2+6], v[vgprValuB_X0_I0_D3+6], 8, v[vgprValuB_X0_I0_D2+6] // pack two int8 Vgpr to one half Vgpr <This is 945-cycle>
v_lshl_or_b32 v[vgprValuB_X0_I0+6], v[vgprValuB_X0_I0_D2+6], 0x10, v[vgprValuB_X0_I0+6] // pack two half Vgpr to one Vgpr <This is 946-cycle>
v_lshl_or_b32 v[vgprValuB_X0_I0+7], v[vgprValuB_X0_I0_D1+7], 8, v[vgprValuB_X0_I0+7] // pack two int8 Vgpr to one half Vgpr <This is 947-cycle>
v_lshl_or_b32 v[vgprValuB_X0_I0_D2+7], v[vgprValuB_X0_I0_D3+7], 8, v[vgprValuB_X0_I0_D2+7] // pack two int8 Vgpr to one half Vgpr <This is 948-cycle>
v_lshl_or_b32 v[vgprValuB_X0_I0+7], v[vgprValuB_X0_I0_D2+7], 0x10, v[vgprValuB_X0_I0+7] // pack two half Vgpr to one Vgpr <This is 949-cycle>
s_nop 1                                            // VALU packing writes to be consumed by matrix instruction <This is 950-cycle>
v_wmma_f32_16x16x64_fp8_fp8 v[vgprValuC+0:vgprValuC+0+7], v[vgprValuA_X0_I0+0+0+0:vgprValuA_X0_I0+0+0+0+7], v[vgprValuB_X0_I0+0+0+0:vgprValuB_X0_I0+0+0+0+7], v[vgprValuC+0:vgprValuC+0+7] matrix_a_reuse matrix_b_reuse // left value = v[0+0:7+0] <This is 951-cycle>
label_InitCIterWmma_target_0:
/* numPrefetchIter=0 */
/* dataAtIterA=0 numReadsIterA=1 skipReadsIterA=0 readsPerIterA=32 */
/* dataAtIterB=0 numReadsIterB=1 skipReadsIterB=0 readsPerIterB=32 */

/******************************************/
/* Unrolled Loop - End                    */
/******************************************/

/* closeLoop loopL finalLoop=1 tailLoop=0 */
s_sub_u32 s[sgprLoopCounterL], s[sgprLoopCounterL], 1 // dec counterL
s_cmp_eq_i32 s[sgprLoopCounterL], 0x2              // counterL==2
s_cbranch_scc0 label_LoopBeginL                    // restart LoopL
label_LoopEndL:

/* Before NLL: Check VGPR.checkin for INT8 LW */

/******************************************/
/* Ord. NoGlobalLoadLoop_1 - Begin        */
/******************************************/
s_wait_dscnt 0                                     // 4wait for local write
// Skip force waitcnt0
s_barrier_signal -1
s_barrier_wait -1                                  // wait for local write done, sync

/* iter 0 (reset local read pointers iteration)  (swap and reset local write pointers iteration)  (swap local read pointers iteration)  */
/*  grEndMfmaIndex:0, lwStartMfmaIndex:0, lwEndMfmaIndex:0  */
/*  numMfmaForLR:0, syncPlrMfmaIndex:0 , sync1LdsMfmaIndex:0 */
/*  mfmaIndex:0  */
/* schedule remaining localreads for one buffer scheduling */
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
s_wait_alu depctr_va_vdst(2)
ds_load_u8 v[vgprValuA_X0_I0+0], v[vgprLocalReadAddrA+0] offset:0 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D1+0], v[vgprLocalReadAddrA+0] offset:32 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D2+0], v[vgprLocalReadAddrA+0] offset:64 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=2 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D3+0], v[vgprLocalReadAddrA+0] offset:96 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=3 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0+1], v[vgprLocalReadAddrA+0] offset:128 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=4 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D1+1], v[vgprLocalReadAddrA+0] offset:160 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=5 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D2+1], v[vgprLocalReadAddrA+0] offset:192 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=6 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D3+1], v[vgprLocalReadAddrA+0] offset:224 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=7 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0+2], v[vgprLocalReadAddrA+0] offset:256 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=8 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D1+2], v[vgprLocalReadAddrA+0] offset:288 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=9 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D2+2], v[vgprLocalReadAddrA+0] offset:320 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=10 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D3+2], v[vgprLocalReadAddrA+0] offset:352 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=11 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0+3], v[vgprLocalReadAddrA+0] offset:384 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=12 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D1+3], v[vgprLocalReadAddrA+0] offset:416 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=13 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D2+3], v[vgprLocalReadAddrA+0] offset:448 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=14 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D3+3], v[vgprLocalReadAddrA+0] offset:480 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=15 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0+4], v[vgprLocalReadAddrA+0] offset:1056 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=16 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D1+4], v[vgprLocalReadAddrA+0] offset:1088 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=17 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D2+4], v[vgprLocalReadAddrA+0] offset:1120 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=18 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D3+4], v[vgprLocalReadAddrA+0] offset:1152 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=19 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0+5], v[vgprLocalReadAddrA+0] offset:1184 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=20 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D1+5], v[vgprLocalReadAddrA+0] offset:1216 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=21 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D2+5], v[vgprLocalReadAddrA+0] offset:1248 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=22 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D3+5], v[vgprLocalReadAddrA+0] offset:1280 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=23 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0+6], v[vgprLocalReadAddrA+0] offset:1312 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=24 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D1+6], v[vgprLocalReadAddrA+0] offset:1344 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=25 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D2+6], v[vgprLocalReadAddrA+0] offset:1376 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=26 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D3+6], v[vgprLocalReadAddrA+0] offset:1408 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=27 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0+7], v[vgprLocalReadAddrA+0] offset:1440 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=28 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D1+7], v[vgprLocalReadAddrA+0] offset:1472 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=29 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D2+7], v[vgprLocalReadAddrA+0] offset:1504 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=30 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D3+7], v[vgprLocalReadAddrA+0] offset:1536 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=31 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0+0], v[vgprLocalReadAddrB+0] offset:0 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D1+0], v[vgprLocalReadAddrB+0] offset:16 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D2+0], v[vgprLocalReadAddrB+0] offset:32 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=2 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D3+0], v[vgprLocalReadAddrB+0] offset:48 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=3 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0+1], v[vgprLocalReadAddrB+0] offset:64 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=4 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D1+1], v[vgprLocalReadAddrB+0] offset:80 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=5 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D2+1], v[vgprLocalReadAddrB+0] offset:96 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=6 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D3+1], v[vgprLocalReadAddrB+0] offset:112 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=7 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0+2], v[vgprLocalReadAddrB+0] offset:128 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=8 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D1+2], v[vgprLocalReadAddrB+0] offset:144 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=9 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D2+2], v[vgprLocalReadAddrB+0] offset:160 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=10 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D3+2], v[vgprLocalReadAddrB+0] offset:176 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=11 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0+3], v[vgprLocalReadAddrB+0] offset:192 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=12 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D1+3], v[vgprLocalReadAddrB+0] offset:208 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=13 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D2+3], v[vgprLocalReadAddrB+0] offset:224 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=14 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D3+3], v[vgprLocalReadAddrB+0] offset:240 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=15 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0+4], v[vgprLocalReadAddrB+0] offset:544 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=16 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D1+4], v[vgprLocalReadAddrB+0] offset:560 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=17 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D2+4], v[vgprLocalReadAddrB+0] offset:576 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=18 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D3+4], v[vgprLocalReadAddrB+0] offset:592 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=19 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0+5], v[vgprLocalReadAddrB+0] offset:608 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=20 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D1+5], v[vgprLocalReadAddrB+0] offset:624 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=21 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D2+5], v[vgprLocalReadAddrB+0] offset:640 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=22 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D3+5], v[vgprLocalReadAddrB+0] offset:656 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=23 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0+6], v[vgprLocalReadAddrB+0] offset:672 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=24 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D1+6], v[vgprLocalReadAddrB+0] offset:688 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=25 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D2+6], v[vgprLocalReadAddrB+0] offset:704 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=26 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D3+6], v[vgprLocalReadAddrB+0] offset:720 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=27 oIdx=0 buffer=0 iui=0 sync LDS0
s_wait_alu depctr_va_vdst(0)
ds_load_u8 v[vgprValuB_X0_I0+7], v[vgprLocalReadAddrB+0] offset:736 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=28 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D1+7], v[vgprLocalReadAddrB+0] offset:752 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=29 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D2+7], v[vgprLocalReadAddrB+0] offset:768 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=30 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D3+7], v[vgprLocalReadAddrB+0] offset:784 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=31 oIdx=0 buffer=0 iui=0 sync LDS0

/* Global Read IncA */

/* global read inc A loopL */
s_cmp_eq_u32 s[sgprLoopCounterL], s[sgprStaggerUIter] // Is this the wrapIter?
s_cselect_b32 s66, s[sgprWrapUA+0], s[sgprGlobalReadIncsA+0] // incLower <- ?
s_cselect_b32 s67, s[sgprWrapUA+1], 0              // incUpper <- ?
s_add_u32 s[sgprSrdA+0], s[sgprSrdA+0], s66        // gra SRD += inc(lower)
s_addc_u32 s[sgprSrdA+1], s[sgprSrdA+1], s67       // gra SRD += inc(upper)
s_sub_u32 s[sgprShadowLimitA+0], s[sgprShadowLimitA+0], s66 // limit -= inc)
s_subb_u32 s[sgprShadowLimitA+1], s[sgprShadowLimitA+1], s67 // limit -= inc)
s_cmp_eq_u32 s[sgprShadowLimitA+1], 0              // are we within 2^32?
s_cselect_b32 s[sgprSrdA+2], s[sgprShadowLimitA+0], BufferLimit // Move shadow to real if we are within 2^32
// Shift num records for gfx125x
s_and_b32 s8, s[sgprSrdA+2], 127
s_lshl_b32 s8, s8, 25
s_and_b32 s[sgprSrdA+1], s[sgprSrdA+1], 33554431
s_or_b32 s[sgprSrdA+1], s[sgprSrdA+1], s8
s_lshr_b32 s[sgprSrdA+2], s[sgprSrdA+2], 7

/* Global Read IncB */

/* global read inc B loopL */
s_cmp_eq_u32 s[sgprLoopCounterL], s[sgprStaggerUIter] // Is this the wrapIter?
s_cselect_b32 s66, s[sgprWrapUB+0], s[sgprGlobalReadIncsB+0] // incLower <- ?
s_cselect_b32 s67, s[sgprWrapUB+1], 0              // incUpper <- ?
s_add_u32 s[sgprSrdB+0], s[sgprSrdB+0], s66        // gra SRD += inc(lower)
s_addc_u32 s[sgprSrdB+1], s[sgprSrdB+1], s67       // gra SRD += inc(upper)
s_sub_u32 s[sgprShadowLimitB+0], s[sgprShadowLimitB+0], s66 // limit -= inc)
s_subb_u32 s[sgprShadowLimitB+1], s[sgprShadowLimitB+1], s67 // limit -= inc)
s_cmp_eq_u32 s[sgprShadowLimitB+1], 0              // are we within 2^32?
s_cselect_b32 s[sgprSrdB+2], s[sgprShadowLimitB+0], BufferLimit // Move shadow to real if we are within 2^32
// Shift num records for gfx125x
s_and_b32 s8, s[sgprSrdB+2], 127
s_lshl_b32 s8, s8, 25
s_and_b32 s[sgprSrdB+1], s[sgprSrdB+1], 33554431
s_or_b32 s[sgprSrdB+1], s[sgprSrdB+1], s8
s_lshr_b32 s[sgprSrdB+2], s[sgprSrdB+2], 7
/* 1 LDS buffer: read-sync-write */
s_wait_dscnt 0
s_barrier_signal -1
s_barrier_wait -1
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 47                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+0] offset:0 // lwoA_0_0_0_0 = (0*LSCA) + (0*LSPA)(*MT0I+PAD) = 0 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 46                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+16] offset:64 // lwoA_0_0_1_0 = (0*LSCA) + (1*LSPA)(*MT0I+PAD) = 64 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 45                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+32] offset:128 // lwoA_0_0_2_0 = (0*LSCA) + (2*LSPA)(*MT0I+PAD) = 128 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 44                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+48] offset:192 // lwoA_0_0_3_0 = (0*LSCA) + (3*LSPA)(*MT0I+PAD) = 192 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 43                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+1] offset:256 // lwoA_0_0_4_0 = (0*LSCA) + (4*LSPA)(*MT0I+PAD) = 256 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 42                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+17] offset:320 // lwoA_0_0_5_0 = (0*LSCA) + (5*LSPA)(*MT0I+PAD) = 320 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 41                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+33] offset:384 // lwoA_0_0_6_0 = (0*LSCA) + (6*LSPA)(*MT0I+PAD) = 384 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 40                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+49] offset:448 // lwoA_0_0_7_0 = (0*LSCA) + (7*LSPA)(*MT0I+PAD) = 448 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 39                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+2] offset:528 // lwoA_0_0_8_0 = (0*LSCA) + (8*LSPA)(*MT0I+PAD) = 528 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 38                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+18] offset:592 // lwoA_0_0_9_0 = (0*LSCA) + (9*LSPA)(*MT0I+PAD) = 592 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 37                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+34] offset:656 // lwoA_0_0_10_0 = (0*LSCA) + (10*LSPA)(*MT0I+PAD) = 656 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 36                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+50] offset:720 // lwoA_0_0_11_0 = (0*LSCA) + (11*LSPA)(*MT0I+PAD) = 720 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 35                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+3] offset:784 // lwoA_0_0_12_0 = (0*LSCA) + (12*LSPA)(*MT0I+PAD) = 784 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 34                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+19] offset:848 // lwoA_0_0_13_0 = (0*LSCA) + (13*LSPA)(*MT0I+PAD) = 848 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 33                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+35] offset:912 // lwoA_0_0_14_0 = (0*LSCA) + (14*LSPA)(*MT0I+PAD) = 912 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 32                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+51] offset:976 // lwoA_0_0_15_0 = (0*LSCA) + (15*LSPA)(*MT0I+PAD) = 976 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 31                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+4] offset:1056 // lwoA_0_0_16_0 = (0*LSCA) + (16*LSPA)(*MT0I+PAD) = 1056 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 30                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+20] offset:1120 // lwoA_0_0_17_0 = (0*LSCA) + (17*LSPA)(*MT0I+PAD) = 1120 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 29                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+36] offset:1184 // lwoA_0_0_18_0 = (0*LSCA) + (18*LSPA)(*MT0I+PAD) = 1184 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 28                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+52] offset:1248 // lwoA_0_0_19_0 = (0*LSCA) + (19*LSPA)(*MT0I+PAD) = 1248 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 27                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+5] offset:1312 // lwoA_0_0_20_0 = (0*LSCA) + (20*LSPA)(*MT0I+PAD) = 1312 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 26                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+21] offset:1376 // lwoA_0_0_21_0 = (0*LSCA) + (21*LSPA)(*MT0I+PAD) = 1376 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 25                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+37] offset:1440 // lwoA_0_0_22_0 = (0*LSCA) + (22*LSPA)(*MT0I+PAD) = 1440 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 24                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+53] offset:1504 // lwoA_0_0_23_0 = (0*LSCA) + (23*LSPA)(*MT0I+PAD) = 1504 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 23                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+6] offset:1584 // lwoA_0_0_24_0 = (0*LSCA) + (24*LSPA)(*MT0I+PAD) = 1584 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 22                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+22] offset:1648 // lwoA_0_0_25_0 = (0*LSCA) + (25*LSPA)(*MT0I+PAD) = 1648 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 21                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+38] offset:1712 // lwoA_0_0_26_0 = (0*LSCA) + (26*LSPA)(*MT0I+PAD) = 1712 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 20                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+54] offset:1776 // lwoA_0_0_27_0 = (0*LSCA) + (27*LSPA)(*MT0I+PAD) = 1776 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 19                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+7] offset:1840 // lwoA_0_0_28_0 = (0*LSCA) + (28*LSPA)(*MT0I+PAD) = 1840 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 18                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+23] offset:1904 // lwoA_0_0_29_0 = (0*LSCA) + (29*LSPA)(*MT0I+PAD) = 1904 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 17                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+39] offset:1968 // lwoA_0_0_30_0 = (0*LSCA) + (30*LSPA)(*MT0I+PAD) = 1968 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 16                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+55] offset:2032 // lwoA_0_0_31_0 = (0*LSCA) + (31*LSPA)(*MT0I+PAD) = 2032 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 15                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+0] offset:0 // lwoB_0_0_0_0 = (0*LSCB) + (0*LSPB)(*MT1J+PAD) = 0 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 14                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+8] offset:64 // lwoB_0_0_1_0 = (0*LSCB) + (1*LSPB)(*MT1J+PAD) = 64 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 13                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+16] offset:128 // lwoB_0_0_2_0 = (0*LSCB) + (2*LSPB)(*MT1J+PAD) = 128 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 12                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+24] offset:192 // lwoB_0_0_3_0 = (0*LSCB) + (3*LSPB)(*MT1J+PAD) = 192 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 11                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+1] offset:272 // lwoB_0_0_4_0 = (0*LSCB) + (4*LSPB)(*MT1J+PAD) = 272 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 10                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+9] offset:336 // lwoB_0_0_5_0 = (0*LSCB) + (5*LSPB)(*MT1J+PAD) = 336 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 9                                   // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+17] offset:400 // lwoB_0_0_6_0 = (0*LSCB) + (6*LSPB)(*MT1J+PAD) = 400 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 8                                   // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+25] offset:464 // lwoB_0_0_7_0 = (0*LSCB) + (7*LSPB)(*MT1J+PAD) = 464 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 7                                   // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+2] offset:544 // lwoB_0_0_8_0 = (0*LSCB) + (8*LSPB)(*MT1J+PAD) = 544 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 6                                   // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+10] offset:608 // lwoB_0_0_9_0 = (0*LSCB) + (9*LSPB)(*MT1J+PAD) = 608 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 5                                   // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+18] offset:672 // lwoB_0_0_10_0 = (0*LSCB) + (10*LSPB)(*MT1J+PAD) = 672 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 4                                   // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+26] offset:736 // lwoB_0_0_11_0 = (0*LSCB) + (11*LSPB)(*MT1J+PAD) = 736 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 3                                   // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+3] offset:816 // lwoB_0_0_12_0 = (0*LSCB) + (12*LSPB)(*MT1J+PAD) = 816 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 2                                   // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+11] offset:880 // lwoB_0_0_13_0 = (0*LSCB) + (13*LSPB)(*MT1J+PAD) = 880 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 1                                   // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+19] offset:944 // lwoB_0_0_14_0 = (0*LSCB) + (14*LSPB)(*MT1J+PAD) = 944 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 0                                   // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+27] offset:1008 // lwoB_0_0_15_0 = (0*LSCB) + (15*LSPB)(*MT1J+PAD) = 1008 sync LDS0

/* local write swap offsets a */

/* local write swap offsets b */

/* local read swap offsets a */

/* local read swap offsets b */

/* local read init pointers a */

/* localReadInitPointers */

/* local read init pointers b */

/* localReadInitPointers */
/* pack scheduling: packAIdx:24, packBIdx:24 */
v_lshl_or_b32 v[vgprValuA_X0_I0+0], v[vgprValuA_X0_I0_D1+0], 8, v[vgprValuA_X0_I0+0] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+0], v[vgprValuA_X0_I0_D3+0], 8, v[vgprValuA_X0_I0_D2+0] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+0], v[vgprValuA_X0_I0_D2+0], 0x10, v[vgprValuA_X0_I0+0] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+1], v[vgprValuA_X0_I0_D1+1], 8, v[vgprValuA_X0_I0+1] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+1], v[vgprValuA_X0_I0_D3+1], 8, v[vgprValuA_X0_I0_D2+1] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+1], v[vgprValuA_X0_I0_D2+1], 0x10, v[vgprValuA_X0_I0+1] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+2], v[vgprValuA_X0_I0_D1+2], 8, v[vgprValuA_X0_I0+2] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+2], v[vgprValuA_X0_I0_D3+2], 8, v[vgprValuA_X0_I0_D2+2] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+2], v[vgprValuA_X0_I0_D2+2], 0x10, v[vgprValuA_X0_I0+2] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+3], v[vgprValuA_X0_I0_D1+3], 8, v[vgprValuA_X0_I0+3] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+3], v[vgprValuA_X0_I0_D3+3], 8, v[vgprValuA_X0_I0_D2+3] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+3], v[vgprValuA_X0_I0_D2+3], 0x10, v[vgprValuA_X0_I0+3] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+4], v[vgprValuA_X0_I0_D1+4], 8, v[vgprValuA_X0_I0+4] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+4], v[vgprValuA_X0_I0_D3+4], 8, v[vgprValuA_X0_I0_D2+4] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+4], v[vgprValuA_X0_I0_D2+4], 0x10, v[vgprValuA_X0_I0+4] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+5], v[vgprValuA_X0_I0_D1+5], 8, v[vgprValuA_X0_I0+5] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+5], v[vgprValuA_X0_I0_D3+5], 8, v[vgprValuA_X0_I0_D2+5] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+5], v[vgprValuA_X0_I0_D2+5], 0x10, v[vgprValuA_X0_I0+5] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+6], v[vgprValuA_X0_I0_D1+6], 8, v[vgprValuA_X0_I0+6] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+6], v[vgprValuA_X0_I0_D3+6], 8, v[vgprValuA_X0_I0_D2+6] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+6], v[vgprValuA_X0_I0_D2+6], 0x10, v[vgprValuA_X0_I0+6] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+7], v[vgprValuA_X0_I0_D1+7], 8, v[vgprValuA_X0_I0+7] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+7], v[vgprValuA_X0_I0_D3+7], 8, v[vgprValuA_X0_I0_D2+7] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+7], v[vgprValuA_X0_I0_D2+7], 0x10, v[vgprValuA_X0_I0+7] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+0], v[vgprValuB_X0_I0_D1+0], 8, v[vgprValuB_X0_I0+0] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0_D2+0], v[vgprValuB_X0_I0_D3+0], 8, v[vgprValuB_X0_I0_D2+0] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+0], v[vgprValuB_X0_I0_D2+0], 0x10, v[vgprValuB_X0_I0+0] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+1], v[vgprValuB_X0_I0_D1+1], 8, v[vgprValuB_X0_I0+1] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0_D2+1], v[vgprValuB_X0_I0_D3+1], 8, v[vgprValuB_X0_I0_D2+1] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+1], v[vgprValuB_X0_I0_D2+1], 0x10, v[vgprValuB_X0_I0+1] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+2], v[vgprValuB_X0_I0_D1+2], 8, v[vgprValuB_X0_I0+2] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0_D2+2], v[vgprValuB_X0_I0_D3+2], 8, v[vgprValuB_X0_I0_D2+2] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+2], v[vgprValuB_X0_I0_D2+2], 0x10, v[vgprValuB_X0_I0+2] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+3], v[vgprValuB_X0_I0_D1+3], 8, v[vgprValuB_X0_I0+3] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0_D2+3], v[vgprValuB_X0_I0_D3+3], 8, v[vgprValuB_X0_I0_D2+3] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+3], v[vgprValuB_X0_I0_D2+3], 0x10, v[vgprValuB_X0_I0+3] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+4], v[vgprValuB_X0_I0_D1+4], 8, v[vgprValuB_X0_I0+4] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0_D2+4], v[vgprValuB_X0_I0_D3+4], 8, v[vgprValuB_X0_I0_D2+4] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+4], v[vgprValuB_X0_I0_D2+4], 0x10, v[vgprValuB_X0_I0+4] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+5], v[vgprValuB_X0_I0_D1+5], 8, v[vgprValuB_X0_I0+5] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0_D2+5], v[vgprValuB_X0_I0_D3+5], 8, v[vgprValuB_X0_I0_D2+5] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+5], v[vgprValuB_X0_I0_D2+5], 0x10, v[vgprValuB_X0_I0+5] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+6], v[vgprValuB_X0_I0_D1+6], 8, v[vgprValuB_X0_I0+6] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0_D2+6], v[vgprValuB_X0_I0_D3+6], 8, v[vgprValuB_X0_I0_D2+6] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+6], v[vgprValuB_X0_I0_D2+6], 0x10, v[vgprValuB_X0_I0+6] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+7], v[vgprValuB_X0_I0_D1+7], 8, v[vgprValuB_X0_I0+7] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0_D2+7], v[vgprValuB_X0_I0_D3+7], 8, v[vgprValuB_X0_I0_D2+7] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+7], v[vgprValuB_X0_I0_D2+7], 0x10, v[vgprValuB_X0_I0+7] // pack two half Vgpr to one Vgpr
s_nop 1                                            // VALU packing writes to be consumed by matrix instruction
v_wmma_f32_16x16x64_fp8_fp8 v[vgprValuC+0:vgprValuC+0+7], v[vgprValuA_X0_I0+0+0+0:vgprValuA_X0_I0+0+0+0+7], v[vgprValuB_X0_I0+0+0+0:vgprValuB_X0_I0+0+0+0+7], v[vgprValuC+0:vgprValuC+0+7] matrix_a_reuse matrix_b_reuse // left value = v[0+0:7+0]
/* numPrefetchIter=0 */
/* dataAtIterA=0 numReadsIterA=1 skipReadsIterA=0 readsPerIterA=32 */
/* dataAtIterB=0 numReadsIterB=1 skipReadsIterB=0 readsPerIterB=32 */
label_toPGR1:
s_and_b32 s8, s[sgprGSU], 0x3fff                   // Restore GSU
s_cmp_eq_u32 s8, 1                                 // GSU == 1 ?
s_cbranch_scc0 label_GSU_3                         // branch if GSU != 1

/******************************************/
/* Opt. NoLoadLoop - Begin                */
/******************************************/
s_mov_b32 s8, 0
s_cmp_eq_u32 s[sgprBeta], s8                       // Beta == 0
s_cbranch_scc0 label_OptNLL_End                    // Branch if Beta is not zero

s_cmp_eq_u32 s[sgprAlpha], 1.0                     // Alpha == 1.0 ?
s_cbranch_scc0 label_OptNLL_End                    // branch if alpha != 1


/* Edge/NonEdge store path check (M): Size % 32 > 0 -> Edge store; else -> NonEdge store */
s_and_b32 s66, 31, s[sgprSizeI]                    // s66 = s[sgprSizeI] % 32
s_add_u32 s67, -0x1, s[sgprNumWorkGroups0]
s_cmp_ge_u32 s[sgprWorkGroup0], s67                // wg0 >= nwg0-1 ?
s_cselect_b32 s66, s66, 0                          // set rem
s_mov_b32 s8, 0
s_cmp_gt_u32 s66, s8                               // rem > 0
s_cbranch_scc1 label_OptNLL_End                    // jump if edges required

/* Edge/NonEdge store path check (N (isSize1)): Size % 16 > 0 -> Edge store; else -> NonEdge store */
s_and_b32 s66, 15, s[sgprSizeJ]                    // s66 = s[sgprSizeJ] % 16
s_add_u32 s67, -0x1, s[sgprNumWorkGroups1]
s_cmp_ge_u32 s[sgprWorkGroup1], s67                // wg1 >= nwg1-1
s_cselect_b32 s66, s66, 0                          // set rem
s_mov_b32 s8, 0
s_cmp_gt_u32 s66, s8                               // rem > 0
s_cbranch_scc1 label_OptNLL_End                    // jump if edges required

s_and_b32 s67, 63, s[sgprSizesSum+0]               // s67 = s[sgprSizesSum+0] % 64
s_cmp_eq_u32 s67, 0                                // numIterL == 0
s_cbranch_scc0 label_OptNLL_End                    // skip if tail loop required
s_wait_dscnt 0                                     // 4wait for local write
// Skip force waitcnt0
s_barrier_signal -1
s_barrier_wait -1                                  // wait for local write done, sync

/* iter 0 (last unrolled loop) */
/*  grEndMfmaIndex:0, lwStartMfmaIndex:0, lwEndMfmaIndex:0  */
/*  numMfmaForLR:0, syncPlrMfmaIndex:0 , sync1LdsMfmaIndex:0 */
/*  mfmaIndex:0  */
/* schedule remaining localreads for one buffer scheduling */
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
s_wait_alu depctr_va_vdst(2)
ds_load_u8 v[vgprValuA_X0_I0+0], v[vgprLocalReadAddrA+0] offset:0 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D1+0], v[vgprLocalReadAddrA+0] offset:32 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D2+0], v[vgprLocalReadAddrA+0] offset:64 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=2 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D3+0], v[vgprLocalReadAddrA+0] offset:96 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=3 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0+1], v[vgprLocalReadAddrA+0] offset:128 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=4 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D1+1], v[vgprLocalReadAddrA+0] offset:160 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=5 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D2+1], v[vgprLocalReadAddrA+0] offset:192 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=6 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D3+1], v[vgprLocalReadAddrA+0] offset:224 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=7 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0+2], v[vgprLocalReadAddrA+0] offset:256 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=8 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D1+2], v[vgprLocalReadAddrA+0] offset:288 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=9 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D2+2], v[vgprLocalReadAddrA+0] offset:320 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=10 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D3+2], v[vgprLocalReadAddrA+0] offset:352 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=11 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0+3], v[vgprLocalReadAddrA+0] offset:384 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=12 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D1+3], v[vgprLocalReadAddrA+0] offset:416 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=13 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D2+3], v[vgprLocalReadAddrA+0] offset:448 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=14 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D3+3], v[vgprLocalReadAddrA+0] offset:480 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=15 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0+4], v[vgprLocalReadAddrA+0] offset:1056 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=16 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D1+4], v[vgprLocalReadAddrA+0] offset:1088 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=17 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D2+4], v[vgprLocalReadAddrA+0] offset:1120 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=18 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D3+4], v[vgprLocalReadAddrA+0] offset:1152 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=19 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0+5], v[vgprLocalReadAddrA+0] offset:1184 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=20 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D1+5], v[vgprLocalReadAddrA+0] offset:1216 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=21 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D2+5], v[vgprLocalReadAddrA+0] offset:1248 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=22 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D3+5], v[vgprLocalReadAddrA+0] offset:1280 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=23 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0+6], v[vgprLocalReadAddrA+0] offset:1312 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=24 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D1+6], v[vgprLocalReadAddrA+0] offset:1344 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=25 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D2+6], v[vgprLocalReadAddrA+0] offset:1376 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=26 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D3+6], v[vgprLocalReadAddrA+0] offset:1408 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=27 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0+7], v[vgprLocalReadAddrA+0] offset:1440 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=28 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D1+7], v[vgprLocalReadAddrA+0] offset:1472 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=29 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D2+7], v[vgprLocalReadAddrA+0] offset:1504 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=30 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D3+7], v[vgprLocalReadAddrA+0] offset:1536 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=31 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0+0], v[vgprLocalReadAddrB+0] offset:0 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D1+0], v[vgprLocalReadAddrB+0] offset:16 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D2+0], v[vgprLocalReadAddrB+0] offset:32 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=2 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D3+0], v[vgprLocalReadAddrB+0] offset:48 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=3 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0+1], v[vgprLocalReadAddrB+0] offset:64 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=4 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D1+1], v[vgprLocalReadAddrB+0] offset:80 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=5 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D2+1], v[vgprLocalReadAddrB+0] offset:96 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=6 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D3+1], v[vgprLocalReadAddrB+0] offset:112 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=7 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0+2], v[vgprLocalReadAddrB+0] offset:128 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=8 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D1+2], v[vgprLocalReadAddrB+0] offset:144 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=9 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D2+2], v[vgprLocalReadAddrB+0] offset:160 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=10 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D3+2], v[vgprLocalReadAddrB+0] offset:176 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=11 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0+3], v[vgprLocalReadAddrB+0] offset:192 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=12 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D1+3], v[vgprLocalReadAddrB+0] offset:208 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=13 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D2+3], v[vgprLocalReadAddrB+0] offset:224 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=14 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D3+3], v[vgprLocalReadAddrB+0] offset:240 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=15 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0+4], v[vgprLocalReadAddrB+0] offset:544 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=16 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D1+4], v[vgprLocalReadAddrB+0] offset:560 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=17 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D2+4], v[vgprLocalReadAddrB+0] offset:576 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=18 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D3+4], v[vgprLocalReadAddrB+0] offset:592 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=19 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0+5], v[vgprLocalReadAddrB+0] offset:608 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=20 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D1+5], v[vgprLocalReadAddrB+0] offset:624 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=21 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D2+5], v[vgprLocalReadAddrB+0] offset:640 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=22 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D3+5], v[vgprLocalReadAddrB+0] offset:656 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=23 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0+6], v[vgprLocalReadAddrB+0] offset:672 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=24 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D1+6], v[vgprLocalReadAddrB+0] offset:688 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=25 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D2+6], v[vgprLocalReadAddrB+0] offset:704 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=26 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D3+6], v[vgprLocalReadAddrB+0] offset:720 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=27 oIdx=0 buffer=0 iui=0 sync LDS0
s_wait_alu depctr_va_vdst(0)
ds_load_u8 v[vgprValuB_X0_I0+7], v[vgprLocalReadAddrB+0] offset:736 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=28 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D1+7], v[vgprLocalReadAddrB+0] offset:752 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=29 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D2+7], v[vgprLocalReadAddrB+0] offset:768 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=30 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D3+7], v[vgprLocalReadAddrB+0] offset:784 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=31 oIdx=0 buffer=0 iui=0 sync LDS0
/* 1 LDS buffer: read-sync-write */
s_wait_dscnt 0
s_barrier_signal -1
s_barrier_wait -1
/* pack scheduling: packAIdx:24, packBIdx:24 */
v_lshl_or_b32 v[vgprValuA_X0_I0+0], v[vgprValuA_X0_I0_D1+0], 8, v[vgprValuA_X0_I0+0] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+0], v[vgprValuA_X0_I0_D3+0], 8, v[vgprValuA_X0_I0_D2+0] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+0], v[vgprValuA_X0_I0_D2+0], 0x10, v[vgprValuA_X0_I0+0] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+1], v[vgprValuA_X0_I0_D1+1], 8, v[vgprValuA_X0_I0+1] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+1], v[vgprValuA_X0_I0_D3+1], 8, v[vgprValuA_X0_I0_D2+1] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+1], v[vgprValuA_X0_I0_D2+1], 0x10, v[vgprValuA_X0_I0+1] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+2], v[vgprValuA_X0_I0_D1+2], 8, v[vgprValuA_X0_I0+2] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+2], v[vgprValuA_X0_I0_D3+2], 8, v[vgprValuA_X0_I0_D2+2] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+2], v[vgprValuA_X0_I0_D2+2], 0x10, v[vgprValuA_X0_I0+2] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+3], v[vgprValuA_X0_I0_D1+3], 8, v[vgprValuA_X0_I0+3] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+3], v[vgprValuA_X0_I0_D3+3], 8, v[vgprValuA_X0_I0_D2+3] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+3], v[vgprValuA_X0_I0_D2+3], 0x10, v[vgprValuA_X0_I0+3] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+4], v[vgprValuA_X0_I0_D1+4], 8, v[vgprValuA_X0_I0+4] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+4], v[vgprValuA_X0_I0_D3+4], 8, v[vgprValuA_X0_I0_D2+4] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+4], v[vgprValuA_X0_I0_D2+4], 0x10, v[vgprValuA_X0_I0+4] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+5], v[vgprValuA_X0_I0_D1+5], 8, v[vgprValuA_X0_I0+5] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+5], v[vgprValuA_X0_I0_D3+5], 8, v[vgprValuA_X0_I0_D2+5] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+5], v[vgprValuA_X0_I0_D2+5], 0x10, v[vgprValuA_X0_I0+5] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+6], v[vgprValuA_X0_I0_D1+6], 8, v[vgprValuA_X0_I0+6] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+6], v[vgprValuA_X0_I0_D3+6], 8, v[vgprValuA_X0_I0_D2+6] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+6], v[vgprValuA_X0_I0_D2+6], 0x10, v[vgprValuA_X0_I0+6] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+7], v[vgprValuA_X0_I0_D1+7], 8, v[vgprValuA_X0_I0+7] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+7], v[vgprValuA_X0_I0_D3+7], 8, v[vgprValuA_X0_I0_D2+7] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+7], v[vgprValuA_X0_I0_D2+7], 0x10, v[vgprValuA_X0_I0+7] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+0], v[vgprValuB_X0_I0_D1+0], 8, v[vgprValuB_X0_I0+0] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0_D2+0], v[vgprValuB_X0_I0_D3+0], 8, v[vgprValuB_X0_I0_D2+0] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+0], v[vgprValuB_X0_I0_D2+0], 0x10, v[vgprValuB_X0_I0+0] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+1], v[vgprValuB_X0_I0_D1+1], 8, v[vgprValuB_X0_I0+1] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0_D2+1], v[vgprValuB_X0_I0_D3+1], 8, v[vgprValuB_X0_I0_D2+1] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+1], v[vgprValuB_X0_I0_D2+1], 0x10, v[vgprValuB_X0_I0+1] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+2], v[vgprValuB_X0_I0_D1+2], 8, v[vgprValuB_X0_I0+2] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0_D2+2], v[vgprValuB_X0_I0_D3+2], 8, v[vgprValuB_X0_I0_D2+2] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+2], v[vgprValuB_X0_I0_D2+2], 0x10, v[vgprValuB_X0_I0+2] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+3], v[vgprValuB_X0_I0_D1+3], 8, v[vgprValuB_X0_I0+3] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0_D2+3], v[vgprValuB_X0_I0_D3+3], 8, v[vgprValuB_X0_I0_D2+3] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+3], v[vgprValuB_X0_I0_D2+3], 0x10, v[vgprValuB_X0_I0+3] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+4], v[vgprValuB_X0_I0_D1+4], 8, v[vgprValuB_X0_I0+4] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0_D2+4], v[vgprValuB_X0_I0_D3+4], 8, v[vgprValuB_X0_I0_D2+4] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+4], v[vgprValuB_X0_I0_D2+4], 0x10, v[vgprValuB_X0_I0+4] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+5], v[vgprValuB_X0_I0_D1+5], 8, v[vgprValuB_X0_I0+5] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0_D2+5], v[vgprValuB_X0_I0_D3+5], 8, v[vgprValuB_X0_I0_D2+5] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+5], v[vgprValuB_X0_I0_D2+5], 0x10, v[vgprValuB_X0_I0+5] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+6], v[vgprValuB_X0_I0_D1+6], 8, v[vgprValuB_X0_I0+6] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0_D2+6], v[vgprValuB_X0_I0_D3+6], 8, v[vgprValuB_X0_I0_D2+6] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+6], v[vgprValuB_X0_I0_D2+6], 0x10, v[vgprValuB_X0_I0+6] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+7], v[vgprValuB_X0_I0_D1+7], 8, v[vgprValuB_X0_I0+7] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0_D2+7], v[vgprValuB_X0_I0_D3+7], 8, v[vgprValuB_X0_I0_D2+7] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+7], v[vgprValuB_X0_I0_D2+7], 0x10, v[vgprValuB_X0_I0+7] // pack two half Vgpr to one Vgpr
s_nop 1                                            // VALU packing writes to be consumed by matrix instruction
v_wmma_f32_16x16x64_fp8_fp8 v[vgprValuC+0:vgprValuC+0+7], v[vgprValuA_X0_I0+0+0+0:vgprValuA_X0_I0+0+0+0+7], v[vgprValuB_X0_I0+0+0+0:vgprValuB_X0_I0+0+0+0+7], v[vgprValuC+0:vgprValuC+0+7] matrix_a_reuse matrix_b_reuse // left value = v[0+0:7+0]
/* numPrefetchIter=0 */
/* dataAtIterA=0 numReadsIterA=1 skipReadsIterA=0 readsPerIterA=32 */
/* dataAtIterB=0 numReadsIterB=1 skipReadsIterB=0 readsPerIterB=32 */
label_toPGR1end_OptNLL:
/* Stores for OptNLL */
label_Summation_End_OptNLL:
/* endSummation: add vgpr [8...224) to pool */
/* load store sgprs */

/* Mapping of Acc register -> C Vgpr register */

/* Multiply MI out register with Alpha -> C Vgpr register */
/* computeStoreVgprs */
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
s_wait_alu depctr_vm_vsrc(6)
v_lshrrev_b32 v12, 5, v[vgprSerial]                // 12 = Serial / 32
v_lshrrev_b32 v13, 1, v12                          // 13 = 12 / 2
v_lshlrev_b32 v9, 4, v13                           // wave coordination offset 1
v_and_b32 v13, 15, v[vgprSerial]                   // v13 = v[vgprSerial] % 16
v_add_lshl_u32 v9, v13, v9, 0                      // coordination 1 = vwB *(wave_id1 + tid1)
v_mul_lo_u32 v10, v9, s[sgprStrideC1J]             //  offset 1
v_mul_lo_u32 v11, v9, s[sgprStrideD1J]             //  offset 1
v_and_b32 v13, 1, v12                              // v13 = v12 % 2
v_lshlrev_b32 v13, 4, v13                          // wave coordination offset 0
v_and_b32 v8, 31, v[vgprSerial]                    // v8 = v[vgprSerial] % 32
v_lshrrev_b32 v8, 4, v8                            // 8 = 8 / 16
v_lshlrev_b32 v8, 3, v8                            // thread0 * continuous_output
v_add_lshl_u32 v8, v13, v8, 0                      // coordination 0 = vwA *(wave_id0 + tid0)
s_mul_i32 s8, 32, s[sgprWorkGroup0]                // wgp0 * MT0
v_add_nc_u32 v8, s8, v8                            // coord 0 = (tid0/MI_m)*4 + waveG0*MIB_m + MT0*SG0
s_mul_i32 s8, 16, s[sgprWorkGroup1]                // wgp1 * MT1
v_add_nc_u32 v9, s8, v9                            // coord 1 = (tid0%MI_m) + waveG1*MIB_n + MT1*SG1

/******************************************/
/* Global Write Elements                  */
/******************************************/
label_GW_B0_OptNLL_MB:
label_GW_B0_FD0_OptNLL_MB:
label_GW_B0_FD0_VW8_OptNLL_MB_Then:

/* edge=0, allocate 1 sgpr. perBatchTmpS=1 perBatchMaskS=0 perElementMaskS=0 elementsPerBatch=28 */
/* optSingleColVgpr=1 optSharedColVgpr=0 optSGPRUsage=BufferLoad_Mask optSrdIncForRow=1 factorDim=0 */

/******************************************/
/* Global Write Batch #0 (d1,d0,vc1,vc0) = */
/*    (0,0,0,0:vw8)                       */
/******************************************/

/* calc coords, apply mask, and issue loads (if necessary) */
/* (d1,vc1,d0,vc0)=(0,0,0,0) */
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_add_nc_u32 v19, v11, v8                          // optSingleColVgpr scaleToBpe: sharedAddrVgpr <- cinRowPtr + coord0, scaled by BPE. BSHERE:coord0=8, coord0Vgpr=8 (multiple bpe)
                                                   // optSingleColVgpr scaleToBpe: sharedAddrVgpr <- cinRowPtr + coord0, scaled by BPE. BSHERE:coord0=8, coord0Vgpr=8 (bpe is 1, no mul)
v_mov_b32 v[vgprValuC+24], v[vgprValuC+0]          // copy MI out reg to vreg[0]
v_mov_b32 v[vgprValuC+25], v[vgprValuC+1]          // copy MI out reg to vreg[1]
v_mov_b32 v[vgprValuC+26], v[vgprValuC+2]          // copy MI out reg to vreg[2]
v_mov_b32 v[vgprValuC+27], v[vgprValuC+3]          // copy MI out reg to vreg[3]
v_mov_b32 v[vgprValuC+28], v[vgprValuC+4]          // copy MI out reg to vreg[4]
v_mov_b32 v[vgprValuC+29], v[vgprValuC+5]          // copy MI out reg to vreg[5]
v_mov_b32 v[vgprValuC+30], v[vgprValuC+6]          // copy MI out reg to vreg[6]
v_mov_b32 v[vgprValuC+31], v[vgprValuC+7]          // copy MI out reg to vreg[7]

/* apply mask, calc new C and issue writes */
v_mov_b32 v16, 0x207                               // Nan and +/- inf
v_mov_b32 v18, 0x43E00000                          // Fp8 Max value 448 as float32
v_mov_b32 v17, 0xc3E00000                          // Fp8 Min value -448 as float32
v_cmp_class_f32 s8, v[vgprValuC+24], v16           // Nan and +/- inf
v_med3_f32 v15, v[vgprValuC+24], v17, v18
v_cndmask_b32 v[vgprValuC+24], v15, v[vgprValuC+24], s8
v_cmp_class_f32 s8, v[vgprValuC+25], v16           // Nan and +/- inf
v_med3_f32 v15, v[vgprValuC+25], v17, v18
v_cndmask_b32 v[vgprValuC+25], v15, v[vgprValuC+25], s8
v_cmp_class_f32 s8, v[vgprValuC+26], v16           // Nan and +/- inf
v_med3_f32 v15, v[vgprValuC+26], v17, v18
v_cndmask_b32 v[vgprValuC+26], v15, v[vgprValuC+26], s8
v_cmp_class_f32 s8, v[vgprValuC+27], v16           // Nan and +/- inf
v_med3_f32 v15, v[vgprValuC+27], v17, v18
v_cndmask_b32 v[vgprValuC+27], v15, v[vgprValuC+27], s8
v_cmp_class_f32 s8, v[vgprValuC+28], v16           // Nan and +/- inf
v_med3_f32 v15, v[vgprValuC+28], v17, v18
v_cndmask_b32 v[vgprValuC+28], v15, v[vgprValuC+28], s8
v_cmp_class_f32 s8, v[vgprValuC+29], v16           // Nan and +/- inf
v_med3_f32 v15, v[vgprValuC+29], v17, v18
v_cndmask_b32 v[vgprValuC+29], v15, v[vgprValuC+29], s8
v_cmp_class_f32 s8, v[vgprValuC+30], v16           // Nan and +/- inf
v_med3_f32 v15, v[vgprValuC+30], v17, v18
v_cndmask_b32 v[vgprValuC+30], v15, v[vgprValuC+30], s8
v_cmp_class_f32 s8, v[vgprValuC+31], v16           // Nan and +/- inf
v_med3_f32 v15, v[vgprValuC+31], v17, v18
v_cndmask_b32 v[vgprValuC+31], v15, v[vgprValuC+31], s8
v_cvt_scalef32_pk8_fp8_f32 v[24:25], v[vgprValuC+24:vgprValuC+24+7], 1.0 // convert 8xF32 to 8xFP8
s_wait_alu depctr_va_vdst(0)
buffer_store_b64 v[24:25], v19, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_nop 0                                            // 1 wait state required when next inst writes vgprs held by previous dwordx4 store inst
s_branch label_GW_End                              // jump to end
label_GW_End:

s_endpgm                                           // Kernel End
label_OptNLL_End:
label_GSU_3:

/******************************************/
/* Ord. NoLoadLoop - Begin                */
/******************************************/
s_wait_dscnt 0                                     // 4wait for local write
// Skip force waitcnt0
s_barrier_signal -1
s_barrier_wait -1                                  // wait for local write done, sync

/* iter 0 (last unrolled loop) */
/*  grEndMfmaIndex:0, lwStartMfmaIndex:0, lwEndMfmaIndex:0  */
/*  numMfmaForLR:0, syncPlrMfmaIndex:0 , sync1LdsMfmaIndex:0 */
/*  mfmaIndex:0  */
/* schedule remaining localreads for one buffer scheduling */
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
s_wait_alu depctr_va_vdst(2)
ds_load_u8 v[vgprValuA_X0_I0+0], v[vgprLocalReadAddrA+0] offset:0 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D1+0], v[vgprLocalReadAddrA+0] offset:32 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D2+0], v[vgprLocalReadAddrA+0] offset:64 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=2 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D3+0], v[vgprLocalReadAddrA+0] offset:96 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=3 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0+1], v[vgprLocalReadAddrA+0] offset:128 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=4 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D1+1], v[vgprLocalReadAddrA+0] offset:160 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=5 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D2+1], v[vgprLocalReadAddrA+0] offset:192 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=6 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D3+1], v[vgprLocalReadAddrA+0] offset:224 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=7 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0+2], v[vgprLocalReadAddrA+0] offset:256 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=8 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D1+2], v[vgprLocalReadAddrA+0] offset:288 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=9 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D2+2], v[vgprLocalReadAddrA+0] offset:320 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=10 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D3+2], v[vgprLocalReadAddrA+0] offset:352 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=11 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0+3], v[vgprLocalReadAddrA+0] offset:384 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=12 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D1+3], v[vgprLocalReadAddrA+0] offset:416 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=13 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D2+3], v[vgprLocalReadAddrA+0] offset:448 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=14 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D3+3], v[vgprLocalReadAddrA+0] offset:480 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=15 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0+4], v[vgprLocalReadAddrA+0] offset:1056 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=16 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D1+4], v[vgprLocalReadAddrA+0] offset:1088 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=17 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D2+4], v[vgprLocalReadAddrA+0] offset:1120 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=18 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D3+4], v[vgprLocalReadAddrA+0] offset:1152 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=19 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0+5], v[vgprLocalReadAddrA+0] offset:1184 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=20 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D1+5], v[vgprLocalReadAddrA+0] offset:1216 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=21 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D2+5], v[vgprLocalReadAddrA+0] offset:1248 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=22 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D3+5], v[vgprLocalReadAddrA+0] offset:1280 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=23 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0+6], v[vgprLocalReadAddrA+0] offset:1312 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=24 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D1+6], v[vgprLocalReadAddrA+0] offset:1344 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=25 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D2+6], v[vgprLocalReadAddrA+0] offset:1376 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=26 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D3+6], v[vgprLocalReadAddrA+0] offset:1408 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=27 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0+7], v[vgprLocalReadAddrA+0] offset:1440 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=28 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D1+7], v[vgprLocalReadAddrA+0] offset:1472 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=29 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D2+7], v[vgprLocalReadAddrA+0] offset:1504 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=30 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D3+7], v[vgprLocalReadAddrA+0] offset:1536 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=31 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0+0], v[vgprLocalReadAddrB+0] offset:0 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D1+0], v[vgprLocalReadAddrB+0] offset:16 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D2+0], v[vgprLocalReadAddrB+0] offset:32 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=2 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D3+0], v[vgprLocalReadAddrB+0] offset:48 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=3 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0+1], v[vgprLocalReadAddrB+0] offset:64 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=4 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D1+1], v[vgprLocalReadAddrB+0] offset:80 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=5 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D2+1], v[vgprLocalReadAddrB+0] offset:96 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=6 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D3+1], v[vgprLocalReadAddrB+0] offset:112 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=7 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0+2], v[vgprLocalReadAddrB+0] offset:128 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=8 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D1+2], v[vgprLocalReadAddrB+0] offset:144 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=9 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D2+2], v[vgprLocalReadAddrB+0] offset:160 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=10 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D3+2], v[vgprLocalReadAddrB+0] offset:176 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=11 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0+3], v[vgprLocalReadAddrB+0] offset:192 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=12 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D1+3], v[vgprLocalReadAddrB+0] offset:208 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=13 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D2+3], v[vgprLocalReadAddrB+0] offset:224 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=14 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D3+3], v[vgprLocalReadAddrB+0] offset:240 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=15 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0+4], v[vgprLocalReadAddrB+0] offset:544 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=16 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D1+4], v[vgprLocalReadAddrB+0] offset:560 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=17 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D2+4], v[vgprLocalReadAddrB+0] offset:576 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=18 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D3+4], v[vgprLocalReadAddrB+0] offset:592 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=19 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0+5], v[vgprLocalReadAddrB+0] offset:608 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=20 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D1+5], v[vgprLocalReadAddrB+0] offset:624 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=21 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D2+5], v[vgprLocalReadAddrB+0] offset:640 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=22 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D3+5], v[vgprLocalReadAddrB+0] offset:656 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=23 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0+6], v[vgprLocalReadAddrB+0] offset:672 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=24 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D1+6], v[vgprLocalReadAddrB+0] offset:688 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=25 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D2+6], v[vgprLocalReadAddrB+0] offset:704 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=26 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D3+6], v[vgprLocalReadAddrB+0] offset:720 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=27 oIdx=0 buffer=0 iui=0 sync LDS0
s_wait_alu depctr_va_vdst(0)
ds_load_u8 v[vgprValuB_X0_I0+7], v[vgprLocalReadAddrB+0] offset:736 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=28 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D1+7], v[vgprLocalReadAddrB+0] offset:752 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=29 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D2+7], v[vgprLocalReadAddrB+0] offset:768 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=30 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D3+7], v[vgprLocalReadAddrB+0] offset:784 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=31 oIdx=0 buffer=0 iui=0 sync LDS0
/* 1 LDS buffer: read-sync-write */
s_wait_dscnt 0
s_barrier_signal -1
s_barrier_wait -1
/* pack scheduling: packAIdx:24, packBIdx:24 */
v_lshl_or_b32 v[vgprValuA_X0_I0+0], v[vgprValuA_X0_I0_D1+0], 8, v[vgprValuA_X0_I0+0] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+0], v[vgprValuA_X0_I0_D3+0], 8, v[vgprValuA_X0_I0_D2+0] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+0], v[vgprValuA_X0_I0_D2+0], 0x10, v[vgprValuA_X0_I0+0] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+1], v[vgprValuA_X0_I0_D1+1], 8, v[vgprValuA_X0_I0+1] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+1], v[vgprValuA_X0_I0_D3+1], 8, v[vgprValuA_X0_I0_D2+1] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+1], v[vgprValuA_X0_I0_D2+1], 0x10, v[vgprValuA_X0_I0+1] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+2], v[vgprValuA_X0_I0_D1+2], 8, v[vgprValuA_X0_I0+2] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+2], v[vgprValuA_X0_I0_D3+2], 8, v[vgprValuA_X0_I0_D2+2] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+2], v[vgprValuA_X0_I0_D2+2], 0x10, v[vgprValuA_X0_I0+2] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+3], v[vgprValuA_X0_I0_D1+3], 8, v[vgprValuA_X0_I0+3] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+3], v[vgprValuA_X0_I0_D3+3], 8, v[vgprValuA_X0_I0_D2+3] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+3], v[vgprValuA_X0_I0_D2+3], 0x10, v[vgprValuA_X0_I0+3] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+4], v[vgprValuA_X0_I0_D1+4], 8, v[vgprValuA_X0_I0+4] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+4], v[vgprValuA_X0_I0_D3+4], 8, v[vgprValuA_X0_I0_D2+4] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+4], v[vgprValuA_X0_I0_D2+4], 0x10, v[vgprValuA_X0_I0+4] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+5], v[vgprValuA_X0_I0_D1+5], 8, v[vgprValuA_X0_I0+5] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+5], v[vgprValuA_X0_I0_D3+5], 8, v[vgprValuA_X0_I0_D2+5] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+5], v[vgprValuA_X0_I0_D2+5], 0x10, v[vgprValuA_X0_I0+5] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+6], v[vgprValuA_X0_I0_D1+6], 8, v[vgprValuA_X0_I0+6] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+6], v[vgprValuA_X0_I0_D3+6], 8, v[vgprValuA_X0_I0_D2+6] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+6], v[vgprValuA_X0_I0_D2+6], 0x10, v[vgprValuA_X0_I0+6] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+7], v[vgprValuA_X0_I0_D1+7], 8, v[vgprValuA_X0_I0+7] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+7], v[vgprValuA_X0_I0_D3+7], 8, v[vgprValuA_X0_I0_D2+7] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+7], v[vgprValuA_X0_I0_D2+7], 0x10, v[vgprValuA_X0_I0+7] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+0], v[vgprValuB_X0_I0_D1+0], 8, v[vgprValuB_X0_I0+0] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0_D2+0], v[vgprValuB_X0_I0_D3+0], 8, v[vgprValuB_X0_I0_D2+0] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+0], v[vgprValuB_X0_I0_D2+0], 0x10, v[vgprValuB_X0_I0+0] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+1], v[vgprValuB_X0_I0_D1+1], 8, v[vgprValuB_X0_I0+1] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0_D2+1], v[vgprValuB_X0_I0_D3+1], 8, v[vgprValuB_X0_I0_D2+1] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+1], v[vgprValuB_X0_I0_D2+1], 0x10, v[vgprValuB_X0_I0+1] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+2], v[vgprValuB_X0_I0_D1+2], 8, v[vgprValuB_X0_I0+2] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0_D2+2], v[vgprValuB_X0_I0_D3+2], 8, v[vgprValuB_X0_I0_D2+2] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+2], v[vgprValuB_X0_I0_D2+2], 0x10, v[vgprValuB_X0_I0+2] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+3], v[vgprValuB_X0_I0_D1+3], 8, v[vgprValuB_X0_I0+3] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0_D2+3], v[vgprValuB_X0_I0_D3+3], 8, v[vgprValuB_X0_I0_D2+3] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+3], v[vgprValuB_X0_I0_D2+3], 0x10, v[vgprValuB_X0_I0+3] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+4], v[vgprValuB_X0_I0_D1+4], 8, v[vgprValuB_X0_I0+4] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0_D2+4], v[vgprValuB_X0_I0_D3+4], 8, v[vgprValuB_X0_I0_D2+4] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+4], v[vgprValuB_X0_I0_D2+4], 0x10, v[vgprValuB_X0_I0+4] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+5], v[vgprValuB_X0_I0_D1+5], 8, v[vgprValuB_X0_I0+5] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0_D2+5], v[vgprValuB_X0_I0_D3+5], 8, v[vgprValuB_X0_I0_D2+5] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+5], v[vgprValuB_X0_I0_D2+5], 0x10, v[vgprValuB_X0_I0+5] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+6], v[vgprValuB_X0_I0_D1+6], 8, v[vgprValuB_X0_I0+6] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0_D2+6], v[vgprValuB_X0_I0_D3+6], 8, v[vgprValuB_X0_I0_D2+6] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+6], v[vgprValuB_X0_I0_D2+6], 0x10, v[vgprValuB_X0_I0+6] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+7], v[vgprValuB_X0_I0_D1+7], 8, v[vgprValuB_X0_I0+7] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0_D2+7], v[vgprValuB_X0_I0_D3+7], 8, v[vgprValuB_X0_I0_D2+7] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+7], v[vgprValuB_X0_I0_D2+7], 0x10, v[vgprValuB_X0_I0+7] // pack two half Vgpr to one Vgpr
s_nop 1                                            // VALU packing writes to be consumed by matrix instruction
v_wmma_f32_16x16x64_fp8_fp8 v[vgprValuC+0:vgprValuC+0+7], v[vgprValuA_X0_I0+0+0+0:vgprValuA_X0_I0+0+0+0+7], v[vgprValuB_X0_I0+0+0+0:vgprValuB_X0_I0+0+0+0+7], v[vgprValuC+0:vgprValuC+0+7] matrix_a_reuse // left value = v[0+0:7+0]
/* numPrefetchIter=0 */
/* dataAtIterA=0 numReadsIterA=1 skipReadsIterA=0 readsPerIterA=32 */
/* dataAtIterB=0 numReadsIterB=1 skipReadsIterB=0 readsPerIterB=32 */
label_toPGR1end_OrdNLL:
label_PrefetchGlobalLastIterEnd:

/* Tail: add ValuA/B vgpr buffer [60...127) to pool */

/* Tail: add address/G2L vgpr [127...224) to pool */

/******************************************/
/* Tail Loop                              */
/******************************************/

/* local write reset offsets a */

/* local write reset offsets b */
/* Check out VGPR (numG2LA,numG2LB,numG2LMXSA,numG2LMXSB,numG2LMetadata) = (64,32,0,0,0) */
.set vgprG2LA_BASE, 60
.set vgprG2LA, vgprG2LA_BASE+0
.set vgprG2LB_BASE, 124
.set vgprG2LB, vgprG2LB_BASE+0

/* remove stagger offsets for tail loop */
s_cmp_eq_u32 s[sgprOrigLoopCounter], 0             // skip if main loop was not executed
s_cbranch_scc1 label_SkipRemoveStagger             // skip removeStagger
//  removeStagger A
s_sub_i32 s66, 3, s[sgprStaggerUIter]
s_cmp_ge_i32 s66, 0
s_cbranch_scc0 label_Negative_T0BIL5BKZVNS39AX
s_mul_hi_u32 s67, s66, s[sgprGlobalReadIncsA+0]    // start offset S in bytes
s_mul_i32 s66, s66, s[sgprGlobalReadIncsA+0]       // start offset S in bytes
s_branch label_MultiplyDone_E5MA2THZDKSWP2A8
label_Negative_T0BIL5BKZVNS39AX:
s_abs_i32 s66, s66
s_mul_hi_u32 s67, s66, s[sgprGlobalReadIncsA+0]    // start offset S in bytes
s_mul_i32 s66, s66, s[sgprGlobalReadIncsA+0]       // start offset S in bytes
s_xor_b32 s66, s66, 0xffffffff
s_xor_b32 s67, s67, 0xffffffff
s_add_u32 s66, s66, 0x1
s_addc_u32 s67, s67, 0
label_MultiplyDone_E5MA2THZDKSWP2A8:
s_sub_u64 s[66:67], s[66:67], s[sgprWrapUA:sgprWrapUA+1] // S - WrapU
s_add_u32 s[sgprSrdA+0], s[sgprSrdA+0], s66        // gra SRD += inc(lower)
s_addc_u32 s[sgprSrdA+1], s[sgprSrdA+1], s67       // gra SRD += inc(upper)
s_sub_u32 s[sgprShadowLimitA+0], s[sgprShadowLimitA+0], s66 // limit -= inc)
s_subb_u32 s[sgprShadowLimitA+1], s[sgprShadowLimitA+1], s67 // limit -= inc)
s_cmp_eq_u32 s[sgprShadowLimitA+1], 0              // are we within 2^32?
s_cselect_b32 s[sgprSrdA+2], s[sgprShadowLimitA+0], BufferLimit // Move shadow to real if we are within 2^32
// Shift num records for gfx125x
s_and_b32 s8, s[sgprSrdA+2], 127
s_lshl_b32 s8, s8, 25
s_and_b32 s[sgprSrdA+1], s[sgprSrdA+1], 33554431
s_or_b32 s[sgprSrdA+1], s[sgprSrdA+1], s8
s_lshr_b32 s[sgprSrdA+2], s[sgprSrdA+2], 7
//  removeStagger B
s_sub_i32 s66, 3, s[sgprStaggerUIter]
s_cmp_ge_i32 s66, 0
s_cbranch_scc0 label_Negative_8RG02XARINPC2PF6
s_mul_hi_u32 s67, s66, s[sgprGlobalReadIncsB+0]    // start offset S in bytes
s_mul_i32 s66, s66, s[sgprGlobalReadIncsB+0]       // start offset S in bytes
s_branch label_MultiplyDone_KRMTR9YUKGWZOCXN
label_Negative_8RG02XARINPC2PF6:
s_abs_i32 s66, s66
s_mul_hi_u32 s67, s66, s[sgprGlobalReadIncsB+0]    // start offset S in bytes
s_mul_i32 s66, s66, s[sgprGlobalReadIncsB+0]       // start offset S in bytes
s_xor_b32 s66, s66, 0xffffffff
s_xor_b32 s67, s67, 0xffffffff
s_add_u32 s66, s66, 0x1
s_addc_u32 s67, s67, 0
label_MultiplyDone_KRMTR9YUKGWZOCXN:
s_sub_u64 s[66:67], s[66:67], s[sgprWrapUB:sgprWrapUB+1] // S - WrapU
s_add_u32 s[sgprSrdB+0], s[sgprSrdB+0], s66        // gra SRD += inc(lower)
s_addc_u32 s[sgprSrdB+1], s[sgprSrdB+1], s67       // gra SRD += inc(upper)
s_sub_u32 s[sgprShadowLimitB+0], s[sgprShadowLimitB+0], s66 // limit -= inc)
s_subb_u32 s[sgprShadowLimitB+1], s[sgprShadowLimitB+1], s67 // limit -= inc)
s_cmp_eq_u32 s[sgprShadowLimitB+1], 0              // are we within 2^32?
s_cselect_b32 s[sgprSrdB+2], s[sgprShadowLimitB+0], BufferLimit // Move shadow to real if we are within 2^32
// Shift num records for gfx125x
s_and_b32 s8, s[sgprSrdB+2], 127
s_lshl_b32 s8, s8, 25
s_and_b32 s[sgprSrdB+1], s[sgprSrdB+1], 33554431
s_or_b32 s[sgprSrdB+1], s[sgprSrdB+1], s8
s_lshr_b32 s[sgprSrdB+2], s[sgprSrdB+2], 7
label_SkipRemoveStagger:

// numIterL = LOCAL_SPLITU * min(sizeL % LOCAL_DEPTHU, DEPTHU / LOCAL_SPLITU)
s_and_b32 s[sgprLoopCounterL], 63, s[sgprSizesSum+0] // s[sgprLoopCounterL] = s[sgprSizesSum+0] % 64
s_and_b32 s66, s[sgprGSU], 0x8000                  // SCC = (GSUC == 1) ?
s_cbranch_scc1 label_GSUC_TL                       // branch if GSUC == 1
s_cmp_lg_u32 s[sgprGSUSumIdx], s[sgprGSUSumIdx+1]  // gsuSumIdx == numIterPerWgRemainder
s_cmov_b32 s[sgprLoopCounterL], 0                  // numIter=0 if gsuSimIdx != numIterPerWgRemainder
s_branch label_GSUC_TL_End
label_GSUC_TL:
s_lshr_b32 s67, s[sgprSizesSum], 6                 // s67 = s[sgprSizesSum] / 64
s_and_b32 s68, s[sgprGSU], 0x3fff                  // Restore GSU
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cvt_f32_u32 v156, s68                            // s66 = s67 / s68
v_rcp_iflag_f32 v156, v156                         // s66 = s67 / s68
v_cvt_f32_u32 v157, s67                            // s66 = s67 / s68
v_mul_f32 v156, v156, v157                         // s66 = s67 / s68
v_cvt_u32_f32 v156, v156                           // s66 = s67 / s68
v_mul_u32_u24 v157, v156, s68                      // s66 = s67 / s68
v_sub_nc_u32 v157, s67, v157                       // s66 = s67 / s68
v_cmp_eq_u32 vcc_lo, v157, s68                     // s66 = s67 / s68
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, vcc_lo                          // s66 = s67 / s68
v_add_nc_u32 v156, 1, v156                         // s66 = s67 / s68
v_mov_b32 v157, 0                                  // s[sgprGSUSumIdx+1] = s67 % s68
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, -1                              // Reset exec
v_cmp_gt_u32 vcc_lo, v157, s68                     // overflow happened in remainder
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, vcc_lo                          // overflow happened in remainder
v_sub_nc_u32 v156, v156, 1                         // quotient - 1
v_mul_u32_u24 v157, v156, s68                      // re-calculate remainder
v_sub_nc_u32 v157, s67, v157                       // re-calculate remainder
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, -1                              // Reset exec
v_readfirstlane_b32 s66, v156                      // quotient
v_readfirstlane_b32 s[sgprGSUSumIdx+1], v157       // remainder
s_sub_u32 s67, s68, 1                              // GSU-1
s_cmp_eq_u32 s66, 0                                // quotient == 0
s_cselect_b32 s66, s[sgprGSUSumIdx+1], s67         // lastWg = (quotient==0) ? numIterPerWgRemainder : GSU-1
s_cmp_lg_u32 s[sgprGSUSumIdx], s66                 // gsuSumIdx == lastWg
s_cmov_b32 s[sgprLoopCounterL], 0                  // numIter=0 if gsuSumIdx != lastWg
label_GSUC_TL_End:
s_cmp_eq_u32 s[sgprLoopCounterL], 0                // numIterL == 0
s_mov_b32 s[sgprOrigLoopCounter], 0                // repurpose to count each localRead increment
s_cbranch_scc1 label_SkipTailLoopL                 // skip to end of tail loop b/c numIter==0

/* Update M0 for DTLDS */

/* Tail global read A */
/* g2l=0, load component 0 */
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
s_wait_alu depctr_va_vdst(6)
buffer_load_d16_u8 v[vgprG2LA+0+0], v[vgprGlobalReadOffsetA+0], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=0, load component 0 */
buffer_load_d16_u8 v[vgprG2LA+0+16], v[vgprGlobalReadOffsetA+1], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=0, load component 0 */
buffer_load_d16_u8 v[vgprG2LA+0+32], v[vgprGlobalReadOffsetA+2], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=0, load component 0 */
buffer_load_d16_u8 v[vgprG2LA+0+48], v[vgprGlobalReadOffsetA+3], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=1, load component 0 */
buffer_load_d16_u8 v[vgprG2LA+1+0], v[vgprGlobalReadOffsetA+4], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=1, load component 0 */
buffer_load_d16_u8 v[vgprG2LA+1+16], v[vgprGlobalReadOffsetA+5], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=1, load component 0 */
buffer_load_d16_u8 v[vgprG2LA+1+32], v[vgprGlobalReadOffsetA+6], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=1, load component 0 */
buffer_load_d16_u8 v[vgprG2LA+1+48], v[vgprGlobalReadOffsetA+7], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=2, load component 0 */
buffer_load_d16_u8 v[vgprG2LA+2+0], v[vgprGlobalReadOffsetA+8], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=2, load component 0 */
buffer_load_d16_u8 v[vgprG2LA+2+16], v[vgprGlobalReadOffsetA+9], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=2, load component 0 */
buffer_load_d16_u8 v[vgprG2LA+2+32], v[vgprGlobalReadOffsetA+10], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=2, load component 0 */
buffer_load_d16_u8 v[vgprG2LA+2+48], v[vgprGlobalReadOffsetA+11], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=3, load component 0 */
buffer_load_d16_u8 v[vgprG2LA+3+0], v[vgprGlobalReadOffsetA+12], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=3, load component 0 */
buffer_load_d16_u8 v[vgprG2LA+3+16], v[vgprGlobalReadOffsetA+13], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=3, load component 0 */
buffer_load_d16_u8 v[vgprG2LA+3+32], v[vgprGlobalReadOffsetA+14], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=3, load component 0 */
buffer_load_d16_u8 v[vgprG2LA+3+48], v[vgprGlobalReadOffsetA+15], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=4, load component 0 */
buffer_load_d16_u8 v[vgprG2LA+4+0], v[vgprGlobalReadOffsetA+16], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=4, load component 0 */
buffer_load_d16_u8 v[vgprG2LA+4+16], v[vgprGlobalReadOffsetA+17], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=4, load component 0 */
buffer_load_d16_u8 v[vgprG2LA+4+32], v[vgprGlobalReadOffsetA+18], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=4, load component 0 */
buffer_load_d16_u8 v[vgprG2LA+4+48], v[vgprGlobalReadOffsetA+19], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=5, load component 0 */
buffer_load_d16_u8 v[vgprG2LA+5+0], v[vgprGlobalReadOffsetA+20], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=5, load component 0 */
buffer_load_d16_u8 v[vgprG2LA+5+16], v[vgprGlobalReadOffsetA+21], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=5, load component 0 */
buffer_load_d16_u8 v[vgprG2LA+5+32], v[vgprGlobalReadOffsetA+22], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=5, load component 0 */
buffer_load_d16_u8 v[vgprG2LA+5+48], v[vgprGlobalReadOffsetA+23], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=6, load component 0 */
buffer_load_d16_u8 v[vgprG2LA+6+0], v[vgprGlobalReadOffsetA+24], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=6, load component 0 */
buffer_load_d16_u8 v[vgprG2LA+6+16], v[vgprGlobalReadOffsetA+25], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=6, load component 0 */
buffer_load_d16_u8 v[vgprG2LA+6+32], v[vgprGlobalReadOffsetA+26], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=6, load component 0 */
buffer_load_d16_u8 v[vgprG2LA+6+48], v[vgprGlobalReadOffsetA+27], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=7, load component 0 */
buffer_load_d16_u8 v[vgprG2LA+7+0], v[vgprGlobalReadOffsetA+28], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=7, load component 0 */
buffer_load_d16_u8 v[vgprG2LA+7+16], v[vgprGlobalReadOffsetA+29], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=7, load component 0 */
buffer_load_d16_u8 v[vgprG2LA+7+32], v[vgprGlobalReadOffsetA+30], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=7, load component 0 */
buffer_load_d16_u8 v[vgprG2LA+7+48], v[vgprGlobalReadOffsetA+31], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value

/* Update M0 for DTLDS */

/* Tail global read B */
/* g2l=0, load component 0 */
buffer_load_d16_u8 v[vgprG2LB+0+0], v[vgprGlobalReadOffsetB+0], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=0, load component 0 */
s_wait_alu depctr_vm_vsrc(6)
buffer_load_d16_u8 v[vgprG2LB+0+8], v[vgprGlobalReadOffsetB+1], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=0, load component 0 */
buffer_load_d16_u8 v[vgprG2LB+0+16], v[vgprGlobalReadOffsetB+2], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=0, load component 0 */
buffer_load_d16_u8 v[vgprG2LB+0+24], v[vgprGlobalReadOffsetB+3], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=1, load component 0 */
buffer_load_d16_u8 v[vgprG2LB+1+0], v[vgprGlobalReadOffsetB+4], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=1, load component 0 */
buffer_load_d16_u8 v[vgprG2LB+1+8], v[vgprGlobalReadOffsetB+5], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=1, load component 0 */
buffer_load_d16_u8 v[vgprG2LB+1+16], v[vgprGlobalReadOffsetB+6], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=1, load component 0 */
buffer_load_d16_u8 v[vgprG2LB+1+24], v[vgprGlobalReadOffsetB+7], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=2, load component 0 */
buffer_load_d16_u8 v[vgprG2LB+2+0], v[vgprGlobalReadOffsetB+8], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=2, load component 0 */
buffer_load_d16_u8 v[vgprG2LB+2+8], v[vgprGlobalReadOffsetB+9], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=2, load component 0 */
buffer_load_d16_u8 v[vgprG2LB+2+16], v[vgprGlobalReadOffsetB+10], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=2, load component 0 */
buffer_load_d16_u8 v[vgprG2LB+2+24], v[vgprGlobalReadOffsetB+11], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=3, load component 0 */
buffer_load_d16_u8 v[vgprG2LB+3+0], v[vgprGlobalReadOffsetB+12], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=3, load component 0 */
buffer_load_d16_u8 v[vgprG2LB+3+8], v[vgprGlobalReadOffsetB+13], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=3, load component 0 */
buffer_load_d16_u8 v[vgprG2LB+3+16], v[vgprGlobalReadOffsetB+14], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=3, load component 0 */
s_wait_alu depctr_va_vdst(4)
buffer_load_d16_u8 v[vgprG2LB+3+24], v[vgprGlobalReadOffsetB+15], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
s_wait_loadcnt 0                                   // 2wait for global read
// Skip force waitcnt0
s_barrier_signal -1
s_barrier_wait -1

/* local write a */
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+0] offset:0 // lwoA_0_0_0_0 = (0*LSCA) + (0*LSPA)(*MT0I+PAD) = 0 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+16] offset:64 // lwoA_0_0_1_0 = (0*LSCA) + (1*LSPA)(*MT0I+PAD) = 64 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+32] offset:128 // lwoA_0_0_2_0 = (0*LSCA) + (2*LSPA)(*MT0I+PAD) = 128 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+48] offset:192 // lwoA_0_0_3_0 = (0*LSCA) + (3*LSPA)(*MT0I+PAD) = 192 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+1] offset:256 // lwoA_0_0_4_0 = (0*LSCA) + (4*LSPA)(*MT0I+PAD) = 256 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+17] offset:320 // lwoA_0_0_5_0 = (0*LSCA) + (5*LSPA)(*MT0I+PAD) = 320 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+33] offset:384 // lwoA_0_0_6_0 = (0*LSCA) + (6*LSPA)(*MT0I+PAD) = 384 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+49] offset:448 // lwoA_0_0_7_0 = (0*LSCA) + (7*LSPA)(*MT0I+PAD) = 448 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+2] offset:528 // lwoA_0_0_8_0 = (0*LSCA) + (8*LSPA)(*MT0I+PAD) = 528 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+18] offset:592 // lwoA_0_0_9_0 = (0*LSCA) + (9*LSPA)(*MT0I+PAD) = 592 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+34] offset:656 // lwoA_0_0_10_0 = (0*LSCA) + (10*LSPA)(*MT0I+PAD) = 656 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+50] offset:720 // lwoA_0_0_11_0 = (0*LSCA) + (11*LSPA)(*MT0I+PAD) = 720 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+3] offset:784 // lwoA_0_0_12_0 = (0*LSCA) + (12*LSPA)(*MT0I+PAD) = 784 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+19] offset:848 // lwoA_0_0_13_0 = (0*LSCA) + (13*LSPA)(*MT0I+PAD) = 848 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+35] offset:912 // lwoA_0_0_14_0 = (0*LSCA) + (14*LSPA)(*MT0I+PAD) = 912 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+51] offset:976 // lwoA_0_0_15_0 = (0*LSCA) + (15*LSPA)(*MT0I+PAD) = 976 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+4] offset:1056 // lwoA_0_0_16_0 = (0*LSCA) + (16*LSPA)(*MT0I+PAD) = 1056 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+20] offset:1120 // lwoA_0_0_17_0 = (0*LSCA) + (17*LSPA)(*MT0I+PAD) = 1120 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+36] offset:1184 // lwoA_0_0_18_0 = (0*LSCA) + (18*LSPA)(*MT0I+PAD) = 1184 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+52] offset:1248 // lwoA_0_0_19_0 = (0*LSCA) + (19*LSPA)(*MT0I+PAD) = 1248 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+5] offset:1312 // lwoA_0_0_20_0 = (0*LSCA) + (20*LSPA)(*MT0I+PAD) = 1312 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+21] offset:1376 // lwoA_0_0_21_0 = (0*LSCA) + (21*LSPA)(*MT0I+PAD) = 1376 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+37] offset:1440 // lwoA_0_0_22_0 = (0*LSCA) + (22*LSPA)(*MT0I+PAD) = 1440 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+53] offset:1504 // lwoA_0_0_23_0 = (0*LSCA) + (23*LSPA)(*MT0I+PAD) = 1504 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+6] offset:1584 // lwoA_0_0_24_0 = (0*LSCA) + (24*LSPA)(*MT0I+PAD) = 1584 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+22] offset:1648 // lwoA_0_0_25_0 = (0*LSCA) + (25*LSPA)(*MT0I+PAD) = 1648 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+38] offset:1712 // lwoA_0_0_26_0 = (0*LSCA) + (26*LSPA)(*MT0I+PAD) = 1712 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+54] offset:1776 // lwoA_0_0_27_0 = (0*LSCA) + (27*LSPA)(*MT0I+PAD) = 1776 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+7] offset:1840 // lwoA_0_0_28_0 = (0*LSCA) + (28*LSPA)(*MT0I+PAD) = 1840 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+23] offset:1904 // lwoA_0_0_29_0 = (0*LSCA) + (29*LSPA)(*MT0I+PAD) = 1904 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+39] offset:1968 // lwoA_0_0_30_0 = (0*LSCA) + (30*LSPA)(*MT0I+PAD) = 1968 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+55] offset:2032 // lwoA_0_0_31_0 = (0*LSCA) + (31*LSPA)(*MT0I+PAD) = 2032 sync LDS0

/* local write b */
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+0] offset:0 // lwoB_0_0_0_0 = (0*LSCB) + (0*LSPB)(*MT1J+PAD) = 0 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+8] offset:64 // lwoB_0_0_1_0 = (0*LSCB) + (1*LSPB)(*MT1J+PAD) = 64 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+16] offset:128 // lwoB_0_0_2_0 = (0*LSCB) + (2*LSPB)(*MT1J+PAD) = 128 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+24] offset:192 // lwoB_0_0_3_0 = (0*LSCB) + (3*LSPB)(*MT1J+PAD) = 192 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+1] offset:272 // lwoB_0_0_4_0 = (0*LSCB) + (4*LSPB)(*MT1J+PAD) = 272 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+9] offset:336 // lwoB_0_0_5_0 = (0*LSCB) + (5*LSPB)(*MT1J+PAD) = 336 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+17] offset:400 // lwoB_0_0_6_0 = (0*LSCB) + (6*LSPB)(*MT1J+PAD) = 400 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+25] offset:464 // lwoB_0_0_7_0 = (0*LSCB) + (7*LSPB)(*MT1J+PAD) = 464 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+2] offset:544 // lwoB_0_0_8_0 = (0*LSCB) + (8*LSPB)(*MT1J+PAD) = 544 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+10] offset:608 // lwoB_0_0_9_0 = (0*LSCB) + (9*LSPB)(*MT1J+PAD) = 608 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+18] offset:672 // lwoB_0_0_10_0 = (0*LSCB) + (10*LSPB)(*MT1J+PAD) = 672 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+26] offset:736 // lwoB_0_0_11_0 = (0*LSCB) + (11*LSPB)(*MT1J+PAD) = 736 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+3] offset:816 // lwoB_0_0_12_0 = (0*LSCB) + (12*LSPB)(*MT1J+PAD) = 816 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+11] offset:880 // lwoB_0_0_13_0 = (0*LSCB) + (13*LSPB)(*MT1J+PAD) = 880 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+19] offset:944 // lwoB_0_0_14_0 = (0*LSCB) + (14*LSPB)(*MT1J+PAD) = 944 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+27] offset:1008 // lwoB_0_0_15_0 = (0*LSCB) + (15*LSPB)(*MT1J+PAD) = 1008 sync LDS0

/* Recalc local read offsets */
s_wait_dscnt 0                                     // 5wait for local write
// Skip force waitcnt0
s_barrier_signal -1
s_barrier_wait -1                                  // Tail loop LW->LR, sync LDS0
.set vgprG2LA_BASE, UNDEF
.set vgprG2LA, UNDEF
.set vgprG2LB_BASE, UNDEF
.set vgprG2LB, UNDEF
.set vgprValuA_X0_I0_BASE, 60
.set vgprValuA_X0_I0, vgprValuA_X0_I0_BASE+0
.set vgprValuA_X0_I0_D0_PACK, 68
.set vgprValuA_X0_I0_D1, vgprValuA_X0_I0_D0_PACK+0
.set vgprValuA_X0_I0_D2, vgprValuA_X0_I0_D0_PACK+8
.set vgprValuA_X0_I0_D3, vgprValuA_X0_I0_D0_PACK+16
.set vgprValuB_X0_I0_BASE, 92
.set vgprValuB_X0_I0, vgprValuB_X0_I0_BASE+0
.set vgprValuB_X0_I0_D0_PACK, 100
.set vgprValuB_X0_I0_D1, vgprValuB_X0_I0_D0_PACK+0
.set vgprValuB_X0_I0_D2, vgprValuB_X0_I0_D0_PACK+8
.set vgprValuB_X0_I0_D3, vgprValuB_X0_I0_D0_PACK+16
.set vgprPackTemp, 124

/* Tail: local read init pointers a */

/* localReadInitPointers */

/* Tail: local read init pointers b */

/* localReadInitPointers */

/* tail loop: macs */
.align 16
label_TailLoopBeginL:

/* local read a */
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
s_wait_alu depctr_va_vdst(14) depctr_vm_vsrc(6)
ds_load_u8 v[vgprValuA_X0_I0+0], v[vgprLocalReadAddrA+0] offset:0 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D1+0], v[vgprLocalReadAddrA+0] offset:32 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D2+0], v[vgprLocalReadAddrA+0] offset:64 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=2 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D3+0], v[vgprLocalReadAddrA+0] offset:96 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=3 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0+1], v[vgprLocalReadAddrA+0] offset:128 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=4 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D1+1], v[vgprLocalReadAddrA+0] offset:160 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=5 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D2+1], v[vgprLocalReadAddrA+0] offset:192 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=6 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D3+1], v[vgprLocalReadAddrA+0] offset:224 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=7 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0+2], v[vgprLocalReadAddrA+0] offset:256 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=8 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D1+2], v[vgprLocalReadAddrA+0] offset:288 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=9 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D2+2], v[vgprLocalReadAddrA+0] offset:320 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=10 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D3+2], v[vgprLocalReadAddrA+0] offset:352 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=11 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0+3], v[vgprLocalReadAddrA+0] offset:384 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=12 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D1+3], v[vgprLocalReadAddrA+0] offset:416 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=13 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D2+3], v[vgprLocalReadAddrA+0] offset:448 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=14 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D3+3], v[vgprLocalReadAddrA+0] offset:480 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=15 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0+4], v[vgprLocalReadAddrA+0] offset:1056 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=16 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D1+4], v[vgprLocalReadAddrA+0] offset:1088 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=17 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D2+4], v[vgprLocalReadAddrA+0] offset:1120 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=18 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D3+4], v[vgprLocalReadAddrA+0] offset:1152 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=19 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0+5], v[vgprLocalReadAddrA+0] offset:1184 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=20 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D1+5], v[vgprLocalReadAddrA+0] offset:1216 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=21 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D2+5], v[vgprLocalReadAddrA+0] offset:1248 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=22 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D3+5], v[vgprLocalReadAddrA+0] offset:1280 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=23 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0+6], v[vgprLocalReadAddrA+0] offset:1312 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=24 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D1+6], v[vgprLocalReadAddrA+0] offset:1344 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=25 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D2+6], v[vgprLocalReadAddrA+0] offset:1376 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=26 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D3+6], v[vgprLocalReadAddrA+0] offset:1408 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=27 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0+7], v[vgprLocalReadAddrA+0] offset:1440 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=28 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D1+7], v[vgprLocalReadAddrA+0] offset:1472 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=29 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D2+7], v[vgprLocalReadAddrA+0] offset:1504 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=30 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D3+7], v[vgprLocalReadAddrA+0] offset:1536 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=31 oIdx=0 buffer=0 iui=0 sync LDS0

/* local read b */
s_wait_alu depctr_va_vdst(13)
ds_load_u8 v[vgprValuB_X0_I0+0], v[vgprLocalReadAddrB+0] offset:0 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D1+0], v[vgprLocalReadAddrB+0] offset:16 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D2+0], v[vgprLocalReadAddrB+0] offset:32 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=2 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D3+0], v[vgprLocalReadAddrB+0] offset:48 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=3 oIdx=0 buffer=0 iui=0 sync LDS0
s_wait_alu depctr_va_vdst(12)
ds_load_u8 v[vgprValuB_X0_I0+1], v[vgprLocalReadAddrB+0] offset:64 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=4 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D1+1], v[vgprLocalReadAddrB+0] offset:80 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=5 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D2+1], v[vgprLocalReadAddrB+0] offset:96 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=6 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D3+1], v[vgprLocalReadAddrB+0] offset:112 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=7 oIdx=0 buffer=0 iui=0 sync LDS0
s_wait_alu depctr_va_vdst(9)
ds_load_u8 v[vgprValuB_X0_I0+2], v[vgprLocalReadAddrB+0] offset:128 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=8 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D1+2], v[vgprLocalReadAddrB+0] offset:144 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=9 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D2+2], v[vgprLocalReadAddrB+0] offset:160 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=10 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D3+2], v[vgprLocalReadAddrB+0] offset:176 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=11 oIdx=0 buffer=0 iui=0 sync LDS0
s_wait_alu depctr_va_vdst(8)
ds_load_u8 v[vgprValuB_X0_I0+3], v[vgprLocalReadAddrB+0] offset:192 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=12 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D1+3], v[vgprLocalReadAddrB+0] offset:208 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=13 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D2+3], v[vgprLocalReadAddrB+0] offset:224 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=14 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D3+3], v[vgprLocalReadAddrB+0] offset:240 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=15 oIdx=0 buffer=0 iui=0 sync LDS0
s_wait_alu depctr_va_vdst(5)
ds_load_u8 v[vgprValuB_X0_I0+4], v[vgprLocalReadAddrB+0] offset:544 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=16 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D1+4], v[vgprLocalReadAddrB+0] offset:560 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=17 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D2+4], v[vgprLocalReadAddrB+0] offset:576 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=18 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D3+4], v[vgprLocalReadAddrB+0] offset:592 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=19 oIdx=0 buffer=0 iui=0 sync LDS0
s_wait_alu depctr_va_vdst(4)
ds_load_u8 v[vgprValuB_X0_I0+5], v[vgprLocalReadAddrB+0] offset:608 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=20 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D1+5], v[vgprLocalReadAddrB+0] offset:624 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=21 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D2+5], v[vgprLocalReadAddrB+0] offset:640 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=22 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D3+5], v[vgprLocalReadAddrB+0] offset:656 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=23 oIdx=0 buffer=0 iui=0 sync LDS0
s_wait_alu depctr_va_vdst(1)
ds_load_u8 v[vgprValuB_X0_I0+6], v[vgprLocalReadAddrB+0] offset:672 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=24 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D1+6], v[vgprLocalReadAddrB+0] offset:688 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=25 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D2+6], v[vgprLocalReadAddrB+0] offset:704 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=26 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D3+6], v[vgprLocalReadAddrB+0] offset:720 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=27 oIdx=0 buffer=0 iui=0 sync LDS0
s_wait_alu depctr_va_vdst(0)
ds_load_u8 v[vgprValuB_X0_I0+7], v[vgprLocalReadAddrB+0] offset:736 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=28 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D1+7], v[vgprLocalReadAddrB+0] offset:752 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=29 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D2+7], v[vgprLocalReadAddrB+0] offset:768 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=30 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuB_X0_I0_D3+7], v[vgprLocalReadAddrB+0] offset:784 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=31 oIdx=0 buffer=0 iui=0 sync LDS0

/* local read inc a */
/* Adding additional 64 pad since cumulative inc has reached 512 */
s_mov_b32 s8, 2112                                 // inc
s_wait_alu depctr_vm_vsrc(6)
v_add_co_u32 v[vgprLocalReadAddrA+0], vcc_lo, s8, v[vgprLocalReadAddrA+0] // lrA += 2048 ((MT+PAD)*bpeDS)

/* local read inc b */
/* Adding additional 64 pad since cumulative inc has reached 256 */
s_mov_b32 s8, 1088                                 // inc
s_wait_alu depctr_vm_vsrc(0)
v_add_co_u32 v[vgprLocalReadAddrB+0], vcc_lo, s8, v[vgprLocalReadAddrB+0] // lrB += 1024 ((MT+PAD)*bpeDS)
s_wait_dscnt 0                                     // 4wait for local read
v_lshl_or_b32 v[vgprValuA_X0_I0+0], v[vgprValuA_X0_I0_D1+0], 8, v[vgprValuA_X0_I0+0] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+0], v[vgprValuA_X0_I0_D3+0], 8, v[vgprValuA_X0_I0_D2+0] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+0], v[vgprValuA_X0_I0_D2+0], 0x10, v[vgprValuA_X0_I0+0] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+1], v[vgprValuA_X0_I0_D1+1], 8, v[vgprValuA_X0_I0+1] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+1], v[vgprValuA_X0_I0_D3+1], 8, v[vgprValuA_X0_I0_D2+1] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+1], v[vgprValuA_X0_I0_D2+1], 0x10, v[vgprValuA_X0_I0+1] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+2], v[vgprValuA_X0_I0_D1+2], 8, v[vgprValuA_X0_I0+2] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+2], v[vgprValuA_X0_I0_D3+2], 8, v[vgprValuA_X0_I0_D2+2] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+2], v[vgprValuA_X0_I0_D2+2], 0x10, v[vgprValuA_X0_I0+2] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+3], v[vgprValuA_X0_I0_D1+3], 8, v[vgprValuA_X0_I0+3] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+3], v[vgprValuA_X0_I0_D3+3], 8, v[vgprValuA_X0_I0_D2+3] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+3], v[vgprValuA_X0_I0_D2+3], 0x10, v[vgprValuA_X0_I0+3] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+4], v[vgprValuA_X0_I0_D1+4], 8, v[vgprValuA_X0_I0+4] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+4], v[vgprValuA_X0_I0_D3+4], 8, v[vgprValuA_X0_I0_D2+4] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+4], v[vgprValuA_X0_I0_D2+4], 0x10, v[vgprValuA_X0_I0+4] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+5], v[vgprValuA_X0_I0_D1+5], 8, v[vgprValuA_X0_I0+5] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+5], v[vgprValuA_X0_I0_D3+5], 8, v[vgprValuA_X0_I0_D2+5] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+5], v[vgprValuA_X0_I0_D2+5], 0x10, v[vgprValuA_X0_I0+5] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+6], v[vgprValuA_X0_I0_D1+6], 8, v[vgprValuA_X0_I0+6] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+6], v[vgprValuA_X0_I0_D3+6], 8, v[vgprValuA_X0_I0_D2+6] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+6], v[vgprValuA_X0_I0_D2+6], 0x10, v[vgprValuA_X0_I0+6] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+7], v[vgprValuA_X0_I0_D1+7], 8, v[vgprValuA_X0_I0+7] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+7], v[vgprValuA_X0_I0_D3+7], 8, v[vgprValuA_X0_I0_D2+7] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+7], v[vgprValuA_X0_I0_D2+7], 0x10, v[vgprValuA_X0_I0+7] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+0], v[vgprValuB_X0_I0_D1+0], 8, v[vgprValuB_X0_I0+0] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0_D2+0], v[vgprValuB_X0_I0_D3+0], 8, v[vgprValuB_X0_I0_D2+0] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+0], v[vgprValuB_X0_I0_D2+0], 0x10, v[vgprValuB_X0_I0+0] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+1], v[vgprValuB_X0_I0_D1+1], 8, v[vgprValuB_X0_I0+1] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0_D2+1], v[vgprValuB_X0_I0_D3+1], 8, v[vgprValuB_X0_I0_D2+1] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+1], v[vgprValuB_X0_I0_D2+1], 0x10, v[vgprValuB_X0_I0+1] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+2], v[vgprValuB_X0_I0_D1+2], 8, v[vgprValuB_X0_I0+2] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0_D2+2], v[vgprValuB_X0_I0_D3+2], 8, v[vgprValuB_X0_I0_D2+2] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+2], v[vgprValuB_X0_I0_D2+2], 0x10, v[vgprValuB_X0_I0+2] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+3], v[vgprValuB_X0_I0_D1+3], 8, v[vgprValuB_X0_I0+3] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0_D2+3], v[vgprValuB_X0_I0_D3+3], 8, v[vgprValuB_X0_I0_D2+3] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+3], v[vgprValuB_X0_I0_D2+3], 0x10, v[vgprValuB_X0_I0+3] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+4], v[vgprValuB_X0_I0_D1+4], 8, v[vgprValuB_X0_I0+4] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0_D2+4], v[vgprValuB_X0_I0_D3+4], 8, v[vgprValuB_X0_I0_D2+4] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+4], v[vgprValuB_X0_I0_D2+4], 0x10, v[vgprValuB_X0_I0+4] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+5], v[vgprValuB_X0_I0_D1+5], 8, v[vgprValuB_X0_I0+5] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0_D2+5], v[vgprValuB_X0_I0_D3+5], 8, v[vgprValuB_X0_I0_D2+5] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+5], v[vgprValuB_X0_I0_D2+5], 0x10, v[vgprValuB_X0_I0+5] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+6], v[vgprValuB_X0_I0_D1+6], 8, v[vgprValuB_X0_I0+6] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0_D2+6], v[vgprValuB_X0_I0_D3+6], 8, v[vgprValuB_X0_I0_D2+6] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+6], v[vgprValuB_X0_I0_D2+6], 0x10, v[vgprValuB_X0_I0+6] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+7], v[vgprValuB_X0_I0_D1+7], 8, v[vgprValuB_X0_I0+7] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0_D2+7], v[vgprValuB_X0_I0_D3+7], 8, v[vgprValuB_X0_I0_D2+7] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuB_X0_I0+7], v[vgprValuB_X0_I0_D2+7], 0x10, v[vgprValuB_X0_I0+7] // pack two half Vgpr to one Vgpr
v_and_b32 v125, 31, v[vgprSerial]                  // v125 = v[vgprSerial] % 32
v_lshrrev_b32 v125, 4, v125                        // 125 = 125 / 16
v_lshlrev_b32 v125, 4, v125                        // v125 = v125 * 16
v_add_nc_u32 v126, v125, 0
v_cmp_ge_i32 s66, v126, s[sgprLoopCounterL]        // check K index >= Size L
v_cndmask_b32 v[vgprValuA_X0_I0+0+0+0+0], v[vgprValuA_X0_I0+0+0+0+0], 0, s66 // set 0 if K_idx >= sizeL
v_cndmask_b32 v[vgprValuA_X0_I0+0+0+0+1], v[vgprValuA_X0_I0+0+0+0+1], 0, s66 // set 0 if K_idx >= sizeL
v_add_nc_u32 v126, v126, 8                         // add part of K
v_cmp_ge_i32 s66, v126, s[sgprLoopCounterL]        // check K index >= Size L
v_cndmask_b32 v[vgprValuA_X0_I0+0+0+0+2], v[vgprValuA_X0_I0+0+0+0+2], 0, s66 // set 0 if K_idx >= sizeL
v_cndmask_b32 v[vgprValuA_X0_I0+0+0+0+3], v[vgprValuA_X0_I0+0+0+0+3], 0, s66 // set 0 if K_idx >= sizeL
v_add_nc_u32 v126, v126, 24                        // add part of K
v_cmp_ge_i32 s66, v126, s[sgprLoopCounterL]        // check K index >= Size L
v_cndmask_b32 v[vgprValuA_X0_I0+0+0+0+4], v[vgprValuA_X0_I0+0+0+0+4], 0, s66 // set 0 if K_idx >= sizeL
v_cndmask_b32 v[vgprValuA_X0_I0+0+0+0+5], v[vgprValuA_X0_I0+0+0+0+5], 0, s66 // set 0 if K_idx >= sizeL
v_add_nc_u32 v126, v126, 8                         // add part of K
v_cmp_ge_i32 s66, v126, s[sgprLoopCounterL]        // check K index >= Size L
v_cndmask_b32 v[vgprValuA_X0_I0+0+0+0+6], v[vgprValuA_X0_I0+0+0+0+6], 0, s66 // set 0 if K_idx >= sizeL
v_cndmask_b32 v[vgprValuA_X0_I0+0+0+0+7], v[vgprValuA_X0_I0+0+0+0+7], 0, s66 // set 0 if K_idx >= sizeL
v_and_b32 v125, 31, v[vgprSerial]                  // v125 = v[vgprSerial] % 32
v_lshrrev_b32 v125, 4, v125                        // 125 = 125 / 16
v_lshlrev_b32 v125, 4, v125                        // v125 = v125 * 16
v_add_nc_u32 v126, v125, 0
v_cmp_ge_i32 s66, v126, s[sgprLoopCounterL]        // check K index >= Size L
v_cndmask_b32 v[vgprValuB_X0_I0+0+0+0+0], v[vgprValuB_X0_I0+0+0+0+0], 0, s66 // set 0 if K_idx >= sizeL
v_cndmask_b32 v[vgprValuB_X0_I0+0+0+0+1], v[vgprValuB_X0_I0+0+0+0+1], 0, s66 // set 0 if K_idx >= sizeL
v_add_nc_u32 v126, v126, 8                         // add part of K
v_cmp_ge_i32 s66, v126, s[sgprLoopCounterL]        // check K index >= Size L
v_cndmask_b32 v[vgprValuB_X0_I0+0+0+0+2], v[vgprValuB_X0_I0+0+0+0+2], 0, s66 // set 0 if K_idx >= sizeL
v_cndmask_b32 v[vgprValuB_X0_I0+0+0+0+3], v[vgprValuB_X0_I0+0+0+0+3], 0, s66 // set 0 if K_idx >= sizeL
v_add_nc_u32 v126, v126, 24                        // add part of K
v_cmp_ge_i32 s66, v126, s[sgprLoopCounterL]        // check K index >= Size L
v_cndmask_b32 v[vgprValuB_X0_I0+0+0+0+4], v[vgprValuB_X0_I0+0+0+0+4], 0, s66 // set 0 if K_idx >= sizeL
v_cndmask_b32 v[vgprValuB_X0_I0+0+0+0+5], v[vgprValuB_X0_I0+0+0+0+5], 0, s66 // set 0 if K_idx >= sizeL
v_add_nc_u32 v126, v126, 8                         // add part of K
v_cmp_ge_i32 s66, v126, s[sgprLoopCounterL]        // check K index >= Size L
v_cndmask_b32 v[vgprValuB_X0_I0+0+0+0+6], v[vgprValuB_X0_I0+0+0+0+6], 0, s66 // set 0 if K_idx >= sizeL
v_cndmask_b32 v[vgprValuB_X0_I0+0+0+0+7], v[vgprValuB_X0_I0+0+0+0+7], 0, s66 // set 0 if K_idx >= sizeL
s_nop 1
v_wmma_f32_16x16x64_fp8_fp8 v[vgprValuC+0:vgprValuC+0+7], v[vgprValuA_X0_I0+0+0+0:vgprValuA_X0_I0+0+0+0+7], v[vgprValuB_X0_I0+0+0+0:vgprValuB_X0_I0+0+0+0+7], v[vgprValuC+0:vgprValuC+0+7] // left value = v[0+0:7+0]

/* closeLoop loopL finalLoop=1 tailLoop=1 */
s_sub_i32 s[sgprLoopCounterL], s[sgprLoopCounterL], 0x40 // dec counterL (tailLoop)
s_add_u32 s[sgprOrigLoopCounter], s[sgprOrigLoopCounter], 0x40 // inc counterL
s_cmp_le_i32 s[sgprLoopCounterL], 0x0              // counterL<=0
s_cbranch_scc0 label_TailLoopBeginL                // restart LoopL
label_TailLoopEndL:
label_SkipTailLoopL:
.set vgprValuA_X0_I0_BASE, UNDEF
.set vgprValuA_X0_I0, UNDEF
.set vgprValuA_X0_I0_D0_PACK, UNDEF
.set vgprValuA_X0_I0_D1, UNDEF
.set vgprValuA_X0_I0_D2, UNDEF
.set vgprValuA_X0_I0_D3, UNDEF
.set vgprValuB_X0_I0_BASE, UNDEF
.set vgprValuB_X0_I0, UNDEF
.set vgprValuB_X0_I0_D0_PACK, UNDEF
.set vgprValuB_X0_I0_D1, UNDEF
.set vgprValuB_X0_I0_D2, UNDEF
.set vgprValuB_X0_I0_D3, UNDEF
.set vgprPackTemp, UNDEF

/* Tail: add MISC Vgpr [8...60) to pool */
label_Summation_End_TJDMMDJV7ZDZEYC5:
.set sgprWGM, UNDEF
.set sgprLoopCounterL, UNDEF
.set sgprOrigLoopCounter, UNDEF
.set sgprSrdA, UNDEF
.set sgprSrdB, UNDEF
.set sgprAddressA, UNDEF
.set sgprAddressB, UNDEF
.set sgprStridesA, UNDEF
.set sgprStridesB, UNDEF
.set sgprStaggerUIter, UNDEF
.set sgprShadowLimitA, UNDEF
.set sgprShadowLimitB, UNDEF
.set sgprWrapUA, UNDEF
.set sgprWrapUB, UNDEF
.set sgprGlobalReadIncsA, UNDEF
.set sgprGlobalReadIncsB, UNDEF
/* load store sgprs */

/* Mapping of Acc register -> C Vgpr register */

/* Multiply MI out register with Alpha -> C Vgpr register */

/* not-LocalSplitU: global write indices */
/* computeStoreVgprs */
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
s_wait_alu depctr_vm_vsrc(6)
v_lshrrev_b32 v12, 5, v[vgprSerial]                // 12 = Serial / 32
v_lshrrev_b32 v13, 1, v12                          // 13 = 12 / 2
v_lshlrev_b32 v9, 4, v13                           // wave coordination offset 1
v_and_b32 v13, 15, v[vgprSerial]                   // v13 = v[vgprSerial] % 16
v_add_lshl_u32 v9, v13, v9, 0                      // coordination 1 = vwB *(wave_id1 + tid1)
v_mul_lo_u32 v10, v9, s[sgprStrideC1J]             //  offset 1
v_mul_lo_u32 v11, v9, s[sgprStrideD1J]             //  offset 1
v_and_b32 v13, 1, v12                              // v13 = v12 % 2
v_lshlrev_b32 v13, 4, v13                          // wave coordination offset 0
v_and_b32 v8, 31, v[vgprSerial]                    // v8 = v[vgprSerial] % 32
v_lshrrev_b32 v8, 4, v8                            // 8 = 8 / 16
v_lshlrev_b32 v8, 3, v8                            // thread0 * continuous_output
v_add_lshl_u32 v8, v13, v8, 0                      // coordination 0 = vwA *(wave_id0 + tid0)
s_mul_i32 s8, 32, s[sgprWorkGroup0]                // wgp0 * MT0
v_add_nc_u32 v8, s8, v8                            // coord 0 = (tid0/MI_m)*4 + waveG0*MIB_m + MT0*SG0
s_mul_i32 s8, 16, s[sgprWorkGroup1]                // wgp1 * MT1
v_add_nc_u32 v9, s8, v9                            // coord 1 = (tid0%MI_m) + waveG1*MIB_n + MT1*SG1

/* not-LocalSplitU: global write */

/******************************************/
/* Global Write Elements                  */
/******************************************/
s_and_b32 s8, s[sgprGSU], 0x3fff                   // Restore GSU
s_cmp_eq_u32 s8, 1                                 // GSU == 1 ?
s_cbranch_scc1 label_GSU_4                         // branch if GSU == 1
label_GW_B0_MB:
label_GW_B0_FD0_MB:

/* Edge/NonEdge store path check (M): Size % 32 > 0 -> Edge store; else -> NonEdge store */
s_and_b32 s24, 31, s[sgprSizeI]                    // s24 = s[sgprSizeI] % 32
s_add_u32 s25, -0x1, s[sgprNumWorkGroups0]
s_cmp_ge_u32 s[sgprWorkGroup0], s25                // wg0 >= nwg0-1 ?
s_cselect_b32 s24, s24, 0                          // set rem
s_mov_b32 s8, 0
s_cmp_gt_u32 s24, s8                               // rem > 0
s_cbranch_scc1 label_GW_B0_FD0_VW8_MB_Else         // jump if edges required

/* Edge/NonEdge store path check (N (isSize1)): Size % 16 > 0 -> Edge store; else -> NonEdge store */
s_and_b32 s24, 15, s[sgprSizeJ]                    // s24 = s[sgprSizeJ] % 16
s_add_u32 s25, -0x1, s[sgprNumWorkGroups1]
s_cmp_ge_u32 s[sgprWorkGroup1], s25                // wg1 >= nwg1-1
s_cselect_b32 s24, s24, 0                          // set rem
s_mov_b32 s8, 0
s_cmp_gt_u32 s24, s8                               // rem > 0
s_cbranch_scc1 label_GW_B0_FD0_VW8_MB_Then         // jump if edges required
label_GW_B0_FD0_VW8_MB_NonEdge:

/* edge=0, allocate 1 sgpr. perBatchTmpS=1 perBatchMaskS=0 perElementMaskS=0 elementsPerBatch=28 */
/* optSingleColVgpr=1 optSharedColVgpr=0 optSGPRUsage=BufferLoad_Mask optSrdIncForRow=1 factorDim=0 */

/******************************************/
/* Global Write Batch #0 (d1,d0,vc1,vc0) = */
/*    (0,0,0,0:vw8)                       */
/******************************************/

/* calc coords, apply mask, and issue loads (if necessary) */
/* (d1,vc1,d0,vc0)=(0,0,0,0) */
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_add_lshl_u32 v19, v11, v8, 2                     // optSingleColVgpr scaleToBpe: sharedAddrVgpr <- cinRowPtr + coord0, scaled by BPE. BSHERE:coord0=8, coord0Vgpr=8 (multiple bpe)

/* rC *= alpha batchElements=[(0, 0, 0, 0)] */
v_mov_b32 v[vgprValuC+24], v[vgprValuC+0]          // Rearrange MI out reg
v_mov_b32 v[vgprValuC+25], v[vgprValuC+1]          // Rearrange MI out reg
v_mov_b32 v[vgprValuC+26], v[vgprValuC+2]          // Rearrange MI out reg
v_mov_b32 v[vgprValuC+27], v[vgprValuC+3]          // Rearrange MI out reg
v_mov_b32 v[vgprValuC+28], v[vgprValuC+4]          // Rearrange MI out reg
v_mov_b32 v[vgprValuC+29], v[vgprValuC+5]          // Rearrange MI out reg
v_mov_b32 v[vgprValuC+30], v[vgprValuC+6]          // Rearrange MI out reg
v_mov_b32 v[vgprValuC+31], v[vgprValuC+7]          // Rearrange MI out reg

/* apply mask, calc new C and issue writes */
s_wait_alu depctr_va_vdst(4)
buffer_store_b128 v[24:27], v19, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(0)
buffer_store_b128 v[28:31], v19, s[sgprSrdD:sgprSrdD+3], null offen offset:16 scope:SCOPE_CU th:TH_STORE_RT // store D
s_nop 0                                            // 1 wait state required when next inst writes vgprs held by previous dwordx4 store inst
s_branch label_GW_End_1                            // jump to end
label_GW_B0_FD0_VW8_MB_NonEdgeEnd:
label_GW_B0_FD0_VW8_MB_Then:

/* edge=1, allocate 3 sgpr. perBatchTmpS=2 perBatchMaskS=1 perElementMaskS=0 elementsPerBatch=24 */
/* optSingleColVgpr=0 optSharedColVgpr=0 optSGPRUsage=BufferLoad_Edge_Mask optSrdIncForRow=0 factorDim=0 */

/******************************************/
/* Global Write Edge Batch #0 (d1,d0,vc1,vc0) = */
/*    (0,0,0,0:vw8)                       */
/******************************************/

/* calc coords, apply mask, and issue loads (if necessary) */
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v14, BufferOOB
/* (d1,vc1,d0,vc0)=(0,0,0,0) */
v_cmp_lt_u32 s24, v8, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s26, v9, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s26, s24, s26                            // in0 && in1
v_add_lshl_u32 v19, v11, v8, 2                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v19, v14, v19, s26                   // LDD clip if OOB. offset

/* rC *= alpha batchElements=[(0, 0, 0, 0)] */
v_mov_b32 v[vgprValuC+24], v[vgprValuC+0]          // Rearrange MI out reg
v_mov_b32 v[vgprValuC+25], v[vgprValuC+1]          // Rearrange MI out reg
v_mov_b32 v[vgprValuC+26], v[vgprValuC+2]          // Rearrange MI out reg
v_mov_b32 v[vgprValuC+27], v[vgprValuC+3]          // Rearrange MI out reg
v_mov_b32 v[vgprValuC+28], v[vgprValuC+4]          // Rearrange MI out reg
v_mov_b32 v[vgprValuC+29], v[vgprValuC+5]          // Rearrange MI out reg
v_mov_b32 v[vgprValuC+30], v[vgprValuC+6]          // Rearrange MI out reg
v_mov_b32 v[vgprValuC+31], v[vgprValuC+7]          // Rearrange MI out reg

/* apply mask, calc new C and issue writes */
s_wait_alu depctr_va_vdst(4)
buffer_store_b128 v[24:27], v19, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(0)
buffer_store_b128 v[28:31], v19, s[sgprSrdD:sgprSrdD+3], null offen offset:16 scope:SCOPE_CU th:TH_STORE_RT // store D
s_nop 0                                            // 1 wait state required when next inst writes vgprs held by previous dwordx4 store inst
s_branch label_GW_End_1                            // jump to end
label_GW_B0_FD0_VW8_MB_Else:
label_GW_B0_FD0_VW1_MB_Else:
label_GW_B0_FD0_VW1_MB_Then:

/* edge=1, allocate 3 sgpr. perBatchTmpS=2 perBatchMaskS=1 perElementMaskS=0 elementsPerBatch=117 */
/* optSingleColVgpr=0 optSharedColVgpr=0 optSGPRUsage=BufferLoad_Edge_Mask optSrdIncForRow=0 factorDim=0 */

/******************************************/
/* Global Write Edge Batch #0 (d1,d0,vc1,vc0) = */
/*    (0,0,0,0:vw1); (0,0,0,1:vw1); (0,0,0,2:vw1); (0,0,0,3:vw1); (0,0,0,4:vw1); (0,0,0,5:vw1); (0,0,0,6:vw1); (0,0,0,7:vw1) */
/******************************************/

/* calc coords, apply mask, and issue loads (if necessary) */
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v14, BufferOOB
/* (d1,vc1,d0,vc0)=(0,0,0,0) */
v_cmp_lt_u32 s24, v8, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s26, v9, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s26, s24, s26                            // in0 && in1
v_add_lshl_u32 v27, v11, v8, 2                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v27, v14, v27, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,0,1) */
v_add_co_u32 v12, vcc_lo, v8, 1                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s24, v12, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v9, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s26, s24, s26                            // in0 && in1
v_add_lshl_u32 v28, v11, v12, 2                    // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v28, v14, v28, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,0,2) */
v_add_co_u32 v12, vcc_lo, v8, 2                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s24, v12, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v9, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s26, s24, s26                            // in0 && in1
v_add_lshl_u32 v29, v11, v12, 2                    // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v29, v14, v29, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,0,3) */
v_add_co_u32 v12, vcc_lo, v8, 3                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s24, v12, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v9, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s26, s24, s26                            // in0 && in1
v_add_lshl_u32 v30, v11, v12, 2                    // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v30, v14, v30, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,0,4) */
v_add_co_u32 v12, vcc_lo, v8, 4                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s24, v12, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v9, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s26, s24, s26                            // in0 && in1
v_add_lshl_u32 v31, v11, v12, 2                    // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v31, v14, v31, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,0,5) */
v_add_co_u32 v12, vcc_lo, v8, 5                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s24, v12, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v9, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s26, s24, s26                            // in0 && in1
v_add_lshl_u32 v32, v11, v12, 2                    // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v32, v14, v32, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,0,6) */
v_add_co_u32 v12, vcc_lo, v8, 6                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s24, v12, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v9, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s26, s24, s26                            // in0 && in1
v_add_lshl_u32 v33, v11, v12, 2                    // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v33, v14, v33, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,0,7) */
v_add_co_u32 v12, vcc_lo, v8, 7                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s24, v12, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v9, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s26, s24, s26                            // in0 && in1
v_add_lshl_u32 v34, v11, v12, 2                    // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v34, v14, v34, s26                   // LDD clip if OOB. offset

/* rC *= alpha batchElements=[(0, 0, 0, 0), (0, 0, 0, 1), (0, 0, 0, 2), (0, 0, 0, 3), (0, 0, 0, 4), (0, 0, 0, 5), (0, 0, 0, 6), (0, 0, 0, 7)] */
v_mov_b32 v[vgprValuC+19], v[vgprValuC+0]          // Rearrange MI out reg
v_mov_b32 v[vgprValuC+20], v[vgprValuC+1]          // Rearrange MI out reg
v_mov_b32 v[vgprValuC+21], v[vgprValuC+2]          // Rearrange MI out reg
v_mov_b32 v[vgprValuC+22], v[vgprValuC+3]          // Rearrange MI out reg
v_mov_b32 v[vgprValuC+23], v[vgprValuC+4]          // Rearrange MI out reg
v_mov_b32 v[vgprValuC+24], v[vgprValuC+5]          // Rearrange MI out reg
v_mov_b32 v[vgprValuC+25], v[vgprValuC+6]          // Rearrange MI out reg
v_mov_b32 v[vgprValuC+26], v[vgprValuC+7]          // Rearrange MI out reg

/* apply mask, calc new C and issue writes */
s_wait_alu depctr_va_vdst(7)
buffer_store_b32 v19, v27, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(6)
buffer_store_b32 v20, v28, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(5)
buffer_store_b32 v21, v29, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(4)
buffer_store_b32 v22, v30, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(3)
buffer_store_b32 v23, v31, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(2)
buffer_store_b32 v24, v32, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(1)
buffer_store_b32 v25, v33, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v26, v34, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_nop 0                                            // 1 wait state required when next inst writes vgprs held by previous dwordx4 store inst
s_branch label_GW_End_1                            // jump to end
label_GW_End_1:
s_getpc_b64 s[24:25]                               // addr of next instr
s_add_i32 s26, label_KernelEnd, 4                  // target branch offset
s_add_u32 s24, s24, s26                            // add target branch offset
s_addc_u32 s25, s25, 0                             // add high and carry
s_setpc_b64 s[24:25]                               // branch to label_KernelEnd
label_GSU_4:
s_mov_b32 s11, 0
s_cmp_eq_u32 s[sgprBeta], s11                      // Beta == 0
s_cbranch_scc0 label_GW_B1_GSU1                    // Branch if Beta is not zero

label_GW_B0_GSU1:
label_GW_B0_FD0_GSU1:

/* Edge/NonEdge store path check (M): Size % 32 > 0 -> Edge store; else -> NonEdge store */
s_and_b32 s24, 31, s[sgprSizeI]                    // s24 = s[sgprSizeI] % 32
s_add_u32 s25, -0x1, s[sgprNumWorkGroups0]
s_cmp_ge_u32 s[sgprWorkGroup0], s25                // wg0 >= nwg0-1 ?
s_cselect_b32 s24, s24, 0                          // set rem
s_mov_b32 s8, 0
s_cmp_gt_u32 s24, s8                               // rem > 0
s_cbranch_scc1 label_GW_B0_FD0_VW8_GSU1_Else       // jump if edges required

/* Edge/NonEdge store path check (N (isSize1)): Size % 16 > 0 -> Edge store; else -> NonEdge store */
s_and_b32 s24, 15, s[sgprSizeJ]                    // s24 = s[sgprSizeJ] % 16
s_add_u32 s25, -0x1, s[sgprNumWorkGroups1]
s_cmp_ge_u32 s[sgprWorkGroup1], s25                // wg1 >= nwg1-1
s_cselect_b32 s24, s24, 0                          // set rem
s_mov_b32 s8, 0
s_cmp_gt_u32 s24, s8                               // rem > 0
s_cbranch_scc1 label_GW_B0_FD0_VW8_GSU1_Then       // jump if edges required
label_GW_B0_FD0_VW8_GSU1_NonEdge:

/* edge=0, allocate 1 sgpr. perBatchTmpS=1 perBatchMaskS=0 perElementMaskS=0 elementsPerBatch=28 */
/* optSingleColVgpr=1 optSharedColVgpr=0 optSGPRUsage=BufferLoad_Mask optSrdIncForRow=1 factorDim=0 */

/******************************************/
/* Global Write Batch #0 (d1,d0,vc1,vc0) = */
/*    (0,0,0,0:vw8)                       */
/******************************************/

/* calc coords, apply mask, and issue loads (if necessary) */
/* (d1,vc1,d0,vc0)=(0,0,0,0) */
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_add_nc_u32 v19, v11, v8                          // optSingleColVgpr scaleToBpe: sharedAddrVgpr <- cinRowPtr + coord0, scaled by BPE. BSHERE:coord0=8, coord0Vgpr=8 (multiple bpe)
                                                   // optSingleColVgpr scaleToBpe: sharedAddrVgpr <- cinRowPtr + coord0, scaled by BPE. BSHERE:coord0=8, coord0Vgpr=8 (bpe is 1, no mul)

/* rC *= alpha batchElements=[(0, 0, 0, 0)] */
v_mul_f32 v[vgprValuC+24], s[sgprAlpha], v[vgprValuC+0] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+25], s[sgprAlpha], v[vgprValuC+1] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+26], s[sgprAlpha], v[vgprValuC+2] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+27], s[sgprAlpha], v[vgprValuC+3] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+28], s[sgprAlpha], v[vgprValuC+4] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+29], s[sgprAlpha], v[vgprValuC+5] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+30], s[sgprAlpha], v[vgprValuC+6] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+31], s[sgprAlpha], v[vgprValuC+7] // Multiply MI out reg with alpha

/* apply mask, calc new C and issue writes */
v_mov_b32 v16, 0x207                               // Nan and +/- inf
v_mov_b32 v18, 0x43E00000                          // Fp8 Max value 448 as float32
v_mov_b32 v17, 0xc3E00000                          // Fp8 Min value -448 as float32
v_cmp_class_f32 s8, v[vgprValuC+24], v16           // Nan and +/- inf
v_med3_f32 v15, v[vgprValuC+24], v17, v18
v_cndmask_b32 v[vgprValuC+24], v15, v[vgprValuC+24], s8
v_cmp_class_f32 s8, v[vgprValuC+25], v16           // Nan and +/- inf
v_med3_f32 v15, v[vgprValuC+25], v17, v18
v_cndmask_b32 v[vgprValuC+25], v15, v[vgprValuC+25], s8
v_cmp_class_f32 s8, v[vgprValuC+26], v16           // Nan and +/- inf
v_med3_f32 v15, v[vgprValuC+26], v17, v18
v_cndmask_b32 v[vgprValuC+26], v15, v[vgprValuC+26], s8
v_cmp_class_f32 s8, v[vgprValuC+27], v16           // Nan and +/- inf
v_med3_f32 v15, v[vgprValuC+27], v17, v18
v_cndmask_b32 v[vgprValuC+27], v15, v[vgprValuC+27], s8
v_cmp_class_f32 s8, v[vgprValuC+28], v16           // Nan and +/- inf
v_med3_f32 v15, v[vgprValuC+28], v17, v18
v_cndmask_b32 v[vgprValuC+28], v15, v[vgprValuC+28], s8
v_cmp_class_f32 s8, v[vgprValuC+29], v16           // Nan and +/- inf
v_med3_f32 v15, v[vgprValuC+29], v17, v18
v_cndmask_b32 v[vgprValuC+29], v15, v[vgprValuC+29], s8
v_cmp_class_f32 s8, v[vgprValuC+30], v16           // Nan and +/- inf
v_med3_f32 v15, v[vgprValuC+30], v17, v18
v_cndmask_b32 v[vgprValuC+30], v15, v[vgprValuC+30], s8
v_cmp_class_f32 s8, v[vgprValuC+31], v16           // Nan and +/- inf
v_med3_f32 v15, v[vgprValuC+31], v17, v18
v_cndmask_b32 v[vgprValuC+31], v15, v[vgprValuC+31], s8
v_cvt_scalef32_pk8_fp8_f32 v[24:25], v[vgprValuC+24:vgprValuC+24+7], 1.0 // convert 8xF32 to 8xFP8
s_wait_alu depctr_va_vdst(0)
buffer_store_b64 v[24:25], v19, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_nop 0                                            // 1 wait state required when next inst writes vgprs held by previous dwordx4 store inst
s_branch label_GW_End_2                            // jump to end
label_GW_B0_FD0_VW8_GSU1_NonEdgeEnd:
label_GW_B0_FD0_VW8_GSU1_Then:

/* edge=1, allocate 3 sgpr. perBatchTmpS=2 perBatchMaskS=1 perElementMaskS=0 elementsPerBatch=24 */
/* optSingleColVgpr=0 optSharedColVgpr=0 optSGPRUsage=BufferLoad_Edge_Mask optSrdIncForRow=0 factorDim=0 */

/******************************************/
/* Global Write Edge Batch #0 (d1,d0,vc1,vc0) = */
/*    (0,0,0,0:vw8)                       */
/******************************************/

/* calc coords, apply mask, and issue loads (if necessary) */
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v14, BufferOOB
/* (d1,vc1,d0,vc0)=(0,0,0,0) */
v_cmp_lt_u32 s24, v8, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s26, v9, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s26, s24, s26                            // in0 && in1
v_add_nc_u32 v19, v11, v8                          // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v19, v14, v19, s26                   // LDD clip if OOB. offset

/* rC *= alpha batchElements=[(0, 0, 0, 0)] */
v_mul_f32 v[vgprValuC+24], s[sgprAlpha], v[vgprValuC+0] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+25], s[sgprAlpha], v[vgprValuC+1] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+26], s[sgprAlpha], v[vgprValuC+2] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+27], s[sgprAlpha], v[vgprValuC+3] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+28], s[sgprAlpha], v[vgprValuC+4] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+29], s[sgprAlpha], v[vgprValuC+5] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+30], s[sgprAlpha], v[vgprValuC+6] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+31], s[sgprAlpha], v[vgprValuC+7] // Multiply MI out reg with alpha

/* apply mask, calc new C and issue writes */
v_mov_b32 v16, 0x207                               // Nan and +/- inf
v_mov_b32 v18, 0x43E00000                          // Fp8 Max value 448 as float32
v_mov_b32 v17, 0xc3E00000                          // Fp8 Min value -448 as float32
v_cmp_class_f32 s24, v[vgprValuC+24], v16          // Nan and +/- inf
v_med3_f32 v15, v[vgprValuC+24], v17, v18
v_cndmask_b32 v[vgprValuC+24], v15, v[vgprValuC+24], s24
v_cmp_class_f32 s24, v[vgprValuC+25], v16          // Nan and +/- inf
v_med3_f32 v15, v[vgprValuC+25], v17, v18
v_cndmask_b32 v[vgprValuC+25], v15, v[vgprValuC+25], s24
v_cmp_class_f32 s24, v[vgprValuC+26], v16          // Nan and +/- inf
v_med3_f32 v15, v[vgprValuC+26], v17, v18
v_cndmask_b32 v[vgprValuC+26], v15, v[vgprValuC+26], s24
v_cmp_class_f32 s24, v[vgprValuC+27], v16          // Nan and +/- inf
v_med3_f32 v15, v[vgprValuC+27], v17, v18
v_cndmask_b32 v[vgprValuC+27], v15, v[vgprValuC+27], s24
v_cmp_class_f32 s24, v[vgprValuC+28], v16          // Nan and +/- inf
v_med3_f32 v15, v[vgprValuC+28], v17, v18
v_cndmask_b32 v[vgprValuC+28], v15, v[vgprValuC+28], s24
v_cmp_class_f32 s24, v[vgprValuC+29], v16          // Nan and +/- inf
v_med3_f32 v15, v[vgprValuC+29], v17, v18
v_cndmask_b32 v[vgprValuC+29], v15, v[vgprValuC+29], s24
v_cmp_class_f32 s24, v[vgprValuC+30], v16          // Nan and +/- inf
v_med3_f32 v15, v[vgprValuC+30], v17, v18
v_cndmask_b32 v[vgprValuC+30], v15, v[vgprValuC+30], s24
v_cmp_class_f32 s24, v[vgprValuC+31], v16          // Nan and +/- inf
v_med3_f32 v15, v[vgprValuC+31], v17, v18
v_cndmask_b32 v[vgprValuC+31], v15, v[vgprValuC+31], s24
v_cvt_scalef32_pk8_fp8_f32 v[24:25], v[vgprValuC+24:vgprValuC+24+7], 1.0 // convert 8xF32 to 8xFP8
s_wait_alu depctr_va_vdst(0)
buffer_store_b64 v[24:25], v19, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_nop 0                                            // 1 wait state required when next inst writes vgprs held by previous dwordx4 store inst
s_branch label_GW_End_2                            // jump to end
label_GW_B0_FD0_VW8_GSU1_Else:
label_GW_B0_FD0_VW1_GSU1_Else:
label_GW_B0_FD0_VW1_GSU1_Then:

/* edge=1, allocate 3 sgpr. perBatchTmpS=2 perBatchMaskS=1 perElementMaskS=0 elementsPerBatch=117 */
/* optSingleColVgpr=0 optSharedColVgpr=0 optSGPRUsage=BufferLoad_Edge_Mask optSrdIncForRow=0 factorDim=0 */

/******************************************/
/* Global Write Edge Batch #0 (d1,d0,vc1,vc0) = */
/*    (0,0,0,0:vw1); (0,0,0,1:vw1); (0,0,0,2:vw1); (0,0,0,3:vw1); (0,0,0,4:vw1); (0,0,0,5:vw1); (0,0,0,6:vw1); (0,0,0,7:vw1) */
/******************************************/

/* calc coords, apply mask, and issue loads (if necessary) */
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v14, BufferOOB
/* (d1,vc1,d0,vc0)=(0,0,0,0) */
v_cmp_lt_u32 s24, v8, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s26, v9, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s26, s24, s26                            // in0 && in1
v_add_nc_u32 v27, v11, v8                          // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v27, v14, v27, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,0,1) */
v_add_co_u32 v12, vcc_lo, v8, 1                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s24, v12, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v9, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s26, s24, s26                            // in0 && in1
v_add_nc_u32 v28, v11, v12                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v28, v14, v28, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,0,2) */
v_add_co_u32 v12, vcc_lo, v8, 2                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s24, v12, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v9, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s26, s24, s26                            // in0 && in1
v_add_nc_u32 v29, v11, v12                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v29, v14, v29, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,0,3) */
v_add_co_u32 v12, vcc_lo, v8, 3                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s24, v12, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v9, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s26, s24, s26                            // in0 && in1
v_add_nc_u32 v30, v11, v12                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v30, v14, v30, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,0,4) */
v_add_co_u32 v12, vcc_lo, v8, 4                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s24, v12, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v9, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s26, s24, s26                            // in0 && in1
v_add_nc_u32 v31, v11, v12                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v31, v14, v31, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,0,5) */
v_add_co_u32 v12, vcc_lo, v8, 5                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s24, v12, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v9, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s26, s24, s26                            // in0 && in1
v_add_nc_u32 v32, v11, v12                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v32, v14, v32, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,0,6) */
v_add_co_u32 v12, vcc_lo, v8, 6                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s24, v12, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v9, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s26, s24, s26                            // in0 && in1
v_add_nc_u32 v33, v11, v12                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v33, v14, v33, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,0,7) */
v_add_co_u32 v12, vcc_lo, v8, 7                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s24, v12, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v9, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s26, s24, s26                            // in0 && in1
v_add_nc_u32 v34, v11, v12                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v34, v14, v34, s26                   // LDD clip if OOB. offset

/* rC *= alpha batchElements=[(0, 0, 0, 0), (0, 0, 0, 1), (0, 0, 0, 2), (0, 0, 0, 3), (0, 0, 0, 4), (0, 0, 0, 5), (0, 0, 0, 6), (0, 0, 0, 7)] */
v_mul_f32 v[vgprValuC+19], s[sgprAlpha], v[vgprValuC+0] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+20], s[sgprAlpha], v[vgprValuC+1] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+21], s[sgprAlpha], v[vgprValuC+2] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+22], s[sgprAlpha], v[vgprValuC+3] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+23], s[sgprAlpha], v[vgprValuC+4] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+24], s[sgprAlpha], v[vgprValuC+5] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+25], s[sgprAlpha], v[vgprValuC+6] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+26], s[sgprAlpha], v[vgprValuC+7] // Multiply MI out reg with alpha

/* apply mask, calc new C and issue writes */
v_mov_b32 v16, 0x207                               // Nan and +/- inf
v_mov_b32 v18, 0x43E00000                          // Fp8 Max value 448 as float32
v_mov_b32 v17, 0xc3E00000                          // Fp8 Min value -448 as float32
v_cmp_class_f32 s24, v[vgprValuC+19], v16          // Nan and +/- inf
v_med3_f32 v15, v[vgprValuC+19], v17, v18
v_cndmask_b32 v[vgprValuC+19], v15, v[vgprValuC+19], s24
v_cvt_pk_fp8_f32 v19, v[vgprValuC+19], v[vgprValuC+19] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v19, v27, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s24, v[vgprValuC+20], v16          // Nan and +/- inf
v_med3_f32 v15, v[vgprValuC+20], v17, v18
v_cndmask_b32 v[vgprValuC+20], v15, v[vgprValuC+20], s24
v_cvt_pk_fp8_f32 v20, v[vgprValuC+20], v[vgprValuC+20] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v20, v28, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s24, v[vgprValuC+21], v16          // Nan and +/- inf
v_med3_f32 v15, v[vgprValuC+21], v17, v18
v_cndmask_b32 v[vgprValuC+21], v15, v[vgprValuC+21], s24
v_cvt_pk_fp8_f32 v21, v[vgprValuC+21], v[vgprValuC+21] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v21, v29, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s24, v[vgprValuC+22], v16          // Nan and +/- inf
v_med3_f32 v15, v[vgprValuC+22], v17, v18
v_cndmask_b32 v[vgprValuC+22], v15, v[vgprValuC+22], s24
v_cvt_pk_fp8_f32 v22, v[vgprValuC+22], v[vgprValuC+22] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v22, v30, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s24, v[vgprValuC+23], v16          // Nan and +/- inf
v_med3_f32 v15, v[vgprValuC+23], v17, v18
v_cndmask_b32 v[vgprValuC+23], v15, v[vgprValuC+23], s24
v_cvt_pk_fp8_f32 v23, v[vgprValuC+23], v[vgprValuC+23] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v23, v31, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s24, v[vgprValuC+24], v16          // Nan and +/- inf
v_med3_f32 v15, v[vgprValuC+24], v17, v18
v_cndmask_b32 v[vgprValuC+24], v15, v[vgprValuC+24], s24
v_cvt_pk_fp8_f32 v24, v[vgprValuC+24], v[vgprValuC+24] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v24, v32, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s24, v[vgprValuC+25], v16          // Nan and +/- inf
v_med3_f32 v15, v[vgprValuC+25], v17, v18
v_cndmask_b32 v[vgprValuC+25], v15, v[vgprValuC+25], s24
v_cvt_pk_fp8_f32 v25, v[vgprValuC+25], v[vgprValuC+25] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v25, v33, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s24, v[vgprValuC+26], v16          // Nan and +/- inf
v_med3_f32 v15, v[vgprValuC+26], v17, v18
v_cndmask_b32 v[vgprValuC+26], v15, v[vgprValuC+26], s24
v_cvt_pk_fp8_f32 v26, v[vgprValuC+26], v[vgprValuC+26] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v26, v34, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_nop 0                                            // 1 wait state required when next inst writes vgprs held by previous dwordx4 store inst
s_branch label_GW_End_2                            // jump to end
label_GW_B1_GSU1:
label_GW_B1_FD0_GSU1:

/* Edge/NonEdge store path check (M): Size % 32 > 0 -> Edge store; else -> NonEdge store */
s_and_b32 s24, 31, s[sgprSizeI]                    // s24 = s[sgprSizeI] % 32
s_add_u32 s25, -0x1, s[sgprNumWorkGroups0]
s_cmp_ge_u32 s[sgprWorkGroup0], s25                // wg0 >= nwg0-1 ?
s_cselect_b32 s24, s24, 0                          // set rem
s_mov_b32 s8, 0
s_cmp_gt_u32 s24, s8                               // rem > 0
s_cbranch_scc1 label_GW_B1_FD0_VW8_GSU1_Else       // jump if edges required

/* Edge/NonEdge store path check (N (isSize1)): Size % 16 > 0 -> Edge store; else -> NonEdge store */
s_and_b32 s24, 15, s[sgprSizeJ]                    // s24 = s[sgprSizeJ] % 16
s_add_u32 s25, -0x1, s[sgprNumWorkGroups1]
s_cmp_ge_u32 s[sgprWorkGroup1], s25                // wg1 >= nwg1-1
s_cselect_b32 s24, s24, 0                          // set rem
s_mov_b32 s8, 0
s_cmp_gt_u32 s24, s8                               // rem > 0
s_cbranch_scc1 label_GW_B1_FD0_VW8_GSU1_Then       // jump if edges required
label_GW_B1_FD0_VW8_GSU1_NonEdge:

/* edge=0, allocate 1 sgpr. perBatchTmpS=1 perBatchMaskS=0 perElementMaskS=0 elementsPerBatch=22 */
/* optSingleColVgpr=1 optSharedColVgpr=0 optSGPRUsage=BufferLoad_Mask optSrdIncForRow=1 factorDim=0 */

/******************************************/
/* Global Write Beta Batch #0 (d1,d0,vc1,vc0) = */
/*    (0,0,0,0:vw8)                       */
/******************************************/

/* calc coords, apply mask, and issue loads (if necessary) */
/* (d1,vc1,d0,vc0)=(0,0,0,0) */
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_add_nc_u32 v20, v10, v8                          // optSingleColVgpr scaleToBpe: sharedAddrVgpr <- cinRowPtr + coord0, scaled by BPE. BSHERE:coord0=8, coord0Vgpr=8 (multiple bpe)
                                                   // optSingleColVgpr scaleToBpe: sharedAddrVgpr <- cinRowPtr + coord0, scaled by BPE. BSHERE:coord0=8, coord0Vgpr=8 (bpe is 1, no mul)
s_wait_alu depctr_va_vdst(0)
buffer_load_b64 v[22:23], v20, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
v_add_nc_u32 v19, v11, v8                          // optSingleColVgpr scaleToBpe: sharedAddrVgpr <- cinRowPtr + coord0, scaled by BPE. BSHERE:coord0=8, coord0Vgpr=8 (multiple bpe)
                                                   // optSingleColVgpr scaleToBpe: sharedAddrVgpr <- cinRowPtr + coord0, scaled by BPE. BSHERE:coord0=8, coord0Vgpr=8 (bpe is 1, no mul)

/* rC *= alpha batchElements=[(0, 0, 0, 0)] */
v_mul_f32 v[vgprValuC+24], s[sgprAlpha], v[vgprValuC+0] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+25], s[sgprAlpha], v[vgprValuC+1] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+26], s[sgprAlpha], v[vgprValuC+2] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+27], s[sgprAlpha], v[vgprValuC+3] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+28], s[sgprAlpha], v[vgprValuC+4] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+29], s[sgprAlpha], v[vgprValuC+5] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+30], s[sgprAlpha], v[vgprValuC+6] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+31], s[sgprAlpha], v[vgprValuC+7] // Multiply MI out reg with alpha

/* apply mask, calc new C and issue writes */
v_mov_b32 v16, 0x207                               // Nan and +/- inf
v_mov_b32 v18, 0x43E00000                          // Fp8 Max value 448 as float32
v_mov_b32 v17, 0xc3E00000                          // Fp8 Min value -448 as float32

s_wait_loadcnt 0                                   // vlcnt(0) = 1 - 1 (beta) (interleaved)
v_cvt_pk_f32_fp8 v[12:13], v22.l op_sel:[0]
s_nop 0
v_fmac_f32 v[vgprValuC+24], v12, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+25], v13, s[sgprBeta]       // finalSum = sum*alpha + C*beta (PK)
v_cvt_pk_f32_fp8 v[12:13], v22.h op_sel:[1]
s_nop 0
v_fmac_f32 v[vgprValuC+26], v12, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+27], v13, s[sgprBeta]       // finalSum = sum*alpha + C*beta (PK)
v_cvt_pk_f32_fp8 v[12:13], v23.l op_sel:[0]
s_nop 0
v_fmac_f32 v[vgprValuC+28], v12, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+29], v13, s[sgprBeta]       // finalSum = sum*alpha + C*beta (PK)
v_cvt_pk_f32_fp8 v[12:13], v23.h op_sel:[1]
s_nop 0
v_fmac_f32 v[vgprValuC+30], v12, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+31], v13, s[sgprBeta]       // finalSum = sum*alpha + C*beta (PK)
v_cmp_class_f32 s8, v[vgprValuC+24], v16           // Nan and +/- inf
v_med3_f32 v15, v[vgprValuC+24], v17, v18
v_cndmask_b32 v[vgprValuC+24], v15, v[vgprValuC+24], s8
v_cmp_class_f32 s8, v[vgprValuC+25], v16           // Nan and +/- inf
v_med3_f32 v15, v[vgprValuC+25], v17, v18
v_cndmask_b32 v[vgprValuC+25], v15, v[vgprValuC+25], s8
v_cmp_class_f32 s8, v[vgprValuC+26], v16           // Nan and +/- inf
v_med3_f32 v15, v[vgprValuC+26], v17, v18
v_cndmask_b32 v[vgprValuC+26], v15, v[vgprValuC+26], s8
v_cmp_class_f32 s8, v[vgprValuC+27], v16           // Nan and +/- inf
v_med3_f32 v15, v[vgprValuC+27], v17, v18
v_cndmask_b32 v[vgprValuC+27], v15, v[vgprValuC+27], s8
v_cmp_class_f32 s8, v[vgprValuC+28], v16           // Nan and +/- inf
v_med3_f32 v15, v[vgprValuC+28], v17, v18
v_cndmask_b32 v[vgprValuC+28], v15, v[vgprValuC+28], s8
v_cmp_class_f32 s8, v[vgprValuC+29], v16           // Nan and +/- inf
v_med3_f32 v15, v[vgprValuC+29], v17, v18
v_cndmask_b32 v[vgprValuC+29], v15, v[vgprValuC+29], s8
v_cmp_class_f32 s8, v[vgprValuC+30], v16           // Nan and +/- inf
v_med3_f32 v15, v[vgprValuC+30], v17, v18
v_cndmask_b32 v[vgprValuC+30], v15, v[vgprValuC+30], s8
v_cmp_class_f32 s8, v[vgprValuC+31], v16           // Nan and +/- inf
v_med3_f32 v15, v[vgprValuC+31], v17, v18
v_cndmask_b32 v[vgprValuC+31], v15, v[vgprValuC+31], s8
v_cvt_scalef32_pk8_fp8_f32 v[24:25], v[vgprValuC+24:vgprValuC+24+7], 1.0 // convert 8xF32 to 8xFP8
s_wait_alu depctr_va_vdst(0)
buffer_store_b64 v[24:25], v19, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_nop 0                                            // 1 wait state required when next inst writes vgprs held by previous dwordx4 store inst
s_branch label_GW_End_2                            // jump to end
label_GW_B1_FD0_VW8_GSU1_NonEdgeEnd:
label_GW_B1_FD0_VW8_GSU1_Then:

/* edge=1, allocate 3 sgpr. perBatchTmpS=2 perBatchMaskS=1 perElementMaskS=0 elementsPerBatch=20 */
/* optSingleColVgpr=0 optSharedColVgpr=0 optSGPRUsage=BufferLoad_Edge_Mask optSrdIncForRow=0 factorDim=0 */

/******************************************/
/* Global Write Beta Edge Batch #0 (d1,d0,vc1,vc0) = */
/*    (0,0,0,0:vw8)                       */
/******************************************/

/* calc coords, apply mask, and issue loads (if necessary) */
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v14, BufferOOB
/* (d1,vc1,d0,vc0)=(0,0,0,0) */
v_cmp_lt_u32 s24, v8, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s26, v9, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s26, s24, s26                            // in0 && in1
v_add_nc_u32 v19, v10, v8                          // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v19, v14, v19, s26                   // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_b64 v[20:21], v19, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_nc_u32 v19, v11, v8                          // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v19, v14, v19, s26                   // LDD clip if OOB. offset

/* rC *= alpha batchElements=[(0, 0, 0, 0)] */
v_mul_f32 v[vgprValuC+24], s[sgprAlpha], v[vgprValuC+0] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+25], s[sgprAlpha], v[vgprValuC+1] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+26], s[sgprAlpha], v[vgprValuC+2] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+27], s[sgprAlpha], v[vgprValuC+3] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+28], s[sgprAlpha], v[vgprValuC+4] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+29], s[sgprAlpha], v[vgprValuC+5] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+30], s[sgprAlpha], v[vgprValuC+6] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+31], s[sgprAlpha], v[vgprValuC+7] // Multiply MI out reg with alpha
s_wait_loadcnt 0                                   // wait for Beta

/* apply mask, calc new C and issue writes */
v_mov_b32 v16, 0x207                               // Nan and +/- inf
v_mov_b32 v18, 0x43E00000                          // Fp8 Max value 448 as float32
v_mov_b32 v17, 0xc3E00000                          // Fp8 Min value -448 as float32
v_cvt_pk_f32_fp8 v[12:13], v20.l op_sel:[0]
s_nop 0
v_fmac_f32 v[vgprValuC+24], v12, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+25], v13, s[sgprBeta]       // finalSum = sum*alpha + C*beta (PK)
v_cvt_pk_f32_fp8 v[12:13], v20.h op_sel:[1]
s_nop 0
v_fmac_f32 v[vgprValuC+26], v12, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+27], v13, s[sgprBeta]       // finalSum = sum*alpha + C*beta (PK)
v_cvt_pk_f32_fp8 v[12:13], v21.l op_sel:[0]
s_nop 0
v_fmac_f32 v[vgprValuC+28], v12, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+29], v13, s[sgprBeta]       // finalSum = sum*alpha + C*beta (PK)
v_cvt_pk_f32_fp8 v[12:13], v21.h op_sel:[1]
s_nop 0
v_fmac_f32 v[vgprValuC+30], v12, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+31], v13, s[sgprBeta]       // finalSum = sum*alpha + C*beta (PK)
v_cmp_class_f32 s24, v[vgprValuC+24], v16          // Nan and +/- inf
v_med3_f32 v15, v[vgprValuC+24], v17, v18
v_cndmask_b32 v[vgprValuC+24], v15, v[vgprValuC+24], s24
v_cmp_class_f32 s24, v[vgprValuC+25], v16          // Nan and +/- inf
v_med3_f32 v15, v[vgprValuC+25], v17, v18
v_cndmask_b32 v[vgprValuC+25], v15, v[vgprValuC+25], s24
v_cmp_class_f32 s24, v[vgprValuC+26], v16          // Nan and +/- inf
v_med3_f32 v15, v[vgprValuC+26], v17, v18
v_cndmask_b32 v[vgprValuC+26], v15, v[vgprValuC+26], s24
v_cmp_class_f32 s24, v[vgprValuC+27], v16          // Nan and +/- inf
v_med3_f32 v15, v[vgprValuC+27], v17, v18
v_cndmask_b32 v[vgprValuC+27], v15, v[vgprValuC+27], s24
v_cmp_class_f32 s24, v[vgprValuC+28], v16          // Nan and +/- inf
v_med3_f32 v15, v[vgprValuC+28], v17, v18
v_cndmask_b32 v[vgprValuC+28], v15, v[vgprValuC+28], s24
v_cmp_class_f32 s24, v[vgprValuC+29], v16          // Nan and +/- inf
v_med3_f32 v15, v[vgprValuC+29], v17, v18
v_cndmask_b32 v[vgprValuC+29], v15, v[vgprValuC+29], s24
v_cmp_class_f32 s24, v[vgprValuC+30], v16          // Nan and +/- inf
v_med3_f32 v15, v[vgprValuC+30], v17, v18
v_cndmask_b32 v[vgprValuC+30], v15, v[vgprValuC+30], s24
v_cmp_class_f32 s24, v[vgprValuC+31], v16          // Nan and +/- inf
v_med3_f32 v15, v[vgprValuC+31], v17, v18
v_cndmask_b32 v[vgprValuC+31], v15, v[vgprValuC+31], s24
v_cvt_scalef32_pk8_fp8_f32 v[24:25], v[vgprValuC+24:vgprValuC+24+7], 1.0 // convert 8xF32 to 8xFP8
s_wait_alu depctr_va_vdst(0)
buffer_store_b64 v[24:25], v19, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_nop 0                                            // 1 wait state required when next inst writes vgprs held by previous dwordx4 store inst
s_branch label_GW_End_2                            // jump to end
label_GW_B1_FD0_VW8_GSU1_Else:
label_GW_B1_FD0_VW1_GSU1_Else:
label_GW_B1_FD0_VW1_GSU1_Then:

/* edge=1, allocate 3 sgpr. perBatchTmpS=2 perBatchMaskS=1 perElementMaskS=0 elementsPerBatch=78 */
/* optSingleColVgpr=0 optSharedColVgpr=0 optSGPRUsage=BufferLoad_Edge_Mask optSrdIncForRow=0 factorDim=0 */

/******************************************/
/* Global Write Beta Edge Batch #0 (d1,d0,vc1,vc0) = */
/*    (0,0,0,0:vw1); (0,0,0,1:vw1); (0,0,0,2:vw1); (0,0,0,3:vw1); (0,0,0,4:vw1); (0,0,0,5:vw1); (0,0,0,6:vw1); (0,0,0,7:vw1) */
/******************************************/

/* calc coords, apply mask, and issue loads (if necessary) */
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v14, BufferOOB
/* (d1,vc1,d0,vc0)=(0,0,0,0) */
v_cmp_lt_u32 s24, v8, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s26, v9, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s26, s24, s26                            // in0 && in1
v_add_nc_u32 v28, v10, v8                          // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v28, v14, v28, s26                   // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_d16_u8 v27, v28, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_nc_u32 v28, v11, v8                          // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v28, v14, v28, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,0,1) */
v_add_co_u32 v12, vcc_lo, v8, 1                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s24, v12, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v9, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s26, s24, s26                            // in0 && in1
v_add_nc_u32 v30, v10, v12                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v30, v14, v30, s26                   // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_d16_u8 v29, v30, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_nc_u32 v30, v11, v12                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v30, v14, v30, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,0,2) */
v_add_co_u32 v12, vcc_lo, v8, 2                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s24, v12, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v9, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s26, s24, s26                            // in0 && in1
v_add_nc_u32 v32, v10, v12                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v32, v14, v32, s26                   // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_d16_u8 v31, v32, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_nc_u32 v32, v11, v12                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v32, v14, v32, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,0,3) */
v_add_co_u32 v12, vcc_lo, v8, 3                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s24, v12, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v9, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s26, s24, s26                            // in0 && in1
v_add_nc_u32 v34, v10, v12                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v34, v14, v34, s26                   // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_d16_u8 v33, v34, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_nc_u32 v34, v11, v12                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v34, v14, v34, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,0,4) */
v_add_co_u32 v12, vcc_lo, v8, 4                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s24, v12, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v9, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s26, s24, s26                            // in0 && in1
v_add_nc_u32 v36, v10, v12                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v36, v14, v36, s26                   // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_d16_u8 v35, v36, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_nc_u32 v36, v11, v12                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v36, v14, v36, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,0,5) */
v_add_co_u32 v12, vcc_lo, v8, 5                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s24, v12, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v9, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s26, s24, s26                            // in0 && in1
v_add_nc_u32 v38, v10, v12                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v38, v14, v38, s26                   // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_d16_u8 v37, v38, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_nc_u32 v38, v11, v12                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v38, v14, v38, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,0,6) */
v_add_co_u32 v12, vcc_lo, v8, 6                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s24, v12, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v9, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s26, s24, s26                            // in0 && in1
v_add_nc_u32 v40, v10, v12                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v40, v14, v40, s26                   // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_d16_u8 v39, v40, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_nc_u32 v40, v11, v12                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v40, v14, v40, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,0,7) */
v_add_co_u32 v12, vcc_lo, v8, 7                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s24, v12, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v9, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s26, s24, s26                            // in0 && in1
v_add_nc_u32 v42, v10, v12                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v42, v14, v42, s26                   // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_d16_u8 v41, v42, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_nc_u32 v42, v11, v12                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v42, v14, v42, s26                   // LDD clip if OOB. offset

/* rC *= alpha batchElements=[(0, 0, 0, 0), (0, 0, 0, 1), (0, 0, 0, 2), (0, 0, 0, 3), (0, 0, 0, 4), (0, 0, 0, 5), (0, 0, 0, 6), (0, 0, 0, 7)] */
v_mul_f32 v[vgprValuC+19], s[sgprAlpha], v[vgprValuC+0] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+20], s[sgprAlpha], v[vgprValuC+1] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+21], s[sgprAlpha], v[vgprValuC+2] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+22], s[sgprAlpha], v[vgprValuC+3] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+23], s[sgprAlpha], v[vgprValuC+4] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+24], s[sgprAlpha], v[vgprValuC+5] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+25], s[sgprAlpha], v[vgprValuC+6] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+26], s[sgprAlpha], v[vgprValuC+7] // Multiply MI out reg with alpha
s_wait_loadcnt 0                                   // wait for Beta

/* apply mask, calc new C and issue writes */
v_mov_b32 v16, 0x207                               // Nan and +/- inf
v_mov_b32 v18, 0x43E00000                          // Fp8 Max value 448 as float32
v_mov_b32 v17, 0xc3E00000                          // Fp8 Min value -448 as float32
v_cvt_f32_fp8 v12, v27 byte_sel:[0]
s_nop 0
v_fmac_f32 v[vgprValuC+19], v12, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_cmp_class_f32 s24, v[vgprValuC+19], v16          // Nan and +/- inf
v_med3_f32 v15, v[vgprValuC+19], v17, v18
v_cndmask_b32 v[vgprValuC+19], v15, v[vgprValuC+19], s24
v_cvt_pk_fp8_f32 v19, v[vgprValuC+19], v[vgprValuC+19] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v19, v28, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cvt_f32_fp8 v12, v29 byte_sel:[0]
s_nop 0
v_fmac_f32 v[vgprValuC+20], v12, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_cmp_class_f32 s24, v[vgprValuC+20], v16          // Nan and +/- inf
v_med3_f32 v15, v[vgprValuC+20], v17, v18
v_cndmask_b32 v[vgprValuC+20], v15, v[vgprValuC+20], s24
v_cvt_pk_fp8_f32 v20, v[vgprValuC+20], v[vgprValuC+20] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v20, v30, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cvt_f32_fp8 v12, v31 byte_sel:[0]
s_nop 0
v_fmac_f32 v[vgprValuC+21], v12, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_cmp_class_f32 s24, v[vgprValuC+21], v16          // Nan and +/- inf
v_med3_f32 v15, v[vgprValuC+21], v17, v18
v_cndmask_b32 v[vgprValuC+21], v15, v[vgprValuC+21], s24
v_cvt_pk_fp8_f32 v21, v[vgprValuC+21], v[vgprValuC+21] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v21, v32, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cvt_f32_fp8 v12, v33 byte_sel:[0]
s_nop 0
v_fmac_f32 v[vgprValuC+22], v12, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_cmp_class_f32 s24, v[vgprValuC+22], v16          // Nan and +/- inf
v_med3_f32 v15, v[vgprValuC+22], v17, v18
v_cndmask_b32 v[vgprValuC+22], v15, v[vgprValuC+22], s24
v_cvt_pk_fp8_f32 v22, v[vgprValuC+22], v[vgprValuC+22] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v22, v34, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cvt_f32_fp8 v12, v35 byte_sel:[0]
s_nop 0
v_fmac_f32 v[vgprValuC+23], v12, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_cmp_class_f32 s24, v[vgprValuC+23], v16          // Nan and +/- inf
v_med3_f32 v15, v[vgprValuC+23], v17, v18
v_cndmask_b32 v[vgprValuC+23], v15, v[vgprValuC+23], s24
v_cvt_pk_fp8_f32 v23, v[vgprValuC+23], v[vgprValuC+23] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v23, v36, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cvt_f32_fp8 v12, v37 byte_sel:[0]
s_nop 0
v_fmac_f32 v[vgprValuC+24], v12, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_cmp_class_f32 s24, v[vgprValuC+24], v16          // Nan and +/- inf
v_med3_f32 v15, v[vgprValuC+24], v17, v18
v_cndmask_b32 v[vgprValuC+24], v15, v[vgprValuC+24], s24
v_cvt_pk_fp8_f32 v24, v[vgprValuC+24], v[vgprValuC+24] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v24, v38, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cvt_f32_fp8 v12, v39 byte_sel:[0]
s_nop 0
v_fmac_f32 v[vgprValuC+25], v12, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_cmp_class_f32 s24, v[vgprValuC+25], v16          // Nan and +/- inf
v_med3_f32 v15, v[vgprValuC+25], v17, v18
v_cndmask_b32 v[vgprValuC+25], v15, v[vgprValuC+25], s24
v_cvt_pk_fp8_f32 v25, v[vgprValuC+25], v[vgprValuC+25] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v25, v40, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cvt_f32_fp8 v12, v41 byte_sel:[0]
s_nop 0
v_fmac_f32 v[vgprValuC+26], v12, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_cmp_class_f32 s24, v[vgprValuC+26], v16          // Nan and +/- inf
v_med3_f32 v15, v[vgprValuC+26], v17, v18
v_cndmask_b32 v[vgprValuC+26], v15, v[vgprValuC+26], s24
v_cvt_pk_fp8_f32 v26, v[vgprValuC+26], v[vgprValuC+26] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v26, v42, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_nop 0                                            // 1 wait state required when next inst writes vgprs held by previous dwordx4 store inst
s_branch label_GW_End_2                            // jump to end
label_GW_End_2:
label_KernelEnd:
s_endpgm                                           // Kernel End
label_ASM_End:  /// The end of the kernel
