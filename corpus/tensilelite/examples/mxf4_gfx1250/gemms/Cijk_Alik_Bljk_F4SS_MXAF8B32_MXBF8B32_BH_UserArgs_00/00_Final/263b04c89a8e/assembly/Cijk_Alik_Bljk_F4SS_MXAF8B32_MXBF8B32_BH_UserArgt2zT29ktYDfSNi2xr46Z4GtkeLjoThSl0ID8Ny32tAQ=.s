
/******************************************/
/* Begin Kernel                           */
/******************************************/
/* STINKY_TOTAL_INST_BYTES: 20848 */
.amdgcn_target "amdgcn-amd-amdhsa--gfx1250"
.text
.protected Cijk_Alik_Bljk_F4SS_MXAF8B32_MXBF8B32_BH_UserArgs_MT64x64x256_MI16x16x1_SN_LDSB0_AFC0_AG0_AGGSUA0_AGNTAB0_AFEM2_AFEM2_ASEM32_BL1_BS1_CD1_1_CLR1_CLS0_CADS0_DTLA0_DTLB0_DTLM0_DTVA0_DTVB0_DTVMXSA0_DTVMXSB0_DTVSM0_DPLB0_EPS0_ELFLR0_EMLLn1_FDSI1_GRPM1_GRVWA2_GRVWB2_GSUAMB_GLS0_HPLR0_ISA1250_ICIW1_IU1_K1_LDSTI0_LBSPPA256_LBSPPB256_LBSPPMXSA0_LBSPPMXSB0_LBSPPM0_LPA32_LPB32_LPMXSA0_LPMXSB0_LPM0_LRVW32_LWPMn1_MIAV1_MIWT2_2_MXLITDM_MXSFIMS_MO40_MGRIPM1_NTn1_NTA0_NTB0_NTC0_NTD0_NTE0_NTMXSA0_NTMXSB0_NTM0_NTWS0_NVn1_NVA0_NVB0_NVC0_NVD0_NVE0_NVMXSA0_NVMXSB0_NVM0_NVWS0_NEPBS0_NLCA1_NLCB1_ONLL1_PAP0_PGL0_PGR2_PLR1_PKA1_SGROB0_SIA0_SS1_SPO0_SRVW0_SSO0_SVW1_SK0_SKFTR0_SKFDPO0_SKWS0_SKXCCM0_SNLL0_SIP1_SGRO0_TDMI3_TDMIM0_TDMLWS0_TDMS0_TIN0_THn1_THA0_THB0_THC0_THD0_THE0_THMXSA0_THMXSB0_THM0_THWS0_TLDS1_TLDSMn1_ULSGRO0_USL1_USLMX0_UDFMAC0_UIOFGRO0_UPLRP0_USFGRO0_USI0_VSn1_VWA1_VWB2_WSGRA0_WSGRB0_WS32_WG32_4_1_WGMXCC1
.globl Cijk_Alik_Bljk_F4SS_MXAF8B32_MXBF8B32_BH_UserArgs_MT64x64x256_MI16x16x1_SN_LDSB0_AFC0_AG0_AGGSUA0_AGNTAB0_AFEM2_AFEM2_ASEM32_BL1_BS1_CD1_1_CLR1_CLS0_CADS0_DTLA0_DTLB0_DTLM0_DTVA0_DTVB0_DTVMXSA0_DTVMXSB0_DTVSM0_DPLB0_EPS0_ELFLR0_EMLLn1_FDSI1_GRPM1_GRVWA2_GRVWB2_GSUAMB_GLS0_HPLR0_ISA1250_ICIW1_IU1_K1_LDSTI0_LBSPPA256_LBSPPB256_LBSPPMXSA0_LBSPPMXSB0_LBSPPM0_LPA32_LPB32_LPMXSA0_LPMXSB0_LPM0_LRVW32_LWPMn1_MIAV1_MIWT2_2_MXLITDM_MXSFIMS_MO40_MGRIPM1_NTn1_NTA0_NTB0_NTC0_NTD0_NTE0_NTMXSA0_NTMXSB0_NTM0_NTWS0_NVn1_NVA0_NVB0_NVC0_NVD0_NVE0_NVMXSA0_NVMXSB0_NVM0_NVWS0_NEPBS0_NLCA1_NLCB1_ONLL1_PAP0_PGL0_PGR2_PLR1_PKA1_SGROB0_SIA0_SS1_SPO0_SRVW0_SSO0_SVW1_SK0_SKFTR0_SKFDPO0_SKWS0_SKXCCM0_SNLL0_SIP1_SGRO0_TDMI3_TDMIM0_TDMLWS0_TDMS0_TIN0_THn1_THA0_THB0_THC0_THD0_THE0_THMXSA0_THMXSB0_THM0_THWS0_TLDS1_TLDSMn1_ULSGRO0_USL1_USLMX0_UDFMAC0_UIOFGRO0_UPLRP0_USFGRO0_USI0_VSn1_VWA1_VWB2_WSGRA0_WSGRB0_WS32_WG32_4_1_WGMXCC1
.p2align 8
.type Cijk_Alik_Bljk_F4SS_MXAF8B32_MXBF8B32_BH_UserArgs_MT64x64x256_MI16x16x1_SN_LDSB0_AFC0_AG0_AGGSUA0_AGNTAB0_AFEM2_AFEM2_ASEM32_BL1_BS1_CD1_1_CLR1_CLS0_CADS0_DTLA0_DTLB0_DTLM0_DTVA0_DTVB0_DTVMXSA0_DTVMXSB0_DTVSM0_DPLB0_EPS0_ELFLR0_EMLLn1_FDSI1_GRPM1_GRVWA2_GRVWB2_GSUAMB_GLS0_HPLR0_ISA1250_ICIW1_IU1_K1_LDSTI0_LBSPPA256_LBSPPB256_LBSPPMXSA0_LBSPPMXSB0_LBSPPM0_LPA32_LPB32_LPMXSA0_LPMXSB0_LPM0_LRVW32_LWPMn1_MIAV1_MIWT2_2_MXLITDM_MXSFIMS_MO40_MGRIPM1_NTn1_NTA0_NTB0_NTC0_NTD0_NTE0_NTMXSA0_NTMXSB0_NTM0_NTWS0_NVn1_NVA0_NVB0_NVC0_NVD0_NVE0_NVMXSA0_NVMXSB0_NVM0_NVWS0_NEPBS0_NLCA1_NLCB1_ONLL1_PAP0_PGL0_PGR2_PLR1_PKA1_SGROB0_SIA0_SS1_SPO0_SRVW0_SSO0_SVW1_SK0_SKFTR0_SKFDPO0_SKWS0_SKXCCM0_SNLL0_SIP1_SGRO0_TDMI3_TDMIM0_TDMLWS0_TDMS0_TIN0_THn1_THA0_THB0_THC0_THD0_THE0_THMXSA0_THMXSB0_THM0_THWS0_TLDS1_TLDSMn1_ULSGRO0_USL1_USLMX0_UDFMAC0_UIOFGRO0_UPLRP0_USFGRO0_USI0_VSn1_VWA1_VWB2_WSGRA0_WSGRB0_WS32_WG32_4_1_WGMXCC1,@function
.section .rodata,#alloc
.p2align 6
.amdhsa_kernel Cijk_Alik_Bljk_F4SS_MXAF8B32_MXBF8B32_BH_UserArgs_MT64x64x256_MI16x16x1_SN_LDSB0_AFC0_AG0_AGGSUA0_AGNTAB0_AFEM2_AFEM2_ASEM32_BL1_BS1_CD1_1_CLR1_CLS0_CADS0_DTLA0_DTLB0_DTLM0_DTVA0_DTVB0_DTVMXSA0_DTVMXSB0_DTVSM0_DPLB0_EPS0_ELFLR0_EMLLn1_FDSI1_GRPM1_GRVWA2_GRVWB2_GSUAMB_GLS0_HPLR0_ISA1250_ICIW1_IU1_K1_LDSTI0_LBSPPA256_LBSPPB256_LBSPPMXSA0_LBSPPMXSB0_LBSPPM0_LPA32_LPB32_LPMXSA0_LPMXSB0_LPM0_LRVW32_LWPMn1_MIAV1_MIWT2_2_MXLITDM_MXSFIMS_MO40_MGRIPM1_NTn1_NTA0_NTB0_NTC0_NTD0_NTE0_NTMXSA0_NTMXSB0_NTM0_NTWS0_NVn1_NVA0_NVB0_NVC0_NVD0_NVE0_NVMXSA0_NVMXSB0_NVM0_NVWS0_NEPBS0_NLCA1_NLCB1_ONLL1_PAP0_PGL0_PGR2_PLR1_PKA1_SGROB0_SIA0_SS1_SPO0_SRVW0_SSO0_SVW1_SK0_SKFTR0_SKFDPO0_SKWS0_SKXCCM0_SNLL0_SIP1_SGRO0_TDMI3_TDMIM0_TDMLWS0_TDMS0_TIN0_THn1_THA0_THB0_THC0_THD0_THE0_THMXSA0_THMXSB0_THM0_THWS0_TLDS1_TLDSMn1_ULSGRO0_USL1_USLMX0_UDFMAC0_UIOFGRO0_UPLRP0_USFGRO0_USI0_VSn1_VWA1_VWB2_WSGRA0_WSGRB0_WS32_WG32_4_1_WGMXCC1
  .amdhsa_user_sgpr_kernarg_segment_ptr 1
  .amdhsa_next_free_vgpr 336 // vgprs
  .amdhsa_next_free_sgpr 94 // sgprs
  .amdhsa_group_segment_fixed_size 51200 // lds bytes
  .amdhsa_wavefront_size32 1 // 32-thread wavefronts
  .amdhsa_private_segment_fixed_size 0
  .amdhsa_system_sgpr_workgroup_id_x 1
  .amdhsa_system_sgpr_workgroup_id_y 1
  .amdhsa_system_sgpr_workgroup_id_z 1
  .amdhsa_system_vgpr_workitem_id 0
  .amdhsa_float_denorm_mode_32 3
  .amdhsa_float_denorm_mode_16_64 3
  .amdhsa_inst_pref_size 162
  .amdhsa_user_sgpr_count 29
  .amdhsa_user_sgpr_kernarg_preload_length 27
  .amdhsa_user_sgpr_kernarg_preload_offset 0
.end_amdhsa_kernel
.text
/* Num VGPR   =336 */
/* Num AccVGPR=0 */
/* Num SGPR   =94 */

/******************************************/
/* Optimizations and Config:              */
/******************************************/
/* ThreadTile= 16 x 2 */
/* SubGroup= 4 x 32 */
/* VectorWidthA=1 */
/* VectorWidthB=2 */
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
  - .name: Cijk_Alik_Bljk_F4SS_MXAF8B32_MXBF8B32_BH_UserArgs_MT64x64x256_MI16x16x1_SN_LDSB0_AFC0_AG0_AGGSUA0_AGNTAB0_AFEM2_AFEM2_ASEM32_BL1_BS1_CD1_1_CLR1_CLS0_CADS0_DTLA0_DTLB0_DTLM0_DTVA0_DTVB0_DTVMXSA0_DTVMXSB0_DTVSM0_DPLB0_EPS0_ELFLR0_EMLLn1_FDSI1_GRPM1_GRVWA2_GRVWB2_GSUAMB_GLS0_HPLR0_ISA1250_ICIW1_IU1_K1_LDSTI0_LBSPPA256_LBSPPB256_LBSPPMXSA0_LBSPPMXSB0_LBSPPM0_LPA32_LPB32_LPMXSA0_LPMXSB0_LPM0_LRVW32_LWPMn1_MIAV1_MIWT2_2_MXLITDM_MXSFIMS_MO40_MGRIPM1_NTn1_NTA0_NTB0_NTC0_NTD0_NTE0_NTMXSA0_NTMXSB0_NTM0_NTWS0_NVn1_NVA0_NVB0_NVC0_NVD0_NVE0_NVMXSA0_NVMXSB0_NVM0_NVWS0_NEPBS0_NLCA1_NLCB1_ONLL1_PAP0_PGL0_PGR2_PLR1_PKA1_SGROB0_SIA0_SS1_SPO0_SRVW0_SSO0_SVW1_SK0_SKFTR0_SKFDPO0_SKWS0_SKXCCM0_SNLL0_SIP1_SGRO0_TDMI3_TDMIM0_TDMLWS0_TDMS0_TIN0_THn1_THA0_THB0_THC0_THD0_THE0_THMXSA0_THMXSB0_THM0_THWS0_TLDS1_TLDSMn1_ULSGRO0_USL1_USLMX0_UDFMAC0_UIOFGRO0_UPLRP0_USFGRO0_USI0_VSn1_VWA1_VWB2_WSGRA0_WSGRB0_WS32_WG32_4_1_WGMXCC1
    .symbol: 'Cijk_Alik_Bljk_F4SS_MXAF8B32_MXBF8B32_BH_UserArgs_MT64x64x256_MI16x16x1_SN_LDSB0_AFC0_AG0_AGGSUA0_AGNTAB0_AFEM2_AFEM2_ASEM32_BL1_BS1_CD1_1_CLR1_CLS0_CADS0_DTLA0_DTLB0_DTLM0_DTVA0_DTVB0_DTVMXSA0_DTVMXSB0_DTVSM0_DPLB0_EPS0_ELFLR0_EMLLn1_FDSI1_GRPM1_GRVWA2_GRVWB2_GSUAMB_GLS0_HPLR0_ISA1250_ICIW1_IU1_K1_LDSTI0_LBSPPA256_LBSPPB256_LBSPPMXSA0_LBSPPMXSB0_LBSPPM0_LPA32_LPB32_LPMXSA0_LPMXSB0_LPM0_LRVW32_LWPMn1_MIAV1_MIWT2_2_MXLITDM_MXSFIMS_MO40_MGRIPM1_NTn1_NTA0_NTB0_NTC0_NTD0_NTE0_NTMXSA0_NTMXSB0_NTM0_NTWS0_NVn1_NVA0_NVB0_NVC0_NVD0_NVE0_NVMXSA0_NVMXSB0_NVM0_NVWS0_NEPBS0_NLCA1_NLCB1_ONLL1_PAP0_PGL0_PGR2_PLR1_PKA1_SGROB0_SIA0_SS1_SPO0_SRVW0_SSO0_SVW1_SK0_SKFTR0_SKFDPO0_SKWS0_SKXCCM0_SNLL0_SIP1_SGRO0_TDMI3_TDMIM0_TDMLWS0_TDMS0_TIN0_THn1_THA0_THB0_THC0_THD0_THE0_THMXSA0_THMXSB0_THM0_THWS0_TLDS1_TLDSMn1_ULSGRO0_USL1_USLMX0_UDFMAC0_UIOFGRO0_UPLRP0_USFGRO0_USI0_VSn1_VWA1_VWB2_WSGRA0_WSGRB0_WS32_WG32_4_1_WGMXCC1.kd'
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
    .group_segment_fixed_size:   51200
    .kernarg_segment_align:      8
    .kernarg_segment_size:       168
    .max_flat_workgroup_size:    128
    .private_segment_fixed_size: 0
    .sgpr_count:                 94
    .sgpr_spill_count:           0
    .vgpr_count:                 336
    .vgpr_spill_count:           0
    .wavefront_size:             32
...
.end_amdgpu_metadata
Cijk_Alik_Bljk_F4SS_MXAF8B32_MXBF8B32_BH_UserArgs_MT64x64x256_MI16x16x1_SN_LDSB0_AFC0_AG0_AGGSUA0_AGNTAB0_AFEM2_AFEM2_ASEM32_BL1_BS1_CD1_1_CLR1_CLS0_CADS0_DTLA0_DTLB0_DTLM0_DTVA0_DTVB0_DTVMXSA0_DTVMXSB0_DTVSM0_DPLB0_EPS0_ELFLR0_EMLLn1_FDSI1_GRPM1_GRVWA2_GRVWB2_GSUAMB_GLS0_HPLR0_ISA1250_ICIW1_IU1_K1_LDSTI0_LBSPPA256_LBSPPB256_LBSPPMXSA0_LBSPPMXSB0_LBSPPM0_LPA32_LPB32_LPMXSA0_LPMXSB0_LPM0_LRVW32_LWPMn1_MIAV1_MIWT2_2_MXLITDM_MXSFIMS_MO40_MGRIPM1_NTn1_NTA0_NTB0_NTC0_NTD0_NTE0_NTMXSA0_NTMXSB0_NTM0_NTWS0_NVn1_NVA0_NVB0_NVC0_NVD0_NVE0_NVMXSA0_NVMXSB0_NVM0_NVWS0_NEPBS0_NLCA1_NLCB1_ONLL1_PAP0_PGL0_PGR2_PLR1_PKA1_SGROB0_SIA0_SS1_SPO0_SRVW0_SSO0_SVW1_SK0_SKFTR0_SKFDPO0_SKWS0_SKXCCM0_SNLL0_SIP1_SGRO0_TDMI3_TDMIM0_TDMLWS0_TDMS0_TIN0_THn1_THA0_THB0_THC0_THD0_THE0_THMXSA0_THMXSB0_THM0_THWS0_TLDS1_TLDSMn1_ULSGRO0_USL1_USLMX0_UDFMAC0_UIOFGRO0_UPLRP0_USFGRO0_USI0_VSn1_VWA1_VWB2_WSGRA0_WSGRB0_WS32_WG32_4_1_WGMXCC1:
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
.set vgprValuMXSB_X0_I0_BASE, vgprMXSBase+4
.set vgprValuMXSA_X0_I0, vgprValuMXSA_X0_I0_BASE+0
.set vgprValuMXSA_X1_I0, vgprValuMXSA_X0_I0_BASE+1
.set vgprValuMXSB_X0_I0, vgprValuMXSB_X0_I0_BASE+0
.set vgprValuMXSB_X1_I0, vgprValuMXSB_X0_I0_BASE+2
.set vgprG2LMXSA, vgprG2LMXSA_BASE+0
.set vgprG2LMXSB, vgprG2LMXSB_BASE+0

/******************************************/
/* VGPR Assignments                       */
/******************************************/
/* ValuC range: [8-40), serializedStore enabled */
.set vgprValuC, 8
/* ValuA/B   Xn=PLR buffer idx,  In=InnerUnroll idx */
.set vgprBase, 44
.set vgprGlobalReadOffsetA, 40
.set vgprGlobalReadOffsetMXSA, 40
.set vgprGlobalReadOffsetB, 40
.set vgprGlobalReadOffsetMXSB, 40
.set vgprLocalReadAddrA, 42
.set vgprLocalReadAddrMXSA, 40
.set vgprLocalReadAddrB, 43
.set vgprLocalReadAddrMXSB, 41
.set vgprSerial, 110

/******************************************/
/* VGPR Macro Assignments                 */
/******************************************/
.set vgprValuA_X0_I0_BASE, vgprBase+0
.set vgprValuB_X0_I0_BASE, vgprBase+34
.set vgprValuA_X0_I0, vgprValuA_X0_I0_BASE+0
.set vgprValuA_X1_I0, vgprValuA_X0_I0_BASE+16
.set vgprValuB_X0_I0, vgprValuB_X0_I0_BASE+0
.set vgprValuB_X1_I0, vgprValuB_X0_I0_BASE+16
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

.set MT0, 64
.set MT1, 64
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
s_mov_b32 m0, 0xc800                               // LDS clamp at 51200 bytes
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v[vgprSerial], v0                        // thread serial id
s_mov_b32 vcc_hi, 0                                // Ensure hi bits are zero
v_readfirstlane_b32 s65, v[vgprSerial]             // first tId
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
/* init: add vgpr [0...8) to pool */
/* init: add vgpr [44...154) to pool */
/* init: add vgpr [8...40) to pool */
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
v_lshlrev_b32 v0, 8, v0                            // 1. N offset: nOffset = nIdx * nStride(256)
/* Skip. 2. block offset: bnOffset = 0 when num1DBlocks = 1 */
                                                   // 4. apply VectorWidth: bnOffset = bnOffset * vw(1) (multiplier is 1, do nothing)
v_lshrrev_b32 v1, 4, v1                            // 5. K offset: kIdx = wtid / (MIN(16) * MIBB(1))
v_lshl_add_u32 v0, v1, 5, v0                       // 5. K offset: lrKOffset = kIdx * mStride(32); 6. offset in wave: lrOffset = bnOffset + lrKOffset
v_lshrrev_b32 v4, 5, v[vgprSerial]                 // 7. wave offset in N dimen: wtid = tid / dividedForWaveId(32)
v_and_b32 v4, 1, v4                                // 7. wave offset in M dimen: wtid0 = wtid / num1DWaves(2)
v_lshl_add_u32 v0, v4, 12, v0                      // 7. wave offset in M dimen: wOffset = wtid0 * W0Stride(4096); 7. final local read offset: flrOffset = lrOffset + WOffset
/* lr0I */
v_and_b32 v1, 31, v[vgprSerial]                    // 0. thread id in wave: wtid = tid % wavelength(32)
v_and_b32 v1, 15, v1                               // 1. N offset: nIdx = wtid % MI_N(16)
v_lshlrev_b32 v1, 2, v1                            // 1. N offset: nOffset = nIdx * nStride(4)
/* Skip. 2. block offset: bnOffset = 0 when num1DBlocks = 1 */
                                                   // 4. apply VectorWidth: bnOffset = bnOffset * vw(1) (multiplier is 1, do nothing)
v_lshrrev_b32 v3, 5, v[vgprSerial]                 // 7. wave offset in N dimen: wtid = tid / dividedForWaveId(32)
v_and_b32 v3, 1, v3                                // 7. wave offset in M dimen: wtid0 = wtid / num1DWaves(2)
v_lshl_add_u32 v1, v3, 6, v1                       // 7. wave offset in M dimen: wOffset = wtid0 * W0Stride(64); 7. final local read offset: flrOffset = lrOffset + WOffset
v_lshrrev_b32 v3, 4, v[vgprSerial]                 // 8. (TileSpan wave-split) hiSel = tid / MI_dim(16)
v_and_b32 v3, 1, v3                                // 8. (TileSpan wave-split) hi = (tid / MI_dim) & 1  (lower/upper half-wave)
v_lshl_add_u32 v1, v3, 7, v1                       // 8. (TileSpan wave-split) wave offset in M dimen: wOffset += hi * hiOffset(128); upper half-wave grabs partner block
/* lr1J */
v_and_b32 v3, 31, v[vgprSerial]                    // 0. thread id in wave: wtid = tid % wavelength(32)
v_and_b32 v2, 15, v3                               // 1. N offset: nIdx = wtid % MI_N(16)
v_lshlrev_b32 v2, 8, v2                            // 1. N offset: nOffset = nIdx * nStride(256)
/* Skip. 2. block offset: bnOffset = 0 when num1DBlocks = 1 */
v_lshlrev_b32 v2, 1, v2                            // 4. apply VectorWidth: bnOffset = bnOffset * vw(2)
v_lshrrev_b32 v3, 4, v3                            // 5. K offset: kIdx = wtid / (MIN(16) * MIBB(1))
v_lshl_add_u32 v2, v3, 5, v2                       // 5. K offset: lrKOffset = kIdx * mStride(32); 6. offset in wave: lrOffset = bnOffset + lrKOffset
v_lshrrev_b32 v6, 6, v[vgprSerial]                 // 7. wave offset in N dimen: wtid = tid / dividedForWaveId(64)
v_and_b32 v6, 1, v6                                // 7. wave offset in M dimen: wtid0 = wtid / num1DWaves(2)
v_lshl_add_u32 v2, v6, 13, v2                      // 7. wave offset in M dimen: wOffset = wtid0 * W0Stride(8192); 7. final local read offset: flrOffset = lrOffset + WOffset
/* lr1J */
v_and_b32 v4, 31, v[vgprSerial]                    // 0. thread id in wave: wtid = tid % wavelength(32)
v_and_b32 v3, 15, v4                               // 1. N offset: nIdx = wtid % MI_N(16)
v_lshlrev_b32 v3, 2, v3                            // 1. N offset: nOffset = nIdx * nStride(4)
/* Skip. 2. block offset: bnOffset = 0 when num1DBlocks = 1 */
v_lshlrev_b32 v3, 1, v3                            // 4. apply VectorWidth: bnOffset = bnOffset * vw(2)
v_lshrrev_b32 v5, 6, v[vgprSerial]                 // 7. wave offset in N dimen: wtid = tid / dividedForWaveId(64)
v_and_b32 v5, 1, v5                                // 7. wave offset in M dimen: wtid0 = wtid / num1DWaves(2)
v_lshl_add_u32 v3, v5, 7, v3                       // 7. wave offset in M dimen: wOffset = wtid0 * W0Stride(128); 7. final local read offset: flrOffset = lrOffset + WOffset

/* local read addresses: final offsets a */
v_lshrrev_b32 v4, 5, v[vgprSerial]                 // 4 = Serial / 32
v_lshrrev_b32 v4, 2, v4                            // LSU offset: Get LSU wave_id
s_mov_b32 s65, 256                                 // LSU offset: stride = lsuStride(256) when umlds==True
v_mul_lo_u32 v4, s65, v4                           // LSU offset: lsuoffset = wave_id*lsuStride*(MT0+PAD)
v_add_nc_u32 v[vgprLocalReadAddrA], v4, v0         // Final Offset: offset = (lro0+lsuoffset)*bpeDS
v_lshrrev_b32 v[vgprLocalReadAddrA], 1, v[vgprLocalReadAddrA] //  (multiple bpe)
v_lshrrev_b32 v5, 8, v[vgprLocalReadAddrA]         // Final Offset: padding 16 per block 256
v_lshl_add_u32 v[vgprLocalReadAddrA], v5, 4, v[vgprLocalReadAddrA] // Final Offset: padding 16 per block 256

/* local read addresses: final offsets mxsa */
v_lshrrev_b32 v0, 5, v[vgprSerial]                 // 0 = Serial / 32
v_lshrrev_b32 v0, 2, v0                            // LSU offset: Get LSU wave_id
s_mov_b32 s65, 512                                 // LSU offset: stride = lsuStride(8)*(MT0(64) + PAD0(0))
v_mul_lo_u32 v0, s65, v0                           // LSU offset: lsuoffset = wave_id*lsuStride*(MT0+PAD)
v_add_nc_u32 v[vgprLocalReadAddrMXSA], v0, v1      // Final Offset: offset = (lro0+lsuoffset)*bpeDS
                                                   //  (bpe is 1, do nothing)

/* local read addresses: final offsets mxsb */
v_lshrrev_b32 v0, 5, v[vgprSerial]                 // 0 = Serial / 32
v_lshrrev_b32 v0, 2, v0                            // LSU offset: Get LSU wave_id
                                                   // LSU offset: stride = lsuStride(8)*(MT1(64) + PAD1(0)) (dup assign opt.)
v_mul_lo_u32 v0, s65, v0                           // LSU offset: lsuoffset = wave_id*lsuStride*(MT1+PAD)
v_add_nc_u32 v[vgprLocalReadAddrMXSB], v0, v3      // Final Offset: offset = (lro1+lsuoffset)*bpeDS
                                                   //  (bpe is 1, do nothing)

/* local read addresses: final offsets b */
v_lshrrev_b32 v0, 5, v[vgprSerial]                 // 0 = Serial / 32
v_lshrrev_b32 v0, 2, v0                            // LSU offset: Get LSU wave_id
s_mov_b32 s65, 256                                 // LSU offset: stride = lsuStride(256) when umlds==True
v_mul_lo_u32 v0, s65, v0                           // LSU offset: lsuoffset = wave_id*lsuStride*(MT1+PAD)
v_add_nc_u32 v[vgprLocalReadAddrB], v0, v2         // Final Offset: offset = (lro1+lsuoffset)*bpeDS
v_lshrrev_b32 v[vgprLocalReadAddrB], 1, v[vgprLocalReadAddrB] //  (multiple bpe)
v_lshrrev_b32 v1, 8, v[vgprLocalReadAddrB]         // Final Offset: padding 16 per block 256
v_lshl_add_u32 v[vgprLocalReadAddrB], v1, 4, v[vgprLocalReadAddrB] // Final Offset: padding 16 per block 256

/* local read addresses: declare addresses a */

/* local read addresses: declare addresses mxsa */
v_add_co_u32 v[vgprLocalReadAddrMXSA+0], vcc_lo, 0x2200, v[vgprLocalReadAddrMXSA+0] //  += LdsOffsetMXSA (lower)

/* local read addresses: declare addresses mxsb */
v_add_co_u32 v[vgprLocalReadAddrMXSB+0], vcc_lo, 0x2400, v[vgprLocalReadAddrMXSB+0] //  += LdsOffsetMXSB (lower)

/* local read addresses: declare addresses b */
v_add_co_u32 v[vgprLocalReadAddrB+0], vcc_lo, 0x2600, v[vgprLocalReadAddrB+0] //  += LdsOffsetB (lower)

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
s_lshr_b32 s22, s32, 6                             // s22 = s32 / 64
s_and_b32 s20, 63, s32                             // s20 = s32 % 64
s_addc_u32 s22, s22, 0
s_lshr_b32 s23, s33, 6                             // s23 = s33 / 64
s_and_b32 s20, 63, s33                             // s20 = s33 % 64
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
s_lshr_b32 s22, s32, 6                             // s22 = s32 / 64
s_and_b32 s20, 63, s32                             // s20 = s32 % 64
s_addc_u32 s22, s22, 0
s_lshr_b32 s23, s33, 6                             // s23 = s33 / 64
s_and_b32 s20, 63, s33                             // s20 = s33 % 64
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
/* init: add vgpr [0...8) to pool */
/* init: add vgpr [44...154) to pool */
/* init: add vgpr [8...40) to pool */
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
v_lshlrev_b32 v0, 8, v0                            // 1. N offset: nOffset = nIdx * nStride(256)
/* Skip. 2. block offset: bnOffset = 0 when num1DBlocks = 1 */
                                                   // 4. apply VectorWidth: bnOffset = bnOffset * vw(1) (multiplier is 1, do nothing)
v_lshrrev_b32 v1, 4, v1                            // 5. K offset: kIdx = wtid / (MIN(16) * MIBB(1))
v_lshl_add_u32 v0, v1, 5, v0                       // 5. K offset: lrKOffset = kIdx * mStride(32); 6. offset in wave: lrOffset = bnOffset + lrKOffset
v_lshrrev_b32 v4, 5, v[vgprSerial]                 // 7. wave offset in N dimen: wtid = tid / dividedForWaveId(32)
v_and_b32 v4, 1, v4                                // 7. wave offset in M dimen: wtid0 = wtid / num1DWaves(2)
v_lshl_add_u32 v0, v4, 12, v0                      // 7. wave offset in M dimen: wOffset = wtid0 * W0Stride(4096); 7. final local read offset: flrOffset = lrOffset + WOffset
/* lr0I */
v_and_b32 v1, 31, v[vgprSerial]                    // 0. thread id in wave: wtid = tid % wavelength(32)
v_and_b32 v1, 15, v1                               // 1. N offset: nIdx = wtid % MI_N(16)
v_lshlrev_b32 v1, 2, v1                            // 1. N offset: nOffset = nIdx * nStride(4)
/* Skip. 2. block offset: bnOffset = 0 when num1DBlocks = 1 */
                                                   // 4. apply VectorWidth: bnOffset = bnOffset * vw(1) (multiplier is 1, do nothing)
v_lshrrev_b32 v3, 5, v[vgprSerial]                 // 7. wave offset in N dimen: wtid = tid / dividedForWaveId(32)
v_and_b32 v3, 1, v3                                // 7. wave offset in M dimen: wtid0 = wtid / num1DWaves(2)
v_lshl_add_u32 v1, v3, 6, v1                       // 7. wave offset in M dimen: wOffset = wtid0 * W0Stride(64); 7. final local read offset: flrOffset = lrOffset + WOffset
v_lshrrev_b32 v3, 4, v[vgprSerial]                 // 8. (TileSpan wave-split) hiSel = tid / MI_dim(16)
v_and_b32 v3, 1, v3                                // 8. (TileSpan wave-split) hi = (tid / MI_dim) & 1  (lower/upper half-wave)
v_lshl_add_u32 v1, v3, 7, v1                       // 8. (TileSpan wave-split) wave offset in M dimen: wOffset += hi * hiOffset(128); upper half-wave grabs partner block
/* lr1J */
v_and_b32 v3, 31, v[vgprSerial]                    // 0. thread id in wave: wtid = tid % wavelength(32)
v_and_b32 v2, 15, v3                               // 1. N offset: nIdx = wtid % MI_N(16)
v_lshlrev_b32 v2, 8, v2                            // 1. N offset: nOffset = nIdx * nStride(256)
/* Skip. 2. block offset: bnOffset = 0 when num1DBlocks = 1 */
v_lshlrev_b32 v2, 1, v2                            // 4. apply VectorWidth: bnOffset = bnOffset * vw(2)
v_lshrrev_b32 v3, 4, v3                            // 5. K offset: kIdx = wtid / (MIN(16) * MIBB(1))
v_lshl_add_u32 v2, v3, 5, v2                       // 5. K offset: lrKOffset = kIdx * mStride(32); 6. offset in wave: lrOffset = bnOffset + lrKOffset
v_lshrrev_b32 v6, 6, v[vgprSerial]                 // 7. wave offset in N dimen: wtid = tid / dividedForWaveId(64)
v_and_b32 v6, 1, v6                                // 7. wave offset in M dimen: wtid0 = wtid / num1DWaves(2)
v_lshl_add_u32 v2, v6, 13, v2                      // 7. wave offset in M dimen: wOffset = wtid0 * W0Stride(8192); 7. final local read offset: flrOffset = lrOffset + WOffset
/* lr1J */
v_and_b32 v4, 31, v[vgprSerial]                    // 0. thread id in wave: wtid = tid % wavelength(32)
v_and_b32 v3, 15, v4                               // 1. N offset: nIdx = wtid % MI_N(16)
v_lshlrev_b32 v3, 2, v3                            // 1. N offset: nOffset = nIdx * nStride(4)
/* Skip. 2. block offset: bnOffset = 0 when num1DBlocks = 1 */
v_lshlrev_b32 v3, 1, v3                            // 4. apply VectorWidth: bnOffset = bnOffset * vw(2)
v_lshrrev_b32 v5, 6, v[vgprSerial]                 // 7. wave offset in N dimen: wtid = tid / dividedForWaveId(64)
v_and_b32 v5, 1, v5                                // 7. wave offset in M dimen: wtid0 = wtid / num1DWaves(2)
v_lshl_add_u32 v3, v5, 7, v3                       // 7. wave offset in M dimen: wOffset = wtid0 * W0Stride(128); 7. final local read offset: flrOffset = lrOffset + WOffset

/* local read addresses: final offsets a */
v_lshrrev_b32 v4, 5, v[vgprSerial]                 // 4 = Serial / 32
v_lshrrev_b32 v4, 2, v4                            // LSU offset: Get LSU wave_id
s_mov_b32 s65, 256                                 // LSU offset: stride = lsuStride(256) when umlds==True
v_mul_lo_u32 v4, s65, v4                           // LSU offset: lsuoffset = wave_id*lsuStride*(MT0+PAD)
v_add_nc_u32 v[vgprLocalReadAddrA], v4, v0         // Final Offset: offset = (lro0+lsuoffset)*bpeDS
v_lshrrev_b32 v[vgprLocalReadAddrA], 1, v[vgprLocalReadAddrA] //  (multiple bpe)
v_lshrrev_b32 v5, 8, v[vgprLocalReadAddrA]         // Final Offset: padding 16 per block 256
v_lshl_add_u32 v[vgprLocalReadAddrA], v5, 4, v[vgprLocalReadAddrA] // Final Offset: padding 16 per block 256

/* local read addresses: final offsets mxsa */
v_lshrrev_b32 v0, 5, v[vgprSerial]                 // 0 = Serial / 32
v_lshrrev_b32 v0, 2, v0                            // LSU offset: Get LSU wave_id
s_mov_b32 s65, 512                                 // LSU offset: stride = lsuStride(8)*(MT0(64) + PAD0(0))
v_mul_lo_u32 v0, s65, v0                           // LSU offset: lsuoffset = wave_id*lsuStride*(MT0+PAD)
v_add_nc_u32 v[vgprLocalReadAddrMXSA], v0, v1      // Final Offset: offset = (lro0+lsuoffset)*bpeDS
                                                   //  (bpe is 1, do nothing)

/* local read addresses: final offsets mxsb */
v_lshrrev_b32 v0, 5, v[vgprSerial]                 // 0 = Serial / 32
v_lshrrev_b32 v0, 2, v0                            // LSU offset: Get LSU wave_id
                                                   // LSU offset: stride = lsuStride(8)*(MT1(64) + PAD1(0)) (dup assign opt.)
v_mul_lo_u32 v0, s65, v0                           // LSU offset: lsuoffset = wave_id*lsuStride*(MT1+PAD)
v_add_nc_u32 v[vgprLocalReadAddrMXSB], v0, v3      // Final Offset: offset = (lro1+lsuoffset)*bpeDS
                                                   //  (bpe is 1, do nothing)

/* local read addresses: final offsets b */
v_lshrrev_b32 v0, 5, v[vgprSerial]                 // 0 = Serial / 32
v_lshrrev_b32 v0, 2, v0                            // LSU offset: Get LSU wave_id
s_mov_b32 s65, 256                                 // LSU offset: stride = lsuStride(256) when umlds==True
v_mul_lo_u32 v0, s65, v0                           // LSU offset: lsuoffset = wave_id*lsuStride*(MT1+PAD)
v_add_nc_u32 v[vgprLocalReadAddrB], v0, v2         // Final Offset: offset = (lro1+lsuoffset)*bpeDS
v_lshrrev_b32 v[vgprLocalReadAddrB], 1, v[vgprLocalReadAddrB] //  (multiple bpe)
v_lshrrev_b32 v1, 8, v[vgprLocalReadAddrB]         // Final Offset: padding 16 per block 256
v_lshl_add_u32 v[vgprLocalReadAddrB], v1, 4, v[vgprLocalReadAddrB] // Final Offset: padding 16 per block 256

/* local read addresses: declare addresses a */

/* local read addresses: declare addresses mxsa */
v_add_co_u32 v[vgprLocalReadAddrMXSA+0], vcc_lo, 0x2200, v[vgprLocalReadAddrMXSA+0] //  += LdsOffsetMXSA (lower)

/* local read addresses: declare addresses mxsb */
v_add_co_u32 v[vgprLocalReadAddrMXSB+0], vcc_lo, 0x2400, v[vgprLocalReadAddrMXSB+0] //  += LdsOffsetMXSB (lower)

/* local read addresses: declare addresses b */
v_add_co_u32 v[vgprLocalReadAddrB+0], vcc_lo, 0x2600, v[vgprLocalReadAddrB+0] //  += LdsOffsetB (lower)

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
.set sgprtdmMXSAGroup0, 64
.set sgprtdmMXSAGroup1, 68
.set sgprtdmBGroup0, sgprtdmAGroup0+0
.set sgprtdmBGroup1, sgprtdmAGroup1+0
.set sgprtdmMXSBGroup0, sgprtdmMXSAGroup0+0
.set sgprtdmMXSBGroup1, sgprtdmMXSAGroup1+0
.set sgprtdmABIncs, 17
.set sgprtdmMXSAMXSBIncs, 18
.set sgprStaggerUIter, 19
.set sgprWrapUA, 76
.set sgprWrapUB, 78
.set sgprWrapUMXSA, 80
.set sgprWrapUMXSB, 82
.set sgprGlobalReadIncsA, 63
.set sgprGlobalReadIncsMXSA, 84
.set sgprGlobalReadIncsB, 85
.set sgprGlobalReadIncsMXSB, 86
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
s_and_b32 s76, s[sgprGSU], 0x3fff                  // Restore GSU
s_cmp_eq_u32 s76, 1                                // GSU == 1 ?
s_cbranch_scc1 label_GSU                           // branch if GSU == 1
// GSU-not-WGMapRR :nwg1 = (size1J + MT1J - 1) / MT1J;
s_and_b32 s76, s[sgprGSU], 0x4000                  // SCC = (GSUWGMRR == 1) ?
s_cbranch_scc1 label_GSUWGMRR                      // branch if GSUWGMRR == 1
s_and_b32 s76, s[sgprGSU], 0x3fff                  // Restore GSU
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cvt_f32_u32 v0, s76                              // s[sgprWorkGroup1] = s[sgprWorkGroup1] / s76
v_rcp_iflag_f32 v0, v0                             // s[sgprWorkGroup1] = s[sgprWorkGroup1] / s76
v_cvt_f32_u32 v1, s[sgprWorkGroup1]                // s[sgprWorkGroup1] = s[sgprWorkGroup1] / s76
v_mul_f32 v0, v0, v1                               // s[sgprWorkGroup1] = s[sgprWorkGroup1] / s76
v_cvt_u32_f32 v0, v0                               // s[sgprWorkGroup1] = s[sgprWorkGroup1] / s76
v_mul_u32_u24 v1, v0, s76                          // s[sgprWorkGroup1] = s[sgprWorkGroup1] / s76
v_sub_nc_u32 v1, s[sgprWorkGroup1], v1             // s[sgprWorkGroup1] = s[sgprWorkGroup1] / s76
v_cmp_eq_u32 vcc_lo, v1, s76                       // s[sgprWorkGroup1] = s[sgprWorkGroup1] / s76
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, vcc_lo                          // s[sgprWorkGroup1] = s[sgprWorkGroup1] / s76
v_add_nc_u32 v0, 1, v0                             // s[sgprWorkGroup1] = s[sgprWorkGroup1] / s76
v_mov_b32 v1, 0                                    // s[sgprGSUSumIdx] = s[sgprWorkGroup1] % s76
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, -1                              // Reset exec
v_cmp_gt_u32 vcc_lo, v1, s76                       // overflow happened in remainder
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, vcc_lo                          // overflow happened in remainder
v_sub_nc_u32 v0, v0, 1                             // quotient - 1
v_mul_u32_u24 v1, v0, s76                          // re-calculate remainder
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
s_mov_b32 s76, s[sgprWGM]                          // Restore WGM
s_sext_i32_i16 s76, s76                            // Restore WGM
s_cmp_gt_i32 s76, 1                                // WGM > 1 ?
s_cbranch_scc1 label_WGMPositive                   // branch if WGM > 1
s_cmp_ge_i32 s76, 0                                // WGM >= 0 ?
s_cbranch_scc1 label_WGM                           // branch if WGM >= 0
s_abs_i32 s76, s76                                 // abs(WGM)
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cvt_f64_u32 v[0:1], s76                          // s77 = s[sgprWorkGroup0] / s76
v_rcp_f64 v[0:1], v[0:1]                           // s77 = s[sgprWorkGroup0] / s76
v_cvt_f64_u32 v[2:3], s[sgprWorkGroup0]            // s77 = s[sgprWorkGroup0] / s76
v_mul_f64 v[0:1], v[0:1], v[2:3]                   // s77 = s[sgprWorkGroup0] / s76
v_cvt_u32_f64 v0, v[0:1]                           // s77 = s[sgprWorkGroup0] / s76
v_mul_lo_u32 v1, v0, s76                           // s77 = s[sgprWorkGroup0] / s76
v_sub_nc_u32 v2, s[sgprWorkGroup0], v1             // s77 = s[sgprWorkGroup0] / s76
v_cmp_ge_u32 vcc_lo, v2, s76                       // s77 = s[sgprWorkGroup0] / s76
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, vcc_lo                          // s77 = s[sgprWorkGroup0] / s76
v_add_nc_u32 v0, v0, 1                             // s77 = s[sgprWorkGroup0] / s76
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, -1                              // Reset exec
v_readfirstlane_b32 s77, v0                        // quotient
s_mul_i32 s87, s77, s76                            // quotient * non-magic divisor
s_sub_u32 s87, s[sgprWorkGroup0], s87              // WorkGroup0=remainder
s_mul_i32 s87, s87, s[sgprNumWorkGroups1]          // (wg1 % WGM)*NumWorkGroups1
s_add_u32 s87, s87, s[sgprWorkGroup1]              // wgSerial = wg0 + (wg1 % WGM)*NumWorkGroups1
v_cvt_f64_u32 v[0:1], s76                          // s78 = s[sgprNumWorkGroups0] / s76
v_rcp_f64 v[0:1], v[0:1]                           // s78 = s[sgprNumWorkGroups0] / s76
v_cvt_f64_u32 v[2:3], s[sgprNumWorkGroups0]        // s78 = s[sgprNumWorkGroups0] / s76
v_mul_f64 v[0:1], v[0:1], v[2:3]                   // s78 = s[sgprNumWorkGroups0] / s76
v_cvt_u32_f64 v0, v[0:1]                           // s78 = s[sgprNumWorkGroups0] / s76
v_mul_lo_u32 v1, v0, s76                           // s78 = s[sgprNumWorkGroups0] / s76
v_sub_nc_u32 v2, s[sgprNumWorkGroups0], v1         // s78 = s[sgprNumWorkGroups0] / s76
v_cmp_ge_u32 vcc_lo, v2, s76                       // s78 = s[sgprNumWorkGroups0] / s76
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, vcc_lo                          // s78 = s[sgprNumWorkGroups0] / s76
v_add_nc_u32 v0, v0, 1                             // s78 = s[sgprNumWorkGroups0] / s76
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, -1                              // Reset exec
v_readfirstlane_b32 s78, v0                        // quotient
s_mul_i32 s79, s76, s78                            // quotient * non-magic divisor
s_sub_u32 s79, s[sgprNumWorkGroups0], s79          // NumWorkGroups0=remainder
s_cmp_eq_u32 s79, 0                                // remainder == 0 ?
s_cmov_b32 s79, s76                                // remainder = WGM if remainder == 0
s_cmp_ge_u32 s77, s78                              // blockId >= numFullBlocks ?
s_cselect_b32 s78, s79, s76
v_cvt_f64_u32 v[0:1], s78                          // s[sgprWorkGroup1] = s87 / s78
v_rcp_f64 v[0:1], v[0:1]                           // s[sgprWorkGroup1] = s87 / s78
v_cvt_f64_u32 v[2:3], s87                          // s[sgprWorkGroup1] = s87 / s78
v_mul_f64 v[0:1], v[0:1], v[2:3]                   // s[sgprWorkGroup1] = s87 / s78
v_cvt_u32_f64 v0, v[0:1]                           // s[sgprWorkGroup1] = s87 / s78
v_mul_lo_u32 v1, v0, s78                           // s[sgprWorkGroup1] = s87 / s78
v_sub_nc_u32 v2, s87, v1                           // s[sgprWorkGroup1] = s87 / s78
v_cmp_ge_u32 vcc_lo, v2, s78                       // s[sgprWorkGroup1] = s87 / s78
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, vcc_lo                          // s[sgprWorkGroup1] = s87 / s78
v_add_nc_u32 v0, v0, 1                             // s[sgprWorkGroup1] = s87 / s78
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, -1                              // Reset exec
v_mul_lo_u32 v1, v0, s78                           // s[sgprWorkGroup1] = s87 / s78
v_sub_nc_u32 v2, s87, v1                           // s[sgprWorkGroup1] = s87 / s78
v_readfirstlane_b32 s[sgprWorkGroup1], v0          // quotient
v_readfirstlane_b32 s[sgprWorkGroup0], v2          // remainder
s_mul_i32 s[sgprWorkGroup0], s[sgprWorkGroup1], s78 // quotient * non-magic divisor
s_sub_u32 s[sgprWorkGroup0], s87, s[sgprWorkGroup0] // WorkGroup0=remainder
s_mul_i32 s77, s77, s76                            // blockId * WGM
s_add_u32 s[sgprWorkGroup0], s[sgprWorkGroup0], s77 // wg1 += blockId * WGM
s_branch label_WGM
label_WGMPositive:
s_mov_b32 s76, s76                                 // WGM
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cvt_f64_u32 v[0:1], s76                          // s77 = s[sgprWorkGroup1] / s76
v_rcp_f64 v[0:1], v[0:1]                           // s77 = s[sgprWorkGroup1] / s76
v_cvt_f64_u32 v[2:3], s[sgprWorkGroup1]            // s77 = s[sgprWorkGroup1] / s76
v_mul_f64 v[0:1], v[0:1], v[2:3]                   // s77 = s[sgprWorkGroup1] / s76
v_cvt_u32_f64 v0, v[0:1]                           // s77 = s[sgprWorkGroup1] / s76
v_mul_lo_u32 v1, v0, s76                           // s77 = s[sgprWorkGroup1] / s76
v_sub_nc_u32 v2, s[sgprWorkGroup1], v1             // s77 = s[sgprWorkGroup1] / s76
v_cmp_ge_u32 vcc_lo, v2, s76                       // s77 = s[sgprWorkGroup1] / s76
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, vcc_lo                          // s77 = s[sgprWorkGroup1] / s76
v_add_nc_u32 v0, v0, 1                             // s77 = s[sgprWorkGroup1] / s76
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, -1                              // Reset exec
v_readfirstlane_b32 s77, v0                        // quotient
s_mul_i32 s87, s77, s76                            // quotient * non-magic divisor
s_sub_u32 s87, s[sgprWorkGroup1], s87              // WorkGroup1=remainder
s_mul_i32 s87, s87, s[sgprNumWorkGroups0]          // (wg1 % WGM)*NumWorkGroups0
s_add_u32 s87, s87, s[sgprWorkGroup0]              // wgSerial = wg0 + (wg1 % WGM)*NumWorkGroups0
v_cvt_f64_u32 v[0:1], s76                          // s78 = s[sgprNumWorkGroups1] / s76
v_rcp_f64 v[0:1], v[0:1]                           // s78 = s[sgprNumWorkGroups1] / s76
v_cvt_f64_u32 v[2:3], s[sgprNumWorkGroups1]        // s78 = s[sgprNumWorkGroups1] / s76
v_mul_f64 v[0:1], v[0:1], v[2:3]                   // s78 = s[sgprNumWorkGroups1] / s76
v_cvt_u32_f64 v0, v[0:1]                           // s78 = s[sgprNumWorkGroups1] / s76
v_mul_lo_u32 v1, v0, s76                           // s78 = s[sgprNumWorkGroups1] / s76
v_sub_nc_u32 v2, s[sgprNumWorkGroups1], v1         // s78 = s[sgprNumWorkGroups1] / s76
v_cmp_ge_u32 vcc_lo, v2, s76                       // s78 = s[sgprNumWorkGroups1] / s76
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, vcc_lo                          // s78 = s[sgprNumWorkGroups1] / s76
v_add_nc_u32 v0, v0, 1                             // s78 = s[sgprNumWorkGroups1] / s76
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, -1                              // Reset exec
v_readfirstlane_b32 s78, v0                        // quotient
s_mul_i32 s79, s76, s78                            // quotient * non-magic divisor
s_sub_u32 s79, s[sgprNumWorkGroups1], s79          // NumWorkGroups1=remainder
s_cmp_eq_u32 s79, 0                                // remainder == 0 ?
s_cmov_b32 s79, s76                                // remainder = WGM if remainder == 0
s_cmp_ge_u32 s77, s78                              // blockId >= numFullBlocks ?
s_cselect_b32 s78, s79, s76
v_cvt_f64_u32 v[0:1], s78                          // s[sgprWorkGroup0] = s87 / s78
v_rcp_f64 v[0:1], v[0:1]                           // s[sgprWorkGroup0] = s87 / s78
v_cvt_f64_u32 v[2:3], s87                          // s[sgprWorkGroup0] = s87 / s78
v_mul_f64 v[0:1], v[0:1], v[2:3]                   // s[sgprWorkGroup0] = s87 / s78
v_cvt_u32_f64 v0, v[0:1]                           // s[sgprWorkGroup0] = s87 / s78
v_mul_lo_u32 v1, v0, s78                           // s[sgprWorkGroup0] = s87 / s78
v_sub_nc_u32 v2, s87, v1                           // s[sgprWorkGroup0] = s87 / s78
v_cmp_ge_u32 vcc_lo, v2, s78                       // s[sgprWorkGroup0] = s87 / s78
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, vcc_lo                          // s[sgprWorkGroup0] = s87 / s78
v_add_nc_u32 v0, v0, 1                             // s[sgprWorkGroup0] = s87 / s78
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, -1                              // Reset exec
v_mul_lo_u32 v1, v0, s78                           // s[sgprWorkGroup0] = s87 / s78
v_sub_nc_u32 v2, s87, v1                           // s[sgprWorkGroup0] = s87 / s78
v_readfirstlane_b32 s[sgprWorkGroup0], v0          // quotient
v_readfirstlane_b32 s[sgprWorkGroup1], v2          // remainder
s_mul_i32 s[sgprWorkGroup1], s[sgprWorkGroup0], s78 // quotient * non-magic divisor
s_sub_u32 s[sgprWorkGroup1], s87, s[sgprWorkGroup1] // WorkGroup1=remainder
s_mul_i32 s77, s77, s76                            // blockId * WGM
s_add_u32 s[sgprWorkGroup1], s[sgprWorkGroup1], s77 // wg1 += blockId * WGM
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
s_and_b32 s[sgprtdmAGroup1], s[sgprtdmAGroup1], 0xfffcffff // Reset data_size
s_or_b32 s[sgprtdmAGroup1], s[sgprtdmAGroup1], 0x0 // Set data_size to 0
// TDM set global addr
s_mov_b64 s[sgprtdmAGroup0+2:sgprtdmAGroup0+2+1], s[sgprAddressA:sgprAddressA+1]
s_or_b32 s[sgprtdmAGroup0+3], s[sgprtdmAGroup0+3], 0x80000000 // set type field to 2(image)
s_lshr_b32 s88, s[sgprWaveIdx], 1                  // wId=WaveIdx // 2 (each component covers 2 waves: numComp = numWaves // 2)
s_mul_i32 s88, s88, 4096                           // woffset = wId * (mt // numComp * du * bpe // dim1Divisor)
s_lshr_b32 s89, s88, 8                             // numPadBlocks = woffset >> log2(ldsBlockSizePerPad=256)
s_mul_i32 s89, s89, 16                             // padBytes = numPadBlocks * (ldsPadSize=16)
s_add_u32 s88, s88, s89                            // woffset += padBytes
s_add_u32 s88, s88, 0                              // ldsOffset = woffset + ldsConstOffset
// TDM set LDS addr
s_mov_b32 s[sgprtdmAGroup0+1], s88
s_mul_i32 s87, 64, s[sgprWorkGroup0]
s_sub_i32 s87, s[sgprSizeI], s87
s_and_b32 s[sgprtdmAGroup1], s[sgprtdmAGroup1], 0xfff7ffff // clear iterate_enable (D# Group 1 bit 19)
// TDM set padding
s_or_b32 s[sgprtdmAGroup1+0], s[sgprtdmAGroup1+0], 0x7500000 // set padding 16 per block 256
// TDM set tensor dim 0
s_and_b32 s[sgprtdmAGroup1+1], s[sgprtdmAGroup1+1], 0xffff
s_and_b32 s[sgprtdmAGroup1+2], s[sgprtdmAGroup1+2], 0xffff0000
s_lshr_b32 s88, s[sgprSizeL], 0x1
s_lshl_b32 s88, s88, 0x10
s_or_b32 s[sgprtdmAGroup1+1], s[sgprtdmAGroup1+1], s88
s_lshr_b32 s88, s[sgprSizeL], 0x1
s_lshr_b32 s88, s88, 0x10
s_or_b32 s[sgprtdmAGroup1+2], s[sgprtdmAGroup1+2], s88
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_readfirstlane_b32 s88, v[vgprSerial]             // first tId
s_lshr_b32 s88, s88, 6                             // wId=fTid // wavelen // 2
s_mul_i32 s88, s88, 32                             // woffset = wId * (mt // numComp // dim1Divisor)
s_sub_u32 s87, s87, s88                            // consider multiple waves
s_cmov_b32 s87, 0                                  // set to 0 for waves that no enough data to load
// TDM set tensor dim 1
s_and_b32 s[sgprtdmAGroup1+2], s[sgprtdmAGroup1+2], 0xffff
s_and_b32 s[sgprtdmAGroup1+3], s[sgprtdmAGroup1+3], 0xffff0000
s_lshl_b32 s89, s87, 0x10
s_or_b32 s[sgprtdmAGroup1+2], s[sgprtdmAGroup1+2], s89
s_lshr_b32 s89, s87, 0x10
s_or_b32 s[sgprtdmAGroup1+3], s[sgprtdmAGroup1+3], s89
// TDM set tensor tile 0
s_and_b32 s[sgprtdmAGroup1+3], s[sgprtdmAGroup1+3], 0xffff
s_or_b32 s[sgprtdmAGroup1+3], s[sgprtdmAGroup1+3], 0x800000 // set tile0 to 128
// TDM set tensor tile 1
s_and_b32 s[sgprtdmAGroup1+4], s[sgprtdmAGroup1+4], 0xffff0000
s_or_b32 s[sgprtdmAGroup1+4], s[sgprtdmAGroup1+4], 0x20 // set tile1 to 32
s_lshr_b32 s[sgprtdmAGroup1+5], s[sgprStrideA0I], 0x1
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
s_and_b32 s[sgprtdmBGroup1], s[sgprtdmBGroup1], 0xfffcffff // Reset data_size
s_or_b32 s[sgprtdmBGroup1], s[sgprtdmBGroup1], 0x0 // Set data_size to 0
// TDM set global addr
s_mov_b64 s[sgprtdmBGroup0+2:sgprtdmBGroup0+2+1], s[sgprAddressB:sgprAddressB+1]
s_or_b32 s[sgprtdmBGroup0+3], s[sgprtdmBGroup0+3], 0x80000000 // set type field to 2(image)
s_lshr_b32 s88, s[sgprWaveIdx], 1                  // wId=WaveIdx // 2 (each component covers 2 waves: numComp = numWaves // 2)
s_mul_i32 s88, s88, 4096                           // woffset = wId * (mt // numComp * du * bpe // dim1Divisor)
s_lshr_b32 s89, s88, 8                             // numPadBlocks = woffset >> log2(ldsBlockSizePerPad=256)
s_mul_i32 s89, s89, 16                             // padBytes = numPadBlocks * (ldsPadSize=16)
s_add_u32 s88, s88, s89                            // woffset += padBytes
s_add_u32 s88, s88, 9728                           // ldsOffset = woffset + ldsConstOffset
// TDM set LDS addr
s_mov_b32 s[sgprtdmBGroup0+1], s88
s_mul_i32 s87, 64, s[sgprWorkGroup1]
s_sub_i32 s87, s[sgprSizeJ], s87
s_and_b32 s[sgprtdmBGroup1], s[sgprtdmBGroup1], 0xfff7ffff // clear iterate_enable (D# Group 1 bit 19)
// TDM set padding
s_or_b32 s[sgprtdmBGroup1+0], s[sgprtdmBGroup1+0], 0x7500000 // set padding 16 per block 256
// TDM set tensor dim 0
s_and_b32 s[sgprtdmBGroup1+1], s[sgprtdmBGroup1+1], 0xffff
s_and_b32 s[sgprtdmBGroup1+2], s[sgprtdmBGroup1+2], 0xffff0000
s_lshr_b32 s88, s[sgprSizeL], 0x1
s_lshl_b32 s88, s88, 0x10
s_or_b32 s[sgprtdmBGroup1+1], s[sgprtdmBGroup1+1], s88
s_lshr_b32 s88, s[sgprSizeL], 0x1
s_lshr_b32 s88, s88, 0x10
s_or_b32 s[sgprtdmBGroup1+2], s[sgprtdmBGroup1+2], s88
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_readfirstlane_b32 s88, v[vgprSerial]             // first tId
s_lshr_b32 s88, s88, 6                             // wId=fTid // wavelen // 2
s_mul_i32 s88, s88, 32                             // woffset = wId * (mt // numComp // dim1Divisor)
s_sub_u32 s87, s87, s88                            // consider multiple waves
s_cmov_b32 s87, 0                                  // set to 0 for waves that no enough data to load
// TDM set tensor dim 1
s_and_b32 s[sgprtdmBGroup1+2], s[sgprtdmBGroup1+2], 0xffff
s_and_b32 s[sgprtdmBGroup1+3], s[sgprtdmBGroup1+3], 0xffff0000
s_lshl_b32 s89, s87, 0x10
s_or_b32 s[sgprtdmBGroup1+2], s[sgprtdmBGroup1+2], s89
s_lshr_b32 s89, s87, 0x10
s_or_b32 s[sgprtdmBGroup1+3], s[sgprtdmBGroup1+3], s89
// TDM set tensor tile 0
s_and_b32 s[sgprtdmBGroup1+3], s[sgprtdmBGroup1+3], 0xffff
s_or_b32 s[sgprtdmBGroup1+3], s[sgprtdmBGroup1+3], 0x800000 // set tile0 to 128
// TDM set tensor tile 1
s_and_b32 s[sgprtdmBGroup1+4], s[sgprtdmBGroup1+4], 0xffff0000
s_or_b32 s[sgprtdmBGroup1+4], s[sgprtdmBGroup1+4], 0x20 // set tile1 to 32
s_lshr_b32 s[sgprtdmBGroup1+5], s[sgprStrideB1J], 0x1
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
s_lshr_b32 s88, s[sgprWaveIdx], 1                  // wId=WaveIdx // 2 (each component covers 2 waves: numComp = numWaves // 2)
s_mul_i32 s88, s88, 256                            // woffset = wId * (mt // numComp * du * bpe // dim1Divisor)
s_add_u32 s88, s88, 8704                           // ldsOffset = woffset + ldsConstOffset
// TDM set LDS addr
s_mov_b32 s[sgprtdmMXSAGroup0+1], s88
s_mul_i32 s87, 64, s[sgprWorkGroup0]
s_sub_i32 s87, s[sgprSizeI], s87
s_and_b32 s[sgprtdmMXSAGroup1], s[sgprtdmMXSAGroup1], 0xfff7ffff // clear iterate_enable (D# Group 1 bit 19)
// TDM set tensor dim 0
s_and_b32 s[sgprtdmMXSAGroup1+1], s[sgprtdmMXSAGroup1+1], 0xffff
s_and_b32 s[sgprtdmMXSAGroup1+2], s[sgprtdmMXSAGroup1+2], 0xffff0000
s_lshl_b32 s89, s87, 0x2
s_lshl_b32 s89, s89, 0x10
s_or_b32 s[sgprtdmMXSAGroup1+1], s[sgprtdmMXSAGroup1+1], s89
s_lshl_b32 s89, s87, 0x2
s_lshr_b32 s89, s89, 0x10
s_or_b32 s[sgprtdmMXSAGroup1+2], s[sgprtdmMXSAGroup1+2], s89
// TDM set tensor dim 1
s_and_b32 s[sgprtdmMXSAGroup1+2], s[sgprtdmMXSAGroup1+2], 0xffff
s_and_b32 s[sgprtdmMXSAGroup1+3], s[sgprtdmMXSAGroup1+3], 0xffff0000
s_add_u32 s89, s[sgprSizeL], 127
s_lshr_b32 s89, s89, 0x7
s_lshl_b32 s89, s89, 0x10
s_or_b32 s[sgprtdmMXSAGroup1+2], s[sgprtdmMXSAGroup1+2], s89
s_lshr_b32 s89, s[sgprSizeL], 0x7
s_lshr_b32 s89, s89, 0x10
s_or_b32 s[sgprtdmMXSAGroup1+3], s[sgprtdmMXSAGroup1+3], s89
// TDM set tensor tile 0
s_and_b32 s[sgprtdmMXSAGroup1+3], s[sgprtdmMXSAGroup1+3], 0xffff
s_or_b32 s[sgprtdmMXSAGroup1+3], s[sgprtdmMXSAGroup1+3], 0x1000000 // set tile0 to 256
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
s_lshr_b32 s88, s[sgprWaveIdx], 1                  // wId=WaveIdx // 2 (each component covers 2 waves: numComp = numWaves // 2)
s_mul_i32 s88, s88, 256                            // woffset = wId * (mt // numComp * du * bpe // dim1Divisor)
s_add_u32 s88, s88, 9216                           // ldsOffset = woffset + ldsConstOffset
// TDM set LDS addr
s_mov_b32 s[sgprtdmMXSBGroup0+1], s88
s_mul_i32 s87, 64, s[sgprWorkGroup1]
s_sub_i32 s87, s[sgprSizeJ], s87
s_and_b32 s[sgprtdmMXSBGroup1], s[sgprtdmMXSBGroup1], 0xfff7ffff // clear iterate_enable (D# Group 1 bit 19)
// TDM set tensor dim 0
s_and_b32 s[sgprtdmMXSBGroup1+1], s[sgprtdmMXSBGroup1+1], 0xffff
s_and_b32 s[sgprtdmMXSBGroup1+2], s[sgprtdmMXSBGroup1+2], 0xffff0000
s_lshl_b32 s89, s87, 0x2
s_lshl_b32 s89, s89, 0x10
s_or_b32 s[sgprtdmMXSBGroup1+1], s[sgprtdmMXSBGroup1+1], s89
s_lshl_b32 s89, s87, 0x2
s_lshr_b32 s89, s89, 0x10
s_or_b32 s[sgprtdmMXSBGroup1+2], s[sgprtdmMXSBGroup1+2], s89
// TDM set tensor dim 1
s_and_b32 s[sgprtdmMXSBGroup1+2], s[sgprtdmMXSBGroup1+2], 0xffff
s_and_b32 s[sgprtdmMXSBGroup1+3], s[sgprtdmMXSBGroup1+3], 0xffff0000
s_add_u32 s89, s[sgprSizeL], 127
s_lshr_b32 s89, s89, 0x7
s_lshl_b32 s89, s89, 0x10
s_or_b32 s[sgprtdmMXSBGroup1+2], s[sgprtdmMXSBGroup1+2], s89
s_lshr_b32 s89, s[sgprSizeL], 0x7
s_lshr_b32 s89, s89, 0x10
s_or_b32 s[sgprtdmMXSBGroup1+3], s[sgprtdmMXSBGroup1+3], s89
// TDM set tensor tile 0
s_and_b32 s[sgprtdmMXSBGroup1+3], s[sgprtdmMXSBGroup1+3], 0xffff
s_or_b32 s[sgprtdmMXSBGroup1+3], s[sgprtdmMXSBGroup1+3], 0x1000000 // set tile0 to 256
// TDM set tensor tile 1
s_and_b32 s[sgprtdmMXSBGroup1+4], s[sgprtdmMXSBGroup1+4], 0xffff0000
s_or_b32 s[sgprtdmMXSBGroup1+4], s[sgprtdmMXSBGroup1+4], 0x1 // set tile1 to 1
s_lshl_b32 s[sgprtdmMXSBGroup1+5], s[sgprSizeJ], 0x2
label_TDMInitMXSAMXSBEnd:
label_TDMGlobalOffsetA:
s_bitcmp1_b32 s[sgprWaveIdx], 0                    // Check parity of wId
s_cbranch_scc1 label_TDMGlobalOffsetB              // Jump to B if wId is odd
// TDM wave separated calc start addr of A
s_mov_b64 s[88:89], 0
s_mul_i32 s88, s[sgprStrideA0I], 32                // tileStride * MT(64) * bpe(0.5)
s_mul_hi_u32 s89, s88, s[sgprWorkGroup0]           // *= wgId
s_mul_i32 s88, s88, s[sgprWorkGroup0]              // *= wgId
s_lshr_b32 s90, s[sgprWaveIdx], 1                  // wCompId = fTid // wavelen(32) // 2)
s_mul_i32 s90, s90, 16                             // woffset = wCompId * mt // numComp(2) * bpe(0.5) // tdmSplit(1)
s_mul_i32 s90, s90, s[sgprStrideA0I]               // woffset *= tdmSeparateStride
s_add_u32 s88, s88, s90                            // += woffset
s_addc_u32 s89, s89, 0                             // += woffset carry
s_mul_i32 s90, s[sgprGSUSumIdx], 128               // gsuOffset = GSUSumIdx * DepthU(256) * bpe(0.5)
s_add_u32 s88, s88, s90                            // += gsuOffset
s_add_u32 s[sgprtdmAGroup0+2], s[sgprtdmAGroup0+2], s88 // += tileOffset(lo)
s_addc_u32 s[sgprtdmAGroup0+3], s[sgprtdmAGroup0+3], s89 // += tileOffset(hi)
s_mul_hi_u32 s89, s[sgprStrideAK], s[sgprWorkGroup2] // Batch: Stride*WG
s_mul_i32 s88, s[sgprStrideAK], s[sgprWorkGroup2]  // Batch: Stride*WG
s_lshr_b64 s[88:89], s[88:89], 1                   // scale by bpe (multiple bpe)
s_add_u32 s[sgprtdmAGroup0+2], s[sgprtdmAGroup0+2], s88 // += batchOffset(lo)
s_addc_u32 s[sgprtdmAGroup0+3], s[sgprtdmAGroup0+3], s89 // += batchOffset(hi)
s_branch label_TDMGlobalOffsetABEnd
label_TDMGlobalOffsetB:
// TDM wave separated calc start addr of B
s_mov_b64 s[88:89], 0
s_mul_i32 s88, s[sgprStrideB1J], 32                // tileStride * MT(64) * bpe(0.5)
s_mul_hi_u32 s89, s88, s[sgprWorkGroup1]           // *= wgId
s_mul_i32 s88, s88, s[sgprWorkGroup1]              // *= wgId
s_lshr_b32 s90, s[sgprWaveIdx], 1                  // wCompId = fTid // wavelen(32) // 2)
s_mul_i32 s90, s90, 16                             // woffset = wCompId * mt // numComp(2) * bpe(0.5) // tdmSplit(1)
s_mul_i32 s90, s90, s[sgprStrideB1J]               // woffset *= tdmSeparateStride
s_add_u32 s88, s88, s90                            // += woffset
s_addc_u32 s89, s89, 0                             // += woffset carry
s_mul_i32 s90, s[sgprGSUSumIdx], 128               // gsuOffset = GSUSumIdx * DepthU(256) * bpe(0.5)
s_add_u32 s88, s88, s90                            // += gsuOffset
s_add_u32 s[sgprtdmBGroup0+2], s[sgprtdmBGroup0+2], s88 // += tileOffset(lo)
s_addc_u32 s[sgprtdmBGroup0+3], s[sgprtdmBGroup0+3], s89 // += tileOffset(hi)
s_mul_hi_u32 s89, s[sgprStrideBK], s[sgprWorkGroup2] // Batch: Stride*WG
s_mul_i32 s88, s[sgprStrideBK], s[sgprWorkGroup2]  // Batch: Stride*WG
s_lshr_b64 s[88:89], s[88:89], 1                   // scale by bpe (multiple bpe)
s_add_u32 s[sgprtdmBGroup0+2], s[sgprtdmBGroup0+2], s88 // += batchOffset(lo)
s_addc_u32 s[sgprtdmBGroup0+3], s[sgprtdmBGroup0+3], s89 // += batchOffset(hi)
label_TDMGlobalOffsetABEnd:
label_TDMGlobalOffsetMXSA:
s_bitcmp1_b32 s[sgprWaveIdx], 0                    // Check parity of wId
s_cbranch_scc1 label_TDMGlobalOffsetMXSB           // Jump to B if wId is odd
// TDM wave separated calc start addr of MXSA
s_mov_b64 s[88:89], 0
s_mul_i32 s88, s[sgprWorkGroup0], 256              // wgId * mxUnit(4) * MT(64) * bpe(1)
s_lshr_b32 s90, s[sgprWaveIdx], 1                  // wCompId = fTid // wavelen(32) // 2)
s_mul_i32 s90, s90, 4                              // woffset = wCompId * mxUnit(4) * numMxKGroups(2) // numComp(2)
s_mul_i32 s90, s90, s[sgprSizeI]                   // woffset *= SizeI
s_add_u32 s88, s88, s90                            // += woffset
s_addc_u32 s89, s89, 0                             // += woffset carry
s_mul_i32 s90, s[sgprGSUSumIdx], 8                 // gsuOffset = GSUSumIdx * DepthU(8) * bpe(1)
s_mul_i32 s90, s90, s[sgprSizeI]                   // MXS: scale GSU offset by tile size SizeI
s_add_u32 s88, s88, s90                            // += gsuOffset
s_add_u32 s[sgprtdmMXSAGroup0+2], s[sgprtdmMXSAGroup0+2], s88 // += tileOffset(lo)
s_addc_u32 s[sgprtdmMXSAGroup0+3], s[sgprtdmMXSAGroup0+3], s89 // += tileOffset(hi)
s_mul_hi_u32 s89, s[sgprStrideMXSAK], s[sgprWorkGroup2] // Batch: Stride*WG
s_mul_i32 s88, s[sgprStrideMXSAK], s[sgprWorkGroup2] // Batch: Stride*WG
                                                   // scale by bpe (bpe is 1, do nothing)
s_add_u32 s[sgprtdmMXSAGroup0+2], s[sgprtdmMXSAGroup0+2], s88 // += batchOffset(lo)
s_addc_u32 s[sgprtdmMXSAGroup0+3], s[sgprtdmMXSAGroup0+3], s89 // += batchOffset(hi)
s_branch label_TDMGlobalOffsetMXSAMXSBEnd
label_TDMGlobalOffsetMXSB:
// TDM wave separated calc start addr of MXSB
s_mov_b64 s[88:89], 0
s_mul_i32 s88, s[sgprWorkGroup1], 256              // wgId * mxUnit(4) * MT(64) * bpe(1)
s_lshr_b32 s90, s[sgprWaveIdx], 1                  // wCompId = fTid // wavelen(32) // 2)
s_mul_i32 s90, s90, 4                              // woffset = wCompId * mxUnit(4) * numMxKGroups(2) // numComp(2)
s_mul_i32 s90, s90, s[sgprSizeJ]                   // woffset *= SizeJ
s_add_u32 s88, s88, s90                            // += woffset
s_addc_u32 s89, s89, 0                             // += woffset carry
s_mul_i32 s90, s[sgprGSUSumIdx], 8                 // gsuOffset = GSUSumIdx * DepthU(8) * bpe(1)
s_mul_i32 s90, s90, s[sgprSizeJ]                   // MXS: scale GSU offset by tile size SizeJ
s_add_u32 s88, s88, s90                            // += gsuOffset
s_add_u32 s[sgprtdmMXSBGroup0+2], s[sgprtdmMXSBGroup0+2], s88 // += tileOffset(lo)
s_addc_u32 s[sgprtdmMXSBGroup0+3], s[sgprtdmMXSBGroup0+3], s89 // += tileOffset(hi)
s_mul_hi_u32 s89, s[sgprStrideMXSBK], s[sgprWorkGroup2] // Batch: Stride*WG
s_mul_i32 s88, s[sgprStrideMXSBK], s[sgprWorkGroup2] // Batch: Stride*WG
                                                   // scale by bpe (bpe is 1, do nothing)
s_add_u32 s[sgprtdmMXSBGroup0+2], s[sgprtdmMXSBGroup0+2], s88 // += batchOffset(lo)
s_addc_u32 s[sgprtdmMXSBGroup0+3], s[sgprtdmMXSBGroup0+3], s89 // += batchOffset(hi)
label_TDMGlobalOffsetMXSAMXSBEnd:

/* global read addresses: tile offsets mxsa */

/* global read addresses: tile offsets mxsb */

/* global read addresses: unroll offsets mxsa */

/* global read addresses: unroll offsets mxsb */

/* global read addresses: increments a */
s_and_b32 s89, s[sgprGSU], 0x3fff                  // Restore GSU
s_mov_b32 s[sgprGlobalReadIncsA+0], 128            // GSU*DepthU*Bpe*MI_dim(1)
s_mul_i32 s89, s89, s[sgprGlobalReadIncsA+0]       // GSU*DepthU*Bpe*MI_dim(1)
s_and_b32 s88, s[sgprGSU], 0x8000                  // SCC = (GSUC == 1) ?
s_cselect_b32 s[sgprGlobalReadIncsA+0], s[sgprGlobalReadIncsA+0], s89 // incrA (unrollIdx)

/* global read addresses: increments mxsa */
s_and_b32 s89, s[sgprGSU], 0x3fff                  // Restore GSU
s_mul_i32 s[sgprGlobalReadIncsMXSA+0], s[sgprSizeI], 8 // GSU*DepthU*Bpe*MI_dim(1) (swizzled MX scale layout)
s_mul_i32 s89, s89, s[sgprGlobalReadIncsMXSA+0]    // GSU*DepthU*Bpe*MI_dim(1)
s_and_b32 s88, s[sgprGSU], 0x8000                  // SCC = (GSUC == 1) ?
s_cselect_b32 s[sgprGlobalReadIncsMXSA+0], s[sgprGlobalReadIncsMXSA+0], s89 // incrMXSA (unrollIdx)

/* global read addresses: increments mxsb */
s_and_b32 s89, s[sgprGSU], 0x3fff                  // Restore GSU
s_mul_i32 s[sgprGlobalReadIncsMXSB+0], s[sgprSizeJ], 8 // GSU*DepthU*Bpe*MI_dim(1) (swizzled MX scale layout)
s_mul_i32 s89, s89, s[sgprGlobalReadIncsMXSB+0]    // GSU*DepthU*Bpe*MI_dim(1)
s_and_b32 s88, s[sgprGSU], 0x8000                  // SCC = (GSUC == 1) ?
s_cselect_b32 s[sgprGlobalReadIncsMXSB+0], s[sgprGlobalReadIncsMXSB+0], s89 // incrMXSB (unrollIdx)

/* global read addresses: increments b */
s_and_b32 s89, s[sgprGSU], 0x3fff                  // Restore GSU
s_mov_b32 s[sgprGlobalReadIncsB+0], 128            // GSU*DepthU*Bpe*MI_dim(1)
s_mul_i32 s89, s89, s[sgprGlobalReadIncsB+0]       // GSU*DepthU*Bpe*MI_dim(1)
s_and_b32 s88, s[sgprGSU], 0x8000                  // SCC = (GSUC == 1) ?
s_cselect_b32 s[sgprGlobalReadIncsB+0], s[sgprGlobalReadIncsB+0], s89 // incrB (unrollIdx)
s_bitcmp1_b32 s[sgprWaveIdx], 0                    // Check parity of wId
s_cselect_b32 s[sgprtdmABIncs], s[sgprGlobalReadIncsB+0], s[sgprGlobalReadIncsA+0]
s_bitcmp1_b32 s[sgprWaveIdx], 0                    // Check parity of wId
s_cselect_b32 s[sgprtdmMXSAMXSBIncs], s[sgprGlobalReadIncsMXSB+0], s[sgprGlobalReadIncsMXSA+0]
/* declare loop num iterations */
s_lshr_b32 s[sgprLoopCounterL], s[sgprSizesSum+0], 8 // s[sgprLoopCounterL] = s[sgprSizesSum+0] / 256
s_and_b32 s88, s[sgprGSU], 0x3fff                  // Restore GSU
s_cmp_eq_u32 s88, 1                                // GSU == 1 ?
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
s_add_u32 s88, 1, s[sgprLoopCounterL]              // tmp<-numIterMyWg+1
s_cmp_lt_u32 s[sgprGSUSumIdx], s[sgprGSUSumIdx+1]  // gsuSumIdx < numIterPerWgRemainder
s_cmov_b32 s[sgprLoopCounterL], s88                // numIterMyWg++ if needed
label_GSU_1:
s_mov_b32 s[sgprOrigLoopCounter], s[sgprLoopCounterL] // copy loop counter
s_cmp_le_u32 s[sgprLoopCounterL], 0x2              // LoopCounterL < EndCounter
s_cbranch_scc0 label_skipInitCVmov                 // skip v_mov initC (WMMA initC will run in main loop)

/* initC: remove ValuMXSA/B vgpr buffer [0...8) from pool */

/* initC: remove ValuC vgpr buffer [8...40) from pool */

/* initC: remove acc vgpr buffer [0...0) from pool */

/* initC: remove ValuA/B vgpr buffer [44...110) from pool */
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
label_skipInitCVmov:
s_and_b32 s90, s[sgprStaggerU], 0x1f00
s_lshr_b32 s90, s90, 0x8
s_and_b32 s91, s[sgprStaggerU], 0xe000
s_and_b32 s[sgprStaggerU], s[sgprStaggerU], 0xff
s_mov_b32 s88, s[sgprStaggerU]                     // init staggerU
label_beginStaggerUIter:
s_lshl_b32 s89, s88, s90                           // shift by StaggerUStride
s_cmp_ge_u32 s[sgprOrigLoopCounter], s89           // loopCount >= current shift Count
s_cbranch_scc1 label_endStaggerUIter               // jump to end
s_lshr_b32 s88, s88, 1                             // step down to smaller stagger
s_branch label_beginStaggerUIter                   // jump to begin
label_endStaggerUIter:
s_sub_u32 s89, s88, 1                              // staggerU mask
s_cmp_ge_u32 s88, 1                                // if current staggerU >= 1
s_cselect_b32 s[sgprStaggerUIter], s89, 0          // set Mask
s_cmp_eq_u32 s91, 0x0
s_cbranch_scc0 label_StaggerUMapping
s_mov_b32 s88, s[sgprWorkGroup0]
s_branch label_staggerInputEnd
label_StaggerUMapping:
s_cmp_eq_u32 s91, 0x2000
s_cbranch_scc0 label_StaggerUMapping_1
s_mov_b32 s88, s[sgprWorkGroup1]
s_branch label_staggerInputEnd
label_StaggerUMapping_1:
s_cmp_eq_u32 s91, 0x4000
s_cbranch_scc0 label_StaggerUMapping_2
s_mov_b32 s88, -0x1
s_branch label_staggerInputEnd
label_StaggerUMapping_2:
s_cmp_eq_u32 s91, 0x6000
s_cbranch_scc0 label_StaggerUMapping_3
s_mul_i32 s89, s[sgprNumWorkGroups0], s[sgprWorkGroup1]
s_add_u32 s88, s88, s89
s_add_u32 s88, s88, s[sgprWorkGroup0]
s_branch label_staggerInputEnd
label_StaggerUMapping_3:
s_cmp_eq_u32 s91, 0x8000
s_cbranch_scc0 label_staggerInputEnd
s_mov_b32 s88, -0x1
s_branch label_staggerInputEnd
label_staggerInputEnd:
s_and_b32 s[sgprStaggerUIter], s[sgprStaggerUIter], s88 // Compute actual stagger start for this tile
s_lshl_b32 s[sgprStaggerUIter], s[sgprStaggerUIter], s90 // shift by StaggerUStride

/* addr += (StaggerUIter) * GlobalReadIncsA+0 */
s_mul_hi_i32 s89, s[sgprStaggerUIter], s[sgprGlobalReadIncsA+0] //  stagger byte offset
s_mul_i32 s88, s[sgprStaggerUIter], s[sgprGlobalReadIncsA+0] //  stagger byte offset
s_bitcmp1_b32 s[sgprWaveIdx], 0                    // check wave parity
s_cbranch_scc1 label_SkipStaggerA                  // skip: odd waves handle B
s_add_u32 s[sgprtdmAGroup0+2], s[sgprtdmAGroup0+2], s88 // TDM addr += stagger offset (lo)
s_addc_u32 s[sgprtdmAGroup0+3], s[sgprtdmAGroup0+3], s89 // TDM addr += stagger offset (hi)
label_SkipStaggerA:
s_mul_hi_i32 s[sgprWrapUA+1], s[sgprLoopCounterL], s[sgprGlobalReadIncsA+0] // Number of bytes accessed by the unroll loop
s_mul_i32 s[sgprWrapUA+0], s[sgprLoopCounterL], s[sgprGlobalReadIncsA+0] // Number of bytes accessed by the unroll loop
s_mov_b32 s92, s[sgprGlobalReadIncsA+0]
s_mov_b32 s93, 0
s_sub_u64 s[sgprWrapUA:sgprWrapUA+1], s[92:93], s[sgprWrapUA:sgprWrapUA+1] // increment-WrapU

/* addr += (StaggerUIter) * GlobalReadIncsMXSA+0 */
s_mul_hi_i32 s89, s[sgprStaggerUIter], s[sgprGlobalReadIncsMXSA+0] //  stagger byte offset
s_mul_i32 s88, s[sgprStaggerUIter], s[sgprGlobalReadIncsMXSA+0] //  stagger byte offset
s_bitcmp1_b32 s[sgprWaveIdx], 0                    // check wave parity
s_cbranch_scc1 label_SkipStaggerMXSA               // skip: odd waves handle B
s_add_u32 s[sgprtdmMXSAGroup0+2], s[sgprtdmMXSAGroup0+2], s88 // TDM addr += stagger offset (lo)
s_addc_u32 s[sgprtdmMXSAGroup0+3], s[sgprtdmMXSAGroup0+3], s89 // TDM addr += stagger offset (hi)
label_SkipStaggerMXSA:
s_mul_hi_i32 s[sgprWrapUMXSA+1], s[sgprLoopCounterL], s[sgprGlobalReadIncsMXSA+0] // Number of bytes accessed by the unroll loop
s_mul_i32 s[sgprWrapUMXSA+0], s[sgprLoopCounterL], s[sgprGlobalReadIncsMXSA+0] // Number of bytes accessed by the unroll loop
s_mov_b32 s92, s[sgprGlobalReadIncsMXSA+0]
s_mov_b32 s93, 0
s_sub_u64 s[sgprWrapUMXSA:sgprWrapUMXSA+1], s[92:93], s[sgprWrapUMXSA:sgprWrapUMXSA+1] // increment-WrapU

/* addr += (StaggerUIter) * GlobalReadIncsMXSB+0 */
s_mul_hi_i32 s89, s[sgprStaggerUIter], s[sgprGlobalReadIncsMXSB+0] //  stagger byte offset
s_mul_i32 s88, s[sgprStaggerUIter], s[sgprGlobalReadIncsMXSB+0] //  stagger byte offset
s_bitcmp1_b32 s[sgprWaveIdx], 0                    // check wave parity
s_cbranch_scc0 label_SkipStaggerMXSB               // skip: even waves handle A
s_add_u32 s[sgprtdmMXSBGroup0+2], s[sgprtdmMXSBGroup0+2], s88 // TDM addr += stagger offset (lo)
s_addc_u32 s[sgprtdmMXSBGroup0+3], s[sgprtdmMXSBGroup0+3], s89 // TDM addr += stagger offset (hi)
label_SkipStaggerMXSB:
s_mul_hi_i32 s[sgprWrapUMXSB+1], s[sgprLoopCounterL], s[sgprGlobalReadIncsMXSB+0] // Number of bytes accessed by the unroll loop
s_mul_i32 s[sgprWrapUMXSB+0], s[sgprLoopCounterL], s[sgprGlobalReadIncsMXSB+0] // Number of bytes accessed by the unroll loop
s_mov_b32 s92, s[sgprGlobalReadIncsMXSB+0]
s_mov_b32 s93, 0
s_sub_u64 s[sgprWrapUMXSB:sgprWrapUMXSB+1], s[92:93], s[sgprWrapUMXSB:sgprWrapUMXSB+1] // increment-WrapU

/* addr += (StaggerUIter) * GlobalReadIncsB+0 */
s_mul_hi_i32 s89, s[sgprStaggerUIter], s[sgprGlobalReadIncsB+0] //  stagger byte offset
s_mul_i32 s88, s[sgprStaggerUIter], s[sgprGlobalReadIncsB+0] //  stagger byte offset
s_bitcmp1_b32 s[sgprWaveIdx], 0                    // check wave parity
s_cbranch_scc0 label_SkipStaggerB                  // skip: even waves handle A
s_add_u32 s[sgprtdmBGroup0+2], s[sgprtdmBGroup0+2], s88 // TDM addr += stagger offset (lo)
s_addc_u32 s[sgprtdmBGroup0+3], s[sgprtdmBGroup0+3], s89 // TDM addr += stagger offset (hi)
label_SkipStaggerB:
s_mul_hi_i32 s[sgprWrapUB+1], s[sgprLoopCounterL], s[sgprGlobalReadIncsB+0] // Number of bytes accessed by the unroll loop
s_mul_i32 s[sgprWrapUB+0], s[sgprLoopCounterL], s[sgprGlobalReadIncsB+0] // Number of bytes accessed by the unroll loop
s_mov_b32 s92, s[sgprGlobalReadIncsB+0]
s_mov_b32 s93, 0
s_sub_u64 s[sgprWrapUB:sgprWrapUB+1], s[92:93], s[sgprWrapUB:sgprWrapUB+1] // increment-WrapU
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
s_cbranch_scc0 label_NoBranch_T8JHFHKM7BO5OHXW     // Only branch on scc1
s_getpc_b64 s[88:89]                               // addr of next instr
s_add_i32 s90, label_PrefetchGlobalLastIterEnd, 4  // target branch offset
s_add_u32 s88, s88, s90                            // add target branch offset
s_addc_u32 s89, s89, 0                             // add high and carry
s_setpc_b64 s[88:89]                               // branch to label_PrefetchGlobalLastIterEnd
label_NoBranch_T8JHFHKM7BO5OHXW:
tensor_load_to_lds s[sgprtdmAGroup0:sgprtdmAGroup0+3], s[sgprtdmAGroup1:sgprtdmAGroup1+7] // sync LDS0
tensor_load_to_lds s[sgprtdmMXSAGroup0:sgprtdmMXSAGroup0+3], s[sgprtdmMXSAGroup1:sgprtdmMXSAGroup1+7] // sync LDS0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_readfirstlane_b32 s5, v[vgprSerial]              // get tId
s_lshr_b32 s5, s5, 5                               // waveId
s_bitcmp1_b32 s5, 0                                // check wave parity
s_cselect_b32 s90, s[sgprWrapUB+0], s[sgprWrapUA+0] // select WrapU based on wave parity (lo)
s_cselect_b32 s91, s[sgprWrapUB+1], s[sgprWrapUA+1] // select WrapU based on wave parity (hi)
s_add_u32 s88, s[sgprLoopCounterL], 1              // remove pf(1)
s_cmp_eq_u32 s[sgprStaggerUIter], s88              // Is this wrapIter? (pf)
s_cselect_b32 s88, s90, s[sgprtdmABIncs]           // select WrapU or normal inc (lo)
s_cselect_b32 s89, s91, 0                          // select WrapU or normal inc (hi)
s_add_u64 s[sgprtdmAGroup0+2:sgprtdmAGroup0+2+1], s[sgprtdmAGroup0+2:sgprtdmAGroup0+2+1], s[88:89] // TDM addr += inc (with wrap, 64-bit)
v_readfirstlane_b32 s5, v[vgprSerial]              // get tId
s_lshr_b32 s5, s5, 5                               // waveId
s_bitcmp1_b32 s5, 0                                // check wave parity
s_cselect_b32 s90, s[sgprWrapUMXSB+0], s[sgprWrapUMXSA+0] // select WrapU based on wave parity (lo)
s_cselect_b32 s91, s[sgprWrapUMXSB+1], s[sgprWrapUMXSA+1] // select WrapU based on wave parity (hi)
s_add_u32 s88, s[sgprLoopCounterL], 1              // remove pf(1)
s_cmp_eq_u32 s[sgprStaggerUIter], s88              // Is this wrapIter? (pf)
s_cselect_b32 s88, s90, s[sgprtdmMXSAMXSBIncs]     // select WrapU or normal inc (lo)
s_cselect_b32 s89, s91, 0                          // select WrapU or normal inc (hi)
s_add_u64 s[sgprtdmMXSAGroup0+2:sgprtdmMXSAGroup0+2+1], s[sgprtdmMXSAGroup0+2:sgprtdmMXSAGroup0+2+1], s[88:89] // TDM addr += inc (with wrap, 64-bit)

/******************************************/
/* End setupNewTile                       */
/******************************************/
s_wait_loadcnt 0
s_wait_tensorcnt 0                                 // wait for global read

/* TDM swap lds a */
// TDM LDS swap(aligned pow2: True)
s_xor_b32 s[sgprtdmAGroup0+1], s[sgprtdmAGroup0+1], 0x8000

/* local write swap mxsa */
// TDM LDS swap(aligned pow2: True)
s_xor_b32 s[sgprtdmMXSAGroup0+1], s[sgprtdmMXSAGroup0+1], 0x8000

/* local write swap mxsb */
s_cmp_eq_u32 s[sgprLoopCounterL], 0x1              // PGR=2 but only 1 loop
s_cbranch_scc1 label_skipPGR2_1                    // PGR=2 but only 1 loop
tensor_load_to_lds s[sgprtdmAGroup0:sgprtdmAGroup0+3], s[sgprtdmAGroup1:sgprtdmAGroup1+7] // sync LDS1
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

/* local read prefetch mxsa */
ds_load_b32 v[vgprValuMXSA_X0_I0+0], v[vgprLocalReadAddrMXSA+0] offset:0 // L -> Reg for MX sync LDS0

/* local read prefetch mxsb */
ds_load_b64 v[vgprValuMXSB_X0_I0+0:vgprValuMXSB_X0_I0+0+1], v[vgprLocalReadAddrMXSB+0] offset:0 // L -> Reg for MX sync LDS0

/* local read prefetch b */
ds_load_b128 v[vgprValuB_X0_I0+0:vgprValuB_X0_I0+0+3], v[vgprLocalReadAddrB+0] offset:0 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_b128 v[vgprValuB_X0_I0+4:vgprValuB_X0_I0+4+3], v[vgprLocalReadAddrB+0] offset:32 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_b128 v[vgprValuB_X0_I0+8:vgprValuB_X0_I0+8+3], v[vgprLocalReadAddrB+0] offset:128 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=1 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_b128 v[vgprValuB_X0_I0+12:vgprValuB_X0_I0+12+3], v[vgprLocalReadAddrB+0] offset:160 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=1 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS0

/* local read inc a */
/* N/A, lro->128 */
/* localReadDoCntA 1 localReadDoCntMXSA 1 localReadDoCntB 1 localReadDoCntMXSB 1 localReadDoCntM 0 */

/* local read inc mxsa */
/* N/A, lro->256 */
/* localReadDoCntA 1 localReadDoCntMXSA 1 localReadDoCntB 1 localReadDoCntMXSB 1 localReadDoCntM 0 */

/* local read inc mxsb */
/* N/A, lro->256 */
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
s_wait_alu depctr_va_vdst(6)
ds_load_b32 v[vgprValuMXSA_X1_I0+0], v[vgprLocalReadAddrMXSA+0] offset:256 // L -> Reg for MX sync LDS0
ds_load_b64 v[vgprValuMXSB_X1_I0+0:vgprValuMXSB_X1_I0+0+1], v[vgprLocalReadAddrMXSB+0] offset:256 // L -> Reg for MX sync LDS0
ds_load_b128 v[vgprValuB_X1_I0+0:vgprValuB_X1_I0+0+3], v[vgprLocalReadAddrB+0] offset:64 // L -> Reg lro=128 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=0 oIdx=0 buffer=1 iui=0 sync LDS0
ds_load_b128 v[vgprValuB_X1_I0+4:vgprValuB_X1_I0+4+3], v[vgprLocalReadAddrB+0] offset:96 // L -> Reg lro=128 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=1 oIdx=0 buffer=1 iui=0 sync LDS0
ds_load_b128 v[vgprValuB_X1_I0+8:vgprValuB_X1_I0+8+3], v[vgprLocalReadAddrB+0] offset:192 // L -> Reg lro=128 swapByteOffset=0 ti=64 vIdx=0 eIdx=1 rIdx=0 oIdx=0 buffer=1 iui=0 sync LDS0
ds_load_b128 v[vgprValuB_X1_I0+12:vgprValuB_X1_I0+12+3], v[vgprLocalReadAddrB+0] offset:224 // L -> Reg lro=128 swapByteOffset=0 ti=64 vIdx=0 eIdx=1 rIdx=1 oIdx=0 buffer=1 iui=0 sync LDS0
s_wait_dscnt 0                                     // wait for local read before cross-wave TDM swap sync
s_barrier_signal -1
s_barrier_wait -1                                  // Waiting current LR finish for next GR(TDM), sync
s_xor_b32 s[sgprtdmAGroup0+1], s[sgprtdmAGroup0+1], 0x8000
s_xor_b32 s[sgprtdmMXSAGroup0+1], s[sgprtdmMXSAGroup0+1], 0x8000
s_wait_alu depctr_vm_vsrc(6)
v_xor_b32 v[vgprLocalReadAddrA], 0x8000, v[vgprLocalReadAddrA] // swap Red Blk
s_wait_alu depctr_vm_vsrc(5)
v_xor_b32 v[vgprLocalReadAddrMXSA], 0x8000, v[vgprLocalReadAddrMXSA] // swap Red Blk
s_wait_alu depctr_vm_vsrc(4)
v_xor_b32 v[vgprLocalReadAddrMXSB], 0x8000, v[vgprLocalReadAddrMXSB] // swap Red Blk
s_wait_alu depctr_vm_vsrc(0)
v_xor_b32 v[vgprLocalReadAddrB], 0x8000, v[vgprLocalReadAddrB] // swap Red Blk
v_readfirstlane_b32 s5, v[vgprSerial]              // get tId
s_lshr_b32 s5, s5, 5                               // waveId
s_bitcmp1_b32 s5, 0                                // check wave parity
s_cselect_b32 s90, s[sgprWrapUB+0], s[sgprWrapUA+0] // select WrapU based on wave parity (lo)
s_cselect_b32 s91, s[sgprWrapUB+1], s[sgprWrapUA+1] // select WrapU based on wave parity (hi)
s_cmp_eq_u32 s[sgprLoopCounterL], s[sgprStaggerUIter] // Is this the wrapIter?
s_cselect_b32 s88, s90, s[sgprtdmABIncs]           // select WrapU or normal inc (lo)
s_cselect_b32 s89, s91, 0                          // select WrapU or normal inc (hi)
s_add_u64 s[sgprtdmAGroup0+2:sgprtdmAGroup0+2+1], s[sgprtdmAGroup0+2:sgprtdmAGroup0+2+1], s[88:89] // TDM addr += inc (with wrap, 64-bit)
v_readfirstlane_b32 s5, v[vgprSerial]              // get tId
s_lshr_b32 s5, s5, 5                               // waveId
s_bitcmp1_b32 s5, 0                                // check wave parity
s_cselect_b32 s90, s[sgprWrapUMXSB+0], s[sgprWrapUMXSA+0] // select WrapU based on wave parity (lo)
s_cselect_b32 s91, s[sgprWrapUMXSB+1], s[sgprWrapUMXSA+1] // select WrapU based on wave parity (hi)
s_cmp_eq_u32 s[sgprLoopCounterL], s[sgprStaggerUIter] // Is this the wrapIter?
s_cselect_b32 s88, s90, s[sgprtdmMXSAMXSBIncs]     // select WrapU or normal inc (lo)
s_cselect_b32 s89, s91, 0                          // select WrapU or normal inc (hi)
s_add_u64 s[sgprtdmMXSAGroup0+2:sgprtdmMXSAGroup0+2+1], s[sgprtdmMXSAGroup0+2:sgprtdmMXSAGroup0+2+1], s[88:89] // TDM addr += inc (with wrap, 64-bit)
s_wait_dscnt 10                                    // wait for prior local read local write old=0, new=10 newLW=0 newLR=10 for iteration == 0
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+0:vgprValuC+0+7], v[vgprValuB_X0_I0+0+0+0:vgprValuB_X0_I0+0+0+0+7], v[vgprValuA_X0_I0+0+0+0:vgprValuA_X0_I0+0+0+0+7], 0, v[vgprValuMXSB_X0_I0+0+0+0], v[vgprValuMXSA_X0_I0+0+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_a_reuse // left value = v[0+0:7+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+8:vgprValuC+8+7], v[vgprValuB_X0_I0+0+0+0:vgprValuB_X0_I0+0+0+0+7], v[vgprValuA_X0_I0+8+0+0:vgprValuA_X0_I0+8+0+0+7], 0, v[vgprValuMXSB_X0_I0+0+0+0], v[vgprValuMXSA_X0_I0+0+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_b_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 // left value = v[8+0:15+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+16:vgprValuC+16+7], v[vgprValuB_X0_I0+8+0+0:vgprValuB_X0_I0+8+0+0+7], v[vgprValuA_X0_I0+0+0+0:vgprValuA_X0_I0+0+0+0+7], 0, v[vgprValuMXSB_X0_I0+1+0+0], v[vgprValuMXSA_X0_I0+0+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_a_reuse // left value = v[16+0:23+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+24:vgprValuC+24+7], v[vgprValuB_X0_I0+8+0+0:vgprValuB_X0_I0+8+0+0+7], v[vgprValuA_X0_I0+8+0+0:vgprValuA_X0_I0+8+0+0+7], 0, v[vgprValuMXSB_X0_I0+1+0+0], v[vgprValuMXSA_X0_I0+0+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_b_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 // left value = v[24+0:31+0]
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

/* local read maxa */
ds_load_b32 v[vgprValuMXSA_X1_I0+0], v[vgprLocalReadAddrMXSA+0] offset:256 // L -> Reg for MX sync LDS0 <This is 23-cycle>

/* local read mxsb */
ds_load_b64 v[vgprValuMXSB_X1_I0+0:vgprValuMXSB_X1_I0+0+1], v[vgprLocalReadAddrMXSB+0] offset:256 // L -> Reg for MX sync LDS0 <This is 25-cycle>

/* local read b */
ds_load_b128 v[vgprValuB_X1_I0+0:vgprValuB_X1_I0+0+3], v[vgprLocalReadAddrB+0] offset:64 // L -> Reg lro=128 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=0 oIdx=0 buffer=1 iui=0 sync LDS0 <This is 27-cycle>
ds_load_b128 v[vgprValuB_X1_I0+4:vgprValuB_X1_I0+4+3], v[vgprLocalReadAddrB+0] offset:96 // L -> Reg lro=128 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=1 oIdx=0 buffer=1 iui=0 sync LDS0 <This is 29-cycle>
ds_load_b128 v[vgprValuB_X1_I0+8:vgprValuB_X1_I0+8+3], v[vgprLocalReadAddrB+0] offset:192 // L -> Reg lro=128 swapByteOffset=0 ti=64 vIdx=0 eIdx=1 rIdx=0 oIdx=0 buffer=1 iui=0 sync LDS0 <This is 31-cycle>
ds_load_b128 v[vgprValuB_X1_I0+12:vgprValuB_X1_I0+12+3], v[vgprLocalReadAddrB+0] offset:224 // L -> Reg lro=128 swapByteOffset=0 ti=64 vIdx=0 eIdx=1 rIdx=1 oIdx=0 buffer=1 iui=0 sync LDS0 <This is 33-cycle>
s_wait_dscnt 0                                     // wait for local read before cross-wave TDM swap sync <This is 34-cycle>
// Skip force waitcnt0
s_barrier_signal -1                                // <This is 35-cycle>
s_barrier_wait -1                                  // Waiting current LR finish for next GR(TDM), sync <This is 45-cycle>

/* tdm swap offsets a */
// TDM LDS swap(aligned pow2: True)
s_xor_b32 s[sgprtdmAGroup0+1], s[sgprtdmAGroup0+1], 0x8000 // <This is 46-cycle>

/* local write swap offsets mxsa */
// TDM LDS swap(aligned pow2: True)
s_xor_b32 s[sgprtdmMXSAGroup0+1], s[sgprtdmMXSAGroup0+1], 0x8000 // <This is 47-cycle>

/* local read swap offsets a */
s_wait_alu depctr_vm_vsrc(6)                       // <This is 48-cycle>
v_xor_b32 v[vgprLocalReadAddrA], 0x8000, v[vgprLocalReadAddrA] // swap Red Blk <This is 49-cycle>

/* local read swap offsets mxsa */
s_wait_alu depctr_vm_vsrc(5)                       // <This is 50-cycle>
v_xor_b32 v[vgprLocalReadAddrMXSA], 0x8000, v[vgprLocalReadAddrMXSA] // swap Red Blk <This is 51-cycle>

/* local read swap offsets mxsb */
s_wait_alu depctr_vm_vsrc(4)                       // <This is 52-cycle>
v_xor_b32 v[vgprLocalReadAddrMXSB], 0x8000, v[vgprLocalReadAddrMXSB] // swap Red Blk <This is 53-cycle>

/* local read swap offsets b */
s_wait_alu depctr_vm_vsrc(0)                       // <This is 54-cycle>
v_xor_b32 v[vgprLocalReadAddrB], 0x8000, v[vgprLocalReadAddrB] // swap Red Blk <This is 55-cycle>

/* local read init pointers a */

/* localReadInitPointers */

/* local read init pointers mxsa */

/* localReadInitPointers */

/* local read init pointers mxsb */

/* localReadInitPointers */

/* local read init pointers b */

/* localReadInitPointers */

/* Global Read IncA */
v_readfirstlane_b32 s5, v[vgprSerial]              // get tId <This is 56-cycle>
s_lshr_b32 s5, s5, 5                               // waveId <This is 57-cycle>
s_bitcmp1_b32 s5, 0                                // check wave parity <This is 58-cycle>
s_cselect_b32 s90, s[sgprWrapUB+0], s[sgprWrapUA+0] // select WrapU based on wave parity (lo) <This is 59-cycle>
s_cselect_b32 s91, s[sgprWrapUB+1], s[sgprWrapUA+1] // select WrapU based on wave parity (hi) <This is 60-cycle>
s_cmp_eq_u32 s[sgprLoopCounterL], s[sgprStaggerUIter] // Is this the wrapIter? <This is 61-cycle>
s_cselect_b32 s88, s90, s[sgprtdmABIncs]           // select WrapU or normal inc (lo) <This is 62-cycle>
s_cselect_b32 s89, s91, 0                          // select WrapU or normal inc (hi) <This is 63-cycle>
s_add_u64 s[sgprtdmAGroup0+2:sgprtdmAGroup0+2+1], s[sgprtdmAGroup0+2:sgprtdmAGroup0+2+1], s[88:89] // TDM addr += inc (with wrap, 64-bit) <This is 64-cycle>

/* Global Read IncB */
v_readfirstlane_b32 s5, v[vgprSerial]              // get tId <This is 65-cycle>
s_lshr_b32 s5, s5, 5                               // waveId <This is 66-cycle>
s_bitcmp1_b32 s5, 0                                // check wave parity <This is 67-cycle>
s_cselect_b32 s90, s[sgprWrapUMXSB+0], s[sgprWrapUMXSA+0] // select WrapU based on wave parity (lo) <This is 68-cycle>
s_cselect_b32 s91, s[sgprWrapUMXSB+1], s[sgprWrapUMXSA+1] // select WrapU based on wave parity (hi) <This is 69-cycle>
s_cmp_eq_u32 s[sgprLoopCounterL], s[sgprStaggerUIter] // Is this the wrapIter? <This is 70-cycle>
s_cselect_b32 s88, s90, s[sgprtdmMXSAMXSBIncs]     // select WrapU or normal inc (lo) <This is 71-cycle>
s_cselect_b32 s89, s91, 0                          // select WrapU or normal inc (hi) <This is 72-cycle>
s_add_u64 s[sgprtdmMXSAGroup0+2:sgprtdmMXSAGroup0+2+1], s[sgprtdmMXSAGroup0+2:sgprtdmMXSAGroup0+2+1], s[88:89] // TDM addr += inc (with wrap, 64-bit) <This is 73-cycle>

/* Global Read A */

/* Global Read MXSA */

/* Global Read MXSB */

/* Global Read B */
s_wait_dscnt 10                                    // wait for prior local read local write old=0, new=10 newLW=0 newLR=10 for iteration == 0 <This is 74-cycle>
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+0:vgprValuC+0+7], v[vgprValuB_X0_I0+0+0+0:vgprValuB_X0_I0+0+0+0+7], v[vgprValuA_X0_I0+0+0+0:vgprValuA_X0_I0+0+0+0+7], v[vgprValuC+0:vgprValuC+0+7], v[vgprValuMXSB_X0_I0+0+0+0], v[vgprValuMXSA_X0_I0+0+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_a_reuse // left value = v[0+0:7+0] <This is 75-cycle>
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+8:vgprValuC+8+7], v[vgprValuB_X0_I0+0+0+0:vgprValuB_X0_I0+0+0+0+7], v[vgprValuA_X0_I0+8+0+0:vgprValuA_X0_I0+8+0+0+7], v[vgprValuC+8:vgprValuC+8+7], v[vgprValuMXSB_X0_I0+0+0+0], v[vgprValuMXSA_X0_I0+0+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_b_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 // left value = v[8+0:15+0] <This is 83-cycle>
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+16:vgprValuC+16+7], v[vgprValuB_X0_I0+8+0+0:vgprValuB_X0_I0+8+0+0+7], v[vgprValuA_X0_I0+0+0+0:vgprValuA_X0_I0+0+0+0+7], v[vgprValuC+16:vgprValuC+16+7], v[vgprValuMXSB_X0_I0+1+0+0], v[vgprValuMXSA_X0_I0+0+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_a_reuse // left value = v[16+0:23+0] <This is 91-cycle>
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+24:vgprValuC+24+7], v[vgprValuB_X0_I0+8+0+0:vgprValuB_X0_I0+8+0+0+7], v[vgprValuA_X0_I0+8+0+0:vgprValuA_X0_I0+8+0+0+7], v[vgprValuC+24:vgprValuC+24+7], v[vgprValuMXSB_X0_I0+1+0+0], v[vgprValuMXSA_X0_I0+0+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_b_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 // left value = v[24+0:31+0] <This is 99-cycle>
label_InitCIterWmma_target_0:
/* numPrefetchIter=0 */
/* dataAtIterA=-1 numReadsIterA=1 skipReadsIterA=1 readsPerIterA=4 */
/* dataAtIterB=-1 numReadsIterB=1 skipReadsIterB=1 readsPerIterB=4 */
/* dataAtIterMXSA=-1 numReadsIterMXSA=1 skipReadsIterMXSA=1 readsPerIterMXSA=1 */
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

/* local read maxa */
s_wait_alu depctr_va_vdst(4)
ds_load_b32 v[vgprValuMXSA_X0_I0+0], v[vgprLocalReadAddrMXSA+0] offset:0 // L -> Reg for MX sync LDS1

/* local read mxsb */
s_wait_alu depctr_va_vdst(3)
ds_load_b64 v[vgprValuMXSB_X0_I0+0:vgprValuMXSB_X0_I0+0+1], v[vgprLocalReadAddrMXSB+0] offset:0 // L -> Reg for MX sync LDS1

/* local read b */
s_wait_alu depctr_va_vdst(2)
ds_load_b128 v[vgprValuB_X0_I0+0:vgprValuB_X0_I0+0+3], v[vgprLocalReadAddrB+0] offset:0 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_b128 v[vgprValuB_X0_I0+4:vgprValuB_X0_I0+4+3], v[vgprLocalReadAddrB+0] offset:32 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_b128 v[vgprValuB_X0_I0+8:vgprValuB_X0_I0+8+3], v[vgprLocalReadAddrB+0] offset:128 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=1 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_b128 v[vgprValuB_X0_I0+12:vgprValuB_X0_I0+12+3], v[vgprLocalReadAddrB+0] offset:160 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=1 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS1

/* local read increment a */
/* N/A, lro->128 */
/* localReadDoCntA 3 localReadDoCntMXSA 3 localReadDoCntB 3 localReadDoCntMXSB 3 localReadDoCntM 0 */

/* local read increment mxsa */
/* N/A, lro->256 */
/* localReadDoCntA 3 localReadDoCntMXSA 3 localReadDoCntB 3 localReadDoCntMXSB 3 localReadDoCntM 0 */

/* local read increment mxsb */
/* N/A, lro->256 */
/* localReadDoCntA 3 localReadDoCntMXSA 3 localReadDoCntB 3 localReadDoCntMXSB 3 localReadDoCntM 0 */

/* local read increment b */
/* N/A, lro->128 */
/* localReadDoCntA 3 localReadDoCntMXSA 3 localReadDoCntB 3 localReadDoCntMXSB 3 localReadDoCntM 0 */

/* Global Read A (TDM deferred after LDS swap) */
tensor_load_to_lds s[sgprtdmAGroup0:sgprtdmAGroup0+3], s[sgprtdmAGroup1:sgprtdmAGroup1+7] // sync LDS0

/* Global Read MXSA (TDM deferred after LDS swap) */
tensor_load_to_lds s[sgprtdmMXSAGroup0:sgprtdmMXSAGroup0+3], s[sgprtdmMXSAGroup1:sgprtdmMXSAGroup1+7] // sync LDS0
s_wait_dscnt 10                                    // wait for prior local read local write old=0, new=10 newLW=0 newLR=10
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+0:vgprValuC+0+7], v[vgprValuB_X1_I0+0+0+0:vgprValuB_X1_I0+0+0+0+7], v[vgprValuA_X1_I0+0+0+0:vgprValuA_X1_I0+0+0+0+7], v[vgprValuC+0:vgprValuC+0+7], v[vgprValuMXSB_X1_I0+0+0+0], v[vgprValuMXSA_X1_I0+0+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_a_reuse // left value = v[0+0:7+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+8:vgprValuC+8+7], v[vgprValuB_X1_I0+0+0+0:vgprValuB_X1_I0+0+0+0+7], v[vgprValuA_X1_I0+8+0+0:vgprValuA_X1_I0+8+0+0+7], v[vgprValuC+8:vgprValuC+8+7], v[vgprValuMXSB_X1_I0+0+0+0], v[vgprValuMXSA_X1_I0+0+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_b_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 // left value = v[8+0:15+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+16:vgprValuC+16+7], v[vgprValuB_X1_I0+8+0+0:vgprValuB_X1_I0+8+0+0+7], v[vgprValuA_X1_I0+0+0+0:vgprValuA_X1_I0+0+0+0+7], v[vgprValuC+16:vgprValuC+16+7], v[vgprValuMXSB_X1_I0+1+0+0], v[vgprValuMXSA_X1_I0+0+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_a_reuse // left value = v[16+0:23+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+24:vgprValuC+24+7], v[vgprValuB_X1_I0+8+0+0:vgprValuB_X1_I0+8+0+0+7], v[vgprValuA_X1_I0+8+0+0:vgprValuA_X1_I0+8+0+0+7], v[vgprValuC+24:vgprValuC+24+7], v[vgprValuMXSB_X1_I0+1+0+0], v[vgprValuMXSA_X1_I0+0+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_b_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 // left value = v[24+0:31+0]
/* numPrefetchIter=1 */
/* dataAtIterA=0 numReadsIterA=1 skipReadsIterA=1 readsPerIterA=4 */
/* dataAtIterB=0 numReadsIterB=1 skipReadsIterB=1 readsPerIterB=4 */
/* dataAtIterMXSA=0 numReadsIterMXSA=1 skipReadsIterMXSA=1 readsPerIterMXSA=1 */
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

/* local read mxsa */
s_wait_alu depctr_va_vdst(6)
ds_load_b32 v[vgprValuMXSA_X1_I0+0], v[vgprLocalReadAddrMXSA+0] offset:256 // L -> Reg for MX sync LDS1

/* local read mxsb */
ds_load_b64 v[vgprValuMXSB_X1_I0+0:vgprValuMXSB_X1_I0+0+1], v[vgprLocalReadAddrMXSB+0] offset:256 // L -> Reg for MX sync LDS1

/* local read b */
ds_load_b128 v[vgprValuB_X1_I0+0:vgprValuB_X1_I0+0+3], v[vgprLocalReadAddrB+0] offset:64 // L -> Reg lro=128 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=0 oIdx=0 buffer=1 iui=0 sync LDS1
ds_load_b128 v[vgprValuB_X1_I0+4:vgprValuB_X1_I0+4+3], v[vgprLocalReadAddrB+0] offset:96 // L -> Reg lro=128 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=1 oIdx=0 buffer=1 iui=0 sync LDS1
ds_load_b128 v[vgprValuB_X1_I0+8:vgprValuB_X1_I0+8+3], v[vgprLocalReadAddrB+0] offset:192 // L -> Reg lro=128 swapByteOffset=0 ti=64 vIdx=0 eIdx=1 rIdx=0 oIdx=0 buffer=1 iui=0 sync LDS1
ds_load_b128 v[vgprValuB_X1_I0+12:vgprValuB_X1_I0+12+3], v[vgprLocalReadAddrB+0] offset:224 // L -> Reg lro=128 swapByteOffset=0 ti=64 vIdx=0 eIdx=1 rIdx=1 oIdx=0 buffer=1 iui=0 sync LDS1

/* tdm swap offsets a */
// TDM LDS swap(aligned pow2: True)
s_xor_b32 s[sgprtdmAGroup0+1], s[sgprtdmAGroup0+1], 0x8000

/* local write swap offsets mxsa */
// TDM LDS swap(aligned pow2: True)
s_xor_b32 s[sgprtdmMXSAGroup0+1], s[sgprtdmMXSAGroup0+1], 0x8000

/* local write swap offsets mxsb */

/* local read swap offsets a */
s_wait_alu depctr_vm_vsrc(6)
v_xor_b32 v[vgprLocalReadAddrA], 0x8000, v[vgprLocalReadAddrA] // swap Red Blk

/* local read swap offsets mxsa */
s_wait_alu depctr_vm_vsrc(5)
v_xor_b32 v[vgprLocalReadAddrMXSA], 0x8000, v[vgprLocalReadAddrMXSA] // swap Red Blk

/* local read swap offsets mxsb */
s_wait_alu depctr_vm_vsrc(4)
v_xor_b32 v[vgprLocalReadAddrMXSB], 0x8000, v[vgprLocalReadAddrMXSB] // swap Red Blk

/* local read swap offsets b */
s_wait_alu depctr_vm_vsrc(0)
v_xor_b32 v[vgprLocalReadAddrB], 0x8000, v[vgprLocalReadAddrB] // swap Red Blk

/* local read init pointers a */

/* localReadInitPointers */

/* local read init pointers mxsa */

/* localReadInitPointers */

/* local read init pointers mxsb */

/* localReadInitPointers */

/* local read init pointers b */

/* localReadInitPointers */

/* Global Read IncA */
v_readfirstlane_b32 s5, v[vgprSerial]              // get tId
s_lshr_b32 s5, s5, 5                               // waveId
s_bitcmp1_b32 s5, 0                                // check wave parity
s_cselect_b32 s90, s[sgprWrapUB+0], s[sgprWrapUA+0] // select WrapU based on wave parity (lo)
s_cselect_b32 s91, s[sgprWrapUB+1], s[sgprWrapUA+1] // select WrapU based on wave parity (hi)
s_cmp_eq_u32 s[sgprLoopCounterL], s[sgprStaggerUIter] // Is this the wrapIter?
s_cselect_b32 s88, s90, s[sgprtdmABIncs]           // select WrapU or normal inc (lo)
s_cselect_b32 s89, s91, 0                          // select WrapU or normal inc (hi)
s_add_u64 s[sgprtdmAGroup0+2:sgprtdmAGroup0+2+1], s[sgprtdmAGroup0+2:sgprtdmAGroup0+2+1], s[88:89] // TDM addr += inc (with wrap, 64-bit)

/* Global Read IncB */
v_readfirstlane_b32 s5, v[vgprSerial]              // get tId
s_lshr_b32 s5, s5, 5                               // waveId
s_bitcmp1_b32 s5, 0                                // check wave parity
s_cselect_b32 s90, s[sgprWrapUMXSB+0], s[sgprWrapUMXSA+0] // select WrapU based on wave parity (lo)
s_cselect_b32 s91, s[sgprWrapUMXSB+1], s[sgprWrapUMXSA+1] // select WrapU based on wave parity (hi)
s_cmp_eq_u32 s[sgprLoopCounterL], s[sgprStaggerUIter] // Is this the wrapIter?
s_cselect_b32 s88, s90, s[sgprtdmMXSAMXSBIncs]     // select WrapU or normal inc (lo)
s_cselect_b32 s89, s91, 0                          // select WrapU or normal inc (hi)
s_add_u64 s[sgprtdmMXSAGroup0+2:sgprtdmMXSAGroup0+2+1], s[sgprtdmMXSAGroup0+2:sgprtdmMXSAGroup0+2+1], s[88:89] // TDM addr += inc (with wrap, 64-bit)
s_wait_dscnt 10                                    // wait for prior local read local write old=0, new=10 newLW=0 newLR=10 for iteration == 0
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+0:vgprValuC+0+7], v[vgprValuB_X0_I0+0+0+0:vgprValuB_X0_I0+0+0+0+7], v[vgprValuA_X0_I0+0+0+0:vgprValuA_X0_I0+0+0+0+7], v[vgprValuC+0:vgprValuC+0+7], v[vgprValuMXSB_X0_I0+0+0+0], v[vgprValuMXSA_X0_I0+0+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_a_reuse // left value = v[0+0:7+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+8:vgprValuC+8+7], v[vgprValuB_X0_I0+0+0+0:vgprValuB_X0_I0+0+0+0+7], v[vgprValuA_X0_I0+8+0+0:vgprValuA_X0_I0+8+0+0+7], v[vgprValuC+8:vgprValuC+8+7], v[vgprValuMXSB_X0_I0+0+0+0], v[vgprValuMXSA_X0_I0+0+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_b_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 // left value = v[8+0:15+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+16:vgprValuC+16+7], v[vgprValuB_X0_I0+8+0+0:vgprValuB_X0_I0+8+0+0+7], v[vgprValuA_X0_I0+0+0+0:vgprValuA_X0_I0+0+0+0+7], v[vgprValuC+16:vgprValuC+16+7], v[vgprValuMXSB_X0_I0+1+0+0], v[vgprValuMXSA_X0_I0+0+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_a_reuse // left value = v[16+0:23+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+24:vgprValuC+24+7], v[vgprValuB_X0_I0+8+0+0:vgprValuB_X0_I0+8+0+0+7], v[vgprValuA_X0_I0+8+0+0:vgprValuA_X0_I0+8+0+0+7], v[vgprValuC+24:vgprValuC+24+7], v[vgprValuMXSB_X0_I0+1+0+0], v[vgprValuMXSA_X0_I0+0+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_b_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 // left value = v[24+0:31+0]
/* numPrefetchIter=0 */
/* dataAtIterA=-1 numReadsIterA=1 skipReadsIterA=1 readsPerIterA=4 */
/* dataAtIterB=-1 numReadsIterB=1 skipReadsIterB=1 readsPerIterB=4 */
/* dataAtIterMXSA=-1 numReadsIterMXSA=1 skipReadsIterMXSA=1 readsPerIterMXSA=1 */
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

/* local read mxsa */
s_wait_alu depctr_va_vdst(4)
ds_load_b32 v[vgprValuMXSA_X0_I0+0], v[vgprLocalReadAddrMXSA+0] offset:0 // L -> Reg for MX sync LDS0

/* local read mxsb */
s_wait_alu depctr_va_vdst(3)
ds_load_b64 v[vgprValuMXSB_X0_I0+0:vgprValuMXSB_X0_I0+0+1], v[vgprLocalReadAddrMXSB+0] offset:0 // L -> Reg for MX sync LDS0

/* local read b */
s_wait_alu depctr_va_vdst(2)
ds_load_b128 v[vgprValuB_X0_I0+0:vgprValuB_X0_I0+0+3], v[vgprLocalReadAddrB+0] offset:0 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_b128 v[vgprValuB_X0_I0+4:vgprValuB_X0_I0+4+3], v[vgprLocalReadAddrB+0] offset:32 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_b128 v[vgprValuB_X0_I0+8:vgprValuB_X0_I0+8+3], v[vgprLocalReadAddrB+0] offset:128 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=1 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_b128 v[vgprValuB_X0_I0+12:vgprValuB_X0_I0+12+3], v[vgprLocalReadAddrB+0] offset:160 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=1 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS0

/* local read increment a */
/* N/A, lro->128 */
/* localReadDoCntA 5 localReadDoCntMXSA 5 localReadDoCntB 5 localReadDoCntMXSB 5 localReadDoCntM 0 */

/* local read increment mxsa */
/* N/A, lro->256 */
/* localReadDoCntA 5 localReadDoCntMXSA 5 localReadDoCntB 5 localReadDoCntMXSB 5 localReadDoCntM 0 */

/* local read increment mxsb */
/* N/A, lro->256 */
/* localReadDoCntA 5 localReadDoCntMXSA 5 localReadDoCntB 5 localReadDoCntMXSB 5 localReadDoCntM 0 */

/* local read increment b */
/* N/A, lro->128 */
/* localReadDoCntA 5 localReadDoCntMXSA 5 localReadDoCntB 5 localReadDoCntMXSB 5 localReadDoCntM 0 */
s_wait_dscnt 10                                    // wait for prior local read local write old=0, new=10 newLW=0 newLR=10
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+0:vgprValuC+0+7], v[vgprValuB_X1_I0+0+0+0:vgprValuB_X1_I0+0+0+0+7], v[vgprValuA_X1_I0+0+0+0:vgprValuA_X1_I0+0+0+0+7], v[vgprValuC+0:vgprValuC+0+7], v[vgprValuMXSB_X1_I0+0+0+0], v[vgprValuMXSA_X1_I0+0+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_a_reuse // left value = v[0+0:7+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+8:vgprValuC+8+7], v[vgprValuB_X1_I0+0+0+0:vgprValuB_X1_I0+0+0+0+7], v[vgprValuA_X1_I0+8+0+0:vgprValuA_X1_I0+8+0+0+7], v[vgprValuC+8:vgprValuC+8+7], v[vgprValuMXSB_X1_I0+0+0+0], v[vgprValuMXSA_X1_I0+0+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_b_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 // left value = v[8+0:15+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+16:vgprValuC+16+7], v[vgprValuB_X1_I0+8+0+0:vgprValuB_X1_I0+8+0+0+7], v[vgprValuA_X1_I0+0+0+0:vgprValuA_X1_I0+0+0+0+7], v[vgprValuC+16:vgprValuC+16+7], v[vgprValuMXSB_X1_I0+1+0+0], v[vgprValuMXSA_X1_I0+0+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_a_reuse // left value = v[16+0:23+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+24:vgprValuC+24+7], v[vgprValuB_X1_I0+8+0+0:vgprValuB_X1_I0+8+0+0+7], v[vgprValuA_X1_I0+8+0+0:vgprValuA_X1_I0+8+0+0+7], v[vgprValuC+24:vgprValuC+24+7], v[vgprValuMXSB_X1_I0+1+0+0], v[vgprValuMXSA_X1_I0+0+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_b_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 // left value = v[24+0:31+0]
/* numPrefetchIter=1 */
/* dataAtIterA=0 numReadsIterA=1 skipReadsIterA=1 readsPerIterA=4 */
/* dataAtIterB=0 numReadsIterB=1 skipReadsIterB=1 readsPerIterB=4 */
/* dataAtIterMXSA=0 numReadsIterMXSA=1 skipReadsIterMXSA=1 readsPerIterMXSA=1 */
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

/* local read mxsa */
s_wait_alu depctr_va_vdst(6)
ds_load_b32 v[vgprValuMXSA_X1_I0+0], v[vgprLocalReadAddrMXSA+0] offset:256 // L -> Reg for MX sync LDS0

/* local read mxsb */
ds_load_b64 v[vgprValuMXSB_X1_I0+0:vgprValuMXSB_X1_I0+0+1], v[vgprLocalReadAddrMXSB+0] offset:256 // L -> Reg for MX sync LDS0

/* local read b */
ds_load_b128 v[vgprValuB_X1_I0+0:vgprValuB_X1_I0+0+3], v[vgprLocalReadAddrB+0] offset:64 // L -> Reg lro=128 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=0 oIdx=0 buffer=1 iui=0 sync LDS0
ds_load_b128 v[vgprValuB_X1_I0+4:vgprValuB_X1_I0+4+3], v[vgprLocalReadAddrB+0] offset:96 // L -> Reg lro=128 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=1 oIdx=0 buffer=1 iui=0 sync LDS0
ds_load_b128 v[vgprValuB_X1_I0+8:vgprValuB_X1_I0+8+3], v[vgprLocalReadAddrB+0] offset:192 // L -> Reg lro=128 swapByteOffset=0 ti=64 vIdx=0 eIdx=1 rIdx=0 oIdx=0 buffer=1 iui=0 sync LDS0
ds_load_b128 v[vgprValuB_X1_I0+12:vgprValuB_X1_I0+12+3], v[vgprLocalReadAddrB+0] offset:224 // L -> Reg lro=128 swapByteOffset=0 ti=64 vIdx=0 eIdx=1 rIdx=1 oIdx=0 buffer=1 iui=0 sync LDS0

/* local read swap offsets a */

/* isSwapLroIter = 1 */
s_wait_alu depctr_vm_vsrc(6)
v_xor_b32 v[vgprLocalReadAddrA], 0x8000, v[vgprLocalReadAddrA] // swap Red Blk

/* local read swap offsets mxsa */
s_wait_alu depctr_vm_vsrc(5)
v_xor_b32 v[vgprLocalReadAddrMXSA], 0x8000, v[vgprLocalReadAddrMXSA] // swap Red Blk

/* local read swap offsets mxsb */
s_wait_alu depctr_vm_vsrc(4)
v_xor_b32 v[vgprLocalReadAddrMXSB], 0x8000, v[vgprLocalReadAddrMXSB] // swap Red Blk

/* local read swap offsets b */
s_wait_alu depctr_vm_vsrc(0)
v_xor_b32 v[vgprLocalReadAddrB], 0x8000, v[vgprLocalReadAddrB] // swap Red Blk

/* Global Read IncA */

/* Global Read IncB */

/* Global Read A */

/* Global Read MXSA */

/* Global Read MXSB */

/* Global Read B */
s_wait_dscnt 10                                    // wait for prior local read local write old=0, new=10 newLW=0 newLR=10 for iteration == 0
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+0:vgprValuC+0+7], v[vgprValuB_X0_I0+0+0+0:vgprValuB_X0_I0+0+0+0+7], v[vgprValuA_X0_I0+0+0+0:vgprValuA_X0_I0+0+0+0+7], v[vgprValuC+0:vgprValuC+0+7], v[vgprValuMXSB_X0_I0+0+0+0], v[vgprValuMXSA_X0_I0+0+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_a_reuse // left value = v[0+0:7+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+8:vgprValuC+8+7], v[vgprValuB_X0_I0+0+0+0:vgprValuB_X0_I0+0+0+0+7], v[vgprValuA_X0_I0+8+0+0:vgprValuA_X0_I0+8+0+0+7], v[vgprValuC+8:vgprValuC+8+7], v[vgprValuMXSB_X0_I0+0+0+0], v[vgprValuMXSA_X0_I0+0+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_b_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 // left value = v[8+0:15+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+16:vgprValuC+16+7], v[vgprValuB_X0_I0+8+0+0:vgprValuB_X0_I0+8+0+0+7], v[vgprValuA_X0_I0+0+0+0:vgprValuA_X0_I0+0+0+0+7], v[vgprValuC+16:vgprValuC+16+7], v[vgprValuMXSB_X0_I0+1+0+0], v[vgprValuMXSA_X0_I0+0+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_a_reuse // left value = v[16+0:23+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+24:vgprValuC+24+7], v[vgprValuB_X0_I0+8+0+0:vgprValuB_X0_I0+8+0+0+7], v[vgprValuA_X0_I0+8+0+0:vgprValuA_X0_I0+8+0+0+7], v[vgprValuC+24:vgprValuC+24+7], v[vgprValuMXSB_X0_I0+1+0+0], v[vgprValuMXSA_X0_I0+0+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_b_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 // left value = v[24+0:31+0]
/* numPrefetchIter=0 */
/* dataAtIterA=-1 numReadsIterA=1 skipReadsIterA=1 readsPerIterA=4 */
/* dataAtIterB=-1 numReadsIterB=1 skipReadsIterB=1 readsPerIterB=4 */
/* dataAtIterMXSA=-1 numReadsIterMXSA=1 skipReadsIterMXSA=1 readsPerIterMXSA=1 */
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
/* N/A, lro->512 */
/* localReadDoCntA 7 localReadDoCntMXSA 7 localReadDoCntB 7 localReadDoCntMXSB 7 localReadDoCntM 0 */

/* local read increment mxsb */
/* N/A, lro->512 */
/* localReadDoCntA 7 localReadDoCntMXSA 7 localReadDoCntB 7 localReadDoCntMXSB 7 localReadDoCntM 0 */

/* local read increment b */
/* N/A, lro->256 */
/* localReadDoCntA 7 localReadDoCntMXSA 7 localReadDoCntB 7 localReadDoCntMXSB 7 localReadDoCntM 0 */
s_wait_dscnt 0                                     // wait for prior local read local write old=0, new=0 newLW=0 newLR=0
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+0:vgprValuC+0+7], v[vgprValuB_X1_I0+0+0+0:vgprValuB_X1_I0+0+0+0+7], v[vgprValuA_X1_I0+0+0+0:vgprValuA_X1_I0+0+0+0+7], v[vgprValuC+0:vgprValuC+0+7], v[vgprValuMXSB_X1_I0+0+0+0], v[vgprValuMXSA_X1_I0+0+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_a_reuse // left value = v[0+0:7+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+8:vgprValuC+8+7], v[vgprValuB_X1_I0+0+0+0:vgprValuB_X1_I0+0+0+0+7], v[vgprValuA_X1_I0+8+0+0:vgprValuA_X1_I0+8+0+0+7], v[vgprValuC+8:vgprValuC+8+7], v[vgprValuMXSB_X1_I0+0+0+0], v[vgprValuMXSA_X1_I0+0+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_b_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 // left value = v[8+0:15+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+16:vgprValuC+16+7], v[vgprValuB_X1_I0+8+0+0:vgprValuB_X1_I0+8+0+0+7], v[vgprValuA_X1_I0+0+0+0:vgprValuA_X1_I0+0+0+0+7], v[vgprValuC+16:vgprValuC+16+7], v[vgprValuMXSB_X1_I0+1+0+0], v[vgprValuMXSA_X1_I0+0+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_a_reuse // left value = v[16+0:23+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+24:vgprValuC+24+7], v[vgprValuB_X1_I0+8+0+0:vgprValuB_X1_I0+8+0+0+7], v[vgprValuA_X1_I0+8+0+0:vgprValuA_X1_I0+8+0+0+7], v[vgprValuC+24:vgprValuC+24+7], v[vgprValuMXSB_X1_I0+1+0+0], v[vgprValuMXSA_X1_I0+0+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_b_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 // left value = v[24+0:31+0]
/* numPrefetchIter=0 */
/* dataAtIterA=0 numReadsIterA=1 skipReadsIterA=0 readsPerIterA=4 */
/* dataAtIterB=0 numReadsIterB=1 skipReadsIterB=0 readsPerIterB=4 */
/* dataAtIterMXSA=0 numReadsIterMXSA=1 skipReadsIterMXSA=0 readsPerIterMXSA=1 */
/* dataAtIterMXSB=0 numReadsIterMXSB=1 skipReadsIterMXSB=0 readsPerIterMXSB=1 */
label_toPGR1end_OrdNLL:
label_PrefetchGlobalLastIterEnd:

/* Tail: add ValuA/B vgpr buffer [44...110) to pool */

/* Tail: add address/G2L vgpr [110...110) to pool */

/******************************************/
/* Tail Loop                              */
/******************************************/

/* local write reset offsets a */

/* local write reset offsets b */
/* Check out VGPR (numG2LA,numG2LB,numG2LMXSA,numG2LMXSB,numG2LMetadata) = (0,0,4,4,0) */
.set vgprG2LMXSA_BASE, 44
.set vgprG2LMXSA, vgprG2LMXSA_BASE+0
.set vgprG2LMXSB_BASE, 48
.set vgprG2LMXSB, vgprG2LMXSB_BASE+0

/* remove stagger offsets for tail loop */
s_cmp_eq_u32 s[sgprOrigLoopCounter], 0             // skip if main loop was not executed
s_cbranch_scc1 label_SkipRemoveStagger             // skip removeStagger
//  removeStagger A
s_sub_i32 s88, 3, s[sgprStaggerUIter]
s_cmp_ge_i32 s88, 0
s_cbranch_scc0 label_Negative_S4FDBQ587JJL6NOU
s_mul_hi_u32 s89, s88, s[sgprGlobalReadIncsA+0]    // start offset S in bytes
s_mul_i32 s88, s88, s[sgprGlobalReadIncsA+0]       // start offset S in bytes
s_branch label_MultiplyDone_L43KTIIJOOEN7J6P
label_Negative_S4FDBQ587JJL6NOU:
s_abs_i32 s88, s88
s_mul_hi_u32 s89, s88, s[sgprGlobalReadIncsA+0]    // start offset S in bytes
s_mul_i32 s88, s88, s[sgprGlobalReadIncsA+0]       // start offset S in bytes
s_xor_b32 s88, s88, 0xffffffff
s_xor_b32 s89, s89, 0xffffffff
s_add_u32 s88, s88, 0x1
s_addc_u32 s89, s89, 0
label_MultiplyDone_L43KTIIJOOEN7J6P:
s_sub_u64 s[88:89], s[88:89], s[sgprWrapUA:sgprWrapUA+1] // S - WrapU
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_readfirstlane_b32 s5, v[vgprSerial]              // get tId
s_lshr_b32 s5, s5, 5                               // waveId
s_bitcmp1_b32 s5, 0                                // check wave parity
s_cbranch_scc1 label_SkipRemoveStaggerA            // skip: odd waves handle B
s_add_u32 s[sgprtdmAGroup0+2], s[sgprtdmAGroup0+2], s88 // TDM addr += removeStagger offset (lo)
s_addc_u32 s[sgprtdmAGroup0+3], s[sgprtdmAGroup0+3], s89 // TDM addr += removeStagger offset (hi)
label_SkipRemoveStaggerA:
//  removeStagger MXSA
s_sub_i32 s88, 3, s[sgprStaggerUIter]
s_cmp_ge_i32 s88, 0
s_cbranch_scc0 label_Negative_UR8VN3A1SJCPC6PO
s_mul_hi_u32 s89, s88, s[sgprGlobalReadIncsMXSA+0] // start offset S in bytes
s_mul_i32 s88, s88, s[sgprGlobalReadIncsMXSA+0]    // start offset S in bytes
s_branch label_MultiplyDone_HYY06MPL0TYYIAT2
label_Negative_UR8VN3A1SJCPC6PO:
s_abs_i32 s88, s88
s_mul_hi_u32 s89, s88, s[sgprGlobalReadIncsMXSA+0] // start offset S in bytes
s_mul_i32 s88, s88, s[sgprGlobalReadIncsMXSA+0]    // start offset S in bytes
s_xor_b32 s88, s88, 0xffffffff
s_xor_b32 s89, s89, 0xffffffff
s_add_u32 s88, s88, 0x1
s_addc_u32 s89, s89, 0
label_MultiplyDone_HYY06MPL0TYYIAT2:
s_sub_u64 s[88:89], s[88:89], s[sgprWrapUMXSA:sgprWrapUMXSA+1] // S - WrapU
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_readfirstlane_b32 s5, v[vgprSerial]              // get tId
s_lshr_b32 s5, s5, 5                               // waveId
s_bitcmp1_b32 s5, 0                                // check wave parity
s_cbranch_scc1 label_SkipRemoveStaggerMXSA         // skip: odd waves handle B
s_add_u32 s[sgprtdmMXSAGroup0+2], s[sgprtdmMXSAGroup0+2], s88 // TDM addr += removeStagger offset (lo)
s_addc_u32 s[sgprtdmMXSAGroup0+3], s[sgprtdmMXSAGroup0+3], s89 // TDM addr += removeStagger offset (hi)
label_SkipRemoveStaggerMXSA:
//  removeStagger MXSB
s_sub_i32 s88, 3, s[sgprStaggerUIter]
s_cmp_ge_i32 s88, 0
s_cbranch_scc0 label_Negative_8S4L1KCK9VFC7AQU
s_mul_hi_u32 s89, s88, s[sgprGlobalReadIncsMXSB+0] // start offset S in bytes
s_mul_i32 s88, s88, s[sgprGlobalReadIncsMXSB+0]    // start offset S in bytes
s_branch label_MultiplyDone_ZU0B7F2XE71N7LVL
label_Negative_8S4L1KCK9VFC7AQU:
s_abs_i32 s88, s88
s_mul_hi_u32 s89, s88, s[sgprGlobalReadIncsMXSB+0] // start offset S in bytes
s_mul_i32 s88, s88, s[sgprGlobalReadIncsMXSB+0]    // start offset S in bytes
s_xor_b32 s88, s88, 0xffffffff
s_xor_b32 s89, s89, 0xffffffff
s_add_u32 s88, s88, 0x1
s_addc_u32 s89, s89, 0
label_MultiplyDone_ZU0B7F2XE71N7LVL:
s_sub_u64 s[88:89], s[88:89], s[sgprWrapUMXSB:sgprWrapUMXSB+1] // S - WrapU
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_readfirstlane_b32 s5, v[vgprSerial]              // get tId
s_lshr_b32 s5, s5, 5                               // waveId
s_bitcmp1_b32 s5, 0                                // check wave parity
s_cbranch_scc0 label_SkipRemoveStaggerMXSB         // skip: even waves handle A
s_add_u32 s[sgprtdmMXSBGroup0+2], s[sgprtdmMXSBGroup0+2], s88 // TDM addr += removeStagger offset (lo)
s_addc_u32 s[sgprtdmMXSBGroup0+3], s[sgprtdmMXSBGroup0+3], s89 // TDM addr += removeStagger offset (hi)
label_SkipRemoveStaggerMXSB:
//  removeStagger B
s_sub_i32 s88, 3, s[sgprStaggerUIter]
s_cmp_ge_i32 s88, 0
s_cbranch_scc0 label_Negative_J5DQFVGFWLXU2DUR
s_mul_hi_u32 s89, s88, s[sgprGlobalReadIncsB+0]    // start offset S in bytes
s_mul_i32 s88, s88, s[sgprGlobalReadIncsB+0]       // start offset S in bytes
s_branch label_MultiplyDone_DLSAQLEVYLOBCPNL
label_Negative_J5DQFVGFWLXU2DUR:
s_abs_i32 s88, s88
s_mul_hi_u32 s89, s88, s[sgprGlobalReadIncsB+0]    // start offset S in bytes
s_mul_i32 s88, s88, s[sgprGlobalReadIncsB+0]       // start offset S in bytes
s_xor_b32 s88, s88, 0xffffffff
s_xor_b32 s89, s89, 0xffffffff
s_add_u32 s88, s88, 0x1
s_addc_u32 s89, s89, 0
label_MultiplyDone_DLSAQLEVYLOBCPNL:
s_sub_u64 s[88:89], s[88:89], s[sgprWrapUB:sgprWrapUB+1] // S - WrapU
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_readfirstlane_b32 s5, v[vgprSerial]              // get tId
s_lshr_b32 s5, s5, 5                               // waveId
s_bitcmp1_b32 s5, 0                                // check wave parity
s_cbranch_scc0 label_SkipRemoveStaggerB            // skip: even waves handle A
s_add_u32 s[sgprtdmBGroup0+2], s[sgprtdmBGroup0+2], s88 // TDM addr += removeStagger offset (lo)
s_addc_u32 s[sgprtdmBGroup0+3], s[sgprtdmBGroup0+3], s89 // TDM addr += removeStagger offset (hi)
label_SkipRemoveStaggerB:
.set sgprGlobalReadIncsA, UNDEF
.set sgprGlobalReadIncsB, UNDEF
.set sgprGlobalReadIncsMXSA, UNDEF
.set sgprGlobalReadIncsMXSB, UNDEF
label_SkipRemoveStagger:

// numIterL = LOCAL_SPLITU * min(sizeL % LOCAL_DEPTHU, DEPTHU / LOCAL_SPLITU)
s_and_b32 s[sgprLoopCounterL], 255, s[sgprSizesSum+0] // s[sgprLoopCounterL] = s[sgprSizesSum+0] % 256
s_and_b32 s84, s[sgprGSU], 0x8000                  // SCC = (GSUC == 1) ?
s_cbranch_scc1 label_GSUC_TL                       // branch if GSUC == 1
s_cmp_lg_u32 s[sgprGSUSumIdx], s[sgprGSUSumIdx+1]  // gsuSumIdx == numIterPerWgRemainder
s_cmov_b32 s[sgprLoopCounterL], 0                  // numIter=0 if gsuSimIdx != numIterPerWgRemainder
s_branch label_GSUC_TL_End
label_GSUC_TL:
s_lshr_b32 s85, s[sgprSizesSum], 8                 // s85 = s[sgprSizesSum] / 256
s_and_b32 s86, s[sgprGSU], 0x3fff                  // Restore GSU
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cvt_f32_u32 v52, s86                             // s84 = s85 / s86
v_rcp_iflag_f32 v52, v52                           // s84 = s85 / s86
v_cvt_f32_u32 v53, s85                             // s84 = s85 / s86
v_mul_f32 v52, v52, v53                            // s84 = s85 / s86
v_cvt_u32_f32 v52, v52                             // s84 = s85 / s86
v_mul_u32_u24 v53, v52, s86                        // s84 = s85 / s86
v_sub_nc_u32 v53, s85, v53                         // s84 = s85 / s86
v_cmp_eq_u32 vcc_lo, v53, s86                      // s84 = s85 / s86
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, vcc_lo                          // s84 = s85 / s86
v_add_nc_u32 v52, 1, v52                           // s84 = s85 / s86
v_mov_b32 v53, 0                                   // s[sgprGSUSumIdx+1] = s85 % s86
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, -1                              // Reset exec
v_cmp_gt_u32 vcc_lo, v53, s86                      // overflow happened in remainder
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, vcc_lo                          // overflow happened in remainder
v_sub_nc_u32 v52, v52, 1                           // quotient - 1
v_mul_u32_u24 v53, v52, s86                        // re-calculate remainder
v_sub_nc_u32 v53, s85, v53                         // re-calculate remainder
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, -1                              // Reset exec
v_readfirstlane_b32 s84, v52                       // quotient
v_readfirstlane_b32 s[sgprGSUSumIdx+1], v53        // remainder
s_sub_u32 s85, s86, 1                              // GSU-1
s_cmp_eq_u32 s84, 0                                // quotient == 0
s_cselect_b32 s84, s[sgprGSUSumIdx+1], s85         // lastWg = (quotient==0) ? numIterPerWgRemainder : GSU-1
s_cmp_lg_u32 s[sgprGSUSumIdx], s84                 // gsuSumIdx == lastWg
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
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_readfirstlane_b32 s84, v[vgprSerial]             // first tId
s_lshr_b32 s84, s84, 5                             // wId=fTid // wavelen
s_bitcmp1_b32 s84, 0                               // Check parity of wId
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
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_readfirstlane_b32 s84, v[vgprSerial]             // first tId
s_lshr_b32 s84, s84, 5                             // wId=fTid // wavelen
s_bitcmp1_b32 s84, 0                               // Check parity of wId
s_cbranch_scc1 label_TDMResetTailMXSB              // Jump to B if wId is odd
s_lshr_b32 s85, s84, 1                             // wOffset=wId // 2
s_mul_i32 s85, s85, 128                            // wOffset = wOffset * du // numpComp
s_and_b32 s5, s[sgprSizeL], 255
s_sub_u32 s5, s5, s85                              // consider multiple waves
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
s_lshr_b32 s85, s84, 1                             // wOffset=wId // 2
s_mul_i32 s85, s85, 128                            // wOffset = wOffset * du // numpComp
s_and_b32 s5, s[sgprSizeL], 255
s_sub_u32 s5, s5, s85                              // consider multiple waves
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
tensor_load_to_lds s[sgprtdmAGroup0:sgprtdmAGroup0+3], s[sgprtdmAGroup1:sgprtdmAGroup1+7] // sync LDS0

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
.set vgprValuA_X0_I0_BASE, 44
.set vgprValuA_X0_I0, vgprValuA_X0_I0_BASE+0
.set vgprValuA_X1_I0, vgprValuA_X0_I0_BASE+16
.set vgprValuB_X0_I0_BASE, 76
.set vgprValuB_X0_I0, vgprValuB_X0_I0_BASE+0
.set vgprValuB_X1_I0, vgprValuB_X0_I0_BASE+16

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

/* local read maxa */
s_wait_alu depctr_va_vdst(2)
ds_load_b32 v[vgprValuMXSA_X0_I0+0], v[vgprLocalReadAddrMXSA+0] offset:0 // L -> Reg for MX sync LDS0

/* local read maxb */
s_wait_alu depctr_va_vdst(1)
ds_load_b64 v[vgprValuMXSB_X0_I0+0:vgprValuMXSB_X0_I0+0+1], v[vgprLocalReadAddrMXSB+0] offset:0 // L -> Reg for MX sync LDS0

/* local read b */
s_wait_alu depctr_va_vdst(0)
ds_load_b128 v[vgprValuB_X0_I0+0:vgprValuB_X0_I0+0+3], v[vgprLocalReadAddrB+0] offset:0 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_b128 v[vgprValuB_X0_I0+4:vgprValuB_X0_I0+4+3], v[vgprLocalReadAddrB+0] offset:32 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_b128 v[vgprValuB_X0_I0+8:vgprValuB_X0_I0+8+3], v[vgprLocalReadAddrB+0] offset:128 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=1 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_b128 v[vgprValuB_X0_I0+12:vgprValuB_X0_I0+12+3], v[vgprLocalReadAddrB+0] offset:160 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=1 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS0

/* local read inc a */
s_mov_b32 s5, 64                                   // inc
s_wait_alu depctr_vm_vsrc(6)
v_add_co_u32 v[vgprLocalReadAddrA+0], vcc_lo, s5, v[vgprLocalReadAddrA+0] // lrA += 64 (bpeDS)

/* local read inc mxsa */
s_mov_b32 s5, 256                                  // inc
s_wait_alu depctr_vm_vsrc(5)
v_add_co_u32 v[vgprLocalReadAddrMXSA+0], vcc_lo, s5, v[vgprLocalReadAddrMXSA+0] // lrMXSA += 256 (bpeDS)

/* local read inc mxsb */
                                                   // inc (dup assign opt.)
s_wait_alu depctr_vm_vsrc(4)
v_add_co_u32 v[vgprLocalReadAddrMXSB+0], vcc_lo, s5, v[vgprLocalReadAddrMXSB+0] // lrMXSB += 256 (bpeDS)

/* local read inc b */
s_mov_b32 s5, 64                                   // inc
s_wait_alu depctr_vm_vsrc(0)
v_add_co_u32 v[vgprLocalReadAddrB+0], vcc_lo, s5, v[vgprLocalReadAddrB+0] // lrB += 64 (bpeDS)
s_wait_dscnt 0                                     // 4wait for local read
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+0:vgprValuC+0+7], v[vgprValuB_X0_I0+0+0+0:vgprValuB_X0_I0+0+0+0+7], v[vgprValuA_X0_I0+0+0+0:vgprValuA_X0_I0+0+0+0+7], v[vgprValuC+0:vgprValuC+0+7], v[vgprValuMXSB_X0_I0+0+0+0], v[vgprValuMXSA_X0_I0+0+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_a_reuse // left value = v[0+0:7+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+8:vgprValuC+8+7], v[vgprValuB_X0_I0+0+0+0:vgprValuB_X0_I0+0+0+0+7], v[vgprValuA_X0_I0+8+0+0:vgprValuA_X0_I0+8+0+0+7], v[vgprValuC+8:vgprValuC+8+7], v[vgprValuMXSB_X0_I0+0+0+0], v[vgprValuMXSA_X0_I0+0+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_b_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 // left value = v[8+0:15+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+16:vgprValuC+16+7], v[vgprValuB_X0_I0+8+0+0:vgprValuB_X0_I0+8+0+0+7], v[vgprValuA_X0_I0+0+0+0:vgprValuA_X0_I0+0+0+0+7], v[vgprValuC+16:vgprValuC+16+7], v[vgprValuMXSB_X0_I0+1+0+0], v[vgprValuMXSA_X0_I0+0+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 matrix_a_reuse // left value = v[16+0:23+0]
v_wmma_scale_f32_16x16x128_f8f6f4 v[vgprValuC+24:vgprValuC+24+7], v[vgprValuB_X0_I0+8+0+0:vgprValuB_X0_I0+8+0+0+7], v[vgprValuA_X0_I0+8+0+0:vgprValuA_X0_I0+8+0+0+7], v[vgprValuC+24:vgprValuC+24+7], v[vgprValuMXSB_X0_I0+1+0+0], v[vgprValuMXSA_X0_I0+0+0+0] matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4 matrix_b_scale:1 matrix_a_scale_fmt:2 matrix_b_scale_fmt:2 // left value = v[24+0:31+0]

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

/* Tail: add MISC Vgpr [40...44) to pool */

/* Tail: add ValuA/B vgpr buffer [0...8) to pool */
label_Summation_End_LQI6BOBE0EY8XIP1:
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
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_lshrrev_b32 v4, 5, v[vgprSerial]                 // 4 = Serial / 32
v_lshrrev_b32 v5, 1, v4                            // 5 = 4 / 2
v_mul_lo_u32 v5, 0x10, v5                          // wave coordination offset 1
v_and_b32 v1, 31, v[vgprSerial]                    // v1 = v[vgprSerial] % 32
v_lshrrev_b32 v1, 4, v1                            // 1 = 1 / 16
v_lshlrev_b32 v1, 3, v1                            // thread0 * continuous_output
v_add_lshl_u32 v1, v5, v1, 1                       // coordination 1 = vwB *(wave_id1 + tid1)
v_mul_lo_u32 v2, v1, s[sgprStrideC1J]              //  offset 1
v_mul_lo_u32 v3, v1, s[sgprStrideD1J]              //  offset 1
v_and_b32 v0, 1, v4                                // v0 = v4 % 2
v_mul_lo_u32 v0, 0x10, v0                          // wave coordination offset 0
v_and_b32 v5, 15, v[vgprSerial]                    // v5 = v[vgprSerial] % 16
v_add_lshl_u32 v0, v5, v0, 0                       // coordination 0 = vwA * (wave_id0 + tid0)
s_mul_i32 s5, 64, s[sgprWorkGroup0]                // wgp0 * MT0
v_add_nc_u32 v0, s5, v0                            // coord 0 = (tid0/MI_m)*4 + waveG0*MIB_m + MT0*SG0
s_mul_i32 s5, 64, s[sgprWorkGroup1]                // wgp1 * MT1
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

/* Edge/NonEdge store path check (M): Size % 64 > 0 -> Edge store; else -> NonEdge store */
s_and_b32 s28, 63, s[sgprSizeI]                    // s28 = s[sgprSizeI] % 64
s_add_u32 s29, -0x1, s[sgprNumWorkGroups0]
s_cmp_ge_u32 s[sgprWorkGroup0], s29                // wg0 >= nwg0-1 ?
s_cselect_b32 s28, s28, 0                          // set rem
s_mov_b32 s5, 0
s_cmp_gt_u32 s28, s5                               // rem > 0
s_cbranch_scc1 label_GW_B0_FD0_VW1_MB_Else         // jump if edges required

/* Edge/NonEdge store path check (N (isSize1)): Size % 64 > 0 -> Edge store; else -> NonEdge store */
s_and_b32 s28, 63, s[sgprSizeJ]                    // s28 = s[sgprSizeJ] % 64
s_add_u32 s29, -0x1, s[sgprNumWorkGroups1]
s_cmp_ge_u32 s[sgprWorkGroup1], s29                // wg1 >= nwg1-1
s_cselect_b32 s28, s28, 0                          // set rem
s_mov_b32 s5, 0
s_cmp_gt_u32 s28, s5                               // rem > 0
s_cbranch_scc1 label_GW_B0_FD0_VW1_MB_Then         // jump if edges required
label_GW_B0_FD0_VW1_MB_NonEdge:

/* edge=0, allocate 1 sgpr. perBatchTmpS=1 perBatchMaskS=0 perElementMaskS=0 elementsPerBatch=294 */
/* optSingleColVgpr=1 optSharedColVgpr=0 optSGPRUsage=BufferLoad_Mask optSrdIncForRow=1 factorDim=0 */

/******************************************/
/* Global Write Batch #0 (d1,d0,vc1,vc0) = */
/*    (0,0,0,0:vw1); (0,1,0,0:vw1); (0,0,1,0:vw1); (0,1,1,0:vw1); (0,0,2,0:vw1); (0,1,2,0:vw1); (0,0,3,0:vw1); (0,1,3,0:vw1); (0,0,4,0:vw1); (0,1,4,0:vw1); (0,0,5,0:vw1); (0,1,5,0:vw1); (0,0,6,0:vw1); (0,1,6,0:vw1); (0,0,7,0:vw1); (0,1,7,0:vw1); (0,0,8,0:vw1); (0,1,8,0:vw1); (0,0,9,0:vw1); (0,1,9,0:vw1); (0,0,10,0:vw1); (0,1,10,0:vw1); (0,0,11,0:vw1); (0,1,11,0:vw1); (0,0,12,0:vw1); (0,1,12,0:vw1); (0,0,13,0:vw1); (0,1,13,0:vw1); (0,0,14,0:vw1); (0,1,14,0:vw1); (0,0,15,0:vw1); (0,1,15,0:vw1) */
/******************************************/

/* calc coords, apply mask, and issue loads (if necessary) */
/* (d1,vc1,d0,vc0)=(0,0,0,0) */
/* (d1,vc1,d0,vc0)=(0,0,1,0) */
/* (d1,vc1,d0,vc0)=(0,1,0,0) */
/* (d1,vc1,d0,vc0)=(0,1,1,0) */
/* (d1,vc1,d0,vc0)=(0,2,0,0) */
/* (d1,vc1,d0,vc0)=(0,2,1,0) */
/* (d1,vc1,d0,vc0)=(0,3,0,0) */
/* (d1,vc1,d0,vc0)=(0,3,1,0) */
/* (d1,vc1,d0,vc0)=(0,4,0,0) */
/* (d1,vc1,d0,vc0)=(0,4,1,0) */
/* (d1,vc1,d0,vc0)=(0,5,0,0) */
/* (d1,vc1,d0,vc0)=(0,5,1,0) */
/* (d1,vc1,d0,vc0)=(0,6,0,0) */
/* (d1,vc1,d0,vc0)=(0,6,1,0) */
/* (d1,vc1,d0,vc0)=(0,7,0,0) */
/* (d1,vc1,d0,vc0)=(0,7,1,0) */
/* (d1,vc1,d0,vc0)=(0,8,0,0) */
/* (d1,vc1,d0,vc0)=(0,8,1,0) */
/* (d1,vc1,d0,vc0)=(0,9,0,0) */
/* (d1,vc1,d0,vc0)=(0,9,1,0) */
/* (d1,vc1,d0,vc0)=(0,10,0,0) */
/* (d1,vc1,d0,vc0)=(0,10,1,0) */
/* (d1,vc1,d0,vc0)=(0,11,0,0) */
/* (d1,vc1,d0,vc0)=(0,11,1,0) */
/* (d1,vc1,d0,vc0)=(0,12,0,0) */
/* (d1,vc1,d0,vc0)=(0,12,1,0) */
/* (d1,vc1,d0,vc0)=(0,13,0,0) */
/* (d1,vc1,d0,vc0)=(0,13,1,0) */
/* (d1,vc1,d0,vc0)=(0,14,0,0) */
/* (d1,vc1,d0,vc0)=(0,14,1,0) */
/* (d1,vc1,d0,vc0)=(0,15,0,0) */
/* (d1,vc1,d0,vc0)=(0,15,1,0) */
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_add_lshl_u32 v7, v3, v0, 2                       // optSingleColVgpr scaleToBpe: sharedAddrVgpr <- cinRowPtr + coord0, scaled by BPE. BSHERE:coord0=0, coord0Vgpr=0 (multiple bpe)

/* rC *= alpha batchElements=[(0, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0, 1, 1, 0), (0, 0, 2, 0), (0, 1, 2, 0), (0, 0, 3, 0), (0, 1, 3, 0), (0, 0, 4, 0), (0, 1, 4, 0), (0, 0, 5, 0), (0, 1, 5, 0), (0, 0, 6, 0), (0, 1, 6, 0), (0, 0, 7, 0), (0, 1, 7, 0), (0, 0, 8, 0), (0, 1, 8, 0), (0, 0, 9, 0), (0, 1, 9, 0), (0, 0, 10, 0), (0, 1, 10, 0), (0, 0, 11, 0), (0, 1, 11, 0), (0, 0, 12, 0), (0, 1, 12, 0), (0, 0, 13, 0), (0, 1, 13, 0), (0, 0, 14, 0), (0, 1, 14, 0), (0, 0, 15, 0), (0, 1, 15, 0)] */
v_mov_b32 v[vgprValuC+33], v[vgprValuC+0]          // Rearrange MI out reg
v_mov_b32 v[vgprValuC+34], v[vgprValuC+8]          // Rearrange MI out reg
v_mov_b32 v[vgprValuC+35], v[vgprValuC+16]         // Rearrange MI out reg
v_mov_b32 v[vgprValuC+36], v[vgprValuC+24]         // Rearrange MI out reg
v_mov_b32 v[vgprValuC+37], v[vgprValuC+1]          // Rearrange MI out reg
v_mov_b32 v[vgprValuC+38], v[vgprValuC+9]          // Rearrange MI out reg
v_mov_b32 v[vgprValuC+39], v[vgprValuC+17]         // Rearrange MI out reg
v_mov_b32 v[vgprValuC+40], v[vgprValuC+25]         // Rearrange MI out reg
v_mov_b32 v[vgprValuC+41], v[vgprValuC+2]          // Rearrange MI out reg
v_mov_b32 v[vgprValuC+42], v[vgprValuC+10]         // Rearrange MI out reg
v_mov_b32 v[vgprValuC+43], v[vgprValuC+18]         // Rearrange MI out reg
v_mov_b32 v[vgprValuC+44], v[vgprValuC+26]         // Rearrange MI out reg
v_mov_b32 v[vgprValuC+45], v[vgprValuC+3]          // Rearrange MI out reg
v_mov_b32 v[vgprValuC+46], v[vgprValuC+11]         // Rearrange MI out reg
v_mov_b32 v[vgprValuC+47], v[vgprValuC+19]         // Rearrange MI out reg
v_mov_b32 v[vgprValuC+48], v[vgprValuC+27]         // Rearrange MI out reg
v_mov_b32 v[vgprValuC+49], v[vgprValuC+4]          // Rearrange MI out reg
v_mov_b32 v[vgprValuC+50], v[vgprValuC+12]         // Rearrange MI out reg
v_mov_b32 v[vgprValuC+51], v[vgprValuC+20]         // Rearrange MI out reg
v_mov_b32 v[vgprValuC+52], v[vgprValuC+28]         // Rearrange MI out reg
v_mov_b32 v[vgprValuC+53], v[vgprValuC+5]          // Rearrange MI out reg
v_mov_b32 v[vgprValuC+54], v[vgprValuC+13]         // Rearrange MI out reg
v_mov_b32 v[vgprValuC+55], v[vgprValuC+21]         // Rearrange MI out reg
v_mov_b32 v[vgprValuC+56], v[vgprValuC+29]         // Rearrange MI out reg
v_mov_b32 v[vgprValuC+57], v[vgprValuC+6]          // Rearrange MI out reg
v_mov_b32 v[vgprValuC+58], v[vgprValuC+14]         // Rearrange MI out reg
v_mov_b32 v[vgprValuC+59], v[vgprValuC+22]         // Rearrange MI out reg
v_mov_b32 v[vgprValuC+60], v[vgprValuC+30]         // Rearrange MI out reg
v_mov_b32 v[vgprValuC+61], v[vgprValuC+7]          // Rearrange MI out reg
v_mov_b32 v[vgprValuC+62], v[vgprValuC+15]         // Rearrange MI out reg
v_mov_b32 v[vgprValuC+63], v[vgprValuC+23]         // Rearrange MI out reg
v_mov_b32 v[vgprValuC+64], v[vgprValuC+31]         // Rearrange MI out reg

/* apply mask, calc new C and issue writes */
s_wait_alu depctr_va_vdst(14)
buffer_store_b32 v41, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v42, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:128 scope:SCOPE_CU th:TH_STORE_RT // store D
s_lshl_b32 s12, s[sgprStrideD1J], 2                // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_store_b32 v43, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v44, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:128 scope:SCOPE_CU th:TH_STORE_RT // store D
s_lshl_b32 s12, s[sgprStrideD1J], 2                // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_store_b32 v45, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v46, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:128 scope:SCOPE_CU th:TH_STORE_RT // store D
s_lshl_b32 s12, s[sgprStrideD1J], 2                // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_store_b32 v47, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v48, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:128 scope:SCOPE_CU th:TH_STORE_RT // store D
s_lshl_b32 s12, s[sgprStrideD1J], 2                // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_store_b32 v49, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v50, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:128 scope:SCOPE_CU th:TH_STORE_RT // store D
s_lshl_b32 s12, s[sgprStrideD1J], 2                // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_store_b32 v51, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v52, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:128 scope:SCOPE_CU th:TH_STORE_RT // store D
s_lshl_b32 s12, s[sgprStrideD1J], 2                // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_store_b32 v53, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v54, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:128 scope:SCOPE_CU th:TH_STORE_RT // store D
s_lshl_b32 s12, s[sgprStrideD1J], 2                // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_store_b32 v55, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v56, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:128 scope:SCOPE_CU th:TH_STORE_RT // store D
s_lshl_b32 s12, s[sgprStrideD1J], 2                // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_store_b32 v57, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v58, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:128 scope:SCOPE_CU th:TH_STORE_RT // store D
s_lshl_b32 s12, s[sgprStrideD1J], 2                // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_wait_alu depctr_va_vdst(13)
buffer_store_b32 v59, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(12)
buffer_store_b32 v60, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:128 scope:SCOPE_CU th:TH_STORE_RT // store D
s_lshl_b32 s12, s[sgprStrideD1J], 2                // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_wait_alu depctr_va_vdst(11)
buffer_store_b32 v61, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(10)
buffer_store_b32 v62, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:128 scope:SCOPE_CU th:TH_STORE_RT // store D
s_lshl_b32 s12, s[sgprStrideD1J], 2                // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_wait_alu depctr_va_vdst(9)
buffer_store_b32 v63, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(8)
buffer_store_b32 v64, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:128 scope:SCOPE_CU th:TH_STORE_RT // store D
s_lshl_b32 s12, s[sgprStrideD1J], 2                // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_wait_alu depctr_va_vdst(7)
buffer_store_b32 v65, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(6)
buffer_store_b32 v66, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:128 scope:SCOPE_CU th:TH_STORE_RT // store D
s_lshl_b32 s12, s[sgprStrideD1J], 2                // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_wait_alu depctr_va_vdst(5)
buffer_store_b32 v67, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(4)
buffer_store_b32 v68, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:128 scope:SCOPE_CU th:TH_STORE_RT // store D
s_lshl_b32 s12, s[sgprStrideD1J], 2                // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_wait_alu depctr_va_vdst(3)
buffer_store_b32 v69, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(2)
buffer_store_b32 v70, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:128 scope:SCOPE_CU th:TH_STORE_RT // store D
s_lshl_b32 s12, s[sgprStrideD1J], 2                // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_wait_alu depctr_va_vdst(1)
buffer_store_b32 v71, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v72, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:128 scope:SCOPE_CU th:TH_STORE_RT // store D
s_nop 0                                            // 1 wait state required when next inst writes vgprs held by previous dwordx4 store inst
s_branch label_GW_End                              // jump to end
label_GW_B0_FD0_VW1_MB_NonEdgeEnd:
label_GW_B0_FD0_VW1_MB_Else:
label_GW_B0_FD0_VW1_MB_Then:

/* edge=1, allocate 3 sgpr. perBatchTmpS=2 perBatchMaskS=1 perElementMaskS=0 elementsPerBatch=147 */
/* optSingleColVgpr=0 optSharedColVgpr=0 optSGPRUsage=BufferLoad_Edge_Mask optSrdIncForRow=0 factorDim=0 */

/******************************************/
/* Global Write Edge Batch #0 (d1,d0,vc1,vc0) = */
/*    (0,0,0,0:vw1); (0,1,0,0:vw1); (0,0,1,0:vw1); (0,1,1,0:vw1); (0,0,2,0:vw1); (0,1,2,0:vw1); (0,0,3,0:vw1); (0,1,3,0:vw1); (0,0,4,0:vw1); (0,1,4,0:vw1); (0,0,5,0:vw1); (0,1,5,0:vw1); (0,0,6,0:vw1); (0,1,6,0:vw1); (0,0,7,0:vw1); (0,1,7,0:vw1); (0,0,8,0:vw1); (0,1,8,0:vw1); (0,0,9,0:vw1); (0,1,9,0:vw1); (0,0,10,0:vw1); (0,1,10,0:vw1); (0,0,11,0:vw1); (0,1,11,0:vw1); (0,0,12,0:vw1); (0,1,12,0:vw1); (0,0,13,0:vw1); (0,1,13,0:vw1); (0,0,14,0:vw1); (0,1,14,0:vw1); (0,0,15,0:vw1); (0,1,15,0:vw1) */
/******************************************/

/* calc coords, apply mask, and issue loads (if necessary) */
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v6, BufferOOB
/* (d1,vc1,d0,vc0)=(0,0,0,0) */
v_cmp_lt_u32 s12, v0, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v71, v3, v0, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v71, v6, v71, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,1,0) */
v_add_co_u32 v4, vcc_lo, v0, 32                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v72, v3, v4, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v72, v6, v72, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,0,0) */
v_add_co_u32 v1, vcc_lo, v1, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v2, v2, s[sgprStrideC1J]              // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v3, v3, s[sgprStrideD1J]              // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v0, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v73, v3, v0, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v73, v6, v73, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,1,0) */
v_add_co_u32 v4, vcc_lo, v0, 32                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v74, v3, v4, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v74, v6, v74, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,0,0) */
v_add_co_u32 v1, vcc_lo, v1, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v2, v2, s[sgprStrideC1J]              // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v3, v3, s[sgprStrideD1J]              // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v0, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v75, v3, v0, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v75, v6, v75, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,1,0) */
v_add_co_u32 v4, vcc_lo, v0, 32                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v76, v3, v4, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v76, v6, v76, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,0,0) */
v_add_co_u32 v1, vcc_lo, v1, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v2, v2, s[sgprStrideC1J]              // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v3, v3, s[sgprStrideD1J]              // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v0, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v77, v3, v0, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v77, v6, v77, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,1,0) */
v_add_co_u32 v4, vcc_lo, v0, 32                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v78, v3, v4, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v78, v6, v78, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,4,0,0) */
v_add_co_u32 v1, vcc_lo, v1, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v2, v2, s[sgprStrideC1J]              // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v3, v3, s[sgprStrideD1J]              // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v0, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v79, v3, v0, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v79, v6, v79, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,4,1,0) */
v_add_co_u32 v4, vcc_lo, v0, 32                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v80, v3, v4, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v80, v6, v80, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,5,0,0) */
v_add_co_u32 v1, vcc_lo, v1, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v2, v2, s[sgprStrideC1J]              // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v3, v3, s[sgprStrideD1J]              // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v0, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v81, v3, v0, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v81, v6, v81, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,5,1,0) */
v_add_co_u32 v4, vcc_lo, v0, 32                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v82, v3, v4, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v82, v6, v82, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,6,0,0) */
v_add_co_u32 v1, vcc_lo, v1, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v2, v2, s[sgprStrideC1J]              // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v3, v3, s[sgprStrideD1J]              // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v0, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v83, v3, v0, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v83, v6, v83, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,6,1,0) */
v_add_co_u32 v4, vcc_lo, v0, 32                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v84, v3, v4, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v84, v6, v84, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,7,0,0) */
v_add_co_u32 v1, vcc_lo, v1, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v2, v2, s[sgprStrideC1J]              // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v3, v3, s[sgprStrideD1J]              // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v0, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v85, v3, v0, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v85, v6, v85, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,7,1,0) */
v_add_co_u32 v4, vcc_lo, v0, 32                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v86, v3, v4, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v86, v6, v86, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,8,0,0) */
v_add_co_u32 v1, vcc_lo, v1, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v2, v2, s[sgprStrideC1J]              // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v3, v3, s[sgprStrideD1J]              // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v0, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v87, v3, v0, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v87, v6, v87, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,8,1,0) */
v_add_co_u32 v4, vcc_lo, v0, 32                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v88, v3, v4, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v88, v6, v88, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,9,0,0) */
v_add_co_u32 v1, vcc_lo, v1, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v2, v2, s[sgprStrideC1J]              // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v3, v3, s[sgprStrideD1J]              // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v0, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v89, v3, v0, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v89, v6, v89, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,9,1,0) */
v_add_co_u32 v4, vcc_lo, v0, 32                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v90, v3, v4, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v90, v6, v90, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,10,0,0) */
v_add_co_u32 v1, vcc_lo, v1, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v2, v2, s[sgprStrideC1J]              // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v3, v3, s[sgprStrideD1J]              // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v0, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v91, v3, v0, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v91, v6, v91, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,10,1,0) */
v_add_co_u32 v4, vcc_lo, v0, 32                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v92, v3, v4, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v92, v6, v92, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,11,0,0) */
v_add_co_u32 v1, vcc_lo, v1, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v2, v2, s[sgprStrideC1J]              // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v3, v3, s[sgprStrideD1J]              // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v0, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v93, v3, v0, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v93, v6, v93, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,11,1,0) */
v_add_co_u32 v4, vcc_lo, v0, 32                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v94, v3, v4, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v94, v6, v94, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,12,0,0) */
v_add_co_u32 v1, vcc_lo, v1, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v2, v2, s[sgprStrideC1J]              // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v3, v3, s[sgprStrideD1J]              // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v0, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v95, v3, v0, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v95, v6, v95, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,12,1,0) */
v_add_co_u32 v4, vcc_lo, v0, 32                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v96, v3, v4, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v96, v6, v96, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,13,0,0) */
v_add_co_u32 v1, vcc_lo, v1, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v2, v2, s[sgprStrideC1J]              // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v3, v3, s[sgprStrideD1J]              // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v0, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v97, v3, v0, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v97, v6, v97, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,13,1,0) */
v_add_co_u32 v4, vcc_lo, v0, 32                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v98, v3, v4, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v98, v6, v98, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,14,0,0) */
v_add_co_u32 v1, vcc_lo, v1, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v2, v2, s[sgprStrideC1J]              // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v3, v3, s[sgprStrideD1J]              // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v0, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v99, v3, v0, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v99, v6, v99, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,14,1,0) */
v_add_co_u32 v4, vcc_lo, v0, 32                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v100, v3, v4, 2                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v100, v6, v100, s14                  // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,15,0,0) */
v_add_co_u32 v1, vcc_lo, v1, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v2, v2, s[sgprStrideC1J]              // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v3, v3, s[sgprStrideD1J]              // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v0, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v101, v3, v0, 2                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v101, v6, v101, s14                  // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,15,1,0) */
v_add_co_u32 v4, vcc_lo, v0, 32                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v102, v3, v4, 2                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v102, v6, v102, s14                  // LDD clip if OOB. offset

/* rC *= alpha batchElements=[(0, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0, 1, 1, 0), (0, 0, 2, 0), (0, 1, 2, 0), (0, 0, 3, 0), (0, 1, 3, 0), (0, 0, 4, 0), (0, 1, 4, 0), (0, 0, 5, 0), (0, 1, 5, 0), (0, 0, 6, 0), (0, 1, 6, 0), (0, 0, 7, 0), (0, 1, 7, 0), (0, 0, 8, 0), (0, 1, 8, 0), (0, 0, 9, 0), (0, 1, 9, 0), (0, 0, 10, 0), (0, 1, 10, 0), (0, 0, 11, 0), (0, 1, 11, 0), (0, 0, 12, 0), (0, 1, 12, 0), (0, 0, 13, 0), (0, 1, 13, 0), (0, 0, 14, 0), (0, 1, 14, 0), (0, 0, 15, 0), (0, 1, 15, 0)] */
v_mov_b32 v[vgprValuC+-1], v[vgprValuC+0]          // Rearrange MI out reg
v_mov_b32 v[vgprValuC+32], v[vgprValuC+8]          // Rearrange MI out reg
v_mov_b32 v[vgprValuC+33], v[vgprValuC+16]         // Rearrange MI out reg
v_mov_b32 v[vgprValuC+34], v[vgprValuC+24]         // Rearrange MI out reg
v_mov_b32 v[vgprValuC+35], v[vgprValuC+1]          // Rearrange MI out reg
v_mov_b32 v[vgprValuC+36], v[vgprValuC+9]          // Rearrange MI out reg
v_mov_b32 v[vgprValuC+37], v[vgprValuC+17]         // Rearrange MI out reg
v_mov_b32 v[vgprValuC+38], v[vgprValuC+25]         // Rearrange MI out reg
v_mov_b32 v[vgprValuC+39], v[vgprValuC+2]          // Rearrange MI out reg
v_mov_b32 v[vgprValuC+40], v[vgprValuC+10]         // Rearrange MI out reg
v_mov_b32 v[vgprValuC+41], v[vgprValuC+18]         // Rearrange MI out reg
v_mov_b32 v[vgprValuC+42], v[vgprValuC+26]         // Rearrange MI out reg
v_mov_b32 v[vgprValuC+43], v[vgprValuC+3]          // Rearrange MI out reg
v_mov_b32 v[vgprValuC+44], v[vgprValuC+11]         // Rearrange MI out reg
v_mov_b32 v[vgprValuC+45], v[vgprValuC+19]         // Rearrange MI out reg
v_mov_b32 v[vgprValuC+46], v[vgprValuC+27]         // Rearrange MI out reg
v_mov_b32 v[vgprValuC+47], v[vgprValuC+4]          // Rearrange MI out reg
v_mov_b32 v[vgprValuC+48], v[vgprValuC+12]         // Rearrange MI out reg
v_mov_b32 v[vgprValuC+49], v[vgprValuC+20]         // Rearrange MI out reg
v_mov_b32 v[vgprValuC+50], v[vgprValuC+28]         // Rearrange MI out reg
v_mov_b32 v[vgprValuC+51], v[vgprValuC+5]          // Rearrange MI out reg
v_mov_b32 v[vgprValuC+52], v[vgprValuC+13]         // Rearrange MI out reg
v_mov_b32 v[vgprValuC+53], v[vgprValuC+21]         // Rearrange MI out reg
v_mov_b32 v[vgprValuC+54], v[vgprValuC+29]         // Rearrange MI out reg
v_mov_b32 v[vgprValuC+55], v[vgprValuC+6]          // Rearrange MI out reg
v_mov_b32 v[vgprValuC+56], v[vgprValuC+14]         // Rearrange MI out reg
v_mov_b32 v[vgprValuC+57], v[vgprValuC+22]         // Rearrange MI out reg
v_mov_b32 v[vgprValuC+58], v[vgprValuC+30]         // Rearrange MI out reg
v_mov_b32 v[vgprValuC+59], v[vgprValuC+7]          // Rearrange MI out reg
v_mov_b32 v[vgprValuC+60], v[vgprValuC+15]         // Rearrange MI out reg
v_mov_b32 v[vgprValuC+61], v[vgprValuC+23]         // Rearrange MI out reg
v_mov_b32 v[vgprValuC+62], v[vgprValuC+31]         // Rearrange MI out reg

/* apply mask, calc new C and issue writes */
s_wait_alu depctr_va_vdst(14)
buffer_store_b32 v7, v71, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v40, v72, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v41, v73, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v42, v74, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v43, v75, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v44, v76, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v45, v77, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v46, v78, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v47, v79, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v48, v80, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v49, v81, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v50, v82, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v51, v83, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v52, v84, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v53, v85, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v54, v86, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v55, v87, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v56, v88, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(13)
buffer_store_b32 v57, v89, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(12)
buffer_store_b32 v58, v90, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(11)
buffer_store_b32 v59, v91, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(10)
buffer_store_b32 v60, v92, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(9)
buffer_store_b32 v61, v93, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(8)
buffer_store_b32 v62, v94, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(7)
buffer_store_b32 v63, v95, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(6)
buffer_store_b32 v64, v96, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(5)
buffer_store_b32 v65, v97, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(4)
buffer_store_b32 v66, v98, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(3)
buffer_store_b32 v67, v99, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(2)
buffer_store_b32 v68, v100, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(1)
buffer_store_b32 v69, v101, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v70, v102, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
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

/* Edge/NonEdge store path check (M): Size % 64 > 0 -> Edge store; else -> NonEdge store */
s_and_b32 s28, 63, s[sgprSizeI]                    // s28 = s[sgprSizeI] % 64
s_add_u32 s29, -0x1, s[sgprNumWorkGroups0]
s_cmp_ge_u32 s[sgprWorkGroup0], s29                // wg0 >= nwg0-1 ?
s_cselect_b32 s28, s28, 0                          // set rem
s_mov_b32 s5, 0
s_cmp_gt_u32 s28, s5                               // rem > 0
s_cbranch_scc1 label_GW_B0_FD0_VW1_GSU1_Else       // jump if edges required

/* Edge/NonEdge store path check (N (isSize1)): Size % 64 > 0 -> Edge store; else -> NonEdge store */
s_and_b32 s28, 63, s[sgprSizeJ]                    // s28 = s[sgprSizeJ] % 64
s_add_u32 s29, -0x1, s[sgprNumWorkGroups1]
s_cmp_ge_u32 s[sgprWorkGroup1], s29                // wg1 >= nwg1-1
s_cselect_b32 s28, s28, 0                          // set rem
s_mov_b32 s5, 0
s_cmp_gt_u32 s28, s5                               // rem > 0
s_cbranch_scc1 label_GW_B0_FD0_VW1_GSU1_Then       // jump if edges required
label_GW_B0_FD0_VW1_GSU1_NonEdge:

/* edge=0, allocate 1 sgpr. perBatchTmpS=1 perBatchMaskS=0 perElementMaskS=0 elementsPerBatch=294 */
/* optSingleColVgpr=1 optSharedColVgpr=0 optSGPRUsage=BufferLoad_Mask optSrdIncForRow=1 factorDim=0 */

/******************************************/
/* Global Write Batch #0 (d1,d0,vc1,vc0) = */
/*    (0,0,0,0:vw1); (0,1,0,0:vw1); (0,0,1,0:vw1); (0,1,1,0:vw1); (0,0,2,0:vw1); (0,1,2,0:vw1); (0,0,3,0:vw1); (0,1,3,0:vw1); (0,0,4,0:vw1); (0,1,4,0:vw1); (0,0,5,0:vw1); (0,1,5,0:vw1); (0,0,6,0:vw1); (0,1,6,0:vw1); (0,0,7,0:vw1); (0,1,7,0:vw1); (0,0,8,0:vw1); (0,1,8,0:vw1); (0,0,9,0:vw1); (0,1,9,0:vw1); (0,0,10,0:vw1); (0,1,10,0:vw1); (0,0,11,0:vw1); (0,1,11,0:vw1); (0,0,12,0:vw1); (0,1,12,0:vw1); (0,0,13,0:vw1); (0,1,13,0:vw1); (0,0,14,0:vw1); (0,1,14,0:vw1); (0,0,15,0:vw1); (0,1,15,0:vw1) */
/******************************************/

/* calc coords, apply mask, and issue loads (if necessary) */
/* (d1,vc1,d0,vc0)=(0,0,0,0) */
/* (d1,vc1,d0,vc0)=(0,0,1,0) */
/* (d1,vc1,d0,vc0)=(0,1,0,0) */
/* (d1,vc1,d0,vc0)=(0,1,1,0) */
/* (d1,vc1,d0,vc0)=(0,2,0,0) */
/* (d1,vc1,d0,vc0)=(0,2,1,0) */
/* (d1,vc1,d0,vc0)=(0,3,0,0) */
/* (d1,vc1,d0,vc0)=(0,3,1,0) */
/* (d1,vc1,d0,vc0)=(0,4,0,0) */
/* (d1,vc1,d0,vc0)=(0,4,1,0) */
/* (d1,vc1,d0,vc0)=(0,5,0,0) */
/* (d1,vc1,d0,vc0)=(0,5,1,0) */
/* (d1,vc1,d0,vc0)=(0,6,0,0) */
/* (d1,vc1,d0,vc0)=(0,6,1,0) */
/* (d1,vc1,d0,vc0)=(0,7,0,0) */
/* (d1,vc1,d0,vc0)=(0,7,1,0) */
/* (d1,vc1,d0,vc0)=(0,8,0,0) */
/* (d1,vc1,d0,vc0)=(0,8,1,0) */
/* (d1,vc1,d0,vc0)=(0,9,0,0) */
/* (d1,vc1,d0,vc0)=(0,9,1,0) */
/* (d1,vc1,d0,vc0)=(0,10,0,0) */
/* (d1,vc1,d0,vc0)=(0,10,1,0) */
/* (d1,vc1,d0,vc0)=(0,11,0,0) */
/* (d1,vc1,d0,vc0)=(0,11,1,0) */
/* (d1,vc1,d0,vc0)=(0,12,0,0) */
/* (d1,vc1,d0,vc0)=(0,12,1,0) */
/* (d1,vc1,d0,vc0)=(0,13,0,0) */
/* (d1,vc1,d0,vc0)=(0,13,1,0) */
/* (d1,vc1,d0,vc0)=(0,14,0,0) */
/* (d1,vc1,d0,vc0)=(0,14,1,0) */
/* (d1,vc1,d0,vc0)=(0,15,0,0) */
/* (d1,vc1,d0,vc0)=(0,15,1,0) */
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_add_lshl_u32 v7, v3, v0, 2                       // optSingleColVgpr scaleToBpe: sharedAddrVgpr <- cinRowPtr + coord0, scaled by BPE. BSHERE:coord0=0, coord0Vgpr=0 (multiple bpe)

/* rC *= alpha batchElements=[(0, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0, 1, 1, 0), (0, 0, 2, 0), (0, 1, 2, 0), (0, 0, 3, 0), (0, 1, 3, 0), (0, 0, 4, 0), (0, 1, 4, 0), (0, 0, 5, 0), (0, 1, 5, 0), (0, 0, 6, 0), (0, 1, 6, 0), (0, 0, 7, 0), (0, 1, 7, 0), (0, 0, 8, 0), (0, 1, 8, 0), (0, 0, 9, 0), (0, 1, 9, 0), (0, 0, 10, 0), (0, 1, 10, 0), (0, 0, 11, 0), (0, 1, 11, 0), (0, 0, 12, 0), (0, 1, 12, 0), (0, 0, 13, 0), (0, 1, 13, 0), (0, 0, 14, 0), (0, 1, 14, 0), (0, 0, 15, 0), (0, 1, 15, 0)] */
v_mul_f32 v[vgprValuC+33], s[sgprAlpha], v[vgprValuC+0] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+34], s[sgprAlpha], v[vgprValuC+8] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+35], s[sgprAlpha], v[vgprValuC+16] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+36], s[sgprAlpha], v[vgprValuC+24] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+37], s[sgprAlpha], v[vgprValuC+1] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+38], s[sgprAlpha], v[vgprValuC+9] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+39], s[sgprAlpha], v[vgprValuC+17] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+40], s[sgprAlpha], v[vgprValuC+25] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+41], s[sgprAlpha], v[vgprValuC+2] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+42], s[sgprAlpha], v[vgprValuC+10] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+43], s[sgprAlpha], v[vgprValuC+18] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+44], s[sgprAlpha], v[vgprValuC+26] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+45], s[sgprAlpha], v[vgprValuC+3] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+46], s[sgprAlpha], v[vgprValuC+11] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+47], s[sgprAlpha], v[vgprValuC+19] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+48], s[sgprAlpha], v[vgprValuC+27] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+49], s[sgprAlpha], v[vgprValuC+4] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+50], s[sgprAlpha], v[vgprValuC+12] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+51], s[sgprAlpha], v[vgprValuC+20] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+52], s[sgprAlpha], v[vgprValuC+28] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+53], s[sgprAlpha], v[vgprValuC+5] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+54], s[sgprAlpha], v[vgprValuC+13] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+55], s[sgprAlpha], v[vgprValuC+21] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+56], s[sgprAlpha], v[vgprValuC+29] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+57], s[sgprAlpha], v[vgprValuC+6] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+58], s[sgprAlpha], v[vgprValuC+14] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+59], s[sgprAlpha], v[vgprValuC+22] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+60], s[sgprAlpha], v[vgprValuC+30] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+61], s[sgprAlpha], v[vgprValuC+7] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+62], s[sgprAlpha], v[vgprValuC+15] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+63], s[sgprAlpha], v[vgprValuC+23] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+64], s[sgprAlpha], v[vgprValuC+31] // Multiply MI out reg with alpha

/* apply mask, calc new C and issue writes */
s_wait_alu depctr_va_vdst(14)
buffer_store_b32 v41, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v42, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:128 scope:SCOPE_CU th:TH_STORE_RT // store D
s_lshl_b32 s12, s[sgprStrideD1J], 2                // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_store_b32 v43, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v44, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:128 scope:SCOPE_CU th:TH_STORE_RT // store D
s_lshl_b32 s12, s[sgprStrideD1J], 2                // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_store_b32 v45, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v46, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:128 scope:SCOPE_CU th:TH_STORE_RT // store D
s_lshl_b32 s12, s[sgprStrideD1J], 2                // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_store_b32 v47, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v48, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:128 scope:SCOPE_CU th:TH_STORE_RT // store D
s_lshl_b32 s12, s[sgprStrideD1J], 2                // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_store_b32 v49, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v50, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:128 scope:SCOPE_CU th:TH_STORE_RT // store D
s_lshl_b32 s12, s[sgprStrideD1J], 2                // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_store_b32 v51, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v52, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:128 scope:SCOPE_CU th:TH_STORE_RT // store D
s_lshl_b32 s12, s[sgprStrideD1J], 2                // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_store_b32 v53, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v54, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:128 scope:SCOPE_CU th:TH_STORE_RT // store D
s_lshl_b32 s12, s[sgprStrideD1J], 2                // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_store_b32 v55, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v56, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:128 scope:SCOPE_CU th:TH_STORE_RT // store D
s_lshl_b32 s12, s[sgprStrideD1J], 2                // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_store_b32 v57, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v58, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:128 scope:SCOPE_CU th:TH_STORE_RT // store D
s_lshl_b32 s12, s[sgprStrideD1J], 2                // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_wait_alu depctr_va_vdst(13)
buffer_store_b32 v59, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(12)
buffer_store_b32 v60, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:128 scope:SCOPE_CU th:TH_STORE_RT // store D
s_lshl_b32 s12, s[sgprStrideD1J], 2                // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_wait_alu depctr_va_vdst(11)
buffer_store_b32 v61, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(10)
buffer_store_b32 v62, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:128 scope:SCOPE_CU th:TH_STORE_RT // store D
s_lshl_b32 s12, s[sgprStrideD1J], 2                // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_wait_alu depctr_va_vdst(9)
buffer_store_b32 v63, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(8)
buffer_store_b32 v64, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:128 scope:SCOPE_CU th:TH_STORE_RT // store D
s_lshl_b32 s12, s[sgprStrideD1J], 2                // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_wait_alu depctr_va_vdst(7)
buffer_store_b32 v65, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(6)
buffer_store_b32 v66, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:128 scope:SCOPE_CU th:TH_STORE_RT // store D
s_lshl_b32 s12, s[sgprStrideD1J], 2                // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_wait_alu depctr_va_vdst(5)
buffer_store_b32 v67, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(4)
buffer_store_b32 v68, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:128 scope:SCOPE_CU th:TH_STORE_RT // store D
s_lshl_b32 s12, s[sgprStrideD1J], 2                // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_wait_alu depctr_va_vdst(3)
buffer_store_b32 v69, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(2)
buffer_store_b32 v70, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:128 scope:SCOPE_CU th:TH_STORE_RT // store D
s_lshl_b32 s12, s[sgprStrideD1J], 2                // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_wait_alu depctr_va_vdst(1)
buffer_store_b32 v71, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v72, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:128 scope:SCOPE_CU th:TH_STORE_RT // store D
s_nop 0                                            // 1 wait state required when next inst writes vgprs held by previous dwordx4 store inst
s_branch label_GW_End_1                            // jump to end
label_GW_B0_FD0_VW1_GSU1_NonEdgeEnd:
label_GW_B0_FD0_VW1_GSU1_Else:
label_GW_B0_FD0_VW1_GSU1_Then:

/* edge=1, allocate 3 sgpr. perBatchTmpS=2 perBatchMaskS=1 perElementMaskS=0 elementsPerBatch=147 */
/* optSingleColVgpr=0 optSharedColVgpr=0 optSGPRUsage=BufferLoad_Edge_Mask optSrdIncForRow=0 factorDim=0 */

/******************************************/
/* Global Write Edge Batch #0 (d1,d0,vc1,vc0) = */
/*    (0,0,0,0:vw1); (0,1,0,0:vw1); (0,0,1,0:vw1); (0,1,1,0:vw1); (0,0,2,0:vw1); (0,1,2,0:vw1); (0,0,3,0:vw1); (0,1,3,0:vw1); (0,0,4,0:vw1); (0,1,4,0:vw1); (0,0,5,0:vw1); (0,1,5,0:vw1); (0,0,6,0:vw1); (0,1,6,0:vw1); (0,0,7,0:vw1); (0,1,7,0:vw1); (0,0,8,0:vw1); (0,1,8,0:vw1); (0,0,9,0:vw1); (0,1,9,0:vw1); (0,0,10,0:vw1); (0,1,10,0:vw1); (0,0,11,0:vw1); (0,1,11,0:vw1); (0,0,12,0:vw1); (0,1,12,0:vw1); (0,0,13,0:vw1); (0,1,13,0:vw1); (0,0,14,0:vw1); (0,1,14,0:vw1); (0,0,15,0:vw1); (0,1,15,0:vw1) */
/******************************************/

/* calc coords, apply mask, and issue loads (if necessary) */
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v6, BufferOOB
/* (d1,vc1,d0,vc0)=(0,0,0,0) */
v_cmp_lt_u32 s12, v0, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v71, v3, v0, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v71, v6, v71, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,1,0) */
v_add_co_u32 v4, vcc_lo, v0, 32                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v72, v3, v4, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v72, v6, v72, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,0,0) */
v_add_co_u32 v1, vcc_lo, v1, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v2, v2, s[sgprStrideC1J]              // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v3, v3, s[sgprStrideD1J]              // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v0, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v73, v3, v0, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v73, v6, v73, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,1,0) */
v_add_co_u32 v4, vcc_lo, v0, 32                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v74, v3, v4, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v74, v6, v74, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,0,0) */
v_add_co_u32 v1, vcc_lo, v1, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v2, v2, s[sgprStrideC1J]              // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v3, v3, s[sgprStrideD1J]              // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v0, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v75, v3, v0, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v75, v6, v75, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,1,0) */
v_add_co_u32 v4, vcc_lo, v0, 32                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v76, v3, v4, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v76, v6, v76, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,0,0) */
v_add_co_u32 v1, vcc_lo, v1, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v2, v2, s[sgprStrideC1J]              // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v3, v3, s[sgprStrideD1J]              // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v0, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v77, v3, v0, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v77, v6, v77, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,1,0) */
v_add_co_u32 v4, vcc_lo, v0, 32                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v78, v3, v4, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v78, v6, v78, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,4,0,0) */
v_add_co_u32 v1, vcc_lo, v1, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v2, v2, s[sgprStrideC1J]              // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v3, v3, s[sgprStrideD1J]              // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v0, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v79, v3, v0, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v79, v6, v79, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,4,1,0) */
v_add_co_u32 v4, vcc_lo, v0, 32                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v80, v3, v4, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v80, v6, v80, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,5,0,0) */
v_add_co_u32 v1, vcc_lo, v1, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v2, v2, s[sgprStrideC1J]              // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v3, v3, s[sgprStrideD1J]              // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v0, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v81, v3, v0, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v81, v6, v81, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,5,1,0) */
v_add_co_u32 v4, vcc_lo, v0, 32                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v82, v3, v4, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v82, v6, v82, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,6,0,0) */
v_add_co_u32 v1, vcc_lo, v1, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v2, v2, s[sgprStrideC1J]              // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v3, v3, s[sgprStrideD1J]              // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v0, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v83, v3, v0, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v83, v6, v83, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,6,1,0) */
v_add_co_u32 v4, vcc_lo, v0, 32                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v84, v3, v4, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v84, v6, v84, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,7,0,0) */
v_add_co_u32 v1, vcc_lo, v1, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v2, v2, s[sgprStrideC1J]              // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v3, v3, s[sgprStrideD1J]              // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v0, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v85, v3, v0, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v85, v6, v85, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,7,1,0) */
v_add_co_u32 v4, vcc_lo, v0, 32                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v86, v3, v4, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v86, v6, v86, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,8,0,0) */
v_add_co_u32 v1, vcc_lo, v1, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v2, v2, s[sgprStrideC1J]              // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v3, v3, s[sgprStrideD1J]              // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v0, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v87, v3, v0, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v87, v6, v87, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,8,1,0) */
v_add_co_u32 v4, vcc_lo, v0, 32                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v88, v3, v4, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v88, v6, v88, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,9,0,0) */
v_add_co_u32 v1, vcc_lo, v1, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v2, v2, s[sgprStrideC1J]              // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v3, v3, s[sgprStrideD1J]              // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v0, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v89, v3, v0, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v89, v6, v89, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,9,1,0) */
v_add_co_u32 v4, vcc_lo, v0, 32                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v90, v3, v4, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v90, v6, v90, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,10,0,0) */
v_add_co_u32 v1, vcc_lo, v1, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v2, v2, s[sgprStrideC1J]              // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v3, v3, s[sgprStrideD1J]              // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v0, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v91, v3, v0, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v91, v6, v91, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,10,1,0) */
v_add_co_u32 v4, vcc_lo, v0, 32                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v92, v3, v4, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v92, v6, v92, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,11,0,0) */
v_add_co_u32 v1, vcc_lo, v1, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v2, v2, s[sgprStrideC1J]              // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v3, v3, s[sgprStrideD1J]              // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v0, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v93, v3, v0, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v93, v6, v93, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,11,1,0) */
v_add_co_u32 v4, vcc_lo, v0, 32                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v94, v3, v4, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v94, v6, v94, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,12,0,0) */
v_add_co_u32 v1, vcc_lo, v1, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v2, v2, s[sgprStrideC1J]              // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v3, v3, s[sgprStrideD1J]              // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v0, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v95, v3, v0, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v95, v6, v95, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,12,1,0) */
v_add_co_u32 v4, vcc_lo, v0, 32                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v96, v3, v4, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v96, v6, v96, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,13,0,0) */
v_add_co_u32 v1, vcc_lo, v1, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v2, v2, s[sgprStrideC1J]              // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v3, v3, s[sgprStrideD1J]              // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v0, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v97, v3, v0, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v97, v6, v97, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,13,1,0) */
v_add_co_u32 v4, vcc_lo, v0, 32                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v98, v3, v4, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v98, v6, v98, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,14,0,0) */
v_add_co_u32 v1, vcc_lo, v1, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v2, v2, s[sgprStrideC1J]              // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v3, v3, s[sgprStrideD1J]              // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v0, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v99, v3, v0, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v99, v6, v99, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,14,1,0) */
v_add_co_u32 v4, vcc_lo, v0, 32                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v100, v3, v4, 2                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v100, v6, v100, s14                  // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,15,0,0) */
v_add_co_u32 v1, vcc_lo, v1, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v2, v2, s[sgprStrideC1J]              // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v3, v3, s[sgprStrideD1J]              // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v0, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v101, v3, v0, 2                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v101, v6, v101, s14                  // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,15,1,0) */
v_add_co_u32 v4, vcc_lo, v0, 32                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v102, v3, v4, 2                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v102, v6, v102, s14                  // LDD clip if OOB. offset

/* rC *= alpha batchElements=[(0, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0, 1, 1, 0), (0, 0, 2, 0), (0, 1, 2, 0), (0, 0, 3, 0), (0, 1, 3, 0), (0, 0, 4, 0), (0, 1, 4, 0), (0, 0, 5, 0), (0, 1, 5, 0), (0, 0, 6, 0), (0, 1, 6, 0), (0, 0, 7, 0), (0, 1, 7, 0), (0, 0, 8, 0), (0, 1, 8, 0), (0, 0, 9, 0), (0, 1, 9, 0), (0, 0, 10, 0), (0, 1, 10, 0), (0, 0, 11, 0), (0, 1, 11, 0), (0, 0, 12, 0), (0, 1, 12, 0), (0, 0, 13, 0), (0, 1, 13, 0), (0, 0, 14, 0), (0, 1, 14, 0), (0, 0, 15, 0), (0, 1, 15, 0)] */
v_mul_f32 v[vgprValuC+-1], s[sgprAlpha], v[vgprValuC+0] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+32], s[sgprAlpha], v[vgprValuC+8] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+33], s[sgprAlpha], v[vgprValuC+16] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+34], s[sgprAlpha], v[vgprValuC+24] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+35], s[sgprAlpha], v[vgprValuC+1] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+36], s[sgprAlpha], v[vgprValuC+9] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+37], s[sgprAlpha], v[vgprValuC+17] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+38], s[sgprAlpha], v[vgprValuC+25] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+39], s[sgprAlpha], v[vgprValuC+2] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+40], s[sgprAlpha], v[vgprValuC+10] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+41], s[sgprAlpha], v[vgprValuC+18] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+42], s[sgprAlpha], v[vgprValuC+26] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+43], s[sgprAlpha], v[vgprValuC+3] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+44], s[sgprAlpha], v[vgprValuC+11] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+45], s[sgprAlpha], v[vgprValuC+19] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+46], s[sgprAlpha], v[vgprValuC+27] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+47], s[sgprAlpha], v[vgprValuC+4] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+48], s[sgprAlpha], v[vgprValuC+12] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+49], s[sgprAlpha], v[vgprValuC+20] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+50], s[sgprAlpha], v[vgprValuC+28] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+51], s[sgprAlpha], v[vgprValuC+5] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+52], s[sgprAlpha], v[vgprValuC+13] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+53], s[sgprAlpha], v[vgprValuC+21] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+54], s[sgprAlpha], v[vgprValuC+29] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+55], s[sgprAlpha], v[vgprValuC+6] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+56], s[sgprAlpha], v[vgprValuC+14] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+57], s[sgprAlpha], v[vgprValuC+22] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+58], s[sgprAlpha], v[vgprValuC+30] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+59], s[sgprAlpha], v[vgprValuC+7] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+60], s[sgprAlpha], v[vgprValuC+15] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+61], s[sgprAlpha], v[vgprValuC+23] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+62], s[sgprAlpha], v[vgprValuC+31] // Multiply MI out reg with alpha

/* apply mask, calc new C and issue writes */
s_wait_alu depctr_va_vdst(14)
buffer_store_b32 v7, v71, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v40, v72, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v41, v73, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v42, v74, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v43, v75, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v44, v76, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v45, v77, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v46, v78, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v47, v79, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v48, v80, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v49, v81, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v50, v82, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v51, v83, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v52, v84, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v53, v85, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v54, v86, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v55, v87, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v56, v88, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(13)
buffer_store_b32 v57, v89, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(12)
buffer_store_b32 v58, v90, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(11)
buffer_store_b32 v59, v91, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(10)
buffer_store_b32 v60, v92, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(9)
buffer_store_b32 v61, v93, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(8)
buffer_store_b32 v62, v94, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(7)
buffer_store_b32 v63, v95, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(6)
buffer_store_b32 v64, v96, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(5)
buffer_store_b32 v65, v97, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(4)
buffer_store_b32 v66, v98, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(3)
buffer_store_b32 v67, v99, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(2)
buffer_store_b32 v68, v100, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(1)
buffer_store_b32 v69, v101, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v70, v102, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_nop 0                                            // 1 wait state required when next inst writes vgprs held by previous dwordx4 store inst
s_branch label_GW_End_1                            // jump to end
label_GW_B1_GSU1:
label_GW_B1_FD0_GSU1:

/* Edge/NonEdge store path check (M): Size % 64 > 0 -> Edge store; else -> NonEdge store */
s_and_b32 s28, 63, s[sgprSizeI]                    // s28 = s[sgprSizeI] % 64
s_add_u32 s29, -0x1, s[sgprNumWorkGroups0]
s_cmp_ge_u32 s[sgprWorkGroup0], s29                // wg0 >= nwg0-1 ?
s_cselect_b32 s28, s28, 0                          // set rem
s_mov_b32 s5, 0
s_cmp_gt_u32 s28, s5                               // rem > 0
s_cbranch_scc1 label_GW_B1_FD0_VW1_GSU1_Else       // jump if edges required

/* Edge/NonEdge store path check (N (isSize1)): Size % 64 > 0 -> Edge store; else -> NonEdge store */
s_and_b32 s28, 63, s[sgprSizeJ]                    // s28 = s[sgprSizeJ] % 64
s_add_u32 s29, -0x1, s[sgprNumWorkGroups1]
s_cmp_ge_u32 s[sgprWorkGroup1], s29                // wg1 >= nwg1-1
s_cselect_b32 s28, s28, 0                          // set rem
s_mov_b32 s5, 0
s_cmp_gt_u32 s28, s5                               // rem > 0
s_cbranch_scc1 label_GW_B1_FD0_VW1_GSU1_Then       // jump if edges required
label_GW_B1_FD0_VW1_GSU1_NonEdge:

/* edge=0, allocate 1 sgpr. perBatchTmpS=1 perBatchMaskS=0 perElementMaskS=0 elementsPerBatch=146 */
/* optSingleColVgpr=1 optSharedColVgpr=0 optSGPRUsage=BufferLoad_Mask optSrdIncForRow=1 factorDim=0 */

/******************************************/
/* Global Write Beta Batch #0 (d1,d0,vc1,vc0) = */
/*    (0,0,0,0:vw1); (0,1,0,0:vw1); (0,0,1,0:vw1); (0,1,1,0:vw1); (0,0,2,0:vw1); (0,1,2,0:vw1); (0,0,3,0:vw1); (0,1,3,0:vw1); (0,0,4,0:vw1); (0,1,4,0:vw1); (0,0,5,0:vw1); (0,1,5,0:vw1); (0,0,6,0:vw1); (0,1,6,0:vw1); (0,0,7,0:vw1); (0,1,7,0:vw1); (0,0,8,0:vw1); (0,1,8,0:vw1); (0,0,9,0:vw1); (0,1,9,0:vw1); (0,0,10,0:vw1); (0,1,10,0:vw1); (0,0,11,0:vw1); (0,1,11,0:vw1); (0,0,12,0:vw1); (0,1,12,0:vw1); (0,0,13,0:vw1); (0,1,13,0:vw1); (0,0,14,0:vw1); (0,1,14,0:vw1); (0,0,15,0:vw1); (0,1,15,0:vw1) */
/******************************************/

/* calc coords, apply mask, and issue loads (if necessary) */
/* (d1,vc1,d0,vc0)=(0,0,0,0) */
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_add_lshl_u32 v40, v2, v0, 2                      // optSingleColVgpr scaleToBpe: sharedAddrVgpr <- cinRowPtr + coord0, scaled by BPE. BSHERE:coord0=0, coord0Vgpr=0 (multiple bpe)
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v73, v40, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
/* (d1,vc1,d0,vc0)=(0,0,1,0) */
buffer_load_b32 v74, v40, s[sgprSrdC:sgprSrdC+3], null offen offset:128 scope:SCOPE_CU th:TH_LOAD_RT // load C
/* (d1,vc1,d0,vc0)=(0,1,0,0) */
s_lshl_b32 s12, s[sgprStrideC1J], 2                // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdC+0], s[sgprSrdC+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdC+1], s[sgprSrdC+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_load_b32 v75, v40, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
/* (d1,vc1,d0,vc0)=(0,1,1,0) */
buffer_load_b32 v76, v40, s[sgprSrdC:sgprSrdC+3], null offen offset:128 scope:SCOPE_CU th:TH_LOAD_RT // load C
/* (d1,vc1,d0,vc0)=(0,2,0,0) */
s_lshl_b32 s12, s[sgprStrideC1J], 2                // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdC+0], s[sgprSrdC+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdC+1], s[sgprSrdC+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_load_b32 v77, v40, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
/* (d1,vc1,d0,vc0)=(0,2,1,0) */
buffer_load_b32 v78, v40, s[sgprSrdC:sgprSrdC+3], null offen offset:128 scope:SCOPE_CU th:TH_LOAD_RT // load C
/* (d1,vc1,d0,vc0)=(0,3,0,0) */
s_lshl_b32 s12, s[sgprStrideC1J], 2                // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdC+0], s[sgprSrdC+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdC+1], s[sgprSrdC+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_load_b32 v79, v40, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
/* (d1,vc1,d0,vc0)=(0,3,1,0) */
buffer_load_b32 v80, v40, s[sgprSrdC:sgprSrdC+3], null offen offset:128 scope:SCOPE_CU th:TH_LOAD_RT // load C
/* (d1,vc1,d0,vc0)=(0,4,0,0) */
s_lshl_b32 s12, s[sgprStrideC1J], 2                // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdC+0], s[sgprSrdC+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdC+1], s[sgprSrdC+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_load_b32 v81, v40, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
/* (d1,vc1,d0,vc0)=(0,4,1,0) */
buffer_load_b32 v82, v40, s[sgprSrdC:sgprSrdC+3], null offen offset:128 scope:SCOPE_CU th:TH_LOAD_RT // load C
/* (d1,vc1,d0,vc0)=(0,5,0,0) */
s_lshl_b32 s12, s[sgprStrideC1J], 2                // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdC+0], s[sgprSrdC+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdC+1], s[sgprSrdC+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_load_b32 v83, v40, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
/* (d1,vc1,d0,vc0)=(0,5,1,0) */
buffer_load_b32 v84, v40, s[sgprSrdC:sgprSrdC+3], null offen offset:128 scope:SCOPE_CU th:TH_LOAD_RT // load C
/* (d1,vc1,d0,vc0)=(0,6,0,0) */
s_lshl_b32 s12, s[sgprStrideC1J], 2                // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdC+0], s[sgprSrdC+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdC+1], s[sgprSrdC+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_load_b32 v85, v40, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
/* (d1,vc1,d0,vc0)=(0,6,1,0) */
buffer_load_b32 v86, v40, s[sgprSrdC:sgprSrdC+3], null offen offset:128 scope:SCOPE_CU th:TH_LOAD_RT // load C
/* (d1,vc1,d0,vc0)=(0,7,0,0) */
s_lshl_b32 s12, s[sgprStrideC1J], 2                // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdC+0], s[sgprSrdC+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdC+1], s[sgprSrdC+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_load_b32 v87, v40, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
/* (d1,vc1,d0,vc0)=(0,7,1,0) */
buffer_load_b32 v88, v40, s[sgprSrdC:sgprSrdC+3], null offen offset:128 scope:SCOPE_CU th:TH_LOAD_RT // load C
/* (d1,vc1,d0,vc0)=(0,8,0,0) */
s_lshl_b32 s12, s[sgprStrideC1J], 2                // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdC+0], s[sgprSrdC+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdC+1], s[sgprSrdC+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_load_b32 v89, v40, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
/* (d1,vc1,d0,vc0)=(0,8,1,0) */
buffer_load_b32 v90, v40, s[sgprSrdC:sgprSrdC+3], null offen offset:128 scope:SCOPE_CU th:TH_LOAD_RT // load C
/* (d1,vc1,d0,vc0)=(0,9,0,0) */
s_lshl_b32 s12, s[sgprStrideC1J], 2                // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdC+0], s[sgprSrdC+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdC+1], s[sgprSrdC+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_load_b32 v91, v40, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
/* (d1,vc1,d0,vc0)=(0,9,1,0) */
buffer_load_b32 v92, v40, s[sgprSrdC:sgprSrdC+3], null offen offset:128 scope:SCOPE_CU th:TH_LOAD_RT // load C
/* (d1,vc1,d0,vc0)=(0,10,0,0) */
s_lshl_b32 s12, s[sgprStrideC1J], 2                // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdC+0], s[sgprSrdC+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdC+1], s[sgprSrdC+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_load_b32 v93, v40, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
/* (d1,vc1,d0,vc0)=(0,10,1,0) */
buffer_load_b32 v94, v40, s[sgprSrdC:sgprSrdC+3], null offen offset:128 scope:SCOPE_CU th:TH_LOAD_RT // load C
/* (d1,vc1,d0,vc0)=(0,11,0,0) */
s_lshl_b32 s12, s[sgprStrideC1J], 2                // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdC+0], s[sgprSrdC+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdC+1], s[sgprSrdC+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_load_b32 v95, v40, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
/* (d1,vc1,d0,vc0)=(0,11,1,0) */
buffer_load_b32 v96, v40, s[sgprSrdC:sgprSrdC+3], null offen offset:128 scope:SCOPE_CU th:TH_LOAD_RT // load C
/* (d1,vc1,d0,vc0)=(0,12,0,0) */
s_lshl_b32 s12, s[sgprStrideC1J], 2                // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdC+0], s[sgprSrdC+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdC+1], s[sgprSrdC+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_load_b32 v97, v40, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
/* (d1,vc1,d0,vc0)=(0,12,1,0) */
buffer_load_b32 v98, v40, s[sgprSrdC:sgprSrdC+3], null offen offset:128 scope:SCOPE_CU th:TH_LOAD_RT // load C
/* (d1,vc1,d0,vc0)=(0,13,0,0) */
s_lshl_b32 s12, s[sgprStrideC1J], 2                // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdC+0], s[sgprSrdC+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdC+1], s[sgprSrdC+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_load_b32 v99, v40, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
/* (d1,vc1,d0,vc0)=(0,13,1,0) */
buffer_load_b32 v100, v40, s[sgprSrdC:sgprSrdC+3], null offen offset:128 scope:SCOPE_CU th:TH_LOAD_RT // load C
/* (d1,vc1,d0,vc0)=(0,14,0,0) */
s_lshl_b32 s12, s[sgprStrideC1J], 2                // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdC+0], s[sgprSrdC+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdC+1], s[sgprSrdC+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_load_b32 v101, v40, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
/* (d1,vc1,d0,vc0)=(0,14,1,0) */
buffer_load_b32 v102, v40, s[sgprSrdC:sgprSrdC+3], null offen offset:128 scope:SCOPE_CU th:TH_LOAD_RT // load C
/* (d1,vc1,d0,vc0)=(0,15,0,0) */
s_lshl_b32 s12, s[sgprStrideC1J], 2                // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdC+0], s[sgprSrdC+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdC+1], s[sgprSrdC+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_load_b32 v103, v40, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
/* (d1,vc1,d0,vc0)=(0,15,1,0) */
buffer_load_b32 v104, v40, s[sgprSrdC:sgprSrdC+3], null offen offset:128 scope:SCOPE_CU th:TH_LOAD_RT // load C
v_add_lshl_u32 v7, v3, v0, 2                       // optSingleColVgpr scaleToBpe: sharedAddrVgpr <- cinRowPtr + coord0, scaled by BPE. BSHERE:coord0=0, coord0Vgpr=0 (multiple bpe)

/* rC *= alpha batchElements=[(0, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0, 1, 1, 0), (0, 0, 2, 0), (0, 1, 2, 0), (0, 0, 3, 0), (0, 1, 3, 0), (0, 0, 4, 0), (0, 1, 4, 0), (0, 0, 5, 0), (0, 1, 5, 0), (0, 0, 6, 0), (0, 1, 6, 0), (0, 0, 7, 0), (0, 1, 7, 0), (0, 0, 8, 0), (0, 1, 8, 0), (0, 0, 9, 0), (0, 1, 9, 0), (0, 0, 10, 0), (0, 1, 10, 0), (0, 0, 11, 0), (0, 1, 11, 0), (0, 0, 12, 0), (0, 1, 12, 0), (0, 0, 13, 0), (0, 1, 13, 0), (0, 0, 14, 0), (0, 1, 14, 0), (0, 0, 15, 0), (0, 1, 15, 0)] */
v_mul_f32 v[vgprValuC+33], s[sgprAlpha], v[vgprValuC+0] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+34], s[sgprAlpha], v[vgprValuC+8] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+35], s[sgprAlpha], v[vgprValuC+16] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+36], s[sgprAlpha], v[vgprValuC+24] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+37], s[sgprAlpha], v[vgprValuC+1] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+38], s[sgprAlpha], v[vgprValuC+9] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+39], s[sgprAlpha], v[vgprValuC+17] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+40], s[sgprAlpha], v[vgprValuC+25] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+41], s[sgprAlpha], v[vgprValuC+2] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+42], s[sgprAlpha], v[vgprValuC+10] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+43], s[sgprAlpha], v[vgprValuC+18] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+44], s[sgprAlpha], v[vgprValuC+26] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+45], s[sgprAlpha], v[vgprValuC+3] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+46], s[sgprAlpha], v[vgprValuC+11] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+47], s[sgprAlpha], v[vgprValuC+19] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+48], s[sgprAlpha], v[vgprValuC+27] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+49], s[sgprAlpha], v[vgprValuC+4] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+50], s[sgprAlpha], v[vgprValuC+12] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+51], s[sgprAlpha], v[vgprValuC+20] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+52], s[sgprAlpha], v[vgprValuC+28] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+53], s[sgprAlpha], v[vgprValuC+5] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+54], s[sgprAlpha], v[vgprValuC+13] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+55], s[sgprAlpha], v[vgprValuC+21] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+56], s[sgprAlpha], v[vgprValuC+29] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+57], s[sgprAlpha], v[vgprValuC+6] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+58], s[sgprAlpha], v[vgprValuC+14] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+59], s[sgprAlpha], v[vgprValuC+22] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+60], s[sgprAlpha], v[vgprValuC+30] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+61], s[sgprAlpha], v[vgprValuC+7] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+62], s[sgprAlpha], v[vgprValuC+15] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+63], s[sgprAlpha], v[vgprValuC+23] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+64], s[sgprAlpha], v[vgprValuC+31] // Multiply MI out reg with alpha

/* apply mask, calc new C and issue writes */

s_wait_loadcnt 31                                  // vlcnt(31) = 32 - 1 (beta) (interleaved)
v_fmac_f32 v[vgprValuC+33], v73, s[sgprBeta]       // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v41, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_loadcnt 30                                  // vlcnt(30) = 32 - 2 (beta) (interleaved)
v_fmac_f32 v[vgprValuC+34], v74, s[sgprBeta]       // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v42, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:128 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_loadcnt 29                                  // vlcnt(29) = 32 - 3 (beta) (interleaved)
v_fmac_f32 v[vgprValuC+35], v75, s[sgprBeta]       // finalSum = sum*alpha + C*beta
s_lshl_b32 s12, s[sgprStrideD1J], 2                // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v43, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_loadcnt 28                                  // vlcnt(28) = 32 - 4 (beta) (interleaved)
v_fmac_f32 v[vgprValuC+36], v76, s[sgprBeta]       // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v44, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:128 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_loadcnt 27                                  // vlcnt(27) = 32 - 5 (beta) (interleaved)
v_fmac_f32 v[vgprValuC+37], v77, s[sgprBeta]       // finalSum = sum*alpha + C*beta
s_lshl_b32 s12, s[sgprStrideD1J], 2                // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v45, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_loadcnt 26                                  // vlcnt(26) = 32 - 6 (beta) (interleaved)
v_fmac_f32 v[vgprValuC+38], v78, s[sgprBeta]       // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v46, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:128 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_loadcnt 25                                  // vlcnt(25) = 32 - 7 (beta) (interleaved)
v_fmac_f32 v[vgprValuC+39], v79, s[sgprBeta]       // finalSum = sum*alpha + C*beta
s_lshl_b32 s12, s[sgprStrideD1J], 2                // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v47, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_loadcnt 24                                  // vlcnt(24) = 32 - 8 (beta) (interleaved)
v_fmac_f32 v[vgprValuC+40], v80, s[sgprBeta]       // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v48, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:128 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_loadcnt 23                                  // vlcnt(23) = 32 - 9 (beta) (interleaved)
v_fmac_f32 v[vgprValuC+41], v81, s[sgprBeta]       // finalSum = sum*alpha + C*beta
s_lshl_b32 s12, s[sgprStrideD1J], 2                // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v49, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_loadcnt 22                                  // vlcnt(22) = 32 - 10 (beta) (interleaved)
v_fmac_f32 v[vgprValuC+42], v82, s[sgprBeta]       // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v50, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:128 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_loadcnt 21                                  // vlcnt(21) = 32 - 11 (beta) (interleaved)
v_fmac_f32 v[vgprValuC+43], v83, s[sgprBeta]       // finalSum = sum*alpha + C*beta
s_lshl_b32 s12, s[sgprStrideD1J], 2                // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v51, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_loadcnt 20                                  // vlcnt(20) = 32 - 12 (beta) (interleaved)
v_fmac_f32 v[vgprValuC+44], v84, s[sgprBeta]       // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v52, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:128 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_loadcnt 19                                  // vlcnt(19) = 32 - 13 (beta) (interleaved)
v_fmac_f32 v[vgprValuC+45], v85, s[sgprBeta]       // finalSum = sum*alpha + C*beta
s_lshl_b32 s12, s[sgprStrideD1J], 2                // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v53, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_loadcnt 18                                  // vlcnt(18) = 32 - 14 (beta) (interleaved)
v_fmac_f32 v[vgprValuC+46], v86, s[sgprBeta]       // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v54, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:128 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_loadcnt 17                                  // vlcnt(17) = 32 - 15 (beta) (interleaved)
v_fmac_f32 v[vgprValuC+47], v87, s[sgprBeta]       // finalSum = sum*alpha + C*beta
s_lshl_b32 s12, s[sgprStrideD1J], 2                // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v55, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_loadcnt 16                                  // vlcnt(16) = 32 - 16 (beta) (interleaved)
v_fmac_f32 v[vgprValuC+48], v88, s[sgprBeta]       // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v56, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:128 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_loadcnt 15                                  // vlcnt(15) = 32 - 17 (beta) (interleaved)
v_fmac_f32 v[vgprValuC+49], v89, s[sgprBeta]       // finalSum = sum*alpha + C*beta
s_lshl_b32 s12, s[sgprStrideD1J], 2                // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v57, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_loadcnt 14                                  // vlcnt(14) = 32 - 18 (beta) (interleaved)
v_fmac_f32 v[vgprValuC+50], v90, s[sgprBeta]       // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v58, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:128 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_loadcnt 13                                  // vlcnt(13) = 32 - 19 (beta) (interleaved)
v_fmac_f32 v[vgprValuC+51], v91, s[sgprBeta]       // finalSum = sum*alpha + C*beta
s_lshl_b32 s12, s[sgprStrideD1J], 2                // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v59, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_loadcnt 12                                  // vlcnt(12) = 32 - 20 (beta) (interleaved)
v_fmac_f32 v[vgprValuC+52], v92, s[sgprBeta]       // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v60, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:128 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_loadcnt 11                                  // vlcnt(11) = 32 - 21 (beta) (interleaved)
v_fmac_f32 v[vgprValuC+53], v93, s[sgprBeta]       // finalSum = sum*alpha + C*beta
s_lshl_b32 s12, s[sgprStrideD1J], 2                // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v61, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_loadcnt 10                                  // vlcnt(10) = 32 - 22 (beta) (interleaved)
v_fmac_f32 v[vgprValuC+54], v94, s[sgprBeta]       // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v62, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:128 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_loadcnt 9                                   // vlcnt(9) = 32 - 23 (beta) (interleaved)
v_fmac_f32 v[vgprValuC+55], v95, s[sgprBeta]       // finalSum = sum*alpha + C*beta
s_lshl_b32 s12, s[sgprStrideD1J], 2                // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v63, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_loadcnt 8                                   // vlcnt(8) = 32 - 24 (beta) (interleaved)
v_fmac_f32 v[vgprValuC+56], v96, s[sgprBeta]       // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v64, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:128 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_loadcnt 7                                   // vlcnt(7) = 32 - 25 (beta) (interleaved)
v_fmac_f32 v[vgprValuC+57], v97, s[sgprBeta]       // finalSum = sum*alpha + C*beta
s_lshl_b32 s12, s[sgprStrideD1J], 2                // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v65, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_loadcnt 6                                   // vlcnt(6) = 32 - 26 (beta) (interleaved)
v_fmac_f32 v[vgprValuC+58], v98, s[sgprBeta]       // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v66, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:128 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_loadcnt 5                                   // vlcnt(5) = 32 - 27 (beta) (interleaved)
v_fmac_f32 v[vgprValuC+59], v99, s[sgprBeta]       // finalSum = sum*alpha + C*beta
s_lshl_b32 s12, s[sgprStrideD1J], 2                // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v67, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_loadcnt 4                                   // vlcnt(4) = 32 - 28 (beta) (interleaved)
v_fmac_f32 v[vgprValuC+60], v100, s[sgprBeta]      // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v68, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:128 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_loadcnt 3                                   // vlcnt(3) = 32 - 29 (beta) (interleaved)
v_fmac_f32 v[vgprValuC+61], v101, s[sgprBeta]      // finalSum = sum*alpha + C*beta
s_lshl_b32 s12, s[sgprStrideD1J], 2                // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v69, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_loadcnt 2                                   // vlcnt(2) = 32 - 30 (beta) (interleaved)
v_fmac_f32 v[vgprValuC+62], v102, s[sgprBeta]      // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v70, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:128 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_loadcnt 1                                   // vlcnt(1) = 32 - 31 (beta) (interleaved)
v_fmac_f32 v[vgprValuC+63], v103, s[sgprBeta]      // finalSum = sum*alpha + C*beta
s_lshl_b32 s12, s[sgprStrideD1J], 2                // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v71, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_loadcnt 0                                   // vlcnt(0) = 32 - 32 (beta) (interleaved)
v_fmac_f32 v[vgprValuC+64], v104, s[sgprBeta]      // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v72, v7, s[sgprSrdD:sgprSrdD+3], null offen offset:128 scope:SCOPE_CU th:TH_STORE_RT // store D
s_nop 0                                            // 1 wait state required when next inst writes vgprs held by previous dwordx4 store inst
s_branch label_GW_End_1                            // jump to end
label_GW_B1_FD0_VW1_GSU1_NonEdgeEnd:
label_GW_B1_FD0_VW1_GSU1_Else:
label_GW_B1_FD0_VW1_GSU1_Then:

/* edge=1, allocate 3 sgpr. perBatchTmpS=2 perBatchMaskS=1 perElementMaskS=0 elementsPerBatch=98 */
/* optSingleColVgpr=0 optSharedColVgpr=0 optSGPRUsage=BufferLoad_Edge_Mask optSrdIncForRow=0 factorDim=0 */

/******************************************/
/* Global Write Beta Edge Batch #0 (d1,d0,vc1,vc0) = */
/*    (0,0,0,0:vw1); (0,1,0,0:vw1); (0,0,1,0:vw1); (0,1,1,0:vw1); (0,0,2,0:vw1); (0,1,2,0:vw1); (0,0,3,0:vw1); (0,1,3,0:vw1); (0,0,4,0:vw1); (0,1,4,0:vw1); (0,0,5,0:vw1); (0,1,5,0:vw1); (0,0,6,0:vw1); (0,1,6,0:vw1); (0,0,7,0:vw1); (0,1,7,0:vw1); (0,0,8,0:vw1); (0,1,8,0:vw1); (0,0,9,0:vw1); (0,1,9,0:vw1); (0,0,10,0:vw1); (0,1,10,0:vw1); (0,0,11,0:vw1); (0,1,11,0:vw1); (0,0,12,0:vw1); (0,1,12,0:vw1); (0,0,13,0:vw1); (0,1,13,0:vw1); (0,0,14,0:vw1); (0,1,14,0:vw1); (0,0,15,0:vw1); (0,1,15,0:vw1) */
/******************************************/

/* calc coords, apply mask, and issue loads (if necessary) */
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v6, BufferOOB
/* (d1,vc1,d0,vc0)=(0,0,0,0) */
v_cmp_lt_u32 s12, v0, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v72, v2, v0, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v72, v6, v72, s14                    // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v71, v72, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v72, v3, v0, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v72, v6, v72, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,1,0) */
v_add_co_u32 v4, vcc_lo, v0, 32                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v74, v2, v4, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v74, v6, v74, s14                    // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v73, v74, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v74, v3, v4, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v74, v6, v74, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,0,0) */
v_add_co_u32 v1, vcc_lo, v1, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v2, v2, s[sgprStrideC1J]              // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v3, v3, s[sgprStrideD1J]              // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v0, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v76, v2, v0, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v76, v6, v76, s14                    // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v75, v76, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v76, v3, v0, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v76, v6, v76, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,1,0) */
v_add_co_u32 v4, vcc_lo, v0, 32                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v78, v2, v4, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v78, v6, v78, s14                    // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v77, v78, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v78, v3, v4, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v78, v6, v78, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,0,0) */
v_add_co_u32 v1, vcc_lo, v1, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v2, v2, s[sgprStrideC1J]              // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v3, v3, s[sgprStrideD1J]              // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v0, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v80, v2, v0, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v80, v6, v80, s14                    // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v79, v80, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v80, v3, v0, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v80, v6, v80, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,1,0) */
v_add_co_u32 v4, vcc_lo, v0, 32                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v82, v2, v4, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v82, v6, v82, s14                    // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v81, v82, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v82, v3, v4, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v82, v6, v82, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,0,0) */
v_add_co_u32 v1, vcc_lo, v1, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v2, v2, s[sgprStrideC1J]              // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v3, v3, s[sgprStrideD1J]              // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v0, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v84, v2, v0, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v84, v6, v84, s14                    // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v83, v84, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v84, v3, v0, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v84, v6, v84, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,1,0) */
v_add_co_u32 v4, vcc_lo, v0, 32                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v86, v2, v4, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v86, v6, v86, s14                    // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v85, v86, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v86, v3, v4, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v86, v6, v86, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,4,0,0) */
v_add_co_u32 v1, vcc_lo, v1, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v2, v2, s[sgprStrideC1J]              // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v3, v3, s[sgprStrideD1J]              // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v0, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v88, v2, v0, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v88, v6, v88, s14                    // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v87, v88, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v88, v3, v0, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v88, v6, v88, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,4,1,0) */
v_add_co_u32 v4, vcc_lo, v0, 32                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v90, v2, v4, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v90, v6, v90, s14                    // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v89, v90, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v90, v3, v4, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v90, v6, v90, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,5,0,0) */
v_add_co_u32 v1, vcc_lo, v1, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v2, v2, s[sgprStrideC1J]              // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v3, v3, s[sgprStrideD1J]              // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v0, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v92, v2, v0, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v92, v6, v92, s14                    // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v91, v92, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v92, v3, v0, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v92, v6, v92, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,5,1,0) */
v_add_co_u32 v4, vcc_lo, v0, 32                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v94, v2, v4, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v94, v6, v94, s14                    // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v93, v94, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v94, v3, v4, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v94, v6, v94, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,6,0,0) */
v_add_co_u32 v1, vcc_lo, v1, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v2, v2, s[sgprStrideC1J]              // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v3, v3, s[sgprStrideD1J]              // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v0, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v96, v2, v0, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v96, v6, v96, s14                    // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v95, v96, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v96, v3, v0, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v96, v6, v96, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,6,1,0) */
v_add_co_u32 v4, vcc_lo, v0, 32                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v98, v2, v4, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v98, v6, v98, s14                    // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v97, v98, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v98, v3, v4, 2                      // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v98, v6, v98, s14                    // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,7,0,0) */
v_add_co_u32 v1, vcc_lo, v1, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v2, v2, s[sgprStrideC1J]              // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v3, v3, s[sgprStrideD1J]              // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v0, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v100, v2, v0, 2                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v100, v6, v100, s14                  // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v99, v100, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v100, v3, v0, 2                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v100, v6, v100, s14                  // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,7,1,0) */
v_add_co_u32 v4, vcc_lo, v0, 32                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v102, v2, v4, 2                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v102, v6, v102, s14                  // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v101, v102, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v102, v3, v4, 2                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v102, v6, v102, s14                  // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,8,0,0) */
v_add_co_u32 v1, vcc_lo, v1, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v2, v2, s[sgprStrideC1J]              // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v3, v3, s[sgprStrideD1J]              // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v0, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v104, v2, v0, 2                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v104, v6, v104, s14                  // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v103, v104, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v104, v3, v0, 2                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v104, v6, v104, s14                  // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,8,1,0) */
v_add_co_u32 v4, vcc_lo, v0, 32                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v106, v2, v4, 2                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v106, v6, v106, s14                  // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v105, v106, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v106, v3, v4, 2                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v106, v6, v106, s14                  // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,9,0,0) */
v_add_co_u32 v1, vcc_lo, v1, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v2, v2, s[sgprStrideC1J]              // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v3, v3, s[sgprStrideD1J]              // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v0, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v108, v2, v0, 2                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v108, v6, v108, s14                  // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v107, v108, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v108, v3, v0, 2                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v108, v6, v108, s14                  // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,9,1,0) */
v_add_co_u32 v4, vcc_lo, v0, 32                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v111, v2, v4, 2                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v111, v6, v111, s14                  // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v109, v111, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v111, v3, v4, 2                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v111, v6, v111, s14                  // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,10,0,0) */
v_add_co_u32 v1, vcc_lo, v1, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v2, v2, s[sgprStrideC1J]              // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v3, v3, s[sgprStrideD1J]              // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v0, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v113, v2, v0, 2                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v113, v6, v113, s14                  // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v112, v113, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v113, v3, v0, 2                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v113, v6, v113, s14                  // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,10,1,0) */
v_add_co_u32 v4, vcc_lo, v0, 32                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v115, v2, v4, 2                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v115, v6, v115, s14                  // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v114, v115, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v115, v3, v4, 2                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v115, v6, v115, s14                  // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,11,0,0) */
v_add_co_u32 v1, vcc_lo, v1, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v2, v2, s[sgprStrideC1J]              // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v3, v3, s[sgprStrideD1J]              // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v0, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v117, v2, v0, 2                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v117, v6, v117, s14                  // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v116, v117, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v117, v3, v0, 2                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v117, v6, v117, s14                  // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,11,1,0) */
v_add_co_u32 v4, vcc_lo, v0, 32                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v119, v2, v4, 2                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v119, v6, v119, s14                  // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v118, v119, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v119, v3, v4, 2                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v119, v6, v119, s14                  // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,12,0,0) */
v_add_co_u32 v1, vcc_lo, v1, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v2, v2, s[sgprStrideC1J]              // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v3, v3, s[sgprStrideD1J]              // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v0, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v121, v2, v0, 2                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v121, v6, v121, s14                  // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v120, v121, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v121, v3, v0, 2                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v121, v6, v121, s14                  // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,12,1,0) */
v_add_co_u32 v4, vcc_lo, v0, 32                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v123, v2, v4, 2                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v123, v6, v123, s14                  // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v122, v123, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v123, v3, v4, 2                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v123, v6, v123, s14                  // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,13,0,0) */
v_add_co_u32 v1, vcc_lo, v1, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v2, v2, s[sgprStrideC1J]              // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v3, v3, s[sgprStrideD1J]              // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v0, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v125, v2, v0, 2                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v125, v6, v125, s14                  // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v124, v125, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v125, v3, v0, 2                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v125, v6, v125, s14                  // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,13,1,0) */
v_add_co_u32 v4, vcc_lo, v0, 32                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v127, v2, v4, 2                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v127, v6, v127, s14                  // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v126, v127, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v127, v3, v4, 2                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v127, v6, v127, s14                  // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,14,0,0) */
v_add_co_u32 v1, vcc_lo, v1, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v2, v2, s[sgprStrideC1J]              // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v3, v3, s[sgprStrideD1J]              // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v0, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v129, v2, v0, 2                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v129, v6, v129, s14                  // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v128, v129, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v129, v3, v0, 2                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v129, v6, v129, s14                  // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,14,1,0) */
v_add_co_u32 v4, vcc_lo, v0, 32                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v131, v2, v4, 2                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v131, v6, v131, s14                  // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v130, v131, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v131, v3, v4, 2                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v131, v6, v131, s14                  // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,15,0,0) */
v_add_co_u32 v1, vcc_lo, v1, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v2, v2, s[sgprStrideC1J]              // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v3, v3, s[sgprStrideD1J]              // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v0, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v133, v2, v0, 2                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v133, v6, v133, s14                  // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v132, v133, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v133, v3, v0, 2                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v133, v6, v133, s14                  // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,15,1,0) */
v_add_co_u32 v4, vcc_lo, v0, 32                    // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v4, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s14, v1, s[sgprSizeJ]                 // coord1 < size1
s_and_b32 s14, s12, s14                            // in0 && in1
v_add_lshl_u32 v135, v2, v4, 2                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v135, v6, v135, s14                  // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_b32 v134, v135, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v135, v3, v4, 2                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v135, v6, v135, s14                  // LDD clip if OOB. offset

/* rC *= alpha batchElements=[(0, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0, 1, 1, 0), (0, 0, 2, 0), (0, 1, 2, 0), (0, 0, 3, 0), (0, 1, 3, 0), (0, 0, 4, 0), (0, 1, 4, 0), (0, 0, 5, 0), (0, 1, 5, 0), (0, 0, 6, 0), (0, 1, 6, 0), (0, 0, 7, 0), (0, 1, 7, 0), (0, 0, 8, 0), (0, 1, 8, 0), (0, 0, 9, 0), (0, 1, 9, 0), (0, 0, 10, 0), (0, 1, 10, 0), (0, 0, 11, 0), (0, 1, 11, 0), (0, 0, 12, 0), (0, 1, 12, 0), (0, 0, 13, 0), (0, 1, 13, 0), (0, 0, 14, 0), (0, 1, 14, 0), (0, 0, 15, 0), (0, 1, 15, 0)] */
v_mul_f32 v[vgprValuC+-1], s[sgprAlpha], v[vgprValuC+0] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+32], s[sgprAlpha], v[vgprValuC+8] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+33], s[sgprAlpha], v[vgprValuC+16] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+34], s[sgprAlpha], v[vgprValuC+24] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+35], s[sgprAlpha], v[vgprValuC+1] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+36], s[sgprAlpha], v[vgprValuC+9] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+37], s[sgprAlpha], v[vgprValuC+17] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+38], s[sgprAlpha], v[vgprValuC+25] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+39], s[sgprAlpha], v[vgprValuC+2] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+40], s[sgprAlpha], v[vgprValuC+10] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+41], s[sgprAlpha], v[vgprValuC+18] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+42], s[sgprAlpha], v[vgprValuC+26] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+43], s[sgprAlpha], v[vgprValuC+3] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+44], s[sgprAlpha], v[vgprValuC+11] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+45], s[sgprAlpha], v[vgprValuC+19] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+46], s[sgprAlpha], v[vgprValuC+27] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+47], s[sgprAlpha], v[vgprValuC+4] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+48], s[sgprAlpha], v[vgprValuC+12] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+49], s[sgprAlpha], v[vgprValuC+20] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+50], s[sgprAlpha], v[vgprValuC+28] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+51], s[sgprAlpha], v[vgprValuC+5] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+52], s[sgprAlpha], v[vgprValuC+13] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+53], s[sgprAlpha], v[vgprValuC+21] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+54], s[sgprAlpha], v[vgprValuC+29] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+55], s[sgprAlpha], v[vgprValuC+6] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+56], s[sgprAlpha], v[vgprValuC+14] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+57], s[sgprAlpha], v[vgprValuC+22] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+58], s[sgprAlpha], v[vgprValuC+30] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+59], s[sgprAlpha], v[vgprValuC+7] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+60], s[sgprAlpha], v[vgprValuC+15] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+61], s[sgprAlpha], v[vgprValuC+23] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+62], s[sgprAlpha], v[vgprValuC+31] // Multiply MI out reg with alpha
s_wait_loadcnt 0                                   // wait for Beta

/* apply mask, calc new C and issue writes */
v_fmac_f32 v[vgprValuC+-1], v71, s[sgprBeta]       // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v7, v72, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+32], v73, s[sgprBeta]       // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v40, v74, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+33], v75, s[sgprBeta]       // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v41, v76, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+34], v77, s[sgprBeta]       // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v42, v78, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+35], v79, s[sgprBeta]       // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v43, v80, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+36], v81, s[sgprBeta]       // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v44, v82, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+37], v83, s[sgprBeta]       // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v45, v84, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+38], v85, s[sgprBeta]       // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v46, v86, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+39], v87, s[sgprBeta]       // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v47, v88, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+40], v89, s[sgprBeta]       // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v48, v90, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+41], v91, s[sgprBeta]       // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v49, v92, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+42], v93, s[sgprBeta]       // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v50, v94, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+43], v95, s[sgprBeta]       // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v51, v96, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+44], v97, s[sgprBeta]       // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v52, v98, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+45], v99, s[sgprBeta]       // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v53, v100, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+46], v101, s[sgprBeta]      // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v54, v102, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+47], v103, s[sgprBeta]      // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v55, v104, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+48], v105, s[sgprBeta]      // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v56, v106, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+49], v107, s[sgprBeta]      // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v57, v108, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+50], v109, s[sgprBeta]      // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v58, v111, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+51], v112, s[sgprBeta]      // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v59, v113, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+52], v114, s[sgprBeta]      // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v60, v115, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+53], v116, s[sgprBeta]      // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v61, v117, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+54], v118, s[sgprBeta]      // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v62, v119, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+55], v120, s[sgprBeta]      // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v63, v121, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+56], v122, s[sgprBeta]      // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v64, v123, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+57], v124, s[sgprBeta]      // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v65, v125, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+58], v126, s[sgprBeta]      // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v66, v127, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+59], v128, s[sgprBeta]      // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v67, v129, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+60], v130, s[sgprBeta]      // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v68, v131, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+61], v132, s[sgprBeta]      // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v69, v133, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_fmac_f32 v[vgprValuC+62], v134, s[sgprBeta]      // finalSum = sum*alpha + C*beta
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v70, v135, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_nop 0                                            // 1 wait state required when next inst writes vgprs held by previous dwordx4 store inst
s_branch label_GW_End_1                            // jump to end
label_GW_End_1:
label_KernelEnd:
s_endpgm                                           // Kernel End
label_ASM_End:  /// The end of the kernel
