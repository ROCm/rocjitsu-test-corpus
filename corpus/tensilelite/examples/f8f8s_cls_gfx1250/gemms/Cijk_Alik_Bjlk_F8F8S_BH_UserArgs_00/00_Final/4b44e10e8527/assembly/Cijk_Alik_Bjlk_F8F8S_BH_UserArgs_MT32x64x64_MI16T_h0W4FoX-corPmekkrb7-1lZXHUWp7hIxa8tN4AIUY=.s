
/******************************************/
/* Begin Kernel                           */
/******************************************/
/* STINKY_TOTAL_INST_BYTES: 52932 */
.amdgcn_target "amdgcn-amd-amdhsa--gfx1250"
.text
.protected Cijk_Alik_Bjlk_F8F8S_BH_UserArgs_MT32x64x64_MI16x16x1_SN_LDSB1_AFC0_AG0_AGGSUA0_AGNTAB0_AFEM2_AFEM1_ASEM32_BL1_BS1_CD1_1_CLR0_CLS1_CADS0_DTLA0_DTLB0_DTLM0_DTVA0_DTVB0_DTVMXSA0_DTVMXSB0_DTVSM0_DPLB0_EPS0_ELFLR0_EMLLn1_FDSI0_GRPM1_GRVWA1_GRVWB1_GSUAMB_GLS0_HPLR0_ISA1250_ICIW1_IU1_K1_LDSTI0_LBSPPA256_LBSPPB1024_LBSPPMXSA0_LBSPPMXSB0_LBSPPM0_LPA16_LPB32_LPMXSA0_LPMXSB0_LPM0_LRVW16_LWPMn1_MIAV1_MIWT2_2_MXLIBL_MXSFNS_MO40_MGRIPM1_NTn1_NTA0_NTB0_NTC0_NTD0_NTE0_NTMXSA0_NTMXSB0_NTM0_NTWS0_NVn1_NVA0_NVB0_NVC0_NVD0_NVE0_NVMXSA0_NVMXSB0_NVM0_NVWS0_NEPBS0_NLCA1_NLCB1_ONLL1_PAP0_PGL0_PGR2_PLR0_PKA1_SGROB0_SIA3_SS1_SPO0_SRVW0_SSO0_SVW2_SK0_SKFTR0_SKFDPO0_SKWS0_SKXCCM0_SNLL0_SIP1_SGRO0_TDMI0_TDMIM0_TDMLWS0_TDMS0_TIN0_THn1_THA0_THB0_THC0_THD0_THE0_THMXSA0_THMXSB0_THM0_THWS0_TLDS1_TLDSMn1_ULSGRO0_USL1_USLMX0_UDFMAC0_UIOFGRO0_UPLRP0_USFGROn1_USI0_VSn1_VWA2_VWB2_WSGRA0_WSGRB0_WS32_WG16_4_1_WGMXCC1
.globl Cijk_Alik_Bjlk_F8F8S_BH_UserArgs_MT32x64x64_MI16x16x1_SN_LDSB1_AFC0_AG0_AGGSUA0_AGNTAB0_AFEM2_AFEM1_ASEM32_BL1_BS1_CD1_1_CLR0_CLS1_CADS0_DTLA0_DTLB0_DTLM0_DTVA0_DTVB0_DTVMXSA0_DTVMXSB0_DTVSM0_DPLB0_EPS0_ELFLR0_EMLLn1_FDSI0_GRPM1_GRVWA1_GRVWB1_GSUAMB_GLS0_HPLR0_ISA1250_ICIW1_IU1_K1_LDSTI0_LBSPPA256_LBSPPB1024_LBSPPMXSA0_LBSPPMXSB0_LBSPPM0_LPA16_LPB32_LPMXSA0_LPMXSB0_LPM0_LRVW16_LWPMn1_MIAV1_MIWT2_2_MXLIBL_MXSFNS_MO40_MGRIPM1_NTn1_NTA0_NTB0_NTC0_NTD0_NTE0_NTMXSA0_NTMXSB0_NTM0_NTWS0_NVn1_NVA0_NVB0_NVC0_NVD0_NVE0_NVMXSA0_NVMXSB0_NVM0_NVWS0_NEPBS0_NLCA1_NLCB1_ONLL1_PAP0_PGL0_PGR2_PLR0_PKA1_SGROB0_SIA3_SS1_SPO0_SRVW0_SSO0_SVW2_SK0_SKFTR0_SKFDPO0_SKWS0_SKXCCM0_SNLL0_SIP1_SGRO0_TDMI0_TDMIM0_TDMLWS0_TDMS0_TIN0_THn1_THA0_THB0_THC0_THD0_THE0_THMXSA0_THMXSB0_THM0_THWS0_TLDS1_TLDSMn1_ULSGRO0_USL1_USLMX0_UDFMAC0_UIOFGRO0_UPLRP0_USFGROn1_USI0_VSn1_VWA2_VWB2_WSGRA0_WSGRB0_WS32_WG16_4_1_WGMXCC1
.p2align 8
.type Cijk_Alik_Bjlk_F8F8S_BH_UserArgs_MT32x64x64_MI16x16x1_SN_LDSB1_AFC0_AG0_AGGSUA0_AGNTAB0_AFEM2_AFEM1_ASEM32_BL1_BS1_CD1_1_CLR0_CLS1_CADS0_DTLA0_DTLB0_DTLM0_DTVA0_DTVB0_DTVMXSA0_DTVMXSB0_DTVSM0_DPLB0_EPS0_ELFLR0_EMLLn1_FDSI0_GRPM1_GRVWA1_GRVWB1_GSUAMB_GLS0_HPLR0_ISA1250_ICIW1_IU1_K1_LDSTI0_LBSPPA256_LBSPPB1024_LBSPPMXSA0_LBSPPMXSB0_LBSPPM0_LPA16_LPB32_LPMXSA0_LPMXSB0_LPM0_LRVW16_LWPMn1_MIAV1_MIWT2_2_MXLIBL_MXSFNS_MO40_MGRIPM1_NTn1_NTA0_NTB0_NTC0_NTD0_NTE0_NTMXSA0_NTMXSB0_NTM0_NTWS0_NVn1_NVA0_NVB0_NVC0_NVD0_NVE0_NVMXSA0_NVMXSB0_NVM0_NVWS0_NEPBS0_NLCA1_NLCB1_ONLL1_PAP0_PGL0_PGR2_PLR0_PKA1_SGROB0_SIA3_SS1_SPO0_SRVW0_SSO0_SVW2_SK0_SKFTR0_SKFDPO0_SKWS0_SKXCCM0_SNLL0_SIP1_SGRO0_TDMI0_TDMIM0_TDMLWS0_TDMS0_TIN0_THn1_THA0_THB0_THC0_THD0_THE0_THMXSA0_THMXSB0_THM0_THWS0_TLDS1_TLDSMn1_ULSGRO0_USL1_USLMX0_UDFMAC0_UIOFGRO0_UPLRP0_USFGROn1_USI0_VSn1_VWA2_VWB2_WSGRA0_WSGRB0_WS32_WG16_4_1_WGMXCC1,@function
.section .rodata,#alloc
.p2align 6
.amdhsa_kernel Cijk_Alik_Bjlk_F8F8S_BH_UserArgs_MT32x64x64_MI16x16x1_SN_LDSB1_AFC0_AG0_AGGSUA0_AGNTAB0_AFEM2_AFEM1_ASEM32_BL1_BS1_CD1_1_CLR0_CLS1_CADS0_DTLA0_DTLB0_DTLM0_DTVA0_DTVB0_DTVMXSA0_DTVMXSB0_DTVSM0_DPLB0_EPS0_ELFLR0_EMLLn1_FDSI0_GRPM1_GRVWA1_GRVWB1_GSUAMB_GLS0_HPLR0_ISA1250_ICIW1_IU1_K1_LDSTI0_LBSPPA256_LBSPPB1024_LBSPPMXSA0_LBSPPMXSB0_LBSPPM0_LPA16_LPB32_LPMXSA0_LPMXSB0_LPM0_LRVW16_LWPMn1_MIAV1_MIWT2_2_MXLIBL_MXSFNS_MO40_MGRIPM1_NTn1_NTA0_NTB0_NTC0_NTD0_NTE0_NTMXSA0_NTMXSB0_NTM0_NTWS0_NVn1_NVA0_NVB0_NVC0_NVD0_NVE0_NVMXSA0_NVMXSB0_NVM0_NVWS0_NEPBS0_NLCA1_NLCB1_ONLL1_PAP0_PGL0_PGR2_PLR0_PKA1_SGROB0_SIA3_SS1_SPO0_SRVW0_SSO0_SVW2_SK0_SKFTR0_SKFDPO0_SKWS0_SKXCCM0_SNLL0_SIP1_SGRO0_TDMI0_TDMIM0_TDMLWS0_TDMS0_TIN0_THn1_THA0_THB0_THC0_THD0_THE0_THMXSA0_THMXSB0_THM0_THWS0_TLDS1_TLDSMn1_ULSGRO0_USL1_USLMX0_UDFMAC0_UIOFGRO0_UPLRP0_USFGROn1_USI0_VSn1_VWA2_VWB2_WSGRA0_WSGRB0_WS32_WG16_4_1_WGMXCC1
  .amdhsa_user_sgpr_kernarg_segment_ptr 1
  .amdhsa_next_free_vgpr 510 // vgprs
  .amdhsa_next_free_sgpr 72 // sgprs
  .amdhsa_group_segment_fixed_size 8192 // lds bytes
  .amdhsa_wavefront_size32 1 // 32-thread wavefronts
  .amdhsa_private_segment_fixed_size 0
  .amdhsa_system_sgpr_workgroup_id_x 1
  .amdhsa_system_sgpr_workgroup_id_y 1
  .amdhsa_system_sgpr_workgroup_id_z 1
  .amdhsa_system_vgpr_workitem_id 0
  .amdhsa_float_denorm_mode_32 3
  .amdhsa_float_denorm_mode_16_64 3
  .amdhsa_inst_pref_size 255
  .amdhsa_user_sgpr_count 28
  .amdhsa_user_sgpr_kernarg_preload_length 26
  .amdhsa_user_sgpr_kernarg_preload_offset 0
.end_amdhsa_kernel
.text
/* Num VGPR   =510 */
/* Num AccVGPR=0 */
/* Num SGPR   =72 */

/******************************************/
/* Optimizations and Config:              */
/******************************************/
/* ThreadTile= 16 x 2 */
/* SubGroup= 2 x 32 */
/* VectorWidthA=2 */
/* VectorWidthB=2 */
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
  - .name: Cijk_Alik_Bjlk_F8F8S_BH_UserArgs_MT32x64x64_MI16x16x1_SN_LDSB1_AFC0_AG0_AGGSUA0_AGNTAB0_AFEM2_AFEM1_ASEM32_BL1_BS1_CD1_1_CLR0_CLS1_CADS0_DTLA0_DTLB0_DTLM0_DTVA0_DTVB0_DTVMXSA0_DTVMXSB0_DTVSM0_DPLB0_EPS0_ELFLR0_EMLLn1_FDSI0_GRPM1_GRVWA1_GRVWB1_GSUAMB_GLS0_HPLR0_ISA1250_ICIW1_IU1_K1_LDSTI0_LBSPPA256_LBSPPB1024_LBSPPMXSA0_LBSPPMXSB0_LBSPPM0_LPA16_LPB32_LPMXSA0_LPMXSB0_LPM0_LRVW16_LWPMn1_MIAV1_MIWT2_2_MXLIBL_MXSFNS_MO40_MGRIPM1_NTn1_NTA0_NTB0_NTC0_NTD0_NTE0_NTMXSA0_NTMXSB0_NTM0_NTWS0_NVn1_NVA0_NVB0_NVC0_NVD0_NVE0_NVMXSA0_NVMXSB0_NVM0_NVWS0_NEPBS0_NLCA1_NLCB1_ONLL1_PAP0_PGL0_PGR2_PLR0_PKA1_SGROB0_SIA3_SS1_SPO0_SRVW0_SSO0_SVW2_SK0_SKFTR0_SKFDPO0_SKWS0_SKXCCM0_SNLL0_SIP1_SGRO0_TDMI0_TDMIM0_TDMLWS0_TDMS0_TIN0_THn1_THA0_THB0_THC0_THD0_THE0_THMXSA0_THMXSB0_THM0_THWS0_TLDS1_TLDSMn1_ULSGRO0_USL1_USLMX0_UDFMAC0_UIOFGRO0_UPLRP0_USFGROn1_USI0_VSn1_VWA2_VWB2_WSGRA0_WSGRB0_WS32_WG16_4_1_WGMXCC1
    .symbol: 'Cijk_Alik_Bjlk_F8F8S_BH_UserArgs_MT32x64x64_MI16x16x1_SN_LDSB1_AFC0_AG0_AGGSUA0_AGNTAB0_AFEM2_AFEM1_ASEM32_BL1_BS1_CD1_1_CLR0_CLS1_CADS0_DTLA0_DTLB0_DTLM0_DTVA0_DTVB0_DTVMXSA0_DTVMXSB0_DTVSM0_DPLB0_EPS0_ELFLR0_EMLLn1_FDSI0_GRPM1_GRVWA1_GRVWB1_GSUAMB_GLS0_HPLR0_ISA1250_ICIW1_IU1_K1_LDSTI0_LBSPPA256_LBSPPB1024_LBSPPMXSA0_LBSPPMXSB0_LBSPPM0_LPA16_LPB32_LPMXSA0_LPMXSB0_LPM0_LRVW16_LWPMn1_MIAV1_MIWT2_2_MXLIBL_MXSFNS_MO40_MGRIPM1_NTn1_NTA0_NTB0_NTC0_NTD0_NTE0_NTMXSA0_NTMXSB0_NTM0_NTWS0_NVn1_NVA0_NVB0_NVC0_NVD0_NVE0_NVMXSA0_NVMXSB0_NVM0_NVWS0_NEPBS0_NLCA1_NLCB1_ONLL1_PAP0_PGL0_PGR2_PLR0_PKA1_SGROB0_SIA3_SS1_SPO0_SRVW0_SSO0_SVW2_SK0_SKFTR0_SKFDPO0_SKWS0_SKXCCM0_SNLL0_SIP1_SGRO0_TDMI0_TDMIM0_TDMLWS0_TDMS0_TIN0_THn1_THA0_THB0_THC0_THD0_THE0_THMXSA0_THMXSB0_THM0_THWS0_TLDS1_TLDSMn1_ULSGRO0_USL1_USLMX0_UDFMAC0_UIOFGRO0_UPLRP0_USFGROn1_USI0_VSn1_VWA2_VWB2_WSGRA0_WSGRB0_WS32_WG16_4_1_WGMXCC1.kd'
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
    .sgpr_count:                 72
    .sgpr_spill_count:           0
    .vgpr_count:                 510
    .vgpr_spill_count:           0
    .wavefront_size:             32
...
.end_amdgpu_metadata
Cijk_Alik_Bjlk_F8F8S_BH_UserArgs_MT32x64x64_MI16x16x1_SN_LDSB1_AFC0_AG0_AGGSUA0_AGNTAB0_AFEM2_AFEM1_ASEM32_BL1_BS1_CD1_1_CLR0_CLS1_CADS0_DTLA0_DTLB0_DTLM0_DTVA0_DTVB0_DTVMXSA0_DTVMXSB0_DTVSM0_DPLB0_EPS0_ELFLR0_EMLLn1_FDSI0_GRPM1_GRVWA1_GRVWB1_GSUAMB_GLS0_HPLR0_ISA1250_ICIW1_IU1_K1_LDSTI0_LBSPPA256_LBSPPB1024_LBSPPMXSA0_LBSPPMXSB0_LBSPPM0_LPA16_LPB32_LPMXSA0_LPMXSB0_LPM0_LRVW16_LWPMn1_MIAV1_MIWT2_2_MXLIBL_MXSFNS_MO40_MGRIPM1_NTn1_NTA0_NTB0_NTC0_NTD0_NTE0_NTMXSA0_NTMXSB0_NTM0_NTWS0_NVn1_NVA0_NVB0_NVC0_NVD0_NVE0_NVMXSA0_NVMXSB0_NVM0_NVWS0_NEPBS0_NLCA1_NLCB1_ONLL1_PAP0_PGL0_PGR2_PLR0_PKA1_SGROB0_SIA3_SS1_SPO0_SRVW0_SSO0_SVW2_SK0_SKFTR0_SKFDPO0_SKWS0_SKXCCM0_SNLL0_SIP1_SGRO0_TDMI0_TDMIM0_TDMLWS0_TDMS0_TIN0_THn1_THA0_THB0_THC0_THD0_THE0_THMXSA0_THMXSB0_THM0_THWS0_TLDS1_TLDSMn1_ULSGRO0_USL1_USLMX0_UDFMAC0_UIOFGRO0_UPLRP0_USFGROn1_USI0_VSn1_VWA2_VWB2_WSGRA0_WSGRB0_WS32_WG16_4_1_WGMXCC1:
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
/* ValuC range: [0-32), serializedStore enabled */
.set vgprValuC, 0
/* ValuA/B   Xn=PLR buffer idx,  In=InnerUnroll idx */
.set vgprBase, 132
.set vgprLocalWriteAddrA, 128
.set vgprLocalWriteAddrB, 129
.set vgprGlobalReadOffsetA, 32
.set vgprGlobalReadOffsetB, 64
.set vgprLocalReadAddrA, 130
.set vgprLocalReadAddrB, 131
.set vgprSerial, 392

/******************************************/
/* VGPR Macro Assignments                 */
/******************************************/
.set vgprValuA_X0_I0_BASE, vgprBase+0
.set vgprValuB_X0_I0_BASE, vgprBase+18
.set vgprValuB_X0_I0_D0_PACK, vgprBase+34
.set vgprG2LA_BASE, vgprBase+68
.set vgprG2LB_BASE, vgprBase+132
.set vgprPackTemp, vgprBase+66
.set vgprValuA_X0_I0, vgprValuA_X0_I0_BASE+0
.set vgprValuB_X0_I0, vgprValuB_X0_I0_BASE+0
.set vgprValuB_X0_I0_D0, vgprValuB_X0_I0_D0_PACK+0
.set vgprValuB_X0_I0_D1, vgprValuB_X0_I0_D0_PACK+1
.set vgprValuB_X0_I0_D2, vgprValuB_X0_I0_D0_PACK+2
.set vgprValuB_X0_I0_D3, vgprValuB_X0_I0_D0_PACK+3
.set vgprValuB_X0_I0_D4, vgprValuB_X0_I0_D0_PACK+4
.set vgprValuB_X0_I0_D5, vgprValuB_X0_I0_D0_PACK+5
.set vgprValuB_X0_I0_D6, vgprValuB_X0_I0_D0_PACK+6
.set vgprValuB_X0_I0_D7, vgprValuB_X0_I0_D0_PACK+7
.set vgprValuB_X0_I0_D8, vgprValuB_X0_I0_D0_PACK+8
.set vgprValuB_X0_I0_D9, vgprValuB_X0_I0_D0_PACK+9
.set vgprValuB_X0_I0_D10, vgprValuB_X0_I0_D0_PACK+10
.set vgprValuB_X0_I0_D11, vgprValuB_X0_I0_D0_PACK+11
.set vgprValuB_X0_I0_D12, vgprValuB_X0_I0_D0_PACK+12
.set vgprValuB_X0_I0_D13, vgprValuB_X0_I0_D0_PACK+13
.set vgprValuB_X0_I0_D14, vgprValuB_X0_I0_D0_PACK+14
.set vgprValuB_X0_I0_D15, vgprValuB_X0_I0_D0_PACK+15
.set vgprValuB_X0_I0_D16, vgprValuB_X0_I0_D0_PACK+16
.set vgprValuB_X0_I0_D17, vgprValuB_X0_I0_D0_PACK+17
.set vgprValuB_X0_I0_D18, vgprValuB_X0_I0_D0_PACK+18
.set vgprValuB_X0_I0_D19, vgprValuB_X0_I0_D0_PACK+19
.set vgprValuB_X0_I0_D20, vgprValuB_X0_I0_D0_PACK+20
.set vgprValuB_X0_I0_D21, vgprValuB_X0_I0_D0_PACK+21
.set vgprValuB_X0_I0_D22, vgprValuB_X0_I0_D0_PACK+22
.set vgprValuB_X0_I0_D23, vgprValuB_X0_I0_D0_PACK+23
.set vgprValuB_X0_I0_D24, vgprValuB_X0_I0_D0_PACK+24
.set vgprValuB_X0_I0_D25, vgprValuB_X0_I0_D0_PACK+25
.set vgprValuB_X0_I0_D26, vgprValuB_X0_I0_D0_PACK+26
.set vgprValuB_X0_I0_D27, vgprValuB_X0_I0_D0_PACK+27
.set vgprValuB_X0_I0_D28, vgprValuB_X0_I0_D0_PACK+28
.set vgprValuB_X0_I0_D29, vgprValuB_X0_I0_D0_PACK+29
.set vgprValuB_X0_I0_D30, vgprValuB_X0_I0_D0_PACK+30
.set vgprValuB_X0_I0_D31, vgprValuB_X0_I0_D0_PACK+31
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
.set constStrideAL, 1
.set sgprStrideA0I, sgprStridesA+0
.set sgprStrideAK, sgprStridesA+1
.set constStrideB1J, 1
.set sgprStrideBL, sgprStridesB+0
.set sgprStrideBK, sgprStridesB+1

.set MT0, 32
.set MT1, 64
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
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_mov_b32 v[vgprSerial-256], v0                    // thread serial id
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
v_cvt_f64_u32 v[6:7], s65                          // s61 = s[sgprWorkGroup0] / s65
v_rcp_f64 v[6:7], v[6:7]                           // s61 = s[sgprWorkGroup0] / s65
v_cvt_f64_u32 v[8:9], s[sgprWorkGroup0]            // s61 = s[sgprWorkGroup0] / s65
v_mul_f64 v[6:7], v[6:7], v[8:9]                   // s61 = s[sgprWorkGroup0] / s65
v_cvt_u32_f64 v6, v[6:7]                           // s61 = s[sgprWorkGroup0] / s65
v_mul_lo_u32 v7, v6, s65                           // s61 = s[sgprWorkGroup0] / s65
v_sub_nc_u32 v8, s[sgprWorkGroup0], v7             // s61 = s[sgprWorkGroup0] / s65
v_cmp_ge_u32 vcc_lo, v8, s65                       // s61 = s[sgprWorkGroup0] / s65
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, vcc_lo                          // s61 = s[sgprWorkGroup0] / s65
v_add_nc_u32 v6, v6, 1                             // s61 = s[sgprWorkGroup0] / s65
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, -1                              // Reset exec
v_mul_lo_u32 v7, v6, s65                           // s61 = s[sgprWorkGroup0] / s65
v_sub_nc_u32 v8, s[sgprWorkGroup0], v7             // s61 = s[sgprWorkGroup0] / s65
v_readfirstlane_b32 s61, v6                        // quotient
v_readfirstlane_b32 s62, v8                        // remainder
s_mul_i32 s61, s61, s65
/* temp1 = (wg%CU_Count)//WGMXCC */
s_lshr_b32 s62, s62, s64
/* temp0 = temp0 + temp1 */
s_add_u32 s61, s61, s62
/* temp1 = (wg%WGMXCC) * ((WGs - (WGs//CU_Count) * CU_Count) if (wg > (WGs//CU_Count) * CU_Count) else CU_Count)//WGMXCC */
v_cvt_f64_u32 v[6:7], s65                          // s62 = s58 / s65
v_rcp_f64 v[6:7], v[6:7]                           // s62 = s58 / s65
v_cvt_f64_u32 v[8:9], s58                          // s62 = s58 / s65
v_mul_f64 v[6:7], v[6:7], v[8:9]                   // s62 = s58 / s65
v_cvt_u32_f64 v6, v[6:7]                           // s62 = s58 / s65
v_mul_lo_u32 v7, v6, s65                           // s62 = s58 / s65
v_sub_nc_u32 v8, s58, v7                           // s62 = s58 / s65
v_cmp_ge_u32 vcc_lo, v8, s65                       // s62 = s58 / s65
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, vcc_lo                          // s62 = s58 / s65
v_add_nc_u32 v6, v6, 1                             // s62 = s58 / s65
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, -1                              // Reset exec
v_readfirstlane_b32 s62, v6                        // quotient
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
/* init: add vgpr [132...331) to pool */
/* init: add vgpr [0...32) to pool */
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
v_lshlrev_b32 v0, 6, v0                            // 1. N offset: nOffset = nIdx * nStride(64)
/* Skip. 2. block offset: bnOffset = 0 when num1DBlocks = 1 */
v_lshlrev_b32 v0, 1, v0                            // 4. apply VectorWidth: bnOffset = bnOffset * vw(2)
v_lshrrev_b32 v1, 4, v1                            // 5. K offset: kIdx = wtid / (MIN(16) * MIBB(1))
v_lshl_add_u32 v0, v1, 4, v0                       // 5. K offset: lrKOffset = kIdx * mStride(16); 6. offset in wave: lrOffset = bnOffset + lrKOffset
/* lr1J */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_and_b32 v2, 31, v[vgprSerial-256]                // 0. thread id in wave: wtid = tid % wavelength(32)
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_and_b32 v1, 15, v2                               // 1. N offset: nIdx = wtid % MI_N(16)
                                                   // 1. N offset: nOffset = nIdx * nStride(1) (multiplier is 1, do nothing)
/* Skip. 2. block offset: bnOffset = 0 when num1DBlocks = 1 */
v_lshlrev_b32 v1, 1, v1                            // 4. apply VectorWidth: bnOffset = bnOffset * vw(2)
v_lshrrev_b32 v2, 4, v2                            // 5. K offset: kIdx = wtid / (MIN(16) * MIBB(1))
v_lshl_add_u32 v1, v2, 10, v1                      // 5. K offset: lrKOffset = kIdx * mStride(1024); 6. offset in wave: lrOffset = bnOffset + lrKOffset
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_lshrrev_b32 v3, 5, v[vgprSerial-256]             // 7. wave offset in N dimen: wtid = tid / dividedForWaveId(32)
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_and_b32 v3, 1, v3                                // 7. wave offset in M dimen: wtid0 = wtid / num1DWaves(2)
v_lshl_add_u32 v1, v3, 5, v1                       // 7. wave offset in M dimen: wOffset = wtid0 * W0Stride(32); 7. final local read offset: flrOffset = lrOffset + WOffset

/* local read addresses: final offsets a */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_lshrrev_b32 v2, 5, v[vgprSerial-256]             // 2 = Serial / 32
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_lshrrev_b32 v2, 1, v2                            // LSU offset: Get LSU wave_id
s_mov_b32 s16, 64                                  // LSU offset: stride = lsuStride(64) when umlds==True
v_mul_lo_u32 v2, s16, v2                           // LSU offset: lsuoffset = wave_id*lsuStride*(MT0+PAD)
v_add_nc_u32 v[vgprLocalReadAddrA], v2, v0         // Final Offset: offset = (lro0+lsuoffset)*bpeDS
                                                   //  (bpe is 1, do nothing)
v_lshrrev_b32 v3, 8, v[vgprLocalReadAddrA]         // Final Offset: padding 16 per block 256
v_lshl_add_u32 v[vgprLocalReadAddrA], v3, 4, v[vgprLocalReadAddrA] // Final Offset: padding 16 per block 256

/* local read addresses: final offsets b */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_lshrrev_b32 v0, 5, v[vgprSerial-256]             // 0 = Serial / 32
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_lshrrev_b32 v0, 1, v0                            // LSU offset: Get LSU wave_id
s_mov_b32 s16, 4096                                // LSU offset: stride = lsuStride(64)*(MT1(64) + PAD1(0))
v_mul_lo_u32 v0, s16, v0                           // LSU offset: lsuoffset = wave_id*lsuStride*(MT1+PAD)
v_add_nc_u32 v[vgprLocalReadAddrB], v0, v1         // Final Offset: offset = (lro1+lsuoffset)*bpeDS
                                                   //  (bpe is 1, do nothing)
v_lshrrev_b32 v2, 10, v[vgprLocalReadAddrB]        // Final Offset: padding 32 per block 1024
v_lshl_add_u32 v[vgprLocalReadAddrB], v2, 5, v[vgprLocalReadAddrB] // Final Offset: padding 32 per block 1024

/* local read addresses: declare addresses a */

/* local read addresses: declare addresses b */
v_add_co_u32 v[vgprLocalReadAddrB+0], vcc_lo, 0x900, v[vgprLocalReadAddrB+0] //  += LdsOffsetB (lower)

/******************************************/
/* Local Write Addresses                  */
/******************************************/
/* LVCA = 64 */
/* v1 = A-unroll = serial%LVCA */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_lshrrev_b32 v0, 6, v[vgprSerial-256]             // 0 = Serial / 64
v_and_b32 v1, 63, v[vgprSerial-256]                // 1 = Serial % 64
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v4, v1                                   // copy for GlobalSplitU
/* LVCB = 64 */
/* v3 = B-unroll = serial/LVCB */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_lshrrev_b32 v3, 6, v[vgprSerial-256]             // 3 = Serial / 64
v_and_b32 v2, 63, v[vgprSerial-256]                // 2 = Serial % 64
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v5, v3                                   // copy for GlobalSplitU
/* lwaUnrollAssignmentA = v4 */
/* lwaUnrollAssignmentB = v5 */

/* local write addresses: first offset a */
v_mul_u32_u24 v[vgprLocalWriteAddrA], 0x40, v0     // lwAL**(DepthU_Compute + PAD)
v_add_nc_u32 v[vgprLocalWriteAddrA], v4, v[vgprLocalWriteAddrA] // lwFOA = (lwAA + lwAL*(DepthU+PAD))
                                                   //  (bpe is 1, do nothing)
v_lshrrev_b32 v6, 8, v[vgprLocalWriteAddrA]        // padding 16 per block 256
v_lshl_add_u32 v[vgprLocalWriteAddrA], v6, 4, v[vgprLocalWriteAddrA] // padding 16 per block 256

/* local write addresses: first offset b */
v_mul_u32_u24 v[vgprLocalWriteAddrB], 0x40, v5     // lwBL**(MTB + PAD)
v_add_nc_u32 v[vgprLocalWriteAddrB], v2, v[vgprLocalWriteAddrB] // lwFOB = (lwBB + lwBL*(MT1J+PAD))
                                                   //  (bpe is 1, do nothing)
v_lshrrev_b32 v6, 10, v[vgprLocalWriteAddrB]       // padding 32 per block 1024
v_lshl_add_u32 v[vgprLocalWriteAddrB], v6, 5, v[vgprLocalWriteAddrB] // padding 32 per block 1024
v_add_co_u32 v[vgprLocalWriteAddrB], vcc_lo, 0x900, v[vgprLocalWriteAddrB] // lwFOB = lw1J + lwL*MT1J + LDS_OFFSET_B=2304
v_mov_b32 v8, MT0                                  // set MT0 into sgpr
v_mov_b32 v7, s[sgprSizesFree+0]                   // set Free0 size
v_cvt_f32_u32 v6, v8                               // v6 = ceil(v7 / v8)
v_rcp_iflag_f32 v6, v6                             // v6 = ceil(v7 / v8)
v_cvt_f32_u32 v9, v7                               // v6 = ceil(v7 / v8)
v_mul_f32 v6, v6, v9                               // v6 = ceil(v7 / v8)
v_cvt_u32_f32 v6, v6                               // v6 = ceil(v7 / v8)
v_mul_u32_u24 v9, v6, v8                           // v6 = ceil(v7 / v8)
v_sub_nc_u32 v9, v7, v9                            // v6 = ceil(v7 / v8)
v_cmp_ne_u32 vcc_lo, v9, 0                         // v6 = ceil(v7 / v8)
v_add_co_ci_u32 v6, vcc_lo, v6, 0, vcc_lo          // ceil
v_mov_b32 v8, MT1                                  // set MT1 into sgpr
v_mov_b32 v7, s[sgprSizesFree+1]                   // set Free1 size
v_readfirstlane_b32 s[sgprNumWorkGroups0], v6      // set back to numWorkGroup0
v_cvt_f32_u32 v6, v8                               // v6 = ceil(v7 / v8)
v_rcp_iflag_f32 v6, v6                             // v6 = ceil(v7 / v8)
v_cvt_f32_u32 v9, v7                               // v6 = ceil(v7 / v8)
v_mul_f32 v6, v6, v9                               // v6 = ceil(v7 / v8)
v_cvt_u32_f32 v6, v6                               // v6 = ceil(v7 / v8)
v_mul_u32_u24 v9, v6, v8                           // v6 = ceil(v7 / v8)
v_sub_nc_u32 v9, v7, v9                            // v6 = ceil(v7 / v8)
v_cmp_ne_u32 vcc_lo, v9, 0                         // v6 = ceil(v7 / v8)
v_add_co_ci_u32 v6, vcc_lo, v6, 0, vcc_lo          // ceil
s_nop 0                                            // 1 wait states
v_readfirstlane_b32 s[sgprNumWorkGroups1], v6      // set back to numWorkGroup1
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
s_lshr_b32 s21, s33, 6                             // s21 = s33 / 64
s_and_b32 s18, 63, s33                             // s18 = s33 % 64
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
s_lshr_b32 s21, s33, 6                             // s21 = s33 / 64
s_and_b32 s18, 63, s33                             // s18 = s33 % 64
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
/* init: add vgpr [132...331) to pool */
/* init: add vgpr [0...32) to pool */
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
v_lshlrev_b32 v0, 6, v0                            // 1. N offset: nOffset = nIdx * nStride(64)
/* Skip. 2. block offset: bnOffset = 0 when num1DBlocks = 1 */
v_lshlrev_b32 v0, 1, v0                            // 4. apply VectorWidth: bnOffset = bnOffset * vw(2)
v_lshrrev_b32 v1, 4, v1                            // 5. K offset: kIdx = wtid / (MIN(16) * MIBB(1))
v_lshl_add_u32 v0, v1, 4, v0                       // 5. K offset: lrKOffset = kIdx * mStride(16); 6. offset in wave: lrOffset = bnOffset + lrKOffset
/* lr1J */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_and_b32 v2, 31, v[vgprSerial-256]                // 0. thread id in wave: wtid = tid % wavelength(32)
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_and_b32 v1, 15, v2                               // 1. N offset: nIdx = wtid % MI_N(16)
                                                   // 1. N offset: nOffset = nIdx * nStride(1) (multiplier is 1, do nothing)
/* Skip. 2. block offset: bnOffset = 0 when num1DBlocks = 1 */
v_lshlrev_b32 v1, 1, v1                            // 4. apply VectorWidth: bnOffset = bnOffset * vw(2)
v_lshrrev_b32 v2, 4, v2                            // 5. K offset: kIdx = wtid / (MIN(16) * MIBB(1))
v_lshl_add_u32 v1, v2, 10, v1                      // 5. K offset: lrKOffset = kIdx * mStride(1024); 6. offset in wave: lrOffset = bnOffset + lrKOffset
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_lshrrev_b32 v3, 5, v[vgprSerial-256]             // 7. wave offset in N dimen: wtid = tid / dividedForWaveId(32)
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_and_b32 v3, 1, v3                                // 7. wave offset in M dimen: wtid0 = wtid / num1DWaves(2)
v_lshl_add_u32 v1, v3, 5, v1                       // 7. wave offset in M dimen: wOffset = wtid0 * W0Stride(32); 7. final local read offset: flrOffset = lrOffset + WOffset

/* local read addresses: final offsets a */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_lshrrev_b32 v2, 5, v[vgprSerial-256]             // 2 = Serial / 32
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_lshrrev_b32 v2, 1, v2                            // LSU offset: Get LSU wave_id
s_mov_b32 s16, 64                                  // LSU offset: stride = lsuStride(64) when umlds==True
v_mul_lo_u32 v2, s16, v2                           // LSU offset: lsuoffset = wave_id*lsuStride*(MT0+PAD)
v_add_nc_u32 v[vgprLocalReadAddrA], v2, v0         // Final Offset: offset = (lro0+lsuoffset)*bpeDS
                                                   //  (bpe is 1, do nothing)
v_lshrrev_b32 v3, 8, v[vgprLocalReadAddrA]         // Final Offset: padding 16 per block 256
v_lshl_add_u32 v[vgprLocalReadAddrA], v3, 4, v[vgprLocalReadAddrA] // Final Offset: padding 16 per block 256

/* local read addresses: final offsets b */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_lshrrev_b32 v0, 5, v[vgprSerial-256]             // 0 = Serial / 32
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_lshrrev_b32 v0, 1, v0                            // LSU offset: Get LSU wave_id
s_mov_b32 s16, 4096                                // LSU offset: stride = lsuStride(64)*(MT1(64) + PAD1(0))
v_mul_lo_u32 v0, s16, v0                           // LSU offset: lsuoffset = wave_id*lsuStride*(MT1+PAD)
v_add_nc_u32 v[vgprLocalReadAddrB], v0, v1         // Final Offset: offset = (lro1+lsuoffset)*bpeDS
                                                   //  (bpe is 1, do nothing)
v_lshrrev_b32 v2, 10, v[vgprLocalReadAddrB]        // Final Offset: padding 32 per block 1024
v_lshl_add_u32 v[vgprLocalReadAddrB], v2, 5, v[vgprLocalReadAddrB] // Final Offset: padding 32 per block 1024

/* local read addresses: declare addresses a */

/* local read addresses: declare addresses b */
v_add_co_u32 v[vgprLocalReadAddrB+0], vcc_lo, 0x900, v[vgprLocalReadAddrB+0] //  += LdsOffsetB (lower)

/******************************************/
/* Local Write Addresses                  */
/******************************************/
/* LVCA = 64 */
/* v1 = A-unroll = serial%LVCA */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_lshrrev_b32 v0, 6, v[vgprSerial-256]             // 0 = Serial / 64
v_and_b32 v1, 63, v[vgprSerial-256]                // 1 = Serial % 64
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v4, v1                                   // copy for GlobalSplitU
/* LVCB = 64 */
/* v3 = B-unroll = serial/LVCB */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_lshrrev_b32 v3, 6, v[vgprSerial-256]             // 3 = Serial / 64
v_and_b32 v2, 63, v[vgprSerial-256]                // 2 = Serial % 64
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v5, v3                                   // copy for GlobalSplitU
/* lwaUnrollAssignmentA = v4 */
/* lwaUnrollAssignmentB = v5 */

/* local write addresses: first offset a */
v_mul_u32_u24 v[vgprLocalWriteAddrA], 0x40, v0     // lwAL**(DepthU_Compute + PAD)
v_add_nc_u32 v[vgprLocalWriteAddrA], v4, v[vgprLocalWriteAddrA] // lwFOA = (lwAA + lwAL*(DepthU+PAD))
                                                   //  (bpe is 1, do nothing)
v_lshrrev_b32 v6, 8, v[vgprLocalWriteAddrA]        // padding 16 per block 256
v_lshl_add_u32 v[vgprLocalWriteAddrA], v6, 4, v[vgprLocalWriteAddrA] // padding 16 per block 256

/* local write addresses: first offset b */
v_mul_u32_u24 v[vgprLocalWriteAddrB], 0x40, v5     // lwBL**(MTB + PAD)
v_add_nc_u32 v[vgprLocalWriteAddrB], v2, v[vgprLocalWriteAddrB] // lwFOB = (lwBB + lwBL*(MT1J+PAD))
                                                   //  (bpe is 1, do nothing)
v_lshrrev_b32 v6, 10, v[vgprLocalWriteAddrB]       // padding 32 per block 1024
v_lshl_add_u32 v[vgprLocalWriteAddrB], v6, 5, v[vgprLocalWriteAddrB] // padding 32 per block 1024
v_add_co_u32 v[vgprLocalWriteAddrB], vcc_lo, 0x900, v[vgprLocalWriteAddrB] // lwFOB = lw1J + lwL*MT1J + LDS_OFFSET_B=2304
v_mov_b32 v8, MT0                                  // set MT0 into sgpr
v_mov_b32 v7, s[sgprSizesFree+0]                   // set Free0 size
v_cvt_f32_u32 v6, v8                               // v6 = ceil(v7 / v8)
v_rcp_iflag_f32 v6, v6                             // v6 = ceil(v7 / v8)
v_cvt_f32_u32 v9, v7                               // v6 = ceil(v7 / v8)
v_mul_f32 v6, v6, v9                               // v6 = ceil(v7 / v8)
v_cvt_u32_f32 v6, v6                               // v6 = ceil(v7 / v8)
v_mul_u32_u24 v9, v6, v8                           // v6 = ceil(v7 / v8)
v_sub_nc_u32 v9, v7, v9                            // v6 = ceil(v7 / v8)
v_cmp_ne_u32 vcc_lo, v9, 0                         // v6 = ceil(v7 / v8)
v_add_co_ci_u32 v6, vcc_lo, v6, 0, vcc_lo          // ceil
v_mov_b32 v8, MT1                                  // set MT1 into sgpr
v_mov_b32 v7, s[sgprSizesFree+1]                   // set Free1 size
v_readfirstlane_b32 s[sgprNumWorkGroups0], v6      // set back to numWorkGroup0
v_cvt_f32_u32 v6, v8                               // v6 = ceil(v7 / v8)
v_rcp_iflag_f32 v6, v6                             // v6 = ceil(v7 / v8)
v_cvt_f32_u32 v9, v7                               // v6 = ceil(v7 / v8)
v_mul_f32 v6, v6, v9                               // v6 = ceil(v7 / v8)
v_cvt_u32_f32 v6, v6                               // v6 = ceil(v7 / v8)
v_mul_u32_u24 v9, v6, v8                           // v6 = ceil(v7 / v8)
v_sub_nc_u32 v9, v7, v9                            // v6 = ceil(v7 / v8)
v_cmp_ne_u32 vcc_lo, v9, 0                         // v6 = ceil(v7 / v8)
v_add_co_ci_u32 v6, vcc_lo, v6, 0, vcc_lo          // ceil
s_nop 0                                            // 1 wait states
v_readfirstlane_b32 s[sgprNumWorkGroups1], v6      // set back to numWorkGroup1
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
.set sgprPackKForV0, 66
.set sgprPackKForV1, 67
s_mov_b32 s[sgprPackKForV0], 0x0c0c0400
s_mov_b32 s[sgprPackKForV1], 0x0c0c0501
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
v_cvt_f64_u32 v[6:7], s16                          // s17 = s[sgprWorkGroup0] / s16
v_rcp_f64 v[6:7], v[6:7]                           // s17 = s[sgprWorkGroup0] / s16
v_cvt_f64_u32 v[8:9], s[sgprWorkGroup0]            // s17 = s[sgprWorkGroup0] / s16
v_mul_f64 v[6:7], v[6:7], v[8:9]                   // s17 = s[sgprWorkGroup0] / s16
v_cvt_u32_f64 v6, v[6:7]                           // s17 = s[sgprWorkGroup0] / s16
v_mul_lo_u32 v7, v6, s16                           // s17 = s[sgprWorkGroup0] / s16
v_sub_nc_u32 v8, s[sgprWorkGroup0], v7             // s17 = s[sgprWorkGroup0] / s16
v_cmp_ge_u32 vcc_lo, v8, s16                       // s17 = s[sgprWorkGroup0] / s16
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, vcc_lo                          // s17 = s[sgprWorkGroup0] / s16
v_add_nc_u32 v6, v6, 1                             // s17 = s[sgprWorkGroup0] / s16
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, -1                              // Reset exec
v_readfirstlane_b32 s17, v6                        // quotient
s_mul_i32 s20, s17, s16                            // quotient * non-magic divisor
s_sub_u32 s20, s[sgprWorkGroup0], s20              // WorkGroup0=remainder
s_mul_i32 s20, s20, s[sgprNumWorkGroups1]          // (wg1 % WGM)*NumWorkGroups1
s_add_u32 s20, s20, s[sgprWorkGroup1]              // wgSerial = wg0 + (wg1 % WGM)*NumWorkGroups1
v_cvt_f64_u32 v[6:7], s16                          // s18 = s[sgprNumWorkGroups0] / s16
v_rcp_f64 v[6:7], v[6:7]                           // s18 = s[sgprNumWorkGroups0] / s16
v_cvt_f64_u32 v[8:9], s[sgprNumWorkGroups0]        // s18 = s[sgprNumWorkGroups0] / s16
v_mul_f64 v[6:7], v[6:7], v[8:9]                   // s18 = s[sgprNumWorkGroups0] / s16
v_cvt_u32_f64 v6, v[6:7]                           // s18 = s[sgprNumWorkGroups0] / s16
v_mul_lo_u32 v7, v6, s16                           // s18 = s[sgprNumWorkGroups0] / s16
v_sub_nc_u32 v8, s[sgprNumWorkGroups0], v7         // s18 = s[sgprNumWorkGroups0] / s16
v_cmp_ge_u32 vcc_lo, v8, s16                       // s18 = s[sgprNumWorkGroups0] / s16
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, vcc_lo                          // s18 = s[sgprNumWorkGroups0] / s16
v_add_nc_u32 v6, v6, 1                             // s18 = s[sgprNumWorkGroups0] / s16
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, -1                              // Reset exec
v_readfirstlane_b32 s18, v6                        // quotient
s_mul_i32 s19, s16, s18                            // quotient * non-magic divisor
s_sub_u32 s19, s[sgprNumWorkGroups0], s19          // NumWorkGroups0=remainder
s_cmp_eq_u32 s19, 0                                // remainder == 0 ?
s_cmov_b32 s19, s16                                // remainder = WGM if remainder == 0
s_cmp_ge_u32 s17, s18                              // blockId >= numFullBlocks ?
s_cselect_b32 s18, s19, s16
v_cvt_f64_u32 v[6:7], s18                          // s[sgprWorkGroup1] = s20 / s18
v_rcp_f64 v[6:7], v[6:7]                           // s[sgprWorkGroup1] = s20 / s18
v_cvt_f64_u32 v[8:9], s20                          // s[sgprWorkGroup1] = s20 / s18
v_mul_f64 v[6:7], v[6:7], v[8:9]                   // s[sgprWorkGroup1] = s20 / s18
v_cvt_u32_f64 v6, v[6:7]                           // s[sgprWorkGroup1] = s20 / s18
v_mul_lo_u32 v7, v6, s18                           // s[sgprWorkGroup1] = s20 / s18
v_sub_nc_u32 v8, s20, v7                           // s[sgprWorkGroup1] = s20 / s18
v_cmp_ge_u32 vcc_lo, v8, s18                       // s[sgprWorkGroup1] = s20 / s18
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, vcc_lo                          // s[sgprWorkGroup1] = s20 / s18
v_add_nc_u32 v6, v6, 1                             // s[sgprWorkGroup1] = s20 / s18
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, -1                              // Reset exec
v_mul_lo_u32 v7, v6, s18                           // s[sgprWorkGroup1] = s20 / s18
v_sub_nc_u32 v8, s20, v7                           // s[sgprWorkGroup1] = s20 / s18
v_readfirstlane_b32 s[sgprWorkGroup1], v6          // quotient
v_readfirstlane_b32 s[sgprWorkGroup0], v8          // remainder
s_mul_i32 s[sgprWorkGroup0], s[sgprWorkGroup1], s18 // quotient * non-magic divisor
s_sub_u32 s[sgprWorkGroup0], s20, s[sgprWorkGroup0] // WorkGroup0=remainder
s_mul_i32 s17, s17, s16                            // blockId * WGM
s_add_u32 s[sgprWorkGroup0], s[sgprWorkGroup0], s17 // wg1 += blockId * WGM
s_branch label_WGM
label_WGMPositive:
s_mov_b32 s16, s16                                 // WGM
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cvt_f64_u32 v[6:7], s16                          // s17 = s[sgprWorkGroup1] / s16
v_rcp_f64 v[6:7], v[6:7]                           // s17 = s[sgprWorkGroup1] / s16
v_cvt_f64_u32 v[8:9], s[sgprWorkGroup1]            // s17 = s[sgprWorkGroup1] / s16
v_mul_f64 v[6:7], v[6:7], v[8:9]                   // s17 = s[sgprWorkGroup1] / s16
v_cvt_u32_f64 v6, v[6:7]                           // s17 = s[sgprWorkGroup1] / s16
v_mul_lo_u32 v7, v6, s16                           // s17 = s[sgprWorkGroup1] / s16
v_sub_nc_u32 v8, s[sgprWorkGroup1], v7             // s17 = s[sgprWorkGroup1] / s16
v_cmp_ge_u32 vcc_lo, v8, s16                       // s17 = s[sgprWorkGroup1] / s16
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, vcc_lo                          // s17 = s[sgprWorkGroup1] / s16
v_add_nc_u32 v6, v6, 1                             // s17 = s[sgprWorkGroup1] / s16
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, -1                              // Reset exec
v_readfirstlane_b32 s17, v6                        // quotient
s_mul_i32 s20, s17, s16                            // quotient * non-magic divisor
s_sub_u32 s20, s[sgprWorkGroup1], s20              // WorkGroup1=remainder
s_mul_i32 s20, s20, s[sgprNumWorkGroups0]          // (wg1 % WGM)*NumWorkGroups0
s_add_u32 s20, s20, s[sgprWorkGroup0]              // wgSerial = wg0 + (wg1 % WGM)*NumWorkGroups0
v_cvt_f64_u32 v[6:7], s16                          // s18 = s[sgprNumWorkGroups1] / s16
v_rcp_f64 v[6:7], v[6:7]                           // s18 = s[sgprNumWorkGroups1] / s16
v_cvt_f64_u32 v[8:9], s[sgprNumWorkGroups1]        // s18 = s[sgprNumWorkGroups1] / s16
v_mul_f64 v[6:7], v[6:7], v[8:9]                   // s18 = s[sgprNumWorkGroups1] / s16
v_cvt_u32_f64 v6, v[6:7]                           // s18 = s[sgprNumWorkGroups1] / s16
v_mul_lo_u32 v7, v6, s16                           // s18 = s[sgprNumWorkGroups1] / s16
v_sub_nc_u32 v8, s[sgprNumWorkGroups1], v7         // s18 = s[sgprNumWorkGroups1] / s16
v_cmp_ge_u32 vcc_lo, v8, s16                       // s18 = s[sgprNumWorkGroups1] / s16
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, vcc_lo                          // s18 = s[sgprNumWorkGroups1] / s16
v_add_nc_u32 v6, v6, 1                             // s18 = s[sgprNumWorkGroups1] / s16
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, -1                              // Reset exec
v_readfirstlane_b32 s18, v6                        // quotient
s_mul_i32 s19, s16, s18                            // quotient * non-magic divisor
s_sub_u32 s19, s[sgprNumWorkGroups1], s19          // NumWorkGroups1=remainder
s_cmp_eq_u32 s19, 0                                // remainder == 0 ?
s_cmov_b32 s19, s16                                // remainder = WGM if remainder == 0
s_cmp_ge_u32 s17, s18                              // blockId >= numFullBlocks ?
s_cselect_b32 s18, s19, s16
v_cvt_f64_u32 v[6:7], s18                          // s[sgprWorkGroup0] = s20 / s18
v_rcp_f64 v[6:7], v[6:7]                           // s[sgprWorkGroup0] = s20 / s18
v_cvt_f64_u32 v[8:9], s20                          // s[sgprWorkGroup0] = s20 / s18
v_mul_f64 v[6:7], v[6:7], v[8:9]                   // s[sgprWorkGroup0] = s20 / s18
v_cvt_u32_f64 v6, v[6:7]                           // s[sgprWorkGroup0] = s20 / s18
v_mul_lo_u32 v7, v6, s18                           // s[sgprWorkGroup0] = s20 / s18
v_sub_nc_u32 v8, s20, v7                           // s[sgprWorkGroup0] = s20 / s18
v_cmp_ge_u32 vcc_lo, v8, s18                       // s[sgprWorkGroup0] = s20 / s18
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, vcc_lo                          // s[sgprWorkGroup0] = s20 / s18
v_add_nc_u32 v6, v6, 1                             // s[sgprWorkGroup0] = s20 / s18
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, -1                              // Reset exec
v_mul_lo_u32 v7, v6, s18                           // s[sgprWorkGroup0] = s20 / s18
v_sub_nc_u32 v8, s20, v7                           // s[sgprWorkGroup0] = s20 / s18
v_readfirstlane_b32 s[sgprWorkGroup0], v6          // quotient
v_readfirstlane_b32 s[sgprWorkGroup1], v8          // remainder
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
v_mov_b32 v132, v0                                 // groA0I_0
v_add_co_u32 v133, vcc_lo, 1, v132                 // groA0I_1 += LSPA
v_add_co_u32 v134, vcc_lo, 1, v133                 // groA0I_2 += LSPA
v_add_co_u32 v135, vcc_lo, 1, v134                 // groA0I_3 += LSPA
v_add_co_u32 v136, vcc_lo, 1, v135                 // groA0I_4 += LSPA
v_add_co_u32 v137, vcc_lo, 1, v136                 // groA0I_5 += LSPA
v_add_co_u32 v138, vcc_lo, 1, v137                 // groA0I_6 += LSPA
v_add_co_u32 v139, vcc_lo, 1, v138                 // groA0I_7 += LSPA
v_add_co_u32 v140, vcc_lo, 1, v139                 // groA0I_8 += LSPA
v_add_co_u32 v141, vcc_lo, 1, v140                 // groA0I_9 += LSPA
v_add_co_u32 v142, vcc_lo, 1, v141                 // groA0I_10 += LSPA
v_add_co_u32 v143, vcc_lo, 1, v142                 // groA0I_11 += LSPA
v_add_co_u32 v144, vcc_lo, 1, v143                 // groA0I_12 += LSPA
v_add_co_u32 v145, vcc_lo, 1, v144                 // groA0I_13 += LSPA
v_add_co_u32 v146, vcc_lo, 1, v145                 // groA0I_14 += LSPA
v_add_co_u32 v147, vcc_lo, 1, v146                 // groA0I_15 += LSPA
v_add_co_u32 v148, vcc_lo, 1, v147                 // groA0I_16 += LSPA
v_add_co_u32 v149, vcc_lo, 1, v148                 // groA0I_17 += LSPA
v_add_co_u32 v150, vcc_lo, 1, v149                 // groA0I_18 += LSPA
v_add_co_u32 v151, vcc_lo, 1, v150                 // groA0I_19 += LSPA
v_add_co_u32 v152, vcc_lo, 1, v151                 // groA0I_20 += LSPA
v_add_co_u32 v153, vcc_lo, 1, v152                 // groA0I_21 += LSPA
v_add_co_u32 v154, vcc_lo, 1, v153                 // groA0I_22 += LSPA
v_add_co_u32 v155, vcc_lo, 1, v154                 // groA0I_23 += LSPA
v_add_co_u32 v156, vcc_lo, 1, v155                 // groA0I_24 += LSPA
v_add_co_u32 v157, vcc_lo, 1, v156                 // groA0I_25 += LSPA
v_add_co_u32 v158, vcc_lo, 1, v157                 // groA0I_26 += LSPA
v_add_co_u32 v159, vcc_lo, 1, v158                 // groA0I_27 += LSPA
v_add_co_u32 v160, vcc_lo, 1, v159                 // groA0I_28 += LSPA
v_add_co_u32 v161, vcc_lo, 1, v160                 // groA0I_29 += LSPA
v_add_co_u32 v162, vcc_lo, 1, v161                 // groA0I_30 += LSPA
v_add_co_u32 v163, vcc_lo, 1, v162                 // groA0I_31 += LSPA

/* global read addresses: tile offsets b */
v_mov_b32 v6, v2                                   // groB1J_0

/* global read addresses: unroll offsets a */
v_mov_b32 v7, v1                                   // groAL_0

/* global read addresses: unroll offsets b */
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_mov_b32 v[393-256], v3                           // groBL_0
s_set_vgpr_msb 16452                               // src0: 0, src1: 1, src2: 0, dst: 1
v_add_co_u32 v[394-256], vcc_lo, 1, v[393-256]     // groBL_1 + LSPB
v_add_co_u32 v[395-256], vcc_lo, 1, v[394-256]     // groBL_2 + LSPB
v_add_co_u32 v[396-256], vcc_lo, 1, v[395-256]     // groBL_3 + LSPB
v_add_co_u32 v[397-256], vcc_lo, 1, v[396-256]     // groBL_4 + LSPB
v_add_co_u32 v[398-256], vcc_lo, 1, v[397-256]     // groBL_5 + LSPB
v_add_co_u32 v[399-256], vcc_lo, 1, v[398-256]     // groBL_6 + LSPB
v_add_co_u32 v[400-256], vcc_lo, 1, v[399-256]     // groBL_7 + LSPB
v_add_co_u32 v[401-256], vcc_lo, 1, v[400-256]     // groBL_8 + LSPB
v_add_co_u32 v[402-256], vcc_lo, 1, v[401-256]     // groBL_9 + LSPB
v_add_co_u32 v[403-256], vcc_lo, 1, v[402-256]     // groBL_10 + LSPB
v_add_co_u32 v[404-256], vcc_lo, 1, v[403-256]     // groBL_11 + LSPB
v_add_co_u32 v[405-256], vcc_lo, 1, v[404-256]     // groBL_12 + LSPB
v_add_co_u32 v[406-256], vcc_lo, 1, v[405-256]     // groBL_13 + LSPB
v_add_co_u32 v[407-256], vcc_lo, 1, v[406-256]     // groBL_14 + LSPB
v_add_co_u32 v[408-256], vcc_lo, 1, v[407-256]     // groBL_15 + LSPB
v_add_co_u32 v[409-256], vcc_lo, 1, v[408-256]     // groBL_16 + LSPB
v_add_co_u32 v[410-256], vcc_lo, 1, v[409-256]     // groBL_17 + LSPB
v_add_co_u32 v[411-256], vcc_lo, 1, v[410-256]     // groBL_18 + LSPB
v_add_co_u32 v[412-256], vcc_lo, 1, v[411-256]     // groBL_19 + LSPB
v_add_co_u32 v[413-256], vcc_lo, 1, v[412-256]     // groBL_20 + LSPB
v_add_co_u32 v[414-256], vcc_lo, 1, v[413-256]     // groBL_21 + LSPB
v_add_co_u32 v[415-256], vcc_lo, 1, v[414-256]     // groBL_22 + LSPB
v_add_co_u32 v[416-256], vcc_lo, 1, v[415-256]     // groBL_23 + LSPB
v_add_co_u32 v[417-256], vcc_lo, 1, v[416-256]     // groBL_24 + LSPB
v_add_co_u32 v[418-256], vcc_lo, 1, v[417-256]     // groBL_25 + LSPB
v_add_co_u32 v[419-256], vcc_lo, 1, v[418-256]     // groBL_26 + LSPB
v_add_co_u32 v[420-256], vcc_lo, 1, v[419-256]     // groBL_27 + LSPB
v_add_co_u32 v[421-256], vcc_lo, 1, v[420-256]     // groBL_28 + LSPB
v_add_co_u32 v[422-256], vcc_lo, 1, v[421-256]     // groBL_29 + LSPB
v_add_co_u32 v[423-256], vcc_lo, 1, v[422-256]     // groBL_30 + LSPB
v_add_co_u32 v[424-256], vcc_lo, 1, v[423-256]     // groBL_31 + LSPB
v_add_co_u32 v[425-256], vcc_lo, 1, v[424-256]     // groBL_32 + LSPB
v_add_co_u32 v[426-256], vcc_lo, 1, v[425-256]     // groBL_33 + LSPB
v_add_co_u32 v[427-256], vcc_lo, 1, v[426-256]     // groBL_34 + LSPB
v_add_co_u32 v[428-256], vcc_lo, 1, v[427-256]     // groBL_35 + LSPB
v_add_co_u32 v[429-256], vcc_lo, 1, v[428-256]     // groBL_36 + LSPB
v_add_co_u32 v[430-256], vcc_lo, 1, v[429-256]     // groBL_37 + LSPB
v_add_co_u32 v[431-256], vcc_lo, 1, v[430-256]     // groBL_38 + LSPB
v_add_co_u32 v[432-256], vcc_lo, 1, v[431-256]     // groBL_39 + LSPB
v_add_co_u32 v[433-256], vcc_lo, 1, v[432-256]     // groBL_40 + LSPB
v_add_co_u32 v[434-256], vcc_lo, 1, v[433-256]     // groBL_41 + LSPB
v_add_co_u32 v[435-256], vcc_lo, 1, v[434-256]     // groBL_42 + LSPB
v_add_co_u32 v[436-256], vcc_lo, 1, v[435-256]     // groBL_43 + LSPB
v_add_co_u32 v[437-256], vcc_lo, 1, v[436-256]     // groBL_44 + LSPB
v_add_co_u32 v[438-256], vcc_lo, 1, v[437-256]     // groBL_45 + LSPB
v_add_co_u32 v[439-256], vcc_lo, 1, v[438-256]     // groBL_46 + LSPB
v_add_co_u32 v[440-256], vcc_lo, 1, v[439-256]     // groBL_47 + LSPB
v_add_co_u32 v[441-256], vcc_lo, 1, v[440-256]     // groBL_48 + LSPB
v_add_co_u32 v[442-256], vcc_lo, 1, v[441-256]     // groBL_49 + LSPB
v_add_co_u32 v[443-256], vcc_lo, 1, v[442-256]     // groBL_50 + LSPB
v_add_co_u32 v[444-256], vcc_lo, 1, v[443-256]     // groBL_51 + LSPB
v_add_co_u32 v[445-256], vcc_lo, 1, v[444-256]     // groBL_52 + LSPB
v_add_co_u32 v[446-256], vcc_lo, 1, v[445-256]     // groBL_53 + LSPB
v_add_co_u32 v[447-256], vcc_lo, 1, v[446-256]     // groBL_54 + LSPB
v_add_co_u32 v[448-256], vcc_lo, 1, v[447-256]     // groBL_55 + LSPB
v_add_co_u32 v[449-256], vcc_lo, 1, v[448-256]     // groBL_56 + LSPB
v_add_co_u32 v[450-256], vcc_lo, 1, v[449-256]     // groBL_57 + LSPB
v_add_co_u32 v[451-256], vcc_lo, 1, v[450-256]     // groBL_58 + LSPB
v_add_co_u32 v[452-256], vcc_lo, 1, v[451-256]     // groBL_59 + LSPB
v_add_co_u32 v[453-256], vcc_lo, 1, v[452-256]     // groBL_60 + LSPB
v_add_co_u32 v[454-256], vcc_lo, 1, v[453-256]     // groBL_61 + LSPB
v_add_co_u32 v[455-256], vcc_lo, 1, v[454-256]     // groBL_62 + LSPB
v_add_co_u32 v[456-256], vcc_lo, 1, v[455-256]     // groBL_63 + LSPB

/* global read addresses: addresses a */
/* max read offset = size[n] * stride[n-1] */
s_mul_hi_u32 s19, s[sgprWorkGroup0], 32            // WorkGroup[01] * MT
s_mul_i32 s18, s[sgprWorkGroup0], 32               // WorkGroup[01] * MT
s_mul_hi_u32 s19, s18, s[sgprStrideA0I]            // tlu=0, scaled tile-offset by stride
s_mul_i32 s18, s18, s[sgprStrideA0I]               // tlu=0, scaled tile-offset by stride
s_and_b32 s16, s[sgprGSU], 0x8000                  // SCC = (GSUC == 1) ?
s_cbranch_scc1 label_GSUC_A                        // branch if GSUC == 1
s_mul_hi_u32 s17, 64, s[sgprGSUSumIdx]             // gsuOffset = DepthU*GSUSumIdx
s_mul_i32 s16, 64, s[sgprGSUSumIdx]                // gsuOffset = DepthU*GSUSumIdx
s_branch label_GSUC_A_End
label_GSUC_A:
s_lshr_b32 s[sgprLoopCounterL], s[sgprSizesSum], 6 // s[LoopCounterL] = s[sgprSizesSum] / 64
s_and_b32 s[sgprGSUSumIdx+1], s[sgprGSU], 0x3fff   // Restore GSU
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cvt_f32_u32 v8, s[sgprGSUSumIdx+1]               // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
v_rcp_iflag_f32 v8, v8                             // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
v_cvt_f32_u32 v9, s[sgprLoopCounterL]              // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
v_mul_f32 v8, v8, v9                               // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
v_cvt_u32_f32 v8, v8                               // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
v_mul_u32_u24 v9, v8, s[sgprGSUSumIdx+1]           // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
v_sub_nc_u32 v9, s[sgprLoopCounterL], v9           // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
v_cmp_eq_u32 vcc_lo, v9, s[sgprGSUSumIdx+1]        // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, vcc_lo                          // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
v_add_nc_u32 v8, 1, v8                             // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
v_mov_b32 v9, 0                                    // s[sgprGSUSumIdx+1] = s[sgprLoopCounterL] % s[sgprGSUSumIdx+1]
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, -1                              // Reset exec
v_cmp_gt_u32 vcc_lo, v9, s[sgprGSUSumIdx+1]        // overflow happened in remainder
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, vcc_lo                          // overflow happened in remainder
v_sub_nc_u32 v8, v8, 1                             // quotient - 1
v_mul_u32_u24 v9, v8, s[sgprGSUSumIdx+1]           // re-calculate remainder
v_sub_nc_u32 v9, s[sgprLoopCounterL], v9           // re-calculate remainder
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, -1                              // Reset exec
v_readfirstlane_b32 s[sgprLoopCounterL], v8        // quotient
v_readfirstlane_b32 s[sgprGSUSumIdx+1], v9         // remainder
s_mul_i32 s17, s[sgprLoopCounterL], s[sgprGSUSumIdx] // quotient*GSUSumIdx
s_add_u32 s16, 1, s[sgprLoopCounterL]              // quotient+1
s_add_u32 s17, s17, s[sgprGSUSumIdx+1]             // quotient*GSUSumIdx+remainder
s_mul_i32 s16, s16, s[sgprGSUSumIdx]               // (quotient+1)*GSUSumIdx
s_cmp_lt_u32 s[sgprGSUSumIdx], s[sgprGSUSumIdx+1]  // gsuSumIdx < numIterPerWgRemainder
s_cselect_b32 s16, s16, s17                        // (quotient+1)*GSUSumIdx if needed
s_mul_hi_u32 s17, s16, 64                          // gsuOffset = DepthU*accumulatedNumOfLoopCounterL
s_mul_i32 s16, s16, 64                             // gsuOffset = DepthU*accumulatedNumOfLoopCounterL
label_GSUC_A_End:
s_add_u32 s18, s18, s16                            // accum GsuOffset term to tilestart
s_addc_u32 s19, s19, s17                           // accum GsuOffset term to tilestart
s_mov_b64 s[sgprShadowLimitA+0:sgprShadowLimitA+0+1], 1 // Init tensor size
s_sub_u32 s16, s[sgprSizeL], 1                     // (size-1)
s_mul_hi_u32 s17, constStrideAL, s16               // stride x (size-1)
s_mul_i32 s16, constStrideAL, s16                  // stride x (size-1)
s_add_u32 s[sgprShadowLimitA+0], s[sgprShadowLimitA+0], s16 // sum tensor size
s_addc_u32 s[sgprShadowLimitA+1], s[sgprShadowLimitA+1], s17 // sum tensor size
s_sub_u32 s16, s[sgprSizeI], 1                     // (size-1)
s_mul_hi_u32 s17, s[sgprStrideA0I], s16            // stride x (size-1)
s_mul_i32 s16, s[sgprStrideA0I], s16               // stride x (size-1)
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
s_mul_hi_u32 s19, s[sgprWorkGroup1], 64            // WorkGroup[01] * MT
s_mul_i32 s18, s[sgprWorkGroup1], 64               // WorkGroup[01] * MT
s_and_b32 s16, s[sgprGSU], 0x8000                  // SCC = (GSUC == 1) ?
s_cbranch_scc1 label_GSUC_B                        // branch if GSUC == 1
s_mul_hi_u32 s17, 64, s[sgprGSUSumIdx]             // gsuOffset = DepthU*GSUSumIdx
s_mul_i32 s16, 64, s[sgprGSUSumIdx]                // gsuOffset = DepthU*GSUSumIdx
s_branch label_GSUC_B_End
label_GSUC_B:
s_lshr_b32 s[sgprLoopCounterL], s[sgprSizesSum], 6 // s[LoopCounterL] = s[sgprSizesSum] / 64
s_and_b32 s[sgprGSUSumIdx+1], s[sgprGSU], 0x3fff   // Restore GSU
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cvt_f32_u32 v8, s[sgprGSUSumIdx+1]               // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
v_rcp_iflag_f32 v8, v8                             // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
v_cvt_f32_u32 v9, s[sgprLoopCounterL]              // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
v_mul_f32 v8, v8, v9                               // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
v_cvt_u32_f32 v8, v8                               // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
v_mul_u32_u24 v9, v8, s[sgprGSUSumIdx+1]           // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
v_sub_nc_u32 v9, s[sgprLoopCounterL], v9           // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
v_cmp_eq_u32 vcc_lo, v9, s[sgprGSUSumIdx+1]        // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, vcc_lo                          // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
v_add_nc_u32 v8, 1, v8                             // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
v_mov_b32 v9, 0                                    // s[sgprGSUSumIdx+1] = s[sgprLoopCounterL] % s[sgprGSUSumIdx+1]
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, -1                              // Reset exec
v_cmp_gt_u32 vcc_lo, v9, s[sgprGSUSumIdx+1]        // overflow happened in remainder
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, vcc_lo                          // overflow happened in remainder
v_sub_nc_u32 v8, v8, 1                             // quotient - 1
v_mul_u32_u24 v9, v8, s[sgprGSUSumIdx+1]           // re-calculate remainder
v_sub_nc_u32 v9, s[sgprLoopCounterL], v9           // re-calculate remainder
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, -1                              // Reset exec
v_readfirstlane_b32 s[sgprLoopCounterL], v8        // quotient
v_readfirstlane_b32 s[sgprGSUSumIdx+1], v9         // remainder
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
v_mul_lo_u32 v8, s[sgprStrideA0I], v132            // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetA+0], vcc_lo, v7, v8 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetA+0], 0x1, v[vgprGlobalReadOffsetA+0] // add prepad for pointer shift

/* Global Offset A (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset A */
v_mul_lo_u32 v8, s[sgprStrideA0I], v133            // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetA+1], vcc_lo, v7, v8 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetA+1], 0x1, v[vgprGlobalReadOffsetA+1] // add prepad for pointer shift

/* Global Offset A (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset A */
v_mul_lo_u32 v8, s[sgprStrideA0I], v134            // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetA+2], vcc_lo, v7, v8 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetA+2], 0x1, v[vgprGlobalReadOffsetA+2] // add prepad for pointer shift

/* Global Offset A (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset A */
v_mul_lo_u32 v8, s[sgprStrideA0I], v135            // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetA+3], vcc_lo, v7, v8 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetA+3], 0x1, v[vgprGlobalReadOffsetA+3] // add prepad for pointer shift

/* Global Offset A (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset A */
v_mul_lo_u32 v8, s[sgprStrideA0I], v136            // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetA+4], vcc_lo, v7, v8 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetA+4], 0x1, v[vgprGlobalReadOffsetA+4] // add prepad for pointer shift

/* Global Offset A (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset A */
v_mul_lo_u32 v8, s[sgprStrideA0I], v137            // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetA+5], vcc_lo, v7, v8 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetA+5], 0x1, v[vgprGlobalReadOffsetA+5] // add prepad for pointer shift

/* Global Offset A (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset A */
v_mul_lo_u32 v8, s[sgprStrideA0I], v138            // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetA+6], vcc_lo, v7, v8 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetA+6], 0x1, v[vgprGlobalReadOffsetA+6] // add prepad for pointer shift

/* Global Offset A (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset A */
v_mul_lo_u32 v8, s[sgprStrideA0I], v139            // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetA+7], vcc_lo, v7, v8 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetA+7], 0x1, v[vgprGlobalReadOffsetA+7] // add prepad for pointer shift

/* Global Offset A (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset A */
v_mul_lo_u32 v8, s[sgprStrideA0I], v140            // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetA+8], vcc_lo, v7, v8 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetA+8], 0x1, v[vgprGlobalReadOffsetA+8] // add prepad for pointer shift

/* Global Offset A (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset A */
v_mul_lo_u32 v8, s[sgprStrideA0I], v141            // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetA+9], vcc_lo, v7, v8 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetA+9], 0x1, v[vgprGlobalReadOffsetA+9] // add prepad for pointer shift

/* Global Offset A (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset A */
v_mul_lo_u32 v8, s[sgprStrideA0I], v142            // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetA+10], vcc_lo, v7, v8 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetA+10], 0x1, v[vgprGlobalReadOffsetA+10] // add prepad for pointer shift

/* Global Offset A (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset A */
v_mul_lo_u32 v8, s[sgprStrideA0I], v143            // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetA+11], vcc_lo, v7, v8 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetA+11], 0x1, v[vgprGlobalReadOffsetA+11] // add prepad for pointer shift

/* Global Offset A (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset A */
v_mul_lo_u32 v8, s[sgprStrideA0I], v144            // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetA+12], vcc_lo, v7, v8 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetA+12], 0x1, v[vgprGlobalReadOffsetA+12] // add prepad for pointer shift

/* Global Offset A (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset A */
v_mul_lo_u32 v8, s[sgprStrideA0I], v145            // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetA+13], vcc_lo, v7, v8 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetA+13], 0x1, v[vgprGlobalReadOffsetA+13] // add prepad for pointer shift

/* Global Offset A (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset A */
v_mul_lo_u32 v8, s[sgprStrideA0I], v146            // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetA+14], vcc_lo, v7, v8 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetA+14], 0x1, v[vgprGlobalReadOffsetA+14] // add prepad for pointer shift

/* Global Offset A (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset A */
v_mul_lo_u32 v8, s[sgprStrideA0I], v147            // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetA+15], vcc_lo, v7, v8 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetA+15], 0x1, v[vgprGlobalReadOffsetA+15] // add prepad for pointer shift

/* Global Offset A (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset A */
v_mul_lo_u32 v8, s[sgprStrideA0I], v148            // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetA+16], vcc_lo, v7, v8 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetA+16], 0x1, v[vgprGlobalReadOffsetA+16] // add prepad for pointer shift

/* Global Offset A (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset A */
v_mul_lo_u32 v8, s[sgprStrideA0I], v149            // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetA+17], vcc_lo, v7, v8 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetA+17], 0x1, v[vgprGlobalReadOffsetA+17] // add prepad for pointer shift

/* Global Offset A (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset A */
v_mul_lo_u32 v8, s[sgprStrideA0I], v150            // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetA+18], vcc_lo, v7, v8 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetA+18], 0x1, v[vgprGlobalReadOffsetA+18] // add prepad for pointer shift

/* Global Offset A (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset A */
v_mul_lo_u32 v8, s[sgprStrideA0I], v151            // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetA+19], vcc_lo, v7, v8 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetA+19], 0x1, v[vgprGlobalReadOffsetA+19] // add prepad for pointer shift

/* Global Offset A (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset A */
v_mul_lo_u32 v8, s[sgprStrideA0I], v152            // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetA+20], vcc_lo, v7, v8 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetA+20], 0x1, v[vgprGlobalReadOffsetA+20] // add prepad for pointer shift

/* Global Offset A (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset A */
v_mul_lo_u32 v8, s[sgprStrideA0I], v153            // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetA+21], vcc_lo, v7, v8 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetA+21], 0x1, v[vgprGlobalReadOffsetA+21] // add prepad for pointer shift

/* Global Offset A (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset A */
v_mul_lo_u32 v8, s[sgprStrideA0I], v154            // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetA+22], vcc_lo, v7, v8 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetA+22], 0x1, v[vgprGlobalReadOffsetA+22] // add prepad for pointer shift

/* Global Offset A (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset A */
v_mul_lo_u32 v8, s[sgprStrideA0I], v155            // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetA+23], vcc_lo, v7, v8 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetA+23], 0x1, v[vgprGlobalReadOffsetA+23] // add prepad for pointer shift

/* Global Offset A (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset A */
v_mul_lo_u32 v8, s[sgprStrideA0I], v156            // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetA+24], vcc_lo, v7, v8 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetA+24], 0x1, v[vgprGlobalReadOffsetA+24] // add prepad for pointer shift

/* Global Offset A (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset A */
v_mul_lo_u32 v8, s[sgprStrideA0I], v157            // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetA+25], vcc_lo, v7, v8 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetA+25], 0x1, v[vgprGlobalReadOffsetA+25] // add prepad for pointer shift

/* Global Offset A (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset A */
v_mul_lo_u32 v8, s[sgprStrideA0I], v158            // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetA+26], vcc_lo, v7, v8 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetA+26], 0x1, v[vgprGlobalReadOffsetA+26] // add prepad for pointer shift

/* Global Offset A (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset A */
v_mul_lo_u32 v8, s[sgprStrideA0I], v159            // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetA+27], vcc_lo, v7, v8 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetA+27], 0x1, v[vgprGlobalReadOffsetA+27] // add prepad for pointer shift

/* Global Offset A (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset A */
v_mul_lo_u32 v8, s[sgprStrideA0I], v160            // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetA+28], vcc_lo, v7, v8 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetA+28], 0x1, v[vgprGlobalReadOffsetA+28] // add prepad for pointer shift

/* Global Offset A (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset A */
v_mul_lo_u32 v8, s[sgprStrideA0I], v161            // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetA+29], vcc_lo, v7, v8 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetA+29], 0x1, v[vgprGlobalReadOffsetA+29] // add prepad for pointer shift

/* Global Offset A (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset A */
v_mul_lo_u32 v8, s[sgprStrideA0I], v162            // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetA+30], vcc_lo, v7, v8 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetA+30], 0x1, v[vgprGlobalReadOffsetA+30] // add prepad for pointer shift

/* Global Offset A (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset A */
v_mul_lo_u32 v8, s[sgprStrideA0I], v163            // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetA+31], vcc_lo, v7, v8 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetA+31], 0x1, v[vgprGlobalReadOffsetA+31] // add prepad for pointer shift

/* Global Offset A (end) */
                                                   //  (bpe is 1, do nothing)
/* ============================================================= */

/* global read addresses: final offsets b */
/* ============================================================= */

/* Global Offset B */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_mul_lo_u32 v7, s[sgprStrideBL], v[393-256]       // mul d1 lower
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v[vgprGlobalReadOffsetB+0], vcc_lo, v6, v7 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+0], 0x1, v[vgprGlobalReadOffsetB+0] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset B */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_mul_lo_u32 v7, s[sgprStrideBL], v[394-256]       // mul d1 lower
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v[vgprGlobalReadOffsetB+1], vcc_lo, v6, v7 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+1], 0x1, v[vgprGlobalReadOffsetB+1] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset B */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_mul_lo_u32 v7, s[sgprStrideBL], v[395-256]       // mul d1 lower
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v[vgprGlobalReadOffsetB+2], vcc_lo, v6, v7 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+2], 0x1, v[vgprGlobalReadOffsetB+2] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset B */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_mul_lo_u32 v7, s[sgprStrideBL], v[396-256]       // mul d1 lower
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v[vgprGlobalReadOffsetB+3], vcc_lo, v6, v7 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+3], 0x1, v[vgprGlobalReadOffsetB+3] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset B */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_mul_lo_u32 v7, s[sgprStrideBL], v[397-256]       // mul d1 lower
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v[vgprGlobalReadOffsetB+4], vcc_lo, v6, v7 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+4], 0x1, v[vgprGlobalReadOffsetB+4] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset B */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_mul_lo_u32 v7, s[sgprStrideBL], v[398-256]       // mul d1 lower
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v[vgprGlobalReadOffsetB+5], vcc_lo, v6, v7 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+5], 0x1, v[vgprGlobalReadOffsetB+5] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset B */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_mul_lo_u32 v7, s[sgprStrideBL], v[399-256]       // mul d1 lower
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v[vgprGlobalReadOffsetB+6], vcc_lo, v6, v7 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+6], 0x1, v[vgprGlobalReadOffsetB+6] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset B */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_mul_lo_u32 v7, s[sgprStrideBL], v[400-256]       // mul d1 lower
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v[vgprGlobalReadOffsetB+7], vcc_lo, v6, v7 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+7], 0x1, v[vgprGlobalReadOffsetB+7] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset B */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_mul_lo_u32 v7, s[sgprStrideBL], v[401-256]       // mul d1 lower
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v[vgprGlobalReadOffsetB+8], vcc_lo, v6, v7 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+8], 0x1, v[vgprGlobalReadOffsetB+8] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset B */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_mul_lo_u32 v7, s[sgprStrideBL], v[402-256]       // mul d1 lower
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v[vgprGlobalReadOffsetB+9], vcc_lo, v6, v7 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+9], 0x1, v[vgprGlobalReadOffsetB+9] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset B */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_mul_lo_u32 v7, s[sgprStrideBL], v[403-256]       // mul d1 lower
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v[vgprGlobalReadOffsetB+10], vcc_lo, v6, v7 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+10], 0x1, v[vgprGlobalReadOffsetB+10] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset B */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_mul_lo_u32 v7, s[sgprStrideBL], v[404-256]       // mul d1 lower
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v[vgprGlobalReadOffsetB+11], vcc_lo, v6, v7 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+11], 0x1, v[vgprGlobalReadOffsetB+11] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset B */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_mul_lo_u32 v7, s[sgprStrideBL], v[405-256]       // mul d1 lower
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v[vgprGlobalReadOffsetB+12], vcc_lo, v6, v7 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+12], 0x1, v[vgprGlobalReadOffsetB+12] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset B */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_mul_lo_u32 v7, s[sgprStrideBL], v[406-256]       // mul d1 lower
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v[vgprGlobalReadOffsetB+13], vcc_lo, v6, v7 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+13], 0x1, v[vgprGlobalReadOffsetB+13] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset B */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_mul_lo_u32 v7, s[sgprStrideBL], v[407-256]       // mul d1 lower
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v[vgprGlobalReadOffsetB+14], vcc_lo, v6, v7 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+14], 0x1, v[vgprGlobalReadOffsetB+14] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset B */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_mul_lo_u32 v7, s[sgprStrideBL], v[408-256]       // mul d1 lower
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v[vgprGlobalReadOffsetB+15], vcc_lo, v6, v7 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+15], 0x1, v[vgprGlobalReadOffsetB+15] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset B */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_mul_lo_u32 v7, s[sgprStrideBL], v[409-256]       // mul d1 lower
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v[vgprGlobalReadOffsetB+16], vcc_lo, v6, v7 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+16], 0x1, v[vgprGlobalReadOffsetB+16] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset B */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_mul_lo_u32 v7, s[sgprStrideBL], v[410-256]       // mul d1 lower
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v[vgprGlobalReadOffsetB+17], vcc_lo, v6, v7 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+17], 0x1, v[vgprGlobalReadOffsetB+17] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset B */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_mul_lo_u32 v7, s[sgprStrideBL], v[411-256]       // mul d1 lower
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v[vgprGlobalReadOffsetB+18], vcc_lo, v6, v7 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+18], 0x1, v[vgprGlobalReadOffsetB+18] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset B */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_mul_lo_u32 v7, s[sgprStrideBL], v[412-256]       // mul d1 lower
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v[vgprGlobalReadOffsetB+19], vcc_lo, v6, v7 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+19], 0x1, v[vgprGlobalReadOffsetB+19] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset B */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_mul_lo_u32 v7, s[sgprStrideBL], v[413-256]       // mul d1 lower
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v[vgprGlobalReadOffsetB+20], vcc_lo, v6, v7 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+20], 0x1, v[vgprGlobalReadOffsetB+20] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset B */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_mul_lo_u32 v7, s[sgprStrideBL], v[414-256]       // mul d1 lower
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v[vgprGlobalReadOffsetB+21], vcc_lo, v6, v7 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+21], 0x1, v[vgprGlobalReadOffsetB+21] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset B */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_mul_lo_u32 v7, s[sgprStrideBL], v[415-256]       // mul d1 lower
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v[vgprGlobalReadOffsetB+22], vcc_lo, v6, v7 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+22], 0x1, v[vgprGlobalReadOffsetB+22] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset B */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_mul_lo_u32 v7, s[sgprStrideBL], v[416-256]       // mul d1 lower
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v[vgprGlobalReadOffsetB+23], vcc_lo, v6, v7 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+23], 0x1, v[vgprGlobalReadOffsetB+23] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset B */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_mul_lo_u32 v7, s[sgprStrideBL], v[417-256]       // mul d1 lower
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v[vgprGlobalReadOffsetB+24], vcc_lo, v6, v7 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+24], 0x1, v[vgprGlobalReadOffsetB+24] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset B */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_mul_lo_u32 v7, s[sgprStrideBL], v[418-256]       // mul d1 lower
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v[vgprGlobalReadOffsetB+25], vcc_lo, v6, v7 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+25], 0x1, v[vgprGlobalReadOffsetB+25] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset B */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_mul_lo_u32 v7, s[sgprStrideBL], v[419-256]       // mul d1 lower
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v[vgprGlobalReadOffsetB+26], vcc_lo, v6, v7 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+26], 0x1, v[vgprGlobalReadOffsetB+26] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset B */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_mul_lo_u32 v7, s[sgprStrideBL], v[420-256]       // mul d1 lower
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v[vgprGlobalReadOffsetB+27], vcc_lo, v6, v7 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+27], 0x1, v[vgprGlobalReadOffsetB+27] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset B */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_mul_lo_u32 v7, s[sgprStrideBL], v[421-256]       // mul d1 lower
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v[vgprGlobalReadOffsetB+28], vcc_lo, v6, v7 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+28], 0x1, v[vgprGlobalReadOffsetB+28] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset B */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_mul_lo_u32 v7, s[sgprStrideBL], v[422-256]       // mul d1 lower
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v[vgprGlobalReadOffsetB+29], vcc_lo, v6, v7 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+29], 0x1, v[vgprGlobalReadOffsetB+29] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset B */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_mul_lo_u32 v7, s[sgprStrideBL], v[423-256]       // mul d1 lower
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v[vgprGlobalReadOffsetB+30], vcc_lo, v6, v7 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+30], 0x1, v[vgprGlobalReadOffsetB+30] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset B */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_mul_lo_u32 v7, s[sgprStrideBL], v[424-256]       // mul d1 lower
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v[vgprGlobalReadOffsetB+31], vcc_lo, v6, v7 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+31], 0x1, v[vgprGlobalReadOffsetB+31] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset B */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_mul_lo_u32 v7, s[sgprStrideBL], v[425-256]       // mul d1 lower
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v[vgprGlobalReadOffsetB+32], vcc_lo, v6, v7 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+32], 0x1, v[vgprGlobalReadOffsetB+32] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset B */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_mul_lo_u32 v7, s[sgprStrideBL], v[426-256]       // mul d1 lower
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v[vgprGlobalReadOffsetB+33], vcc_lo, v6, v7 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+33], 0x1, v[vgprGlobalReadOffsetB+33] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset B */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_mul_lo_u32 v7, s[sgprStrideBL], v[427-256]       // mul d1 lower
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v[vgprGlobalReadOffsetB+34], vcc_lo, v6, v7 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+34], 0x1, v[vgprGlobalReadOffsetB+34] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset B */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_mul_lo_u32 v7, s[sgprStrideBL], v[428-256]       // mul d1 lower
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v[vgprGlobalReadOffsetB+35], vcc_lo, v6, v7 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+35], 0x1, v[vgprGlobalReadOffsetB+35] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset B */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_mul_lo_u32 v7, s[sgprStrideBL], v[429-256]       // mul d1 lower
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v[vgprGlobalReadOffsetB+36], vcc_lo, v6, v7 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+36], 0x1, v[vgprGlobalReadOffsetB+36] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset B */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_mul_lo_u32 v7, s[sgprStrideBL], v[430-256]       // mul d1 lower
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v[vgprGlobalReadOffsetB+37], vcc_lo, v6, v7 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+37], 0x1, v[vgprGlobalReadOffsetB+37] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset B */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_mul_lo_u32 v7, s[sgprStrideBL], v[431-256]       // mul d1 lower
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v[vgprGlobalReadOffsetB+38], vcc_lo, v6, v7 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+38], 0x1, v[vgprGlobalReadOffsetB+38] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset B */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_mul_lo_u32 v7, s[sgprStrideBL], v[432-256]       // mul d1 lower
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v[vgprGlobalReadOffsetB+39], vcc_lo, v6, v7 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+39], 0x1, v[vgprGlobalReadOffsetB+39] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset B */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_mul_lo_u32 v7, s[sgprStrideBL], v[433-256]       // mul d1 lower
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v[vgprGlobalReadOffsetB+40], vcc_lo, v6, v7 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+40], 0x1, v[vgprGlobalReadOffsetB+40] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset B */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_mul_lo_u32 v7, s[sgprStrideBL], v[434-256]       // mul d1 lower
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v[vgprGlobalReadOffsetB+41], vcc_lo, v6, v7 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+41], 0x1, v[vgprGlobalReadOffsetB+41] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset B */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_mul_lo_u32 v7, s[sgprStrideBL], v[435-256]       // mul d1 lower
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v[vgprGlobalReadOffsetB+42], vcc_lo, v6, v7 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+42], 0x1, v[vgprGlobalReadOffsetB+42] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset B */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_mul_lo_u32 v7, s[sgprStrideBL], v[436-256]       // mul d1 lower
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v[vgprGlobalReadOffsetB+43], vcc_lo, v6, v7 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+43], 0x1, v[vgprGlobalReadOffsetB+43] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset B */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_mul_lo_u32 v7, s[sgprStrideBL], v[437-256]       // mul d1 lower
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v[vgprGlobalReadOffsetB+44], vcc_lo, v6, v7 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+44], 0x1, v[vgprGlobalReadOffsetB+44] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset B */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_mul_lo_u32 v7, s[sgprStrideBL], v[438-256]       // mul d1 lower
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v[vgprGlobalReadOffsetB+45], vcc_lo, v6, v7 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+45], 0x1, v[vgprGlobalReadOffsetB+45] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset B */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_mul_lo_u32 v7, s[sgprStrideBL], v[439-256]       // mul d1 lower
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v[vgprGlobalReadOffsetB+46], vcc_lo, v6, v7 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+46], 0x1, v[vgprGlobalReadOffsetB+46] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset B */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_mul_lo_u32 v7, s[sgprStrideBL], v[440-256]       // mul d1 lower
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v[vgprGlobalReadOffsetB+47], vcc_lo, v6, v7 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+47], 0x1, v[vgprGlobalReadOffsetB+47] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset B */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_mul_lo_u32 v7, s[sgprStrideBL], v[441-256]       // mul d1 lower
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v[vgprGlobalReadOffsetB+48], vcc_lo, v6, v7 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+48], 0x1, v[vgprGlobalReadOffsetB+48] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset B */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_mul_lo_u32 v7, s[sgprStrideBL], v[442-256]       // mul d1 lower
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v[vgprGlobalReadOffsetB+49], vcc_lo, v6, v7 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+49], 0x1, v[vgprGlobalReadOffsetB+49] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset B */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_mul_lo_u32 v7, s[sgprStrideBL], v[443-256]       // mul d1 lower
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v[vgprGlobalReadOffsetB+50], vcc_lo, v6, v7 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+50], 0x1, v[vgprGlobalReadOffsetB+50] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset B */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_mul_lo_u32 v7, s[sgprStrideBL], v[444-256]       // mul d1 lower
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v[vgprGlobalReadOffsetB+51], vcc_lo, v6, v7 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+51], 0x1, v[vgprGlobalReadOffsetB+51] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset B */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_mul_lo_u32 v7, s[sgprStrideBL], v[445-256]       // mul d1 lower
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v[vgprGlobalReadOffsetB+52], vcc_lo, v6, v7 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+52], 0x1, v[vgprGlobalReadOffsetB+52] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset B */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_mul_lo_u32 v7, s[sgprStrideBL], v[446-256]       // mul d1 lower
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v[vgprGlobalReadOffsetB+53], vcc_lo, v6, v7 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+53], 0x1, v[vgprGlobalReadOffsetB+53] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset B */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_mul_lo_u32 v7, s[sgprStrideBL], v[447-256]       // mul d1 lower
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v[vgprGlobalReadOffsetB+54], vcc_lo, v6, v7 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+54], 0x1, v[vgprGlobalReadOffsetB+54] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset B */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_mul_lo_u32 v7, s[sgprStrideBL], v[448-256]       // mul d1 lower
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v[vgprGlobalReadOffsetB+55], vcc_lo, v6, v7 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+55], 0x1, v[vgprGlobalReadOffsetB+55] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset B */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_mul_lo_u32 v7, s[sgprStrideBL], v[449-256]       // mul d1 lower
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v[vgprGlobalReadOffsetB+56], vcc_lo, v6, v7 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+56], 0x1, v[vgprGlobalReadOffsetB+56] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset B */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_mul_lo_u32 v7, s[sgprStrideBL], v[450-256]       // mul d1 lower
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v[vgprGlobalReadOffsetB+57], vcc_lo, v6, v7 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+57], 0x1, v[vgprGlobalReadOffsetB+57] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset B */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_mul_lo_u32 v7, s[sgprStrideBL], v[451-256]       // mul d1 lower
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v[vgprGlobalReadOffsetB+58], vcc_lo, v6, v7 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+58], 0x1, v[vgprGlobalReadOffsetB+58] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset B */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_mul_lo_u32 v7, s[sgprStrideBL], v[452-256]       // mul d1 lower
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v[vgprGlobalReadOffsetB+59], vcc_lo, v6, v7 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+59], 0x1, v[vgprGlobalReadOffsetB+59] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset B */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_mul_lo_u32 v7, s[sgprStrideBL], v[453-256]       // mul d1 lower
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v[vgprGlobalReadOffsetB+60], vcc_lo, v6, v7 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+60], 0x1, v[vgprGlobalReadOffsetB+60] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset B */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_mul_lo_u32 v7, s[sgprStrideBL], v[454-256]       // mul d1 lower
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v[vgprGlobalReadOffsetB+61], vcc_lo, v6, v7 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+61], 0x1, v[vgprGlobalReadOffsetB+61] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset B */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_mul_lo_u32 v7, s[sgprStrideBL], v[455-256]       // mul d1 lower
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v[vgprGlobalReadOffsetB+62], vcc_lo, v6, v7 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+62], 0x1, v[vgprGlobalReadOffsetB+62] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset B */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_mul_lo_u32 v7, s[sgprStrideBL], v[456-256]       // mul d1 lower
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_add_co_u32 v[vgprGlobalReadOffsetB+63], vcc_lo, v6, v7 // accumulate K lower
v_add_nc_u32 v[vgprGlobalReadOffsetB+63], 0x1, v[vgprGlobalReadOffsetB+63] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)
/* ============================================================= */

/* global read addresses: increments a */
s_and_b32 s17, s[sgprGSU], 0x3fff                  // Restore GSU
s_mov_b32 s[sgprGlobalReadIncsA+0], 64             // GSU*DepthU*Bpe*MI_dim(1)
s_mul_i32 s17, s17, s[sgprGlobalReadIncsA+0]       // GSU*DepthU*Bpe*MI_dim(1)
s_and_b32 s16, s[sgprGSU], 0x8000                  // SCC = (GSUC == 1) ?
s_cselect_b32 s[sgprGlobalReadIncsA+0], s[sgprGlobalReadIncsA+0], s17 // incrA (unrollIdx)

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
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
buffer_load_d16_u8 v[vgprG2LB+0-256], v[vgprGlobalReadOffsetB+0], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_0_0
buffer_load_d16_u8 v[vgprG2LB+32-256], v[vgprGlobalReadOffsetB+1], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_1_0
buffer_load_d16_u8 v[vgprG2LB+64-256], v[vgprGlobalReadOffsetB+2], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_2_0
buffer_load_d16_u8 v[vgprG2LB+96-256], v[vgprGlobalReadOffsetB+3], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_3_0
buffer_load_d16_u8 v[vgprG2LB+1-256], v[vgprGlobalReadOffsetB+4], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_4_0
buffer_load_d16_u8 v[vgprG2LB+33-256], v[vgprGlobalReadOffsetB+5], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_5_0
buffer_load_d16_u8 v[vgprG2LB+65-256], v[vgprGlobalReadOffsetB+6], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_6_0
buffer_load_d16_u8 v[vgprG2LB+97-256], v[vgprGlobalReadOffsetB+7], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_7_0
buffer_load_d16_u8 v[vgprG2LB+2-256], v[vgprGlobalReadOffsetB+8], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_8_0
buffer_load_d16_u8 v[vgprG2LB+34-256], v[vgprGlobalReadOffsetB+9], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_9_0
buffer_load_d16_u8 v[vgprG2LB+66-256], v[vgprGlobalReadOffsetB+10], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_10_0
buffer_load_d16_u8 v[vgprG2LB+98-256], v[vgprGlobalReadOffsetB+11], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_11_0
buffer_load_d16_u8 v[vgprG2LB+3-256], v[vgprGlobalReadOffsetB+12], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_12_0
buffer_load_d16_u8 v[vgprG2LB+35-256], v[vgprGlobalReadOffsetB+13], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_13_0
buffer_load_d16_u8 v[vgprG2LB+67-256], v[vgprGlobalReadOffsetB+14], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_14_0
buffer_load_d16_u8 v[vgprG2LB+99-256], v[vgprGlobalReadOffsetB+15], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_15_0
buffer_load_d16_u8 v[vgprG2LB+4-256], v[vgprGlobalReadOffsetB+16], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_16_0
buffer_load_d16_u8 v[vgprG2LB+36-256], v[vgprGlobalReadOffsetB+17], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_17_0
buffer_load_d16_u8 v[vgprG2LB+68-256], v[vgprGlobalReadOffsetB+18], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_18_0
buffer_load_d16_u8 v[vgprG2LB+100-256], v[vgprGlobalReadOffsetB+19], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_19_0
buffer_load_d16_u8 v[vgprG2LB+5-256], v[vgprGlobalReadOffsetB+20], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_20_0
buffer_load_d16_u8 v[vgprG2LB+37-256], v[vgprGlobalReadOffsetB+21], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_21_0
buffer_load_d16_u8 v[vgprG2LB+69-256], v[vgprGlobalReadOffsetB+22], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_22_0
buffer_load_d16_u8 v[vgprG2LB+101-256], v[vgprGlobalReadOffsetB+23], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_23_0
buffer_load_d16_u8 v[vgprG2LB+6-256], v[vgprGlobalReadOffsetB+24], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_24_0
buffer_load_d16_u8 v[vgprG2LB+38-256], v[vgprGlobalReadOffsetB+25], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_25_0
buffer_load_d16_u8 v[vgprG2LB+70-256], v[vgprGlobalReadOffsetB+26], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_26_0
buffer_load_d16_u8 v[vgprG2LB+102-256], v[vgprGlobalReadOffsetB+27], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_27_0
buffer_load_d16_u8 v[vgprG2LB+7-256], v[vgprGlobalReadOffsetB+28], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_28_0
buffer_load_d16_u8 v[vgprG2LB+39-256], v[vgprGlobalReadOffsetB+29], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_29_0
buffer_load_d16_u8 v[vgprG2LB+71-256], v[vgprGlobalReadOffsetB+30], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_30_0
buffer_load_d16_u8 v[vgprG2LB+103-256], v[vgprGlobalReadOffsetB+31], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_31_0
buffer_load_d16_u8 v[vgprG2LB+8-256], v[vgprGlobalReadOffsetB+32], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_32_0
buffer_load_d16_u8 v[vgprG2LB+40-256], v[vgprGlobalReadOffsetB+33], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_33_0
buffer_load_d16_u8 v[vgprG2LB+72-256], v[vgprGlobalReadOffsetB+34], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_34_0
buffer_load_d16_u8 v[vgprG2LB+104-256], v[vgprGlobalReadOffsetB+35], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_35_0
buffer_load_d16_u8 v[vgprG2LB+9-256], v[vgprGlobalReadOffsetB+36], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_36_0
buffer_load_d16_u8 v[vgprG2LB+41-256], v[vgprGlobalReadOffsetB+37], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_37_0
buffer_load_d16_u8 v[vgprG2LB+73-256], v[vgprGlobalReadOffsetB+38], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_38_0
buffer_load_d16_u8 v[vgprG2LB+105-256], v[vgprGlobalReadOffsetB+39], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_39_0
buffer_load_d16_u8 v[vgprG2LB+10-256], v[vgprGlobalReadOffsetB+40], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_40_0
buffer_load_d16_u8 v[vgprG2LB+42-256], v[vgprGlobalReadOffsetB+41], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_41_0
buffer_load_d16_u8 v[vgprG2LB+74-256], v[vgprGlobalReadOffsetB+42], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_42_0
buffer_load_d16_u8 v[vgprG2LB+106-256], v[vgprGlobalReadOffsetB+43], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_43_0
buffer_load_d16_u8 v[vgprG2LB+11-256], v[vgprGlobalReadOffsetB+44], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_44_0
buffer_load_d16_u8 v[vgprG2LB+43-256], v[vgprGlobalReadOffsetB+45], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_45_0
buffer_load_d16_u8 v[vgprG2LB+75-256], v[vgprGlobalReadOffsetB+46], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_46_0
buffer_load_d16_u8 v[vgprG2LB+107-256], v[vgprGlobalReadOffsetB+47], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_47_0
buffer_load_d16_u8 v[vgprG2LB+12-256], v[vgprGlobalReadOffsetB+48], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_48_0
buffer_load_d16_u8 v[vgprG2LB+44-256], v[vgprGlobalReadOffsetB+49], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_49_0
buffer_load_d16_u8 v[vgprG2LB+76-256], v[vgprGlobalReadOffsetB+50], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_50_0
buffer_load_d16_u8 v[vgprG2LB+108-256], v[vgprGlobalReadOffsetB+51], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_51_0
buffer_load_d16_u8 v[vgprG2LB+13-256], v[vgprGlobalReadOffsetB+52], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_52_0
buffer_load_d16_u8 v[vgprG2LB+45-256], v[vgprGlobalReadOffsetB+53], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_53_0
buffer_load_d16_u8 v[vgprG2LB+77-256], v[vgprGlobalReadOffsetB+54], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_54_0
buffer_load_d16_u8 v[vgprG2LB+109-256], v[vgprGlobalReadOffsetB+55], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_55_0
buffer_load_d16_u8 v[vgprG2LB+14-256], v[vgprGlobalReadOffsetB+56], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_56_0
buffer_load_d16_u8 v[vgprG2LB+46-256], v[vgprGlobalReadOffsetB+57], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_57_0
buffer_load_d16_u8 v[vgprG2LB+78-256], v[vgprGlobalReadOffsetB+58], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_58_0
s_wait_alu depctr_va_vdst(12)
buffer_load_d16_u8 v[vgprG2LB+110-256], v[vgprGlobalReadOffsetB+59], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_59_0
s_wait_alu depctr_va_vdst(9)
buffer_load_d16_u8 v[vgprG2LB+15-256], v[vgprGlobalReadOffsetB+60], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_60_0
s_wait_alu depctr_va_vdst(6)
buffer_load_d16_u8 v[vgprG2LB+47-256], v[vgprGlobalReadOffsetB+61], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_61_0
s_wait_alu depctr_va_vdst(3)
buffer_load_d16_u8 v[vgprG2LB+79-256], v[vgprGlobalReadOffsetB+62], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_62_0
s_wait_alu depctr_va_vdst(0)
buffer_load_d16_u8 v[vgprG2LB+111-256], v[vgprGlobalReadOffsetB+63], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_63_0

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
s_and_b32 s68, s[sgprGSU], 0x3fff                  // Restore GSU
s_cmp_eq_u32 s68, 1                                // GSU == 1 ?
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
s_and_b32 s68, s[sgprSrdD+2], 127
s_lshl_b32 s68, s68, 25
s_and_b32 s[sgprSrdD+1], s[sgprSrdD+1], 33554431
s_or_b32 s[sgprSrdD+1], s[sgprSrdD+1], s68
s_lshr_b32 s[sgprSrdD+2], s[sgprSrdD+2], 7

s_and_b32 s68, s[sgprGSU], 0x3fff                  // Restore GSU
s_cmp_eq_u32 s68, 1                                // GSU == 1 ?
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
s_and_b32 s68, s[sgprSrdC+2], 127
s_lshl_b32 s68, s68, 25
s_and_b32 s[sgprSrdC+1], s[sgprSrdC+1], 33554431
s_or_b32 s[sgprSrdC+1], s[sgprSrdC+1], s68
s_lshr_b32 s[sgprSrdC+2], s[sgprSrdC+2], 7


s_mul_i32 s70, MT1, s[sgprWorkGroup1]              // <- wg1*MT1
s_and_b32 s69, s[sgprGSU], 0x3fff                  // Restore GSU
s_mul_hi_u32 s69, s70, s[sgprStrideC1J]            // ScaleC s70 by Stride
s_mul_i32 s68, s70, s[sgprStrideC1J]               // ScaleC s70 by Stride
s_lshl_b64 s[68:69], s[68:69], s[sgprGSULog2BpeC]  // scale by bpe
s_add_u32 s[sgprSrdC+0], s[sgprSrdC+0], s68        // add lo to SRD
s_addc_u32 s[sgprSrdC+1], s[sgprSrdC+1], s69       // add hi to SRD
s_and_b32 s69, s[sgprGSU], 0x3fff                  // Restore GSU
s_mul_hi_u32 s69, s70, s[sgprStrideD1J]            // ScaleD s70 by Stride
s_mul_i32 s68, s70, s[sgprStrideD1J]               // ScaleD s70 by Stride
s_lshl_b64 s[68:69], s[68:69], s[sgprGSULog2BpeD]  // scale by bpe
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s68        // add lo to SRD
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], s69       // add hi to SRD

s_and_b32 s69, s[sgprGSU], 0x3fff                  // Restore GSU
s_cmp_eq_u32 s69, 1                                // GSU == 1 ?
s_cbranch_scc0 label_StridedBatchedGemmLoadC
s_cmp_eq_u32 s[sgprArgType], 3                     // ArgType == 3 for General Batched GEMM
s_cbranch_scc1 label_GeneralBatchedGemmLoadC
label_StridedBatchedGemmLoadC:  /// Computing the Batch Matrix's base address for Strided Batched GEMM
s_mul_hi_u32 s69, s[sgprWorkGroup2], s[sgprStrideCK] // ScaleC s[sgprWorkGroup2] by Stride
s_mul_i32 s68, s[sgprWorkGroup2], s[sgprStrideCK]  // ScaleC s[sgprWorkGroup2] by Stride
s_lshl_b64 s[68:69], s[68:69], s[sgprGSULog2BpeC]  // scale by bpe
s_add_u32 s[sgprSrdC+0], s[sgprSrdC+0], s68        // add lo to SRD
s_addc_u32 s[sgprSrdC+1], s[sgprSrdC+1], s69       // add hi to SRD
s_branch label_GeneralBatchedGemmLoadC_End
label_GeneralBatchedGemmLoadC:  /// Computing the Batch Matrix's base address for General Batched GEMM
s_mul_i32 s68, 8, s[sgprWorkGroup2]                // Compute stride in bytes into Pointer Array
s_add_u32 s68, s68, s[sgprAddressC+0]              // Offsetting to the location [Lower half of address]
s_addc_u32 s69, s[sgprAddressC+1], 0               // Offsetting to the location [Higher half of address]
s_load_b64 s[70:71], s[68:69], 0                   // Load the Matrix Address in the Pointer Array
s_wait_kmcnt 0                                     // Wait for the Matrix Address Load from the Pointer Array
s_add_u32 s[sgprSrdC+0], s[sgprSrdC+0], s70        // Offsetting within the Batch Matrix [Lower half of address]
s_addc_u32 s[sgprSrdC+1], s[sgprSrdC+1], s71       // Offsetting within the Batch Matrix [Higher half of address]
label_GeneralBatchedGemmLoadC_End:  /// End of label GeneralBatchedGemmLoadC
s_and_b32 s69, s[sgprGSU], 0x3fff                  // Restore GSU
s_cmp_eq_u32 s69, 1                                // GSU == 1 ?
s_cbranch_scc0 label_StridedBatchedGemmLoadD
s_cmp_eq_u32 s[sgprArgType], 3                     // ArgType == 3 for General Batched GEMM
s_cbranch_scc1 label_GeneralBatchedGemmLoadD
label_StridedBatchedGemmLoadD:  /// Computing the Batch Matrix's base address for Strided Batched GEMM
s_mul_hi_u32 s69, s[sgprWorkGroup2], s[sgprStrideDK] // ScaleD s[sgprWorkGroup2] by Stride
s_mul_i32 s68, s[sgprWorkGroup2], s[sgprStrideDK]  // ScaleD s[sgprWorkGroup2] by Stride
s_lshl_b64 s[68:69], s[68:69], s[sgprGSULog2BpeD]  // scale by bpe
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s68        // add lo to SRD
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], s69       // add hi to SRD
s_branch label_GeneralBatchedGemmLoadD_End
label_GeneralBatchedGemmLoadD:  /// Computing the Batch Matrix's base address for General Batched GEMM
s_mul_i32 s68, 8, s[sgprWorkGroup2]                // Compute stride in bytes into Pointer Array
s_add_u32 s68, s68, s[sgprAddressD+0]              // Offsetting to the location [Lower half of address]
s_addc_u32 s69, s[sgprAddressD+1], 0               // Offsetting to the location [Higher half of address]
s_load_b64 s[70:71], s[68:69], 0                   // Load the Matrix Address in the Pointer Array
s_wait_kmcnt 0                                     // Wait for the Matrix Address Load from the Pointer Array
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s70        // Offsetting within the Batch Matrix [Lower half of address]
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], s71       // Offsetting within the Batch Matrix [Higher half of address]
label_GeneralBatchedGemmLoadD_End:  /// End of label GeneralBatchedGemmLoadD

s_and_b32 s68, s[sgprGSU], 0x3fff                  // Restore GSU
s_cmp_eq_u32 s68, 1                                // GSU == 1 ?
s_cbranch_scc1 label_GSU_2                         // branch if GSU == 1
// GSU Output Buffer offset: Free0 + (Free1-1)*StrideC1J + (Free2-1)*StrideCK * GSUIdx * bpe%s
s_mul_hi_u32 s69, s[sgprSizesFree+0], s[sgprGSUSumIdx] // Free0
s_mul_i32 s68, s[sgprSizesFree+0], s[sgprGSUSumIdx] // Free0
s_sub_u32 s70, s[sgprSizesFree+1], 1               // Free1
s_mul_i32 s70, s70, s[sgprGSUSumIdx]               // Free1
s_mul_hi_u32 s71, s70, s[sgprStrideC1J]            // Free1
s_mul_i32 s70, s70, s[sgprStrideC1J]               // Free1
s_add_u32 s68, s68, s70                            // Free1
s_addc_u32 s69, s69, s71                           // Free1
s_sub_u32 s70, s[sgprSizesFree+2], 1               // Free2
s_mul_i32 s70, s70, s[sgprGSUSumIdx]               // Free2
s_mul_hi_u32 s71, s70, s[sgprStrideCK]             // Free2
s_mul_i32 s70, s70, s[sgprStrideCK]                // Free2
s_add_u32 s68, s68, s70                            // Free2
s_addc_u32 s69, s69, s71                           // Free2
s_lshl_b64 s[68:69], s[68:69], 2                   // scale by bpe
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s68        // add lo GSU offset to SRD
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], s69       // add hi GSU offset to SRD
label_GSU_2:
.set sgprGSULog2BpeC, UNDEF
.set sgprAddressC, UNDEF
s_cmp_le_u32 s[sgprLoopCounterL], 0x2              // LoopCounterL < EndCounter
s_cbranch_scc0 label_skipInitCVmov                 // skip v_mov initC (WMMA initC will run in main loop)

/* initC: remove ValuC vgpr buffer [0...32) from pool */

/* initC: remove acc vgpr buffer [0...0) from pool */

/* initC: remove ValuA/B vgpr buffer [132...199) from pool */
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
s_cmp_eq_u32 s[sgprLoopCounterL], 0                // at last iteration?

/* after InitC, skip to end of prefetch last iter if numIter==0 */

/* label_PrefetchGlobalLastIterEnd */
s_cbranch_scc0 label_NoBranch_T8JHFHKM7BO5OHXW     // Only branch on scc1
s_getpc_b64 s[68:69]                               // addr of next instr
s_add_i32 s70, label_PrefetchGlobalLastIterEnd, 4  // target branch offset
s_add_u32 s68, s68, s70                            // add target branch offset
s_addc_u32 s69, s69, 0                             // add high and carry
s_setpc_b64 s[68:69]                               // branch to label_PrefetchGlobalLastIterEnd
label_NoBranch_T8JHFHKM7BO5OHXW:
s_wait_loadcnt 0                                   // wait for global read

/* local write a */
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+0] offset:0 // lwoA_0_0_0_0 = (0*LSCA)*(MT0I+PAD) + (0*LSPA) = 0 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+16] offset:64 // lwoA_0_0_1_0 = (0*LSCA)*(MT0I+PAD) + (1*LSPA) = 64 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+32] offset:128 // lwoA_0_0_2_0 = (0*LSCA)*(MT0I+PAD) + (2*LSPA) = 128 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+48] offset:192 // lwoA_0_0_3_0 = (0*LSCA)*(MT0I+PAD) + (3*LSPA) = 192 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+1] offset:272 // lwoA_0_0_4_0 = (0*LSCA)*(MT0I+PAD) + (4*LSPA) = 272 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+17] offset:336 // lwoA_0_0_5_0 = (0*LSCA)*(MT0I+PAD) + (5*LSPA) = 336 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+33] offset:400 // lwoA_0_0_6_0 = (0*LSCA)*(MT0I+PAD) + (6*LSPA) = 400 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+49] offset:464 // lwoA_0_0_7_0 = (0*LSCA)*(MT0I+PAD) + (7*LSPA) = 464 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+2] offset:544 // lwoA_0_0_8_0 = (0*LSCA)*(MT0I+PAD) + (8*LSPA) = 544 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+18] offset:608 // lwoA_0_0_9_0 = (0*LSCA)*(MT0I+PAD) + (9*LSPA) = 608 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+34] offset:672 // lwoA_0_0_10_0 = (0*LSCA)*(MT0I+PAD) + (10*LSPA) = 672 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+50] offset:736 // lwoA_0_0_11_0 = (0*LSCA)*(MT0I+PAD) + (11*LSPA) = 736 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+3] offset:816 // lwoA_0_0_12_0 = (0*LSCA)*(MT0I+PAD) + (12*LSPA) = 816 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+19] offset:880 // lwoA_0_0_13_0 = (0*LSCA)*(MT0I+PAD) + (13*LSPA) = 880 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+35] offset:944 // lwoA_0_0_14_0 = (0*LSCA)*(MT0I+PAD) + (14*LSPA) = 944 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+51] offset:1008 // lwoA_0_0_15_0 = (0*LSCA)*(MT0I+PAD) + (15*LSPA) = 1008 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+4] offset:1088 // lwoA_0_0_16_0 = (0*LSCA)*(MT0I+PAD) + (16*LSPA) = 1088 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+20] offset:1152 // lwoA_0_0_17_0 = (0*LSCA)*(MT0I+PAD) + (17*LSPA) = 1152 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+36] offset:1216 // lwoA_0_0_18_0 = (0*LSCA)*(MT0I+PAD) + (18*LSPA) = 1216 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+52] offset:1280 // lwoA_0_0_19_0 = (0*LSCA)*(MT0I+PAD) + (19*LSPA) = 1280 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+5] offset:1360 // lwoA_0_0_20_0 = (0*LSCA)*(MT0I+PAD) + (20*LSPA) = 1360 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+21] offset:1424 // lwoA_0_0_21_0 = (0*LSCA)*(MT0I+PAD) + (21*LSPA) = 1424 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+37] offset:1488 // lwoA_0_0_22_0 = (0*LSCA)*(MT0I+PAD) + (22*LSPA) = 1488 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+53] offset:1552 // lwoA_0_0_23_0 = (0*LSCA)*(MT0I+PAD) + (23*LSPA) = 1552 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+6] offset:1632 // lwoA_0_0_24_0 = (0*LSCA)*(MT0I+PAD) + (24*LSPA) = 1632 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+22] offset:1696 // lwoA_0_0_25_0 = (0*LSCA)*(MT0I+PAD) + (25*LSPA) = 1696 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+38] offset:1760 // lwoA_0_0_26_0 = (0*LSCA)*(MT0I+PAD) + (26*LSPA) = 1760 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+54] offset:1824 // lwoA_0_0_27_0 = (0*LSCA)*(MT0I+PAD) + (27*LSPA) = 1824 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+7] offset:1904 // lwoA_0_0_28_0 = (0*LSCA)*(MT0I+PAD) + (28*LSPA) = 1904 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+23] offset:1968 // lwoA_0_0_29_0 = (0*LSCA)*(MT0I+PAD) + (29*LSPA) = 1968 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+39] offset:2032 // lwoA_0_0_30_0 = (0*LSCA)*(MT0I+PAD) + (30*LSPA) = 2032 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+55] offset:2096 // lwoA_0_0_31_0 = (0*LSCA)*(MT0I+PAD) + (31*LSPA) = 2096 sync LDS0

/* local write b */
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+0-256] offset:0 // lwoB_0_0_0_0 = (0*LSCB) + (0*LSPB)(*MT1J+PAD) = 0 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+32-256] offset:64 // lwoB_0_0_1_0 = (0*LSCB) + (1*LSPB)(*MT1J+PAD) = 64 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+64-256] offset:128 // lwoB_0_0_2_0 = (0*LSCB) + (2*LSPB)(*MT1J+PAD) = 128 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+96-256] offset:192 // lwoB_0_0_3_0 = (0*LSCB) + (3*LSPB)(*MT1J+PAD) = 192 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+1-256] offset:256 // lwoB_0_0_4_0 = (0*LSCB) + (4*LSPB)(*MT1J+PAD) = 256 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+33-256] offset:320 // lwoB_0_0_5_0 = (0*LSCB) + (5*LSPB)(*MT1J+PAD) = 320 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+65-256] offset:384 // lwoB_0_0_6_0 = (0*LSCB) + (6*LSPB)(*MT1J+PAD) = 384 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+97-256] offset:448 // lwoB_0_0_7_0 = (0*LSCB) + (7*LSPB)(*MT1J+PAD) = 448 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+2-256] offset:512 // lwoB_0_0_8_0 = (0*LSCB) + (8*LSPB)(*MT1J+PAD) = 512 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+34-256] offset:576 // lwoB_0_0_9_0 = (0*LSCB) + (9*LSPB)(*MT1J+PAD) = 576 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+66-256] offset:640 // lwoB_0_0_10_0 = (0*LSCB) + (10*LSPB)(*MT1J+PAD) = 640 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+98-256] offset:704 // lwoB_0_0_11_0 = (0*LSCB) + (11*LSPB)(*MT1J+PAD) = 704 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+3-256] offset:768 // lwoB_0_0_12_0 = (0*LSCB) + (12*LSPB)(*MT1J+PAD) = 768 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+35-256] offset:832 // lwoB_0_0_13_0 = (0*LSCB) + (13*LSPB)(*MT1J+PAD) = 832 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+67-256] offset:896 // lwoB_0_0_14_0 = (0*LSCB) + (14*LSPB)(*MT1J+PAD) = 896 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+99-256] offset:960 // lwoB_0_0_15_0 = (0*LSCB) + (15*LSPB)(*MT1J+PAD) = 960 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+4-256] offset:1056 // lwoB_0_0_16_0 = (0*LSCB) + (16*LSPB)(*MT1J+PAD) = 1056 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+36-256] offset:1120 // lwoB_0_0_17_0 = (0*LSCB) + (17*LSPB)(*MT1J+PAD) = 1120 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+68-256] offset:1184 // lwoB_0_0_18_0 = (0*LSCB) + (18*LSPB)(*MT1J+PAD) = 1184 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+100-256] offset:1248 // lwoB_0_0_19_0 = (0*LSCB) + (19*LSPB)(*MT1J+PAD) = 1248 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+5-256] offset:1312 // lwoB_0_0_20_0 = (0*LSCB) + (20*LSPB)(*MT1J+PAD) = 1312 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+37-256] offset:1376 // lwoB_0_0_21_0 = (0*LSCB) + (21*LSPB)(*MT1J+PAD) = 1376 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+69-256] offset:1440 // lwoB_0_0_22_0 = (0*LSCB) + (22*LSPB)(*MT1J+PAD) = 1440 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+101-256] offset:1504 // lwoB_0_0_23_0 = (0*LSCB) + (23*LSPB)(*MT1J+PAD) = 1504 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+6-256] offset:1568 // lwoB_0_0_24_0 = (0*LSCB) + (24*LSPB)(*MT1J+PAD) = 1568 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+38-256] offset:1632 // lwoB_0_0_25_0 = (0*LSCB) + (25*LSPB)(*MT1J+PAD) = 1632 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+70-256] offset:1696 // lwoB_0_0_26_0 = (0*LSCB) + (26*LSPB)(*MT1J+PAD) = 1696 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+102-256] offset:1760 // lwoB_0_0_27_0 = (0*LSCB) + (27*LSPB)(*MT1J+PAD) = 1760 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+7-256] offset:1824 // lwoB_0_0_28_0 = (0*LSCB) + (28*LSPB)(*MT1J+PAD) = 1824 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+39-256] offset:1888 // lwoB_0_0_29_0 = (0*LSCB) + (29*LSPB)(*MT1J+PAD) = 1888 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+71-256] offset:1952 // lwoB_0_0_30_0 = (0*LSCB) + (30*LSPB)(*MT1J+PAD) = 1952 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+103-256] offset:2016 // lwoB_0_0_31_0 = (0*LSCB) + (31*LSPB)(*MT1J+PAD) = 2016 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+8-256] offset:2112 // lwoB_0_0_32_0 = (0*LSCB) + (32*LSPB)(*MT1J+PAD) = 2112 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+40-256] offset:2176 // lwoB_0_0_33_0 = (0*LSCB) + (33*LSPB)(*MT1J+PAD) = 2176 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+72-256] offset:2240 // lwoB_0_0_34_0 = (0*LSCB) + (34*LSPB)(*MT1J+PAD) = 2240 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+104-256] offset:2304 // lwoB_0_0_35_0 = (0*LSCB) + (35*LSPB)(*MT1J+PAD) = 2304 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+9-256] offset:2368 // lwoB_0_0_36_0 = (0*LSCB) + (36*LSPB)(*MT1J+PAD) = 2368 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+41-256] offset:2432 // lwoB_0_0_37_0 = (0*LSCB) + (37*LSPB)(*MT1J+PAD) = 2432 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+73-256] offset:2496 // lwoB_0_0_38_0 = (0*LSCB) + (38*LSPB)(*MT1J+PAD) = 2496 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+105-256] offset:2560 // lwoB_0_0_39_0 = (0*LSCB) + (39*LSPB)(*MT1J+PAD) = 2560 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+10-256] offset:2624 // lwoB_0_0_40_0 = (0*LSCB) + (40*LSPB)(*MT1J+PAD) = 2624 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+42-256] offset:2688 // lwoB_0_0_41_0 = (0*LSCB) + (41*LSPB)(*MT1J+PAD) = 2688 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+74-256] offset:2752 // lwoB_0_0_42_0 = (0*LSCB) + (42*LSPB)(*MT1J+PAD) = 2752 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+106-256] offset:2816 // lwoB_0_0_43_0 = (0*LSCB) + (43*LSPB)(*MT1J+PAD) = 2816 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+11-256] offset:2880 // lwoB_0_0_44_0 = (0*LSCB) + (44*LSPB)(*MT1J+PAD) = 2880 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+43-256] offset:2944 // lwoB_0_0_45_0 = (0*LSCB) + (45*LSPB)(*MT1J+PAD) = 2944 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+75-256] offset:3008 // lwoB_0_0_46_0 = (0*LSCB) + (46*LSPB)(*MT1J+PAD) = 3008 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+107-256] offset:3072 // lwoB_0_0_47_0 = (0*LSCB) + (47*LSPB)(*MT1J+PAD) = 3072 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+12-256] offset:3168 // lwoB_0_0_48_0 = (0*LSCB) + (48*LSPB)(*MT1J+PAD) = 3168 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+44-256] offset:3232 // lwoB_0_0_49_0 = (0*LSCB) + (49*LSPB)(*MT1J+PAD) = 3232 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+76-256] offset:3296 // lwoB_0_0_50_0 = (0*LSCB) + (50*LSPB)(*MT1J+PAD) = 3296 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+108-256] offset:3360 // lwoB_0_0_51_0 = (0*LSCB) + (51*LSPB)(*MT1J+PAD) = 3360 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+13-256] offset:3424 // lwoB_0_0_52_0 = (0*LSCB) + (52*LSPB)(*MT1J+PAD) = 3424 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+45-256] offset:3488 // lwoB_0_0_53_0 = (0*LSCB) + (53*LSPB)(*MT1J+PAD) = 3488 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+77-256] offset:3552 // lwoB_0_0_54_0 = (0*LSCB) + (54*LSPB)(*MT1J+PAD) = 3552 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+109-256] offset:3616 // lwoB_0_0_55_0 = (0*LSCB) + (55*LSPB)(*MT1J+PAD) = 3616 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+14-256] offset:3680 // lwoB_0_0_56_0 = (0*LSCB) + (56*LSPB)(*MT1J+PAD) = 3680 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+46-256] offset:3744 // lwoB_0_0_57_0 = (0*LSCB) + (57*LSPB)(*MT1J+PAD) = 3744 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+78-256] offset:3808 // lwoB_0_0_58_0 = (0*LSCB) + (58*LSPB)(*MT1J+PAD) = 3808 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+110-256] offset:3872 // lwoB_0_0_59_0 = (0*LSCB) + (59*LSPB)(*MT1J+PAD) = 3872 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+15-256] offset:3936 // lwoB_0_0_60_0 = (0*LSCB) + (60*LSPB)(*MT1J+PAD) = 3936 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+47-256] offset:4000 // lwoB_0_0_61_0 = (0*LSCB) + (61*LSPB)(*MT1J+PAD) = 4000 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+79-256] offset:4064 // lwoB_0_0_62_0 = (0*LSCB) + (62*LSPB)(*MT1J+PAD) = 4064 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+111-256] offset:4128 // lwoB_0_0_63_0 = (0*LSCB) + (63*LSPB)(*MT1J+PAD) = 4128 sync LDS0

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
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
buffer_load_d16_u8 v[vgprG2LB+0-256], v[vgprGlobalReadOffsetB+0], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_0_0
buffer_load_d16_u8 v[vgprG2LB+32-256], v[vgprGlobalReadOffsetB+1], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_1_0
buffer_load_d16_u8 v[vgprG2LB+64-256], v[vgprGlobalReadOffsetB+2], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_2_0
buffer_load_d16_u8 v[vgprG2LB+96-256], v[vgprGlobalReadOffsetB+3], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_3_0
buffer_load_d16_u8 v[vgprG2LB+1-256], v[vgprGlobalReadOffsetB+4], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_4_0
buffer_load_d16_u8 v[vgprG2LB+33-256], v[vgprGlobalReadOffsetB+5], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_5_0
buffer_load_d16_u8 v[vgprG2LB+65-256], v[vgprGlobalReadOffsetB+6], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_6_0
buffer_load_d16_u8 v[vgprG2LB+97-256], v[vgprGlobalReadOffsetB+7], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_7_0
buffer_load_d16_u8 v[vgprG2LB+2-256], v[vgprGlobalReadOffsetB+8], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_8_0
buffer_load_d16_u8 v[vgprG2LB+34-256], v[vgprGlobalReadOffsetB+9], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_9_0
buffer_load_d16_u8 v[vgprG2LB+66-256], v[vgprGlobalReadOffsetB+10], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_10_0
buffer_load_d16_u8 v[vgprG2LB+98-256], v[vgprGlobalReadOffsetB+11], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_11_0
buffer_load_d16_u8 v[vgprG2LB+3-256], v[vgprGlobalReadOffsetB+12], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_12_0
buffer_load_d16_u8 v[vgprG2LB+35-256], v[vgprGlobalReadOffsetB+13], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_13_0
buffer_load_d16_u8 v[vgprG2LB+67-256], v[vgprGlobalReadOffsetB+14], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_14_0
buffer_load_d16_u8 v[vgprG2LB+99-256], v[vgprGlobalReadOffsetB+15], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_15_0
buffer_load_d16_u8 v[vgprG2LB+4-256], v[vgprGlobalReadOffsetB+16], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_16_0
buffer_load_d16_u8 v[vgprG2LB+36-256], v[vgprGlobalReadOffsetB+17], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_17_0
buffer_load_d16_u8 v[vgprG2LB+68-256], v[vgprGlobalReadOffsetB+18], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_18_0
buffer_load_d16_u8 v[vgprG2LB+100-256], v[vgprGlobalReadOffsetB+19], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_19_0
buffer_load_d16_u8 v[vgprG2LB+5-256], v[vgprGlobalReadOffsetB+20], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_20_0
buffer_load_d16_u8 v[vgprG2LB+37-256], v[vgprGlobalReadOffsetB+21], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_21_0
buffer_load_d16_u8 v[vgprG2LB+69-256], v[vgprGlobalReadOffsetB+22], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_22_0
buffer_load_d16_u8 v[vgprG2LB+101-256], v[vgprGlobalReadOffsetB+23], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_23_0
buffer_load_d16_u8 v[vgprG2LB+6-256], v[vgprGlobalReadOffsetB+24], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_24_0
buffer_load_d16_u8 v[vgprG2LB+38-256], v[vgprGlobalReadOffsetB+25], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_25_0
buffer_load_d16_u8 v[vgprG2LB+70-256], v[vgprGlobalReadOffsetB+26], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_26_0
buffer_load_d16_u8 v[vgprG2LB+102-256], v[vgprGlobalReadOffsetB+27], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_27_0
buffer_load_d16_u8 v[vgprG2LB+7-256], v[vgprGlobalReadOffsetB+28], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_28_0
buffer_load_d16_u8 v[vgprG2LB+39-256], v[vgprGlobalReadOffsetB+29], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_29_0
buffer_load_d16_u8 v[vgprG2LB+71-256], v[vgprGlobalReadOffsetB+30], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_30_0
buffer_load_d16_u8 v[vgprG2LB+103-256], v[vgprGlobalReadOffsetB+31], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_31_0
buffer_load_d16_u8 v[vgprG2LB+8-256], v[vgprGlobalReadOffsetB+32], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_32_0
buffer_load_d16_u8 v[vgprG2LB+40-256], v[vgprGlobalReadOffsetB+33], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_33_0
buffer_load_d16_u8 v[vgprG2LB+72-256], v[vgprGlobalReadOffsetB+34], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_34_0
buffer_load_d16_u8 v[vgprG2LB+104-256], v[vgprGlobalReadOffsetB+35], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_35_0
buffer_load_d16_u8 v[vgprG2LB+9-256], v[vgprGlobalReadOffsetB+36], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_36_0
buffer_load_d16_u8 v[vgprG2LB+41-256], v[vgprGlobalReadOffsetB+37], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_37_0
buffer_load_d16_u8 v[vgprG2LB+73-256], v[vgprGlobalReadOffsetB+38], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_38_0
buffer_load_d16_u8 v[vgprG2LB+105-256], v[vgprGlobalReadOffsetB+39], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_39_0
buffer_load_d16_u8 v[vgprG2LB+10-256], v[vgprGlobalReadOffsetB+40], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_40_0
buffer_load_d16_u8 v[vgprG2LB+42-256], v[vgprGlobalReadOffsetB+41], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_41_0
buffer_load_d16_u8 v[vgprG2LB+74-256], v[vgprGlobalReadOffsetB+42], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_42_0
buffer_load_d16_u8 v[vgprG2LB+106-256], v[vgprGlobalReadOffsetB+43], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_43_0
buffer_load_d16_u8 v[vgprG2LB+11-256], v[vgprGlobalReadOffsetB+44], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_44_0
buffer_load_d16_u8 v[vgprG2LB+43-256], v[vgprGlobalReadOffsetB+45], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_45_0
buffer_load_d16_u8 v[vgprG2LB+75-256], v[vgprGlobalReadOffsetB+46], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_46_0
buffer_load_d16_u8 v[vgprG2LB+107-256], v[vgprGlobalReadOffsetB+47], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_47_0
buffer_load_d16_u8 v[vgprG2LB+12-256], v[vgprGlobalReadOffsetB+48], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_48_0
buffer_load_d16_u8 v[vgprG2LB+44-256], v[vgprGlobalReadOffsetB+49], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_49_0
buffer_load_d16_u8 v[vgprG2LB+76-256], v[vgprGlobalReadOffsetB+50], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_50_0
buffer_load_d16_u8 v[vgprG2LB+108-256], v[vgprGlobalReadOffsetB+51], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_51_0
buffer_load_d16_u8 v[vgprG2LB+13-256], v[vgprGlobalReadOffsetB+52], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_52_0
buffer_load_d16_u8 v[vgprG2LB+45-256], v[vgprGlobalReadOffsetB+53], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_53_0
buffer_load_d16_u8 v[vgprG2LB+77-256], v[vgprGlobalReadOffsetB+54], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_54_0
buffer_load_d16_u8 v[vgprG2LB+109-256], v[vgprGlobalReadOffsetB+55], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_55_0
buffer_load_d16_u8 v[vgprG2LB+14-256], v[vgprGlobalReadOffsetB+56], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_56_0
buffer_load_d16_u8 v[vgprG2LB+46-256], v[vgprGlobalReadOffsetB+57], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_57_0
s_wait_alu depctr_vm_vsrc(5)
buffer_load_d16_u8 v[vgprG2LB+78-256], v[vgprGlobalReadOffsetB+58], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_58_0
s_wait_alu depctr_va_vdst(12) depctr_vm_vsrc(4)
buffer_load_d16_u8 v[vgprG2LB+110-256], v[vgprGlobalReadOffsetB+59], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_59_0
s_wait_alu depctr_va_vdst(9) depctr_vm_vsrc(3)
buffer_load_d16_u8 v[vgprG2LB+15-256], v[vgprGlobalReadOffsetB+60], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_60_0
s_wait_alu depctr_va_vdst(6) depctr_vm_vsrc(2)
buffer_load_d16_u8 v[vgprG2LB+47-256], v[vgprGlobalReadOffsetB+61], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_61_0
s_wait_alu depctr_va_vdst(3) depctr_vm_vsrc(1)
buffer_load_d16_u8 v[vgprG2LB+79-256], v[vgprGlobalReadOffsetB+62], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_62_0
s_wait_alu depctr_va_vdst(0) depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+111-256], v[vgprGlobalReadOffsetB+63], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_63_0
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
s_wait_alu depctr_va_vdst(14)
ds_load_b128 v[vgprValuA_X0_I0+0:vgprValuA_X0_I0+0+3], v[vgprLocalReadAddrA+0] offset:0 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_b128 v[vgprValuA_X0_I0+4:vgprValuA_X0_I0+4+3], v[vgprLocalReadAddrA+0] offset:32 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D0+0], v[vgprLocalReadAddrB+0] offset:0 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D1+0], v[vgprLocalReadAddrB+0] offset:64 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D2+0], v[vgprLocalReadAddrB+0] offset:128 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=2 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D3+0], v[vgprLocalReadAddrB+0] offset:192 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=3 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D4+0], v[vgprLocalReadAddrB+0] offset:256 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=4 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D5+0], v[vgprLocalReadAddrB+0] offset:320 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=5 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D6+0], v[vgprLocalReadAddrB+0] offset:384 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=6 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D7+0], v[vgprLocalReadAddrB+0] offset:448 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=7 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D8+0], v[vgprLocalReadAddrB+0] offset:512 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=8 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D9+0], v[vgprLocalReadAddrB+0] offset:576 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=9 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D10+0], v[vgprLocalReadAddrB+0] offset:640 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=10 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D11+0], v[vgprLocalReadAddrB+0] offset:704 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=11 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D12+0], v[vgprLocalReadAddrB+0] offset:768 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=12 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D13+0], v[vgprLocalReadAddrB+0] offset:832 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=13 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D14+0], v[vgprLocalReadAddrB+0] offset:896 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=14 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D15+0], v[vgprLocalReadAddrB+0] offset:960 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=15 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D16+0], v[vgprLocalReadAddrB+0] offset:2112 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=16 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D17+0], v[vgprLocalReadAddrB+0] offset:2176 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=17 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D18+0], v[vgprLocalReadAddrB+0] offset:2240 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=18 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D19+0], v[vgprLocalReadAddrB+0] offset:2304 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=19 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D20+0], v[vgprLocalReadAddrB+0] offset:2368 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=20 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D21+0], v[vgprLocalReadAddrB+0] offset:2432 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=21 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D22+0], v[vgprLocalReadAddrB+0] offset:2496 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=22 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D23+0], v[vgprLocalReadAddrB+0] offset:2560 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=23 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D24+0], v[vgprLocalReadAddrB+0] offset:2624 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=24 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D25+0], v[vgprLocalReadAddrB+0] offset:2688 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=25 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D26+0], v[vgprLocalReadAddrB+0] offset:2752 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=26 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D27+0], v[vgprLocalReadAddrB+0] offset:2816 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=27 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D28+0], v[vgprLocalReadAddrB+0] offset:2880 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=28 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D29+0], v[vgprLocalReadAddrB+0] offset:2944 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=29 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D30+0], v[vgprLocalReadAddrB+0] offset:3008 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=30 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D31+0], v[vgprLocalReadAddrB+0] offset:3072 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=31 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_b128 v[vgprValuA_X0_I0+8:vgprValuA_X0_I0+8+3], v[vgprLocalReadAddrA+0] offset:64 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=1 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_b128 v[vgprValuA_X0_I0+12:vgprValuA_X0_I0+12+3], v[vgprLocalReadAddrA+0] offset:96 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=1 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS0
s_wait_dscnt 2                                     // Wait for dependent lr
v_perm_b32 v[vgprValuB_X0_I0+0], v[vgprValuB_X0_I0_D1+0], v[vgprValuB_X0_I0_D0+0], s[sgprPackKForV0] // select K=01 for vector=0
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D3+0], v[vgprValuB_X0_I0_D2+0], s[sgprPackKForV0] // select K=23 for vector=0
v_lshl_or_b32 v[vgprValuB_X0_I0+0], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+0] // pack two half Vgpr to one Vgpr
v_perm_b32 v[vgprValuB_X0_I0+1], v[vgprValuB_X0_I0_D5+0], v[vgprValuB_X0_I0_D4+0], s[sgprPackKForV0] // select K=45 for vector=0
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D7+0], v[vgprValuB_X0_I0_D6+0], s[sgprPackKForV0] // select K=67 for vector=0
v_lshl_or_b32 v[vgprValuB_X0_I0+1], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+1] // pack two half Vgpr to one Vgpr
v_perm_b32 v[vgprValuB_X0_I0+2], v[vgprValuB_X0_I0_D9+0], v[vgprValuB_X0_I0_D8+0], s[sgprPackKForV0] // select K=89 for vector=0
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D11+0], v[vgprValuB_X0_I0_D10+0], s[sgprPackKForV0] // select K=1011 for vector=0
v_lshl_or_b32 v[vgprValuB_X0_I0+2], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+2] // pack two half Vgpr to one Vgpr
v_perm_b32 v[vgprValuB_X0_I0+3], v[vgprValuB_X0_I0_D13+0], v[vgprValuB_X0_I0_D12+0], s[sgprPackKForV0] // select K=1213 for vector=0
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D15+0], v[vgprValuB_X0_I0_D14+0], s[sgprPackKForV0] // select K=1415 for vector=0
v_lshl_or_b32 v[vgprValuB_X0_I0+3], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+3] // pack two half Vgpr to one Vgpr
v_perm_b32 v[vgprValuB_X0_I0+4], v[vgprValuB_X0_I0_D17+0], v[vgprValuB_X0_I0_D16+0], s[sgprPackKForV0] // select K=1617 for vector=0
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D19+0], v[vgprValuB_X0_I0_D18+0], s[sgprPackKForV0] // select K=1819 for vector=0
v_lshl_or_b32 v[vgprValuB_X0_I0+4], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+4] // pack two half Vgpr to one Vgpr
v_perm_b32 v[vgprValuB_X0_I0+5], v[vgprValuB_X0_I0_D21+0], v[vgprValuB_X0_I0_D20+0], s[sgprPackKForV0] // select K=2021 for vector=0
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D23+0], v[vgprValuB_X0_I0_D22+0], s[sgprPackKForV0] // select K=2223 for vector=0
v_lshl_or_b32 v[vgprValuB_X0_I0+5], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+5] // pack two half Vgpr to one Vgpr
v_perm_b32 v[vgprValuB_X0_I0+6], v[vgprValuB_X0_I0_D25+0], v[vgprValuB_X0_I0_D24+0], s[sgprPackKForV0] // select K=2425 for vector=0
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D27+0], v[vgprValuB_X0_I0_D26+0], s[sgprPackKForV0] // select K=2627 for vector=0
v_lshl_or_b32 v[vgprValuB_X0_I0+6], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+6] // pack two half Vgpr to one Vgpr
v_perm_b32 v[vgprValuB_X0_I0+7], v[vgprValuB_X0_I0_D29+0], v[vgprValuB_X0_I0_D28+0], s[sgprPackKForV0] // select K=2829 for vector=0
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D31+0], v[vgprValuB_X0_I0_D30+0], s[sgprPackKForV0] // select K=3031 for vector=0
v_lshl_or_b32 v[vgprValuB_X0_I0+7], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+7] // pack two half Vgpr to one Vgpr
v_perm_b32 v[vgprValuB_X0_I0+8], v[vgprValuB_X0_I0_D1+0], v[vgprValuB_X0_I0_D0+0], s[sgprPackKForV1] // select K=01 for vector=1
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D3+0], v[vgprValuB_X0_I0_D2+0], s[sgprPackKForV1] // select K=23 for vector=1
v_wmma_f32_16x16x64_fp8_fp8 v[vgprValuC+0:vgprValuC+0+7], v[vgprValuB_X0_I0+0+0+0:vgprValuB_X0_I0+0+0+0+7], v[vgprValuA_X0_I0+0+0+0:vgprValuA_X0_I0+0+0+0+7], 0 matrix_a_reuse // left value = v[0+0:7+0]
s_cmp_eq_u32 s[sgprLoopCounterL], s[sgprStaggerUIter] // Is this the wrapIter?
s_cselect_b32 s68, s[sgprWrapUA+0], s[sgprGlobalReadIncsA+0] // incLower <- ?
s_cselect_b32 s69, s[sgprWrapUA+1], 0              // incUpper <- ?
s_wait_dscnt 0                                     // Wait for dependent lr
v_lshl_or_b32 v[vgprValuB_X0_I0+8], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+8] // pack two half Vgpr to one Vgpr
v_perm_b32 v[vgprValuB_X0_I0+9], v[vgprValuB_X0_I0_D5+0], v[vgprValuB_X0_I0_D4+0], s[sgprPackKForV1] // select K=45 for vector=1
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D7+0], v[vgprValuB_X0_I0_D6+0], s[sgprPackKForV1] // select K=67 for vector=1
v_lshl_or_b32 v[vgprValuB_X0_I0+9], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+9] // pack two half Vgpr to one Vgpr
v_perm_b32 v[vgprValuB_X0_I0+10], v[vgprValuB_X0_I0_D9+0], v[vgprValuB_X0_I0_D8+0], s[sgprPackKForV1] // select K=89 for vector=1
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D11+0], v[vgprValuB_X0_I0_D10+0], s[sgprPackKForV1] // select K=1011 for vector=1
v_lshl_or_b32 v[vgprValuB_X0_I0+10], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+10] // pack two half Vgpr to one Vgpr
v_perm_b32 v[vgprValuB_X0_I0+11], v[vgprValuB_X0_I0_D13+0], v[vgprValuB_X0_I0_D12+0], s[sgprPackKForV1] // select K=1213 for vector=1
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D15+0], v[vgprValuB_X0_I0_D14+0], s[sgprPackKForV1] // select K=1415 for vector=1
v_lshl_or_b32 v[vgprValuB_X0_I0+11], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+11] // pack two half Vgpr to one Vgpr
v_perm_b32 v[vgprValuB_X0_I0+12], v[vgprValuB_X0_I0_D17+0], v[vgprValuB_X0_I0_D16+0], s[sgprPackKForV1] // select K=1617 for vector=1
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D19+0], v[vgprValuB_X0_I0_D18+0], s[sgprPackKForV1] // select K=1819 for vector=1
v_lshl_or_b32 v[vgprValuB_X0_I0+12], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+12] // pack two half Vgpr to one Vgpr
v_perm_b32 v[vgprValuB_X0_I0+13], v[vgprValuB_X0_I0_D21+0], v[vgprValuB_X0_I0_D20+0], s[sgprPackKForV1] // select K=2021 for vector=1
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D23+0], v[vgprValuB_X0_I0_D22+0], s[sgprPackKForV1] // select K=2223 for vector=1
v_lshl_or_b32 v[vgprValuB_X0_I0+13], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+13] // pack two half Vgpr to one Vgpr
v_perm_b32 v[vgprValuB_X0_I0+14], v[vgprValuB_X0_I0_D25+0], v[vgprValuB_X0_I0_D24+0], s[sgprPackKForV1] // select K=2425 for vector=1
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D27+0], v[vgprValuB_X0_I0_D26+0], s[sgprPackKForV1] // select K=2627 for vector=1
v_lshl_or_b32 v[vgprValuB_X0_I0+14], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+14] // pack two half Vgpr to one Vgpr
v_perm_b32 v[vgprValuB_X0_I0+15], v[vgprValuB_X0_I0_D29+0], v[vgprValuB_X0_I0_D28+0], s[sgprPackKForV1] // select K=2829 for vector=1
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D31+0], v[vgprValuB_X0_I0_D30+0], s[sgprPackKForV1] // select K=3031 for vector=1
v_lshl_or_b32 v[vgprValuB_X0_I0+15], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+15] // pack two half Vgpr to one Vgpr
v_wmma_f32_16x16x64_fp8_fp8 v[vgprValuC+8:vgprValuC+8+7], v[vgprValuB_X0_I0+0+0+0:vgprValuB_X0_I0+0+0+0+7], v[vgprValuA_X0_I0+8+0+0:vgprValuA_X0_I0+8+0+0+7], 0 // left value = v[8+0:15+0]
s_add_u32 s[sgprSrdA+0], s[sgprSrdA+0], s68        // gra SRD += inc(lower)
s_addc_u32 s[sgprSrdA+1], s[sgprSrdA+1], s69       // gra SRD += inc(upper)
s_sub_u32 s[sgprShadowLimitA+0], s[sgprShadowLimitA+0], s68 // limit -= inc)
s_wait_dscnt 0
s_barrier_signal -1
s_barrier_wait -1
v_wmma_f32_16x16x64_fp8_fp8 v[vgprValuC+16:vgprValuC+16+7], v[vgprValuB_X0_I0+8+0+0:vgprValuB_X0_I0+8+0+0+7], v[vgprValuA_X0_I0+0+0+0:vgprValuA_X0_I0+0+0+0+7], 0 matrix_a_reuse // left value = v[16+0:23+0]
s_subb_u32 s[sgprShadowLimitA+1], s[sgprShadowLimitA+1], s69 // limit -= inc)
s_cmp_eq_u32 s[sgprShadowLimitA+1], 0              // are we within 2^32?
s_cselect_b32 s[sgprSrdA+2], s[sgprShadowLimitA+0], BufferLimit // Move shadow to real if we are within 2^32
s_and_b32 s8, s[sgprSrdA+2], 127
s_lshl_b32 s8, s8, 25
s_and_b32 s[sgprSrdA+1], s[sgprSrdA+1], 33554431
s_or_b32 s[sgprSrdA+1], s[sgprSrdA+1], s8
s_lshr_b32 s[sgprSrdA+2], s[sgprSrdA+2], 7
s_cmp_eq_u32 s[sgprLoopCounterL], s[sgprStaggerUIter] // Is this the wrapIter?
s_cselect_b32 s68, s[sgprWrapUB+0], s[sgprGlobalReadIncsB+0] // incLower <- ?
s_cselect_b32 s69, s[sgprWrapUB+1], 0              // incUpper <- ?
s_add_u32 s[sgprSrdB+0], s[sgprSrdB+0], s68        // gra SRD += inc(lower)
s_addc_u32 s[sgprSrdB+1], s[sgprSrdB+1], s69       // gra SRD += inc(upper)
s_sub_u32 s[sgprShadowLimitB+0], s[sgprShadowLimitB+0], s68 // limit -= inc)
s_subb_u32 s[sgprShadowLimitB+1], s[sgprShadowLimitB+1], s69 // limit -= inc)
s_cmp_eq_u32 s[sgprShadowLimitB+1], 0              // are we within 2^32?
s_cselect_b32 s[sgprSrdB+2], s[sgprShadowLimitB+0], BufferLimit // Move shadow to real if we are within 2^32
s_and_b32 s8, s[sgprSrdB+2], 127
s_lshl_b32 s8, s8, 25
s_and_b32 s[sgprSrdB+1], s[sgprSrdB+1], 33554431
s_or_b32 s[sgprSrdB+1], s[sgprSrdB+1], s8
s_lshr_b32 s[sgprSrdB+2], s[sgprSrdB+2], 7
s_wait_loadcnt 63                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+0] offset:0 // lwoA_0_0_0_0 = (0*LSCA)*(MT0I+PAD) + (0*LSPA) = 0 sync LDS0
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LA+0], v[vgprGlobalReadOffsetA+0], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_0_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+16] offset:64 // lwoA_0_0_1_0 = (0*LSCA)*(MT0I+PAD) + (1*LSPA) = 64 sync LDS0
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LA+16], v[vgprGlobalReadOffsetA+1], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_1_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+32] offset:128 // lwoA_0_0_2_0 = (0*LSCA)*(MT0I+PAD) + (2*LSPA) = 128 sync LDS0
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LA+32], v[vgprGlobalReadOffsetA+2], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_2_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+48] offset:192 // lwoA_0_0_3_0 = (0*LSCA)*(MT0I+PAD) + (3*LSPA) = 192 sync LDS0
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LA+48], v[vgprGlobalReadOffsetA+3], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_3_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+1] offset:272 // lwoA_0_0_4_0 = (0*LSCA)*(MT0I+PAD) + (4*LSPA) = 272 sync LDS0
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LA+1], v[vgprGlobalReadOffsetA+4], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_4_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+17] offset:336 // lwoA_0_0_5_0 = (0*LSCA)*(MT0I+PAD) + (5*LSPA) = 336 sync LDS0
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LA+17], v[vgprGlobalReadOffsetA+5], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_5_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+33] offset:400 // lwoA_0_0_6_0 = (0*LSCA)*(MT0I+PAD) + (6*LSPA) = 400 sync LDS0
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LA+33], v[vgprGlobalReadOffsetA+6], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_6_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+49] offset:464 // lwoA_0_0_7_0 = (0*LSCA)*(MT0I+PAD) + (7*LSPA) = 464 sync LDS0
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LA+49], v[vgprGlobalReadOffsetA+7], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_7_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+2] offset:544 // lwoA_0_0_8_0 = (0*LSCA)*(MT0I+PAD) + (8*LSPA) = 544 sync LDS0
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LA+2], v[vgprGlobalReadOffsetA+8], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_8_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+18] offset:608 // lwoA_0_0_9_0 = (0*LSCA)*(MT0I+PAD) + (9*LSPA) = 608 sync LDS0
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LA+18], v[vgprGlobalReadOffsetA+9], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_9_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+34] offset:672 // lwoA_0_0_10_0 = (0*LSCA)*(MT0I+PAD) + (10*LSPA) = 672 sync LDS0
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LA+34], v[vgprGlobalReadOffsetA+10], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_10_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+50] offset:736 // lwoA_0_0_11_0 = (0*LSCA)*(MT0I+PAD) + (11*LSPA) = 736 sync LDS0
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LA+50], v[vgprGlobalReadOffsetA+11], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_11_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+3] offset:816 // lwoA_0_0_12_0 = (0*LSCA)*(MT0I+PAD) + (12*LSPA) = 816 sync LDS0
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LA+3], v[vgprGlobalReadOffsetA+12], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_12_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+19] offset:880 // lwoA_0_0_13_0 = (0*LSCA)*(MT0I+PAD) + (13*LSPA) = 880 sync LDS0
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LA+19], v[vgprGlobalReadOffsetA+13], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_13_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+35] offset:944 // lwoA_0_0_14_0 = (0*LSCA)*(MT0I+PAD) + (14*LSPA) = 944 sync LDS0
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LA+35], v[vgprGlobalReadOffsetA+14], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_14_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+51] offset:1008 // lwoA_0_0_15_0 = (0*LSCA)*(MT0I+PAD) + (15*LSPA) = 1008 sync LDS0
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LA+51], v[vgprGlobalReadOffsetA+15], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_15_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+4] offset:1088 // lwoA_0_0_16_0 = (0*LSCA)*(MT0I+PAD) + (16*LSPA) = 1088 sync LDS0
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LA+4], v[vgprGlobalReadOffsetA+16], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_16_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+20] offset:1152 // lwoA_0_0_17_0 = (0*LSCA)*(MT0I+PAD) + (17*LSPA) = 1152 sync LDS0
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LA+20], v[vgprGlobalReadOffsetA+17], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_17_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+36] offset:1216 // lwoA_0_0_18_0 = (0*LSCA)*(MT0I+PAD) + (18*LSPA) = 1216 sync LDS0
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LA+36], v[vgprGlobalReadOffsetA+18], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_18_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+52] offset:1280 // lwoA_0_0_19_0 = (0*LSCA)*(MT0I+PAD) + (19*LSPA) = 1280 sync LDS0
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LA+52], v[vgprGlobalReadOffsetA+19], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_19_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+5] offset:1360 // lwoA_0_0_20_0 = (0*LSCA)*(MT0I+PAD) + (20*LSPA) = 1360 sync LDS0
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LA+5], v[vgprGlobalReadOffsetA+20], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_20_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+21] offset:1424 // lwoA_0_0_21_0 = (0*LSCA)*(MT0I+PAD) + (21*LSPA) = 1424 sync LDS0
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LA+21], v[vgprGlobalReadOffsetA+21], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_21_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+37] offset:1488 // lwoA_0_0_22_0 = (0*LSCA)*(MT0I+PAD) + (22*LSPA) = 1488 sync LDS0
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LA+37], v[vgprGlobalReadOffsetA+22], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_22_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+53] offset:1552 // lwoA_0_0_23_0 = (0*LSCA)*(MT0I+PAD) + (23*LSPA) = 1552 sync LDS0
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LA+53], v[vgprGlobalReadOffsetA+23], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_23_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+6] offset:1632 // lwoA_0_0_24_0 = (0*LSCA)*(MT0I+PAD) + (24*LSPA) = 1632 sync LDS0
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LA+6], v[vgprGlobalReadOffsetA+24], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_24_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+22] offset:1696 // lwoA_0_0_25_0 = (0*LSCA)*(MT0I+PAD) + (25*LSPA) = 1696 sync LDS0
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LA+22], v[vgprGlobalReadOffsetA+25], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_25_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+38] offset:1760 // lwoA_0_0_26_0 = (0*LSCA)*(MT0I+PAD) + (26*LSPA) = 1760 sync LDS0
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LA+38], v[vgprGlobalReadOffsetA+26], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_26_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+54] offset:1824 // lwoA_0_0_27_0 = (0*LSCA)*(MT0I+PAD) + (27*LSPA) = 1824 sync LDS0
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LA+54], v[vgprGlobalReadOffsetA+27], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_27_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+7] offset:1904 // lwoA_0_0_28_0 = (0*LSCA)*(MT0I+PAD) + (28*LSPA) = 1904 sync LDS0
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LA+7], v[vgprGlobalReadOffsetA+28], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_28_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+23] offset:1968 // lwoA_0_0_29_0 = (0*LSCA)*(MT0I+PAD) + (29*LSPA) = 1968 sync LDS0
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LA+23], v[vgprGlobalReadOffsetA+29], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_29_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+39] offset:2032 // lwoA_0_0_30_0 = (0*LSCA)*(MT0I+PAD) + (30*LSPA) = 2032 sync LDS0
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LA+39], v[vgprGlobalReadOffsetA+30], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_30_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+55] offset:2096 // lwoA_0_0_31_0 = (0*LSCA)*(MT0I+PAD) + (31*LSPA) = 2096 sync LDS0
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LA+55], v[vgprGlobalReadOffsetA+31], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_31_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+0-256] offset:0 // lwoB_0_0_0_0 = (0*LSCB) + (0*LSPB)(*MT1J+PAD) = 0 sync LDS0
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+0-256], v[vgprGlobalReadOffsetB+0], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_0_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+32-256] offset:64 // lwoB_0_0_1_0 = (0*LSCB) + (1*LSPB)(*MT1J+PAD) = 64 sync LDS0
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+32-256], v[vgprGlobalReadOffsetB+1], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_1_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+64-256] offset:128 // lwoB_0_0_2_0 = (0*LSCB) + (2*LSPB)(*MT1J+PAD) = 128 sync LDS0
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+64-256], v[vgprGlobalReadOffsetB+2], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_2_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+96-256] offset:192 // lwoB_0_0_3_0 = (0*LSCB) + (3*LSPB)(*MT1J+PAD) = 192 sync LDS0
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+96-256], v[vgprGlobalReadOffsetB+3], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_3_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+1-256] offset:256 // lwoB_0_0_4_0 = (0*LSCB) + (4*LSPB)(*MT1J+PAD) = 256 sync LDS0
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+1-256], v[vgprGlobalReadOffsetB+4], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_4_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+33-256] offset:320 // lwoB_0_0_5_0 = (0*LSCB) + (5*LSPB)(*MT1J+PAD) = 320 sync LDS0
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+33-256], v[vgprGlobalReadOffsetB+5], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_5_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+65-256] offset:384 // lwoB_0_0_6_0 = (0*LSCB) + (6*LSPB)(*MT1J+PAD) = 384 sync LDS0
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+65-256], v[vgprGlobalReadOffsetB+6], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_6_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+97-256] offset:448 // lwoB_0_0_7_0 = (0*LSCB) + (7*LSPB)(*MT1J+PAD) = 448 sync LDS0
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+97-256], v[vgprGlobalReadOffsetB+7], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_7_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+2-256] offset:512 // lwoB_0_0_8_0 = (0*LSCB) + (8*LSPB)(*MT1J+PAD) = 512 sync LDS0
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+2-256], v[vgprGlobalReadOffsetB+8], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_8_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+34-256] offset:576 // lwoB_0_0_9_0 = (0*LSCB) + (9*LSPB)(*MT1J+PAD) = 576 sync LDS0
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+34-256], v[vgprGlobalReadOffsetB+9], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_9_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+66-256] offset:640 // lwoB_0_0_10_0 = (0*LSCB) + (10*LSPB)(*MT1J+PAD) = 640 sync LDS0
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+66-256], v[vgprGlobalReadOffsetB+10], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_10_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+98-256] offset:704 // lwoB_0_0_11_0 = (0*LSCB) + (11*LSPB)(*MT1J+PAD) = 704 sync LDS0
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+98-256], v[vgprGlobalReadOffsetB+11], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_11_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+3-256] offset:768 // lwoB_0_0_12_0 = (0*LSCB) + (12*LSPB)(*MT1J+PAD) = 768 sync LDS0
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+3-256], v[vgprGlobalReadOffsetB+12], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_12_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+35-256] offset:832 // lwoB_0_0_13_0 = (0*LSCB) + (13*LSPB)(*MT1J+PAD) = 832 sync LDS0
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+35-256], v[vgprGlobalReadOffsetB+13], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_13_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+67-256] offset:896 // lwoB_0_0_14_0 = (0*LSCB) + (14*LSPB)(*MT1J+PAD) = 896 sync LDS0
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+67-256], v[vgprGlobalReadOffsetB+14], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_14_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+99-256] offset:960 // lwoB_0_0_15_0 = (0*LSCB) + (15*LSPB)(*MT1J+PAD) = 960 sync LDS0
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+99-256], v[vgprGlobalReadOffsetB+15], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_15_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+4-256] offset:1056 // lwoB_0_0_16_0 = (0*LSCB) + (16*LSPB)(*MT1J+PAD) = 1056 sync LDS0
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+4-256], v[vgprGlobalReadOffsetB+16], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_16_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+36-256] offset:1120 // lwoB_0_0_17_0 = (0*LSCB) + (17*LSPB)(*MT1J+PAD) = 1120 sync LDS0
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+36-256], v[vgprGlobalReadOffsetB+17], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_17_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+68-256] offset:1184 // lwoB_0_0_18_0 = (0*LSCB) + (18*LSPB)(*MT1J+PAD) = 1184 sync LDS0
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+68-256], v[vgprGlobalReadOffsetB+18], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_18_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+100-256] offset:1248 // lwoB_0_0_19_0 = (0*LSCB) + (19*LSPB)(*MT1J+PAD) = 1248 sync LDS0
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+100-256], v[vgprGlobalReadOffsetB+19], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_19_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+5-256] offset:1312 // lwoB_0_0_20_0 = (0*LSCB) + (20*LSPB)(*MT1J+PAD) = 1312 sync LDS0
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+5-256], v[vgprGlobalReadOffsetB+20], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_20_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+37-256] offset:1376 // lwoB_0_0_21_0 = (0*LSCB) + (21*LSPB)(*MT1J+PAD) = 1376 sync LDS0
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+37-256], v[vgprGlobalReadOffsetB+21], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_21_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+69-256] offset:1440 // lwoB_0_0_22_0 = (0*LSCB) + (22*LSPB)(*MT1J+PAD) = 1440 sync LDS0
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+69-256], v[vgprGlobalReadOffsetB+22], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_22_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+101-256] offset:1504 // lwoB_0_0_23_0 = (0*LSCB) + (23*LSPB)(*MT1J+PAD) = 1504 sync LDS0
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+101-256], v[vgprGlobalReadOffsetB+23], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_23_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+6-256] offset:1568 // lwoB_0_0_24_0 = (0*LSCB) + (24*LSPB)(*MT1J+PAD) = 1568 sync LDS0
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+6-256], v[vgprGlobalReadOffsetB+24], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_24_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+38-256] offset:1632 // lwoB_0_0_25_0 = (0*LSCB) + (25*LSPB)(*MT1J+PAD) = 1632 sync LDS0
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+38-256], v[vgprGlobalReadOffsetB+25], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_25_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+70-256] offset:1696 // lwoB_0_0_26_0 = (0*LSCB) + (26*LSPB)(*MT1J+PAD) = 1696 sync LDS0
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+70-256], v[vgprGlobalReadOffsetB+26], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_26_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+102-256] offset:1760 // lwoB_0_0_27_0 = (0*LSCB) + (27*LSPB)(*MT1J+PAD) = 1760 sync LDS0
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+102-256], v[vgprGlobalReadOffsetB+27], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_27_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+7-256] offset:1824 // lwoB_0_0_28_0 = (0*LSCB) + (28*LSPB)(*MT1J+PAD) = 1824 sync LDS0
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+7-256], v[vgprGlobalReadOffsetB+28], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_28_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+39-256] offset:1888 // lwoB_0_0_29_0 = (0*LSCB) + (29*LSPB)(*MT1J+PAD) = 1888 sync LDS0
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+39-256], v[vgprGlobalReadOffsetB+29], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_29_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+71-256] offset:1952 // lwoB_0_0_30_0 = (0*LSCB) + (30*LSPB)(*MT1J+PAD) = 1952 sync LDS0
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+71-256], v[vgprGlobalReadOffsetB+30], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_30_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+103-256] offset:2016 // lwoB_0_0_31_0 = (0*LSCB) + (31*LSPB)(*MT1J+PAD) = 2016 sync LDS0
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+103-256], v[vgprGlobalReadOffsetB+31], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_31_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+8-256] offset:2112 // lwoB_0_0_32_0 = (0*LSCB) + (32*LSPB)(*MT1J+PAD) = 2112 sync LDS0
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+8-256], v[vgprGlobalReadOffsetB+32], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_32_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+40-256] offset:2176 // lwoB_0_0_33_0 = (0*LSCB) + (33*LSPB)(*MT1J+PAD) = 2176 sync LDS0
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+40-256], v[vgprGlobalReadOffsetB+33], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_33_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+72-256] offset:2240 // lwoB_0_0_34_0 = (0*LSCB) + (34*LSPB)(*MT1J+PAD) = 2240 sync LDS0
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+72-256], v[vgprGlobalReadOffsetB+34], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_34_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+104-256] offset:2304 // lwoB_0_0_35_0 = (0*LSCB) + (35*LSPB)(*MT1J+PAD) = 2304 sync LDS0
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+104-256], v[vgprGlobalReadOffsetB+35], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_35_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+9-256] offset:2368 // lwoB_0_0_36_0 = (0*LSCB) + (36*LSPB)(*MT1J+PAD) = 2368 sync LDS0
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+9-256], v[vgprGlobalReadOffsetB+36], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_36_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+41-256] offset:2432 // lwoB_0_0_37_0 = (0*LSCB) + (37*LSPB)(*MT1J+PAD) = 2432 sync LDS0
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+41-256], v[vgprGlobalReadOffsetB+37], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_37_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+73-256] offset:2496 // lwoB_0_0_38_0 = (0*LSCB) + (38*LSPB)(*MT1J+PAD) = 2496 sync LDS0
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+73-256], v[vgprGlobalReadOffsetB+38], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_38_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+105-256] offset:2560 // lwoB_0_0_39_0 = (0*LSCB) + (39*LSPB)(*MT1J+PAD) = 2560 sync LDS0
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+105-256], v[vgprGlobalReadOffsetB+39], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_39_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+10-256] offset:2624 // lwoB_0_0_40_0 = (0*LSCB) + (40*LSPB)(*MT1J+PAD) = 2624 sync LDS0
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+10-256], v[vgprGlobalReadOffsetB+40], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_40_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+42-256] offset:2688 // lwoB_0_0_41_0 = (0*LSCB) + (41*LSPB)(*MT1J+PAD) = 2688 sync LDS0
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+42-256], v[vgprGlobalReadOffsetB+41], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_41_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+74-256] offset:2752 // lwoB_0_0_42_0 = (0*LSCB) + (42*LSPB)(*MT1J+PAD) = 2752 sync LDS0
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+74-256], v[vgprGlobalReadOffsetB+42], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_42_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+106-256] offset:2816 // lwoB_0_0_43_0 = (0*LSCB) + (43*LSPB)(*MT1J+PAD) = 2816 sync LDS0
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+106-256], v[vgprGlobalReadOffsetB+43], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_43_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+11-256] offset:2880 // lwoB_0_0_44_0 = (0*LSCB) + (44*LSPB)(*MT1J+PAD) = 2880 sync LDS0
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+11-256], v[vgprGlobalReadOffsetB+44], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_44_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+43-256] offset:2944 // lwoB_0_0_45_0 = (0*LSCB) + (45*LSPB)(*MT1J+PAD) = 2944 sync LDS0
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+43-256], v[vgprGlobalReadOffsetB+45], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_45_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+75-256] offset:3008 // lwoB_0_0_46_0 = (0*LSCB) + (46*LSPB)(*MT1J+PAD) = 3008 sync LDS0
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+75-256], v[vgprGlobalReadOffsetB+46], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_46_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+107-256] offset:3072 // lwoB_0_0_47_0 = (0*LSCB) + (47*LSPB)(*MT1J+PAD) = 3072 sync LDS0
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+107-256], v[vgprGlobalReadOffsetB+47], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_47_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+12-256] offset:3168 // lwoB_0_0_48_0 = (0*LSCB) + (48*LSPB)(*MT1J+PAD) = 3168 sync LDS0
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+12-256], v[vgprGlobalReadOffsetB+48], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_48_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+44-256] offset:3232 // lwoB_0_0_49_0 = (0*LSCB) + (49*LSPB)(*MT1J+PAD) = 3232 sync LDS0
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+44-256], v[vgprGlobalReadOffsetB+49], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_49_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+76-256] offset:3296 // lwoB_0_0_50_0 = (0*LSCB) + (50*LSPB)(*MT1J+PAD) = 3296 sync LDS0
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+76-256], v[vgprGlobalReadOffsetB+50], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_50_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+108-256] offset:3360 // lwoB_0_0_51_0 = (0*LSCB) + (51*LSPB)(*MT1J+PAD) = 3360 sync LDS0
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+108-256], v[vgprGlobalReadOffsetB+51], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_51_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+13-256] offset:3424 // lwoB_0_0_52_0 = (0*LSCB) + (52*LSPB)(*MT1J+PAD) = 3424 sync LDS0
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+13-256], v[vgprGlobalReadOffsetB+52], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_52_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+45-256] offset:3488 // lwoB_0_0_53_0 = (0*LSCB) + (53*LSPB)(*MT1J+PAD) = 3488 sync LDS0
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+45-256], v[vgprGlobalReadOffsetB+53], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_53_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+77-256] offset:3552 // lwoB_0_0_54_0 = (0*LSCB) + (54*LSPB)(*MT1J+PAD) = 3552 sync LDS0
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+77-256], v[vgprGlobalReadOffsetB+54], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_54_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+109-256] offset:3616 // lwoB_0_0_55_0 = (0*LSCB) + (55*LSPB)(*MT1J+PAD) = 3616 sync LDS0
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+109-256], v[vgprGlobalReadOffsetB+55], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_55_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+14-256] offset:3680 // lwoB_0_0_56_0 = (0*LSCB) + (56*LSPB)(*MT1J+PAD) = 3680 sync LDS0
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+14-256], v[vgprGlobalReadOffsetB+56], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_56_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+46-256] offset:3744 // lwoB_0_0_57_0 = (0*LSCB) + (57*LSPB)(*MT1J+PAD) = 3744 sync LDS0
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+46-256], v[vgprGlobalReadOffsetB+57], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_57_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+78-256] offset:3808 // lwoB_0_0_58_0 = (0*LSCB) + (58*LSPB)(*MT1J+PAD) = 3808 sync LDS0
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+78-256], v[vgprGlobalReadOffsetB+58], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_58_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+110-256] offset:3872 // lwoB_0_0_59_0 = (0*LSCB) + (59*LSPB)(*MT1J+PAD) = 3872 sync LDS0
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_va_vdst(14) depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+110-256], v[vgprGlobalReadOffsetB+59], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_59_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+15-256] offset:3936 // lwoB_0_0_60_0 = (0*LSCB) + (60*LSPB)(*MT1J+PAD) = 3936 sync LDS0
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+15-256], v[vgprGlobalReadOffsetB+60], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_60_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+47-256] offset:4000 // lwoB_0_0_61_0 = (0*LSCB) + (61*LSPB)(*MT1J+PAD) = 4000 sync LDS0
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+47-256], v[vgprGlobalReadOffsetB+61], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_61_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+79-256] offset:4064 // lwoB_0_0_62_0 = (0*LSCB) + (62*LSPB)(*MT1J+PAD) = 4064 sync LDS0
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+79-256], v[vgprGlobalReadOffsetB+62], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_62_0
s_wait_loadcnt 63                                  // wait for global read before writing to local
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+111-256] offset:4128 // lwoB_0_0_63_0 = (0*LSCB) + (63*LSPB)(*MT1J+PAD) = 4128 sync LDS0
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1
s_wait_alu depctr_vm_vsrc(0)
buffer_load_d16_u8 v[vgprG2LB+111-256], v[vgprGlobalReadOffsetB+63], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_63_0
s_set_vgpr_msb 16384                               // src0: 0, src1: 0, src2: 0, dst: 0
v_wmma_f32_16x16x64_fp8_fp8 v[vgprValuC+24:vgprValuC+24+7], v[vgprValuB_X0_I0+8+0+0:vgprValuB_X0_I0+8+0+0+7], v[vgprValuA_X0_I0+8+0+0:vgprValuA_X0_I0+8+0+0+7], 0 // left value = v[24+0:31+0]
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
/*  grEndMfmaIndex:3, lwStartMfmaIndex:3, lwEndMfmaIndex:3  */
/*  numMfmaForLR:3, syncPlrMfmaIndex:0 , sync1LdsMfmaIndex:2 */
/*  mfmaIndex:0  */
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0 <This is 13-cycle>
ds_load_b128 v[vgprValuA_X0_I0+0:vgprValuA_X0_I0+0+3], v[vgprLocalReadAddrA+0] offset:0 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 14-cycle>
ds_load_b128 v[vgprValuA_X0_I0+4:vgprValuA_X0_I0+4+3], v[vgprLocalReadAddrA+0] offset:32 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 16-cycle>
ds_load_u16 v[vgprValuB_X0_I0_D0+0], v[vgprLocalReadAddrB+0] offset:0 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 18-cycle>
ds_load_u16 v[vgprValuB_X0_I0_D1+0], v[vgprLocalReadAddrB+0] offset:64 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 20-cycle>
ds_load_u16 v[vgprValuB_X0_I0_D2+0], v[vgprLocalReadAddrB+0] offset:128 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=2 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 22-cycle>
ds_load_u16 v[vgprValuB_X0_I0_D3+0], v[vgprLocalReadAddrB+0] offset:192 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=3 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 24-cycle>
ds_load_u16 v[vgprValuB_X0_I0_D4+0], v[vgprLocalReadAddrB+0] offset:256 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=4 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 26-cycle>
ds_load_u16 v[vgprValuB_X0_I0_D5+0], v[vgprLocalReadAddrB+0] offset:320 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=5 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 28-cycle>
ds_load_u16 v[vgprValuB_X0_I0_D6+0], v[vgprLocalReadAddrB+0] offset:384 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=6 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 30-cycle>
ds_load_u16 v[vgprValuB_X0_I0_D7+0], v[vgprLocalReadAddrB+0] offset:448 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=7 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 32-cycle>
ds_load_u16 v[vgprValuB_X0_I0_D8+0], v[vgprLocalReadAddrB+0] offset:512 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=8 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 34-cycle>
ds_load_u16 v[vgprValuB_X0_I0_D9+0], v[vgprLocalReadAddrB+0] offset:576 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=9 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 36-cycle>
ds_load_u16 v[vgprValuB_X0_I0_D10+0], v[vgprLocalReadAddrB+0] offset:640 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=10 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 38-cycle>
ds_load_u16 v[vgprValuB_X0_I0_D11+0], v[vgprLocalReadAddrB+0] offset:704 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=11 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 40-cycle>
ds_load_u16 v[vgprValuB_X0_I0_D12+0], v[vgprLocalReadAddrB+0] offset:768 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=12 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 42-cycle>
ds_load_u16 v[vgprValuB_X0_I0_D13+0], v[vgprLocalReadAddrB+0] offset:832 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=13 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 44-cycle>
ds_load_u16 v[vgprValuB_X0_I0_D14+0], v[vgprLocalReadAddrB+0] offset:896 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=14 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 46-cycle>
ds_load_u16 v[vgprValuB_X0_I0_D15+0], v[vgprLocalReadAddrB+0] offset:960 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=15 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 48-cycle>
ds_load_u16 v[vgprValuB_X0_I0_D16+0], v[vgprLocalReadAddrB+0] offset:2112 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=16 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 50-cycle>
ds_load_u16 v[vgprValuB_X0_I0_D17+0], v[vgprLocalReadAddrB+0] offset:2176 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=17 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 52-cycle>
ds_load_u16 v[vgprValuB_X0_I0_D18+0], v[vgprLocalReadAddrB+0] offset:2240 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=18 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 54-cycle>
ds_load_u16 v[vgprValuB_X0_I0_D19+0], v[vgprLocalReadAddrB+0] offset:2304 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=19 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 56-cycle>
ds_load_u16 v[vgprValuB_X0_I0_D20+0], v[vgprLocalReadAddrB+0] offset:2368 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=20 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 58-cycle>
ds_load_u16 v[vgprValuB_X0_I0_D21+0], v[vgprLocalReadAddrB+0] offset:2432 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=21 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 60-cycle>
ds_load_u16 v[vgprValuB_X0_I0_D22+0], v[vgprLocalReadAddrB+0] offset:2496 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=22 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 62-cycle>
ds_load_u16 v[vgprValuB_X0_I0_D23+0], v[vgprLocalReadAddrB+0] offset:2560 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=23 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 64-cycle>
ds_load_u16 v[vgprValuB_X0_I0_D24+0], v[vgprLocalReadAddrB+0] offset:2624 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=24 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 66-cycle>
ds_load_u16 v[vgprValuB_X0_I0_D25+0], v[vgprLocalReadAddrB+0] offset:2688 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=25 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 68-cycle>
ds_load_u16 v[vgprValuB_X0_I0_D26+0], v[vgprLocalReadAddrB+0] offset:2752 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=26 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 70-cycle>
ds_load_u16 v[vgprValuB_X0_I0_D27+0], v[vgprLocalReadAddrB+0] offset:2816 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=27 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 72-cycle>
ds_load_u16 v[vgprValuB_X0_I0_D28+0], v[vgprLocalReadAddrB+0] offset:2880 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=28 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 74-cycle>
ds_load_u16 v[vgprValuB_X0_I0_D29+0], v[vgprLocalReadAddrB+0] offset:2944 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=29 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 76-cycle>
ds_load_u16 v[vgprValuB_X0_I0_D30+0], v[vgprLocalReadAddrB+0] offset:3008 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=30 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 78-cycle>
ds_load_u16 v[vgprValuB_X0_I0_D31+0], v[vgprLocalReadAddrB+0] offset:3072 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=31 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 80-cycle>
ds_load_b128 v[vgprValuA_X0_I0+8:vgprValuA_X0_I0+8+3], v[vgprLocalReadAddrA+0] offset:64 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=1 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 82-cycle>
ds_load_b128 v[vgprValuA_X0_I0+12:vgprValuA_X0_I0+12+3], v[vgprLocalReadAddrA+0] offset:96 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=1 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 84-cycle>
s_wait_dscnt 2                                     // Wait for dependent lr <This is 90-cycle>
/* pack scheduling: packAIdx:0, packBIdx:24 */
v_perm_b32 v[vgprValuB_X0_I0+0], v[vgprValuB_X0_I0_D1+0], v[vgprValuB_X0_I0_D0+0], s[sgprPackKForV0] // select K=01 for vector=0 <This is 91-cycle>
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D3+0], v[vgprValuB_X0_I0_D2+0], s[sgprPackKForV0] // select K=23 for vector=0 <This is 92-cycle>
v_lshl_or_b32 v[vgprValuB_X0_I0+0], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+0] // pack two half Vgpr to one Vgpr <This is 93-cycle>
v_perm_b32 v[vgprValuB_X0_I0+1], v[vgprValuB_X0_I0_D5+0], v[vgprValuB_X0_I0_D4+0], s[sgprPackKForV0] // select K=45 for vector=0 <This is 94-cycle>
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D7+0], v[vgprValuB_X0_I0_D6+0], s[sgprPackKForV0] // select K=67 for vector=0 <This is 95-cycle>
v_lshl_or_b32 v[vgprValuB_X0_I0+1], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+1] // pack two half Vgpr to one Vgpr <This is 96-cycle>
v_perm_b32 v[vgprValuB_X0_I0+2], v[vgprValuB_X0_I0_D9+0], v[vgprValuB_X0_I0_D8+0], s[sgprPackKForV0] // select K=89 for vector=0 <This is 97-cycle>
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D11+0], v[vgprValuB_X0_I0_D10+0], s[sgprPackKForV0] // select K=1011 for vector=0 <This is 98-cycle>
v_lshl_or_b32 v[vgprValuB_X0_I0+2], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+2] // pack two half Vgpr to one Vgpr <This is 99-cycle>
v_perm_b32 v[vgprValuB_X0_I0+3], v[vgprValuB_X0_I0_D13+0], v[vgprValuB_X0_I0_D12+0], s[sgprPackKForV0] // select K=1213 for vector=0 <This is 100-cycle>
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D15+0], v[vgprValuB_X0_I0_D14+0], s[sgprPackKForV0] // select K=1415 for vector=0 <This is 101-cycle>
v_lshl_or_b32 v[vgprValuB_X0_I0+3], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+3] // pack two half Vgpr to one Vgpr <This is 102-cycle>
v_perm_b32 v[vgprValuB_X0_I0+4], v[vgprValuB_X0_I0_D17+0], v[vgprValuB_X0_I0_D16+0], s[sgprPackKForV0] // select K=1617 for vector=0 <This is 103-cycle>
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D19+0], v[vgprValuB_X0_I0_D18+0], s[sgprPackKForV0] // select K=1819 for vector=0 <This is 104-cycle>
v_lshl_or_b32 v[vgprValuB_X0_I0+4], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+4] // pack two half Vgpr to one Vgpr <This is 105-cycle>
v_perm_b32 v[vgprValuB_X0_I0+5], v[vgprValuB_X0_I0_D21+0], v[vgprValuB_X0_I0_D20+0], s[sgprPackKForV0] // select K=2021 for vector=0 <This is 106-cycle>
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D23+0], v[vgprValuB_X0_I0_D22+0], s[sgprPackKForV0] // select K=2223 for vector=0 <This is 107-cycle>
v_lshl_or_b32 v[vgprValuB_X0_I0+5], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+5] // pack two half Vgpr to one Vgpr <This is 108-cycle>
v_perm_b32 v[vgprValuB_X0_I0+6], v[vgprValuB_X0_I0_D25+0], v[vgprValuB_X0_I0_D24+0], s[sgprPackKForV0] // select K=2425 for vector=0 <This is 109-cycle>
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D27+0], v[vgprValuB_X0_I0_D26+0], s[sgprPackKForV0] // select K=2627 for vector=0 <This is 110-cycle>
v_lshl_or_b32 v[vgprValuB_X0_I0+6], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+6] // pack two half Vgpr to one Vgpr <This is 111-cycle>
v_perm_b32 v[vgprValuB_X0_I0+7], v[vgprValuB_X0_I0_D29+0], v[vgprValuB_X0_I0_D28+0], s[sgprPackKForV0] // select K=2829 for vector=0 <This is 112-cycle>
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D31+0], v[vgprValuB_X0_I0_D30+0], s[sgprPackKForV0] // select K=3031 for vector=0 <This is 113-cycle>
v_lshl_or_b32 v[vgprValuB_X0_I0+7], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+7] // pack two half Vgpr to one Vgpr <This is 114-cycle>
v_perm_b32 v[vgprValuB_X0_I0+8], v[vgprValuB_X0_I0_D1+0], v[vgprValuB_X0_I0_D0+0], s[sgprPackKForV1] // select K=01 for vector=1 <This is 115-cycle>
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D3+0], v[vgprValuB_X0_I0_D2+0], s[sgprPackKForV1] // select K=23 for vector=1 <This is 116-cycle>
v_wmma_f32_16x16x64_fp8_fp8 v[vgprValuC+0:vgprValuC+0+7], v[vgprValuB_X0_I0+0+0+0:vgprValuB_X0_I0+0+0+0+7], v[vgprValuA_X0_I0+0+0+0:vgprValuA_X0_I0+0+0+0+7], v[vgprValuC+0:vgprValuC+0+7] matrix_a_reuse // left value = v[0+0:7+0] <This is 117-cycle>
/*  mfmaIndex:1  */
/* localReadsVacancy: latencyLeft 5 */

/* global read inc A loopL */
s_cmp_eq_u32 s[sgprLoopCounterL], s[sgprStaggerUIter] // Is this the wrapIter? <This is 117-cycle>
s_cselect_b32 s68, s[sgprWrapUA+0], s[sgprGlobalReadIncsA+0] // incLower <- ? <This is 117-cycle>
s_cselect_b32 s69, s[sgprWrapUA+1], 0              // incUpper <- ? <This is 117-cycle>
s_wait_dscnt 0                                     // Wait for dependent lr <This is 117-cycle>
/* pack scheduling: packAIdx:0, packBIdx:24 */
v_lshl_or_b32 v[vgprValuB_X0_I0+8], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+8] // pack two half Vgpr to one Vgpr <This is 118-cycle>
v_perm_b32 v[vgprValuB_X0_I0+9], v[vgprValuB_X0_I0_D5+0], v[vgprValuB_X0_I0_D4+0], s[sgprPackKForV1] // select K=45 for vector=1 <This is 119-cycle>
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D7+0], v[vgprValuB_X0_I0_D6+0], s[sgprPackKForV1] // select K=67 for vector=1 <This is 120-cycle>
v_lshl_or_b32 v[vgprValuB_X0_I0+9], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+9] // pack two half Vgpr to one Vgpr <This is 121-cycle>
v_perm_b32 v[vgprValuB_X0_I0+10], v[vgprValuB_X0_I0_D9+0], v[vgprValuB_X0_I0_D8+0], s[sgprPackKForV1] // select K=89 for vector=1 <This is 122-cycle>
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D11+0], v[vgprValuB_X0_I0_D10+0], s[sgprPackKForV1] // select K=1011 for vector=1 <This is 123-cycle>
v_lshl_or_b32 v[vgprValuB_X0_I0+10], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+10] // pack two half Vgpr to one Vgpr <This is 124-cycle>
v_perm_b32 v[vgprValuB_X0_I0+11], v[vgprValuB_X0_I0_D13+0], v[vgprValuB_X0_I0_D12+0], s[sgprPackKForV1] // select K=1213 for vector=1 <This is 125-cycle>
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D15+0], v[vgprValuB_X0_I0_D14+0], s[sgprPackKForV1] // select K=1415 for vector=1 <This is 126-cycle>
v_lshl_or_b32 v[vgprValuB_X0_I0+11], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+11] // pack two half Vgpr to one Vgpr <This is 127-cycle>
v_perm_b32 v[vgprValuB_X0_I0+12], v[vgprValuB_X0_I0_D17+0], v[vgprValuB_X0_I0_D16+0], s[sgprPackKForV1] // select K=1617 for vector=1 <This is 128-cycle>
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D19+0], v[vgprValuB_X0_I0_D18+0], s[sgprPackKForV1] // select K=1819 for vector=1 <This is 129-cycle>
v_lshl_or_b32 v[vgprValuB_X0_I0+12], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+12] // pack two half Vgpr to one Vgpr <This is 130-cycle>
v_perm_b32 v[vgprValuB_X0_I0+13], v[vgprValuB_X0_I0_D21+0], v[vgprValuB_X0_I0_D20+0], s[sgprPackKForV1] // select K=2021 for vector=1 <This is 131-cycle>
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D23+0], v[vgprValuB_X0_I0_D22+0], s[sgprPackKForV1] // select K=2223 for vector=1 <This is 132-cycle>
v_lshl_or_b32 v[vgprValuB_X0_I0+13], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+13] // pack two half Vgpr to one Vgpr <This is 133-cycle>
v_perm_b32 v[vgprValuB_X0_I0+14], v[vgprValuB_X0_I0_D25+0], v[vgprValuB_X0_I0_D24+0], s[sgprPackKForV1] // select K=2425 for vector=1 <This is 134-cycle>
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D27+0], v[vgprValuB_X0_I0_D26+0], s[sgprPackKForV1] // select K=2627 for vector=1 <This is 135-cycle>
v_lshl_or_b32 v[vgprValuB_X0_I0+14], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+14] // pack two half Vgpr to one Vgpr <This is 136-cycle>
v_perm_b32 v[vgprValuB_X0_I0+15], v[vgprValuB_X0_I0_D29+0], v[vgprValuB_X0_I0_D28+0], s[sgprPackKForV1] // select K=2829 for vector=1 <This is 137-cycle>
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D31+0], v[vgprValuB_X0_I0_D30+0], s[sgprPackKForV1] // select K=3031 for vector=1 <This is 138-cycle>
v_lshl_or_b32 v[vgprValuB_X0_I0+15], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+15] // pack two half Vgpr to one Vgpr <This is 139-cycle>
v_wmma_f32_16x16x64_fp8_fp8 v[vgprValuC+8:vgprValuC+8+7], v[vgprValuB_X0_I0+0+0+0:vgprValuB_X0_I0+0+0+0+7], v[vgprValuA_X0_I0+8+0+0:vgprValuA_X0_I0+8+0+0+7], v[vgprValuC+8:vgprValuC+8+7] // left value = v[8+0:15+0] <This is 140-cycle>
/*  mfmaIndex:2  */
/* schedule remaining localreads for one buffer scheduling */
/* localReadsVacancy: latencyLeft 5 */
s_add_u32 s[sgprSrdA+0], s[sgprSrdA+0], s68        // gra SRD += inc(lower) <This is 140-cycle>
s_addc_u32 s[sgprSrdA+1], s[sgprSrdA+1], s69       // gra SRD += inc(upper) <This is 140-cycle>
s_sub_u32 s[sgprShadowLimitA+0], s[sgprShadowLimitA+0], s68 // limit -= inc) <This is 140-cycle>
/* 1 LDS buffer: read-sync-write */
s_wait_dscnt 0                                     // <This is 140-cycle>
s_barrier_signal -1                                // <This is 140-cycle>
s_barrier_wait -1                                  // <This is 140-cycle>
v_wmma_f32_16x16x64_fp8_fp8 v[vgprValuC+16:vgprValuC+16+7], v[vgprValuB_X0_I0+8+0+0:vgprValuB_X0_I0+8+0+0+7], v[vgprValuA_X0_I0+0+0+0:vgprValuA_X0_I0+0+0+0+7], v[vgprValuC+16:vgprValuC+16+7] matrix_a_reuse // left value = v[16+0:23+0] <This is 144-cycle>
/*  mfmaIndex:3  */
s_subb_u32 s[sgprShadowLimitA+1], s[sgprShadowLimitA+1], s69 // limit -= inc) <This is 144-cycle>
s_cmp_eq_u32 s[sgprShadowLimitA+1], 0              // are we within 2^32? <This is 144-cycle>
s_cselect_b32 s[sgprSrdA+2], s[sgprShadowLimitA+0], BufferLimit // Move shadow to real if we are within 2^32 <This is 144-cycle>
// Shift num records for gfx125x
s_and_b32 s8, s[sgprSrdA+2], 127                   // <This is 144-cycle>
s_lshl_b32 s8, s8, 25                              // <This is 144-cycle>
s_and_b32 s[sgprSrdA+1], s[sgprSrdA+1], 33554431   // <This is 144-cycle>
s_or_b32 s[sgprSrdA+1], s[sgprSrdA+1], s8          // <This is 144-cycle>
s_lshr_b32 s[sgprSrdA+2], s[sgprSrdA+2], 7         // <This is 144-cycle>

/* global read inc B loopL */
s_cmp_eq_u32 s[sgprLoopCounterL], s[sgprStaggerUIter] // Is this the wrapIter? <This is 144-cycle>
s_cselect_b32 s68, s[sgprWrapUB+0], s[sgprGlobalReadIncsB+0] // incLower <- ? <This is 144-cycle>
s_cselect_b32 s69, s[sgprWrapUB+1], 0              // incUpper <- ? <This is 144-cycle>
s_add_u32 s[sgprSrdB+0], s[sgprSrdB+0], s68        // gra SRD += inc(lower) <This is 144-cycle>
s_addc_u32 s[sgprSrdB+1], s[sgprSrdB+1], s69       // gra SRD += inc(upper) <This is 144-cycle>
s_sub_u32 s[sgprShadowLimitB+0], s[sgprShadowLimitB+0], s68 // limit -= inc) <This is 144-cycle>
s_subb_u32 s[sgprShadowLimitB+1], s[sgprShadowLimitB+1], s69 // limit -= inc) <This is 144-cycle>
s_cmp_eq_u32 s[sgprShadowLimitB+1], 0              // are we within 2^32? <This is 144-cycle>
s_cselect_b32 s[sgprSrdB+2], s[sgprShadowLimitB+0], BufferLimit // Move shadow to real if we are within 2^32 <This is 144-cycle>
// Shift num records for gfx125x
s_and_b32 s8, s[sgprSrdB+2], 127                   // <This is 144-cycle>
s_lshl_b32 s8, s8, 25                              // <This is 144-cycle>
s_and_b32 s[sgprSrdB+1], s[sgprSrdB+1], 33554431   // <This is 144-cycle>
s_or_b32 s[sgprSrdB+1], s[sgprSrdB+1], s8          // <This is 144-cycle>
s_lshr_b32 s[sgprSrdB+2], s[sgprSrdB+2], 7         // <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+0] offset:0 // lwoA_0_0_0_0 = (0*LSCA)*(MT0I+PAD) + (0*LSPA) = 0 sync LDS0 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LA+0], v[vgprGlobalReadOffsetA+0], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_0_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+16] offset:64 // lwoA_0_0_1_0 = (0*LSCA)*(MT0I+PAD) + (1*LSPA) = 64 sync LDS0 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LA+16], v[vgprGlobalReadOffsetA+1], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_1_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+32] offset:128 // lwoA_0_0_2_0 = (0*LSCA)*(MT0I+PAD) + (2*LSPA) = 128 sync LDS0 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LA+32], v[vgprGlobalReadOffsetA+2], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_2_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+48] offset:192 // lwoA_0_0_3_0 = (0*LSCA)*(MT0I+PAD) + (3*LSPA) = 192 sync LDS0 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LA+48], v[vgprGlobalReadOffsetA+3], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_3_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+1] offset:272 // lwoA_0_0_4_0 = (0*LSCA)*(MT0I+PAD) + (4*LSPA) = 272 sync LDS0 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LA+1], v[vgprGlobalReadOffsetA+4], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_4_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+17] offset:336 // lwoA_0_0_5_0 = (0*LSCA)*(MT0I+PAD) + (5*LSPA) = 336 sync LDS0 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LA+17], v[vgprGlobalReadOffsetA+5], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_5_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+33] offset:400 // lwoA_0_0_6_0 = (0*LSCA)*(MT0I+PAD) + (6*LSPA) = 400 sync LDS0 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LA+33], v[vgprGlobalReadOffsetA+6], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_6_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+49] offset:464 // lwoA_0_0_7_0 = (0*LSCA)*(MT0I+PAD) + (7*LSPA) = 464 sync LDS0 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LA+49], v[vgprGlobalReadOffsetA+7], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_7_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+2] offset:544 // lwoA_0_0_8_0 = (0*LSCA)*(MT0I+PAD) + (8*LSPA) = 544 sync LDS0 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LA+2], v[vgprGlobalReadOffsetA+8], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_8_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+18] offset:608 // lwoA_0_0_9_0 = (0*LSCA)*(MT0I+PAD) + (9*LSPA) = 608 sync LDS0 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LA+18], v[vgprGlobalReadOffsetA+9], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_9_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+34] offset:672 // lwoA_0_0_10_0 = (0*LSCA)*(MT0I+PAD) + (10*LSPA) = 672 sync LDS0 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LA+34], v[vgprGlobalReadOffsetA+10], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_10_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+50] offset:736 // lwoA_0_0_11_0 = (0*LSCA)*(MT0I+PAD) + (11*LSPA) = 736 sync LDS0 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LA+50], v[vgprGlobalReadOffsetA+11], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_11_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+3] offset:816 // lwoA_0_0_12_0 = (0*LSCA)*(MT0I+PAD) + (12*LSPA) = 816 sync LDS0 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LA+3], v[vgprGlobalReadOffsetA+12], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_12_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+19] offset:880 // lwoA_0_0_13_0 = (0*LSCA)*(MT0I+PAD) + (13*LSPA) = 880 sync LDS0 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LA+19], v[vgprGlobalReadOffsetA+13], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_13_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+35] offset:944 // lwoA_0_0_14_0 = (0*LSCA)*(MT0I+PAD) + (14*LSPA) = 944 sync LDS0 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LA+35], v[vgprGlobalReadOffsetA+14], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_14_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+51] offset:1008 // lwoA_0_0_15_0 = (0*LSCA)*(MT0I+PAD) + (15*LSPA) = 1008 sync LDS0 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LA+51], v[vgprGlobalReadOffsetA+15], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_15_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+4] offset:1088 // lwoA_0_0_16_0 = (0*LSCA)*(MT0I+PAD) + (16*LSPA) = 1088 sync LDS0 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LA+4], v[vgprGlobalReadOffsetA+16], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_16_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+20] offset:1152 // lwoA_0_0_17_0 = (0*LSCA)*(MT0I+PAD) + (17*LSPA) = 1152 sync LDS0 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LA+20], v[vgprGlobalReadOffsetA+17], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_17_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+36] offset:1216 // lwoA_0_0_18_0 = (0*LSCA)*(MT0I+PAD) + (18*LSPA) = 1216 sync LDS0 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LA+36], v[vgprGlobalReadOffsetA+18], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_18_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+52] offset:1280 // lwoA_0_0_19_0 = (0*LSCA)*(MT0I+PAD) + (19*LSPA) = 1280 sync LDS0 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LA+52], v[vgprGlobalReadOffsetA+19], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_19_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+5] offset:1360 // lwoA_0_0_20_0 = (0*LSCA)*(MT0I+PAD) + (20*LSPA) = 1360 sync LDS0 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LA+5], v[vgprGlobalReadOffsetA+20], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_20_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+21] offset:1424 // lwoA_0_0_21_0 = (0*LSCA)*(MT0I+PAD) + (21*LSPA) = 1424 sync LDS0 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LA+21], v[vgprGlobalReadOffsetA+21], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_21_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+37] offset:1488 // lwoA_0_0_22_0 = (0*LSCA)*(MT0I+PAD) + (22*LSPA) = 1488 sync LDS0 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LA+37], v[vgprGlobalReadOffsetA+22], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_22_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+53] offset:1552 // lwoA_0_0_23_0 = (0*LSCA)*(MT0I+PAD) + (23*LSPA) = 1552 sync LDS0 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LA+53], v[vgprGlobalReadOffsetA+23], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_23_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+6] offset:1632 // lwoA_0_0_24_0 = (0*LSCA)*(MT0I+PAD) + (24*LSPA) = 1632 sync LDS0 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LA+6], v[vgprGlobalReadOffsetA+24], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_24_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+22] offset:1696 // lwoA_0_0_25_0 = (0*LSCA)*(MT0I+PAD) + (25*LSPA) = 1696 sync LDS0 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LA+22], v[vgprGlobalReadOffsetA+25], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_25_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+38] offset:1760 // lwoA_0_0_26_0 = (0*LSCA)*(MT0I+PAD) + (26*LSPA) = 1760 sync LDS0 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LA+38], v[vgprGlobalReadOffsetA+26], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_26_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+54] offset:1824 // lwoA_0_0_27_0 = (0*LSCA)*(MT0I+PAD) + (27*LSPA) = 1824 sync LDS0 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LA+54], v[vgprGlobalReadOffsetA+27], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_27_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+7] offset:1904 // lwoA_0_0_28_0 = (0*LSCA)*(MT0I+PAD) + (28*LSPA) = 1904 sync LDS0 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LA+7], v[vgprGlobalReadOffsetA+28], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_28_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+23] offset:1968 // lwoA_0_0_29_0 = (0*LSCA)*(MT0I+PAD) + (29*LSPA) = 1968 sync LDS0 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LA+23], v[vgprGlobalReadOffsetA+29], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_29_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+39] offset:2032 // lwoA_0_0_30_0 = (0*LSCA)*(MT0I+PAD) + (30*LSPA) = 2032 sync LDS0 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LA+39], v[vgprGlobalReadOffsetA+30], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_30_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+55] offset:2096 // lwoA_0_0_31_0 = (0*LSCA)*(MT0I+PAD) + (31*LSPA) = 2096 sync LDS0 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LA+55], v[vgprGlobalReadOffsetA+31], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_31_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0 <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+0-256] offset:0 // lwoB_0_0_0_0 = (0*LSCB) + (0*LSPB)(*MT1J+PAD) = 0 sync LDS0 <This is 144-cycle>
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LB+0-256], v[vgprGlobalReadOffsetB+0], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_0_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0 <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+32-256] offset:64 // lwoB_0_0_1_0 = (0*LSCB) + (1*LSPB)(*MT1J+PAD) = 64 sync LDS0 <This is 144-cycle>
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LB+32-256], v[vgprGlobalReadOffsetB+1], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_1_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0 <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+64-256] offset:128 // lwoB_0_0_2_0 = (0*LSCB) + (2*LSPB)(*MT1J+PAD) = 128 sync LDS0 <This is 144-cycle>
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LB+64-256], v[vgprGlobalReadOffsetB+2], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_2_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0 <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+96-256] offset:192 // lwoB_0_0_3_0 = (0*LSCB) + (3*LSPB)(*MT1J+PAD) = 192 sync LDS0 <This is 144-cycle>
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LB+96-256], v[vgprGlobalReadOffsetB+3], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_3_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0 <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+1-256] offset:256 // lwoB_0_0_4_0 = (0*LSCB) + (4*LSPB)(*MT1J+PAD) = 256 sync LDS0 <This is 144-cycle>
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LB+1-256], v[vgprGlobalReadOffsetB+4], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_4_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0 <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+33-256] offset:320 // lwoB_0_0_5_0 = (0*LSCB) + (5*LSPB)(*MT1J+PAD) = 320 sync LDS0 <This is 144-cycle>
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LB+33-256], v[vgprGlobalReadOffsetB+5], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_5_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0 <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+65-256] offset:384 // lwoB_0_0_6_0 = (0*LSCB) + (6*LSPB)(*MT1J+PAD) = 384 sync LDS0 <This is 144-cycle>
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LB+65-256], v[vgprGlobalReadOffsetB+6], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_6_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0 <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+97-256] offset:448 // lwoB_0_0_7_0 = (0*LSCB) + (7*LSPB)(*MT1J+PAD) = 448 sync LDS0 <This is 144-cycle>
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LB+97-256], v[vgprGlobalReadOffsetB+7], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_7_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0 <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+2-256] offset:512 // lwoB_0_0_8_0 = (0*LSCB) + (8*LSPB)(*MT1J+PAD) = 512 sync LDS0 <This is 144-cycle>
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LB+2-256], v[vgprGlobalReadOffsetB+8], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_8_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0 <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+34-256] offset:576 // lwoB_0_0_9_0 = (0*LSCB) + (9*LSPB)(*MT1J+PAD) = 576 sync LDS0 <This is 144-cycle>
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LB+34-256], v[vgprGlobalReadOffsetB+9], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_9_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0 <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+66-256] offset:640 // lwoB_0_0_10_0 = (0*LSCB) + (10*LSPB)(*MT1J+PAD) = 640 sync LDS0 <This is 144-cycle>
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LB+66-256], v[vgprGlobalReadOffsetB+10], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_10_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0 <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+98-256] offset:704 // lwoB_0_0_11_0 = (0*LSCB) + (11*LSPB)(*MT1J+PAD) = 704 sync LDS0 <This is 144-cycle>
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LB+98-256], v[vgprGlobalReadOffsetB+11], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_11_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0 <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+3-256] offset:768 // lwoB_0_0_12_0 = (0*LSCB) + (12*LSPB)(*MT1J+PAD) = 768 sync LDS0 <This is 144-cycle>
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LB+3-256], v[vgprGlobalReadOffsetB+12], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_12_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0 <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+35-256] offset:832 // lwoB_0_0_13_0 = (0*LSCB) + (13*LSPB)(*MT1J+PAD) = 832 sync LDS0 <This is 144-cycle>
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LB+35-256], v[vgprGlobalReadOffsetB+13], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_13_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0 <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+67-256] offset:896 // lwoB_0_0_14_0 = (0*LSCB) + (14*LSPB)(*MT1J+PAD) = 896 sync LDS0 <This is 144-cycle>
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LB+67-256], v[vgprGlobalReadOffsetB+14], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_14_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0 <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+99-256] offset:960 // lwoB_0_0_15_0 = (0*LSCB) + (15*LSPB)(*MT1J+PAD) = 960 sync LDS0 <This is 144-cycle>
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LB+99-256], v[vgprGlobalReadOffsetB+15], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_15_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0 <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+4-256] offset:1056 // lwoB_0_0_16_0 = (0*LSCB) + (16*LSPB)(*MT1J+PAD) = 1056 sync LDS0 <This is 144-cycle>
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LB+4-256], v[vgprGlobalReadOffsetB+16], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_16_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0 <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+36-256] offset:1120 // lwoB_0_0_17_0 = (0*LSCB) + (17*LSPB)(*MT1J+PAD) = 1120 sync LDS0 <This is 144-cycle>
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LB+36-256], v[vgprGlobalReadOffsetB+17], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_17_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0 <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+68-256] offset:1184 // lwoB_0_0_18_0 = (0*LSCB) + (18*LSPB)(*MT1J+PAD) = 1184 sync LDS0 <This is 144-cycle>
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LB+68-256], v[vgprGlobalReadOffsetB+18], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_18_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0 <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+100-256] offset:1248 // lwoB_0_0_19_0 = (0*LSCB) + (19*LSPB)(*MT1J+PAD) = 1248 sync LDS0 <This is 144-cycle>
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LB+100-256], v[vgprGlobalReadOffsetB+19], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_19_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0 <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+5-256] offset:1312 // lwoB_0_0_20_0 = (0*LSCB) + (20*LSPB)(*MT1J+PAD) = 1312 sync LDS0 <This is 144-cycle>
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LB+5-256], v[vgprGlobalReadOffsetB+20], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_20_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0 <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+37-256] offset:1376 // lwoB_0_0_21_0 = (0*LSCB) + (21*LSPB)(*MT1J+PAD) = 1376 sync LDS0 <This is 144-cycle>
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LB+37-256], v[vgprGlobalReadOffsetB+21], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_21_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0 <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+69-256] offset:1440 // lwoB_0_0_22_0 = (0*LSCB) + (22*LSPB)(*MT1J+PAD) = 1440 sync LDS0 <This is 144-cycle>
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LB+69-256], v[vgprGlobalReadOffsetB+22], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_22_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0 <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+101-256] offset:1504 // lwoB_0_0_23_0 = (0*LSCB) + (23*LSPB)(*MT1J+PAD) = 1504 sync LDS0 <This is 144-cycle>
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LB+101-256], v[vgprGlobalReadOffsetB+23], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_23_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0 <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+6-256] offset:1568 // lwoB_0_0_24_0 = (0*LSCB) + (24*LSPB)(*MT1J+PAD) = 1568 sync LDS0 <This is 144-cycle>
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LB+6-256], v[vgprGlobalReadOffsetB+24], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_24_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0 <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+38-256] offset:1632 // lwoB_0_0_25_0 = (0*LSCB) + (25*LSPB)(*MT1J+PAD) = 1632 sync LDS0 <This is 144-cycle>
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LB+38-256], v[vgprGlobalReadOffsetB+25], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_25_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0 <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+70-256] offset:1696 // lwoB_0_0_26_0 = (0*LSCB) + (26*LSPB)(*MT1J+PAD) = 1696 sync LDS0 <This is 144-cycle>
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LB+70-256], v[vgprGlobalReadOffsetB+26], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_26_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0 <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+102-256] offset:1760 // lwoB_0_0_27_0 = (0*LSCB) + (27*LSPB)(*MT1J+PAD) = 1760 sync LDS0 <This is 144-cycle>
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LB+102-256], v[vgprGlobalReadOffsetB+27], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_27_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0 <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+7-256] offset:1824 // lwoB_0_0_28_0 = (0*LSCB) + (28*LSPB)(*MT1J+PAD) = 1824 sync LDS0 <This is 144-cycle>
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LB+7-256], v[vgprGlobalReadOffsetB+28], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_28_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0 <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+39-256] offset:1888 // lwoB_0_0_29_0 = (0*LSCB) + (29*LSPB)(*MT1J+PAD) = 1888 sync LDS0 <This is 144-cycle>
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LB+39-256], v[vgprGlobalReadOffsetB+29], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_29_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0 <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+71-256] offset:1952 // lwoB_0_0_30_0 = (0*LSCB) + (30*LSPB)(*MT1J+PAD) = 1952 sync LDS0 <This is 144-cycle>
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LB+71-256], v[vgprGlobalReadOffsetB+30], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_30_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0 <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+103-256] offset:2016 // lwoB_0_0_31_0 = (0*LSCB) + (31*LSPB)(*MT1J+PAD) = 2016 sync LDS0 <This is 144-cycle>
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LB+103-256], v[vgprGlobalReadOffsetB+31], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_31_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0 <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+8-256] offset:2112 // lwoB_0_0_32_0 = (0*LSCB) + (32*LSPB)(*MT1J+PAD) = 2112 sync LDS0 <This is 144-cycle>
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LB+8-256], v[vgprGlobalReadOffsetB+32], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_32_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0 <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+40-256] offset:2176 // lwoB_0_0_33_0 = (0*LSCB) + (33*LSPB)(*MT1J+PAD) = 2176 sync LDS0 <This is 144-cycle>
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LB+40-256], v[vgprGlobalReadOffsetB+33], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_33_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0 <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+72-256] offset:2240 // lwoB_0_0_34_0 = (0*LSCB) + (34*LSPB)(*MT1J+PAD) = 2240 sync LDS0 <This is 144-cycle>
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LB+72-256], v[vgprGlobalReadOffsetB+34], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_34_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0 <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+104-256] offset:2304 // lwoB_0_0_35_0 = (0*LSCB) + (35*LSPB)(*MT1J+PAD) = 2304 sync LDS0 <This is 144-cycle>
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LB+104-256], v[vgprGlobalReadOffsetB+35], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_35_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0 <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+9-256] offset:2368 // lwoB_0_0_36_0 = (0*LSCB) + (36*LSPB)(*MT1J+PAD) = 2368 sync LDS0 <This is 144-cycle>
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LB+9-256], v[vgprGlobalReadOffsetB+36], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_36_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0 <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+41-256] offset:2432 // lwoB_0_0_37_0 = (0*LSCB) + (37*LSPB)(*MT1J+PAD) = 2432 sync LDS0 <This is 144-cycle>
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LB+41-256], v[vgprGlobalReadOffsetB+37], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_37_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0 <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+73-256] offset:2496 // lwoB_0_0_38_0 = (0*LSCB) + (38*LSPB)(*MT1J+PAD) = 2496 sync LDS0 <This is 144-cycle>
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LB+73-256], v[vgprGlobalReadOffsetB+38], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_38_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0 <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+105-256] offset:2560 // lwoB_0_0_39_0 = (0*LSCB) + (39*LSPB)(*MT1J+PAD) = 2560 sync LDS0 <This is 144-cycle>
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LB+105-256], v[vgprGlobalReadOffsetB+39], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_39_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0 <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+10-256] offset:2624 // lwoB_0_0_40_0 = (0*LSCB) + (40*LSPB)(*MT1J+PAD) = 2624 sync LDS0 <This is 144-cycle>
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LB+10-256], v[vgprGlobalReadOffsetB+40], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_40_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0 <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+42-256] offset:2688 // lwoB_0_0_41_0 = (0*LSCB) + (41*LSPB)(*MT1J+PAD) = 2688 sync LDS0 <This is 144-cycle>
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LB+42-256], v[vgprGlobalReadOffsetB+41], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_41_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0 <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+74-256] offset:2752 // lwoB_0_0_42_0 = (0*LSCB) + (42*LSPB)(*MT1J+PAD) = 2752 sync LDS0 <This is 144-cycle>
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LB+74-256], v[vgprGlobalReadOffsetB+42], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_42_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0 <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+106-256] offset:2816 // lwoB_0_0_43_0 = (0*LSCB) + (43*LSPB)(*MT1J+PAD) = 2816 sync LDS0 <This is 144-cycle>
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LB+106-256], v[vgprGlobalReadOffsetB+43], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_43_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0 <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+11-256] offset:2880 // lwoB_0_0_44_0 = (0*LSCB) + (44*LSPB)(*MT1J+PAD) = 2880 sync LDS0 <This is 144-cycle>
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LB+11-256], v[vgprGlobalReadOffsetB+44], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_44_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0 <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+43-256] offset:2944 // lwoB_0_0_45_0 = (0*LSCB) + (45*LSPB)(*MT1J+PAD) = 2944 sync LDS0 <This is 144-cycle>
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LB+43-256], v[vgprGlobalReadOffsetB+45], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_45_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0 <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+75-256] offset:3008 // lwoB_0_0_46_0 = (0*LSCB) + (46*LSPB)(*MT1J+PAD) = 3008 sync LDS0 <This is 144-cycle>
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LB+75-256], v[vgprGlobalReadOffsetB+46], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_46_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0 <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+107-256] offset:3072 // lwoB_0_0_47_0 = (0*LSCB) + (47*LSPB)(*MT1J+PAD) = 3072 sync LDS0 <This is 144-cycle>
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LB+107-256], v[vgprGlobalReadOffsetB+47], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_47_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0 <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+12-256] offset:3168 // lwoB_0_0_48_0 = (0*LSCB) + (48*LSPB)(*MT1J+PAD) = 3168 sync LDS0 <This is 144-cycle>
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LB+12-256], v[vgprGlobalReadOffsetB+48], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_48_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0 <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+44-256] offset:3232 // lwoB_0_0_49_0 = (0*LSCB) + (49*LSPB)(*MT1J+PAD) = 3232 sync LDS0 <This is 144-cycle>
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LB+44-256], v[vgprGlobalReadOffsetB+49], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_49_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0 <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+76-256] offset:3296 // lwoB_0_0_50_0 = (0*LSCB) + (50*LSPB)(*MT1J+PAD) = 3296 sync LDS0 <This is 144-cycle>
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LB+76-256], v[vgprGlobalReadOffsetB+50], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_50_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0 <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+108-256] offset:3360 // lwoB_0_0_51_0 = (0*LSCB) + (51*LSPB)(*MT1J+PAD) = 3360 sync LDS0 <This is 144-cycle>
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LB+108-256], v[vgprGlobalReadOffsetB+51], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_51_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0 <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+13-256] offset:3424 // lwoB_0_0_52_0 = (0*LSCB) + (52*LSPB)(*MT1J+PAD) = 3424 sync LDS0 <This is 144-cycle>
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LB+13-256], v[vgprGlobalReadOffsetB+52], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_52_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0 <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+45-256] offset:3488 // lwoB_0_0_53_0 = (0*LSCB) + (53*LSPB)(*MT1J+PAD) = 3488 sync LDS0 <This is 144-cycle>
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LB+45-256], v[vgprGlobalReadOffsetB+53], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_53_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0 <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+77-256] offset:3552 // lwoB_0_0_54_0 = (0*LSCB) + (54*LSPB)(*MT1J+PAD) = 3552 sync LDS0 <This is 144-cycle>
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LB+77-256], v[vgprGlobalReadOffsetB+54], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_54_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0 <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+109-256] offset:3616 // lwoB_0_0_55_0 = (0*LSCB) + (55*LSPB)(*MT1J+PAD) = 3616 sync LDS0 <This is 144-cycle>
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LB+109-256], v[vgprGlobalReadOffsetB+55], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_55_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0 <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+14-256] offset:3680 // lwoB_0_0_56_0 = (0*LSCB) + (56*LSPB)(*MT1J+PAD) = 3680 sync LDS0 <This is 144-cycle>
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LB+14-256], v[vgprGlobalReadOffsetB+56], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_56_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0 <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+46-256] offset:3744 // lwoB_0_0_57_0 = (0*LSCB) + (57*LSPB)(*MT1J+PAD) = 3744 sync LDS0 <This is 144-cycle>
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LB+46-256], v[vgprGlobalReadOffsetB+57], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_57_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0 <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+78-256] offset:3808 // lwoB_0_0_58_0 = (0*LSCB) + (58*LSPB)(*MT1J+PAD) = 3808 sync LDS0 <This is 144-cycle>
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LB+78-256], v[vgprGlobalReadOffsetB+58], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_58_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0 <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+110-256] offset:3872 // lwoB_0_0_59_0 = (0*LSCB) + (59*LSPB)(*MT1J+PAD) = 3872 sync LDS0 <This is 144-cycle>
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LB+110-256], v[vgprGlobalReadOffsetB+59], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_59_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0 <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+15-256] offset:3936 // lwoB_0_0_60_0 = (0*LSCB) + (60*LSPB)(*MT1J+PAD) = 3936 sync LDS0 <This is 144-cycle>
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LB+15-256], v[vgprGlobalReadOffsetB+60], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_60_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0 <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+47-256] offset:4000 // lwoB_0_0_61_0 = (0*LSCB) + (61*LSPB)(*MT1J+PAD) = 4000 sync LDS0 <This is 144-cycle>
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LB+47-256], v[vgprGlobalReadOffsetB+61], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_61_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0 <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+79-256] offset:4064 // lwoB_0_0_62_0 = (0*LSCB) + (62*LSPB)(*MT1J+PAD) = 4064 sync LDS0 <This is 144-cycle>
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LB+79-256], v[vgprGlobalReadOffsetB+62], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_62_0 <This is 144-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local <This is 144-cycle>
s_set_vgpr_msb 16388                               // src0: 0, src1: 1, src2: 0, dst: 0 <This is 144-cycle>
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+111-256] offset:4128 // lwoB_0_0_63_0 = (0*LSCB) + (63*LSPB)(*MT1J+PAD) = 4128 sync LDS0 <This is 144-cycle>
s_set_vgpr_msb 1088                                // src0: 0, src1: 0, src2: 0, dst: 1 <This is 144-cycle>
s_wait_alu depctr_vm_vsrc(0)                       // <This is 144-cycle>
buffer_load_d16_u8 v[vgprG2LB+111-256], v[vgprGlobalReadOffsetB+63], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_63_0 <This is 144-cycle>

/* local write swap offsets a */

/* local write swap offsets b */

/* local read swap offsets a */

/* local read swap offsets b */

/* local read init pointers a */

/* localReadInitPointers */

/* local read init pointers b */

/* localReadInitPointers */
s_set_vgpr_msb 16384                               // src0: 0, src1: 0, src2: 0, dst: 0 <This is 144-cycle>
v_wmma_f32_16x16x64_fp8_fp8 v[vgprValuC+24:vgprValuC+24+7], v[vgprValuB_X0_I0+8+0+0:vgprValuB_X0_I0+8+0+0+7], v[vgprValuA_X0_I0+8+0+0:vgprValuA_X0_I0+8+0+0+7], v[vgprValuC+24:vgprValuC+24+7] // left value = v[24+0:31+0] <This is 148-cycle>
label_InitCIterWmma_target_0:
/* numPrefetchIter=0 */
/* dataAtIterA=0 numReadsIterA=1 skipReadsIterA=0 readsPerIterA=4 */
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
/*  grEndMfmaIndex:3, lwStartMfmaIndex:3, lwEndMfmaIndex:3  */
/*  numMfmaForLR:3, syncPlrMfmaIndex:0 , sync1LdsMfmaIndex:2 */
/*  mfmaIndex:0  */
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
s_wait_alu depctr_va_vdst(14)
ds_load_b128 v[vgprValuA_X0_I0+0:vgprValuA_X0_I0+0+3], v[vgprLocalReadAddrA+0] offset:0 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_b128 v[vgprValuA_X0_I0+4:vgprValuA_X0_I0+4+3], v[vgprLocalReadAddrA+0] offset:32 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D0+0], v[vgprLocalReadAddrB+0] offset:0 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D1+0], v[vgprLocalReadAddrB+0] offset:64 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D2+0], v[vgprLocalReadAddrB+0] offset:128 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=2 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D3+0], v[vgprLocalReadAddrB+0] offset:192 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=3 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D4+0], v[vgprLocalReadAddrB+0] offset:256 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=4 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D5+0], v[vgprLocalReadAddrB+0] offset:320 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=5 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D6+0], v[vgprLocalReadAddrB+0] offset:384 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=6 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D7+0], v[vgprLocalReadAddrB+0] offset:448 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=7 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D8+0], v[vgprLocalReadAddrB+0] offset:512 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=8 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D9+0], v[vgprLocalReadAddrB+0] offset:576 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=9 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D10+0], v[vgprLocalReadAddrB+0] offset:640 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=10 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D11+0], v[vgprLocalReadAddrB+0] offset:704 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=11 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D12+0], v[vgprLocalReadAddrB+0] offset:768 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=12 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D13+0], v[vgprLocalReadAddrB+0] offset:832 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=13 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D14+0], v[vgprLocalReadAddrB+0] offset:896 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=14 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D15+0], v[vgprLocalReadAddrB+0] offset:960 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=15 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D16+0], v[vgprLocalReadAddrB+0] offset:2112 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=16 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D17+0], v[vgprLocalReadAddrB+0] offset:2176 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=17 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D18+0], v[vgprLocalReadAddrB+0] offset:2240 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=18 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D19+0], v[vgprLocalReadAddrB+0] offset:2304 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=19 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D20+0], v[vgprLocalReadAddrB+0] offset:2368 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=20 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D21+0], v[vgprLocalReadAddrB+0] offset:2432 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=21 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D22+0], v[vgprLocalReadAddrB+0] offset:2496 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=22 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D23+0], v[vgprLocalReadAddrB+0] offset:2560 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=23 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D24+0], v[vgprLocalReadAddrB+0] offset:2624 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=24 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D25+0], v[vgprLocalReadAddrB+0] offset:2688 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=25 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D26+0], v[vgprLocalReadAddrB+0] offset:2752 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=26 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D27+0], v[vgprLocalReadAddrB+0] offset:2816 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=27 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D28+0], v[vgprLocalReadAddrB+0] offset:2880 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=28 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D29+0], v[vgprLocalReadAddrB+0] offset:2944 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=29 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D30+0], v[vgprLocalReadAddrB+0] offset:3008 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=30 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D31+0], v[vgprLocalReadAddrB+0] offset:3072 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=31 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_b128 v[vgprValuA_X0_I0+8:vgprValuA_X0_I0+8+3], v[vgprLocalReadAddrA+0] offset:64 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=1 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_b128 v[vgprValuA_X0_I0+12:vgprValuA_X0_I0+12+3], v[vgprLocalReadAddrA+0] offset:96 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=1 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS0

/* Global Read IncA */

/* global read inc A loopL */
s_cmp_eq_u32 s[sgprLoopCounterL], s[sgprStaggerUIter] // Is this the wrapIter?
s_cselect_b32 s68, s[sgprWrapUA+0], s[sgprGlobalReadIncsA+0] // incLower <- ?
s_cselect_b32 s69, s[sgprWrapUA+1], 0              // incUpper <- ?
s_add_u32 s[sgprSrdA+0], s[sgprSrdA+0], s68        // gra SRD += inc(lower)
s_addc_u32 s[sgprSrdA+1], s[sgprSrdA+1], s69       // gra SRD += inc(upper)
s_sub_u32 s[sgprShadowLimitA+0], s[sgprShadowLimitA+0], s68 // limit -= inc)
s_subb_u32 s[sgprShadowLimitA+1], s[sgprShadowLimitA+1], s69 // limit -= inc)
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
s_cselect_b32 s68, s[sgprWrapUB+0], s[sgprGlobalReadIncsB+0] // incLower <- ?
s_cselect_b32 s69, s[sgprWrapUB+1], 0              // incUpper <- ?
s_add_u32 s[sgprSrdB+0], s[sgprSrdB+0], s68        // gra SRD += inc(lower)
s_addc_u32 s[sgprSrdB+1], s[sgprSrdB+1], s69       // gra SRD += inc(upper)
s_sub_u32 s[sgprShadowLimitB+0], s[sgprShadowLimitB+0], s68 // limit -= inc)
s_subb_u32 s[sgprShadowLimitB+1], s[sgprShadowLimitB+1], s69 // limit -= inc)
s_cmp_eq_u32 s[sgprShadowLimitB+1], 0              // are we within 2^32?
s_cselect_b32 s[sgprSrdB+2], s[sgprShadowLimitB+0], BufferLimit // Move shadow to real if we are within 2^32
// Shift num records for gfx125x
s_and_b32 s8, s[sgprSrdB+2], 127
s_lshl_b32 s8, s8, 25
s_and_b32 s[sgprSrdB+1], s[sgprSrdB+1], 33554431
s_or_b32 s[sgprSrdB+1], s[sgprSrdB+1], s8
s_lshr_b32 s[sgprSrdB+2], s[sgprSrdB+2], 7
s_wait_dscnt 2                                     // Wait for dependent lr
/* pack scheduling: packAIdx:0, packBIdx:24 */
v_perm_b32 v[vgprValuB_X0_I0+0], v[vgprValuB_X0_I0_D1+0], v[vgprValuB_X0_I0_D0+0], s[sgprPackKForV0] // select K=01 for vector=0
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D3+0], v[vgprValuB_X0_I0_D2+0], s[sgprPackKForV0] // select K=23 for vector=0
v_lshl_or_b32 v[vgprValuB_X0_I0+0], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+0] // pack two half Vgpr to one Vgpr
v_perm_b32 v[vgprValuB_X0_I0+1], v[vgprValuB_X0_I0_D5+0], v[vgprValuB_X0_I0_D4+0], s[sgprPackKForV0] // select K=45 for vector=0
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D7+0], v[vgprValuB_X0_I0_D6+0], s[sgprPackKForV0] // select K=67 for vector=0
v_lshl_or_b32 v[vgprValuB_X0_I0+1], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+1] // pack two half Vgpr to one Vgpr
v_perm_b32 v[vgprValuB_X0_I0+2], v[vgprValuB_X0_I0_D9+0], v[vgprValuB_X0_I0_D8+0], s[sgprPackKForV0] // select K=89 for vector=0
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D11+0], v[vgprValuB_X0_I0_D10+0], s[sgprPackKForV0] // select K=1011 for vector=0
v_lshl_or_b32 v[vgprValuB_X0_I0+2], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+2] // pack two half Vgpr to one Vgpr
v_perm_b32 v[vgprValuB_X0_I0+3], v[vgprValuB_X0_I0_D13+0], v[vgprValuB_X0_I0_D12+0], s[sgprPackKForV0] // select K=1213 for vector=0
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D15+0], v[vgprValuB_X0_I0_D14+0], s[sgprPackKForV0] // select K=1415 for vector=0
v_lshl_or_b32 v[vgprValuB_X0_I0+3], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+3] // pack two half Vgpr to one Vgpr
v_perm_b32 v[vgprValuB_X0_I0+4], v[vgprValuB_X0_I0_D17+0], v[vgprValuB_X0_I0_D16+0], s[sgprPackKForV0] // select K=1617 for vector=0
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D19+0], v[vgprValuB_X0_I0_D18+0], s[sgprPackKForV0] // select K=1819 for vector=0
v_lshl_or_b32 v[vgprValuB_X0_I0+4], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+4] // pack two half Vgpr to one Vgpr
v_perm_b32 v[vgprValuB_X0_I0+5], v[vgprValuB_X0_I0_D21+0], v[vgprValuB_X0_I0_D20+0], s[sgprPackKForV0] // select K=2021 for vector=0
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D23+0], v[vgprValuB_X0_I0_D22+0], s[sgprPackKForV0] // select K=2223 for vector=0
v_lshl_or_b32 v[vgprValuB_X0_I0+5], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+5] // pack two half Vgpr to one Vgpr
v_perm_b32 v[vgprValuB_X0_I0+6], v[vgprValuB_X0_I0_D25+0], v[vgprValuB_X0_I0_D24+0], s[sgprPackKForV0] // select K=2425 for vector=0
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D27+0], v[vgprValuB_X0_I0_D26+0], s[sgprPackKForV0] // select K=2627 for vector=0
v_lshl_or_b32 v[vgprValuB_X0_I0+6], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+6] // pack two half Vgpr to one Vgpr
v_perm_b32 v[vgprValuB_X0_I0+7], v[vgprValuB_X0_I0_D29+0], v[vgprValuB_X0_I0_D28+0], s[sgprPackKForV0] // select K=2829 for vector=0
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D31+0], v[vgprValuB_X0_I0_D30+0], s[sgprPackKForV0] // select K=3031 for vector=0
v_lshl_or_b32 v[vgprValuB_X0_I0+7], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+7] // pack two half Vgpr to one Vgpr
v_perm_b32 v[vgprValuB_X0_I0+8], v[vgprValuB_X0_I0_D1+0], v[vgprValuB_X0_I0_D0+0], s[sgprPackKForV1] // select K=01 for vector=1
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D3+0], v[vgprValuB_X0_I0_D2+0], s[sgprPackKForV1] // select K=23 for vector=1
v_wmma_f32_16x16x64_fp8_fp8 v[vgprValuC+0:vgprValuC+0+7], v[vgprValuB_X0_I0+0+0+0:vgprValuB_X0_I0+0+0+0+7], v[vgprValuA_X0_I0+0+0+0:vgprValuA_X0_I0+0+0+0+7], v[vgprValuC+0:vgprValuC+0+7] matrix_a_reuse // left value = v[0+0:7+0]
/*  mfmaIndex:1  */
/* localReadsVacancy: latencyLeft 5 */
s_wait_dscnt 0                                     // Wait for dependent lr
/* pack scheduling: packAIdx:0, packBIdx:24 */
v_lshl_or_b32 v[vgprValuB_X0_I0+8], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+8] // pack two half Vgpr to one Vgpr
v_perm_b32 v[vgprValuB_X0_I0+9], v[vgprValuB_X0_I0_D5+0], v[vgprValuB_X0_I0_D4+0], s[sgprPackKForV1] // select K=45 for vector=1
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D7+0], v[vgprValuB_X0_I0_D6+0], s[sgprPackKForV1] // select K=67 for vector=1
v_lshl_or_b32 v[vgprValuB_X0_I0+9], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+9] // pack two half Vgpr to one Vgpr
v_perm_b32 v[vgprValuB_X0_I0+10], v[vgprValuB_X0_I0_D9+0], v[vgprValuB_X0_I0_D8+0], s[sgprPackKForV1] // select K=89 for vector=1
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D11+0], v[vgprValuB_X0_I0_D10+0], s[sgprPackKForV1] // select K=1011 for vector=1
v_lshl_or_b32 v[vgprValuB_X0_I0+10], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+10] // pack two half Vgpr to one Vgpr
v_perm_b32 v[vgprValuB_X0_I0+11], v[vgprValuB_X0_I0_D13+0], v[vgprValuB_X0_I0_D12+0], s[sgprPackKForV1] // select K=1213 for vector=1
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D15+0], v[vgprValuB_X0_I0_D14+0], s[sgprPackKForV1] // select K=1415 for vector=1
v_lshl_or_b32 v[vgprValuB_X0_I0+11], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+11] // pack two half Vgpr to one Vgpr
v_perm_b32 v[vgprValuB_X0_I0+12], v[vgprValuB_X0_I0_D17+0], v[vgprValuB_X0_I0_D16+0], s[sgprPackKForV1] // select K=1617 for vector=1
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D19+0], v[vgprValuB_X0_I0_D18+0], s[sgprPackKForV1] // select K=1819 for vector=1
v_lshl_or_b32 v[vgprValuB_X0_I0+12], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+12] // pack two half Vgpr to one Vgpr
v_perm_b32 v[vgprValuB_X0_I0+13], v[vgprValuB_X0_I0_D21+0], v[vgprValuB_X0_I0_D20+0], s[sgprPackKForV1] // select K=2021 for vector=1
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D23+0], v[vgprValuB_X0_I0_D22+0], s[sgprPackKForV1] // select K=2223 for vector=1
v_lshl_or_b32 v[vgprValuB_X0_I0+13], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+13] // pack two half Vgpr to one Vgpr
v_perm_b32 v[vgprValuB_X0_I0+14], v[vgprValuB_X0_I0_D25+0], v[vgprValuB_X0_I0_D24+0], s[sgprPackKForV1] // select K=2425 for vector=1
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D27+0], v[vgprValuB_X0_I0_D26+0], s[sgprPackKForV1] // select K=2627 for vector=1
v_lshl_or_b32 v[vgprValuB_X0_I0+14], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+14] // pack two half Vgpr to one Vgpr
v_perm_b32 v[vgprValuB_X0_I0+15], v[vgprValuB_X0_I0_D29+0], v[vgprValuB_X0_I0_D28+0], s[sgprPackKForV1] // select K=2829 for vector=1
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D31+0], v[vgprValuB_X0_I0_D30+0], s[sgprPackKForV1] // select K=3031 for vector=1
v_lshl_or_b32 v[vgprValuB_X0_I0+15], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+15] // pack two half Vgpr to one Vgpr
v_wmma_f32_16x16x64_fp8_fp8 v[vgprValuC+8:vgprValuC+8+7], v[vgprValuB_X0_I0+0+0+0:vgprValuB_X0_I0+0+0+0+7], v[vgprValuA_X0_I0+8+0+0:vgprValuA_X0_I0+8+0+0+7], v[vgprValuC+8:vgprValuC+8+7] // left value = v[8+0:15+0]
/*  mfmaIndex:2  */
/* schedule remaining localreads for one buffer scheduling */
/* localReadsVacancy: latencyLeft 5 */
/* 1 LDS buffer: read-sync-write */
s_wait_dscnt 0
s_barrier_signal -1
s_barrier_wait -1
v_wmma_f32_16x16x64_fp8_fp8 v[vgprValuC+16:vgprValuC+16+7], v[vgprValuB_X0_I0+8+0+0:vgprValuB_X0_I0+8+0+0+7], v[vgprValuA_X0_I0+0+0+0:vgprValuA_X0_I0+0+0+0+7], v[vgprValuC+16:vgprValuC+16+7] matrix_a_reuse // left value = v[16+0:23+0]
/*  mfmaIndex:3  */
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+0] offset:0 // lwoA_0_0_0_0 = (0*LSCA)*(MT0I+PAD) + (0*LSPA) = 0 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+16] offset:64 // lwoA_0_0_1_0 = (0*LSCA)*(MT0I+PAD) + (1*LSPA) = 64 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+32] offset:128 // lwoA_0_0_2_0 = (0*LSCA)*(MT0I+PAD) + (2*LSPA) = 128 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+48] offset:192 // lwoA_0_0_3_0 = (0*LSCA)*(MT0I+PAD) + (3*LSPA) = 192 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+1] offset:272 // lwoA_0_0_4_0 = (0*LSCA)*(MT0I+PAD) + (4*LSPA) = 272 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+17] offset:336 // lwoA_0_0_5_0 = (0*LSCA)*(MT0I+PAD) + (5*LSPA) = 336 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+33] offset:400 // lwoA_0_0_6_0 = (0*LSCA)*(MT0I+PAD) + (6*LSPA) = 400 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+49] offset:464 // lwoA_0_0_7_0 = (0*LSCA)*(MT0I+PAD) + (7*LSPA) = 464 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+2] offset:544 // lwoA_0_0_8_0 = (0*LSCA)*(MT0I+PAD) + (8*LSPA) = 544 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+18] offset:608 // lwoA_0_0_9_0 = (0*LSCA)*(MT0I+PAD) + (9*LSPA) = 608 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+34] offset:672 // lwoA_0_0_10_0 = (0*LSCA)*(MT0I+PAD) + (10*LSPA) = 672 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+50] offset:736 // lwoA_0_0_11_0 = (0*LSCA)*(MT0I+PAD) + (11*LSPA) = 736 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+3] offset:816 // lwoA_0_0_12_0 = (0*LSCA)*(MT0I+PAD) + (12*LSPA) = 816 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+19] offset:880 // lwoA_0_0_13_0 = (0*LSCA)*(MT0I+PAD) + (13*LSPA) = 880 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+35] offset:944 // lwoA_0_0_14_0 = (0*LSCA)*(MT0I+PAD) + (14*LSPA) = 944 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+51] offset:1008 // lwoA_0_0_15_0 = (0*LSCA)*(MT0I+PAD) + (15*LSPA) = 1008 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+4] offset:1088 // lwoA_0_0_16_0 = (0*LSCA)*(MT0I+PAD) + (16*LSPA) = 1088 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+20] offset:1152 // lwoA_0_0_17_0 = (0*LSCA)*(MT0I+PAD) + (17*LSPA) = 1152 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+36] offset:1216 // lwoA_0_0_18_0 = (0*LSCA)*(MT0I+PAD) + (18*LSPA) = 1216 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+52] offset:1280 // lwoA_0_0_19_0 = (0*LSCA)*(MT0I+PAD) + (19*LSPA) = 1280 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+5] offset:1360 // lwoA_0_0_20_0 = (0*LSCA)*(MT0I+PAD) + (20*LSPA) = 1360 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+21] offset:1424 // lwoA_0_0_21_0 = (0*LSCA)*(MT0I+PAD) + (21*LSPA) = 1424 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+37] offset:1488 // lwoA_0_0_22_0 = (0*LSCA)*(MT0I+PAD) + (22*LSPA) = 1488 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+53] offset:1552 // lwoA_0_0_23_0 = (0*LSCA)*(MT0I+PAD) + (23*LSPA) = 1552 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+6] offset:1632 // lwoA_0_0_24_0 = (0*LSCA)*(MT0I+PAD) + (24*LSPA) = 1632 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+22] offset:1696 // lwoA_0_0_25_0 = (0*LSCA)*(MT0I+PAD) + (25*LSPA) = 1696 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+38] offset:1760 // lwoA_0_0_26_0 = (0*LSCA)*(MT0I+PAD) + (26*LSPA) = 1760 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+54] offset:1824 // lwoA_0_0_27_0 = (0*LSCA)*(MT0I+PAD) + (27*LSPA) = 1824 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+7] offset:1904 // lwoA_0_0_28_0 = (0*LSCA)*(MT0I+PAD) + (28*LSPA) = 1904 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+23] offset:1968 // lwoA_0_0_29_0 = (0*LSCA)*(MT0I+PAD) + (29*LSPA) = 1968 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+39] offset:2032 // lwoA_0_0_30_0 = (0*LSCA)*(MT0I+PAD) + (30*LSPA) = 2032 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+55] offset:2096 // lwoA_0_0_31_0 = (0*LSCA)*(MT0I+PAD) + (31*LSPA) = 2096 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 63                                  // wait for global read before writing to local
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+0-256] offset:0 // lwoB_0_0_0_0 = (0*LSCB) + (0*LSPB)(*MT1J+PAD) = 0 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 62                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+32-256] offset:64 // lwoB_0_0_1_0 = (0*LSCB) + (1*LSPB)(*MT1J+PAD) = 64 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 61                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+64-256] offset:128 // lwoB_0_0_2_0 = (0*LSCB) + (2*LSPB)(*MT1J+PAD) = 128 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 60                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+96-256] offset:192 // lwoB_0_0_3_0 = (0*LSCB) + (3*LSPB)(*MT1J+PAD) = 192 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 59                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+1-256] offset:256 // lwoB_0_0_4_0 = (0*LSCB) + (4*LSPB)(*MT1J+PAD) = 256 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 58                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+33-256] offset:320 // lwoB_0_0_5_0 = (0*LSCB) + (5*LSPB)(*MT1J+PAD) = 320 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 57                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+65-256] offset:384 // lwoB_0_0_6_0 = (0*LSCB) + (6*LSPB)(*MT1J+PAD) = 384 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 56                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+97-256] offset:448 // lwoB_0_0_7_0 = (0*LSCB) + (7*LSPB)(*MT1J+PAD) = 448 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 55                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+2-256] offset:512 // lwoB_0_0_8_0 = (0*LSCB) + (8*LSPB)(*MT1J+PAD) = 512 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 54                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+34-256] offset:576 // lwoB_0_0_9_0 = (0*LSCB) + (9*LSPB)(*MT1J+PAD) = 576 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 53                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+66-256] offset:640 // lwoB_0_0_10_0 = (0*LSCB) + (10*LSPB)(*MT1J+PAD) = 640 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 52                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+98-256] offset:704 // lwoB_0_0_11_0 = (0*LSCB) + (11*LSPB)(*MT1J+PAD) = 704 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 51                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+3-256] offset:768 // lwoB_0_0_12_0 = (0*LSCB) + (12*LSPB)(*MT1J+PAD) = 768 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 50                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+35-256] offset:832 // lwoB_0_0_13_0 = (0*LSCB) + (13*LSPB)(*MT1J+PAD) = 832 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 49                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+67-256] offset:896 // lwoB_0_0_14_0 = (0*LSCB) + (14*LSPB)(*MT1J+PAD) = 896 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 48                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+99-256] offset:960 // lwoB_0_0_15_0 = (0*LSCB) + (15*LSPB)(*MT1J+PAD) = 960 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 47                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+4-256] offset:1056 // lwoB_0_0_16_0 = (0*LSCB) + (16*LSPB)(*MT1J+PAD) = 1056 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 46                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+36-256] offset:1120 // lwoB_0_0_17_0 = (0*LSCB) + (17*LSPB)(*MT1J+PAD) = 1120 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 45                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+68-256] offset:1184 // lwoB_0_0_18_0 = (0*LSCB) + (18*LSPB)(*MT1J+PAD) = 1184 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 44                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+100-256] offset:1248 // lwoB_0_0_19_0 = (0*LSCB) + (19*LSPB)(*MT1J+PAD) = 1248 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 43                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+5-256] offset:1312 // lwoB_0_0_20_0 = (0*LSCB) + (20*LSPB)(*MT1J+PAD) = 1312 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 42                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+37-256] offset:1376 // lwoB_0_0_21_0 = (0*LSCB) + (21*LSPB)(*MT1J+PAD) = 1376 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 41                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+69-256] offset:1440 // lwoB_0_0_22_0 = (0*LSCB) + (22*LSPB)(*MT1J+PAD) = 1440 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 40                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+101-256] offset:1504 // lwoB_0_0_23_0 = (0*LSCB) + (23*LSPB)(*MT1J+PAD) = 1504 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 39                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+6-256] offset:1568 // lwoB_0_0_24_0 = (0*LSCB) + (24*LSPB)(*MT1J+PAD) = 1568 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 38                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+38-256] offset:1632 // lwoB_0_0_25_0 = (0*LSCB) + (25*LSPB)(*MT1J+PAD) = 1632 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 37                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+70-256] offset:1696 // lwoB_0_0_26_0 = (0*LSCB) + (26*LSPB)(*MT1J+PAD) = 1696 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 36                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+102-256] offset:1760 // lwoB_0_0_27_0 = (0*LSCB) + (27*LSPB)(*MT1J+PAD) = 1760 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 35                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+7-256] offset:1824 // lwoB_0_0_28_0 = (0*LSCB) + (28*LSPB)(*MT1J+PAD) = 1824 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 34                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+39-256] offset:1888 // lwoB_0_0_29_0 = (0*LSCB) + (29*LSPB)(*MT1J+PAD) = 1888 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 33                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+71-256] offset:1952 // lwoB_0_0_30_0 = (0*LSCB) + (30*LSPB)(*MT1J+PAD) = 1952 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 32                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+103-256] offset:2016 // lwoB_0_0_31_0 = (0*LSCB) + (31*LSPB)(*MT1J+PAD) = 2016 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 31                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+8-256] offset:2112 // lwoB_0_0_32_0 = (0*LSCB) + (32*LSPB)(*MT1J+PAD) = 2112 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 30                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+40-256] offset:2176 // lwoB_0_0_33_0 = (0*LSCB) + (33*LSPB)(*MT1J+PAD) = 2176 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 29                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+72-256] offset:2240 // lwoB_0_0_34_0 = (0*LSCB) + (34*LSPB)(*MT1J+PAD) = 2240 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 28                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+104-256] offset:2304 // lwoB_0_0_35_0 = (0*LSCB) + (35*LSPB)(*MT1J+PAD) = 2304 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 27                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+9-256] offset:2368 // lwoB_0_0_36_0 = (0*LSCB) + (36*LSPB)(*MT1J+PAD) = 2368 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 26                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+41-256] offset:2432 // lwoB_0_0_37_0 = (0*LSCB) + (37*LSPB)(*MT1J+PAD) = 2432 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 25                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+73-256] offset:2496 // lwoB_0_0_38_0 = (0*LSCB) + (38*LSPB)(*MT1J+PAD) = 2496 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 24                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+105-256] offset:2560 // lwoB_0_0_39_0 = (0*LSCB) + (39*LSPB)(*MT1J+PAD) = 2560 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 23                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+10-256] offset:2624 // lwoB_0_0_40_0 = (0*LSCB) + (40*LSPB)(*MT1J+PAD) = 2624 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 22                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+42-256] offset:2688 // lwoB_0_0_41_0 = (0*LSCB) + (41*LSPB)(*MT1J+PAD) = 2688 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 21                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+74-256] offset:2752 // lwoB_0_0_42_0 = (0*LSCB) + (42*LSPB)(*MT1J+PAD) = 2752 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 20                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+106-256] offset:2816 // lwoB_0_0_43_0 = (0*LSCB) + (43*LSPB)(*MT1J+PAD) = 2816 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 19                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+11-256] offset:2880 // lwoB_0_0_44_0 = (0*LSCB) + (44*LSPB)(*MT1J+PAD) = 2880 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 18                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+43-256] offset:2944 // lwoB_0_0_45_0 = (0*LSCB) + (45*LSPB)(*MT1J+PAD) = 2944 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 17                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+75-256] offset:3008 // lwoB_0_0_46_0 = (0*LSCB) + (46*LSPB)(*MT1J+PAD) = 3008 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 16                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+107-256] offset:3072 // lwoB_0_0_47_0 = (0*LSCB) + (47*LSPB)(*MT1J+PAD) = 3072 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 15                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+12-256] offset:3168 // lwoB_0_0_48_0 = (0*LSCB) + (48*LSPB)(*MT1J+PAD) = 3168 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 14                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+44-256] offset:3232 // lwoB_0_0_49_0 = (0*LSCB) + (49*LSPB)(*MT1J+PAD) = 3232 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 13                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+76-256] offset:3296 // lwoB_0_0_50_0 = (0*LSCB) + (50*LSPB)(*MT1J+PAD) = 3296 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 12                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+108-256] offset:3360 // lwoB_0_0_51_0 = (0*LSCB) + (51*LSPB)(*MT1J+PAD) = 3360 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 11                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+13-256] offset:3424 // lwoB_0_0_52_0 = (0*LSCB) + (52*LSPB)(*MT1J+PAD) = 3424 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 10                                  // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+45-256] offset:3488 // lwoB_0_0_53_0 = (0*LSCB) + (53*LSPB)(*MT1J+PAD) = 3488 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 9                                   // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+77-256] offset:3552 // lwoB_0_0_54_0 = (0*LSCB) + (54*LSPB)(*MT1J+PAD) = 3552 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 8                                   // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+109-256] offset:3616 // lwoB_0_0_55_0 = (0*LSCB) + (55*LSPB)(*MT1J+PAD) = 3616 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 7                                   // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+14-256] offset:3680 // lwoB_0_0_56_0 = (0*LSCB) + (56*LSPB)(*MT1J+PAD) = 3680 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 6                                   // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+46-256] offset:3744 // lwoB_0_0_57_0 = (0*LSCB) + (57*LSPB)(*MT1J+PAD) = 3744 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 5                                   // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+78-256] offset:3808 // lwoB_0_0_58_0 = (0*LSCB) + (58*LSPB)(*MT1J+PAD) = 3808 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 4                                   // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+110-256] offset:3872 // lwoB_0_0_59_0 = (0*LSCB) + (59*LSPB)(*MT1J+PAD) = 3872 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 3                                   // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+15-256] offset:3936 // lwoB_0_0_60_0 = (0*LSCB) + (60*LSPB)(*MT1J+PAD) = 3936 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 2                                   // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+47-256] offset:4000 // lwoB_0_0_61_0 = (0*LSCB) + (61*LSPB)(*MT1J+PAD) = 4000 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 1                                   // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+79-256] offset:4064 // lwoB_0_0_62_0 = (0*LSCB) + (62*LSPB)(*MT1J+PAD) = 4064 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 0                                   // wait for global read before writing to local
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+111-256] offset:4128 // lwoB_0_0_63_0 = (0*LSCB) + (63*LSPB)(*MT1J+PAD) = 4128 sync LDS0

/* local write swap offsets a */

/* local write swap offsets b */

/* local read swap offsets a */

/* local read swap offsets b */

/* local read init pointers a */

/* localReadInitPointers */

/* local read init pointers b */

/* localReadInitPointers */
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_wmma_f32_16x16x64_fp8_fp8 v[vgprValuC+24:vgprValuC+24+7], v[vgprValuB_X0_I0+8+0+0:vgprValuB_X0_I0+8+0+0+7], v[vgprValuA_X0_I0+8+0+0:vgprValuA_X0_I0+8+0+0+7], v[vgprValuC+24:vgprValuC+24+7] // left value = v[24+0:31+0]
/* numPrefetchIter=0 */
/* dataAtIterA=0 numReadsIterA=1 skipReadsIterA=0 readsPerIterA=4 */
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
s_and_b32 s68, 31, s[sgprSizeI]                    // s68 = s[sgprSizeI] % 32
s_add_u32 s69, -0x1, s[sgprNumWorkGroups0]
s_cmp_ge_u32 s[sgprWorkGroup0], s69                // wg0 >= nwg0-1 ?
s_cselect_b32 s68, s68, 0                          // set rem
s_mov_b32 s8, 0
s_cmp_gt_u32 s68, s8                               // rem > 0
s_cbranch_scc1 label_OptNLL_End                    // jump if edges required

/* Edge/NonEdge store path check (N (isSize1)): Size % 64 > 0 -> Edge store; else -> NonEdge store */
s_and_b32 s68, 63, s[sgprSizeJ]                    // s68 = s[sgprSizeJ] % 64
s_add_u32 s69, -0x1, s[sgprNumWorkGroups1]
s_cmp_ge_u32 s[sgprWorkGroup1], s69                // wg1 >= nwg1-1
s_cselect_b32 s68, s68, 0                          // set rem
s_mov_b32 s8, 0
s_cmp_gt_u32 s68, s8                               // rem > 0
s_cbranch_scc1 label_OptNLL_End                    // jump if edges required

s_and_b32 s69, 63, s[sgprSizesSum+0]               // s69 = s[sgprSizesSum+0] % 64
s_cmp_eq_u32 s69, 0                                // numIterL == 0
s_cbranch_scc0 label_OptNLL_End                    // skip if tail loop required
s_wait_dscnt 0                                     // 4wait for local write
// Skip force waitcnt0
s_barrier_signal -1
s_barrier_wait -1                                  // wait for local write done, sync

/* iter 0 (last unrolled loop) */
/*  grEndMfmaIndex:0, lwStartMfmaIndex:3, lwEndMfmaIndex:3  */
/*  numMfmaForLR:3, syncPlrMfmaIndex:0 , sync1LdsMfmaIndex:2 */
/*  mfmaIndex:0  */
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
s_wait_alu depctr_va_vdst(14)
ds_load_b128 v[vgprValuA_X0_I0+0:vgprValuA_X0_I0+0+3], v[vgprLocalReadAddrA+0] offset:0 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_b128 v[vgprValuA_X0_I0+4:vgprValuA_X0_I0+4+3], v[vgprLocalReadAddrA+0] offset:32 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D0+0], v[vgprLocalReadAddrB+0] offset:0 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D1+0], v[vgprLocalReadAddrB+0] offset:64 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D2+0], v[vgprLocalReadAddrB+0] offset:128 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=2 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D3+0], v[vgprLocalReadAddrB+0] offset:192 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=3 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D4+0], v[vgprLocalReadAddrB+0] offset:256 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=4 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D5+0], v[vgprLocalReadAddrB+0] offset:320 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=5 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D6+0], v[vgprLocalReadAddrB+0] offset:384 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=6 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D7+0], v[vgprLocalReadAddrB+0] offset:448 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=7 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D8+0], v[vgprLocalReadAddrB+0] offset:512 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=8 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D9+0], v[vgprLocalReadAddrB+0] offset:576 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=9 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D10+0], v[vgprLocalReadAddrB+0] offset:640 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=10 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D11+0], v[vgprLocalReadAddrB+0] offset:704 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=11 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D12+0], v[vgprLocalReadAddrB+0] offset:768 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=12 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D13+0], v[vgprLocalReadAddrB+0] offset:832 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=13 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D14+0], v[vgprLocalReadAddrB+0] offset:896 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=14 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D15+0], v[vgprLocalReadAddrB+0] offset:960 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=15 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D16+0], v[vgprLocalReadAddrB+0] offset:2112 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=16 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D17+0], v[vgprLocalReadAddrB+0] offset:2176 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=17 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D18+0], v[vgprLocalReadAddrB+0] offset:2240 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=18 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D19+0], v[vgprLocalReadAddrB+0] offset:2304 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=19 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D20+0], v[vgprLocalReadAddrB+0] offset:2368 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=20 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D21+0], v[vgprLocalReadAddrB+0] offset:2432 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=21 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D22+0], v[vgprLocalReadAddrB+0] offset:2496 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=22 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D23+0], v[vgprLocalReadAddrB+0] offset:2560 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=23 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D24+0], v[vgprLocalReadAddrB+0] offset:2624 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=24 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D25+0], v[vgprLocalReadAddrB+0] offset:2688 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=25 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D26+0], v[vgprLocalReadAddrB+0] offset:2752 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=26 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D27+0], v[vgprLocalReadAddrB+0] offset:2816 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=27 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D28+0], v[vgprLocalReadAddrB+0] offset:2880 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=28 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D29+0], v[vgprLocalReadAddrB+0] offset:2944 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=29 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D30+0], v[vgprLocalReadAddrB+0] offset:3008 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=30 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D31+0], v[vgprLocalReadAddrB+0] offset:3072 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=31 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_b128 v[vgprValuA_X0_I0+8:vgprValuA_X0_I0+8+3], v[vgprLocalReadAddrA+0] offset:64 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=1 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_b128 v[vgprValuA_X0_I0+12:vgprValuA_X0_I0+12+3], v[vgprLocalReadAddrA+0] offset:96 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=1 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS0
s_wait_dscnt 2                                     // Wait for dependent lr
/* pack scheduling: packAIdx:0, packBIdx:24 */
v_perm_b32 v[vgprValuB_X0_I0+0], v[vgprValuB_X0_I0_D1+0], v[vgprValuB_X0_I0_D0+0], s[sgprPackKForV0] // select K=01 for vector=0
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D3+0], v[vgprValuB_X0_I0_D2+0], s[sgprPackKForV0] // select K=23 for vector=0
v_lshl_or_b32 v[vgprValuB_X0_I0+0], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+0] // pack two half Vgpr to one Vgpr
v_perm_b32 v[vgprValuB_X0_I0+1], v[vgprValuB_X0_I0_D5+0], v[vgprValuB_X0_I0_D4+0], s[sgprPackKForV0] // select K=45 for vector=0
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D7+0], v[vgprValuB_X0_I0_D6+0], s[sgprPackKForV0] // select K=67 for vector=0
v_lshl_or_b32 v[vgprValuB_X0_I0+1], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+1] // pack two half Vgpr to one Vgpr
v_perm_b32 v[vgprValuB_X0_I0+2], v[vgprValuB_X0_I0_D9+0], v[vgprValuB_X0_I0_D8+0], s[sgprPackKForV0] // select K=89 for vector=0
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D11+0], v[vgprValuB_X0_I0_D10+0], s[sgprPackKForV0] // select K=1011 for vector=0
v_lshl_or_b32 v[vgprValuB_X0_I0+2], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+2] // pack two half Vgpr to one Vgpr
v_perm_b32 v[vgprValuB_X0_I0+3], v[vgprValuB_X0_I0_D13+0], v[vgprValuB_X0_I0_D12+0], s[sgprPackKForV0] // select K=1213 for vector=0
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D15+0], v[vgprValuB_X0_I0_D14+0], s[sgprPackKForV0] // select K=1415 for vector=0
v_lshl_or_b32 v[vgprValuB_X0_I0+3], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+3] // pack two half Vgpr to one Vgpr
v_perm_b32 v[vgprValuB_X0_I0+4], v[vgprValuB_X0_I0_D17+0], v[vgprValuB_X0_I0_D16+0], s[sgprPackKForV0] // select K=1617 for vector=0
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D19+0], v[vgprValuB_X0_I0_D18+0], s[sgprPackKForV0] // select K=1819 for vector=0
v_lshl_or_b32 v[vgprValuB_X0_I0+4], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+4] // pack two half Vgpr to one Vgpr
v_perm_b32 v[vgprValuB_X0_I0+5], v[vgprValuB_X0_I0_D21+0], v[vgprValuB_X0_I0_D20+0], s[sgprPackKForV0] // select K=2021 for vector=0
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D23+0], v[vgprValuB_X0_I0_D22+0], s[sgprPackKForV0] // select K=2223 for vector=0
v_lshl_or_b32 v[vgprValuB_X0_I0+5], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+5] // pack two half Vgpr to one Vgpr
v_perm_b32 v[vgprValuB_X0_I0+6], v[vgprValuB_X0_I0_D25+0], v[vgprValuB_X0_I0_D24+0], s[sgprPackKForV0] // select K=2425 for vector=0
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D27+0], v[vgprValuB_X0_I0_D26+0], s[sgprPackKForV0] // select K=2627 for vector=0
v_lshl_or_b32 v[vgprValuB_X0_I0+6], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+6] // pack two half Vgpr to one Vgpr
v_perm_b32 v[vgprValuB_X0_I0+7], v[vgprValuB_X0_I0_D29+0], v[vgprValuB_X0_I0_D28+0], s[sgprPackKForV0] // select K=2829 for vector=0
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D31+0], v[vgprValuB_X0_I0_D30+0], s[sgprPackKForV0] // select K=3031 for vector=0
v_lshl_or_b32 v[vgprValuB_X0_I0+7], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+7] // pack two half Vgpr to one Vgpr
v_perm_b32 v[vgprValuB_X0_I0+8], v[vgprValuB_X0_I0_D1+0], v[vgprValuB_X0_I0_D0+0], s[sgprPackKForV1] // select K=01 for vector=1
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D3+0], v[vgprValuB_X0_I0_D2+0], s[sgprPackKForV1] // select K=23 for vector=1
v_wmma_f32_16x16x64_fp8_fp8 v[vgprValuC+0:vgprValuC+0+7], v[vgprValuB_X0_I0+0+0+0:vgprValuB_X0_I0+0+0+0+7], v[vgprValuA_X0_I0+0+0+0:vgprValuA_X0_I0+0+0+0+7], v[vgprValuC+0:vgprValuC+0+7] matrix_a_reuse // left value = v[0+0:7+0]
/*  mfmaIndex:1  */
/* localReadsVacancy: latencyLeft 5 */
s_wait_dscnt 0                                     // Wait for dependent lr
/* pack scheduling: packAIdx:0, packBIdx:24 */
v_lshl_or_b32 v[vgprValuB_X0_I0+8], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+8] // pack two half Vgpr to one Vgpr
v_perm_b32 v[vgprValuB_X0_I0+9], v[vgprValuB_X0_I0_D5+0], v[vgprValuB_X0_I0_D4+0], s[sgprPackKForV1] // select K=45 for vector=1
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D7+0], v[vgprValuB_X0_I0_D6+0], s[sgprPackKForV1] // select K=67 for vector=1
v_lshl_or_b32 v[vgprValuB_X0_I0+9], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+9] // pack two half Vgpr to one Vgpr
v_perm_b32 v[vgprValuB_X0_I0+10], v[vgprValuB_X0_I0_D9+0], v[vgprValuB_X0_I0_D8+0], s[sgprPackKForV1] // select K=89 for vector=1
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D11+0], v[vgprValuB_X0_I0_D10+0], s[sgprPackKForV1] // select K=1011 for vector=1
v_lshl_or_b32 v[vgprValuB_X0_I0+10], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+10] // pack two half Vgpr to one Vgpr
v_perm_b32 v[vgprValuB_X0_I0+11], v[vgprValuB_X0_I0_D13+0], v[vgprValuB_X0_I0_D12+0], s[sgprPackKForV1] // select K=1213 for vector=1
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D15+0], v[vgprValuB_X0_I0_D14+0], s[sgprPackKForV1] // select K=1415 for vector=1
v_lshl_or_b32 v[vgprValuB_X0_I0+11], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+11] // pack two half Vgpr to one Vgpr
v_perm_b32 v[vgprValuB_X0_I0+12], v[vgprValuB_X0_I0_D17+0], v[vgprValuB_X0_I0_D16+0], s[sgprPackKForV1] // select K=1617 for vector=1
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D19+0], v[vgprValuB_X0_I0_D18+0], s[sgprPackKForV1] // select K=1819 for vector=1
v_lshl_or_b32 v[vgprValuB_X0_I0+12], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+12] // pack two half Vgpr to one Vgpr
v_perm_b32 v[vgprValuB_X0_I0+13], v[vgprValuB_X0_I0_D21+0], v[vgprValuB_X0_I0_D20+0], s[sgprPackKForV1] // select K=2021 for vector=1
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D23+0], v[vgprValuB_X0_I0_D22+0], s[sgprPackKForV1] // select K=2223 for vector=1
v_lshl_or_b32 v[vgprValuB_X0_I0+13], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+13] // pack two half Vgpr to one Vgpr
v_perm_b32 v[vgprValuB_X0_I0+14], v[vgprValuB_X0_I0_D25+0], v[vgprValuB_X0_I0_D24+0], s[sgprPackKForV1] // select K=2425 for vector=1
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D27+0], v[vgprValuB_X0_I0_D26+0], s[sgprPackKForV1] // select K=2627 for vector=1
v_lshl_or_b32 v[vgprValuB_X0_I0+14], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+14] // pack two half Vgpr to one Vgpr
v_perm_b32 v[vgprValuB_X0_I0+15], v[vgprValuB_X0_I0_D29+0], v[vgprValuB_X0_I0_D28+0], s[sgprPackKForV1] // select K=2829 for vector=1
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D31+0], v[vgprValuB_X0_I0_D30+0], s[sgprPackKForV1] // select K=3031 for vector=1
v_lshl_or_b32 v[vgprValuB_X0_I0+15], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+15] // pack two half Vgpr to one Vgpr
v_wmma_f32_16x16x64_fp8_fp8 v[vgprValuC+8:vgprValuC+8+7], v[vgprValuB_X0_I0+0+0+0:vgprValuB_X0_I0+0+0+0+7], v[vgprValuA_X0_I0+8+0+0:vgprValuA_X0_I0+8+0+0+7], v[vgprValuC+8:vgprValuC+8+7] // left value = v[8+0:15+0]
/*  mfmaIndex:2  */
/* schedule remaining localreads for one buffer scheduling */
/* localReadsVacancy: latencyLeft 5 */
/* 1 LDS buffer: read-sync-write */
s_wait_dscnt 0
s_barrier_signal -1
s_barrier_wait -1
v_wmma_f32_16x16x64_fp8_fp8 v[vgprValuC+16:vgprValuC+16+7], v[vgprValuB_X0_I0+8+0+0:vgprValuB_X0_I0+8+0+0+7], v[vgprValuA_X0_I0+0+0+0:vgprValuA_X0_I0+0+0+0+7], v[vgprValuC+16:vgprValuC+16+7] matrix_a_reuse // left value = v[16+0:23+0]
/*  mfmaIndex:3  */
v_wmma_f32_16x16x64_fp8_fp8 v[vgprValuC+24:vgprValuC+24+7], v[vgprValuB_X0_I0+8+0+0:vgprValuB_X0_I0+8+0+0+7], v[vgprValuA_X0_I0+8+0+0:vgprValuA_X0_I0+8+0+0+7], v[vgprValuC+24:vgprValuC+24+7] // left value = v[24+0:31+0]
/* numPrefetchIter=0 */
/* dataAtIterA=0 numReadsIterA=1 skipReadsIterA=0 readsPerIterA=4 */
/* dataAtIterB=0 numReadsIterB=1 skipReadsIterB=0 readsPerIterB=32 */
label_toPGR1end_OptNLL:
/* Stores for OptNLL */
label_Summation_End_OptNLL:
/* endSummation: add vgpr [32...392) to pool */
/* load store sgprs */

/* Mapping of Acc register -> C Vgpr register */

/* Multiply MI out register with Alpha -> C Vgpr register */
/* computeStoreVgprs */
s_nop 0
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
s_wait_alu depctr_vm_vsrc(6)
v_lshrrev_b32 v36, 5, v[vgprSerial-256]            // 36 = Serial / 32
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_lshrrev_b32 v37, 0, v36                          // 37 = 36 / 1
v_mul_lo_u32 v37, 0x10, v37                        // wave coordination offset 1
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_and_b32 v33, 31, v[vgprSerial-256]               // v33 = v[vgprSerial-256] % 32
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_lshrrev_b32 v33, 4, v33                          // 33 = 33 / 16
v_lshlrev_b32 v33, 3, v33                          // thread0 * continuous_output
v_add_lshl_u32 v33, v37, v33, 1                    // coordination 1 = vwB *(wave_id1 + tid1)
v_mul_lo_u32 v34, v33, s[sgprStrideC1J]            //  offset 1
v_mul_lo_u32 v35, v33, s[sgprStrideD1J]            //  offset 1
v_and_b32 v32, 0, v36                              // v32 = v36 % 1
v_mul_lo_u32 v32, 0x10, v32                        // wave coordination offset 0
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_and_b32 v37, 15, v[vgprSerial-256]               // v37 = v[vgprSerial-256] % 16
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_add_lshl_u32 v32, v37, v32, 1                    // coordination 0 = vwA * (wave_id0 + tid0)
s_mul_i32 s8, 32, s[sgprWorkGroup0]                // wgp0 * MT0
v_add_nc_u32 v32, s8, v32                          // coord 0 = (tid0/MI_m)*4 + waveG0*MIB_m + MT0*SG0
s_mul_i32 s8, 64, s[sgprWorkGroup1]                // wgp1 * MT1
v_add_nc_u32 v33, s8, v33                          // coord 1 = (tid0%MI_m) + waveG1*MIB_n + MT1*SG1

/******************************************/
/* Global Write Elements                  */
/******************************************/
label_GW_B0_OptNLL_MB:
label_GW_B0_FD0_OptNLL_MB:
label_GW_B0_FD0_VW2_OptNLL_MB_Then:
.set sgprCLSm0Base, 8
.set sgprCLSLoopCounter, 11

/* edge=0, allocate 1 sgpr. perBatchTmpS=1 perBatchMaskS=0 perElementMaskS=0 elementsPerBatch=232 */
/* optSingleColVgpr=1 optSharedColVgpr=0 optSGPRUsage=BufferLoad_Mask optSrdIncForRow=1 factorDim=0 */
/* (d1,vc1,d0,vc0)=(0,0,0,0) */
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_add_nc_u32 v43, v35, v32                         // optSingleColVgpr scaleToBpe: sharedAddrVgpr <- cinRowPtr + coord0, scaled by BPE. BSHERE:coord0=32, coord0Vgpr=32 (multiple bpe)
                                                   // optSingleColVgpr scaleToBpe: sharedAddrVgpr <- cinRowPtr + coord0, scaled by BPE. BSHERE:coord0=32, coord0Vgpr=32 (bpe is 1, no mul)
s_mov_b32 s12, 0                                   // Init sgpr offset
s_mov_b32 s13, 0                                   // Init sgpr offset
s_mov_b32 s[sgprCLSm0Base], 0x0                    // CLS M0 base = 0
s_mov_b32 s[sgprCLSLoopCounter], 0x1               // CLS loop iter count

/******************************************/
/* Global Write Batch #0 (d1,d0,vc1,vc0) = */
/*    (0,0,0,0:vw2); (0,0,1,0:vw2); (0,0,2,0:vw2); (0,0,3,0:vw2); (0,0,4,0:vw2); (0,0,5,0:vw2); (0,0,6,0:vw2); (0,0,7,0:vw2); (0,0,8,0:vw2); (0,0,9,0:vw2); (0,0,10,0:vw2); (0,0,11,0:vw2); (0,0,12,0:vw2); (0,0,13,0:vw2); (0,0,14,0:vw2); (0,0,15,0:vw2) */
/******************************************/
label_CLS:
s_mov_b32 m0, s[sgprCLSm0Base]                     // LDS clamp at sgpr(CLSm0Base)
s_add_u32 s[sgprCLSm0Base], s[sgprCLSm0Base], 1    // CLS M0 step (src coef of CLS iter dim)

/* calc coords, apply mask, and issue loads (if necessary) */
/* (d1,vc1,d0,vc0)=(0,0,0,0) */
/* (d1,vc1,d0,vc0)=(0,1,0,0) */
/* (d1,vc1,d0,vc0)=(0,2,0,0) */
/* (d1,vc1,d0,vc0)=(0,3,0,0) */
/* (d1,vc1,d0,vc0)=(0,4,0,0) */
/* (d1,vc1,d0,vc0)=(0,5,0,0) */
/* (d1,vc1,d0,vc0)=(0,6,0,0) */
/* (d1,vc1,d0,vc0)=(0,7,0,0) */
/* (d1,vc1,d0,vc0)=(0,8,0,0) */
/* (d1,vc1,d0,vc0)=(0,9,0,0) */
/* (d1,vc1,d0,vc0)=(0,10,0,0) */
/* (d1,vc1,d0,vc0)=(0,11,0,0) */
/* (d1,vc1,d0,vc0)=(0,12,0,0) */
/* (d1,vc1,d0,vc0)=(0,13,0,0) */
/* (d1,vc1,d0,vc0)=(0,14,0,0) */
/* (d1,vc1,d0,vc0)=(0,15,0,0) */
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
s_wait_alu depctr_vm_vsrc(6)
v_movrelsd_2_b32 v[vgprValuC+46], v[vgprValuC+0]   // copy MI out reg to vreg[0]
v_movrelsd_2_b32 v[vgprValuC+47], v[vgprValuC+8]   // copy MI out reg to vreg[1]
v_movrelsd_2_b32 v[vgprValuC+48], v[vgprValuC+16]  // copy MI out reg to vreg[2]
v_movrelsd_2_b32 v[vgprValuC+49], v[vgprValuC+24]  // copy MI out reg to vreg[3]
v_movrelsd_2_b32 v[vgprValuC+50], v[vgprValuC+1]   // copy MI out reg to vreg[4]
v_movrelsd_2_b32 v[vgprValuC+51], v[vgprValuC+9]   // copy MI out reg to vreg[5]
v_movrelsd_2_b32 v[vgprValuC+52], v[vgprValuC+17]  // copy MI out reg to vreg[6]
v_movrelsd_2_b32 v[vgprValuC+53], v[vgprValuC+25]  // copy MI out reg to vreg[7]
v_movrelsd_2_b32 v[vgprValuC+54], v[vgprValuC+2]   // copy MI out reg to vreg[8]
v_movrelsd_2_b32 v[vgprValuC+55], v[vgprValuC+10]  // copy MI out reg to vreg[9]
v_movrelsd_2_b32 v[vgprValuC+56], v[vgprValuC+18]  // copy MI out reg to vreg[10]
v_movrelsd_2_b32 v[vgprValuC+57], v[vgprValuC+26]  // copy MI out reg to vreg[11]
v_movrelsd_2_b32 v[vgprValuC+58], v[vgprValuC+3]   // copy MI out reg to vreg[12]
v_movrelsd_2_b32 v[vgprValuC+59], v[vgprValuC+11]  // copy MI out reg to vreg[13]
v_movrelsd_2_b32 v[vgprValuC+60], v[vgprValuC+19]  // copy MI out reg to vreg[14]
v_movrelsd_2_b32 v[vgprValuC+61], v[vgprValuC+27]  // copy MI out reg to vreg[15]
v_movrelsd_2_b32 v[vgprValuC+62], v[vgprValuC+4]   // copy MI out reg to vreg[16]
v_movrelsd_2_b32 v[vgprValuC+63], v[vgprValuC+12]  // copy MI out reg to vreg[17]
v_movrelsd_2_b32 v[vgprValuC+64], v[vgprValuC+20]  // copy MI out reg to vreg[18]
v_movrelsd_2_b32 v[vgprValuC+65], v[vgprValuC+28]  // copy MI out reg to vreg[19]
s_wait_alu depctr_vm_vsrc(5)
v_movrelsd_2_b32 v[vgprValuC+66], v[vgprValuC+5]   // copy MI out reg to vreg[20]
v_movrelsd_2_b32 v[vgprValuC+67], v[vgprValuC+13]  // copy MI out reg to vreg[21]
s_wait_alu depctr_vm_vsrc(4)
v_movrelsd_2_b32 v[vgprValuC+68], v[vgprValuC+21]  // copy MI out reg to vreg[22]
v_movrelsd_2_b32 v[vgprValuC+69], v[vgprValuC+29]  // copy MI out reg to vreg[23]
s_wait_alu depctr_vm_vsrc(3)
v_movrelsd_2_b32 v[vgprValuC+70], v[vgprValuC+6]   // copy MI out reg to vreg[24]
v_movrelsd_2_b32 v[vgprValuC+71], v[vgprValuC+14]  // copy MI out reg to vreg[25]
s_wait_alu depctr_vm_vsrc(2)
v_movrelsd_2_b32 v[vgprValuC+72], v[vgprValuC+22]  // copy MI out reg to vreg[26]
v_movrelsd_2_b32 v[vgprValuC+73], v[vgprValuC+30]  // copy MI out reg to vreg[27]
s_wait_alu depctr_vm_vsrc(1)
v_movrelsd_2_b32 v[vgprValuC+74], v[vgprValuC+7]   // copy MI out reg to vreg[28]
v_movrelsd_2_b32 v[vgprValuC+75], v[vgprValuC+15]  // copy MI out reg to vreg[29]
s_wait_alu depctr_vm_vsrc(0)
v_movrelsd_2_b32 v[vgprValuC+76], v[vgprValuC+23]  // copy MI out reg to vreg[30]
v_movrelsd_2_b32 v[vgprValuC+77], v[vgprValuC+31]  // copy MI out reg to vreg[31]

/* apply mask, calc new C and issue writes */
v_mov_b32 v40, 0x207                               // Nan and +/- inf
v_mov_b32 v42, 0x43E00000                          // Fp8 Max value 448 as float32
v_mov_b32 v41, 0xc3E00000                          // Fp8 Min value -448 as float32
v_cmp_class_f32 s13, v[vgprValuC+46], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+46], v41, v42
v_cndmask_b32 v[vgprValuC+46], v39, v[vgprValuC+46], s13
v_cmp_class_f32 s13, v[vgprValuC+47], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+47], v41, v42
v_cndmask_b32 v[vgprValuC+47], v39, v[vgprValuC+47], s13
v_cvt_pk_fp8_f32 v46, v[vgprValuC+46], v[vgprValuC+47] op_sel:[0,0,0]
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s12, s[sgprStrideD1J], 0                // incToNextRow: Scale by BPE
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v46, v43, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s13, v[vgprValuC+48], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+48], v41, v42
v_cndmask_b32 v[vgprValuC+48], v39, v[vgprValuC+48], s13
v_cmp_class_f32 s13, v[vgprValuC+49], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+49], v41, v42
v_cndmask_b32 v[vgprValuC+49], v39, v[vgprValuC+49], s13
v_cvt_pk_fp8_f32 v48, v[vgprValuC+48], v[vgprValuC+49] op_sel:[0,0,0]
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s12, s[sgprStrideD1J], 0                // incToNextRow: Scale by BPE
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v48, v43, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s13, v[vgprValuC+50], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+50], v41, v42
v_cndmask_b32 v[vgprValuC+50], v39, v[vgprValuC+50], s13
v_cmp_class_f32 s13, v[vgprValuC+51], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+51], v41, v42
v_cndmask_b32 v[vgprValuC+51], v39, v[vgprValuC+51], s13
v_cvt_pk_fp8_f32 v50, v[vgprValuC+50], v[vgprValuC+51] op_sel:[0,0,0]
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s12, s[sgprStrideD1J], 0                // incToNextRow: Scale by BPE
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v50, v43, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s13, v[vgprValuC+52], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+52], v41, v42
v_cndmask_b32 v[vgprValuC+52], v39, v[vgprValuC+52], s13
v_cmp_class_f32 s13, v[vgprValuC+53], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+53], v41, v42
v_cndmask_b32 v[vgprValuC+53], v39, v[vgprValuC+53], s13
v_cvt_pk_fp8_f32 v52, v[vgprValuC+52], v[vgprValuC+53] op_sel:[0,0,0]
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s12, s[sgprStrideD1J], 0                // incToNextRow: Scale by BPE
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v52, v43, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s13, v[vgprValuC+54], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+54], v41, v42
v_cndmask_b32 v[vgprValuC+54], v39, v[vgprValuC+54], s13
v_cmp_class_f32 s13, v[vgprValuC+55], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+55], v41, v42
v_cndmask_b32 v[vgprValuC+55], v39, v[vgprValuC+55], s13
v_cvt_pk_fp8_f32 v54, v[vgprValuC+54], v[vgprValuC+55] op_sel:[0,0,0]
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s12, s[sgprStrideD1J], 0                // incToNextRow: Scale by BPE
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v54, v43, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s13, v[vgprValuC+56], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+56], v41, v42
v_cndmask_b32 v[vgprValuC+56], v39, v[vgprValuC+56], s13
v_cmp_class_f32 s13, v[vgprValuC+57], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+57], v41, v42
v_cndmask_b32 v[vgprValuC+57], v39, v[vgprValuC+57], s13
v_cvt_pk_fp8_f32 v56, v[vgprValuC+56], v[vgprValuC+57] op_sel:[0,0,0]
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s12, s[sgprStrideD1J], 0                // incToNextRow: Scale by BPE
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v56, v43, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s13, v[vgprValuC+58], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+58], v41, v42
v_cndmask_b32 v[vgprValuC+58], v39, v[vgprValuC+58], s13
v_cmp_class_f32 s13, v[vgprValuC+59], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+59], v41, v42
v_cndmask_b32 v[vgprValuC+59], v39, v[vgprValuC+59], s13
v_cvt_pk_fp8_f32 v58, v[vgprValuC+58], v[vgprValuC+59] op_sel:[0,0,0]
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s12, s[sgprStrideD1J], 0                // incToNextRow: Scale by BPE
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v58, v43, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s13, v[vgprValuC+60], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+60], v41, v42
v_cndmask_b32 v[vgprValuC+60], v39, v[vgprValuC+60], s13
v_cmp_class_f32 s13, v[vgprValuC+61], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+61], v41, v42
v_cndmask_b32 v[vgprValuC+61], v39, v[vgprValuC+61], s13
v_cvt_pk_fp8_f32 v60, v[vgprValuC+60], v[vgprValuC+61] op_sel:[0,0,0]
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s12, s[sgprStrideD1J], 0                // incToNextRow: Scale by BPE
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v60, v43, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s13, v[vgprValuC+62], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+62], v41, v42
v_cndmask_b32 v[vgprValuC+62], v39, v[vgprValuC+62], s13
v_cmp_class_f32 s13, v[vgprValuC+63], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+63], v41, v42
v_cndmask_b32 v[vgprValuC+63], v39, v[vgprValuC+63], s13
v_cvt_pk_fp8_f32 v62, v[vgprValuC+62], v[vgprValuC+63] op_sel:[0,0,0]
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s12, s[sgprStrideD1J], 0                // incToNextRow: Scale by BPE
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v62, v43, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s13, v[vgprValuC+64], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+64], v41, v42
v_cndmask_b32 v[vgprValuC+64], v39, v[vgprValuC+64], s13
v_cmp_class_f32 s13, v[vgprValuC+65], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+65], v41, v42
v_cndmask_b32 v[vgprValuC+65], v39, v[vgprValuC+65], s13
v_cvt_pk_fp8_f32 v64, v[vgprValuC+64], v[vgprValuC+65] op_sel:[0,0,0]
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s12, s[sgprStrideD1J], 0                // incToNextRow: Scale by BPE
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v64, v43, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s13, v[vgprValuC+66], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+66], v41, v42
v_cndmask_b32 v[vgprValuC+66], v39, v[vgprValuC+66], s13
v_cmp_class_f32 s13, v[vgprValuC+67], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+67], v41, v42
v_cndmask_b32 v[vgprValuC+67], v39, v[vgprValuC+67], s13
v_cvt_pk_fp8_f32 v66, v[vgprValuC+66], v[vgprValuC+67] op_sel:[0,0,0]
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s12, s[sgprStrideD1J], 0                // incToNextRow: Scale by BPE
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v66, v43, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s13, v[vgprValuC+68], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+68], v41, v42
v_cndmask_b32 v[vgprValuC+68], v39, v[vgprValuC+68], s13
v_cmp_class_f32 s13, v[vgprValuC+69], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+69], v41, v42
v_cndmask_b32 v[vgprValuC+69], v39, v[vgprValuC+69], s13
v_cvt_pk_fp8_f32 v68, v[vgprValuC+68], v[vgprValuC+69] op_sel:[0,0,0]
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s12, s[sgprStrideD1J], 0                // incToNextRow: Scale by BPE
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v68, v43, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s13, v[vgprValuC+70], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+70], v41, v42
v_cndmask_b32 v[vgprValuC+70], v39, v[vgprValuC+70], s13
v_cmp_class_f32 s13, v[vgprValuC+71], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+71], v41, v42
v_cndmask_b32 v[vgprValuC+71], v39, v[vgprValuC+71], s13
v_cvt_pk_fp8_f32 v70, v[vgprValuC+70], v[vgprValuC+71] op_sel:[0,0,0]
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s12, s[sgprStrideD1J], 0                // incToNextRow: Scale by BPE
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v70, v43, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s13, v[vgprValuC+72], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+72], v41, v42
v_cndmask_b32 v[vgprValuC+72], v39, v[vgprValuC+72], s13
v_cmp_class_f32 s13, v[vgprValuC+73], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+73], v41, v42
v_cndmask_b32 v[vgprValuC+73], v39, v[vgprValuC+73], s13
v_cvt_pk_fp8_f32 v72, v[vgprValuC+72], v[vgprValuC+73] op_sel:[0,0,0]
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s12, s[sgprStrideD1J], 0                // incToNextRow: Scale by BPE
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v72, v43, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s13, v[vgprValuC+74], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+74], v41, v42
v_cndmask_b32 v[vgprValuC+74], v39, v[vgprValuC+74], s13
v_cmp_class_f32 s13, v[vgprValuC+75], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+75], v41, v42
v_cndmask_b32 v[vgprValuC+75], v39, v[vgprValuC+75], s13
v_cvt_pk_fp8_f32 v74, v[vgprValuC+74], v[vgprValuC+75] op_sel:[0,0,0]
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s12, s[sgprStrideD1J], 0                // incToNextRow: Scale by BPE
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v74, v43, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s13, v[vgprValuC+76], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+76], v41, v42
v_cndmask_b32 v[vgprValuC+76], v39, v[vgprValuC+76], s13
v_cmp_class_f32 s13, v[vgprValuC+77], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+77], v41, v42
v_cndmask_b32 v[vgprValuC+77], v39, v[vgprValuC+77], s13
v_cvt_pk_fp8_f32 v76, v[vgprValuC+76], v[vgprValuC+77] op_sel:[0,0,0]
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s12, s[sgprStrideD1J], 0                // incToNextRow: Scale by BPE
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v76, v43, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_nop 0                                            // 1 wait state required when next inst writes vgprs held by previous dwordx4 store inst
s_sub_i32 s[sgprCLSLoopCounter], s[sgprCLSLoopCounter], 1
s_cmp_eq_u32 s[sgprCLSLoopCounter], 0
s_cbranch_scc1 label_NoBranch_S4FDBQ587JJL6NOU     // Only branch on scc0
// loop while counter != 0
s_getpc_b64 s[24:25]                               // addr of next instr
s_add_i32 s26, label_CLS, 4                        // target branch offset
s_abs_i32 s26, s26                                 // abs offset
s_sub_u32 s24, s24, s26                            // sub target branch offset
s_subb_u32 s25, s25, 0                             // sub high and carry
s_setpc_b64 s[24:25]                               // branch to label_CLS
label_NoBranch_S4FDBQ587JJL6NOU:
.set sgprCLSLoopCounter, UNDEF
.set sgprCLSm0Base, UNDEF
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
/*  grEndMfmaIndex:0, lwStartMfmaIndex:3, lwEndMfmaIndex:3  */
/*  numMfmaForLR:3, syncPlrMfmaIndex:0 , sync1LdsMfmaIndex:2 */
/*  mfmaIndex:0  */
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
s_wait_alu depctr_va_vdst(14)
ds_load_b128 v[vgprValuA_X0_I0+0:vgprValuA_X0_I0+0+3], v[vgprLocalReadAddrA+0] offset:0 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_b128 v[vgprValuA_X0_I0+4:vgprValuA_X0_I0+4+3], v[vgprLocalReadAddrA+0] offset:32 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D0+0], v[vgprLocalReadAddrB+0] offset:0 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D1+0], v[vgprLocalReadAddrB+0] offset:64 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D2+0], v[vgprLocalReadAddrB+0] offset:128 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=2 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D3+0], v[vgprLocalReadAddrB+0] offset:192 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=3 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D4+0], v[vgprLocalReadAddrB+0] offset:256 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=4 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D5+0], v[vgprLocalReadAddrB+0] offset:320 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=5 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D6+0], v[vgprLocalReadAddrB+0] offset:384 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=6 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D7+0], v[vgprLocalReadAddrB+0] offset:448 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=7 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D8+0], v[vgprLocalReadAddrB+0] offset:512 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=8 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D9+0], v[vgprLocalReadAddrB+0] offset:576 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=9 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D10+0], v[vgprLocalReadAddrB+0] offset:640 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=10 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D11+0], v[vgprLocalReadAddrB+0] offset:704 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=11 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D12+0], v[vgprLocalReadAddrB+0] offset:768 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=12 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D13+0], v[vgprLocalReadAddrB+0] offset:832 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=13 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D14+0], v[vgprLocalReadAddrB+0] offset:896 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=14 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D15+0], v[vgprLocalReadAddrB+0] offset:960 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=15 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D16+0], v[vgprLocalReadAddrB+0] offset:2112 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=16 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D17+0], v[vgprLocalReadAddrB+0] offset:2176 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=17 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D18+0], v[vgprLocalReadAddrB+0] offset:2240 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=18 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D19+0], v[vgprLocalReadAddrB+0] offset:2304 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=19 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D20+0], v[vgprLocalReadAddrB+0] offset:2368 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=20 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D21+0], v[vgprLocalReadAddrB+0] offset:2432 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=21 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D22+0], v[vgprLocalReadAddrB+0] offset:2496 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=22 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D23+0], v[vgprLocalReadAddrB+0] offset:2560 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=23 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D24+0], v[vgprLocalReadAddrB+0] offset:2624 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=24 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D25+0], v[vgprLocalReadAddrB+0] offset:2688 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=25 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D26+0], v[vgprLocalReadAddrB+0] offset:2752 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=26 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D27+0], v[vgprLocalReadAddrB+0] offset:2816 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=27 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D28+0], v[vgprLocalReadAddrB+0] offset:2880 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=28 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D29+0], v[vgprLocalReadAddrB+0] offset:2944 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=29 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D30+0], v[vgprLocalReadAddrB+0] offset:3008 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=30 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D31+0], v[vgprLocalReadAddrB+0] offset:3072 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=31 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_b128 v[vgprValuA_X0_I0+8:vgprValuA_X0_I0+8+3], v[vgprLocalReadAddrA+0] offset:64 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=1 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_b128 v[vgprValuA_X0_I0+12:vgprValuA_X0_I0+12+3], v[vgprLocalReadAddrA+0] offset:96 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=1 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS0
s_wait_dscnt 2                                     // Wait for dependent lr
/* pack scheduling: packAIdx:0, packBIdx:24 */
v_perm_b32 v[vgprValuB_X0_I0+0], v[vgprValuB_X0_I0_D1+0], v[vgprValuB_X0_I0_D0+0], s[sgprPackKForV0] // select K=01 for vector=0
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D3+0], v[vgprValuB_X0_I0_D2+0], s[sgprPackKForV0] // select K=23 for vector=0
v_lshl_or_b32 v[vgprValuB_X0_I0+0], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+0] // pack two half Vgpr to one Vgpr
v_perm_b32 v[vgprValuB_X0_I0+1], v[vgprValuB_X0_I0_D5+0], v[vgprValuB_X0_I0_D4+0], s[sgprPackKForV0] // select K=45 for vector=0
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D7+0], v[vgprValuB_X0_I0_D6+0], s[sgprPackKForV0] // select K=67 for vector=0
v_lshl_or_b32 v[vgprValuB_X0_I0+1], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+1] // pack two half Vgpr to one Vgpr
v_perm_b32 v[vgprValuB_X0_I0+2], v[vgprValuB_X0_I0_D9+0], v[vgprValuB_X0_I0_D8+0], s[sgprPackKForV0] // select K=89 for vector=0
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D11+0], v[vgprValuB_X0_I0_D10+0], s[sgprPackKForV0] // select K=1011 for vector=0
v_lshl_or_b32 v[vgprValuB_X0_I0+2], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+2] // pack two half Vgpr to one Vgpr
v_perm_b32 v[vgprValuB_X0_I0+3], v[vgprValuB_X0_I0_D13+0], v[vgprValuB_X0_I0_D12+0], s[sgprPackKForV0] // select K=1213 for vector=0
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D15+0], v[vgprValuB_X0_I0_D14+0], s[sgprPackKForV0] // select K=1415 for vector=0
v_lshl_or_b32 v[vgprValuB_X0_I0+3], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+3] // pack two half Vgpr to one Vgpr
v_perm_b32 v[vgprValuB_X0_I0+4], v[vgprValuB_X0_I0_D17+0], v[vgprValuB_X0_I0_D16+0], s[sgprPackKForV0] // select K=1617 for vector=0
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D19+0], v[vgprValuB_X0_I0_D18+0], s[sgprPackKForV0] // select K=1819 for vector=0
v_lshl_or_b32 v[vgprValuB_X0_I0+4], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+4] // pack two half Vgpr to one Vgpr
v_perm_b32 v[vgprValuB_X0_I0+5], v[vgprValuB_X0_I0_D21+0], v[vgprValuB_X0_I0_D20+0], s[sgprPackKForV0] // select K=2021 for vector=0
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D23+0], v[vgprValuB_X0_I0_D22+0], s[sgprPackKForV0] // select K=2223 for vector=0
v_lshl_or_b32 v[vgprValuB_X0_I0+5], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+5] // pack two half Vgpr to one Vgpr
v_perm_b32 v[vgprValuB_X0_I0+6], v[vgprValuB_X0_I0_D25+0], v[vgprValuB_X0_I0_D24+0], s[sgprPackKForV0] // select K=2425 for vector=0
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D27+0], v[vgprValuB_X0_I0_D26+0], s[sgprPackKForV0] // select K=2627 for vector=0
v_lshl_or_b32 v[vgprValuB_X0_I0+6], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+6] // pack two half Vgpr to one Vgpr
v_perm_b32 v[vgprValuB_X0_I0+7], v[vgprValuB_X0_I0_D29+0], v[vgprValuB_X0_I0_D28+0], s[sgprPackKForV0] // select K=2829 for vector=0
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D31+0], v[vgprValuB_X0_I0_D30+0], s[sgprPackKForV0] // select K=3031 for vector=0
v_lshl_or_b32 v[vgprValuB_X0_I0+7], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+7] // pack two half Vgpr to one Vgpr
v_perm_b32 v[vgprValuB_X0_I0+8], v[vgprValuB_X0_I0_D1+0], v[vgprValuB_X0_I0_D0+0], s[sgprPackKForV1] // select K=01 for vector=1
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D3+0], v[vgprValuB_X0_I0_D2+0], s[sgprPackKForV1] // select K=23 for vector=1
v_wmma_f32_16x16x64_fp8_fp8 v[vgprValuC+0:vgprValuC+0+7], v[vgprValuB_X0_I0+0+0+0:vgprValuB_X0_I0+0+0+0+7], v[vgprValuA_X0_I0+0+0+0:vgprValuA_X0_I0+0+0+0+7], v[vgprValuC+0:vgprValuC+0+7] matrix_a_reuse // left value = v[0+0:7+0]
/*  mfmaIndex:1  */
/* localReadsVacancy: latencyLeft 5 */
s_wait_dscnt 0                                     // Wait for dependent lr
/* pack scheduling: packAIdx:0, packBIdx:24 */
v_lshl_or_b32 v[vgprValuB_X0_I0+8], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+8] // pack two half Vgpr to one Vgpr
v_perm_b32 v[vgprValuB_X0_I0+9], v[vgprValuB_X0_I0_D5+0], v[vgprValuB_X0_I0_D4+0], s[sgprPackKForV1] // select K=45 for vector=1
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D7+0], v[vgprValuB_X0_I0_D6+0], s[sgprPackKForV1] // select K=67 for vector=1
v_lshl_or_b32 v[vgprValuB_X0_I0+9], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+9] // pack two half Vgpr to one Vgpr
v_perm_b32 v[vgprValuB_X0_I0+10], v[vgprValuB_X0_I0_D9+0], v[vgprValuB_X0_I0_D8+0], s[sgprPackKForV1] // select K=89 for vector=1
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D11+0], v[vgprValuB_X0_I0_D10+0], s[sgprPackKForV1] // select K=1011 for vector=1
v_lshl_or_b32 v[vgprValuB_X0_I0+10], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+10] // pack two half Vgpr to one Vgpr
v_perm_b32 v[vgprValuB_X0_I0+11], v[vgprValuB_X0_I0_D13+0], v[vgprValuB_X0_I0_D12+0], s[sgprPackKForV1] // select K=1213 for vector=1
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D15+0], v[vgprValuB_X0_I0_D14+0], s[sgprPackKForV1] // select K=1415 for vector=1
v_lshl_or_b32 v[vgprValuB_X0_I0+11], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+11] // pack two half Vgpr to one Vgpr
v_perm_b32 v[vgprValuB_X0_I0+12], v[vgprValuB_X0_I0_D17+0], v[vgprValuB_X0_I0_D16+0], s[sgprPackKForV1] // select K=1617 for vector=1
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D19+0], v[vgprValuB_X0_I0_D18+0], s[sgprPackKForV1] // select K=1819 for vector=1
v_lshl_or_b32 v[vgprValuB_X0_I0+12], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+12] // pack two half Vgpr to one Vgpr
v_perm_b32 v[vgprValuB_X0_I0+13], v[vgprValuB_X0_I0_D21+0], v[vgprValuB_X0_I0_D20+0], s[sgprPackKForV1] // select K=2021 for vector=1
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D23+0], v[vgprValuB_X0_I0_D22+0], s[sgprPackKForV1] // select K=2223 for vector=1
v_lshl_or_b32 v[vgprValuB_X0_I0+13], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+13] // pack two half Vgpr to one Vgpr
v_perm_b32 v[vgprValuB_X0_I0+14], v[vgprValuB_X0_I0_D25+0], v[vgprValuB_X0_I0_D24+0], s[sgprPackKForV1] // select K=2425 for vector=1
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D27+0], v[vgprValuB_X0_I0_D26+0], s[sgprPackKForV1] // select K=2627 for vector=1
v_lshl_or_b32 v[vgprValuB_X0_I0+14], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+14] // pack two half Vgpr to one Vgpr
v_perm_b32 v[vgprValuB_X0_I0+15], v[vgprValuB_X0_I0_D29+0], v[vgprValuB_X0_I0_D28+0], s[sgprPackKForV1] // select K=2829 for vector=1
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D31+0], v[vgprValuB_X0_I0_D30+0], s[sgprPackKForV1] // select K=3031 for vector=1
v_lshl_or_b32 v[vgprValuB_X0_I0+15], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+15] // pack two half Vgpr to one Vgpr
v_wmma_f32_16x16x64_fp8_fp8 v[vgprValuC+8:vgprValuC+8+7], v[vgprValuB_X0_I0+0+0+0:vgprValuB_X0_I0+0+0+0+7], v[vgprValuA_X0_I0+8+0+0:vgprValuA_X0_I0+8+0+0+7], v[vgprValuC+8:vgprValuC+8+7] // left value = v[8+0:15+0]
/*  mfmaIndex:2  */
/* schedule remaining localreads for one buffer scheduling */
/* localReadsVacancy: latencyLeft 5 */
/* 1 LDS buffer: read-sync-write */
s_wait_dscnt 0
s_barrier_signal -1
s_barrier_wait -1
v_wmma_f32_16x16x64_fp8_fp8 v[vgprValuC+16:vgprValuC+16+7], v[vgprValuB_X0_I0+8+0+0:vgprValuB_X0_I0+8+0+0+7], v[vgprValuA_X0_I0+0+0+0:vgprValuA_X0_I0+0+0+0+7], v[vgprValuC+16:vgprValuC+16+7] matrix_a_reuse // left value = v[16+0:23+0]
/*  mfmaIndex:3  */
v_wmma_f32_16x16x64_fp8_fp8 v[vgprValuC+24:vgprValuC+24+7], v[vgprValuB_X0_I0+8+0+0:vgprValuB_X0_I0+8+0+0+7], v[vgprValuA_X0_I0+8+0+0:vgprValuA_X0_I0+8+0+0+7], v[vgprValuC+24:vgprValuC+24+7] // left value = v[24+0:31+0]
/* numPrefetchIter=0 */
/* dataAtIterA=0 numReadsIterA=1 skipReadsIterA=0 readsPerIterA=4 */
/* dataAtIterB=0 numReadsIterB=1 skipReadsIterB=0 readsPerIterB=32 */
label_toPGR1end_OrdNLL:
label_PrefetchGlobalLastIterEnd:

/* Tail: add ValuA/B vgpr buffer [132...199) to pool */

/* Tail: add address/G2L vgpr [199...392) to pool */

/******************************************/
/* Tail Loop                              */
/******************************************/

/* local write reset offsets a */

/* local write reset offsets b */
/* Check out VGPR (numG2LA,numG2LB,numG2LMXSA,numG2LMXSB,numG2LMetadata) = (64,128,0,0,0) */
.set vgprG2LA_BASE, 132
.set vgprG2LA, vgprG2LA_BASE+0
.set vgprG2LB_BASE, 196
.set vgprG2LB, vgprG2LB_BASE+0

/* remove stagger offsets for tail loop */
s_cmp_eq_u32 s[sgprOrigLoopCounter], 0             // skip if main loop was not executed
s_cbranch_scc1 label_SkipRemoveStagger             // skip removeStagger
//  removeStagger A
s_sub_i32 s68, 3, s[sgprStaggerUIter]
s_cmp_ge_i32 s68, 0
s_cbranch_scc0 label_Negative_UR8VN3A1SJCPC6PO
s_mul_hi_u32 s69, s68, s[sgprGlobalReadIncsA+0]    // start offset S in bytes
s_mul_i32 s68, s68, s[sgprGlobalReadIncsA+0]       // start offset S in bytes
s_branch label_MultiplyDone_HYY06MPL0TYYIAT2
label_Negative_UR8VN3A1SJCPC6PO:
s_abs_i32 s68, s68
s_mul_hi_u32 s69, s68, s[sgprGlobalReadIncsA+0]    // start offset S in bytes
s_mul_i32 s68, s68, s[sgprGlobalReadIncsA+0]       // start offset S in bytes
s_xor_b32 s68, s68, 0xffffffff
s_xor_b32 s69, s69, 0xffffffff
s_add_u32 s68, s68, 0x1
s_addc_u32 s69, s69, 0
label_MultiplyDone_HYY06MPL0TYYIAT2:
s_sub_u64 s[68:69], s[68:69], s[sgprWrapUA:sgprWrapUA+1] // S - WrapU
s_add_u32 s[sgprSrdA+0], s[sgprSrdA+0], s68        // gra SRD += inc(lower)
s_addc_u32 s[sgprSrdA+1], s[sgprSrdA+1], s69       // gra SRD += inc(upper)
s_sub_u32 s[sgprShadowLimitA+0], s[sgprShadowLimitA+0], s68 // limit -= inc)
s_subb_u32 s[sgprShadowLimitA+1], s[sgprShadowLimitA+1], s69 // limit -= inc)
s_cmp_eq_u32 s[sgprShadowLimitA+1], 0              // are we within 2^32?
s_cselect_b32 s[sgprSrdA+2], s[sgprShadowLimitA+0], BufferLimit // Move shadow to real if we are within 2^32
// Shift num records for gfx125x
s_and_b32 s8, s[sgprSrdA+2], 127
s_lshl_b32 s8, s8, 25
s_and_b32 s[sgprSrdA+1], s[sgprSrdA+1], 33554431
s_or_b32 s[sgprSrdA+1], s[sgprSrdA+1], s8
s_lshr_b32 s[sgprSrdA+2], s[sgprSrdA+2], 7
//  removeStagger B
s_sub_i32 s68, 3, s[sgprStaggerUIter]
s_cmp_ge_i32 s68, 0
s_cbranch_scc0 label_Negative_8S4L1KCK9VFC7AQU
s_mul_hi_u32 s69, s68, s[sgprGlobalReadIncsB+0]    // start offset S in bytes
s_mul_i32 s68, s68, s[sgprGlobalReadIncsB+0]       // start offset S in bytes
s_branch label_MultiplyDone_ZU0B7F2XE71N7LVL
label_Negative_8S4L1KCK9VFC7AQU:
s_abs_i32 s68, s68
s_mul_hi_u32 s69, s68, s[sgprGlobalReadIncsB+0]    // start offset S in bytes
s_mul_i32 s68, s68, s[sgprGlobalReadIncsB+0]       // start offset S in bytes
s_xor_b32 s68, s68, 0xffffffff
s_xor_b32 s69, s69, 0xffffffff
s_add_u32 s68, s68, 0x1
s_addc_u32 s69, s69, 0
label_MultiplyDone_ZU0B7F2XE71N7LVL:
s_sub_u64 s[68:69], s[68:69], s[sgprWrapUB:sgprWrapUB+1] // S - WrapU
s_add_u32 s[sgprSrdB+0], s[sgprSrdB+0], s68        // gra SRD += inc(lower)
s_addc_u32 s[sgprSrdB+1], s[sgprSrdB+1], s69       // gra SRD += inc(upper)
s_sub_u32 s[sgprShadowLimitB+0], s[sgprShadowLimitB+0], s68 // limit -= inc)
s_subb_u32 s[sgprShadowLimitB+1], s[sgprShadowLimitB+1], s69 // limit -= inc)
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
s_and_b32 s68, s[sgprGSU], 0x8000                  // SCC = (GSUC == 1) ?
s_cbranch_scc1 label_GSUC_TL                       // branch if GSUC == 1
s_cmp_lg_u32 s[sgprGSUSumIdx], s[sgprGSUSumIdx+1]  // gsuSumIdx == numIterPerWgRemainder
s_cmov_b32 s[sgprLoopCounterL], 0                  // numIter=0 if gsuSimIdx != numIterPerWgRemainder
s_branch label_GSUC_TL_End
label_GSUC_TL:
s_lshr_b32 s69, s[sgprSizesSum], 6                 // s69 = s[sgprSizesSum] / 64
s_and_b32 s70, s[sgprGSU], 0x3fff                  // Restore GSU
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
v_cvt_f32_u32 v[324-256], s70                      // s68 = s69 / s70
s_set_vgpr_msb 16449                               // src0: 1, src1: 0, src2: 0, dst: 1
v_rcp_iflag_f32 v[324-256], v[324-256]             // s68 = s69 / s70
s_set_vgpr_msb 16704                               // src0: 0, src1: 0, src2: 0, dst: 1
v_cvt_f32_u32 v[325-256], s69                      // s68 = s69 / s70
s_set_vgpr_msb 16453                               // src0: 1, src1: 1, src2: 0, dst: 1
v_mul_f32 v[324-256], v[324-256], v[325-256]       // s68 = s69 / s70
s_set_vgpr_msb 17729                               // src0: 1, src1: 0, src2: 0, dst: 1
v_cvt_u32_f32 v[324-256], v[324-256]               // s68 = s69 / s70
v_mul_u32_u24 v[325-256], v[324-256], s70          // s68 = s69 / s70
s_set_vgpr_msb 16708                               // src0: 0, src1: 1, src2: 0, dst: 1
v_sub_nc_u32 v[325-256], s69, v[325-256]           // s68 = s69 / s70
s_set_vgpr_msb 17409                               // src0: 1, src1: 0, src2: 0, dst: 0
v_cmp_eq_u32 vcc_lo, v[325-256], s70               // s68 = s69 / s70
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, vcc_lo                          // s68 = s69 / s70
s_set_vgpr_msb 324                                 // src0: 0, src1: 1, src2: 0, dst: 1
v_add_nc_u32 v[324-256], 1, v[324-256]             // s68 = s69 / s70
s_set_vgpr_msb 17472                               // src0: 0, src1: 0, src2: 0, dst: 1
v_mov_b32 v[325-256], 0                            // s[sgprGSUSumIdx+1] = s69 % s70
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, -1                              // Reset exec
s_set_vgpr_msb 16385                               // src0: 1, src1: 0, src2: 0, dst: 0
v_cmp_gt_u32 vcc_lo, v[325-256], s70               // overflow happened in remainder
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, vcc_lo                          // overflow happened in remainder
s_set_vgpr_msb 321                                 // src0: 1, src1: 0, src2: 0, dst: 1
v_sub_nc_u32 v[324-256], v[324-256], 1             // quotient - 1
v_mul_u32_u24 v[325-256], v[324-256], s70          // re-calculate remainder
s_set_vgpr_msb 16708                               // src0: 0, src1: 1, src2: 0, dst: 1
v_sub_nc_u32 v[325-256], s69, v[325-256]           // re-calculate remainder
s_wait_alu depctr_va_vdst(0)
s_mov_b32 exec_lo, -1                              // Reset exec
s_set_vgpr_msb 17409                               // src0: 1, src1: 0, src2: 0, dst: 0
v_readfirstlane_b32 s68, v[324-256]                // quotient
v_readfirstlane_b32 s[sgprGSUSumIdx+1], v[325-256] // remainder
s_sub_u32 s69, s70, 1                              // GSU-1
s_cmp_eq_u32 s68, 0                                // quotient == 0
s_cselect_b32 s68, s[sgprGSUSumIdx+1], s69         // lastWg = (quotient==0) ? numIterPerWgRemainder : GSU-1
s_cmp_lg_u32 s[sgprGSUSumIdx], s68                 // gsuSumIdx == lastWg
s_cmov_b32 s[sgprLoopCounterL], 0                  // numIter=0 if gsuSumIdx != lastWg
label_GSUC_TL_End:
s_cmp_eq_u32 s[sgprLoopCounterL], 0                // numIterL == 0
s_mov_b32 s[sgprOrigLoopCounter], 0                // repurpose to count each localRead increment
s_cbranch_scc1 label_SkipTailLoopL                 // skip to end of tail loop b/c numIter==0

/* Update M0 for DTLDS */

/* Tail global read A */
/* g2l=0, load component 0 */
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
s_wait_alu depctr_va_vdst(14)
buffer_load_d16_u8 v[vgprG2LA+0+0], v[vgprGlobalReadOffsetA+0], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=0, load component 0 */
buffer_load_d16_u8 v[vgprG2LA+0+16], v[vgprGlobalReadOffsetA+1], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=0, load component 0 */
s_wait_alu depctr_va_vdst(7)
buffer_load_d16_u8 v[vgprG2LA+0+32], v[vgprGlobalReadOffsetA+2], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=0, load component 0 */
buffer_load_d16_u8 v[vgprG2LA+0+48], v[vgprGlobalReadOffsetA+3], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=1, load component 0 */
buffer_load_d16_u8 v[vgprG2LA+1+0], v[vgprGlobalReadOffsetA+4], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=1, load component 0 */
buffer_load_d16_u8 v[vgprG2LA+1+16], v[vgprGlobalReadOffsetA+5], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=1, load component 0 */
s_wait_alu depctr_va_vdst(4)
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
buffer_load_d16_u8 v[vgprG2LB+0+32], v[vgprGlobalReadOffsetB+1], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=0, load component 0 */
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
buffer_load_d16_u8 v[vgprG2LB+0+64-256], v[vgprGlobalReadOffsetB+2], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=0, load component 0 */
buffer_load_d16_u8 v[vgprG2LB+0+96-256], v[vgprGlobalReadOffsetB+3], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=1, load component 0 */
s_set_vgpr_msb 16384                               // src0: 0, src1: 0, src2: 0, dst: 0
buffer_load_d16_u8 v[vgprG2LB+1+0], v[vgprGlobalReadOffsetB+4], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=1, load component 0 */
buffer_load_d16_u8 v[vgprG2LB+1+32], v[vgprGlobalReadOffsetB+5], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=1, load component 0 */
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
buffer_load_d16_u8 v[vgprG2LB+1+64-256], v[vgprGlobalReadOffsetB+6], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=1, load component 0 */
buffer_load_d16_u8 v[vgprG2LB+1+96-256], v[vgprGlobalReadOffsetB+7], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=2, load component 0 */
s_set_vgpr_msb 16384                               // src0: 0, src1: 0, src2: 0, dst: 0
buffer_load_d16_u8 v[vgprG2LB+2+0], v[vgprGlobalReadOffsetB+8], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=2, load component 0 */
buffer_load_d16_u8 v[vgprG2LB+2+32], v[vgprGlobalReadOffsetB+9], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=2, load component 0 */
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
buffer_load_d16_u8 v[vgprG2LB+2+64-256], v[vgprGlobalReadOffsetB+10], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=2, load component 0 */
buffer_load_d16_u8 v[vgprG2LB+2+96-256], v[vgprGlobalReadOffsetB+11], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=3, load component 0 */
s_set_vgpr_msb 16384                               // src0: 0, src1: 0, src2: 0, dst: 0
buffer_load_d16_u8 v[vgprG2LB+3+0], v[vgprGlobalReadOffsetB+12], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=3, load component 0 */
buffer_load_d16_u8 v[vgprG2LB+3+32], v[vgprGlobalReadOffsetB+13], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=3, load component 0 */
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
buffer_load_d16_u8 v[vgprG2LB+3+64-256], v[vgprGlobalReadOffsetB+14], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=3, load component 0 */
buffer_load_d16_u8 v[vgprG2LB+3+96-256], v[vgprGlobalReadOffsetB+15], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=4, load component 0 */
s_set_vgpr_msb 16384                               // src0: 0, src1: 0, src2: 0, dst: 0
s_wait_alu depctr_vm_vsrc(6)
buffer_load_d16_u8 v[vgprG2LB+4+0], v[vgprGlobalReadOffsetB+16], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=4, load component 0 */
buffer_load_d16_u8 v[vgprG2LB+4+32], v[vgprGlobalReadOffsetB+17], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=4, load component 0 */
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
buffer_load_d16_u8 v[vgprG2LB+4+64-256], v[vgprGlobalReadOffsetB+18], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=4, load component 0 */
buffer_load_d16_u8 v[vgprG2LB+4+96-256], v[vgprGlobalReadOffsetB+19], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=5, load component 0 */
s_set_vgpr_msb 16384                               // src0: 0, src1: 0, src2: 0, dst: 0
buffer_load_d16_u8 v[vgprG2LB+5+0], v[vgprGlobalReadOffsetB+20], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=5, load component 0 */
buffer_load_d16_u8 v[vgprG2LB+5+32], v[vgprGlobalReadOffsetB+21], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=5, load component 0 */
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
buffer_load_d16_u8 v[vgprG2LB+5+64-256], v[vgprGlobalReadOffsetB+22], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=5, load component 0 */
buffer_load_d16_u8 v[vgprG2LB+5+96-256], v[vgprGlobalReadOffsetB+23], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=6, load component 0 */
s_set_vgpr_msb 16384                               // src0: 0, src1: 0, src2: 0, dst: 0
buffer_load_d16_u8 v[vgprG2LB+6+0], v[vgprGlobalReadOffsetB+24], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=6, load component 0 */
buffer_load_d16_u8 v[vgprG2LB+6+32], v[vgprGlobalReadOffsetB+25], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=6, load component 0 */
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
buffer_load_d16_u8 v[vgprG2LB+6+64-256], v[vgprGlobalReadOffsetB+26], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=6, load component 0 */
buffer_load_d16_u8 v[vgprG2LB+6+96-256], v[vgprGlobalReadOffsetB+27], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=7, load component 0 */
s_set_vgpr_msb 16384                               // src0: 0, src1: 0, src2: 0, dst: 0
buffer_load_d16_u8 v[vgprG2LB+7+0], v[vgprGlobalReadOffsetB+28], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=7, load component 0 */
buffer_load_d16_u8 v[vgprG2LB+7+32], v[vgprGlobalReadOffsetB+29], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=7, load component 0 */
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
buffer_load_d16_u8 v[vgprG2LB+7+64-256], v[vgprGlobalReadOffsetB+30], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=7, load component 0 */
buffer_load_d16_u8 v[vgprG2LB+7+96-256], v[vgprGlobalReadOffsetB+31], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=8, load component 0 */
s_set_vgpr_msb 16384                               // src0: 0, src1: 0, src2: 0, dst: 0
buffer_load_d16_u8 v[vgprG2LB+8+0], v[vgprGlobalReadOffsetB+32], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=8, load component 0 */
buffer_load_d16_u8 v[vgprG2LB+8+32], v[vgprGlobalReadOffsetB+33], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=8, load component 0 */
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
buffer_load_d16_u8 v[vgprG2LB+8+64-256], v[vgprGlobalReadOffsetB+34], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=8, load component 0 */
buffer_load_d16_u8 v[vgprG2LB+8+96-256], v[vgprGlobalReadOffsetB+35], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=9, load component 0 */
s_set_vgpr_msb 16384                               // src0: 0, src1: 0, src2: 0, dst: 0
buffer_load_d16_u8 v[vgprG2LB+9+0], v[vgprGlobalReadOffsetB+36], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=9, load component 0 */
buffer_load_d16_u8 v[vgprG2LB+9+32], v[vgprGlobalReadOffsetB+37], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=9, load component 0 */
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
buffer_load_d16_u8 v[vgprG2LB+9+64-256], v[vgprGlobalReadOffsetB+38], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=9, load component 0 */
buffer_load_d16_u8 v[vgprG2LB+9+96-256], v[vgprGlobalReadOffsetB+39], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=10, load component 0 */
s_set_vgpr_msb 16384                               // src0: 0, src1: 0, src2: 0, dst: 0
buffer_load_d16_u8 v[vgprG2LB+10+0], v[vgprGlobalReadOffsetB+40], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=10, load component 0 */
buffer_load_d16_u8 v[vgprG2LB+10+32], v[vgprGlobalReadOffsetB+41], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=10, load component 0 */
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
buffer_load_d16_u8 v[vgprG2LB+10+64-256], v[vgprGlobalReadOffsetB+42], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=10, load component 0 */
buffer_load_d16_u8 v[vgprG2LB+10+96-256], v[vgprGlobalReadOffsetB+43], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=11, load component 0 */
s_set_vgpr_msb 16384                               // src0: 0, src1: 0, src2: 0, dst: 0
buffer_load_d16_u8 v[vgprG2LB+11+0], v[vgprGlobalReadOffsetB+44], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=11, load component 0 */
buffer_load_d16_u8 v[vgprG2LB+11+32], v[vgprGlobalReadOffsetB+45], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=11, load component 0 */
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
buffer_load_d16_u8 v[vgprG2LB+11+64-256], v[vgprGlobalReadOffsetB+46], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=11, load component 0 */
buffer_load_d16_u8 v[vgprG2LB+11+96-256], v[vgprGlobalReadOffsetB+47], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=12, load component 0 */
s_set_vgpr_msb 16384                               // src0: 0, src1: 0, src2: 0, dst: 0
buffer_load_d16_u8 v[vgprG2LB+12+0], v[vgprGlobalReadOffsetB+48], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=12, load component 0 */
buffer_load_d16_u8 v[vgprG2LB+12+32], v[vgprGlobalReadOffsetB+49], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=12, load component 0 */
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
buffer_load_d16_u8 v[vgprG2LB+12+64-256], v[vgprGlobalReadOffsetB+50], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=12, load component 0 */
buffer_load_d16_u8 v[vgprG2LB+12+96-256], v[vgprGlobalReadOffsetB+51], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=13, load component 0 */
s_set_vgpr_msb 16384                               // src0: 0, src1: 0, src2: 0, dst: 0
buffer_load_d16_u8 v[vgprG2LB+13+0], v[vgprGlobalReadOffsetB+52], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=13, load component 0 */
buffer_load_d16_u8 v[vgprG2LB+13+32], v[vgprGlobalReadOffsetB+53], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=13, load component 0 */
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
buffer_load_d16_u8 v[vgprG2LB+13+64-256], v[vgprGlobalReadOffsetB+54], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=13, load component 0 */
buffer_load_d16_u8 v[vgprG2LB+13+96-256], v[vgprGlobalReadOffsetB+55], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=14, load component 0 */
s_set_vgpr_msb 16384                               // src0: 0, src1: 0, src2: 0, dst: 0
buffer_load_d16_u8 v[vgprG2LB+14+0], v[vgprGlobalReadOffsetB+56], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=14, load component 0 */
buffer_load_d16_u8 v[vgprG2LB+14+32], v[vgprGlobalReadOffsetB+57], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=14, load component 0 */
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
buffer_load_d16_u8 v[vgprG2LB+14+64-256], v[vgprGlobalReadOffsetB+58], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=14, load component 0 */
buffer_load_d16_u8 v[vgprG2LB+14+96-256], v[vgprGlobalReadOffsetB+59], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=15, load component 0 */
s_set_vgpr_msb 16384                               // src0: 0, src1: 0, src2: 0, dst: 0
buffer_load_d16_u8 v[vgprG2LB+15+0], v[vgprGlobalReadOffsetB+60], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=15, load component 0 */
buffer_load_d16_u8 v[vgprG2LB+15+32], v[vgprGlobalReadOffsetB+61], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=15, load component 0 */
s_set_vgpr_msb 64                                  // src0: 0, src1: 0, src2: 0, dst: 1
buffer_load_d16_u8 v[vgprG2LB+15+64-256], v[vgprGlobalReadOffsetB+62], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=15, load component 0 */
buffer_load_d16_u8 v[vgprG2LB+15+96-256], v[vgprGlobalReadOffsetB+63], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
s_wait_loadcnt 0                                   // 2wait for global read
// Skip force waitcnt0
s_barrier_signal -1
s_barrier_wait -1

/* local write a */
s_set_vgpr_msb 16384                               // src0: 0, src1: 0, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+0] offset:0 // lwoA_0_0_0_0 = (0*LSCA)*(MT0I+PAD) + (0*LSPA) = 0 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+16] offset:64 // lwoA_0_0_1_0 = (0*LSCA)*(MT0I+PAD) + (1*LSPA) = 64 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+32] offset:128 // lwoA_0_0_2_0 = (0*LSCA)*(MT0I+PAD) + (2*LSPA) = 128 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+48] offset:192 // lwoA_0_0_3_0 = (0*LSCA)*(MT0I+PAD) + (3*LSPA) = 192 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+1] offset:272 // lwoA_0_0_4_0 = (0*LSCA)*(MT0I+PAD) + (4*LSPA) = 272 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+17] offset:336 // lwoA_0_0_5_0 = (0*LSCA)*(MT0I+PAD) + (5*LSPA) = 336 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+33] offset:400 // lwoA_0_0_6_0 = (0*LSCA)*(MT0I+PAD) + (6*LSPA) = 400 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+49] offset:464 // lwoA_0_0_7_0 = (0*LSCA)*(MT0I+PAD) + (7*LSPA) = 464 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+2] offset:544 // lwoA_0_0_8_0 = (0*LSCA)*(MT0I+PAD) + (8*LSPA) = 544 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+18] offset:608 // lwoA_0_0_9_0 = (0*LSCA)*(MT0I+PAD) + (9*LSPA) = 608 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+34] offset:672 // lwoA_0_0_10_0 = (0*LSCA)*(MT0I+PAD) + (10*LSPA) = 672 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+50] offset:736 // lwoA_0_0_11_0 = (0*LSCA)*(MT0I+PAD) + (11*LSPA) = 736 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+3] offset:816 // lwoA_0_0_12_0 = (0*LSCA)*(MT0I+PAD) + (12*LSPA) = 816 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+19] offset:880 // lwoA_0_0_13_0 = (0*LSCA)*(MT0I+PAD) + (13*LSPA) = 880 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+35] offset:944 // lwoA_0_0_14_0 = (0*LSCA)*(MT0I+PAD) + (14*LSPA) = 944 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+51] offset:1008 // lwoA_0_0_15_0 = (0*LSCA)*(MT0I+PAD) + (15*LSPA) = 1008 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+4] offset:1088 // lwoA_0_0_16_0 = (0*LSCA)*(MT0I+PAD) + (16*LSPA) = 1088 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+20] offset:1152 // lwoA_0_0_17_0 = (0*LSCA)*(MT0I+PAD) + (17*LSPA) = 1152 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+36] offset:1216 // lwoA_0_0_18_0 = (0*LSCA)*(MT0I+PAD) + (18*LSPA) = 1216 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+52] offset:1280 // lwoA_0_0_19_0 = (0*LSCA)*(MT0I+PAD) + (19*LSPA) = 1280 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+5] offset:1360 // lwoA_0_0_20_0 = (0*LSCA)*(MT0I+PAD) + (20*LSPA) = 1360 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+21] offset:1424 // lwoA_0_0_21_0 = (0*LSCA)*(MT0I+PAD) + (21*LSPA) = 1424 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+37] offset:1488 // lwoA_0_0_22_0 = (0*LSCA)*(MT0I+PAD) + (22*LSPA) = 1488 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+53] offset:1552 // lwoA_0_0_23_0 = (0*LSCA)*(MT0I+PAD) + (23*LSPA) = 1552 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+6] offset:1632 // lwoA_0_0_24_0 = (0*LSCA)*(MT0I+PAD) + (24*LSPA) = 1632 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+22] offset:1696 // lwoA_0_0_25_0 = (0*LSCA)*(MT0I+PAD) + (25*LSPA) = 1696 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+38] offset:1760 // lwoA_0_0_26_0 = (0*LSCA)*(MT0I+PAD) + (26*LSPA) = 1760 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+54] offset:1824 // lwoA_0_0_27_0 = (0*LSCA)*(MT0I+PAD) + (27*LSPA) = 1824 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+7] offset:1904 // lwoA_0_0_28_0 = (0*LSCA)*(MT0I+PAD) + (28*LSPA) = 1904 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+23] offset:1968 // lwoA_0_0_29_0 = (0*LSCA)*(MT0I+PAD) + (29*LSPA) = 1968 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+39] offset:2032 // lwoA_0_0_30_0 = (0*LSCA)*(MT0I+PAD) + (30*LSPA) = 2032 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrA+0], v[vgprG2LA+55] offset:2096 // lwoA_0_0_31_0 = (0*LSCA)*(MT0I+PAD) + (31*LSPA) = 2096 sync LDS0

/* local write b */
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+0] offset:0 // lwoB_0_0_0_0 = (0*LSCB) + (0*LSPB)(*MT1J+PAD) = 0 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+32] offset:64 // lwoB_0_0_1_0 = (0*LSCB) + (1*LSPB)(*MT1J+PAD) = 64 sync LDS0
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+64-256] offset:128 // lwoB_0_0_2_0 = (0*LSCB) + (2*LSPB)(*MT1J+PAD) = 128 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+96-256] offset:192 // lwoB_0_0_3_0 = (0*LSCB) + (3*LSPB)(*MT1J+PAD) = 192 sync LDS0
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+1] offset:256 // lwoB_0_0_4_0 = (0*LSCB) + (4*LSPB)(*MT1J+PAD) = 256 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+33] offset:320 // lwoB_0_0_5_0 = (0*LSCB) + (5*LSPB)(*MT1J+PAD) = 320 sync LDS0
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+65-256] offset:384 // lwoB_0_0_6_0 = (0*LSCB) + (6*LSPB)(*MT1J+PAD) = 384 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+97-256] offset:448 // lwoB_0_0_7_0 = (0*LSCB) + (7*LSPB)(*MT1J+PAD) = 448 sync LDS0
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+2] offset:512 // lwoB_0_0_8_0 = (0*LSCB) + (8*LSPB)(*MT1J+PAD) = 512 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+34] offset:576 // lwoB_0_0_9_0 = (0*LSCB) + (9*LSPB)(*MT1J+PAD) = 576 sync LDS0
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+66-256] offset:640 // lwoB_0_0_10_0 = (0*LSCB) + (10*LSPB)(*MT1J+PAD) = 640 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+98-256] offset:704 // lwoB_0_0_11_0 = (0*LSCB) + (11*LSPB)(*MT1J+PAD) = 704 sync LDS0
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+3] offset:768 // lwoB_0_0_12_0 = (0*LSCB) + (12*LSPB)(*MT1J+PAD) = 768 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+35] offset:832 // lwoB_0_0_13_0 = (0*LSCB) + (13*LSPB)(*MT1J+PAD) = 832 sync LDS0
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+67-256] offset:896 // lwoB_0_0_14_0 = (0*LSCB) + (14*LSPB)(*MT1J+PAD) = 896 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+99-256] offset:960 // lwoB_0_0_15_0 = (0*LSCB) + (15*LSPB)(*MT1J+PAD) = 960 sync LDS0
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+4] offset:1056 // lwoB_0_0_16_0 = (0*LSCB) + (16*LSPB)(*MT1J+PAD) = 1056 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+36] offset:1120 // lwoB_0_0_17_0 = (0*LSCB) + (17*LSPB)(*MT1J+PAD) = 1120 sync LDS0
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+68-256] offset:1184 // lwoB_0_0_18_0 = (0*LSCB) + (18*LSPB)(*MT1J+PAD) = 1184 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+100-256] offset:1248 // lwoB_0_0_19_0 = (0*LSCB) + (19*LSPB)(*MT1J+PAD) = 1248 sync LDS0
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+5] offset:1312 // lwoB_0_0_20_0 = (0*LSCB) + (20*LSPB)(*MT1J+PAD) = 1312 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+37] offset:1376 // lwoB_0_0_21_0 = (0*LSCB) + (21*LSPB)(*MT1J+PAD) = 1376 sync LDS0
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+69-256] offset:1440 // lwoB_0_0_22_0 = (0*LSCB) + (22*LSPB)(*MT1J+PAD) = 1440 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+101-256] offset:1504 // lwoB_0_0_23_0 = (0*LSCB) + (23*LSPB)(*MT1J+PAD) = 1504 sync LDS0
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+6] offset:1568 // lwoB_0_0_24_0 = (0*LSCB) + (24*LSPB)(*MT1J+PAD) = 1568 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+38] offset:1632 // lwoB_0_0_25_0 = (0*LSCB) + (25*LSPB)(*MT1J+PAD) = 1632 sync LDS0
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+70-256] offset:1696 // lwoB_0_0_26_0 = (0*LSCB) + (26*LSPB)(*MT1J+PAD) = 1696 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+102-256] offset:1760 // lwoB_0_0_27_0 = (0*LSCB) + (27*LSPB)(*MT1J+PAD) = 1760 sync LDS0
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+7] offset:1824 // lwoB_0_0_28_0 = (0*LSCB) + (28*LSPB)(*MT1J+PAD) = 1824 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+39] offset:1888 // lwoB_0_0_29_0 = (0*LSCB) + (29*LSPB)(*MT1J+PAD) = 1888 sync LDS0
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+71-256] offset:1952 // lwoB_0_0_30_0 = (0*LSCB) + (30*LSPB)(*MT1J+PAD) = 1952 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+103-256] offset:2016 // lwoB_0_0_31_0 = (0*LSCB) + (31*LSPB)(*MT1J+PAD) = 2016 sync LDS0
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+8] offset:2112 // lwoB_0_0_32_0 = (0*LSCB) + (32*LSPB)(*MT1J+PAD) = 2112 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+40] offset:2176 // lwoB_0_0_33_0 = (0*LSCB) + (33*LSPB)(*MT1J+PAD) = 2176 sync LDS0
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+72-256] offset:2240 // lwoB_0_0_34_0 = (0*LSCB) + (34*LSPB)(*MT1J+PAD) = 2240 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+104-256] offset:2304 // lwoB_0_0_35_0 = (0*LSCB) + (35*LSPB)(*MT1J+PAD) = 2304 sync LDS0
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+9] offset:2368 // lwoB_0_0_36_0 = (0*LSCB) + (36*LSPB)(*MT1J+PAD) = 2368 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+41] offset:2432 // lwoB_0_0_37_0 = (0*LSCB) + (37*LSPB)(*MT1J+PAD) = 2432 sync LDS0
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+73-256] offset:2496 // lwoB_0_0_38_0 = (0*LSCB) + (38*LSPB)(*MT1J+PAD) = 2496 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+105-256] offset:2560 // lwoB_0_0_39_0 = (0*LSCB) + (39*LSPB)(*MT1J+PAD) = 2560 sync LDS0
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+10] offset:2624 // lwoB_0_0_40_0 = (0*LSCB) + (40*LSPB)(*MT1J+PAD) = 2624 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+42] offset:2688 // lwoB_0_0_41_0 = (0*LSCB) + (41*LSPB)(*MT1J+PAD) = 2688 sync LDS0
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+74-256] offset:2752 // lwoB_0_0_42_0 = (0*LSCB) + (42*LSPB)(*MT1J+PAD) = 2752 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+106-256] offset:2816 // lwoB_0_0_43_0 = (0*LSCB) + (43*LSPB)(*MT1J+PAD) = 2816 sync LDS0
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+11] offset:2880 // lwoB_0_0_44_0 = (0*LSCB) + (44*LSPB)(*MT1J+PAD) = 2880 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+43] offset:2944 // lwoB_0_0_45_0 = (0*LSCB) + (45*LSPB)(*MT1J+PAD) = 2944 sync LDS0
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+75-256] offset:3008 // lwoB_0_0_46_0 = (0*LSCB) + (46*LSPB)(*MT1J+PAD) = 3008 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+107-256] offset:3072 // lwoB_0_0_47_0 = (0*LSCB) + (47*LSPB)(*MT1J+PAD) = 3072 sync LDS0
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+12] offset:3168 // lwoB_0_0_48_0 = (0*LSCB) + (48*LSPB)(*MT1J+PAD) = 3168 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+44] offset:3232 // lwoB_0_0_49_0 = (0*LSCB) + (49*LSPB)(*MT1J+PAD) = 3232 sync LDS0
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+76-256] offset:3296 // lwoB_0_0_50_0 = (0*LSCB) + (50*LSPB)(*MT1J+PAD) = 3296 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+108-256] offset:3360 // lwoB_0_0_51_0 = (0*LSCB) + (51*LSPB)(*MT1J+PAD) = 3360 sync LDS0
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+13] offset:3424 // lwoB_0_0_52_0 = (0*LSCB) + (52*LSPB)(*MT1J+PAD) = 3424 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+45] offset:3488 // lwoB_0_0_53_0 = (0*LSCB) + (53*LSPB)(*MT1J+PAD) = 3488 sync LDS0
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+77-256] offset:3552 // lwoB_0_0_54_0 = (0*LSCB) + (54*LSPB)(*MT1J+PAD) = 3552 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+109-256] offset:3616 // lwoB_0_0_55_0 = (0*LSCB) + (55*LSPB)(*MT1J+PAD) = 3616 sync LDS0
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+14] offset:3680 // lwoB_0_0_56_0 = (0*LSCB) + (56*LSPB)(*MT1J+PAD) = 3680 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+46] offset:3744 // lwoB_0_0_57_0 = (0*LSCB) + (57*LSPB)(*MT1J+PAD) = 3744 sync LDS0
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+78-256] offset:3808 // lwoB_0_0_58_0 = (0*LSCB) + (58*LSPB)(*MT1J+PAD) = 3808 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+110-256] offset:3872 // lwoB_0_0_59_0 = (0*LSCB) + (59*LSPB)(*MT1J+PAD) = 3872 sync LDS0
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+15] offset:3936 // lwoB_0_0_60_0 = (0*LSCB) + (60*LSPB)(*MT1J+PAD) = 3936 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+47] offset:4000 // lwoB_0_0_61_0 = (0*LSCB) + (61*LSPB)(*MT1J+PAD) = 4000 sync LDS0
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+79-256] offset:4064 // lwoB_0_0_62_0 = (0*LSCB) + (62*LSPB)(*MT1J+PAD) = 4064 sync LDS0
ds_store_b8 v[vgprLocalWriteAddrB+0], v[vgprG2LB+111-256] offset:4128 // lwoB_0_0_63_0 = (0*LSCB) + (63*LSPB)(*MT1J+PAD) = 4128 sync LDS0

/* Recalc local read offsets */
s_wait_dscnt 0                                     // 5wait for local write
// Skip force waitcnt0
s_barrier_signal -1
s_barrier_wait -1                                  // Tail loop LW->LR, sync LDS0
.set vgprG2LA_BASE, UNDEF
.set vgprG2LA, UNDEF
.set vgprG2LB_BASE, UNDEF
.set vgprG2LB, UNDEF
.set vgprValuA_X0_I0_BASE, 132
.set vgprValuA_X0_I0, vgprValuA_X0_I0_BASE+0
.set vgprValuB_X0_I0_BASE, 148
.set vgprValuB_X0_I0, vgprValuB_X0_I0_BASE+0
.set vgprValuB_X0_I0_D0_PACK, 164
.set vgprValuB_X0_I0_D0, vgprValuB_X0_I0_D0_PACK+0
.set vgprValuB_X0_I0_D1, vgprValuB_X0_I0_D0_PACK+1
.set vgprValuB_X0_I0_D2, vgprValuB_X0_I0_D0_PACK+2
.set vgprValuB_X0_I0_D3, vgprValuB_X0_I0_D0_PACK+3
.set vgprValuB_X0_I0_D4, vgprValuB_X0_I0_D0_PACK+4
.set vgprValuB_X0_I0_D5, vgprValuB_X0_I0_D0_PACK+5
.set vgprValuB_X0_I0_D6, vgprValuB_X0_I0_D0_PACK+6
.set vgprValuB_X0_I0_D7, vgprValuB_X0_I0_D0_PACK+7
.set vgprValuB_X0_I0_D8, vgprValuB_X0_I0_D0_PACK+8
.set vgprValuB_X0_I0_D9, vgprValuB_X0_I0_D0_PACK+9
.set vgprValuB_X0_I0_D10, vgprValuB_X0_I0_D0_PACK+10
.set vgprValuB_X0_I0_D11, vgprValuB_X0_I0_D0_PACK+11
.set vgprValuB_X0_I0_D12, vgprValuB_X0_I0_D0_PACK+12
.set vgprValuB_X0_I0_D13, vgprValuB_X0_I0_D0_PACK+13
.set vgprValuB_X0_I0_D14, vgprValuB_X0_I0_D0_PACK+14
.set vgprValuB_X0_I0_D15, vgprValuB_X0_I0_D0_PACK+15
.set vgprValuB_X0_I0_D16, vgprValuB_X0_I0_D0_PACK+16
.set vgprValuB_X0_I0_D17, vgprValuB_X0_I0_D0_PACK+17
.set vgprValuB_X0_I0_D18, vgprValuB_X0_I0_D0_PACK+18
.set vgprValuB_X0_I0_D19, vgprValuB_X0_I0_D0_PACK+19
.set vgprValuB_X0_I0_D20, vgprValuB_X0_I0_D0_PACK+20
.set vgprValuB_X0_I0_D21, vgprValuB_X0_I0_D0_PACK+21
.set vgprValuB_X0_I0_D22, vgprValuB_X0_I0_D0_PACK+22
.set vgprValuB_X0_I0_D23, vgprValuB_X0_I0_D0_PACK+23
.set vgprValuB_X0_I0_D24, vgprValuB_X0_I0_D0_PACK+24
.set vgprValuB_X0_I0_D25, vgprValuB_X0_I0_D0_PACK+25
.set vgprValuB_X0_I0_D26, vgprValuB_X0_I0_D0_PACK+26
.set vgprValuB_X0_I0_D27, vgprValuB_X0_I0_D0_PACK+27
.set vgprValuB_X0_I0_D28, vgprValuB_X0_I0_D0_PACK+28
.set vgprValuB_X0_I0_D29, vgprValuB_X0_I0_D0_PACK+29
.set vgprValuB_X0_I0_D30, vgprValuB_X0_I0_D0_PACK+30
.set vgprValuB_X0_I0_D31, vgprValuB_X0_I0_D0_PACK+31
.set vgprPackTemp, 196

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
ds_load_b128 v[vgprValuA_X0_I0+0:vgprValuA_X0_I0+0+3], v[vgprLocalReadAddrA+0] offset:0 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_b128 v[vgprValuA_X0_I0+4:vgprValuA_X0_I0+4+3], v[vgprLocalReadAddrA+0] offset:32 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=0 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_b128 v[vgprValuA_X0_I0+8:vgprValuA_X0_I0+8+3], v[vgprLocalReadAddrA+0] offset:64 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=1 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_b128 v[vgprValuA_X0_I0+12:vgprValuA_X0_I0+12+3], v[vgprLocalReadAddrA+0] offset:96 // L -> Reg lro=0 swapByteOffset=0 ti=32 vIdx=0 eIdx=1 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS0

/* local read b */
ds_load_u16 v[vgprValuB_X0_I0_D0+0], v[vgprLocalReadAddrB+0] offset:0 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D1+0], v[vgprLocalReadAddrB+0] offset:64 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D2+0], v[vgprLocalReadAddrB+0] offset:128 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=2 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D3+0], v[vgprLocalReadAddrB+0] offset:192 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=3 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D4+0], v[vgprLocalReadAddrB+0] offset:256 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=4 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D5+0], v[vgprLocalReadAddrB+0] offset:320 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=5 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D6+0], v[vgprLocalReadAddrB+0] offset:384 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=6 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D7+0], v[vgprLocalReadAddrB+0] offset:448 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=7 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D8+0], v[vgprLocalReadAddrB+0] offset:512 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=8 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D9+0], v[vgprLocalReadAddrB+0] offset:576 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=9 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D10+0], v[vgprLocalReadAddrB+0] offset:640 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=10 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D11+0], v[vgprLocalReadAddrB+0] offset:704 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=11 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D12+0], v[vgprLocalReadAddrB+0] offset:768 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=12 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D13+0], v[vgprLocalReadAddrB+0] offset:832 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=13 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D14+0], v[vgprLocalReadAddrB+0] offset:896 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=14 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D15+0], v[vgprLocalReadAddrB+0] offset:960 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=15 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D16+0], v[vgprLocalReadAddrB+0] offset:2112 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=16 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D17+0], v[vgprLocalReadAddrB+0] offset:2176 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=17 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D18+0], v[vgprLocalReadAddrB+0] offset:2240 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=18 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D19+0], v[vgprLocalReadAddrB+0] offset:2304 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=19 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D20+0], v[vgprLocalReadAddrB+0] offset:2368 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=20 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D21+0], v[vgprLocalReadAddrB+0] offset:2432 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=21 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D22+0], v[vgprLocalReadAddrB+0] offset:2496 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=22 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D23+0], v[vgprLocalReadAddrB+0] offset:2560 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=23 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D24+0], v[vgprLocalReadAddrB+0] offset:2624 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=24 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D25+0], v[vgprLocalReadAddrB+0] offset:2688 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=25 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D26+0], v[vgprLocalReadAddrB+0] offset:2752 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=26 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D27+0], v[vgprLocalReadAddrB+0] offset:2816 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=27 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D28+0], v[vgprLocalReadAddrB+0] offset:2880 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=28 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D29+0], v[vgprLocalReadAddrB+0] offset:2944 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=29 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D30+0], v[vgprLocalReadAddrB+0] offset:3008 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=30 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u16 v[vgprValuB_X0_I0_D31+0], v[vgprLocalReadAddrB+0] offset:3072 // L -> Reg lro=0 swapByteOffset=0 ti=64 vIdx=0 eIdx=0 rIdx=31 oIdx=0 buffer=0 iui=0 sync LDS0

/* local read inc a */
s_mov_b32 s8, 64                                   // inc
s_wait_alu depctr_vm_vsrc(6)
v_add_co_u32 v[vgprLocalReadAddrA+0], vcc_lo, s8, v[vgprLocalReadAddrA+0] // lrA += 64 (bpeDS)

/* local read inc b */
/* Adding additional 128 pad since cumulative inc has reached 1024 */
s_mov_b32 s8, 4224                                 // inc
s_wait_alu depctr_vm_vsrc(0)
v_add_co_u32 v[vgprLocalReadAddrB+0], vcc_lo, s8, v[vgprLocalReadAddrB+0] // lrB += 4096 ((MT+PAD)*bpeDS)
s_wait_dscnt 0                                     // 4wait for local read
v_perm_b32 v[vgprValuB_X0_I0+0], v[vgprValuB_X0_I0_D1+0], v[vgprValuB_X0_I0_D0+0], s[sgprPackKForV0] // select K=01 for vector=0
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D3+0], v[vgprValuB_X0_I0_D2+0], s[sgprPackKForV0] // select K=23 for vector=0
v_lshl_or_b32 v[vgprValuB_X0_I0+0], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+0] // pack two half Vgpr to one Vgpr
v_perm_b32 v[vgprValuB_X0_I0+1], v[vgprValuB_X0_I0_D5+0], v[vgprValuB_X0_I0_D4+0], s[sgprPackKForV0] // select K=45 for vector=0
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D7+0], v[vgprValuB_X0_I0_D6+0], s[sgprPackKForV0] // select K=67 for vector=0
v_lshl_or_b32 v[vgprValuB_X0_I0+1], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+1] // pack two half Vgpr to one Vgpr
v_perm_b32 v[vgprValuB_X0_I0+2], v[vgprValuB_X0_I0_D9+0], v[vgprValuB_X0_I0_D8+0], s[sgprPackKForV0] // select K=89 for vector=0
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D11+0], v[vgprValuB_X0_I0_D10+0], s[sgprPackKForV0] // select K=1011 for vector=0
v_lshl_or_b32 v[vgprValuB_X0_I0+2], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+2] // pack two half Vgpr to one Vgpr
v_perm_b32 v[vgprValuB_X0_I0+3], v[vgprValuB_X0_I0_D13+0], v[vgprValuB_X0_I0_D12+0], s[sgprPackKForV0] // select K=1213 for vector=0
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D15+0], v[vgprValuB_X0_I0_D14+0], s[sgprPackKForV0] // select K=1415 for vector=0
v_lshl_or_b32 v[vgprValuB_X0_I0+3], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+3] // pack two half Vgpr to one Vgpr
v_perm_b32 v[vgprValuB_X0_I0+4], v[vgprValuB_X0_I0_D17+0], v[vgprValuB_X0_I0_D16+0], s[sgprPackKForV0] // select K=1617 for vector=0
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D19+0], v[vgprValuB_X0_I0_D18+0], s[sgprPackKForV0] // select K=1819 for vector=0
v_lshl_or_b32 v[vgprValuB_X0_I0+4], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+4] // pack two half Vgpr to one Vgpr
v_perm_b32 v[vgprValuB_X0_I0+5], v[vgprValuB_X0_I0_D21+0], v[vgprValuB_X0_I0_D20+0], s[sgprPackKForV0] // select K=2021 for vector=0
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D23+0], v[vgprValuB_X0_I0_D22+0], s[sgprPackKForV0] // select K=2223 for vector=0
v_lshl_or_b32 v[vgprValuB_X0_I0+5], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+5] // pack two half Vgpr to one Vgpr
v_perm_b32 v[vgprValuB_X0_I0+6], v[vgprValuB_X0_I0_D25+0], v[vgprValuB_X0_I0_D24+0], s[sgprPackKForV0] // select K=2425 for vector=0
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D27+0], v[vgprValuB_X0_I0_D26+0], s[sgprPackKForV0] // select K=2627 for vector=0
v_lshl_or_b32 v[vgprValuB_X0_I0+6], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+6] // pack two half Vgpr to one Vgpr
v_perm_b32 v[vgprValuB_X0_I0+7], v[vgprValuB_X0_I0_D29+0], v[vgprValuB_X0_I0_D28+0], s[sgprPackKForV0] // select K=2829 for vector=0
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D31+0], v[vgprValuB_X0_I0_D30+0], s[sgprPackKForV0] // select K=3031 for vector=0
v_lshl_or_b32 v[vgprValuB_X0_I0+7], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+7] // pack two half Vgpr to one Vgpr
v_perm_b32 v[vgprValuB_X0_I0+8], v[vgprValuB_X0_I0_D1+0], v[vgprValuB_X0_I0_D0+0], s[sgprPackKForV1] // select K=01 for vector=1
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D3+0], v[vgprValuB_X0_I0_D2+0], s[sgprPackKForV1] // select K=23 for vector=1
v_lshl_or_b32 v[vgprValuB_X0_I0+8], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+8] // pack two half Vgpr to one Vgpr
v_perm_b32 v[vgprValuB_X0_I0+9], v[vgprValuB_X0_I0_D5+0], v[vgprValuB_X0_I0_D4+0], s[sgprPackKForV1] // select K=45 for vector=1
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D7+0], v[vgprValuB_X0_I0_D6+0], s[sgprPackKForV1] // select K=67 for vector=1
v_lshl_or_b32 v[vgprValuB_X0_I0+9], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+9] // pack two half Vgpr to one Vgpr
v_perm_b32 v[vgprValuB_X0_I0+10], v[vgprValuB_X0_I0_D9+0], v[vgprValuB_X0_I0_D8+0], s[sgprPackKForV1] // select K=89 for vector=1
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D11+0], v[vgprValuB_X0_I0_D10+0], s[sgprPackKForV1] // select K=1011 for vector=1
v_lshl_or_b32 v[vgprValuB_X0_I0+10], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+10] // pack two half Vgpr to one Vgpr
v_perm_b32 v[vgprValuB_X0_I0+11], v[vgprValuB_X0_I0_D13+0], v[vgprValuB_X0_I0_D12+0], s[sgprPackKForV1] // select K=1213 for vector=1
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D15+0], v[vgprValuB_X0_I0_D14+0], s[sgprPackKForV1] // select K=1415 for vector=1
v_lshl_or_b32 v[vgprValuB_X0_I0+11], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+11] // pack two half Vgpr to one Vgpr
v_perm_b32 v[vgprValuB_X0_I0+12], v[vgprValuB_X0_I0_D17+0], v[vgprValuB_X0_I0_D16+0], s[sgprPackKForV1] // select K=1617 for vector=1
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D19+0], v[vgprValuB_X0_I0_D18+0], s[sgprPackKForV1] // select K=1819 for vector=1
v_lshl_or_b32 v[vgprValuB_X0_I0+12], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+12] // pack two half Vgpr to one Vgpr
v_perm_b32 v[vgprValuB_X0_I0+13], v[vgprValuB_X0_I0_D21+0], v[vgprValuB_X0_I0_D20+0], s[sgprPackKForV1] // select K=2021 for vector=1
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D23+0], v[vgprValuB_X0_I0_D22+0], s[sgprPackKForV1] // select K=2223 for vector=1
v_lshl_or_b32 v[vgprValuB_X0_I0+13], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+13] // pack two half Vgpr to one Vgpr
v_perm_b32 v[vgprValuB_X0_I0+14], v[vgprValuB_X0_I0_D25+0], v[vgprValuB_X0_I0_D24+0], s[sgprPackKForV1] // select K=2425 for vector=1
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D27+0], v[vgprValuB_X0_I0_D26+0], s[sgprPackKForV1] // select K=2627 for vector=1
v_lshl_or_b32 v[vgprValuB_X0_I0+14], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+14] // pack two half Vgpr to one Vgpr
v_perm_b32 v[vgprValuB_X0_I0+15], v[vgprValuB_X0_I0_D29+0], v[vgprValuB_X0_I0_D28+0], s[sgprPackKForV1] // select K=2829 for vector=1
v_perm_b32 v[vgprPackTemp], v[vgprValuB_X0_I0_D31+0], v[vgprValuB_X0_I0_D30+0], s[sgprPackKForV1] // select K=3031 for vector=1
v_lshl_or_b32 v[vgprValuB_X0_I0+15], v[vgprPackTemp], 16, v[vgprValuB_X0_I0+15] // pack two half Vgpr to one Vgpr
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_and_b32 v197, 31, v[vgprSerial-256]              // v197 = v[vgprSerial-256] % 32
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_lshrrev_b32 v197, 4, v197                        // 197 = 197 / 16
v_lshlrev_b32 v197, 4, v197                        // v197 = v197 * 16
v_add_nc_u32 v198, v197, 0
v_cmp_ge_i32 s68, v198, s[sgprLoopCounterL]        // check K index >= Size L
v_cndmask_b32 v[vgprValuA_X0_I0+0+0+0+0], v[vgprValuA_X0_I0+0+0+0+0], 0, s68 // set 0 if K_idx >= sizeL
v_cndmask_b32 v[vgprValuA_X0_I0+8+0+0+0], v[vgprValuA_X0_I0+8+0+0+0], 0, s68 // set 0 if K_idx >= sizeL
v_cndmask_b32 v[vgprValuA_X0_I0+0+0+0+1], v[vgprValuA_X0_I0+0+0+0+1], 0, s68 // set 0 if K_idx >= sizeL
v_cndmask_b32 v[vgprValuA_X0_I0+8+0+0+1], v[vgprValuA_X0_I0+8+0+0+1], 0, s68 // set 0 if K_idx >= sizeL
v_add_nc_u32 v198, v198, 8                         // add part of K
v_cmp_ge_i32 s68, v198, s[sgprLoopCounterL]        // check K index >= Size L
v_cndmask_b32 v[vgprValuA_X0_I0+0+0+0+2], v[vgprValuA_X0_I0+0+0+0+2], 0, s68 // set 0 if K_idx >= sizeL
v_cndmask_b32 v[vgprValuA_X0_I0+8+0+0+2], v[vgprValuA_X0_I0+8+0+0+2], 0, s68 // set 0 if K_idx >= sizeL
v_cndmask_b32 v[vgprValuA_X0_I0+0+0+0+3], v[vgprValuA_X0_I0+0+0+0+3], 0, s68 // set 0 if K_idx >= sizeL
v_cndmask_b32 v[vgprValuA_X0_I0+8+0+0+3], v[vgprValuA_X0_I0+8+0+0+3], 0, s68 // set 0 if K_idx >= sizeL
v_add_nc_u32 v198, v198, 24                        // add part of K
v_cmp_ge_i32 s68, v198, s[sgprLoopCounterL]        // check K index >= Size L
v_cndmask_b32 v[vgprValuA_X0_I0+0+0+0+4], v[vgprValuA_X0_I0+0+0+0+4], 0, s68 // set 0 if K_idx >= sizeL
v_cndmask_b32 v[vgprValuA_X0_I0+8+0+0+4], v[vgprValuA_X0_I0+8+0+0+4], 0, s68 // set 0 if K_idx >= sizeL
v_cndmask_b32 v[vgprValuA_X0_I0+0+0+0+5], v[vgprValuA_X0_I0+0+0+0+5], 0, s68 // set 0 if K_idx >= sizeL
v_cndmask_b32 v[vgprValuA_X0_I0+8+0+0+5], v[vgprValuA_X0_I0+8+0+0+5], 0, s68 // set 0 if K_idx >= sizeL
v_add_nc_u32 v198, v198, 8                         // add part of K
v_cmp_ge_i32 s68, v198, s[sgprLoopCounterL]        // check K index >= Size L
v_cndmask_b32 v[vgprValuA_X0_I0+0+0+0+6], v[vgprValuA_X0_I0+0+0+0+6], 0, s68 // set 0 if K_idx >= sizeL
v_cndmask_b32 v[vgprValuA_X0_I0+8+0+0+6], v[vgprValuA_X0_I0+8+0+0+6], 0, s68 // set 0 if K_idx >= sizeL
v_cndmask_b32 v[vgprValuA_X0_I0+0+0+0+7], v[vgprValuA_X0_I0+0+0+0+7], 0, s68 // set 0 if K_idx >= sizeL
v_cndmask_b32 v[vgprValuA_X0_I0+8+0+0+7], v[vgprValuA_X0_I0+8+0+0+7], 0, s68 // set 0 if K_idx >= sizeL
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_and_b32 v197, 31, v[vgprSerial-256]              // v197 = v[vgprSerial-256] % 32
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_lshrrev_b32 v197, 4, v197                        // 197 = 197 / 16
v_lshlrev_b32 v197, 4, v197                        // v197 = v197 * 16
v_add_nc_u32 v198, v197, 0
v_cmp_ge_i32 s68, v198, s[sgprLoopCounterL]        // check K index >= Size L
v_cndmask_b32 v[vgprValuB_X0_I0+0+0+0+0], v[vgprValuB_X0_I0+0+0+0+0], 0, s68 // set 0 if K_idx >= sizeL
v_cndmask_b32 v[vgprValuB_X0_I0+8+0+0+0], v[vgprValuB_X0_I0+8+0+0+0], 0, s68 // set 0 if K_idx >= sizeL
v_cndmask_b32 v[vgprValuB_X0_I0+0+0+0+1], v[vgprValuB_X0_I0+0+0+0+1], 0, s68 // set 0 if K_idx >= sizeL
v_cndmask_b32 v[vgprValuB_X0_I0+8+0+0+1], v[vgprValuB_X0_I0+8+0+0+1], 0, s68 // set 0 if K_idx >= sizeL
v_add_nc_u32 v198, v198, 8                         // add part of K
v_cmp_ge_i32 s68, v198, s[sgprLoopCounterL]        // check K index >= Size L
v_cndmask_b32 v[vgprValuB_X0_I0+0+0+0+2], v[vgprValuB_X0_I0+0+0+0+2], 0, s68 // set 0 if K_idx >= sizeL
v_cndmask_b32 v[vgprValuB_X0_I0+8+0+0+2], v[vgprValuB_X0_I0+8+0+0+2], 0, s68 // set 0 if K_idx >= sizeL
v_cndmask_b32 v[vgprValuB_X0_I0+0+0+0+3], v[vgprValuB_X0_I0+0+0+0+3], 0, s68 // set 0 if K_idx >= sizeL
v_cndmask_b32 v[vgprValuB_X0_I0+8+0+0+3], v[vgprValuB_X0_I0+8+0+0+3], 0, s68 // set 0 if K_idx >= sizeL
v_add_nc_u32 v198, v198, 24                        // add part of K
v_cmp_ge_i32 s68, v198, s[sgprLoopCounterL]        // check K index >= Size L
v_cndmask_b32 v[vgprValuB_X0_I0+0+0+0+4], v[vgprValuB_X0_I0+0+0+0+4], 0, s68 // set 0 if K_idx >= sizeL
v_cndmask_b32 v[vgprValuB_X0_I0+8+0+0+4], v[vgprValuB_X0_I0+8+0+0+4], 0, s68 // set 0 if K_idx >= sizeL
v_cndmask_b32 v[vgprValuB_X0_I0+0+0+0+5], v[vgprValuB_X0_I0+0+0+0+5], 0, s68 // set 0 if K_idx >= sizeL
v_cndmask_b32 v[vgprValuB_X0_I0+8+0+0+5], v[vgprValuB_X0_I0+8+0+0+5], 0, s68 // set 0 if K_idx >= sizeL
v_add_nc_u32 v198, v198, 8                         // add part of K
v_cmp_ge_i32 s68, v198, s[sgprLoopCounterL]        // check K index >= Size L
v_cndmask_b32 v[vgprValuB_X0_I0+0+0+0+6], v[vgprValuB_X0_I0+0+0+0+6], 0, s68 // set 0 if K_idx >= sizeL
v_cndmask_b32 v[vgprValuB_X0_I0+8+0+0+6], v[vgprValuB_X0_I0+8+0+0+6], 0, s68 // set 0 if K_idx >= sizeL
v_cndmask_b32 v[vgprValuB_X0_I0+0+0+0+7], v[vgprValuB_X0_I0+0+0+0+7], 0, s68 // set 0 if K_idx >= sizeL
v_cndmask_b32 v[vgprValuB_X0_I0+8+0+0+7], v[vgprValuB_X0_I0+8+0+0+7], 0, s68 // set 0 if K_idx >= sizeL
s_nop 1
v_wmma_f32_16x16x64_fp8_fp8 v[vgprValuC+0:vgprValuC+0+7], v[vgprValuB_X0_I0+0+0+0:vgprValuB_X0_I0+0+0+0+7], v[vgprValuA_X0_I0+0+0+0:vgprValuA_X0_I0+0+0+0+7], v[vgprValuC+0:vgprValuC+0+7] matrix_a_reuse // left value = v[0+0:7+0]
v_wmma_f32_16x16x64_fp8_fp8 v[vgprValuC+8:vgprValuC+8+7], v[vgprValuB_X0_I0+0+0+0:vgprValuB_X0_I0+0+0+0+7], v[vgprValuA_X0_I0+8+0+0:vgprValuA_X0_I0+8+0+0+7], v[vgprValuC+8:vgprValuC+8+7] // left value = v[8+0:15+0]
v_wmma_f32_16x16x64_fp8_fp8 v[vgprValuC+16:vgprValuC+16+7], v[vgprValuB_X0_I0+8+0+0:vgprValuB_X0_I0+8+0+0+7], v[vgprValuA_X0_I0+0+0+0:vgprValuA_X0_I0+0+0+0+7], v[vgprValuC+16:vgprValuC+16+7] matrix_a_reuse // left value = v[16+0:23+0]
v_wmma_f32_16x16x64_fp8_fp8 v[vgprValuC+24:vgprValuC+24+7], v[vgprValuB_X0_I0+8+0+0:vgprValuB_X0_I0+8+0+0+7], v[vgprValuA_X0_I0+8+0+0:vgprValuA_X0_I0+8+0+0+7], v[vgprValuC+24:vgprValuC+24+7] // left value = v[24+0:31+0]

/* closeLoop loopL finalLoop=1 tailLoop=1 */
s_sub_i32 s[sgprLoopCounterL], s[sgprLoopCounterL], 0x40 // dec counterL (tailLoop)
s_add_u32 s[sgprOrigLoopCounter], s[sgprOrigLoopCounter], 0x40 // inc counterL
s_cmp_le_i32 s[sgprLoopCounterL], 0x0              // counterL<=0
s_cbranch_scc0 label_TailLoopBeginL                // restart LoopL
label_TailLoopEndL:
label_SkipTailLoopL:
.set vgprValuA_X0_I0_BASE, UNDEF
.set vgprValuA_X0_I0, UNDEF
.set vgprValuB_X0_I0_BASE, UNDEF
.set vgprValuB_X0_I0, UNDEF
.set vgprValuB_X0_I0_D0_PACK, UNDEF
.set vgprValuB_X0_I0_D0, UNDEF
.set vgprValuB_X0_I0_D1, UNDEF
.set vgprValuB_X0_I0_D2, UNDEF
.set vgprValuB_X0_I0_D3, UNDEF
.set vgprValuB_X0_I0_D4, UNDEF
.set vgprValuB_X0_I0_D5, UNDEF
.set vgprValuB_X0_I0_D6, UNDEF
.set vgprValuB_X0_I0_D7, UNDEF
.set vgprValuB_X0_I0_D8, UNDEF
.set vgprValuB_X0_I0_D9, UNDEF
.set vgprValuB_X0_I0_D10, UNDEF
.set vgprValuB_X0_I0_D11, UNDEF
.set vgprValuB_X0_I0_D12, UNDEF
.set vgprValuB_X0_I0_D13, UNDEF
.set vgprValuB_X0_I0_D14, UNDEF
.set vgprValuB_X0_I0_D15, UNDEF
.set vgprValuB_X0_I0_D16, UNDEF
.set vgprValuB_X0_I0_D17, UNDEF
.set vgprValuB_X0_I0_D18, UNDEF
.set vgprValuB_X0_I0_D19, UNDEF
.set vgprValuB_X0_I0_D20, UNDEF
.set vgprValuB_X0_I0_D21, UNDEF
.set vgprValuB_X0_I0_D22, UNDEF
.set vgprValuB_X0_I0_D23, UNDEF
.set vgprValuB_X0_I0_D24, UNDEF
.set vgprValuB_X0_I0_D25, UNDEF
.set vgprValuB_X0_I0_D26, UNDEF
.set vgprValuB_X0_I0_D27, UNDEF
.set vgprValuB_X0_I0_D28, UNDEF
.set vgprValuB_X0_I0_D29, UNDEF
.set vgprValuB_X0_I0_D30, UNDEF
.set vgprValuB_X0_I0_D31, UNDEF
.set vgprPackTemp, UNDEF

/* Tail: add MISC Vgpr [32...132) to pool */
label_Summation_End_J5DQFVGFWLXU2DUR:
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
.set sgprPackKForV0, UNDEF
.set sgprPackKForV1, UNDEF
/* load store sgprs */

/* Mapping of Acc register -> C Vgpr register */

/* Multiply MI out register with Alpha -> C Vgpr register */

/* not-LocalSplitU: global write indices */
/* computeStoreVgprs */
s_nop 0
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
s_wait_alu depctr_vm_vsrc(6)
v_lshrrev_b32 v36, 5, v[vgprSerial-256]            // 36 = Serial / 32
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_lshrrev_b32 v37, 0, v36                          // 37 = 36 / 1
v_mul_lo_u32 v37, 0x10, v37                        // wave coordination offset 1
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_and_b32 v33, 31, v[vgprSerial-256]               // v33 = v[vgprSerial-256] % 32
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_lshrrev_b32 v33, 4, v33                          // 33 = 33 / 16
v_lshlrev_b32 v33, 3, v33                          // thread0 * continuous_output
v_add_lshl_u32 v33, v37, v33, 1                    // coordination 1 = vwB *(wave_id1 + tid1)
v_mul_lo_u32 v34, v33, s[sgprStrideC1J]            //  offset 1
v_mul_lo_u32 v35, v33, s[sgprStrideD1J]            //  offset 1
v_and_b32 v32, 0, v36                              // v32 = v36 % 1
v_mul_lo_u32 v32, 0x10, v32                        // wave coordination offset 0
s_set_vgpr_msb 4                                   // src0: 0, src1: 1, src2: 0, dst: 0
v_and_b32 v37, 15, v[vgprSerial-256]               // v37 = v[vgprSerial-256] % 16
s_set_vgpr_msb 1024                                // src0: 0, src1: 0, src2: 0, dst: 0
v_add_lshl_u32 v32, v37, v32, 1                    // coordination 0 = vwA * (wave_id0 + tid0)
s_mul_i32 s8, 32, s[sgprWorkGroup0]                // wgp0 * MT0
v_add_nc_u32 v32, s8, v32                          // coord 0 = (tid0/MI_m)*4 + waveG0*MIB_m + MT0*SG0
s_mul_i32 s8, 64, s[sgprWorkGroup1]                // wgp1 * MT1
v_add_nc_u32 v33, s8, v33                          // coord 1 = (tid0%MI_m) + waveG1*MIB_n + MT1*SG1

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
s_cbranch_scc1 label_GW_B0_FD0_VW2_MB_Else         // jump if edges required

/* Edge/NonEdge store path check (N (isSize1)): Size % 64 > 0 -> Edge store; else -> NonEdge store */
s_and_b32 s24, 63, s[sgprSizeJ]                    // s24 = s[sgprSizeJ] % 64
s_add_u32 s25, -0x1, s[sgprNumWorkGroups1]
s_cmp_ge_u32 s[sgprWorkGroup1], s25                // wg1 >= nwg1-1
s_cselect_b32 s24, s24, 0                          // set rem
s_mov_b32 s8, 0
s_cmp_gt_u32 s24, s8                               // rem > 0
s_cbranch_scc1 label_GW_B0_FD0_VW2_MB_Then         // jump if edges required
label_GW_B0_FD0_VW2_MB_NonEdge:
.set sgprCLSm0Base, 8
.set sgprCLSLoopCounter, 11

/* edge=0, allocate 1 sgpr. perBatchTmpS=1 perBatchMaskS=0 perElementMaskS=0 elementsPerBatch=232 */
/* optSingleColVgpr=1 optSharedColVgpr=0 optSGPRUsage=BufferLoad_Mask optSrdIncForRow=1 factorDim=0 */
/* (d1,vc1,d0,vc0)=(0,0,0,0) */
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_add_lshl_u32 v43, v35, v32, 2                    // optSingleColVgpr scaleToBpe: sharedAddrVgpr <- cinRowPtr + coord0, scaled by BPE. BSHERE:coord0=32, coord0Vgpr=32 (multiple bpe)
s_mov_b32 s12, 0                                   // Init sgpr offset
s_mov_b32 s13, 0                                   // Init sgpr offset
s_mov_b32 s[sgprCLSm0Base], 0x0                    // CLS M0 base = 0
s_mov_b32 s[sgprCLSLoopCounter], 0x1               // CLS loop iter count

/******************************************/
/* Global Write Batch #0 (d1,d0,vc1,vc0) = */
/*    (0,0,0,0:vw2); (0,0,1,0:vw2); (0,0,2,0:vw2); (0,0,3,0:vw2); (0,0,4,0:vw2); (0,0,5,0:vw2); (0,0,6,0:vw2); (0,0,7,0:vw2); (0,0,8,0:vw2); (0,0,9,0:vw2); (0,0,10,0:vw2); (0,0,11,0:vw2); (0,0,12,0:vw2); (0,0,13,0:vw2); (0,0,14,0:vw2); (0,0,15,0:vw2) */
/******************************************/
label_CLS_3:
s_mov_b32 m0, s[sgprCLSm0Base]                     // LDS clamp at sgpr(CLSm0Base)
s_add_u32 s[sgprCLSm0Base], s[sgprCLSm0Base], 1    // CLS M0 step (src coef of CLS iter dim)

/* calc coords, apply mask, and issue loads (if necessary) */
/* (d1,vc1,d0,vc0)=(0,0,0,0) */
/* (d1,vc1,d0,vc0)=(0,1,0,0) */
/* (d1,vc1,d0,vc0)=(0,2,0,0) */
/* (d1,vc1,d0,vc0)=(0,3,0,0) */
/* (d1,vc1,d0,vc0)=(0,4,0,0) */
/* (d1,vc1,d0,vc0)=(0,5,0,0) */
/* (d1,vc1,d0,vc0)=(0,6,0,0) */
/* (d1,vc1,d0,vc0)=(0,7,0,0) */
/* (d1,vc1,d0,vc0)=(0,8,0,0) */
/* (d1,vc1,d0,vc0)=(0,9,0,0) */
/* (d1,vc1,d0,vc0)=(0,10,0,0) */
/* (d1,vc1,d0,vc0)=(0,11,0,0) */
/* (d1,vc1,d0,vc0)=(0,12,0,0) */
/* (d1,vc1,d0,vc0)=(0,13,0,0) */
/* (d1,vc1,d0,vc0)=(0,14,0,0) */
/* (d1,vc1,d0,vc0)=(0,15,0,0) */
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
s_wait_alu depctr_vm_vsrc(6)
v_movrelsd_2_b32 v[vgprValuC+46], v[vgprValuC+0]   // copy MI out reg to vreg[0]
v_movrelsd_2_b32 v[vgprValuC+47], v[vgprValuC+8]   // copy MI out reg to vreg[1]
v_movrelsd_2_b32 v[vgprValuC+48], v[vgprValuC+16]  // copy MI out reg to vreg[2]
v_movrelsd_2_b32 v[vgprValuC+49], v[vgprValuC+24]  // copy MI out reg to vreg[3]
v_movrelsd_2_b32 v[vgprValuC+50], v[vgprValuC+1]   // copy MI out reg to vreg[4]
v_movrelsd_2_b32 v[vgprValuC+51], v[vgprValuC+9]   // copy MI out reg to vreg[5]
v_movrelsd_2_b32 v[vgprValuC+52], v[vgprValuC+17]  // copy MI out reg to vreg[6]
v_movrelsd_2_b32 v[vgprValuC+53], v[vgprValuC+25]  // copy MI out reg to vreg[7]
v_movrelsd_2_b32 v[vgprValuC+54], v[vgprValuC+2]   // copy MI out reg to vreg[8]
v_movrelsd_2_b32 v[vgprValuC+55], v[vgprValuC+10]  // copy MI out reg to vreg[9]
v_movrelsd_2_b32 v[vgprValuC+56], v[vgprValuC+18]  // copy MI out reg to vreg[10]
v_movrelsd_2_b32 v[vgprValuC+57], v[vgprValuC+26]  // copy MI out reg to vreg[11]
v_movrelsd_2_b32 v[vgprValuC+58], v[vgprValuC+3]   // copy MI out reg to vreg[12]
v_movrelsd_2_b32 v[vgprValuC+59], v[vgprValuC+11]  // copy MI out reg to vreg[13]
v_movrelsd_2_b32 v[vgprValuC+60], v[vgprValuC+19]  // copy MI out reg to vreg[14]
v_movrelsd_2_b32 v[vgprValuC+61], v[vgprValuC+27]  // copy MI out reg to vreg[15]
v_movrelsd_2_b32 v[vgprValuC+62], v[vgprValuC+4]   // copy MI out reg to vreg[16]
v_movrelsd_2_b32 v[vgprValuC+63], v[vgprValuC+12]  // copy MI out reg to vreg[17]
v_movrelsd_2_b32 v[vgprValuC+64], v[vgprValuC+20]  // copy MI out reg to vreg[18]
v_movrelsd_2_b32 v[vgprValuC+65], v[vgprValuC+28]  // copy MI out reg to vreg[19]
s_wait_alu depctr_vm_vsrc(5)
v_movrelsd_2_b32 v[vgprValuC+66], v[vgprValuC+5]   // copy MI out reg to vreg[20]
v_movrelsd_2_b32 v[vgprValuC+67], v[vgprValuC+13]  // copy MI out reg to vreg[21]
s_wait_alu depctr_vm_vsrc(4)
v_movrelsd_2_b32 v[vgprValuC+68], v[vgprValuC+21]  // copy MI out reg to vreg[22]
v_movrelsd_2_b32 v[vgprValuC+69], v[vgprValuC+29]  // copy MI out reg to vreg[23]
s_wait_alu depctr_vm_vsrc(3)
v_movrelsd_2_b32 v[vgprValuC+70], v[vgprValuC+6]   // copy MI out reg to vreg[24]
v_movrelsd_2_b32 v[vgprValuC+71], v[vgprValuC+14]  // copy MI out reg to vreg[25]
s_wait_alu depctr_vm_vsrc(2)
v_movrelsd_2_b32 v[vgprValuC+72], v[vgprValuC+22]  // copy MI out reg to vreg[26]
v_movrelsd_2_b32 v[vgprValuC+73], v[vgprValuC+30]  // copy MI out reg to vreg[27]
s_wait_alu depctr_vm_vsrc(1)
v_movrelsd_2_b32 v[vgprValuC+74], v[vgprValuC+7]   // copy MI out reg to vreg[28]
v_movrelsd_2_b32 v[vgprValuC+75], v[vgprValuC+15]  // copy MI out reg to vreg[29]
s_wait_alu depctr_vm_vsrc(0)
v_movrelsd_2_b32 v[vgprValuC+76], v[vgprValuC+23]  // copy MI out reg to vreg[30]
v_movrelsd_2_b32 v[vgprValuC+77], v[vgprValuC+31]  // copy MI out reg to vreg[31]

/* rC *= alpha batchElements=[(0, 0, 0, 0), (0, 0, 1, 0), (0, 0, 2, 0), (0, 0, 3, 0), (0, 0, 4, 0), (0, 0, 5, 0), (0, 0, 6, 0), (0, 0, 7, 0), (0, 0, 8, 0), (0, 0, 9, 0), (0, 0, 10, 0), (0, 0, 11, 0), (0, 0, 12, 0), (0, 0, 13, 0), (0, 0, 14, 0), (0, 0, 15, 0)] */

/* apply mask, calc new C and issue writes */
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s12, s[sgprStrideD1J], 2                // incToNextRow: Scale by BPE
s_wait_alu depctr_va_vdst(14)
buffer_store_b64 v[46:47], v43, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s12, s[sgprStrideD1J], 2                // incToNextRow: Scale by BPE
buffer_store_b64 v[48:49], v43, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s12, s[sgprStrideD1J], 2                // incToNextRow: Scale by BPE
buffer_store_b64 v[50:51], v43, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s12, s[sgprStrideD1J], 2                // incToNextRow: Scale by BPE
buffer_store_b64 v[52:53], v43, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s12, s[sgprStrideD1J], 2                // incToNextRow: Scale by BPE
buffer_store_b64 v[54:55], v43, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s12, s[sgprStrideD1J], 2                // incToNextRow: Scale by BPE
buffer_store_b64 v[56:57], v43, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s12, s[sgprStrideD1J], 2                // incToNextRow: Scale by BPE
buffer_store_b64 v[58:59], v43, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s12, s[sgprStrideD1J], 2                // incToNextRow: Scale by BPE
buffer_store_b64 v[60:61], v43, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s12, s[sgprStrideD1J], 2                // incToNextRow: Scale by BPE
buffer_store_b64 v[62:63], v43, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s12, s[sgprStrideD1J], 2                // incToNextRow: Scale by BPE
s_wait_alu depctr_va_vdst(12)
buffer_store_b64 v[64:65], v43, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s12, s[sgprStrideD1J], 2                // incToNextRow: Scale by BPE
s_wait_alu depctr_va_vdst(10)
buffer_store_b64 v[66:67], v43, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s12, s[sgprStrideD1J], 2                // incToNextRow: Scale by BPE
s_wait_alu depctr_va_vdst(8)
buffer_store_b64 v[68:69], v43, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s12, s[sgprStrideD1J], 2                // incToNextRow: Scale by BPE
s_wait_alu depctr_va_vdst(6)
buffer_store_b64 v[70:71], v43, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s12, s[sgprStrideD1J], 2                // incToNextRow: Scale by BPE
s_wait_alu depctr_va_vdst(4)
buffer_store_b64 v[72:73], v43, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s12, s[sgprStrideD1J], 2                // incToNextRow: Scale by BPE
s_wait_alu depctr_va_vdst(2)
buffer_store_b64 v[74:75], v43, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s12, s[sgprStrideD1J], 2                // incToNextRow: Scale by BPE
s_wait_alu depctr_va_vdst(0)
buffer_store_b64 v[76:77], v43, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_nop 0                                            // 1 wait state required when next inst writes vgprs held by previous dwordx4 store inst
s_sub_i32 s[sgprCLSLoopCounter], s[sgprCLSLoopCounter], 1
s_cmp_eq_u32 s[sgprCLSLoopCounter], 0
s_cbranch_scc1 label_NoBranch_QWMA7J3AUDGL0X23     // Only branch on scc0
// loop while counter != 0
s_getpc_b64 s[24:25]                               // addr of next instr
s_add_i32 s26, label_CLS_3, 4                      // target branch offset
s_abs_i32 s26, s26                                 // abs offset
s_sub_u32 s24, s24, s26                            // sub target branch offset
s_subb_u32 s25, s25, 0                             // sub high and carry
s_setpc_b64 s[24:25]                               // branch to label_CLS_3
label_NoBranch_QWMA7J3AUDGL0X23:
.set sgprCLSLoopCounter, UNDEF
.set sgprCLSm0Base, UNDEF
s_branch label_GW_End_1                            // jump to end
label_GW_B0_FD0_VW2_MB_NonEdgeEnd:
label_GW_B0_FD0_VW2_MB_Then:
.set sgprCLSm0Base, 8
.set sgprCLSLoopCounter, 11

/* edge=1, allocate 3 sgpr. perBatchTmpS=2 perBatchMaskS=1 perElementMaskS=0 elementsPerBatch=155 */
/* optSingleColVgpr=0 optSharedColVgpr=0 optSGPRUsage=BufferLoad_Edge_Mask optSrdIncForRow=0 factorDim=0 */
/* (d1,vc1,d0,vc0)=(0,0,0,0) */
s_mov_b32 s24, 0                                   // Init sgpr offset
s_mov_b32 s25, 0                                   // Init sgpr offset
s_mov_b32 s[sgprCLSm0Base], 0x0                    // CLS M0 base = 0
s_mov_b32 s[sgprCLSLoopCounter], 0x1               // CLS loop iter count

/******************************************/
/* Global Write Edge Batch #0 (d1,d0,vc1,vc0) = */
/*    (0,0,0,0:vw2); (0,0,1,0:vw2); (0,0,2,0:vw2); (0,0,3,0:vw2); (0,0,4,0:vw2); (0,0,5,0:vw2); (0,0,6,0:vw2); (0,0,7,0:vw2); (0,0,8,0:vw2); (0,0,9,0:vw2); (0,0,10,0:vw2); (0,0,11,0:vw2); (0,0,12,0:vw2); (0,0,13,0:vw2); (0,0,14,0:vw2); (0,0,15,0:vw2) */
/******************************************/
label_CLS_2:
s_mov_b32 m0, s[sgprCLSm0Base]                     // LDS clamp at sgpr(CLSm0Base)
s_add_u32 s[sgprCLSm0Base], s[sgprCLSm0Base], 1    // CLS M0 step (src coef of CLS iter dim)

/* calc coords, apply mask, and issue loads (if necessary) */
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v38, BufferOOB
/* (d1,vc1,d0,vc0)=(0,0,0,0) */
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
s_wait_alu depctr_vm_vsrc(6)
v_add_lshl_u32 v43, v35, v32, 2                    // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v43, v38, v43, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_lshl_u32 v76, v35, v32, 2                    // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v76, v38, v76, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_lshl_u32 v77, v35, v32, 2                    // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v77, v38, v77, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_lshl_u32 v78, v35, v32, 2                    // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v78, v38, v78, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,4,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_lshl_u32 v79, v35, v32, 2                    // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v79, v38, v79, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,5,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_lshl_u32 v80, v35, v32, 2                    // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v80, v38, v80, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,6,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_lshl_u32 v81, v35, v32, 2                    // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v81, v38, v81, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,7,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_lshl_u32 v82, v35, v32, 2                    // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v82, v38, v82, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,8,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_lshl_u32 v83, v35, v32, 2                    // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v83, v38, v83, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,9,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_lshl_u32 v84, v35, v32, 2                    // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v84, v38, v84, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,10,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
s_wait_alu depctr_vm_vsrc(5)
v_add_lshl_u32 v85, v35, v32, 2                    // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v85, v38, v85, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,11,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
s_wait_alu depctr_vm_vsrc(4)
v_add_lshl_u32 v86, v35, v32, 2                    // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v86, v38, v86, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,12,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
s_wait_alu depctr_vm_vsrc(3)
v_add_lshl_u32 v87, v35, v32, 2                    // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v87, v38, v87, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,13,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
s_wait_alu depctr_vm_vsrc(2)
v_add_lshl_u32 v88, v35, v32, 2                    // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v88, v38, v88, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,14,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
s_wait_alu depctr_vm_vsrc(1)
v_add_lshl_u32 v89, v35, v32, 2                    // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v89, v38, v89, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,15,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v90, v35, v32, 2                    // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v90, v38, v90, s26                   // LDD clip if OOB. offset
v_movrelsd_2_b32 v[vgprValuC+44], v[vgprValuC+0]   // copy MI out reg to vreg[0]
v_movrelsd_2_b32 v[vgprValuC+45], v[vgprValuC+8]   // copy MI out reg to vreg[1]
v_movrelsd_2_b32 v[vgprValuC+46], v[vgprValuC+16]  // copy MI out reg to vreg[2]
v_movrelsd_2_b32 v[vgprValuC+47], v[vgprValuC+24]  // copy MI out reg to vreg[3]
v_movrelsd_2_b32 v[vgprValuC+48], v[vgprValuC+1]   // copy MI out reg to vreg[4]
v_movrelsd_2_b32 v[vgprValuC+49], v[vgprValuC+9]   // copy MI out reg to vreg[5]
v_movrelsd_2_b32 v[vgprValuC+50], v[vgprValuC+17]  // copy MI out reg to vreg[6]
v_movrelsd_2_b32 v[vgprValuC+51], v[vgprValuC+25]  // copy MI out reg to vreg[7]
v_movrelsd_2_b32 v[vgprValuC+52], v[vgprValuC+2]   // copy MI out reg to vreg[8]
v_movrelsd_2_b32 v[vgprValuC+53], v[vgprValuC+10]  // copy MI out reg to vreg[9]
v_movrelsd_2_b32 v[vgprValuC+54], v[vgprValuC+18]  // copy MI out reg to vreg[10]
v_movrelsd_2_b32 v[vgprValuC+55], v[vgprValuC+26]  // copy MI out reg to vreg[11]
v_movrelsd_2_b32 v[vgprValuC+56], v[vgprValuC+3]   // copy MI out reg to vreg[12]
v_movrelsd_2_b32 v[vgprValuC+57], v[vgprValuC+11]  // copy MI out reg to vreg[13]
v_movrelsd_2_b32 v[vgprValuC+58], v[vgprValuC+19]  // copy MI out reg to vreg[14]
v_movrelsd_2_b32 v[vgprValuC+59], v[vgprValuC+27]  // copy MI out reg to vreg[15]
v_movrelsd_2_b32 v[vgprValuC+60], v[vgprValuC+4]   // copy MI out reg to vreg[16]
v_movrelsd_2_b32 v[vgprValuC+61], v[vgprValuC+12]  // copy MI out reg to vreg[17]
v_movrelsd_2_b32 v[vgprValuC+62], v[vgprValuC+20]  // copy MI out reg to vreg[18]
v_movrelsd_2_b32 v[vgprValuC+63], v[vgprValuC+28]  // copy MI out reg to vreg[19]
v_movrelsd_2_b32 v[vgprValuC+64], v[vgprValuC+5]   // copy MI out reg to vreg[20]
v_movrelsd_2_b32 v[vgprValuC+65], v[vgprValuC+13]  // copy MI out reg to vreg[21]
v_movrelsd_2_b32 v[vgprValuC+66], v[vgprValuC+21]  // copy MI out reg to vreg[22]
v_movrelsd_2_b32 v[vgprValuC+67], v[vgprValuC+29]  // copy MI out reg to vreg[23]
v_movrelsd_2_b32 v[vgprValuC+68], v[vgprValuC+6]   // copy MI out reg to vreg[24]
v_movrelsd_2_b32 v[vgprValuC+69], v[vgprValuC+14]  // copy MI out reg to vreg[25]
v_movrelsd_2_b32 v[vgprValuC+70], v[vgprValuC+22]  // copy MI out reg to vreg[26]
v_movrelsd_2_b32 v[vgprValuC+71], v[vgprValuC+30]  // copy MI out reg to vreg[27]
v_movrelsd_2_b32 v[vgprValuC+72], v[vgprValuC+7]   // copy MI out reg to vreg[28]
v_movrelsd_2_b32 v[vgprValuC+73], v[vgprValuC+15]  // copy MI out reg to vreg[29]
v_movrelsd_2_b32 v[vgprValuC+74], v[vgprValuC+23]  // copy MI out reg to vreg[30]
v_movrelsd_2_b32 v[vgprValuC+75], v[vgprValuC+31]  // copy MI out reg to vreg[31]

/* rC *= alpha batchElements=[(0, 0, 0, 0), (0, 0, 1, 0), (0, 0, 2, 0), (0, 0, 3, 0), (0, 0, 4, 0), (0, 0, 5, 0), (0, 0, 6, 0), (0, 0, 7, 0), (0, 0, 8, 0), (0, 0, 9, 0), (0, 0, 10, 0), (0, 0, 11, 0), (0, 0, 12, 0), (0, 0, 13, 0), (0, 0, 14, 0), (0, 0, 15, 0)] */

/* apply mask, calc new C and issue writes */
s_wait_alu depctr_va_vdst(14)
buffer_store_b64 v[44:45], v43, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b64 v[46:47], v76, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b64 v[48:49], v77, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b64 v[50:51], v78, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b64 v[52:53], v79, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b64 v[54:55], v80, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b64 v[56:57], v81, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b64 v[58:59], v82, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b64 v[60:61], v83, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(12)
buffer_store_b64 v[62:63], v84, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(10)
buffer_store_b64 v[64:65], v85, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(8)
buffer_store_b64 v[66:67], v86, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(6)
buffer_store_b64 v[68:69], v87, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(4)
buffer_store_b64 v[70:71], v88, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(2)
buffer_store_b64 v[72:73], v89, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(0)
buffer_store_b64 v[74:75], v90, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_nop 0                                            // 1 wait state required when next inst writes vgprs held by previous dwordx4 store inst
s_sub_i32 s[sgprCLSLoopCounter], s[sgprCLSLoopCounter], 1
s_cmp_eq_u32 s[sgprCLSLoopCounter], 0
s_cbranch_scc1 label_NoBranch_9N1QELR2XL4Z0HRB     // Only branch on scc0
// loop while counter != 0
s_getpc_b64 s[28:29]                               // addr of next instr
s_add_i32 s30, label_CLS_2, 4                      // target branch offset
s_abs_i32 s30, s30                                 // abs offset
s_sub_u32 s28, s28, s30                            // sub target branch offset
s_subb_u32 s29, s29, 0                             // sub high and carry
s_setpc_b64 s[28:29]                               // branch to label_CLS_2
label_NoBranch_9N1QELR2XL4Z0HRB:
.set sgprCLSLoopCounter, UNDEF
.set sgprCLSm0Base, UNDEF
s_branch label_GW_End_1                            // jump to end
label_GW_B0_FD0_VW2_MB_Else:
label_GW_B0_FD0_VW1_MB_Else:
label_GW_B0_FD0_VW1_MB_Then:
.set sgprCLSm0Base, 8
.set sgprCLSLoopCounter, 11

/* edge=1, allocate 3 sgpr. perBatchTmpS=2 perBatchMaskS=1 perElementMaskS=0 elementsPerBatch=233 */
/* optSingleColVgpr=0 optSharedColVgpr=0 optSGPRUsage=BufferLoad_Edge_Mask optSrdIncForRow=0 factorDim=0 */
/* (d1,vc1,d0,vc0)=(0,0,0,0) */
s_mov_b32 s24, 0                                   // Init sgpr offset
s_mov_b32 s25, 0                                   // Init sgpr offset
s_mov_b32 s[sgprCLSm0Base], 0x0                    // CLS M0 base = 0
s_mov_b32 s[sgprCLSLoopCounter], 0x1               // CLS loop iter count

/******************************************/
/* Global Write Edge Batch #0 (d1,d0,vc1,vc0) = */
/*    (0,0,0,0:vw1); (0,0,0,1:vw1); (0,0,1,0:vw1); (0,0,1,1:vw1); (0,0,2,0:vw1); (0,0,2,1:vw1); (0,0,3,0:vw1); (0,0,3,1:vw1); (0,0,4,0:vw1); (0,0,4,1:vw1); (0,0,5,0:vw1); (0,0,5,1:vw1); (0,0,6,0:vw1); (0,0,6,1:vw1); (0,0,7,0:vw1); (0,0,7,1:vw1); (0,0,8,0:vw1); (0,0,8,1:vw1); (0,0,9,0:vw1); (0,0,9,1:vw1); (0,0,10,0:vw1); (0,0,10,1:vw1); (0,0,11,0:vw1); (0,0,11,1:vw1); (0,0,12,0:vw1); (0,0,12,1:vw1); (0,0,13,0:vw1); (0,0,13,1:vw1); (0,0,14,0:vw1); (0,0,14,1:vw1); (0,0,15,0:vw1); (0,0,15,1:vw1) */
/******************************************/
label_CLS_1:
s_mov_b32 m0, s[sgprCLSm0Base]                     // LDS clamp at sgpr(CLSm0Base)
s_add_u32 s[sgprCLSm0Base], s[sgprCLSm0Base], 1    // CLS M0 step (src coef of CLS iter dim)

/* calc coords, apply mask, and issue loads (if necessary) */
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v38, BufferOOB
/* (d1,vc1,d0,vc0)=(0,0,0,0) */
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
s_wait_alu depctr_vm_vsrc(6)
v_add_lshl_u32 v75, v35, v32, 2                    // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v75, v38, v75, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,0,1) */
v_add_co_u32 v36, vcc_lo, v32, 1                   // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v36, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_lshl_u32 v76, v35, v36, 2                    // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v76, v38, v76, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_lshl_u32 v77, v35, v32, 2                    // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v77, v38, v77, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,0,1) */
v_add_co_u32 v36, vcc_lo, v32, 1                   // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v36, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_lshl_u32 v78, v35, v36, 2                    // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v78, v38, v78, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_lshl_u32 v79, v35, v32, 2                    // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v79, v38, v79, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,0,1) */
v_add_co_u32 v36, vcc_lo, v32, 1                   // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v36, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_lshl_u32 v80, v35, v36, 2                    // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v80, v38, v80, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_lshl_u32 v81, v35, v32, 2                    // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v81, v38, v81, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,0,1) */
v_add_co_u32 v36, vcc_lo, v32, 1                   // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v36, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_lshl_u32 v82, v35, v36, 2                    // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v82, v38, v82, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,4,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_lshl_u32 v83, v35, v32, 2                    // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v83, v38, v83, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,4,0,1) */
v_add_co_u32 v36, vcc_lo, v32, 1                   // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v36, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_lshl_u32 v84, v35, v36, 2                    // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v84, v38, v84, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,5,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_lshl_u32 v85, v35, v32, 2                    // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v85, v38, v85, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,5,0,1) */
v_add_co_u32 v36, vcc_lo, v32, 1                   // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v36, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_lshl_u32 v86, v35, v36, 2                    // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v86, v38, v86, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,6,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_lshl_u32 v87, v35, v32, 2                    // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v87, v38, v87, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,6,0,1) */
v_add_co_u32 v36, vcc_lo, v32, 1                   // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v36, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_lshl_u32 v88, v35, v36, 2                    // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v88, v38, v88, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,7,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_lshl_u32 v89, v35, v32, 2                    // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v89, v38, v89, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,7,0,1) */
v_add_co_u32 v36, vcc_lo, v32, 1                   // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v36, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_lshl_u32 v90, v35, v36, 2                    // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v90, v38, v90, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,8,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_lshl_u32 v91, v35, v32, 2                    // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v91, v38, v91, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,8,0,1) */
v_add_co_u32 v36, vcc_lo, v32, 1                   // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v36, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_lshl_u32 v92, v35, v36, 2                    // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v92, v38, v92, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,9,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_lshl_u32 v93, v35, v32, 2                    // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v93, v38, v93, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,9,0,1) */
v_add_co_u32 v36, vcc_lo, v32, 1                   // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v36, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_lshl_u32 v94, v35, v36, 2                    // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v94, v38, v94, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,10,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_lshl_u32 v95, v35, v32, 2                    // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v95, v38, v95, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,10,0,1) */
v_add_co_u32 v36, vcc_lo, v32, 1                   // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v36, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_lshl_u32 v96, v35, v36, 2                    // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v96, v38, v96, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,11,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_lshl_u32 v97, v35, v32, 2                    // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v97, v38, v97, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,11,0,1) */
v_add_co_u32 v36, vcc_lo, v32, 1                   // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v36, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_lshl_u32 v98, v35, v36, 2                    // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v98, v38, v98, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,12,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_wait_xcnt 0
s_prefetch_inst_pc_rel 0, null, 31
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_lshl_u32 v99, v35, v32, 2                    // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v99, v38, v99, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,12,0,1) */
v_add_co_u32 v36, vcc_lo, v32, 1                   // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v36, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_lshl_u32 v100, v35, v36, 2                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v100, v38, v100, s26                 // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,13,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
s_wait_alu depctr_vm_vsrc(5)
v_add_lshl_u32 v101, v35, v32, 2                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v101, v38, v101, s26                 // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,13,0,1) */
v_add_co_u32 v36, vcc_lo, v32, 1                   // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v36, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
s_wait_alu depctr_vm_vsrc(4)
v_add_lshl_u32 v102, v35, v36, 2                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v102, v38, v102, s26                 // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,14,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
s_wait_alu depctr_vm_vsrc(3)
v_add_lshl_u32 v103, v35, v32, 2                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v103, v38, v103, s26                 // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,14,0,1) */
v_add_co_u32 v36, vcc_lo, v32, 1                   // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v36, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
s_wait_alu depctr_vm_vsrc(2)
v_add_lshl_u32 v104, v35, v36, 2                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v104, v38, v104, s26                 // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,15,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
s_wait_alu depctr_vm_vsrc(1)
v_add_lshl_u32 v105, v35, v32, 2                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v105, v38, v105, s26                 // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,15,0,1) */
v_add_co_u32 v36, vcc_lo, v32, 1                   // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v36, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
s_wait_alu depctr_vm_vsrc(0)
v_add_lshl_u32 v106, v35, v36, 2                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v106, v38, v106, s26                 // LDD clip if OOB. offset
v_movrelsd_2_b32 v[vgprValuC+43], v[vgprValuC+0]   // copy MI out reg to vreg[0]
v_movrelsd_2_b32 v[vgprValuC+44], v[vgprValuC+8]   // copy MI out reg to vreg[1]
v_movrelsd_2_b32 v[vgprValuC+45], v[vgprValuC+16]  // copy MI out reg to vreg[2]
v_movrelsd_2_b32 v[vgprValuC+46], v[vgprValuC+24]  // copy MI out reg to vreg[3]
v_movrelsd_2_b32 v[vgprValuC+47], v[vgprValuC+1]   // copy MI out reg to vreg[4]
v_movrelsd_2_b32 v[vgprValuC+48], v[vgprValuC+9]   // copy MI out reg to vreg[5]
v_movrelsd_2_b32 v[vgprValuC+49], v[vgprValuC+17]  // copy MI out reg to vreg[6]
v_movrelsd_2_b32 v[vgprValuC+50], v[vgprValuC+25]  // copy MI out reg to vreg[7]
v_movrelsd_2_b32 v[vgprValuC+51], v[vgprValuC+2]   // copy MI out reg to vreg[8]
v_movrelsd_2_b32 v[vgprValuC+52], v[vgprValuC+10]  // copy MI out reg to vreg[9]
v_movrelsd_2_b32 v[vgprValuC+53], v[vgprValuC+18]  // copy MI out reg to vreg[10]
v_movrelsd_2_b32 v[vgprValuC+54], v[vgprValuC+26]  // copy MI out reg to vreg[11]
v_movrelsd_2_b32 v[vgprValuC+55], v[vgprValuC+3]   // copy MI out reg to vreg[12]
v_movrelsd_2_b32 v[vgprValuC+56], v[vgprValuC+11]  // copy MI out reg to vreg[13]
v_movrelsd_2_b32 v[vgprValuC+57], v[vgprValuC+19]  // copy MI out reg to vreg[14]
v_movrelsd_2_b32 v[vgprValuC+58], v[vgprValuC+27]  // copy MI out reg to vreg[15]
v_movrelsd_2_b32 v[vgprValuC+59], v[vgprValuC+4]   // copy MI out reg to vreg[16]
v_movrelsd_2_b32 v[vgprValuC+60], v[vgprValuC+12]  // copy MI out reg to vreg[17]
v_movrelsd_2_b32 v[vgprValuC+61], v[vgprValuC+20]  // copy MI out reg to vreg[18]
v_movrelsd_2_b32 v[vgprValuC+62], v[vgprValuC+28]  // copy MI out reg to vreg[19]
v_movrelsd_2_b32 v[vgprValuC+63], v[vgprValuC+5]   // copy MI out reg to vreg[20]
v_movrelsd_2_b32 v[vgprValuC+64], v[vgprValuC+13]  // copy MI out reg to vreg[21]
v_movrelsd_2_b32 v[vgprValuC+65], v[vgprValuC+21]  // copy MI out reg to vreg[22]
v_movrelsd_2_b32 v[vgprValuC+66], v[vgprValuC+29]  // copy MI out reg to vreg[23]
v_movrelsd_2_b32 v[vgprValuC+67], v[vgprValuC+6]   // copy MI out reg to vreg[24]
v_movrelsd_2_b32 v[vgprValuC+68], v[vgprValuC+14]  // copy MI out reg to vreg[25]
v_movrelsd_2_b32 v[vgprValuC+69], v[vgprValuC+22]  // copy MI out reg to vreg[26]
v_movrelsd_2_b32 v[vgprValuC+70], v[vgprValuC+30]  // copy MI out reg to vreg[27]
v_movrelsd_2_b32 v[vgprValuC+71], v[vgprValuC+7]   // copy MI out reg to vreg[28]
v_movrelsd_2_b32 v[vgprValuC+72], v[vgprValuC+15]  // copy MI out reg to vreg[29]
v_movrelsd_2_b32 v[vgprValuC+73], v[vgprValuC+23]  // copy MI out reg to vreg[30]
v_movrelsd_2_b32 v[vgprValuC+74], v[vgprValuC+31]  // copy MI out reg to vreg[31]

/* rC *= alpha batchElements=[(0, 0, 0, 0), (0, 0, 0, 1), (0, 0, 1, 0), (0, 0, 1, 1), (0, 0, 2, 0), (0, 0, 2, 1), (0, 0, 3, 0), (0, 0, 3, 1), (0, 0, 4, 0), (0, 0, 4, 1), (0, 0, 5, 0), (0, 0, 5, 1), (0, 0, 6, 0), (0, 0, 6, 1), (0, 0, 7, 0), (0, 0, 7, 1), (0, 0, 8, 0), (0, 0, 8, 1), (0, 0, 9, 0), (0, 0, 9, 1), (0, 0, 10, 0), (0, 0, 10, 1), (0, 0, 11, 0), (0, 0, 11, 1), (0, 0, 12, 0), (0, 0, 12, 1), (0, 0, 13, 0), (0, 0, 13, 1), (0, 0, 14, 0), (0, 0, 14, 1), (0, 0, 15, 0), (0, 0, 15, 1)] */

/* apply mask, calc new C and issue writes */
s_wait_alu depctr_va_vdst(14)
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
buffer_store_b32 v57, v89, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v58, v90, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v59, v91, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v60, v92, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(13)
buffer_store_b32 v61, v93, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(12)
buffer_store_b32 v62, v94, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(11)
buffer_store_b32 v63, v95, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(10)
buffer_store_b32 v64, v96, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(9)
buffer_store_b32 v65, v97, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(8)
buffer_store_b32 v66, v98, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(7)
buffer_store_b32 v67, v99, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(6)
buffer_store_b32 v68, v100, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(5)
buffer_store_b32 v69, v101, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(4)
buffer_store_b32 v70, v102, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(3)
buffer_store_b32 v71, v103, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(2)
buffer_store_b32 v72, v104, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(1)
buffer_store_b32 v73, v105, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_wait_alu depctr_va_vdst(0)
buffer_store_b32 v74, v106, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_nop 0                                            // 1 wait state required when next inst writes vgprs held by previous dwordx4 store inst
s_sub_i32 s[sgprCLSLoopCounter], s[sgprCLSLoopCounter], 1
s_cmp_eq_u32 s[sgprCLSLoopCounter], 0
s_cbranch_scc1 label_NoBranch_DLSAQLEVYLOBCPNL     // Only branch on scc0
// loop while counter != 0
s_wait_xcnt 0
s_prefetch_inst_pc_rel 0, null, 31
s_getpc_b64 s[28:29]                               // addr of next instr
s_add_i32 s30, label_CLS_1, 4                      // target branch offset
s_abs_i32 s30, s30                                 // abs offset
s_sub_u32 s28, s28, s30                            // sub target branch offset
s_subb_u32 s29, s29, 0                             // sub high and carry
s_setpc_b64 s[28:29]                               // branch to label_CLS_1
label_NoBranch_DLSAQLEVYLOBCPNL:
.set sgprCLSLoopCounter, UNDEF
.set sgprCLSm0Base, UNDEF
s_wait_xcnt 0
s_prefetch_inst_pc_rel 0, null, 31
s_branch label_GW_End_1                            // jump to end
label_GW_End_1:
s_wait_xcnt 0
s_prefetch_inst_pc_rel 0, null, 31
s_getpc_b64 s[24:25]                               // addr of next instr
s_add_i32 s26, label_KernelEnd, 4                  // target branch offset
s_add_u32 s24, s24, s26                            // add target branch offset
s_addc_u32 s25, s25, 0                             // add high and carry
s_setpc_b64 s[24:25]                               // branch to label_KernelEnd
label_GSU_4:
s_wait_xcnt 0
s_prefetch_inst_pc_rel 0, null, 31
s_mov_b32 s11, 0
s_cmp_eq_u32 s[sgprBeta], s11                      // Beta == 0
s_cbranch_scc0 label_GW_B1_GSU1                    // Branch if Beta is not zero

label_GW_B0_GSU1:
label_GW_B0_FD0_GSU1:

/* Edge/NonEdge store path check (M): Size % 32 > 0 -> Edge store; else -> NonEdge store */
s_wait_xcnt 0
s_prefetch_inst_pc_rel 0, null, 31
s_and_b32 s24, 31, s[sgprSizeI]                    // s24 = s[sgprSizeI] % 32
s_add_u32 s25, -0x1, s[sgprNumWorkGroups0]
s_cmp_ge_u32 s[sgprWorkGroup0], s25                // wg0 >= nwg0-1 ?
s_cselect_b32 s24, s24, 0                          // set rem
s_mov_b32 s8, 0
s_cmp_gt_u32 s24, s8                               // rem > 0
s_cbranch_scc1 label_GW_B0_FD0_VW2_GSU1_Else       // jump if edges required

/* Edge/NonEdge store path check (N (isSize1)): Size % 64 > 0 -> Edge store; else -> NonEdge store */
s_wait_xcnt 0
s_prefetch_inst_pc_rel 0, null, 31
s_and_b32 s24, 63, s[sgprSizeJ]                    // s24 = s[sgprSizeJ] % 64
s_add_u32 s25, -0x1, s[sgprNumWorkGroups1]
s_cmp_ge_u32 s[sgprWorkGroup1], s25                // wg1 >= nwg1-1
s_cselect_b32 s24, s24, 0                          // set rem
s_mov_b32 s8, 0
s_cmp_gt_u32 s24, s8                               // rem > 0
s_cbranch_scc1 label_GW_B0_FD0_VW2_GSU1_Then       // jump if edges required
label_GW_B0_FD0_VW2_GSU1_NonEdge:
.set sgprCLSm0Base, 8
.set sgprCLSLoopCounter, 11

/* edge=0, allocate 1 sgpr. perBatchTmpS=1 perBatchMaskS=0 perElementMaskS=0 elementsPerBatch=232 */
/* optSingleColVgpr=1 optSharedColVgpr=0 optSGPRUsage=BufferLoad_Mask optSrdIncForRow=1 factorDim=0 */
/* (d1,vc1,d0,vc0)=(0,0,0,0) */
s_wait_xcnt 0
s_prefetch_inst_pc_rel 0, null, 31
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_add_nc_u32 v43, v35, v32                         // optSingleColVgpr scaleToBpe: sharedAddrVgpr <- cinRowPtr + coord0, scaled by BPE. BSHERE:coord0=32, coord0Vgpr=32 (multiple bpe)
                                                   // optSingleColVgpr scaleToBpe: sharedAddrVgpr <- cinRowPtr + coord0, scaled by BPE. BSHERE:coord0=32, coord0Vgpr=32 (bpe is 1, no mul)
s_mov_b32 s12, 0                                   // Init sgpr offset
s_mov_b32 s13, 0                                   // Init sgpr offset
s_mov_b32 s[sgprCLSm0Base], 0x0                    // CLS M0 base = 0
s_mov_b32 s[sgprCLSLoopCounter], 0x1               // CLS loop iter count

/******************************************/
/* Global Write Batch #0 (d1,d0,vc1,vc0) = */
/*    (0,0,0,0:vw2); (0,0,1,0:vw2); (0,0,2,0:vw2); (0,0,3,0:vw2); (0,0,4,0:vw2); (0,0,5,0:vw2); (0,0,6,0:vw2); (0,0,7,0:vw2); (0,0,8,0:vw2); (0,0,9,0:vw2); (0,0,10,0:vw2); (0,0,11,0:vw2); (0,0,12,0:vw2); (0,0,13,0:vw2); (0,0,14,0:vw2); (0,0,15,0:vw2) */
/******************************************/
label_CLS_9:
s_wait_xcnt 0
s_prefetch_inst_pc_rel 0, null, 31
s_mov_b32 m0, s[sgprCLSm0Base]                     // LDS clamp at sgpr(CLSm0Base)
s_add_u32 s[sgprCLSm0Base], s[sgprCLSm0Base], 1    // CLS M0 step (src coef of CLS iter dim)

/* calc coords, apply mask, and issue loads (if necessary) */
/* (d1,vc1,d0,vc0)=(0,0,0,0) */
/* (d1,vc1,d0,vc0)=(0,1,0,0) */
/* (d1,vc1,d0,vc0)=(0,2,0,0) */
/* (d1,vc1,d0,vc0)=(0,3,0,0) */
/* (d1,vc1,d0,vc0)=(0,4,0,0) */
/* (d1,vc1,d0,vc0)=(0,5,0,0) */
/* (d1,vc1,d0,vc0)=(0,6,0,0) */
/* (d1,vc1,d0,vc0)=(0,7,0,0) */
/* (d1,vc1,d0,vc0)=(0,8,0,0) */
/* (d1,vc1,d0,vc0)=(0,9,0,0) */
/* (d1,vc1,d0,vc0)=(0,10,0,0) */
/* (d1,vc1,d0,vc0)=(0,11,0,0) */
/* (d1,vc1,d0,vc0)=(0,12,0,0) */
/* (d1,vc1,d0,vc0)=(0,13,0,0) */
/* (d1,vc1,d0,vc0)=(0,14,0,0) */
/* (d1,vc1,d0,vc0)=(0,15,0,0) */
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
s_wait_alu depctr_vm_vsrc(6)
v_movrelsd_2_b32 v[vgprValuC+46], v[vgprValuC+0]   // copy MI out reg to vreg[0]
v_movrelsd_2_b32 v[vgprValuC+47], v[vgprValuC+8]   // copy MI out reg to vreg[1]
v_movrelsd_2_b32 v[vgprValuC+48], v[vgprValuC+16]  // copy MI out reg to vreg[2]
v_movrelsd_2_b32 v[vgprValuC+49], v[vgprValuC+24]  // copy MI out reg to vreg[3]
v_movrelsd_2_b32 v[vgprValuC+50], v[vgprValuC+1]   // copy MI out reg to vreg[4]
v_movrelsd_2_b32 v[vgprValuC+51], v[vgprValuC+9]   // copy MI out reg to vreg[5]
v_movrelsd_2_b32 v[vgprValuC+52], v[vgprValuC+17]  // copy MI out reg to vreg[6]
v_movrelsd_2_b32 v[vgprValuC+53], v[vgprValuC+25]  // copy MI out reg to vreg[7]
v_movrelsd_2_b32 v[vgprValuC+54], v[vgprValuC+2]   // copy MI out reg to vreg[8]
v_movrelsd_2_b32 v[vgprValuC+55], v[vgprValuC+10]  // copy MI out reg to vreg[9]
v_movrelsd_2_b32 v[vgprValuC+56], v[vgprValuC+18]  // copy MI out reg to vreg[10]
v_movrelsd_2_b32 v[vgprValuC+57], v[vgprValuC+26]  // copy MI out reg to vreg[11]
v_movrelsd_2_b32 v[vgprValuC+58], v[vgprValuC+3]   // copy MI out reg to vreg[12]
v_movrelsd_2_b32 v[vgprValuC+59], v[vgprValuC+11]  // copy MI out reg to vreg[13]
v_movrelsd_2_b32 v[vgprValuC+60], v[vgprValuC+19]  // copy MI out reg to vreg[14]
v_movrelsd_2_b32 v[vgprValuC+61], v[vgprValuC+27]  // copy MI out reg to vreg[15]
v_movrelsd_2_b32 v[vgprValuC+62], v[vgprValuC+4]   // copy MI out reg to vreg[16]
v_movrelsd_2_b32 v[vgprValuC+63], v[vgprValuC+12]  // copy MI out reg to vreg[17]
v_movrelsd_2_b32 v[vgprValuC+64], v[vgprValuC+20]  // copy MI out reg to vreg[18]
v_movrelsd_2_b32 v[vgprValuC+65], v[vgprValuC+28]  // copy MI out reg to vreg[19]
s_wait_alu depctr_vm_vsrc(5)
v_movrelsd_2_b32 v[vgprValuC+66], v[vgprValuC+5]   // copy MI out reg to vreg[20]
v_movrelsd_2_b32 v[vgprValuC+67], v[vgprValuC+13]  // copy MI out reg to vreg[21]
s_wait_alu depctr_vm_vsrc(4)
v_movrelsd_2_b32 v[vgprValuC+68], v[vgprValuC+21]  // copy MI out reg to vreg[22]
v_movrelsd_2_b32 v[vgprValuC+69], v[vgprValuC+29]  // copy MI out reg to vreg[23]
s_wait_alu depctr_vm_vsrc(3)
v_movrelsd_2_b32 v[vgprValuC+70], v[vgprValuC+6]   // copy MI out reg to vreg[24]
v_movrelsd_2_b32 v[vgprValuC+71], v[vgprValuC+14]  // copy MI out reg to vreg[25]
s_wait_alu depctr_vm_vsrc(2)
v_movrelsd_2_b32 v[vgprValuC+72], v[vgprValuC+22]  // copy MI out reg to vreg[26]
v_movrelsd_2_b32 v[vgprValuC+73], v[vgprValuC+30]  // copy MI out reg to vreg[27]
s_wait_alu depctr_vm_vsrc(1)
v_movrelsd_2_b32 v[vgprValuC+74], v[vgprValuC+7]   // copy MI out reg to vreg[28]
v_movrelsd_2_b32 v[vgprValuC+75], v[vgprValuC+15]  // copy MI out reg to vreg[29]
s_wait_alu depctr_vm_vsrc(0)
v_movrelsd_2_b32 v[vgprValuC+76], v[vgprValuC+23]  // copy MI out reg to vreg[30]
v_movrelsd_2_b32 v[vgprValuC+77], v[vgprValuC+31]  // copy MI out reg to vreg[31]

/* rC *= alpha batchElements=[(0, 0, 0, 0), (0, 0, 1, 0), (0, 0, 2, 0), (0, 0, 3, 0), (0, 0, 4, 0), (0, 0, 5, 0), (0, 0, 6, 0), (0, 0, 7, 0), (0, 0, 8, 0), (0, 0, 9, 0), (0, 0, 10, 0), (0, 0, 11, 0), (0, 0, 12, 0), (0, 0, 13, 0), (0, 0, 14, 0), (0, 0, 15, 0)] */
v_pk_mul_f32 v[vgprValuC+46:vgprValuC+46+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+46:vgprValuC+46+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+48:vgprValuC+48+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+48:vgprValuC+48+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+50:vgprValuC+50+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+50:vgprValuC+50+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+52:vgprValuC+52+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+52:vgprValuC+52+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+54:vgprValuC+54+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+54:vgprValuC+54+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+56:vgprValuC+56+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+56:vgprValuC+56+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+58:vgprValuC+58+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+58:vgprValuC+58+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+60:vgprValuC+60+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+60:vgprValuC+60+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+62:vgprValuC+62+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+62:vgprValuC+62+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+64:vgprValuC+64+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+64:vgprValuC+64+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+66:vgprValuC+66+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+66:vgprValuC+66+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+68:vgprValuC+68+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+68:vgprValuC+68+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+70:vgprValuC+70+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+70:vgprValuC+70+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+72:vgprValuC+72+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+72:vgprValuC+72+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+74:vgprValuC+74+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+74:vgprValuC+74+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+76:vgprValuC+76+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+76:vgprValuC+76+1] op_sel_hi:[0,1,1] // *= alpha (pk)

/* apply mask, calc new C and issue writes */
v_mov_b32 v40, 0x207                               // Nan and +/- inf
v_mov_b32 v42, 0x43E00000                          // Fp8 Max value 448 as float32
v_mov_b32 v41, 0xc3E00000                          // Fp8 Min value -448 as float32
v_cmp_class_f32 s13, v[vgprValuC+46], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+46], v41, v42
v_cndmask_b32 v[vgprValuC+46], v39, v[vgprValuC+46], s13
v_cmp_class_f32 s13, v[vgprValuC+47], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+47], v41, v42
v_cndmask_b32 v[vgprValuC+47], v39, v[vgprValuC+47], s13
v_cvt_pk_fp8_f32 v46, v[vgprValuC+46], v[vgprValuC+47] op_sel:[0,0,0]
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s12, s[sgprStrideD1J], 0                // incToNextRow: Scale by BPE
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v46, v43, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s13, v[vgprValuC+48], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+48], v41, v42
v_cndmask_b32 v[vgprValuC+48], v39, v[vgprValuC+48], s13
v_cmp_class_f32 s13, v[vgprValuC+49], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+49], v41, v42
v_cndmask_b32 v[vgprValuC+49], v39, v[vgprValuC+49], s13
v_cvt_pk_fp8_f32 v48, v[vgprValuC+48], v[vgprValuC+49] op_sel:[0,0,0]
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s12, s[sgprStrideD1J], 0                // incToNextRow: Scale by BPE
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v48, v43, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s13, v[vgprValuC+50], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+50], v41, v42
v_cndmask_b32 v[vgprValuC+50], v39, v[vgprValuC+50], s13
v_cmp_class_f32 s13, v[vgprValuC+51], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+51], v41, v42
v_cndmask_b32 v[vgprValuC+51], v39, v[vgprValuC+51], s13
v_cvt_pk_fp8_f32 v50, v[vgprValuC+50], v[vgprValuC+51] op_sel:[0,0,0]
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s12, s[sgprStrideD1J], 0                // incToNextRow: Scale by BPE
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v50, v43, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s13, v[vgprValuC+52], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+52], v41, v42
v_cndmask_b32 v[vgprValuC+52], v39, v[vgprValuC+52], s13
v_cmp_class_f32 s13, v[vgprValuC+53], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+53], v41, v42
v_cndmask_b32 v[vgprValuC+53], v39, v[vgprValuC+53], s13
v_cvt_pk_fp8_f32 v52, v[vgprValuC+52], v[vgprValuC+53] op_sel:[0,0,0]
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s12, s[sgprStrideD1J], 0                // incToNextRow: Scale by BPE
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v52, v43, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s13, v[vgprValuC+54], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+54], v41, v42
v_cndmask_b32 v[vgprValuC+54], v39, v[vgprValuC+54], s13
v_cmp_class_f32 s13, v[vgprValuC+55], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+55], v41, v42
v_cndmask_b32 v[vgprValuC+55], v39, v[vgprValuC+55], s13
v_cvt_pk_fp8_f32 v54, v[vgprValuC+54], v[vgprValuC+55] op_sel:[0,0,0]
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s12, s[sgprStrideD1J], 0                // incToNextRow: Scale by BPE
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v54, v43, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s13, v[vgprValuC+56], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+56], v41, v42
v_cndmask_b32 v[vgprValuC+56], v39, v[vgprValuC+56], s13
v_cmp_class_f32 s13, v[vgprValuC+57], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+57], v41, v42
v_cndmask_b32 v[vgprValuC+57], v39, v[vgprValuC+57], s13
v_cvt_pk_fp8_f32 v56, v[vgprValuC+56], v[vgprValuC+57] op_sel:[0,0,0]
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s12, s[sgprStrideD1J], 0                // incToNextRow: Scale by BPE
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v56, v43, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s13, v[vgprValuC+58], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+58], v41, v42
v_cndmask_b32 v[vgprValuC+58], v39, v[vgprValuC+58], s13
v_cmp_class_f32 s13, v[vgprValuC+59], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+59], v41, v42
v_cndmask_b32 v[vgprValuC+59], v39, v[vgprValuC+59], s13
v_cvt_pk_fp8_f32 v58, v[vgprValuC+58], v[vgprValuC+59] op_sel:[0,0,0]
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s12, s[sgprStrideD1J], 0                // incToNextRow: Scale by BPE
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v58, v43, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s13, v[vgprValuC+60], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+60], v41, v42
v_cndmask_b32 v[vgprValuC+60], v39, v[vgprValuC+60], s13
v_cmp_class_f32 s13, v[vgprValuC+61], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+61], v41, v42
v_cndmask_b32 v[vgprValuC+61], v39, v[vgprValuC+61], s13
v_cvt_pk_fp8_f32 v60, v[vgprValuC+60], v[vgprValuC+61] op_sel:[0,0,0]
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s12, s[sgprStrideD1J], 0                // incToNextRow: Scale by BPE
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v60, v43, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s13, v[vgprValuC+62], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+62], v41, v42
v_cndmask_b32 v[vgprValuC+62], v39, v[vgprValuC+62], s13
v_cmp_class_f32 s13, v[vgprValuC+63], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+63], v41, v42
v_cndmask_b32 v[vgprValuC+63], v39, v[vgprValuC+63], s13
v_cvt_pk_fp8_f32 v62, v[vgprValuC+62], v[vgprValuC+63] op_sel:[0,0,0]
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s12, s[sgprStrideD1J], 0                // incToNextRow: Scale by BPE
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v62, v43, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s13, v[vgprValuC+64], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+64], v41, v42
v_cndmask_b32 v[vgprValuC+64], v39, v[vgprValuC+64], s13
v_cmp_class_f32 s13, v[vgprValuC+65], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+65], v41, v42
v_cndmask_b32 v[vgprValuC+65], v39, v[vgprValuC+65], s13
v_cvt_pk_fp8_f32 v64, v[vgprValuC+64], v[vgprValuC+65] op_sel:[0,0,0]
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s12, s[sgprStrideD1J], 0                // incToNextRow: Scale by BPE
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v64, v43, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s13, v[vgprValuC+66], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+66], v41, v42
v_cndmask_b32 v[vgprValuC+66], v39, v[vgprValuC+66], s13
v_cmp_class_f32 s13, v[vgprValuC+67], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+67], v41, v42
v_cndmask_b32 v[vgprValuC+67], v39, v[vgprValuC+67], s13
v_cvt_pk_fp8_f32 v66, v[vgprValuC+66], v[vgprValuC+67] op_sel:[0,0,0]
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s12, s[sgprStrideD1J], 0                // incToNextRow: Scale by BPE
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v66, v43, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s13, v[vgprValuC+68], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+68], v41, v42
v_cndmask_b32 v[vgprValuC+68], v39, v[vgprValuC+68], s13
v_cmp_class_f32 s13, v[vgprValuC+69], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+69], v41, v42
v_cndmask_b32 v[vgprValuC+69], v39, v[vgprValuC+69], s13
v_cvt_pk_fp8_f32 v68, v[vgprValuC+68], v[vgprValuC+69] op_sel:[0,0,0]
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s12, s[sgprStrideD1J], 0                // incToNextRow: Scale by BPE
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v68, v43, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s13, v[vgprValuC+70], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+70], v41, v42
v_cndmask_b32 v[vgprValuC+70], v39, v[vgprValuC+70], s13
v_cmp_class_f32 s13, v[vgprValuC+71], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+71], v41, v42
v_cndmask_b32 v[vgprValuC+71], v39, v[vgprValuC+71], s13
v_cvt_pk_fp8_f32 v70, v[vgprValuC+70], v[vgprValuC+71] op_sel:[0,0,0]
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s12, s[sgprStrideD1J], 0                // incToNextRow: Scale by BPE
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v70, v43, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s13, v[vgprValuC+72], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+72], v41, v42
v_cndmask_b32 v[vgprValuC+72], v39, v[vgprValuC+72], s13
v_cmp_class_f32 s13, v[vgprValuC+73], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+73], v41, v42
v_cndmask_b32 v[vgprValuC+73], v39, v[vgprValuC+73], s13
v_cvt_pk_fp8_f32 v72, v[vgprValuC+72], v[vgprValuC+73] op_sel:[0,0,0]
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s12, s[sgprStrideD1J], 0                // incToNextRow: Scale by BPE
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v72, v43, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s13, v[vgprValuC+74], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+74], v41, v42
v_cndmask_b32 v[vgprValuC+74], v39, v[vgprValuC+74], s13
v_cmp_class_f32 s13, v[vgprValuC+75], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+75], v41, v42
v_cndmask_b32 v[vgprValuC+75], v39, v[vgprValuC+75], s13
v_cvt_pk_fp8_f32 v74, v[vgprValuC+74], v[vgprValuC+75] op_sel:[0,0,0]
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s12, s[sgprStrideD1J], 0                // incToNextRow: Scale by BPE
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v74, v43, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s13, v[vgprValuC+76], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+76], v41, v42
v_cndmask_b32 v[vgprValuC+76], v39, v[vgprValuC+76], s13
v_cmp_class_f32 s13, v[vgprValuC+77], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+77], v41, v42
v_cndmask_b32 v[vgprValuC+77], v39, v[vgprValuC+77], s13
v_cvt_pk_fp8_f32 v76, v[vgprValuC+76], v[vgprValuC+77] op_sel:[0,0,0]
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s12, s[sgprStrideD1J], 0                // incToNextRow: Scale by BPE
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v76, v43, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_nop 0                                            // 1 wait state required when next inst writes vgprs held by previous dwordx4 store inst
s_sub_i32 s[sgprCLSLoopCounter], s[sgprCLSLoopCounter], 1
s_cmp_eq_u32 s[sgprCLSLoopCounter], 0
s_cbranch_scc1 label_NoBranch_YZEYGSMMBUPBBI4G     // Only branch on scc0
// loop while counter != 0
s_wait_xcnt 0
s_prefetch_inst_pc_rel 0, null, 31
s_getpc_b64 s[24:25]                               // addr of next instr
s_add_i32 s26, label_CLS_9, 4                      // target branch offset
s_abs_i32 s26, s26                                 // abs offset
s_sub_u32 s24, s24, s26                            // sub target branch offset
s_subb_u32 s25, s25, 0                             // sub high and carry
s_setpc_b64 s[24:25]                               // branch to label_CLS_9
label_NoBranch_YZEYGSMMBUPBBI4G:
.set sgprCLSLoopCounter, UNDEF
.set sgprCLSm0Base, UNDEF
s_wait_xcnt 0
s_prefetch_inst_pc_rel 0, null, 31
s_branch label_GW_End_2                            // jump to end
label_GW_B0_FD0_VW2_GSU1_NonEdgeEnd:
label_GW_B0_FD0_VW2_GSU1_Then:
.set sgprCLSm0Base, 8
.set sgprCLSLoopCounter, 11

/* edge=1, allocate 3 sgpr. perBatchTmpS=2 perBatchMaskS=1 perElementMaskS=0 elementsPerBatch=155 */
/* optSingleColVgpr=0 optSharedColVgpr=0 optSGPRUsage=BufferLoad_Edge_Mask optSrdIncForRow=0 factorDim=0 */
/* (d1,vc1,d0,vc0)=(0,0,0,0) */
s_wait_xcnt 0
s_prefetch_inst_pc_rel 0, null, 31
s_wait_dscnt 0                                     // Wait for LDS write
s_barrier_signal -1
s_barrier_wait -1                                  // LDS write barrier
s_mov_b32 s24, 0                                   // Init sgpr offset
s_mov_b32 s25, 0                                   // Init sgpr offset
s_mov_b32 s[sgprCLSm0Base], 0x0                    // CLS M0 base = 0
s_mov_b32 s[sgprCLSLoopCounter], 0x1               // CLS loop iter count

/******************************************/
/* Global Write Edge Batch #0 (d1,d0,vc1,vc0) = */
/*    (0,0,0,0:vw2); (0,0,1,0:vw2); (0,0,2,0:vw2); (0,0,3,0:vw2); (0,0,4,0:vw2); (0,0,5,0:vw2); (0,0,6,0:vw2); (0,0,7,0:vw2); (0,0,8,0:vw2); (0,0,9,0:vw2); (0,0,10,0:vw2); (0,0,11,0:vw2); (0,0,12,0:vw2); (0,0,13,0:vw2); (0,0,14,0:vw2); (0,0,15,0:vw2) */
/******************************************/
label_CLS_8:
s_wait_xcnt 0
s_prefetch_inst_pc_rel 0, null, 31
s_mov_b32 m0, s[sgprCLSm0Base]                     // LDS clamp at sgpr(CLSm0Base)
s_add_u32 s[sgprCLSm0Base], s[sgprCLSm0Base], 1    // CLS M0 step (src coef of CLS iter dim)

/* calc coords, apply mask, and issue loads (if necessary) */
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v38, BufferOOB
/* (d1,vc1,d0,vc0)=(0,0,0,0) */
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
s_wait_alu depctr_vm_vsrc(6)
v_add_nc_u32 v43, v35, v32                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v43, v38, v43, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v76, v35, v32                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v76, v38, v76, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v77, v35, v32                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v77, v38, v77, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v78, v35, v32                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v78, v38, v78, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,4,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v79, v35, v32                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v79, v38, v79, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,5,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v80, v35, v32                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v80, v38, v80, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,6,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v81, v35, v32                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v81, v38, v81, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,7,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v82, v35, v32                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v82, v38, v82, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,8,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v83, v35, v32                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v83, v38, v83, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,9,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v84, v35, v32                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v84, v38, v84, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,10,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
s_wait_alu depctr_vm_vsrc(5)
v_add_nc_u32 v85, v35, v32                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v85, v38, v85, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,11,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
s_wait_alu depctr_vm_vsrc(4)
v_add_nc_u32 v86, v35, v32                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v86, v38, v86, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,12,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
s_wait_alu depctr_vm_vsrc(3)
v_add_nc_u32 v87, v35, v32                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v87, v38, v87, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,13,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
s_wait_alu depctr_vm_vsrc(2)
v_add_nc_u32 v88, v35, v32                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v88, v38, v88, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,14,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
s_wait_alu depctr_vm_vsrc(1)
v_add_nc_u32 v89, v35, v32                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v89, v38, v89, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,15,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
s_wait_alu depctr_vm_vsrc(0)
v_add_nc_u32 v90, v35, v32                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v90, v38, v90, s26                   // LDD clip if OOB. offset
v_movrelsd_2_b32 v[vgprValuC+44], v[vgprValuC+0]   // copy MI out reg to vreg[0]
v_movrelsd_2_b32 v[vgprValuC+45], v[vgprValuC+8]   // copy MI out reg to vreg[1]
v_movrelsd_2_b32 v[vgprValuC+46], v[vgprValuC+16]  // copy MI out reg to vreg[2]
v_movrelsd_2_b32 v[vgprValuC+47], v[vgprValuC+24]  // copy MI out reg to vreg[3]
v_movrelsd_2_b32 v[vgprValuC+48], v[vgprValuC+1]   // copy MI out reg to vreg[4]
v_movrelsd_2_b32 v[vgprValuC+49], v[vgprValuC+9]   // copy MI out reg to vreg[5]
v_movrelsd_2_b32 v[vgprValuC+50], v[vgprValuC+17]  // copy MI out reg to vreg[6]
v_movrelsd_2_b32 v[vgprValuC+51], v[vgprValuC+25]  // copy MI out reg to vreg[7]
v_movrelsd_2_b32 v[vgprValuC+52], v[vgprValuC+2]   // copy MI out reg to vreg[8]
v_movrelsd_2_b32 v[vgprValuC+53], v[vgprValuC+10]  // copy MI out reg to vreg[9]
v_movrelsd_2_b32 v[vgprValuC+54], v[vgprValuC+18]  // copy MI out reg to vreg[10]
v_movrelsd_2_b32 v[vgprValuC+55], v[vgprValuC+26]  // copy MI out reg to vreg[11]
v_movrelsd_2_b32 v[vgprValuC+56], v[vgprValuC+3]   // copy MI out reg to vreg[12]
v_movrelsd_2_b32 v[vgprValuC+57], v[vgprValuC+11]  // copy MI out reg to vreg[13]
v_movrelsd_2_b32 v[vgprValuC+58], v[vgprValuC+19]  // copy MI out reg to vreg[14]
v_movrelsd_2_b32 v[vgprValuC+59], v[vgprValuC+27]  // copy MI out reg to vreg[15]
v_movrelsd_2_b32 v[vgprValuC+60], v[vgprValuC+4]   // copy MI out reg to vreg[16]
v_movrelsd_2_b32 v[vgprValuC+61], v[vgprValuC+12]  // copy MI out reg to vreg[17]
v_movrelsd_2_b32 v[vgprValuC+62], v[vgprValuC+20]  // copy MI out reg to vreg[18]
v_movrelsd_2_b32 v[vgprValuC+63], v[vgprValuC+28]  // copy MI out reg to vreg[19]
v_movrelsd_2_b32 v[vgprValuC+64], v[vgprValuC+5]   // copy MI out reg to vreg[20]
v_movrelsd_2_b32 v[vgprValuC+65], v[vgprValuC+13]  // copy MI out reg to vreg[21]
v_movrelsd_2_b32 v[vgprValuC+66], v[vgprValuC+21]  // copy MI out reg to vreg[22]
v_movrelsd_2_b32 v[vgprValuC+67], v[vgprValuC+29]  // copy MI out reg to vreg[23]
v_movrelsd_2_b32 v[vgprValuC+68], v[vgprValuC+6]   // copy MI out reg to vreg[24]
v_movrelsd_2_b32 v[vgprValuC+69], v[vgprValuC+14]  // copy MI out reg to vreg[25]
v_movrelsd_2_b32 v[vgprValuC+70], v[vgprValuC+22]  // copy MI out reg to vreg[26]
v_movrelsd_2_b32 v[vgprValuC+71], v[vgprValuC+30]  // copy MI out reg to vreg[27]
v_movrelsd_2_b32 v[vgprValuC+72], v[vgprValuC+7]   // copy MI out reg to vreg[28]
v_movrelsd_2_b32 v[vgprValuC+73], v[vgprValuC+15]  // copy MI out reg to vreg[29]
v_movrelsd_2_b32 v[vgprValuC+74], v[vgprValuC+23]  // copy MI out reg to vreg[30]
v_movrelsd_2_b32 v[vgprValuC+75], v[vgprValuC+31]  // copy MI out reg to vreg[31]

/* rC *= alpha batchElements=[(0, 0, 0, 0), (0, 0, 1, 0), (0, 0, 2, 0), (0, 0, 3, 0), (0, 0, 4, 0), (0, 0, 5, 0), (0, 0, 6, 0), (0, 0, 7, 0), (0, 0, 8, 0), (0, 0, 9, 0), (0, 0, 10, 0), (0, 0, 11, 0), (0, 0, 12, 0), (0, 0, 13, 0), (0, 0, 14, 0), (0, 0, 15, 0)] */
v_pk_mul_f32 v[vgprValuC+44:vgprValuC+44+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+44:vgprValuC+44+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+46:vgprValuC+46+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+46:vgprValuC+46+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+48:vgprValuC+48+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+48:vgprValuC+48+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+50:vgprValuC+50+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+50:vgprValuC+50+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+52:vgprValuC+52+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+52:vgprValuC+52+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+54:vgprValuC+54+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+54:vgprValuC+54+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+56:vgprValuC+56+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+56:vgprValuC+56+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+58:vgprValuC+58+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+58:vgprValuC+58+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+60:vgprValuC+60+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+60:vgprValuC+60+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+62:vgprValuC+62+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+62:vgprValuC+62+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+64:vgprValuC+64+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+64:vgprValuC+64+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+66:vgprValuC+66+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+66:vgprValuC+66+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+68:vgprValuC+68+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+68:vgprValuC+68+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+70:vgprValuC+70+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+70:vgprValuC+70+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+72:vgprValuC+72+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+72:vgprValuC+72+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+74:vgprValuC+74+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+74:vgprValuC+74+1] op_sel_hi:[0,1,1] // *= alpha (pk)

/* apply mask, calc new C and issue writes */
v_mov_b32 v40, 0x207                               // Nan and +/- inf
v_mov_b32 v42, 0x43E00000                          // Fp8 Max value 448 as float32
v_mov_b32 v41, 0xc3E00000                          // Fp8 Min value -448 as float32
v_cmp_class_f32 s12, v[vgprValuC+44], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+44], v41, v42
v_cndmask_b32 v[vgprValuC+44], v39, v[vgprValuC+44], s12
v_cmp_class_f32 s12, v[vgprValuC+45], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+45], v41, v42
v_cndmask_b32 v[vgprValuC+45], v39, v[vgprValuC+45], s12
v_cvt_pk_fp8_f32 v44, v[vgprValuC+44], v[vgprValuC+45] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v44, v43, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s12, v[vgprValuC+46], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+46], v41, v42
v_cndmask_b32 v[vgprValuC+46], v39, v[vgprValuC+46], s12
v_cmp_class_f32 s12, v[vgprValuC+47], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+47], v41, v42
v_cndmask_b32 v[vgprValuC+47], v39, v[vgprValuC+47], s12
v_cvt_pk_fp8_f32 v46, v[vgprValuC+46], v[vgprValuC+47] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v46, v76, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s12, v[vgprValuC+48], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+48], v41, v42
v_cndmask_b32 v[vgprValuC+48], v39, v[vgprValuC+48], s12
v_cmp_class_f32 s12, v[vgprValuC+49], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+49], v41, v42
v_cndmask_b32 v[vgprValuC+49], v39, v[vgprValuC+49], s12
v_cvt_pk_fp8_f32 v48, v[vgprValuC+48], v[vgprValuC+49] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v48, v77, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s12, v[vgprValuC+50], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+50], v41, v42
v_cndmask_b32 v[vgprValuC+50], v39, v[vgprValuC+50], s12
v_cmp_class_f32 s12, v[vgprValuC+51], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+51], v41, v42
v_cndmask_b32 v[vgprValuC+51], v39, v[vgprValuC+51], s12
v_cvt_pk_fp8_f32 v50, v[vgprValuC+50], v[vgprValuC+51] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v50, v78, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s12, v[vgprValuC+52], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+52], v41, v42
v_cndmask_b32 v[vgprValuC+52], v39, v[vgprValuC+52], s12
v_cmp_class_f32 s12, v[vgprValuC+53], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+53], v41, v42
v_cndmask_b32 v[vgprValuC+53], v39, v[vgprValuC+53], s12
v_cvt_pk_fp8_f32 v52, v[vgprValuC+52], v[vgprValuC+53] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v52, v79, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s12, v[vgprValuC+54], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+54], v41, v42
v_cndmask_b32 v[vgprValuC+54], v39, v[vgprValuC+54], s12
v_cmp_class_f32 s12, v[vgprValuC+55], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+55], v41, v42
v_cndmask_b32 v[vgprValuC+55], v39, v[vgprValuC+55], s12
v_cvt_pk_fp8_f32 v54, v[vgprValuC+54], v[vgprValuC+55] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v54, v80, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s12, v[vgprValuC+56], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+56], v41, v42
v_cndmask_b32 v[vgprValuC+56], v39, v[vgprValuC+56], s12
v_cmp_class_f32 s12, v[vgprValuC+57], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+57], v41, v42
v_cndmask_b32 v[vgprValuC+57], v39, v[vgprValuC+57], s12
v_cvt_pk_fp8_f32 v56, v[vgprValuC+56], v[vgprValuC+57] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v56, v81, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s12, v[vgprValuC+58], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+58], v41, v42
v_cndmask_b32 v[vgprValuC+58], v39, v[vgprValuC+58], s12
v_cmp_class_f32 s12, v[vgprValuC+59], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+59], v41, v42
v_cndmask_b32 v[vgprValuC+59], v39, v[vgprValuC+59], s12
v_cvt_pk_fp8_f32 v58, v[vgprValuC+58], v[vgprValuC+59] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v58, v82, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s12, v[vgprValuC+60], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+60], v41, v42
v_cndmask_b32 v[vgprValuC+60], v39, v[vgprValuC+60], s12
v_cmp_class_f32 s12, v[vgprValuC+61], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+61], v41, v42
v_cndmask_b32 v[vgprValuC+61], v39, v[vgprValuC+61], s12
v_cvt_pk_fp8_f32 v60, v[vgprValuC+60], v[vgprValuC+61] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v60, v83, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s12, v[vgprValuC+62], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+62], v41, v42
v_cndmask_b32 v[vgprValuC+62], v39, v[vgprValuC+62], s12
v_cmp_class_f32 s12, v[vgprValuC+63], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+63], v41, v42
v_cndmask_b32 v[vgprValuC+63], v39, v[vgprValuC+63], s12
v_cvt_pk_fp8_f32 v62, v[vgprValuC+62], v[vgprValuC+63] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v62, v84, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s12, v[vgprValuC+64], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+64], v41, v42
v_cndmask_b32 v[vgprValuC+64], v39, v[vgprValuC+64], s12
v_cmp_class_f32 s12, v[vgprValuC+65], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+65], v41, v42
v_cndmask_b32 v[vgprValuC+65], v39, v[vgprValuC+65], s12
v_cvt_pk_fp8_f32 v64, v[vgprValuC+64], v[vgprValuC+65] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v64, v85, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s12, v[vgprValuC+66], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+66], v41, v42
v_cndmask_b32 v[vgprValuC+66], v39, v[vgprValuC+66], s12
v_cmp_class_f32 s12, v[vgprValuC+67], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+67], v41, v42
v_cndmask_b32 v[vgprValuC+67], v39, v[vgprValuC+67], s12
v_cvt_pk_fp8_f32 v66, v[vgprValuC+66], v[vgprValuC+67] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v66, v86, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s12, v[vgprValuC+68], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+68], v41, v42
v_cndmask_b32 v[vgprValuC+68], v39, v[vgprValuC+68], s12
v_cmp_class_f32 s12, v[vgprValuC+69], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+69], v41, v42
v_cndmask_b32 v[vgprValuC+69], v39, v[vgprValuC+69], s12
v_cvt_pk_fp8_f32 v68, v[vgprValuC+68], v[vgprValuC+69] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v68, v87, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s12, v[vgprValuC+70], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+70], v41, v42
v_cndmask_b32 v[vgprValuC+70], v39, v[vgprValuC+70], s12
v_cmp_class_f32 s12, v[vgprValuC+71], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+71], v41, v42
v_cndmask_b32 v[vgprValuC+71], v39, v[vgprValuC+71], s12
v_cvt_pk_fp8_f32 v70, v[vgprValuC+70], v[vgprValuC+71] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v70, v88, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s12, v[vgprValuC+72], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+72], v41, v42
v_cndmask_b32 v[vgprValuC+72], v39, v[vgprValuC+72], s12
v_cmp_class_f32 s12, v[vgprValuC+73], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+73], v41, v42
v_cndmask_b32 v[vgprValuC+73], v39, v[vgprValuC+73], s12
v_cvt_pk_fp8_f32 v72, v[vgprValuC+72], v[vgprValuC+73] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v72, v89, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s12, v[vgprValuC+74], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+74], v41, v42
v_cndmask_b32 v[vgprValuC+74], v39, v[vgprValuC+74], s12
v_cmp_class_f32 s12, v[vgprValuC+75], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+75], v41, v42
v_cndmask_b32 v[vgprValuC+75], v39, v[vgprValuC+75], s12
v_cvt_pk_fp8_f32 v74, v[vgprValuC+74], v[vgprValuC+75] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v74, v90, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_nop 0                                            // 1 wait state required when next inst writes vgprs held by previous dwordx4 store inst
s_sub_i32 s[sgprCLSLoopCounter], s[sgprCLSLoopCounter], 1
s_cmp_eq_u32 s[sgprCLSLoopCounter], 0
s_cbranch_scc1 label_NoBranch_MTO29R7IGT2W9QNN     // Only branch on scc0
// loop while counter != 0
s_wait_xcnt 0
s_prefetch_inst_pc_rel 0, null, 31
s_getpc_b64 s[28:29]                               // addr of next instr
s_add_i32 s30, label_CLS_8, 4                      // target branch offset
s_abs_i32 s30, s30                                 // abs offset
s_sub_u32 s28, s28, s30                            // sub target branch offset
s_subb_u32 s29, s29, 0                             // sub high and carry
s_setpc_b64 s[28:29]                               // branch to label_CLS_8
label_NoBranch_MTO29R7IGT2W9QNN:
.set sgprCLSLoopCounter, UNDEF
.set sgprCLSm0Base, UNDEF
s_wait_xcnt 0
s_prefetch_inst_pc_rel 0, null, 31
s_branch label_GW_End_2                            // jump to end
label_GW_B0_FD0_VW2_GSU1_Else:
label_GW_B0_FD0_VW1_GSU1_Else:
label_GW_B0_FD0_VW1_GSU1_Then:
.set sgprCLSm0Base, 8
.set sgprCLSLoopCounter, 11

/* edge=1, allocate 3 sgpr. perBatchTmpS=2 perBatchMaskS=1 perElementMaskS=0 elementsPerBatch=233 */
/* optSingleColVgpr=0 optSharedColVgpr=0 optSGPRUsage=BufferLoad_Edge_Mask optSrdIncForRow=0 factorDim=0 */
/* (d1,vc1,d0,vc0)=(0,0,0,0) */
s_wait_xcnt 0
s_prefetch_inst_pc_rel 0, null, 31
s_wait_dscnt 0                                     // Wait for LDS write
s_barrier_signal -1
s_barrier_wait -1                                  // LDS write barrier
s_mov_b32 s24, 0                                   // Init sgpr offset
s_mov_b32 s25, 0                                   // Init sgpr offset
s_mov_b32 s[sgprCLSm0Base], 0x0                    // CLS M0 base = 0
s_mov_b32 s[sgprCLSLoopCounter], 0x1               // CLS loop iter count

/******************************************/
/* Global Write Edge Batch #0 (d1,d0,vc1,vc0) = */
/*    (0,0,0,0:vw1); (0,0,0,1:vw1); (0,0,1,0:vw1); (0,0,1,1:vw1); (0,0,2,0:vw1); (0,0,2,1:vw1); (0,0,3,0:vw1); (0,0,3,1:vw1); (0,0,4,0:vw1); (0,0,4,1:vw1); (0,0,5,0:vw1); (0,0,5,1:vw1); (0,0,6,0:vw1); (0,0,6,1:vw1); (0,0,7,0:vw1); (0,0,7,1:vw1); (0,0,8,0:vw1); (0,0,8,1:vw1); (0,0,9,0:vw1); (0,0,9,1:vw1); (0,0,10,0:vw1); (0,0,10,1:vw1); (0,0,11,0:vw1); (0,0,11,1:vw1); (0,0,12,0:vw1); (0,0,12,1:vw1); (0,0,13,0:vw1); (0,0,13,1:vw1); (0,0,14,0:vw1); (0,0,14,1:vw1); (0,0,15,0:vw1); (0,0,15,1:vw1) */
/******************************************/
label_CLS_7:
s_wait_xcnt 0
s_prefetch_inst_pc_rel 0, null, 31
s_mov_b32 m0, s[sgprCLSm0Base]                     // LDS clamp at sgpr(CLSm0Base)
s_add_u32 s[sgprCLSm0Base], s[sgprCLSm0Base], 1    // CLS M0 step (src coef of CLS iter dim)

/* calc coords, apply mask, and issue loads (if necessary) */
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v38, BufferOOB
/* (d1,vc1,d0,vc0)=(0,0,0,0) */
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
s_wait_alu depctr_vm_vsrc(6)
v_add_nc_u32 v75, v35, v32                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v75, v38, v75, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,0,1) */
v_add_co_u32 v36, vcc_lo, v32, 1                   // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v36, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v76, v35, v36                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v76, v38, v76, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v77, v35, v32                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v77, v38, v77, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,0,1) */
v_add_co_u32 v36, vcc_lo, v32, 1                   // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v36, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v78, v35, v36                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v78, v38, v78, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v79, v35, v32                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v79, v38, v79, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,0,1) */
v_add_co_u32 v36, vcc_lo, v32, 1                   // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v36, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v80, v35, v36                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v80, v38, v80, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v81, v35, v32                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v81, v38, v81, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,0,1) */
v_add_co_u32 v36, vcc_lo, v32, 1                   // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v36, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v82, v35, v36                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v82, v38, v82, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,4,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v83, v35, v32                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v83, v38, v83, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,4,0,1) */
v_add_co_u32 v36, vcc_lo, v32, 1                   // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v36, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v84, v35, v36                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v84, v38, v84, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,5,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v85, v35, v32                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v85, v38, v85, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,5,0,1) */
v_add_co_u32 v36, vcc_lo, v32, 1                   // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v36, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v86, v35, v36                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v86, v38, v86, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,6,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v87, v35, v32                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v87, v38, v87, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,6,0,1) */
v_add_co_u32 v36, vcc_lo, v32, 1                   // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v36, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v88, v35, v36                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v88, v38, v88, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,7,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v89, v35, v32                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v89, v38, v89, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,7,0,1) */
v_add_co_u32 v36, vcc_lo, v32, 1                   // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v36, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v90, v35, v36                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v90, v38, v90, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,8,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v91, v35, v32                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v91, v38, v91, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,8,0,1) */
v_add_co_u32 v36, vcc_lo, v32, 1                   // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v36, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v92, v35, v36                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v92, v38, v92, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,9,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v93, v35, v32                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v93, v38, v93, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,9,0,1) */
v_add_co_u32 v36, vcc_lo, v32, 1                   // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v36, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v94, v35, v36                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v94, v38, v94, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,10,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v95, v35, v32                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v95, v38, v95, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,10,0,1) */
v_add_co_u32 v36, vcc_lo, v32, 1                   // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v36, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v96, v35, v36                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v96, v38, v96, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,11,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v97, v35, v32                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v97, v38, v97, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,11,0,1) */
v_add_co_u32 v36, vcc_lo, v32, 1                   // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v36, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v98, v35, v36                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v98, v38, v98, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,12,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v99, v35, v32                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v99, v38, v99, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,12,0,1) */
v_add_co_u32 v36, vcc_lo, v32, 1                   // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v36, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v100, v35, v36                        // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v100, v38, v100, s26                 // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,13,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
s_wait_alu depctr_vm_vsrc(5)
v_add_nc_u32 v101, v35, v32                        // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v101, v38, v101, s26                 // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,13,0,1) */
v_add_co_u32 v36, vcc_lo, v32, 1                   // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v36, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
s_wait_alu depctr_vm_vsrc(4)
v_add_nc_u32 v102, v35, v36                        // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v102, v38, v102, s26                 // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,14,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
s_wait_alu depctr_vm_vsrc(3)
v_add_nc_u32 v103, v35, v32                        // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v103, v38, v103, s26                 // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,14,0,1) */
v_add_co_u32 v36, vcc_lo, v32, 1                   // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v36, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
s_wait_alu depctr_vm_vsrc(2)
v_add_nc_u32 v104, v35, v36                        // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v104, v38, v104, s26                 // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,15,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
s_wait_alu depctr_vm_vsrc(1)
v_add_nc_u32 v105, v35, v32                        // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v105, v38, v105, s26                 // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,15,0,1) */
v_add_co_u32 v36, vcc_lo, v32, 1                   // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v36, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
s_wait_alu depctr_vm_vsrc(0)
v_add_nc_u32 v106, v35, v36                        // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v106, v38, v106, s26                 // LDD clip if OOB. offset
v_movrelsd_2_b32 v[vgprValuC+43], v[vgprValuC+0]   // copy MI out reg to vreg[0]
v_movrelsd_2_b32 v[vgprValuC+44], v[vgprValuC+8]   // copy MI out reg to vreg[1]
v_movrelsd_2_b32 v[vgprValuC+45], v[vgprValuC+16]  // copy MI out reg to vreg[2]
v_movrelsd_2_b32 v[vgprValuC+46], v[vgprValuC+24]  // copy MI out reg to vreg[3]
v_movrelsd_2_b32 v[vgprValuC+47], v[vgprValuC+1]   // copy MI out reg to vreg[4]
v_movrelsd_2_b32 v[vgprValuC+48], v[vgprValuC+9]   // copy MI out reg to vreg[5]
v_movrelsd_2_b32 v[vgprValuC+49], v[vgprValuC+17]  // copy MI out reg to vreg[6]
v_movrelsd_2_b32 v[vgprValuC+50], v[vgprValuC+25]  // copy MI out reg to vreg[7]
v_movrelsd_2_b32 v[vgprValuC+51], v[vgprValuC+2]   // copy MI out reg to vreg[8]
v_movrelsd_2_b32 v[vgprValuC+52], v[vgprValuC+10]  // copy MI out reg to vreg[9]
v_movrelsd_2_b32 v[vgprValuC+53], v[vgprValuC+18]  // copy MI out reg to vreg[10]
v_movrelsd_2_b32 v[vgprValuC+54], v[vgprValuC+26]  // copy MI out reg to vreg[11]
v_movrelsd_2_b32 v[vgprValuC+55], v[vgprValuC+3]   // copy MI out reg to vreg[12]
v_movrelsd_2_b32 v[vgprValuC+56], v[vgprValuC+11]  // copy MI out reg to vreg[13]
v_movrelsd_2_b32 v[vgprValuC+57], v[vgprValuC+19]  // copy MI out reg to vreg[14]
v_movrelsd_2_b32 v[vgprValuC+58], v[vgprValuC+27]  // copy MI out reg to vreg[15]
v_movrelsd_2_b32 v[vgprValuC+59], v[vgprValuC+4]   // copy MI out reg to vreg[16]
v_movrelsd_2_b32 v[vgprValuC+60], v[vgprValuC+12]  // copy MI out reg to vreg[17]
v_movrelsd_2_b32 v[vgprValuC+61], v[vgprValuC+20]  // copy MI out reg to vreg[18]
v_movrelsd_2_b32 v[vgprValuC+62], v[vgprValuC+28]  // copy MI out reg to vreg[19]
v_movrelsd_2_b32 v[vgprValuC+63], v[vgprValuC+5]   // copy MI out reg to vreg[20]
v_movrelsd_2_b32 v[vgprValuC+64], v[vgprValuC+13]  // copy MI out reg to vreg[21]
v_movrelsd_2_b32 v[vgprValuC+65], v[vgprValuC+21]  // copy MI out reg to vreg[22]
v_movrelsd_2_b32 v[vgprValuC+66], v[vgprValuC+29]  // copy MI out reg to vreg[23]
v_movrelsd_2_b32 v[vgprValuC+67], v[vgprValuC+6]   // copy MI out reg to vreg[24]
v_movrelsd_2_b32 v[vgprValuC+68], v[vgprValuC+14]  // copy MI out reg to vreg[25]
v_movrelsd_2_b32 v[vgprValuC+69], v[vgprValuC+22]  // copy MI out reg to vreg[26]
v_movrelsd_2_b32 v[vgprValuC+70], v[vgprValuC+30]  // copy MI out reg to vreg[27]
v_movrelsd_2_b32 v[vgprValuC+71], v[vgprValuC+7]   // copy MI out reg to vreg[28]
v_movrelsd_2_b32 v[vgprValuC+72], v[vgprValuC+15]  // copy MI out reg to vreg[29]
v_movrelsd_2_b32 v[vgprValuC+73], v[vgprValuC+23]  // copy MI out reg to vreg[30]
v_movrelsd_2_b32 v[vgprValuC+74], v[vgprValuC+31]  // copy MI out reg to vreg[31]

/* rC *= alpha batchElements=[(0, 0, 0, 0), (0, 0, 0, 1), (0, 0, 1, 0), (0, 0, 1, 1), (0, 0, 2, 0), (0, 0, 2, 1), (0, 0, 3, 0), (0, 0, 3, 1), (0, 0, 4, 0), (0, 0, 4, 1), (0, 0, 5, 0), (0, 0, 5, 1), (0, 0, 6, 0), (0, 0, 6, 1), (0, 0, 7, 0), (0, 0, 7, 1), (0, 0, 8, 0), (0, 0, 8, 1), (0, 0, 9, 0), (0, 0, 9, 1), (0, 0, 10, 0), (0, 0, 10, 1), (0, 0, 11, 0), (0, 0, 11, 1), (0, 0, 12, 0), (0, 0, 12, 1), (0, 0, 13, 0), (0, 0, 13, 1), (0, 0, 14, 0), (0, 0, 14, 1), (0, 0, 15, 0), (0, 0, 15, 1)] */
v_mul_f32 v[vgprValuC+43], s[sgprAlpha], v[vgprValuC+43] // *= alpha
v_pk_mul_f32 v[vgprValuC+44:vgprValuC+44+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+44:vgprValuC+44+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+46:vgprValuC+46+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+46:vgprValuC+46+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+48:vgprValuC+48+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+48:vgprValuC+48+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+50:vgprValuC+50+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+50:vgprValuC+50+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+52:vgprValuC+52+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+52:vgprValuC+52+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+54:vgprValuC+54+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+54:vgprValuC+54+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+56:vgprValuC+56+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+56:vgprValuC+56+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+58:vgprValuC+58+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+58:vgprValuC+58+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+60:vgprValuC+60+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+60:vgprValuC+60+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+62:vgprValuC+62+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+62:vgprValuC+62+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+64:vgprValuC+64+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+64:vgprValuC+64+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+66:vgprValuC+66+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+66:vgprValuC+66+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+68:vgprValuC+68+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+68:vgprValuC+68+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+70:vgprValuC+70+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+70:vgprValuC+70+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+72:vgprValuC+72+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+72:vgprValuC+72+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_mul_f32 v[vgprValuC+74], s[sgprAlpha], v[vgprValuC+74] // *= alpha

/* apply mask, calc new C and issue writes */
v_mov_b32 v40, 0x207                               // Nan and +/- inf
v_mov_b32 v42, 0x43E00000                          // Fp8 Max value 448 as float32
v_mov_b32 v41, 0xc3E00000                          // Fp8 Min value -448 as float32
v_cmp_class_f32 s12, v[vgprValuC+43], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+43], v41, v42
v_cndmask_b32 v[vgprValuC+43], v39, v[vgprValuC+43], s12
v_cvt_pk_fp8_f32 v43, v[vgprValuC+43], v[vgprValuC+43] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v43, v75, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s12, v[vgprValuC+44], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+44], v41, v42
v_cndmask_b32 v[vgprValuC+44], v39, v[vgprValuC+44], s12
v_cvt_pk_fp8_f32 v44, v[vgprValuC+44], v[vgprValuC+44] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v44, v76, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s12, v[vgprValuC+45], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+45], v41, v42
v_cndmask_b32 v[vgprValuC+45], v39, v[vgprValuC+45], s12
v_cvt_pk_fp8_f32 v45, v[vgprValuC+45], v[vgprValuC+45] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v45, v77, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s12, v[vgprValuC+46], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+46], v41, v42
v_cndmask_b32 v[vgprValuC+46], v39, v[vgprValuC+46], s12
v_cvt_pk_fp8_f32 v46, v[vgprValuC+46], v[vgprValuC+46] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v46, v78, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s12, v[vgprValuC+47], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+47], v41, v42
v_cndmask_b32 v[vgprValuC+47], v39, v[vgprValuC+47], s12
v_cvt_pk_fp8_f32 v47, v[vgprValuC+47], v[vgprValuC+47] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v47, v79, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s12, v[vgprValuC+48], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+48], v41, v42
v_cndmask_b32 v[vgprValuC+48], v39, v[vgprValuC+48], s12
v_cvt_pk_fp8_f32 v48, v[vgprValuC+48], v[vgprValuC+48] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v48, v80, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s12, v[vgprValuC+49], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+49], v41, v42
v_cndmask_b32 v[vgprValuC+49], v39, v[vgprValuC+49], s12
v_cvt_pk_fp8_f32 v49, v[vgprValuC+49], v[vgprValuC+49] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v49, v81, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s12, v[vgprValuC+50], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+50], v41, v42
v_cndmask_b32 v[vgprValuC+50], v39, v[vgprValuC+50], s12
v_cvt_pk_fp8_f32 v50, v[vgprValuC+50], v[vgprValuC+50] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v50, v82, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s12, v[vgprValuC+51], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+51], v41, v42
v_cndmask_b32 v[vgprValuC+51], v39, v[vgprValuC+51], s12
v_cvt_pk_fp8_f32 v51, v[vgprValuC+51], v[vgprValuC+51] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v51, v83, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s12, v[vgprValuC+52], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+52], v41, v42
v_cndmask_b32 v[vgprValuC+52], v39, v[vgprValuC+52], s12
v_cvt_pk_fp8_f32 v52, v[vgprValuC+52], v[vgprValuC+52] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v52, v84, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s12, v[vgprValuC+53], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+53], v41, v42
v_cndmask_b32 v[vgprValuC+53], v39, v[vgprValuC+53], s12
v_cvt_pk_fp8_f32 v53, v[vgprValuC+53], v[vgprValuC+53] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v53, v85, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s12, v[vgprValuC+54], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+54], v41, v42
v_cndmask_b32 v[vgprValuC+54], v39, v[vgprValuC+54], s12
v_cvt_pk_fp8_f32 v54, v[vgprValuC+54], v[vgprValuC+54] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v54, v86, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s12, v[vgprValuC+55], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+55], v41, v42
v_cndmask_b32 v[vgprValuC+55], v39, v[vgprValuC+55], s12
v_cvt_pk_fp8_f32 v55, v[vgprValuC+55], v[vgprValuC+55] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v55, v87, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s12, v[vgprValuC+56], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+56], v41, v42
v_cndmask_b32 v[vgprValuC+56], v39, v[vgprValuC+56], s12
v_cvt_pk_fp8_f32 v56, v[vgprValuC+56], v[vgprValuC+56] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v56, v88, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s12, v[vgprValuC+57], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+57], v41, v42
v_cndmask_b32 v[vgprValuC+57], v39, v[vgprValuC+57], s12
v_cvt_pk_fp8_f32 v57, v[vgprValuC+57], v[vgprValuC+57] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v57, v89, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s12, v[vgprValuC+58], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+58], v41, v42
v_cndmask_b32 v[vgprValuC+58], v39, v[vgprValuC+58], s12
v_cvt_pk_fp8_f32 v58, v[vgprValuC+58], v[vgprValuC+58] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v58, v90, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s12, v[vgprValuC+59], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+59], v41, v42
v_cndmask_b32 v[vgprValuC+59], v39, v[vgprValuC+59], s12
v_cvt_pk_fp8_f32 v59, v[vgprValuC+59], v[vgprValuC+59] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v59, v91, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s12, v[vgprValuC+60], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+60], v41, v42
v_cndmask_b32 v[vgprValuC+60], v39, v[vgprValuC+60], s12
v_cvt_pk_fp8_f32 v60, v[vgprValuC+60], v[vgprValuC+60] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v60, v92, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s12, v[vgprValuC+61], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+61], v41, v42
v_cndmask_b32 v[vgprValuC+61], v39, v[vgprValuC+61], s12
v_cvt_pk_fp8_f32 v61, v[vgprValuC+61], v[vgprValuC+61] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v61, v93, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s12, v[vgprValuC+62], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+62], v41, v42
v_cndmask_b32 v[vgprValuC+62], v39, v[vgprValuC+62], s12
v_cvt_pk_fp8_f32 v62, v[vgprValuC+62], v[vgprValuC+62] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v62, v94, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s12, v[vgprValuC+63], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+63], v41, v42
v_cndmask_b32 v[vgprValuC+63], v39, v[vgprValuC+63], s12
v_cvt_pk_fp8_f32 v63, v[vgprValuC+63], v[vgprValuC+63] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v63, v95, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s12, v[vgprValuC+64], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+64], v41, v42
v_cndmask_b32 v[vgprValuC+64], v39, v[vgprValuC+64], s12
v_cvt_pk_fp8_f32 v64, v[vgprValuC+64], v[vgprValuC+64] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v64, v96, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s12, v[vgprValuC+65], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+65], v41, v42
v_cndmask_b32 v[vgprValuC+65], v39, v[vgprValuC+65], s12
v_cvt_pk_fp8_f32 v65, v[vgprValuC+65], v[vgprValuC+65] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v65, v97, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s12, v[vgprValuC+66], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+66], v41, v42
v_cndmask_b32 v[vgprValuC+66], v39, v[vgprValuC+66], s12
v_cvt_pk_fp8_f32 v66, v[vgprValuC+66], v[vgprValuC+66] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v66, v98, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s12, v[vgprValuC+67], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+67], v41, v42
v_cndmask_b32 v[vgprValuC+67], v39, v[vgprValuC+67], s12
v_cvt_pk_fp8_f32 v67, v[vgprValuC+67], v[vgprValuC+67] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v67, v99, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s12, v[vgprValuC+68], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+68], v41, v42
v_cndmask_b32 v[vgprValuC+68], v39, v[vgprValuC+68], s12
v_cvt_pk_fp8_f32 v68, v[vgprValuC+68], v[vgprValuC+68] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v68, v100, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s12, v[vgprValuC+69], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+69], v41, v42
v_cndmask_b32 v[vgprValuC+69], v39, v[vgprValuC+69], s12
v_cvt_pk_fp8_f32 v69, v[vgprValuC+69], v[vgprValuC+69] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v69, v101, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s12, v[vgprValuC+70], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+70], v41, v42
v_cndmask_b32 v[vgprValuC+70], v39, v[vgprValuC+70], s12
v_cvt_pk_fp8_f32 v70, v[vgprValuC+70], v[vgprValuC+70] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v70, v102, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s12, v[vgprValuC+71], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+71], v41, v42
v_cndmask_b32 v[vgprValuC+71], v39, v[vgprValuC+71], s12
v_cvt_pk_fp8_f32 v71, v[vgprValuC+71], v[vgprValuC+71] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v71, v103, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s12, v[vgprValuC+72], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+72], v41, v42
v_cndmask_b32 v[vgprValuC+72], v39, v[vgprValuC+72], s12
v_cvt_pk_fp8_f32 v72, v[vgprValuC+72], v[vgprValuC+72] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v72, v104, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s12, v[vgprValuC+73], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+73], v41, v42
v_cndmask_b32 v[vgprValuC+73], v39, v[vgprValuC+73], s12
v_cvt_pk_fp8_f32 v73, v[vgprValuC+73], v[vgprValuC+73] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v73, v105, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cmp_class_f32 s12, v[vgprValuC+74], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+74], v41, v42
v_cndmask_b32 v[vgprValuC+74], v39, v[vgprValuC+74], s12
v_cvt_pk_fp8_f32 v74, v[vgprValuC+74], v[vgprValuC+74] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v74, v106, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_nop 0                                            // 1 wait state required when next inst writes vgprs held by previous dwordx4 store inst
s_sub_i32 s[sgprCLSLoopCounter], s[sgprCLSLoopCounter], 1
s_cmp_eq_u32 s[sgprCLSLoopCounter], 0
s_cbranch_scc1 label_NoBranch_L0MWAQWFIZGUQAI0     // Only branch on scc0
// loop while counter != 0
s_wait_xcnt 0
s_prefetch_inst_pc_rel 0, null, 31
s_getpc_b64 s[28:29]                               // addr of next instr
s_add_i32 s30, label_CLS_7, 4                      // target branch offset
s_abs_i32 s30, s30                                 // abs offset
s_sub_u32 s28, s28, s30                            // sub target branch offset
s_subb_u32 s29, s29, 0                             // sub high and carry
s_setpc_b64 s[28:29]                               // branch to label_CLS_7
label_NoBranch_L0MWAQWFIZGUQAI0:
.set sgprCLSLoopCounter, UNDEF
.set sgprCLSm0Base, UNDEF
s_wait_xcnt 0
s_prefetch_inst_pc_rel 0, null, 31
s_branch label_GW_End_2                            // jump to end
label_GW_B1_GSU1:
label_GW_B1_FD0_GSU1:

/* Edge/NonEdge store path check (M): Size % 32 > 0 -> Edge store; else -> NonEdge store */
s_wait_xcnt 0
s_prefetch_inst_pc_rel 0, null, 31
s_and_b32 s24, 31, s[sgprSizeI]                    // s24 = s[sgprSizeI] % 32
s_add_u32 s25, -0x1, s[sgprNumWorkGroups0]
s_cmp_ge_u32 s[sgprWorkGroup0], s25                // wg0 >= nwg0-1 ?
s_cselect_b32 s24, s24, 0                          // set rem
s_mov_b32 s8, 0
s_cmp_gt_u32 s24, s8                               // rem > 0
s_cbranch_scc1 label_GW_B1_FD0_VW2_GSU1_Else       // jump if edges required

/* Edge/NonEdge store path check (N (isSize1)): Size % 64 > 0 -> Edge store; else -> NonEdge store */
s_wait_xcnt 0
s_prefetch_inst_pc_rel 0, null, 31
s_and_b32 s24, 63, s[sgprSizeJ]                    // s24 = s[sgprSizeJ] % 64
s_add_u32 s25, -0x1, s[sgprNumWorkGroups1]
s_cmp_ge_u32 s[sgprWorkGroup1], s25                // wg1 >= nwg1-1
s_cselect_b32 s24, s24, 0                          // set rem
s_mov_b32 s8, 0
s_cmp_gt_u32 s24, s8                               // rem > 0
s_cbranch_scc1 label_GW_B1_FD0_VW2_GSU1_Then       // jump if edges required
label_GW_B1_FD0_VW2_GSU1_NonEdge:
.set sgprCLSm0Base, 8
.set sgprCLSLoopCounter, 11

/* edge=0, allocate 1 sgpr. perBatchTmpS=1 perBatchMaskS=0 perElementMaskS=0 elementsPerBatch=154 */
/* optSingleColVgpr=1 optSharedColVgpr=0 optSGPRUsage=BufferLoad_Mask optSrdIncForRow=1 factorDim=0 */
/* (d1,vc1,d0,vc0)=(0,0,0,0) */
s_wait_xcnt 0
s_prefetch_inst_pc_rel 0, null, 31
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_add_nc_u32 v43, v35, v32                         // optSingleColVgpr scaleToBpe: sharedAddrVgpr <- cinRowPtr + coord0, scaled by BPE. BSHERE:coord0=32, coord0Vgpr=32 (multiple bpe)
                                                   // optSingleColVgpr scaleToBpe: sharedAddrVgpr <- cinRowPtr + coord0, scaled by BPE. BSHERE:coord0=32, coord0Vgpr=32 (bpe is 1, no mul)
v_add_nc_u32 v44, v34, v32                         // optSingleColVgpr scaleToBpe: sharedAddrVgpr <- cinRowPtr + coord0, scaled by BPE. BSHERE:coord0=32, coord0Vgpr=32 (multiple bpe)
                                                   // optSingleColVgpr scaleToBpe: sharedAddrVgpr <- cinRowPtr + coord0, scaled by BPE. BSHERE:coord0=32, coord0Vgpr=32 (bpe is 1, no mul)
s_mov_b32 s12, 0                                   // Init sgpr offset
s_mov_b32 s13, 0                                   // Init sgpr offset
s_mov_b32 s[sgprCLSm0Base], 0x0                    // CLS M0 base = 0
s_mov_b32 s[sgprCLSLoopCounter], 0x1               // CLS loop iter count

/******************************************/
/* Global Write Beta Batch #0 (d1,d0,vc1,vc0) = */
/*    (0,0,0,0:vw2); (0,0,1,0:vw2); (0,0,2,0:vw2); (0,0,3,0:vw2); (0,0,4,0:vw2); (0,0,5,0:vw2); (0,0,6,0:vw2); (0,0,7,0:vw2); (0,0,8,0:vw2); (0,0,9,0:vw2); (0,0,10,0:vw2); (0,0,11,0:vw2); (0,0,12,0:vw2); (0,0,13,0:vw2); (0,0,14,0:vw2); (0,0,15,0:vw2) */
/******************************************/
label_CLS_6:
s_wait_xcnt 0
s_prefetch_inst_pc_rel 0, null, 31
s_mov_b32 m0, s[sgprCLSm0Base]                     // LDS clamp at sgpr(CLSm0Base)
s_add_u32 s[sgprCLSm0Base], s[sgprCLSm0Base], 1    // CLS M0 step (src coef of CLS iter dim)

/* calc coords, apply mask, and issue loads (if necessary) */
/* (d1,vc1,d0,vc0)=(0,0,0,0) */
s_add_u32 s[sgprSrdC+0], s[sgprSrdC+0], s13        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdC+1], s[sgprSrdC+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s13, s[sgprStrideC1J], 0                // incToNextRow: Scale by BPE
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
s_wait_alu depctr_va_vdst(0)
buffer_load_d16_b16 v45, v44, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
/* (d1,vc1,d0,vc0)=(0,1,0,0) */
s_add_u32 s[sgprSrdC+0], s[sgprSrdC+0], s13        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdC+1], s[sgprSrdC+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s13, s[sgprStrideC1J], 0                // incToNextRow: Scale by BPE
buffer_load_d16_b16 v78, v44, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
/* (d1,vc1,d0,vc0)=(0,2,0,0) */
s_add_u32 s[sgprSrdC+0], s[sgprSrdC+0], s13        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdC+1], s[sgprSrdC+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s13, s[sgprStrideC1J], 0                // incToNextRow: Scale by BPE
buffer_load_d16_b16 v79, v44, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
/* (d1,vc1,d0,vc0)=(0,3,0,0) */
s_add_u32 s[sgprSrdC+0], s[sgprSrdC+0], s13        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdC+1], s[sgprSrdC+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s13, s[sgprStrideC1J], 0                // incToNextRow: Scale by BPE
buffer_load_d16_b16 v80, v44, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
/* (d1,vc1,d0,vc0)=(0,4,0,0) */
s_add_u32 s[sgprSrdC+0], s[sgprSrdC+0], s13        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdC+1], s[sgprSrdC+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s13, s[sgprStrideC1J], 0                // incToNextRow: Scale by BPE
buffer_load_d16_b16 v81, v44, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
/* (d1,vc1,d0,vc0)=(0,5,0,0) */
s_add_u32 s[sgprSrdC+0], s[sgprSrdC+0], s13        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdC+1], s[sgprSrdC+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s13, s[sgprStrideC1J], 0                // incToNextRow: Scale by BPE
buffer_load_d16_b16 v82, v44, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
/* (d1,vc1,d0,vc0)=(0,6,0,0) */
s_add_u32 s[sgprSrdC+0], s[sgprSrdC+0], s13        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdC+1], s[sgprSrdC+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s13, s[sgprStrideC1J], 0                // incToNextRow: Scale by BPE
buffer_load_d16_b16 v83, v44, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
/* (d1,vc1,d0,vc0)=(0,7,0,0) */
s_add_u32 s[sgprSrdC+0], s[sgprSrdC+0], s13        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdC+1], s[sgprSrdC+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s13, s[sgprStrideC1J], 0                // incToNextRow: Scale by BPE
buffer_load_d16_b16 v84, v44, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
/* (d1,vc1,d0,vc0)=(0,8,0,0) */
s_add_u32 s[sgprSrdC+0], s[sgprSrdC+0], s13        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdC+1], s[sgprSrdC+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s13, s[sgprStrideC1J], 0                // incToNextRow: Scale by BPE
buffer_load_d16_b16 v85, v44, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
/* (d1,vc1,d0,vc0)=(0,9,0,0) */
s_add_u32 s[sgprSrdC+0], s[sgprSrdC+0], s13        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdC+1], s[sgprSrdC+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s13, s[sgprStrideC1J], 0                // incToNextRow: Scale by BPE
buffer_load_d16_b16 v86, v44, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
/* (d1,vc1,d0,vc0)=(0,10,0,0) */
s_add_u32 s[sgprSrdC+0], s[sgprSrdC+0], s13        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdC+1], s[sgprSrdC+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s13, s[sgprStrideC1J], 0                // incToNextRow: Scale by BPE
buffer_load_d16_b16 v87, v44, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
/* (d1,vc1,d0,vc0)=(0,11,0,0) */
s_add_u32 s[sgprSrdC+0], s[sgprSrdC+0], s13        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdC+1], s[sgprSrdC+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s13, s[sgprStrideC1J], 0                // incToNextRow: Scale by BPE
buffer_load_d16_b16 v88, v44, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
/* (d1,vc1,d0,vc0)=(0,12,0,0) */
s_add_u32 s[sgprSrdC+0], s[sgprSrdC+0], s13        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdC+1], s[sgprSrdC+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s13, s[sgprStrideC1J], 0                // incToNextRow: Scale by BPE
buffer_load_d16_b16 v89, v44, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
/* (d1,vc1,d0,vc0)=(0,13,0,0) */
s_add_u32 s[sgprSrdC+0], s[sgprSrdC+0], s13        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdC+1], s[sgprSrdC+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s13, s[sgprStrideC1J], 0                // incToNextRow: Scale by BPE
buffer_load_d16_b16 v90, v44, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
/* (d1,vc1,d0,vc0)=(0,14,0,0) */
s_add_u32 s[sgprSrdC+0], s[sgprSrdC+0], s13        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdC+1], s[sgprSrdC+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s13, s[sgprStrideC1J], 0                // incToNextRow: Scale by BPE
buffer_load_d16_b16 v91, v44, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
/* (d1,vc1,d0,vc0)=(0,15,0,0) */
s_add_u32 s[sgprSrdC+0], s[sgprSrdC+0], s13        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdC+1], s[sgprSrdC+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s13, s[sgprStrideC1J], 0                // incToNextRow: Scale by BPE
buffer_load_d16_b16 v92, v44, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(6)
v_movrelsd_2_b32 v[vgprValuC+46], v[vgprValuC+0]   // copy MI out reg to vreg[0]
v_movrelsd_2_b32 v[vgprValuC+47], v[vgprValuC+8]   // copy MI out reg to vreg[1]
v_movrelsd_2_b32 v[vgprValuC+48], v[vgprValuC+16]  // copy MI out reg to vreg[2]
v_movrelsd_2_b32 v[vgprValuC+49], v[vgprValuC+24]  // copy MI out reg to vreg[3]
v_movrelsd_2_b32 v[vgprValuC+50], v[vgprValuC+1]   // copy MI out reg to vreg[4]
v_movrelsd_2_b32 v[vgprValuC+51], v[vgprValuC+9]   // copy MI out reg to vreg[5]
v_movrelsd_2_b32 v[vgprValuC+52], v[vgprValuC+17]  // copy MI out reg to vreg[6]
v_movrelsd_2_b32 v[vgprValuC+53], v[vgprValuC+25]  // copy MI out reg to vreg[7]
v_movrelsd_2_b32 v[vgprValuC+54], v[vgprValuC+2]   // copy MI out reg to vreg[8]
v_movrelsd_2_b32 v[vgprValuC+55], v[vgprValuC+10]  // copy MI out reg to vreg[9]
v_movrelsd_2_b32 v[vgprValuC+56], v[vgprValuC+18]  // copy MI out reg to vreg[10]
v_movrelsd_2_b32 v[vgprValuC+57], v[vgprValuC+26]  // copy MI out reg to vreg[11]
v_movrelsd_2_b32 v[vgprValuC+58], v[vgprValuC+3]   // copy MI out reg to vreg[12]
v_movrelsd_2_b32 v[vgprValuC+59], v[vgprValuC+11]  // copy MI out reg to vreg[13]
v_movrelsd_2_b32 v[vgprValuC+60], v[vgprValuC+19]  // copy MI out reg to vreg[14]
v_movrelsd_2_b32 v[vgprValuC+61], v[vgprValuC+27]  // copy MI out reg to vreg[15]
v_movrelsd_2_b32 v[vgprValuC+62], v[vgprValuC+4]   // copy MI out reg to vreg[16]
v_movrelsd_2_b32 v[vgprValuC+63], v[vgprValuC+12]  // copy MI out reg to vreg[17]
v_movrelsd_2_b32 v[vgprValuC+64], v[vgprValuC+20]  // copy MI out reg to vreg[18]
v_movrelsd_2_b32 v[vgprValuC+65], v[vgprValuC+28]  // copy MI out reg to vreg[19]
v_movrelsd_2_b32 v[vgprValuC+66], v[vgprValuC+5]   // copy MI out reg to vreg[20]
v_movrelsd_2_b32 v[vgprValuC+67], v[vgprValuC+13]  // copy MI out reg to vreg[21]
v_movrelsd_2_b32 v[vgprValuC+68], v[vgprValuC+21]  // copy MI out reg to vreg[22]
v_movrelsd_2_b32 v[vgprValuC+69], v[vgprValuC+29]  // copy MI out reg to vreg[23]
v_movrelsd_2_b32 v[vgprValuC+70], v[vgprValuC+6]   // copy MI out reg to vreg[24]
v_movrelsd_2_b32 v[vgprValuC+71], v[vgprValuC+14]  // copy MI out reg to vreg[25]
v_movrelsd_2_b32 v[vgprValuC+72], v[vgprValuC+22]  // copy MI out reg to vreg[26]
v_movrelsd_2_b32 v[vgprValuC+73], v[vgprValuC+30]  // copy MI out reg to vreg[27]
v_movrelsd_2_b32 v[vgprValuC+74], v[vgprValuC+7]   // copy MI out reg to vreg[28]
v_movrelsd_2_b32 v[vgprValuC+75], v[vgprValuC+15]  // copy MI out reg to vreg[29]
v_movrelsd_2_b32 v[vgprValuC+76], v[vgprValuC+23]  // copy MI out reg to vreg[30]
v_movrelsd_2_b32 v[vgprValuC+77], v[vgprValuC+31]  // copy MI out reg to vreg[31]

/* rC *= alpha batchElements=[(0, 0, 0, 0), (0, 0, 1, 0), (0, 0, 2, 0), (0, 0, 3, 0), (0, 0, 4, 0), (0, 0, 5, 0), (0, 0, 6, 0), (0, 0, 7, 0), (0, 0, 8, 0), (0, 0, 9, 0), (0, 0, 10, 0), (0, 0, 11, 0), (0, 0, 12, 0), (0, 0, 13, 0), (0, 0, 14, 0), (0, 0, 15, 0)] */
v_pk_mul_f32 v[vgprValuC+46:vgprValuC+46+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+46:vgprValuC+46+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+48:vgprValuC+48+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+48:vgprValuC+48+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+50:vgprValuC+50+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+50:vgprValuC+50+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+52:vgprValuC+52+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+52:vgprValuC+52+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+54:vgprValuC+54+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+54:vgprValuC+54+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+56:vgprValuC+56+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+56:vgprValuC+56+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+58:vgprValuC+58+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+58:vgprValuC+58+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+60:vgprValuC+60+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+60:vgprValuC+60+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+62:vgprValuC+62+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+62:vgprValuC+62+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+64:vgprValuC+64+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+64:vgprValuC+64+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+66:vgprValuC+66+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+66:vgprValuC+66+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+68:vgprValuC+68+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+68:vgprValuC+68+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+70:vgprValuC+70+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+70:vgprValuC+70+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+72:vgprValuC+72+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+72:vgprValuC+72+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+74:vgprValuC+74+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+74:vgprValuC+74+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+76:vgprValuC+76+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+76:vgprValuC+76+1] op_sel_hi:[0,1,1] // *= alpha (pk)

/* apply mask, calc new C and issue writes */
v_mov_b32 v40, 0x207                               // Nan and +/- inf
v_mov_b32 v42, 0x43E00000                          // Fp8 Max value 448 as float32
v_mov_b32 v41, 0xc3E00000                          // Fp8 Min value -448 as float32

s_wait_loadcnt 15                                  // vlcnt(15) = 16 - 1 (beta) (interleaved)
v_cvt_pk_f32_fp8 v[36:37], v45.l op_sel:[0]
s_nop 0
v_fmac_f32 v[vgprValuC+46], v36, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+47], v37, s[sgprBeta]       // finalSum = sum*alpha + C*beta (PK)
v_cmp_class_f32 s13, v[vgprValuC+46], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+46], v41, v42
v_cndmask_b32 v[vgprValuC+46], v39, v[vgprValuC+46], s13
v_cmp_class_f32 s13, v[vgprValuC+47], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+47], v41, v42
v_cndmask_b32 v[vgprValuC+47], v39, v[vgprValuC+47], s13
v_cvt_pk_fp8_f32 v46, v[vgprValuC+46], v[vgprValuC+47] op_sel:[0,0,0]
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s12, s[sgprStrideD1J], 0                // incToNextRow: Scale by BPE
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v46, v43, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_loadcnt 14                                  // vlcnt(14) = 16 - 2 (beta) (interleaved)
v_cvt_pk_f32_fp8 v[36:37], v78.l op_sel:[0]
s_nop 0
v_fmac_f32 v[vgprValuC+48], v36, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+49], v37, s[sgprBeta]       // finalSum = sum*alpha + C*beta (PK)
v_cmp_class_f32 s13, v[vgprValuC+48], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+48], v41, v42
v_cndmask_b32 v[vgprValuC+48], v39, v[vgprValuC+48], s13
v_cmp_class_f32 s13, v[vgprValuC+49], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+49], v41, v42
v_cndmask_b32 v[vgprValuC+49], v39, v[vgprValuC+49], s13
v_cvt_pk_fp8_f32 v48, v[vgprValuC+48], v[vgprValuC+49] op_sel:[0,0,0]
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s12, s[sgprStrideD1J], 0                // incToNextRow: Scale by BPE
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v48, v43, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_loadcnt 13                                  // vlcnt(13) = 16 - 3 (beta) (interleaved)
v_cvt_pk_f32_fp8 v[36:37], v79.l op_sel:[0]
s_nop 0
v_fmac_f32 v[vgprValuC+50], v36, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+51], v37, s[sgprBeta]       // finalSum = sum*alpha + C*beta (PK)
v_cmp_class_f32 s13, v[vgprValuC+50], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+50], v41, v42
v_cndmask_b32 v[vgprValuC+50], v39, v[vgprValuC+50], s13
v_cmp_class_f32 s13, v[vgprValuC+51], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+51], v41, v42
v_cndmask_b32 v[vgprValuC+51], v39, v[vgprValuC+51], s13
v_cvt_pk_fp8_f32 v50, v[vgprValuC+50], v[vgprValuC+51] op_sel:[0,0,0]
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s12, s[sgprStrideD1J], 0                // incToNextRow: Scale by BPE
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v50, v43, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_loadcnt 12                                  // vlcnt(12) = 16 - 4 (beta) (interleaved)
v_cvt_pk_f32_fp8 v[36:37], v80.l op_sel:[0]
s_nop 0
v_fmac_f32 v[vgprValuC+52], v36, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+53], v37, s[sgprBeta]       // finalSum = sum*alpha + C*beta (PK)
v_cmp_class_f32 s13, v[vgprValuC+52], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+52], v41, v42
v_cndmask_b32 v[vgprValuC+52], v39, v[vgprValuC+52], s13
v_cmp_class_f32 s13, v[vgprValuC+53], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+53], v41, v42
v_cndmask_b32 v[vgprValuC+53], v39, v[vgprValuC+53], s13
v_cvt_pk_fp8_f32 v52, v[vgprValuC+52], v[vgprValuC+53] op_sel:[0,0,0]
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s12, s[sgprStrideD1J], 0                // incToNextRow: Scale by BPE
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v52, v43, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_loadcnt 11                                  // vlcnt(11) = 16 - 5 (beta) (interleaved)
v_cvt_pk_f32_fp8 v[36:37], v81.l op_sel:[0]
s_nop 0
v_fmac_f32 v[vgprValuC+54], v36, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+55], v37, s[sgprBeta]       // finalSum = sum*alpha + C*beta (PK)
v_cmp_class_f32 s13, v[vgprValuC+54], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+54], v41, v42
v_cndmask_b32 v[vgprValuC+54], v39, v[vgprValuC+54], s13
v_cmp_class_f32 s13, v[vgprValuC+55], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+55], v41, v42
v_cndmask_b32 v[vgprValuC+55], v39, v[vgprValuC+55], s13
v_cvt_pk_fp8_f32 v54, v[vgprValuC+54], v[vgprValuC+55] op_sel:[0,0,0]
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s12, s[sgprStrideD1J], 0                // incToNextRow: Scale by BPE
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v54, v43, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_loadcnt 10                                  // vlcnt(10) = 16 - 6 (beta) (interleaved)
v_cvt_pk_f32_fp8 v[36:37], v82.l op_sel:[0]
s_nop 0
v_fmac_f32 v[vgprValuC+56], v36, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+57], v37, s[sgprBeta]       // finalSum = sum*alpha + C*beta (PK)
v_cmp_class_f32 s13, v[vgprValuC+56], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+56], v41, v42
v_cndmask_b32 v[vgprValuC+56], v39, v[vgprValuC+56], s13
v_cmp_class_f32 s13, v[vgprValuC+57], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+57], v41, v42
v_cndmask_b32 v[vgprValuC+57], v39, v[vgprValuC+57], s13
v_cvt_pk_fp8_f32 v56, v[vgprValuC+56], v[vgprValuC+57] op_sel:[0,0,0]
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s12, s[sgprStrideD1J], 0                // incToNextRow: Scale by BPE
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v56, v43, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_loadcnt 9                                   // vlcnt(9) = 16 - 7 (beta) (interleaved)
v_cvt_pk_f32_fp8 v[36:37], v83.l op_sel:[0]
s_nop 0
v_fmac_f32 v[vgprValuC+58], v36, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+59], v37, s[sgprBeta]       // finalSum = sum*alpha + C*beta (PK)
v_cmp_class_f32 s13, v[vgprValuC+58], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+58], v41, v42
v_cndmask_b32 v[vgprValuC+58], v39, v[vgprValuC+58], s13
v_cmp_class_f32 s13, v[vgprValuC+59], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+59], v41, v42
v_cndmask_b32 v[vgprValuC+59], v39, v[vgprValuC+59], s13
v_cvt_pk_fp8_f32 v58, v[vgprValuC+58], v[vgprValuC+59] op_sel:[0,0,0]
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s12, s[sgprStrideD1J], 0                // incToNextRow: Scale by BPE
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v58, v43, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_loadcnt 8                                   // vlcnt(8) = 16 - 8 (beta) (interleaved)
v_cvt_pk_f32_fp8 v[36:37], v84.l op_sel:[0]
s_nop 0
v_fmac_f32 v[vgprValuC+60], v36, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+61], v37, s[sgprBeta]       // finalSum = sum*alpha + C*beta (PK)
v_cmp_class_f32 s13, v[vgprValuC+60], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+60], v41, v42
v_cndmask_b32 v[vgprValuC+60], v39, v[vgprValuC+60], s13
v_cmp_class_f32 s13, v[vgprValuC+61], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+61], v41, v42
v_cndmask_b32 v[vgprValuC+61], v39, v[vgprValuC+61], s13
v_cvt_pk_fp8_f32 v60, v[vgprValuC+60], v[vgprValuC+61] op_sel:[0,0,0]
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s12, s[sgprStrideD1J], 0                // incToNextRow: Scale by BPE
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v60, v43, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_loadcnt 7                                   // vlcnt(7) = 16 - 9 (beta) (interleaved)
v_cvt_pk_f32_fp8 v[36:37], v85.l op_sel:[0]
s_nop 0
v_fmac_f32 v[vgprValuC+62], v36, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+63], v37, s[sgprBeta]       // finalSum = sum*alpha + C*beta (PK)
v_cmp_class_f32 s13, v[vgprValuC+62], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+62], v41, v42
v_cndmask_b32 v[vgprValuC+62], v39, v[vgprValuC+62], s13
v_cmp_class_f32 s13, v[vgprValuC+63], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+63], v41, v42
v_cndmask_b32 v[vgprValuC+63], v39, v[vgprValuC+63], s13
v_cvt_pk_fp8_f32 v62, v[vgprValuC+62], v[vgprValuC+63] op_sel:[0,0,0]
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s12, s[sgprStrideD1J], 0                // incToNextRow: Scale by BPE
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v62, v43, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_loadcnt 6                                   // vlcnt(6) = 16 - 10 (beta) (interleaved)
v_cvt_pk_f32_fp8 v[36:37], v86.l op_sel:[0]
s_nop 0
v_fmac_f32 v[vgprValuC+64], v36, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+65], v37, s[sgprBeta]       // finalSum = sum*alpha + C*beta (PK)
v_cmp_class_f32 s13, v[vgprValuC+64], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+64], v41, v42
v_cndmask_b32 v[vgprValuC+64], v39, v[vgprValuC+64], s13
v_cmp_class_f32 s13, v[vgprValuC+65], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+65], v41, v42
v_cndmask_b32 v[vgprValuC+65], v39, v[vgprValuC+65], s13
v_cvt_pk_fp8_f32 v64, v[vgprValuC+64], v[vgprValuC+65] op_sel:[0,0,0]
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s12, s[sgprStrideD1J], 0                // incToNextRow: Scale by BPE
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v64, v43, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_loadcnt 5                                   // vlcnt(5) = 16 - 11 (beta) (interleaved)
v_cvt_pk_f32_fp8 v[36:37], v87.l op_sel:[0]
s_nop 0
v_fmac_f32 v[vgprValuC+66], v36, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+67], v37, s[sgprBeta]       // finalSum = sum*alpha + C*beta (PK)
v_cmp_class_f32 s13, v[vgprValuC+66], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+66], v41, v42
v_cndmask_b32 v[vgprValuC+66], v39, v[vgprValuC+66], s13
v_cmp_class_f32 s13, v[vgprValuC+67], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+67], v41, v42
v_cndmask_b32 v[vgprValuC+67], v39, v[vgprValuC+67], s13
v_cvt_pk_fp8_f32 v66, v[vgprValuC+66], v[vgprValuC+67] op_sel:[0,0,0]
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s12, s[sgprStrideD1J], 0                // incToNextRow: Scale by BPE
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v66, v43, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_loadcnt 4                                   // vlcnt(4) = 16 - 12 (beta) (interleaved)
v_cvt_pk_f32_fp8 v[36:37], v88.l op_sel:[0]
s_nop 0
v_fmac_f32 v[vgprValuC+68], v36, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+69], v37, s[sgprBeta]       // finalSum = sum*alpha + C*beta (PK)
v_cmp_class_f32 s13, v[vgprValuC+68], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+68], v41, v42
v_cndmask_b32 v[vgprValuC+68], v39, v[vgprValuC+68], s13
v_cmp_class_f32 s13, v[vgprValuC+69], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+69], v41, v42
v_cndmask_b32 v[vgprValuC+69], v39, v[vgprValuC+69], s13
v_cvt_pk_fp8_f32 v68, v[vgprValuC+68], v[vgprValuC+69] op_sel:[0,0,0]
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s12, s[sgprStrideD1J], 0                // incToNextRow: Scale by BPE
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v68, v43, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_loadcnt 3                                   // vlcnt(3) = 16 - 13 (beta) (interleaved)
v_cvt_pk_f32_fp8 v[36:37], v89.l op_sel:[0]
s_nop 0
v_fmac_f32 v[vgprValuC+70], v36, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+71], v37, s[sgprBeta]       // finalSum = sum*alpha + C*beta (PK)
v_cmp_class_f32 s13, v[vgprValuC+70], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+70], v41, v42
v_cndmask_b32 v[vgprValuC+70], v39, v[vgprValuC+70], s13
v_cmp_class_f32 s13, v[vgprValuC+71], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+71], v41, v42
v_cndmask_b32 v[vgprValuC+71], v39, v[vgprValuC+71], s13
v_cvt_pk_fp8_f32 v70, v[vgprValuC+70], v[vgprValuC+71] op_sel:[0,0,0]
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s12, s[sgprStrideD1J], 0                // incToNextRow: Scale by BPE
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v70, v43, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_loadcnt 2                                   // vlcnt(2) = 16 - 14 (beta) (interleaved)
v_cvt_pk_f32_fp8 v[36:37], v90.l op_sel:[0]
s_nop 0
v_fmac_f32 v[vgprValuC+72], v36, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+73], v37, s[sgprBeta]       // finalSum = sum*alpha + C*beta (PK)
v_cmp_class_f32 s13, v[vgprValuC+72], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+72], v41, v42
v_cndmask_b32 v[vgprValuC+72], v39, v[vgprValuC+72], s13
v_cmp_class_f32 s13, v[vgprValuC+73], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+73], v41, v42
v_cndmask_b32 v[vgprValuC+73], v39, v[vgprValuC+73], s13
v_cvt_pk_fp8_f32 v72, v[vgprValuC+72], v[vgprValuC+73] op_sel:[0,0,0]
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s12, s[sgprStrideD1J], 0                // incToNextRow: Scale by BPE
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v72, v43, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_loadcnt 1                                   // vlcnt(1) = 16 - 15 (beta) (interleaved)
v_cvt_pk_f32_fp8 v[36:37], v91.l op_sel:[0]
s_nop 0
v_fmac_f32 v[vgprValuC+74], v36, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+75], v37, s[sgprBeta]       // finalSum = sum*alpha + C*beta (PK)
v_cmp_class_f32 s13, v[vgprValuC+74], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+74], v41, v42
v_cndmask_b32 v[vgprValuC+74], v39, v[vgprValuC+74], s13
v_cmp_class_f32 s13, v[vgprValuC+75], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+75], v41, v42
v_cndmask_b32 v[vgprValuC+75], v39, v[vgprValuC+75], s13
v_cvt_pk_fp8_f32 v74, v[vgprValuC+74], v[vgprValuC+75] op_sel:[0,0,0]
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s12, s[sgprStrideD1J], 0                // incToNextRow: Scale by BPE
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v74, v43, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_loadcnt 0                                   // vlcnt(0) = 16 - 16 (beta) (interleaved)
v_cvt_pk_f32_fp8 v[36:37], v92.l op_sel:[0]
s_nop 0
v_fmac_f32 v[vgprValuC+76], v36, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+77], v37, s[sgprBeta]       // finalSum = sum*alpha + C*beta (PK)
v_cmp_class_f32 s13, v[vgprValuC+76], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+76], v41, v42
v_cndmask_b32 v[vgprValuC+76], v39, v[vgprValuC+76], s13
v_cmp_class_f32 s13, v[vgprValuC+77], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+77], v41, v42
v_cndmask_b32 v[vgprValuC+77], v39, v[vgprValuC+77], s13
v_cvt_pk_fp8_f32 v76, v[vgprValuC+76], v[vgprValuC+77] op_sel:[0,0,0]
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s12        // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
s_lshl_b32 s12, s[sgprStrideD1J], 0                // incToNextRow: Scale by BPE
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v76, v43, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_nop 0                                            // 1 wait state required when next inst writes vgprs held by previous dwordx4 store inst
s_sub_i32 s[sgprCLSLoopCounter], s[sgprCLSLoopCounter], 1
s_cmp_eq_u32 s[sgprCLSLoopCounter], 0
s_cbranch_scc1 label_NoBranch_Y57Y54XUE2DV604X     // Only branch on scc0
// loop while counter != 0
s_wait_xcnt 0
s_prefetch_inst_pc_rel 0, null, 31
s_getpc_b64 s[24:25]                               // addr of next instr
s_add_i32 s26, label_CLS_6, 4                      // target branch offset
s_abs_i32 s26, s26                                 // abs offset
s_sub_u32 s24, s24, s26                            // sub target branch offset
s_subb_u32 s25, s25, 0                             // sub high and carry
s_setpc_b64 s[24:25]                               // branch to label_CLS_6
label_NoBranch_Y57Y54XUE2DV604X:
.set sgprCLSLoopCounter, UNDEF
.set sgprCLSm0Base, UNDEF
s_wait_xcnt 0
s_prefetch_inst_pc_rel 0, null, 31
s_branch label_GW_End_2                            // jump to end
label_GW_B1_FD0_VW2_GSU1_NonEdgeEnd:
label_GW_B1_FD0_VW2_GSU1_Then:
.set sgprCLSm0Base, 8
.set sgprCLSLoopCounter, 11

/* edge=1, allocate 3 sgpr. perBatchTmpS=2 perBatchMaskS=1 perElementMaskS=0 elementsPerBatch=116 */
/* optSingleColVgpr=0 optSharedColVgpr=0 optSGPRUsage=BufferLoad_Edge_Mask optSrdIncForRow=0 factorDim=0 */
/* (d1,vc1,d0,vc0)=(0,0,0,0) */
s_wait_xcnt 0
s_prefetch_inst_pc_rel 0, null, 31
s_wait_dscnt 0                                     // Wait for LDS write
s_barrier_signal -1
s_barrier_wait -1                                  // LDS write barrier
s_mov_b32 s24, 0                                   // Init sgpr offset
s_mov_b32 s25, 0                                   // Init sgpr offset
s_mov_b32 s[sgprCLSm0Base], 0x0                    // CLS M0 base = 0
s_mov_b32 s[sgprCLSLoopCounter], 0x1               // CLS loop iter count

/******************************************/
/* Global Write Beta Edge Batch #0 (d1,d0,vc1,vc0) = */
/*    (0,0,0,0:vw2); (0,0,1,0:vw2); (0,0,2,0:vw2); (0,0,3,0:vw2); (0,0,4,0:vw2); (0,0,5,0:vw2); (0,0,6,0:vw2); (0,0,7,0:vw2); (0,0,8,0:vw2); (0,0,9,0:vw2); (0,0,10,0:vw2); (0,0,11,0:vw2); (0,0,12,0:vw2); (0,0,13,0:vw2); (0,0,14,0:vw2); (0,0,15,0:vw2) */
/******************************************/
label_CLS_5:
s_wait_xcnt 0
s_prefetch_inst_pc_rel 0, null, 31
s_mov_b32 m0, s[sgprCLSm0Base]                     // LDS clamp at sgpr(CLSm0Base)
s_add_u32 s[sgprCLSm0Base], s[sgprCLSm0Base], 1    // CLS M0 step (src coef of CLS iter dim)

/* calc coords, apply mask, and issue loads (if necessary) */
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v38, BufferOOB
/* (d1,vc1,d0,vc0)=(0,0,0,0) */
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
s_wait_alu depctr_vm_vsrc(6)
v_add_nc_u32 v76, v34, v32                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v76, v38, v76, s26                   // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_d16_b16 v43, v76, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_nc_u32 v76, v35, v32                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v76, v38, v76, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v78, v34, v32                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v78, v38, v78, s26                   // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_d16_b16 v77, v78, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_nc_u32 v78, v35, v32                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v78, v38, v78, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v80, v34, v32                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v80, v38, v80, s26                   // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_d16_b16 v79, v80, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_nc_u32 v80, v35, v32                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v80, v38, v80, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v82, v34, v32                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v82, v38, v82, s26                   // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_d16_b16 v81, v82, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_nc_u32 v82, v35, v32                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v82, v38, v82, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,4,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v84, v34, v32                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v84, v38, v84, s26                   // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_d16_b16 v83, v84, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_nc_u32 v84, v35, v32                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v84, v38, v84, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,5,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v86, v34, v32                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v86, v38, v86, s26                   // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_d16_b16 v85, v86, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_nc_u32 v86, v35, v32                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v86, v38, v86, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,6,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v88, v34, v32                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v88, v38, v88, s26                   // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_d16_b16 v87, v88, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_nc_u32 v88, v35, v32                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v88, v38, v88, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,7,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v90, v34, v32                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v90, v38, v90, s26                   // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_d16_b16 v89, v90, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_nc_u32 v90, v35, v32                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v90, v38, v90, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,8,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v92, v34, v32                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v92, v38, v92, s26                   // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_d16_b16 v91, v92, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_nc_u32 v92, v35, v32                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v92, v38, v92, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,9,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v94, v34, v32                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v94, v38, v94, s26                   // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_d16_b16 v93, v94, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_nc_u32 v94, v35, v32                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v94, v38, v94, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,10,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v96, v34, v32                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v96, v38, v96, s26                   // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_d16_b16 v95, v96, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_nc_u32 v96, v35, v32                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v96, v38, v96, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,11,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v98, v34, v32                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v98, v38, v98, s26                   // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_d16_b16 v97, v98, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_nc_u32 v98, v35, v32                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v98, v38, v98, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,12,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v100, v34, v32                        // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v100, v38, v100, s26                 // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_d16_b16 v99, v100, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_nc_u32 v100, v35, v32                        // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v100, v38, v100, s26                 // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,13,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v102, v34, v32                        // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v102, v38, v102, s26                 // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_d16_b16 v101, v102, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_nc_u32 v102, v35, v32                        // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v102, v38, v102, s26                 // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,14,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v104, v34, v32                        // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v104, v38, v104, s26                 // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_d16_b16 v103, v104, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_nc_u32 v104, v35, v32                        // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v104, v38, v104, s26                 // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,15,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v106, v34, v32                        // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v106, v38, v106, s26                 // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_d16_b16 v105, v106, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_nc_u32 v106, v35, v32                        // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v106, v38, v106, s26                 // LDD clip if OOB. offset
v_movrelsd_2_b32 v[vgprValuC+44], v[vgprValuC+0]   // copy MI out reg to vreg[0]
v_movrelsd_2_b32 v[vgprValuC+45], v[vgprValuC+8]   // copy MI out reg to vreg[1]
v_movrelsd_2_b32 v[vgprValuC+46], v[vgprValuC+16]  // copy MI out reg to vreg[2]
v_movrelsd_2_b32 v[vgprValuC+47], v[vgprValuC+24]  // copy MI out reg to vreg[3]
v_movrelsd_2_b32 v[vgprValuC+48], v[vgprValuC+1]   // copy MI out reg to vreg[4]
v_movrelsd_2_b32 v[vgprValuC+49], v[vgprValuC+9]   // copy MI out reg to vreg[5]
v_movrelsd_2_b32 v[vgprValuC+50], v[vgprValuC+17]  // copy MI out reg to vreg[6]
v_movrelsd_2_b32 v[vgprValuC+51], v[vgprValuC+25]  // copy MI out reg to vreg[7]
v_movrelsd_2_b32 v[vgprValuC+52], v[vgprValuC+2]   // copy MI out reg to vreg[8]
v_movrelsd_2_b32 v[vgprValuC+53], v[vgprValuC+10]  // copy MI out reg to vreg[9]
v_movrelsd_2_b32 v[vgprValuC+54], v[vgprValuC+18]  // copy MI out reg to vreg[10]
v_movrelsd_2_b32 v[vgprValuC+55], v[vgprValuC+26]  // copy MI out reg to vreg[11]
v_movrelsd_2_b32 v[vgprValuC+56], v[vgprValuC+3]   // copy MI out reg to vreg[12]
v_movrelsd_2_b32 v[vgprValuC+57], v[vgprValuC+11]  // copy MI out reg to vreg[13]
v_movrelsd_2_b32 v[vgprValuC+58], v[vgprValuC+19]  // copy MI out reg to vreg[14]
v_movrelsd_2_b32 v[vgprValuC+59], v[vgprValuC+27]  // copy MI out reg to vreg[15]
v_movrelsd_2_b32 v[vgprValuC+60], v[vgprValuC+4]   // copy MI out reg to vreg[16]
v_movrelsd_2_b32 v[vgprValuC+61], v[vgprValuC+12]  // copy MI out reg to vreg[17]
v_movrelsd_2_b32 v[vgprValuC+62], v[vgprValuC+20]  // copy MI out reg to vreg[18]
v_movrelsd_2_b32 v[vgprValuC+63], v[vgprValuC+28]  // copy MI out reg to vreg[19]
v_movrelsd_2_b32 v[vgprValuC+64], v[vgprValuC+5]   // copy MI out reg to vreg[20]
v_movrelsd_2_b32 v[vgprValuC+65], v[vgprValuC+13]  // copy MI out reg to vreg[21]
v_movrelsd_2_b32 v[vgprValuC+66], v[vgprValuC+21]  // copy MI out reg to vreg[22]
v_movrelsd_2_b32 v[vgprValuC+67], v[vgprValuC+29]  // copy MI out reg to vreg[23]
v_movrelsd_2_b32 v[vgprValuC+68], v[vgprValuC+6]   // copy MI out reg to vreg[24]
v_movrelsd_2_b32 v[vgprValuC+69], v[vgprValuC+14]  // copy MI out reg to vreg[25]
v_movrelsd_2_b32 v[vgprValuC+70], v[vgprValuC+22]  // copy MI out reg to vreg[26]
v_movrelsd_2_b32 v[vgprValuC+71], v[vgprValuC+30]  // copy MI out reg to vreg[27]
v_movrelsd_2_b32 v[vgprValuC+72], v[vgprValuC+7]   // copy MI out reg to vreg[28]
v_movrelsd_2_b32 v[vgprValuC+73], v[vgprValuC+15]  // copy MI out reg to vreg[29]
v_movrelsd_2_b32 v[vgprValuC+74], v[vgprValuC+23]  // copy MI out reg to vreg[30]
v_movrelsd_2_b32 v[vgprValuC+75], v[vgprValuC+31]  // copy MI out reg to vreg[31]

/* rC *= alpha batchElements=[(0, 0, 0, 0), (0, 0, 1, 0), (0, 0, 2, 0), (0, 0, 3, 0), (0, 0, 4, 0), (0, 0, 5, 0), (0, 0, 6, 0), (0, 0, 7, 0), (0, 0, 8, 0), (0, 0, 9, 0), (0, 0, 10, 0), (0, 0, 11, 0), (0, 0, 12, 0), (0, 0, 13, 0), (0, 0, 14, 0), (0, 0, 15, 0)] */
v_pk_mul_f32 v[vgprValuC+44:vgprValuC+44+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+44:vgprValuC+44+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+46:vgprValuC+46+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+46:vgprValuC+46+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+48:vgprValuC+48+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+48:vgprValuC+48+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+50:vgprValuC+50+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+50:vgprValuC+50+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+52:vgprValuC+52+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+52:vgprValuC+52+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+54:vgprValuC+54+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+54:vgprValuC+54+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+56:vgprValuC+56+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+56:vgprValuC+56+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+58:vgprValuC+58+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+58:vgprValuC+58+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+60:vgprValuC+60+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+60:vgprValuC+60+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+62:vgprValuC+62+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+62:vgprValuC+62+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+64:vgprValuC+64+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+64:vgprValuC+64+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+66:vgprValuC+66+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+66:vgprValuC+66+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+68:vgprValuC+68+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+68:vgprValuC+68+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+70:vgprValuC+70+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+70:vgprValuC+70+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+72:vgprValuC+72+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+72:vgprValuC+72+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+74:vgprValuC+74+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+74:vgprValuC+74+1] op_sel_hi:[0,1,1] // *= alpha (pk)
s_wait_loadcnt 0                                   // wait for Beta

/* apply mask, calc new C and issue writes */
v_mov_b32 v40, 0x207                               // Nan and +/- inf
v_mov_b32 v42, 0x43E00000                          // Fp8 Max value 448 as float32
v_mov_b32 v41, 0xc3E00000                          // Fp8 Min value -448 as float32
v_cvt_pk_f32_fp8 v[36:37], v43.l op_sel:[0]
s_nop 0
v_fmac_f32 v[vgprValuC+44], v36, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+45], v37, s[sgprBeta]       // finalSum = sum*alpha + C*beta (PK)
v_cmp_class_f32 s12, v[vgprValuC+44], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+44], v41, v42
v_cndmask_b32 v[vgprValuC+44], v39, v[vgprValuC+44], s12
v_cmp_class_f32 s12, v[vgprValuC+45], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+45], v41, v42
v_cndmask_b32 v[vgprValuC+45], v39, v[vgprValuC+45], s12
v_cvt_pk_fp8_f32 v44, v[vgprValuC+44], v[vgprValuC+45] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v44, v76, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cvt_pk_f32_fp8 v[36:37], v77.l op_sel:[0]
s_nop 0
v_fmac_f32 v[vgprValuC+46], v36, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+47], v37, s[sgprBeta]       // finalSum = sum*alpha + C*beta (PK)
v_cmp_class_f32 s12, v[vgprValuC+46], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+46], v41, v42
v_cndmask_b32 v[vgprValuC+46], v39, v[vgprValuC+46], s12
v_cmp_class_f32 s12, v[vgprValuC+47], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+47], v41, v42
v_cndmask_b32 v[vgprValuC+47], v39, v[vgprValuC+47], s12
v_cvt_pk_fp8_f32 v46, v[vgprValuC+46], v[vgprValuC+47] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v46, v78, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cvt_pk_f32_fp8 v[36:37], v79.l op_sel:[0]
s_nop 0
v_fmac_f32 v[vgprValuC+48], v36, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+49], v37, s[sgprBeta]       // finalSum = sum*alpha + C*beta (PK)
v_cmp_class_f32 s12, v[vgprValuC+48], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+48], v41, v42
v_cndmask_b32 v[vgprValuC+48], v39, v[vgprValuC+48], s12
v_cmp_class_f32 s12, v[vgprValuC+49], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+49], v41, v42
v_cndmask_b32 v[vgprValuC+49], v39, v[vgprValuC+49], s12
v_cvt_pk_fp8_f32 v48, v[vgprValuC+48], v[vgprValuC+49] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v48, v80, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cvt_pk_f32_fp8 v[36:37], v81.l op_sel:[0]
s_nop 0
v_fmac_f32 v[vgprValuC+50], v36, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+51], v37, s[sgprBeta]       // finalSum = sum*alpha + C*beta (PK)
v_cmp_class_f32 s12, v[vgprValuC+50], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+50], v41, v42
v_cndmask_b32 v[vgprValuC+50], v39, v[vgprValuC+50], s12
v_cmp_class_f32 s12, v[vgprValuC+51], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+51], v41, v42
v_cndmask_b32 v[vgprValuC+51], v39, v[vgprValuC+51], s12
v_cvt_pk_fp8_f32 v50, v[vgprValuC+50], v[vgprValuC+51] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v50, v82, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cvt_pk_f32_fp8 v[36:37], v83.l op_sel:[0]
s_nop 0
v_fmac_f32 v[vgprValuC+52], v36, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+53], v37, s[sgprBeta]       // finalSum = sum*alpha + C*beta (PK)
v_cmp_class_f32 s12, v[vgprValuC+52], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+52], v41, v42
v_cndmask_b32 v[vgprValuC+52], v39, v[vgprValuC+52], s12
v_cmp_class_f32 s12, v[vgprValuC+53], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+53], v41, v42
v_cndmask_b32 v[vgprValuC+53], v39, v[vgprValuC+53], s12
v_cvt_pk_fp8_f32 v52, v[vgprValuC+52], v[vgprValuC+53] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v52, v84, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cvt_pk_f32_fp8 v[36:37], v85.l op_sel:[0]
s_nop 0
v_fmac_f32 v[vgprValuC+54], v36, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+55], v37, s[sgprBeta]       // finalSum = sum*alpha + C*beta (PK)
v_cmp_class_f32 s12, v[vgprValuC+54], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+54], v41, v42
v_cndmask_b32 v[vgprValuC+54], v39, v[vgprValuC+54], s12
v_cmp_class_f32 s12, v[vgprValuC+55], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+55], v41, v42
v_cndmask_b32 v[vgprValuC+55], v39, v[vgprValuC+55], s12
v_cvt_pk_fp8_f32 v54, v[vgprValuC+54], v[vgprValuC+55] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v54, v86, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cvt_pk_f32_fp8 v[36:37], v87.l op_sel:[0]
s_nop 0
v_fmac_f32 v[vgprValuC+56], v36, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+57], v37, s[sgprBeta]       // finalSum = sum*alpha + C*beta (PK)
v_cmp_class_f32 s12, v[vgprValuC+56], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+56], v41, v42
v_cndmask_b32 v[vgprValuC+56], v39, v[vgprValuC+56], s12
v_cmp_class_f32 s12, v[vgprValuC+57], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+57], v41, v42
v_cndmask_b32 v[vgprValuC+57], v39, v[vgprValuC+57], s12
v_cvt_pk_fp8_f32 v56, v[vgprValuC+56], v[vgprValuC+57] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v56, v88, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cvt_pk_f32_fp8 v[36:37], v89.l op_sel:[0]
s_nop 0
v_fmac_f32 v[vgprValuC+58], v36, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+59], v37, s[sgprBeta]       // finalSum = sum*alpha + C*beta (PK)
v_cmp_class_f32 s12, v[vgprValuC+58], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+58], v41, v42
v_cndmask_b32 v[vgprValuC+58], v39, v[vgprValuC+58], s12
v_cmp_class_f32 s12, v[vgprValuC+59], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+59], v41, v42
v_cndmask_b32 v[vgprValuC+59], v39, v[vgprValuC+59], s12
v_cvt_pk_fp8_f32 v58, v[vgprValuC+58], v[vgprValuC+59] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v58, v90, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cvt_pk_f32_fp8 v[36:37], v91.l op_sel:[0]
s_nop 0
v_fmac_f32 v[vgprValuC+60], v36, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+61], v37, s[sgprBeta]       // finalSum = sum*alpha + C*beta (PK)
v_cmp_class_f32 s12, v[vgprValuC+60], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+60], v41, v42
v_cndmask_b32 v[vgprValuC+60], v39, v[vgprValuC+60], s12
v_cmp_class_f32 s12, v[vgprValuC+61], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+61], v41, v42
v_cndmask_b32 v[vgprValuC+61], v39, v[vgprValuC+61], s12
v_cvt_pk_fp8_f32 v60, v[vgprValuC+60], v[vgprValuC+61] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v60, v92, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cvt_pk_f32_fp8 v[36:37], v93.l op_sel:[0]
s_nop 0
v_fmac_f32 v[vgprValuC+62], v36, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+63], v37, s[sgprBeta]       // finalSum = sum*alpha + C*beta (PK)
v_cmp_class_f32 s12, v[vgprValuC+62], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+62], v41, v42
v_cndmask_b32 v[vgprValuC+62], v39, v[vgprValuC+62], s12
v_cmp_class_f32 s12, v[vgprValuC+63], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+63], v41, v42
v_cndmask_b32 v[vgprValuC+63], v39, v[vgprValuC+63], s12
v_cvt_pk_fp8_f32 v62, v[vgprValuC+62], v[vgprValuC+63] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v62, v94, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cvt_pk_f32_fp8 v[36:37], v95.l op_sel:[0]
s_nop 0
v_fmac_f32 v[vgprValuC+64], v36, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+65], v37, s[sgprBeta]       // finalSum = sum*alpha + C*beta (PK)
v_cmp_class_f32 s12, v[vgprValuC+64], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+64], v41, v42
v_cndmask_b32 v[vgprValuC+64], v39, v[vgprValuC+64], s12
v_cmp_class_f32 s12, v[vgprValuC+65], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+65], v41, v42
v_cndmask_b32 v[vgprValuC+65], v39, v[vgprValuC+65], s12
v_cvt_pk_fp8_f32 v64, v[vgprValuC+64], v[vgprValuC+65] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v64, v96, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cvt_pk_f32_fp8 v[36:37], v97.l op_sel:[0]
s_nop 0
v_fmac_f32 v[vgprValuC+66], v36, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+67], v37, s[sgprBeta]       // finalSum = sum*alpha + C*beta (PK)
v_cmp_class_f32 s12, v[vgprValuC+66], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+66], v41, v42
v_cndmask_b32 v[vgprValuC+66], v39, v[vgprValuC+66], s12
v_cmp_class_f32 s12, v[vgprValuC+67], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+67], v41, v42
v_cndmask_b32 v[vgprValuC+67], v39, v[vgprValuC+67], s12
v_cvt_pk_fp8_f32 v66, v[vgprValuC+66], v[vgprValuC+67] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v66, v98, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cvt_pk_f32_fp8 v[36:37], v99.l op_sel:[0]
s_nop 0
v_fmac_f32 v[vgprValuC+68], v36, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+69], v37, s[sgprBeta]       // finalSum = sum*alpha + C*beta (PK)
v_cmp_class_f32 s12, v[vgprValuC+68], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+68], v41, v42
v_cndmask_b32 v[vgprValuC+68], v39, v[vgprValuC+68], s12
v_cmp_class_f32 s12, v[vgprValuC+69], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+69], v41, v42
v_cndmask_b32 v[vgprValuC+69], v39, v[vgprValuC+69], s12
v_cvt_pk_fp8_f32 v68, v[vgprValuC+68], v[vgprValuC+69] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v68, v100, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cvt_pk_f32_fp8 v[36:37], v101.l op_sel:[0]
s_nop 0
v_fmac_f32 v[vgprValuC+70], v36, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+71], v37, s[sgprBeta]       // finalSum = sum*alpha + C*beta (PK)
v_cmp_class_f32 s12, v[vgprValuC+70], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+70], v41, v42
v_cndmask_b32 v[vgprValuC+70], v39, v[vgprValuC+70], s12
v_cmp_class_f32 s12, v[vgprValuC+71], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+71], v41, v42
v_cndmask_b32 v[vgprValuC+71], v39, v[vgprValuC+71], s12
v_cvt_pk_fp8_f32 v70, v[vgprValuC+70], v[vgprValuC+71] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v70, v102, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cvt_pk_f32_fp8 v[36:37], v103.l op_sel:[0]
s_nop 0
v_fmac_f32 v[vgprValuC+72], v36, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+73], v37, s[sgprBeta]       // finalSum = sum*alpha + C*beta (PK)
v_cmp_class_f32 s12, v[vgprValuC+72], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+72], v41, v42
v_cndmask_b32 v[vgprValuC+72], v39, v[vgprValuC+72], s12
v_cmp_class_f32 s12, v[vgprValuC+73], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+73], v41, v42
v_cndmask_b32 v[vgprValuC+73], v39, v[vgprValuC+73], s12
v_cvt_pk_fp8_f32 v72, v[vgprValuC+72], v[vgprValuC+73] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v72, v104, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cvt_pk_f32_fp8 v[36:37], v105.l op_sel:[0]
s_nop 0
v_fmac_f32 v[vgprValuC+74], v36, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_fmac_f32 v[vgprValuC+75], v37, s[sgprBeta]       // finalSum = sum*alpha + C*beta (PK)
v_cmp_class_f32 s12, v[vgprValuC+74], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+74], v41, v42
v_cndmask_b32 v[vgprValuC+74], v39, v[vgprValuC+74], s12
v_cmp_class_f32 s12, v[vgprValuC+75], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+75], v41, v42
v_cndmask_b32 v[vgprValuC+75], v39, v[vgprValuC+75], s12
v_cvt_pk_fp8_f32 v74, v[vgprValuC+74], v[vgprValuC+75] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b16 v74, v106, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_nop 0                                            // 1 wait state required when next inst writes vgprs held by previous dwordx4 store inst
s_sub_i32 s[sgprCLSLoopCounter], s[sgprCLSLoopCounter], 1
s_cmp_eq_u32 s[sgprCLSLoopCounter], 0
s_cbranch_scc1 label_NoBranch_IXPKU979JKZCQDH3     // Only branch on scc0
// loop while counter != 0
s_wait_xcnt 0
s_prefetch_inst_pc_rel 0, null, 31
s_getpc_b64 s[28:29]                               // addr of next instr
s_add_i32 s30, label_CLS_5, 4                      // target branch offset
s_abs_i32 s30, s30                                 // abs offset
s_sub_u32 s28, s28, s30                            // sub target branch offset
s_subb_u32 s29, s29, 0                             // sub high and carry
s_setpc_b64 s[28:29]                               // branch to label_CLS_5
label_NoBranch_IXPKU979JKZCQDH3:
.set sgprCLSLoopCounter, UNDEF
.set sgprCLSm0Base, UNDEF
s_wait_xcnt 0
s_prefetch_inst_pc_rel 0, null, 31
s_branch label_GW_End_2                            // jump to end
label_GW_B1_FD0_VW2_GSU1_Else:
label_GW_B1_FD0_VW1_GSU1_Else:
label_GW_B1_FD0_VW1_GSU1_Then:
.set sgprCLSm0Base, 8
.set sgprCLSLoopCounter, 11

/* edge=1, allocate 3 sgpr. perBatchTmpS=2 perBatchMaskS=1 perElementMaskS=0 elementsPerBatch=155 */
/* optSingleColVgpr=0 optSharedColVgpr=0 optSGPRUsage=BufferLoad_Edge_Mask optSrdIncForRow=0 factorDim=0 */
/* (d1,vc1,d0,vc0)=(0,0,0,0) */
s_wait_xcnt 0
s_prefetch_inst_pc_rel 0, null, 31
s_wait_dscnt 0                                     // Wait for LDS write
s_barrier_signal -1
s_barrier_wait -1                                  // LDS write barrier
s_mov_b32 s24, 0                                   // Init sgpr offset
s_mov_b32 s25, 0                                   // Init sgpr offset
s_mov_b32 s[sgprCLSm0Base], 0x0                    // CLS M0 base = 0
s_mov_b32 s[sgprCLSLoopCounter], 0x1               // CLS loop iter count

/******************************************/
/* Global Write Beta Edge Batch #0 (d1,d0,vc1,vc0) = */
/*    (0,0,0,0:vw1); (0,0,0,1:vw1); (0,0,1,0:vw1); (0,0,1,1:vw1); (0,0,2,0:vw1); (0,0,2,1:vw1); (0,0,3,0:vw1); (0,0,3,1:vw1); (0,0,4,0:vw1); (0,0,4,1:vw1); (0,0,5,0:vw1); (0,0,5,1:vw1); (0,0,6,0:vw1); (0,0,6,1:vw1); (0,0,7,0:vw1); (0,0,7,1:vw1); (0,0,8,0:vw1); (0,0,8,1:vw1); (0,0,9,0:vw1); (0,0,9,1:vw1); (0,0,10,0:vw1); (0,0,10,1:vw1); (0,0,11,0:vw1); (0,0,11,1:vw1); (0,0,12,0:vw1); (0,0,12,1:vw1); (0,0,13,0:vw1); (0,0,13,1:vw1); (0,0,14,0:vw1); (0,0,14,1:vw1); (0,0,15,0:vw1); (0,0,15,1:vw1) */
/******************************************/
label_CLS_4:
s_wait_xcnt 0
s_prefetch_inst_pc_rel 0, null, 31
s_mov_b32 m0, s[sgprCLSm0Base]                     // LDS clamp at sgpr(CLSm0Base)
s_add_u32 s[sgprCLSm0Base], s[sgprCLSm0Base], 1    // CLS M0 step (src coef of CLS iter dim)

/* calc coords, apply mask, and issue loads (if necessary) */
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v38, BufferOOB
/* (d1,vc1,d0,vc0)=(0,0,0,0) */
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
s_wait_alu depctr_vm_vsrc(6)
v_add_nc_u32 v76, v34, v32                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v76, v38, v76, s26                   // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_d16_u8 v75, v76, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_nc_u32 v76, v35, v32                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v76, v38, v76, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,0,0,1) */
v_add_co_u32 v36, vcc_lo, v32, 1                   // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v36, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v78, v34, v36                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v78, v38, v78, s26                   // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_d16_u8 v77, v78, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_nc_u32 v78, v35, v36                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v78, v38, v78, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v80, v34, v32                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v80, v38, v80, s26                   // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_d16_u8 v79, v80, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_nc_u32 v80, v35, v32                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v80, v38, v80, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,0,1) */
v_add_co_u32 v36, vcc_lo, v32, 1                   // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v36, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v82, v34, v36                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v82, v38, v82, s26                   // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_d16_u8 v81, v82, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_nc_u32 v82, v35, v36                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v82, v38, v82, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v84, v34, v32                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v84, v38, v84, s26                   // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_d16_u8 v83, v84, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_nc_u32 v84, v35, v32                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v84, v38, v84, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,0,1) */
v_add_co_u32 v36, vcc_lo, v32, 1                   // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v36, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v86, v34, v36                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v86, v38, v86, s26                   // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_d16_u8 v85, v86, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_nc_u32 v86, v35, v36                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v86, v38, v86, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v88, v34, v32                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v88, v38, v88, s26                   // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_d16_u8 v87, v88, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_nc_u32 v88, v35, v32                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v88, v38, v88, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,0,1) */
v_add_co_u32 v36, vcc_lo, v32, 1                   // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v36, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v90, v34, v36                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v90, v38, v90, s26                   // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_d16_u8 v89, v90, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_nc_u32 v90, v35, v36                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v90, v38, v90, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,4,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v92, v34, v32                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v92, v38, v92, s26                   // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_d16_u8 v91, v92, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_nc_u32 v92, v35, v32                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v92, v38, v92, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,4,0,1) */
v_add_co_u32 v36, vcc_lo, v32, 1                   // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v36, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v94, v34, v36                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v94, v38, v94, s26                   // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_d16_u8 v93, v94, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_nc_u32 v94, v35, v36                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v94, v38, v94, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,5,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v96, v34, v32                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v96, v38, v96, s26                   // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_d16_u8 v95, v96, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_nc_u32 v96, v35, v32                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v96, v38, v96, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,5,0,1) */
v_add_co_u32 v36, vcc_lo, v32, 1                   // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v36, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v98, v34, v36                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v98, v38, v98, s26                   // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_d16_u8 v97, v98, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_nc_u32 v98, v35, v36                         // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v98, v38, v98, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,6,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v100, v34, v32                        // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v100, v38, v100, s26                 // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_d16_u8 v99, v100, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_nc_u32 v100, v35, v32                        // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v100, v38, v100, s26                 // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,6,0,1) */
v_add_co_u32 v36, vcc_lo, v32, 1                   // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v36, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v102, v34, v36                        // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v102, v38, v102, s26                 // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_d16_u8 v101, v102, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_nc_u32 v102, v35, v36                        // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v102, v38, v102, s26                 // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,7,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v104, v34, v32                        // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v104, v38, v104, s26                 // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_d16_u8 v103, v104, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_nc_u32 v104, v35, v32                        // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v104, v38, v104, s26                 // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,7,0,1) */
v_add_co_u32 v36, vcc_lo, v32, 1                   // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v36, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v106, v34, v36                        // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v106, v38, v106, s26                 // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_d16_u8 v105, v106, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_nc_u32 v106, v35, v36                        // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v106, v38, v106, s26                 // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,8,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v108, v34, v32                        // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v108, v38, v108, s26                 // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_d16_u8 v107, v108, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_nc_u32 v108, v35, v32                        // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v108, v38, v108, s26                 // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,8,0,1) */
v_add_co_u32 v36, vcc_lo, v32, 1                   // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v36, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v110, v34, v36                        // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v110, v38, v110, s26                 // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_d16_u8 v109, v110, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_nc_u32 v110, v35, v36                        // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v110, v38, v110, s26                 // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,9,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v112, v34, v32                        // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v112, v38, v112, s26                 // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_d16_u8 v111, v112, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_nc_u32 v112, v35, v32                        // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v112, v38, v112, s26                 // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,9,0,1) */
v_add_co_u32 v36, vcc_lo, v32, 1                   // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v36, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v114, v34, v36                        // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v114, v38, v114, s26                 // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_d16_u8 v113, v114, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_nc_u32 v114, v35, v36                        // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v114, v38, v114, s26                 // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,10,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v116, v34, v32                        // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v116, v38, v116, s26                 // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_d16_u8 v115, v116, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_nc_u32 v116, v35, v32                        // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v116, v38, v116, s26                 // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,10,0,1) */
v_add_co_u32 v36, vcc_lo, v32, 1                   // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v36, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v118, v34, v36                        // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v118, v38, v118, s26                 // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_d16_u8 v117, v118, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_nc_u32 v118, v35, v36                        // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v118, v38, v118, s26                 // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,11,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v120, v34, v32                        // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v120, v38, v120, s26                 // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_d16_u8 v119, v120, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_nc_u32 v120, v35, v32                        // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v120, v38, v120, s26                 // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,11,0,1) */
v_add_co_u32 v36, vcc_lo, v32, 1                   // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v36, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v122, v34, v36                        // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v122, v38, v122, s26                 // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_d16_u8 v121, v122, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_nc_u32 v122, v35, v36                        // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v122, v38, v122, s26                 // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,12,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v124, v34, v32                        // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v124, v38, v124, s26                 // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_d16_u8 v123, v124, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_nc_u32 v124, v35, v32                        // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v124, v38, v124, s26                 // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,12,0,1) */
v_add_co_u32 v36, vcc_lo, v32, 1                   // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v36, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v126, v34, v36                        // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v126, v38, v126, s26                 // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_d16_u8 v125, v126, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_nc_u32 v126, v35, v36                        // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v126, v38, v126, s26                 // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,13,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v128, v34, v32                        // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v128, v38, v128, s26                 // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_d16_u8 v127, v128, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_nc_u32 v128, v35, v32                        // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v128, v38, v128, s26                 // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,13,0,1) */
v_add_co_u32 v36, vcc_lo, v32, 1                   // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v36, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v130, v34, v36                        // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v130, v38, v130, s26                 // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_d16_u8 v129, v130, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_nc_u32 v130, v35, v36                        // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v130, v38, v130, s26                 // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,14,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v132, v34, v32                        // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v132, v38, v132, s26                 // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_d16_u8 v131, v132, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_nc_u32 v132, v35, v32                        // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v132, v38, v132, s26                 // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,14,0,1) */
v_add_co_u32 v36, vcc_lo, v32, 1                   // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v36, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v134, v34, v36                        // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v134, v38, v134, s26                 // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_d16_u8 v133, v134, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_nc_u32 v134, v35, v36                        // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v134, v38, v134, s26                 // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,15,0,0) */
v_add_co_u32 v33, vcc_lo, v33, 1                   // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v34, v34, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v35, v35, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s12, v32, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v136, v34, v32                        // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v136, v38, v136, s26                 // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_d16_u8 v135, v136, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_nc_u32 v136, v35, v32                        // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v136, v38, v136, s26                 // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,15,0,1) */
v_add_co_u32 v36, vcc_lo, v32, 1                   // coord0.1: coord0 += d0*sg0*VW + vc0
v_cmp_lt_u32 s12, v36, s[sgprSizeI]                // coord0 < size0
v_cmp_lt_u32 s26, v33, s[sgprSizeJ]                // coord1 < size1
s_and_b32 s26, s12, s26                            // in0 && in1
v_add_nc_u32 v138, v34, v36                        // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v138, v38, v138, s26                 // LDC clip if OOB. offset
s_wait_alu depctr_va_vdst(0)
buffer_load_d16_u8 v137, v138, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_wait_alu depctr_vm_vsrc(0)
v_add_nc_u32 v138, v35, v36                        // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
                                                   // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (bpe is 1, no mul)
v_cndmask_b32 v138, v38, v138, s26                 // LDD clip if OOB. offset
v_movrelsd_2_b32 v[vgprValuC+43], v[vgprValuC+0]   // copy MI out reg to vreg[0]
v_movrelsd_2_b32 v[vgprValuC+44], v[vgprValuC+8]   // copy MI out reg to vreg[1]
v_movrelsd_2_b32 v[vgprValuC+45], v[vgprValuC+16]  // copy MI out reg to vreg[2]
v_movrelsd_2_b32 v[vgprValuC+46], v[vgprValuC+24]  // copy MI out reg to vreg[3]
v_movrelsd_2_b32 v[vgprValuC+47], v[vgprValuC+1]   // copy MI out reg to vreg[4]
v_movrelsd_2_b32 v[vgprValuC+48], v[vgprValuC+9]   // copy MI out reg to vreg[5]
v_movrelsd_2_b32 v[vgprValuC+49], v[vgprValuC+17]  // copy MI out reg to vreg[6]
v_movrelsd_2_b32 v[vgprValuC+50], v[vgprValuC+25]  // copy MI out reg to vreg[7]
v_movrelsd_2_b32 v[vgprValuC+51], v[vgprValuC+2]   // copy MI out reg to vreg[8]
v_movrelsd_2_b32 v[vgprValuC+52], v[vgprValuC+10]  // copy MI out reg to vreg[9]
v_movrelsd_2_b32 v[vgprValuC+53], v[vgprValuC+18]  // copy MI out reg to vreg[10]
v_movrelsd_2_b32 v[vgprValuC+54], v[vgprValuC+26]  // copy MI out reg to vreg[11]
v_movrelsd_2_b32 v[vgprValuC+55], v[vgprValuC+3]   // copy MI out reg to vreg[12]
v_movrelsd_2_b32 v[vgprValuC+56], v[vgprValuC+11]  // copy MI out reg to vreg[13]
v_movrelsd_2_b32 v[vgprValuC+57], v[vgprValuC+19]  // copy MI out reg to vreg[14]
v_movrelsd_2_b32 v[vgprValuC+58], v[vgprValuC+27]  // copy MI out reg to vreg[15]
v_movrelsd_2_b32 v[vgprValuC+59], v[vgprValuC+4]   // copy MI out reg to vreg[16]
v_movrelsd_2_b32 v[vgprValuC+60], v[vgprValuC+12]  // copy MI out reg to vreg[17]
v_movrelsd_2_b32 v[vgprValuC+61], v[vgprValuC+20]  // copy MI out reg to vreg[18]
v_movrelsd_2_b32 v[vgprValuC+62], v[vgprValuC+28]  // copy MI out reg to vreg[19]
v_movrelsd_2_b32 v[vgprValuC+63], v[vgprValuC+5]   // copy MI out reg to vreg[20]
v_movrelsd_2_b32 v[vgprValuC+64], v[vgprValuC+13]  // copy MI out reg to vreg[21]
v_movrelsd_2_b32 v[vgprValuC+65], v[vgprValuC+21]  // copy MI out reg to vreg[22]
v_movrelsd_2_b32 v[vgprValuC+66], v[vgprValuC+29]  // copy MI out reg to vreg[23]
v_movrelsd_2_b32 v[vgprValuC+67], v[vgprValuC+6]   // copy MI out reg to vreg[24]
v_movrelsd_2_b32 v[vgprValuC+68], v[vgprValuC+14]  // copy MI out reg to vreg[25]
v_movrelsd_2_b32 v[vgprValuC+69], v[vgprValuC+22]  // copy MI out reg to vreg[26]
v_movrelsd_2_b32 v[vgprValuC+70], v[vgprValuC+30]  // copy MI out reg to vreg[27]
v_movrelsd_2_b32 v[vgprValuC+71], v[vgprValuC+7]   // copy MI out reg to vreg[28]
v_movrelsd_2_b32 v[vgprValuC+72], v[vgprValuC+15]  // copy MI out reg to vreg[29]
v_movrelsd_2_b32 v[vgprValuC+73], v[vgprValuC+23]  // copy MI out reg to vreg[30]
v_movrelsd_2_b32 v[vgprValuC+74], v[vgprValuC+31]  // copy MI out reg to vreg[31]

/* rC *= alpha batchElements=[(0, 0, 0, 0), (0, 0, 0, 1), (0, 0, 1, 0), (0, 0, 1, 1), (0, 0, 2, 0), (0, 0, 2, 1), (0, 0, 3, 0), (0, 0, 3, 1), (0, 0, 4, 0), (0, 0, 4, 1), (0, 0, 5, 0), (0, 0, 5, 1), (0, 0, 6, 0), (0, 0, 6, 1), (0, 0, 7, 0), (0, 0, 7, 1), (0, 0, 8, 0), (0, 0, 8, 1), (0, 0, 9, 0), (0, 0, 9, 1), (0, 0, 10, 0), (0, 0, 10, 1), (0, 0, 11, 0), (0, 0, 11, 1), (0, 0, 12, 0), (0, 0, 12, 1), (0, 0, 13, 0), (0, 0, 13, 1), (0, 0, 14, 0), (0, 0, 14, 1), (0, 0, 15, 0), (0, 0, 15, 1)] */
v_mul_f32 v[vgprValuC+43], s[sgprAlpha], v[vgprValuC+43] // *= alpha
v_pk_mul_f32 v[vgprValuC+44:vgprValuC+44+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+44:vgprValuC+44+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+46:vgprValuC+46+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+46:vgprValuC+46+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+48:vgprValuC+48+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+48:vgprValuC+48+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+50:vgprValuC+50+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+50:vgprValuC+50+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+52:vgprValuC+52+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+52:vgprValuC+52+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+54:vgprValuC+54+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+54:vgprValuC+54+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+56:vgprValuC+56+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+56:vgprValuC+56+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+58:vgprValuC+58+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+58:vgprValuC+58+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+60:vgprValuC+60+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+60:vgprValuC+60+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+62:vgprValuC+62+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+62:vgprValuC+62+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+64:vgprValuC+64+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+64:vgprValuC+64+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+66:vgprValuC+66+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+66:vgprValuC+66+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+68:vgprValuC+68+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+68:vgprValuC+68+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+70:vgprValuC+70+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+70:vgprValuC+70+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_pk_mul_f32 v[vgprValuC+72:vgprValuC+72+1], s[sgprAlpha:sgprAlpha+1], v[vgprValuC+72:vgprValuC+72+1] op_sel_hi:[0,1,1] // *= alpha (pk)
v_mul_f32 v[vgprValuC+74], s[sgprAlpha], v[vgprValuC+74] // *= alpha
s_wait_loadcnt 0                                   // wait for Beta

/* apply mask, calc new C and issue writes */
v_mov_b32 v40, 0x207                               // Nan and +/- inf
v_mov_b32 v42, 0x43E00000                          // Fp8 Max value 448 as float32
v_mov_b32 v41, 0xc3E00000                          // Fp8 Min value -448 as float32
v_cvt_f32_fp8 v36, v75 byte_sel:[0]
s_nop 0
v_fmac_f32 v[vgprValuC+43], v36, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_cmp_class_f32 s12, v[vgprValuC+43], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+43], v41, v42
v_cndmask_b32 v[vgprValuC+43], v39, v[vgprValuC+43], s12
v_cvt_pk_fp8_f32 v43, v[vgprValuC+43], v[vgprValuC+43] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v43, v76, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cvt_f32_fp8 v36, v77 byte_sel:[0]
s_nop 0
v_fmac_f32 v[vgprValuC+44], v36, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_cmp_class_f32 s12, v[vgprValuC+44], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+44], v41, v42
v_cndmask_b32 v[vgprValuC+44], v39, v[vgprValuC+44], s12
v_cvt_pk_fp8_f32 v44, v[vgprValuC+44], v[vgprValuC+44] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v44, v78, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cvt_f32_fp8 v36, v79 byte_sel:[0]
s_nop 0
v_fmac_f32 v[vgprValuC+45], v36, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_cmp_class_f32 s12, v[vgprValuC+45], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+45], v41, v42
v_cndmask_b32 v[vgprValuC+45], v39, v[vgprValuC+45], s12
v_cvt_pk_fp8_f32 v45, v[vgprValuC+45], v[vgprValuC+45] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v45, v80, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cvt_f32_fp8 v36, v81 byte_sel:[0]
s_nop 0
v_fmac_f32 v[vgprValuC+46], v36, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_cmp_class_f32 s12, v[vgprValuC+46], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+46], v41, v42
v_cndmask_b32 v[vgprValuC+46], v39, v[vgprValuC+46], s12
v_cvt_pk_fp8_f32 v46, v[vgprValuC+46], v[vgprValuC+46] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v46, v82, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cvt_f32_fp8 v36, v83 byte_sel:[0]
s_nop 0
v_fmac_f32 v[vgprValuC+47], v36, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_cmp_class_f32 s12, v[vgprValuC+47], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+47], v41, v42
v_cndmask_b32 v[vgprValuC+47], v39, v[vgprValuC+47], s12
v_cvt_pk_fp8_f32 v47, v[vgprValuC+47], v[vgprValuC+47] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v47, v84, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cvt_f32_fp8 v36, v85 byte_sel:[0]
s_nop 0
v_fmac_f32 v[vgprValuC+48], v36, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_cmp_class_f32 s12, v[vgprValuC+48], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+48], v41, v42
v_cndmask_b32 v[vgprValuC+48], v39, v[vgprValuC+48], s12
v_cvt_pk_fp8_f32 v48, v[vgprValuC+48], v[vgprValuC+48] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v48, v86, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cvt_f32_fp8 v36, v87 byte_sel:[0]
s_nop 0
v_fmac_f32 v[vgprValuC+49], v36, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_cmp_class_f32 s12, v[vgprValuC+49], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+49], v41, v42
v_cndmask_b32 v[vgprValuC+49], v39, v[vgprValuC+49], s12
v_cvt_pk_fp8_f32 v49, v[vgprValuC+49], v[vgprValuC+49] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v49, v88, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cvt_f32_fp8 v36, v89 byte_sel:[0]
s_nop 0
v_fmac_f32 v[vgprValuC+50], v36, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_cmp_class_f32 s12, v[vgprValuC+50], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+50], v41, v42
v_cndmask_b32 v[vgprValuC+50], v39, v[vgprValuC+50], s12
v_cvt_pk_fp8_f32 v50, v[vgprValuC+50], v[vgprValuC+50] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v50, v90, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cvt_f32_fp8 v36, v91 byte_sel:[0]
s_nop 0
v_fmac_f32 v[vgprValuC+51], v36, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_cmp_class_f32 s12, v[vgprValuC+51], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+51], v41, v42
v_cndmask_b32 v[vgprValuC+51], v39, v[vgprValuC+51], s12
v_cvt_pk_fp8_f32 v51, v[vgprValuC+51], v[vgprValuC+51] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v51, v92, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cvt_f32_fp8 v36, v93 byte_sel:[0]
s_nop 0
v_fmac_f32 v[vgprValuC+52], v36, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_cmp_class_f32 s12, v[vgprValuC+52], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+52], v41, v42
v_cndmask_b32 v[vgprValuC+52], v39, v[vgprValuC+52], s12
v_cvt_pk_fp8_f32 v52, v[vgprValuC+52], v[vgprValuC+52] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v52, v94, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cvt_f32_fp8 v36, v95 byte_sel:[0]
s_nop 0
v_fmac_f32 v[vgprValuC+53], v36, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_cmp_class_f32 s12, v[vgprValuC+53], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+53], v41, v42
v_cndmask_b32 v[vgprValuC+53], v39, v[vgprValuC+53], s12
v_cvt_pk_fp8_f32 v53, v[vgprValuC+53], v[vgprValuC+53] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v53, v96, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cvt_f32_fp8 v36, v97 byte_sel:[0]
s_nop 0
v_fmac_f32 v[vgprValuC+54], v36, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_cmp_class_f32 s12, v[vgprValuC+54], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+54], v41, v42
v_cndmask_b32 v[vgprValuC+54], v39, v[vgprValuC+54], s12
v_cvt_pk_fp8_f32 v54, v[vgprValuC+54], v[vgprValuC+54] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v54, v98, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cvt_f32_fp8 v36, v99 byte_sel:[0]
s_nop 0
v_fmac_f32 v[vgprValuC+55], v36, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_cmp_class_f32 s12, v[vgprValuC+55], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+55], v41, v42
v_cndmask_b32 v[vgprValuC+55], v39, v[vgprValuC+55], s12
v_cvt_pk_fp8_f32 v55, v[vgprValuC+55], v[vgprValuC+55] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v55, v100, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cvt_f32_fp8 v36, v101 byte_sel:[0]
s_nop 0
v_fmac_f32 v[vgprValuC+56], v36, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_cmp_class_f32 s12, v[vgprValuC+56], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+56], v41, v42
v_cndmask_b32 v[vgprValuC+56], v39, v[vgprValuC+56], s12
v_cvt_pk_fp8_f32 v56, v[vgprValuC+56], v[vgprValuC+56] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v56, v102, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cvt_f32_fp8 v36, v103 byte_sel:[0]
s_nop 0
v_fmac_f32 v[vgprValuC+57], v36, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_cmp_class_f32 s12, v[vgprValuC+57], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+57], v41, v42
v_cndmask_b32 v[vgprValuC+57], v39, v[vgprValuC+57], s12
v_cvt_pk_fp8_f32 v57, v[vgprValuC+57], v[vgprValuC+57] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v57, v104, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cvt_f32_fp8 v36, v105 byte_sel:[0]
s_nop 0
v_fmac_f32 v[vgprValuC+58], v36, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_cmp_class_f32 s12, v[vgprValuC+58], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+58], v41, v42
v_cndmask_b32 v[vgprValuC+58], v39, v[vgprValuC+58], s12
v_cvt_pk_fp8_f32 v58, v[vgprValuC+58], v[vgprValuC+58] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v58, v106, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cvt_f32_fp8 v36, v107 byte_sel:[0]
s_nop 0
v_fmac_f32 v[vgprValuC+59], v36, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_cmp_class_f32 s12, v[vgprValuC+59], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+59], v41, v42
v_cndmask_b32 v[vgprValuC+59], v39, v[vgprValuC+59], s12
v_cvt_pk_fp8_f32 v59, v[vgprValuC+59], v[vgprValuC+59] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v59, v108, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cvt_f32_fp8 v36, v109 byte_sel:[0]
s_nop 0
v_fmac_f32 v[vgprValuC+60], v36, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_cmp_class_f32 s12, v[vgprValuC+60], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+60], v41, v42
v_cndmask_b32 v[vgprValuC+60], v39, v[vgprValuC+60], s12
v_cvt_pk_fp8_f32 v60, v[vgprValuC+60], v[vgprValuC+60] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v60, v110, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cvt_f32_fp8 v36, v111 byte_sel:[0]
s_nop 0
s_wait_xcnt 0
s_prefetch_inst_pc_rel 0, null, 31
v_fmac_f32 v[vgprValuC+61], v36, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_cmp_class_f32 s12, v[vgprValuC+61], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+61], v41, v42
v_cndmask_b32 v[vgprValuC+61], v39, v[vgprValuC+61], s12
v_cvt_pk_fp8_f32 v61, v[vgprValuC+61], v[vgprValuC+61] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v61, v112, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cvt_f32_fp8 v36, v113 byte_sel:[0]
s_nop 0
v_fmac_f32 v[vgprValuC+62], v36, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_cmp_class_f32 s12, v[vgprValuC+62], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+62], v41, v42
v_cndmask_b32 v[vgprValuC+62], v39, v[vgprValuC+62], s12
v_cvt_pk_fp8_f32 v62, v[vgprValuC+62], v[vgprValuC+62] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v62, v114, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cvt_f32_fp8 v36, v115 byte_sel:[0]
s_nop 0
v_fmac_f32 v[vgprValuC+63], v36, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_cmp_class_f32 s12, v[vgprValuC+63], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+63], v41, v42
v_cndmask_b32 v[vgprValuC+63], v39, v[vgprValuC+63], s12
v_cvt_pk_fp8_f32 v63, v[vgprValuC+63], v[vgprValuC+63] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v63, v116, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cvt_f32_fp8 v36, v117 byte_sel:[0]
s_nop 0
v_fmac_f32 v[vgprValuC+64], v36, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_cmp_class_f32 s12, v[vgprValuC+64], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+64], v41, v42
v_cndmask_b32 v[vgprValuC+64], v39, v[vgprValuC+64], s12
v_cvt_pk_fp8_f32 v64, v[vgprValuC+64], v[vgprValuC+64] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v64, v118, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cvt_f32_fp8 v36, v119 byte_sel:[0]
s_nop 0
v_fmac_f32 v[vgprValuC+65], v36, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_cmp_class_f32 s12, v[vgprValuC+65], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+65], v41, v42
v_cndmask_b32 v[vgprValuC+65], v39, v[vgprValuC+65], s12
v_cvt_pk_fp8_f32 v65, v[vgprValuC+65], v[vgprValuC+65] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v65, v120, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cvt_f32_fp8 v36, v121 byte_sel:[0]
s_nop 0
v_fmac_f32 v[vgprValuC+66], v36, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_cmp_class_f32 s12, v[vgprValuC+66], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+66], v41, v42
v_cndmask_b32 v[vgprValuC+66], v39, v[vgprValuC+66], s12
v_cvt_pk_fp8_f32 v66, v[vgprValuC+66], v[vgprValuC+66] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v66, v122, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cvt_f32_fp8 v36, v123 byte_sel:[0]
s_nop 0
v_fmac_f32 v[vgprValuC+67], v36, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_cmp_class_f32 s12, v[vgprValuC+67], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+67], v41, v42
v_cndmask_b32 v[vgprValuC+67], v39, v[vgprValuC+67], s12
v_cvt_pk_fp8_f32 v67, v[vgprValuC+67], v[vgprValuC+67] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v67, v124, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cvt_f32_fp8 v36, v125 byte_sel:[0]
s_nop 0
v_fmac_f32 v[vgprValuC+68], v36, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_cmp_class_f32 s12, v[vgprValuC+68], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+68], v41, v42
v_cndmask_b32 v[vgprValuC+68], v39, v[vgprValuC+68], s12
v_cvt_pk_fp8_f32 v68, v[vgprValuC+68], v[vgprValuC+68] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v68, v126, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cvt_f32_fp8 v36, v127 byte_sel:[0]
s_nop 0
v_fmac_f32 v[vgprValuC+69], v36, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_cmp_class_f32 s12, v[vgprValuC+69], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+69], v41, v42
v_cndmask_b32 v[vgprValuC+69], v39, v[vgprValuC+69], s12
v_cvt_pk_fp8_f32 v69, v[vgprValuC+69], v[vgprValuC+69] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v69, v128, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cvt_f32_fp8 v36, v129 byte_sel:[0]
s_nop 0
v_fmac_f32 v[vgprValuC+70], v36, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_cmp_class_f32 s12, v[vgprValuC+70], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+70], v41, v42
v_cndmask_b32 v[vgprValuC+70], v39, v[vgprValuC+70], s12
v_cvt_pk_fp8_f32 v70, v[vgprValuC+70], v[vgprValuC+70] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v70, v130, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cvt_f32_fp8 v36, v131 byte_sel:[0]
s_nop 0
v_fmac_f32 v[vgprValuC+71], v36, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_cmp_class_f32 s12, v[vgprValuC+71], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+71], v41, v42
v_cndmask_b32 v[vgprValuC+71], v39, v[vgprValuC+71], s12
v_cvt_pk_fp8_f32 v71, v[vgprValuC+71], v[vgprValuC+71] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v71, v132, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cvt_f32_fp8 v36, v133 byte_sel:[0]
s_nop 0
v_fmac_f32 v[vgprValuC+72], v36, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_cmp_class_f32 s12, v[vgprValuC+72], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+72], v41, v42
v_cndmask_b32 v[vgprValuC+72], v39, v[vgprValuC+72], s12
v_cvt_pk_fp8_f32 v72, v[vgprValuC+72], v[vgprValuC+72] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v72, v134, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cvt_f32_fp8 v36, v135 byte_sel:[0]
s_nop 0
v_fmac_f32 v[vgprValuC+73], v36, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_cmp_class_f32 s12, v[vgprValuC+73], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+73], v41, v42
v_cndmask_b32 v[vgprValuC+73], v39, v[vgprValuC+73], s12
v_cvt_pk_fp8_f32 v73, v[vgprValuC+73], v[vgprValuC+73] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v73, v136, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_cvt_f32_fp8 v36, v137 byte_sel:[0]
s_nop 0
v_fmac_f32 v[vgprValuC+74], v36, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_cmp_class_f32 s12, v[vgprValuC+74], v40          // Nan and +/- inf
v_med3_f32 v39, v[vgprValuC+74], v41, v42
v_cndmask_b32 v[vgprValuC+74], v39, v[vgprValuC+74], s12
v_cvt_pk_fp8_f32 v74, v[vgprValuC+74], v[vgprValuC+74] op_sel:[0,0,0]
s_wait_alu depctr_va_vdst(0)
buffer_store_b8 v74, v138, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_nop 0                                            // 1 wait state required when next inst writes vgprs held by previous dwordx4 store inst
s_sub_i32 s[sgprCLSLoopCounter], s[sgprCLSLoopCounter], 1
s_cmp_eq_u32 s[sgprCLSLoopCounter], 0
s_cbranch_scc1 label_NoBranch_0MXDW6EW9K7ZNG8F     // Only branch on scc0
// loop while counter != 0
s_wait_xcnt 0
s_prefetch_inst_pc_rel 0, null, 31
s_getpc_b64 s[28:29]                               // addr of next instr
s_add_i32 s30, label_CLS_4, 4                      // target branch offset
s_abs_i32 s30, s30                                 // abs offset
s_sub_u32 s28, s28, s30                            // sub target branch offset
s_subb_u32 s29, s29, 0                             // sub high and carry
s_setpc_b64 s[28:29]                               // branch to label_CLS_4
label_NoBranch_0MXDW6EW9K7ZNG8F:
.set sgprCLSLoopCounter, UNDEF
.set sgprCLSm0Base, UNDEF
s_wait_xcnt 0
s_prefetch_inst_pc_rel 0, null, 31
s_branch label_GW_End_2                            // jump to end
label_GW_End_2:
label_KernelEnd:
s_wait_xcnt 0
s_prefetch_inst_pc_rel 0, null, 31
s_endpgm                                           // Kernel End
label_ASM_End:  /// The end of the kernel
