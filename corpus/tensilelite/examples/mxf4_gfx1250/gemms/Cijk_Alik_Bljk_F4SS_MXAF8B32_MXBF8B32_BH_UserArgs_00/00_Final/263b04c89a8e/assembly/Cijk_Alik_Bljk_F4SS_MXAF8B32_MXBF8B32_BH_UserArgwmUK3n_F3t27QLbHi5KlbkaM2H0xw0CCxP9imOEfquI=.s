
/******************************************/
/* Begin Kernel                           */
/******************************************/
/* STINKY_TOTAL_INST_BYTES: 61812 */
.amdgcn_target "amdgcn-amd-amdhsa--gfx1250"
.text
.protected Cijk_Alik_Bljk_F4SS_MXAF8B32_MXBF8B32_BH_UserArgs_MT128x128x256_MI16x16x1_SN_LDSB0_AFC0_AG0_AGGSUA0_AGNTAB0_AFEM2_AFEM2_ASEM32_BL1_BS1_CD1_1_CLR1_CLS0_CADS0_DTLA0_DTLB0_DTLM0_DTVA0_DTVB0_DTVMXSA0_DTVMXSB0_DTVSM0_DPLB0_EPS0_ELFLR0_EMLLn1_FDSI1_GRPM1_GRVWA2_GRVWB2_GSUAMB_GLS0_HPLR0_ISA1250_ICIW1_IU1_K1_LDSTI0_LBSPPA256_LBSPPB512_LBSPPMXSA0_LBSPPMXSB0_LBSPPM0_LPA32_LPB32_LPMXSA0_LPMXSB0_LPM0_LRVW32_LWPMn1_MIAV1_MIWT4_4_MXLITDM_MXSFIMS_MO40_MGRIPM1_NTn1_NTA0_NTB0_NTC0_NTD0_NTE0_NTMXSA0_NTMXSB0_NTM0_NTWS0_NVn1_NVA0_NVB0_NVC0_NVD0_NVE0_NVMXSA0_NVMXSB0_NVM0_NVWS0_NEPBS0_NLCA1_NLCB1_ONLL1_PAP0_PGL0_PGR2_PLR1_PKA1_SGROB0_SIA0_SS0_SPO0_SRVW0_SSO0_SVW8_SK0_SKFTR0_SKFDPO0_SKWS0_SKXCCM0_SNLL0_SIP1_SGRO0_TDMI3_TDMIM3_TDMLWS0_TDMS0_TIN0_THn1_THA0_THB0_THC0_THD0_THE0_THMXSA0_THMXSB0_THM0_THWS0_TLDS1_TLDSMn1_ULSGRO0_USL1_USLMX0_UDFMAC0_UIOFGRO0_UPLRP0_USFGRO0_USI0_VSn1_VWA1_VWB4_WSGRA0_WSGRB0_WS32_WG32_4_1_WGMXCC1
.globl Cijk_Alik_Bljk_F4SS_MXAF8B32_MXBF8B32_BH_UserArgs_MT128x128x256_MI16x16x1_SN_LDSB0_AFC0_AG0_AGGSUA0_AGNTAB0_AFEM2_AFEM2_ASEM32_BL1_BS1_CD1_1_CLR1_CLS0_CADS0_DTLA0_DTLB0_DTLM0_DTVA0_DTVB0_DTVMXSA0_DTVMXSB0_DTVSM0_DPLB0_EPS0_ELFLR0_EMLLn1_FDSI1_GRPM1_GRVWA2_GRVWB2_GSUAMB_GLS0_HPLR0_ISA1250_ICIW1_IU1_K1_LDSTI0_LBSPPA256_LBSPPB512_LBSPPMXSA0_LBSPPMXSB0_LBSPPM0_LPA32_LPB32_LPMXSA0_LPMXSB0_LPM0_LRVW32_LWPMn1_MIAV1_MIWT4_4_MXLITDM_MXSFIMS_MO40_MGRIPM1_NTn1_NTA0_NTB0_NTC0_NTD0_NTE0_NTMXSA0_NTMXSB0_NTM0_NTWS0_NVn1_NVA0_NVB0_NVC0_NVD0_NVE0_NVMXSA0_NVMXSB0_NVM0_NVWS0_NEPBS0_NLCA1_NLCB1_ONLL1_PAP0_PGL0_PGR2_PLR1_PKA1_SGROB0_SIA0_SS0_SPO0_SRVW0_SSO0_SVW8_SK0_SKFTR0_SKFDPO0_SKWS0_SKXCCM0_SNLL0_SIP1_SGRO0_TDMI3_TDMIM3_TDMLWS0_TDMS0_TIN0_THn1_THA0_THB0_THC0_THD0_THE0_THMXSA0_THMXSB0_THM0_THWS0_TLDS1_TLDSMn1_ULSGRO0_USL1_USLMX0_UDFMAC0_UIOFGRO0_UPLRP0_USFGRO0_USI0_VSn1_VWA1_VWB4_WSGRA0_WSGRB0_WS32_WG32_4_1_WGMXCC1
.p2align 8
.type Cijk_Alik_Bljk_F4SS_MXAF8B32_MXBF8B32_BH_UserArgs_MT128x128x256_MI16x16x1_SN_LDSB0_AFC0_AG0_AGGSUA0_AGNTAB0_AFEM2_AFEM2_ASEM32_BL1_BS1_CD1_1_CLR1_CLS0_CADS0_DTLA0_DTLB0_DTLM0_DTVA0_DTVB0_DTVMXSA0_DTVMXSB0_DTVSM0_DPLB0_EPS0_ELFLR0_EMLLn1_FDSI1_GRPM1_GRVWA2_GRVWB2_GSUAMB_GLS0_HPLR0_ISA1250_ICIW1_IU1_K1_LDSTI0_LBSPPA256_LBSPPB512_LBSPPMXSA0_LBSPPMXSB0_LBSPPM0_LPA32_LPB32_LPMXSA0_LPMXSB0_LPM0_LRVW32_LWPMn1_MIAV1_MIWT4_4_MXLITDM_MXSFIMS_MO40_MGRIPM1_NTn1_NTA0_NTB0_NTC0_NTD0_NTE0_NTMXSA0_NTMXSB0_NTM0_NTWS0_NVn1_NVA0_NVB0_NVC0_NVD0_NVE0_NVMXSA0_NVMXSB0_NVM0_NVWS0_NEPBS0_NLCA1_NLCB1_ONLL1_PAP0_PGL0_PGR2_PLR1_PKA1_SGROB0_SIA0_SS0_SPO0_SRVW0_SSO0_SVW8_SK0_SKFTR0_SKFDPO0_SKWS0_SKXCCM0_SNLL0_SIP1_SGRO0_TDMI3_TDMIM3_TDMLWS0_TDMS0_TIN0_THn1_THA0_THB0_THC0_THD0_THE0_THMXSA0_THMXSB0_THM0_THWS0_TLDS1_TLDSMn1_ULSGRO0_USL1_USLMX0_UDFMAC0_UIOFGRO0_UPLRP0_USFGRO0_USI0_VSn1_VWA1_VWB4_WSGRA0_WSGRB0_WS32_WG32_4_1_WGMXCC1,@function
.section .rodata,#alloc
.p2align 6
.amdhsa_kernel Cijk_Alik_Bljk_F4SS_MXAF8B32_MXBF8B32_BH_UserArgs_MT128x128x256_MI16x16x1_SN_LDSB0_AFC0_AG0_AGGSUA0_AGNTAB0_AFEM2_AFEM2_ASEM32_BL1_BS1_CD1_1_CLR1_CLS0_CADS0_DTLA0_DTLB0_DTLM0_DTVA0_DTVB0_DTVMXSA0_DTVMXSB0_DTVSM0_DPLB0_EPS0_ELFLR0_EMLLn1_FDSI1_GRPM1_GRVWA2_GRVWB2_GSUAMB_GLS0_HPLR0_ISA1250_ICIW1_IU1_K1_LDSTI0_LBSPPA256_LBSPPB512_LBSPPMXSA0_LBSPPMXSB0_LBSPPM0_LPA32_LPB32_LPMXSA0_LPMXSB0_LPM0_LRVW32_LWPMn1_MIAV1_MIWT4_4_MXLITDM_MXSFIMS_MO40_MGRIPM1_NTn1_NTA0_NTB0_NTC0_NTD0_NTE0_NTMXSA0_NTMXSB0_NTM0_NTWS0_NVn1_NVA0_NVB0_NVC0_NVD0_NVE0_NVMXSA0_NVMXSB0_NVM0_NVWS0_NEPBS0_NLCA1_NLCB1_ONLL1_PAP0_PGL0_PGR2_PLR1_PKA1_SGROB0_SIA0_SS0_SPO0_SRVW0_SSO0_SVW8_SK0_SKFTR0_SKFDPO0_SKWS0_SKXCCM0_SNLL0_SIP1_SGRO0_TDMI3_TDMIM3_TDMLWS0_TDMS0_TIN0_THn1_THA0_THB0_THC0_THD0_THE0_THMXSA0_THMXSB0_THM0_THWS0_TLDS1_TLDSMn1_ULSGRO0_USL1_USLMX0_UDFMAC0_UIOFGRO0_UPLRP0_USFGRO0_USI0_VSn1_VWA1_VWB4_WSGRA0_WSGRB0_WS32_WG32_4_1_WGMXCC1
  .amdhsa_user_sgpr_kernarg_segment_ptr 1
  .amdhsa_next_free_vgpr 678 // vgprs
  .amdhsa_next_free_sgpr 98 // sgprs
  .amdhsa_group_segment_fixed_size 101888 // lds bytes
  .amdhsa_wavefront_size32 1 // 32-thread wavefronts
  .amdhsa_private_segment_fixed_size 0
  .amdhsa_system_sgpr_workgroup_id_x 1
  .amdhsa_system_sgpr_workgroup_id_y 1
  .amdhsa_system_sgpr_workgroup_id_z 1
  .amdhsa_system_vgpr_workitem_id 0
  .amdhsa_float_denorm_mode_32 3
  .amdhsa_float_denorm_mode_16_64 3
  .amdhsa_inst_pref_size 255
  .amdhsa_user_sgpr_count 29
  .amdhsa_user_sgpr_kernarg_preload_length 27
  .amdhsa_user_sgpr_kernarg_preload_offset 0
.end_amdhsa_kernel
.text
/* Num VGPR   =678 */
/* Num AccVGPR=0 */
/* Num SGPR   =98 */

/******************************************/
/* Optimizations and Config:              */
/******************************************/
/* ThreadTile= 32 x 4 */
/* SubGroup= 4 x 32 */
/* VectorWidthA=1 */
/* VectorWidthB=4 */
/* GlobalReadVectorWidthA=2, GlobalReadVectorWidthB=2 */
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
  - .name: Cijk_Alik_Bljk_F4SS_MXAF8B32_MXBF8B32_BH_UserArgs_MT128x128x256_MI16x16x1_SN_LDSB0_AFC0_AG0_AGGSUA0_AGNTAB0_AFEM2_AFEM2_ASEM32_BL1_BS1_CD1_1_CLR1_CLS0_CADS0_DTLA0_DTLB0_DTLM0_DTVA0_DTVB0_DTVMXSA0_DTVMXSB0_DTVSM0_DPLB0_EPS0_ELFLR0_EMLLn1_FDSI1_GRPM1_GRVWA2_GRVWB2_GSUAMB_GLS0_HPLR0_ISA1250_ICIW1_IU1_K1_LDSTI0_LBSPPA256_LBSPPB512_LBSPPMXSA0_LBSPPMXSB0_LBSPPM0_LPA32_LPB32_LPMXSA0_LPMXSB0_LPM0_LRVW32_LWPMn1_MIAV1_MIWT4_4_MXLITDM_MXSFIMS_MO40_MGRIPM1_NTn1_NTA0_NTB0_NTC0_NTD0_NTE0_NTMXSA0_NTMXSB0_NTM0_NTWS0_NVn1_NVA0_NVB0_NVC0_NVD0_NVE0_NVMXSA0_NVMXSB0_NVM0_NVWS0_NEPBS0_NLCA1_NLCB1_ONLL1_PAP0_PGL0_PGR2_PLR1_PKA1_SGROB0_SIA0_SS0_SPO0_SRVW0_SSO0_SVW8_SK0_SKFTR0_SKFDPO0_SKWS0_SKXCCM0_SNLL0_SIP1_SGRO0_TDMI3_TDMIM3_TDMLWS0_TDMS0_TIN0_THn1_THA0_THB0_THC0_THD0_THE0_THMXSA0_THMXSB0_THM0_THWS0_TLDS1_TLDSMn1_ULSGRO0_USL1_USLMX0_UDFMAC0_UIOFGRO0_UPLRP0_USFGRO0_USI0_VSn1_VWA1_VWB4_WSGRA0_WSGRB0_WS32_WG32_4_1_WGMXCC1
    .symbol: 'Cijk_Alik_Bljk_F4SS_MXAF8B32_MXBF8B32_BH_UserArgs_MT128x128x256_MI16x16x1_SN_LDSB0_AFC0_AG0_AGGSUA0_AGNTAB0_AFEM2_AFEM2_ASEM32_BL1_BS1_CD1_1_CLR1_CLS0_CADS0_DTLA0_DTLB0_DTLM0_DTVA0_DTVB0_DTVMXSA0_DTVMXSB0_DTVSM0_DPLB0_EPS0_ELFLR0_EMLLn1_FDSI1_GRPM1_GRVWA2_GRVWB2_GSUAMB_GLS0_HPLR0_ISA1250_ICIW1_IU1_K1_LDSTI0_LBSPPA256_LBSPPB512_LBSPPMXSA0_LBSPPMXSB0_LBSPPM0_LPA32_LPB32_LPMXSA0_LPMXSB0_LPM0_LRVW32_LWPMn1_MIAV1_MIWT4_4_MXLITDM_MXSFIMS_MO40_MGRIPM1_NTn1_NTA0_NTB0_NTC0_NTD0_NTE0_NTMXSA0_NTMXSB0_NTM0_NTWS0_NVn1_NVA0_NVB0_NVC0_NVD0_NVE0_NVMXSA0_NVMXSB0_NVM0_NVWS0_NEPBS0_NLCA1_NLCB1_ONLL1_PAP0_PGL0_PGR2_PLR1_PKA1_SGROB0_SIA0_SS0_SPO0_SRVW0_SSO0_SVW8_SK0_SKFTR0_SKFDPO0_SKWS0_SKXCCM0_SNLL0_SIP1_SGRO0_TDMI3_TDMIM3_TDMLWS0_TDMS0_TIN0_THn1_THA0_THB0_THC0_THD0_THE0_THMXSA0_THMXSB0_THM0_THWS0_TLDS1_TLDSMn1_ULSGRO0_USL1_USLMX0_UDFMAC0_UIOFGRO0_UPLRP0_USFGRO0_USI0_VSn1_VWA1_VWB4_WSGRA0_WSGRB0_WS32_WG32_4_1_WGMXCC1.kd'
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
        .value_type:      f32
        .address_space:   generic
      - .name:            C
        .size:            8
        .offset:          40
        .value_kind:      global_buffer
        .value_type:      f32
        .address_space:   generic
      - .name:            A
        .size:            8
        .offset:          48
        .value_kind:      global_buffer
        .value_type:      fp4
        .address_space:   generic
      - .name:            MXSA
        .size:            8
        .offset:          56
        .value_kind:      global_buffer
        .value_type:      void
        .address_space:   generic
      - .name:            B
        .size:            8
        .offset:          64
        .value_kind:      global_buffer
        .value_type:      fp4
        .address_space:   generic
      - .name:            MXSB
        .size:            8
        .offset:          72
        .value_kind:      global_buffer
        .value_type:      void
        .address_space:   generic
      - .name:            strideD0
        .size:            4
        .offset:          80
        .value_kind:      by_value
        .value_type:      u32
      - .name:            strideD1
        .size:            4
        .offset:          84
        .value_kind:      by_value
        .value_type:      u32
      - .name:            strideC0
        .size:            4
        .offset:          88
        .value_kind:      by_value
        .value_type:      u32
      - .name:            strideC1
        .size:            4
        .offset:          92
        .value_kind:      by_value
        .value_type:      u32
      - .name:            strideA0
        .size:            4
        .offset:          96
        .value_kind:      by_value
        .value_type:      u32
      - .name:            strideA1
        .size:            4
        .offset:          100
        .value_kind:      by_value
        .value_type:      u32
      - .name:            strideMXSA0
        .size:            4
        .offset:          104
        .value_kind:      by_value
        .value_type:      u32
      - .name:            strideMXSA1
        .size:            4
        .offset:          108
        .value_kind:      by_value
        .value_type:      u32
      - .name:            strideB0
        .size:            4
        .offset:          112
        .value_kind:      by_value
        .value_type:      u32
      - .name:            strideB1
        .size:            4
        .offset:          116
        .value_kind:      by_value
        .value_type:      u32
      - .name:            strideMXSB0
        .size:            4
        .offset:          120
        .value_kind:      by_value
        .value_type:      u32
      - .name:            strideMXSB1
        .size:            4
        .offset:          124
        .value_kind:      by_value
        .value_type:      u32
      - .name:            alpha
        .size:            4
        .offset:          128
        .value_kind:      by_value
        .value_type:      f32
      - .name:            beta
        .size:            4
        .offset:          132
        .value_kind:      by_value
        .value_type:      f32
      - .name:            batchOffsetD
        .size:            8
        .offset:          136
        .value_kind:      by_value
        .value_type:      u64
      - .name:            batchOffsetC
        .size:            8
        .offset:          144
        .value_kind:      by_value
        .value_type:      u64
      - .name:            batchOffsetA
        .size:            8
        .offset:          152
        .value_kind:      by_value
        .value_type:      u64
      - .name:            batchOffsetB
        .size:            8
        .offset:          160
        .value_kind:      by_value
        .value_type:      u64
    .group_segment_fixed_size:   101888
    .kernarg_segment_align:      8
    .kernarg_segment_size:       168
    .max_flat_workgroup_size:    128
    .private_segment_fixed_size: 0
    .sgpr_count:                 98
    .sgpr_spill_count:           0
    .vgpr_count:                 678
    .vgpr_spill_count:           0
    .wavefront_size:             32
...
.end_amdgpu_metadata
Cijk_Alik_Bljk_F4SS_MXAF8B32_MXBF8B32_BH_UserArgs_MT128x128x256_MI16x16x1_SN_LDSB0_AFC0_AG0_AGGSUA0_AGNTAB0_AFEM2_AFEM2_ASEM32_BL1_BS1_CD1_1_CLR1_CLS0_CADS0_DTLA0_DTLB0_DTLM0_DTVA0_DTVB0_DTVMXSA0_DTVMXSB0_DTVSM0_DPLB0_EPS0_ELFLR0_EMLLn1_FDSI1_GRPM1_GRVWA2_GRVWB2_GSUAMB_GLS0_HPLR0_ISA1250_ICIW1_IU1_K1_LDSTI0_LBSPPA256_LBSPPB512_LBSPPMXSA0_LBSPPMXSB0_LBSPPM0_LPA32_LPB32_LPMXSA0_LPMXSB0_LPM0_LRVW32_LWPMn1_MIAV1_MIWT4_4_MXLITDM_MXSFIMS_MO40_MGRIPM1_NTn1_NTA0_NTB0_NTC0_NTD0_NTE0_NTMXSA0_NTMXSB0_NTM0_NTWS0_NVn1_NVA0_NVB0_NVC0_NVD0_NVE0_NVMXSA0_NVMXSB0_NVM0_NVWS0_NEPBS0_NLCA1_NLCB1_ONLL1_PAP0_PGL0_PGR2_PLR1_PKA1_SGROB0_SIA0_SS0_SPO0_SRVW0_SSO0_SVW8_SK0_SKFTR0_SKFDPO0_SKWS0_SKXCCM0_SNLL0_SIP1_SGRO0_TDMI3_TDMIM3_TDMLWS0_TDMS0_TIN0_THn1_THA0_THB0_THC0_THD0_THE0_THMXSA0_THMXSB0_THM0_THWS0_TLDS1_TLDSMn1_ULSGRO0_USL1_USLMX0_UDFMAC0_UIOFGRO0_UPLRP0_USFGRO0_USI0_VSn1_VWA1_VWB4_WSGRA0_WSGRB0_WS32_WG32_4_1_WGMXCC1:
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
.set vgprValuMXSA_X0_I0_BASE, vgprMXSBase+0
.set vgprValuMXSB_X0_I0_BASE, vgprMXSBase+6
.set vgprValuMXSA_X0_I0, vgprValuMXSA_X0_I0_BASE+0
.set vgprValuMXSA_X1_I0, vgprValuMXSA_X0_I0_BASE+2
.set vgprValuMXSB_X0_I0, vgprValuMXSB_X0_I0_BASE+0
.set vgprValuMXSB_X1_I0, vgprValuMXSB_X0_I0_BASE+4
.set vgprG2LMXSA, vgprG2LMXSA_BASE+0
.set vgprG2LMXSB, vgprG2LMXSB_BASE+0

/******************************************/
/* VGPR Assignments                       */
/******************************************/
/* ValuC range: [14-142), serializedStore enabled */
.set vgprValuC, 14
/* ValuA/B   Xn=PLR buffer idx,  In=InnerUnroll idx */
.set vgprBase, 146
.set vgprGlobalReadOffsetA, 142
.set vgprGlobalReadOffsetMXSA, 142
.set vgprGlobalReadOffsetB, 142
.set vgprGlobalReadOffsetMXSB, 142
.set vgprLocalReadAddrA, 144
.set vgprLocalReadAddrMXSA, 142
.set vgprLocalReadAddrB, 145
.set vgprLocalReadAddrMXSB, 143
.set vgprSerial, 276

/******************************************/
/* VGPR Macro Assignments                 */
/******************************************/
.set vgprValuA_X0_I0_BASE, vgprBase+0
.set vgprValuB_X0_I0_BASE, vgprBase+66
.set vgprValuA_X0_I0, vgprValuA_X0_I0_BASE+0
.set vgprValuA_X1_I0, vgprValuA_X0_I0_BASE+32
.set vgprValuB_X0_I0, vgprValuB_X0_I0_BASE+0
.set vgprValuB_X1_I0, vgprValuB_X0_I0_BASE+32
.set vgprG2LA, vgprG2LA_BASE+0
.set vgprG2LB, vgprG2LB_BASE+0

/******************************************/
/* SGPR Assignments                       */
/******************************************/
.set sgprKernArgAddress, 0
.set sgprWorkGroup0, 2
.set sgprWorkGroup1, 3
.set sgprWorkGroup2, 4
.set sgprWaveIdx, 5
.set sgprArgType, 6
.set sgprGSUSumIdx, 8
.set sgprGSULog2BpeC, 7
.set sgprGSULog2BpeD, 10
.set sgprStaggerU, 11
.set sgprWGM, 12
.set sgprLoopCounterL, 13
.set sgprOrigLoopCounter, 14
.set sgprNumWorkGroups0, 15
.set sgprNumWorkGroups1, 16
.set sgprSizesFree, 32
.set sgprSizesSum, 35
.set sgprAddressD, 36
.set sgprAddressC, 38
.set sgprAddressA, 40
.set sgprAddressMXSA, 42
.set sgprAddressB, 44
.set sgprAddressMXSB, 46
.set sgprStridesD, 48
.set sgprStridesC, 50
.set sgprStridesA, 52
.set sgprStridesMXSA, 54
.set sgprStridesB, 56
.set sgprStridesMXSB, 58
.set sgprAlpha, 60
.set sgprBeta, 61
.set sgprGSU, 62

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
.set constStrideAL, 1
.set sgprStrideA0I, sgprStridesA+0
.set sgprStrideAK, sgprStridesA+1
.set constStrideBL, 1
.set sgprStrideB1J, sgprStridesB+0
.set sgprStrideBK, sgprStridesB+1
.set constStrideMXSAL, 1
.set sgprStrideMXSA0I, sgprStridesMXSA+0
.set sgprStrideMXSAK, sgprStridesMXSA+1
.set constStrideMXSBL, 1
.set sgprStrideMXSB1J, sgprStridesMXSB+0
.set sgprStrideMXSBK, sgprStridesMXSB+1

.set MT0, 128
.set MT1, 128
.set DepthU, 256
/* Number of elements to shift-left SRD */
.set SrdShiftLeftA, 2
.set SrdShiftLeftMXSA, 2
.set SrdShiftLeftB, 2
.set SrdShiftLeftMXSB, 2
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

/* Global Offset MXSA */

/* Global Offset MXSB */

/******************************************/
/* Allocate Resources                     */
/******************************************/
label_Preload_Offset_Start:
s_setreg_IMM32_b32 hwreg(26,0,2), 2
s_and_b32 s63, 0x3fffffff, s2                      // Get nums of gemm
s_lshr_b32 s64, s2, 0x1e                           // Get arg type
s_mov_b32 s65, s3                                  // Preload internal args
s_cmp_eq_u32 s64, 3                                // Is kernel argType == 3
s_cbranch_scc1 label_Bypass_ArgType3_to_ArgType0_Instance2
s_cmp_eq_u32 s64, 0                                // Is kernel args
s_cbranch_scc0 label_Preload_HBMArgs
label_Bypass_ArgType3_to_ArgType0_Instance2:
s_add_u32 s[sgprKernArgAddress], s[sgprKernArgAddress], 0x10 // Shift common args
s_addc_u32 s[sgprKernArgAddress+1], s[sgprKernArgAddress+1], 0

/* Load Kernel Args */
s_load_b32 s55, s[sgprKernArgAddress:sgprKernArgAddress+1], 92 // 92
s_load_b128 s[56:59], s[sgprKernArgAddress:sgprKernArgAddress+1], 96 // 96
s_load_b64 s[60:61], s[sgprKernArgAddress:sgprKernArgAddress+1], 112 // 112
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
s_mov_b32 s54, s28                                 // move preload data to correct sgpr
s_branch label_Preload_LoadArgsEnd
label_Preload_HBMArgs:
s_mov_b64 s[sgprKernArgAddress:sgprKernArgAddress+1], s[6:7] // Load address of kernel arguments
label_Preload_LoadArgsEnd:
s_mov_b32 s[sgprWGM], s4                           // Preload internal args2
s_mov_b32 s66, s5                                  // Load num of WGs
s_and_b32 s[sgprStaggerU], s65, 0xffff0000         // Restore StaggerU related vars
s_lshr_b32 s[sgprStaggerU], s[sgprStaggerU], 0x10
s_and_b32 s[sgprGSU], s65, 0xffff                  // Restore GSUConfig and GSU
s_mov_b32 s[sgprArgType], s64
s_mov_b32 m0, 0x18e00                              // LDS clamp at 101888 bytes
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_mov_b32 v[vgprSerial-256], v0                    // thread serial id
s_mov_b32 vcc_hi, 0                                // Ensure hi bits are zero
s_set_vgpr_msb 16385                               // src0: 1, src1: 0, src2: 0, dst: 0
v_readfirstlane_b32 s65, v[vgprSerial-256]         // first tId
s_lshr_b32 s[sgprWaveIdx], s65, 5                  // wId=fTid // wavelen

/* Init workgroup id from ttmp */
s_mov_b32 s[sgprWorkGroup0], ttmp9
s_and_b32 s[sgprWorkGroup1], 0xffff, ttmp7
s_lshr_b32 s[sgprWorkGroup2], ttmp7, 0x10

/* remap workgroup to XCCs */
s_lshr_b32 s72, s[sgprWGM], 0x10                   // Get WGMXCC
s_ff1_i32_b32 s72, s72                             // Get log(WGMXCC)
s_lshr_b32 s73, s[sgprWGM], 0x16                   // Get CU_Count
/* remap WGs if WGMXCC > 1 ( log(WGMXCC) > 0 ) */
s_cmp_gt_i32 s72, 0
s_cbranch_scc0 label_skip_WGMXCC
/* only remap WGs in the range */
s_lshr_b32 s69, s66, s72
s_lshl_b32 s69, s69, s72
s_cmp_ge_u32 s[sgprWorkGroup0], s69
s_cbranch_scc1 label_skip_WGMXCC
s_cmp_eq_u32 s73, 0                                // CU_Count == 0 ?
s_cbranch_scc0 label_XCCG_nonzero
s_lshr_b32 s69, s[sgprWorkGroup0], s72
s_bfm_b32 s70, s72, 0
s_and_b32 s70, s[sgprWorkGroup0], s70
s_lshr_b32 s71, s66, s72
s_mul_i32 s70, s70, s71
s_add_u32 s[sgprWorkGroup0], s69, s70
s_branch label_skip_WGMXCC
label_XCCG_nonzero:
/* temp0 = (wg//CU_Count)*CU_Count */
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cvt_f64_u32 v[0:1], s73                          // s69 = s[sgprWorkGroup0] / s73
v_rcp_f64 v[0:1], v[0:1]                           // s69 = s[sgprWorkGroup0] / s73
v_cvt_f64_u32 v[2:3], s[sgprWorkGroup0]            // s69 = s[sgprWorkGroup0] / s73
v_mul_f64 v[0:1], v[0:1], v[2:3]                   // s69 = s[sgprWorkGroup0] / s73
v_cvt_u32_f64 v0, v[0:1]                           // s69 = s[sgprWorkGroup0] / s73
v_mul_lo_u32 v1, v0, s73                           // s69 = s[sgprWorkGroup0] / s73
v_sub_nc_u32 v2, s[sgprWorkGroup0], v1             // s69 = s[sgprWorkGroup0] / s73
v_cmp_ge_u32 vcc_lo, v2, s73                       // s69 = s[sgprWorkGroup0] / s73
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, vcc_lo                          // s69 = s[sgprWorkGroup0] / s73
v_add_nc_u32 v0, v0, 1                             // s69 = s[sgprWorkGroup0] / s73
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, -1                              // Reset exec
v_mul_lo_u32 v1, v0, s73                           // s69 = s[sgprWorkGroup0] / s73
v_sub_nc_u32 v2, s[sgprWorkGroup0], v1             // s69 = s[sgprWorkGroup0] / s73
v_readfirstlane_b32 s69, v0                        // quotient
v_readfirstlane_b32 s70, v2                        // remainder
s_mul_i32 s69, s69, s73
/* temp1 = (wg%CU_Count)//WGMXCC */
s_lshr_b32 s70, s70, s72
/* temp0 = temp0 + temp1 */
s_add_u32 s69, s69, s70
/* temp1 = (wg%WGMXCC) * ((WGs - (WGs//CU_Count) * CU_Count) if (wg > (WGs//CU_Count) * CU_Count) else CU_Count)//WGMXCC */
v_cvt_f64_u32 v[0:1], s73                          // s70 = s66 / s73
v_rcp_f64 v[0:1], v[0:1]                           // s70 = s66 / s73
v_cvt_f64_u32 v[2:3], s66                          // s70 = s66 / s73
v_mul_f64 v[0:1], v[0:1], v[2:3]                   // s70 = s66 / s73
v_cvt_u32_f64 v0, v[0:1]                           // s70 = s66 / s73
v_mul_lo_u32 v1, v0, s73                           // s70 = s66 / s73
v_sub_nc_u32 v2, s66, v1                           // s70 = s66 / s73
v_cmp_ge_u32 vcc_lo, v2, s73                       // s70 = s66 / s73
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, vcc_lo                          // s70 = s66 / s73
v_add_nc_u32 v0, v0, 1                             // s70 = s66 / s73
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, -1                              // Reset exec
v_readfirstlane_b32 s70, v0                        // quotient
s_mul_i32 s70, s70, s73
s_sub_u32 s71, s66, s70
s_cmp_gt_u32 s[sgprWorkGroup0], s70
s_cselect_b32 s70, s71, s73
s_lshr_b32 s70, s70, s72
s_bfm_b32 s71, s72, 0
s_and_b32 s71, s[sgprWorkGroup0], s71
s_mul_i32 s70, s70, s71
/* WorkGroup0 = temp0 + temp1 */
s_add_u32 s[sgprWorkGroup0], s69, s70
label_skip_WGMXCC:  /// skip WGMXCC if no enough WGs to remap
s_cmp_eq_u32 s64, 3
s_cbranch_scc1 label_ArgType3_Routed_To_ArgType0
s_cmp_eq_u32 s64, 0
s_cbranch_scc0 label_MultiGemm
label_ArgType3_Routed_To_ArgType0:
/* init: add vgpr [0...14) to pool */
/* init: add vgpr [146...422) to pool */
/* init: add vgpr [14...142) to pool */
/* init: add agpr [0...0) to pool */

/******************************************/
/* Local Read Addresses                   */
/******************************************/

/* local read addresses: tile assignments a/b */
/* lr0I */
s_nop 0
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_and_b32 v1, 31, v[vgprSerial-256]                // 0. thread id in wave: wtid = tid % wavelength(32)
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_and_b32 v0, 15, v1                               // 1. N offset: nIdx = wtid % MI_N(16)
v_lshlrev_b32 v0, 8, v0                            // 1. N offset: nOffset = nIdx * nStride(256)
/* Skip. 2. block offset: bnOffset = 0 when num1DBlocks = 1 */
                                                   // 4. apply VectorWidth: bnOffset = bnOffset * vw(1) (multiplier is 1, do nothing)
v_lshrrev_b32 v1, 4, v1                            // 5. K offset: kIdx = wtid / (MIN(16) * MIBB(1))
v_lshl_add_u32 v0, v1, 5, v0                       // 5. K offset: lrKOffset = kIdx * mStride(32); 6. offset in wave: lrOffset = bnOffset + lrKOffset
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_lshrrev_b32 v4, 5, v[vgprSerial-256]             // 7. wave offset in N dimen: wtid = tid / dividedForWaveId(32)
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_and_b32 v4, 1, v4                                // 7. wave offset in M dimen: wtid0 = wtid / num1DWaves(2)
v_lshl_add_u32 v0, v4, 12, v0                      // 7. wave offset in M dimen: wOffset = wtid0 * W0Stride(4096); 7. final local read offset: flrOffset = lrOffset + WOffset
/* lr0I */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_and_b32 v1, 31, v[vgprSerial-256]                // 0. thread id in wave: wtid = tid % wavelength(32)
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_and_b32 v1, 15, v1                               // 1. N offset: nIdx = wtid % MI_N(16)
v_lshlrev_b32 v1, 2, v1                            // 1. N offset: nOffset = nIdx * nStride(4)
/* Skip. 2. block offset: bnOffset = 0 when num1DBlocks = 1 */
                                                   // 4. apply VectorWidth: bnOffset = bnOffset * vw(1) (multiplier is 1, do nothing)
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_lshrrev_b32 v3, 5, v[vgprSerial-256]             // 7. wave offset in N dimen: wtid = tid / dividedForWaveId(32)
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_and_b32 v3, 1, v3                                // 7. wave offset in M dimen: wtid0 = wtid / num1DWaves(2)
v_lshl_add_u32 v1, v3, 6, v1                       // 7. wave offset in M dimen: wOffset = wtid0 * W0Stride(64); 7. final local read offset: flrOffset = lrOffset + WOffset
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_lshrrev_b32 v3, 4, v[vgprSerial-256]             // 8. (TileSpan wave-split) hiSel = tid / MI_dim(16)
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_and_b32 v3, 1, v3                                // 8. (TileSpan wave-split) hi = (tid / MI_dim) & 1  (lower/upper half-wave)
v_lshl_add_u32 v1, v3, 7, v1                       // 8. (TileSpan wave-split) wave offset in M dimen: wOffset += hi * hiOffset(128); upper half-wave grabs partner block
/* lr1J */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_and_b32 v3, 31, v[vgprSerial-256]                // 0. thread id in wave: wtid = tid % wavelength(32)
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_and_b32 v2, 15, v3                               // 1. N offset: nIdx = wtid % MI_N(16)
v_lshlrev_b32 v2, 8, v2                            // 1. N offset: nOffset = nIdx * nStride(256)
/* Skip. 2. block offset: bnOffset = 0 when num1DBlocks = 1 */
v_lshlrev_b32 v2, 2, v2                            // 4. apply VectorWidth: bnOffset = bnOffset * vw(4)
v_lshrrev_b32 v3, 4, v3                            // 5. K offset: kIdx = wtid / (MIN(16) * MIBB(1))
v_lshl_add_u32 v2, v3, 5, v2                       // 5. K offset: lrKOffset = kIdx * mStride(32); 6. offset in wave: lrOffset = bnOffset + lrKOffset
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_lshrrev_b32 v6, 6, v[vgprSerial-256]             // 7. wave offset in N dimen: wtid = tid / dividedForWaveId(64)
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_and_b32 v6, 1, v6                                // 7. wave offset in M dimen: wtid0 = wtid / num1DWaves(2)
v_lshl_add_u32 v2, v6, 14, v2                      // 7. wave offset in M dimen: wOffset = wtid0 * W0Stride(16384); 7. final local read offset: flrOffset = lrOffset + WOffset
/* lr1J */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_and_b32 v4, 31, v[vgprSerial-256]                // 0. thread id in wave: wtid = tid % wavelength(32)
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_and_b32 v3, 15, v4                               // 1. N offset: nIdx = wtid % MI_N(16)
v_lshlrev_b32 v3, 2, v3                            // 1. N offset: nOffset = nIdx * nStride(4)
/* Skip. 2. block offset: bnOffset = 0 when num1DBlocks = 1 */
v_lshlrev_b32 v3, 2, v3                            // 4. apply VectorWidth: bnOffset = bnOffset * vw(4)
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_lshrrev_b32 v5, 6, v[vgprSerial-256]             // 7. wave offset in N dimen: wtid = tid / dividedForWaveId(64)
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_and_b32 v5, 1, v5                                // 7. wave offset in M dimen: wtid0 = wtid / num1DWaves(2)
v_lshl_add_u32 v3, v5, 8, v3                       // 7. wave offset in M dimen: wOffset = wtid0 * W0Stride(256); 7. final local read offset: flrOffset = lrOffset + WOffset

/* local read addresses: final offsets a */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_lshrrev_b32 v4, 5, v[vgprSerial-256]             // 4 = Serial / 32
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_lshrrev_b32 v4, 2, v4                            // LSU offset: Get LSU wave_id
s_mov_b32 s65, 256                                 // LSU offset: stride = lsuStride(256) when umlds==True
v_mul_lo_u32 v4, s65, v4                           // LSU offset: lsuoffset = wave_id*lsuStride*(MT0+PAD)
v_add_nc_u32 v[vgprLocalReadAddrA], v4, v0         // Final Offset: offset = (lro0+lsuoffset)*bpeDS
v_lshrrev_b32 v[vgprLocalReadAddrA], 1, v[vgprLocalReadAddrA] //  (multiple bpe)
v_lshrrev_b32 v5, 8, v[vgprLocalReadAddrA]         // Final Offset: padding 16 per block 256
v_lshl_add_u32 v[vgprLocalReadAddrA], v5, 4, v[vgprLocalReadAddrA] // Final Offset: padding 16 per block 256

/* local read addresses: final offsets mxsa */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_lshrrev_b32 v0, 5, v[vgprSerial-256]             // 0 = Serial / 32
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_lshrrev_b32 v0, 2, v0                            // LSU offset: Get LSU wave_id
s_mov_b32 s65, 1024                                // LSU offset: stride = lsuStride(8)*(MT0(128) + PAD0(0))
v_mul_lo_u32 v0, s65, v0                           // LSU offset: lsuoffset = wave_id*lsuStride*(MT0+PAD)
v_add_nc_u32 v[vgprLocalReadAddrMXSA], v0, v1      // Final Offset: offset = (lro0+lsuoffset)*bpeDS
                                                   //  (bpe is 1, do nothing)

/* local read addresses: final offsets mxsb */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_lshrrev_b32 v0, 5, v[vgprSerial-256]             // 0 = Serial / 32
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_lshrrev_b32 v0, 2, v0                            // LSU offset: Get LSU wave_id
                                                   // LSU offset: stride = lsuStride(8)*(MT1(128) + PAD1(0)) (dup assign opt.)
v_mul_lo_u32 v0, s65, v0                           // LSU offset: lsuoffset = wave_id*lsuStride*(MT1+PAD)
v_add_nc_u32 v[vgprLocalReadAddrMXSB], v0, v3      // Final Offset: offset = (lro1+lsuoffset)*bpeDS
                                                   //  (bpe is 1, do nothing)

/* local read addresses: final offsets b */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_lshrrev_b32 v0, 5, v[vgprSerial-256]             // 0 = Serial / 32
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_lshrrev_b32 v0, 2, v0                            // LSU offset: Get LSU wave_id
s_mov_b32 s65, 256                                 // LSU offset: stride = lsuStride(256) when umlds==True
v_mul_lo_u32 v0, s65, v0                           // LSU offset: lsuoffset = wave_id*lsuStride*(MT1+PAD)
v_add_nc_u32 v[vgprLocalReadAddrB], v0, v2         // Final Offset: offset = (lro1+lsuoffset)*bpeDS
v_lshrrev_b32 v[vgprLocalReadAddrB], 1, v[vgprLocalReadAddrB] //  (multiple bpe)
v_lshrrev_b32 v1, 9, v[vgprLocalReadAddrB]         // Final Offset: padding 16 per block 512
v_lshl_add_u32 v[vgprLocalReadAddrB], v1, 4, v[vgprLocalReadAddrB] // Final Offset: padding 16 per block 512

/* local read addresses: declare addresses a */

/* local read addresses: declare addresses mxsa */
v_add_co_u32 v[vgprLocalReadAddrMXSA+0], vcc_lo, 0x4400, v[vgprLocalReadAddrMXSA+0] //  += LdsOffsetMXSA (lower)

/* local read addresses: declare addresses mxsb */
v_add_co_u32 v[vgprLocalReadAddrMXSB+0], vcc_lo, 0x4800, v[vgprLocalReadAddrMXSB+0] //  += LdsOffsetMXSB (lower)

/* local read addresses: declare addresses b */
v_add_co_u32 v[vgprLocalReadAddrB+0], vcc_lo, 0x4c00, v[vgprLocalReadAddrB+0] //  += LdsOffsetB (lower)

/******************************************/
/* Local Write Addresses                  */
/******************************************/

/* local write addresses: first offset a */

/* local write addresses: first offset b */
v_mov_b32 v2, MT0                                  // set MT0 into sgpr
v_mov_b32 v1, s[sgprSizesFree+0]                   // set Free0 size
v_cvt_f32_u32 v0, v2                               // v0 = ceil(v1 / v2)
v_rcp_iflag_f32 v0, v0                             // v0 = ceil(v1 / v2)
v_cvt_f32_u32 v3, v1                               // v0 = ceil(v1 / v2)
v_mul_f32 v0, v0, v3                               // v0 = ceil(v1 / v2)
v_cvt_u32_f32 v0, v0                               // v0 = ceil(v1 / v2)
v_mul_u32_u24 v3, v0, v2                           // v0 = ceil(v1 / v2)
v_sub_nc_u32 v3, v1, v3                            // v0 = ceil(v1 / v2)
v_cmp_ne_u32 vcc_lo, v3, 0                         // v0 = ceil(v1 / v2)
v_add_co_ci_u32 v0, vcc_lo, v0, 0, vcc_lo          // ceil
v_mov_b32 v2, MT1                                  // set MT1 into sgpr
v_mov_b32 v1, s[sgprSizesFree+1]                   // set Free1 size
v_readfirstlane_b32 s[sgprNumWorkGroups0], v0      // set back to numWorkGroup0
v_cvt_f32_u32 v0, v2                               // v0 = ceil(v1 / v2)
v_rcp_iflag_f32 v0, v0                             // v0 = ceil(v1 / v2)
v_cvt_f32_u32 v3, v1                               // v0 = ceil(v1 / v2)
v_mul_f32 v0, v0, v3                               // v0 = ceil(v1 / v2)
v_cvt_u32_f32 v0, v0                               // v0 = ceil(v1 / v2)
v_mul_u32_u24 v3, v0, v2                           // v0 = ceil(v1 / v2)
v_sub_nc_u32 v3, v1, v3                            // v0 = ceil(v1 / v2)
v_cmp_ne_u32 vcc_lo, v3, 0                         // v0 = ceil(v1 / v2)
v_add_co_ci_u32 v0, vcc_lo, v0, 0, vcc_lo          // ceil
s_nop 0                                            // 1 wait states
v_readfirstlane_b32 s[sgprNumWorkGroups1], v0      // set back to numWorkGroup1
s_wait_kmcnt 0                                     // wait for 12/0 bytes of kern args

/* remap wg from 1D(idxWG012) to 3D(wg2,wg1,wg0) */
/* wg2 = idxWG012 * smallMagicNumber(1/(numWG0*numWG1)) */
s_mul_i32 s64, s[sgprNumWorkGroups0], s[sgprNumWorkGroups1]
s_and_b32 s65, s[sgprGSU], 0x3fff                  // Restore GSU
s_mul_i32 s64, s64, s65
v_cvt_f32_u32 v0, s64                              // s64 = s[sgprWorkGroup0] / s64
v_rcp_iflag_f32 v0, v0                             // s64 = s[sgprWorkGroup0] / s64
v_cvt_f32_u32 v1, s[sgprWorkGroup0]                // s64 = s[sgprWorkGroup0] / s64
v_mul_f32 v0, v0, v1                               // s64 = s[sgprWorkGroup0] / s64
v_cvt_u32_f32 v0, v0                               // s64 = s[sgprWorkGroup0] / s64
v_mul_u32_u24 v1, v0, s64                          // s64 = s[sgprWorkGroup0] / s64
v_sub_nc_u32 v1, s[sgprWorkGroup0], v1             // s64 = s[sgprWorkGroup0] / s64
v_cmp_eq_u32 vcc_lo, v1, s64                       // s64 = s[sgprWorkGroup0] / s64
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, vcc_lo                          // s64 = s[sgprWorkGroup0] / s64
v_add_nc_u32 v0, 1, v0                             // s64 = s[sgprWorkGroup0] / s64
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, -1                              // Reset exec
v_cmp_gt_u32 vcc_lo, v1, s64                       // overflow happened in remainder
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, vcc_lo                          // overflow happened in remainder
v_sub_nc_u32 v0, v0, 1                             // quotient - 1
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, -1                              // Reset exec
v_readfirstlane_b32 s64, v0                        // quotient
s_mov_b32 s[sgprWorkGroup2], s64
/* idxWG01 = idxWG012 - wg2 * numWG0 * numWG1 */
s_mul_i32 s64, s[sgprNumWorkGroups1], s[sgprNumWorkGroups0]
s_mul_i32 s64, s64, s[sgprWorkGroup2]
s_mul_i32 s64, s64, s65
s_sub_u32 s[sgprWorkGroup0], s[sgprWorkGroup0], s64
/* wg1 = idxWG01 * smallMagicNumber(1/numWG0) */
v_cvt_f32_u32 v0, s[sgprNumWorkGroups0]            // s64 = s[sgprWorkGroup0] / s[sgprNumWorkGroups0]
v_rcp_iflag_f32 v0, v0                             // s64 = s[sgprWorkGroup0] / s[sgprNumWorkGroups0]
v_cvt_f32_u32 v1, s[sgprWorkGroup0]                // s64 = s[sgprWorkGroup0] / s[sgprNumWorkGroups0]
v_mul_f32 v0, v0, v1                               // s64 = s[sgprWorkGroup0] / s[sgprNumWorkGroups0]
v_cvt_u32_f32 v0, v0                               // s64 = s[sgprWorkGroup0] / s[sgprNumWorkGroups0]
v_mul_u32_u24 v1, v0, s[sgprNumWorkGroups0]        // s64 = s[sgprWorkGroup0] / s[sgprNumWorkGroups0]
v_sub_nc_u32 v1, s[sgprWorkGroup0], v1             // s64 = s[sgprWorkGroup0] / s[sgprNumWorkGroups0]
v_cmp_eq_u32 vcc_lo, v1, s[sgprNumWorkGroups0]     // s64 = s[sgprWorkGroup0] / s[sgprNumWorkGroups0]
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, vcc_lo                          // s64 = s[sgprWorkGroup0] / s[sgprNumWorkGroups0]
v_add_nc_u32 v0, 1, v0                             // s64 = s[sgprWorkGroup0] / s[sgprNumWorkGroups0]
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, -1                              // Reset exec
v_cmp_gt_u32 vcc_lo, v1, s[sgprNumWorkGroups0]     // overflow happened in remainder
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, vcc_lo                          // overflow happened in remainder
v_sub_nc_u32 v0, v0, 1                             // quotient - 1
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, -1                              // Reset exec
v_readfirstlane_b32 s64, v0                        // quotient
s_mov_b32 s[sgprWorkGroup1], s64
/* wg0 = idxWG01 - wg1 * numWG0 */
s_mul_i32 s64, s[sgprWorkGroup1], s[sgprNumWorkGroups0]
s_sub_u32 s[sgprWorkGroup0], s[sgprWorkGroup0], s64
s_branch label_MultiGemmEnd
label_MultiGemm:

/* Check if custom structure pointer is null */
s_cmp_eq_u32 s[sgprArgType], 2                     // ArgType == 2 ?
s_cbranch_scc1 label_IsExternalValid               // branch if ArgType == 2
s_mov_b32 s16, 120                                 // KernArgAddressOffset
s_mul_i32 s24, s63, 4
s_mov_b64 s[18:19], s[sgprKernArgAddress:sgprKernArgAddress+1]
s_branch label_IsExternalValidEnd
label_IsExternalValid:
s_mov_b32 s16, 260
s_mov_b32 s24, 0
s_mov_b64 s[18:19], s[sgprKernArgAddress:sgprKernArgAddress+1]
label_IsExternalValidEnd:

/* Grouped Gemm:: prefetch 1 arg load */
s_mov_b32 s15, 1
s_mov_b32 s25, 0
s_load_b128 s[32:35], s[18:19], s24
s_mov_b32 s17, 1
s_cmp_eq_u32 s63, s17                              // if gemm_count is 1?
s_cbranch_scc1 label_wgTable_noLoadLoop

/* Grouped Gemm:: accumulate numTiles for each gemm */
/* Grouped Gemm:: loop start */
label_Loop_GemmCount:
s_wait_kmcnt 0
s_lshr_b32 s22, s32, 7                             // s22 = s32 / 128
s_and_b32 s20, 127, s32                            // s20 = s32 % 128
s_addc_u32 s22, s22, 0
s_lshr_b32 s23, s33, 7                             // s23 = s33 / 128
s_and_b32 s20, 127, s33                            // s20 = s33 % 128
s_addc_u32 s23, s23, 0
s_mul_i32 s22, s22, s23
s_mul_i32 s22, s22, s34
s_and_b32 s23, s[sgprGSU], 0x3fff                  // Restore GSU
s_mul_i32 s22, s22, s23
s_add_u32 s25, s25, s22
s_cmp_lt_u32 s[sgprWorkGroup0], s25
s_cbranch_scc1 label_FOUND
s_add_u32 s24, s24, s16
s_load_b128 s[32:35], s[18:19], s24
s_add_u32 s15, s15, 1
s_cmp_lt_u32 s15, s63
s_cbranch_scc1 label_Loop_GemmCount

/* Grouped Gemm:: noLoadLoop */
label_wgTable_noLoadLoop:
s_wait_kmcnt 0
s_lshr_b32 s22, s32, 7                             // s22 = s32 / 128
s_and_b32 s20, 127, s32                            // s20 = s32 % 128
s_addc_u32 s22, s22, 0
s_lshr_b32 s23, s33, 7                             // s23 = s33 / 128
s_and_b32 s20, 127, s33                            // s20 = s33 % 128
s_addc_u32 s23, s23, 0
s_mul_i32 s22, s22, s23
s_mul_i32 s22, s22, s34
s_and_b32 s18, s[sgprGSU], 0x3fff                  // Restore GSU
s_mul_i32 s22, s22, s18
s_add_u32 s25, s25, s22

/* Grouped Gemm:: gemmIndex found */
label_FOUND:
s_sub_u32 s19, s15, 1
s_sub_u32 s18, s25, s22
s_sub_u32 s[sgprWorkGroup0], s[sgprWorkGroup0], s18
/* Check if custom structure pointer is null */
s_cmp_eq_u32 s[sgprArgType], 2                     // ArgType == 2 ?
s_cbranch_scc1 label_LoadExternalStruct            // branch if ArgType == 2

/* Grouped Gemm: offset argument address to gemm */
/* Grouped Gemm: offset address from wg_table_start to args_start */
s_lshl2_add_u32 s[sgprKernArgAddress], s63, s[sgprKernArgAddress]
s_addc_u32 s[sgprKernArgAddress+1], s[sgprKernArgAddress+1], 0
/* Grouped Gemm: offset address from args_start to gemm_start */
s_mul_i32 s19, s19, 120                            // KernArgAddressOffset
s_add_u32 s[sgprKernArgAddress], s[sgprKernArgAddress], s19
s_addc_u32 s[sgprKernArgAddress+1], s[sgprKernArgAddress+1], 0

/* Load Kernel Args */
s_load_b512 s[36:51], s[sgprKernArgAddress:sgprKernArgAddress+1], 16 // 16
s_load_b256 s[52:59], s[sgprKernArgAddress:sgprKernArgAddress+1], 80 // 80
s_load_b64 s[60:61], s[sgprKernArgAddress:sgprKernArgAddress+1], 112 // 112
s_branch label_LoadExternalStructEnd
label_LoadExternalStruct:
/* Grouped Gemm: offset address from args_start to gemm_start */
s_mul_i32 s19, s19, 260
s_add_u32 s[sgprKernArgAddress], s[sgprKernArgAddress], s19
s_addc_u32 s[sgprKernArgAddress+1], s[sgprKernArgAddress+1], 0
s_load_b512 s[36:51], s[sgprKernArgAddress:sgprKernArgAddress+1], 16 // 16
s_load_b256 s[52:59], s[sgprKernArgAddress:sgprKernArgAddress+1], 80 // 80
s_load_b32 s60, s[sgprKernArgAddress:sgprKernArgAddress+1], 112 // 112
// Read Beta
s_load_b32 s61, s[sgprKernArgAddress:sgprKernArgAddress+1], 128 // 128
label_LoadExternalStructEnd:
/* init: add vgpr [0...14) to pool */
/* init: add vgpr [146...422) to pool */
/* init: add vgpr [14...142) to pool */
/* init: add agpr [0...0) to pool */

/******************************************/
/* Local Read Addresses                   */
/******************************************/

/* local read addresses: tile assignments a/b */
/* lr0I */
s_nop 0
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_and_b32 v1, 31, v[vgprSerial-256]                // 0. thread id in wave: wtid = tid % wavelength(32)
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_and_b32 v0, 15, v1                               // 1. N offset: nIdx = wtid % MI_N(16)
v_lshlrev_b32 v0, 8, v0                            // 1. N offset: nOffset = nIdx * nStride(256)
/* Skip. 2. block offset: bnOffset = 0 when num1DBlocks = 1 */
                                                   // 4. apply VectorWidth: bnOffset = bnOffset * vw(1) (multiplier is 1, do nothing)
v_lshrrev_b32 v1, 4, v1                            // 5. K offset: kIdx = wtid / (MIN(16) * MIBB(1))
v_lshl_add_u32 v0, v1, 5, v0                       // 5. K offset: lrKOffset = kIdx * mStride(32); 6. offset in wave: lrOffset = bnOffset + lrKOffset
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_lshrrev_b32 v4, 5, v[vgprSerial-256]             // 7. wave offset in N dimen: wtid = tid / dividedForWaveId(32)
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_and_b32 v4, 1, v4                                // 7. wave offset in M dimen: wtid0 = wtid / num1DWaves(2)
v_lshl_add_u32 v0, v4, 12, v0                      // 7. wave offset in M dimen: wOffset = wtid0 * W0Stride(4096); 7. final local read offset: flrOffset = lrOffset + WOffset
/* lr0I */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_and_b32 v1, 31, v[vgprSerial-256]                // 0. thread id in wave: wtid = tid % wavelength(32)
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_and_b32 v1, 15, v1                               // 1. N offset: nIdx = wtid % MI_N(16)
v_lshlrev_b32 v1, 2, v1                            // 1. N offset: nOffset = nIdx * nStride(4)
/* Skip. 2. block offset: bnOffset = 0 when num1DBlocks = 1 */
                                                   // 4. apply VectorWidth: bnOffset = bnOffset * vw(1) (multiplier is 1, do nothing)
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_lshrrev_b32 v3, 5, v[vgprSerial-256]             // 7. wave offset in N dimen: wtid = tid / dividedForWaveId(32)
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_and_b32 v3, 1, v3                                // 7. wave offset in M dimen: wtid0 = wtid / num1DWaves(2)
v_lshl_add_u32 v1, v3, 6, v1                       // 7. wave offset in M dimen: wOffset = wtid0 * W0Stride(64); 7. final local read offset: flrOffset = lrOffset + WOffset
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_lshrrev_b32 v3, 4, v[vgprSerial-256]             // 8. (TileSpan wave-split) hiSel = tid / MI_dim(16)
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_and_b32 v3, 1, v3                                // 8. (TileSpan wave-split) hi = (tid / MI_dim) & 1  (lower/upper half-wave)
v_lshl_add_u32 v1, v3, 7, v1                       // 8. (TileSpan wave-split) wave offset in M dimen: wOffset += hi * hiOffset(128); upper half-wave grabs partner block
/* lr1J */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_and_b32 v3, 31, v[vgprSerial-256]                // 0. thread id in wave: wtid = tid % wavelength(32)
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_and_b32 v2, 15, v3                               // 1. N offset: nIdx = wtid % MI_N(16)
v_lshlrev_b32 v2, 8, v2                            // 1. N offset: nOffset = nIdx * nStride(256)
/* Skip. 2. block offset: bnOffset = 0 when num1DBlocks = 1 */
v_lshlrev_b32 v2, 2, v2                            // 4. apply VectorWidth: bnOffset = bnOffset * vw(4)
v_lshrrev_b32 v3, 4, v3                            // 5. K offset: kIdx = wtid / (MIN(16) * MIBB(1))
v_lshl_add_u32 v2, v3, 5, v2                       // 5. K offset: lrKOffset = kIdx * mStride(32); 6. offset in wave: lrOffset = bnOffset + lrKOffset
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_lshrrev_b32 v6, 6, v[vgprSerial-256]             // 7. wave offset in N dimen: wtid = tid / dividedForWaveId(64)
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_and_b32 v6, 1, v6                                // 7. wave offset in M dimen: wtid0 = wtid / num1DWaves(2)
v_lshl_add_u32 v2, v6, 14, v2                      // 7. wave offset in M dimen: wOffset = wtid0 * W0Stride(16384); 7. final local read offset: flrOffset = lrOffset + WOffset
/* lr1J */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_and_b32 v4, 31, v[vgprSerial-256]                // 0. thread id in wave: wtid = tid % wavelength(32)
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_and_b32 v3, 15, v4                               // 1. N offset: nIdx = wtid % MI_N(16)
v_lshlrev_b32 v3, 2, v3                            // 1. N offset: nOffset = nIdx * nStride(4)
/* Skip. 2. block offset: bnOffset = 0 when num1DBlocks = 1 */
v_lshlrev_b32 v3, 2, v3                            // 4. apply VectorWidth: bnOffset = bnOffset * vw(4)
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_lshrrev_b32 v5, 6, v[vgprSerial-256]             // 7. wave offset in N dimen: wtid = tid / dividedForWaveId(64)
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_and_b32 v5, 1, v5                                // 7. wave offset in M dimen: wtid0 = wtid / num1DWaves(2)
v_lshl_add_u32 v3, v5, 8, v3                       // 7. wave offset in M dimen: wOffset = wtid0 * W0Stride(256); 7. final local read offset: flrOffset = lrOffset + WOffset

/* local read addresses: final offsets a */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_lshrrev_b32 v4, 5, v[vgprSerial-256]             // 4 = Serial / 32
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_lshrrev_b32 v4, 2, v4                            // LSU offset: Get LSU wave_id
s_mov_b32 s65, 256                                 // LSU offset: stride = lsuStride(256) when umlds==True
v_mul_lo_u32 v4, s65, v4                           // LSU offset: lsuoffset = wave_id*lsuStride*(MT0+PAD)
v_add_nc_u32 v[vgprLocalReadAddrA], v4, v0         // Final Offset: offset = (lro0+lsuoffset)*bpeDS
v_lshrrev_b32 v[vgprLocalReadAddrA], 1, v[vgprLocalReadAddrA] //  (multiple bpe)
v_lshrrev_b32 v5, 8, v[vgprLocalReadAddrA]         // Final Offset: padding 16 per block 256
v_lshl_add_u32 v[vgprLocalReadAddrA], v5, 4, v[vgprLocalReadAddrA] // Final Offset: padding 16 per block 256

/* local read addresses: final offsets mxsa */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_lshrrev_b32 v0, 5, v[vgprSerial-256]             // 0 = Serial / 32
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_lshrrev_b32 v0, 2, v0                            // LSU offset: Get LSU wave_id
s_mov_b32 s65, 1024                                // LSU offset: stride = lsuStride(8)*(MT0(128) + PAD0(0))
v_mul_lo_u32 v0, s65, v0                           // LSU offset: lsuoffset = wave_id*lsuStride*(MT0+PAD)
v_add_nc_u32 v[vgprLocalReadAddrMXSA], v0, v1      // Final Offset: offset = (lro0+lsuoffset)*bpeDS
                                                   //  (bpe is 1, do nothing)

/* local read addresses: final offsets mxsb */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_lshrrev_b32 v0, 5, v[vgprSerial-256]             // 0 = Serial / 32
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_lshrrev_b32 v0, 2, v0                            // LSU offset: Get LSU wave_id
                                                   // LSU offset: stride = lsuStride(8)*(MT1(128) + PAD1(0)) (dup assign opt.)
v_mul_lo_u32 v0, s65, v0                           // LSU offset: lsuoffset = wave_id*lsuStride*(MT1+PAD)
v_add_nc_u32 v[vgprLocalReadAddrMXSB], v0, v3      // Final Offset: offset = (lro1+lsuoffset)*bpeDS
                                                   //  (bpe is 1, do nothing)

/* local read addresses: final offsets b */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_lshrrev_b32 v0, 5, v[vgprSerial-256]             // 0 = Serial / 32
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_lshrrev_b32 v0, 2, v0                            // LSU offset: Get LSU wave_id
s_mov_b32 s65, 256                                 // LSU offset: stride = lsuStride(256) when umlds==True
v_mul_lo_u32 v0, s65, v0                           // LSU offset: lsuoffset = wave_id*lsuStride*(MT1+PAD)
v_add_nc_u32 v[vgprLocalReadAddrB], v0, v2         // Final Offset: offset = (lro1+lsuoffset)*bpeDS
v_lshrrev_b32 v[vgprLocalReadAddrB], 1, v[vgprLocalReadAddrB] //  (multiple bpe)
v_lshrrev_b32 v1, 9, v[vgprLocalReadAddrB]         // Final Offset: padding 16 per block 512
v_lshl_add_u32 v[vgprLocalReadAddrB], v1, 4, v[vgprLocalReadAddrB] // Final Offset: padding 16 per block 512

/* local read addresses: declare addresses a */

/* local read addresses: declare addresses mxsa */
v_add_co_u32 v[vgprLocalReadAddrMXSA+0], vcc_lo, 0x4400, v[vgprLocalReadAddrMXSA+0] //  += LdsOffsetMXSA (lower)

/* local read addresses: declare addresses mxsb */
v_add_co_u32 v[vgprLocalReadAddrMXSB+0], vcc_lo, 0x4800, v[vgprLocalReadAddrMXSB+0] //  += LdsOffsetMXSB (lower)

/* local read addresses: declare addresses b */
v_add_co_u32 v[vgprLocalReadAddrB+0], vcc_lo, 0x4c00, v[vgprLocalReadAddrB+0] //  += LdsOffsetB (lower)

/******************************************/
/* Local Write Addresses                  */
/******************************************/

/* local write addresses: first offset a */

/* local write addresses: first offset b */
v_mov_b32 v2, MT0                                  // set MT0 into sgpr
v_mov_b32 v1, s[sgprSizesFree+0]                   // set Free0 size
v_cvt_f32_u32 v0, v2                               // v0 = ceil(v1 / v2)
v_rcp_iflag_f32 v0, v0                             // v0 = ceil(v1 / v2)
v_cvt_f32_u32 v3, v1                               // v0 = ceil(v1 / v2)
v_mul_f32 v0, v0, v3                               // v0 = ceil(v1 / v2)
v_cvt_u32_f32 v0, v0                               // v0 = ceil(v1 / v2)
v_mul_u32_u24 v3, v0, v2                           // v0 = ceil(v1 / v2)
v_sub_nc_u32 v3, v1, v3                            // v0 = ceil(v1 / v2)
v_cmp_ne_u32 vcc_lo, v3, 0                         // v0 = ceil(v1 / v2)
v_add_co_ci_u32 v0, vcc_lo, v0, 0, vcc_lo          // ceil
v_mov_b32 v2, MT1                                  // set MT1 into sgpr
v_mov_b32 v1, s[sgprSizesFree+1]                   // set Free1 size
v_readfirstlane_b32 s[sgprNumWorkGroups0], v0      // set back to numWorkGroup0
v_cvt_f32_u32 v0, v2                               // v0 = ceil(v1 / v2)
v_rcp_iflag_f32 v0, v0                             // v0 = ceil(v1 / v2)
v_cvt_f32_u32 v3, v1                               // v0 = ceil(v1 / v2)
v_mul_f32 v0, v0, v3                               // v0 = ceil(v1 / v2)
v_cvt_u32_f32 v0, v0                               // v0 = ceil(v1 / v2)
v_mul_u32_u24 v3, v0, v2                           // v0 = ceil(v1 / v2)
v_sub_nc_u32 v3, v1, v3                            // v0 = ceil(v1 / v2)
v_cmp_ne_u32 vcc_lo, v3, 0                         // v0 = ceil(v1 / v2)
v_add_co_ci_u32 v0, vcc_lo, v0, 0, vcc_lo          // ceil
s_nop 0                                            // 1 wait states
v_readfirstlane_b32 s[sgprNumWorkGroups1], v0      // set back to numWorkGroup1
s_wait_kmcnt 0                                     // wait for 12/0 bytes of kern args

/* Early stop if N(SizeFreeJ) == 0 */
s_cmp_eq_u32 s[sgprSizeJ], 0
s_cbranch_scc0 label_NoEarlyStop_N0
label_EarlyStop_if_N_is_0:
s_endpgm
label_NoEarlyStop_N0:

/* remap wg from 1D(idxWG012) to 3D(wg2,wg1,wg0) */
/* wg2 = idxWG012 * smallMagicNumber(1/(numWG0*numWG1)) */
s_mul_i32 s18, s[sgprNumWorkGroups0], s[sgprNumWorkGroups1]
s_and_b32 s19, s[sgprGSU], 0x3fff                  // Restore GSU
s_mul_i32 s18, s18, s19
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cvt_f32_u32 v0, s18                              // s18 = s[sgprWorkGroup0] / s18
v_rcp_iflag_f32 v0, v0                             // s18 = s[sgprWorkGroup0] / s18
v_cvt_f32_u32 v1, s[sgprWorkGroup0]                // s18 = s[sgprWorkGroup0] / s18
v_mul_f32 v0, v0, v1                               // s18 = s[sgprWorkGroup0] / s18
v_cvt_u32_f32 v0, v0                               // s18 = s[sgprWorkGroup0] / s18
v_mul_u32_u24 v1, v0, s18                          // s18 = s[sgprWorkGroup0] / s18
v_sub_nc_u32 v1, s[sgprWorkGroup0], v1             // s18 = s[sgprWorkGroup0] / s18
v_cmp_eq_u32 vcc_lo, v1, s18                       // s18 = s[sgprWorkGroup0] / s18
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, vcc_lo                          // s18 = s[sgprWorkGroup0] / s18
v_add_nc_u32 v0, 1, v0                             // s18 = s[sgprWorkGroup0] / s18
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, -1                              // Reset exec
v_cmp_gt_u32 vcc_lo, v1, s18                       // overflow happened in remainder
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, vcc_lo                          // overflow happened in remainder
v_sub_nc_u32 v0, v0, 1                             // quotient - 1
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, -1                              // Reset exec
v_readfirstlane_b32 s18, v0                        // quotient
s_mov_b32 s[sgprWorkGroup2], s18
/* idxWG01 = idxWG012 - wg2 * numWG0 * numWG1 */
s_mul_i32 s18, s[sgprNumWorkGroups1], s[sgprNumWorkGroups0]
s_mul_i32 s18, s18, s[sgprWorkGroup2]
s_mul_i32 s18, s18, s19
s_sub_u32 s[sgprWorkGroup0], s[sgprWorkGroup0], s18
/* wg1 = idxWG01 * smallMagicNumber(1/numWG0) */
v_cvt_f32_u32 v0, s[sgprNumWorkGroups0]            // s18 = s[sgprWorkGroup0] / s[sgprNumWorkGroups0]
v_rcp_iflag_f32 v0, v0                             // s18 = s[sgprWorkGroup0] / s[sgprNumWorkGroups0]
v_cvt_f32_u32 v1, s[sgprWorkGroup0]                // s18 = s[sgprWorkGroup0] / s[sgprNumWorkGroups0]
v_mul_f32 v0, v0, v1                               // s18 = s[sgprWorkGroup0] / s[sgprNumWorkGroups0]
v_cvt_u32_f32 v0, v0                               // s18 = s[sgprWorkGroup0] / s[sgprNumWorkGroups0]
v_mul_u32_u24 v1, v0, s[sgprNumWorkGroups0]        // s18 = s[sgprWorkGroup0] / s[sgprNumWorkGroups0]
v_sub_nc_u32 v1, s[sgprWorkGroup0], v1             // s18 = s[sgprWorkGroup0] / s[sgprNumWorkGroups0]
v_cmp_eq_u32 vcc_lo, v1, s[sgprNumWorkGroups0]     // s18 = s[sgprWorkGroup0] / s[sgprNumWorkGroups0]
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, vcc_lo                          // s18 = s[sgprWorkGroup0] / s[sgprNumWorkGroups0]
v_add_nc_u32 v0, 1, v0                             // s18 = s[sgprWorkGroup0] / s[sgprNumWorkGroups0]
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, -1                              // Reset exec
v_cmp_gt_u32 vcc_lo, v1, s[sgprNumWorkGroups0]     // overflow happened in remainder
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, vcc_lo                          // overflow happened in remainder
v_sub_nc_u32 v0, v0, 1                             // quotient - 1
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, -1                              // Reset exec
v_readfirstlane_b32 s18, v0                        // quotient
s_mov_b32 s[sgprWorkGroup1], s18
/* wg0 = idxWG01 - wg1 * numWG0 */
s_mul_i32 s18, s[sgprWorkGroup1], s[sgprNumWorkGroups0]
s_sub_u32 s[sgprWorkGroup0], s[sgprWorkGroup0], s18

/* Early stop if wg exceed */
s_cmp_ge_u32 s[sgprWorkGroup2], s[sgprSizesFree+2]
s_cbranch_scc0 label_NoEarlyStop_wgExceed
label_EarlyStop_if_wg_exceed:
s_endpgm
label_NoEarlyStop_wgExceed:

label_MultiGemmEnd:
.set sgprtdmAGroup0, 20
.set sgprtdmAGroup1, 24
.set sgprtdmAGroup2, 64
.set sgprtdmAGroup3, sgprtdmAGroup2+0
.set sgprtdmMXSAGroup0, 68
.set sgprtdmMXSAGroup1, 72
.set sgprtdmBGroup0, sgprtdmAGroup0+0
.set sgprtdmBGroup1, sgprtdmAGroup1+0
.set sgprtdmBGroup2, sgprtdmAGroup2+0
.set sgprtdmBGroup3, sgprtdmAGroup2+0
.set sgprtdmMXSBGroup0, sgprtdmMXSAGroup0+0
.set sgprtdmMXSBGroup1, sgprtdmMXSAGroup1+0
.set sgprtdmABIncs, 17
.set sgprtdmMXSAMXSBIncs, 18
.set sgprStaggerUIter, 19
.set sgprWrapUA, 80
.set sgprWrapUB, 82
.set sgprWrapUMXSA, 84
.set sgprWrapUMXSB, 86
.set sgprGlobalReadIncsA, 63
.set sgprGlobalReadIncsMXSA, 88
.set sgprGlobalReadIncsB, 89
.set sgprGlobalReadIncsMXSB, 90
s_cmp_eq_u32 s[sgprArgType], 3                     // ArgType == 3 for General Batched GEMM
s_cbranch_scc1 label_Skip_Address_Prepad_For_Pointer_Array
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
s_and_b32 s80, s[sgprGSU], 0x3fff                  // Restore GSU
s_cmp_eq_u32 s80, 1                                // GSU == 1 ?
s_cbranch_scc1 label_GSU                           // branch if GSU == 1
// GSU-not-WGMapRR :nwg1 = (size1J + MT1J - 1) / MT1J;
s_and_b32 s80, s[sgprGSU], 0x4000                  // SCC = (GSUWGMRR == 1) ?
s_cbranch_scc1 label_GSUWGMRR                      // branch if GSUWGMRR == 1
s_and_b32 s80, s[sgprGSU], 0x3fff                  // Restore GSU
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cvt_f32_u32 v0, s80                              // s[sgprWorkGroup1] = s[sgprWorkGroup1] / s80
v_rcp_iflag_f32 v0, v0                             // s[sgprWorkGroup1] = s[sgprWorkGroup1] / s80
v_cvt_f32_u32 v1, s[sgprWorkGroup1]                // s[sgprWorkGroup1] = s[sgprWorkGroup1] / s80
v_mul_f32 v0, v0, v1                               // s[sgprWorkGroup1] = s[sgprWorkGroup1] / s80
v_cvt_u32_f32 v0, v0                               // s[sgprWorkGroup1] = s[sgprWorkGroup1] / s80
v_mul_u32_u24 v1, v0, s80                          // s[sgprWorkGroup1] = s[sgprWorkGroup1] / s80
v_sub_nc_u32 v1, s[sgprWorkGroup1], v1             // s[sgprWorkGroup1] = s[sgprWorkGroup1] / s80
v_cmp_eq_u32 vcc_lo, v1, s80                       // s[sgprWorkGroup1] = s[sgprWorkGroup1] / s80
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, vcc_lo                          // s[sgprWorkGroup1] = s[sgprWorkGroup1] / s80
v_add_nc_u32 v0, 1, v0                             // s[sgprWorkGroup1] = s[sgprWorkGroup1] / s80
v_mov_b32 v1, 0                                    // s[sgprGSUSumIdx] = s[sgprWorkGroup1] % s80
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, -1                              // Reset exec
v_cmp_gt_u32 vcc_lo, v1, s80                       // overflow happened in remainder
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, vcc_lo                          // overflow happened in remainder
v_sub_nc_u32 v0, v0, 1                             // quotient - 1
v_mul_u32_u24 v1, v0, s80                          // re-calculate remainder
v_sub_nc_u32 v1, s[sgprWorkGroup1], v1             // re-calculate remainder
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, -1                              // Reset exec
v_readfirstlane_b32 s[sgprWorkGroup1], v0          // quotient
v_readfirstlane_b32 s[sgprGSUSumIdx], v1           // remainder
s_branch label_GSUWGMRR_End
label_GSUWGMRR:
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cvt_f32_u32 v0, s[sgprNumWorkGroups1]            // s[sgprGSUSumIdx] = s[sgprWorkGroup1] / s[sgprNumWorkGroups1]
v_rcp_iflag_f32 v0, v0                             // s[sgprGSUSumIdx] = s[sgprWorkGroup1] / s[sgprNumWorkGroups1]
v_cvt_f32_u32 v1, s[sgprWorkGroup1]                // s[sgprGSUSumIdx] = s[sgprWorkGroup1] / s[sgprNumWorkGroups1]
v_mul_f32 v0, v0, v1                               // s[sgprGSUSumIdx] = s[sgprWorkGroup1] / s[sgprNumWorkGroups1]
v_cvt_u32_f32 v0, v0                               // s[sgprGSUSumIdx] = s[sgprWorkGroup1] / s[sgprNumWorkGroups1]
v_mul_u32_u24 v1, v0, s[sgprNumWorkGroups1]        // s[sgprGSUSumIdx] = s[sgprWorkGroup1] / s[sgprNumWorkGroups1]
v_sub_nc_u32 v1, s[sgprWorkGroup1], v1             // s[sgprGSUSumIdx] = s[sgprWorkGroup1] / s[sgprNumWorkGroups1]
v_cmp_eq_u32 vcc_lo, v1, s[sgprNumWorkGroups1]     // s[sgprGSUSumIdx] = s[sgprWorkGroup1] / s[sgprNumWorkGroups1]
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, vcc_lo                          // s[sgprGSUSumIdx] = s[sgprWorkGroup1] / s[sgprNumWorkGroups1]
v_add_nc_u32 v0, 1, v0                             // s[sgprGSUSumIdx] = s[sgprWorkGroup1] / s[sgprNumWorkGroups1]
v_mov_b32 v1, 0                                    // s[sgprWorkGroup1] = s[sgprWorkGroup1] % s[sgprNumWorkGroups1]
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, -1                              // Reset exec
v_cmp_gt_u32 vcc_lo, v1, s[sgprNumWorkGroups1]     // overflow happened in remainder
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, vcc_lo                          // overflow happened in remainder
v_sub_nc_u32 v0, v0, 1                             // quotient - 1
v_mul_u32_u24 v1, v0, s[sgprNumWorkGroups1]        // re-calculate remainder
v_sub_nc_u32 v1, s[sgprWorkGroup1], v1             // re-calculate remainder
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, -1                              // Reset exec
v_readfirstlane_b32 s[sgprGSUSumIdx], v0           // quotient
v_readfirstlane_b32 s[sgprWorkGroup1], v1          // remainder
label_GSUWGMRR_End:
s_mov_b32 s[sgprGSULog2BpeC], 2
s_mov_b32 s[sgprGSULog2BpeD], 2
s_branch label_GSU_End
label_GSU:
s_mov_b64 s[sgprGSUSumIdx:sgprGSUSumIdx+1], 0      // Set GSUSumIdx to 0
s_mov_b32 s[sgprGSULog2BpeC], 2
s_mov_b32 s[sgprGSULog2BpeD], 2
label_GSU_End:
/* WGM Calculation */
s_mov_b32 s80, s[sgprWGM]                          // Restore WGM
s_sext_i32_i16 s80, s80                            // Restore WGM
s_cmp_gt_i32 s80, 1                                // WGM > 1 ?
s_cbranch_scc1 label_WGMPositive                   // branch if WGM > 1
s_cmp_ge_i32 s80, 0                                // WGM >= 0 ?
s_cbranch_scc1 label_WGM                           // branch if WGM >= 0
s_abs_i32 s80, s80                                 // abs(WGM)
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cvt_f64_u32 v[0:1], s80                          // s81 = s[sgprWorkGroup0] / s80
v_rcp_f64 v[0:1], v[0:1]                           // s81 = s[sgprWorkGroup0] / s80
v_cvt_f64_u32 v[2:3], s[sgprWorkGroup0]            // s81 = s[sgprWorkGroup0] / s80
v_mul_f64 v[0:1], v[0:1], v[2:3]                   // s81 = s[sgprWorkGroup0] / s80
v_cvt_u32_f64 v0, v[0:1]                           // s81 = s[sgprWorkGroup0] / s80
v_mul_lo_u32 v1, v0, s80                           // s81 = s[sgprWorkGroup0] / s80
v_sub_nc_u32 v2, s[sgprWorkGroup0], v1             // s81 = s[sgprWorkGroup0] / s80
v_cmp_ge_u32 vcc_lo, v2, s80                       // s81 = s[sgprWorkGroup0] / s80
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, vcc_lo                          // s81 = s[sgprWorkGroup0] / s80
v_add_nc_u32 v0, v0, 1                             // s81 = s[sgprWorkGroup0] / s80
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, -1                              // Reset exec
v_readfirstlane_b32 s81, v0                        // quotient
s_mul_i32 s91, s81, s80                            // quotient * non-magic divisor
s_sub_u32 s91, s[sgprWorkGroup0], s91              // WorkGroup0=remainder
s_mul_i32 s91, s91, s[sgprNumWorkGroups1]          // (wg1 % WGM)*NumWorkGroups1
s_add_u32 s91, s91, s[sgprWorkGroup1]              // wgSerial = wg0 + (wg1 % WGM)*NumWorkGroups1
v_cvt_f64_u32 v[0:1], s80                          // s82 = s[sgprNumWorkGroups0] / s80
v_rcp_f64 v[0:1], v[0:1]                           // s82 = s[sgprNumWorkGroups0] / s80
v_cvt_f64_u32 v[2:3], s[sgprNumWorkGroups0]        // s82 = s[sgprNumWorkGroups0] / s80
v_mul_f64 v[0:1], v[0:1], v[2:3]                   // s82 = s[sgprNumWorkGroups0] / s80
v_cvt_u32_f64 v0, v[0:1]                           // s82 = s[sgprNumWorkGroups0] / s80
v_mul_lo_u32 v1, v0, s80                           // s82 = s[sgprNumWorkGroups0] / s80
v_sub_nc_u32 v2, s[sgprNumWorkGroups0], v1         // s82 = s[sgprNumWorkGroups0] / s80
v_cmp_ge_u32 vcc_lo, v2, s80                       // s82 = s[sgprNumWorkGroups0] / s80
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, vcc_lo                          // s82 = s[sgprNumWorkGroups0] / s80
v_add_nc_u32 v0, v0, 1                             // s82 = s[sgprNumWorkGroups0] / s80
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, -1                              // Reset exec
v_readfirstlane_b32 s82, v0                        // quotient
s_mul_i32 s83, s80, s82                            // quotient * non-magic divisor
s_sub_u32 s83, s[sgprNumWorkGroups0], s83          // NumWorkGroups0=remainder
s_cmp_eq_u32 s83, 0                                // remainder == 0 ?
s_cmov_b32 s83, s80                                // remainder = WGM if remainder == 0
s_cmp_ge_u32 s81, s82                              // blockId >= numFullBlocks ?
s_cselect_b32 s82, s83, s80
v_cvt_f64_u32 v[0:1], s82                          // s[sgprWorkGroup1] = s91 / s82
v_rcp_f64 v[0:1], v[0:1]                           // s[sgprWorkGroup1] = s91 / s82
v_cvt_f64_u32 v[2:3], s91                          // s[sgprWorkGroup1] = s91 / s82
v_mul_f64 v[0:1], v[0:1], v[2:3]                   // s[sgprWorkGroup1] = s91 / s82
v_cvt_u32_f64 v0, v[0:1]                           // s[sgprWorkGroup1] = s91 / s82
v_mul_lo_u32 v1, v0, s82                           // s[sgprWorkGroup1] = s91 / s82
v_sub_nc_u32 v2, s91, v1                           // s[sgprWorkGroup1] = s91 / s82
v_cmp_ge_u32 vcc_lo, v2, s82                       // s[sgprWorkGroup1] = s91 / s82
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, vcc_lo                          // s[sgprWorkGroup1] = s91 / s82
v_add_nc_u32 v0, v0, 1                             // s[sgprWorkGroup1] = s91 / s82
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, -1                              // Reset exec
v_mul_lo_u32 v1, v0, s82                           // s[sgprWorkGroup1] = s91 / s82
v_sub_nc_u32 v2, s91, v1                           // s[sgprWorkGroup1] = s91 / s82
v_readfirstlane_b32 s[sgprWorkGroup1], v0          // quotient
v_readfirstlane_b32 s[sgprWorkGroup0], v2          // remainder
s_mul_i32 s[sgprWorkGroup0], s[sgprWorkGroup1], s82 // quotient * non-magic divisor
s_sub_u32 s[sgprWorkGroup0], s91, s[sgprWorkGroup0] // WorkGroup0=remainder
s_mul_i32 s81, s81, s80                            // blockId * WGM
s_add_u32 s[sgprWorkGroup0], s[sgprWorkGroup0], s81 // wg1 += blockId * WGM
s_branch label_WGM
label_WGMPositive:
s_mov_b32 s80, s80                                 // WGM
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cvt_f64_u32 v[0:1], s80                          // s81 = s[sgprWorkGroup1] / s80
v_rcp_f64 v[0:1], v[0:1]                           // s81 = s[sgprWorkGroup1] / s80
v_cvt_f64_u32 v[2:3], s[sgprWorkGroup1]            // s81 = s[sgprWorkGroup1] / s80
v_mul_f64 v[0:1], v[0:1], v[2:3]                   // s81 = s[sgprWorkGroup1] / s80
v_cvt_u32_f64 v0, v[0:1]                           // s81 = s[sgprWorkGroup1] / s80
v_mul_lo_u32 v1, v0, s80                           // s81 = s[sgprWorkGroup1] / s80
v_sub_nc_u32 v2, s[sgprWorkGroup1], v1             // s81 = s[sgprWorkGroup1] / s80
v_cmp_ge_u32 vcc_lo, v2, s80                       // s81 = s[sgprWorkGroup1] / s80
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, vcc_lo                          // s81 = s[sgprWorkGroup1] / s80
v_add_nc_u32 v0, v0, 1                             // s81 = s[sgprWorkGroup1] / s80
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, -1                              // Reset exec
v_readfirstlane_b32 s81, v0                        // quotient
s_mul_i32 s91, s81, s80                            // quotient * non-magic divisor
s_sub_u32 s91, s[sgprWorkGroup1], s91              // WorkGroup1=remainder
s_mul_i32 s91, s91, s[sgprNumWorkGroups0]          // (wg1 % WGM)*NumWorkGroups0
s_add_u32 s91, s91, s[sgprWorkGroup0]              // wgSerial = wg0 + (wg1 % WGM)*NumWorkGroups0
v_cvt_f64_u32 v[0:1], s80                          // s82 = s[sgprNumWorkGroups1] / s80
v_rcp_f64 v[0:1], v[0:1]                           // s82 = s[sgprNumWorkGroups1] / s80
v_cvt_f64_u32 v[2:3], s[sgprNumWorkGroups1]        // s82 = s[sgprNumWorkGroups1] / s80
v_mul_f64 v[0:1], v[0:1], v[2:3]                   // s82 = s[sgprNumWorkGroups1] / s80
v_cvt_u32_f64 v0, v[0:1]                           // s82 = s[sgprNumWorkGroups1] / s80
v_mul_lo_u32 v1, v0, s80                           // s82 = s[sgprNumWorkGroups1] / s80
v_sub_nc_u32 v2, s[sgprNumWorkGroups1], v1         // s82 = s[sgprNumWorkGroups1] / s80
v_cmp_ge_u32 vcc_lo, v2, s80                       // s82 = s[sgprNumWorkGroups1] / s80
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, vcc_lo                          // s82 = s[sgprNumWorkGroups1] / s80
v_add_nc_u32 v0, v0, 1                             // s82 = s[sgprNumWorkGroups1] / s80
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, -1                              // Reset exec
v_readfirstlane_b32 s82, v0                        // quotient
s_mul_i32 s83, s80, s82                            // quotient * non-magic divisor
s_sub_u32 s83, s[sgprNumWorkGroups1], s83          // NumWorkGroups1=remainder
s_cmp_eq_u32 s83, 0                                // remainder == 0 ?
s_cmov_b32 s83, s80                                // remainder = WGM if remainder == 0
s_cmp_ge_u32 s81, s82                              // blockId >= numFullBlocks ?
s_cselect_b32 s82, s83, s80
v_cvt_f64_u32 v[0:1], s82                          // s[sgprWorkGroup0] = s91 / s82
v_rcp_f64 v[0:1], v[0:1]                           // s[sgprWorkGroup0] = s91 / s82
v_cvt_f64_u32 v[2:3], s91                          // s[sgprWorkGroup0] = s91 / s82
v_mul_f64 v[0:1], v[0:1], v[2:3]                   // s[sgprWorkGroup0] = s91 / s82
v_cvt_u32_f64 v0, v[0:1]                           // s[sgprWorkGroup0] = s91 / s82
v_mul_lo_u32 v1, v0, s82                           // s[sgprWorkGroup0] = s91 / s82
v_sub_nc_u32 v2, s91, v1                           // s[sgprWorkGroup0] = s91 / s82
v_cmp_ge_u32 vcc_lo, v2, s82                       // s[sgprWorkGroup0] = s91 / s82
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, vcc_lo                          // s[sgprWorkGroup0] = s91 / s82
v_add_nc_u32 v0, v0, 1                             // s[sgprWorkGroup0] = s91 / s82
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, -1                              // Reset exec
v_mul_lo_u32 v1, v0, s82                           // s[sgprWorkGroup0] = s91 / s82
v_sub_nc_u32 v2, s91, v1                           // s[sgprWorkGroup0] = s91 / s82
v_readfirstlane_b32 s[sgprWorkGroup0], v0          // quotient
v_readfirstlane_b32 s[sgprWorkGroup1], v2          // remainder
s_mul_i32 s[sgprWorkGroup1], s[sgprWorkGroup0], s82 // quotient * non-magic divisor
s_sub_u32 s[sgprWorkGroup1], s91, s[sgprWorkGroup1] // WorkGroup1=remainder
s_mul_i32 s81, s81, s80                            // blockId * WGM
s_add_u32 s[sgprWorkGroup1], s[sgprWorkGroup1], s81 // wg1 += blockId * WGM
label_WGM:
label_TDMInitA:
s_bitcmp1_b32 s[sgprWaveIdx], 0                    // Check parity of wId
s_cbranch_scc1 label_TDMInitB                      // Jump to B if wId is odd
s_mov_b32 s[sgprtdmAGroup0+0], 1
s_mov_b32 s[sgprtdmAGroup0+1], 0
s_mov_b32 s[sgprtdmAGroup0+2], 0
s_mov_b32 s[sgprtdmAGroup0+3], 0
s_or_b32 s[sgprtdmAGroup0+3], s[sgprtdmAGroup0+3], 0x80000000 // set type field to 2(image)
s_mov_b32 s[sgprtdmAGroup1+0], 0
s_mov_b32 s[sgprtdmAGroup1+1], 0
s_mov_b32 s[sgprtdmAGroup1+2], 0
s_mov_b32 s[sgprtdmAGroup1+3], 0
s_mov_b32 s[sgprtdmAGroup1+4], 0
s_mov_b32 s[sgprtdmAGroup1+5], 0
s_mov_b32 s[sgprtdmAGroup1+6], 0
s_mov_b32 s[sgprtdmAGroup1+7], 0
s_mov_b32 s[sgprtdmAGroup2+0], 0
s_mov_b32 s[sgprtdmAGroup2+1], 0
s_mov_b32 s[sgprtdmAGroup2+2], 0
s_mov_b32 s[sgprtdmAGroup2+3], 0
s_and_b32 s[sgprtdmAGroup1], s[sgprtdmAGroup1], 0xfffcffff // Reset data_size
s_or_b32 s[sgprtdmAGroup1], s[sgprtdmAGroup1], 0x0 // Set data_size to 0
// TDM set global addr
s_mov_b64 s[sgprtdmAGroup0+2:sgprtdmAGroup0+2+1], s[sgprAddressA:sgprAddressA+1]
s_or_b32 s[sgprtdmAGroup0+3], s[sgprtdmAGroup0+3], 0x80000000 // set type field to 2(image)
s_lshr_b32 s92, s[sgprWaveIdx], 1                  // wId=WaveIdx // 2 (each component covers 2 waves: numComp = numWaves // 2)
s_mul_i32 s92, s92, 8192                           // woffset = wId * (mt // numComp * du * bpe // dim1Divisor)
s_lshr_b32 s93, s92, 8                             // numPadBlocks = woffset >> log2(ldsBlockSizePerPad=256)
s_mul_i32 s93, s93, 16                             // padBytes = numPadBlocks * (ldsPadSize=16)
s_add_u32 s92, s92, s93                            // woffset += padBytes
s_add_u32 s92, s92, 0                              // ldsOffset = woffset + ldsConstOffset
// TDM set LDS addr
s_mov_b32 s[sgprtdmAGroup0+1], s92
s_mul_i32 s91, 128, s[sgprWorkGroup0]
s_sub_i32 s91, s[sgprSizeI], s91
s_and_b32 s[sgprtdmAGroup1], s[sgprtdmAGroup1], 0xfff7ffff // clear iterate_enable (D# Group 1 bit 19)
// TDM set tensor dim 0
s_and_b32 s[sgprtdmAGroup1+1], s[sgprtdmAGroup1+1], 0xffff
s_and_b32 s[sgprtdmAGroup1+2], s[sgprtdmAGroup1+2], 0xffff0000
s_lshr_b32 s92, s[sgprSizeL], 0x1
s_lshl_b32 s92, s92, 0x10
s_or_b32 s[sgprtdmAGroup1+1], s[sgprtdmAGroup1+1], s92
s_lshr_b32 s92, s[sgprSizeL], 0x1
s_lshr_b32 s92, s92, 0x10
s_or_b32 s[sgprtdmAGroup1+2], s[sgprtdmAGroup1+2], s92
s_set_vgpr_msb 1                                   // src0: 1, src1: 0, src2: 0, dst: 0
v_readfirstlane_b32 s92, v[vgprSerial-256]         // first tId
s_lshr_b32 s92, s92, 6                             // wId=fTid // wavelen // 2
s_mul_i32 s92, s92, 64                             // woffset = wId * (mt // numComp // dim1Divisor)
s_sub_u32 s91, s91, s92                            // consider multiple waves
s_cmov_b32 s91, 0                                  // set to 0 for waves that no enough data to load
// TDM set tensor dim 1
s_and_b32 s[sgprtdmAGroup1+2], s[sgprtdmAGroup1+2], 0xffff
s_and_b32 s[sgprtdmAGroup1+3], s[sgprtdmAGroup1+3], 0xffff0000
s_lshl_b32 s93, s91, 0x10
s_or_b32 s[sgprtdmAGroup1+2], s[sgprtdmAGroup1+2], s93
s_lshr_b32 s93, s91, 0x10
s_or_b32 s[sgprtdmAGroup1+3], s[sgprtdmAGroup1+3], s93
// TDM set tensor tile 0
s_and_b32 s[sgprtdmAGroup1+3], s[sgprtdmAGroup1+3], 0xffff
s_or_b32 s[sgprtdmAGroup1+3], s[sgprtdmAGroup1+3], 0x800000 // set tile0 to 128
// TDM set tensor tile 1
s_and_b32 s[sgprtdmAGroup1+4], s[sgprtdmAGroup1+4], 0xffff0000
s_or_b32 s[sgprtdmAGroup1+4], s[sgprtdmAGroup1+4], 0x2 // set tile1 to 2
s_lshr_b32 s[sgprtdmAGroup1+5], s[sgprStrideA0I], 0x1
s_mul_i32 s93, s[sgprStrideA0I], 2                 // TDM iter global_inc = strideN * tile_dim1(2)
s_lshr_b32 s93, s93, 1                             // fp4 sub-byte: bytes = elements / 2
s_or_b32 s[sgprtdmAGroup1], s[sgprtdmAGroup1], 0x80000 // set iterate_enable (D# Group 1 bit 19)
s_mov_b32 s[sgprtdmAGroup2+1], 0x110               // set lds increment to 272
s_mov_b32 s[sgprtdmAGroup2+2], s93
s_mov_b32 s92, 0x1f                                // TDM iter_count = rows_per_il(64) / tile_dim1(2) - 1
s_mov_b32 s[sgprtdmAGroup2+3], s92
s_lshl_b32 s[sgprtdmAGroup2+3], s[sgprtdmAGroup2+3], 0x10
s_branch label_TDMInitABEnd
label_TDMInitB:
s_mov_b32 s[sgprtdmBGroup0+0], 1
s_mov_b32 s[sgprtdmBGroup0+1], 0
s_mov_b32 s[sgprtdmBGroup0+2], 0
s_mov_b32 s[sgprtdmBGroup0+3], 0
s_or_b32 s[sgprtdmBGroup0+3], s[sgprtdmBGroup0+3], 0x80000000 // set type field to 2(image)
s_mov_b32 s[sgprtdmBGroup1+0], 0
s_mov_b32 s[sgprtdmBGroup1+1], 0
s_mov_b32 s[sgprtdmBGroup1+2], 0
s_mov_b32 s[sgprtdmBGroup1+3], 0
s_mov_b32 s[sgprtdmBGroup1+4], 0
s_mov_b32 s[sgprtdmBGroup1+5], 0
s_mov_b32 s[sgprtdmBGroup1+6], 0
s_mov_b32 s[sgprtdmBGroup1+7], 0
s_mov_b32 s[sgprtdmBGroup2+0], 0
s_mov_b32 s[sgprtdmBGroup2+1], 0
s_mov_b32 s[sgprtdmBGroup2+2], 0
s_mov_b32 s[sgprtdmBGroup2+3], 0
s_and_b32 s[sgprtdmBGroup1], s[sgprtdmBGroup1], 0xfffcffff // Reset data_size
s_or_b32 s[sgprtdmBGroup1], s[sgprtdmBGroup1], 0x0 // Set data_size to 0
// TDM set global addr
s_mov_b64 s[sgprtdmBGroup0+2:sgprtdmBGroup0+2+1], s[sgprAddressB:sgprAddressB+1]
s_or_b32 s[sgprtdmBGroup0+3], s[sgprtdmBGroup0+3], 0x80000000 // set type field to 2(image)
s_lshr_b32 s92, s[sgprWaveIdx], 1                  // wId=WaveIdx // 2 (each component covers 2 waves: numComp = numWaves // 2)
s_mul_i32 s92, s92, 8192                           // woffset = wId * (mt // numComp * du * bpe // dim1Divisor)
s_lshr_b32 s93, s92, 9                             // numPadBlocks = woffset >> log2(ldsBlockSizePerPad=512)
s_mul_i32 s93, s93, 16                             // padBytes = numPadBlocks * (ldsPadSize=16)
s_add_u32 s92, s92, s93                            // woffset += padBytes
s_add_u32 s92, s92, 19456                          // ldsOffset = woffset + ldsConstOffset
// TDM set LDS addr
s_mov_b32 s[sgprtdmBGroup0+1], s92
s_mul_i32 s91, 128, s[sgprWorkGroup1]
s_sub_i32 s91, s[sgprSizeJ], s91
s_and_b32 s[sgprtdmBGroup1], s[sgprtdmBGroup1], 0xfff7ffff // clear iterate_enable (D# Group 1 bit 19)
// TDM set tensor dim 0
s_and_b32 s[sgprtdmBGroup1+1], s[sgprtdmBGroup1+1], 0xffff
s_and_b32 s[sgprtdmBGroup1+2], s[sgprtdmBGroup1+2], 0xffff0000
s_lshr_b32 s92, s[sgprSizeL], 0x1
s_lshl_b32 s92, s92, 0x10
s_or_b32 s[sgprtdmBGroup1+1], s[sgprtdmBGroup1+1], s92
s_lshr_b32 s92, s[sgprSizeL], 0x1
s_lshr_b32 s92, s92, 0x10
s_or_b32 s[sgprtdmBGroup1+2], s[sgprtdmBGroup1+2], s92
s_set_vgpr_msb 1                                   // src0: 1, src1: 0, src2: 0, dst: 0
v_readfirstlane_b32 s92, v[vgprSerial-256]         // first tId
s_lshr_b32 s92, s92, 6                             // wId=fTid // wavelen // 2
s_mul_i32 s92, s92, 64                             // woffset = wId * (mt // numComp // dim1Divisor)
s_sub_u32 s91, s91, s92                            // consider multiple waves
s_cmov_b32 s91, 0                                  // set to 0 for waves that no enough data to load
// TDM set tensor dim 1
s_and_b32 s[sgprtdmBGroup1+2], s[sgprtdmBGroup1+2], 0xffff
s_and_b32 s[sgprtdmBGroup1+3], s[sgprtdmBGroup1+3], 0xffff0000
s_lshl_b32 s93, s91, 0x10
s_or_b32 s[sgprtdmBGroup1+2], s[sgprtdmBGroup1+2], s93
s_lshr_b32 s93, s91, 0x10
s_or_b32 s[sgprtdmBGroup1+3], s[sgprtdmBGroup1+3], s93
// TDM set tensor tile 0
s_and_b32 s[sgprtdmBGroup1+3], s[sgprtdmBGroup1+3], 0xffff
s_or_b32 s[sgprtdmBGroup1+3], s[sgprtdmBGroup1+3], 0x800000 // set tile0 to 128
// TDM set tensor tile 1
s_and_b32 s[sgprtdmBGroup1+4], s[sgprtdmBGroup1+4], 0xffff0000
s_or_b32 s[sgprtdmBGroup1+4], s[sgprtdmBGroup1+4], 0x4 // set tile1 to 4
s_lshr_b32 s[sgprtdmBGroup1+5], s[sgprStrideB1J], 0x1
s_mul_i32 s93, s[sgprStrideB1J], 4                 // TDM iter global_inc = strideN * tile_dim1(4)
s_lshr_b32 s93, s93, 1                             // fp4 sub-byte: bytes = elements / 2
s_or_b32 s[sgprtdmBGroup1], s[sgprtdmBGroup1], 0x80000 // set iterate_enable (D# Group 1 bit 19)
s_mov_b32 s[sgprtdmBGroup2+1], 0x210               // set lds increment to 528
s_mov_b32 s[sgprtdmBGroup2+2], s93
s_mov_b32 s92, 0xf                                 // TDM iter_count = rows_per_il(64) / tile_dim1(4) - 1
s_mov_b32 s[sgprtdmBGroup2+3], s92
s_lshl_b32 s[sgprtdmBGroup2+3], s[sgprtdmBGroup2+3], 0x10
label_TDMInitABEnd:
label_TDMInitMXSA:
s_bitcmp1_b32 s[sgprWaveIdx], 0                    // Check parity of wId
s_cbranch_scc1 label_TDMInitMXSB                   // Jump to B if wId is odd
s_mov_b32 s[sgprtdmMXSAGroup0+0], 1
s_mov_b32 s[sgprtdmMXSAGroup0+1], 0
s_mov_b32 s[sgprtdmMXSAGroup0+2], 0
s_mov_b32 s[sgprtdmMXSAGroup0+3], 0
s_or_b32 s[sgprtdmMXSAGroup0+3], s[sgprtdmMXSAGroup0+3], 0x80000000 // set type field to 2(image)
s_mov_b32 s[sgprtdmMXSAGroup1+0], 0
s_mov_b32 s[sgprtdmMXSAGroup1+1], 0
s_mov_b32 s[sgprtdmMXSAGroup1+2], 0
s_mov_b32 s[sgprtdmMXSAGroup1+3], 0
s_mov_b32 s[sgprtdmMXSAGroup1+4], 0
s_mov_b32 s[sgprtdmMXSAGroup1+5], 0
s_mov_b32 s[sgprtdmMXSAGroup1+6], 0
s_mov_b32 s[sgprtdmMXSAGroup1+7], 0
s_and_b32 s[sgprtdmMXSAGroup1], s[sgprtdmMXSAGroup1], 0xfffcffff // Reset data_size
s_or_b32 s[sgprtdmMXSAGroup1], s[sgprtdmMXSAGroup1], 0x0 // Set data_size to 0
// TDM set global addr
s_mov_b64 s[sgprtdmMXSAGroup0+2:sgprtdmMXSAGroup0+2+1], s[sgprAddressMXSA:sgprAddressMXSA+1]
s_or_b32 s[sgprtdmMXSAGroup0+3], s[sgprtdmMXSAGroup0+3], 0x80000000 // set type field to 2(image)
s_lshr_b32 s92, s[sgprWaveIdx], 1                  // wId=WaveIdx // 2 (each component covers 2 waves: numComp = numWaves // 2)
s_mul_i32 s92, s92, 512                            // woffset = wId * (mt // numComp * du * bpe // dim1Divisor)
s_add_u32 s92, s92, 17408                          // ldsOffset = woffset + ldsConstOffset
// TDM set LDS addr
s_mov_b32 s[sgprtdmMXSAGroup0+1], s92
s_mul_i32 s91, 128, s[sgprWorkGroup0]
s_sub_i32 s91, s[sgprSizeI], s91
s_and_b32 s[sgprtdmMXSAGroup1], s[sgprtdmMXSAGroup1], 0xfff7ffff // clear iterate_enable (D# Group 1 bit 19)
// TDM set tensor dim 0
s_and_b32 s[sgprtdmMXSAGroup1+1], s[sgprtdmMXSAGroup1+1], 0xffff
s_and_b32 s[sgprtdmMXSAGroup1+2], s[sgprtdmMXSAGroup1+2], 0xffff0000
s_lshl_b32 s93, s91, 0x2
s_lshl_b32 s93, s93, 0x10
s_or_b32 s[sgprtdmMXSAGroup1+1], s[sgprtdmMXSAGroup1+1], s93
s_lshl_b32 s93, s91, 0x2
s_lshr_b32 s93, s93, 0x10
s_or_b32 s[sgprtdmMXSAGroup1+2], s[sgprtdmMXSAGroup1+2], s93
// TDM set tensor dim 1
s_and_b32 s[sgprtdmMXSAGroup1+2], s[sgprtdmMXSAGroup1+2], 0xffff
s_and_b32 s[sgprtdmMXSAGroup1+3], s[sgprtdmMXSAGroup1+3], 0xffff0000
s_add_u32 s93, s[sgprSizeL], 127
s_lshr_b32 s93, s93, 0x7
s_lshl_b32 s93, s93, 0x10
s_or_b32 s[sgprtdmMXSAGroup1+2], s[sgprtdmMXSAGroup1+2], s93
s_lshr_b32 s93, s[sgprSizeL], 0x7
s_lshr_b32 s93, s93, 0x10
s_or_b32 s[sgprtdmMXSAGroup1+3], s[sgprtdmMXSAGroup1+3], s93
// TDM set tensor tile 0
s_and_b32 s[sgprtdmMXSAGroup1+3], s[sgprtdmMXSAGroup1+3], 0xffff
s_or_b32 s[sgprtdmMXSAGroup1+3], s[sgprtdmMXSAGroup1+3], 0x2000000 // set tile0 to 512
// TDM set tensor tile 1
s_and_b32 s[sgprtdmMXSAGroup1+4], s[sgprtdmMXSAGroup1+4], 0xffff0000
s_or_b32 s[sgprtdmMXSAGroup1+4], s[sgprtdmMXSAGroup1+4], 0x1 // set tile1 to 1
s_lshl_b32 s[sgprtdmMXSAGroup1+5], s[sgprSizeI], 0x2
s_branch label_TDMInitMXSAMXSBEnd
label_TDMInitMXSB:
s_mov_b32 s[sgprtdmMXSBGroup0+0], 1
s_mov_b32 s[sgprtdmMXSBGroup0+1], 0
s_mov_b32 s[sgprtdmMXSBGroup0+2], 0
s_mov_b32 s[sgprtdmMXSBGroup0+3], 0
s_or_b32 s[sgprtdmMXSBGroup0+3], s[sgprtdmMXSBGroup0+3], 0x80000000 // set type field to 2(image)
s_mov_b32 s[sgprtdmMXSBGroup1+0], 0
s_mov_b32 s[sgprtdmMXSBGroup1+1], 0
s_mov_b32 s[sgprtdmMXSBGroup1+2], 0
s_mov_b32 s[sgprtdmMXSBGroup1+3], 0
s_mov_b32 s[sgprtdmMXSBGroup1+4], 0
s_mov_b32 s[sgprtdmMXSBGroup1+5], 0
s_mov_b32 s[sgprtdmMXSBGroup1+6], 0
s_mov_b32 s[sgprtdmMXSBGroup1+7], 0
s_and_b32 s[sgprtdmMXSBGroup1], s[sgprtdmMXSBGroup1], 0xfffcffff // Reset data_size
s_or_b32 s[sgprtdmMXSBGroup1], s[sgprtdmMXSBGroup1], 0x0 // Set data_size to 0
// TDM set global addr
s_mov_b64 s[sgprtdmMXSBGroup0+2:sgprtdmMXSBGroup0+2+1], s[sgprAddressMXSB:sgprAddressMXSB+1]
s_or_b32 s[sgprtdmMXSBGroup0+3], s[sgprtdmMXSBGroup0+3], 0x80000000 // set type field to 2(image)
s_lshr_b32 s92, s[sgprWaveIdx], 1                  // wId=WaveIdx // 2 (each component covers 2 waves: numComp = numWaves // 2)
s_mul_i32 s92, s92, 512                            // woffset = wId * (mt // numComp * du * bpe // dim1Divisor)
s_add_u32 s92, s92, 18432                          // ldsOffset = woffset + ldsConstOffset
// TDM set LDS addr
s_mov_b32 s[sgprtdmMXSBGroup0+1], s92
s_mul_i32 s91, 128, s[sgprWorkGroup1]
s_sub_i32 s91, s[sgprSizeJ], s91
s_and_b32 s[sgprtdmMXSBGroup1], s[sgprtdmMXSBGroup1], 0xfff7ffff // clear iterate_enable (D# Group 1 bit 19)
// TDM set tensor dim 0
s_and_b32 s[sgprtdmMXSBGroup1+1], s[sgprtdmMXSBGroup1+1], 0xffff
s_and_b32 s[sgprtdmMXSBGroup1+2], s[sgprtdmMXSBGroup1+2], 0xffff0000
s_lshl_b32 s93, s91, 0x2
s_lshl_b32 s93, s93, 0x10
s_or_b32 s[sgprtdmMXSBGroup1+1], s[sgprtdmMXSBGroup1+1], s93
s_lshl_b32 s93, s91, 0x2
s_lshr_b32 s93, s93, 0x10
s_or_b32 s[sgprtdmMXSBGroup1+2], s[sgprtdmMXSBGroup1+2], s93
// TDM set tensor dim 1
s_and_b32 s[sgprtdmMXSBGroup1+2], s[sgprtdmMXSBGroup1+2], 0xffff
s_and_b32 s[sgprtdmMXSBGroup1+3], s[sgprtdmMXSBGroup1+3], 0xffff0000
s_add_u32 s93, s[sgprSizeL], 127
s_lshr_b32 s93, s93, 0x7
s_lshl_b32 s93, s93, 0x10
s_or_b32 s[sgprtdmMXSBGroup1+2], s[sgprtdmMXSBGroup1+2], s93
s_lshr_b32 s93, s[sgprSizeL], 0x7
s_lshr_b32 s93, s93, 0x10
s_or_b32 s[sgprtdmMXSBGroup1+3], s[sgprtdmMXSBGroup1+3], s93
// TDM set tensor tile 0
s_and_b32 s[sgprtdmMXSBGroup1+3], s[sgprtdmMXSBGroup1+3], 0xffff
s_or_b32 s[sgprtdmMXSBGroup1+3], s[sgprtdmMXSBGroup1+3], 0x2000000 // set tile0 to 512
// TDM set tensor tile 1
s_and_b32 s[sgprtdmMXSBGroup1+4], s[sgprtdmMXSBGroup1+4], 0xffff0000
s_or_b32 s[sgprtdmMXSBGroup1+4], s[sgprtdmMXSBGroup1+4], 0x1 // set tile1 to 1
s_lshl_b32 s[sgprtdmMXSBGroup1+5], s[sgprSizeJ], 0x2
label_TDMInitMXSAMXSBEnd:
label_TDMGlobalOffsetA:
s_bitcmp1_b32 s[sgprWaveIdx], 0                    // Check parity of wId
s_cbranch_scc1 label_TDMGlobalOffsetB              // Jump to B if wId is odd
// TDM wave separated calc start addr of A
s_mov_b64 s[92:93], 0
s_mul_i32 s92, s[sgprStrideA0I], 64                // tileStride * MT(128) * bpe(0.5)
s_mul_hi_u32 s93, s92, s[sgprWorkGroup0]           // *= wgId
s_mul_i32 s92, s92, s[sgprWorkGroup0]              // *= wgId
s_lshr_b32 s94, s[sgprWaveIdx], 1                  // wCompId = fTid // wavelen(32) // 2)
s_mul_i32 s94, s94, 32                             // woffset = wCompId * mt // numComp(2) * bpe(0.5) // tdmSplit(1)
s_mul_i32 s94, s94, s[sgprStrideA0I]               // woffset *= tdmSeparateStride
s_add_u32 s92, s92, s94                            // += woffset
s_addc_u32 s93, s93, 0                             // += woffset carry
s_mul_i32 s94, s[sgprGSUSumIdx], 128               // gsuOffset = GSUSumIdx * DepthU(256) * bpe(0.5)
s_add_u32 s92, s92, s94                            // += gsuOffset
s_add_u32 s[sgprtdmAGroup0+2], s[sgprtdmAGroup0+2], s92 // += tileOffset(lo)
s_addc_u32 s[sgprtdmAGroup0+3], s[sgprtdmAGroup0+3], s93 // += tileOffset(hi)
s_mul_hi_u32 s93, s[sgprStrideAK], s[sgprWorkGroup2] // Batch: Stride*WG
s_mul_i32 s92, s[sgprStrideAK], s[sgprWorkGroup2]  // Batch: Stride*WG
s_lshr_b64 s[92:93], s[92:93], 1                   // scale by bpe (multiple bpe)
s_add_u32 s[sgprtdmAGroup0+2], s[sgprtdmAGroup0+2], s92 // += batchOffset(lo)
s_addc_u32 s[sgprtdmAGroup0+3], s[sgprtdmAGroup0+3], s93 // += batchOffset(hi)
s_branch label_TDMGlobalOffsetABEnd
label_TDMGlobalOffsetB:
// TDM wave separated calc start addr of B
s_mov_b64 s[92:93], 0
s_mul_i32 s92, s[sgprStrideB1J], 64                // tileStride * MT(128) * bpe(0.5)
s_mul_hi_u32 s93, s92, s[sgprWorkGroup1]           // *= wgId
s_mul_i32 s92, s92, s[sgprWorkGroup1]              // *= wgId
s_lshr_b32 s94, s[sgprWaveIdx], 1                  // wCompId = fTid // wavelen(32) // 2)
s_mul_i32 s94, s94, 32                             // woffset = wCompId * mt // numComp(2) * bpe(0.5) // tdmSplit(1)
s_mul_i32 s94, s94, s[sgprStrideB1J]               // woffset *= tdmSeparateStride
s_add_u32 s92, s92, s94                            // += woffset
s_addc_u32 s93, s93, 0                             // += woffset carry
s_mul_i32 s94, s[sgprGSUSumIdx], 128               // gsuOffset = GSUSumIdx * DepthU(256) * bpe(0.5)
s_add_u32 s92, s92, s94                            // += gsuOffset
s_add_u32 s[sgprtdmBGroup0+2], s[sgprtdmBGroup0+2], s92 // += tileOffset(lo)
s_addc_u32 s[sgprtdmBGroup0+3], s[sgprtdmBGroup0+3], s93 // += tileOffset(hi)
s_mul_hi_u32 s93, s[sgprStrideBK], s[sgprWorkGroup2] // Batch: Stride*WG
s_mul_i32 s92, s[sgprStrideBK], s[sgprWorkGroup2]  // Batch: Stride*WG
s_lshr_b64 s[92:93], s[92:93], 1                   // scale by bpe (multiple bpe)
s_add_u32 s[sgprtdmBGroup0+2], s[sgprtdmBGroup0+2], s92 // += batchOffset(lo)
s_addc_u32 s[sgprtdmBGroup0+3], s[sgprtdmBGroup0+3], s93 // += batchOffset(hi)
label_TDMGlobalOffsetABEnd:
label_TDMGlobalOffsetMXSA:
s_bitcmp1_b32 s[sgprWaveIdx], 0                    // Check parity of wId
s_cbranch_scc1 label_TDMGlobalOffsetMXSB           // Jump to B if wId is odd
// TDM wave separated calc start addr of MXSA
s_mov_b64 s[92:93], 0
s_mul_i32 s92, s[sgprWorkGroup0], 512              // wgId * mxUnit(4) * MT(128) * bpe(1)
s_lshr_b32 s94, s[sgprWaveIdx], 1                  // wCompId = fTid // wavelen(32) // 2)
s_mul_i32 s94, s94, 4                              // woffset = wCompId * mxUnit(4) * numMxKGroups(2) // numComp(2)
s_mul_i32 s94, s94, s[sgprSizeI]                   // woffset *= SizeI
s_add_u32 s92, s92, s94                            // += woffset
s_addc_u32 s93, s93, 0                             // += woffset carry
s_mul_i32 s94, s[sgprGSUSumIdx], 8                 // gsuOffset = GSUSumIdx * DepthU(8) * bpe(1)
s_mul_i32 s94, s94, s[sgprSizeI]                   // MXS: scale GSU offset by tile size SizeI
s_add_u32 s92, s92, s94                            // += gsuOffset
s_add_u32 s[sgprtdmMXSAGroup0+2], s[sgprtdmMXSAGroup0+2], s92 // += tileOffset(lo)
s_addc_u32 s[sgprtdmMXSAGroup0+3], s[sgprtdmMXSAGroup0+3], s93 // += tileOffset(hi)
s_mul_hi_u32 s93, s[sgprStrideMXSAK], s[sgprWorkGroup2] // Batch: Stride*WG
s_mul_i32 s92, s[sgprStrideMXSAK], s[sgprWorkGroup2] // Batch: Stride*WG
                                                   // scale by bpe (bpe is 1, do nothing)
s_add_u32 s[sgprtdmMXSAGroup0+2], s[sgprtdmMXSAGroup0+2], s92 // += batchOffset(lo)
s_addc_u32 s[sgprtdmMXSAGroup0+3], s[sgprtdmMXSAGroup0+3], s93 // += batchOffset(hi)
s_branch label_TDMGlobalOffsetMXSAMXSBEnd
label_TDMGlobalOffsetMXSB:
// TDM wave separated calc start addr of MXSB
s_mov_b64 s[92:93], 0
s_mul_i32 s92, s[sgprWorkGroup1], 512              // wgId * mxUnit(4) * MT(128) * bpe(1)
s_lshr_b32 s94, s[sgprWaveIdx], 1                  // wCompId = fTid // wavelen(32) // 2)
s_mul_i32 s94, s94, 4                              // woffset = wCompId * mxUnit(4) * numMxKGroups(2) // numComp(2)
s_mul_i32 s94, s94, s[sgprSizeJ]                   // woffset *= SizeJ
s_add_u32 s92, s92, s94                            // += woffset
s_addc_u32 s93, s93, 0                             // += woffset carry
s_mul_i32 s94, s[sgprGSUSumIdx], 8                 // gsuOffset = GSUSumIdx * DepthU(8) * bpe(1)
s_mul_i32 s94, s94, s[sgprSizeJ]                   // MXS: scale GSU offset by tile size SizeJ
s_add_u32 s92, s92, s94                            // += gsuOffset
s_add_u32 s[sgprtdmMXSBGroup0+2], s[sgprtdmMXSBGroup0+2], s92 // += tileOffset(lo)
s_addc_u32 s[sgprtdmMXSBGroup0+3], s[sgprtdmMXSBGroup0+3], s93 // += tileOffset(hi)
s_mul_hi_u32 s93, s[sgprStrideMXSBK], s[sgprWorkGroup2] // Batch: Stride*WG
s_mul_i32 s92, s[sgprStrideMXSBK], s[sgprWorkGroup2] // Batch: Stride*WG
                                                   // scale by bpe (bpe is 1, do nothing)
s_add_u32 s[sgprtdmMXSBGroup0+2], s[sgprtdmMXSBGroup0+2], s92 // += batchOffset(lo)
s_addc_u32 s[sgprtdmMXSBGroup0+3], s[sgprtdmMXSBGroup0+3], s93 // += batchOffset(hi)
label_TDMGlobalOffsetMXSAMXSBEnd:

/* global read addresses: tile offsets mxsa */

/* global read addresses: tile offsets mxsb */

/* global read addresses: unroll offsets mxsa */

/* global read addresses: unroll offsets mxsb */

/* global read addresses: increments a */
s_and_b32 s93, s[sgprGSU], 0x3fff                  // Restore GSU
s_mov_b32 s[sgprGlobalReadIncsA+0], 128            // GSU*DepthU*Bpe*MI_dim(1)
s_mul_i32 s93, s93, s[sgprGlobalReadIncsA+0]       // GSU*DepthU*Bpe*MI_dim(1)
s_and_b32 s92, s[sgprGSU], 0x8000                  // SCC = (GSUC == 1) ?
s_cselect_b32 s[sgprGlobalReadIncsA+0], s[sgprGlobalReadIncsA+0], s93 // incrA (unrollIdx)

/* global read addresses: increments mxsa */
s_and_b32 s93, s[sgprGSU], 0x3fff                  // Restore GSU
s_mul_i32 s[sgprGlobalReadIncsMXSA+0], s[sgprSizeI], 8 // GSU*DepthU*Bpe*MI_dim(1) (swizzled MX scale layout)
s_mul_i32 s93, s93, s[sgprGlobalReadIncsMXSA+0]    // GSU*DepthU*Bpe*MI_dim(1)
s_and_b32 s92, s[sgprGSU], 0x8000                  // SCC = (GSUC == 1) ?
s_cselect_b32 s[sgprGlobalReadIncsMXSA+0], s[sgprGlobalReadIncsMXSA+0], s93 // incrMXSA (unrollIdx)

/* global read addresses: increments mxsb */
s_and_b32 s93, s[sgprGSU], 0x3fff                  // Restore GSU
s_mul_i32 s[sgprGlobalReadIncsMXSB+0], s[sgprSizeJ], 8 // GSU*DepthU*Bpe*MI_dim(1) (swizzled MX scale layout)
s_mul_i32 s93, s93, s[sgprGlobalReadIncsMXSB+0]    // GSU*DepthU*Bpe*MI_dim(1)
s_and_b32 s92, s[sgprGSU], 0x8000                  // SCC = (GSUC == 1) ?
s_cselect_b32 s[sgprGlobalReadIncsMXSB+0], s[sgprGlobalReadIncsMXSB+0], s93 // incrMXSB (unrollIdx)

/* global read addresses: increments b */
s_and_b32 s93, s[sgprGSU], 0x3fff                  // Restore GSU
s_mov_b32 s[sgprGlobalReadIncsB+0], 128            // GSU*DepthU*Bpe*MI_dim(1)
s_mul_i32 s93, s93, s[sgprGlobalReadIncsB+0]       // GSU*DepthU*Bpe*MI_dim(1)
s_and_b32 s92, s[sgprGSU], 0x8000                  // SCC = (GSUC == 1) ?
s_cselect_b32 s[sgprGlobalReadIncsB+0], s[sgprGlobalReadIncsB+0], s93 // incrB (unrollIdx)
s_bitcmp1_b32 s[sgprWaveIdx], 0                    // Check parity of wId
s_cselect_b32 s[sgprtdmABIncs], s[sgprGlobalReadIncsB+0], s[sgprGlobalReadIncsA+0]
s_bitcmp1_b32 s[sgprWaveIdx], 0                    // Check parity of wId
s_cselect_b32 s[sgprtdmMXSAMXSBIncs], s[sgprGlobalReadIncsMXSB+0], s[sgprGlobalReadIncsMXSA+0]
/* declare loop num iterations */
s_lshr_b32 s[sgprLoopCounterL], s[sgprSizesSum+0], 8 // s[sgprLoopCounterL] = s[sgprSizesSum+0] / 256
s_and_b32 s92, s[sgprGSU], 0x3fff                  // Restore GSU
s_cmp_eq_u32 s92, 1                                // GSU == 1 ?
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
s_add_u32 s92, 1, s[sgprLoopCounterL]              // tmp<-numIterMyWg+1
s_cmp_lt_u32 s[sgprGSUSumIdx], s[sgprGSUSumIdx+1]  // gsuSumIdx < numIterPerWgRemainder
s_cmov_b32 s[sgprLoopCounterL], s92                // numIterMyWg++ if needed
label_GSU_1:
s_mov_b32 s[sgprOrigLoopCounter], s[sgprLoopCounterL] // copy loop counter
s_cmp_le_u32 s[sgprLoopCounterL], 0x2              // LoopCounterL < EndCounter
s_cbranch_scc0 label_skipInitCVmov                 // skip v_mov initC (WMMA initC will run in main loop)

/* initC: remove ValuMXSA/B vgpr buffer [0...14) from pool */

/* initC: remove ValuC vgpr buffer [14...142) from pool */

/* initC: remove acc vgpr buffer [0...0) from pool */

/* initC: remove ValuA/B vgpr buffer [146...276) from pool */
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v[vgprValuC+0], 0                        // initC
v_mov_b32 v[vgprValuC+1], 0                        // initC
v_mov_b32 v[vgprValuC+2], 0                        // initC
v_mov_b32 v[vgprValuC+3], 0                        // initC
v_mov_b32 v[vgprValuC+4], 0                        // initC
v_mov_b32 v[vgprValuC+5], 0                        // initC
v_mov_b32 v[vgprValuC+6], 0                        // initC
v_mov_b32 v[vgprValuC+7], 0                        // initC
v_mov_b32 v[vgprValuC+8], 0                        // initC
v_mov_b32 v[vgprValuC+9], 0                        // initC
v_mov_b32 v[vgprValuC+10], 0                       // initC
v_mov_b32 v[vgprValuC+11], 0                       // initC
v_mov_b32 v[vgprValuC+12], 0                       // initC
v_mov_b32 v[vgprValuC+13], 0                       // initC
v_mov_b32 v[vgprValuC+14], 0                       // initC
v_mov_b32 v[vgprValuC+15], 0                       // initC
v_mov_b32 v[vgprValuC+16], 0                       // initC
v_mov_b32 v[vgprValuC+17], 0                       // initC
v_mov_b32 v[vgprValuC+18], 0                       // initC
v_mov_b32 v[vgprValuC+19], 0                       // initC
v_mov_b32 v[vgprValuC+20], 0                       // initC
v_mov_b32 v[vgprValuC+21], 0                       // initC
v_mov_b32 v[vgprValuC+22], 0                       // initC
v_mov_b32 v[vgprValuC+23], 0                       // initC
v_mov_b32 v[vgprValuC+24], 0                       // initC
v_mov_b32 v[vgprValuC+25], 0                       // initC
v_mov_b32 v[vgprValuC+26], 0                       // initC
v_mov_b32 v[vgprValuC+27], 0                       // initC
v_mov_b32 v[vgprValuC+28], 0                       // initC
v_mov_b32 v[vgprValuC+29], 0                       // initC
v_mov_b32 v[vgprValuC+30], 0                       // initC
v_mov_b32 v[vgprValuC+31], 0                       // initC
v_mov_b32 v[vgprValuC+32], 0                       // initC
v_mov_b32 v[vgprValuC+33], 0                       // initC
v_mov_b32 v[vgprValuC+34], 0                       // initC
v_mov_b32 v[vgprValuC+35], 0                       // initC
v_mov_b32 v[vgprValuC+36], 0                       // initC
v_mov_b32 v[vgprValuC+37], 0                       // initC
v_mov_b32 v[vgprValuC+38], 0                       // initC
v_mov_b32 v[vgprValuC+39], 0                       // initC
v_mov_b32 v[vgprValuC+40], 0                       // initC
v_mov_b32 v[vgprValuC+41], 0                       // initC
v_mov_b32 v[vgprValuC+42], 0                       // initC
v_mov_b32 v[vgprValuC+43], 0                       // initC
v_mov_b32 v[vgprValuC+44], 0                       // initC
v_mov_b32 v[vgprValuC+45], 0                       // initC
v_mov_b32 v[vgprValuC+46], 0                       // initC
v_mov_b32 v[vgprValuC+47], 0                       // initC
v_mov_b32 v[vgprValuC+48], 0                       // initC
v_mov_b32 v[vgprValuC+49], 0                       // initC
v_mov_b32 v[vgprValuC+50], 0                       // initC
v_mov_b32 v[vgprValuC+51], 0                       // initC
v_mov_b32 v[vgprValuC+52], 0                       // initC
v_mov_b32 v[vgprValuC+53], 0                       // initC
v_mov_b32 v[vgprValuC+54], 0                       // initC
v_mov_b32 v[vgprValuC+55], 0                       // initC
v_mov_b32 v[vgprValuC+56], 0                       // initC
v_mov_b32 v[vgprValuC+57], 0                       // initC
v_mov_b32 v[vgprValuC+58], 0                       // initC
v_mov_b32 v[vgprValuC+59], 0                       // initC
v_mov_b32 v[vgprValuC+60], 0                       // initC
v_mov_b32 v[vgprValuC+61], 0                       // initC
v_mov_b32 v[vgprValuC+62], 0                       // initC
v_mov_b32 v[vgprValuC+63], 0                       // initC
v_mov_b32 v[vgprValuC+64], 0                       // initC
v_mov_b32 v[vgprValuC+65], 0                       // initC
v_mov_b32 v[vgprValuC+66], 0                       // initC
v_mov_b32 v[vgprValuC+67], 0                       // initC
v_mov_b32 v[vgprValuC+68], 0                       // initC
v_mov_b32 v[vgprValuC+69], 0                       // initC
v_mov_b32 v[vgprValuC+70], 0                       // initC
v_mov_b32 v[vgprValuC+71], 0                       // initC
v_mov_b32 v[vgprValuC+72], 0                       // initC
v_mov_b32 v[vgprValuC+73], 0                       // initC
v_mov_b32 v[vgprValuC+74], 0                       // initC
v_mov_b32 v[vgprValuC+75], 0                       // initC
v_mov_b32 v[vgprValuC+76], 0                       // initC
v_mov_b32 v[vgprValuC+77], 0                       // initC
v_mov_b32 v[vgprValuC+78], 0                       // initC
v_mov_b32 v[vgprValuC+79], 0                       // initC
v_mov_b32 v[vgprValuC+80], 0                       // initC
v_mov_b32 v[vgprValuC+81], 0                       // initC
v_mov_b32 v[vgprValuC+82], 0                       // initC
v_mov_b32 v[vgprValuC+83], 0                       // initC
v_mov_b32 v[vgprValuC+84], 0                       // initC
v_mov_b32 v[vgprValuC+85], 0                       // initC
v_mov_b32 v[vgprValuC+86], 0                       // initC
v_mov_b32 v[vgprValuC+87], 0                       // initC
v_mov_b32 v[vgprValuC+88], 0                       // initC
v_mov_b32 v[vgprValuC+89], 0                       // initC
v_mov_b32 v[vgprValuC+90], 0                       // initC
v_mov_b32 v[vgprValuC+91], 0                       // initC
v_mov_b32 v[vgprValuC+92], 0                       // initC
v_mov_b32 v[vgprValuC+93], 0                       // initC
v_mov_b32 v[vgprValuC+94], 0                       // initC
v_mov_b32 v[vgprValuC+95], 0                       // initC
v_mov_b32 v[vgprValuC+96], 0                       // initC
v_mov_b32 v[vgprValuC+97], 0                       // initC
v_mov_b32 v[vgprValuC+98], 0                       // initC
v_mov_b32 v[vgprValuC+99], 0                       // initC
v_mov_b32 v[vgprValuC+100], 0                      // initC
v_mov_b32 v[vgprValuC+101], 0                      // initC
v_mov_b32 v[vgprValuC+102], 0                      // initC
v_mov_b32 v[vgprValuC+103], 0                      // initC
v_mov_b32 v[vgprValuC+104], 0                      // initC
v_mov_b32 v[vgprValuC+105], 0                      // initC
v_mov_b32 v[vgprValuC+106], 0                      // initC
v_mov_b32 v[vgprValuC+107], 0                      // initC
v_mov_b32 v[vgprValuC+108], 0                      // initC
v_mov_b32 v[vgprValuC+109], 0                      // initC
v_mov_b32 v[vgprValuC+110], 0                      // initC
v_mov_b32 v[vgprValuC+111], 0                      // initC
v_mov_b32 v[vgprValuC+112], 0                      // initC
v_mov_b32 v[vgprValuC+113], 0                      // initC
v_mov_b32 v[vgprValuC+114], 0                      // initC
v_mov_b32 v[vgprValuC+115], 0                      // initC
v_mov_b32 v[vgprValuC+116], 0                      // initC
v_mov_b32 v[vgprValuC+117], 0                      // initC
v_mov_b32 v[vgprValuC+118], 0                      // initC
v_mov_b32 v[vgprValuC+119], 0                      // initC
v_mov_b32 v[vgprValuC+120], 0                      // initC
v_mov_b32 v[vgprValuC+121], 0                      // initC
v_mov_b32 v[vgprValuC+122], 0                      // initC
v_mov_b32 v[vgprValuC+123], 0                      // initC
v_mov_b32 v[vgprValuC+124], 0                      // initC
v_mov_b32 v[vgprValuC+125], 0                      // initC
v_mov_b32 v[vgprValuC+126], 0                      // initC
v_mov_b32 v[vgprValuC+127], 0                      // initC
label_skipInitCVmov:
s_and_b32 s94, s[sgprStaggerU], 0x1f00
s_lshr_b32 s94, s94, 0x8
s_and_b32 s95, s[sgprStaggerU], 0xe000
s_and_b32 s[sgprStaggerU], s[sgprStaggerU], 0xff
s_mov_b32 s92, s[sgprStaggerU]                     // init staggerU
label_beginStaggerUIter:
s_lshl_b32 s93, s92, s94                           // shift by StaggerUStride
s_cmp_ge_u32 s[sgprOrigLoopCounter], s93           // loopCount >= current shift Count
s_cbranch_scc1 label_endStaggerUIter               // jump to end
s_lshr_b32 s92, s92, 1                             // step down to smaller stagger
s_branch label_beginStaggerUIter                   // jump to begin
label_endStaggerUIter:
s_sub_u32 s93, s92, 1                              // staggerU mask
s_cmp_ge_u32 s92, 1                                // if current staggerU >= 1
s_cselect_b32 s[sgprStaggerUIter], s93, 0          // set Mask
s_cmp_eq_u32 s95, 0x0
s_cbranch_scc0 label_StaggerUMapping
s_mov_b32 s92, s[sgprWorkGroup0]
s_branch label_staggerInputEnd
label_StaggerUMapping:
s_cmp_eq_u32 s95, 0x2000
s_cbranch_scc0 label_StaggerUMapping_1
s_mov_b32 s92, s[sgprWorkGroup1]
s_branch label_staggerInputEnd
label_StaggerUMapping_1:
s_cmp_eq_u32 s95, 0x4000
s_cbranch_scc0 label_StaggerUMapping_2
s_mov_b32 s92, -0x1
s_branch label_staggerInputEnd
label_StaggerUMapping_2:
s_cmp_eq_u32 s95, 0x6000
s_cbranch_scc0 label_StaggerUMapping_3
s_mul_i32 s93, s[sgprNumWorkGroups0], s[sgprWorkGroup1]
s_add_u32 s92, s92, s93
s_add_u32 s92, s92, s[sgprWorkGroup0]
s_branch label_staggerInputEnd
label_StaggerUMapping_3:
s_cmp_eq_u32 s95, 0x8000
s_cbranch_scc0 label_staggerInputEnd
s_mov_b32 s92, -0x1
s_branch label_staggerInputEnd
label_staggerInputEnd:
s_and_b32 s[sgprStaggerUIter], s[sgprStaggerUIter], s92 // Compute actual stagger start for this tile
s_lshl_b32 s[sgprStaggerUIter], s[sgprStaggerUIter], s94 // shift by StaggerUStride

/* addr += (StaggerUIter) * GlobalReadIncsA+0 */
s_mul_hi_i32 s93, s[sgprStaggerUIter], s[sgprGlobalReadIncsA+0] //  stagger byte offset
s_mul_i32 s92, s[sgprStaggerUIter], s[sgprGlobalReadIncsA+0] //  stagger byte offset
s_bitcmp1_b32 s[sgprWaveIdx], 0                    // check wave parity
s_cbranch_scc1 label_SkipStaggerA                  // skip: odd waves handle B
s_add_u32 s[sgprtdmAGroup0+2], s[sgprtdmAGroup0+2], s92 // TDM addr += stagger offset (lo)
s_addc_u32 s[sgprtdmAGroup0+3], s[sgprtdmAGroup0+3], s93 // TDM addr += stagger offset (hi)
label_SkipStaggerA:
s_mul_hi_i32 s[sgprWrapUA+1], s[sgprLoopCounterL], s[sgprGlobalReadIncsA+0] // Number of bytes accessed by the unroll loop
s_mul_i32 s[sgprWrapUA+0], s[sgprLoopCounterL], s[sgprGlobalReadIncsA+0] // Number of bytes accessed by the unroll loop
s_mov_b32 s96, s[sgprGlobalReadIncsA+0]
s_mov_b32 s97, 0
s_sub_u64 s[sgprWrapUA:sgprWrapUA+1], s[96:97], s[sgprWrapUA:sgprWrapUA+1] // increment-WrapU

/* addr += (StaggerUIter) * GlobalReadIncsMXSA+0 */
s_mul_hi_i32 s93, s[sgprStaggerUIter], s[sgprGlobalReadIncsMXSA+0] //  stagger byte offset
s_mul_i32 s92, s[sgprStaggerUIter], s[sgprGlobalReadIncsMXSA+0] //  stagger byte offset
s_bitcmp1_b32 s[sgprWaveIdx], 0                    // check wave parity
s_cbranch_scc1 label_SkipStaggerMXSA               // skip: odd waves handle B
s_add_u32 s[sgprtdmMXSAGroup0+2], s[sgprtdmMXSAGroup0+2], s92 // TDM addr += stagger offset (lo)
s_addc_u32 s[sgprtdmMXSAGroup0+3], s[sgprtdmMXSAGroup0+3], s93 // TDM addr += stagger offset (hi)
label_SkipStaggerMXSA:
s_mul_hi_i32 s[sgprWrapUMXSA+1], s[sgprLoopCounterL], s[sgprGlobalReadIncsMXSA+0] // Number of bytes accessed by the unroll loop
s_mul_i32 s[sgprWrapUMXSA+0], s[sgprLoopCounterL], s[sgprGlobalReadIncsMXSA+0] // Number of bytes accessed by the unroll loop
s_mov_b32 s96, s[sgprGlobalReadIncsMXSA+0]
s_mov_b32 s97, 0
s_sub_u64 s[sgprWrapUMXSA:sgprWrapUMXSA+1], s[96:97], s[sgprWrapUMXSA:sgprWrapUMXSA+1] // increment-WrapU

/* addr += (StaggerUIter) * GlobalReadIncsMXSB+0 */
s_mul_hi_i32 s93, s[sgprStaggerUIter], s[sgprGlobalReadIncsMXSB+0] //  stagger byte offset
s_mul_i32 s92, s[sgprStaggerUIter], s[sgprGlobalReadIncsMXSB+0] //  stagger byte offset
s_bitcmp1_b32 s[sgprWaveIdx], 0                    // check wave parity
s_cbranch_scc0 label_SkipStaggerMXSB               // skip: even waves handle A
s_add_u32 s[sgprtdmMXSBGroup0+2], s[sgprtdmMXSBGroup0+2], s92 // TDM addr += stagger offset (lo)
s_addc_u32 s[sgprtdmMXSBGroup0+3], s[sgprtdmMXSBGroup0+3], s93 // TDM addr += stagger offset (hi)
label_SkipStaggerMXSB:
s_mul_hi_i32 s[sgprWrapUMXSB+1], s[sgprLoopCounterL], s[sgprGlobalReadIncsMXSB+0] // Number of bytes accessed by the unroll loop
s_mul_i32 s[sgprWrapUMXSB+0], s[sgprLoopCounterL], s[sgprGlobalReadIncsMXSB+0] // Number of bytes accessed by the unroll loop
s_mov_b32 s96, s[sgprGlobalReadIncsMXSB+0]
s_mov_b32 s97, 0
s_sub_u64 s[sgprWrapUMXSB:sgprWrapUMXSB+1], s[96:97], s[sgprWrapUMXSB:sgprWrapUMXSB+1] // increment-WrapU

/* addr += (StaggerUIter) * GlobalReadIncsB+0 */
s_mul_hi_i32 s93, s[sgprStaggerUIter], s[sgprGlobalReadIncsB+0] //  stagger byte offset
s_mul_i32 s92, s[sgprStaggerUIter], s[sgprGlobalReadIncsB+0] //  stagger byte offset
s_bitcmp1_b32 s[sgprWaveIdx], 0                    // check wave parity
s_cbranch_scc0 label_SkipStaggerB                  // skip: even waves handle A
s_add_u32 s[sgprtdmBGroup0+2], s[sgprtdmBGroup0+2], s92 // TDM addr += stagger offset (lo)
s_addc_u32 s[sgprtdmBGroup0+3], s[sgprtdmBGroup0+3], s93 // TDM addr += stagger offset (hi)
label_SkipStaggerB:
s_mul_hi_i32 s[sgprWrapUB+1], s[sgprLoopCounterL], s[sgprGlobalReadIncsB+0] // Number of bytes accessed by the unroll loop
s_mul_i32 s[sgprWrapUB+0], s[sgprLoopCounterL], s[sgprGlobalReadIncsB+0] // Number of bytes accessed by the unroll loop
s_mov_b32 s96, s[sgprGlobalReadIncsB+0]
s_mov_b32 s97, 0
s_sub_u64 s[sgprWrapUB:sgprWrapUB+1], s[96:97], s[sgprWrapUB:sgprWrapUB+1] // increment-WrapU
s_add_u32 s[sgprStaggerUIter], s[sgprStaggerUIter], 2 // Subtract (PGR-1); StaggerUIter now contains target iteration to wrap
.set sgprWaveIdx, UNDEF
/* local read addresses: init pointers a */

/* localReadInitPointers */
/* local read addresses: init pointers mxsa */

/* localReadInitPointers */
/* local read addresses: init pointers mxsb */

/* localReadInitPointers */
/* local read addresses: init pointers b */

/* localReadInitPointers */

/* prefetch: global -> local */
s_cmp_eq_u32 s[sgprLoopCounterL], 0                // at last iteration?

/* after InitC, skip to end of prefetch last iter if numIter==0 */
s_cbranch_scc0 label_NoBranch_0WFUFF0IRV1EFU7F     // Only branch on scc1
s_getpc_b64 s[92:93]                               // addr of next instr
s_add_i32 s94, label_PrefetchGlobalLastIterEnd, 4  // target branch offset
s_add_u32 s92, s92, s94                            // add target branch offset
s_addc_u32 s93, s93, 0                             // add high and carry
s_setpc_b64 s[92:93]                               // branch to label_PrefetchGlobalLastIterEnd
label_NoBranch_0WFUFF0IRV1EFU7F:
tensor_load_to_lds s[sgprtdmAGroup0:sgprtdmAGroup0+3], s[sgprtdmAGroup1:sgprtdmAGroup1+7], s[sgprtdmAGroup2:sgprtdmAGroup2+3], s[sgprtdmAGroup3:sgprtdmAGroup3+3] // sync LDS0
tensor_load_to_lds s[sgprtdmMXSAGroup0:sgprtdmMXSAGroup0+3], s[sgprtdmMXSAGroup1:sgprtdmMXSAGroup1+7] // sync LDS0
s_set_vgpr_msb 1                                   // src0: 1, src1: 0, src2: 0, dst: 0
v_readfirstlane_b32 s5, v[vgprSerial-256]          // get tId
s_lshr_b32 s5, s5, 5                               // waveId
s_bitcmp1_b32 s5, 0                                // check wave parity
s_cselect_b32 s94, s[sgprWrapUB+0], s[sgprWrapUA+0] // select WrapU based on wave parity (lo)
s_cselect_b32 s95, s[sgprWrapUB+1], s[sgprWrapUA+1] // select WrapU based on wave parity (hi)
s_add_u32 s92, s[sgprLoopCounterL], 1              // remove pf(1)
s_cmp_eq_u32 s[sgprStaggerUIter], s92              // Is this wrapIter? (pf)
s_cselect_b32 s92, s94, s[sgprtdmABIncs]           // select WrapU or normal inc (lo)
s_cselect_b32 s93, s95, 0                          // select WrapU or normal inc (hi)
s_add_u64 s[sgprtdmAGroup0+2:sgprtdmAGroup0+2+1], s[sgprtdmAGroup0+2:sgprtdmAGroup0+2+1], s[92:93] // TDM addr += inc (with wrap, 64-bit)
v_readfirstlane_b32 s5, v[vgprSerial-256]          // get tId
s_lshr_b32 s5, s5, 5                               // waveId
s_bitcmp1_b32 s5, 0                                // check wave parity
s_cselect_b32 s94, s[sgprWrapUMXSB+0], s[sgprWrapUMXSA+0] // select WrapU based on wave parity (lo)
s_cselect_b32 s95, s[sgprWrapUMXSB+1], s[sgprWrapUMXSA+1] // select WrapU based on wave parity (hi)
s_add_u32 s92, s[sgprLoopCounterL], 1              // remove pf(1)
s_cmp_eq_u32 s[sgprStaggerUIter], s92              // Is this wrapIter? (pf)
s_cselect_b32 s92, s94, s[sgprtdmMXSAMXSBIncs]     // select WrapU or normal inc (lo)
s_cselect_b32 s93, s95, 0                          // select WrapU or normal inc (hi)
s_add_u64 s[sgprtdmMXSAGroup0+2:sgprtdmMXSAGroup0+2+1], s[sgprtdmMXSAGroup0+2:sgprtdmMXSAGroup0+2+1], s[92:93] // TDM addr += inc (with wrap, 64-bit)

/******************************************/
/* End setupNewTile                       */
/******************************************/
s_wait_loadcnt 0
s_wait_tensorcnt 0                                 // wait for global read

/* TDM swap lds a */
// TDM LDS swap(aligned pow2: True)
s_xor_b32 s[sgprtdmAGroup0+1], s[sgprtdmAGroup0+1], 0x10000

/* local write swap mxsa */
// TDM LDS swap(aligned pow2: True)
s_xor_b32 s[sgprtdmMXSAGroup0+1], s[sgprtdmMXSAGroup0+1], 0x10000

/* local write swap mxsb */
s_cmp_eq_u32 s[sgprLoopCounterL], 0x1              // PGR=2 but only 1 loop
s_cbranch_scc1 label_skipPGR2_1                    // PGR=2 but only 1 loop
tensor_load_to_lds s[sgprtdmAGroup0:sgprtdmAGroup0+3], s[sgprtdmAGroup1:sgprtdmAGroup1+7], s[sgprtdmAGroup2:sgprtdmAGroup2+3], s[sgprtdmAGroup3:sgprtdmAGroup3+3] // sync LDS1
tensor_load_to_lds s[sgprtdmMXSAGroup0:sgprtdmMXSAGroup0+3], s[sgprtdmMXSAGroup1:sgprtdmMXSAGroup1+7] // sync LDS1
s_branch label_skipPGR2_2                          // jump to PGR=2 label
label_skipPGR2_1:
label_skipPGR2_2:
// Skip force waitcnt0
s_barrier_signal -1
s_barrier_wait -1                                  // LW to PLR, sync

/* local read prefetch a */
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
ds_load_b128 v[vgprValuA_X0_I0+0:vgprValuA_X0_I0+0+3], v[vgprLocalReadAddrA+0] offset:0 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_b128 v[vgprValuA_X0_I0+4:vgprValuA_X0_I0+4+3], v[vgprLocalReadAddrA+0] offset:32 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_b128 v[vgprValuA_X0_I0+8:vgprValuA_X0_I0+8+3], v[vgprLocalReadAddrA+0] offset:4352 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=1 eIdx=0 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_b128 v[vgprValuA_X0_I0+12:vgprValuA_X0_I0+12+3], v[vgprLocalReadAddrA+0] offset:4384 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=1 eIdx=0 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_b128 v[vgprValuA_X0_I0+16:vgprValuA_X0_I0+16+3], v[vgprLocalReadAddrA+0] offset:8704 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=2 eIdx=0 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_b128 v[vgprValuA_X0_I0+20:vgprValuA_X0_I0+20+3], v[vgprLocalReadAddrA+0] offset:8736 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=2 eIdx=0 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_b128 v[vgprValuA_X0_I0+24:vgprValuA_X0_I0+24+3], v[vgprLocalReadAddrA+0] offset:13056 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=3 eIdx=0 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_b128 v[vgprValuA_X0_I0+28:vgprValuA_X0_I0+28+3], v[vgprLocalReadAddrA+0] offset:13088 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=3 eIdx=0 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS0

/* local read prefetch mxsa */
ds_load_b32 v[vgprValuMXSA_X0_I0+0], v[vgprLocalReadAddrMXSA+0] offset:0 // L -> Reg for MX sync LDS0
s_wait_alu depctr_va_vdst(6)
ds_load_b32 v[vgprValuMXSA_X0_I0+1], v[vgprLocalReadAddrMXSA+0] offset:256 // L -> Reg for MX sync LDS0

/* local read prefetch mxsb */
ds_load_b128 v[vgprValuMXSB_X0_I0+0:vgprValuMXSB_X0_I0+0+3], v[vgprLocalReadAddrMXSB+0] offset:0 // L -> Reg for MX sync LDS0

/* local read prefetch b */
ds_load_b128 v[vgprValuB_X0_I0+0:vgprValuB_X0_I0+0+3], v[vgprLocalReadAddrB+0] offset:0 // L -> Reg lro=0 swapByteOffset=0 ti=128 vIdx=0 eIdx=0 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_b128 v[vgprValuB_X0_I0+4:vgprValuB_X0_I0+4+3], v[vgprLocalReadAddrB+0] offset:32 // L -> Reg lro=0 swapByteOffset=0 ti=128 vIdx=0 eIdx=0 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_b128 v[vgprValuB_X0_I0+8:vgprValuB_X0_I0+8+3], v[vgprLocalReadAddrB+0] offset:128 // L -> Reg lro=0 swapByteOffset=0 ti=128 vIdx=0 eIdx=1 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_b128 v[vgprValuB_X0_I0+12:vgprValuB_X0_I0+12+3], v[vgprLocalReadAddrB+0] offset:160 // L -> Reg lro=0 swapByteOffset=0 ti=128 vIdx=0 eIdx=1 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_b128 v[vgprValuB_X0_I0+16:vgprValuB_X0_I0+16+3], v[vgprLocalReadAddrB+0] offset:256 // L -> Reg lro=0 swapByteOffset=0 ti=128 vIdx=0 eIdx=2 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_b128 v[vgprValuB_X0_I0+20:vgprValuB_X0_I0+20+3], v[vgprLocalReadAddrB+0] offset:288 // L -> Reg lro=0 swapByteOffset=0 ti=128 vIdx=0 eIdx=2 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_b128 v[vgprValuB_X0_I0+24:vgprValuB_X0_I0+24+3], v[vgprLocalReadAddrB+0] offset:384 // L -> Reg lro=0 swapByteOffset=0 ti=128 vIdx=0 eIdx=3 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_b128 v[vgprValuB_X0_I0+28:vgprValuB_X0_I0+28+3], v[vgprLocalReadAddrB+0] offset:416 // L -> Reg lro=0 swapByteOffset=0 ti=128 vIdx=0 eIdx=3 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS0

/* local read inc a */
/* N/A, lro->128 */
/* localReadDoCntA 1 localReadDoCntMXSA 1 localReadDoCntB 1 localReadDoCntMXSB 1 localReadDoCntM 0 */

/* local read inc mxsa */
/* N/A, lro->512 */
/* localReadDoCntA 1 localReadDoCntMXSA 1 localReadDoCntB 1 localReadDoCntMXSB 1 localReadDoCntM 0 */

/* local read inc mxsb */
/* N/A, lro->512 */
/* localReadDoCntA 1 localReadDoCntMXSA 1 localReadDoCntB 1 localReadDoCntMXSB 1 localReadDoCntM 0 */

/* local read inc b */
/* N/A, lro->128 */
/* localReadDoCntA 1 localReadDoCntMXSA 1 localReadDoCntB 1 localReadDoCntMXSB 1 localReadDoCntM 0 */

/******************************************/
/* Unrolled Loop(s) - Begin               */
/******************************************/
label_openLoopL:
s_cmp_eq_u32 s[sgprLoopCounterL], 0x1              // LoopCounterL == 1 (PGR>=2, not Suppress: single-loop -> toPGR1)
s_cbranch_scc1 label_toPGR1                        // PGR=2 but only 1 loop, toPGR1
s_cmp_le_u32 s[sgprLoopCounterL], 0x2              // LoopCounterL < EndCounter
s_cbranch_scc1 label_LoopEndL                      // do not enter LoopL
label_InitCIterWmma_label_LoopBeginL_0:
s_wait_loadcnt 0
s_wait_tensorcnt 0                                 // wait for tensor load to finish
s_barrier_signal -1
s_barrier_wait -1                                  // wait for tensor load to finish, PGR->LW needs sync
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
ds_load_b128 v[vgprValuA_X1_I0+0:vgprValuA_X1_I0+0+3], v[vgprLocalReadAddrA+0] offset:64 // L -> Reg lro=128 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=0 oIdx=0 buffer=1 iui=0 sync LDS0
ds_load_b128 v[vgprValuA_X1_I0+4:vgprValuA_X1_I0+4+3], v[vgprLocalReadAddrA+0] offset:96 // L -> Reg lro=128 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=1 oIdx=0 buffer=1 iui=0 sync LDS0
ds_load_b128 v[vgprValuA_X1_I0+8:vgprValuA_X1_I0+8+3], v[vgprLocalReadAddrA+0] offset:4416 // L -> Reg lro=128 swapByteOffset=0 ti=32 vIdx=1 eIdx=0 rIdx=0 oIdx=0 buffer=1 iui=0 sync LDS0
ds_load_b128 v[vgprValuA_X1_I0+12:vgprValuA_X1_I0+12+3], v[vgprLocalReadAddrA+0] offset:4448 // L -> Reg lro=128 swapByteOffset=0 ti=32 vIdx=1 eIdx=0 rIdx=1 oIdx=0 buffer=1 iui=0 sync LDS0
ds_load_b128 v[vgprValuA_X1_I0+16:vgprValuA_X1_I0+16+3], v[vgprLocalReadAddrA+0] offset:8768 // L -> Reg lro=128 swapByteOffset=0 ti=32 vIdx=2 eIdx=0 rIdx=0 oIdx=0 buffer=1 iui=0 sync LDS0
ds_load_b128 v[vgprValuA_X1_I0+20:vgprValuA_X1_I0+20+3], v[vgprLocalReadAddrA+0] offset:8800 // L -> Reg lro=128 swapByteOffset=0 ti=32 vIdx=2 eIdx=0 rIdx=1 oIdx=0 buffer=1 iui=0 sync LDS0
ds_load_b128 v[vgprValuA_X1_I0+24:vgprValuA_X1_I0+24+3], v[vgprLocalReadAddrA+0] offset:13120 // L -> Reg lro=128 swapByteOffset=0 ti=32 vIdx=3 eIdx=0 rIdx=0 oIdx=0 buffer=1 iui=0 sync LDS0
ds_load_b128 v[vgprValuA_X1_I0+28:vgprValuA_X1_I0+28+3], v[vgprLocalReadAddrA+0] offset:13152 // L -> Reg lro=128 swapByteOffset=0 ti=32 vIdx=3 eIdx=0 rIdx=1 oIdx=0 buffer=1 iui=0 sync LDS0
s_wait_alu depctr_va_vdst(5)
ds_load_b32 v[vgprValuMXSA_X1_I0+0], v[vgprLocalReadAddrMXSA+0] offset:512 // L -> Reg for MX sync LDS0
ds_load_b32 v[vgprValuMXSA_X1_I0+1], v[vgprLocalReadAddrMXSA+0] offset:768 // L -> Reg for MX sync LDS0
ds_load_b128 v[vgprValuMXSB_X1_I0+0:vgprValuMXSB_X1_I0+0+3], v[vgprLocalReadAddrMXSB+0] offset:512 // L -> Reg for MX sync LDS0
ds_load_b128 v[vgprValuB_X1_I0+0:vgprValuB_X1_I0+0+3], v[vgprLocalReadAddrB+0] offset:64 // L -> Reg lro=128 swapByteOffset=0 ti=128 vIdx=0 eIdx=0 rIdx=0 oIdx=0 buffer=1 iui=0 sync LDS0
ds_load_b128 v[vgprValuB_X1_I0+4:vgprValuB_X1_I0+4+3], v[vgprLocalReadAddrB+0] offset:96 // L -> Reg lro=128 swapByteOffset=0 ti=128 vIdx=0 eIdx=0 rIdx=1 oIdx=0 buffer=1 iui=0 sync LDS0
ds_load_b128 v[vgprValuB_X1_I0+8:vgprValuB_X1_I0+8+3], v[vgprLocalReadAddrB+0] offset:192 // L -> Reg lro=128 swapByteOffset=0 ti=128 vIdx=0 eIdx=1 rIdx=0 oIdx=0 buffer=1 iui=0 sync LDS0
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
ds_load_b128 v[vgprValuB_X1_I0+12-256:vgprValuB_X1_I0+12-256+3], v[vgprLocalReadAddrB+0] offset:224 // L -> Reg lro=128 swapByteOffset=0 ti=128 vIdx=0 eIdx=1 rIdx=1 oIdx=0 buffer=1 iui=0 sync LDS0
ds_load_b128 v[vgprValuB_X1_I0+16-256:vgprValuB_X1_I0+16-256+3], v[vgprLocalReadAddrB+0] offset:320 // L -> Reg lro=128 swapByteOffset=0 ti=128 vIdx=0 eIdx=2 rIdx=0 oIdx=0 buffer=1 iui=0 sync LDS0
ds_load_b128 v[vgprValuB_X1_I0+20-256:vgprValuB_X1_I0+20-256+3], v[vgprLocalReadAddrB+0] offset:352 // L -> Reg lro=128 swapByteOffset=0 ti=128 vIdx=0 eIdx=2 rIdx=1 oIdx=0 buffer=1 iui=0 sync LDS0
ds_load_b128 v[vgprValuB_X1_I0+24-256:vgprValuB_X1_I0+24-256+3], v[vgprLocalReadAddrB+0] offset:448 // L -> Reg lro=128 swapByteOffset=0 ti=128 vIdx=0 eIdx=3 rIdx=0 oIdx=0 buffer=1 iui=0 sync LDS0
ds_load_b128 v[vgprValuB_X1_I0+28-256:vgprValuB_X1_I0+28-256+3], v[vgprLocalReadAddrB+0] offset:480 // L -> Reg lro=128 swapByteOffset=0 ti=128 vIdx=0 eIdx=3 rIdx=1 oIdx=0 buffer=1 iui=0 sync LDS0
s_wait_dscnt 0                                     // wait for local read before cross-wave TDM swap sync
s_barrier_signal -1
s_barrier_wait -1                                  // Waiting current LR finish for next GR(TDM), sync
s_xor_b32 s[sgprtdmAGroup0+1], s[sgprtdmAGroup0+1], 0x10000
s_xor_b32 s[sgprtdmMXSAGroup0+1], s[sgprtdmMXSAGroup0+1], 0x10000
s_set_vgpr_msb 16384                               // src0: 0, src1: 0, src2: 0, dst: 0
s_wait_alu depctr_vm_vsrc(6)
v_xor_b32 v[vgprLocalReadAddrA], 0x10000, v[vgprLocalReadAddrA] // swap Red Blk
v_xor_b32 v[vgprLocalReadAddrMXSA], 0x10000, v[vgprLocalReadAddrMXSA] // swap Red Blk
v_xor_b32 v[vgprLocalReadAddrMXSB], 0x10000, v[vgprLocalReadAddrMXSB] // swap Red Blk
s_wait_alu depctr_vm_vsrc(0)
v_xor_b32 v[vgprLocalReadAddrB], 0x10000, v[vgprLocalReadAddrB] // swap Red Blk
s_set_vgpr_msb 1                                   // src0: 1, src1: 0, src2: 0, dst: 0
v_readfirstlane_b32 s5, v[vgprSerial-256]          // get tId
s_lshr_b32 s5, s5, 5                               // waveId
s_bitcmp1_b32 s5, 0                                // check wave parity
s_cselect_b32 s94, s[sgprWrapUB+0], s[sgprWrapUA+0] // select WrapU based on wave parity (lo)
s_cselect_b32 s95, s[sgprWrapUB+1], s[sgprWrapUA+1] // select WrapU based on wave parity (hi)
s_cmp_eq_u32 s[sgprLoopCounterL], s[sgprStaggerUIter] // Is this the wrapIter?
s_cselect_b32 s92, s94, s[sgprtdmABIncs]           // select WrapU or normal inc (lo)
s_cselect_b32 s93, s95, 0                          // select WrapU or normal inc (hi)
s_add_u64 s[sgprtdmAGroup0+2:sgprtdmAGroup0+2+1], s[sgprtdmAGroup0+2:sgprtdmAGroup0+2+1], s[92:93] // TDM addr += inc (with wrap, 64-bit)
v_readfirstlane_b32 s5, v[vgprSerial-256]          // get tId
s_lshr_b32 s5, s5, 5                               // waveId
s_bitcmp1_b32 s5, 0                                // check wave parity
s_cselect_b32 s94, s[sgprWrapUMXSB+0], s[sgprWrapUMXSA+0] // select WrapU based on wave parity (lo)
s_cselect_b32 s95, s[sgprWrapUMXSB+1], s[sgprWrapUMXSA+1] // select WrapU based on wave parity (hi)
s_cmp_eq_u32 s[sgprLoopCounterL], s[sgprStaggerUIter] // Is this the wrapIter?
s_cselect_b32 s92, s94, s[sgprtdmMXSAMXSBIncs]     // select WrapU or normal inc (lo)
s_cselect_b32 s93, s95, 0                          // select WrapU or normal inc (hi)
s_add_u64 s[sgprtdmMXSAGroup0+2:sgprtdmMXSAGroup0+2+1], s[sgprtdmMXSAGroup0+2:sgprtdmMXSAGroup0+2+1], s[92:93] // TDM addr += inc (with wrap, 64-bit)
s_set_vgpr_msb 256                                 // src0: 0, src1: 0, src2: 0, dst: 0
s_wait_dscnt 19                                    // wait for prior local read local write old=0, new=19 newLW=0 newLR=19 for iteration == 0
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+0:vgprValuC+0+7], v[vgprValuA_X0_I0+0+0+0:vgprValuA_X0_I0+0+0+0+7], v[vgprValuB_X0_I0+0+0+0:vgprValuB_X0_I0+0+0+0+7], 0, v[vgprValuMXSA_X0_I0+0+0+0], v[vgprValuMXSB_X0_I0+0+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[0+0:7+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+8:vgprValuC+8+7], v[vgprValuA_X0_I0+8+0+0:vgprValuA_X0_I0+8+0+0+7], v[vgprValuB_X0_I0+0+0+0:vgprValuB_X0_I0+0+0+0+7], 0, v[vgprValuMXSA_X0_I0+0+0+0], v[vgprValuMXSB_X0_I0+0+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[8+0:15+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+16:vgprValuC+16+7], v[vgprValuA_X0_I0+16+0+0:vgprValuA_X0_I0+16+0+0+7], v[vgprValuB_X0_I0+0+0+0:vgprValuB_X0_I0+0+0+0+7], 0, v[vgprValuMXSA_X0_I0+1+0+0], v[vgprValuMXSB_X0_I0+0+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[16+0:23+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+24:vgprValuC+24+7], v[vgprValuA_X0_I0+24+0+0:vgprValuA_X0_I0+24+0+0+7], v[vgprValuB_X0_I0+0+0+0:vgprValuB_X0_I0+0+0+0+7], 0, v[vgprValuMXSA_X0_I0+1+0+0], v[vgprValuMXSB_X0_I0+0+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 // left value = v[24+0:31+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+32:vgprValuC+32+7], v[vgprValuA_X0_I0+0+0+0:vgprValuA_X0_I0+0+0+0+7], v[vgprValuB_X0_I0+8+0+0:vgprValuB_X0_I0+8+0+0+7], 0, v[vgprValuMXSA_X0_I0+0+0+0], v[vgprValuMXSB_X0_I0+1+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[32+0:39+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+40:vgprValuC+40+7], v[vgprValuA_X0_I0+8+0+0:vgprValuA_X0_I0+8+0+0+7], v[vgprValuB_X0_I0+8+0+0:vgprValuB_X0_I0+8+0+0+7], 0, v[vgprValuMXSA_X0_I0+0+0+0], v[vgprValuMXSB_X0_I0+1+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[40+0:47+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+48:vgprValuC+48+7], v[vgprValuA_X0_I0+16+0+0:vgprValuA_X0_I0+16+0+0+7], v[vgprValuB_X0_I0+8+0+0:vgprValuB_X0_I0+8+0+0+7], 0, v[vgprValuMXSA_X0_I0+1+0+0], v[vgprValuMXSB_X0_I0+1+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[48+0:55+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+56:vgprValuC+56+7], v[vgprValuA_X0_I0+24+0+0:vgprValuA_X0_I0+24+0+0+7], v[vgprValuB_X0_I0+8+0+0:vgprValuB_X0_I0+8+0+0+7], 0, v[vgprValuMXSA_X0_I0+1+0+0], v[vgprValuMXSB_X0_I0+1+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 // left value = v[56+0:63+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+64:vgprValuC+64+7], v[vgprValuA_X0_I0+0+0+0:vgprValuA_X0_I0+0+0+0+7], v[vgprValuB_X0_I0+16+0+0:vgprValuB_X0_I0+16+0+0+7], 0, v[vgprValuMXSA_X0_I0+0+0+0], v[vgprValuMXSB_X0_I0+2+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[64+0:71+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+72:vgprValuC+72+7], v[vgprValuA_X0_I0+8+0+0:vgprValuA_X0_I0+8+0+0+7], v[vgprValuB_X0_I0+16+0+0:vgprValuB_X0_I0+16+0+0+7], 0, v[vgprValuMXSA_X0_I0+0+0+0], v[vgprValuMXSB_X0_I0+2+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[72+0:79+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+80:vgprValuC+80+7], v[vgprValuA_X0_I0+16+0+0:vgprValuA_X0_I0+16+0+0+7], v[vgprValuB_X0_I0+16+0+0:vgprValuB_X0_I0+16+0+0+7], 0, v[vgprValuMXSA_X0_I0+1+0+0], v[vgprValuMXSB_X0_I0+2+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[80+0:87+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+88:vgprValuC+88+7], v[vgprValuA_X0_I0+24+0+0:vgprValuA_X0_I0+24+0+0+7], v[vgprValuB_X0_I0+16+0+0:vgprValuB_X0_I0+16+0+0+7], 0, v[vgprValuMXSA_X0_I0+1+0+0], v[vgprValuMXSB_X0_I0+2+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 // left value = v[88+0:95+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+96:vgprValuC+96+7], v[vgprValuA_X0_I0+0+0+0:vgprValuA_X0_I0+0+0+0+7], v[vgprValuB_X0_I0+24+0+0:vgprValuB_X0_I0+24+0+0+7], 0, v[vgprValuMXSA_X0_I0+0+0+0], v[vgprValuMXSB_X0_I0+3+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[96+0:103+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+104:vgprValuC+104+7], v[vgprValuA_X0_I0+8+0+0:vgprValuA_X0_I0+8+0+0+7], v[vgprValuB_X0_I0+24+0+0:vgprValuB_X0_I0+24+0+0+7], 0, v[vgprValuMXSA_X0_I0+0+0+0], v[vgprValuMXSB_X0_I0+3+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[104+0:111+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+112:vgprValuC+112+7], v[vgprValuA_X0_I0+16+0+0:vgprValuA_X0_I0+16+0+0+7], v[vgprValuB_X0_I0+24+0+0:vgprValuB_X0_I0+24+0+0+7], 0, v[vgprValuMXSA_X0_I0+1+0+0], v[vgprValuMXSB_X0_I0+3+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[112+0:119+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+120:vgprValuC+120+7], v[vgprValuA_X0_I0+24+0+0:vgprValuA_X0_I0+24+0+0+7], v[vgprValuB_X0_I0+24+0+0:vgprValuB_X0_I0+24+0+0+7], 0, v[vgprValuMXSA_X0_I0+1+0+0], v[vgprValuMXSB_X0_I0+3+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 // left value = v[120+0:127+0]
s_branch label_InitCIterWmma_target_0
.align 16
label_LoopBeginL:

/******************************************/
/* Unrolled Loop 1/1 - Begin              */
/******************************************/
s_wait_loadcnt 0                                   // <This is 1-cycle>
s_wait_tensorcnt 0                                 // wait for tensor load to finish <This is 2-cycle>
// Skip force waitcnt0
s_barrier_signal -1                                // <This is 3-cycle>
s_barrier_wait -1                                  // wait for tensor load to finish, PGR->LW needs sync <This is 13-cycle>

/* Begin Each Unroll: Check VGPR.checkin for INT8 LW */

/* iter 0 (reset local read pointers iteration)  (swap and reset local write pointers iteration)  (swap local read pointers iteration)  */

/* local read a */
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0 <This is 14-cycle>
ds_load_b128 v[vgprValuA_X1_I0+0:vgprValuA_X1_I0+0+3], v[vgprLocalReadAddrA+0] offset:64 // L -> Reg lro=128 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=0 oIdx=0 buffer=1 iui=0 sync LDS0 <This is 15-cycle>
ds_load_b128 v[vgprValuA_X1_I0+4:vgprValuA_X1_I0+4+3], v[vgprLocalReadAddrA+0] offset:96 // L -> Reg lro=128 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=1 oIdx=0 buffer=1 iui=0 sync LDS0 <This is 17-cycle>
ds_load_b128 v[vgprValuA_X1_I0+8:vgprValuA_X1_I0+8+3], v[vgprLocalReadAddrA+0] offset:4416 // L -> Reg lro=128 swapByteOffset=0 ti=32 vIdx=1 eIdx=0 rIdx=0 oIdx=0 buffer=1 iui=0 sync LDS0 <This is 19-cycle>
ds_load_b128 v[vgprValuA_X1_I0+12:vgprValuA_X1_I0+12+3], v[vgprLocalReadAddrA+0] offset:4448 // L -> Reg lro=128 swapByteOffset=0 ti=32 vIdx=1 eIdx=0 rIdx=1 oIdx=0 buffer=1 iui=0 sync LDS0 <This is 21-cycle>
ds_load_b128 v[vgprValuA_X1_I0+16:vgprValuA_X1_I0+16+3], v[vgprLocalReadAddrA+0] offset:8768 // L -> Reg lro=128 swapByteOffset=0 ti=32 vIdx=2 eIdx=0 rIdx=0 oIdx=0 buffer=1 iui=0 sync LDS0 <This is 23-cycle>
ds_load_b128 v[vgprValuA_X1_I0+20:vgprValuA_X1_I0+20+3], v[vgprLocalReadAddrA+0] offset:8800 // L -> Reg lro=128 swapByteOffset=0 ti=32 vIdx=2 eIdx=0 rIdx=1 oIdx=0 buffer=1 iui=0 sync LDS0 <This is 25-cycle>
ds_load_b128 v[vgprValuA_X1_I0+24:vgprValuA_X1_I0+24+3], v[vgprLocalReadAddrA+0] offset:13120 // L -> Reg lro=128 swapByteOffset=0 ti=32 vIdx=3 eIdx=0 rIdx=0 oIdx=0 buffer=1 iui=0 sync LDS0 <This is 27-cycle>
ds_load_b128 v[vgprValuA_X1_I0+28:vgprValuA_X1_I0+28+3], v[vgprLocalReadAddrA+0] offset:13152 // L -> Reg lro=128 swapByteOffset=0 ti=32 vIdx=3 eIdx=0 rIdx=1 oIdx=0 buffer=1 iui=0 sync LDS0 <This is 29-cycle>

/* local read maxa */
ds_load_b32 v[vgprValuMXSA_X1_I0+0], v[vgprLocalReadAddrMXSA+0] offset:512 // L -> Reg for MX sync LDS0 <This is 31-cycle>
ds_load_b32 v[vgprValuMXSA_X1_I0+1], v[vgprLocalReadAddrMXSA+0] offset:768 // L -> Reg for MX sync LDS0 <This is 33-cycle>

/* local read mxsb */
ds_load_b128 v[vgprValuMXSB_X1_I0+0:vgprValuMXSB_X1_I0+0+3], v[vgprLocalReadAddrMXSB+0] offset:512 // L -> Reg for MX sync LDS0 <This is 35-cycle>

/* local read b */
ds_load_b128 v[vgprValuB_X1_I0+0:vgprValuB_X1_I0+0+3], v[vgprLocalReadAddrB+0] offset:64 // L -> Reg lro=128 swapByteOffset=0 ti=128 vIdx=0 eIdx=0 rIdx=0 oIdx=0 buffer=1 iui=0 sync LDS0 <This is 37-cycle>
ds_load_b128 v[vgprValuB_X1_I0+4:vgprValuB_X1_I0+4+3], v[vgprLocalReadAddrB+0] offset:96 // L -> Reg lro=128 swapByteOffset=0 ti=128 vIdx=0 eIdx=0 rIdx=1 oIdx=0 buffer=1 iui=0 sync LDS0 <This is 39-cycle>
ds_load_b128 v[vgprValuB_X1_I0+8:vgprValuB_X1_I0+8+3], v[vgprLocalReadAddrB+0] offset:192 // L -> Reg lro=128 swapByteOffset=0 ti=128 vIdx=0 eIdx=1 rIdx=0 oIdx=0 buffer=1 iui=0 sync LDS0 <This is 41-cycle>
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1 <This is 42-cycle>
ds_load_b128 v[vgprValuB_X1_I0+12-256:vgprValuB_X1_I0+12-256+3], v[vgprLocalReadAddrB+0] offset:224 // L -> Reg lro=128 swapByteOffset=0 ti=128 vIdx=0 eIdx=1 rIdx=1 oIdx=0 buffer=1 iui=0 sync LDS0 <This is 43-cycle>
ds_load_b128 v[vgprValuB_X1_I0+16-256:vgprValuB_X1_I0+16-256+3], v[vgprLocalReadAddrB+0] offset:320 // L -> Reg lro=128 swapByteOffset=0 ti=128 vIdx=0 eIdx=2 rIdx=0 oIdx=0 buffer=1 iui=0 sync LDS0 <This is 45-cycle>
ds_load_b128 v[vgprValuB_X1_I0+20-256:vgprValuB_X1_I0+20-256+3], v[vgprLocalReadAddrB+0] offset:352 // L -> Reg lro=128 swapByteOffset=0 ti=128 vIdx=0 eIdx=2 rIdx=1 oIdx=0 buffer=1 iui=0 sync LDS0 <This is 47-cycle>
ds_load_b128 v[vgprValuB_X1_I0+24-256:vgprValuB_X1_I0+24-256+3], v[vgprLocalReadAddrB+0] offset:448 // L -> Reg lro=128 swapByteOffset=0 ti=128 vIdx=0 eIdx=3 rIdx=0 oIdx=0 buffer=1 iui=0 sync LDS0 <This is 49-cycle>
ds_load_b128 v[vgprValuB_X1_I0+28-256:vgprValuB_X1_I0+28-256+3], v[vgprLocalReadAddrB+0] offset:480 // L -> Reg lro=128 swapByteOffset=0 ti=128 vIdx=0 eIdx=3 rIdx=1 oIdx=0 buffer=1 iui=0 sync LDS0 <This is 51-cycle>
s_wait_dscnt 0                                     // wait for local read before cross-wave TDM swap sync <This is 52-cycle>
// Skip force waitcnt0
s_barrier_signal -1                                // <This is 53-cycle>
s_barrier_wait -1                                  // Waiting current LR finish for next GR(TDM), sync <This is 63-cycle>

/* tdm swap offsets a */
// TDM LDS swap(aligned pow2: True)
s_xor_b32 s[sgprtdmAGroup0+1], s[sgprtdmAGroup0+1], 0x10000 // <This is 64-cycle>

/* local write swap offsets mxsa */
// TDM LDS swap(aligned pow2: True)
s_xor_b32 s[sgprtdmMXSAGroup0+1], s[sgprtdmMXSAGroup0+1], 0x10000 // <This is 65-cycle>

/* local read swap offsets a */
s_set_vgpr_msb 16384                               // src0: 0, src1: 0, src2: 0, dst: 0 <This is 66-cycle>
s_wait_alu depctr_vm_vsrc(6)                       // <This is 67-cycle>
v_xor_b32 v[vgprLocalReadAddrA], 0x10000, v[vgprLocalReadAddrA] // swap Red Blk <This is 68-cycle>

/* local read swap offsets mxsa */
v_xor_b32 v[vgprLocalReadAddrMXSA], 0x10000, v[vgprLocalReadAddrMXSA] // swap Red Blk <This is 69-cycle>

/* local read swap offsets mxsb */
v_xor_b32 v[vgprLocalReadAddrMXSB], 0x10000, v[vgprLocalReadAddrMXSB] // swap Red Blk <This is 70-cycle>

/* local read swap offsets b */
s_wait_alu depctr_vm_vsrc(0)                       // <This is 71-cycle>
v_xor_b32 v[vgprLocalReadAddrB], 0x10000, v[vgprLocalReadAddrB] // swap Red Blk <This is 72-cycle>

/* local read init pointers a */

/* localReadInitPointers */

/* local read init pointers mxsa */

/* localReadInitPointers */

/* local read init pointers mxsb */

/* localReadInitPointers */

/* local read init pointers b */

/* localReadInitPointers */

/* Global Read IncA */
s_set_vgpr_msb 1                                   // src0: 1, src1: 0, src2: 0, dst: 0 <This is 73-cycle>
v_readfirstlane_b32 s5, v[vgprSerial-256]          // get tId <This is 74-cycle>
s_lshr_b32 s5, s5, 5                               // waveId <This is 75-cycle>
s_bitcmp1_b32 s5, 0                                // check wave parity <This is 76-cycle>
s_cselect_b32 s94, s[sgprWrapUB+0], s[sgprWrapUA+0] // select WrapU based on wave parity (lo) <This is 77-cycle>
s_cselect_b32 s95, s[sgprWrapUB+1], s[sgprWrapUA+1] // select WrapU based on wave parity (hi) <This is 78-cycle>
s_cmp_eq_u32 s[sgprLoopCounterL], s[sgprStaggerUIter] // Is this the wrapIter? <This is 79-cycle>
s_cselect_b32 s92, s94, s[sgprtdmABIncs]           // select WrapU or normal inc (lo) <This is 80-cycle>
s_cselect_b32 s93, s95, 0                          // select WrapU or normal inc (hi) <This is 81-cycle>
s_add_u64 s[sgprtdmAGroup0+2:sgprtdmAGroup0+2+1], s[sgprtdmAGroup0+2:sgprtdmAGroup0+2+1], s[92:93] // TDM addr += inc (with wrap, 64-bit) <This is 82-cycle>

/* Global Read IncB */
v_readfirstlane_b32 s5, v[vgprSerial-256]          // get tId <This is 83-cycle>
s_lshr_b32 s5, s5, 5                               // waveId <This is 84-cycle>
s_bitcmp1_b32 s5, 0                                // check wave parity <This is 85-cycle>
s_cselect_b32 s94, s[sgprWrapUMXSB+0], s[sgprWrapUMXSA+0] // select WrapU based on wave parity (lo) <This is 86-cycle>
s_cselect_b32 s95, s[sgprWrapUMXSB+1], s[sgprWrapUMXSA+1] // select WrapU based on wave parity (hi) <This is 87-cycle>
s_cmp_eq_u32 s[sgprLoopCounterL], s[sgprStaggerUIter] // Is this the wrapIter? <This is 88-cycle>
s_cselect_b32 s92, s94, s[sgprtdmMXSAMXSBIncs]     // select WrapU or normal inc (lo) <This is 89-cycle>
s_cselect_b32 s93, s95, 0                          // select WrapU or normal inc (hi) <This is 90-cycle>
s_add_u64 s[sgprtdmMXSAGroup0+2:sgprtdmMXSAGroup0+2+1], s[sgprtdmMXSAGroup0+2:sgprtdmMXSAGroup0+2+1], s[92:93] // TDM addr += inc (with wrap, 64-bit) <This is 91-cycle>

/* Global Read A */

/* Global Read MXSA */

/* Global Read MXSB */

/* Global Read B */
s_set_vgpr_msb 256                                 // src0: 0, src1: 0, src2: 0, dst: 0 <This is 92-cycle>
s_wait_dscnt 19                                    // wait for prior local read local write old=0, new=19 newLW=0 newLR=19 for iteration == 0 <This is 93-cycle>
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+0:vgprValuC+0+7], v[vgprValuA_X0_I0+0+0+0:vgprValuA_X0_I0+0+0+0+7], v[vgprValuB_X0_I0+0+0+0:vgprValuB_X0_I0+0+0+0+7], v[vgprValuC+0:vgprValuC+0+7], v[vgprValuMXSA_X0_I0+0+0+0], v[vgprValuMXSB_X0_I0+0+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[0+0:7+0] <This is 94-cycle>
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+8:vgprValuC+8+7], v[vgprValuA_X0_I0+8+0+0:vgprValuA_X0_I0+8+0+0+7], v[vgprValuB_X0_I0+0+0+0:vgprValuB_X0_I0+0+0+0+7], v[vgprValuC+8:vgprValuC+8+7], v[vgprValuMXSA_X0_I0+0+0+0], v[vgprValuMXSB_X0_I0+0+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[8+0:15+0] <This is 102-cycle>
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+16:vgprValuC+16+7], v[vgprValuA_X0_I0+16+0+0:vgprValuA_X0_I0+16+0+0+7], v[vgprValuB_X0_I0+0+0+0:vgprValuB_X0_I0+0+0+0+7], v[vgprValuC+16:vgprValuC+16+7], v[vgprValuMXSA_X0_I0+1+0+0], v[vgprValuMXSB_X0_I0+0+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[16+0:23+0] <This is 110-cycle>
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+24:vgprValuC+24+7], v[vgprValuA_X0_I0+24+0+0:vgprValuA_X0_I0+24+0+0+7], v[vgprValuB_X0_I0+0+0+0:vgprValuB_X0_I0+0+0+0+7], v[vgprValuC+24:vgprValuC+24+7], v[vgprValuMXSA_X0_I0+1+0+0], v[vgprValuMXSB_X0_I0+0+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 // left value = v[24+0:31+0] <This is 118-cycle>
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+32:vgprValuC+32+7], v[vgprValuA_X0_I0+0+0+0:vgprValuA_X0_I0+0+0+0+7], v[vgprValuB_X0_I0+8+0+0:vgprValuB_X0_I0+8+0+0+7], v[vgprValuC+32:vgprValuC+32+7], v[vgprValuMXSA_X0_I0+0+0+0], v[vgprValuMXSB_X0_I0+1+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[32+0:39+0] <This is 126-cycle>
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+40:vgprValuC+40+7], v[vgprValuA_X0_I0+8+0+0:vgprValuA_X0_I0+8+0+0+7], v[vgprValuB_X0_I0+8+0+0:vgprValuB_X0_I0+8+0+0+7], v[vgprValuC+40:vgprValuC+40+7], v[vgprValuMXSA_X0_I0+0+0+0], v[vgprValuMXSB_X0_I0+1+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[40+0:47+0] <This is 134-cycle>
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+48:vgprValuC+48+7], v[vgprValuA_X0_I0+16+0+0:vgprValuA_X0_I0+16+0+0+7], v[vgprValuB_X0_I0+8+0+0:vgprValuB_X0_I0+8+0+0+7], v[vgprValuC+48:vgprValuC+48+7], v[vgprValuMXSA_X0_I0+1+0+0], v[vgprValuMXSB_X0_I0+1+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[48+0:55+0] <This is 142-cycle>
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+56:vgprValuC+56+7], v[vgprValuA_X0_I0+24+0+0:vgprValuA_X0_I0+24+0+0+7], v[vgprValuB_X0_I0+8+0+0:vgprValuB_X0_I0+8+0+0+7], v[vgprValuC+56:vgprValuC+56+7], v[vgprValuMXSA_X0_I0+1+0+0], v[vgprValuMXSB_X0_I0+1+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 // left value = v[56+0:63+0] <This is 150-cycle>
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+64:vgprValuC+64+7], v[vgprValuA_X0_I0+0+0+0:vgprValuA_X0_I0+0+0+0+7], v[vgprValuB_X0_I0+16+0+0:vgprValuB_X0_I0+16+0+0+7], v[vgprValuC+64:vgprValuC+64+7], v[vgprValuMXSA_X0_I0+0+0+0], v[vgprValuMXSB_X0_I0+2+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[64+0:71+0] <This is 158-cycle>
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+72:vgprValuC+72+7], v[vgprValuA_X0_I0+8+0+0:vgprValuA_X0_I0+8+0+0+7], v[vgprValuB_X0_I0+16+0+0:vgprValuB_X0_I0+16+0+0+7], v[vgprValuC+72:vgprValuC+72+7], v[vgprValuMXSA_X0_I0+0+0+0], v[vgprValuMXSB_X0_I0+2+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[72+0:79+0] <This is 166-cycle>
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+80:vgprValuC+80+7], v[vgprValuA_X0_I0+16+0+0:vgprValuA_X0_I0+16+0+0+7], v[vgprValuB_X0_I0+16+0+0:vgprValuB_X0_I0+16+0+0+7], v[vgprValuC+80:vgprValuC+80+7], v[vgprValuMXSA_X0_I0+1+0+0], v[vgprValuMXSB_X0_I0+2+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[80+0:87+0] <This is 174-cycle>
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+88:vgprValuC+88+7], v[vgprValuA_X0_I0+24+0+0:vgprValuA_X0_I0+24+0+0+7], v[vgprValuB_X0_I0+16+0+0:vgprValuB_X0_I0+16+0+0+7], v[vgprValuC+88:vgprValuC+88+7], v[vgprValuMXSA_X0_I0+1+0+0], v[vgprValuMXSB_X0_I0+2+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 // left value = v[88+0:95+0] <This is 182-cycle>
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+96:vgprValuC+96+7], v[vgprValuA_X0_I0+0+0+0:vgprValuA_X0_I0+0+0+0+7], v[vgprValuB_X0_I0+24+0+0:vgprValuB_X0_I0+24+0+0+7], v[vgprValuC+96:vgprValuC+96+7], v[vgprValuMXSA_X0_I0+0+0+0], v[vgprValuMXSB_X0_I0+3+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[96+0:103+0] <This is 190-cycle>
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+104:vgprValuC+104+7], v[vgprValuA_X0_I0+8+0+0:vgprValuA_X0_I0+8+0+0+7], v[vgprValuB_X0_I0+24+0+0:vgprValuB_X0_I0+24+0+0+7], v[vgprValuC+104:vgprValuC+104+7], v[vgprValuMXSA_X0_I0+0+0+0], v[vgprValuMXSB_X0_I0+3+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[104+0:111+0] <This is 198-cycle>
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+112:vgprValuC+112+7], v[vgprValuA_X0_I0+16+0+0:vgprValuA_X0_I0+16+0+0+7], v[vgprValuB_X0_I0+24+0+0:vgprValuB_X0_I0+24+0+0+7], v[vgprValuC+112:vgprValuC+112+7], v[vgprValuMXSA_X0_I0+1+0+0], v[vgprValuMXSB_X0_I0+3+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[112+0:119+0] <This is 206-cycle>
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+120:vgprValuC+120+7], v[vgprValuA_X0_I0+24+0+0:vgprValuA_X0_I0+24+0+0+7], v[vgprValuB_X0_I0+24+0+0:vgprValuB_X0_I0+24+0+0+7], v[vgprValuC+120:vgprValuC+120+7], v[vgprValuMXSA_X0_I0+1+0+0], v[vgprValuMXSB_X0_I0+3+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 // left value = v[120+0:127+0] <This is 214-cycle>
label_InitCIterWmma_target_0:
/* numPrefetchIter=0 */
/* dataAtIterA=-1 numReadsIterA=1 skipReadsIterA=1 readsPerIterA=8 */
/* dataAtIterB=-1 numReadsIterB=1 skipReadsIterB=1 readsPerIterB=8 */
/* dataAtIterMXSA=-1 numReadsIterMXSA=1 skipReadsIterMXSA=1 readsPerIterMXSA=2 */
/* dataAtIterMXSB=-1 numReadsIterMXSB=1 skipReadsIterMXSB=1 readsPerIterMXSB=1 */

/* iter 1 */
s_wait_loadcnt 0
s_wait_tensorcnt 0                                 // wait for TDM global reads
s_wait_loadcnt 0
s_wait_tensorcnt 0                                 // wait for TDM tensor loads
// Skip force waitcnt0
s_barrier_signal -1
s_barrier_wait -1                                  // PGR, and wait until LW done to sync

/* local read a */
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
s_wait_alu depctr_va_vdst(5)
ds_load_b128 v[vgprValuA_X0_I0+0:vgprValuA_X0_I0+0+3], v[vgprLocalReadAddrA+0] offset:0 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_b128 v[vgprValuA_X0_I0+4:vgprValuA_X0_I0+4+3], v[vgprLocalReadAddrA+0] offset:32 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_b128 v[vgprValuA_X0_I0+8:vgprValuA_X0_I0+8+3], v[vgprLocalReadAddrA+0] offset:4352 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=1 eIdx=0 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_b128 v[vgprValuA_X0_I0+12:vgprValuA_X0_I0+12+3], v[vgprLocalReadAddrA+0] offset:4384 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=1 eIdx=0 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_b128 v[vgprValuA_X0_I0+16:vgprValuA_X0_I0+16+3], v[vgprLocalReadAddrA+0] offset:8704 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=2 eIdx=0 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_b128 v[vgprValuA_X0_I0+20:vgprValuA_X0_I0+20+3], v[vgprLocalReadAddrA+0] offset:8736 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=2 eIdx=0 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_b128 v[vgprValuA_X0_I0+24:vgprValuA_X0_I0+24+3], v[vgprLocalReadAddrA+0] offset:13056 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=3 eIdx=0 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_b128 v[vgprValuA_X0_I0+28:vgprValuA_X0_I0+28+3], v[vgprLocalReadAddrA+0] offset:13088 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=3 eIdx=0 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS1

/* local read maxa */
s_wait_alu depctr_va_vdst(4)
ds_load_b32 v[vgprValuMXSA_X0_I0+0], v[vgprLocalReadAddrMXSA+0] offset:0 // L -> Reg for MX sync LDS1
ds_load_b32 v[vgprValuMXSA_X0_I0+1], v[vgprLocalReadAddrMXSA+0] offset:256 // L -> Reg for MX sync LDS1

/* local read mxsb */
s_wait_alu depctr_va_vdst(3)
ds_load_b128 v[vgprValuMXSB_X0_I0+0:vgprValuMXSB_X0_I0+0+3], v[vgprLocalReadAddrMXSB+0] offset:0 // L -> Reg for MX sync LDS1

/* local read b */
s_wait_alu depctr_va_vdst(2)
ds_load_b128 v[vgprValuB_X0_I0+0:vgprValuB_X0_I0+0+3], v[vgprLocalReadAddrB+0] offset:0 // L -> Reg lro=0 swapByteOffset=0 ti=128 vIdx=0 eIdx=0 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_b128 v[vgprValuB_X0_I0+4:vgprValuB_X0_I0+4+3], v[vgprLocalReadAddrB+0] offset:32 // L -> Reg lro=0 swapByteOffset=0 ti=128 vIdx=0 eIdx=0 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_b128 v[vgprValuB_X0_I0+8:vgprValuB_X0_I0+8+3], v[vgprLocalReadAddrB+0] offset:128 // L -> Reg lro=0 swapByteOffset=0 ti=128 vIdx=0 eIdx=1 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_b128 v[vgprValuB_X0_I0+12:vgprValuB_X0_I0+12+3], v[vgprLocalReadAddrB+0] offset:160 // L -> Reg lro=0 swapByteOffset=0 ti=128 vIdx=0 eIdx=1 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_b128 v[vgprValuB_X0_I0+16:vgprValuB_X0_I0+16+3], v[vgprLocalReadAddrB+0] offset:256 // L -> Reg lro=0 swapByteOffset=0 ti=128 vIdx=0 eIdx=2 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_b128 v[vgprValuB_X0_I0+20:vgprValuB_X0_I0+20+3], v[vgprLocalReadAddrB+0] offset:288 // L -> Reg lro=0 swapByteOffset=0 ti=128 vIdx=0 eIdx=2 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_b128 v[vgprValuB_X0_I0+24:vgprValuB_X0_I0+24+3], v[vgprLocalReadAddrB+0] offset:384 // L -> Reg lro=0 swapByteOffset=0 ti=128 vIdx=0 eIdx=3 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_b128 v[vgprValuB_X0_I0+28:vgprValuB_X0_I0+28+3], v[vgprLocalReadAddrB+0] offset:416 // L -> Reg lro=0 swapByteOffset=0 ti=128 vIdx=0 eIdx=3 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS1

/* local read increment a */
/* N/A, lro->128 */
/* localReadDoCntA 3 localReadDoCntMXSA 3 localReadDoCntB 3 localReadDoCntMXSB 3 localReadDoCntM 0 */

/* local read increment mxsa */
/* N/A, lro->512 */
/* localReadDoCntA 3 localReadDoCntMXSA 3 localReadDoCntB 3 localReadDoCntMXSB 3 localReadDoCntM 0 */

/* local read increment mxsb */
/* N/A, lro->512 */
/* localReadDoCntA 3 localReadDoCntMXSA 3 localReadDoCntB 3 localReadDoCntMXSB 3 localReadDoCntM 0 */

/* local read increment b */
/* N/A, lro->128 */
/* localReadDoCntA 3 localReadDoCntMXSA 3 localReadDoCntB 3 localReadDoCntMXSB 3 localReadDoCntM 0 */

/* Global Read A (TDM deferred after LDS swap) */
tensor_load_to_lds s[sgprtdmAGroup0:sgprtdmAGroup0+3], s[sgprtdmAGroup1:sgprtdmAGroup1+7], s[sgprtdmAGroup2:sgprtdmAGroup2+3], s[sgprtdmAGroup3:sgprtdmAGroup3+3] // sync LDS0

/* Global Read MXSA (TDM deferred after LDS swap) */
tensor_load_to_lds s[sgprtdmMXSAGroup0:sgprtdmMXSAGroup0+3], s[sgprtdmMXSAGroup1:sgprtdmMXSAGroup1+7] // sync LDS0
s_wait_dscnt 19                                    // wait for prior local read local write old=0, new=19 newLW=0 newLR=19
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+0:vgprValuC+0+7], v[vgprValuA_X1_I0+0+0+0:vgprValuA_X1_I0+0+0+0+7], v[vgprValuB_X1_I0+0+0+0:vgprValuB_X1_I0+0+0+0+7], v[vgprValuC+0:vgprValuC+0+7], v[vgprValuMXSA_X1_I0+0+0+0], v[vgprValuMXSB_X1_I0+0+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[0+0:7+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+8:vgprValuC+8+7], v[vgprValuA_X1_I0+8+0+0:vgprValuA_X1_I0+8+0+0+7], v[vgprValuB_X1_I0+0+0+0:vgprValuB_X1_I0+0+0+0+7], v[vgprValuC+8:vgprValuC+8+7], v[vgprValuMXSA_X1_I0+0+0+0], v[vgprValuMXSB_X1_I0+0+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[8+0:15+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+16:vgprValuC+16+7], v[vgprValuA_X1_I0+16+0+0:vgprValuA_X1_I0+16+0+0+7], v[vgprValuB_X1_I0+0+0+0:vgprValuB_X1_I0+0+0+0+7], v[vgprValuC+16:vgprValuC+16+7], v[vgprValuMXSA_X1_I0+1+0+0], v[vgprValuMXSB_X1_I0+0+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[16+0:23+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+24:vgprValuC+24+7], v[vgprValuA_X1_I0+24+0+0:vgprValuA_X1_I0+24+0+0+7], v[vgprValuB_X1_I0+0+0+0:vgprValuB_X1_I0+0+0+0+7], v[vgprValuC+24:vgprValuC+24+7], v[vgprValuMXSA_X1_I0+1+0+0], v[vgprValuMXSB_X1_I0+0+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 // left value = v[24+0:31+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+32:vgprValuC+32+7], v[vgprValuA_X1_I0+0+0+0:vgprValuA_X1_I0+0+0+0+7], v[vgprValuB_X1_I0+8+0+0:vgprValuB_X1_I0+8+0+0+7], v[vgprValuC+32:vgprValuC+32+7], v[vgprValuMXSA_X1_I0+0+0+0], v[vgprValuMXSB_X1_I0+1+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[32+0:39+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+40:vgprValuC+40+7], v[vgprValuA_X1_I0+8+0+0:vgprValuA_X1_I0+8+0+0+7], v[vgprValuB_X1_I0+8+0+0:vgprValuB_X1_I0+8+0+0+7], v[vgprValuC+40:vgprValuC+40+7], v[vgprValuMXSA_X1_I0+0+0+0], v[vgprValuMXSB_X1_I0+1+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[40+0:47+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+48:vgprValuC+48+7], v[vgprValuA_X1_I0+16+0+0:vgprValuA_X1_I0+16+0+0+7], v[vgprValuB_X1_I0+8+0+0:vgprValuB_X1_I0+8+0+0+7], v[vgprValuC+48:vgprValuC+48+7], v[vgprValuMXSA_X1_I0+1+0+0], v[vgprValuMXSB_X1_I0+1+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[48+0:55+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+56:vgprValuC+56+7], v[vgprValuA_X1_I0+24+0+0:vgprValuA_X1_I0+24+0+0+7], v[vgprValuB_X1_I0+8+0+0:vgprValuB_X1_I0+8+0+0+7], v[vgprValuC+56:vgprValuC+56+7], v[vgprValuMXSA_X1_I0+1+0+0], v[vgprValuMXSB_X1_I0+1+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 // left value = v[56+0:63+0]
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+64:vgprValuC+64+7], v[vgprValuA_X1_I0+0+0+0:vgprValuA_X1_I0+0+0+0+7], v[vgprValuB_X1_I0+16+0+0-256:vgprValuB_X1_I0+16+0+0-256+7], v[vgprValuC+64:vgprValuC+64+7], v[vgprValuMXSA_X1_I0+0+0+0], v[vgprValuMXSB_X1_I0+2+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[64+0:71+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+72:vgprValuC+72+7], v[vgprValuA_X1_I0+8+0+0:vgprValuA_X1_I0+8+0+0+7], v[vgprValuB_X1_I0+16+0+0-256:vgprValuB_X1_I0+16+0+0-256+7], v[vgprValuC+72:vgprValuC+72+7], v[vgprValuMXSA_X1_I0+0+0+0], v[vgprValuMXSB_X1_I0+2+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[72+0:79+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+80:vgprValuC+80+7], v[vgprValuA_X1_I0+16+0+0:vgprValuA_X1_I0+16+0+0+7], v[vgprValuB_X1_I0+16+0+0-256:vgprValuB_X1_I0+16+0+0-256+7], v[vgprValuC+80:vgprValuC+80+7], v[vgprValuMXSA_X1_I0+1+0+0], v[vgprValuMXSB_X1_I0+2+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[80+0:87+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+88:vgprValuC+88+7], v[vgprValuA_X1_I0+24+0+0:vgprValuA_X1_I0+24+0+0+7], v[vgprValuB_X1_I0+16+0+0-256:vgprValuB_X1_I0+16+0+0-256+7], v[vgprValuC+88:vgprValuC+88+7], v[vgprValuMXSA_X1_I0+1+0+0], v[vgprValuMXSB_X1_I0+2+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 // left value = v[88+0:95+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+96:vgprValuC+96+7], v[vgprValuA_X1_I0+0+0+0:vgprValuA_X1_I0+0+0+0+7], v[vgprValuB_X1_I0+24+0+0-256:vgprValuB_X1_I0+24+0+0-256+7], v[vgprValuC+96:vgprValuC+96+7], v[vgprValuMXSA_X1_I0+0+0+0], v[vgprValuMXSB_X1_I0+3+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[96+0:103+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+104:vgprValuC+104+7], v[vgprValuA_X1_I0+8+0+0:vgprValuA_X1_I0+8+0+0+7], v[vgprValuB_X1_I0+24+0+0-256:vgprValuB_X1_I0+24+0+0-256+7], v[vgprValuC+104:vgprValuC+104+7], v[vgprValuMXSA_X1_I0+0+0+0], v[vgprValuMXSB_X1_I0+3+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[104+0:111+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+112:vgprValuC+112+7], v[vgprValuA_X1_I0+16+0+0:vgprValuA_X1_I0+16+0+0+7], v[vgprValuB_X1_I0+24+0+0-256:vgprValuB_X1_I0+24+0+0-256+7], v[vgprValuC+112:vgprValuC+112+7], v[vgprValuMXSA_X1_I0+1+0+0], v[vgprValuMXSB_X1_I0+3+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[112+0:119+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+120:vgprValuC+120+7], v[vgprValuA_X1_I0+24+0+0:vgprValuA_X1_I0+24+0+0+7], v[vgprValuB_X1_I0+24+0+0-256:vgprValuB_X1_I0+24+0+0-256+7], v[vgprValuC+120:vgprValuC+120+7], v[vgprValuMXSA_X1_I0+1+0+0], v[vgprValuMXSB_X1_I0+3+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 // left value = v[120+0:127+0]
/* numPrefetchIter=1 */
/* dataAtIterA=0 numReadsIterA=1 skipReadsIterA=1 readsPerIterA=8 */
/* dataAtIterB=0 numReadsIterB=1 skipReadsIterB=1 readsPerIterB=8 */
/* dataAtIterMXSA=0 numReadsIterMXSA=1 skipReadsIterMXSA=1 readsPerIterMXSA=2 */
/* dataAtIterMXSB=0 numReadsIterMXSB=1 skipReadsIterMXSB=1 readsPerIterMXSB=1 */

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
s_wait_loadcnt 0
s_wait_tensorcnt 0                                 // wait for tensor load to finish
// Skip force waitcnt0
s_barrier_signal -1
s_barrier_wait -1                                  // wait for tensor load done, sync

/* iter 0 (reset local read pointers iteration)  (swap and reset local write pointers iteration)  (swap local read pointers iteration)  */

/* local read a */
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
ds_load_b128 v[vgprValuA_X1_I0+0:vgprValuA_X1_I0+0+3], v[vgprLocalReadAddrA+0] offset:64 // L -> Reg lro=128 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=0 oIdx=0 buffer=1 iui=0 sync LDS1
ds_load_b128 v[vgprValuA_X1_I0+4:vgprValuA_X1_I0+4+3], v[vgprLocalReadAddrA+0] offset:96 // L -> Reg lro=128 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=1 oIdx=0 buffer=1 iui=0 sync LDS1
ds_load_b128 v[vgprValuA_X1_I0+8:vgprValuA_X1_I0+8+3], v[vgprLocalReadAddrA+0] offset:4416 // L -> Reg lro=128 swapByteOffset=0 ti=32 vIdx=1 eIdx=0 rIdx=0 oIdx=0 buffer=1 iui=0 sync LDS1
ds_load_b128 v[vgprValuA_X1_I0+12:vgprValuA_X1_I0+12+3], v[vgprLocalReadAddrA+0] offset:4448 // L -> Reg lro=128 swapByteOffset=0 ti=32 vIdx=1 eIdx=0 rIdx=1 oIdx=0 buffer=1 iui=0 sync LDS1
ds_load_b128 v[vgprValuA_X1_I0+16:vgprValuA_X1_I0+16+3], v[vgprLocalReadAddrA+0] offset:8768 // L -> Reg lro=128 swapByteOffset=0 ti=32 vIdx=2 eIdx=0 rIdx=0 oIdx=0 buffer=1 iui=0 sync LDS1
ds_load_b128 v[vgprValuA_X1_I0+20:vgprValuA_X1_I0+20+3], v[vgprLocalReadAddrA+0] offset:8800 // L -> Reg lro=128 swapByteOffset=0 ti=32 vIdx=2 eIdx=0 rIdx=1 oIdx=0 buffer=1 iui=0 sync LDS1
ds_load_b128 v[vgprValuA_X1_I0+24:vgprValuA_X1_I0+24+3], v[vgprLocalReadAddrA+0] offset:13120 // L -> Reg lro=128 swapByteOffset=0 ti=32 vIdx=3 eIdx=0 rIdx=0 oIdx=0 buffer=1 iui=0 sync LDS1
ds_load_b128 v[vgprValuA_X1_I0+28:vgprValuA_X1_I0+28+3], v[vgprLocalReadAddrA+0] offset:13152 // L -> Reg lro=128 swapByteOffset=0 ti=32 vIdx=3 eIdx=0 rIdx=1 oIdx=0 buffer=1 iui=0 sync LDS1

/* local read mxsa */
s_wait_alu depctr_va_vdst(5)
ds_load_b32 v[vgprValuMXSA_X1_I0+0], v[vgprLocalReadAddrMXSA+0] offset:512 // L -> Reg for MX sync LDS1
ds_load_b32 v[vgprValuMXSA_X1_I0+1], v[vgprLocalReadAddrMXSA+0] offset:768 // L -> Reg for MX sync LDS1

/* local read mxsb */
ds_load_b128 v[vgprValuMXSB_X1_I0+0:vgprValuMXSB_X1_I0+0+3], v[vgprLocalReadAddrMXSB+0] offset:512 // L -> Reg for MX sync LDS1

/* local read b */
ds_load_b128 v[vgprValuB_X1_I0+0:vgprValuB_X1_I0+0+3], v[vgprLocalReadAddrB+0] offset:64 // L -> Reg lro=128 swapByteOffset=0 ti=128 vIdx=0 eIdx=0 rIdx=0 oIdx=0 buffer=1 iui=0 sync LDS1
ds_load_b128 v[vgprValuB_X1_I0+4:vgprValuB_X1_I0+4+3], v[vgprLocalReadAddrB+0] offset:96 // L -> Reg lro=128 swapByteOffset=0 ti=128 vIdx=0 eIdx=0 rIdx=1 oIdx=0 buffer=1 iui=0 sync LDS1
ds_load_b128 v[vgprValuB_X1_I0+8:vgprValuB_X1_I0+8+3], v[vgprLocalReadAddrB+0] offset:192 // L -> Reg lro=128 swapByteOffset=0 ti=128 vIdx=0 eIdx=1 rIdx=0 oIdx=0 buffer=1 iui=0 sync LDS1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
ds_load_b128 v[vgprValuB_X1_I0+12-256:vgprValuB_X1_I0+12-256+3], v[vgprLocalReadAddrB+0] offset:224 // L -> Reg lro=128 swapByteOffset=0 ti=128 vIdx=0 eIdx=1 rIdx=1 oIdx=0 buffer=1 iui=0 sync LDS1
ds_load_b128 v[vgprValuB_X1_I0+16-256:vgprValuB_X1_I0+16-256+3], v[vgprLocalReadAddrB+0] offset:320 // L -> Reg lro=128 swapByteOffset=0 ti=128 vIdx=0 eIdx=2 rIdx=0 oIdx=0 buffer=1 iui=0 sync LDS1
ds_load_b128 v[vgprValuB_X1_I0+20-256:vgprValuB_X1_I0+20-256+3], v[vgprLocalReadAddrB+0] offset:352 // L -> Reg lro=128 swapByteOffset=0 ti=128 vIdx=0 eIdx=2 rIdx=1 oIdx=0 buffer=1 iui=0 sync LDS1
ds_load_b128 v[vgprValuB_X1_I0+24-256:vgprValuB_X1_I0+24-256+3], v[vgprLocalReadAddrB+0] offset:448 // L -> Reg lro=128 swapByteOffset=0 ti=128 vIdx=0 eIdx=3 rIdx=0 oIdx=0 buffer=1 iui=0 sync LDS1
ds_load_b128 v[vgprValuB_X1_I0+28-256:vgprValuB_X1_I0+28-256+3], v[vgprLocalReadAddrB+0] offset:480 // L -> Reg lro=128 swapByteOffset=0 ti=128 vIdx=0 eIdx=3 rIdx=1 oIdx=0 buffer=1 iui=0 sync LDS1

/* tdm swap offsets a */
// TDM LDS swap(aligned pow2: True)
s_xor_b32 s[sgprtdmAGroup0+1], s[sgprtdmAGroup0+1], 0x10000

/* local write swap offsets mxsa */
// TDM LDS swap(aligned pow2: True)
s_xor_b32 s[sgprtdmMXSAGroup0+1], s[sgprtdmMXSAGroup0+1], 0x10000

/* local write swap offsets mxsb */

/* local read swap offsets a */
s_set_vgpr_msb 16384                               // src0: 0, src1: 0, src2: 0, dst: 0
s_wait_alu depctr_vm_vsrc(6)
v_xor_b32 v[vgprLocalReadAddrA], 0x10000, v[vgprLocalReadAddrA] // swap Red Blk

/* local read swap offsets mxsa */
v_xor_b32 v[vgprLocalReadAddrMXSA], 0x10000, v[vgprLocalReadAddrMXSA] // swap Red Blk

/* local read swap offsets mxsb */
v_xor_b32 v[vgprLocalReadAddrMXSB], 0x10000, v[vgprLocalReadAddrMXSB] // swap Red Blk

/* local read swap offsets b */
s_wait_alu depctr_vm_vsrc(0)
v_xor_b32 v[vgprLocalReadAddrB], 0x10000, v[vgprLocalReadAddrB] // swap Red Blk

/* local read init pointers a */

/* localReadInitPointers */

/* local read init pointers mxsa */

/* localReadInitPointers */

/* local read init pointers mxsb */

/* localReadInitPointers */

/* local read init pointers b */

/* localReadInitPointers */

/* Global Read IncA */
s_set_vgpr_msb 1                                   // src0: 1, src1: 0, src2: 0, dst: 0
v_readfirstlane_b32 s5, v[vgprSerial-256]          // get tId
s_lshr_b32 s5, s5, 5                               // waveId
s_bitcmp1_b32 s5, 0                                // check wave parity
s_cselect_b32 s94, s[sgprWrapUB+0], s[sgprWrapUA+0] // select WrapU based on wave parity (lo)
s_cselect_b32 s95, s[sgprWrapUB+1], s[sgprWrapUA+1] // select WrapU based on wave parity (hi)
s_cmp_eq_u32 s[sgprLoopCounterL], s[sgprStaggerUIter] // Is this the wrapIter?
s_cselect_b32 s92, s94, s[sgprtdmABIncs]           // select WrapU or normal inc (lo)
s_cselect_b32 s93, s95, 0                          // select WrapU or normal inc (hi)
s_add_u64 s[sgprtdmAGroup0+2:sgprtdmAGroup0+2+1], s[sgprtdmAGroup0+2:sgprtdmAGroup0+2+1], s[92:93] // TDM addr += inc (with wrap, 64-bit)

/* Global Read IncB */
v_readfirstlane_b32 s5, v[vgprSerial-256]          // get tId
s_lshr_b32 s5, s5, 5                               // waveId
s_bitcmp1_b32 s5, 0                                // check wave parity
s_cselect_b32 s94, s[sgprWrapUMXSB+0], s[sgprWrapUMXSA+0] // select WrapU based on wave parity (lo)
s_cselect_b32 s95, s[sgprWrapUMXSB+1], s[sgprWrapUMXSA+1] // select WrapU based on wave parity (hi)
s_cmp_eq_u32 s[sgprLoopCounterL], s[sgprStaggerUIter] // Is this the wrapIter?
s_cselect_b32 s92, s94, s[sgprtdmMXSAMXSBIncs]     // select WrapU or normal inc (lo)
s_cselect_b32 s93, s95, 0                          // select WrapU or normal inc (hi)
s_add_u64 s[sgprtdmMXSAGroup0+2:sgprtdmMXSAGroup0+2+1], s[sgprtdmMXSAGroup0+2:sgprtdmMXSAGroup0+2+1], s[92:93] // TDM addr += inc (with wrap, 64-bit)
s_set_vgpr_msb 256                                 // src0: 0, src1: 0, src2: 0, dst: 0
s_wait_dscnt 19                                    // wait for prior local read local write old=0, new=19 newLW=0 newLR=19 for iteration == 0
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+0:vgprValuC+0+7], v[vgprValuA_X0_I0+0+0+0:vgprValuA_X0_I0+0+0+0+7], v[vgprValuB_X0_I0+0+0+0:vgprValuB_X0_I0+0+0+0+7], v[vgprValuC+0:vgprValuC+0+7], v[vgprValuMXSA_X0_I0+0+0+0], v[vgprValuMXSB_X0_I0+0+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[0+0:7+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+8:vgprValuC+8+7], v[vgprValuA_X0_I0+8+0+0:vgprValuA_X0_I0+8+0+0+7], v[vgprValuB_X0_I0+0+0+0:vgprValuB_X0_I0+0+0+0+7], v[vgprValuC+8:vgprValuC+8+7], v[vgprValuMXSA_X0_I0+0+0+0], v[vgprValuMXSB_X0_I0+0+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[8+0:15+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+16:vgprValuC+16+7], v[vgprValuA_X0_I0+16+0+0:vgprValuA_X0_I0+16+0+0+7], v[vgprValuB_X0_I0+0+0+0:vgprValuB_X0_I0+0+0+0+7], v[vgprValuC+16:vgprValuC+16+7], v[vgprValuMXSA_X0_I0+1+0+0], v[vgprValuMXSB_X0_I0+0+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[16+0:23+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+24:vgprValuC+24+7], v[vgprValuA_X0_I0+24+0+0:vgprValuA_X0_I0+24+0+0+7], v[vgprValuB_X0_I0+0+0+0:vgprValuB_X0_I0+0+0+0+7], v[vgprValuC+24:vgprValuC+24+7], v[vgprValuMXSA_X0_I0+1+0+0], v[vgprValuMXSB_X0_I0+0+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 // left value = v[24+0:31+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+32:vgprValuC+32+7], v[vgprValuA_X0_I0+0+0+0:vgprValuA_X0_I0+0+0+0+7], v[vgprValuB_X0_I0+8+0+0:vgprValuB_X0_I0+8+0+0+7], v[vgprValuC+32:vgprValuC+32+7], v[vgprValuMXSA_X0_I0+0+0+0], v[vgprValuMXSB_X0_I0+1+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[32+0:39+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+40:vgprValuC+40+7], v[vgprValuA_X0_I0+8+0+0:vgprValuA_X0_I0+8+0+0+7], v[vgprValuB_X0_I0+8+0+0:vgprValuB_X0_I0+8+0+0+7], v[vgprValuC+40:vgprValuC+40+7], v[vgprValuMXSA_X0_I0+0+0+0], v[vgprValuMXSB_X0_I0+1+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[40+0:47+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+48:vgprValuC+48+7], v[vgprValuA_X0_I0+16+0+0:vgprValuA_X0_I0+16+0+0+7], v[vgprValuB_X0_I0+8+0+0:vgprValuB_X0_I0+8+0+0+7], v[vgprValuC+48:vgprValuC+48+7], v[vgprValuMXSA_X0_I0+1+0+0], v[vgprValuMXSB_X0_I0+1+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[48+0:55+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+56:vgprValuC+56+7], v[vgprValuA_X0_I0+24+0+0:vgprValuA_X0_I0+24+0+0+7], v[vgprValuB_X0_I0+8+0+0:vgprValuB_X0_I0+8+0+0+7], v[vgprValuC+56:vgprValuC+56+7], v[vgprValuMXSA_X0_I0+1+0+0], v[vgprValuMXSB_X0_I0+1+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 // left value = v[56+0:63+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+64:vgprValuC+64+7], v[vgprValuA_X0_I0+0+0+0:vgprValuA_X0_I0+0+0+0+7], v[vgprValuB_X0_I0+16+0+0:vgprValuB_X0_I0+16+0+0+7], v[vgprValuC+64:vgprValuC+64+7], v[vgprValuMXSA_X0_I0+0+0+0], v[vgprValuMXSB_X0_I0+2+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[64+0:71+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+72:vgprValuC+72+7], v[vgprValuA_X0_I0+8+0+0:vgprValuA_X0_I0+8+0+0+7], v[vgprValuB_X0_I0+16+0+0:vgprValuB_X0_I0+16+0+0+7], v[vgprValuC+72:vgprValuC+72+7], v[vgprValuMXSA_X0_I0+0+0+0], v[vgprValuMXSB_X0_I0+2+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[72+0:79+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+80:vgprValuC+80+7], v[vgprValuA_X0_I0+16+0+0:vgprValuA_X0_I0+16+0+0+7], v[vgprValuB_X0_I0+16+0+0:vgprValuB_X0_I0+16+0+0+7], v[vgprValuC+80:vgprValuC+80+7], v[vgprValuMXSA_X0_I0+1+0+0], v[vgprValuMXSB_X0_I0+2+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[80+0:87+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+88:vgprValuC+88+7], v[vgprValuA_X0_I0+24+0+0:vgprValuA_X0_I0+24+0+0+7], v[vgprValuB_X0_I0+16+0+0:vgprValuB_X0_I0+16+0+0+7], v[vgprValuC+88:vgprValuC+88+7], v[vgprValuMXSA_X0_I0+1+0+0], v[vgprValuMXSB_X0_I0+2+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 // left value = v[88+0:95+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+96:vgprValuC+96+7], v[vgprValuA_X0_I0+0+0+0:vgprValuA_X0_I0+0+0+0+7], v[vgprValuB_X0_I0+24+0+0:vgprValuB_X0_I0+24+0+0+7], v[vgprValuC+96:vgprValuC+96+7], v[vgprValuMXSA_X0_I0+0+0+0], v[vgprValuMXSB_X0_I0+3+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[96+0:103+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+104:vgprValuC+104+7], v[vgprValuA_X0_I0+8+0+0:vgprValuA_X0_I0+8+0+0+7], v[vgprValuB_X0_I0+24+0+0:vgprValuB_X0_I0+24+0+0+7], v[vgprValuC+104:vgprValuC+104+7], v[vgprValuMXSA_X0_I0+0+0+0], v[vgprValuMXSB_X0_I0+3+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[104+0:111+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+112:vgprValuC+112+7], v[vgprValuA_X0_I0+16+0+0:vgprValuA_X0_I0+16+0+0+7], v[vgprValuB_X0_I0+24+0+0:vgprValuB_X0_I0+24+0+0+7], v[vgprValuC+112:vgprValuC+112+7], v[vgprValuMXSA_X0_I0+1+0+0], v[vgprValuMXSB_X0_I0+3+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[112+0:119+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+120:vgprValuC+120+7], v[vgprValuA_X0_I0+24+0+0:vgprValuA_X0_I0+24+0+0+7], v[vgprValuB_X0_I0+24+0+0:vgprValuB_X0_I0+24+0+0+7], v[vgprValuC+120:vgprValuC+120+7], v[vgprValuMXSA_X0_I0+1+0+0], v[vgprValuMXSB_X0_I0+3+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 // left value = v[120+0:127+0]
/* numPrefetchIter=0 */
/* dataAtIterA=-1 numReadsIterA=1 skipReadsIterA=1 readsPerIterA=8 */
/* dataAtIterB=-1 numReadsIterB=1 skipReadsIterB=1 readsPerIterB=8 */
/* dataAtIterMXSA=-1 numReadsIterMXSA=1 skipReadsIterMXSA=1 readsPerIterMXSA=2 */
/* dataAtIterMXSB=-1 numReadsIterMXSB=1 skipReadsIterMXSB=1 readsPerIterMXSB=1 */

/* iter 1 */
s_wait_loadcnt 0
s_wait_tensorcnt 0                                 // wait for TDM tensor loads
// Skip force waitcnt0
s_barrier_signal -1
s_barrier_wait -1                                  // noLoadLoop sync

/* local read a */
s_wait_alu depctr_va_vdst(5)
ds_load_b128 v[vgprValuA_X0_I0+0:vgprValuA_X0_I0+0+3], v[vgprLocalReadAddrA+0] offset:0 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_b128 v[vgprValuA_X0_I0+4:vgprValuA_X0_I0+4+3], v[vgprLocalReadAddrA+0] offset:32 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_b128 v[vgprValuA_X0_I0+8:vgprValuA_X0_I0+8+3], v[vgprLocalReadAddrA+0] offset:4352 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=1 eIdx=0 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_b128 v[vgprValuA_X0_I0+12:vgprValuA_X0_I0+12+3], v[vgprLocalReadAddrA+0] offset:4384 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=1 eIdx=0 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_b128 v[vgprValuA_X0_I0+16:vgprValuA_X0_I0+16+3], v[vgprLocalReadAddrA+0] offset:8704 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=2 eIdx=0 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_b128 v[vgprValuA_X0_I0+20:vgprValuA_X0_I0+20+3], v[vgprLocalReadAddrA+0] offset:8736 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=2 eIdx=0 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_b128 v[vgprValuA_X0_I0+24:vgprValuA_X0_I0+24+3], v[vgprLocalReadAddrA+0] offset:13056 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=3 eIdx=0 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_b128 v[vgprValuA_X0_I0+28:vgprValuA_X0_I0+28+3], v[vgprLocalReadAddrA+0] offset:13088 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=3 eIdx=0 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS0

/* local read mxsa */
s_wait_alu depctr_va_vdst(4)
ds_load_b32 v[vgprValuMXSA_X0_I0+0], v[vgprLocalReadAddrMXSA+0] offset:0 // L -> Reg for MX sync LDS0
ds_load_b32 v[vgprValuMXSA_X0_I0+1], v[vgprLocalReadAddrMXSA+0] offset:256 // L -> Reg for MX sync LDS0

/* local read mxsb */
s_wait_alu depctr_va_vdst(3)
ds_load_b128 v[vgprValuMXSB_X0_I0+0:vgprValuMXSB_X0_I0+0+3], v[vgprLocalReadAddrMXSB+0] offset:0 // L -> Reg for MX sync LDS0

/* local read b */
s_wait_alu depctr_va_vdst(2)
ds_load_b128 v[vgprValuB_X0_I0+0:vgprValuB_X0_I0+0+3], v[vgprLocalReadAddrB+0] offset:0 // L -> Reg lro=0 swapByteOffset=0 ti=128 vIdx=0 eIdx=0 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_b128 v[vgprValuB_X0_I0+4:vgprValuB_X0_I0+4+3], v[vgprLocalReadAddrB+0] offset:32 // L -> Reg lro=0 swapByteOffset=0 ti=128 vIdx=0 eIdx=0 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_b128 v[vgprValuB_X0_I0+8:vgprValuB_X0_I0+8+3], v[vgprLocalReadAddrB+0] offset:128 // L -> Reg lro=0 swapByteOffset=0 ti=128 vIdx=0 eIdx=1 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_b128 v[vgprValuB_X0_I0+12:vgprValuB_X0_I0+12+3], v[vgprLocalReadAddrB+0] offset:160 // L -> Reg lro=0 swapByteOffset=0 ti=128 vIdx=0 eIdx=1 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_b128 v[vgprValuB_X0_I0+16:vgprValuB_X0_I0+16+3], v[vgprLocalReadAddrB+0] offset:256 // L -> Reg lro=0 swapByteOffset=0 ti=128 vIdx=0 eIdx=2 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_b128 v[vgprValuB_X0_I0+20:vgprValuB_X0_I0+20+3], v[vgprLocalReadAddrB+0] offset:288 // L -> Reg lro=0 swapByteOffset=0 ti=128 vIdx=0 eIdx=2 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_b128 v[vgprValuB_X0_I0+24:vgprValuB_X0_I0+24+3], v[vgprLocalReadAddrB+0] offset:384 // L -> Reg lro=0 swapByteOffset=0 ti=128 vIdx=0 eIdx=3 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_b128 v[vgprValuB_X0_I0+28:vgprValuB_X0_I0+28+3], v[vgprLocalReadAddrB+0] offset:416 // L -> Reg lro=0 swapByteOffset=0 ti=128 vIdx=0 eIdx=3 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS0

/* local read increment a */
/* N/A, lro->128 */
/* localReadDoCntA 5 localReadDoCntMXSA 5 localReadDoCntB 5 localReadDoCntMXSB 5 localReadDoCntM 0 */

/* local read increment mxsa */
/* N/A, lro->512 */
/* localReadDoCntA 5 localReadDoCntMXSA 5 localReadDoCntB 5 localReadDoCntMXSB 5 localReadDoCntM 0 */

/* local read increment mxsb */
/* N/A, lro->512 */
/* localReadDoCntA 5 localReadDoCntMXSA 5 localReadDoCntB 5 localReadDoCntMXSB 5 localReadDoCntM 0 */

/* local read increment b */
/* N/A, lro->128 */
/* localReadDoCntA 5 localReadDoCntMXSA 5 localReadDoCntB 5 localReadDoCntMXSB 5 localReadDoCntM 0 */
s_wait_dscnt 19                                    // wait for prior local read local write old=0, new=19 newLW=0 newLR=19
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+0:vgprValuC+0+7], v[vgprValuA_X1_I0+0+0+0:vgprValuA_X1_I0+0+0+0+7], v[vgprValuB_X1_I0+0+0+0:vgprValuB_X1_I0+0+0+0+7], v[vgprValuC+0:vgprValuC+0+7], v[vgprValuMXSA_X1_I0+0+0+0], v[vgprValuMXSB_X1_I0+0+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[0+0:7+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+8:vgprValuC+8+7], v[vgprValuA_X1_I0+8+0+0:vgprValuA_X1_I0+8+0+0+7], v[vgprValuB_X1_I0+0+0+0:vgprValuB_X1_I0+0+0+0+7], v[vgprValuC+8:vgprValuC+8+7], v[vgprValuMXSA_X1_I0+0+0+0], v[vgprValuMXSB_X1_I0+0+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[8+0:15+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+16:vgprValuC+16+7], v[vgprValuA_X1_I0+16+0+0:vgprValuA_X1_I0+16+0+0+7], v[vgprValuB_X1_I0+0+0+0:vgprValuB_X1_I0+0+0+0+7], v[vgprValuC+16:vgprValuC+16+7], v[vgprValuMXSA_X1_I0+1+0+0], v[vgprValuMXSB_X1_I0+0+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[16+0:23+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+24:vgprValuC+24+7], v[vgprValuA_X1_I0+24+0+0:vgprValuA_X1_I0+24+0+0+7], v[vgprValuB_X1_I0+0+0+0:vgprValuB_X1_I0+0+0+0+7], v[vgprValuC+24:vgprValuC+24+7], v[vgprValuMXSA_X1_I0+1+0+0], v[vgprValuMXSB_X1_I0+0+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 // left value = v[24+0:31+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+32:vgprValuC+32+7], v[vgprValuA_X1_I0+0+0+0:vgprValuA_X1_I0+0+0+0+7], v[vgprValuB_X1_I0+8+0+0:vgprValuB_X1_I0+8+0+0+7], v[vgprValuC+32:vgprValuC+32+7], v[vgprValuMXSA_X1_I0+0+0+0], v[vgprValuMXSB_X1_I0+1+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[32+0:39+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+40:vgprValuC+40+7], v[vgprValuA_X1_I0+8+0+0:vgprValuA_X1_I0+8+0+0+7], v[vgprValuB_X1_I0+8+0+0:vgprValuB_X1_I0+8+0+0+7], v[vgprValuC+40:vgprValuC+40+7], v[vgprValuMXSA_X1_I0+0+0+0], v[vgprValuMXSB_X1_I0+1+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[40+0:47+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+48:vgprValuC+48+7], v[vgprValuA_X1_I0+16+0+0:vgprValuA_X1_I0+16+0+0+7], v[vgprValuB_X1_I0+8+0+0:vgprValuB_X1_I0+8+0+0+7], v[vgprValuC+48:vgprValuC+48+7], v[vgprValuMXSA_X1_I0+1+0+0], v[vgprValuMXSB_X1_I0+1+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[48+0:55+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+56:vgprValuC+56+7], v[vgprValuA_X1_I0+24+0+0:vgprValuA_X1_I0+24+0+0+7], v[vgprValuB_X1_I0+8+0+0:vgprValuB_X1_I0+8+0+0+7], v[vgprValuC+56:vgprValuC+56+7], v[vgprValuMXSA_X1_I0+1+0+0], v[vgprValuMXSB_X1_I0+1+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 // left value = v[56+0:63+0]
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+64:vgprValuC+64+7], v[vgprValuA_X1_I0+0+0+0:vgprValuA_X1_I0+0+0+0+7], v[vgprValuB_X1_I0+16+0+0-256:vgprValuB_X1_I0+16+0+0-256+7], v[vgprValuC+64:vgprValuC+64+7], v[vgprValuMXSA_X1_I0+0+0+0], v[vgprValuMXSB_X1_I0+2+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[64+0:71+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+72:vgprValuC+72+7], v[vgprValuA_X1_I0+8+0+0:vgprValuA_X1_I0+8+0+0+7], v[vgprValuB_X1_I0+16+0+0-256:vgprValuB_X1_I0+16+0+0-256+7], v[vgprValuC+72:vgprValuC+72+7], v[vgprValuMXSA_X1_I0+0+0+0], v[vgprValuMXSB_X1_I0+2+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[72+0:79+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+80:vgprValuC+80+7], v[vgprValuA_X1_I0+16+0+0:vgprValuA_X1_I0+16+0+0+7], v[vgprValuB_X1_I0+16+0+0-256:vgprValuB_X1_I0+16+0+0-256+7], v[vgprValuC+80:vgprValuC+80+7], v[vgprValuMXSA_X1_I0+1+0+0], v[vgprValuMXSB_X1_I0+2+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[80+0:87+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+88:vgprValuC+88+7], v[vgprValuA_X1_I0+24+0+0:vgprValuA_X1_I0+24+0+0+7], v[vgprValuB_X1_I0+16+0+0-256:vgprValuB_X1_I0+16+0+0-256+7], v[vgprValuC+88:vgprValuC+88+7], v[vgprValuMXSA_X1_I0+1+0+0], v[vgprValuMXSB_X1_I0+2+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 // left value = v[88+0:95+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+96:vgprValuC+96+7], v[vgprValuA_X1_I0+0+0+0:vgprValuA_X1_I0+0+0+0+7], v[vgprValuB_X1_I0+24+0+0-256:vgprValuB_X1_I0+24+0+0-256+7], v[vgprValuC+96:vgprValuC+96+7], v[vgprValuMXSA_X1_I0+0+0+0], v[vgprValuMXSB_X1_I0+3+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[96+0:103+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+104:vgprValuC+104+7], v[vgprValuA_X1_I0+8+0+0:vgprValuA_X1_I0+8+0+0+7], v[vgprValuB_X1_I0+24+0+0-256:vgprValuB_X1_I0+24+0+0-256+7], v[vgprValuC+104:vgprValuC+104+7], v[vgprValuMXSA_X1_I0+0+0+0], v[vgprValuMXSB_X1_I0+3+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[104+0:111+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+112:vgprValuC+112+7], v[vgprValuA_X1_I0+16+0+0:vgprValuA_X1_I0+16+0+0+7], v[vgprValuB_X1_I0+24+0+0-256:vgprValuB_X1_I0+24+0+0-256+7], v[vgprValuC+112:vgprValuC+112+7], v[vgprValuMXSA_X1_I0+1+0+0], v[vgprValuMXSB_X1_I0+3+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[112+0:119+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+120:vgprValuC+120+7], v[vgprValuA_X1_I0+24+0+0:vgprValuA_X1_I0+24+0+0+7], v[vgprValuB_X1_I0+24+0+0-256:vgprValuB_X1_I0+24+0+0-256+7], v[vgprValuC+120:vgprValuC+120+7], v[vgprValuMXSA_X1_I0+1+0+0], v[vgprValuMXSB_X1_I0+3+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 // left value = v[120+0:127+0]
/* numPrefetchIter=1 */
/* dataAtIterA=0 numReadsIterA=1 skipReadsIterA=1 readsPerIterA=8 */
/* dataAtIterB=0 numReadsIterB=1 skipReadsIterB=1 readsPerIterB=8 */
/* dataAtIterMXSA=0 numReadsIterMXSA=1 skipReadsIterMXSA=1 readsPerIterMXSA=2 */
/* dataAtIterMXSB=0 numReadsIterMXSB=1 skipReadsIterMXSB=1 readsPerIterMXSB=1 */
label_toPGR1:
s_and_b32 s5, s[sgprGSU], 0x3fff                   // Restore GSU
s_cmp_eq_u32 s5, 1                                 // GSU == 1 ?
s_cbranch_scc0 label_GSU_2                         // branch if GSU != 1
label_GSU_2:

/******************************************/
/* Ord. NoLoadLoop - Begin                */
/******************************************/
s_wait_loadcnt 0
s_wait_tensorcnt 0                                 // wait for tensor load to finish
// Skip force waitcnt0
s_barrier_signal -1
s_barrier_wait -1                                  // wait for tensor load done, sync

/* iter 0 (last unrolled loop) */

/* local read a */
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
ds_load_b128 v[vgprValuA_X1_I0+0:vgprValuA_X1_I0+0+3], v[vgprLocalReadAddrA+0] offset:64 // L -> Reg lro=128 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=0 oIdx=0 buffer=1 iui=0 sync LDS0
ds_load_b128 v[vgprValuA_X1_I0+4:vgprValuA_X1_I0+4+3], v[vgprLocalReadAddrA+0] offset:96 // L -> Reg lro=128 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=1 oIdx=0 buffer=1 iui=0 sync LDS0
ds_load_b128 v[vgprValuA_X1_I0+8:vgprValuA_X1_I0+8+3], v[vgprLocalReadAddrA+0] offset:4416 // L -> Reg lro=128 swapByteOffset=0 ti=32 vIdx=1 eIdx=0 rIdx=0 oIdx=0 buffer=1 iui=0 sync LDS0
ds_load_b128 v[vgprValuA_X1_I0+12:vgprValuA_X1_I0+12+3], v[vgprLocalReadAddrA+0] offset:4448 // L -> Reg lro=128 swapByteOffset=0 ti=32 vIdx=1 eIdx=0 rIdx=1 oIdx=0 buffer=1 iui=0 sync LDS0
ds_load_b128 v[vgprValuA_X1_I0+16:vgprValuA_X1_I0+16+3], v[vgprLocalReadAddrA+0] offset:8768 // L -> Reg lro=128 swapByteOffset=0 ti=32 vIdx=2 eIdx=0 rIdx=0 oIdx=0 buffer=1 iui=0 sync LDS0
ds_load_b128 v[vgprValuA_X1_I0+20:vgprValuA_X1_I0+20+3], v[vgprLocalReadAddrA+0] offset:8800 // L -> Reg lro=128 swapByteOffset=0 ti=32 vIdx=2 eIdx=0 rIdx=1 oIdx=0 buffer=1 iui=0 sync LDS0
ds_load_b128 v[vgprValuA_X1_I0+24:vgprValuA_X1_I0+24+3], v[vgprLocalReadAddrA+0] offset:13120 // L -> Reg lro=128 swapByteOffset=0 ti=32 vIdx=3 eIdx=0 rIdx=0 oIdx=0 buffer=1 iui=0 sync LDS0
ds_load_b128 v[vgprValuA_X1_I0+28:vgprValuA_X1_I0+28+3], v[vgprLocalReadAddrA+0] offset:13152 // L -> Reg lro=128 swapByteOffset=0 ti=32 vIdx=3 eIdx=0 rIdx=1 oIdx=0 buffer=1 iui=0 sync LDS0

/* local read mxsa */
s_wait_alu depctr_va_vdst(5)
ds_load_b32 v[vgprValuMXSA_X1_I0+0], v[vgprLocalReadAddrMXSA+0] offset:512 // L -> Reg for MX sync LDS0
ds_load_b32 v[vgprValuMXSA_X1_I0+1], v[vgprLocalReadAddrMXSA+0] offset:768 // L -> Reg for MX sync LDS0

/* local read mxsb */
ds_load_b128 v[vgprValuMXSB_X1_I0+0:vgprValuMXSB_X1_I0+0+3], v[vgprLocalReadAddrMXSB+0] offset:512 // L -> Reg for MX sync LDS0

/* local read b */
ds_load_b128 v[vgprValuB_X1_I0+0:vgprValuB_X1_I0+0+3], v[vgprLocalReadAddrB+0] offset:64 // L -> Reg lro=128 swapByteOffset=0 ti=128 vIdx=0 eIdx=0 rIdx=0 oIdx=0 buffer=1 iui=0 sync LDS0
ds_load_b128 v[vgprValuB_X1_I0+4:vgprValuB_X1_I0+4+3], v[vgprLocalReadAddrB+0] offset:96 // L -> Reg lro=128 swapByteOffset=0 ti=128 vIdx=0 eIdx=0 rIdx=1 oIdx=0 buffer=1 iui=0 sync LDS0
ds_load_b128 v[vgprValuB_X1_I0+8:vgprValuB_X1_I0+8+3], v[vgprLocalReadAddrB+0] offset:192 // L -> Reg lro=128 swapByteOffset=0 ti=128 vIdx=0 eIdx=1 rIdx=0 oIdx=0 buffer=1 iui=0 sync LDS0
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
ds_load_b128 v[vgprValuB_X1_I0+12-256:vgprValuB_X1_I0+12-256+3], v[vgprLocalReadAddrB+0] offset:224 // L -> Reg lro=128 swapByteOffset=0 ti=128 vIdx=0 eIdx=1 rIdx=1 oIdx=0 buffer=1 iui=0 sync LDS0
ds_load_b128 v[vgprValuB_X1_I0+16-256:vgprValuB_X1_I0+16-256+3], v[vgprLocalReadAddrB+0] offset:320 // L -> Reg lro=128 swapByteOffset=0 ti=128 vIdx=0 eIdx=2 rIdx=0 oIdx=0 buffer=1 iui=0 sync LDS0
ds_load_b128 v[vgprValuB_X1_I0+20-256:vgprValuB_X1_I0+20-256+3], v[vgprLocalReadAddrB+0] offset:352 // L -> Reg lro=128 swapByteOffset=0 ti=128 vIdx=0 eIdx=2 rIdx=1 oIdx=0 buffer=1 iui=0 sync LDS0
ds_load_b128 v[vgprValuB_X1_I0+24-256:vgprValuB_X1_I0+24-256+3], v[vgprLocalReadAddrB+0] offset:448 // L -> Reg lro=128 swapByteOffset=0 ti=128 vIdx=0 eIdx=3 rIdx=0 oIdx=0 buffer=1 iui=0 sync LDS0
ds_load_b128 v[vgprValuB_X1_I0+28-256:vgprValuB_X1_I0+28-256+3], v[vgprLocalReadAddrB+0] offset:480 // L -> Reg lro=128 swapByteOffset=0 ti=128 vIdx=0 eIdx=3 rIdx=1 oIdx=0 buffer=1 iui=0 sync LDS0

/* local read swap offsets a */

/* isSwapLroIter = 1 */
s_set_vgpr_msb 16384                               // src0: 0, src1: 0, src2: 0, dst: 0
s_wait_alu depctr_vm_vsrc(6)
v_xor_b32 v[vgprLocalReadAddrA], 0x10000, v[vgprLocalReadAddrA] // swap Red Blk

/* local read swap offsets mxsa */
v_xor_b32 v[vgprLocalReadAddrMXSA], 0x10000, v[vgprLocalReadAddrMXSA] // swap Red Blk

/* local read swap offsets mxsb */
v_xor_b32 v[vgprLocalReadAddrMXSB], 0x10000, v[vgprLocalReadAddrMXSB] // swap Red Blk

/* local read swap offsets b */
s_wait_alu depctr_vm_vsrc(0)
v_xor_b32 v[vgprLocalReadAddrB], 0x10000, v[vgprLocalReadAddrB] // swap Red Blk

/* Global Read IncA */

/* Global Read IncB */

/* Global Read A */

/* Global Read MXSA */

/* Global Read MXSB */

/* Global Read B */
s_wait_dscnt 19                                    // wait for prior local read local write old=0, new=19 newLW=0 newLR=19 for iteration == 0
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+0:vgprValuC+0+7], v[vgprValuA_X0_I0+0+0+0:vgprValuA_X0_I0+0+0+0+7], v[vgprValuB_X0_I0+0+0+0:vgprValuB_X0_I0+0+0+0+7], v[vgprValuC+0:vgprValuC+0+7], v[vgprValuMXSA_X0_I0+0+0+0], v[vgprValuMXSB_X0_I0+0+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[0+0:7+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+8:vgprValuC+8+7], v[vgprValuA_X0_I0+8+0+0:vgprValuA_X0_I0+8+0+0+7], v[vgprValuB_X0_I0+0+0+0:vgprValuB_X0_I0+0+0+0+7], v[vgprValuC+8:vgprValuC+8+7], v[vgprValuMXSA_X0_I0+0+0+0], v[vgprValuMXSB_X0_I0+0+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[8+0:15+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+16:vgprValuC+16+7], v[vgprValuA_X0_I0+16+0+0:vgprValuA_X0_I0+16+0+0+7], v[vgprValuB_X0_I0+0+0+0:vgprValuB_X0_I0+0+0+0+7], v[vgprValuC+16:vgprValuC+16+7], v[vgprValuMXSA_X0_I0+1+0+0], v[vgprValuMXSB_X0_I0+0+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[16+0:23+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+24:vgprValuC+24+7], v[vgprValuA_X0_I0+24+0+0:vgprValuA_X0_I0+24+0+0+7], v[vgprValuB_X0_I0+0+0+0:vgprValuB_X0_I0+0+0+0+7], v[vgprValuC+24:vgprValuC+24+7], v[vgprValuMXSA_X0_I0+1+0+0], v[vgprValuMXSB_X0_I0+0+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 // left value = v[24+0:31+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+32:vgprValuC+32+7], v[vgprValuA_X0_I0+0+0+0:vgprValuA_X0_I0+0+0+0+7], v[vgprValuB_X0_I0+8+0+0:vgprValuB_X0_I0+8+0+0+7], v[vgprValuC+32:vgprValuC+32+7], v[vgprValuMXSA_X0_I0+0+0+0], v[vgprValuMXSB_X0_I0+1+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[32+0:39+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+40:vgprValuC+40+7], v[vgprValuA_X0_I0+8+0+0:vgprValuA_X0_I0+8+0+0+7], v[vgprValuB_X0_I0+8+0+0:vgprValuB_X0_I0+8+0+0+7], v[vgprValuC+40:vgprValuC+40+7], v[vgprValuMXSA_X0_I0+0+0+0], v[vgprValuMXSB_X0_I0+1+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[40+0:47+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+48:vgprValuC+48+7], v[vgprValuA_X0_I0+16+0+0:vgprValuA_X0_I0+16+0+0+7], v[vgprValuB_X0_I0+8+0+0:vgprValuB_X0_I0+8+0+0+7], v[vgprValuC+48:vgprValuC+48+7], v[vgprValuMXSA_X0_I0+1+0+0], v[vgprValuMXSB_X0_I0+1+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[48+0:55+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+56:vgprValuC+56+7], v[vgprValuA_X0_I0+24+0+0:vgprValuA_X0_I0+24+0+0+7], v[vgprValuB_X0_I0+8+0+0:vgprValuB_X0_I0+8+0+0+7], v[vgprValuC+56:vgprValuC+56+7], v[vgprValuMXSA_X0_I0+1+0+0], v[vgprValuMXSB_X0_I0+1+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 // left value = v[56+0:63+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+64:vgprValuC+64+7], v[vgprValuA_X0_I0+0+0+0:vgprValuA_X0_I0+0+0+0+7], v[vgprValuB_X0_I0+16+0+0:vgprValuB_X0_I0+16+0+0+7], v[vgprValuC+64:vgprValuC+64+7], v[vgprValuMXSA_X0_I0+0+0+0], v[vgprValuMXSB_X0_I0+2+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[64+0:71+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+72:vgprValuC+72+7], v[vgprValuA_X0_I0+8+0+0:vgprValuA_X0_I0+8+0+0+7], v[vgprValuB_X0_I0+16+0+0:vgprValuB_X0_I0+16+0+0+7], v[vgprValuC+72:vgprValuC+72+7], v[vgprValuMXSA_X0_I0+0+0+0], v[vgprValuMXSB_X0_I0+2+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[72+0:79+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+80:vgprValuC+80+7], v[vgprValuA_X0_I0+16+0+0:vgprValuA_X0_I0+16+0+0+7], v[vgprValuB_X0_I0+16+0+0:vgprValuB_X0_I0+16+0+0+7], v[vgprValuC+80:vgprValuC+80+7], v[vgprValuMXSA_X0_I0+1+0+0], v[vgprValuMXSB_X0_I0+2+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[80+0:87+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+88:vgprValuC+88+7], v[vgprValuA_X0_I0+24+0+0:vgprValuA_X0_I0+24+0+0+7], v[vgprValuB_X0_I0+16+0+0:vgprValuB_X0_I0+16+0+0+7], v[vgprValuC+88:vgprValuC+88+7], v[vgprValuMXSA_X0_I0+1+0+0], v[vgprValuMXSB_X0_I0+2+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 // left value = v[88+0:95+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+96:vgprValuC+96+7], v[vgprValuA_X0_I0+0+0+0:vgprValuA_X0_I0+0+0+0+7], v[vgprValuB_X0_I0+24+0+0:vgprValuB_X0_I0+24+0+0+7], v[vgprValuC+96:vgprValuC+96+7], v[vgprValuMXSA_X0_I0+0+0+0], v[vgprValuMXSB_X0_I0+3+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[96+0:103+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+104:vgprValuC+104+7], v[vgprValuA_X0_I0+8+0+0:vgprValuA_X0_I0+8+0+0+7], v[vgprValuB_X0_I0+24+0+0:vgprValuB_X0_I0+24+0+0+7], v[vgprValuC+104:vgprValuC+104+7], v[vgprValuMXSA_X0_I0+0+0+0], v[vgprValuMXSB_X0_I0+3+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[104+0:111+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+112:vgprValuC+112+7], v[vgprValuA_X0_I0+16+0+0:vgprValuA_X0_I0+16+0+0+7], v[vgprValuB_X0_I0+24+0+0:vgprValuB_X0_I0+24+0+0+7], v[vgprValuC+112:vgprValuC+112+7], v[vgprValuMXSA_X0_I0+1+0+0], v[vgprValuMXSB_X0_I0+3+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[112+0:119+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+120:vgprValuC+120+7], v[vgprValuA_X0_I0+24+0+0:vgprValuA_X0_I0+24+0+0+7], v[vgprValuB_X0_I0+24+0+0:vgprValuB_X0_I0+24+0+0+7], v[vgprValuC+120:vgprValuC+120+7], v[vgprValuMXSA_X0_I0+1+0+0], v[vgprValuMXSB_X0_I0+3+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 // left value = v[120+0:127+0]
/* numPrefetchIter=0 */
/* dataAtIterA=-1 numReadsIterA=1 skipReadsIterA=1 readsPerIterA=8 */
/* dataAtIterB=-1 numReadsIterB=1 skipReadsIterB=1 readsPerIterB=8 */
/* dataAtIterMXSA=-1 numReadsIterMXSA=1 skipReadsIterMXSA=1 readsPerIterMXSA=2 */
/* dataAtIterMXSB=-1 numReadsIterMXSB=1 skipReadsIterMXSB=1 readsPerIterMXSB=1 */

/* iter 1 (last unrolled loop) */

/* local read a */

/* local read mxsa */

/* local read mxsb */

/* local read b */

/* local read increment a */
/* N/A, lro->256 */
/* localReadDoCntA 7 localReadDoCntMXSA 7 localReadDoCntB 7 localReadDoCntMXSB 7 localReadDoCntM 0 */

/* local read increment mxsa */
/* N/A, lro->1024 */
/* localReadDoCntA 7 localReadDoCntMXSA 7 localReadDoCntB 7 localReadDoCntMXSB 7 localReadDoCntM 0 */

/* local read increment mxsb */
/* N/A, lro->1024 */
/* localReadDoCntA 7 localReadDoCntMXSA 7 localReadDoCntB 7 localReadDoCntMXSB 7 localReadDoCntM 0 */

/* local read increment b */
/* N/A, lro->256 */
/* localReadDoCntA 7 localReadDoCntMXSA 7 localReadDoCntB 7 localReadDoCntMXSB 7 localReadDoCntM 0 */
s_wait_dscnt 0                                     // wait for prior local read local write old=0, new=0 newLW=0 newLR=0
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+0:vgprValuC+0+7], v[vgprValuA_X1_I0+0+0+0:vgprValuA_X1_I0+0+0+0+7], v[vgprValuB_X1_I0+0+0+0:vgprValuB_X1_I0+0+0+0+7], v[vgprValuC+0:vgprValuC+0+7], v[vgprValuMXSA_X1_I0+0+0+0], v[vgprValuMXSB_X1_I0+0+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[0+0:7+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+8:vgprValuC+8+7], v[vgprValuA_X1_I0+8+0+0:vgprValuA_X1_I0+8+0+0+7], v[vgprValuB_X1_I0+0+0+0:vgprValuB_X1_I0+0+0+0+7], v[vgprValuC+8:vgprValuC+8+7], v[vgprValuMXSA_X1_I0+0+0+0], v[vgprValuMXSB_X1_I0+0+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[8+0:15+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+16:vgprValuC+16+7], v[vgprValuA_X1_I0+16+0+0:vgprValuA_X1_I0+16+0+0+7], v[vgprValuB_X1_I0+0+0+0:vgprValuB_X1_I0+0+0+0+7], v[vgprValuC+16:vgprValuC+16+7], v[vgprValuMXSA_X1_I0+1+0+0], v[vgprValuMXSB_X1_I0+0+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[16+0:23+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+24:vgprValuC+24+7], v[vgprValuA_X1_I0+24+0+0:vgprValuA_X1_I0+24+0+0+7], v[vgprValuB_X1_I0+0+0+0:vgprValuB_X1_I0+0+0+0+7], v[vgprValuC+24:vgprValuC+24+7], v[vgprValuMXSA_X1_I0+1+0+0], v[vgprValuMXSB_X1_I0+0+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 // left value = v[24+0:31+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+32:vgprValuC+32+7], v[vgprValuA_X1_I0+0+0+0:vgprValuA_X1_I0+0+0+0+7], v[vgprValuB_X1_I0+8+0+0:vgprValuB_X1_I0+8+0+0+7], v[vgprValuC+32:vgprValuC+32+7], v[vgprValuMXSA_X1_I0+0+0+0], v[vgprValuMXSB_X1_I0+1+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[32+0:39+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+40:vgprValuC+40+7], v[vgprValuA_X1_I0+8+0+0:vgprValuA_X1_I0+8+0+0+7], v[vgprValuB_X1_I0+8+0+0:vgprValuB_X1_I0+8+0+0+7], v[vgprValuC+40:vgprValuC+40+7], v[vgprValuMXSA_X1_I0+0+0+0], v[vgprValuMXSB_X1_I0+1+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[40+0:47+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+48:vgprValuC+48+7], v[vgprValuA_X1_I0+16+0+0:vgprValuA_X1_I0+16+0+0+7], v[vgprValuB_X1_I0+8+0+0:vgprValuB_X1_I0+8+0+0+7], v[vgprValuC+48:vgprValuC+48+7], v[vgprValuMXSA_X1_I0+1+0+0], v[vgprValuMXSB_X1_I0+1+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[48+0:55+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+56:vgprValuC+56+7], v[vgprValuA_X1_I0+24+0+0:vgprValuA_X1_I0+24+0+0+7], v[vgprValuB_X1_I0+8+0+0:vgprValuB_X1_I0+8+0+0+7], v[vgprValuC+56:vgprValuC+56+7], v[vgprValuMXSA_X1_I0+1+0+0], v[vgprValuMXSB_X1_I0+1+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 // left value = v[56+0:63+0]
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+64:vgprValuC+64+7], v[vgprValuA_X1_I0+0+0+0:vgprValuA_X1_I0+0+0+0+7], v[vgprValuB_X1_I0+16+0+0-256:vgprValuB_X1_I0+16+0+0-256+7], v[vgprValuC+64:vgprValuC+64+7], v[vgprValuMXSA_X1_I0+0+0+0], v[vgprValuMXSB_X1_I0+2+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[64+0:71+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+72:vgprValuC+72+7], v[vgprValuA_X1_I0+8+0+0:vgprValuA_X1_I0+8+0+0+7], v[vgprValuB_X1_I0+16+0+0-256:vgprValuB_X1_I0+16+0+0-256+7], v[vgprValuC+72:vgprValuC+72+7], v[vgprValuMXSA_X1_I0+0+0+0], v[vgprValuMXSB_X1_I0+2+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[72+0:79+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+80:vgprValuC+80+7], v[vgprValuA_X1_I0+16+0+0:vgprValuA_X1_I0+16+0+0+7], v[vgprValuB_X1_I0+16+0+0-256:vgprValuB_X1_I0+16+0+0-256+7], v[vgprValuC+80:vgprValuC+80+7], v[vgprValuMXSA_X1_I0+1+0+0], v[vgprValuMXSB_X1_I0+2+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[80+0:87+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+88:vgprValuC+88+7], v[vgprValuA_X1_I0+24+0+0:vgprValuA_X1_I0+24+0+0+7], v[vgprValuB_X1_I0+16+0+0-256:vgprValuB_X1_I0+16+0+0-256+7], v[vgprValuC+88:vgprValuC+88+7], v[vgprValuMXSA_X1_I0+1+0+0], v[vgprValuMXSB_X1_I0+2+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 // left value = v[88+0:95+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+96:vgprValuC+96+7], v[vgprValuA_X1_I0+0+0+0:vgprValuA_X1_I0+0+0+0+7], v[vgprValuB_X1_I0+24+0+0-256:vgprValuB_X1_I0+24+0+0-256+7], v[vgprValuC+96:vgprValuC+96+7], v[vgprValuMXSA_X1_I0+0+0+0], v[vgprValuMXSB_X1_I0+3+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[96+0:103+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+104:vgprValuC+104+7], v[vgprValuA_X1_I0+8+0+0:vgprValuA_X1_I0+8+0+0+7], v[vgprValuB_X1_I0+24+0+0-256:vgprValuB_X1_I0+24+0+0-256+7], v[vgprValuC+104:vgprValuC+104+7], v[vgprValuMXSA_X1_I0+0+0+0], v[vgprValuMXSB_X1_I0+3+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[104+0:111+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+112:vgprValuC+112+7], v[vgprValuA_X1_I0+16+0+0:vgprValuA_X1_I0+16+0+0+7], v[vgprValuB_X1_I0+24+0+0-256:vgprValuB_X1_I0+24+0+0-256+7], v[vgprValuC+112:vgprValuC+112+7], v[vgprValuMXSA_X1_I0+1+0+0], v[vgprValuMXSB_X1_I0+3+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[112+0:119+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+120:vgprValuC+120+7], v[vgprValuA_X1_I0+24+0+0:vgprValuA_X1_I0+24+0+0+7], v[vgprValuB_X1_I0+24+0+0-256:vgprValuB_X1_I0+24+0+0-256+7], v[vgprValuC+120:vgprValuC+120+7], v[vgprValuMXSA_X1_I0+1+0+0], v[vgprValuMXSB_X1_I0+3+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 // left value = v[120+0:127+0]
/* numPrefetchIter=0 */
/* dataAtIterA=0 numReadsIterA=1 skipReadsIterA=0 readsPerIterA=8 */
/* dataAtIterB=0 numReadsIterB=1 skipReadsIterB=0 readsPerIterB=8 */
/* dataAtIterMXSA=0 numReadsIterMXSA=1 skipReadsIterMXSA=0 readsPerIterMXSA=2 */
/* dataAtIterMXSB=0 numReadsIterMXSB=1 skipReadsIterMXSB=0 readsPerIterMXSB=1 */
label_toPGR1end_OrdNLL:
label_PrefetchGlobalLastIterEnd:

/* Tail: add ValuA/B vgpr buffer [146...276) to pool */

/* Tail: add address/G2L vgpr [276...276) to pool */

/******************************************/
/* Tail Loop                              */
/******************************************/

/* local write reset offsets a */

/* local write reset offsets b */
/* Check out VGPR (numG2LA,numG2LB,numG2LMXSA,numG2LMXSB,numG2LMetadata) = (0,0,4,4,0) */
.set vgprG2LMXSA_BASE, 146
.set vgprG2LMXSA, vgprG2LMXSA_BASE+0
.set vgprG2LMXSB_BASE, 150
.set vgprG2LMXSB, vgprG2LMXSB_BASE+0

/* remove stagger offsets for tail loop */
s_cmp_eq_u32 s[sgprOrigLoopCounter], 0             // skip if main loop was not executed
s_cbranch_scc1 label_SkipRemoveStagger             // skip removeStagger
//  removeStagger A
s_sub_i32 s92, 3, s[sgprStaggerUIter]
s_cmp_ge_i32 s92, 0
s_cbranch_scc0 label_Negative_FGPK1V9YGG210F6S
s_mul_hi_u32 s93, s92, s[sgprGlobalReadIncsA+0]    // start offset S in bytes
s_mul_i32 s92, s92, s[sgprGlobalReadIncsA+0]       // start offset S in bytes
s_branch label_MultiplyDone_Y2SUO6ZWN29S5UNR
label_Negative_FGPK1V9YGG210F6S:
s_abs_i32 s92, s92
s_mul_hi_u32 s93, s92, s[sgprGlobalReadIncsA+0]    // start offset S in bytes
s_mul_i32 s92, s92, s[sgprGlobalReadIncsA+0]       // start offset S in bytes
s_xor_b32 s92, s92, 0xffffffff
s_xor_b32 s93, s93, 0xffffffff
s_add_u32 s92, s92, 0x1
s_addc_u32 s93, s93, 0
label_MultiplyDone_Y2SUO6ZWN29S5UNR:
s_sub_u64 s[92:93], s[92:93], s[sgprWrapUA:sgprWrapUA+1] // S - WrapU
s_set_vgpr_msb 1                                   // src0: 1, src1: 0, src2: 0, dst: 0
v_readfirstlane_b32 s5, v[vgprSerial-256]          // get tId
s_lshr_b32 s5, s5, 5                               // waveId
s_bitcmp1_b32 s5, 0                                // check wave parity
s_cbranch_scc1 label_SkipRemoveStaggerA            // skip: odd waves handle B
s_add_u32 s[sgprtdmAGroup0+2], s[sgprtdmAGroup0+2], s92 // TDM addr += removeStagger offset (lo)
s_addc_u32 s[sgprtdmAGroup0+3], s[sgprtdmAGroup0+3], s93 // TDM addr += removeStagger offset (hi)
label_SkipRemoveStaggerA:
//  removeStagger MXSA
s_sub_i32 s92, 3, s[sgprStaggerUIter]
s_cmp_ge_i32 s92, 0
s_cbranch_scc0 label_Negative_GIH73GW9M4GTQDRE
s_mul_hi_u32 s93, s92, s[sgprGlobalReadIncsMXSA+0] // start offset S in bytes
s_mul_i32 s92, s92, s[sgprGlobalReadIncsMXSA+0]    // start offset S in bytes
s_branch label_MultiplyDone_LPF0L4MFW2X82AP9
label_Negative_GIH73GW9M4GTQDRE:
s_abs_i32 s92, s92
s_mul_hi_u32 s93, s92, s[sgprGlobalReadIncsMXSA+0] // start offset S in bytes
s_mul_i32 s92, s92, s[sgprGlobalReadIncsMXSA+0]    // start offset S in bytes
s_xor_b32 s92, s92, 0xffffffff
s_xor_b32 s93, s93, 0xffffffff
s_add_u32 s92, s92, 0x1
s_addc_u32 s93, s93, 0
label_MultiplyDone_LPF0L4MFW2X82AP9:
s_sub_u64 s[92:93], s[92:93], s[sgprWrapUMXSA:sgprWrapUMXSA+1] // S - WrapU
s_set_vgpr_msb 1                                   // src0: 1, src1: 0, src2: 0, dst: 0
v_readfirstlane_b32 s5, v[vgprSerial-256]          // get tId
s_lshr_b32 s5, s5, 5                               // waveId
s_bitcmp1_b32 s5, 0                                // check wave parity
s_cbranch_scc1 label_SkipRemoveStaggerMXSA         // skip: odd waves handle B
s_add_u32 s[sgprtdmMXSAGroup0+2], s[sgprtdmMXSAGroup0+2], s92 // TDM addr += removeStagger offset (lo)
s_addc_u32 s[sgprtdmMXSAGroup0+3], s[sgprtdmMXSAGroup0+3], s93 // TDM addr += removeStagger offset (hi)
label_SkipRemoveStaggerMXSA:
//  removeStagger MXSB
s_sub_i32 s92, 3, s[sgprStaggerUIter]
s_cmp_ge_i32 s92, 0
s_cbranch_scc0 label_Negative_ICMBZOQBJWAFFRJR
s_mul_hi_u32 s93, s92, s[sgprGlobalReadIncsMXSB+0] // start offset S in bytes
s_mul_i32 s92, s92, s[sgprGlobalReadIncsMXSB+0]    // start offset S in bytes
s_branch label_MultiplyDone_7OXYYP31H6FA6UPU
label_Negative_ICMBZOQBJWAFFRJR:
s_abs_i32 s92, s92
s_mul_hi_u32 s93, s92, s[sgprGlobalReadIncsMXSB+0] // start offset S in bytes
s_mul_i32 s92, s92, s[sgprGlobalReadIncsMXSB+0]    // start offset S in bytes
s_xor_b32 s92, s92, 0xffffffff
s_xor_b32 s93, s93, 0xffffffff
s_add_u32 s92, s92, 0x1
s_addc_u32 s93, s93, 0
label_MultiplyDone_7OXYYP31H6FA6UPU:
s_sub_u64 s[92:93], s[92:93], s[sgprWrapUMXSB:sgprWrapUMXSB+1] // S - WrapU
s_set_vgpr_msb 1                                   // src0: 1, src1: 0, src2: 0, dst: 0
v_readfirstlane_b32 s5, v[vgprSerial-256]          // get tId
s_lshr_b32 s5, s5, 5                               // waveId
s_bitcmp1_b32 s5, 0                                // check wave parity
s_cbranch_scc0 label_SkipRemoveStaggerMXSB         // skip: even waves handle A
s_add_u32 s[sgprtdmMXSBGroup0+2], s[sgprtdmMXSBGroup0+2], s92 // TDM addr += removeStagger offset (lo)
s_addc_u32 s[sgprtdmMXSBGroup0+3], s[sgprtdmMXSBGroup0+3], s93 // TDM addr += removeStagger offset (hi)
label_SkipRemoveStaggerMXSB:
//  removeStagger B
s_sub_i32 s92, 3, s[sgprStaggerUIter]
s_cmp_ge_i32 s92, 0
s_cbranch_scc0 label_Negative_C1B1WRJLUJQFHFCU
s_mul_hi_u32 s93, s92, s[sgprGlobalReadIncsB+0]    // start offset S in bytes
s_mul_i32 s92, s92, s[sgprGlobalReadIncsB+0]       // start offset S in bytes
s_branch label_MultiplyDone_UZYYV8P24UI1UD1X
label_Negative_C1B1WRJLUJQFHFCU:
s_abs_i32 s92, s92
s_mul_hi_u32 s93, s92, s[sgprGlobalReadIncsB+0]    // start offset S in bytes
s_mul_i32 s92, s92, s[sgprGlobalReadIncsB+0]       // start offset S in bytes
s_xor_b32 s92, s92, 0xffffffff
s_xor_b32 s93, s93, 0xffffffff
s_add_u32 s92, s92, 0x1
s_addc_u32 s93, s93, 0
label_MultiplyDone_UZYYV8P24UI1UD1X:
s_sub_u64 s[92:93], s[92:93], s[sgprWrapUB:sgprWrapUB+1] // S - WrapU
s_set_vgpr_msb 1                                   // src0: 1, src1: 0, src2: 0, dst: 0
v_readfirstlane_b32 s5, v[vgprSerial-256]          // get tId
s_lshr_b32 s5, s5, 5                               // waveId
s_bitcmp1_b32 s5, 0                                // check wave parity
s_cbranch_scc0 label_SkipRemoveStaggerB            // skip: even waves handle A
s_add_u32 s[sgprtdmBGroup0+2], s[sgprtdmBGroup0+2], s92 // TDM addr += removeStagger offset (lo)
s_addc_u32 s[sgprtdmBGroup0+3], s[sgprtdmBGroup0+3], s93 // TDM addr += removeStagger offset (hi)
label_SkipRemoveStaggerB:
.set sgprGlobalReadIncsA, UNDEF
.set sgprGlobalReadIncsB, UNDEF
.set sgprGlobalReadIncsMXSA, UNDEF
.set sgprGlobalReadIncsMXSB, UNDEF
label_SkipRemoveStagger:

// numIterL = LOCAL_SPLITU * min(sizeL % LOCAL_DEPTHU, DEPTHU / LOCAL_SPLITU)
s_and_b32 s[sgprLoopCounterL], 255, s[sgprSizesSum+0] // s[sgprLoopCounterL] = s[sgprSizesSum+0] % 256
s_and_b32 s88, s[sgprGSU], 0x8000                  // SCC = (GSUC == 1) ?
s_cbranch_scc1 label_GSUC_TL                       // branch if GSUC == 1
s_cmp_lg_u32 s[sgprGSUSumIdx], s[sgprGSUSumIdx+1]  // gsuSumIdx == numIterPerWgRemainder
s_cmov_b32 s[sgprLoopCounterL], 0                  // numIter=0 if gsuSimIdx != numIterPerWgRemainder
s_branch label_GSUC_TL_End
label_GSUC_TL:
s_lshr_b32 s89, s[sgprSizesSum], 8                 // s89 = s[sgprSizesSum] / 256
s_and_b32 s90, s[sgprGSU], 0x3fff                  // Restore GSU
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cvt_f32_u32 v154, s90                            // s88 = s89 / s90
v_rcp_iflag_f32 v154, v154                         // s88 = s89 / s90
v_cvt_f32_u32 v155, s89                            // s88 = s89 / s90
v_mul_f32 v154, v154, v155                         // s88 = s89 / s90
v_cvt_u32_f32 v154, v154                           // s88 = s89 / s90
v_mul_u32_u24 v155, v154, s90                      // s88 = s89 / s90
v_sub_nc_u32 v155, s89, v155                       // s88 = s89 / s90
v_cmp_eq_u32 vcc_lo, v155, s90                     // s88 = s89 / s90
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, vcc_lo                          // s88 = s89 / s90
v_add_nc_u32 v154, 1, v154                         // s88 = s89 / s90
v_mov_b32 v155, 0                                  // s[sgprGSUSumIdx+1] = s89 % s90
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, -1                              // Reset exec
v_cmp_gt_u32 vcc_lo, v155, s90                     // overflow happened in remainder
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, vcc_lo                          // overflow happened in remainder
v_sub_nc_u32 v154, v154, 1                         // quotient - 1
v_mul_u32_u24 v155, v154, s90                      // re-calculate remainder
v_sub_nc_u32 v155, s89, v155                       // re-calculate remainder
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, -1                              // Reset exec
v_readfirstlane_b32 s88, v154                      // quotient
v_readfirstlane_b32 s[sgprGSUSumIdx+1], v155       // remainder
s_sub_u32 s89, s90, 1                              // GSU-1
s_cmp_eq_u32 s88, 0                                // quotient == 0
s_cselect_b32 s88, s[sgprGSUSumIdx+1], s89         // lastWg = (quotient==0) ? numIterPerWgRemainder : GSU-1
s_cmp_lg_u32 s[sgprGSUSumIdx], s88                 // gsuSumIdx == lastWg
s_cmov_b32 s[sgprLoopCounterL], 0                  // numIter=0 if gsuSumIdx != lastWg
label_GSUC_TL_End:
s_cmp_eq_u32 s[sgprLoopCounterL], 0                // numIterL == 0
s_mov_b32 s[sgprOrigLoopCounter], 0                // repurpose to count each localRead increment
s_cbranch_scc1 label_SkipTailLoopL                 // skip to end of tail loop b/c numIter==0
// Skip force waitcnt0
s_barrier_signal -1
s_barrier_wait -1                                  // Barrier before tail TDM loads (WAR hazard with NLL LDS reads)
label_TDMResetTailA:
s_nop 0
s_set_vgpr_msb 1                                   // src0: 1, src1: 0, src2: 0, dst: 0
v_readfirstlane_b32 s88, v[vgprSerial-256]         // first tId
s_lshr_b32 s88, s88, 5                             // wId=fTid // wavelen
s_bitcmp1_b32 s88, 0                               // Check parity of wId
s_cbranch_scc1 label_TDMResetTailB                 // Jump to B if wId is odd
s_and_b32 s5, s[sgprSizeL], 255
// TDM reset tensor dim for tail
s_and_b32 s[sgprtdmAGroup1+1], s[sgprtdmAGroup1+1], 0xffff
s_and_b32 s[sgprtdmAGroup1+2], s[sgprtdmAGroup1+2], 0xffff0000
s_lshr_b32 s63, s5, 0x1
s_lshl_b32 s63, s63, 0x10
s_or_b32 s[sgprtdmAGroup1+1], s[sgprtdmAGroup1+1], s63
s_lshr_b32 s63, s5, 0x1
s_lshr_b32 s63, s63, 0x10
s_or_b32 s[sgprtdmAGroup1+2], s[sgprtdmAGroup1+2], s63
s_branch label_TDMResetTailABEnd
label_TDMResetTailB:
s_and_b32 s5, s[sgprSizeL], 255
// TDM reset tensor dim for tail
s_and_b32 s[sgprtdmBGroup1+1], s[sgprtdmBGroup1+1], 0xffff
s_and_b32 s[sgprtdmBGroup1+2], s[sgprtdmBGroup1+2], 0xffff0000
s_lshr_b32 s63, s5, 0x1
s_lshl_b32 s63, s63, 0x10
s_or_b32 s[sgprtdmBGroup1+1], s[sgprtdmBGroup1+1], s63
s_lshr_b32 s63, s5, 0x1
s_lshr_b32 s63, s63, 0x10
s_or_b32 s[sgprtdmBGroup1+2], s[sgprtdmBGroup1+2], s63
label_TDMResetTailABEnd:
label_TDMResetTailMXSA:
s_nop 0
s_set_vgpr_msb 1                                   // src0: 1, src1: 0, src2: 0, dst: 0
v_readfirstlane_b32 s88, v[vgprSerial-256]         // first tId
s_lshr_b32 s88, s88, 5                             // wId=fTid // wavelen
s_bitcmp1_b32 s88, 0                               // Check parity of wId
s_cbranch_scc1 label_TDMResetTailMXSB              // Jump to B if wId is odd
s_lshr_b32 s89, s88, 1                             // wOffset=wId // 2
s_mul_i32 s89, s89, 128                            // wOffset = wOffset * du // numpComp
s_and_b32 s5, s[sgprSizeL], 255
s_sub_u32 s5, s5, s89                              // consider multiple waves
s_cmov_b32 s5, 0                                   // set to 0 for waves that no enough data to load
// TDM reset tensor dim for tail
s_and_b32 s[sgprtdmMXSAGroup1+2], s[sgprtdmMXSAGroup1+2], 0xffff
s_and_b32 s[sgprtdmMXSAGroup1+3], s[sgprtdmMXSAGroup1+3], 0xffff0000
s_add_u32 s63, s5, 127
s_lshr_b32 s63, s63, 0x7
s_lshl_b32 s63, s63, 0x10
s_or_b32 s[sgprtdmMXSAGroup1+2], s[sgprtdmMXSAGroup1+2], s63
s_lshr_b32 s63, s5, 0x7
s_lshr_b32 s63, s63, 0x10
s_or_b32 s[sgprtdmMXSAGroup1+3], s[sgprtdmMXSAGroup1+3], s63
s_branch label_TDMResetTailMXSAMXSBEnd
label_TDMResetTailMXSB:
s_lshr_b32 s89, s88, 1                             // wOffset=wId // 2
s_mul_i32 s89, s89, 128                            // wOffset = wOffset * du // numpComp
s_and_b32 s5, s[sgprSizeL], 255
s_sub_u32 s5, s5, s89                              // consider multiple waves
s_cmov_b32 s5, 0                                   // set to 0 for waves that no enough data to load
// TDM reset tensor dim for tail
s_and_b32 s[sgprtdmMXSBGroup1+2], s[sgprtdmMXSBGroup1+2], 0xffff
s_and_b32 s[sgprtdmMXSBGroup1+3], s[sgprtdmMXSBGroup1+3], 0xffff0000
s_add_u32 s63, s5, 127
s_lshr_b32 s63, s63, 0x7
s_lshl_b32 s63, s63, 0x10
s_or_b32 s[sgprtdmMXSBGroup1+2], s[sgprtdmMXSBGroup1+2], s63
s_lshr_b32 s63, s5, 0x7
s_lshr_b32 s63, s63, 0x10
s_or_b32 s[sgprtdmMXSBGroup1+3], s[sgprtdmMXSBGroup1+3], s63
label_TDMResetTailMXSAMXSBEnd:

/* Update M0 for DTLDS */

/* Tail global read A */
tensor_load_to_lds s[sgprtdmAGroup0:sgprtdmAGroup0+3], s[sgprtdmAGroup1:sgprtdmAGroup1+7], s[sgprtdmAGroup2:sgprtdmAGroup2+3], s[sgprtdmAGroup3:sgprtdmAGroup3+3] // sync LDS0

/* Update M0 for DTLDS */

/* Tail global read MXSA */
tensor_load_to_lds s[sgprtdmMXSAGroup0:sgprtdmMXSAGroup0+3], s[sgprtdmMXSAGroup1:sgprtdmMXSAGroup1+7] // sync LDS0

/* Update M0 for DTLDS */

/* Tail global read MXSB */

/* Update M0 for DTLDS */

/* Tail global read B */
s_wait_loadcnt 0
s_wait_tensorcnt 0                                 // 2wait for global read
// Skip force waitcnt0
s_barrier_signal -1
s_barrier_wait -1

/* Recalc local read offsets */
s_wait_dscnt 0                                     // 5wait for local write
// Skip force waitcnt0
s_barrier_signal -1
s_barrier_wait -1                                  // Tail loop LW->LR, sync LDS0
.set vgprG2LMXSA_BASE, UNDEF
.set vgprG2LMXSA, UNDEF
.set vgprG2LMXSB_BASE, UNDEF
.set vgprG2LMXSB, UNDEF
.set vgprValuA_X0_I0_BASE, 146
.set vgprValuA_X0_I0, vgprValuA_X0_I0_BASE+0
.set vgprValuA_X1_I0, vgprValuA_X0_I0_BASE+32
.set vgprValuB_X0_I0_BASE, 210
.set vgprValuB_X0_I0, vgprValuB_X0_I0_BASE+0
.set vgprValuB_X1_I0, vgprValuB_X0_I0_BASE+32

/* Tail: local read init pointers a */

/* localReadInitPointers */

/* Tail: local read init pointers mxsa */

/* localReadInitPointers */

/* Tail: local read init pointers mxsb */

/* localReadInitPointers */

/* Tail: local read init pointers b */

/* localReadInitPointers */

/* tail loop: macs */
.align 16
label_TailLoopBeginL:

/* local read a */
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
s_wait_alu depctr_va_vdst(3)
ds_load_b128 v[vgprValuA_X0_I0+0:vgprValuA_X0_I0+0+3], v[vgprLocalReadAddrA+0] offset:0 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_b128 v[vgprValuA_X0_I0+4:vgprValuA_X0_I0+4+3], v[vgprLocalReadAddrA+0] offset:32 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_b128 v[vgprValuA_X0_I0+8:vgprValuA_X0_I0+8+3], v[vgprLocalReadAddrA+0] offset:4352 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=1 eIdx=0 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_b128 v[vgprValuA_X0_I0+12:vgprValuA_X0_I0+12+3], v[vgprLocalReadAddrA+0] offset:4384 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=1 eIdx=0 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_b128 v[vgprValuA_X0_I0+16:vgprValuA_X0_I0+16+3], v[vgprLocalReadAddrA+0] offset:8704 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=2 eIdx=0 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_b128 v[vgprValuA_X0_I0+20:vgprValuA_X0_I0+20+3], v[vgprLocalReadAddrA+0] offset:8736 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=2 eIdx=0 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_b128 v[vgprValuA_X0_I0+24:vgprValuA_X0_I0+24+3], v[vgprLocalReadAddrA+0] offset:13056 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=3 eIdx=0 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_b128 v[vgprValuA_X0_I0+28:vgprValuA_X0_I0+28+3], v[vgprLocalReadAddrA+0] offset:13088 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=3 eIdx=0 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS0

/* local read maxa */
s_wait_alu depctr_va_vdst(2)
ds_load_b32 v[vgprValuMXSA_X0_I0+0], v[vgprLocalReadAddrMXSA+0] offset:0 // L -> Reg for MX sync LDS0
ds_load_b32 v[vgprValuMXSA_X0_I0+1], v[vgprLocalReadAddrMXSA+0] offset:256 // L -> Reg for MX sync LDS0

/* local read maxb */
s_wait_alu depctr_va_vdst(1)
ds_load_b128 v[vgprValuMXSB_X0_I0+0:vgprValuMXSB_X0_I0+0+3], v[vgprLocalReadAddrMXSB+0] offset:0 // L -> Reg for MX sync LDS0

/* local read b */
s_wait_alu depctr_va_vdst(0)
ds_load_b128 v[vgprValuB_X0_I0+0:vgprValuB_X0_I0+0+3], v[vgprLocalReadAddrB+0] offset:0 // L -> Reg lro=0 swapByteOffset=0 ti=128 vIdx=0 eIdx=0 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_b128 v[vgprValuB_X0_I0+4:vgprValuB_X0_I0+4+3], v[vgprLocalReadAddrB+0] offset:32 // L -> Reg lro=0 swapByteOffset=0 ti=128 vIdx=0 eIdx=0 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_b128 v[vgprValuB_X0_I0+8:vgprValuB_X0_I0+8+3], v[vgprLocalReadAddrB+0] offset:128 // L -> Reg lro=0 swapByteOffset=0 ti=128 vIdx=0 eIdx=1 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_b128 v[vgprValuB_X0_I0+12:vgprValuB_X0_I0+12+3], v[vgprLocalReadAddrB+0] offset:160 // L -> Reg lro=0 swapByteOffset=0 ti=128 vIdx=0 eIdx=1 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_b128 v[vgprValuB_X0_I0+16:vgprValuB_X0_I0+16+3], v[vgprLocalReadAddrB+0] offset:256 // L -> Reg lro=0 swapByteOffset=0 ti=128 vIdx=0 eIdx=2 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_b128 v[vgprValuB_X0_I0+20:vgprValuB_X0_I0+20+3], v[vgprLocalReadAddrB+0] offset:288 // L -> Reg lro=0 swapByteOffset=0 ti=128 vIdx=0 eIdx=2 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_b128 v[vgprValuB_X0_I0+24:vgprValuB_X0_I0+24+3], v[vgprLocalReadAddrB+0] offset:384 // L -> Reg lro=0 swapByteOffset=0 ti=128 vIdx=0 eIdx=3 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_b128 v[vgprValuB_X0_I0+28:vgprValuB_X0_I0+28+3], v[vgprLocalReadAddrB+0] offset:416 // L -> Reg lro=0 swapByteOffset=0 ti=128 vIdx=0 eIdx=3 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS0

/* local read inc a */
s_mov_b32 s5, 64                                   // inc
s_wait_alu depctr_vm_vsrc(6)
v_add_co_u32 v[vgprLocalReadAddrA+0], vcc_lo, s5, v[vgprLocalReadAddrA+0] // lrA += 64 (bpeDS)

/* local read inc mxsa */
s_mov_b32 s5, 512                                  // inc
v_add_co_u32 v[vgprLocalReadAddrMXSA+0], vcc_lo, s5, v[vgprLocalReadAddrMXSA+0] // lrMXSA += 512 (bpeDS)

/* local read inc mxsb */
                                                   // inc (dup assign opt.)
v_add_co_u32 v[vgprLocalReadAddrMXSB+0], vcc_lo, s5, v[vgprLocalReadAddrMXSB+0] // lrMXSB += 512 (bpeDS)

/* local read inc b */
s_mov_b32 s5, 64                                   // inc
s_wait_alu depctr_vm_vsrc(0)
v_add_co_u32 v[vgprLocalReadAddrB+0], vcc_lo, s5, v[vgprLocalReadAddrB+0] // lrB += 64 (bpeDS)
s_wait_dscnt 0                                     // 4wait for local read
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+0:vgprValuC+0+7], v[vgprValuA_X0_I0+0+0+0:vgprValuA_X0_I0+0+0+0+7], v[vgprValuB_X0_I0+0+0+0:vgprValuB_X0_I0+0+0+0+7], v[vgprValuC+0:vgprValuC+0+7], v[vgprValuMXSA_X0_I0+0+0+0], v[vgprValuMXSB_X0_I0+0+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[0+0:7+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+8:vgprValuC+8+7], v[vgprValuA_X0_I0+8+0+0:vgprValuA_X0_I0+8+0+0+7], v[vgprValuB_X0_I0+0+0+0:vgprValuB_X0_I0+0+0+0+7], v[vgprValuC+8:vgprValuC+8+7], v[vgprValuMXSA_X0_I0+0+0+0], v[vgprValuMXSB_X0_I0+0+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[8+0:15+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+16:vgprValuC+16+7], v[vgprValuA_X0_I0+16+0+0:vgprValuA_X0_I0+16+0+0+7], v[vgprValuB_X0_I0+0+0+0:vgprValuB_X0_I0+0+0+0+7], v[vgprValuC+16:vgprValuC+16+7], v[vgprValuMXSA_X0_I0+1+0+0], v[vgprValuMXSB_X0_I0+0+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[16+0:23+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+24:vgprValuC+24+7], v[vgprValuA_X0_I0+24+0+0:vgprValuA_X0_I0+24+0+0+7], v[vgprValuB_X0_I0+0+0+0:vgprValuB_X0_I0+0+0+0+7], v[vgprValuC+24:vgprValuC+24+7], v[vgprValuMXSA_X0_I0+1+0+0], v[vgprValuMXSB_X0_I0+0+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 // left value = v[24+0:31+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+32:vgprValuC+32+7], v[vgprValuA_X0_I0+0+0+0:vgprValuA_X0_I0+0+0+0+7], v[vgprValuB_X0_I0+8+0+0:vgprValuB_X0_I0+8+0+0+7], v[vgprValuC+32:vgprValuC+32+7], v[vgprValuMXSA_X0_I0+0+0+0], v[vgprValuMXSB_X0_I0+1+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[32+0:39+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+40:vgprValuC+40+7], v[vgprValuA_X0_I0+8+0+0:vgprValuA_X0_I0+8+0+0+7], v[vgprValuB_X0_I0+8+0+0:vgprValuB_X0_I0+8+0+0+7], v[vgprValuC+40:vgprValuC+40+7], v[vgprValuMXSA_X0_I0+0+0+0], v[vgprValuMXSB_X0_I0+1+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[40+0:47+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+48:vgprValuC+48+7], v[vgprValuA_X0_I0+16+0+0:vgprValuA_X0_I0+16+0+0+7], v[vgprValuB_X0_I0+8+0+0:vgprValuB_X0_I0+8+0+0+7], v[vgprValuC+48:vgprValuC+48+7], v[vgprValuMXSA_X0_I0+1+0+0], v[vgprValuMXSB_X0_I0+1+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[48+0:55+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+56:vgprValuC+56+7], v[vgprValuA_X0_I0+24+0+0:vgprValuA_X0_I0+24+0+0+7], v[vgprValuB_X0_I0+8+0+0:vgprValuB_X0_I0+8+0+0+7], v[vgprValuC+56:vgprValuC+56+7], v[vgprValuMXSA_X0_I0+1+0+0], v[vgprValuMXSB_X0_I0+1+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 // left value = v[56+0:63+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+64:vgprValuC+64+7], v[vgprValuA_X0_I0+0+0+0:vgprValuA_X0_I0+0+0+0+7], v[vgprValuB_X0_I0+16+0+0:vgprValuB_X0_I0+16+0+0+7], v[vgprValuC+64:vgprValuC+64+7], v[vgprValuMXSA_X0_I0+0+0+0], v[vgprValuMXSB_X0_I0+2+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[64+0:71+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+72:vgprValuC+72+7], v[vgprValuA_X0_I0+8+0+0:vgprValuA_X0_I0+8+0+0+7], v[vgprValuB_X0_I0+16+0+0:vgprValuB_X0_I0+16+0+0+7], v[vgprValuC+72:vgprValuC+72+7], v[vgprValuMXSA_X0_I0+0+0+0], v[vgprValuMXSB_X0_I0+2+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[72+0:79+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+80:vgprValuC+80+7], v[vgprValuA_X0_I0+16+0+0:vgprValuA_X0_I0+16+0+0+7], v[vgprValuB_X0_I0+16+0+0:vgprValuB_X0_I0+16+0+0+7], v[vgprValuC+80:vgprValuC+80+7], v[vgprValuMXSA_X0_I0+1+0+0], v[vgprValuMXSB_X0_I0+2+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[80+0:87+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+88:vgprValuC+88+7], v[vgprValuA_X0_I0+24+0+0:vgprValuA_X0_I0+24+0+0+7], v[vgprValuB_X0_I0+16+0+0:vgprValuB_X0_I0+16+0+0+7], v[vgprValuC+88:vgprValuC+88+7], v[vgprValuMXSA_X0_I0+1+0+0], v[vgprValuMXSB_X0_I0+2+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 // left value = v[88+0:95+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+96:vgprValuC+96+7], v[vgprValuA_X0_I0+0+0+0:vgprValuA_X0_I0+0+0+0+7], v[vgprValuB_X0_I0+24+0+0:vgprValuB_X0_I0+24+0+0+7], v[vgprValuC+96:vgprValuC+96+7], v[vgprValuMXSA_X0_I0+0+0+0], v[vgprValuMXSB_X0_I0+3+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[96+0:103+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+104:vgprValuC+104+7], v[vgprValuA_X0_I0+8+0+0:vgprValuA_X0_I0+8+0+0+7], v[vgprValuB_X0_I0+24+0+0:vgprValuB_X0_I0+24+0+0+7], v[vgprValuC+104:vgprValuC+104+7], v[vgprValuMXSA_X0_I0+0+0+0], v[vgprValuMXSB_X0_I0+3+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[104+0:111+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+112:vgprValuC+112+7], v[vgprValuA_X0_I0+16+0+0:vgprValuA_X0_I0+16+0+0+7], v[vgprValuB_X0_I0+24+0+0:vgprValuB_X0_I0+24+0+0+7], v[vgprValuC+112:vgprValuC+112+7], v[vgprValuMXSA_X0_I0+1+0+0], v[vgprValuMXSB_X0_I0+3+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_b_reuse // left value = v[112+0:119+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+120:vgprValuC+120+7], v[vgprValuA_X0_I0+24+0+0:vgprValuA_X0_I0+24+0+0+7], v[vgprValuB_X0_I0+24+0+0:vgprValuB_X0_I0+24+0+0+7], v[vgprValuC+120:vgprValuC+120+7], v[vgprValuMXSA_X0_I0+1+0+0], v[vgprValuMXSB_X0_I0+3+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 // left value = v[120+0:127+0]

/* closeLoop loopL finalLoop=1 tailLoop=1 */
s_sub_i32 s[sgprLoopCounterL], s[sgprLoopCounterL], 0x80 // dec counterL (tailLoop)
s_add_u32 s[sgprOrigLoopCounter], s[sgprOrigLoopCounter], 0x80 // inc counterL
s_cmp_le_i32 s[sgprLoopCounterL], 0x0              // counterL<=0
s_cbranch_scc0 label_TailLoopBeginL                // restart LoopL
label_TailLoopEndL:
label_SkipTailLoopL:
.set vgprValuA_X0_I0_BASE, UNDEF
.set vgprValuA_X0_I0, UNDEF
.set vgprValuA_X1_I0, UNDEF
.set vgprValuB_X0_I0_BASE, UNDEF
.set vgprValuB_X0_I0, UNDEF
.set vgprValuB_X1_I0, UNDEF

/* Tail: add MISC Vgpr [142...146) to pool */

/* Tail: add ValuA/B vgpr buffer [0...14) to pool */
label_Summation_End_L3O7KXIKNEQAJSUJ:
.set sgprWGM, UNDEF
.set sgprLoopCounterL, UNDEF
.set sgprOrigLoopCounter, UNDEF
.set sgprtdmABIncs, UNDEF
.set sgprtdmMXSAMXSBIncs, UNDEF
.set sgprStaggerUIter, UNDEF
.set sgprtdmAGroup0, UNDEF
.set sgprtdmAGroup1, UNDEF
.set sgprAddressA, UNDEF
.set sgprAddressMXSA, UNDEF
.set sgprAddressB, UNDEF
.set sgprAddressMXSB, UNDEF
.set sgprStridesA, UNDEF
.set sgprStridesMXSA, UNDEF
.set sgprStridesB, UNDEF
.set sgprStridesMXSB, UNDEF
.set sgprGlobalReadIncsA, UNDEF
.set sgprtdmAGroup2, UNDEF
.set sgprtdmMXSAGroup0, UNDEF
.set sgprtdmMXSAGroup1, UNDEF
.set sgprWrapUA, UNDEF
.set sgprWrapUB, UNDEF
.set sgprWrapUMXSA, UNDEF
.set sgprWrapUMXSB, UNDEF
.set sgprGlobalReadIncsMXSA, UNDEF
.set sgprGlobalReadIncsB, UNDEF
.set sgprGlobalReadIncsMXSB, UNDEF
/* load store sgprs */
.set sgprSrdC, 24
.set sgprSrdD, 20

/* Mapping of Acc register -> C Vgpr register */

/* Multiply MI out register with Alpha -> C Vgpr register */
s_and_b32 s5, s[sgprGSU], 0x3fff                   // Restore GSU
s_cmp_eq_u32 s5, 1                                 // GSU == 1 ?
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
s_and_b32 s5, s[sgprSrdD+2], 127
s_lshl_b32 s5, s5, 25
s_and_b32 s[sgprSrdD+1], s[sgprSrdD+1], 33554431
s_or_b32 s[sgprSrdD+1], s[sgprSrdD+1], s5
s_lshr_b32 s[sgprSrdD+2], s[sgprSrdD+2], 7

s_and_b32 s5, s[sgprGSU], 0x3fff                   // Restore GSU
s_cmp_eq_u32 s5, 1                                 // GSU == 1 ?
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
s_and_b32 s5, s[sgprSrdC+2], 127
s_lshl_b32 s5, s5, 25
s_and_b32 s[sgprSrdC+1], s[sgprSrdC+1], 33554431
s_or_b32 s[sgprSrdC+1], s[sgprSrdC+1], s5
s_lshr_b32 s[sgprSrdC+2], s[sgprSrdC+2], 7


s_mul_i32 s30, MT1, s[sgprWorkGroup1]              // <- wg1*MT1
s_and_b32 s29, s[sgprGSU], 0x3fff                  // Restore GSU
s_mul_hi_u32 s29, s30, s[sgprStrideC1J]            // ScaleC s30 by Stride
s_mul_i32 s28, s30, s[sgprStrideC1J]               // ScaleC s30 by Stride
s_lshl_b64 s[28:29], s[28:29], s[sgprGSULog2BpeC]  // scale by bpe
s_add_u32 s[sgprSrdC+0], s[sgprSrdC+0], s28        // add lo to SRD
s_addc_u32 s[sgprSrdC+1], s[sgprSrdC+1], s29       // add hi to SRD
s_and_b32 s29, s[sgprGSU], 0x3fff                  // Restore GSU
s_mul_hi_u32 s29, s30, s[sgprStrideD1J]            // ScaleD s30 by Stride
s_mul_i32 s28, s30, s[sgprStrideD1J]               // ScaleD s30 by Stride
s_lshl_b64 s[28:29], s[28:29], s[sgprGSULog2BpeD]  // scale by bpe
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s28        // add lo to SRD
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], s29       // add hi to SRD

s_and_b32 s29, s[sgprGSU], 0x3fff                  // Restore GSU
s_cmp_eq_u32 s29, 1                                // GSU == 1 ?
s_cbranch_scc0 label_StridedBatchedGemmLoadC
s_cmp_eq_u32 s[sgprArgType], 3                     // ArgType == 3 for General Batched GEMM
s_cbranch_scc1 label_GeneralBatchedGemmLoadC
label_StridedBatchedGemmLoadC:  /// Computing the Batch Matrix's base address for Strided Batched GEMM
s_mul_hi_u32 s29, s[sgprWorkGroup2], s[sgprStrideCK] // ScaleC s[sgprWorkGroup2] by Stride
s_mul_i32 s28, s[sgprWorkGroup2], s[sgprStrideCK]  // ScaleC s[sgprWorkGroup2] by Stride
s_lshl_b64 s[28:29], s[28:29], s[sgprGSULog2BpeC]  // scale by bpe
s_add_u32 s[sgprSrdC+0], s[sgprSrdC+0], s28        // add lo to SRD
s_addc_u32 s[sgprSrdC+1], s[sgprSrdC+1], s29       // add hi to SRD
s_branch label_GeneralBatchedGemmLoadC_End
label_GeneralBatchedGemmLoadC:  /// Computing the Batch Matrix's base address for General Batched GEMM
s_mul_i32 s28, 8, s[sgprWorkGroup2]                // Compute stride in bytes into Pointer Array
s_add_u32 s28, s28, s[sgprAddressC+0]              // Offsetting to the location [Lower half of address]
s_addc_u32 s29, s[sgprAddressC+1], 0               // Offsetting to the location [Higher half of address]
s_load_b64 s[30:31], s[28:29], 0                   // Load the Matrix Address in the Pointer Array
s_wait_kmcnt 0                                     // Wait for the Matrix Address Load from the Pointer Array
s_add_u32 s[sgprSrdC+0], s[sgprSrdC+0], s30        // Offsetting within the Batch Matrix [Lower half of address]
s_addc_u32 s[sgprSrdC+1], s[sgprSrdC+1], s31       // Offsetting within the Batch Matrix [Higher half of address]
label_GeneralBatchedGemmLoadC_End:  /// End of label GeneralBatchedGemmLoadC
s_and_b32 s29, s[sgprGSU], 0x3fff                  // Restore GSU
s_cmp_eq_u32 s29, 1                                // GSU == 1 ?
s_cbranch_scc0 label_StridedBatchedGemmLoadD
s_cmp_eq_u32 s[sgprArgType], 3                     // ArgType == 3 for General Batched GEMM
s_cbranch_scc1 label_GeneralBatchedGemmLoadD
label_StridedBatchedGemmLoadD:  /// Computing the Batch Matrix's base address for Strided Batched GEMM
s_mul_hi_u32 s29, s[sgprWorkGroup2], s[sgprStrideDK] // ScaleD s[sgprWorkGroup2] by Stride
s_mul_i32 s28, s[sgprWorkGroup2], s[sgprStrideDK]  // ScaleD s[sgprWorkGroup2] by Stride
s_lshl_b64 s[28:29], s[28:29], s[sgprGSULog2BpeD]  // scale by bpe
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s28        // add lo to SRD
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], s29       // add hi to SRD
s_branch label_GeneralBatchedGemmLoadD_End
label_GeneralBatchedGemmLoadD:  /// Computing the Batch Matrix's base address for General Batched GEMM
s_mul_i32 s28, 8, s[sgprWorkGroup2]                // Compute stride in bytes into Pointer Array
s_add_u32 s28, s28, s[sgprAddressD+0]              // Offsetting to the location [Lower half of address]
s_addc_u32 s29, s[sgprAddressD+1], 0               // Offsetting to the location [Higher half of address]
s_load_b64 s[30:31], s[28:29], 0                   // Load the Matrix Address in the Pointer Array
s_wait_kmcnt 0                                     // Wait for the Matrix Address Load from the Pointer Array
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s30        // Offsetting within the Batch Matrix [Lower half of address]
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], s31       // Offsetting within the Batch Matrix [Higher half of address]
label_GeneralBatchedGemmLoadD_End:  /// End of label GeneralBatchedGemmLoadD

s_and_b32 s5, s[sgprGSU], 0x3fff                   // Restore GSU
s_cmp_eq_u32 s5, 1                                 // GSU == 1 ?
s_cbranch_scc1 label_GSU_3                         // branch if GSU == 1
// GSU Output Buffer offset: Free0 + (Free1-1)*StrideC1J + (Free2-1)*StrideCK * GSUIdx * bpe%s
s_mul_hi_u32 s29, s[sgprSizesFree+0], s[sgprGSUSumIdx] // Free0
s_mul_i32 s28, s[sgprSizesFree+0], s[sgprGSUSumIdx] // Free0
s_sub_u32 s30, s[sgprSizesFree+1], 1               // Free1
s_mul_i32 s30, s30, s[sgprGSUSumIdx]               // Free1
s_mul_hi_u32 s31, s30, s[sgprStrideC1J]            // Free1
s_mul_i32 s30, s30, s[sgprStrideC1J]               // Free1
s_add_u32 s28, s28, s30                            // Free1
s_addc_u32 s29, s29, s31                           // Free1
s_sub_u32 s30, s[sgprSizesFree+2], 1               // Free2
s_mul_i32 s30, s30, s[sgprGSUSumIdx]               // Free2
s_mul_hi_u32 s31, s30, s[sgprStrideCK]             // Free2
s_mul_i32 s30, s30, s[sgprStrideCK]                // Free2
s_add_u32 s28, s28, s30                            // Free2
s_addc_u32 s29, s29, s31                           // Free2
s_lshl_b64 s[28:29], s[28:29], 2                   // scale by bpe
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s28        // add lo GSU offset to SRD
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], s29       // add hi GSU offset to SRD
label_GSU_3:
.set sgprGSULog2BpeC, UNDEF
.set sgprAddressC, UNDEF

/* not-LocalSplitU: global write indices */
/* computeStoreVgprs */
s_nop 0
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_lshrrev_b32 v4, 5, v[vgprSerial-256]             // 4 = Serial / 32
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_lshrrev_b32 v5, 1, v4                            // 5 = 4 / 2
v_lshlrev_b32 v1, 4, v5                            // wave coordination offset 1
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_and_b32 v5, 15, v[vgprSerial-256]                // v5 = v[vgprSerial-256] % 16
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_add_lshl_u32 v1, v5, v1, 2                       // coordination 1 = vwB *(wave_id1 + tid1)
v_mul_lo_u32 v2, v1, s[sgprStrideC1J]              //  offset 1
v_mul_lo_u32 v3, v1, s[sgprStrideD1J]              //  offset 1
v_and_b32 v5, 1, v4                                // v5 = v4 % 2
v_lshlrev_b32 v5, 4, v5                            // wave coordination offset 0
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_and_b32 v0, 31, v[vgprSerial-256]                // v0 = v[vgprSerial-256] % 32
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_lshrrev_b32 v0, 4, v0                            // 0 = 0 / 16
v_lshlrev_b32 v0, 3, v0                            // thread0 * continuous_output
v_add_lshl_u32 v0, v5, v0, 0                       // coordination 0 = vwA *(wave_id0 + tid0)
s_mul_i32 s5, 128, s[sgprWorkGroup0]               // wgp0 * MT0
v_add_nc_u32 v0, s5, v0                            // coord 0 = (tid0/MI_m)*4 + waveG0*MIB_m + MT0*SG0
s_mul_i32 s5, 128, s[sgprWorkGroup1]               // wgp1 * MT1
v_add_nc_u32 v1, s5, v1                            // coord 1 = (tid0%MI_m) + waveG1*MIB_n + MT1*SG1

/* not-LocalSplitU: global write */

/******************************************/
/* Global Write Elements                  */
/******************************************/
s_and_b32 s5, s[sgprGSU], 0x3fff                   // Restore GSU
s_cmp_eq_u32 s5, 1                                 // GSU == 1 ?
s_cbranch_scc1 label_GSU_4                         // branch if GSU == 1
label_GW_B0_MB:
label_GW_B0_FD0_MB:

/* Edge/NonEdge store path check (M): Size % 128 > 0 -> Edge store; else -> NonEdge store */
s_and_b32 s28, 127, s[sgprSizeI]                   // s28 = s[sgprSizeI] % 128
s_add_u32 s29, -0x1, s[sgprNumWorkGroups0]
s_cmp_ge_u32 s[sgprWorkGroup0], s29                // wg0 >= nwg0-1 ?
s_cselect_b32 s28, s28, 0                          // set rem
s_mov_b32 s5, 0
s_cmp_gt_u32 s28, s5                               // rem > 0
s_cbranch_scc1 label_GW_B0_FD0_VW8_MB_Else         // jump if edges required

/* Edge/NonEdge store path check (N (isSize1)): Size % 128 > 0 -> Edge store; else -> NonEdge store */
s_and_b32 s28, 127, s[sgprSizeJ]                   // s28 = s[sgprSizeJ] % 128
s_add_u32 s29, -0x1, s[sgprNumWorkGroups1]
s_cmp_ge_u32 s[sgprWorkGroup1], s29                // wg1 >= nwg1-1
s_cselect_b32 s28, s28, 0                          // set rem
s_mov_b32 s5, 0
s_cmp_gt_u32 s28, s5                               // rem > 0
s_cbranch_scc1 label_GW_B0_FD0_VW8_MB_Then         // jump if edges required
label_GW_B0_FD0_VW8_MB_NonEdge:

/* edge=0, allocate 1 sgpr. perBatchTmpS=1 perBatchMaskS=0 perElementMaskS=0 elementsPerBatch=66 */
/* optSingleColVgpr=1 optSharedColVgpr=0 optSGPRUsage=BufferLoad_Mask optSrdIncForRow=1 factorDim=0 */

/******************************************/
/* Global Write Batch #0 (d1,d0,vc1,vc0) = */
/*    (0,0,0,0:vw8); (0,1,0,0:vw8); (0,2,0,0:vw8); (0,3,0,0:vw8); (0,0,1,0:vw8); (0,1,1,0:vw8); (0,2,1,0:vw8); (0,3,1,0:vw8); (0,0,2,0:vw8); (0,1,2,0:vw8); (0,2,2,0:vw8); (0,3,2,0:vw8); (0,0,3,0:vw8); (0,1,3,0:vw8); (0,2,3,0:vw8); (0,3,3,0:vw8) */
/******************************************/

/* calc coords, apply mask, and issue loads (if necessary) */
/* (d1,vc1,d0,vc0)=(0,0,0,0) */
/* (d1,vc1,d0,vc0)=(0,0,1,0) */
/* (d1,vc1,d0,vc0)=(0,0,2,0) */
/* (d1,vc1,d0,vc0)=(0,0,3,0) */
/* (d1,vc1,d0,vc0)=(0,1,0,0) */
/* (d1,vc1,d0,vc0)=(0,1,1,0) */
/* (d1,vc1,d0,vc0)=(0,1,2,0) */
/* (d1,vc1,d0,vc0)=(0,1,3,0) */
/* (d1,vc1,d0,vc0)=(0,2,0,0) */
/* (d1,vc1,d0,vc0)=(0,2,1,0) */
/* (d1,vc1,d0,vc0)=(0,2,2,0) */
/* (d1,vc1,d0,vc0)=(0,2,3,0) */
/* (d1,vc1,d0,vc0)=(0,3,0,0) */
/* (d1,vc1,d0,vc0)=(0,3,1,0) */
/* (d1,vc1,d0,vc0)=(0,3,2,0) */
/* (d1,vc1,d0,vc0)=(0,3,3,0) */
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_add_lshl_u32 v7, v3, v0, 2                       // optSingleColVgpr scaleToBpe: sharedAddrVgpr <- cinRowPtr + coord0, scaled by BPE. BSHERE:coord0=0, coord0Vgpr=0 (multiple bpe)

/* rC *= alpha batchElements=[(0, 0, 0, 0), (0, 1, 0, 0), (0, 2, 0, 0), (0, 3, 0, 0), (0, 0, 1, 0), (0, 1, 1, 0), (0, 2, 1, 0), (0, 3, 1, 0), (0, 0, 2, 0), (0, 1, 2, 0), (0, 2, 2, 0), (0, 3, 2, 0), (0, 0, 3, 0), (0, 1, 3, 0), (0, 2, 3, 0), (0, 3, 3, 0)] */
v_mov_b32 v[vgprValuC+130], v[vgprValuC+0]         // Rearrange MI out reg
v_mov_b32 v[vgprValuC+131], v[vgprValuC+1]         // Rearrange MI out reg
v_mov_b32 v[vgprValuC+132], v[vgprValuC+2]         // Rearrange MI out reg
v_mov_b32 v[vgprValuC+133], v[vgprValuC+3]         // Rearrange MI out reg
v_mov_b32 v[vgprValuC+134], v[vgprValuC+4]         // Rearrange MI out reg
v_mov_b32 v[vgprValuC+135], v[vgprValuC+5]         // Rearrange MI out reg
v_mov_b32 v[vgprValuC+136], v[vgprValuC+6]         // Rearrange MI out reg
v_mov_b32 v[vgprValuC+137], v[vgprValuC+7]         // Rearrange MI out reg
v_mov_b32 v[vgprValuC+138], v[vgprValuC+8]         // Rearrange MI out reg
v_mov_b32 v[vgprValuC+139], v[vgprValuC+9]         // Rearrange MI out reg
v_mov_b32 v[vgprValuC+140], v[vgprValuC+10]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+141], v[vgprValuC+11]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+142], v[vgprValuC+12]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+143], v[vgprValuC+13]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+144], v[vgprValuC+14]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+145], v[vgprValuC+15]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+146], v[vgprValuC+16]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+147], v[vgprValuC+17]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+148], v[vgprValuC+18]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+149], v[vgprValuC+19]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+150], v[vgprValuC+20]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+151], v[vgprValuC+21]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+152], v[vgprValuC+22]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+153], v[vgprValuC+23]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+154], v[vgprValuC+24]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+155], v[vgprValuC+25]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+156], v[vgprValuC+26]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+157], v[vgprValuC+27]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+158], v[vgprValuC+28]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+159], v[vgprValuC+29]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+160], v[vgprValuC+30]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+161], v[vgprValuC+31]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+162], v[vgprValuC+32]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+163], v[vgprValuC+33]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+164], v[vgprValuC+34]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+165], v[vgprValuC+35]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+166], v[vgprValuC+36]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+167], v[vgprValuC+37]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+168], v[vgprValuC+38]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+169], v[vgprValuC+39]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+170], v[vgprValuC+40]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+171], v[vgprValuC+41]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+172], v[vgprValuC+42]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+173], v[vgprValuC+43]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+174], v[vgprValuC+44]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+175], v[vgprValuC+45]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+176], v[vgprValuC+46]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+177], v[vgprValuC+47]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+178], v[vgprValuC+48]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+179], v[vgprValuC+49]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+180], v[vgprValuC+50]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+181], v[vgprValuC+51]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+182], v[vgprValuC+52]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+183], v[vgprValuC+53]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+184], v[vgprValuC+54]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+185], v[vgprValuC+55]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+186], v[vgprValuC+56]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+187], v[vgprValuC+57]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+188], v[vgprValuC+58]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+189], v[vgprValuC+59]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+190], v[vgprValuC+60]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+191], v[vgprValuC+61]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+192], v[vgprValuC+62]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+193], v[vgprValuC+63]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+194], v[vgprValuC+64]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+195], v[vgprValuC+65]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+196], v[vgprValuC+66]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+197], v[vgprValuC+67]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+198], v[vgprValuC+68]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+199], v[vgprValuC+69]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+200], v[vgprValuC+70]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+201], v[vgprValuC+71]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+202], v[vgprValuC+72]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+203], v[vgprValuC+73]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+204], v[vgprValuC+74]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+205], v[vgprValuC+75]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+206], v[vgprValuC+76]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+207], v[vgprValuC+77]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+208], v[vgprValuC+78]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+209], v[vgprValuC+79]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+210], v[vgprValuC+80]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+211], v[vgprValuC+81]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+212], v[vgprValuC+82]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+213], v[vgprValuC+83]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+214], v[vgprValuC+84]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+215], v[vgprValuC+85]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+216], v[vgprValuC+86]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+217], v[vgprValuC+87]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+218], v[vgprValuC+88]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+219], v[vgprValuC+89]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+220], v[vgprValuC+90]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+221], v[vgprValuC+91]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+222], v[vgprValuC+92]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+223], v[vgprValuC+93]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+224], v[vgprValuC+94]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+225], v[vgprValuC+95]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+226], v[vgprValuC+96]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+227], v[vgprValuC+97]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+228], v[vgprValuC+98]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+229], v[vgprValuC+99]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+230], v[vgprValuC+100]       // Rearrange MI out reg
v_mov_b32 v[vgprValuC+231], v[vgprValuC+101]       // Rearrange MI out reg
v_mov_b32 v[vgprValuC+232], v[vgprValuC+102]       // Rearrange MI out reg
v_mov_b32 v[vgprValuC+233], v[vgprValuC+103]       // Rearrange MI out reg
v_mov_b32 v[vgprValuC+234], v[vgprValuC+104]       // Rearrange MI out reg
v_mov_b32 v[vgprValuC+235], v[vgprValuC+105]       // Rearrange MI out reg
v_mov_b32 v[vgprValuC+236], v[vgprValuC+106]       // Rearrange MI out reg
v_mov_b32 v[vgprValuC+237], v[vgprValuC+107]       // Rearrange MI out reg
v_mov_b32 v[vgprValuC+238], v[vgprValuC+108]       // Rearrange MI out reg
v_mov_b32 v[vgprValuC+239], v[vgprValuC+109]       // Rearrange MI out reg
v_mov_b32 v[vgprValuC+240], v[vgprValuC+110]       // Rearrange MI out reg
v_mov_b32 v[vgprValuC+241], v[vgprValuC+111]       // Rearrange MI out reg
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_mov_b32 v[vgprValuC+242-256], v[vgprValuC+112]   // Rearrange MI out reg
v_mov_b32 v[vgprValuC+243-256], v[vgprValuC+113]   // Rearrange MI out reg
v_mov_b32 v[vgprValuC+244-256], v[vgprValuC+114]   // Rearrange MI out reg
v_mov_b32 v[vgprValuC+245-256], v[vgprValuC+115]   // Rearrange MI out reg
v_mov_b32 v[vgprValuC+246-256], v[vgprValuC+116]   // Rearrange MI out reg
v_mov_b32 v[vgprValuC+247-256], v[vgprValuC+117]   // Rearrange MI out reg
v_mov_b32 v[vgprValuC+248-256], v[vgprValuC+118]   // Rearrange MI out reg
v_mov_b32 v[vgprValuC+249-256], v[vgprValuC+119]   // Rearrange MI out reg
v_mov_b32 v[vgprValuC+250-256], v[vgprValuC+120]   // Rearrange MI out reg
v_mov_b32 v[vgprValuC+251-256], v[vgprValuC+121]   // Rearrange MI out reg
v_mov_b32 v[vgprValuC+252-256], v[vgprValuC+122]   // Rearrange MI out reg
v_mov_b32 v[vgprValuC+253-256], v[vgprValuC+123]   // Rearrange MI out reg
v_mov_b32 v[vgprValuC+254-256], v[vgprValuC+124]   // Rearrange MI out reg
v_mov_b32 v[vgprValuC+255-256], v[vgprValuC+125]   // Rearrange MI out reg
v_mov_b32 v[vgprValuC+256-256], v[vgprValuC+126]   // Rearrange MI out reg
v_mov_b32 v[vgprValuC+257-256], v[vgprValuC+127]   // Rearrange MI out reg

/* apply mask, calc new C and issue writes */
s_set_vgpr_msb 16384                               // src0: 0, src1: 0, src2: 0, dst: 0
s_wait_alu depctr_va_vdst(14)
buffer_store_b128 v[144:147], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[148:151], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:16 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[152:155], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:128 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[156:159], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:144 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[160:163], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:256 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[164:167], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:272 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[168:171], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:384 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[172:175], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:400 scope:SCOPE_CU th:TH_STORE_RT // store D
s_lshl_b32 s12, s[sgprStrideD1J], 2                // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_store_b128 v[176:179], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[180:183], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:16 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[184:187], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:128 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[188:191], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:144 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[192:195], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:256 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[196:199], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:272 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[200:203], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:384 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[204:207], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:400 scope:SCOPE_CU th:TH_STORE_RT // store D
s_lshl_b32 s12, s[sgprStrideD1J], 2                // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_store_b128 v[208:211], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[212:215], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:16 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[216:219], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:128 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[220:223], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:144 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[224:227], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:256 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[228:231], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:272 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[232:235], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:384 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[236:239], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:400 scope:SCOPE_CU th:TH_STORE_RT // store D
s_lshl_b32 s12, s[sgprStrideD1J], 2                // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_store_b128 v[240:243], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[244:247], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:16 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[248:251], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:128 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[252:255], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:144 scope:SCOPE_CU th:TH_STORE_RT // store D
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(12)
buffer_store_b128 v[256-256:259-256], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:256 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(8)
buffer_store_b128 v[260-256:263-256], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:272 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(4)
buffer_store_b128 v[264-256:267-256], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:384 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(0)
buffer_store_b128 v[268-256:271-256], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:400 scope:SCOPE_CU th:TH_STORE_RT // store D
s_nop 0                                            // 1 wait state required when next inst writes vgprs held by previous dwordx4 store inst
s_branch label_GW_End                              // jump to end
label_GW_B0_FD0_VW8_MB_NonEdgeEnd:
label_GW_B0_FD0_VW8_MB_Then:

/* edge=1, allocate 3 sgpr. perBatchTmpS=2 perBatchMaskS=1 perElementMaskS=0 elementsPerBatch=58 */
/* optSingleColVgpr=0 optSharedColVgpr=0 optSGPRUsage=BufferLoad_Edge_Mask optSrdIncForRow=0 factorDim=0 */

/******************************************/
/* Global Write Edge Batch #0 (d1,d0,vc1,vc0) = */
/*    (0,0,0,0:vw8); (0,1,0,0:vw8); (0,2,0,0:vw8); (0,3,0,0:vw8); (0,0,1,0:vw8); (0,1,1,0:vw8); (0,2,1,0:vw8); (0,3,1,0:vw8); (0,0,2,0:vw8); (0,1,2,0:vw8); (0,2,2,0:vw8); (0,3,2,0:vw8); (0,0,3,0:vw8); (0,1,3,0:vw8); (0,2,3,0:vw8); (0,3,3,0:vw8) */
/******************************************/

/* calc coords, apply mask, and issue loads (if necessary) */
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v6, BufferOOB
/* (d1,vc1,d0,vc0)=(0,0,0,0) */
v_cmp_lt_u32 s12, v0, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v7, v3, v0, 2                       // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v7, v6, v7, s14                      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,1,0) */
v_add_co_u32 v4, vcc_lo, v0, 32                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v8, v3, v4, 2                       // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v8, v6, v8, s14                      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,2,0) */
v_add_co_u32 v4, vcc_lo, v0, 64                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v9, v3, v4, 2                       // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v9, v6, v9, s14                      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,3,0) */
s_mov_b32 s12, 96                                  // coordOffset0 d0=3 vc0=0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v10, v3, v4, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v10, v6, v10, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,0,0) */
v_add_co_u32 v1, vcc_lo, v1, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v2, v2, s[sgprStrideC1J]              // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v3, v3, s[sgprStrideD1J]              // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v0, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v11, v3, v0, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v11, v6, v11, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,1,0) */
v_add_co_u32 v4, vcc_lo, v0, 32                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v12, v3, v4, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v12, v6, v12, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,2,0) */
v_add_co_u32 v4, vcc_lo, v0, 64                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v13, v3, v4, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v13, v6, v13, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,3,0) */
s_mov_b32 s12, 96                                  // coordOffset0 d0=3 vc0=0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v142, v3, v4, 2                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v142, v6, v142, s14                  // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,0,0) */
v_add_co_u32 v1, vcc_lo, v1, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v2, v2, s[sgprStrideC1J]              // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v3, v3, s[sgprStrideD1J]              // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v0, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v143, v3, v0, 2                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v143, v6, v143, s14                  // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,1,0) */
v_add_co_u32 v4, vcc_lo, v0, 32                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[272-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[272-256], v6, v[272-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,2,0) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 64                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[273-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[273-256], v6, v[273-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,3,0) */
s_mov_b32 s12, 96                                  // coordOffset0 d0=3 vc0=0
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[274-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[274-256], v6, v[274-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,0,0) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v1, vcc_lo, v1, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v2, v2, s[sgprStrideC1J]              // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v3, v3, s[sgprStrideD1J]              // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v0, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[275-256], v3, v0, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[275-256], v6, v[275-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,1,0) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 32                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[277-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[277-256], v6, v[277-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,2,0) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 64                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[278-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[278-256], v6, v[278-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,3,0) */
s_mov_b32 s12, 96                                  // coordOffset0 d0=3 vc0=0
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[279-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[279-256], v6, v[279-256], s14      // LDD clip if OOB. offset

/* rC *= alpha batchElements=[(0, 0, 0, 0), (0, 1, 0, 0), (0, 2, 0, 0), (0, 3, 0, 0), (0, 0, 1, 0), (0, 1, 1, 0), (0, 2, 1, 0), (0, 3, 1, 0), (0, 0, 2, 0), (0, 1, 2, 0), (0, 2, 2, 0), (0, 3, 2, 0), (0, 0, 3, 0), (0, 1, 3, 0), (0, 2, 3, 0), (0, 3, 3, 0)] */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v[vgprValuC+130], v[vgprValuC+0]         // Rearrange MI out reg
v_mov_b32 v[vgprValuC+131], v[vgprValuC+1]         // Rearrange MI out reg
v_mov_b32 v[vgprValuC+132], v[vgprValuC+2]         // Rearrange MI out reg
v_mov_b32 v[vgprValuC+133], v[vgprValuC+3]         // Rearrange MI out reg
v_mov_b32 v[vgprValuC+134], v[vgprValuC+4]         // Rearrange MI out reg
v_mov_b32 v[vgprValuC+135], v[vgprValuC+5]         // Rearrange MI out reg
v_mov_b32 v[vgprValuC+136], v[vgprValuC+6]         // Rearrange MI out reg
v_mov_b32 v[vgprValuC+137], v[vgprValuC+7]         // Rearrange MI out reg
v_mov_b32 v[vgprValuC+138], v[vgprValuC+8]         // Rearrange MI out reg
v_mov_b32 v[vgprValuC+139], v[vgprValuC+9]         // Rearrange MI out reg
v_mov_b32 v[vgprValuC+140], v[vgprValuC+10]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+141], v[vgprValuC+11]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+142], v[vgprValuC+12]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+143], v[vgprValuC+13]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+144], v[vgprValuC+14]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+145], v[vgprValuC+15]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+146], v[vgprValuC+16]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+147], v[vgprValuC+17]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+148], v[vgprValuC+18]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+149], v[vgprValuC+19]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+150], v[vgprValuC+20]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+151], v[vgprValuC+21]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+152], v[vgprValuC+22]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+153], v[vgprValuC+23]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+154], v[vgprValuC+24]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+155], v[vgprValuC+25]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+156], v[vgprValuC+26]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+157], v[vgprValuC+27]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+158], v[vgprValuC+28]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+159], v[vgprValuC+29]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+160], v[vgprValuC+30]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+161], v[vgprValuC+31]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+162], v[vgprValuC+32]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+163], v[vgprValuC+33]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+164], v[vgprValuC+34]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+165], v[vgprValuC+35]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+166], v[vgprValuC+36]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+167], v[vgprValuC+37]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+168], v[vgprValuC+38]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+169], v[vgprValuC+39]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+170], v[vgprValuC+40]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+171], v[vgprValuC+41]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+172], v[vgprValuC+42]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+173], v[vgprValuC+43]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+174], v[vgprValuC+44]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+175], v[vgprValuC+45]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+176], v[vgprValuC+46]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+177], v[vgprValuC+47]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+178], v[vgprValuC+48]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+179], v[vgprValuC+49]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+180], v[vgprValuC+50]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+181], v[vgprValuC+51]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+182], v[vgprValuC+52]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+183], v[vgprValuC+53]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+184], v[vgprValuC+54]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+185], v[vgprValuC+55]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+186], v[vgprValuC+56]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+187], v[vgprValuC+57]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+188], v[vgprValuC+58]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+189], v[vgprValuC+59]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+190], v[vgprValuC+60]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+191], v[vgprValuC+61]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+192], v[vgprValuC+62]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+193], v[vgprValuC+63]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+194], v[vgprValuC+64]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+195], v[vgprValuC+65]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+196], v[vgprValuC+66]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+197], v[vgprValuC+67]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+198], v[vgprValuC+68]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+199], v[vgprValuC+69]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+200], v[vgprValuC+70]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+201], v[vgprValuC+71]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+202], v[vgprValuC+72]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+203], v[vgprValuC+73]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+204], v[vgprValuC+74]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+205], v[vgprValuC+75]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+206], v[vgprValuC+76]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+207], v[vgprValuC+77]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+208], v[vgprValuC+78]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+209], v[vgprValuC+79]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+210], v[vgprValuC+80]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+211], v[vgprValuC+81]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+212], v[vgprValuC+82]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+213], v[vgprValuC+83]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+214], v[vgprValuC+84]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+215], v[vgprValuC+85]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+216], v[vgprValuC+86]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+217], v[vgprValuC+87]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+218], v[vgprValuC+88]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+219], v[vgprValuC+89]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+220], v[vgprValuC+90]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+221], v[vgprValuC+91]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+222], v[vgprValuC+92]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+223], v[vgprValuC+93]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+224], v[vgprValuC+94]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+225], v[vgprValuC+95]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+226], v[vgprValuC+96]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+227], v[vgprValuC+97]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+228], v[vgprValuC+98]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+229], v[vgprValuC+99]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+230], v[vgprValuC+100]       // Rearrange MI out reg
v_mov_b32 v[vgprValuC+231], v[vgprValuC+101]       // Rearrange MI out reg
v_mov_b32 v[vgprValuC+232], v[vgprValuC+102]       // Rearrange MI out reg
v_mov_b32 v[vgprValuC+233], v[vgprValuC+103]       // Rearrange MI out reg
v_mov_b32 v[vgprValuC+234], v[vgprValuC+104]       // Rearrange MI out reg
v_mov_b32 v[vgprValuC+235], v[vgprValuC+105]       // Rearrange MI out reg
v_mov_b32 v[vgprValuC+236], v[vgprValuC+106]       // Rearrange MI out reg
v_mov_b32 v[vgprValuC+237], v[vgprValuC+107]       // Rearrange MI out reg
v_mov_b32 v[vgprValuC+238], v[vgprValuC+108]       // Rearrange MI out reg
v_mov_b32 v[vgprValuC+239], v[vgprValuC+109]       // Rearrange MI out reg
v_mov_b32 v[vgprValuC+240], v[vgprValuC+110]       // Rearrange MI out reg
v_mov_b32 v[vgprValuC+241], v[vgprValuC+111]       // Rearrange MI out reg
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_mov_b32 v[vgprValuC+242-256], v[vgprValuC+112]   // Rearrange MI out reg
v_mov_b32 v[vgprValuC+243-256], v[vgprValuC+113]   // Rearrange MI out reg
v_mov_b32 v[vgprValuC+244-256], v[vgprValuC+114]   // Rearrange MI out reg
v_mov_b32 v[vgprValuC+245-256], v[vgprValuC+115]   // Rearrange MI out reg
v_mov_b32 v[vgprValuC+246-256], v[vgprValuC+116]   // Rearrange MI out reg
v_mov_b32 v[vgprValuC+247-256], v[vgprValuC+117]   // Rearrange MI out reg
v_mov_b32 v[vgprValuC+248-256], v[vgprValuC+118]   // Rearrange MI out reg
v_mov_b32 v[vgprValuC+249-256], v[vgprValuC+119]   // Rearrange MI out reg
v_mov_b32 v[vgprValuC+250-256], v[vgprValuC+120]   // Rearrange MI out reg
v_mov_b32 v[vgprValuC+251-256], v[vgprValuC+121]   // Rearrange MI out reg
v_mov_b32 v[vgprValuC+252-256], v[vgprValuC+122]   // Rearrange MI out reg
v_mov_b32 v[vgprValuC+253-256], v[vgprValuC+123]   // Rearrange MI out reg
v_mov_b32 v[vgprValuC+254-256], v[vgprValuC+124]   // Rearrange MI out reg
v_mov_b32 v[vgprValuC+255-256], v[vgprValuC+125]   // Rearrange MI out reg
v_mov_b32 v[vgprValuC+256-256], v[vgprValuC+126]   // Rearrange MI out reg
v_mov_b32 v[vgprValuC+257-256], v[vgprValuC+127]   // Rearrange MI out reg

/* apply mask, calc new C and issue writes */
s_set_vgpr_msb 16384                               // src0: 0, src1: 0, src2: 0, dst: 0
s_wait_alu depctr_va_vdst(14)
buffer_store_b128 v[144:147], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[148:151], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:16 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[152:155], v8, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[156:159], v8, s[sgprSrdD:sgprSrdD+3], null offen offset:16 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[160:163], v9, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[164:167], v9, s[sgprSrdD:sgprSrdD+3], null offen offset:16 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[168:171], v10, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[172:175], v10, s[sgprSrdD:sgprSrdD+3], null offen offset:16 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[176:179], v11, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[180:183], v11, s[sgprSrdD:sgprSrdD+3], null offen offset:16 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[184:187], v12, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[188:191], v12, s[sgprSrdD:sgprSrdD+3], null offen offset:16 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[192:195], v13, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[196:199], v13, s[sgprSrdD:sgprSrdD+3], null offen offset:16 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[200:203], v142, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[204:207], v142, s[sgprSrdD:sgprSrdD+3], null offen offset:16 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[208:211], v143, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[212:215], v143, s[sgprSrdD:sgprSrdD+3], null offen offset:16 scope:SCOPE_CU th:TH_STORE_RT // store D
s_set_vgpr_msb 1                                   // src0: 1, src1: 0, src2: 0, dst: 0
buffer_store_b128 v[216:219], v[272-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[220:223], v[272-256], s[sgprSrdD:sgprSrdD+3], null offen offset:16 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[224:227], v[273-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[228:231], v[273-256], s[sgprSrdD:sgprSrdD+3], null offen offset:16 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[232:235], v[274-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[236:239], v[274-256], s[sgprSrdD:sgprSrdD+3], null offen offset:16 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[240:243], v[275-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[244:247], v[275-256], s[sgprSrdD:sgprSrdD+3], null offen offset:16 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[248:251], v[277-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[252:255], v[277-256], s[sgprSrdD:sgprSrdD+3], null offen offset:16 scope:SCOPE_CU th:TH_STORE_RT // store D
s_set_vgpr_msb 321                                 // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(12)
buffer_store_b128 v[256-256:259-256], v[278-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(8)
buffer_store_b128 v[260-256:263-256], v[278-256], s[sgprSrdD:sgprSrdD+3], null offen offset:16 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(4)
buffer_store_b128 v[264-256:267-256], v[279-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(0)
buffer_store_b128 v[268-256:271-256], v[279-256], s[sgprSrdD:sgprSrdD+3], null offen offset:16 scope:SCOPE_CU th:TH_STORE_RT // store D
s_nop 0                                            // 1 wait state required when next inst writes vgprs held by previous dwordx4 store inst
s_branch label_GW_End                              // jump to end
label_GW_B0_FD0_VW8_MB_Else:
label_GW_B0_FD0_VW1_MB_Else:
label_GW_B0_FD0_VW1_MB_Then:

/* edge=1, allocate 3 sgpr. perBatchTmpS=2 perBatchMaskS=1 perElementMaskS=0 elementsPerBatch=271 */
/* optSingleColVgpr=0 optSharedColVgpr=0 optSGPRUsage=BufferLoad_Edge_Mask optSrdIncForRow=0 factorDim=0 */

/******************************************/
/* Global Write Edge Batch #0 (d1,d0,vc1,vc0) = */
/*    (0,0,0,0:vw1); (0,0,0,1:vw1); (0,0,0,2:vw1); (0,0,0,3:vw1); (0,0,0,4:vw1); (0,0,0,5:vw1); (0,0,0,6:vw1); (0,0,0,7:vw1); (0,1,0,0:vw1); (0,1,0,1:vw1); (0,1,0,2:vw1); (0,1,0,3:vw1); (0,1,0,4:vw1); (0,1,0,5:vw1); (0,1,0,6:vw1); (0,1,0,7:vw1); (0,2,0,0:vw1); (0,2,0,1:vw1); (0,2,0,2:vw1); (0,2,0,3:vw1); (0,2,0,4:vw1); (0,2,0,5:vw1); (0,2,0,6:vw1); (0,2,0,7:vw1); (0,3,0,0:vw1); (0,3,0,1:vw1); (0,3,0,2:vw1); (0,3,0,3:vw1); (0,3,0,4:vw1); (0,3,0,5:vw1); (0,3,0,6:vw1); (0,3,0,7:vw1); (0,0,1,0:vw1); (0,0,1,1:vw1); (0,0,1,2:vw1); (0,0,1,3:vw1); (0,0,1,4:vw1); (0,0,1,5:vw1); (0,0,1,6:vw1); (0,0,1,7:vw1); (0,1,1,0:vw1); (0,1,1,1:vw1); (0,1,1,2:vw1); (0,1,1,3:vw1); (0,1,1,4:vw1); (0,1,1,5:vw1); (0,1,1,6:vw1); (0,1,1,7:vw1); (0,2,1,0:vw1); (0,2,1,1:vw1); (0,2,1,2:vw1); (0,2,1,3:vw1); (0,2,1,4:vw1); (0,2,1,5:vw1); (0,2,1,6:vw1); (0,2,1,7:vw1); (0,3,1,0:vw1); (0,3,1,1:vw1); (0,3,1,2:vw1); (0,3,1,3:vw1); (0,3,1,4:vw1); (0,3,1,5:vw1); (0,3,1,6:vw1); (0,3,1,7:vw1); (0,0,2,0:vw1); (0,0,2,1:vw1); (0,0,2,2:vw1); (0,0,2,3:vw1); (0,0,2,4:vw1); (0,0,2,5:vw1); (0,0,2,6:vw1); (0,0,2,7:vw1); (0,1,2,0:vw1); (0,1,2,1:vw1); (0,1,2,2:vw1); (0,1,2,3:vw1); (0,1,2,4:vw1); (0,1,2,5:vw1); (0,1,2,6:vw1); (0,1,2,7:vw1); (0,2,2,0:vw1); (0,2,2,1:vw1); (0,2,2,2:vw1); (0,2,2,3:vw1); (0,2,2,4:vw1); (0,2,2,5:vw1); (0,2,2,6:vw1); (0,2,2,7:vw1); (0,3,2,0:vw1); (0,3,2,1:vw1); (0,3,2,2:vw1); (0,3,2,3:vw1); (0,3,2,4:vw1); (0,3,2,5:vw1); (0,3,2,6:vw1); (0,3,2,7:vw1); (0,0,3,0:vw1); (0,0,3,1:vw1); (0,0,3,2:vw1); (0,0,3,3:vw1); (0,0,3,4:vw1); (0,0,3,5:vw1); (0,0,3,6:vw1); (0,0,3,7:vw1); (0,1,3,0:vw1); (0,1,3,1:vw1); (0,1,3,2:vw1); (0,1,3,3:vw1); (0,1,3,4:vw1); (0,1,3,5:vw1); (0,1,3,6:vw1); (0,1,3,7:vw1); (0,2,3,0:vw1); (0,2,3,1:vw1); (0,2,3,2:vw1); (0,2,3,3:vw1); (0,2,3,4:vw1); (0,2,3,5:vw1); (0,2,3,6:vw1); (0,2,3,7:vw1); (0,3,3,0:vw1); (0,3,3,1:vw1); (0,3,3,2:vw1); (0,3,3,3:vw1); (0,3,3,4:vw1); (0,3,3,5:vw1); (0,3,3,6:vw1); (0,3,3,7:vw1) */
/******************************************/

/* calc coords, apply mask, and issue loads (if necessary) */
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v6, BufferOOB
/* (d1,vc1,d0,vc0)=(0,0,0,0) */
v_cmp_lt_u32 s12, v0, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[263-256], v3, v0, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[263-256], v6, v[263-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,0,1) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 1                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[264-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[264-256], v6, v[264-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,0,2) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 2                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[265-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[265-256], v6, v[265-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,0,3) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 3                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[266-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[266-256], v6, v[266-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,0,4) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 4                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[267-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[267-256], v6, v[267-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,0,5) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 5                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[268-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[268-256], v6, v[268-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,0,6) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 6                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[269-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[269-256], v6, v[269-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,0,7) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 7                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[270-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[270-256], v6, v[270-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,1,0) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 32                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[271-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[271-256], v6, v[271-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,1,1) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 33                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[272-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[272-256], v6, v[272-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,1,2) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 34                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[273-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[273-256], v6, v[273-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,1,3) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 35                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[274-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[274-256], v6, v[274-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,1,4) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 36                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[275-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[275-256], v6, v[275-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,1,5) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 37                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[277-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[277-256], v6, v[277-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,1,6) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 38                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[278-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[278-256], v6, v[278-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,1,7) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 39                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[279-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[279-256], v6, v[279-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,2,0) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 64                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[280-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[280-256], v6, v[280-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,2,1) */
s_mov_b32 s12, 65                                  // coordOffset0 d0=2 vc0=1
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[281-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[281-256], v6, v[281-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,2,2) */
s_mov_b32 s12, 66                                  // coordOffset0 d0=2 vc0=2
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[282-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[282-256], v6, v[282-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,2,3) */
s_mov_b32 s12, 67                                  // coordOffset0 d0=2 vc0=3
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[283-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[283-256], v6, v[283-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,2,4) */
s_mov_b32 s12, 68                                  // coordOffset0 d0=2 vc0=4
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[284-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[284-256], v6, v[284-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,2,5) */
s_mov_b32 s12, 69                                  // coordOffset0 d0=2 vc0=5
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[285-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[285-256], v6, v[285-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,2,6) */
s_mov_b32 s12, 70                                  // coordOffset0 d0=2 vc0=6
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[286-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[286-256], v6, v[286-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,2,7) */
s_mov_b32 s12, 71                                  // coordOffset0 d0=2 vc0=7
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[287-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[287-256], v6, v[287-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,3,0) */
s_mov_b32 s12, 96                                  // coordOffset0 d0=3 vc0=0
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[288-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[288-256], v6, v[288-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,3,1) */
s_mov_b32 s12, 97                                  // coordOffset0 d0=3 vc0=1
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[289-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[289-256], v6, v[289-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,3,2) */
s_mov_b32 s12, 98                                  // coordOffset0 d0=3 vc0=2
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[290-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[290-256], v6, v[290-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,3,3) */
s_mov_b32 s12, 99                                  // coordOffset0 d0=3 vc0=3
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[291-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[291-256], v6, v[291-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,3,4) */
s_mov_b32 s12, 100                                 // coordOffset0 d0=3 vc0=4
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[292-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[292-256], v6, v[292-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,3,5) */
s_mov_b32 s12, 101                                 // coordOffset0 d0=3 vc0=5
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[293-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[293-256], v6, v[293-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,3,6) */
s_mov_b32 s12, 102                                 // coordOffset0 d0=3 vc0=6
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[294-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[294-256], v6, v[294-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,3,7) */
s_mov_b32 s12, 103                                 // coordOffset0 d0=3 vc0=7
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[295-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[295-256], v6, v[295-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,0,0) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v1, vcc_lo, v1, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v2, v2, s[sgprStrideC1J]              // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v3, v3, s[sgprStrideD1J]              // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v0, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[296-256], v3, v0, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[296-256], v6, v[296-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,0,1) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 1                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[297-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[297-256], v6, v[297-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,0,2) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 2                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[298-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[298-256], v6, v[298-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,0,3) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 3                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[299-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[299-256], v6, v[299-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,0,4) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 4                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[300-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[300-256], v6, v[300-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,0,5) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 5                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[301-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[301-256], v6, v[301-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,0,6) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 6                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[302-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[302-256], v6, v[302-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,0,7) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 7                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[303-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[303-256], v6, v[303-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,1,0) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 32                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[304-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[304-256], v6, v[304-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,1,1) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 33                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[305-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[305-256], v6, v[305-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,1,2) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 34                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[306-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[306-256], v6, v[306-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,1,3) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 35                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[307-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[307-256], v6, v[307-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,1,4) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 36                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[308-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[308-256], v6, v[308-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,1,5) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 37                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[309-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[309-256], v6, v[309-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,1,6) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 38                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[310-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[310-256], v6, v[310-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,1,7) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 39                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[311-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[311-256], v6, v[311-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,2,0) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 64                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[312-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[312-256], v6, v[312-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,2,1) */
s_mov_b32 s12, 65                                  // coordOffset0 d0=2 vc0=1
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[313-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[313-256], v6, v[313-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,2,2) */
s_mov_b32 s12, 66                                  // coordOffset0 d0=2 vc0=2
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[314-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[314-256], v6, v[314-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,2,3) */
s_mov_b32 s12, 67                                  // coordOffset0 d0=2 vc0=3
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[315-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[315-256], v6, v[315-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,2,4) */
s_mov_b32 s12, 68                                  // coordOffset0 d0=2 vc0=4
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[316-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[316-256], v6, v[316-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,2,5) */
s_mov_b32 s12, 69                                  // coordOffset0 d0=2 vc0=5
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[317-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[317-256], v6, v[317-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,2,6) */
s_mov_b32 s12, 70                                  // coordOffset0 d0=2 vc0=6
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[318-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[318-256], v6, v[318-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,2,7) */
s_mov_b32 s12, 71                                  // coordOffset0 d0=2 vc0=7
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[319-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[319-256], v6, v[319-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,3,0) */
s_mov_b32 s12, 96                                  // coordOffset0 d0=3 vc0=0
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[320-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[320-256], v6, v[320-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,3,1) */
s_mov_b32 s12, 97                                  // coordOffset0 d0=3 vc0=1
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[321-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[321-256], v6, v[321-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,3,2) */
s_mov_b32 s12, 98                                  // coordOffset0 d0=3 vc0=2
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[322-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[322-256], v6, v[322-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,3,3) */
s_mov_b32 s12, 99                                  // coordOffset0 d0=3 vc0=3
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[323-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[323-256], v6, v[323-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,3,4) */
s_mov_b32 s12, 100                                 // coordOffset0 d0=3 vc0=4
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[324-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[324-256], v6, v[324-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,3,5) */
s_mov_b32 s12, 101                                 // coordOffset0 d0=3 vc0=5
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[325-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[325-256], v6, v[325-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,3,6) */
s_mov_b32 s12, 102                                 // coordOffset0 d0=3 vc0=6
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[326-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[326-256], v6, v[326-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,3,7) */
s_mov_b32 s12, 103                                 // coordOffset0 d0=3 vc0=7
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[327-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[327-256], v6, v[327-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,0,0) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v1, vcc_lo, v1, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v2, v2, s[sgprStrideC1J]              // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v3, v3, s[sgprStrideD1J]              // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v0, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[328-256], v3, v0, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[328-256], v6, v[328-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,0,1) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 1                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[329-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[329-256], v6, v[329-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,0,2) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 2                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[330-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[330-256], v6, v[330-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,0,3) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 3                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[331-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[331-256], v6, v[331-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,0,4) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 4                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[332-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[332-256], v6, v[332-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,0,5) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 5                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[333-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[333-256], v6, v[333-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,0,6) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 6                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[334-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[334-256], v6, v[334-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,0,7) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 7                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[335-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[335-256], v6, v[335-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,1,0) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 32                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[336-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[336-256], v6, v[336-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,1,1) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 33                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[337-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[337-256], v6, v[337-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,1,2) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 34                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[338-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[338-256], v6, v[338-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,1,3) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 35                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[339-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[339-256], v6, v[339-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,1,4) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 36                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[340-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[340-256], v6, v[340-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,1,5) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 37                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[341-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[341-256], v6, v[341-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,1,6) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 38                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[342-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[342-256], v6, v[342-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,1,7) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 39                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[343-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[343-256], v6, v[343-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,2,0) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 64                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[344-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[344-256], v6, v[344-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,2,1) */
s_mov_b32 s12, 65                                  // coordOffset0 d0=2 vc0=1
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[345-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[345-256], v6, v[345-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,2,2) */
s_mov_b32 s12, 66                                  // coordOffset0 d0=2 vc0=2
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[346-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[346-256], v6, v[346-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,2,3) */
s_mov_b32 s12, 67                                  // coordOffset0 d0=2 vc0=3
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[347-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[347-256], v6, v[347-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,2,4) */
s_mov_b32 s12, 68                                  // coordOffset0 d0=2 vc0=4
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[348-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[348-256], v6, v[348-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,2,5) */
s_mov_b32 s12, 69                                  // coordOffset0 d0=2 vc0=5
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[349-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[349-256], v6, v[349-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,2,6) */
s_mov_b32 s12, 70                                  // coordOffset0 d0=2 vc0=6
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[350-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[350-256], v6, v[350-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,2,7) */
s_mov_b32 s12, 71                                  // coordOffset0 d0=2 vc0=7
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[351-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[351-256], v6, v[351-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,3,0) */
s_mov_b32 s12, 96                                  // coordOffset0 d0=3 vc0=0
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[352-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[352-256], v6, v[352-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,3,1) */
s_mov_b32 s12, 97                                  // coordOffset0 d0=3 vc0=1
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[353-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[353-256], v6, v[353-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,3,2) */
s_mov_b32 s12, 98                                  // coordOffset0 d0=3 vc0=2
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[354-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[354-256], v6, v[354-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,3,3) */
s_mov_b32 s12, 99                                  // coordOffset0 d0=3 vc0=3
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[355-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[355-256], v6, v[355-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,3,4) */
s_mov_b32 s12, 100                                 // coordOffset0 d0=3 vc0=4
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[356-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[356-256], v6, v[356-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,3,5) */
s_mov_b32 s12, 101                                 // coordOffset0 d0=3 vc0=5
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[357-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[357-256], v6, v[357-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,3,6) */
s_mov_b32 s12, 102                                 // coordOffset0 d0=3 vc0=6
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[358-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[358-256], v6, v[358-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,3,7) */
s_mov_b32 s12, 103                                 // coordOffset0 d0=3 vc0=7
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[359-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[359-256], v6, v[359-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,0,0) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v1, vcc_lo, v1, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v2, v2, s[sgprStrideC1J]              // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v3, v3, s[sgprStrideD1J]              // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v0, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[360-256], v3, v0, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[360-256], v6, v[360-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,0,1) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 1                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[361-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[361-256], v6, v[361-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,0,2) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 2                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[362-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[362-256], v6, v[362-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,0,3) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 3                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[363-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[363-256], v6, v[363-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,0,4) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 4                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[364-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[364-256], v6, v[364-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,0,5) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 5                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[365-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[365-256], v6, v[365-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,0,6) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 6                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[366-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[366-256], v6, v[366-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,0,7) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 7                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[367-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[367-256], v6, v[367-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,1,0) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 32                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[368-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[368-256], v6, v[368-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,1,1) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 33                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[369-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[369-256], v6, v[369-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,1,2) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 34                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[370-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[370-256], v6, v[370-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,1,3) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 35                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[371-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[371-256], v6, v[371-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,1,4) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 36                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[372-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[372-256], v6, v[372-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,1,5) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 37                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[373-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[373-256], v6, v[373-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,1,6) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 38                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[374-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[374-256], v6, v[374-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,1,7) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 39                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[375-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[375-256], v6, v[375-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,2,0) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 64                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[376-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[376-256], v6, v[376-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,2,1) */
s_mov_b32 s12, 65                                  // coordOffset0 d0=2 vc0=1
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[377-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[377-256], v6, v[377-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,2,2) */
s_mov_b32 s12, 66                                  // coordOffset0 d0=2 vc0=2
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[378-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[378-256], v6, v[378-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,2,3) */
s_mov_b32 s12, 67                                  // coordOffset0 d0=2 vc0=3
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[379-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[379-256], v6, v[379-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,2,4) */
s_mov_b32 s12, 68                                  // coordOffset0 d0=2 vc0=4
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[380-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[380-256], v6, v[380-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,2,5) */
s_mov_b32 s12, 69                                  // coordOffset0 d0=2 vc0=5
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[381-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[381-256], v6, v[381-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,2,6) */
s_mov_b32 s12, 70                                  // coordOffset0 d0=2 vc0=6
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[382-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[382-256], v6, v[382-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,2,7) */
s_mov_b32 s12, 71                                  // coordOffset0 d0=2 vc0=7
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[383-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[383-256], v6, v[383-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,3,0) */
s_mov_b32 s12, 96                                  // coordOffset0 d0=3 vc0=0
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[384-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[384-256], v6, v[384-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,3,1) */
s_mov_b32 s12, 97                                  // coordOffset0 d0=3 vc0=1
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[385-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[385-256], v6, v[385-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,3,2) */
s_mov_b32 s12, 98                                  // coordOffset0 d0=3 vc0=2
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[386-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[386-256], v6, v[386-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,3,3) */
s_mov_b32 s12, 99                                  // coordOffset0 d0=3 vc0=3
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[387-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[387-256], v6, v[387-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,3,4) */
s_mov_b32 s12, 100                                 // coordOffset0 d0=3 vc0=4
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[388-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[388-256], v6, v[388-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,3,5) */
s_mov_b32 s12, 101                                 // coordOffset0 d0=3 vc0=5
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[389-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[389-256], v6, v[389-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,3,6) */
s_mov_b32 s12, 102                                 // coordOffset0 d0=3 vc0=6
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[390-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[390-256], v6, v[390-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,3,7) */
s_mov_b32 s12, 103                                 // coordOffset0 d0=3 vc0=7
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[391-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[391-256], v6, v[391-256], s14      // LDD clip if OOB. offset

/* rC *= alpha batchElements=[(0, 0, 0, 0), (0, 0, 0, 1), (0, 0, 0, 2), (0, 0, 0, 3), (0, 0, 0, 4), (0, 0, 0, 5), (0, 0, 0, 6), (0, 0, 0, 7), (0, 1, 0, 0), (0, 1, 0, 1), (0, 1, 0, 2), (0, 1, 0, 3), (0, 1, 0, 4), (0, 1, 0, 5), (0, 1, 0, 6), (0, 1, 0, 7), (0, 2, 0, 0), (0, 2, 0, 1), (0, 2, 0, 2), (0, 2, 0, 3), (0, 2, 0, 4), (0, 2, 0, 5), (0, 2, 0, 6), (0, 2, 0, 7), (0, 3, 0, 0), (0, 3, 0, 1), (0, 3, 0, 2), (0, 3, 0, 3), (0, 3, 0, 4), (0, 3, 0, 5), (0, 3, 0, 6), (0, 3, 0, 7), (0, 0, 1, 0), (0, 0, 1, 1), (0, 0, 1, 2), (0, 0, 1, 3), (0, 0, 1, 4), (0, 0, 1, 5), (0, 0, 1, 6), (0, 0, 1, 7), (0, 1, 1, 0), (0, 1, 1, 1), (0, 1, 1, 2), (0, 1, 1, 3), (0, 1, 1, 4), (0, 1, 1, 5), (0, 1, 1, 6), (0, 1, 1, 7), (0, 2, 1, 0), (0, 2, 1, 1), (0, 2, 1, 2), (0, 2, 1, 3), (0, 2, 1, 4), (0, 2, 1, 5), (0, 2, 1, 6), (0, 2, 1, 7), (0, 3, 1, 0), (0, 3, 1, 1), (0, 3, 1, 2), (0, 3, 1, 3), (0, 3, 1, 4), (0, 3, 1, 5), (0, 3, 1, 6), (0, 3, 1, 7), (0, 0, 2, 0), (0, 0, 2, 1), (0, 0, 2, 2), (0, 0, 2, 3), (0, 0, 2, 4), (0, 0, 2, 5), (0, 0, 2, 6), (0, 0, 2, 7), (0, 1, 2, 0), (0, 1, 2, 1), (0, 1, 2, 2), (0, 1, 2, 3), (0, 1, 2, 4), (0, 1, 2, 5), (0, 1, 2, 6), (0, 1, 2, 7), (0, 2, 2, 0), (0, 2, 2, 1), (0, 2, 2, 2), (0, 2, 2, 3), (0, 2, 2, 4), (0, 2, 2, 5), (0, 2, 2, 6), (0, 2, 2, 7), (0, 3, 2, 0), (0, 3, 2, 1), (0, 3, 2, 2), (0, 3, 2, 3), (0, 3, 2, 4), (0, 3, 2, 5), (0, 3, 2, 6), (0, 3, 2, 7), (0, 0, 3, 0), (0, 0, 3, 1), (0, 0, 3, 2), (0, 0, 3, 3), (0, 0, 3, 4), (0, 0, 3, 5), (0, 0, 3, 6), (0, 0, 3, 7), (0, 1, 3, 0), (0, 1, 3, 1), (0, 1, 3, 2), (0, 1, 3, 3), (0, 1, 3, 4), (0, 1, 3, 5), (0, 1, 3, 6), (0, 1, 3, 7), (0, 2, 3, 0), (0, 2, 3, 1), (0, 2, 3, 2), (0, 2, 3, 3), (0, 2, 3, 4), (0, 2, 3, 5), (0, 2, 3, 6), (0, 2, 3, 7), (0, 3, 3, 0), (0, 3, 3, 1), (0, 3, 3, 2), (0, 3, 3, 3), (0, 3, 3, 4), (0, 3, 3, 5), (0, 3, 3, 6), (0, 3, 3, 7)] */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v[vgprValuC+-7], v[vgprValuC+0]          // Rearrange MI out reg
v_mov_b32 v[vgprValuC+-6], v[vgprValuC+1]          // Rearrange MI out reg
v_mov_b32 v[vgprValuC+-5], v[vgprValuC+2]          // Rearrange MI out reg
v_mov_b32 v[vgprValuC+-4], v[vgprValuC+3]          // Rearrange MI out reg
v_mov_b32 v[vgprValuC+-3], v[vgprValuC+4]          // Rearrange MI out reg
v_mov_b32 v[vgprValuC+-2], v[vgprValuC+5]          // Rearrange MI out reg
v_mov_b32 v[vgprValuC+-1], v[vgprValuC+6]          // Rearrange MI out reg
v_mov_b32 v[vgprValuC+128], v[vgprValuC+7]         // Rearrange MI out reg
v_mov_b32 v[vgprValuC+129], v[vgprValuC+8]         // Rearrange MI out reg
v_mov_b32 v[vgprValuC+130], v[vgprValuC+9]         // Rearrange MI out reg
v_mov_b32 v[vgprValuC+131], v[vgprValuC+10]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+132], v[vgprValuC+11]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+133], v[vgprValuC+12]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+134], v[vgprValuC+13]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+135], v[vgprValuC+14]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+136], v[vgprValuC+15]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+137], v[vgprValuC+16]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+138], v[vgprValuC+17]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+139], v[vgprValuC+18]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+140], v[vgprValuC+19]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+141], v[vgprValuC+20]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+142], v[vgprValuC+21]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+143], v[vgprValuC+22]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+144], v[vgprValuC+23]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+145], v[vgprValuC+24]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+146], v[vgprValuC+25]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+147], v[vgprValuC+26]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+148], v[vgprValuC+27]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+149], v[vgprValuC+28]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+150], v[vgprValuC+29]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+151], v[vgprValuC+30]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+152], v[vgprValuC+31]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+153], v[vgprValuC+32]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+154], v[vgprValuC+33]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+155], v[vgprValuC+34]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+156], v[vgprValuC+35]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+157], v[vgprValuC+36]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+158], v[vgprValuC+37]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+159], v[vgprValuC+38]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+160], v[vgprValuC+39]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+161], v[vgprValuC+40]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+162], v[vgprValuC+41]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+163], v[vgprValuC+42]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+164], v[vgprValuC+43]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+165], v[vgprValuC+44]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+166], v[vgprValuC+45]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+167], v[vgprValuC+46]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+168], v[vgprValuC+47]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+169], v[vgprValuC+48]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+170], v[vgprValuC+49]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+171], v[vgprValuC+50]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+172], v[vgprValuC+51]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+173], v[vgprValuC+52]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+174], v[vgprValuC+53]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+175], v[vgprValuC+54]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+176], v[vgprValuC+55]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+177], v[vgprValuC+56]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+178], v[vgprValuC+57]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+179], v[vgprValuC+58]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+180], v[vgprValuC+59]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+181], v[vgprValuC+60]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+182], v[vgprValuC+61]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+183], v[vgprValuC+62]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+184], v[vgprValuC+63]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+185], v[vgprValuC+64]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+186], v[vgprValuC+65]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+187], v[vgprValuC+66]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+188], v[vgprValuC+67]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+189], v[vgprValuC+68]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+190], v[vgprValuC+69]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+191], v[vgprValuC+70]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+192], v[vgprValuC+71]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+193], v[vgprValuC+72]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+194], v[vgprValuC+73]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+195], v[vgprValuC+74]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+196], v[vgprValuC+75]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+197], v[vgprValuC+76]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+198], v[vgprValuC+77]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+199], v[vgprValuC+78]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+200], v[vgprValuC+79]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+201], v[vgprValuC+80]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+202], v[vgprValuC+81]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+203], v[vgprValuC+82]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+204], v[vgprValuC+83]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+205], v[vgprValuC+84]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+206], v[vgprValuC+85]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+207], v[vgprValuC+86]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+208], v[vgprValuC+87]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+209], v[vgprValuC+88]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+210], v[vgprValuC+89]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+211], v[vgprValuC+90]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+212], v[vgprValuC+91]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+213], v[vgprValuC+92]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+214], v[vgprValuC+93]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+215], v[vgprValuC+94]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+216], v[vgprValuC+95]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+217], v[vgprValuC+96]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+218], v[vgprValuC+97]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+219], v[vgprValuC+98]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+220], v[vgprValuC+99]        // Rearrange MI out reg
v_mov_b32 v[vgprValuC+221], v[vgprValuC+100]       // Rearrange MI out reg
v_mov_b32 v[vgprValuC+222], v[vgprValuC+101]       // Rearrange MI out reg
v_mov_b32 v[vgprValuC+223], v[vgprValuC+102]       // Rearrange MI out reg
v_mov_b32 v[vgprValuC+224], v[vgprValuC+103]       // Rearrange MI out reg
v_mov_b32 v[vgprValuC+225], v[vgprValuC+104]       // Rearrange MI out reg
v_mov_b32 v[vgprValuC+226], v[vgprValuC+105]       // Rearrange MI out reg
v_mov_b32 v[vgprValuC+227], v[vgprValuC+106]       // Rearrange MI out reg
v_mov_b32 v[vgprValuC+228], v[vgprValuC+107]       // Rearrange MI out reg
v_mov_b32 v[vgprValuC+229], v[vgprValuC+108]       // Rearrange MI out reg
v_mov_b32 v[vgprValuC+230], v[vgprValuC+109]       // Rearrange MI out reg
v_mov_b32 v[vgprValuC+231], v[vgprValuC+110]       // Rearrange MI out reg
v_mov_b32 v[vgprValuC+232], v[vgprValuC+111]       // Rearrange MI out reg
v_mov_b32 v[vgprValuC+233], v[vgprValuC+112]       // Rearrange MI out reg
v_mov_b32 v[vgprValuC+234], v[vgprValuC+113]       // Rearrange MI out reg
v_mov_b32 v[vgprValuC+235], v[vgprValuC+114]       // Rearrange MI out reg
v_mov_b32 v[vgprValuC+236], v[vgprValuC+115]       // Rearrange MI out reg
v_mov_b32 v[vgprValuC+237], v[vgprValuC+116]       // Rearrange MI out reg
v_mov_b32 v[vgprValuC+238], v[vgprValuC+117]       // Rearrange MI out reg
v_mov_b32 v[vgprValuC+239], v[vgprValuC+118]       // Rearrange MI out reg
v_mov_b32 v[vgprValuC+240], v[vgprValuC+119]       // Rearrange MI out reg
v_mov_b32 v[vgprValuC+241], v[vgprValuC+120]       // Rearrange MI out reg
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_mov_b32 v[vgprValuC+242-256], v[vgprValuC+121]   // Rearrange MI out reg
v_mov_b32 v[vgprValuC+243-256], v[vgprValuC+122]   // Rearrange MI out reg
v_mov_b32 v[vgprValuC+244-256], v[vgprValuC+123]   // Rearrange MI out reg
v_mov_b32 v[vgprValuC+245-256], v[vgprValuC+124]   // Rearrange MI out reg
v_mov_b32 v[vgprValuC+246-256], v[vgprValuC+125]   // Rearrange MI out reg
v_mov_b32 v[vgprValuC+247-256], v[vgprValuC+126]   // Rearrange MI out reg
v_mov_b32 v[vgprValuC+248-256], v[vgprValuC+127]   // Rearrange MI out reg

/* apply mask, calc new C and issue writes */
s_set_vgpr_msb 16385                               // src0: 1, src1: 0, src2: 0, dst: 0
s_wait_alu depctr_va_vdst(14)
buffer_store_b32 v7, v[263-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v8, v[264-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v9, v[265-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v10, v[266-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v11, v[267-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v12, v[268-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v13, v[269-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v142, v[270-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v143, v[271-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v144, v[272-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v145, v[273-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v146, v[274-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v147, v[275-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v148, v[277-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v149, v[278-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v150, v[279-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v151, v[280-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v152, v[281-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v153, v[282-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v154, v[283-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v155, v[284-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v156, v[285-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v157, v[286-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v158, v[287-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v159, v[288-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v160, v[289-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v161, v[290-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v162, v[291-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v163, v[292-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v164, v[293-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v165, v[294-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v166, v[295-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v167, v[296-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v168, v[297-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v169, v[298-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v170, v[299-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v171, v[300-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v172, v[301-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v173, v[302-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v174, v[303-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v175, v[304-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v176, v[305-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v177, v[306-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v178, v[307-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v179, v[308-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v180, v[309-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v181, v[310-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v182, v[311-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v183, v[312-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v184, v[313-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v185, v[314-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v186, v[315-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v187, v[316-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v188, v[317-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v189, v[318-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v190, v[319-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v191, v[320-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v192, v[321-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v193, v[322-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v194, v[323-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v195, v[324-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v196, v[325-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v197, v[326-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v198, v[327-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v199, v[328-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v200, v[329-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v201, v[330-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v202, v[331-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v203, v[332-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v204, v[333-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v205, v[334-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v206, v[335-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v207, v[336-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v208, v[337-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v209, v[338-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v210, v[339-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v211, v[340-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v212, v[341-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v213, v[342-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v214, v[343-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v215, v[344-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v216, v[345-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v217, v[346-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v218, v[347-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v219, v[348-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v220, v[349-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v221, v[350-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v222, v[351-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v223, v[352-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v224, v[353-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v225, v[354-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v226, v[355-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v227, v[356-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v228, v[357-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v229, v[358-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v230, v[359-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v231, v[360-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v232, v[361-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v233, v[362-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v234, v[363-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v235, v[364-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v236, v[365-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v237, v[366-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v238, v[367-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v239, v[368-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v240, v[369-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v241, v[370-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v242, v[371-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v243, v[372-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v244, v[373-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v245, v[374-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v246, v[375-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v247, v[376-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v248, v[377-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(13)
buffer_store_b32 v249, v[378-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(12)
buffer_store_b32 v250, v[379-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(11)
buffer_store_b32 v251, v[380-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(10)
buffer_store_b32 v252, v[381-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(9)
buffer_store_b32 v253, v[382-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(8)
buffer_store_b32 v254, v[383-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(7)
buffer_store_b32 v255, v[384-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_set_vgpr_msb 321                                 // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(6)
buffer_store_b32 v[256-256], v[385-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(5)
buffer_store_b32 v[257-256], v[386-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(4)
buffer_store_b32 v[258-256], v[387-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(3)
buffer_store_b32 v[259-256], v[388-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(2)
buffer_store_b32 v[260-256], v[389-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(1)
buffer_store_b32 v[261-256], v[390-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v[262-256], v[391-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_nop 0                                            // 1 wait state required when next inst writes vgprs held by previous dwordx4 store inst
s_branch label_GW_End                              // jump to end
label_GW_End:
s_getpc_b64 s[12:13]                               // addr of next instr
s_add_i32 s14, label_KernelEnd, 4                  // target branch offset
s_add_u32 s12, s12, s14                            // add target branch offset
s_addc_u32 s13, s13, 0                             // add high and carry
s_setpc_b64 s[12:13]                               // branch to label_KernelEnd
label_GSU_4:
s_mov_b32 s7, 0
s_cmp_eq_u32 s[sgprBeta], s7                       // Beta == 0
s_cbranch_scc0 label_GW_B1_GSU1                    // Branch if Beta is not zero

label_GW_B0_GSU1:
label_GW_B0_FD0_GSU1:

/* Edge/NonEdge store path check (M): Size % 128 > 0 -> Edge store; else -> NonEdge store */
s_and_b32 s28, 127, s[sgprSizeI]                   // s28 = s[sgprSizeI] % 128
s_add_u32 s29, -0x1, s[sgprNumWorkGroups0]
s_cmp_ge_u32 s[sgprWorkGroup0], s29                // wg0 >= nwg0-1 ?
s_cselect_b32 s28, s28, 0                          // set rem
s_mov_b32 s5, 0
s_cmp_gt_u32 s28, s5                               // rem > 0
s_cbranch_scc1 label_GW_B0_FD0_VW8_GSU1_Else       // jump if edges required

/* Edge/NonEdge store path check (N (isSize1)): Size % 128 > 0 -> Edge store; else -> NonEdge store */
s_and_b32 s28, 127, s[sgprSizeJ]                   // s28 = s[sgprSizeJ] % 128
s_add_u32 s29, -0x1, s[sgprNumWorkGroups1]
s_cmp_ge_u32 s[sgprWorkGroup1], s29                // wg1 >= nwg1-1
s_cselect_b32 s28, s28, 0                          // set rem
s_mov_b32 s5, 0
s_cmp_gt_u32 s28, s5                               // rem > 0
s_cbranch_scc1 label_GW_B0_FD0_VW8_GSU1_Then       // jump if edges required
label_GW_B0_FD0_VW8_GSU1_NonEdge:

/* edge=0, allocate 1 sgpr. perBatchTmpS=1 perBatchMaskS=0 perElementMaskS=0 elementsPerBatch=66 */
/* optSingleColVgpr=1 optSharedColVgpr=0 optSGPRUsage=BufferLoad_Mask optSrdIncForRow=1 factorDim=0 */

/******************************************/
/* Global Write Batch #0 (d1,d0,vc1,vc0) = */
/*    (0,0,0,0:vw8); (0,1,0,0:vw8); (0,2,0,0:vw8); (0,3,0,0:vw8); (0,0,1,0:vw8); (0,1,1,0:vw8); (0,2,1,0:vw8); (0,3,1,0:vw8); (0,0,2,0:vw8); (0,1,2,0:vw8); (0,2,2,0:vw8); (0,3,2,0:vw8); (0,0,3,0:vw8); (0,1,3,0:vw8); (0,2,3,0:vw8); (0,3,3,0:vw8) */
/******************************************/

/* calc coords, apply mask, and issue loads (if necessary) */
/* (d1,vc1,d0,vc0)=(0,0,0,0) */
/* (d1,vc1,d0,vc0)=(0,0,1,0) */
/* (d1,vc1,d0,vc0)=(0,0,2,0) */
/* (d1,vc1,d0,vc0)=(0,0,3,0) */
/* (d1,vc1,d0,vc0)=(0,1,0,0) */
/* (d1,vc1,d0,vc0)=(0,1,1,0) */
/* (d1,vc1,d0,vc0)=(0,1,2,0) */
/* (d1,vc1,d0,vc0)=(0,1,3,0) */
/* (d1,vc1,d0,vc0)=(0,2,0,0) */
/* (d1,vc1,d0,vc0)=(0,2,1,0) */
/* (d1,vc1,d0,vc0)=(0,2,2,0) */
/* (d1,vc1,d0,vc0)=(0,2,3,0) */
/* (d1,vc1,d0,vc0)=(0,3,0,0) */
/* (d1,vc1,d0,vc0)=(0,3,1,0) */
/* (d1,vc1,d0,vc0)=(0,3,2,0) */
/* (d1,vc1,d0,vc0)=(0,3,3,0) */
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_add_lshl_u32 v7, v3, v0, 2                       // optSingleColVgpr scaleToBpe: sharedAddrVgpr <- cinRowPtr + coord0, scaled by BPE. BSHERE:coord0=0, coord0Vgpr=0 (multiple bpe)

/* rC *= alpha batchElements=[(0, 0, 0, 0), (0, 1, 0, 0), (0, 2, 0, 0), (0, 3, 0, 0), (0, 0, 1, 0), (0, 1, 1, 0), (0, 2, 1, 0), (0, 3, 1, 0), (0, 0, 2, 0), (0, 1, 2, 0), (0, 2, 2, 0), (0, 3, 2, 0), (0, 0, 3, 0), (0, 1, 3, 0), (0, 2, 3, 0), (0, 3, 3, 0)] */
v_mul_f32 v[vgprValuC+130], s[sgprAlpha], v[vgprValuC+0] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+131], s[sgprAlpha], v[vgprValuC+1] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+132], s[sgprAlpha], v[vgprValuC+2] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+133], s[sgprAlpha], v[vgprValuC+3] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+134], s[sgprAlpha], v[vgprValuC+4] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+135], s[sgprAlpha], v[vgprValuC+5] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+136], s[sgprAlpha], v[vgprValuC+6] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+137], s[sgprAlpha], v[vgprValuC+7] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+138], s[sgprAlpha], v[vgprValuC+8] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+139], s[sgprAlpha], v[vgprValuC+9] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+140], s[sgprAlpha], v[vgprValuC+10] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+141], s[sgprAlpha], v[vgprValuC+11] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+142], s[sgprAlpha], v[vgprValuC+12] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+143], s[sgprAlpha], v[vgprValuC+13] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+144], s[sgprAlpha], v[vgprValuC+14] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+145], s[sgprAlpha], v[vgprValuC+15] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+146], s[sgprAlpha], v[vgprValuC+16] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+147], s[sgprAlpha], v[vgprValuC+17] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+148], s[sgprAlpha], v[vgprValuC+18] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+149], s[sgprAlpha], v[vgprValuC+19] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+150], s[sgprAlpha], v[vgprValuC+20] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+151], s[sgprAlpha], v[vgprValuC+21] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+152], s[sgprAlpha], v[vgprValuC+22] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+153], s[sgprAlpha], v[vgprValuC+23] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+154], s[sgprAlpha], v[vgprValuC+24] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+155], s[sgprAlpha], v[vgprValuC+25] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+156], s[sgprAlpha], v[vgprValuC+26] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+157], s[sgprAlpha], v[vgprValuC+27] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+158], s[sgprAlpha], v[vgprValuC+28] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+159], s[sgprAlpha], v[vgprValuC+29] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+160], s[sgprAlpha], v[vgprValuC+30] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+161], s[sgprAlpha], v[vgprValuC+31] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+162], s[sgprAlpha], v[vgprValuC+32] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+163], s[sgprAlpha], v[vgprValuC+33] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+164], s[sgprAlpha], v[vgprValuC+34] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+165], s[sgprAlpha], v[vgprValuC+35] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+166], s[sgprAlpha], v[vgprValuC+36] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+167], s[sgprAlpha], v[vgprValuC+37] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+168], s[sgprAlpha], v[vgprValuC+38] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+169], s[sgprAlpha], v[vgprValuC+39] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+170], s[sgprAlpha], v[vgprValuC+40] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+171], s[sgprAlpha], v[vgprValuC+41] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+172], s[sgprAlpha], v[vgprValuC+42] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+173], s[sgprAlpha], v[vgprValuC+43] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+174], s[sgprAlpha], v[vgprValuC+44] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+175], s[sgprAlpha], v[vgprValuC+45] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+176], s[sgprAlpha], v[vgprValuC+46] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+177], s[sgprAlpha], v[vgprValuC+47] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+178], s[sgprAlpha], v[vgprValuC+48] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+179], s[sgprAlpha], v[vgprValuC+49] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+180], s[sgprAlpha], v[vgprValuC+50] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+181], s[sgprAlpha], v[vgprValuC+51] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+182], s[sgprAlpha], v[vgprValuC+52] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+183], s[sgprAlpha], v[vgprValuC+53] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+184], s[sgprAlpha], v[vgprValuC+54] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+185], s[sgprAlpha], v[vgprValuC+55] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+186], s[sgprAlpha], v[vgprValuC+56] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+187], s[sgprAlpha], v[vgprValuC+57] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+188], s[sgprAlpha], v[vgprValuC+58] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+189], s[sgprAlpha], v[vgprValuC+59] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+190], s[sgprAlpha], v[vgprValuC+60] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+191], s[sgprAlpha], v[vgprValuC+61] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+192], s[sgprAlpha], v[vgprValuC+62] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+193], s[sgprAlpha], v[vgprValuC+63] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+194], s[sgprAlpha], v[vgprValuC+64] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+195], s[sgprAlpha], v[vgprValuC+65] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+196], s[sgprAlpha], v[vgprValuC+66] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+197], s[sgprAlpha], v[vgprValuC+67] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+198], s[sgprAlpha], v[vgprValuC+68] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+199], s[sgprAlpha], v[vgprValuC+69] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+200], s[sgprAlpha], v[vgprValuC+70] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+201], s[sgprAlpha], v[vgprValuC+71] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+202], s[sgprAlpha], v[vgprValuC+72] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+203], s[sgprAlpha], v[vgprValuC+73] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+204], s[sgprAlpha], v[vgprValuC+74] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+205], s[sgprAlpha], v[vgprValuC+75] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+206], s[sgprAlpha], v[vgprValuC+76] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+207], s[sgprAlpha], v[vgprValuC+77] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+208], s[sgprAlpha], v[vgprValuC+78] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+209], s[sgprAlpha], v[vgprValuC+79] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+210], s[sgprAlpha], v[vgprValuC+80] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+211], s[sgprAlpha], v[vgprValuC+81] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+212], s[sgprAlpha], v[vgprValuC+82] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+213], s[sgprAlpha], v[vgprValuC+83] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+214], s[sgprAlpha], v[vgprValuC+84] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+215], s[sgprAlpha], v[vgprValuC+85] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+216], s[sgprAlpha], v[vgprValuC+86] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+217], s[sgprAlpha], v[vgprValuC+87] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+218], s[sgprAlpha], v[vgprValuC+88] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+219], s[sgprAlpha], v[vgprValuC+89] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+220], s[sgprAlpha], v[vgprValuC+90] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+221], s[sgprAlpha], v[vgprValuC+91] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+222], s[sgprAlpha], v[vgprValuC+92] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+223], s[sgprAlpha], v[vgprValuC+93] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+224], s[sgprAlpha], v[vgprValuC+94] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+225], s[sgprAlpha], v[vgprValuC+95] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+226], s[sgprAlpha], v[vgprValuC+96] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+227], s[sgprAlpha], v[vgprValuC+97] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+228], s[sgprAlpha], v[vgprValuC+98] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+229], s[sgprAlpha], v[vgprValuC+99] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+230], s[sgprAlpha], v[vgprValuC+100] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+231], s[sgprAlpha], v[vgprValuC+101] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+232], s[sgprAlpha], v[vgprValuC+102] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+233], s[sgprAlpha], v[vgprValuC+103] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+234], s[sgprAlpha], v[vgprValuC+104] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+235], s[sgprAlpha], v[vgprValuC+105] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+236], s[sgprAlpha], v[vgprValuC+106] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+237], s[sgprAlpha], v[vgprValuC+107] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+238], s[sgprAlpha], v[vgprValuC+108] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+239], s[sgprAlpha], v[vgprValuC+109] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+240], s[sgprAlpha], v[vgprValuC+110] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+241], s[sgprAlpha], v[vgprValuC+111] // Multiply MI out reg with alpha
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_mul_f32 v[vgprValuC+242-256], s[sgprAlpha], v[vgprValuC+112] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+243-256], s[sgprAlpha], v[vgprValuC+113] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+244-256], s[sgprAlpha], v[vgprValuC+114] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+245-256], s[sgprAlpha], v[vgprValuC+115] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+246-256], s[sgprAlpha], v[vgprValuC+116] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+247-256], s[sgprAlpha], v[vgprValuC+117] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+248-256], s[sgprAlpha], v[vgprValuC+118] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+249-256], s[sgprAlpha], v[vgprValuC+119] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+250-256], s[sgprAlpha], v[vgprValuC+120] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+251-256], s[sgprAlpha], v[vgprValuC+121] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+252-256], s[sgprAlpha], v[vgprValuC+122] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+253-256], s[sgprAlpha], v[vgprValuC+123] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+254-256], s[sgprAlpha], v[vgprValuC+124] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+255-256], s[sgprAlpha], v[vgprValuC+125] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+256-256], s[sgprAlpha], v[vgprValuC+126] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+257-256], s[sgprAlpha], v[vgprValuC+127] // Multiply MI out reg with alpha

/* apply mask, calc new C and issue writes */
s_set_vgpr_msb 16384                               // src0: 0, src1: 0, src2: 0, dst: 0
s_wait_alu depctr_va_vdst(14)
buffer_store_b128 v[144:147], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[148:151], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:16 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[152:155], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:128 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[156:159], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:144 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[160:163], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:256 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[164:167], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:272 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[168:171], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:384 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[172:175], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:400 scope:SCOPE_CU th:TH_STORE_RT // store D
s_lshl_b32 s12, s[sgprStrideD1J], 2                // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_store_b128 v[176:179], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[180:183], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:16 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[184:187], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:128 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[188:191], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:144 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[192:195], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:256 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[196:199], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:272 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[200:203], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:384 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[204:207], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:400 scope:SCOPE_CU th:TH_STORE_RT // store D
s_lshl_b32 s12, s[sgprStrideD1J], 2                // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_store_b128 v[208:211], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[212:215], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:16 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[216:219], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:128 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[220:223], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:144 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[224:227], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:256 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[228:231], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:272 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[232:235], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:384 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[236:239], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:400 scope:SCOPE_CU th:TH_STORE_RT // store D
s_lshl_b32 s12, s[sgprStrideD1J], 2                // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_store_b128 v[240:243], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[244:247], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:16 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[248:251], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:128 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[252:255], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:144 scope:SCOPE_CU th:TH_STORE_RT // store D
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(12)
buffer_store_b128 v[256-256:259-256], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:256 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(8)
buffer_store_b128 v[260-256:263-256], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:272 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(4)
buffer_store_b128 v[264-256:267-256], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:384 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(0)
buffer_store_b128 v[268-256:271-256], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:400 scope:SCOPE_CU th:TH_STORE_RT // store D
s_nop 0                                            // 1 wait state required when next inst writes vgprs held by previous dwordx4 store inst
s_branch label_GW_End_1                            // jump to end
label_GW_B0_FD0_VW8_GSU1_NonEdgeEnd:
label_GW_B0_FD0_VW8_GSU1_Then:

/* edge=1, allocate 3 sgpr. perBatchTmpS=2 perBatchMaskS=1 perElementMaskS=0 elementsPerBatch=58 */
/* optSingleColVgpr=0 optSharedColVgpr=0 optSGPRUsage=BufferLoad_Edge_Mask optSrdIncForRow=0 factorDim=0 */

/******************************************/
/* Global Write Edge Batch #0 (d1,d0,vc1,vc0) = */
/*    (0,0,0,0:vw8); (0,1,0,0:vw8); (0,2,0,0:vw8); (0,3,0,0:vw8); (0,0,1,0:vw8); (0,1,1,0:vw8); (0,2,1,0:vw8); (0,3,1,0:vw8); (0,0,2,0:vw8); (0,1,2,0:vw8); (0,2,2,0:vw8); (0,3,2,0:vw8); (0,0,3,0:vw8); (0,1,3,0:vw8); (0,2,3,0:vw8); (0,3,3,0:vw8) */
/******************************************/

/* calc coords, apply mask, and issue loads (if necessary) */
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v6, BufferOOB
/* (d1,vc1,d0,vc0)=(0,0,0,0) */
v_cmp_lt_u32 s12, v0, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v7, v3, v0, 2                       // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v7, v6, v7, s14                      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,1,0) */
v_add_co_u32 v4, vcc_lo, v0, 32                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v8, v3, v4, 2                       // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v8, v6, v8, s14                      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,2,0) */
v_add_co_u32 v4, vcc_lo, v0, 64                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v9, v3, v4, 2                       // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v9, v6, v9, s14                      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,3,0) */
s_mov_b32 s12, 96                                  // coordOffset0 d0=3 vc0=0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v10, v3, v4, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v10, v6, v10, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,0,0) */
v_add_co_u32 v1, vcc_lo, v1, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v2, v2, s[sgprStrideC1J]              // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v3, v3, s[sgprStrideD1J]              // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v0, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v11, v3, v0, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v11, v6, v11, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,1,0) */
v_add_co_u32 v4, vcc_lo, v0, 32                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v12, v3, v4, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v12, v6, v12, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,2,0) */
v_add_co_u32 v4, vcc_lo, v0, 64                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v13, v3, v4, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v13, v6, v13, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,3,0) */
s_mov_b32 s12, 96                                  // coordOffset0 d0=3 vc0=0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v142, v3, v4, 2                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v142, v6, v142, s14                  // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,0,0) */
v_add_co_u32 v1, vcc_lo, v1, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v2, v2, s[sgprStrideC1J]              // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v3, v3, s[sgprStrideD1J]              // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v0, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v143, v3, v0, 2                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v143, v6, v143, s14                  // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,1,0) */
v_add_co_u32 v4, vcc_lo, v0, 32                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[272-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[272-256], v6, v[272-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,2,0) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 64                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[273-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[273-256], v6, v[273-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,3,0) */
s_mov_b32 s12, 96                                  // coordOffset0 d0=3 vc0=0
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[274-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[274-256], v6, v[274-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,0,0) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v1, vcc_lo, v1, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v2, v2, s[sgprStrideC1J]              // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v3, v3, s[sgprStrideD1J]              // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v0, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[275-256], v3, v0, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[275-256], v6, v[275-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,1,0) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 32                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[277-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[277-256], v6, v[277-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,2,0) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 64                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[278-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[278-256], v6, v[278-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,3,0) */
s_mov_b32 s12, 96                                  // coordOffset0 d0=3 vc0=0
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[279-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[279-256], v6, v[279-256], s14      // LDD clip if OOB. offset

/* rC *= alpha batchElements=[(0, 0, 0, 0), (0, 1, 0, 0), (0, 2, 0, 0), (0, 3, 0, 0), (0, 0, 1, 0), (0, 1, 1, 0), (0, 2, 1, 0), (0, 3, 1, 0), (0, 0, 2, 0), (0, 1, 2, 0), (0, 2, 2, 0), (0, 3, 2, 0), (0, 0, 3, 0), (0, 1, 3, 0), (0, 2, 3, 0), (0, 3, 3, 0)] */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_mul_f32 v[vgprValuC+130], s[sgprAlpha], v[vgprValuC+0] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+131], s[sgprAlpha], v[vgprValuC+1] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+132], s[sgprAlpha], v[vgprValuC+2] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+133], s[sgprAlpha], v[vgprValuC+3] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+134], s[sgprAlpha], v[vgprValuC+4] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+135], s[sgprAlpha], v[vgprValuC+5] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+136], s[sgprAlpha], v[vgprValuC+6] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+137], s[sgprAlpha], v[vgprValuC+7] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+138], s[sgprAlpha], v[vgprValuC+8] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+139], s[sgprAlpha], v[vgprValuC+9] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+140], s[sgprAlpha], v[vgprValuC+10] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+141], s[sgprAlpha], v[vgprValuC+11] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+142], s[sgprAlpha], v[vgprValuC+12] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+143], s[sgprAlpha], v[vgprValuC+13] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+144], s[sgprAlpha], v[vgprValuC+14] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+145], s[sgprAlpha], v[vgprValuC+15] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+146], s[sgprAlpha], v[vgprValuC+16] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+147], s[sgprAlpha], v[vgprValuC+17] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+148], s[sgprAlpha], v[vgprValuC+18] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+149], s[sgprAlpha], v[vgprValuC+19] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+150], s[sgprAlpha], v[vgprValuC+20] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+151], s[sgprAlpha], v[vgprValuC+21] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+152], s[sgprAlpha], v[vgprValuC+22] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+153], s[sgprAlpha], v[vgprValuC+23] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+154], s[sgprAlpha], v[vgprValuC+24] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+155], s[sgprAlpha], v[vgprValuC+25] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+156], s[sgprAlpha], v[vgprValuC+26] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+157], s[sgprAlpha], v[vgprValuC+27] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+158], s[sgprAlpha], v[vgprValuC+28] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+159], s[sgprAlpha], v[vgprValuC+29] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+160], s[sgprAlpha], v[vgprValuC+30] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+161], s[sgprAlpha], v[vgprValuC+31] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+162], s[sgprAlpha], v[vgprValuC+32] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+163], s[sgprAlpha], v[vgprValuC+33] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+164], s[sgprAlpha], v[vgprValuC+34] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+165], s[sgprAlpha], v[vgprValuC+35] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+166], s[sgprAlpha], v[vgprValuC+36] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+167], s[sgprAlpha], v[vgprValuC+37] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+168], s[sgprAlpha], v[vgprValuC+38] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+169], s[sgprAlpha], v[vgprValuC+39] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+170], s[sgprAlpha], v[vgprValuC+40] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+171], s[sgprAlpha], v[vgprValuC+41] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+172], s[sgprAlpha], v[vgprValuC+42] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+173], s[sgprAlpha], v[vgprValuC+43] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+174], s[sgprAlpha], v[vgprValuC+44] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+175], s[sgprAlpha], v[vgprValuC+45] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+176], s[sgprAlpha], v[vgprValuC+46] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+177], s[sgprAlpha], v[vgprValuC+47] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+178], s[sgprAlpha], v[vgprValuC+48] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+179], s[sgprAlpha], v[vgprValuC+49] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+180], s[sgprAlpha], v[vgprValuC+50] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+181], s[sgprAlpha], v[vgprValuC+51] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+182], s[sgprAlpha], v[vgprValuC+52] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+183], s[sgprAlpha], v[vgprValuC+53] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+184], s[sgprAlpha], v[vgprValuC+54] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+185], s[sgprAlpha], v[vgprValuC+55] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+186], s[sgprAlpha], v[vgprValuC+56] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+187], s[sgprAlpha], v[vgprValuC+57] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+188], s[sgprAlpha], v[vgprValuC+58] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+189], s[sgprAlpha], v[vgprValuC+59] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+190], s[sgprAlpha], v[vgprValuC+60] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+191], s[sgprAlpha], v[vgprValuC+61] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+192], s[sgprAlpha], v[vgprValuC+62] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+193], s[sgprAlpha], v[vgprValuC+63] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+194], s[sgprAlpha], v[vgprValuC+64] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+195], s[sgprAlpha], v[vgprValuC+65] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+196], s[sgprAlpha], v[vgprValuC+66] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+197], s[sgprAlpha], v[vgprValuC+67] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+198], s[sgprAlpha], v[vgprValuC+68] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+199], s[sgprAlpha], v[vgprValuC+69] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+200], s[sgprAlpha], v[vgprValuC+70] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+201], s[sgprAlpha], v[vgprValuC+71] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+202], s[sgprAlpha], v[vgprValuC+72] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+203], s[sgprAlpha], v[vgprValuC+73] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+204], s[sgprAlpha], v[vgprValuC+74] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+205], s[sgprAlpha], v[vgprValuC+75] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+206], s[sgprAlpha], v[vgprValuC+76] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+207], s[sgprAlpha], v[vgprValuC+77] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+208], s[sgprAlpha], v[vgprValuC+78] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+209], s[sgprAlpha], v[vgprValuC+79] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+210], s[sgprAlpha], v[vgprValuC+80] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+211], s[sgprAlpha], v[vgprValuC+81] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+212], s[sgprAlpha], v[vgprValuC+82] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+213], s[sgprAlpha], v[vgprValuC+83] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+214], s[sgprAlpha], v[vgprValuC+84] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+215], s[sgprAlpha], v[vgprValuC+85] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+216], s[sgprAlpha], v[vgprValuC+86] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+217], s[sgprAlpha], v[vgprValuC+87] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+218], s[sgprAlpha], v[vgprValuC+88] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+219], s[sgprAlpha], v[vgprValuC+89] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+220], s[sgprAlpha], v[vgprValuC+90] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+221], s[sgprAlpha], v[vgprValuC+91] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+222], s[sgprAlpha], v[vgprValuC+92] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+223], s[sgprAlpha], v[vgprValuC+93] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+224], s[sgprAlpha], v[vgprValuC+94] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+225], s[sgprAlpha], v[vgprValuC+95] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+226], s[sgprAlpha], v[vgprValuC+96] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+227], s[sgprAlpha], v[vgprValuC+97] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+228], s[sgprAlpha], v[vgprValuC+98] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+229], s[sgprAlpha], v[vgprValuC+99] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+230], s[sgprAlpha], v[vgprValuC+100] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+231], s[sgprAlpha], v[vgprValuC+101] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+232], s[sgprAlpha], v[vgprValuC+102] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+233], s[sgprAlpha], v[vgprValuC+103] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+234], s[sgprAlpha], v[vgprValuC+104] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+235], s[sgprAlpha], v[vgprValuC+105] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+236], s[sgprAlpha], v[vgprValuC+106] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+237], s[sgprAlpha], v[vgprValuC+107] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+238], s[sgprAlpha], v[vgprValuC+108] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+239], s[sgprAlpha], v[vgprValuC+109] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+240], s[sgprAlpha], v[vgprValuC+110] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+241], s[sgprAlpha], v[vgprValuC+111] // Multiply MI out reg with alpha
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_mul_f32 v[vgprValuC+242-256], s[sgprAlpha], v[vgprValuC+112] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+243-256], s[sgprAlpha], v[vgprValuC+113] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+244-256], s[sgprAlpha], v[vgprValuC+114] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+245-256], s[sgprAlpha], v[vgprValuC+115] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+246-256], s[sgprAlpha], v[vgprValuC+116] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+247-256], s[sgprAlpha], v[vgprValuC+117] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+248-256], s[sgprAlpha], v[vgprValuC+118] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+249-256], s[sgprAlpha], v[vgprValuC+119] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+250-256], s[sgprAlpha], v[vgprValuC+120] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+251-256], s[sgprAlpha], v[vgprValuC+121] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+252-256], s[sgprAlpha], v[vgprValuC+122] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+253-256], s[sgprAlpha], v[vgprValuC+123] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+254-256], s[sgprAlpha], v[vgprValuC+124] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+255-256], s[sgprAlpha], v[vgprValuC+125] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+256-256], s[sgprAlpha], v[vgprValuC+126] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+257-256], s[sgprAlpha], v[vgprValuC+127] // Multiply MI out reg with alpha

/* apply mask, calc new C and issue writes */
s_set_vgpr_msb 16384                               // src0: 0, src1: 0, src2: 0, dst: 0
s_wait_alu depctr_va_vdst(14)
buffer_store_b128 v[144:147], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[148:151], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:16 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[152:155], v8, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[156:159], v8, s[sgprSrdD:sgprSrdD+3], null offen offset:16 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[160:163], v9, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[164:167], v9, s[sgprSrdD:sgprSrdD+3], null offen offset:16 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[168:171], v10, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[172:175], v10, s[sgprSrdD:sgprSrdD+3], null offen offset:16 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[176:179], v11, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[180:183], v11, s[sgprSrdD:sgprSrdD+3], null offen offset:16 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[184:187], v12, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[188:191], v12, s[sgprSrdD:sgprSrdD+3], null offen offset:16 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[192:195], v13, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[196:199], v13, s[sgprSrdD:sgprSrdD+3], null offen offset:16 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[200:203], v142, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[204:207], v142, s[sgprSrdD:sgprSrdD+3], null offen offset:16 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[208:211], v143, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[212:215], v143, s[sgprSrdD:sgprSrdD+3], null offen offset:16 scope:SCOPE_CU th:TH_STORE_RT // store D
s_set_vgpr_msb 1                                   // src0: 1, src1: 0, src2: 0, dst: 0
buffer_store_b128 v[216:219], v[272-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[220:223], v[272-256], s[sgprSrdD:sgprSrdD+3], null offen offset:16 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[224:227], v[273-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[228:231], v[273-256], s[sgprSrdD:sgprSrdD+3], null offen offset:16 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[232:235], v[274-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[236:239], v[274-256], s[sgprSrdD:sgprSrdD+3], null offen offset:16 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[240:243], v[275-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[244:247], v[275-256], s[sgprSrdD:sgprSrdD+3], null offen offset:16 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[248:251], v[277-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b128 v[252:255], v[277-256], s[sgprSrdD:sgprSrdD+3], null offen offset:16 scope:SCOPE_CU th:TH_STORE_RT // store D
s_set_vgpr_msb 321                                 // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(12)
buffer_store_b128 v[256-256:259-256], v[278-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(8)
buffer_store_b128 v[260-256:263-256], v[278-256], s[sgprSrdD:sgprSrdD+3], null offen offset:16 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(4)
buffer_store_b128 v[264-256:267-256], v[279-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(0)
buffer_store_b128 v[268-256:271-256], v[279-256], s[sgprSrdD:sgprSrdD+3], null offen offset:16 scope:SCOPE_CU th:TH_STORE_RT // store D
s_nop 0                                            // 1 wait state required when next inst writes vgprs held by previous dwordx4 store inst
s_branch label_GW_End_1                            // jump to end
label_GW_B0_FD0_VW8_GSU1_Else:
label_GW_B0_FD0_VW1_GSU1_Else:
label_GW_B0_FD0_VW1_GSU1_Then:

/* edge=1, allocate 3 sgpr. perBatchTmpS=2 perBatchMaskS=1 perElementMaskS=0 elementsPerBatch=271 */
/* optSingleColVgpr=0 optSharedColVgpr=0 optSGPRUsage=BufferLoad_Edge_Mask optSrdIncForRow=0 factorDim=0 */

/******************************************/
/* Global Write Edge Batch #0 (d1,d0,vc1,vc0) = */
/*    (0,0,0,0:vw1); (0,0,0,1:vw1); (0,0,0,2:vw1); (0,0,0,3:vw1); (0,0,0,4:vw1); (0,0,0,5:vw1); (0,0,0,6:vw1); (0,0,0,7:vw1); (0,1,0,0:vw1); (0,1,0,1:vw1); (0,1,0,2:vw1); (0,1,0,3:vw1); (0,1,0,4:vw1); (0,1,0,5:vw1); (0,1,0,6:vw1); (0,1,0,7:vw1); (0,2,0,0:vw1); (0,2,0,1:vw1); (0,2,0,2:vw1); (0,2,0,3:vw1); (0,2,0,4:vw1); (0,2,0,5:vw1); (0,2,0,6:vw1); (0,2,0,7:vw1); (0,3,0,0:vw1); (0,3,0,1:vw1); (0,3,0,2:vw1); (0,3,0,3:vw1); (0,3,0,4:vw1); (0,3,0,5:vw1); (0,3,0,6:vw1); (0,3,0,7:vw1); (0,0,1,0:vw1); (0,0,1,1:vw1); (0,0,1,2:vw1); (0,0,1,3:vw1); (0,0,1,4:vw1); (0,0,1,5:vw1); (0,0,1,6:vw1); (0,0,1,7:vw1); (0,1,1,0:vw1); (0,1,1,1:vw1); (0,1,1,2:vw1); (0,1,1,3:vw1); (0,1,1,4:vw1); (0,1,1,5:vw1); (0,1,1,6:vw1); (0,1,1,7:vw1); (0,2,1,0:vw1); (0,2,1,1:vw1); (0,2,1,2:vw1); (0,2,1,3:vw1); (0,2,1,4:vw1); (0,2,1,5:vw1); (0,2,1,6:vw1); (0,2,1,7:vw1); (0,3,1,0:vw1); (0,3,1,1:vw1); (0,3,1,2:vw1); (0,3,1,3:vw1); (0,3,1,4:vw1); (0,3,1,5:vw1); (0,3,1,6:vw1); (0,3,1,7:vw1); (0,0,2,0:vw1); (0,0,2,1:vw1); (0,0,2,2:vw1); (0,0,2,3:vw1); (0,0,2,4:vw1); (0,0,2,5:vw1); (0,0,2,6:vw1); (0,0,2,7:vw1); (0,1,2,0:vw1); (0,1,2,1:vw1); (0,1,2,2:vw1); (0,1,2,3:vw1); (0,1,2,4:vw1); (0,1,2,5:vw1); (0,1,2,6:vw1); (0,1,2,7:vw1); (0,2,2,0:vw1); (0,2,2,1:vw1); (0,2,2,2:vw1); (0,2,2,3:vw1); (0,2,2,4:vw1); (0,2,2,5:vw1); (0,2,2,6:vw1); (0,2,2,7:vw1); (0,3,2,0:vw1); (0,3,2,1:vw1); (0,3,2,2:vw1); (0,3,2,3:vw1); (0,3,2,4:vw1); (0,3,2,5:vw1); (0,3,2,6:vw1); (0,3,2,7:vw1); (0,0,3,0:vw1); (0,0,3,1:vw1); (0,0,3,2:vw1); (0,0,3,3:vw1); (0,0,3,4:vw1); (0,0,3,5:vw1); (0,0,3,6:vw1); (0,0,3,7:vw1); (0,1,3,0:vw1); (0,1,3,1:vw1); (0,1,3,2:vw1); (0,1,3,3:vw1); (0,1,3,4:vw1); (0,1,3,5:vw1); (0,1,3,6:vw1); (0,1,3,7:vw1); (0,2,3,0:vw1); (0,2,3,1:vw1); (0,2,3,2:vw1); (0,2,3,3:vw1); (0,2,3,4:vw1); (0,2,3,5:vw1); (0,2,3,6:vw1); (0,2,3,7:vw1); (0,3,3,0:vw1); (0,3,3,1:vw1); (0,3,3,2:vw1); (0,3,3,3:vw1); (0,3,3,4:vw1); (0,3,3,5:vw1); (0,3,3,6:vw1); (0,3,3,7:vw1) */
/******************************************/

/* calc coords, apply mask, and issue loads (if necessary) */
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v6, BufferOOB
/* (d1,vc1,d0,vc0)=(0,0,0,0) */
v_cmp_lt_u32 s12, v0, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[263-256], v3, v0, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[263-256], v6, v[263-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,0,1) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 1                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[264-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[264-256], v6, v[264-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,0,2) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 2                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[265-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[265-256], v6, v[265-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,0,3) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 3                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[266-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[266-256], v6, v[266-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,0,4) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 4                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[267-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[267-256], v6, v[267-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,0,5) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 5                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[268-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[268-256], v6, v[268-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,0,6) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 6                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[269-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[269-256], v6, v[269-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,0,7) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 7                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[270-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[270-256], v6, v[270-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,1,0) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 32                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[271-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[271-256], v6, v[271-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,1,1) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 33                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[272-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[272-256], v6, v[272-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,1,2) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 34                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[273-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[273-256], v6, v[273-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,1,3) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 35                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[274-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[274-256], v6, v[274-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,1,4) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 36                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[275-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[275-256], v6, v[275-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,1,5) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 37                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[277-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[277-256], v6, v[277-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,1,6) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 38                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[278-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[278-256], v6, v[278-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,1,7) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 39                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[279-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[279-256], v6, v[279-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,2,0) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 64                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[280-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[280-256], v6, v[280-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,2,1) */
s_mov_b32 s12, 65                                  // coordOffset0 d0=2 vc0=1
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[281-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[281-256], v6, v[281-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,2,2) */
s_mov_b32 s12, 66                                  // coordOffset0 d0=2 vc0=2
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[282-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[282-256], v6, v[282-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,2,3) */
s_mov_b32 s12, 67                                  // coordOffset0 d0=2 vc0=3
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[283-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[283-256], v6, v[283-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,2,4) */
s_mov_b32 s12, 68                                  // coordOffset0 d0=2 vc0=4
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[284-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[284-256], v6, v[284-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,2,5) */
s_mov_b32 s12, 69                                  // coordOffset0 d0=2 vc0=5
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[285-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[285-256], v6, v[285-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,2,6) */
s_mov_b32 s12, 70                                  // coordOffset0 d0=2 vc0=6
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[286-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[286-256], v6, v[286-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,2,7) */
s_mov_b32 s12, 71                                  // coordOffset0 d0=2 vc0=7
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[287-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[287-256], v6, v[287-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,3,0) */
s_mov_b32 s12, 96                                  // coordOffset0 d0=3 vc0=0
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[288-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[288-256], v6, v[288-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,3,1) */
s_mov_b32 s12, 97                                  // coordOffset0 d0=3 vc0=1
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[289-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[289-256], v6, v[289-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,3,2) */
s_mov_b32 s12, 98                                  // coordOffset0 d0=3 vc0=2
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[290-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[290-256], v6, v[290-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,3,3) */
s_mov_b32 s12, 99                                  // coordOffset0 d0=3 vc0=3
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[291-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[291-256], v6, v[291-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,3,4) */
s_mov_b32 s12, 100                                 // coordOffset0 d0=3 vc0=4
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[292-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[292-256], v6, v[292-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,3,5) */
s_mov_b32 s12, 101                                 // coordOffset0 d0=3 vc0=5
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[293-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[293-256], v6, v[293-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,3,6) */
s_mov_b32 s12, 102                                 // coordOffset0 d0=3 vc0=6
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[294-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[294-256], v6, v[294-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,3,7) */
s_mov_b32 s12, 103                                 // coordOffset0 d0=3 vc0=7
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[295-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[295-256], v6, v[295-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,0,0) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v1, vcc_lo, v1, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v2, v2, s[sgprStrideC1J]              // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v3, v3, s[sgprStrideD1J]              // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v0, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[296-256], v3, v0, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[296-256], v6, v[296-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,0,1) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 1                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[297-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[297-256], v6, v[297-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,0,2) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 2                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[298-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[298-256], v6, v[298-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,0,3) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 3                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[299-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[299-256], v6, v[299-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,0,4) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 4                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[300-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[300-256], v6, v[300-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,0,5) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 5                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[301-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[301-256], v6, v[301-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,0,6) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 6                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[302-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[302-256], v6, v[302-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,0,7) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 7                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[303-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[303-256], v6, v[303-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,1,0) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 32                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[304-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[304-256], v6, v[304-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,1,1) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 33                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[305-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[305-256], v6, v[305-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,1,2) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 34                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[306-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[306-256], v6, v[306-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,1,3) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 35                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[307-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[307-256], v6, v[307-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,1,4) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 36                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[308-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[308-256], v6, v[308-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,1,5) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 37                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[309-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[309-256], v6, v[309-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,1,6) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 38                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[310-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[310-256], v6, v[310-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,1,7) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 39                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[311-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[311-256], v6, v[311-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,2,0) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 64                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[312-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[312-256], v6, v[312-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,2,1) */
s_mov_b32 s12, 65                                  // coordOffset0 d0=2 vc0=1
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[313-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[313-256], v6, v[313-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,2,2) */
s_mov_b32 s12, 66                                  // coordOffset0 d0=2 vc0=2
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[314-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[314-256], v6, v[314-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,2,3) */
s_mov_b32 s12, 67                                  // coordOffset0 d0=2 vc0=3
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[315-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[315-256], v6, v[315-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,2,4) */
s_mov_b32 s12, 68                                  // coordOffset0 d0=2 vc0=4
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[316-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[316-256], v6, v[316-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,2,5) */
s_mov_b32 s12, 69                                  // coordOffset0 d0=2 vc0=5
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[317-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[317-256], v6, v[317-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,2,6) */
s_mov_b32 s12, 70                                  // coordOffset0 d0=2 vc0=6
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[318-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[318-256], v6, v[318-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,2,7) */
s_mov_b32 s12, 71                                  // coordOffset0 d0=2 vc0=7
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[319-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[319-256], v6, v[319-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,3,0) */
s_mov_b32 s12, 96                                  // coordOffset0 d0=3 vc0=0
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[320-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[320-256], v6, v[320-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,3,1) */
s_mov_b32 s12, 97                                  // coordOffset0 d0=3 vc0=1
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[321-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[321-256], v6, v[321-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,3,2) */
s_mov_b32 s12, 98                                  // coordOffset0 d0=3 vc0=2
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[322-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[322-256], v6, v[322-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,3,3) */
s_mov_b32 s12, 99                                  // coordOffset0 d0=3 vc0=3
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[323-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[323-256], v6, v[323-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,3,4) */
s_mov_b32 s12, 100                                 // coordOffset0 d0=3 vc0=4
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[324-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[324-256], v6, v[324-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,3,5) */
s_mov_b32 s12, 101                                 // coordOffset0 d0=3 vc0=5
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[325-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[325-256], v6, v[325-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,3,6) */
s_mov_b32 s12, 102                                 // coordOffset0 d0=3 vc0=6
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[326-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[326-256], v6, v[326-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,3,7) */
s_mov_b32 s12, 103                                 // coordOffset0 d0=3 vc0=7
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[327-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[327-256], v6, v[327-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,0,0) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v1, vcc_lo, v1, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v2, v2, s[sgprStrideC1J]              // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v3, v3, s[sgprStrideD1J]              // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v0, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[328-256], v3, v0, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[328-256], v6, v[328-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,0,1) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 1                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[329-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[329-256], v6, v[329-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,0,2) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 2                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[330-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[330-256], v6, v[330-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,0,3) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 3                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[331-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[331-256], v6, v[331-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,0,4) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 4                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[332-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[332-256], v6, v[332-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,0,5) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 5                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[333-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[333-256], v6, v[333-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,0,6) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 6                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[334-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[334-256], v6, v[334-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,0,7) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 7                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[335-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[335-256], v6, v[335-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,1,0) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 32                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[336-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[336-256], v6, v[336-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,1,1) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 33                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[337-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[337-256], v6, v[337-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,1,2) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 34                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[338-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[338-256], v6, v[338-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,1,3) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 35                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[339-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[339-256], v6, v[339-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,1,4) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 36                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[340-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[340-256], v6, v[340-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,1,5) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 37                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[341-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[341-256], v6, v[341-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,1,6) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 38                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[342-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[342-256], v6, v[342-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,1,7) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 39                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[343-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[343-256], v6, v[343-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,2,0) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 64                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[344-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[344-256], v6, v[344-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,2,1) */
s_mov_b32 s12, 65                                  // coordOffset0 d0=2 vc0=1
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[345-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[345-256], v6, v[345-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,2,2) */
s_mov_b32 s12, 66                                  // coordOffset0 d0=2 vc0=2
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[346-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[346-256], v6, v[346-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,2,3) */
s_mov_b32 s12, 67                                  // coordOffset0 d0=2 vc0=3
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[347-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[347-256], v6, v[347-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,2,4) */
s_mov_b32 s12, 68                                  // coordOffset0 d0=2 vc0=4
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
s_wait_xcnt 0
s_prefetch_inst_pc_rel 0, null, 31
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[348-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[348-256], v6, v[348-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,2,5) */
s_mov_b32 s12, 69                                  // coordOffset0 d0=2 vc0=5
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[349-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[349-256], v6, v[349-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,2,6) */
s_mov_b32 s12, 70                                  // coordOffset0 d0=2 vc0=6
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[350-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[350-256], v6, v[350-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,2,7) */
s_mov_b32 s12, 71                                  // coordOffset0 d0=2 vc0=7
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[351-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[351-256], v6, v[351-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,3,0) */
s_mov_b32 s12, 96                                  // coordOffset0 d0=3 vc0=0
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[352-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[352-256], v6, v[352-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,3,1) */
s_mov_b32 s12, 97                                  // coordOffset0 d0=3 vc0=1
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[353-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[353-256], v6, v[353-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,3,2) */
s_mov_b32 s12, 98                                  // coordOffset0 d0=3 vc0=2
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[354-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[354-256], v6, v[354-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,3,3) */
s_mov_b32 s12, 99                                  // coordOffset0 d0=3 vc0=3
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[355-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[355-256], v6, v[355-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,3,4) */
s_mov_b32 s12, 100                                 // coordOffset0 d0=3 vc0=4
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[356-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[356-256], v6, v[356-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,3,5) */
s_mov_b32 s12, 101                                 // coordOffset0 d0=3 vc0=5
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[357-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[357-256], v6, v[357-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,3,6) */
s_mov_b32 s12, 102                                 // coordOffset0 d0=3 vc0=6
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[358-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[358-256], v6, v[358-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,3,7) */
s_mov_b32 s12, 103                                 // coordOffset0 d0=3 vc0=7
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[359-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[359-256], v6, v[359-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,0,0) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v1, vcc_lo, v1, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v2, v2, s[sgprStrideC1J]              // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v3, v3, s[sgprStrideD1J]              // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v0, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[360-256], v3, v0, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[360-256], v6, v[360-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,0,1) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 1                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[361-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[361-256], v6, v[361-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,0,2) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 2                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[362-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[362-256], v6, v[362-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,0,3) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 3                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[363-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[363-256], v6, v[363-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,0,4) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 4                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[364-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[364-256], v6, v[364-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,0,5) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 5                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[365-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[365-256], v6, v[365-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,0,6) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 6                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[366-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[366-256], v6, v[366-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,0,7) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 7                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[367-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[367-256], v6, v[367-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,1,0) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 32                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[368-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[368-256], v6, v[368-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,1,1) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 33                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[369-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[369-256], v6, v[369-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,1,2) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 34                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[370-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[370-256], v6, v[370-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,1,3) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 35                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[371-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[371-256], v6, v[371-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,1,4) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 36                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[372-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[372-256], v6, v[372-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,1,5) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 37                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[373-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[373-256], v6, v[373-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,1,6) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 38                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[374-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[374-256], v6, v[374-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,1,7) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 39                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[375-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[375-256], v6, v[375-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,2,0) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 64                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[376-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[376-256], v6, v[376-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,2,1) */
s_mov_b32 s12, 65                                  // coordOffset0 d0=2 vc0=1
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[377-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[377-256], v6, v[377-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,2,2) */
s_mov_b32 s12, 66                                  // coordOffset0 d0=2 vc0=2
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[378-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[378-256], v6, v[378-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,2,3) */
s_mov_b32 s12, 67                                  // coordOffset0 d0=2 vc0=3
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[379-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[379-256], v6, v[379-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,2,4) */
s_mov_b32 s12, 68                                  // coordOffset0 d0=2 vc0=4
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[380-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[380-256], v6, v[380-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,2,5) */
s_mov_b32 s12, 69                                  // coordOffset0 d0=2 vc0=5
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[381-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[381-256], v6, v[381-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,2,6) */
s_mov_b32 s12, 70                                  // coordOffset0 d0=2 vc0=6
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[382-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[382-256], v6, v[382-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,2,7) */
s_mov_b32 s12, 71                                  // coordOffset0 d0=2 vc0=7
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[383-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[383-256], v6, v[383-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,3,0) */
s_mov_b32 s12, 96                                  // coordOffset0 d0=3 vc0=0
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[384-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[384-256], v6, v[384-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,3,1) */
s_mov_b32 s12, 97                                  // coordOffset0 d0=3 vc0=1
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[385-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[385-256], v6, v[385-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,3,2) */
s_mov_b32 s12, 98                                  // coordOffset0 d0=3 vc0=2
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[386-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[386-256], v6, v[386-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,3,3) */
s_mov_b32 s12, 99                                  // coordOffset0 d0=3 vc0=3
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[387-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[387-256], v6, v[387-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,3,4) */
s_mov_b32 s12, 100                                 // coordOffset0 d0=3 vc0=4
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[388-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[388-256], v6, v[388-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,3,5) */
s_mov_b32 s12, 101                                 // coordOffset0 d0=3 vc0=5
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[389-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[389-256], v6, v[389-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,3,6) */
s_mov_b32 s12, 102                                 // coordOffset0 d0=3 vc0=6
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[390-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[390-256], v6, v[390-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,3,7) */
s_mov_b32 s12, 103                                 // coordOffset0 d0=3 vc0=7
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[391-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[391-256], v6, v[391-256], s14      // LDD clip if OOB. offset

/* rC *= alpha batchElements=[(0, 0, 0, 0), (0, 0, 0, 1), (0, 0, 0, 2), (0, 0, 0, 3), (0, 0, 0, 4), (0, 0, 0, 5), (0, 0, 0, 6), (0, 0, 0, 7), (0, 1, 0, 0), (0, 1, 0, 1), (0, 1, 0, 2), (0, 1, 0, 3), (0, 1, 0, 4), (0, 1, 0, 5), (0, 1, 0, 6), (0, 1, 0, 7), (0, 2, 0, 0), (0, 2, 0, 1), (0, 2, 0, 2), (0, 2, 0, 3), (0, 2, 0, 4), (0, 2, 0, 5), (0, 2, 0, 6), (0, 2, 0, 7), (0, 3, 0, 0), (0, 3, 0, 1), (0, 3, 0, 2), (0, 3, 0, 3), (0, 3, 0, 4), (0, 3, 0, 5), (0, 3, 0, 6), (0, 3, 0, 7), (0, 0, 1, 0), (0, 0, 1, 1), (0, 0, 1, 2), (0, 0, 1, 3), (0, 0, 1, 4), (0, 0, 1, 5), (0, 0, 1, 6), (0, 0, 1, 7), (0, 1, 1, 0), (0, 1, 1, 1), (0, 1, 1, 2), (0, 1, 1, 3), (0, 1, 1, 4), (0, 1, 1, 5), (0, 1, 1, 6), (0, 1, 1, 7), (0, 2, 1, 0), (0, 2, 1, 1), (0, 2, 1, 2), (0, 2, 1, 3), (0, 2, 1, 4), (0, 2, 1, 5), (0, 2, 1, 6), (0, 2, 1, 7), (0, 3, 1, 0), (0, 3, 1, 1), (0, 3, 1, 2), (0, 3, 1, 3), (0, 3, 1, 4), (0, 3, 1, 5), (0, 3, 1, 6), (0, 3, 1, 7), (0, 0, 2, 0), (0, 0, 2, 1), (0, 0, 2, 2), (0, 0, 2, 3), (0, 0, 2, 4), (0, 0, 2, 5), (0, 0, 2, 6), (0, 0, 2, 7), (0, 1, 2, 0), (0, 1, 2, 1), (0, 1, 2, 2), (0, 1, 2, 3), (0, 1, 2, 4), (0, 1, 2, 5), (0, 1, 2, 6), (0, 1, 2, 7), (0, 2, 2, 0), (0, 2, 2, 1), (0, 2, 2, 2), (0, 2, 2, 3), (0, 2, 2, 4), (0, 2, 2, 5), (0, 2, 2, 6), (0, 2, 2, 7), (0, 3, 2, 0), (0, 3, 2, 1), (0, 3, 2, 2), (0, 3, 2, 3), (0, 3, 2, 4), (0, 3, 2, 5), (0, 3, 2, 6), (0, 3, 2, 7), (0, 0, 3, 0), (0, 0, 3, 1), (0, 0, 3, 2), (0, 0, 3, 3), (0, 0, 3, 4), (0, 0, 3, 5), (0, 0, 3, 6), (0, 0, 3, 7), (0, 1, 3, 0), (0, 1, 3, 1), (0, 1, 3, 2), (0, 1, 3, 3), (0, 1, 3, 4), (0, 1, 3, 5), (0, 1, 3, 6), (0, 1, 3, 7), (0, 2, 3, 0), (0, 2, 3, 1), (0, 2, 3, 2), (0, 2, 3, 3), (0, 2, 3, 4), (0, 2, 3, 5), (0, 2, 3, 6), (0, 2, 3, 7), (0, 3, 3, 0), (0, 3, 3, 1), (0, 3, 3, 2), (0, 3, 3, 3), (0, 3, 3, 4), (0, 3, 3, 5), (0, 3, 3, 6), (0, 3, 3, 7)] */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_mul_f32 v[vgprValuC+-7], s[sgprAlpha], v[vgprValuC+0] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+-6], s[sgprAlpha], v[vgprValuC+1] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+-5], s[sgprAlpha], v[vgprValuC+2] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+-4], s[sgprAlpha], v[vgprValuC+3] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+-3], s[sgprAlpha], v[vgprValuC+4] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+-2], s[sgprAlpha], v[vgprValuC+5] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+-1], s[sgprAlpha], v[vgprValuC+6] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+128], s[sgprAlpha], v[vgprValuC+7] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+129], s[sgprAlpha], v[vgprValuC+8] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+130], s[sgprAlpha], v[vgprValuC+9] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+131], s[sgprAlpha], v[vgprValuC+10] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+132], s[sgprAlpha], v[vgprValuC+11] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+133], s[sgprAlpha], v[vgprValuC+12] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+134], s[sgprAlpha], v[vgprValuC+13] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+135], s[sgprAlpha], v[vgprValuC+14] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+136], s[sgprAlpha], v[vgprValuC+15] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+137], s[sgprAlpha], v[vgprValuC+16] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+138], s[sgprAlpha], v[vgprValuC+17] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+139], s[sgprAlpha], v[vgprValuC+18] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+140], s[sgprAlpha], v[vgprValuC+19] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+141], s[sgprAlpha], v[vgprValuC+20] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+142], s[sgprAlpha], v[vgprValuC+21] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+143], s[sgprAlpha], v[vgprValuC+22] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+144], s[sgprAlpha], v[vgprValuC+23] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+145], s[sgprAlpha], v[vgprValuC+24] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+146], s[sgprAlpha], v[vgprValuC+25] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+147], s[sgprAlpha], v[vgprValuC+26] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+148], s[sgprAlpha], v[vgprValuC+27] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+149], s[sgprAlpha], v[vgprValuC+28] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+150], s[sgprAlpha], v[vgprValuC+29] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+151], s[sgprAlpha], v[vgprValuC+30] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+152], s[sgprAlpha], v[vgprValuC+31] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+153], s[sgprAlpha], v[vgprValuC+32] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+154], s[sgprAlpha], v[vgprValuC+33] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+155], s[sgprAlpha], v[vgprValuC+34] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+156], s[sgprAlpha], v[vgprValuC+35] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+157], s[sgprAlpha], v[vgprValuC+36] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+158], s[sgprAlpha], v[vgprValuC+37] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+159], s[sgprAlpha], v[vgprValuC+38] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+160], s[sgprAlpha], v[vgprValuC+39] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+161], s[sgprAlpha], v[vgprValuC+40] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+162], s[sgprAlpha], v[vgprValuC+41] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+163], s[sgprAlpha], v[vgprValuC+42] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+164], s[sgprAlpha], v[vgprValuC+43] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+165], s[sgprAlpha], v[vgprValuC+44] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+166], s[sgprAlpha], v[vgprValuC+45] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+167], s[sgprAlpha], v[vgprValuC+46] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+168], s[sgprAlpha], v[vgprValuC+47] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+169], s[sgprAlpha], v[vgprValuC+48] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+170], s[sgprAlpha], v[vgprValuC+49] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+171], s[sgprAlpha], v[vgprValuC+50] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+172], s[sgprAlpha], v[vgprValuC+51] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+173], s[sgprAlpha], v[vgprValuC+52] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+174], s[sgprAlpha], v[vgprValuC+53] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+175], s[sgprAlpha], v[vgprValuC+54] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+176], s[sgprAlpha], v[vgprValuC+55] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+177], s[sgprAlpha], v[vgprValuC+56] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+178], s[sgprAlpha], v[vgprValuC+57] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+179], s[sgprAlpha], v[vgprValuC+58] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+180], s[sgprAlpha], v[vgprValuC+59] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+181], s[sgprAlpha], v[vgprValuC+60] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+182], s[sgprAlpha], v[vgprValuC+61] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+183], s[sgprAlpha], v[vgprValuC+62] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+184], s[sgprAlpha], v[vgprValuC+63] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+185], s[sgprAlpha], v[vgprValuC+64] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+186], s[sgprAlpha], v[vgprValuC+65] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+187], s[sgprAlpha], v[vgprValuC+66] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+188], s[sgprAlpha], v[vgprValuC+67] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+189], s[sgprAlpha], v[vgprValuC+68] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+190], s[sgprAlpha], v[vgprValuC+69] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+191], s[sgprAlpha], v[vgprValuC+70] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+192], s[sgprAlpha], v[vgprValuC+71] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+193], s[sgprAlpha], v[vgprValuC+72] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+194], s[sgprAlpha], v[vgprValuC+73] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+195], s[sgprAlpha], v[vgprValuC+74] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+196], s[sgprAlpha], v[vgprValuC+75] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+197], s[sgprAlpha], v[vgprValuC+76] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+198], s[sgprAlpha], v[vgprValuC+77] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+199], s[sgprAlpha], v[vgprValuC+78] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+200], s[sgprAlpha], v[vgprValuC+79] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+201], s[sgprAlpha], v[vgprValuC+80] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+202], s[sgprAlpha], v[vgprValuC+81] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+203], s[sgprAlpha], v[vgprValuC+82] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+204], s[sgprAlpha], v[vgprValuC+83] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+205], s[sgprAlpha], v[vgprValuC+84] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+206], s[sgprAlpha], v[vgprValuC+85] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+207], s[sgprAlpha], v[vgprValuC+86] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+208], s[sgprAlpha], v[vgprValuC+87] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+209], s[sgprAlpha], v[vgprValuC+88] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+210], s[sgprAlpha], v[vgprValuC+89] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+211], s[sgprAlpha], v[vgprValuC+90] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+212], s[sgprAlpha], v[vgprValuC+91] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+213], s[sgprAlpha], v[vgprValuC+92] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+214], s[sgprAlpha], v[vgprValuC+93] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+215], s[sgprAlpha], v[vgprValuC+94] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+216], s[sgprAlpha], v[vgprValuC+95] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+217], s[sgprAlpha], v[vgprValuC+96] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+218], s[sgprAlpha], v[vgprValuC+97] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+219], s[sgprAlpha], v[vgprValuC+98] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+220], s[sgprAlpha], v[vgprValuC+99] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+221], s[sgprAlpha], v[vgprValuC+100] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+222], s[sgprAlpha], v[vgprValuC+101] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+223], s[sgprAlpha], v[vgprValuC+102] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+224], s[sgprAlpha], v[vgprValuC+103] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+225], s[sgprAlpha], v[vgprValuC+104] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+226], s[sgprAlpha], v[vgprValuC+105] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+227], s[sgprAlpha], v[vgprValuC+106] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+228], s[sgprAlpha], v[vgprValuC+107] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+229], s[sgprAlpha], v[vgprValuC+108] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+230], s[sgprAlpha], v[vgprValuC+109] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+231], s[sgprAlpha], v[vgprValuC+110] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+232], s[sgprAlpha], v[vgprValuC+111] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+233], s[sgprAlpha], v[vgprValuC+112] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+234], s[sgprAlpha], v[vgprValuC+113] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+235], s[sgprAlpha], v[vgprValuC+114] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+236], s[sgprAlpha], v[vgprValuC+115] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+237], s[sgprAlpha], v[vgprValuC+116] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+238], s[sgprAlpha], v[vgprValuC+117] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+239], s[sgprAlpha], v[vgprValuC+118] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+240], s[sgprAlpha], v[vgprValuC+119] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+241], s[sgprAlpha], v[vgprValuC+120] // Multiply MI out reg with alpha
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_mul_f32 v[vgprValuC+242-256], s[sgprAlpha], v[vgprValuC+121] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+243-256], s[sgprAlpha], v[vgprValuC+122] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+244-256], s[sgprAlpha], v[vgprValuC+123] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+245-256], s[sgprAlpha], v[vgprValuC+124] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+246-256], s[sgprAlpha], v[vgprValuC+125] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+247-256], s[sgprAlpha], v[vgprValuC+126] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+248-256], s[sgprAlpha], v[vgprValuC+127] // Multiply MI out reg with alpha

/* apply mask, calc new C and issue writes */
s_set_vgpr_msb 16385                               // src0: 1, src1: 0, src2: 0, dst: 0
s_wait_alu depctr_va_vdst(14)
buffer_store_b32 v7, v[263-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v8, v[264-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v9, v[265-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v10, v[266-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v11, v[267-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v12, v[268-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v13, v[269-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v142, v[270-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v143, v[271-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v144, v[272-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v145, v[273-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v146, v[274-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v147, v[275-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v148, v[277-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v149, v[278-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v150, v[279-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v151, v[280-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v152, v[281-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v153, v[282-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v154, v[283-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v155, v[284-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v156, v[285-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v157, v[286-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v158, v[287-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v159, v[288-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v160, v[289-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v161, v[290-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v162, v[291-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v163, v[292-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v164, v[293-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v165, v[294-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v166, v[295-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v167, v[296-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v168, v[297-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v169, v[298-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v170, v[299-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v171, v[300-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v172, v[301-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v173, v[302-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v174, v[303-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v175, v[304-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v176, v[305-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v177, v[306-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v178, v[307-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v179, v[308-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v180, v[309-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v181, v[310-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v182, v[311-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v183, v[312-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v184, v[313-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v185, v[314-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v186, v[315-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v187, v[316-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v188, v[317-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v189, v[318-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v190, v[319-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v191, v[320-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v192, v[321-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v193, v[322-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v194, v[323-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v195, v[324-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v196, v[325-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v197, v[326-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v198, v[327-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v199, v[328-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v200, v[329-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v201, v[330-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v202, v[331-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v203, v[332-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v204, v[333-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v205, v[334-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v206, v[335-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_xcnt 0
s_prefetch_inst_pc_rel 0, null, 31
buffer_store_b32 v207, v[336-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v208, v[337-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v209, v[338-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v210, v[339-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v211, v[340-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v212, v[341-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v213, v[342-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v214, v[343-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v215, v[344-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v216, v[345-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v217, v[346-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v218, v[347-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v219, v[348-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v220, v[349-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v221, v[350-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v222, v[351-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v223, v[352-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v224, v[353-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v225, v[354-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v226, v[355-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v227, v[356-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v228, v[357-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v229, v[358-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v230, v[359-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v231, v[360-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v232, v[361-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v233, v[362-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v234, v[363-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v235, v[364-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v236, v[365-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v237, v[366-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v238, v[367-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v239, v[368-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v240, v[369-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v241, v[370-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v242, v[371-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v243, v[372-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v244, v[373-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v245, v[374-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v246, v[375-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v247, v[376-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v248, v[377-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(13)
buffer_store_b32 v249, v[378-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(12)
buffer_store_b32 v250, v[379-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(11)
buffer_store_b32 v251, v[380-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(10)
buffer_store_b32 v252, v[381-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(9)
buffer_store_b32 v253, v[382-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(8)
buffer_store_b32 v254, v[383-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(7)
buffer_store_b32 v255, v[384-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_set_vgpr_msb 321                                 // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(6)
buffer_store_b32 v[256-256], v[385-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(5)
buffer_store_b32 v[257-256], v[386-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(4)
buffer_store_b32 v[258-256], v[387-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(3)
buffer_store_b32 v[259-256], v[388-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(2)
buffer_store_b32 v[260-256], v[389-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(1)
buffer_store_b32 v[261-256], v[390-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v[262-256], v[391-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_nop 0                                            // 1 wait state required when next inst writes vgprs held by previous dwordx4 store inst
s_branch label_GW_End_1                            // jump to end
label_GW_B1_GSU1:
label_GW_B1_FD0_GSU1:

/* Edge/NonEdge store path check (M): Size % 128 > 0 -> Edge store; else -> NonEdge store */
s_wait_xcnt 0
s_prefetch_inst_pc_rel 0, null, 31
s_and_b32 s28, 127, s[sgprSizeI]                   // s28 = s[sgprSizeI] % 128
s_add_u32 s29, -0x1, s[sgprNumWorkGroups0]
s_cmp_ge_u32 s[sgprWorkGroup0], s29                // wg0 >= nwg0-1 ?
s_cselect_b32 s28, s28, 0                          // set rem
s_mov_b32 s5, 0
s_cmp_gt_u32 s28, s5                               // rem > 0
s_cbranch_scc1 label_GW_B1_FD0_VW8_GSU1_Else       // jump if edges required

/* Edge/NonEdge store path check (N (isSize1)): Size % 128 > 0 -> Edge store; else -> NonEdge store */
s_wait_xcnt 0
s_prefetch_inst_pc_rel 0, null, 31
s_and_b32 s28, 127, s[sgprSizeJ]                   // s28 = s[sgprSizeJ] % 128
s_add_u32 s29, -0x1, s[sgprNumWorkGroups1]
s_cmp_ge_u32 s[sgprWorkGroup1], s29                // wg1 >= nwg1-1
s_cselect_b32 s28, s28, 0                          // set rem
s_mov_b32 s5, 0
s_cmp_gt_u32 s28, s5                               // rem > 0
s_cbranch_scc1 label_GW_B1_FD0_VW8_GSU1_Then       // jump if edges required
label_GW_B1_FD0_VW8_GSU1_NonEdge:

/* edge=0, allocate 1 sgpr. perBatchTmpS=1 perBatchMaskS=0 perElementMaskS=0 elementsPerBatch=33 */
/* optSingleColVgpr=1 optSharedColVgpr=0 optSGPRUsage=BufferLoad_Mask optSrdIncForRow=1 factorDim=0 */

/******************************************/
/* Global Write Beta Batch #0 (d1,d0,vc1,vc0) = */
/*    (0,0,0,0:vw8); (0,1,0,0:vw8); (0,2,0,0:vw8); (0,3,0,0:vw8); (0,0,1,0:vw8); (0,1,1,0:vw8); (0,2,1,0:vw8); (0,3,1,0:vw8); (0,0,2,0:vw8); (0,1,2,0:vw8); (0,2,2,0:vw8); (0,3,2,0:vw8); (0,0,3,0:vw8); (0,1,3,0:vw8); (0,2,3,0:vw8); (0,3,3,0:vw8) */
/******************************************/

/* calc coords, apply mask, and issue loads (if necessary) */
/* (d1,vc1,d0,vc0)=(0,0,0,0) */
s_wait_xcnt 0
s_prefetch_inst_pc_rel 0, null, 31
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_add_lshl_u32 v8, v2, v0, 2                       // optSingleColVgpr scaleToBpe: sharedAddrVgpr <- cinRowPtr + coord0, scaled by BPE. BSHERE:coord0=0, coord0Vgpr=0 (multiple bpe)
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b128 v[280-256:283-256], v8, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
buffer_load_b128 v[284-256:287-256], v8, s[sgprSrdC:sgprSrdC+3], null offen offset:16 scope:SCOPE_CU th:TH_LOAD_RT // load C
/* (d1,vc1,d0,vc0)=(0,0,1,0) */
buffer_load_b128 v[288-256:291-256], v8, s[sgprSrdC:sgprSrdC+3], null offen offset:128 scope:SCOPE_CU th:TH_LOAD_RT // load C
buffer_load_b128 v[292-256:295-256], v8, s[sgprSrdC:sgprSrdC+3], null offen offset:144 scope:SCOPE_CU th:TH_LOAD_RT // load C
/* (d1,vc1,d0,vc0)=(0,0,2,0) */
buffer_load_b128 v[296-256:299-256], v8, s[sgprSrdC:sgprSrdC+3], null offen offset:256 scope:SCOPE_CU th:TH_LOAD_RT // load C
buffer_load_b128 v[300-256:303-256], v8, s[sgprSrdC:sgprSrdC+3], null offen offset:272 scope:SCOPE_CU th:TH_LOAD_RT // load C
/* (d1,vc1,d0,vc0)=(0,0,3,0) */
buffer_load_b128 v[304-256:307-256], v8, s[sgprSrdC:sgprSrdC+3], null offen offset:384 scope:SCOPE_CU th:TH_LOAD_RT // load C
buffer_load_b128 v[308-256:311-256], v8, s[sgprSrdC:sgprSrdC+3], null offen offset:400 scope:SCOPE_CU th:TH_LOAD_RT // load C
/* (d1,vc1,d0,vc0)=(0,1,0,0) */
s_lshl_b32 s12, s[sgprStrideC1J], 2                // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdC+0], s[sgprSrdC+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdC+1], s[sgprSrdC+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_load_b128 v[312-256:315-256], v8, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
buffer_load_b128 v[316-256:319-256], v8, s[sgprSrdC:sgprSrdC+3], null offen offset:16 scope:SCOPE_CU th:TH_LOAD_RT // load C
/* (d1,vc1,d0,vc0)=(0,1,1,0) */
buffer_load_b128 v[320-256:323-256], v8, s[sgprSrdC:sgprSrdC+3], null offen offset:128 scope:SCOPE_CU th:TH_LOAD_RT // load C
buffer_load_b128 v[324-256:327-256], v8, s[sgprSrdC:sgprSrdC+3], null offen offset:144 scope:SCOPE_CU th:TH_LOAD_RT // load C
/* (d1,vc1,d0,vc0)=(0,1,2,0) */
buffer_load_b128 v[328-256:331-256], v8, s[sgprSrdC:sgprSrdC+3], null offen offset:256 scope:SCOPE_CU th:TH_LOAD_RT // load C
buffer_load_b128 v[332-256:335-256], v8, s[sgprSrdC:sgprSrdC+3], null offen offset:272 scope:SCOPE_CU th:TH_LOAD_RT // load C
/* (d1,vc1,d0,vc0)=(0,1,3,0) */
buffer_load_b128 v[336-256:339-256], v8, s[sgprSrdC:sgprSrdC+3], null offen offset:384 scope:SCOPE_CU th:TH_LOAD_RT // load C
buffer_load_b128 v[340-256:343-256], v8, s[sgprSrdC:sgprSrdC+3], null offen offset:400 scope:SCOPE_CU th:TH_LOAD_RT // load C
/* (d1,vc1,d0,vc0)=(0,2,0,0) */
s_lshl_b32 s12, s[sgprStrideC1J], 2                // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdC+0], s[sgprSrdC+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdC+1], s[sgprSrdC+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_load_b128 v[344-256:347-256], v8, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
buffer_load_b128 v[348-256:351-256], v8, s[sgprSrdC:sgprSrdC+3], null offen offset:16 scope:SCOPE_CU th:TH_LOAD_RT // load C
/* (d1,vc1,d0,vc0)=(0,2,1,0) */
buffer_load_b128 v[352-256:355-256], v8, s[sgprSrdC:sgprSrdC+3], null offen offset:128 scope:SCOPE_CU th:TH_LOAD_RT // load C
buffer_load_b128 v[356-256:359-256], v8, s[sgprSrdC:sgprSrdC+3], null offen offset:144 scope:SCOPE_CU th:TH_LOAD_RT // load C
/* (d1,vc1,d0,vc0)=(0,2,2,0) */
buffer_load_b128 v[360-256:363-256], v8, s[sgprSrdC:sgprSrdC+3], null offen offset:256 scope:SCOPE_CU th:TH_LOAD_RT // load C
buffer_load_b128 v[364-256:367-256], v8, s[sgprSrdC:sgprSrdC+3], null offen offset:272 scope:SCOPE_CU th:TH_LOAD_RT // load C
/* (d1,vc1,d0,vc0)=(0,2,3,0) */
buffer_load_b128 v[368-256:371-256], v8, s[sgprSrdC:sgprSrdC+3], null offen offset:384 scope:SCOPE_CU th:TH_LOAD_RT // load C
buffer_load_b128 v[372-256:375-256], v8, s[sgprSrdC:sgprSrdC+3], null offen offset:400 scope:SCOPE_CU th:TH_LOAD_RT // load C
/* (d1,vc1,d0,vc0)=(0,3,0,0) */
s_lshl_b32 s12, s[sgprStrideC1J], 2                // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdC+0], s[sgprSrdC+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdC+1], s[sgprSrdC+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_load_b128 v[376-256:379-256], v8, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
buffer_load_b128 v[380-256:383-256], v8, s[sgprSrdC:sgprSrdC+3], null offen offset:16 scope:SCOPE_CU th:TH_LOAD_RT // load C
/* (d1,vc1,d0,vc0)=(0,3,1,0) */
buffer_load_b128 v[384-256:387-256], v8, s[sgprSrdC:sgprSrdC+3], null offen offset:128 scope:SCOPE_CU th:TH_LOAD_RT // load C
buffer_load_b128 v[388-256:391-256], v8, s[sgprSrdC:sgprSrdC+3], null offen offset:144 scope:SCOPE_CU th:TH_LOAD_RT // load C
/* (d1,vc1,d0,vc0)=(0,3,2,0) */
buffer_load_b128 v[392-256:395-256], v8, s[sgprSrdC:sgprSrdC+3], null offen offset:256 scope:SCOPE_CU th:TH_LOAD_RT // load C
buffer_load_b128 v[396-256:399-256], v8, s[sgprSrdC:sgprSrdC+3], null offen offset:272 scope:SCOPE_CU th:TH_LOAD_RT // load C
/* (d1,vc1,d0,vc0)=(0,3,3,0) */
buffer_load_b128 v[400-256:403-256], v8, s[sgprSrdC:sgprSrdC+3], null offen offset:384 scope:SCOPE_CU th:TH_LOAD_RT // load C
buffer_load_b128 v[404-256:407-256], v8, s[sgprSrdC:sgprSrdC+3], null offen offset:400 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16384                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_lshl_u32 v7, v3, v0, 2                       // optSingleColVgpr scaleToBpe: sharedAddrVgpr <- cinRowPtr + coord0, scaled by BPE. BSHERE:coord0=0, coord0Vgpr=0 (multiple bpe)

/* rC *= alpha batchElements=[(0, 0, 0, 0), (0, 1, 0, 0), (0, 2, 0, 0), (0, 3, 0, 0), (0, 0, 1, 0), (0, 1, 1, 0), (0, 2, 1, 0), (0, 3, 1, 0), (0, 0, 2, 0), (0, 1, 2, 0), (0, 2, 2, 0), (0, 3, 2, 0), (0, 0, 3, 0), (0, 1, 3, 0), (0, 2, 3, 0), (0, 3, 3, 0)] */
v_mul_f32 v[vgprValuC+130], s[sgprAlpha], v[vgprValuC+0] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+131], s[sgprAlpha], v[vgprValuC+1] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+132], s[sgprAlpha], v[vgprValuC+2] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+133], s[sgprAlpha], v[vgprValuC+3] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+134], s[sgprAlpha], v[vgprValuC+4] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+135], s[sgprAlpha], v[vgprValuC+5] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+136], s[sgprAlpha], v[vgprValuC+6] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+137], s[sgprAlpha], v[vgprValuC+7] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+138], s[sgprAlpha], v[vgprValuC+8] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+139], s[sgprAlpha], v[vgprValuC+9] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+140], s[sgprAlpha], v[vgprValuC+10] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+141], s[sgprAlpha], v[vgprValuC+11] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+142], s[sgprAlpha], v[vgprValuC+12] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+143], s[sgprAlpha], v[vgprValuC+13] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+144], s[sgprAlpha], v[vgprValuC+14] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+145], s[sgprAlpha], v[vgprValuC+15] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+146], s[sgprAlpha], v[vgprValuC+16] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+147], s[sgprAlpha], v[vgprValuC+17] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+148], s[sgprAlpha], v[vgprValuC+18] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+149], s[sgprAlpha], v[vgprValuC+19] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+150], s[sgprAlpha], v[vgprValuC+20] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+151], s[sgprAlpha], v[vgprValuC+21] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+152], s[sgprAlpha], v[vgprValuC+22] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+153], s[sgprAlpha], v[vgprValuC+23] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+154], s[sgprAlpha], v[vgprValuC+24] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+155], s[sgprAlpha], v[vgprValuC+25] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+156], s[sgprAlpha], v[vgprValuC+26] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+157], s[sgprAlpha], v[vgprValuC+27] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+158], s[sgprAlpha], v[vgprValuC+28] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+159], s[sgprAlpha], v[vgprValuC+29] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+160], s[sgprAlpha], v[vgprValuC+30] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+161], s[sgprAlpha], v[vgprValuC+31] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+162], s[sgprAlpha], v[vgprValuC+32] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+163], s[sgprAlpha], v[vgprValuC+33] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+164], s[sgprAlpha], v[vgprValuC+34] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+165], s[sgprAlpha], v[vgprValuC+35] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+166], s[sgprAlpha], v[vgprValuC+36] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+167], s[sgprAlpha], v[vgprValuC+37] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+168], s[sgprAlpha], v[vgprValuC+38] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+169], s[sgprAlpha], v[vgprValuC+39] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+170], s[sgprAlpha], v[vgprValuC+40] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+171], s[sgprAlpha], v[vgprValuC+41] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+172], s[sgprAlpha], v[vgprValuC+42] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+173], s[sgprAlpha], v[vgprValuC+43] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+174], s[sgprAlpha], v[vgprValuC+44] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+175], s[sgprAlpha], v[vgprValuC+45] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+176], s[sgprAlpha], v[vgprValuC+46] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+177], s[sgprAlpha], v[vgprValuC+47] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+178], s[sgprAlpha], v[vgprValuC+48] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+179], s[sgprAlpha], v[vgprValuC+49] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+180], s[sgprAlpha], v[vgprValuC+50] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+181], s[sgprAlpha], v[vgprValuC+51] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+182], s[sgprAlpha], v[vgprValuC+52] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+183], s[sgprAlpha], v[vgprValuC+53] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+184], s[sgprAlpha], v[vgprValuC+54] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+185], s[sgprAlpha], v[vgprValuC+55] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+186], s[sgprAlpha], v[vgprValuC+56] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+187], s[sgprAlpha], v[vgprValuC+57] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+188], s[sgprAlpha], v[vgprValuC+58] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+189], s[sgprAlpha], v[vgprValuC+59] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+190], s[sgprAlpha], v[vgprValuC+60] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+191], s[sgprAlpha], v[vgprValuC+61] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+192], s[sgprAlpha], v[vgprValuC+62] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+193], s[sgprAlpha], v[vgprValuC+63] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+194], s[sgprAlpha], v[vgprValuC+64] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+195], s[sgprAlpha], v[vgprValuC+65] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+196], s[sgprAlpha], v[vgprValuC+66] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+197], s[sgprAlpha], v[vgprValuC+67] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+198], s[sgprAlpha], v[vgprValuC+68] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+199], s[sgprAlpha], v[vgprValuC+69] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+200], s[sgprAlpha], v[vgprValuC+70] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+201], s[sgprAlpha], v[vgprValuC+71] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+202], s[sgprAlpha], v[vgprValuC+72] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+203], s[sgprAlpha], v[vgprValuC+73] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+204], s[sgprAlpha], v[vgprValuC+74] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+205], s[sgprAlpha], v[vgprValuC+75] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+206], s[sgprAlpha], v[vgprValuC+76] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+207], s[sgprAlpha], v[vgprValuC+77] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+208], s[sgprAlpha], v[vgprValuC+78] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+209], s[sgprAlpha], v[vgprValuC+79] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+210], s[sgprAlpha], v[vgprValuC+80] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+211], s[sgprAlpha], v[vgprValuC+81] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+212], s[sgprAlpha], v[vgprValuC+82] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+213], s[sgprAlpha], v[vgprValuC+83] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+214], s[sgprAlpha], v[vgprValuC+84] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+215], s[sgprAlpha], v[vgprValuC+85] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+216], s[sgprAlpha], v[vgprValuC+86] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+217], s[sgprAlpha], v[vgprValuC+87] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+218], s[sgprAlpha], v[vgprValuC+88] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+219], s[sgprAlpha], v[vgprValuC+89] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+220], s[sgprAlpha], v[vgprValuC+90] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+221], s[sgprAlpha], v[vgprValuC+91] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+222], s[sgprAlpha], v[vgprValuC+92] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+223], s[sgprAlpha], v[vgprValuC+93] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+224], s[sgprAlpha], v[vgprValuC+94] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+225], s[sgprAlpha], v[vgprValuC+95] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+226], s[sgprAlpha], v[vgprValuC+96] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+227], s[sgprAlpha], v[vgprValuC+97] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+228], s[sgprAlpha], v[vgprValuC+98] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+229], s[sgprAlpha], v[vgprValuC+99] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+230], s[sgprAlpha], v[vgprValuC+100] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+231], s[sgprAlpha], v[vgprValuC+101] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+232], s[sgprAlpha], v[vgprValuC+102] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+233], s[sgprAlpha], v[vgprValuC+103] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+234], s[sgprAlpha], v[vgprValuC+104] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+235], s[sgprAlpha], v[vgprValuC+105] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+236], s[sgprAlpha], v[vgprValuC+106] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+237], s[sgprAlpha], v[vgprValuC+107] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+238], s[sgprAlpha], v[vgprValuC+108] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+239], s[sgprAlpha], v[vgprValuC+109] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+240], s[sgprAlpha], v[vgprValuC+110] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+241], s[sgprAlpha], v[vgprValuC+111] // Multiply MI out reg with alpha
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_mul_f32 v[vgprValuC+242-256], s[sgprAlpha], v[vgprValuC+112] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+243-256], s[sgprAlpha], v[vgprValuC+113] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+244-256], s[sgprAlpha], v[vgprValuC+114] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+245-256], s[sgprAlpha], v[vgprValuC+115] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+246-256], s[sgprAlpha], v[vgprValuC+116] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+247-256], s[sgprAlpha], v[vgprValuC+117] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+248-256], s[sgprAlpha], v[vgprValuC+118] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+249-256], s[sgprAlpha], v[vgprValuC+119] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+250-256], s[sgprAlpha], v[vgprValuC+120] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+251-256], s[sgprAlpha], v[vgprValuC+121] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+252-256], s[sgprAlpha], v[vgprValuC+122] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+253-256], s[sgprAlpha], v[vgprValuC+123] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+254-256], s[sgprAlpha], v[vgprValuC+124] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+255-256], s[sgprAlpha], v[vgprValuC+125] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+256-256], s[sgprAlpha], v[vgprValuC+126] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+257-256], s[sgprAlpha], v[vgprValuC+127] // Multiply MI out reg with alpha

/* apply mask, calc new C and issue writes */

s_set_vgpr_msb 16385                               // src0: 1, src1: 0, src2: 0, dst: 0
s_wait_loadcnt 30                                  // vlcnt(30) = 32 - 2 (beta) (interleaved)
v_fmac_f32 v[vgprValuC+130], v[280-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+131], v[281-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+132], v[282-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+133], v[283-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+134], v[284-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+135], v[285-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+136], v[286-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+137], v[287-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_set_vgpr_msb 256                                 // src0: 0, src1: 0, src2: 0, dst: 0
s_wait_alu depctr_va_vdst(4)
buffer_store_b128 v[144:147], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(0)
buffer_store_b128 v[148:151], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:16 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_loadcnt 28                                  // vlcnt(28) = 32 - 4 (beta) (interleaved)
s_set_vgpr_msb 1                                   // src0: 1, src1: 0, src2: 0, dst: 0
v_fmac_f32 v[vgprValuC+138], v[288-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+139], v[289-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+140], v[290-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+141], v[291-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+142], v[292-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+143], v[293-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+144], v[294-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+145], v[295-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_set_vgpr_msb 256                                 // src0: 0, src1: 0, src2: 0, dst: 0
s_wait_alu depctr_va_vdst(4)
buffer_store_b128 v[152:155], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:128 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(0)
buffer_store_b128 v[156:159], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:144 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_loadcnt 26                                  // vlcnt(26) = 32 - 6 (beta) (interleaved)
s_set_vgpr_msb 1                                   // src0: 1, src1: 0, src2: 0, dst: 0
v_fmac_f32 v[vgprValuC+146], v[296-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+147], v[297-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+148], v[298-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+149], v[299-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+150], v[300-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+151], v[301-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+152], v[302-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+153], v[303-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_set_vgpr_msb 256                                 // src0: 0, src1: 0, src2: 0, dst: 0
s_wait_alu depctr_va_vdst(4)
buffer_store_b128 v[160:163], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:256 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(0)
buffer_store_b128 v[164:167], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:272 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_loadcnt 24                                  // vlcnt(24) = 32 - 8 (beta) (interleaved)
s_set_vgpr_msb 1                                   // src0: 1, src1: 0, src2: 0, dst: 0
v_fmac_f32 v[vgprValuC+154], v[304-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+155], v[305-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+156], v[306-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+157], v[307-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+158], v[308-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+159], v[309-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+160], v[310-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+161], v[311-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_set_vgpr_msb 256                                 // src0: 0, src1: 0, src2: 0, dst: 0
s_wait_alu depctr_va_vdst(4)
buffer_store_b128 v[168:171], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:384 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(0)
buffer_store_b128 v[172:175], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:400 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_loadcnt 22                                  // vlcnt(22) = 32 - 10 (beta) (interleaved)
s_set_vgpr_msb 1                                   // src0: 1, src1: 0, src2: 0, dst: 0
v_fmac_f32 v[vgprValuC+162], v[312-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+163], v[313-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+164], v[314-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+165], v[315-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+166], v[316-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+167], v[317-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+168], v[318-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+169], v[319-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_lshl_b32 s12, s[sgprStrideD1J], 2                // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_set_vgpr_msb 256                                 // src0: 0, src1: 0, src2: 0, dst: 0
s_wait_alu depctr_va_vdst(4)
buffer_store_b128 v[176:179], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(0)
buffer_store_b128 v[180:183], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:16 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_loadcnt 20                                  // vlcnt(20) = 32 - 12 (beta) (interleaved)
s_set_vgpr_msb 1                                   // src0: 1, src1: 0, src2: 0, dst: 0
v_fmac_f32 v[vgprValuC+170], v[320-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+171], v[321-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+172], v[322-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+173], v[323-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+174], v[324-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+175], v[325-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+176], v[326-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+177], v[327-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_set_vgpr_msb 256                                 // src0: 0, src1: 0, src2: 0, dst: 0
s_wait_alu depctr_va_vdst(4)
buffer_store_b128 v[184:187], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:128 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(0)
buffer_store_b128 v[188:191], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:144 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_loadcnt 18                                  // vlcnt(18) = 32 - 14 (beta) (interleaved)
s_set_vgpr_msb 1                                   // src0: 1, src1: 0, src2: 0, dst: 0
v_fmac_f32 v[vgprValuC+178], v[328-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+179], v[329-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+180], v[330-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+181], v[331-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+182], v[332-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+183], v[333-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+184], v[334-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+185], v[335-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_set_vgpr_msb 256                                 // src0: 0, src1: 0, src2: 0, dst: 0
s_wait_alu depctr_va_vdst(4)
buffer_store_b128 v[192:195], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:256 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(0)
buffer_store_b128 v[196:199], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:272 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_loadcnt 16                                  // vlcnt(16) = 32 - 16 (beta) (interleaved)
s_set_vgpr_msb 1                                   // src0: 1, src1: 0, src2: 0, dst: 0
v_fmac_f32 v[vgprValuC+186], v[336-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+187], v[337-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+188], v[338-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+189], v[339-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+190], v[340-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+191], v[341-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+192], v[342-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+193], v[343-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_set_vgpr_msb 256                                 // src0: 0, src1: 0, src2: 0, dst: 0
s_wait_alu depctr_va_vdst(4)
buffer_store_b128 v[200:203], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:384 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(0)
buffer_store_b128 v[204:207], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:400 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_loadcnt 14                                  // vlcnt(14) = 32 - 18 (beta) (interleaved)
s_set_vgpr_msb 1                                   // src0: 1, src1: 0, src2: 0, dst: 0
v_fmac_f32 v[vgprValuC+194], v[344-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+195], v[345-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+196], v[346-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+197], v[347-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+198], v[348-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+199], v[349-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+200], v[350-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+201], v[351-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_lshl_b32 s12, s[sgprStrideD1J], 2                // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_set_vgpr_msb 256                                 // src0: 0, src1: 0, src2: 0, dst: 0
s_wait_alu depctr_va_vdst(4)
buffer_store_b128 v[208:211], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(0)
buffer_store_b128 v[212:215], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:16 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_loadcnt 12                                  // vlcnt(12) = 32 - 20 (beta) (interleaved)
s_set_vgpr_msb 1                                   // src0: 1, src1: 0, src2: 0, dst: 0
v_fmac_f32 v[vgprValuC+202], v[352-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+203], v[353-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+204], v[354-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+205], v[355-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+206], v[356-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+207], v[357-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+208], v[358-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+209], v[359-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_set_vgpr_msb 256                                 // src0: 0, src1: 0, src2: 0, dst: 0
s_wait_alu depctr_va_vdst(4)
buffer_store_b128 v[216:219], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:128 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(0)
buffer_store_b128 v[220:223], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:144 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_loadcnt 10                                  // vlcnt(10) = 32 - 22 (beta) (interleaved)
s_set_vgpr_msb 1                                   // src0: 1, src1: 0, src2: 0, dst: 0
v_fmac_f32 v[vgprValuC+210], v[360-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+211], v[361-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+212], v[362-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+213], v[363-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+214], v[364-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+215], v[365-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+216], v[366-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+217], v[367-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_set_vgpr_msb 256                                 // src0: 0, src1: 0, src2: 0, dst: 0
s_wait_alu depctr_va_vdst(4)
buffer_store_b128 v[224:227], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:256 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(0)
buffer_store_b128 v[228:231], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:272 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_loadcnt 8                                   // vlcnt(8) = 32 - 24 (beta) (interleaved)
s_set_vgpr_msb 1                                   // src0: 1, src1: 0, src2: 0, dst: 0
v_fmac_f32 v[vgprValuC+218], v[368-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+219], v[369-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+220], v[370-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+221], v[371-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+222], v[372-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+223], v[373-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+224], v[374-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+225], v[375-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_set_vgpr_msb 256                                 // src0: 0, src1: 0, src2: 0, dst: 0
s_wait_alu depctr_va_vdst(4)
buffer_store_b128 v[232:235], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:384 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(0)
buffer_store_b128 v[236:239], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:400 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_loadcnt 6                                   // vlcnt(6) = 32 - 26 (beta) (interleaved)
s_set_vgpr_msb 1                                   // src0: 1, src1: 0, src2: 0, dst: 0
v_fmac_f32 v[vgprValuC+226], v[376-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+227], v[377-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+228], v[378-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+229], v[379-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+230], v[380-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+231], v[381-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+232], v[382-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+233], v[383-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_lshl_b32 s12, s[sgprStrideD1J], 2                // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_set_vgpr_msb 256                                 // src0: 0, src1: 0, src2: 0, dst: 0
s_wait_alu depctr_va_vdst(4)
buffer_store_b128 v[240:243], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(0)
buffer_store_b128 v[244:247], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:16 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_loadcnt 4                                   // vlcnt(4) = 32 - 28 (beta) (interleaved)
s_set_vgpr_msb 1                                   // src0: 1, src1: 0, src2: 0, dst: 0
v_fmac_f32 v[vgprValuC+234], v[384-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+235], v[385-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+236], v[386-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+237], v[387-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+238], v[388-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+239], v[389-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+240], v[390-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+241], v[391-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_set_vgpr_msb 256                                 // src0: 0, src1: 0, src2: 0, dst: 0
s_wait_alu depctr_va_vdst(4)
buffer_store_b128 v[248:251], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:128 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(0)
buffer_store_b128 v[252:255], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:144 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_loadcnt 2                                   // vlcnt(2) = 32 - 30 (beta) (interleaved)
s_set_vgpr_msb 65                                  // src0: 1, src1: 0, src2: 0, dst: 1
v_fmac_f32 v[vgprValuC+242-256], v[392-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+243-256], v[393-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+244-256], v[394-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+245-256], v[395-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+246-256], v[396-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+247-256], v[397-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+248-256], v[398-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+249-256], v[399-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(4)
buffer_store_b128 v[256-256:259-256], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:256 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(0)
buffer_store_b128 v[260-256:263-256], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:272 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_loadcnt 0                                   // vlcnt(0) = 32 - 32 (beta) (interleaved)
s_set_vgpr_msb 16449                               // src0: 1, src1: 0, src2: 0, dst: 1
v_fmac_f32 v[vgprValuC+250-256], v[400-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+251-256], v[401-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+252-256], v[402-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+253-256], v[403-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+254-256], v[404-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+255-256], v[405-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+256-256], v[406-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+257-256], v[407-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(4)
buffer_store_b128 v[264-256:267-256], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:384 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(0)
buffer_store_b128 v[268-256:271-256], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:400 scope:SCOPE_CU th:TH_STORE_RT // store D
s_nop 0                                            // 1 wait state required when next inst writes vgprs held by previous dwordx4 store inst
s_branch label_GW_End_1                            // jump to end
label_GW_B1_FD0_VW8_GSU1_NonEdgeEnd:
label_GW_B1_FD0_VW8_GSU1_Then:

/* edge=1, allocate 3 sgpr. perBatchTmpS=2 perBatchMaskS=1 perElementMaskS=0 elementsPerBatch=30 */
/* optSingleColVgpr=0 optSharedColVgpr=0 optSGPRUsage=BufferLoad_Edge_Mask optSrdIncForRow=0 factorDim=0 */

/******************************************/
/* Global Write Beta Edge Batch #0 (d1,d0,vc1,vc0) = */
/*    (0,0,0,0:vw8); (0,1,0,0:vw8); (0,2,0,0:vw8); (0,3,0,0:vw8); (0,0,1,0:vw8); (0,1,1,0:vw8); (0,2,1,0:vw8); (0,3,1,0:vw8); (0,0,2,0:vw8); (0,1,2,0:vw8); (0,2,2,0:vw8); (0,3,2,0:vw8); (0,0,3,0:vw8); (0,1,3,0:vw8); (0,2,3,0:vw8); (0,3,3,0:vw8) */
/******************************************/

/* calc coords, apply mask, and issue loads (if necessary) */
s_wait_xcnt 0
s_prefetch_inst_pc_rel 0, null, 31
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v6, BufferOOB
/* (d1,vc1,d0,vc0)=(0,0,0,0) */
v_cmp_lt_u32 s12, v0, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v7, v2, v0, 2                       // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v7, v6, v7, s14                      // LDC clip if OOB. offset
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b128 v[280-256:283-256], v7, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
buffer_load_b128 v[284-256:287-256], v7, s[sgprSrdC:sgprSrdC+3], null offen offset:16 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16384                               // src0: 0, src1: 0, src2: 0, dst: 0
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v7, v3, v0, 2                       // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v7, v6, v7, s14                      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,1,0) */
v_add_co_u32 v4, vcc_lo, v0, 32                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v8, v2, v4, 2                       // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v8, v6, v8, s14                      // LDC clip if OOB. offset
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b128 v[288-256:291-256], v8, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
buffer_load_b128 v[292-256:295-256], v8, s[sgprSrdC:sgprSrdC+3], null offen offset:16 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16384                               // src0: 0, src1: 0, src2: 0, dst: 0
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v8, v3, v4, 2                       // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v8, v6, v8, s14                      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,2,0) */
v_add_co_u32 v4, vcc_lo, v0, 64                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v9, v2, v4, 2                       // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v9, v6, v9, s14                      // LDC clip if OOB. offset
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b128 v[296-256:299-256], v9, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
buffer_load_b128 v[300-256:303-256], v9, s[sgprSrdC:sgprSrdC+3], null offen offset:16 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16384                               // src0: 0, src1: 0, src2: 0, dst: 0
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v9, v3, v4, 2                       // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v9, v6, v9, s14                      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,3,0) */
s_mov_b32 s12, 96                                  // coordOffset0 d0=3 vc0=0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v10, v2, v4, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v10, v6, v10, s14                    // LDC clip if OOB. offset
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b128 v[304-256:307-256], v10, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
buffer_load_b128 v[308-256:311-256], v10, s[sgprSrdC:sgprSrdC+3], null offen offset:16 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16384                               // src0: 0, src1: 0, src2: 0, dst: 0
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v10, v3, v4, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v10, v6, v10, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,0,0) */
v_add_co_u32 v1, vcc_lo, v1, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v2, v2, s[sgprStrideC1J]              // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v3, v3, s[sgprStrideD1J]              // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v0, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v11, v2, v0, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v11, v6, v11, s14                    // LDC clip if OOB. offset
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b128 v[312-256:315-256], v11, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
buffer_load_b128 v[316-256:319-256], v11, s[sgprSrdC:sgprSrdC+3], null offen offset:16 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16384                               // src0: 0, src1: 0, src2: 0, dst: 0
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v11, v3, v0, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v11, v6, v11, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,1,0) */
v_add_co_u32 v4, vcc_lo, v0, 32                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v12, v2, v4, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v12, v6, v12, s14                    // LDC clip if OOB. offset
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b128 v[320-256:323-256], v12, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
buffer_load_b128 v[324-256:327-256], v12, s[sgprSrdC:sgprSrdC+3], null offen offset:16 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16384                               // src0: 0, src1: 0, src2: 0, dst: 0
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v12, v3, v4, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v12, v6, v12, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,2,0) */
v_add_co_u32 v4, vcc_lo, v0, 64                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v13, v2, v4, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v13, v6, v13, s14                    // LDC clip if OOB. offset
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b128 v[328-256:331-256], v13, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
buffer_load_b128 v[332-256:335-256], v13, s[sgprSrdC:sgprSrdC+3], null offen offset:16 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16384                               // src0: 0, src1: 0, src2: 0, dst: 0
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v13, v3, v4, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v13, v6, v13, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,3,0) */
s_mov_b32 s12, 96                                  // coordOffset0 d0=3 vc0=0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v142, v2, v4, 2                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v142, v6, v142, s14                  // LDC clip if OOB. offset
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b128 v[336-256:339-256], v142, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
buffer_load_b128 v[340-256:343-256], v142, s[sgprSrdC:sgprSrdC+3], null offen offset:16 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16384                               // src0: 0, src1: 0, src2: 0, dst: 0
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v142, v3, v4, 2                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v142, v6, v142, s14                  // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,0,0) */
v_add_co_u32 v1, vcc_lo, v1, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v2, v2, s[sgprStrideC1J]              // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v3, v3, s[sgprStrideD1J]              // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v0, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v143, v2, v0, 2                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v143, v6, v143, s14                  // LDC clip if OOB. offset
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b128 v[344-256:347-256], v143, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
buffer_load_b128 v[348-256:351-256], v143, s[sgprSrdC:sgprSrdC+3], null offen offset:16 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16384                               // src0: 0, src1: 0, src2: 0, dst: 0
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v143, v3, v0, 2                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v143, v6, v143, s14                  // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,1,0) */
v_add_co_u32 v4, vcc_lo, v0, 32                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[272-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[272-256], v6, v[272-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b128 v[352-256:355-256], v[272-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
buffer_load_b128 v[356-256:359-256], v[272-256], s[sgprSrdC:sgprSrdC+3], null offen offset:16 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[272-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[272-256], v6, v[272-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,2,0) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 64                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[273-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[273-256], v6, v[273-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b128 v[360-256:363-256], v[273-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
buffer_load_b128 v[364-256:367-256], v[273-256], s[sgprSrdC:sgprSrdC+3], null offen offset:16 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[273-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[273-256], v6, v[273-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,3,0) */
s_mov_b32 s12, 96                                  // coordOffset0 d0=3 vc0=0
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[274-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[274-256], v6, v[274-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b128 v[368-256:371-256], v[274-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
buffer_load_b128 v[372-256:375-256], v[274-256], s[sgprSrdC:sgprSrdC+3], null offen offset:16 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[274-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[274-256], v6, v[274-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,0,0) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v1, vcc_lo, v1, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v2, v2, s[sgprStrideC1J]              // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v3, v3, s[sgprStrideD1J]              // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v0, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[275-256], v2, v0, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[275-256], v6, v[275-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b128 v[376-256:379-256], v[275-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
buffer_load_b128 v[380-256:383-256], v[275-256], s[sgprSrdC:sgprSrdC+3], null offen offset:16 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[275-256], v3, v0, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[275-256], v6, v[275-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,1,0) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 32                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[277-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[277-256], v6, v[277-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b128 v[384-256:387-256], v[277-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
buffer_load_b128 v[388-256:391-256], v[277-256], s[sgprSrdC:sgprSrdC+3], null offen offset:16 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[277-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[277-256], v6, v[277-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,2,0) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 64                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[278-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[278-256], v6, v[278-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b128 v[392-256:395-256], v[278-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
buffer_load_b128 v[396-256:399-256], v[278-256], s[sgprSrdC:sgprSrdC+3], null offen offset:16 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[278-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[278-256], v6, v[278-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,3,0) */
s_mov_b32 s12, 96                                  // coordOffset0 d0=3 vc0=0
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[279-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[279-256], v6, v[279-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b128 v[400-256:403-256], v[279-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
buffer_load_b128 v[404-256:407-256], v[279-256], s[sgprSrdC:sgprSrdC+3], null offen offset:16 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[279-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[279-256], v6, v[279-256], s14      // LDD clip if OOB. offset

/* rC *= alpha batchElements=[(0, 0, 0, 0), (0, 1, 0, 0), (0, 2, 0, 0), (0, 3, 0, 0), (0, 0, 1, 0), (0, 1, 1, 0), (0, 2, 1, 0), (0, 3, 1, 0), (0, 0, 2, 0), (0, 1, 2, 0), (0, 2, 2, 0), (0, 3, 2, 0), (0, 0, 3, 0), (0, 1, 3, 0), (0, 2, 3, 0), (0, 3, 3, 0)] */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_mul_f32 v[vgprValuC+130], s[sgprAlpha], v[vgprValuC+0] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+131], s[sgprAlpha], v[vgprValuC+1] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+132], s[sgprAlpha], v[vgprValuC+2] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+133], s[sgprAlpha], v[vgprValuC+3] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+134], s[sgprAlpha], v[vgprValuC+4] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+135], s[sgprAlpha], v[vgprValuC+5] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+136], s[sgprAlpha], v[vgprValuC+6] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+137], s[sgprAlpha], v[vgprValuC+7] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+138], s[sgprAlpha], v[vgprValuC+8] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+139], s[sgprAlpha], v[vgprValuC+9] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+140], s[sgprAlpha], v[vgprValuC+10] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+141], s[sgprAlpha], v[vgprValuC+11] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+142], s[sgprAlpha], v[vgprValuC+12] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+143], s[sgprAlpha], v[vgprValuC+13] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+144], s[sgprAlpha], v[vgprValuC+14] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+145], s[sgprAlpha], v[vgprValuC+15] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+146], s[sgprAlpha], v[vgprValuC+16] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+147], s[sgprAlpha], v[vgprValuC+17] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+148], s[sgprAlpha], v[vgprValuC+18] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+149], s[sgprAlpha], v[vgprValuC+19] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+150], s[sgprAlpha], v[vgprValuC+20] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+151], s[sgprAlpha], v[vgprValuC+21] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+152], s[sgprAlpha], v[vgprValuC+22] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+153], s[sgprAlpha], v[vgprValuC+23] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+154], s[sgprAlpha], v[vgprValuC+24] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+155], s[sgprAlpha], v[vgprValuC+25] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+156], s[sgprAlpha], v[vgprValuC+26] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+157], s[sgprAlpha], v[vgprValuC+27] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+158], s[sgprAlpha], v[vgprValuC+28] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+159], s[sgprAlpha], v[vgprValuC+29] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+160], s[sgprAlpha], v[vgprValuC+30] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+161], s[sgprAlpha], v[vgprValuC+31] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+162], s[sgprAlpha], v[vgprValuC+32] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+163], s[sgprAlpha], v[vgprValuC+33] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+164], s[sgprAlpha], v[vgprValuC+34] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+165], s[sgprAlpha], v[vgprValuC+35] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+166], s[sgprAlpha], v[vgprValuC+36] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+167], s[sgprAlpha], v[vgprValuC+37] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+168], s[sgprAlpha], v[vgprValuC+38] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+169], s[sgprAlpha], v[vgprValuC+39] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+170], s[sgprAlpha], v[vgprValuC+40] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+171], s[sgprAlpha], v[vgprValuC+41] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+172], s[sgprAlpha], v[vgprValuC+42] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+173], s[sgprAlpha], v[vgprValuC+43] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+174], s[sgprAlpha], v[vgprValuC+44] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+175], s[sgprAlpha], v[vgprValuC+45] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+176], s[sgprAlpha], v[vgprValuC+46] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+177], s[sgprAlpha], v[vgprValuC+47] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+178], s[sgprAlpha], v[vgprValuC+48] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+179], s[sgprAlpha], v[vgprValuC+49] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+180], s[sgprAlpha], v[vgprValuC+50] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+181], s[sgprAlpha], v[vgprValuC+51] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+182], s[sgprAlpha], v[vgprValuC+52] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+183], s[sgprAlpha], v[vgprValuC+53] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+184], s[sgprAlpha], v[vgprValuC+54] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+185], s[sgprAlpha], v[vgprValuC+55] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+186], s[sgprAlpha], v[vgprValuC+56] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+187], s[sgprAlpha], v[vgprValuC+57] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+188], s[sgprAlpha], v[vgprValuC+58] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+189], s[sgprAlpha], v[vgprValuC+59] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+190], s[sgprAlpha], v[vgprValuC+60] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+191], s[sgprAlpha], v[vgprValuC+61] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+192], s[sgprAlpha], v[vgprValuC+62] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+193], s[sgprAlpha], v[vgprValuC+63] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+194], s[sgprAlpha], v[vgprValuC+64] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+195], s[sgprAlpha], v[vgprValuC+65] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+196], s[sgprAlpha], v[vgprValuC+66] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+197], s[sgprAlpha], v[vgprValuC+67] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+198], s[sgprAlpha], v[vgprValuC+68] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+199], s[sgprAlpha], v[vgprValuC+69] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+200], s[sgprAlpha], v[vgprValuC+70] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+201], s[sgprAlpha], v[vgprValuC+71] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+202], s[sgprAlpha], v[vgprValuC+72] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+203], s[sgprAlpha], v[vgprValuC+73] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+204], s[sgprAlpha], v[vgprValuC+74] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+205], s[sgprAlpha], v[vgprValuC+75] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+206], s[sgprAlpha], v[vgprValuC+76] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+207], s[sgprAlpha], v[vgprValuC+77] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+208], s[sgprAlpha], v[vgprValuC+78] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+209], s[sgprAlpha], v[vgprValuC+79] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+210], s[sgprAlpha], v[vgprValuC+80] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+211], s[sgprAlpha], v[vgprValuC+81] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+212], s[sgprAlpha], v[vgprValuC+82] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+213], s[sgprAlpha], v[vgprValuC+83] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+214], s[sgprAlpha], v[vgprValuC+84] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+215], s[sgprAlpha], v[vgprValuC+85] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+216], s[sgprAlpha], v[vgprValuC+86] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+217], s[sgprAlpha], v[vgprValuC+87] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+218], s[sgprAlpha], v[vgprValuC+88] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+219], s[sgprAlpha], v[vgprValuC+89] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+220], s[sgprAlpha], v[vgprValuC+90] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+221], s[sgprAlpha], v[vgprValuC+91] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+222], s[sgprAlpha], v[vgprValuC+92] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+223], s[sgprAlpha], v[vgprValuC+93] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+224], s[sgprAlpha], v[vgprValuC+94] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+225], s[sgprAlpha], v[vgprValuC+95] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+226], s[sgprAlpha], v[vgprValuC+96] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+227], s[sgprAlpha], v[vgprValuC+97] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+228], s[sgprAlpha], v[vgprValuC+98] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+229], s[sgprAlpha], v[vgprValuC+99] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+230], s[sgprAlpha], v[vgprValuC+100] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+231], s[sgprAlpha], v[vgprValuC+101] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+232], s[sgprAlpha], v[vgprValuC+102] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+233], s[sgprAlpha], v[vgprValuC+103] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+234], s[sgprAlpha], v[vgprValuC+104] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+235], s[sgprAlpha], v[vgprValuC+105] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+236], s[sgprAlpha], v[vgprValuC+106] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+237], s[sgprAlpha], v[vgprValuC+107] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+238], s[sgprAlpha], v[vgprValuC+108] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+239], s[sgprAlpha], v[vgprValuC+109] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+240], s[sgprAlpha], v[vgprValuC+110] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+241], s[sgprAlpha], v[vgprValuC+111] // Multiply MI out reg with alpha
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_mul_f32 v[vgprValuC+242-256], s[sgprAlpha], v[vgprValuC+112] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+243-256], s[sgprAlpha], v[vgprValuC+113] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+244-256], s[sgprAlpha], v[vgprValuC+114] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+245-256], s[sgprAlpha], v[vgprValuC+115] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+246-256], s[sgprAlpha], v[vgprValuC+116] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+247-256], s[sgprAlpha], v[vgprValuC+117] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+248-256], s[sgprAlpha], v[vgprValuC+118] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+249-256], s[sgprAlpha], v[vgprValuC+119] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+250-256], s[sgprAlpha], v[vgprValuC+120] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+251-256], s[sgprAlpha], v[vgprValuC+121] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+252-256], s[sgprAlpha], v[vgprValuC+122] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+253-256], s[sgprAlpha], v[vgprValuC+123] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+254-256], s[sgprAlpha], v[vgprValuC+124] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+255-256], s[sgprAlpha], v[vgprValuC+125] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+256-256], s[sgprAlpha], v[vgprValuC+126] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+257-256], s[sgprAlpha], v[vgprValuC+127] // Multiply MI out reg with alpha
s_set_vgpr_msb 16385                               // src0: 1, src1: 0, src2: 0, dst: 0
s_wait_loadcnt 0                                   // wait for Beta

/* apply mask, calc new C and issue writes */
v_fmac_f32 v[vgprValuC+130], v[280-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+131], v[281-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+132], v[282-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+133], v[283-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+134], v[284-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+135], v[285-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+136], v[286-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+137], v[287-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_set_vgpr_msb 256                                 // src0: 0, src1: 0, src2: 0, dst: 0
s_wait_alu depctr_va_vdst(4)
buffer_store_b128 v[144:147], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(0)
buffer_store_b128 v[148:151], v7, s[sgprSrdD:sgprSrdD+3], null offen offset:16 scope:SCOPE_CU th:TH_STORE_RT // store D
s_set_vgpr_msb 1                                   // src0: 1, src1: 0, src2: 0, dst: 0
v_fmac_f32 v[vgprValuC+138], v[288-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+139], v[289-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+140], v[290-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+141], v[291-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+142], v[292-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+143], v[293-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+144], v[294-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+145], v[295-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_set_vgpr_msb 256                                 // src0: 0, src1: 0, src2: 0, dst: 0
s_wait_alu depctr_va_vdst(4)
buffer_store_b128 v[152:155], v8, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(0)
buffer_store_b128 v[156:159], v8, s[sgprSrdD:sgprSrdD+3], null offen offset:16 scope:SCOPE_CU th:TH_STORE_RT // store D
s_set_vgpr_msb 1                                   // src0: 1, src1: 0, src2: 0, dst: 0
v_fmac_f32 v[vgprValuC+146], v[296-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+147], v[297-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+148], v[298-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+149], v[299-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+150], v[300-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+151], v[301-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+152], v[302-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+153], v[303-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_set_vgpr_msb 256                                 // src0: 0, src1: 0, src2: 0, dst: 0
s_wait_alu depctr_va_vdst(4)
buffer_store_b128 v[160:163], v9, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(0)
buffer_store_b128 v[164:167], v9, s[sgprSrdD:sgprSrdD+3], null offen offset:16 scope:SCOPE_CU th:TH_STORE_RT // store D
s_set_vgpr_msb 1                                   // src0: 1, src1: 0, src2: 0, dst: 0
v_fmac_f32 v[vgprValuC+154], v[304-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+155], v[305-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+156], v[306-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+157], v[307-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+158], v[308-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+159], v[309-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+160], v[310-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+161], v[311-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_set_vgpr_msb 256                                 // src0: 0, src1: 0, src2: 0, dst: 0
s_wait_alu depctr_va_vdst(4)
buffer_store_b128 v[168:171], v10, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(0)
buffer_store_b128 v[172:175], v10, s[sgprSrdD:sgprSrdD+3], null offen offset:16 scope:SCOPE_CU th:TH_STORE_RT // store D
s_set_vgpr_msb 1                                   // src0: 1, src1: 0, src2: 0, dst: 0
v_fmac_f32 v[vgprValuC+162], v[312-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+163], v[313-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+164], v[314-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+165], v[315-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+166], v[316-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+167], v[317-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+168], v[318-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+169], v[319-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_set_vgpr_msb 256                                 // src0: 0, src1: 0, src2: 0, dst: 0
s_wait_alu depctr_va_vdst(4)
buffer_store_b128 v[176:179], v11, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(0)
buffer_store_b128 v[180:183], v11, s[sgprSrdD:sgprSrdD+3], null offen offset:16 scope:SCOPE_CU th:TH_STORE_RT // store D
s_set_vgpr_msb 1                                   // src0: 1, src1: 0, src2: 0, dst: 0
v_fmac_f32 v[vgprValuC+170], v[320-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+171], v[321-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+172], v[322-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+173], v[323-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+174], v[324-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+175], v[325-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+176], v[326-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+177], v[327-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_set_vgpr_msb 256                                 // src0: 0, src1: 0, src2: 0, dst: 0
s_wait_alu depctr_va_vdst(4)
buffer_store_b128 v[184:187], v12, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(0)
buffer_store_b128 v[188:191], v12, s[sgprSrdD:sgprSrdD+3], null offen offset:16 scope:SCOPE_CU th:TH_STORE_RT // store D
s_set_vgpr_msb 1                                   // src0: 1, src1: 0, src2: 0, dst: 0
v_fmac_f32 v[vgprValuC+178], v[328-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+179], v[329-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+180], v[330-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+181], v[331-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+182], v[332-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+183], v[333-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+184], v[334-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+185], v[335-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_set_vgpr_msb 256                                 // src0: 0, src1: 0, src2: 0, dst: 0
s_wait_alu depctr_va_vdst(4)
buffer_store_b128 v[192:195], v13, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(0)
buffer_store_b128 v[196:199], v13, s[sgprSrdD:sgprSrdD+3], null offen offset:16 scope:SCOPE_CU th:TH_STORE_RT // store D
s_set_vgpr_msb 1                                   // src0: 1, src1: 0, src2: 0, dst: 0
v_fmac_f32 v[vgprValuC+186], v[336-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+187], v[337-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+188], v[338-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+189], v[339-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+190], v[340-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+191], v[341-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+192], v[342-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+193], v[343-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_set_vgpr_msb 256                                 // src0: 0, src1: 0, src2: 0, dst: 0
s_wait_alu depctr_va_vdst(4)
buffer_store_b128 v[200:203], v142, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(0)
buffer_store_b128 v[204:207], v142, s[sgprSrdD:sgprSrdD+3], null offen offset:16 scope:SCOPE_CU th:TH_STORE_RT // store D
s_set_vgpr_msb 1                                   // src0: 1, src1: 0, src2: 0, dst: 0
v_fmac_f32 v[vgprValuC+194], v[344-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+195], v[345-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+196], v[346-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+197], v[347-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+198], v[348-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+199], v[349-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+200], v[350-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+201], v[351-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_set_vgpr_msb 256                                 // src0: 0, src1: 0, src2: 0, dst: 0
s_wait_alu depctr_va_vdst(4)
buffer_store_b128 v[208:211], v143, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(0)
buffer_store_b128 v[212:215], v143, s[sgprSrdD:sgprSrdD+3], null offen offset:16 scope:SCOPE_CU th:TH_STORE_RT // store D
s_set_vgpr_msb 1                                   // src0: 1, src1: 0, src2: 0, dst: 0
v_fmac_f32 v[vgprValuC+202], v[352-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+203], v[353-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+204], v[354-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+205], v[355-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+206], v[356-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+207], v[357-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+208], v[358-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+209], v[359-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(4)
buffer_store_b128 v[216:219], v[272-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(0)
buffer_store_b128 v[220:223], v[272-256], s[sgprSrdD:sgprSrdD+3], null offen offset:16 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+210], v[360-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+211], v[361-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+212], v[362-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+213], v[363-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+214], v[364-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+215], v[365-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+216], v[366-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+217], v[367-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(4)
buffer_store_b128 v[224:227], v[273-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(0)
buffer_store_b128 v[228:231], v[273-256], s[sgprSrdD:sgprSrdD+3], null offen offset:16 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+218], v[368-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+219], v[369-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+220], v[370-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+221], v[371-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+222], v[372-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+223], v[373-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+224], v[374-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+225], v[375-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(4)
buffer_store_b128 v[232:235], v[274-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(0)
buffer_store_b128 v[236:239], v[274-256], s[sgprSrdD:sgprSrdD+3], null offen offset:16 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+226], v[376-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+227], v[377-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+228], v[378-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+229], v[379-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+230], v[380-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+231], v[381-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+232], v[382-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+233], v[383-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(4)
buffer_store_b128 v[240:243], v[275-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(0)
buffer_store_b128 v[244:247], v[275-256], s[sgprSrdD:sgprSrdD+3], null offen offset:16 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+234], v[384-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+235], v[385-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+236], v[386-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+237], v[387-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+238], v[388-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+239], v[389-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+240], v[390-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+241], v[391-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(4)
buffer_store_b128 v[248:251], v[277-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(0)
buffer_store_b128 v[252:255], v[277-256], s[sgprSrdD:sgprSrdD+3], null offen offset:16 scope:SCOPE_CU th:TH_STORE_RT // store D
s_set_vgpr_msb 321                                 // src0: 1, src1: 0, src2: 0, dst: 1
v_fmac_f32 v[vgprValuC+242-256], v[392-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+243-256], v[393-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+244-256], v[394-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+245-256], v[395-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+246-256], v[396-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+247-256], v[397-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+248-256], v[398-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+249-256], v[399-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(4)
buffer_store_b128 v[256-256:259-256], v[278-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(0)
buffer_store_b128 v[260-256:263-256], v[278-256], s[sgprSrdD:sgprSrdD+3], null offen offset:16 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+250-256], v[400-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+251-256], v[401-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+252-256], v[402-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+253-256], v[403-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+254-256], v[404-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+255-256], v[405-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+256-256], v[406-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+257-256], v[407-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(4)
buffer_store_b128 v[264-256:267-256], v[279-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(0)
buffer_store_b128 v[268-256:271-256], v[279-256], s[sgprSrdD:sgprSrdD+3], null offen offset:16 scope:SCOPE_CU th:TH_STORE_RT // store D
s_nop 0                                            // 1 wait state required when next inst writes vgprs held by previous dwordx4 store inst
s_branch label_GW_End_1                            // jump to end
label_GW_B1_FD0_VW8_GSU1_Else:
label_GW_B1_FD0_VW1_GSU1_Else:
label_GW_B1_FD0_VW1_GSU1_Then:

/* edge=1, allocate 3 sgpr. perBatchTmpS=2 perBatchMaskS=1 perElementMaskS=0 elementsPerBatch=180 */
/* optSingleColVgpr=0 optSharedColVgpr=0 optSGPRUsage=BufferLoad_Edge_Mask optSrdIncForRow=0 factorDim=0 */

/******************************************/
/* Global Write Beta Edge Batch #0 (d1,d0,vc1,vc0) = */
/*    (0,0,0,0:vw1); (0,0,0,1:vw1); (0,0,0,2:vw1); (0,0,0,3:vw1); (0,0,0,4:vw1); (0,0,0,5:vw1); (0,0,0,6:vw1); (0,0,0,7:vw1); (0,1,0,0:vw1); (0,1,0,1:vw1); (0,1,0,2:vw1); (0,1,0,3:vw1); (0,1,0,4:vw1); (0,1,0,5:vw1); (0,1,0,6:vw1); (0,1,0,7:vw1); (0,2,0,0:vw1); (0,2,0,1:vw1); (0,2,0,2:vw1); (0,2,0,3:vw1); (0,2,0,4:vw1); (0,2,0,5:vw1); (0,2,0,6:vw1); (0,2,0,7:vw1); (0,3,0,0:vw1); (0,3,0,1:vw1); (0,3,0,2:vw1); (0,3,0,3:vw1); (0,3,0,4:vw1); (0,3,0,5:vw1); (0,3,0,6:vw1); (0,3,0,7:vw1); (0,0,1,0:vw1); (0,0,1,1:vw1); (0,0,1,2:vw1); (0,0,1,3:vw1); (0,0,1,4:vw1); (0,0,1,5:vw1); (0,0,1,6:vw1); (0,0,1,7:vw1); (0,1,1,0:vw1); (0,1,1,1:vw1); (0,1,1,2:vw1); (0,1,1,3:vw1); (0,1,1,4:vw1); (0,1,1,5:vw1); (0,1,1,6:vw1); (0,1,1,7:vw1); (0,2,1,0:vw1); (0,2,1,1:vw1); (0,2,1,2:vw1); (0,2,1,3:vw1); (0,2,1,4:vw1); (0,2,1,5:vw1); (0,2,1,6:vw1); (0,2,1,7:vw1); (0,3,1,0:vw1); (0,3,1,1:vw1); (0,3,1,2:vw1); (0,3,1,3:vw1); (0,3,1,4:vw1); (0,3,1,5:vw1); (0,3,1,6:vw1); (0,3,1,7:vw1); (0,0,2,0:vw1); (0,0,2,1:vw1); (0,0,2,2:vw1); (0,0,2,3:vw1); (0,0,2,4:vw1); (0,0,2,5:vw1); (0,0,2,6:vw1); (0,0,2,7:vw1); (0,1,2,0:vw1); (0,1,2,1:vw1); (0,1,2,2:vw1); (0,1,2,3:vw1); (0,1,2,4:vw1); (0,1,2,5:vw1); (0,1,2,6:vw1); (0,1,2,7:vw1); (0,2,2,0:vw1); (0,2,2,1:vw1); (0,2,2,2:vw1); (0,2,2,3:vw1); (0,2,2,4:vw1); (0,2,2,5:vw1); (0,2,2,6:vw1); (0,2,2,7:vw1); (0,3,2,0:vw1); (0,3,2,1:vw1); (0,3,2,2:vw1); (0,3,2,3:vw1); (0,3,2,4:vw1); (0,3,2,5:vw1); (0,3,2,6:vw1); (0,3,2,7:vw1); (0,0,3,0:vw1); (0,0,3,1:vw1); (0,0,3,2:vw1); (0,0,3,3:vw1); (0,0,3,4:vw1); (0,0,3,5:vw1); (0,0,3,6:vw1); (0,0,3,7:vw1); (0,1,3,0:vw1); (0,1,3,1:vw1); (0,1,3,2:vw1); (0,1,3,3:vw1); (0,1,3,4:vw1); (0,1,3,5:vw1); (0,1,3,6:vw1); (0,1,3,7:vw1); (0,2,3,0:vw1); (0,2,3,1:vw1); (0,2,3,2:vw1); (0,2,3,3:vw1); (0,2,3,4:vw1); (0,2,3,5:vw1); (0,2,3,6:vw1); (0,2,3,7:vw1); (0,3,3,0:vw1); (0,3,3,1:vw1); (0,3,3,2:vw1); (0,3,3,3:vw1); (0,3,3,4:vw1); (0,3,3,5:vw1); (0,3,3,6:vw1); (0,3,3,7:vw1) */
/******************************************/

/* calc coords, apply mask, and issue loads (if necessary) */
s_wait_xcnt 0
s_prefetch_inst_pc_rel 0, null, 31
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v6, BufferOOB
/* (d1,vc1,d0,vc0)=(0,0,0,0) */
v_cmp_lt_u32 s12, v0, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[264-256], v2, v0, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[264-256], v6, v[264-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[263-256], v[264-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[264-256], v3, v0, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[264-256], v6, v[264-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,0,1) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 1                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[266-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[266-256], v6, v[266-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[265-256], v[266-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[266-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[266-256], v6, v[266-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,0,2) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 2                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[268-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[268-256], v6, v[268-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[267-256], v[268-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[268-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[268-256], v6, v[268-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,0,3) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 3                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[270-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[270-256], v6, v[270-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[269-256], v[270-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[270-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[270-256], v6, v[270-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,0,4) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 4                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[272-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[272-256], v6, v[272-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[271-256], v[272-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[272-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[272-256], v6, v[272-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,0,5) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 5                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[274-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[274-256], v6, v[274-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[273-256], v[274-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[274-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[274-256], v6, v[274-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,0,6) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 6                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[277-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[277-256], v6, v[277-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[275-256], v[277-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[277-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[277-256], v6, v[277-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,0,7) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 7                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[279-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[279-256], v6, v[279-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[278-256], v[279-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[279-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[279-256], v6, v[279-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,1,0) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 32                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[281-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[281-256], v6, v[281-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[280-256], v[281-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[281-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[281-256], v6, v[281-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,1,1) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 33                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[283-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[283-256], v6, v[283-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[282-256], v[283-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[283-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[283-256], v6, v[283-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,1,2) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 34                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[285-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[285-256], v6, v[285-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[284-256], v[285-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[285-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[285-256], v6, v[285-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,1,3) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 35                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[287-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[287-256], v6, v[287-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[286-256], v[287-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[287-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[287-256], v6, v[287-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,1,4) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 36                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[289-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[289-256], v6, v[289-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[288-256], v[289-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[289-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[289-256], v6, v[289-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,1,5) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 37                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[291-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[291-256], v6, v[291-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[290-256], v[291-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[291-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[291-256], v6, v[291-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,1,6) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 38                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[293-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[293-256], v6, v[293-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[292-256], v[293-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[293-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[293-256], v6, v[293-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,1,7) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 39                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[295-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[295-256], v6, v[295-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[294-256], v[295-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[295-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[295-256], v6, v[295-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,2,0) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 64                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[297-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[297-256], v6, v[297-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[296-256], v[297-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[297-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[297-256], v6, v[297-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,2,1) */
s_mov_b32 s12, 65                                  // coordOffset0 d0=2 vc0=1
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[299-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[299-256], v6, v[299-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[298-256], v[299-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[299-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[299-256], v6, v[299-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,2,2) */
s_mov_b32 s12, 66                                  // coordOffset0 d0=2 vc0=2
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[301-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[301-256], v6, v[301-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[300-256], v[301-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[301-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[301-256], v6, v[301-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,2,3) */
s_mov_b32 s12, 67                                  // coordOffset0 d0=2 vc0=3
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[303-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[303-256], v6, v[303-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[302-256], v[303-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[303-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[303-256], v6, v[303-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,2,4) */
s_mov_b32 s12, 68                                  // coordOffset0 d0=2 vc0=4
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[305-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[305-256], v6, v[305-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[304-256], v[305-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[305-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[305-256], v6, v[305-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,2,5) */
s_mov_b32 s12, 69                                  // coordOffset0 d0=2 vc0=5
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[307-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[307-256], v6, v[307-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[306-256], v[307-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[307-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[307-256], v6, v[307-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,2,6) */
s_mov_b32 s12, 70                                  // coordOffset0 d0=2 vc0=6
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[309-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[309-256], v6, v[309-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[308-256], v[309-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[309-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[309-256], v6, v[309-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,2,7) */
s_mov_b32 s12, 71                                  // coordOffset0 d0=2 vc0=7
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[311-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[311-256], v6, v[311-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[310-256], v[311-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[311-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[311-256], v6, v[311-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,3,0) */
s_mov_b32 s12, 96                                  // coordOffset0 d0=3 vc0=0
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[313-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[313-256], v6, v[313-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[312-256], v[313-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[313-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[313-256], v6, v[313-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,3,1) */
s_mov_b32 s12, 97                                  // coordOffset0 d0=3 vc0=1
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[315-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[315-256], v6, v[315-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[314-256], v[315-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[315-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[315-256], v6, v[315-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,3,2) */
s_mov_b32 s12, 98                                  // coordOffset0 d0=3 vc0=2
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[317-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[317-256], v6, v[317-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[316-256], v[317-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[317-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[317-256], v6, v[317-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,3,3) */
s_mov_b32 s12, 99                                  // coordOffset0 d0=3 vc0=3
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[319-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[319-256], v6, v[319-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[318-256], v[319-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[319-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[319-256], v6, v[319-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,3,4) */
s_mov_b32 s12, 100                                 // coordOffset0 d0=3 vc0=4
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[321-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[321-256], v6, v[321-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[320-256], v[321-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[321-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[321-256], v6, v[321-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,3,5) */
s_mov_b32 s12, 101                                 // coordOffset0 d0=3 vc0=5
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[323-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[323-256], v6, v[323-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[322-256], v[323-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[323-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[323-256], v6, v[323-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,3,6) */
s_mov_b32 s12, 102                                 // coordOffset0 d0=3 vc0=6
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[325-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[325-256], v6, v[325-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[324-256], v[325-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[325-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[325-256], v6, v[325-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,3,7) */
s_mov_b32 s12, 103                                 // coordOffset0 d0=3 vc0=7
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[327-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[327-256], v6, v[327-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[326-256], v[327-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[327-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[327-256], v6, v[327-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,0,0) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v1, vcc_lo, v1, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v2, v2, s[sgprStrideC1J]              // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v3, v3, s[sgprStrideD1J]              // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v0, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[329-256], v2, v0, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[329-256], v6, v[329-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[328-256], v[329-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[329-256], v3, v0, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[329-256], v6, v[329-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,0,1) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 1                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[331-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[331-256], v6, v[331-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[330-256], v[331-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[331-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[331-256], v6, v[331-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,0,2) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 2                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[333-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[333-256], v6, v[333-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[332-256], v[333-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[333-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[333-256], v6, v[333-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,0,3) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 3                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[335-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[335-256], v6, v[335-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[334-256], v[335-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[335-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[335-256], v6, v[335-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,0,4) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 4                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[337-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[337-256], v6, v[337-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[336-256], v[337-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[337-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[337-256], v6, v[337-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,0,5) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 5                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[339-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[339-256], v6, v[339-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[338-256], v[339-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[339-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_wait_xcnt 0
s_prefetch_inst_pc_rel 0, null, 31
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[339-256], v6, v[339-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,0,6) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 6                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[341-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[341-256], v6, v[341-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[340-256], v[341-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[341-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[341-256], v6, v[341-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,0,7) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 7                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[343-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[343-256], v6, v[343-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[342-256], v[343-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[343-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[343-256], v6, v[343-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,1,0) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 32                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[345-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[345-256], v6, v[345-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[344-256], v[345-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[345-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[345-256], v6, v[345-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,1,1) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 33                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[347-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[347-256], v6, v[347-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[346-256], v[347-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[347-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[347-256], v6, v[347-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,1,2) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 34                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[349-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[349-256], v6, v[349-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[348-256], v[349-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[349-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[349-256], v6, v[349-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,1,3) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 35                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[351-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[351-256], v6, v[351-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[350-256], v[351-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[351-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[351-256], v6, v[351-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,1,4) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 36                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[353-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[353-256], v6, v[353-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[352-256], v[353-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[353-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[353-256], v6, v[353-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,1,5) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 37                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[355-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[355-256], v6, v[355-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[354-256], v[355-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[355-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[355-256], v6, v[355-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,1,6) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 38                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[357-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[357-256], v6, v[357-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[356-256], v[357-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[357-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[357-256], v6, v[357-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,1,7) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 39                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[359-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[359-256], v6, v[359-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[358-256], v[359-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[359-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[359-256], v6, v[359-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,2,0) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 64                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[361-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[361-256], v6, v[361-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[360-256], v[361-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[361-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[361-256], v6, v[361-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,2,1) */
s_mov_b32 s12, 65                                  // coordOffset0 d0=2 vc0=1
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[363-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[363-256], v6, v[363-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[362-256], v[363-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[363-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[363-256], v6, v[363-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,2,2) */
s_mov_b32 s12, 66                                  // coordOffset0 d0=2 vc0=2
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[365-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[365-256], v6, v[365-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[364-256], v[365-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[365-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[365-256], v6, v[365-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,2,3) */
s_mov_b32 s12, 67                                  // coordOffset0 d0=2 vc0=3
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[367-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[367-256], v6, v[367-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[366-256], v[367-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[367-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[367-256], v6, v[367-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,2,4) */
s_mov_b32 s12, 68                                  // coordOffset0 d0=2 vc0=4
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[369-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[369-256], v6, v[369-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[368-256], v[369-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[369-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[369-256], v6, v[369-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,2,5) */
s_mov_b32 s12, 69                                  // coordOffset0 d0=2 vc0=5
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[371-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[371-256], v6, v[371-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[370-256], v[371-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[371-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[371-256], v6, v[371-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,2,6) */
s_mov_b32 s12, 70                                  // coordOffset0 d0=2 vc0=6
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[373-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[373-256], v6, v[373-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[372-256], v[373-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[373-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[373-256], v6, v[373-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,2,7) */
s_mov_b32 s12, 71                                  // coordOffset0 d0=2 vc0=7
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[375-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[375-256], v6, v[375-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[374-256], v[375-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[375-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[375-256], v6, v[375-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,3,0) */
s_mov_b32 s12, 96                                  // coordOffset0 d0=3 vc0=0
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[377-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[377-256], v6, v[377-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[376-256], v[377-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[377-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[377-256], v6, v[377-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,3,1) */
s_mov_b32 s12, 97                                  // coordOffset0 d0=3 vc0=1
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[379-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[379-256], v6, v[379-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[378-256], v[379-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[379-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[379-256], v6, v[379-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,3,2) */
s_mov_b32 s12, 98                                  // coordOffset0 d0=3 vc0=2
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[381-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[381-256], v6, v[381-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[380-256], v[381-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[381-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[381-256], v6, v[381-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,3,3) */
s_mov_b32 s12, 99                                  // coordOffset0 d0=3 vc0=3
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[383-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[383-256], v6, v[383-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[382-256], v[383-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[383-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[383-256], v6, v[383-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,3,4) */
s_mov_b32 s12, 100                                 // coordOffset0 d0=3 vc0=4
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[385-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[385-256], v6, v[385-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[384-256], v[385-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[385-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[385-256], v6, v[385-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,3,5) */
s_mov_b32 s12, 101                                 // coordOffset0 d0=3 vc0=5
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[387-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[387-256], v6, v[387-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[386-256], v[387-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[387-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[387-256], v6, v[387-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,3,6) */
s_mov_b32 s12, 102                                 // coordOffset0 d0=3 vc0=6
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[389-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[389-256], v6, v[389-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[388-256], v[389-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[389-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[389-256], v6, v[389-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,3,7) */
s_mov_b32 s12, 103                                 // coordOffset0 d0=3 vc0=7
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[391-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[391-256], v6, v[391-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[390-256], v[391-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[391-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[391-256], v6, v[391-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,0,0) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v1, vcc_lo, v1, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v2, v2, s[sgprStrideC1J]              // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v3, v3, s[sgprStrideD1J]              // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v0, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[393-256], v2, v0, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[393-256], v6, v[393-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[392-256], v[393-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[393-256], v3, v0, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[393-256], v6, v[393-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,0,1) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 1                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[395-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[395-256], v6, v[395-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[394-256], v[395-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[395-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[395-256], v6, v[395-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,0,2) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 2                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[397-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[397-256], v6, v[397-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[396-256], v[397-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[397-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[397-256], v6, v[397-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,0,3) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 3                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[399-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[399-256], v6, v[399-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[398-256], v[399-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[399-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[399-256], v6, v[399-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,0,4) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 4                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[401-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[401-256], v6, v[401-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[400-256], v[401-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[401-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[401-256], v6, v[401-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,0,5) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 5                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[403-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[403-256], v6, v[403-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[402-256], v[403-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[403-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[403-256], v6, v[403-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,0,6) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 6                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[405-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[405-256], v6, v[405-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[404-256], v[405-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[405-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[405-256], v6, v[405-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,0,7) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 7                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[407-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[407-256], v6, v[407-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[406-256], v[407-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[407-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[407-256], v6, v[407-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,1,0) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 32                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[409-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[409-256], v6, v[409-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[408-256], v[409-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[409-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[409-256], v6, v[409-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,1,1) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 33                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[411-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[411-256], v6, v[411-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[410-256], v[411-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[411-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[411-256], v6, v[411-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,1,2) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 34                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[413-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[413-256], v6, v[413-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[412-256], v[413-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[413-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[413-256], v6, v[413-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,1,3) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 35                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[415-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[415-256], v6, v[415-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[414-256], v[415-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
s_wait_xcnt 0
s_prefetch_inst_pc_rel 0, null, 31
v_add_lshl_u32 v[415-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[415-256], v6, v[415-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,1,4) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 36                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[417-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[417-256], v6, v[417-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[416-256], v[417-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[417-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[417-256], v6, v[417-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,1,5) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 37                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[419-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[419-256], v6, v[419-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[418-256], v[419-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[419-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[419-256], v6, v[419-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,1,6) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 38                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[421-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[421-256], v6, v[421-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[420-256], v[421-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[421-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[421-256], v6, v[421-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,1,7) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 39                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[423-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[423-256], v6, v[423-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[422-256], v[423-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[423-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[423-256], v6, v[423-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,2,0) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 64                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[425-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[425-256], v6, v[425-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[424-256], v[425-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[425-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[425-256], v6, v[425-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,2,1) */
s_mov_b32 s12, 65                                  // coordOffset0 d0=2 vc0=1
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[427-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[427-256], v6, v[427-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[426-256], v[427-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[427-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[427-256], v6, v[427-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,2,2) */
s_mov_b32 s12, 66                                  // coordOffset0 d0=2 vc0=2
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[429-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[429-256], v6, v[429-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[428-256], v[429-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[429-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[429-256], v6, v[429-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,2,3) */
s_mov_b32 s12, 67                                  // coordOffset0 d0=2 vc0=3
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[431-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[431-256], v6, v[431-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[430-256], v[431-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[431-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[431-256], v6, v[431-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,2,4) */
s_mov_b32 s12, 68                                  // coordOffset0 d0=2 vc0=4
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[433-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[433-256], v6, v[433-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[432-256], v[433-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[433-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[433-256], v6, v[433-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,2,5) */
s_mov_b32 s12, 69                                  // coordOffset0 d0=2 vc0=5
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[435-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[435-256], v6, v[435-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[434-256], v[435-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[435-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[435-256], v6, v[435-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,2,6) */
s_mov_b32 s12, 70                                  // coordOffset0 d0=2 vc0=6
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[437-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[437-256], v6, v[437-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[436-256], v[437-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[437-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[437-256], v6, v[437-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,2,7) */
s_mov_b32 s12, 71                                  // coordOffset0 d0=2 vc0=7
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[439-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[439-256], v6, v[439-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[438-256], v[439-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[439-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[439-256], v6, v[439-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,3,0) */
s_mov_b32 s12, 96                                  // coordOffset0 d0=3 vc0=0
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[441-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[441-256], v6, v[441-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[440-256], v[441-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[441-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[441-256], v6, v[441-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,3,1) */
s_mov_b32 s12, 97                                  // coordOffset0 d0=3 vc0=1
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[443-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[443-256], v6, v[443-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[442-256], v[443-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[443-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[443-256], v6, v[443-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,3,2) */
s_mov_b32 s12, 98                                  // coordOffset0 d0=3 vc0=2
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[445-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[445-256], v6, v[445-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[444-256], v[445-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[445-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[445-256], v6, v[445-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,3,3) */
s_mov_b32 s12, 99                                  // coordOffset0 d0=3 vc0=3
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[447-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[447-256], v6, v[447-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[446-256], v[447-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[447-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[447-256], v6, v[447-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,3,4) */
s_mov_b32 s12, 100                                 // coordOffset0 d0=3 vc0=4
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[449-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[449-256], v6, v[449-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[448-256], v[449-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[449-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[449-256], v6, v[449-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,3,5) */
s_mov_b32 s12, 101                                 // coordOffset0 d0=3 vc0=5
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[451-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[451-256], v6, v[451-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[450-256], v[451-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[451-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[451-256], v6, v[451-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,3,6) */
s_mov_b32 s12, 102                                 // coordOffset0 d0=3 vc0=6
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[453-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[453-256], v6, v[453-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[452-256], v[453-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[453-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[453-256], v6, v[453-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,3,7) */
s_mov_b32 s12, 103                                 // coordOffset0 d0=3 vc0=7
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[455-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[455-256], v6, v[455-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[454-256], v[455-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[455-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[455-256], v6, v[455-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,0,0) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v1, vcc_lo, v1, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v2, v2, s[sgprStrideC1J]              // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v3, v3, s[sgprStrideD1J]              // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v0, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[457-256], v2, v0, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[457-256], v6, v[457-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[456-256], v[457-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[457-256], v3, v0, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[457-256], v6, v[457-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,0,1) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 1                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[459-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[459-256], v6, v[459-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[458-256], v[459-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[459-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[459-256], v6, v[459-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,0,2) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 2                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[461-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[461-256], v6, v[461-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[460-256], v[461-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[461-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[461-256], v6, v[461-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,0,3) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 3                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[463-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[463-256], v6, v[463-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[462-256], v[463-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[463-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[463-256], v6, v[463-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,0,4) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 4                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[465-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[465-256], v6, v[465-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[464-256], v[465-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[465-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[465-256], v6, v[465-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,0,5) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 5                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[467-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[467-256], v6, v[467-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[466-256], v[467-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[467-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[467-256], v6, v[467-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,0,6) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 6                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[469-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[469-256], v6, v[469-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[468-256], v[469-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[469-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[469-256], v6, v[469-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,0,7) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 7                     // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[471-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[471-256], v6, v[471-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[470-256], v[471-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[471-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[471-256], v6, v[471-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,1,0) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 32                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[473-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[473-256], v6, v[473-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[472-256], v[473-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[473-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[473-256], v6, v[473-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,1,1) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 33                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[475-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[475-256], v6, v[475-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[474-256], v[475-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[475-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[475-256], v6, v[475-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,1,2) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 34                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[477-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[477-256], v6, v[477-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[476-256], v[477-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[477-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[477-256], v6, v[477-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,1,3) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 35                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[479-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[479-256], v6, v[479-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[478-256], v[479-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[479-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[479-256], v6, v[479-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,1,4) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 36                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[481-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[481-256], v6, v[481-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[480-256], v[481-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[481-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[481-256], v6, v[481-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,1,5) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 37                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[483-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[483-256], v6, v[483-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[482-256], v[483-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[483-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[483-256], v6, v[483-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,1,6) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 38                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[485-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[485-256], v6, v[485-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[484-256], v[485-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[485-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[485-256], v6, v[485-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,1,7) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 39                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[487-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[487-256], v6, v[487-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[486-256], v[487-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[487-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[487-256], v6, v[487-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,2,0) */
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, 64                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[489-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[489-256], v6, v[489-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[488-256], v[489-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[489-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[489-256], v6, v[489-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,2,1) */
s_mov_b32 s12, 65                                  // coordOffset0 d0=2 vc0=1
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[491-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[491-256], v6, v[491-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[490-256], v[491-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_xcnt 0
s_prefetch_inst_pc_rel 0, null, 31
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[491-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[491-256], v6, v[491-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,2,2) */
s_mov_b32 s12, 66                                  // coordOffset0 d0=2 vc0=2
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[493-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[493-256], v6, v[493-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[492-256], v[493-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[493-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[493-256], v6, v[493-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,2,3) */
s_mov_b32 s12, 67                                  // coordOffset0 d0=2 vc0=3
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[495-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[495-256], v6, v[495-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[494-256], v[495-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[495-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[495-256], v6, v[495-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,2,4) */
s_mov_b32 s12, 68                                  // coordOffset0 d0=2 vc0=4
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[497-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[497-256], v6, v[497-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[496-256], v[497-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[497-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[497-256], v6, v[497-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,2,5) */
s_mov_b32 s12, 69                                  // coordOffset0 d0=2 vc0=5
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[499-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[499-256], v6, v[499-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[498-256], v[499-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[499-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[499-256], v6, v[499-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,2,6) */
s_mov_b32 s12, 70                                  // coordOffset0 d0=2 vc0=6
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[501-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[501-256], v6, v[501-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[500-256], v[501-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[501-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[501-256], v6, v[501-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,2,7) */
s_mov_b32 s12, 71                                  // coordOffset0 d0=2 vc0=7
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[503-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[503-256], v6, v[503-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[502-256], v[503-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[503-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[503-256], v6, v[503-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,3,0) */
s_mov_b32 s12, 96                                  // coordOffset0 d0=3 vc0=0
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[505-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[505-256], v6, v[505-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[504-256], v[505-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[505-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[505-256], v6, v[505-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,3,1) */
s_mov_b32 s12, 97                                  // coordOffset0 d0=3 vc0=1
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[507-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[507-256], v6, v[507-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[506-256], v[507-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[507-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[507-256], v6, v[507-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,3,2) */
s_mov_b32 s12, 98                                  // coordOffset0 d0=3 vc0=2
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[509-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[509-256], v6, v[509-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[508-256], v[509-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[509-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[509-256], v6, v[509-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,3,3) */
s_mov_b32 s12, 99                                  // coordOffset0 d0=3 vc0=3
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_add_lshl_u32 v[511-256], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[511-256], v6, v[511-256], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 17473                               // src0: 1, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[510-256], v[511-256], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[511-256], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_cndmask_b32 v[511-256], v6, v[511-256], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,3,4) */
s_mov_b32 s12, 100                                 // coordOffset0 d0=3 vc0=4
s_set_vgpr_msb 17408                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 128                                 // src0: 0, src1: 0, src2: 0, dst: 2
v_add_lshl_u32 v[513-512], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 32904                               // src0: 0, src1: 2, src2: 0, dst: 2
v_cndmask_b32 v[513-512], v6, v[513-512], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 34946                               // src0: 2, src1: 0, src2: 0, dst: 2
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[512-512], v[513-512], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 33408                               // src0: 0, src1: 0, src2: 0, dst: 2
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[513-512], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 32904                               // src0: 0, src1: 2, src2: 0, dst: 2
v_cndmask_b32 v[513-512], v6, v[513-512], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,3,5) */
s_mov_b32 s12, 101                                 // coordOffset0 d0=3 vc0=5
s_set_vgpr_msb 34816                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 128                                 // src0: 0, src1: 0, src2: 0, dst: 2
v_add_lshl_u32 v[515-512], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 32904                               // src0: 0, src1: 2, src2: 0, dst: 2
v_cndmask_b32 v[515-512], v6, v[515-512], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 34946                               // src0: 2, src1: 0, src2: 0, dst: 2
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[514-512], v[515-512], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 33408                               // src0: 0, src1: 0, src2: 0, dst: 2
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[515-512], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 32904                               // src0: 0, src1: 2, src2: 0, dst: 2
v_cndmask_b32 v[515-512], v6, v[515-512], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,3,6) */
s_mov_b32 s12, 102                                 // coordOffset0 d0=3 vc0=6
s_set_vgpr_msb 34816                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 128                                 // src0: 0, src1: 0, src2: 0, dst: 2
v_add_lshl_u32 v[517-512], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 32904                               // src0: 0, src1: 2, src2: 0, dst: 2
v_cndmask_b32 v[517-512], v6, v[517-512], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 34946                               // src0: 2, src1: 0, src2: 0, dst: 2
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[516-512], v[517-512], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 33408                               // src0: 0, src1: 0, src2: 0, dst: 2
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[517-512], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 32904                               // src0: 0, src1: 2, src2: 0, dst: 2
v_cndmask_b32 v[517-512], v6, v[517-512], s14      // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,3,7) */
s_mov_b32 s12, 103                                 // coordOffset0 d0=3 vc0=7
s_set_vgpr_msb 34816                               // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v4, vcc_lo, v0, s12                   // coord0.2: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
s_set_vgpr_msb 128                                 // src0: 0, src1: 0, src2: 0, dst: 2
v_add_lshl_u32 v[519-512], v2, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 32904                               // src0: 0, src1: 2, src2: 0, dst: 2
v_cndmask_b32 v[519-512], v6, v[519-512], s14      // LDC clip if OOB. offset
s_set_vgpr_msb 34946                               // src0: 2, src1: 0, src2: 0, dst: 2
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v[518-512], v[519-512], s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_set_vgpr_msb 33408                               // src0: 0, src1: 0, src2: 0, dst: 2
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v[519-512], v3, v4, 2               // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
s_set_vgpr_msb 32904                               // src0: 0, src1: 2, src2: 0, dst: 2
v_cndmask_b32 v[519-512], v6, v[519-512], s14      // LDD clip if OOB. offset

/* rC *= alpha batchElements=[(0, 0, 0, 0), (0, 0, 0, 1), (0, 0, 0, 2), (0, 0, 0, 3), (0, 0, 0, 4), (0, 0, 0, 5), (0, 0, 0, 6), (0, 0, 0, 7), (0, 1, 0, 0), (0, 1, 0, 1), (0, 1, 0, 2), (0, 1, 0, 3), (0, 1, 0, 4), (0, 1, 0, 5), (0, 1, 0, 6), (0, 1, 0, 7), (0, 2, 0, 0), (0, 2, 0, 1), (0, 2, 0, 2), (0, 2, 0, 3), (0, 2, 0, 4), (0, 2, 0, 5), (0, 2, 0, 6), (0, 2, 0, 7), (0, 3, 0, 0), (0, 3, 0, 1), (0, 3, 0, 2), (0, 3, 0, 3), (0, 3, 0, 4), (0, 3, 0, 5), (0, 3, 0, 6), (0, 3, 0, 7), (0, 0, 1, 0), (0, 0, 1, 1), (0, 0, 1, 2), (0, 0, 1, 3), (0, 0, 1, 4), (0, 0, 1, 5), (0, 0, 1, 6), (0, 0, 1, 7), (0, 1, 1, 0), (0, 1, 1, 1), (0, 1, 1, 2), (0, 1, 1, 3), (0, 1, 1, 4), (0, 1, 1, 5), (0, 1, 1, 6), (0, 1, 1, 7), (0, 2, 1, 0), (0, 2, 1, 1), (0, 2, 1, 2), (0, 2, 1, 3), (0, 2, 1, 4), (0, 2, 1, 5), (0, 2, 1, 6), (0, 2, 1, 7), (0, 3, 1, 0), (0, 3, 1, 1), (0, 3, 1, 2), (0, 3, 1, 3), (0, 3, 1, 4), (0, 3, 1, 5), (0, 3, 1, 6), (0, 3, 1, 7), (0, 0, 2, 0), (0, 0, 2, 1), (0, 0, 2, 2), (0, 0, 2, 3), (0, 0, 2, 4), (0, 0, 2, 5), (0, 0, 2, 6), (0, 0, 2, 7), (0, 1, 2, 0), (0, 1, 2, 1), (0, 1, 2, 2), (0, 1, 2, 3), (0, 1, 2, 4), (0, 1, 2, 5), (0, 1, 2, 6), (0, 1, 2, 7), (0, 2, 2, 0), (0, 2, 2, 1), (0, 2, 2, 2), (0, 2, 2, 3), (0, 2, 2, 4), (0, 2, 2, 5), (0, 2, 2, 6), (0, 2, 2, 7), (0, 3, 2, 0), (0, 3, 2, 1), (0, 3, 2, 2), (0, 3, 2, 3), (0, 3, 2, 4), (0, 3, 2, 5), (0, 3, 2, 6), (0, 3, 2, 7), (0, 0, 3, 0), (0, 0, 3, 1), (0, 0, 3, 2), (0, 0, 3, 3), (0, 0, 3, 4), (0, 0, 3, 5), (0, 0, 3, 6), (0, 0, 3, 7), (0, 1, 3, 0), (0, 1, 3, 1), (0, 1, 3, 2), (0, 1, 3, 3), (0, 1, 3, 4), (0, 1, 3, 5), (0, 1, 3, 6), (0, 1, 3, 7), (0, 2, 3, 0), (0, 2, 3, 1), (0, 2, 3, 2), (0, 2, 3, 3), (0, 2, 3, 4), (0, 2, 3, 5), (0, 2, 3, 6), (0, 2, 3, 7), (0, 3, 3, 0), (0, 3, 3, 1), (0, 3, 3, 2), (0, 3, 3, 3), (0, 3, 3, 4), (0, 3, 3, 5), (0, 3, 3, 6), (0, 3, 3, 7)] */
s_set_vgpr_msb 34816                               // src0: 0, src1: 0, src2: 0, dst: 0
v_mul_f32 v[vgprValuC+-7], s[sgprAlpha], v[vgprValuC+0] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+-6], s[sgprAlpha], v[vgprValuC+1] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+-5], s[sgprAlpha], v[vgprValuC+2] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+-4], s[sgprAlpha], v[vgprValuC+3] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+-3], s[sgprAlpha], v[vgprValuC+4] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+-2], s[sgprAlpha], v[vgprValuC+5] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+-1], s[sgprAlpha], v[vgprValuC+6] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+128], s[sgprAlpha], v[vgprValuC+7] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+129], s[sgprAlpha], v[vgprValuC+8] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+130], s[sgprAlpha], v[vgprValuC+9] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+131], s[sgprAlpha], v[vgprValuC+10] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+132], s[sgprAlpha], v[vgprValuC+11] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+133], s[sgprAlpha], v[vgprValuC+12] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+134], s[sgprAlpha], v[vgprValuC+13] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+135], s[sgprAlpha], v[vgprValuC+14] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+136], s[sgprAlpha], v[vgprValuC+15] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+137], s[sgprAlpha], v[vgprValuC+16] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+138], s[sgprAlpha], v[vgprValuC+17] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+139], s[sgprAlpha], v[vgprValuC+18] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+140], s[sgprAlpha], v[vgprValuC+19] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+141], s[sgprAlpha], v[vgprValuC+20] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+142], s[sgprAlpha], v[vgprValuC+21] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+143], s[sgprAlpha], v[vgprValuC+22] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+144], s[sgprAlpha], v[vgprValuC+23] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+145], s[sgprAlpha], v[vgprValuC+24] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+146], s[sgprAlpha], v[vgprValuC+25] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+147], s[sgprAlpha], v[vgprValuC+26] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+148], s[sgprAlpha], v[vgprValuC+27] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+149], s[sgprAlpha], v[vgprValuC+28] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+150], s[sgprAlpha], v[vgprValuC+29] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+151], s[sgprAlpha], v[vgprValuC+30] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+152], s[sgprAlpha], v[vgprValuC+31] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+153], s[sgprAlpha], v[vgprValuC+32] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+154], s[sgprAlpha], v[vgprValuC+33] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+155], s[sgprAlpha], v[vgprValuC+34] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+156], s[sgprAlpha], v[vgprValuC+35] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+157], s[sgprAlpha], v[vgprValuC+36] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+158], s[sgprAlpha], v[vgprValuC+37] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+159], s[sgprAlpha], v[vgprValuC+38] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+160], s[sgprAlpha], v[vgprValuC+39] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+161], s[sgprAlpha], v[vgprValuC+40] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+162], s[sgprAlpha], v[vgprValuC+41] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+163], s[sgprAlpha], v[vgprValuC+42] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+164], s[sgprAlpha], v[vgprValuC+43] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+165], s[sgprAlpha], v[vgprValuC+44] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+166], s[sgprAlpha], v[vgprValuC+45] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+167], s[sgprAlpha], v[vgprValuC+46] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+168], s[sgprAlpha], v[vgprValuC+47] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+169], s[sgprAlpha], v[vgprValuC+48] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+170], s[sgprAlpha], v[vgprValuC+49] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+171], s[sgprAlpha], v[vgprValuC+50] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+172], s[sgprAlpha], v[vgprValuC+51] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+173], s[sgprAlpha], v[vgprValuC+52] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+174], s[sgprAlpha], v[vgprValuC+53] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+175], s[sgprAlpha], v[vgprValuC+54] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+176], s[sgprAlpha], v[vgprValuC+55] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+177], s[sgprAlpha], v[vgprValuC+56] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+178], s[sgprAlpha], v[vgprValuC+57] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+179], s[sgprAlpha], v[vgprValuC+58] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+180], s[sgprAlpha], v[vgprValuC+59] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+181], s[sgprAlpha], v[vgprValuC+60] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+182], s[sgprAlpha], v[vgprValuC+61] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+183], s[sgprAlpha], v[vgprValuC+62] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+184], s[sgprAlpha], v[vgprValuC+63] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+185], s[sgprAlpha], v[vgprValuC+64] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+186], s[sgprAlpha], v[vgprValuC+65] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+187], s[sgprAlpha], v[vgprValuC+66] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+188], s[sgprAlpha], v[vgprValuC+67] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+189], s[sgprAlpha], v[vgprValuC+68] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+190], s[sgprAlpha], v[vgprValuC+69] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+191], s[sgprAlpha], v[vgprValuC+70] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+192], s[sgprAlpha], v[vgprValuC+71] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+193], s[sgprAlpha], v[vgprValuC+72] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+194], s[sgprAlpha], v[vgprValuC+73] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+195], s[sgprAlpha], v[vgprValuC+74] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+196], s[sgprAlpha], v[vgprValuC+75] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+197], s[sgprAlpha], v[vgprValuC+76] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+198], s[sgprAlpha], v[vgprValuC+77] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+199], s[sgprAlpha], v[vgprValuC+78] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+200], s[sgprAlpha], v[vgprValuC+79] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+201], s[sgprAlpha], v[vgprValuC+80] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+202], s[sgprAlpha], v[vgprValuC+81] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+203], s[sgprAlpha], v[vgprValuC+82] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+204], s[sgprAlpha], v[vgprValuC+83] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+205], s[sgprAlpha], v[vgprValuC+84] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+206], s[sgprAlpha], v[vgprValuC+85] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+207], s[sgprAlpha], v[vgprValuC+86] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+208], s[sgprAlpha], v[vgprValuC+87] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+209], s[sgprAlpha], v[vgprValuC+88] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+210], s[sgprAlpha], v[vgprValuC+89] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+211], s[sgprAlpha], v[vgprValuC+90] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+212], s[sgprAlpha], v[vgprValuC+91] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+213], s[sgprAlpha], v[vgprValuC+92] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+214], s[sgprAlpha], v[vgprValuC+93] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+215], s[sgprAlpha], v[vgprValuC+94] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+216], s[sgprAlpha], v[vgprValuC+95] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+217], s[sgprAlpha], v[vgprValuC+96] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+218], s[sgprAlpha], v[vgprValuC+97] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+219], s[sgprAlpha], v[vgprValuC+98] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+220], s[sgprAlpha], v[vgprValuC+99] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+221], s[sgprAlpha], v[vgprValuC+100] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+222], s[sgprAlpha], v[vgprValuC+101] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+223], s[sgprAlpha], v[vgprValuC+102] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+224], s[sgprAlpha], v[vgprValuC+103] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+225], s[sgprAlpha], v[vgprValuC+104] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+226], s[sgprAlpha], v[vgprValuC+105] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+227], s[sgprAlpha], v[vgprValuC+106] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+228], s[sgprAlpha], v[vgprValuC+107] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+229], s[sgprAlpha], v[vgprValuC+108] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+230], s[sgprAlpha], v[vgprValuC+109] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+231], s[sgprAlpha], v[vgprValuC+110] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+232], s[sgprAlpha], v[vgprValuC+111] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+233], s[sgprAlpha], v[vgprValuC+112] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+234], s[sgprAlpha], v[vgprValuC+113] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+235], s[sgprAlpha], v[vgprValuC+114] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+236], s[sgprAlpha], v[vgprValuC+115] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+237], s[sgprAlpha], v[vgprValuC+116] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+238], s[sgprAlpha], v[vgprValuC+117] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+239], s[sgprAlpha], v[vgprValuC+118] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+240], s[sgprAlpha], v[vgprValuC+119] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+241], s[sgprAlpha], v[vgprValuC+120] // Multiply MI out reg with alpha
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_mul_f32 v[vgprValuC+242-256], s[sgprAlpha], v[vgprValuC+121] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+243-256], s[sgprAlpha], v[vgprValuC+122] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+244-256], s[sgprAlpha], v[vgprValuC+123] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+245-256], s[sgprAlpha], v[vgprValuC+124] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+246-256], s[sgprAlpha], v[vgprValuC+125] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+247-256], s[sgprAlpha], v[vgprValuC+126] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+248-256], s[sgprAlpha], v[vgprValuC+127] // Multiply MI out reg with alpha
s_set_vgpr_msb 16385                               // src0: 1, src1: 0, src2: 0, dst: 0
s_wait_loadcnt 0                                   // wait for Beta

/* apply mask, calc new C and issue writes */
v_fmac_f32 v[vgprValuC+-7], v[263-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v7, v[264-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+-6], v[265-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v8, v[266-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+-5], v[267-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v9, v[268-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+-4], v[269-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v10, v[270-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+-3], v[271-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v11, v[272-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+-2], v[273-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v12, v[274-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+-1], v[275-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v13, v[277-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+128], v[278-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v142, v[279-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+129], v[280-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v143, v[281-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+130], v[282-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v144, v[283-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+131], v[284-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v145, v[285-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+132], v[286-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v146, v[287-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+133], v[288-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v147, v[289-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+134], v[290-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v148, v[291-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+135], v[292-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v149, v[293-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+136], v[294-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v150, v[295-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+137], v[296-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v151, v[297-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+138], v[298-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v152, v[299-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+139], v[300-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v153, v[301-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+140], v[302-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v154, v[303-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+141], v[304-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v155, v[305-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+142], v[306-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v156, v[307-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+143], v[308-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v157, v[309-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+144], v[310-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v158, v[311-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+145], v[312-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v159, v[313-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+146], v[314-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v160, v[315-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+147], v[316-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v161, v[317-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+148], v[318-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v162, v[319-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+149], v[320-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v163, v[321-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+150], v[322-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v164, v[323-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+151], v[324-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v165, v[325-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+152], v[326-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v166, v[327-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+153], v[328-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v167, v[329-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+154], v[330-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v168, v[331-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+155], v[332-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v169, v[333-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+156], v[334-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v170, v[335-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+157], v[336-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v171, v[337-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+158], v[338-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v172, v[339-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+159], v[340-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v173, v[341-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+160], v[342-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v174, v[343-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+161], v[344-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v175, v[345-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+162], v[346-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v176, v[347-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+163], v[348-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v177, v[349-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+164], v[350-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v178, v[351-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+165], v[352-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v179, v[353-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+166], v[354-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v180, v[355-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+167], v[356-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v181, v[357-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+168], v[358-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v182, v[359-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+169], v[360-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v183, v[361-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+170], v[362-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v184, v[363-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+171], v[364-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v185, v[365-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+172], v[366-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v186, v[367-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+173], v[368-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v187, v[369-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+174], v[370-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v188, v[371-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+175], v[372-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v189, v[373-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+176], v[374-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v190, v[375-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+177], v[376-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v191, v[377-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+178], v[378-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v192, v[379-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+179], v[380-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v193, v[381-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+180], v[382-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v194, v[383-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+181], v[384-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v195, v[385-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+182], v[386-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v196, v[387-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+183], v[388-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v197, v[389-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+184], v[390-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v198, v[391-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+185], v[392-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v199, v[393-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+186], v[394-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v200, v[395-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+187], v[396-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v201, v[397-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+188], v[398-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v202, v[399-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+189], v[400-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v203, v[401-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+190], v[402-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v204, v[403-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+191], v[404-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v205, v[405-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+192], v[406-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v206, v[407-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+193], v[408-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v207, v[409-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+194], v[410-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v208, v[411-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+195], v[412-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v209, v[413-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+196], v[414-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v210, v[415-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+197], v[416-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v211, v[417-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+198], v[418-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v212, v[419-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+199], v[420-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v213, v[421-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+200], v[422-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v214, v[423-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+201], v[424-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v215, v[425-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+202], v[426-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
s_wait_xcnt 0
s_prefetch_inst_pc_rel 0, null, 31
buffer_store_b32 v216, v[427-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+203], v[428-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v217, v[429-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+204], v[430-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v218, v[431-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+205], v[432-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v219, v[433-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+206], v[434-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v220, v[435-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+207], v[436-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v221, v[437-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+208], v[438-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v222, v[439-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+209], v[440-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v223, v[441-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+210], v[442-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v224, v[443-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+211], v[444-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v225, v[445-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+212], v[446-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v226, v[447-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+213], v[448-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v227, v[449-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+214], v[450-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v228, v[451-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+215], v[452-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v229, v[453-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+216], v[454-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v230, v[455-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+217], v[456-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v231, v[457-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+218], v[458-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v232, v[459-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+219], v[460-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v233, v[461-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+220], v[462-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v234, v[463-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+221], v[464-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v235, v[465-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+222], v[466-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v236, v[467-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+223], v[468-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v237, v[469-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+224], v[470-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v238, v[471-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+225], v[472-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v239, v[473-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+226], v[474-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v240, v[475-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+227], v[476-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v241, v[477-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+228], v[478-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v242, v[479-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+229], v[480-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v243, v[481-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+230], v[482-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v244, v[483-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+231], v[484-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v245, v[485-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+232], v[486-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v246, v[487-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+233], v[488-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v247, v[489-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+234], v[490-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v248, v[491-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+235], v[492-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v249, v[493-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+236], v[494-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v250, v[495-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+237], v[496-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v251, v[497-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+238], v[498-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v252, v[499-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+239], v[500-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v253, v[501-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+240], v[502-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v254, v[503-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+241], v[504-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v255, v[505-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_set_vgpr_msb 321                                 // src0: 1, src1: 0, src2: 0, dst: 1
v_fmac_f32 v[vgprValuC+242-256], v[506-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v[256-256], v[507-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+243-256], v[508-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v[257-256], v[509-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+244-256], v[510-256], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v[258-256], v[511-256], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_set_vgpr_msb 16706                               // src0: 2, src1: 0, src2: 0, dst: 1
v_fmac_f32 v[vgprValuC+245-256], v[512-512], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v[259-256], v[513-512], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+246-256], v[514-512], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v[260-256], v[515-512], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+247-256], v[516-512], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v[261-256], v[517-512], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+248-256], v[518-512], s[sgprBeta] // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v[262-256], v[519-512], s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_nop 0                                            // 1 wait state required when next inst writes vgprs held by previous dwordx4 store inst
s_branch label_GW_End_1                            // jump to end
label_GW_End_1:
label_KernelEnd:
s_wait_xcnt 0
s_prefetch_inst_pc_rel 0, null, 31
s_endpgm                                           // Kernel End
label_ASM_End:  /// The end of the kernel
