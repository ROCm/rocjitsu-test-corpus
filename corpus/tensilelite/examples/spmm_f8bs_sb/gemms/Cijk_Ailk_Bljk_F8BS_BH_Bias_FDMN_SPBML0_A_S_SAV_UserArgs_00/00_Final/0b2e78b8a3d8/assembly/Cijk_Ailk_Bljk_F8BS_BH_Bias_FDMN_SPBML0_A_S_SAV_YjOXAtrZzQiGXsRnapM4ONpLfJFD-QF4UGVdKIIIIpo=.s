
/******************************************/
/* Begin Kernel                           */
/******************************************/
/* STINKY_TOTAL_INST_BYTES: 39980 */
.amdgcn_target "amdgcn-amd-amdhsa--gfx1250"
.text
.protected Cijk_Ailk_Bljk_F8BS_BH_Bias_FDMN_SPBML0_A_S_SAV_UserArgs_MT16x16x128_MI16x16x1_SN_LDSB0_AFC1_AG0_AGGSUA0_AGNTAB0_AFEM1_AFEM1_ASEM8_BL1_BS1_CD1_1_CLR0_CLS0_CADS0_DTLA0_DTLB0_DTLM0_DTVA0_DTVB0_DTVMXSA0_DTVMXSB0_DTVSM0_DPLB0_EPS1_ELFLR0_EMLLn1_FDSI0_GRPM1_GRVWA16_GRVWB16_GSUAMB_GLS0_HPLR0_ISA1250_ICIW0_IU1_K1_LDSTI0_LBSPPA256_LBSPPB256_LBSPPMXSA0_LBSPPMXSB0_LBSPPM0_LPA16_LPB16_LPMXSA0_LPMXSB0_LPM4_LRVWn1_LWPMn1_MIAV1_MIWT1_1_MXLIBL_MXSFNS_MO40_MGRIPM1_NTn1_NTA0_NTB0_NTC0_NTD0_NTE0_NTMXSA0_NTMXSB0_NTM0_NTWS0_NVn1_NVA0_NVB0_NVC0_NVD0_NVE0_NVMXSA0_NVMXSB0_NVM0_NVWS0_NEPBS0_NLCA1_NLCB1_ONLL1_PAP0_PGL0_PGR2_PLR0_PKA1_SGROB0_SIA3_SS1_SPO0_SRVW0_SSO0_SVW1_SK0_SKFTR0_SKFDPO0_SKWS0_SKXCCM0_SNLL0_SIP1_SGRO0_TDMI0_TDMIM0_TDMLWS0_TDMS0_TIN0_THn1_THA0_THB0_THC0_THD0_THE0_THMXSA0_THMXSB0_THM0_THWS0_TLDS1_TLDSM1_ULSGRO0_USL1_USLMX0_UDFMAC0_UIOFGRO0_UPLRP0_USFGROn1_USI0_VSn1_VWA1_VWB1_WSGRA0_WSGRB0_WS32_WG16_2_1_WGMXCC1
.globl Cijk_Ailk_Bljk_F8BS_BH_Bias_FDMN_SPBML0_A_S_SAV_UserArgs_MT16x16x128_MI16x16x1_SN_LDSB0_AFC1_AG0_AGGSUA0_AGNTAB0_AFEM1_AFEM1_ASEM8_BL1_BS1_CD1_1_CLR0_CLS0_CADS0_DTLA0_DTLB0_DTLM0_DTVA0_DTVB0_DTVMXSA0_DTVMXSB0_DTVSM0_DPLB0_EPS1_ELFLR0_EMLLn1_FDSI0_GRPM1_GRVWA16_GRVWB16_GSUAMB_GLS0_HPLR0_ISA1250_ICIW0_IU1_K1_LDSTI0_LBSPPA256_LBSPPB256_LBSPPMXSA0_LBSPPMXSB0_LBSPPM0_LPA16_LPB16_LPMXSA0_LPMXSB0_LPM4_LRVWn1_LWPMn1_MIAV1_MIWT1_1_MXLIBL_MXSFNS_MO40_MGRIPM1_NTn1_NTA0_NTB0_NTC0_NTD0_NTE0_NTMXSA0_NTMXSB0_NTM0_NTWS0_NVn1_NVA0_NVB0_NVC0_NVD0_NVE0_NVMXSA0_NVMXSB0_NVM0_NVWS0_NEPBS0_NLCA1_NLCB1_ONLL1_PAP0_PGL0_PGR2_PLR0_PKA1_SGROB0_SIA3_SS1_SPO0_SRVW0_SSO0_SVW1_SK0_SKFTR0_SKFDPO0_SKWS0_SKXCCM0_SNLL0_SIP1_SGRO0_TDMI0_TDMIM0_TDMLWS0_TDMS0_TIN0_THn1_THA0_THB0_THC0_THD0_THE0_THMXSA0_THMXSB0_THM0_THWS0_TLDS1_TLDSM1_ULSGRO0_USL1_USLMX0_UDFMAC0_UIOFGRO0_UPLRP0_USFGROn1_USI0_VSn1_VWA1_VWB1_WSGRA0_WSGRB0_WS32_WG16_2_1_WGMXCC1
.p2align 8
.type Cijk_Ailk_Bljk_F8BS_BH_Bias_FDMN_SPBML0_A_S_SAV_UserArgs_MT16x16x128_MI16x16x1_SN_LDSB0_AFC1_AG0_AGGSUA0_AGNTAB0_AFEM1_AFEM1_ASEM8_BL1_BS1_CD1_1_CLR0_CLS0_CADS0_DTLA0_DTLB0_DTLM0_DTVA0_DTVB0_DTVMXSA0_DTVMXSB0_DTVSM0_DPLB0_EPS1_ELFLR0_EMLLn1_FDSI0_GRPM1_GRVWA16_GRVWB16_GSUAMB_GLS0_HPLR0_ISA1250_ICIW0_IU1_K1_LDSTI0_LBSPPA256_LBSPPB256_LBSPPMXSA0_LBSPPMXSB0_LBSPPM0_LPA16_LPB16_LPMXSA0_LPMXSB0_LPM4_LRVWn1_LWPMn1_MIAV1_MIWT1_1_MXLIBL_MXSFNS_MO40_MGRIPM1_NTn1_NTA0_NTB0_NTC0_NTD0_NTE0_NTMXSA0_NTMXSB0_NTM0_NTWS0_NVn1_NVA0_NVB0_NVC0_NVD0_NVE0_NVMXSA0_NVMXSB0_NVM0_NVWS0_NEPBS0_NLCA1_NLCB1_ONLL1_PAP0_PGL0_PGR2_PLR0_PKA1_SGROB0_SIA3_SS1_SPO0_SRVW0_SSO0_SVW1_SK0_SKFTR0_SKFDPO0_SKWS0_SKXCCM0_SNLL0_SIP1_SGRO0_TDMI0_TDMIM0_TDMLWS0_TDMS0_TIN0_THn1_THA0_THB0_THC0_THD0_THE0_THMXSA0_THMXSB0_THM0_THWS0_TLDS1_TLDSM1_ULSGRO0_USL1_USLMX0_UDFMAC0_UIOFGRO0_UPLRP0_USFGROn1_USI0_VSn1_VWA1_VWB1_WSGRA0_WSGRB0_WS32_WG16_2_1_WGMXCC1,@function
.section .rodata,#alloc
.p2align 6
.amdhsa_kernel Cijk_Ailk_Bljk_F8BS_BH_Bias_FDMN_SPBML0_A_S_SAV_UserArgs_MT16x16x128_MI16x16x1_SN_LDSB0_AFC1_AG0_AGGSUA0_AGNTAB0_AFEM1_AFEM1_ASEM8_BL1_BS1_CD1_1_CLR0_CLS0_CADS0_DTLA0_DTLB0_DTLM0_DTVA0_DTVB0_DTVMXSA0_DTVMXSB0_DTVSM0_DPLB0_EPS1_ELFLR0_EMLLn1_FDSI0_GRPM1_GRVWA16_GRVWB16_GSUAMB_GLS0_HPLR0_ISA1250_ICIW0_IU1_K1_LDSTI0_LBSPPA256_LBSPPB256_LBSPPMXSA0_LBSPPMXSB0_LBSPPM0_LPA16_LPB16_LPMXSA0_LPMXSB0_LPM4_LRVWn1_LWPMn1_MIAV1_MIWT1_1_MXLIBL_MXSFNS_MO40_MGRIPM1_NTn1_NTA0_NTB0_NTC0_NTD0_NTE0_NTMXSA0_NTMXSB0_NTM0_NTWS0_NVn1_NVA0_NVB0_NVC0_NVD0_NVE0_NVMXSA0_NVMXSB0_NVM0_NVWS0_NEPBS0_NLCA1_NLCB1_ONLL1_PAP0_PGL0_PGR2_PLR0_PKA1_SGROB0_SIA3_SS1_SPO0_SRVW0_SSO0_SVW1_SK0_SKFTR0_SKFDPO0_SKWS0_SKXCCM0_SNLL0_SIP1_SGRO0_TDMI0_TDMIM0_TDMLWS0_TDMS0_TIN0_THn1_THA0_THB0_THC0_THD0_THE0_THMXSA0_THMXSB0_THM0_THWS0_TLDS1_TLDSM1_ULSGRO0_USL1_USLMX0_UDFMAC0_UIOFGRO0_UPLRP0_USFGROn1_USI0_VSn1_VWA1_VWB1_WSGRA0_WSGRB0_WS32_WG16_2_1_WGMXCC1
  .amdhsa_user_sgpr_kernarg_segment_ptr 1
  .amdhsa_next_free_vgpr 256 // vgprs
  .amdhsa_next_free_sgpr 84 // sgprs
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
  .amdhsa_user_sgpr_count 29
  .amdhsa_user_sgpr_kernarg_preload_length 27
  .amdhsa_user_sgpr_kernarg_preload_offset 0
.end_amdhsa_kernel
.text
/* Num VGPR   =256 */
/* Num AccVGPR=0 */
/* Num SGPR   =84 */

/******************************************/
/* Optimizations and Config:              */
/******************************************/
/* ThreadTile= 8 x 1 */
/* SubGroup= 2 x 16 */
/* VectorWidthA=1 */
/* VectorWidthB=1 */
/* GlobalReadVectorWidthA=16, GlobalReadVectorWidthB=16 */
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
  - .name: Cijk_Ailk_Bljk_F8BS_BH_Bias_FDMN_SPBML0_A_S_SAV_UserArgs_MT16x16x128_MI16x16x1_SN_LDSB0_AFC1_AG0_AGGSUA0_AGNTAB0_AFEM1_AFEM1_ASEM8_BL1_BS1_CD1_1_CLR0_CLS0_CADS0_DTLA0_DTLB0_DTLM0_DTVA0_DTVB0_DTVMXSA0_DTVMXSB0_DTVSM0_DPLB0_EPS1_ELFLR0_EMLLn1_FDSI0_GRPM1_GRVWA16_GRVWB16_GSUAMB_GLS0_HPLR0_ISA1250_ICIW0_IU1_K1_LDSTI0_LBSPPA256_LBSPPB256_LBSPPMXSA0_LBSPPMXSB0_LBSPPM0_LPA16_LPB16_LPMXSA0_LPMXSB0_LPM4_LRVWn1_LWPMn1_MIAV1_MIWT1_1_MXLIBL_MXSFNS_MO40_MGRIPM1_NTn1_NTA0_NTB0_NTC0_NTD0_NTE0_NTMXSA0_NTMXSB0_NTM0_NTWS0_NVn1_NVA0_NVB0_NVC0_NVD0_NVE0_NVMXSA0_NVMXSB0_NVM0_NVWS0_NEPBS0_NLCA1_NLCB1_ONLL1_PAP0_PGL0_PGR2_PLR0_PKA1_SGROB0_SIA3_SS1_SPO0_SRVW0_SSO0_SVW1_SK0_SKFTR0_SKFDPO0_SKWS0_SKXCCM0_SNLL0_SIP1_SGRO0_TDMI0_TDMIM0_TDMLWS0_TDMS0_TIN0_THn1_THA0_THB0_THC0_THD0_THE0_THMXSA0_THMXSB0_THM0_THWS0_TLDS1_TLDSM1_ULSGRO0_USL1_USLMX0_UDFMAC0_UIOFGRO0_UPLRP0_USFGROn1_USI0_VSn1_VWA1_VWB1_WSGRA0_WSGRB0_WS32_WG16_2_1_WGMXCC1
    .symbol: 'Cijk_Ailk_Bljk_F8BS_BH_Bias_FDMN_SPBML0_A_S_SAV_UserArgs_MT16x16x128_MI16x16x1_SN_LDSB0_AFC1_AG0_AGGSUA0_AGNTAB0_AFEM1_AFEM1_ASEM8_BL1_BS1_CD1_1_CLR0_CLS0_CADS0_DTLA0_DTLB0_DTLM0_DTVA0_DTVB0_DTVMXSA0_DTVMXSB0_DTVSM0_DPLB0_EPS1_ELFLR0_EMLLn1_FDSI0_GRPM1_GRVWA16_GRVWB16_GSUAMB_GLS0_HPLR0_ISA1250_ICIW0_IU1_K1_LDSTI0_LBSPPA256_LBSPPB256_LBSPPMXSA0_LBSPPMXSB0_LBSPPM0_LPA16_LPB16_LPMXSA0_LPMXSB0_LPM4_LRVWn1_LWPMn1_MIAV1_MIWT1_1_MXLIBL_MXSFNS_MO40_MGRIPM1_NTn1_NTA0_NTB0_NTC0_NTD0_NTE0_NTMXSA0_NTMXSB0_NTM0_NTWS0_NVn1_NVA0_NVB0_NVC0_NVD0_NVE0_NVMXSA0_NVMXSB0_NVM0_NVWS0_NEPBS0_NLCA1_NLCB1_ONLL1_PAP0_PGL0_PGR2_PLR0_PKA1_SGROB0_SIA3_SS1_SPO0_SRVW0_SSO0_SVW1_SK0_SKFTR0_SKFDPO0_SKWS0_SKXCCM0_SNLL0_SIP1_SGRO0_TDMI0_TDMIM0_TDMLWS0_TDMS0_TIN0_THn1_THA0_THB0_THC0_THD0_THE0_THMXSA0_THMXSB0_THM0_THWS0_TLDS1_TLDSM1_ULSGRO0_USL1_USLMX0_UDFMAC0_UIOFGRO0_UPLRP0_USFGROn1_USI0_VSn1_VWA1_VWB1_WSGRA0_WSGRB0_WS32_WG16_2_1_WGMXCC1.kd'
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
        .value_type:      bf16
        .address_space:   generic
      - .name:            C
        .size:            8
        .offset:          40
        .value_kind:      global_buffer
        .value_type:      bf16
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
      - .name:            MetaData
        .size:            8
        .offset:          64
        .value_kind:      global_buffer
        .value_type:      void
        .address_space:   generic
      - .name:            strideD0
        .size:            4
        .offset:          72
        .value_kind:      by_value
        .value_type:      u32
      - .name:            strideD1
        .size:            4
        .offset:          76
        .value_kind:      by_value
        .value_type:      u32
      - .name:            strideC0
        .size:            4
        .offset:          80
        .value_kind:      by_value
        .value_type:      u32
      - .name:            strideC1
        .size:            4
        .offset:          84
        .value_kind:      by_value
        .value_type:      u32
      - .name:            strideA0
        .size:            4
        .offset:          88
        .value_kind:      by_value
        .value_type:      u32
      - .name:            strideA1
        .size:            4
        .offset:          92
        .value_kind:      by_value
        .value_type:      u32
      - .name:            strideB0
        .size:            4
        .offset:          96
        .value_kind:      by_value
        .value_type:      u32
      - .name:            strideB1
        .size:            4
        .offset:          100
        .value_kind:      by_value
        .value_type:      u32
      - .name:            strideMetadata0
        .size:            4
        .offset:          104
        .value_kind:      by_value
        .value_type:      u32
      - .name:            strideMetadata1
        .size:            4
        .offset:          108
        .value_kind:      by_value
        .value_type:      u32
      - .name:            alpha
        .size:            4
        .offset:          112
        .value_kind:      by_value
        .value_type:      f32
      - .name:            beta
        .size:            4
        .offset:          116
        .value_kind:      by_value
        .value_type:      f32
      - .name:            AddressScaleAlphaVec
        .size:            8
        .offset:          120
        .value_kind:      global_buffer
        .value_type:      f32
        .address_space:   generic
      - .name:            bias
        .size:            8
        .offset:          128
        .value_kind:      global_buffer
        .value_type:      void
        .address_space:   generic
      - .name:            biasType
        .size:            4
        .offset:          136
        .value_kind:      by_value
        .value_type:      u32
      - .name:            StrideBias
        .size:            4
        .offset:          140
        .value_kind:      by_value
        .value_type:      u32
      - .name:            factorDim
        .size:            4
        .offset:          144
        .value_kind:      by_value
        .value_type:      u32
      - .name:            activationAlpha
        .size:            4
        .offset:          148
        .value_kind:      by_value
        .value_type:      f32
      - .name:            activationBeta
        .size:            4
        .offset:          152
        .value_kind:      by_value
        .value_type:      f32
      - .name:            activationType
        .size:            4
        .offset:          156
        .value_kind:      by_value
        .value_type:      u32
      - .name:            batchOffsetD
        .size:            8
        .offset:          160
        .value_kind:      by_value
        .value_type:      u64
      - .name:            batchOffsetC
        .size:            8
        .offset:          168
        .value_kind:      by_value
        .value_type:      u64
      - .name:            batchOffsetA
        .size:            8
        .offset:          176
        .value_kind:      by_value
        .value_type:      u64
      - .name:            batchOffsetB
        .size:            8
        .offset:          184
        .value_kind:      by_value
        .value_type:      u64
    .group_segment_fixed_size:   8192
    .kernarg_segment_align:      8
    .kernarg_segment_size:       192
    .max_flat_workgroup_size:    32
    .private_segment_fixed_size: 0
    .sgpr_count:                 84
    .sgpr_spill_count:           0
    .vgpr_count:                 256
    .vgpr_spill_count:           0
    .wavefront_size:             32
...
.end_amdgpu_metadata
Cijk_Ailk_Bljk_F8BS_BH_Bias_FDMN_SPBML0_A_S_SAV_UserArgs_MT16x16x128_MI16x16x1_SN_LDSB0_AFC1_AG0_AGGSUA0_AGNTAB0_AFEM1_AFEM1_ASEM8_BL1_BS1_CD1_1_CLR0_CLS0_CADS0_DTLA0_DTLB0_DTLM0_DTVA0_DTVB0_DTVMXSA0_DTVMXSB0_DTVSM0_DPLB0_EPS1_ELFLR0_EMLLn1_FDSI0_GRPM1_GRVWA16_GRVWB16_GSUAMB_GLS0_HPLR0_ISA1250_ICIW0_IU1_K1_LDSTI0_LBSPPA256_LBSPPB256_LBSPPMXSA0_LBSPPMXSB0_LBSPPM0_LPA16_LPB16_LPMXSA0_LPMXSB0_LPM4_LRVWn1_LWPMn1_MIAV1_MIWT1_1_MXLIBL_MXSFNS_MO40_MGRIPM1_NTn1_NTA0_NTB0_NTC0_NTD0_NTE0_NTMXSA0_NTMXSB0_NTM0_NTWS0_NVn1_NVA0_NVB0_NVC0_NVD0_NVE0_NVMXSA0_NVMXSB0_NVM0_NVWS0_NEPBS0_NLCA1_NLCB1_ONLL1_PAP0_PGL0_PGR2_PLR0_PKA1_SGROB0_SIA3_SS1_SPO0_SRVW0_SSO0_SVW1_SK0_SKFTR0_SKFDPO0_SKWS0_SKXCCM0_SNLL0_SIP1_SGRO0_TDMI0_TDMIM0_TDMLWS0_TDMS0_TIN0_THn1_THA0_THB0_THC0_THD0_THE0_THMXSA0_THMXSB0_THM0_THWS0_TLDS1_TLDSM1_ULSGRO0_USL1_USLMX0_UDFMAC0_UIOFGRO0_UPLRP0_USFGROn1_USI0_VSn1_VWA1_VWB1_WSGRA0_WSGRB0_WS32_WG16_2_1_WGMXCC1:
label_ASM_Start:  /// Main body of the asm kernel

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
.set vgprBase, 20
.set vgprLocalWriteAddrA, 15
.set vgprLocalWriteAddrB, 16
.set vgprLocalWriteAddrMetadata, 17
.set vgprGlobalReadOffsetA, 8
.set vgprGlobalReadOffsetB, 12
.set vgprGlobalReadOffsetMetadata, 14
.set vgprLocalReadAddrA, 126
.set vgprLocalReadAddrB, 19
.set vgprLocalReadAddrMetadata, 18
.set vgprSerial, 127

/******************************************/
/* VGPR Macro Assignments                 */
/******************************************/
.set vgprValuA_X0_I0_BASE, vgprBase+0
.set vgprValuA_X0_I0_D0_PACK, vgprBase+16
.set vgprValuB_X0_I0_BASE, vgprBase+66
.set vgprValuMetadata_X0_I0_BASE, vgprBase+78
.set vgprG2LA_BASE, vgprBase+80
.set vgprG2LB_BASE, vgprBase+96
.set vgprG2LMetadata, vgprBase+104
.set vgprPackTemp, vgprBase+74
.set vgprValuA_X0_I0, vgprValuA_X0_I0_BASE+0
.set vgprValuB_X0_I0, vgprValuB_X0_I0_BASE+0
.set vgprValuA_X0_I0_D1, vgprValuA_X0_I0_D0_PACK+0
.set vgprValuA_X0_I0_D2, vgprValuA_X0_I0_D0_PACK+16
.set vgprValuA_X0_I0_D3, vgprValuA_X0_I0_D0_PACK+32
.set vgprValuMetadata_X0_I0, vgprValuMetadata_X0_I0_BASE+0
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
.set sgprAddressMetadata, 44
.set sgprStridesD, 46
.set sgprStridesC, 48
.set sgprStridesA, 50
.set sgprStridesB, 52
.set sgprStridesMetadata, 54
.set sgprAlpha, 56
.set sgprBeta, 57
.set sgprGSU, 58

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
.set constStrideBL, 1
.set sgprStrideB1J, sgprStridesB+0
.set sgprStrideBK, sgprStridesB+1
.set constStrideMetadataL, 1
.set sgprStrideMetadata1J, sgprStridesMetadata+0
.set sgprStrideMetadataK, sgprStridesMetadata+1

.set MT0, 16
.set MT1, 16
.set DepthU, 128
/* Number of elements to shift-left SRD */
.set SrdShiftLeftA, 16
.set SrdShiftLeftB, 16
.set SrdShiftLeftMetadata, 8
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

/* Global Offset Metadata */

/******************************************/
/* Allocate Resources                     */
/******************************************/
label_Preload_Offset_Start:
global_prefetch_b8 v0, s[0:1] th:TH_LOAD_RT scope:SCOPE_SE
v_nop
s_and_b32 s59, 0x3fffffff, s2                      // Get nums of gemm
s_lshr_b32 s60, s2, 0x1e                           // Get arg type
s_mov_b32 s61, s3                                  // Preload internal args
s_cmp_eq_u32 s60, 3                                // Is kernel argType == 3
s_cbranch_scc1 label_Bypass_ArgType3_to_ArgType0_Instance2
s_cmp_eq_u32 s60, 0                                // Is kernel args
s_cbranch_scc0 label_Preload_HBMArgs
label_Bypass_ArgType3_to_ArgType0_Instance2:
s_add_u32 s[sgprKernArgAddress], s[sgprKernArgAddress], 0x10 // Shift common args
s_addc_u32 s[sgprKernArgAddress+1], s[sgprKernArgAddress+1], 0

/* Load Kernel Args */
s_load_b32 s55, s[sgprKernArgAddress:sgprKernArgAddress+1], 92 // 92
s_load_b64 s[56:57], s[sgprKernArgAddress:sgprKernArgAddress+1], 96 // 96
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
s_mov_b32 s62, s5                                  // Load num of WGs
s_and_b32 s[sgprStaggerU], s61, 0xffff0000         // Restore StaggerU related vars
s_delay_alu instid0(SALU_CYCLE_1)
s_lshr_b32 s[sgprStaggerU], s[sgprStaggerU], 0x10
s_and_b32 s[sgprGSU], s61, 0xffff                  // Restore GSUConfig and GSU
s_mov_b32 s[sgprArgType], s60
s_mov_b32 m0, 0x2000                               // LDS clamp at 8192 bytes
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v[vgprSerial], v0                        // thread serial id
s_mov_b32 vcc_hi, 0                                // Ensure hi bits are zero

/* Init workgroup id from ttmp */
s_mov_b32 s[sgprWorkGroup0], ttmp9
s_and_b32 s[sgprWorkGroup1], 0xffff, ttmp7
s_lshr_b32 s[sgprWorkGroup2], ttmp7, 0x10

/* remap workgroup to XCCs */
s_lshr_b32 s68, s[sgprWGM], 0x10                   // Get WGMXCC
s_delay_alu instid0(SALU_CYCLE_1)
s_ff1_i32_b32 s68, s68                             // Get log(WGMXCC)
s_lshr_b32 s69, s[sgprWGM], 0x16                   // Get CU_Count
/* remap WGs if WGMXCC > 1 ( log(WGMXCC) > 0 ) */
s_cmp_gt_i32 s68, 0
s_cbranch_scc0 label_skip_WGMXCC
/* only remap WGs in the range */
s_lshr_b32 s65, s62, s68
s_delay_alu instid0(SALU_CYCLE_1)
s_lshl_b32 s65, s65, s68
s_cmp_ge_u32 s[sgprWorkGroup0], s65
s_cbranch_scc1 label_skip_WGMXCC
s_cmp_eq_u32 s69, 0                                // CU_Count == 0 ?
s_cbranch_scc0 label_XCCG_nonzero
s_lshr_b32 s65, s[sgprWorkGroup0], s68
s_bfm_b32 s66, s68, 0
s_and_b32 s66, s[sgprWorkGroup0], s66
s_lshr_b32 s67, s62, s68
s_delay_alu instid0(SALU_CYCLE_1)
s_mul_i32 s66, s66, s67
s_delay_alu instid0(SALU_CYCLE_1)
s_add_u32 s[sgprWorkGroup0], s65, s66
s_branch label_skip_WGMXCC
label_XCCG_nonzero:
/* temp0 = (wg//CU_Count)*CU_Count */
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cvt_f64_u32 v[24:25], s69                        // s65 = s[sgprWorkGroup0] / s69
s_delay_alu instid0(VALU_DEP_1)
v_rcp_f64 v[24:25], v[24:25]                       // s65 = s[sgprWorkGroup0] / s69
v_cvt_f64_u32 v[26:27], s[sgprWorkGroup0]          // s65 = s[sgprWorkGroup0] / s69
s_delay_alu instid0(VALU_DEP_1)
v_mul_f64 v[24:25], v[24:25], v[26:27]             // s65 = s[sgprWorkGroup0] / s69
s_delay_alu instid0(VALU_DEP_1)
v_cvt_u32_f64 v24, v[24:25]                        // s65 = s[sgprWorkGroup0] / s69
v_mul_lo_u32 v25, v24, s69                         // s65 = s[sgprWorkGroup0] / s69
v_sub_nc_u32 v26, s[sgprWorkGroup0], v25           // s65 = s[sgprWorkGroup0] / s69
v_cmp_ge_u32 vcc_lo, v26, s69                      // s65 = s[sgprWorkGroup0] / s69
s_mov_b32 exec_lo, vcc_lo                          // s65 = s[sgprWorkGroup0] / s69
s_delay_alu instid0(VALU_DEP_4)
v_add_nc_u32 v24, v24, 1                           // s65 = s[sgprWorkGroup0] / s69
s_mov_b32 exec_lo, -1                              // Reset exec
v_mul_lo_u32 v25, v24, s69                         // s65 = s[sgprWorkGroup0] / s69
v_sub_nc_u32 v26, s[sgprWorkGroup0], v25           // s65 = s[sgprWorkGroup0] / s69
s_delay_alu instid0(VALU_DEP_3)
v_readfirstlane_b32 s65, v24                       // quotient
s_delay_alu instid0(VALU_DEP_2)
v_readfirstlane_b32 s66, v26                       // remainder
s_mul_i32 s65, s65, s69
/* temp1 = (wg%CU_Count)//WGMXCC */
s_lshr_b32 s66, s66, s68
/* temp0 = temp0 + temp1 */
s_delay_alu instid0(SALU_CYCLE_1)
s_add_u32 s65, s65, s66
/* temp1 = (wg%WGMXCC) * ((WGs - (WGs//CU_Count) * CU_Count) if (wg > (WGs//CU_Count) * CU_Count) else CU_Count)//WGMXCC */
v_cvt_f64_u32 v[24:25], s69                        // s66 = s62 / s69
s_delay_alu instid0(VALU_DEP_1)
v_rcp_f64 v[24:25], v[24:25]                       // s66 = s62 / s69
v_cvt_f64_u32 v[26:27], s62                        // s66 = s62 / s69
s_delay_alu instid0(VALU_DEP_1)
v_mul_f64 v[24:25], v[24:25], v[26:27]             // s66 = s62 / s69
s_delay_alu instid0(VALU_DEP_1)
v_cvt_u32_f64 v24, v[24:25]                        // s66 = s62 / s69
v_mul_lo_u32 v25, v24, s69                         // s66 = s62 / s69
v_sub_nc_u32 v26, s62, v25                         // s66 = s62 / s69
v_cmp_ge_u32 vcc_lo, v26, s69                      // s66 = s62 / s69
s_mov_b32 exec_lo, vcc_lo                          // s66 = s62 / s69
s_delay_alu instid0(VALU_DEP_4)
v_add_nc_u32 v24, v24, 1                           // s66 = s62 / s69
s_mov_b32 exec_lo, -1                              // Reset exec
s_delay_alu instid0(VALU_DEP_1)
v_readfirstlane_b32 s66, v24                       // quotient
s_mul_i32 s66, s66, s69
s_sub_u32 s67, s62, s66
s_cmp_gt_u32 s[sgprWorkGroup0], s66
s_cselect_b32 s66, s67, s69
s_delay_alu instid0(SALU_CYCLE_1)
s_lshr_b32 s66, s66, s68
s_bfm_b32 s67, s68, 0
s_delay_alu instid0(SALU_CYCLE_1)
s_and_b32 s67, s[sgprWorkGroup0], s67
s_delay_alu instid0(SALU_CYCLE_1)
s_mul_i32 s66, s66, s67
/* WorkGroup0 = temp0 + temp1 */
s_delay_alu instid0(SALU_CYCLE_1)
s_add_u32 s[sgprWorkGroup0], s65, s66
label_skip_WGMXCC:  /// skip WGMXCC if no enough WGs to remap
s_cmp_eq_u32 s60, 3
s_cbranch_scc1 label_ArgType3_Routed_To_ArgType0
s_cmp_eq_u32 s60, 0
s_cbranch_scc0 label_MultiGemm
label_ArgType3_Routed_To_ArgType0:
/* init: add vgpr [20...120) to pool */
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
/* lr1J */
v_and_b32 v2, 31, v[vgprSerial]                    // 0. thread id in wave: wtid = tid % wavelength(32)
v_and_b32 v1, 15, v2                               // 1. N offset: nIdx = wtid % MI_N(16)
v_lshlrev_b32 v1, 6, v1                            // 1. N offset: nOffset = nIdx * nStride(64)
/* Skip. 2. block offset: bnOffset = 0 when num1DBlocks = 1 */
                                                   // 4. apply VectorWidth: bnOffset = bnOffset * vw(1) (multiplier is 1, do nothing)
v_lshrrev_b32 v2, 4, v2                            // 5. K offset: kIdx = wtid / (MIN(16) * MIBB(1))
v_lshl_add_u32 v1, v2, 4, v1                       // 5. K offset: lrKOffset = kIdx * mStride(16); 6. offset in wave: lrOffset = bnOffset + lrKOffset
/* lr1J */
v_and_b32 v3, 31, v[vgprSerial]                    // 0. thread id in wave: wtid = tid % wavelength(32)
v_and_b32 v2, 15, v3                               // 1. N offset: nIdx = wtid % MI_N(16)
v_mul_lo_u32 v2, 20, v2                            // 1. N offset: nOffset = nIdx * nStride(20)
/* Skip. 2. block offset: bnOffset = 0 when num1DBlocks = 1 */
                                                   // 4. apply VectorWidth: bnOffset = bnOffset * vw(1) (multiplier is 1, do nothing)
v_lshrrev_b32 v3, 4, v3                            // 5. K offset: kIdx = wtid / (MIN(16) * MIBB(1))
v_lshl_add_u32 v2, v3, 3, v2                       // 5. K offset: lrKOffset = kIdx * mStride(8); 6. offset in wave: lrOffset = bnOffset + lrKOffset

/* local read addresses: final offsets a */
v_lshrrev_b32 v3, 5, v[vgprSerial]                 // 3 = Serial / 32
v_lshrrev_b32 v3, 0, v3                            // LSU offset: Get LSU wave_id
s_mov_b32 s16, 2048                                // LSU offset: stride = lsuStride(128)*(MT0(16) + PAD0(0))
v_mul_lo_u32 v3, s16, v3                           // LSU offset: lsuoffset = wave_id*lsuStride*(MT0+PAD)
v_add_nc_u32 v[vgprLocalReadAddrA], v3, v0         // Final Offset: offset = (lro0+lsuoffset)*bpeDS
                                                   //  (bpe is 1, do nothing)
v_lshrrev_b32 v4, 8, v[vgprLocalReadAddrA]         // Final Offset: padding 16 per block 256
v_lshl_add_u32 v[vgprLocalReadAddrA], v4, 4, v[vgprLocalReadAddrA] // Final Offset: padding 16 per block 256

/* local read addresses: final offsets metadata */
v_lshrrev_b32 v0, 5, v[vgprSerial]                 // 0 = Serial / 32
v_lshrrev_b32 v0, 0, v0                            // LSU offset: Get LSU wave_id
s_mov_b32 s16, 16                                  // LSU offset: stride = lsuStride(16) when umlds==True
v_mul_lo_u32 v0, s16, v0                           // LSU offset: lsuoffset = wave_id*lsuStride*(MT1+PAD)
v_add_nc_u32 v[vgprLocalReadAddrMetadata], v0, v2  // Final Offset: offset = (lro1+lsuoffset)*bpeDS
                                                   //  (bpe is 1, do nothing)

/* local read addresses: final offsets b */
v_lshrrev_b32 v0, 5, v[vgprSerial]                 // 0 = Serial / 32
v_lshrrev_b32 v0, 0, v0                            // LSU offset: Get LSU wave_id
s_mov_b32 s16, 64                                  // LSU offset: stride = lsuStride(64) when umlds==True
v_mul_lo_u32 v0, s16, v0                           // LSU offset: lsuoffset = wave_id*lsuStride*(MT1+PAD)
v_add_nc_u32 v[vgprLocalReadAddrB], v0, v1         // Final Offset: offset = (lro1+lsuoffset)*bpeDS
                                                   //  (bpe is 1, do nothing)
v_lshrrev_b32 v2, 8, v[vgprLocalReadAddrB]         // Final Offset: padding 16 per block 256
v_lshl_add_u32 v[vgprLocalReadAddrB], v2, 4, v[vgprLocalReadAddrB] // Final Offset: padding 16 per block 256

/* local read addresses: declare addresses a */

/* local read addresses: declare addresses metadata */
v_add_co_u32 v[vgprLocalReadAddrMetadata+0], vcc_lo, 0x900, v[vgprLocalReadAddrMetadata+0] //  += LdsOffsetMetadata (lower)

/* local read addresses: declare addresses b */
v_add_co_u32 v[vgprLocalReadAddrB+0], vcc_lo, 0xb00, v[vgprLocalReadAddrB+0] //  += LdsOffsetB (lower)

/******************************************/
/* Local Write Addresses                  */
/******************************************/
/* LVCA = 1 */
/* v1 = A-unroll = serial/LVCA */
v_lshrrev_b32 v1, 0, v[vgprSerial]                 // 1 = Serial / 1
v_and_b32 v0, 0, v[vgprSerial]                     // 0 = Serial % 1
/* tile *= glvw */
v_lshlrev_b32 v0, 4, v0                            // v0 = v0 * 16
v_mov_b32 v4, v1                                   // copy for GlobalSplitU
/* LVCB = 4 */
/* v3 = B-unroll = serial%LVCB */
v_lshrrev_b32 v2, 2, v[vgprSerial]                 // 2 = Serial / 4
v_and_b32 v3, 3, v[vgprSerial]                     // 3 = Serial % 4
/* unroll *= glvw */
v_lshlrev_b32 v3, 4, v3                            // v3 = v3 * 16
v_mov_b32 v5, v3                                   // copy for GlobalSplitU
/* LVCMetadata = 2 */
/* v7 = Metadata-unroll = serial%LVCMetadata */
v_lshrrev_b32 v6, 1, v[vgprSerial]                 // 6 = Serial / 2
v_and_b32 v7, 1, v[vgprSerial]                     // 7 = Serial % 2
/* unroll *= glvw */
v_lshlrev_b32 v7, 3, v7                            // v7 = v7 * 8
v_mov_b32 v22, v7                                  // copy for GlobalSplitU
/* lwaUnrollAssignmentA = v4 */
/* lwaUnrollAssignmentB = v5 */
/* lwaUnrollAssignmentMetadata = v22 */

/* local write addresses: first offset a */
v_mul_u32_u24 v[vgprLocalWriteAddrA], 0x10, v4     // lwAL**(MTA + PAD)
v_add_nc_u32 v[vgprLocalWriteAddrA], v0, v[vgprLocalWriteAddrA] // lwFOA = (lwAA + lwAL*(MT0I+PAD))
                                                   //  (bpe is 1, do nothing)
v_lshrrev_b32 v20, 8, v[vgprLocalWriteAddrA]       // padding 16 per block 256
v_lshl_add_u32 v[vgprLocalWriteAddrA], v20, 4, v[vgprLocalWriteAddrA] // padding 16 per block 256

/* local write addresses: first offset metadata */
v_mul_u32_u24 v[vgprLocalWriteAddrMetadata], 0x14, v6 // lwMetadataL**(DepthU_Compute + PAD)
v_add_nc_u32 v[vgprLocalWriteAddrMetadata], v22, v[vgprLocalWriteAddrMetadata] // lwFOMetadata = (lwMetadataMetadata + lwMetadataL*(DepthU+PAD))
                                                   //  (bpe is 1, do nothing)
s_delay_alu instid0(VALU_DEP_1)
v_add_co_u32 v[vgprLocalWriteAddrMetadata], vcc_lo, 0x900, v[vgprLocalWriteAddrMetadata] // lwFOMetadata = lw1J + lwL*MT1J + LDS_OFFSET_Metadata=2304

/* local write addresses: first offset b */
v_mul_u32_u24 v[vgprLocalWriteAddrB], 0x40, v2     // lwBL**(DepthU_Compute + PAD)
v_add_nc_u32 v[vgprLocalWriteAddrB], v5, v[vgprLocalWriteAddrB] // lwFOB = (lwBB + lwBL*(DepthU+PAD))
                                                   //  (bpe is 1, do nothing)
v_lshrrev_b32 v20, 8, v[vgprLocalWriteAddrB]       // padding 16 per block 256
v_lshl_add_u32 v[vgprLocalWriteAddrB], v20, 4, v[vgprLocalWriteAddrB] // padding 16 per block 256
s_delay_alu instid0(VALU_DEP_1)
v_add_co_u32 v[vgprLocalWriteAddrB], vcc_lo, 0xb00, v[vgprLocalWriteAddrB] // lwFOB = lw1J + lwL*MT1J + LDS_OFFSET_B=2816
v_mov_b32 v25, MT0                                 // set MT0 into sgpr
v_mov_b32 v24, s[sgprSizesFree+0]                  // set Free0 size
v_cvt_f32_u32 v23, v25                             // v23 = ceil(v24 / v25)
s_delay_alu instid0(VALU_DEP_1)
v_rcp_iflag_f32 v23, v23                           // v23 = ceil(v24 / v25)
v_cvt_f32_u32 v26, v24                             // v23 = ceil(v24 / v25)
s_delay_alu instid0(VALU_DEP_1)
v_mul_f32 v23, v23, v26                            // v23 = ceil(v24 / v25)
s_delay_alu instid0(VALU_DEP_1)
v_cvt_u32_f32 v23, v23                             // v23 = ceil(v24 / v25)
v_mul_u32_u24 v26, v23, v25                        // v23 = ceil(v24 / v25)
v_sub_nc_u32 v26, v24, v26                         // v23 = ceil(v24 / v25)
s_delay_alu instid0(VALU_DEP_1)
v_cmp_ne_u32 vcc_lo, v26, 0                        // v23 = ceil(v24 / v25)
s_delay_alu instid0(VALU_DEP_4)
v_add_co_ci_u32 v23, vcc_lo, v23, 0, vcc_lo        // ceil
v_mov_b32 v25, MT1                                 // set MT1 into sgpr
v_mov_b32 v24, s[sgprSizesFree+1]                  // set Free1 size
v_readfirstlane_b32 s[sgprNumWorkGroups0], v23     // set back to numWorkGroup0
v_cvt_f32_u32 v23, v25                             // v23 = ceil(v24 / v25)
s_delay_alu instid0(VALU_DEP_1)
v_rcp_iflag_f32 v23, v23                           // v23 = ceil(v24 / v25)
v_cvt_f32_u32 v26, v24                             // v23 = ceil(v24 / v25)
s_delay_alu instid0(VALU_DEP_1)
v_mul_f32 v23, v23, v26                            // v23 = ceil(v24 / v25)
s_delay_alu instid0(VALU_DEP_1)
v_cvt_u32_f32 v23, v23                             // v23 = ceil(v24 / v25)
v_mul_u32_u24 v26, v23, v25                        // v23 = ceil(v24 / v25)
v_sub_nc_u32 v26, v24, v26                         // v23 = ceil(v24 / v25)
s_delay_alu instid0(VALU_DEP_1)
v_cmp_ne_u32 vcc_lo, v26, 0                        // v23 = ceil(v24 / v25)
s_delay_alu instid0(VALU_DEP_4)
v_add_co_ci_u32 v23, vcc_lo, v23, 0, vcc_lo        // ceil
s_nop 0                                            // 1 wait states
v_readfirstlane_b32 s[sgprNumWorkGroups1], v23     // set back to numWorkGroup1
s_wait_kmcnt 0                                     // wait for -4/0 bytes of kern args

/* remap wg from 1D(idxWG012) to 3D(wg2,wg1,wg0) */
/* wg2 = idxWG012 * smallMagicNumber(1/(numWG0*numWG1)) */
s_mul_i32 s16, s[sgprNumWorkGroups0], s[sgprNumWorkGroups1]
s_and_b32 s17, s[sgprGSU], 0x3fff                  // Restore GSU
s_delay_alu instid0(SALU_CYCLE_1)
s_mul_i32 s16, s16, s17
v_cvt_f32_u32 v20, s16                             // s16 = s[sgprWorkGroup0] / s16
s_delay_alu instid0(VALU_DEP_1)
v_rcp_iflag_f32 v20, v20                           // s16 = s[sgprWorkGroup0] / s16
v_cvt_f32_u32 v21, s[sgprWorkGroup0]               // s16 = s[sgprWorkGroup0] / s16
s_delay_alu instid0(VALU_DEP_1)
v_mul_f32 v20, v20, v21                            // s16 = s[sgprWorkGroup0] / s16
s_delay_alu instid0(VALU_DEP_1)
v_cvt_u32_f32 v20, v20                             // s16 = s[sgprWorkGroup0] / s16
v_mul_u32_u24 v21, v20, s16                        // s16 = s[sgprWorkGroup0] / s16
v_sub_nc_u32 v21, s[sgprWorkGroup0], v21           // s16 = s[sgprWorkGroup0] / s16
v_cmp_eq_u32 vcc_lo, v21, s16                      // s16 = s[sgprWorkGroup0] / s16
s_mov_b32 exec_lo, vcc_lo                          // s16 = s[sgprWorkGroup0] / s16
s_delay_alu instid0(VALU_DEP_4)
v_add_nc_u32 v20, 1, v20                           // s16 = s[sgprWorkGroup0] / s16
s_mov_b32 exec_lo, -1                              // Reset exec
v_cmp_gt_u32 vcc_lo, v21, s16                      // overflow happened in remainder
s_mov_b32 exec_lo, vcc_lo                          // overflow happened in remainder
s_delay_alu instid0(VALU_DEP_2)
v_sub_nc_u32 v20, v20, 1                           // quotient - 1
s_mov_b32 exec_lo, -1                              // Reset exec
s_delay_alu instid0(VALU_DEP_1)
v_readfirstlane_b32 s16, v20                       // quotient
s_delay_alu instid0(SALU_CYCLE_1)
s_mov_b32 s[sgprWorkGroup2], s16
/* idxWG01 = idxWG012 - wg2 * numWG0 * numWG1 */
s_mul_i32 s16, s[sgprNumWorkGroups1], s[sgprNumWorkGroups0]
s_delay_alu instid0(SALU_CYCLE_1)
s_mul_i32 s16, s16, s[sgprWorkGroup2]
s_delay_alu instid0(SALU_CYCLE_1)
s_mul_i32 s16, s16, s17
s_sub_u32 s[sgprWorkGroup0], s[sgprWorkGroup0], s16
/* wg1 = idxWG01 * smallMagicNumber(1/numWG0) */
v_cvt_f32_u32 v20, s[sgprNumWorkGroups0]           // s16 = s[sgprWorkGroup0] / s[sgprNumWorkGroups0]
s_delay_alu instid0(VALU_DEP_1)
v_rcp_iflag_f32 v20, v20                           // s16 = s[sgprWorkGroup0] / s[sgprNumWorkGroups0]
v_cvt_f32_u32 v21, s[sgprWorkGroup0]               // s16 = s[sgprWorkGroup0] / s[sgprNumWorkGroups0]
s_delay_alu instid0(VALU_DEP_1)
v_mul_f32 v20, v20, v21                            // s16 = s[sgprWorkGroup0] / s[sgprNumWorkGroups0]
s_delay_alu instid0(VALU_DEP_1)
v_cvt_u32_f32 v20, v20                             // s16 = s[sgprWorkGroup0] / s[sgprNumWorkGroups0]
v_mul_u32_u24 v21, v20, s[sgprNumWorkGroups0]      // s16 = s[sgprWorkGroup0] / s[sgprNumWorkGroups0]
v_sub_nc_u32 v21, s[sgprWorkGroup0], v21           // s16 = s[sgprWorkGroup0] / s[sgprNumWorkGroups0]
v_cmp_eq_u32 vcc_lo, v21, s[sgprNumWorkGroups0]    // s16 = s[sgprWorkGroup0] / s[sgprNumWorkGroups0]
s_mov_b32 exec_lo, vcc_lo                          // s16 = s[sgprWorkGroup0] / s[sgprNumWorkGroups0]
s_delay_alu instid0(VALU_DEP_4)
v_add_nc_u32 v20, 1, v20                           // s16 = s[sgprWorkGroup0] / s[sgprNumWorkGroups0]
s_mov_b32 exec_lo, -1                              // Reset exec
v_cmp_gt_u32 vcc_lo, v21, s[sgprNumWorkGroups0]    // overflow happened in remainder
s_mov_b32 exec_lo, vcc_lo                          // overflow happened in remainder
s_delay_alu instid0(VALU_DEP_2)
v_sub_nc_u32 v20, v20, 1                           // quotient - 1
s_mov_b32 exec_lo, -1                              // Reset exec
s_delay_alu instid0(VALU_DEP_1)
v_readfirstlane_b32 s16, v20                       // quotient
s_mov_b32 s[sgprWorkGroup1], s16
/* wg0 = idxWG01 - wg1 * numWG0 */
s_mul_i32 s16, s[sgprWorkGroup1], s[sgprNumWorkGroups0]
s_delay_alu instid0(SALU_CYCLE_1)
s_sub_u32 s[sgprWorkGroup0], s[sgprWorkGroup0], s16
s_branch label_MultiGemmEnd
label_MultiGemm:

/* Check if custom structure pointer is null */
s_cmp_eq_u32 s[sgprArgType], 2                     // ArgType == 2 ?
s_cbranch_scc1 label_IsExternalValid               // branch if ArgType == 2
s_mov_b32 s15, 144                                 // KernArgAddressOffset
s_mul_i32 s22, s59, 4
s_mov_b64 s[16:17], s[sgprKernArgAddress:sgprKernArgAddress+1]
s_branch label_IsExternalValidEnd
label_IsExternalValid:
s_mov_b32 s15, 232
s_mov_b32 s22, 0
s_mov_b64 s[16:17], s[sgprKernArgAddress:sgprKernArgAddress+1]
label_IsExternalValidEnd:

/* Grouped Gemm:: prefetch 1 arg load */
s_mov_b32 s14, 1
s_mov_b32 s23, 0
s_load_b128 s[32:35], s[16:17], s22
s_mov_b32 s24, 1
s_cmp_eq_u32 s59, s24                              // if gemm_count is 1?
s_cbranch_scc1 label_wgTable_noLoadLoop

/* Grouped Gemm:: accumulate numTiles for each gemm */
/* Grouped Gemm:: loop start */
label_Loop_GemmCount:
s_wait_kmcnt 0
s_lshr_b32 s20, s32, 4                             // s20 = s32 / 16
s_and_b32 s18, 15, s32                             // s18 = s32 % 16
s_addc_u32 s20, s20, 0
s_lshr_b32 s21, s33, 4                             // s21 = s33 / 16
s_and_b32 s18, 15, s33                             // s18 = s33 % 16
s_addc_u32 s21, s21, 0
s_mul_i32 s20, s20, s21
s_mul_i32 s20, s20, s34
s_and_b32 s21, s[sgprGSU], 0x3fff                  // Restore GSU
s_delay_alu instid0(SALU_CYCLE_1)
s_mul_i32 s20, s20, s21
s_delay_alu instid0(SALU_CYCLE_1)
s_add_u32 s23, s23, s20
s_cmp_lt_u32 s[sgprWorkGroup0], s23
s_cbranch_scc1 label_FOUND
s_add_u32 s22, s22, s15
s_load_b128 s[32:35], s[16:17], s22
s_add_u32 s14, s14, 1
s_cmp_lt_u32 s14, s59
s_cbranch_scc1 label_Loop_GemmCount

/* Grouped Gemm:: noLoadLoop */
label_wgTable_noLoadLoop:
s_wait_kmcnt 0
s_lshr_b32 s20, s32, 4                             // s20 = s32 / 16
s_and_b32 s18, 15, s32                             // s18 = s32 % 16
s_addc_u32 s20, s20, 0
s_lshr_b32 s21, s33, 4                             // s21 = s33 / 16
s_and_b32 s18, 15, s33                             // s18 = s33 % 16
s_addc_u32 s21, s21, 0
s_mul_i32 s20, s20, s21
s_mul_i32 s20, s20, s34
s_and_b32 s16, s[sgprGSU], 0x3fff                  // Restore GSU
s_delay_alu instid0(SALU_CYCLE_1)
s_mul_i32 s20, s20, s16
s_delay_alu instid0(SALU_CYCLE_1)
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
s_lshl2_add_u32 s[sgprKernArgAddress], s59, s[sgprKernArgAddress]
s_addc_u32 s[sgprKernArgAddress+1], s[sgprKernArgAddress+1], 0
/* Grouped Gemm: offset address from args_start to gemm_start */
s_mul_i32 s17, s17, 144                            // KernArgAddressOffset
s_delay_alu instid0(SALU_CYCLE_1)
s_add_u32 s[sgprKernArgAddress], s[sgprKernArgAddress], s17
s_addc_u32 s[sgprKernArgAddress+1], s[sgprKernArgAddress+1], 0

/* Load Kernel Args */
s_load_b512 s[36:51], s[sgprKernArgAddress:sgprKernArgAddress+1], 16 // 16
s_load_b128 s[52:55], s[sgprKernArgAddress:sgprKernArgAddress+1], 80 // 80
s_load_b64 s[56:57], s[sgprKernArgAddress:sgprKernArgAddress+1], 96 // 96
s_branch label_LoadExternalStructEnd
label_LoadExternalStruct:
/* Grouped Gemm: offset address from args_start to gemm_start */
s_mul_i32 s17, s17, 232
s_delay_alu instid0(SALU_CYCLE_1)
s_add_u32 s[sgprKernArgAddress], s[sgprKernArgAddress], s17
s_addc_u32 s[sgprKernArgAddress+1], s[sgprKernArgAddress+1], 0
s_load_b512 s[36:51], s[sgprKernArgAddress:sgprKernArgAddress+1], 16 // 16
s_load_b128 s[52:55], s[sgprKernArgAddress:sgprKernArgAddress+1], 80 // 80
s_load_b32 s56, s[sgprKernArgAddress:sgprKernArgAddress+1], 96 // 96
// Read Beta
s_load_b32 s57, s[sgprKernArgAddress:sgprKernArgAddress+1], 112 // 112
label_LoadExternalStructEnd:
/* init: add vgpr [20...120) to pool */
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
/* lr1J */
v_and_b32 v2, 31, v[vgprSerial]                    // 0. thread id in wave: wtid = tid % wavelength(32)
v_and_b32 v1, 15, v2                               // 1. N offset: nIdx = wtid % MI_N(16)
v_lshlrev_b32 v1, 6, v1                            // 1. N offset: nOffset = nIdx * nStride(64)
/* Skip. 2. block offset: bnOffset = 0 when num1DBlocks = 1 */
                                                   // 4. apply VectorWidth: bnOffset = bnOffset * vw(1) (multiplier is 1, do nothing)
v_lshrrev_b32 v2, 4, v2                            // 5. K offset: kIdx = wtid / (MIN(16) * MIBB(1))
v_lshl_add_u32 v1, v2, 4, v1                       // 5. K offset: lrKOffset = kIdx * mStride(16); 6. offset in wave: lrOffset = bnOffset + lrKOffset
/* lr1J */
v_and_b32 v3, 31, v[vgprSerial]                    // 0. thread id in wave: wtid = tid % wavelength(32)
v_and_b32 v2, 15, v3                               // 1. N offset: nIdx = wtid % MI_N(16)
v_mul_lo_u32 v2, 20, v2                            // 1. N offset: nOffset = nIdx * nStride(20)
/* Skip. 2. block offset: bnOffset = 0 when num1DBlocks = 1 */
                                                   // 4. apply VectorWidth: bnOffset = bnOffset * vw(1) (multiplier is 1, do nothing)
v_lshrrev_b32 v3, 4, v3                            // 5. K offset: kIdx = wtid / (MIN(16) * MIBB(1))
v_lshl_add_u32 v2, v3, 3, v2                       // 5. K offset: lrKOffset = kIdx * mStride(8); 6. offset in wave: lrOffset = bnOffset + lrKOffset

/* local read addresses: final offsets a */
v_lshrrev_b32 v3, 5, v[vgprSerial]                 // 3 = Serial / 32
v_lshrrev_b32 v3, 0, v3                            // LSU offset: Get LSU wave_id
s_mov_b32 s16, 2048                                // LSU offset: stride = lsuStride(128)*(MT0(16) + PAD0(0))
v_mul_lo_u32 v3, s16, v3                           // LSU offset: lsuoffset = wave_id*lsuStride*(MT0+PAD)
v_add_nc_u32 v[vgprLocalReadAddrA], v3, v0         // Final Offset: offset = (lro0+lsuoffset)*bpeDS
                                                   //  (bpe is 1, do nothing)
v_lshrrev_b32 v4, 8, v[vgprLocalReadAddrA]         // Final Offset: padding 16 per block 256
v_lshl_add_u32 v[vgprLocalReadAddrA], v4, 4, v[vgprLocalReadAddrA] // Final Offset: padding 16 per block 256

/* local read addresses: final offsets metadata */
v_lshrrev_b32 v0, 5, v[vgprSerial]                 // 0 = Serial / 32
v_lshrrev_b32 v0, 0, v0                            // LSU offset: Get LSU wave_id
s_mov_b32 s16, 16                                  // LSU offset: stride = lsuStride(16) when umlds==True
v_mul_lo_u32 v0, s16, v0                           // LSU offset: lsuoffset = wave_id*lsuStride*(MT1+PAD)
v_add_nc_u32 v[vgprLocalReadAddrMetadata], v0, v2  // Final Offset: offset = (lro1+lsuoffset)*bpeDS
                                                   //  (bpe is 1, do nothing)

/* local read addresses: final offsets b */
v_lshrrev_b32 v0, 5, v[vgprSerial]                 // 0 = Serial / 32
v_lshrrev_b32 v0, 0, v0                            // LSU offset: Get LSU wave_id
s_mov_b32 s16, 64                                  // LSU offset: stride = lsuStride(64) when umlds==True
v_mul_lo_u32 v0, s16, v0                           // LSU offset: lsuoffset = wave_id*lsuStride*(MT1+PAD)
v_add_nc_u32 v[vgprLocalReadAddrB], v0, v1         // Final Offset: offset = (lro1+lsuoffset)*bpeDS
                                                   //  (bpe is 1, do nothing)
v_lshrrev_b32 v2, 8, v[vgprLocalReadAddrB]         // Final Offset: padding 16 per block 256
v_lshl_add_u32 v[vgprLocalReadAddrB], v2, 4, v[vgprLocalReadAddrB] // Final Offset: padding 16 per block 256

/* local read addresses: declare addresses a */

/* local read addresses: declare addresses metadata */
v_add_co_u32 v[vgprLocalReadAddrMetadata+0], vcc_lo, 0x900, v[vgprLocalReadAddrMetadata+0] //  += LdsOffsetMetadata (lower)

/* local read addresses: declare addresses b */
v_add_co_u32 v[vgprLocalReadAddrB+0], vcc_lo, 0xb00, v[vgprLocalReadAddrB+0] //  += LdsOffsetB (lower)

/******************************************/
/* Local Write Addresses                  */
/******************************************/
/* LVCA = 1 */
/* v1 = A-unroll = serial/LVCA */
v_lshrrev_b32 v1, 0, v[vgprSerial]                 // 1 = Serial / 1
v_and_b32 v0, 0, v[vgprSerial]                     // 0 = Serial % 1
/* tile *= glvw */
v_lshlrev_b32 v0, 4, v0                            // v0 = v0 * 16
v_mov_b32 v4, v1                                   // copy for GlobalSplitU
/* LVCB = 4 */
/* v3 = B-unroll = serial%LVCB */
v_lshrrev_b32 v2, 2, v[vgprSerial]                 // 2 = Serial / 4
v_and_b32 v3, 3, v[vgprSerial]                     // 3 = Serial % 4
/* unroll *= glvw */
v_lshlrev_b32 v3, 4, v3                            // v3 = v3 * 16
v_mov_b32 v5, v3                                   // copy for GlobalSplitU
/* LVCMetadata = 2 */
/* v7 = Metadata-unroll = serial%LVCMetadata */
v_lshrrev_b32 v6, 1, v[vgprSerial]                 // 6 = Serial / 2
v_and_b32 v7, 1, v[vgprSerial]                     // 7 = Serial % 2
/* unroll *= glvw */
v_lshlrev_b32 v7, 3, v7                            // v7 = v7 * 8
v_mov_b32 v22, v7                                  // copy for GlobalSplitU
/* lwaUnrollAssignmentA = v4 */
/* lwaUnrollAssignmentB = v5 */
/* lwaUnrollAssignmentMetadata = v22 */

/* local write addresses: first offset a */
v_mul_u32_u24 v[vgprLocalWriteAddrA], 0x10, v4     // lwAL**(MTA + PAD)
v_add_nc_u32 v[vgprLocalWriteAddrA], v0, v[vgprLocalWriteAddrA] // lwFOA = (lwAA + lwAL*(MT0I+PAD))
                                                   //  (bpe is 1, do nothing)
v_lshrrev_b32 v20, 8, v[vgprLocalWriteAddrA]       // padding 16 per block 256
v_lshl_add_u32 v[vgprLocalWriteAddrA], v20, 4, v[vgprLocalWriteAddrA] // padding 16 per block 256

/* local write addresses: first offset metadata */
v_mul_u32_u24 v[vgprLocalWriteAddrMetadata], 0x14, v6 // lwMetadataL**(DepthU_Compute + PAD)
v_add_nc_u32 v[vgprLocalWriteAddrMetadata], v22, v[vgprLocalWriteAddrMetadata] // lwFOMetadata = (lwMetadataMetadata + lwMetadataL*(DepthU+PAD))
                                                   //  (bpe is 1, do nothing)
s_delay_alu instid0(VALU_DEP_1)
v_add_co_u32 v[vgprLocalWriteAddrMetadata], vcc_lo, 0x900, v[vgprLocalWriteAddrMetadata] // lwFOMetadata = lw1J + lwL*MT1J + LDS_OFFSET_Metadata=2304

/* local write addresses: first offset b */
v_mul_u32_u24 v[vgprLocalWriteAddrB], 0x40, v2     // lwBL**(DepthU_Compute + PAD)
v_add_nc_u32 v[vgprLocalWriteAddrB], v5, v[vgprLocalWriteAddrB] // lwFOB = (lwBB + lwBL*(DepthU+PAD))
                                                   //  (bpe is 1, do nothing)
v_lshrrev_b32 v20, 8, v[vgprLocalWriteAddrB]       // padding 16 per block 256
v_lshl_add_u32 v[vgprLocalWriteAddrB], v20, 4, v[vgprLocalWriteAddrB] // padding 16 per block 256
s_delay_alu instid0(VALU_DEP_1)
v_add_co_u32 v[vgprLocalWriteAddrB], vcc_lo, 0xb00, v[vgprLocalWriteAddrB] // lwFOB = lw1J + lwL*MT1J + LDS_OFFSET_B=2816
v_mov_b32 v25, MT0                                 // set MT0 into sgpr
v_mov_b32 v24, s[sgprSizesFree+0]                  // set Free0 size
v_cvt_f32_u32 v23, v25                             // v23 = ceil(v24 / v25)
s_delay_alu instid0(VALU_DEP_1)
v_rcp_iflag_f32 v23, v23                           // v23 = ceil(v24 / v25)
v_cvt_f32_u32 v26, v24                             // v23 = ceil(v24 / v25)
s_delay_alu instid0(VALU_DEP_1)
v_mul_f32 v23, v23, v26                            // v23 = ceil(v24 / v25)
s_delay_alu instid0(VALU_DEP_1)
v_cvt_u32_f32 v23, v23                             // v23 = ceil(v24 / v25)
v_mul_u32_u24 v26, v23, v25                        // v23 = ceil(v24 / v25)
v_sub_nc_u32 v26, v24, v26                         // v23 = ceil(v24 / v25)
s_delay_alu instid0(VALU_DEP_1)
v_cmp_ne_u32 vcc_lo, v26, 0                        // v23 = ceil(v24 / v25)
s_delay_alu instid0(VALU_DEP_4)
v_add_co_ci_u32 v23, vcc_lo, v23, 0, vcc_lo        // ceil
v_mov_b32 v25, MT1                                 // set MT1 into sgpr
v_mov_b32 v24, s[sgprSizesFree+1]                  // set Free1 size
v_readfirstlane_b32 s[sgprNumWorkGroups0], v23     // set back to numWorkGroup0
v_cvt_f32_u32 v23, v25                             // v23 = ceil(v24 / v25)
s_delay_alu instid0(VALU_DEP_1)
v_rcp_iflag_f32 v23, v23                           // v23 = ceil(v24 / v25)
v_cvt_f32_u32 v26, v24                             // v23 = ceil(v24 / v25)
s_delay_alu instid0(VALU_DEP_1)
v_mul_f32 v23, v23, v26                            // v23 = ceil(v24 / v25)
s_delay_alu instid0(VALU_DEP_1)
v_cvt_u32_f32 v23, v23                             // v23 = ceil(v24 / v25)
v_mul_u32_u24 v26, v23, v25                        // v23 = ceil(v24 / v25)
v_sub_nc_u32 v26, v24, v26                         // v23 = ceil(v24 / v25)
s_delay_alu instid0(VALU_DEP_1)
v_cmp_ne_u32 vcc_lo, v26, 0                        // v23 = ceil(v24 / v25)
s_delay_alu instid0(VALU_DEP_4)
v_add_co_ci_u32 v23, vcc_lo, v23, 0, vcc_lo        // ceil
s_nop 0                                            // 1 wait states
v_readfirstlane_b32 s[sgprNumWorkGroups1], v23     // set back to numWorkGroup1
s_wait_kmcnt 0                                     // wait for -4/0 bytes of kern args

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
s_delay_alu instid0(SALU_CYCLE_1)
s_mul_i32 s16, s16, s17
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cvt_f32_u32 v20, s16                             // s16 = s[sgprWorkGroup0] / s16
s_delay_alu instid0(VALU_DEP_1)
v_rcp_iflag_f32 v20, v20                           // s16 = s[sgprWorkGroup0] / s16
v_cvt_f32_u32 v21, s[sgprWorkGroup0]               // s16 = s[sgprWorkGroup0] / s16
s_delay_alu instid0(VALU_DEP_1)
v_mul_f32 v20, v20, v21                            // s16 = s[sgprWorkGroup0] / s16
s_delay_alu instid0(VALU_DEP_1)
v_cvt_u32_f32 v20, v20                             // s16 = s[sgprWorkGroup0] / s16
v_mul_u32_u24 v21, v20, s16                        // s16 = s[sgprWorkGroup0] / s16
v_sub_nc_u32 v21, s[sgprWorkGroup0], v21           // s16 = s[sgprWorkGroup0] / s16
v_cmp_eq_u32 vcc_lo, v21, s16                      // s16 = s[sgprWorkGroup0] / s16
s_mov_b32 exec_lo, vcc_lo                          // s16 = s[sgprWorkGroup0] / s16
s_delay_alu instid0(VALU_DEP_4)
v_add_nc_u32 v20, 1, v20                           // s16 = s[sgprWorkGroup0] / s16
s_mov_b32 exec_lo, -1                              // Reset exec
v_cmp_gt_u32 vcc_lo, v21, s16                      // overflow happened in remainder
s_mov_b32 exec_lo, vcc_lo                          // overflow happened in remainder
s_delay_alu instid0(VALU_DEP_2)
v_sub_nc_u32 v20, v20, 1                           // quotient - 1
s_mov_b32 exec_lo, -1                              // Reset exec
s_delay_alu instid0(VALU_DEP_1)
v_readfirstlane_b32 s16, v20                       // quotient
s_delay_alu instid0(SALU_CYCLE_1)
s_mov_b32 s[sgprWorkGroup2], s16
/* idxWG01 = idxWG012 - wg2 * numWG0 * numWG1 */
s_mul_i32 s16, s[sgprNumWorkGroups1], s[sgprNumWorkGroups0]
s_delay_alu instid0(SALU_CYCLE_1)
s_mul_i32 s16, s16, s[sgprWorkGroup2]
s_delay_alu instid0(SALU_CYCLE_1)
s_mul_i32 s16, s16, s17
s_sub_u32 s[sgprWorkGroup0], s[sgprWorkGroup0], s16
/* wg1 = idxWG01 * smallMagicNumber(1/numWG0) */
v_cvt_f32_u32 v20, s[sgprNumWorkGroups0]           // s16 = s[sgprWorkGroup0] / s[sgprNumWorkGroups0]
s_delay_alu instid0(VALU_DEP_1)
v_rcp_iflag_f32 v20, v20                           // s16 = s[sgprWorkGroup0] / s[sgprNumWorkGroups0]
v_cvt_f32_u32 v21, s[sgprWorkGroup0]               // s16 = s[sgprWorkGroup0] / s[sgprNumWorkGroups0]
s_delay_alu instid0(VALU_DEP_1)
v_mul_f32 v20, v20, v21                            // s16 = s[sgprWorkGroup0] / s[sgprNumWorkGroups0]
s_delay_alu instid0(VALU_DEP_1)
v_cvt_u32_f32 v20, v20                             // s16 = s[sgprWorkGroup0] / s[sgprNumWorkGroups0]
v_mul_u32_u24 v21, v20, s[sgprNumWorkGroups0]      // s16 = s[sgprWorkGroup0] / s[sgprNumWorkGroups0]
v_sub_nc_u32 v21, s[sgprWorkGroup0], v21           // s16 = s[sgprWorkGroup0] / s[sgprNumWorkGroups0]
v_cmp_eq_u32 vcc_lo, v21, s[sgprNumWorkGroups0]    // s16 = s[sgprWorkGroup0] / s[sgprNumWorkGroups0]
s_mov_b32 exec_lo, vcc_lo                          // s16 = s[sgprWorkGroup0] / s[sgprNumWorkGroups0]
s_delay_alu instid0(VALU_DEP_4)
v_add_nc_u32 v20, 1, v20                           // s16 = s[sgprWorkGroup0] / s[sgprNumWorkGroups0]
s_mov_b32 exec_lo, -1                              // Reset exec
v_cmp_gt_u32 vcc_lo, v21, s[sgprNumWorkGroups0]    // overflow happened in remainder
s_mov_b32 exec_lo, vcc_lo                          // overflow happened in remainder
s_delay_alu instid0(VALU_DEP_2)
v_sub_nc_u32 v20, v20, 1                           // quotient - 1
s_mov_b32 exec_lo, -1                              // Reset exec
s_delay_alu instid0(VALU_DEP_1)
v_readfirstlane_b32 s16, v20                       // quotient
s_mov_b32 s[sgprWorkGroup1], s16
/* wg0 = idxWG01 - wg1 * numWG0 */
s_mul_i32 s16, s[sgprWorkGroup1], s[sgprNumWorkGroups0]
s_delay_alu instid0(SALU_CYCLE_1)
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
.set sgprSrdMetadata, 60
.set sgprShadowLimitA, 64
.set sgprShadowLimitB, 66
.set sgprShadowLimitMetadata, 68
.set sgprStaggerUIter, 59
.set sgprWrapUA, 70
.set sgprWrapUB, 72
.set sgprWrapUMetadata, 74
.set sgprGlobalReadIncsA, 76
.set sgprGlobalReadIncsB, 77
.set sgprGlobalReadIncsMetadata, 78
s_cmp_eq_u32 s[sgprArgType], 3                     // ArgType == 3 for General Batched GEMM
s_cbranch_scc1 label_Skip_Address_Prepad_For_Pointer_Array
s_sub_u32 s[sgprAddressA+0], s[sgprAddressA+0], 16 // pre-pad to make room for possible pointer shift
s_subb_u32 s[sgprAddressA+1], s[sgprAddressA+1], 0 // pre-pad to make room for possible pointer shift
s_sub_u32 s[sgprAddressB+0], s[sgprAddressB+0], 16 // pre-pad to make room for possible pointer shift
s_subb_u32 s[sgprAddressB+1], s[sgprAddressB+1], 0 // pre-pad to make room for possible pointer shift
s_sub_u32 s[sgprAddressMetadata+0], s[sgprAddressMetadata+0], 8 // pre-pad to make room for possible pointer shift
s_subb_u32 s[sgprAddressMetadata+1], s[sgprAddressMetadata+1], 0 // pre-pad to make room for possible pointer shift
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
s_delay_alu instid0(SALU_CYCLE_1)
s_cmp_eq_u32 s16, 1                                // GSU == 1 ?
s_cbranch_scc1 label_GSU                           // branch if GSU == 1
// GSU-not-WGMapRR :nwg1 = (size1J + MT1J - 1) / MT1J;
s_and_b32 s16, s[sgprGSU], 0x4000                  // SCC = (GSUWGMRR == 1) ?
s_cbranch_scc1 label_GSUWGMRR                      // branch if GSUWGMRR == 1
s_and_b32 s16, s[sgprGSU], 0x3fff                  // Restore GSU
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cvt_f32_u32 v20, s16                             // s[sgprWorkGroup1] = s[sgprWorkGroup1] / s16
s_delay_alu instid0(VALU_DEP_1)
v_rcp_iflag_f32 v20, v20                           // s[sgprWorkGroup1] = s[sgprWorkGroup1] / s16
v_cvt_f32_u32 v21, s[sgprWorkGroup1]               // s[sgprWorkGroup1] = s[sgprWorkGroup1] / s16
s_delay_alu instid0(VALU_DEP_1)
v_mul_f32 v20, v20, v21                            // s[sgprWorkGroup1] = s[sgprWorkGroup1] / s16
s_delay_alu instid0(VALU_DEP_1)
v_cvt_u32_f32 v20, v20                             // s[sgprWorkGroup1] = s[sgprWorkGroup1] / s16
v_mul_u32_u24 v21, v20, s16                        // s[sgprWorkGroup1] = s[sgprWorkGroup1] / s16
v_sub_nc_u32 v21, s[sgprWorkGroup1], v21           // s[sgprWorkGroup1] = s[sgprWorkGroup1] / s16
v_cmp_eq_u32 vcc_lo, v21, s16                      // s[sgprWorkGroup1] = s[sgprWorkGroup1] / s16
s_mov_b32 exec_lo, vcc_lo                          // s[sgprWorkGroup1] = s[sgprWorkGroup1] / s16
s_delay_alu instid0(VALU_DEP_4)
v_add_nc_u32 v20, 1, v20                           // s[sgprWorkGroup1] = s[sgprWorkGroup1] / s16
v_mov_b32 v21, 0                                   // s[sgprGSUSumIdx] = s[sgprWorkGroup1] % s16
s_mov_b32 exec_lo, -1                              // Reset exec
v_cmp_gt_u32 vcc_lo, v21, s16                      // overflow happened in remainder
s_mov_b32 exec_lo, vcc_lo                          // overflow happened in remainder
s_delay_alu instid0(VALU_DEP_3)
v_sub_nc_u32 v20, v20, 1                           // quotient - 1
v_mul_u32_u24 v21, v20, s16                        // re-calculate remainder
v_sub_nc_u32 v21, s[sgprWorkGroup1], v21           // re-calculate remainder
s_mov_b32 exec_lo, -1                              // Reset exec
s_delay_alu instid0(VALU_DEP_3)
v_readfirstlane_b32 s[sgprWorkGroup1], v20         // quotient
s_delay_alu instid0(VALU_DEP_2)
v_readfirstlane_b32 s[sgprGSUSumIdx], v21          // remainder
s_branch label_GSUWGMRR_End
label_GSUWGMRR:
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cvt_f32_u32 v20, s[sgprNumWorkGroups1]           // s[sgprGSUSumIdx] = s[sgprWorkGroup1] / s[sgprNumWorkGroups1]
s_delay_alu instid0(VALU_DEP_1)
v_rcp_iflag_f32 v20, v20                           // s[sgprGSUSumIdx] = s[sgprWorkGroup1] / s[sgprNumWorkGroups1]
v_cvt_f32_u32 v21, s[sgprWorkGroup1]               // s[sgprGSUSumIdx] = s[sgprWorkGroup1] / s[sgprNumWorkGroups1]
s_delay_alu instid0(VALU_DEP_1)
v_mul_f32 v20, v20, v21                            // s[sgprGSUSumIdx] = s[sgprWorkGroup1] / s[sgprNumWorkGroups1]
s_delay_alu instid0(VALU_DEP_1)
v_cvt_u32_f32 v20, v20                             // s[sgprGSUSumIdx] = s[sgprWorkGroup1] / s[sgprNumWorkGroups1]
v_mul_u32_u24 v21, v20, s[sgprNumWorkGroups1]      // s[sgprGSUSumIdx] = s[sgprWorkGroup1] / s[sgprNumWorkGroups1]
v_sub_nc_u32 v21, s[sgprWorkGroup1], v21           // s[sgprGSUSumIdx] = s[sgprWorkGroup1] / s[sgprNumWorkGroups1]
v_cmp_eq_u32 vcc_lo, v21, s[sgprNumWorkGroups1]    // s[sgprGSUSumIdx] = s[sgprWorkGroup1] / s[sgprNumWorkGroups1]
s_mov_b32 exec_lo, vcc_lo                          // s[sgprGSUSumIdx] = s[sgprWorkGroup1] / s[sgprNumWorkGroups1]
s_delay_alu instid0(VALU_DEP_4)
v_add_nc_u32 v20, 1, v20                           // s[sgprGSUSumIdx] = s[sgprWorkGroup1] / s[sgprNumWorkGroups1]
v_mov_b32 v21, 0                                   // s[sgprWorkGroup1] = s[sgprWorkGroup1] % s[sgprNumWorkGroups1]
s_mov_b32 exec_lo, -1                              // Reset exec
v_cmp_gt_u32 vcc_lo, v21, s[sgprNumWorkGroups1]    // overflow happened in remainder
s_mov_b32 exec_lo, vcc_lo                          // overflow happened in remainder
s_delay_alu instid0(VALU_DEP_3)
v_sub_nc_u32 v20, v20, 1                           // quotient - 1
v_mul_u32_u24 v21, v20, s[sgprNumWorkGroups1]      // re-calculate remainder
v_sub_nc_u32 v21, s[sgprWorkGroup1], v21           // re-calculate remainder
s_mov_b32 exec_lo, -1                              // Reset exec
s_delay_alu instid0(VALU_DEP_3)
v_readfirstlane_b32 s[sgprGSUSumIdx], v20          // quotient
s_delay_alu instid0(VALU_DEP_2)
v_readfirstlane_b32 s[sgprWorkGroup1], v21         // remainder
label_GSUWGMRR_End:
s_mov_b32 s[sgprGSULog2BpeC], 1
s_mov_b32 s[sgprGSULog2BpeD], 2
s_branch label_GSU_End
label_GSU:
s_mov_b64 s[sgprGSUSumIdx:sgprGSUSumIdx+1], 0      // Set GSUSumIdx to 0
s_mov_b32 s[sgprGSULog2BpeC], 1
s_mov_b32 s[sgprGSULog2BpeD], 1
label_GSU_End:
/* WGM Calculation */
s_mov_b32 s16, s[sgprWGM]                          // Restore WGM
s_delay_alu instid0(SALU_CYCLE_1)
s_sext_i32_i16 s16, s16                            // Restore WGM
s_delay_alu instid0(SALU_CYCLE_1)
s_cmp_gt_i32 s16, 1                                // WGM > 1 ?
s_cbranch_scc1 label_WGMPositive                   // branch if WGM > 1
s_cmp_ge_i32 s16, 0                                // WGM >= 0 ?
s_cbranch_scc1 label_WGM                           // branch if WGM >= 0
s_abs_i32 s16, s16                                 // abs(WGM)
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cvt_f64_u32 v[24:25], s16                        // s17 = s[sgprWorkGroup0] / s16
s_delay_alu instid0(VALU_DEP_1)
v_rcp_f64 v[24:25], v[24:25]                       // s17 = s[sgprWorkGroup0] / s16
v_cvt_f64_u32 v[26:27], s[sgprWorkGroup0]          // s17 = s[sgprWorkGroup0] / s16
s_delay_alu instid0(VALU_DEP_1)
v_mul_f64 v[24:25], v[24:25], v[26:27]             // s17 = s[sgprWorkGroup0] / s16
s_delay_alu instid0(VALU_DEP_1)
v_cvt_u32_f64 v24, v[24:25]                        // s17 = s[sgprWorkGroup0] / s16
v_mul_lo_u32 v25, v24, s16                         // s17 = s[sgprWorkGroup0] / s16
v_sub_nc_u32 v26, s[sgprWorkGroup0], v25           // s17 = s[sgprWorkGroup0] / s16
v_cmp_ge_u32 vcc_lo, v26, s16                      // s17 = s[sgprWorkGroup0] / s16
s_mov_b32 exec_lo, vcc_lo                          // s17 = s[sgprWorkGroup0] / s16
s_delay_alu instid0(VALU_DEP_4)
v_add_nc_u32 v24, v24, 1                           // s17 = s[sgprWorkGroup0] / s16
s_mov_b32 exec_lo, -1                              // Reset exec
s_delay_alu instid0(VALU_DEP_1)
v_readfirstlane_b32 s17, v24                       // quotient
s_mul_i32 s20, s17, s16                            // quotient * non-magic divisor
s_sub_u32 s20, s[sgprWorkGroup0], s20              // WorkGroup0=remainder
s_mul_i32 s20, s20, s[sgprNumWorkGroups1]          // (wg1 % WGM)*NumWorkGroups1
s_add_u32 s20, s20, s[sgprWorkGroup1]              // wgSerial = wg0 + (wg1 % WGM)*NumWorkGroups1
v_cvt_f64_u32 v[24:25], s16                        // s18 = s[sgprNumWorkGroups0] / s16
s_delay_alu instid0(VALU_DEP_1)
v_rcp_f64 v[24:25], v[24:25]                       // s18 = s[sgprNumWorkGroups0] / s16
v_cvt_f64_u32 v[26:27], s[sgprNumWorkGroups0]      // s18 = s[sgprNumWorkGroups0] / s16
s_delay_alu instid0(VALU_DEP_1)
v_mul_f64 v[24:25], v[24:25], v[26:27]             // s18 = s[sgprNumWorkGroups0] / s16
s_delay_alu instid0(VALU_DEP_1)
v_cvt_u32_f64 v24, v[24:25]                        // s18 = s[sgprNumWorkGroups0] / s16
v_mul_lo_u32 v25, v24, s16                         // s18 = s[sgprNumWorkGroups0] / s16
v_sub_nc_u32 v26, s[sgprNumWorkGroups0], v25       // s18 = s[sgprNumWorkGroups0] / s16
v_cmp_ge_u32 vcc_lo, v26, s16                      // s18 = s[sgprNumWorkGroups0] / s16
s_mov_b32 exec_lo, vcc_lo                          // s18 = s[sgprNumWorkGroups0] / s16
s_delay_alu instid0(VALU_DEP_4)
v_add_nc_u32 v24, v24, 1                           // s18 = s[sgprNumWorkGroups0] / s16
s_mov_b32 exec_lo, -1                              // Reset exec
s_delay_alu instid0(VALU_DEP_1)
v_readfirstlane_b32 s18, v24                       // quotient
s_mul_i32 s19, s16, s18                            // quotient * non-magic divisor
s_sub_u32 s19, s[sgprNumWorkGroups0], s19          // NumWorkGroups0=remainder
s_delay_alu instid0(SALU_CYCLE_1)
s_cmp_eq_u32 s19, 0                                // remainder == 0 ?
s_cmov_b32 s19, s16                                // remainder = WGM if remainder == 0
s_cmp_ge_u32 s17, s18                              // blockId >= numFullBlocks ?
s_cselect_b32 s18, s19, s16
v_cvt_f64_u32 v[24:25], s18                        // s[sgprWorkGroup1] = s20 / s18
s_delay_alu instid0(VALU_DEP_1)
v_rcp_f64 v[24:25], v[24:25]                       // s[sgprWorkGroup1] = s20 / s18
v_cvt_f64_u32 v[26:27], s20                        // s[sgprWorkGroup1] = s20 / s18
s_delay_alu instid0(VALU_DEP_1)
v_mul_f64 v[24:25], v[24:25], v[26:27]             // s[sgprWorkGroup1] = s20 / s18
s_delay_alu instid0(VALU_DEP_1)
v_cvt_u32_f64 v24, v[24:25]                        // s[sgprWorkGroup1] = s20 / s18
v_mul_lo_u32 v25, v24, s18                         // s[sgprWorkGroup1] = s20 / s18
v_sub_nc_u32 v26, s20, v25                         // s[sgprWorkGroup1] = s20 / s18
v_cmp_ge_u32 vcc_lo, v26, s18                      // s[sgprWorkGroup1] = s20 / s18
s_mov_b32 exec_lo, vcc_lo                          // s[sgprWorkGroup1] = s20 / s18
s_delay_alu instid0(VALU_DEP_4)
v_add_nc_u32 v24, v24, 1                           // s[sgprWorkGroup1] = s20 / s18
s_mov_b32 exec_lo, -1                              // Reset exec
v_mul_lo_u32 v25, v24, s18                         // s[sgprWorkGroup1] = s20 / s18
v_sub_nc_u32 v26, s20, v25                         // s[sgprWorkGroup1] = s20 / s18
s_delay_alu instid0(VALU_DEP_3)
v_readfirstlane_b32 s[sgprWorkGroup1], v24         // quotient
s_delay_alu instid0(VALU_DEP_2)
v_readfirstlane_b32 s[sgprWorkGroup0], v26         // remainder
s_mul_i32 s[sgprWorkGroup0], s[sgprWorkGroup1], s18 // quotient * non-magic divisor
s_delay_alu instid0(SALU_CYCLE_1)
s_sub_u32 s[sgprWorkGroup0], s20, s[sgprWorkGroup0] // WorkGroup0=remainder
s_mul_i32 s17, s17, s16                            // blockId * WGM
s_delay_alu instid0(SALU_CYCLE_1)
s_add_u32 s[sgprWorkGroup0], s[sgprWorkGroup0], s17 // wg1 += blockId * WGM
s_branch label_WGM
label_WGMPositive:
s_mov_b32 s16, s16                                 // WGM
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cvt_f64_u32 v[24:25], s16                        // s17 = s[sgprWorkGroup1] / s16
s_delay_alu instid0(VALU_DEP_1)
v_rcp_f64 v[24:25], v[24:25]                       // s17 = s[sgprWorkGroup1] / s16
v_cvt_f64_u32 v[26:27], s[sgprWorkGroup1]          // s17 = s[sgprWorkGroup1] / s16
s_delay_alu instid0(VALU_DEP_1)
v_mul_f64 v[24:25], v[24:25], v[26:27]             // s17 = s[sgprWorkGroup1] / s16
s_delay_alu instid0(VALU_DEP_1)
v_cvt_u32_f64 v24, v[24:25]                        // s17 = s[sgprWorkGroup1] / s16
v_mul_lo_u32 v25, v24, s16                         // s17 = s[sgprWorkGroup1] / s16
v_sub_nc_u32 v26, s[sgprWorkGroup1], v25           // s17 = s[sgprWorkGroup1] / s16
v_cmp_ge_u32 vcc_lo, v26, s16                      // s17 = s[sgprWorkGroup1] / s16
s_mov_b32 exec_lo, vcc_lo                          // s17 = s[sgprWorkGroup1] / s16
s_delay_alu instid0(VALU_DEP_4)
v_add_nc_u32 v24, v24, 1                           // s17 = s[sgprWorkGroup1] / s16
s_mov_b32 exec_lo, -1                              // Reset exec
s_delay_alu instid0(VALU_DEP_1)
v_readfirstlane_b32 s17, v24                       // quotient
s_delay_alu instid0(SALU_CYCLE_1)
s_mul_i32 s20, s17, s16                            // quotient * non-magic divisor
s_sub_u32 s20, s[sgprWorkGroup1], s20              // WorkGroup1=remainder
s_mul_i32 s20, s20, s[sgprNumWorkGroups0]          // (wg1 % WGM)*NumWorkGroups0
s_delay_alu instid0(SALU_CYCLE_1)
s_add_u32 s20, s20, s[sgprWorkGroup0]              // wgSerial = wg0 + (wg1 % WGM)*NumWorkGroups0
v_cvt_f64_u32 v[24:25], s16                        // s18 = s[sgprNumWorkGroups1] / s16
s_delay_alu instid0(VALU_DEP_1)
v_rcp_f64 v[24:25], v[24:25]                       // s18 = s[sgprNumWorkGroups1] / s16
v_cvt_f64_u32 v[26:27], s[sgprNumWorkGroups1]      // s18 = s[sgprNumWorkGroups1] / s16
s_delay_alu instid0(VALU_DEP_1)
v_mul_f64 v[24:25], v[24:25], v[26:27]             // s18 = s[sgprNumWorkGroups1] / s16
s_delay_alu instid0(VALU_DEP_1)
v_cvt_u32_f64 v24, v[24:25]                        // s18 = s[sgprNumWorkGroups1] / s16
v_mul_lo_u32 v25, v24, s16                         // s18 = s[sgprNumWorkGroups1] / s16
v_sub_nc_u32 v26, s[sgprNumWorkGroups1], v25       // s18 = s[sgprNumWorkGroups1] / s16
v_cmp_ge_u32 vcc_lo, v26, s16                      // s18 = s[sgprNumWorkGroups1] / s16
s_mov_b32 exec_lo, vcc_lo                          // s18 = s[sgprNumWorkGroups1] / s16
s_delay_alu instid0(VALU_DEP_4)
v_add_nc_u32 v24, v24, 1                           // s18 = s[sgprNumWorkGroups1] / s16
s_mov_b32 exec_lo, -1                              // Reset exec
s_delay_alu instid0(VALU_DEP_1)
v_readfirstlane_b32 s18, v24                       // quotient
s_mul_i32 s19, s16, s18                            // quotient * non-magic divisor
s_sub_u32 s19, s[sgprNumWorkGroups1], s19          // NumWorkGroups1=remainder
s_delay_alu instid0(SALU_CYCLE_1)
s_cmp_eq_u32 s19, 0                                // remainder == 0 ?
s_cmov_b32 s19, s16                                // remainder = WGM if remainder == 0
s_cmp_ge_u32 s17, s18                              // blockId >= numFullBlocks ?
s_cselect_b32 s18, s19, s16
v_cvt_f64_u32 v[24:25], s18                        // s[sgprWorkGroup0] = s20 / s18
s_delay_alu instid0(VALU_DEP_1)
v_rcp_f64 v[24:25], v[24:25]                       // s[sgprWorkGroup0] = s20 / s18
v_cvt_f64_u32 v[26:27], s20                        // s[sgprWorkGroup0] = s20 / s18
s_delay_alu instid0(VALU_DEP_1)
v_mul_f64 v[24:25], v[24:25], v[26:27]             // s[sgprWorkGroup0] = s20 / s18
s_delay_alu instid0(VALU_DEP_1)
v_cvt_u32_f64 v24, v[24:25]                        // s[sgprWorkGroup0] = s20 / s18
v_mul_lo_u32 v25, v24, s18                         // s[sgprWorkGroup0] = s20 / s18
v_sub_nc_u32 v26, s20, v25                         // s[sgprWorkGroup0] = s20 / s18
v_cmp_ge_u32 vcc_lo, v26, s18                      // s[sgprWorkGroup0] = s20 / s18
s_mov_b32 exec_lo, vcc_lo                          // s[sgprWorkGroup0] = s20 / s18
s_delay_alu instid0(VALU_DEP_4)
v_add_nc_u32 v24, v24, 1                           // s[sgprWorkGroup0] = s20 / s18
s_mov_b32 exec_lo, -1                              // Reset exec
v_mul_lo_u32 v25, v24, s18                         // s[sgprWorkGroup0] = s20 / s18
v_sub_nc_u32 v26, s20, v25                         // s[sgprWorkGroup0] = s20 / s18
s_delay_alu instid0(VALU_DEP_3)
v_readfirstlane_b32 s[sgprWorkGroup0], v24         // quotient
s_delay_alu instid0(VALU_DEP_2)
v_readfirstlane_b32 s[sgprWorkGroup1], v26         // remainder
s_delay_alu instid0(SALU_CYCLE_1)
s_mul_i32 s[sgprWorkGroup1], s[sgprWorkGroup0], s18 // quotient * non-magic divisor
s_delay_alu instid0(SALU_CYCLE_1)
s_sub_u32 s[sgprWorkGroup1], s20, s[sgprWorkGroup1] // WorkGroup1=remainder
s_mul_i32 s17, s17, s16                            // blockId * WGM
s_delay_alu instid0(SALU_CYCLE_1)
s_add_u32 s[sgprWorkGroup1], s[sgprWorkGroup1], s17 // wg1 += blockId * WGM
label_WGM:

/* global read addresses: tile offset assignment a */
/* graTileAssignmentA = v0 */

/* global read addresses: tile offset assignment metadata */
/* graTileAssignmentMetadata = v6 */

/* global read addresses: tile offset assignment b */
/* graTileAssignmentB = v2 */

/* global read addresses: unroll assignment a */
/* v1 */

/* global read addresses: unroll assignment metadata */
/* v7 */

/* global read addresses: unroll assignment b */
/* v3 */

/* global read addresses: other free assignments */
/* s[sgprWorkGroup2] */

/* global read addresses: tile offsets a */
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v20, v0                                  // groA0I_0

/* global read addresses: tile offsets metadata */
v_lshrrev_b32 v21, 0x0, v6                         // groMetadata1J_0 /= 1
s_delay_alu instid0(VALU_DEP_1)
v_lshlrev_b32 v21, 0x0, v21                        // groMetadata1J_0 *= 1

/* global read addresses: tile offsets b */
v_mov_b32 v23, v2                                  // groB1J_0
s_delay_alu instid0(VALU_DEP_1)
v_add_co_u32 v24, vcc_lo, 8, v23                   // groB1J_1 += LSPB

/* global read addresses: unroll offsets a */
v_mov_b32 v25, v1                                  // groAL_0
s_delay_alu instid0(VALU_DEP_1)
v_add_co_u32 v26, vcc_lo, 32, v25                  // groAL_1 + LSPA
s_delay_alu instid0(VALU_DEP_1)
v_add_co_u32 v27, vcc_lo, 32, v26                  // groAL_2 + LSPA
s_delay_alu instid0(VALU_DEP_1)
v_add_co_u32 v28, vcc_lo, 32, v27                  // groAL_3 + LSPA

/* global read addresses: unroll offsets metadata */
v_mov_b32 v29, v7                                  // groMetadataL_0

/* global read addresses: unroll offsets b */
v_mov_b32 v30, v3                                  // groBL_0

/* global read addresses: shift a */
s_mul_i32 s16, s[sgprWorkGroup0], 16               // WorkGroup[01] * MT
s_sub_u32 s16, s[sgprSizeI], s16                   // edge = Size0I - WG*MT
s_delay_alu instid0(SALU_CYCLE_1)
s_sub_u32 s16, s16, 16                             // edge -= margin(16)
s_delay_alu instid0(NO_DEP)
v_mov_b32 v31, s16                                 // edge vgpr = Size0I- WG*MT - margin(16)
v_min_i32 v20, v31, v20                            // offset = (offset < edge) ? offset(v20) : edge(v31)

/* global read addresses: shift metadata */
s_mul_i32 s16, s[sgprWorkGroup1], 16               // WorkGroup[01] * MT
s_sub_u32 s16, s[sgprSizeJ], s16                   // edge = Size1J - WG*MT
s_delay_alu instid0(SALU_CYCLE_1)
s_sub_u32 s16, s16, 1                              // edge -= margin(1)
s_delay_alu instid0(NO_DEP)
v_mov_b32 v31, s16                                 // edge vgpr = Size1J- WG*MT - margin(1)
v_min_i32 v21, v31, v21                            // offset = (offset < edge) ? offset(v21) : edge(v31)
v_and_b32 v31, 0, v6                               // shifTailOffstet = tailOffset % 1
s_delay_alu instid0(VALU_DEP_1)
v_add_nc_u32 v21, v31, v21                         // offset += shifTailOffstet

/* global read addresses: addresses a */
/* max read offset = size[n] * stride[n-1] */
s_mul_hi_u32 s19, s[sgprWorkGroup0], 16            // WorkGroup[01] * MT
s_mul_i32 s18, s[sgprWorkGroup0], 16               // WorkGroup[01] * MT
s_and_b32 s16, s[sgprGSU], 0x8000                  // SCC = (GSUC == 1) ?
s_cbranch_scc1 label_GSUC_A                        // branch if GSUC == 1
s_mul_hi_u32 s17, 128, s[sgprGSUSumIdx]            // gsuOffset = DepthU*GSUSumIdx
s_mul_i32 s16, 128, s[sgprGSUSumIdx]               // gsuOffset = DepthU*GSUSumIdx
s_branch label_GSUC_A_End
label_GSUC_A:
s_lshr_b32 s[sgprLoopCounterL], s[sgprSizesSum], 7 // s[LoopCounterL] = s[sgprSizesSum] / 128
s_and_b32 s[sgprGSUSumIdx+1], s[sgprGSU], 0x3fff   // Restore GSU
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cvt_f32_u32 v31, s[sgprGSUSumIdx+1]              // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
s_delay_alu instid0(VALU_DEP_1)
v_rcp_iflag_f32 v31, v31                           // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
v_cvt_f32_u32 v32, s[sgprLoopCounterL]             // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
s_delay_alu instid0(VALU_DEP_1)
v_mul_f32 v31, v31, v32                            // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
s_delay_alu instid0(VALU_DEP_1)
v_cvt_u32_f32 v31, v31                             // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
v_mul_u32_u24 v32, v31, s[sgprGSUSumIdx+1]         // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
v_sub_nc_u32 v32, s[sgprLoopCounterL], v32         // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
v_cmp_eq_u32 vcc_lo, v32, s[sgprGSUSumIdx+1]       // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
s_mov_b32 exec_lo, vcc_lo                          // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
s_delay_alu instid0(VALU_DEP_4)
v_add_nc_u32 v31, 1, v31                           // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
v_mov_b32 v32, 0                                   // s[sgprGSUSumIdx+1] = s[sgprLoopCounterL] % s[sgprGSUSumIdx+1]
s_mov_b32 exec_lo, -1                              // Reset exec
v_cmp_gt_u32 vcc_lo, v32, s[sgprGSUSumIdx+1]       // overflow happened in remainder
s_mov_b32 exec_lo, vcc_lo                          // overflow happened in remainder
s_delay_alu instid0(VALU_DEP_3)
v_sub_nc_u32 v31, v31, 1                           // quotient - 1
v_mul_u32_u24 v32, v31, s[sgprGSUSumIdx+1]         // re-calculate remainder
v_sub_nc_u32 v32, s[sgprLoopCounterL], v32         // re-calculate remainder
s_mov_b32 exec_lo, -1                              // Reset exec
s_delay_alu instid0(VALU_DEP_3)
v_readfirstlane_b32 s[sgprLoopCounterL], v31       // quotient
s_delay_alu instid0(VALU_DEP_2)
v_readfirstlane_b32 s[sgprGSUSumIdx+1], v32        // remainder
s_mul_i32 s17, s[sgprLoopCounterL], s[sgprGSUSumIdx] // quotient*GSUSumIdx
s_add_u32 s16, 1, s[sgprLoopCounterL]              // quotient+1
s_add_u32 s17, s17, s[sgprGSUSumIdx+1]             // quotient*GSUSumIdx+remainder
s_mul_i32 s16, s16, s[sgprGSUSumIdx]               // (quotient+1)*GSUSumIdx
s_cmp_lt_u32 s[sgprGSUSumIdx], s[sgprGSUSumIdx+1]  // gsuSumIdx < numIterPerWgRemainder
s_cselect_b32 s16, s16, s17                        // (quotient+1)*GSUSumIdx if needed
s_mul_hi_u32 s17, s16, 128                         // gsuOffset = DepthU*accumulatedNumOfLoopCounterL
s_mul_i32 s16, s16, 128                            // gsuOffset = DepthU*accumulatedNumOfLoopCounterL
label_GSUC_A_End:
s_mul_hi_u32 s17, s16, s[sgprStrideAL]             // tlu=1, scaled unroll-offset by stride
s_mul_i32 s16, s16, s[sgprStrideAL]                // tlu=1, scaled unroll-offset by stride
s_add_u32 s18, s18, s16                            // accum GsuOffset term to tilestart
s_addc_u32 s19, s19, s17                           // accum GsuOffset term to tilestart
s_mov_b64 s[sgprShadowLimitA+0:sgprShadowLimitA+0+1], 1 // Init tensor size
s_sub_u32 s16, s[sgprSizeI], 1                     // (size-1)
s_delay_alu instid0(SALU_CYCLE_1)
s_mul_hi_u32 s17, constStrideA0I, s16              // stride x (size-1)
s_mul_i32 s16, constStrideA0I, s16                 // stride x (size-1)
s_add_u32 s[sgprShadowLimitA+0], s[sgprShadowLimitA+0], s16 // sum tensor size
s_addc_u32 s[sgprShadowLimitA+1], s[sgprShadowLimitA+1], s17 // sum tensor size
s_sub_u32 s16, s[sgprSizeL], 1                     // (size-1)
s_mul_hi_u32 s17, s[sgprStrideAL], s16             // stride x (size-1)
s_mul_i32 s16, s[sgprStrideAL], s16                // stride x (size-1)
s_delay_alu instid0(SALU_CYCLE_1)
s_add_u32 s[sgprShadowLimitA+0], s[sgprShadowLimitA+0], s16 // sum tensor size
s_addc_u32 s[sgprShadowLimitA+1], s[sgprShadowLimitA+1], s17 // sum tensor size
s_sub_u32 s[sgprShadowLimitA+0], s[sgprShadowLimitA+0], s18 // sub tileStart
s_subb_u32 s[sgprShadowLimitA+1], s[sgprShadowLimitA+1], s19 // sub tileStart
                                                   // Set limit to use bytes (bpe is 1, do nothing)
s_add_u32 s[sgprShadowLimitA+0], s[sgprShadowLimitA+0], 16 // extend limit for pre-pad
s_addc_u32 s[sgprShadowLimitA+1], s[sgprShadowLimitA+1], 0 // extend limit for pre-pad
s_delay_alu instid0(SALU_CYCLE_1)
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
s_sub_u32 s[sgprSrdA+0], s[sgprSrdA+0], 16         // pre-pad to make room for possible pointer shift
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
s_delay_alu instid0(SALU_CYCLE_1)
s_lshl_b32 s16, s16, 25
s_and_b32 s[sgprSrdA+1], s[sgprSrdA+1], 33554431
s_delay_alu instid0(SALU_CYCLE_1)
s_or_b32 s[sgprSrdA+1], s[sgprSrdA+1], s16
s_lshr_b32 s[sgprSrdA+2], s[sgprSrdA+2], 7

/* global read addresses: addresses metadata */
/* max read offset = size[n] * stride[n-1] */
s_mul_hi_u32 s19, s[sgprWorkGroup1], 16            // WorkGroup[01] * MT
s_mul_i32 s18, s[sgprWorkGroup1], 16               // WorkGroup[01] * MT
s_mul_hi_u32 s19, s18, s[sgprStrideMetadata1J]     // tlu=0, scaled tile-offset by stride
s_mul_i32 s18, s18, s[sgprStrideMetadata1J]        // tlu=0, scaled tile-offset by stride
s_and_b32 s16, s[sgprGSU], 0x8000                  // SCC = (GSUC == 1) ?
s_cbranch_scc1 label_GSUC_Metadata                 // branch if GSUC == 1
s_mul_hi_u32 s17, 16, s[sgprGSUSumIdx]             // gsuOffset = DepthU*GSUSumIdx
s_mul_i32 s16, 16, s[sgprGSUSumIdx]                // gsuOffset = DepthU*GSUSumIdx
s_branch label_GSUC_Metadata_End
label_GSUC_Metadata:
s_lshr_b32 s[sgprLoopCounterL], s[sgprSizesSum], 7 // s[LoopCounterL] = s[sgprSizesSum] / 128
s_and_b32 s[sgprGSUSumIdx+1], s[sgprGSU], 0x3fff   // Restore GSU
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cvt_f32_u32 v31, s[sgprGSUSumIdx+1]              // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
s_delay_alu instid0(VALU_DEP_1)
v_rcp_iflag_f32 v31, v31                           // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
v_cvt_f32_u32 v32, s[sgprLoopCounterL]             // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
s_delay_alu instid0(VALU_DEP_1)
v_mul_f32 v31, v31, v32                            // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
s_delay_alu instid0(VALU_DEP_1)
v_cvt_u32_f32 v31, v31                             // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
v_mul_u32_u24 v32, v31, s[sgprGSUSumIdx+1]         // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
v_sub_nc_u32 v32, s[sgprLoopCounterL], v32         // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
v_cmp_eq_u32 vcc_lo, v32, s[sgprGSUSumIdx+1]       // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
s_mov_b32 exec_lo, vcc_lo                          // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
s_delay_alu instid0(VALU_DEP_4)
v_add_nc_u32 v31, 1, v31                           // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
v_mov_b32 v32, 0                                   // s[sgprGSUSumIdx+1] = s[sgprLoopCounterL] % s[sgprGSUSumIdx+1]
s_mov_b32 exec_lo, -1                              // Reset exec
v_cmp_gt_u32 vcc_lo, v32, s[sgprGSUSumIdx+1]       // overflow happened in remainder
s_mov_b32 exec_lo, vcc_lo                          // overflow happened in remainder
s_delay_alu instid0(VALU_DEP_3)
v_sub_nc_u32 v31, v31, 1                           // quotient - 1
v_mul_u32_u24 v32, v31, s[sgprGSUSumIdx+1]         // re-calculate remainder
v_sub_nc_u32 v32, s[sgprLoopCounterL], v32         // re-calculate remainder
s_mov_b32 exec_lo, -1                              // Reset exec
s_delay_alu instid0(VALU_DEP_3)
v_readfirstlane_b32 s[sgprLoopCounterL], v31       // quotient
s_delay_alu instid0(VALU_DEP_2)
v_readfirstlane_b32 s[sgprGSUSumIdx+1], v32        // remainder
s_mul_i32 s17, s[sgprLoopCounterL], s[sgprGSUSumIdx] // quotient*GSUSumIdx
s_add_u32 s16, 1, s[sgprLoopCounterL]              // quotient+1
s_add_u32 s17, s17, s[sgprGSUSumIdx+1]             // quotient*GSUSumIdx+remainder
s_mul_i32 s16, s16, s[sgprGSUSumIdx]               // (quotient+1)*GSUSumIdx
s_cmp_lt_u32 s[sgprGSUSumIdx], s[sgprGSUSumIdx+1]  // gsuSumIdx < numIterPerWgRemainder
s_cselect_b32 s16, s16, s17                        // (quotient+1)*GSUSumIdx if needed
s_mul_hi_u32 s17, s16, 16                          // gsuOffset = DepthU*accumulatedNumOfLoopCounterL
s_mul_i32 s16, s16, 16                             // gsuOffset = DepthU*accumulatedNumOfLoopCounterL
label_GSUC_Metadata_End:
s_add_u32 s18, s18, s16                            // accum GsuOffset term to tilestart
s_addc_u32 s19, s19, s17                           // accum GsuOffset term to tilestart
s_mov_b64 s[sgprShadowLimitMetadata+0:sgprShadowLimitMetadata+0+1], 1 // Init tensor size
s_lshr_b32 s16, s[sgprSizeL], 0x3                  // (size/8)
s_delay_alu instid0(SALU_CYCLE_1)
s_sub_u32 s16, s16, 1                              // (size/8-1)
s_delay_alu instid0(SALU_CYCLE_1)
s_mul_hi_u32 s17, constStrideMetadataL, s16        // stride x (size-1)
s_mul_i32 s16, constStrideMetadataL, s16           // stride x (size-1)
s_add_u32 s[sgprShadowLimitMetadata+0], s[sgprShadowLimitMetadata+0], s16 // sum tensor size
s_addc_u32 s[sgprShadowLimitMetadata+1], s[sgprShadowLimitMetadata+1], s17 // sum tensor size
s_sub_u32 s16, s[sgprSizeJ], 1                     // (size-1)
s_mul_hi_u32 s17, s[sgprStrideMetadata1J], s16     // stride x (size-1)
s_mul_i32 s16, s[sgprStrideMetadata1J], s16        // stride x (size-1)
s_delay_alu instid0(SALU_CYCLE_1)
s_add_u32 s[sgprShadowLimitMetadata+0], s[sgprShadowLimitMetadata+0], s16 // sum tensor size
s_addc_u32 s[sgprShadowLimitMetadata+1], s[sgprShadowLimitMetadata+1], s17 // sum tensor size
s_sub_u32 s[sgprShadowLimitMetadata+0], s[sgprShadowLimitMetadata+0], s18 // sub tileStart
s_subb_u32 s[sgprShadowLimitMetadata+1], s[sgprShadowLimitMetadata+1], s19 // sub tileStart
                                                   // Set limit to use bytes (bpe is 1, do nothing)
s_add_u32 s[sgprShadowLimitMetadata+0], s[sgprShadowLimitMetadata+0], 8 // extend limit for pre-pad
s_addc_u32 s[sgprShadowLimitMetadata+1], s[sgprShadowLimitMetadata+1], 0 // extend limit for pre-pad
s_delay_alu instid0(SALU_CYCLE_1)
s_cmp_eq_u32 s[sgprShadowLimitMetadata+1], 0       // are we within 2^32?
s_cselect_b32 s[sgprSrdMetadata+2], s[sgprShadowLimitMetadata+0], BufferLimit // Move shadow to real if we are within 2^32
s_cmp_eq_u32 s[sgprArgType], 3                     // ArgType == 3 for General Batched GEMM
s_cbranch_scc0 label_StridedBatchedGemmLoadMetadata
s_mul_i32 s16, 8, s[sgprWorkGroup2]                // Compute Offset into Pointer Array
s_cmp_eq_u32 s[sgprSizesSum], 0x0                  // Don't dereference Pointer array if SizesSum == 0
s_cbranch_scc1 label_StridedBatchedGemmLoadMetadata_End
s_add_u32 s16, s16, s[sgprAddressMetadata+0]       // Offsetting to the location [Lower half of address]
s_addc_u32 s17, s[sgprAddressMetadata+1], 0        // Offsetting to the location [Higher half of address]
s_load_b64 s[sgprSrdMetadata:sgprSrdMetadata+1], s[16:17], 0 // Load the Matrix Address in the Pointer Array
s_wait_kmcnt 0                                     // Wait for the Matrix Address Load from the Pointer Array
                                                   // tileStart (bpe is 1, do nothing)
s_add_u32 s[sgprSrdMetadata+0], s18, s[sgprSrdMetadata+0] // SRD base = Address+ tileStart0
s_addc_u32 s[sgprSrdMetadata+1], s19, s[sgprSrdMetadata+1] // SRD base = Address+ tileStart1
s_branch label_StridedBatchedGemmLoadMetadata_End
label_StridedBatchedGemmLoadMetadata:  /// Computing the Batch Matrix's base address for Strided Batched GEMM
s_mul_hi_u32 s17, s[sgprStrideMetadataK], s[sgprWorkGroup2] // Stride*WG
s_mul_i32 s16, s[sgprStrideMetadataK], s[sgprWorkGroup2] // Stride*WG
s_add_u32 s18, s18, s16                            // accum wg term to tilestart
s_addc_u32 s19, s19, s17                           // accum wg term to tilestart
                                                   // tileStart (bpe is 1, do nothing)
s_add_u32 s[sgprSrdMetadata+0], s[sgprAddressMetadata+0], s18 // SRD base = Address+ tileStart0
s_addc_u32 s[sgprSrdMetadata+1], s[sgprAddressMetadata+1], s19 // SRD base = Address+ tileStart1
label_StridedBatchedGemmLoadMetadata_End:  /// End Computing the Batch Matrix's base address for Strided Batched
s_mov_b32 s[sgprSrdMetadata+3], Srd127_96          // Set bits 127_96 in SRD
// Shift num records for gfx125x
s_and_b32 s16, s[sgprSrdMetadata+2], 127
s_delay_alu instid0(SALU_CYCLE_1)
s_lshl_b32 s16, s16, 25
s_and_b32 s[sgprSrdMetadata+1], s[sgprSrdMetadata+1], 33554431
s_delay_alu instid0(SALU_CYCLE_1)
s_or_b32 s[sgprSrdMetadata+1], s[sgprSrdMetadata+1], s16
s_lshr_b32 s[sgprSrdMetadata+2], s[sgprSrdMetadata+2], 7

/* global read addresses: addresses b */
/* max read offset = size[n] * stride[n-1] */
s_mul_hi_u32 s19, s[sgprWorkGroup1], 16            // WorkGroup[01] * MT
s_mul_i32 s18, s[sgprWorkGroup1], 16               // WorkGroup[01] * MT
s_mul_hi_u32 s19, s18, s[sgprStrideB1J]            // tlu=0, scaled tile-offset by stride
s_mul_i32 s18, s18, s[sgprStrideB1J]               // tlu=0, scaled tile-offset by stride
s_and_b32 s16, s[sgprGSU], 0x8000                  // SCC = (GSUC == 1) ?
s_cbranch_scc1 label_GSUC_B                        // branch if GSUC == 1
s_mul_hi_u32 s17, 64, s[sgprGSUSumIdx]             // gsuOffset = DepthU*GSUSumIdx
s_mul_i32 s16, 64, s[sgprGSUSumIdx]                // gsuOffset = DepthU*GSUSumIdx
s_branch label_GSUC_B_End
label_GSUC_B:
s_lshr_b32 s[sgprLoopCounterL], s[sgprSizesSum], 7 // s[LoopCounterL] = s[sgprSizesSum] / 128
s_and_b32 s[sgprGSUSumIdx+1], s[sgprGSU], 0x3fff   // Restore GSU
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cvt_f32_u32 v31, s[sgprGSUSumIdx+1]              // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
s_delay_alu instid0(VALU_DEP_1)
v_rcp_iflag_f32 v31, v31                           // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
v_cvt_f32_u32 v32, s[sgprLoopCounterL]             // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
s_delay_alu instid0(VALU_DEP_1)
v_mul_f32 v31, v31, v32                            // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
s_delay_alu instid0(VALU_DEP_1)
v_cvt_u32_f32 v31, v31                             // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
v_mul_u32_u24 v32, v31, s[sgprGSUSumIdx+1]         // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
v_sub_nc_u32 v32, s[sgprLoopCounterL], v32         // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
v_cmp_eq_u32 vcc_lo, v32, s[sgprGSUSumIdx+1]       // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
s_mov_b32 exec_lo, vcc_lo                          // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
s_delay_alu instid0(VALU_DEP_4)
v_add_nc_u32 v31, 1, v31                           // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
v_mov_b32 v32, 0                                   // s[sgprGSUSumIdx+1] = s[sgprLoopCounterL] % s[sgprGSUSumIdx+1]
s_mov_b32 exec_lo, -1                              // Reset exec
v_cmp_gt_u32 vcc_lo, v32, s[sgprGSUSumIdx+1]       // overflow happened in remainder
s_mov_b32 exec_lo, vcc_lo                          // overflow happened in remainder
s_delay_alu instid0(VALU_DEP_3)
v_sub_nc_u32 v31, v31, 1                           // quotient - 1
v_mul_u32_u24 v32, v31, s[sgprGSUSumIdx+1]         // re-calculate remainder
v_sub_nc_u32 v32, s[sgprLoopCounterL], v32         // re-calculate remainder
s_mov_b32 exec_lo, -1                              // Reset exec
s_delay_alu instid0(VALU_DEP_3)
v_readfirstlane_b32 s[sgprLoopCounterL], v31       // quotient
s_delay_alu instid0(VALU_DEP_2)
v_readfirstlane_b32 s[sgprGSUSumIdx+1], v32        // remainder
s_mul_i32 s17, s[sgprLoopCounterL], s[sgprGSUSumIdx] // quotient*GSUSumIdx
s_add_u32 s16, 1, s[sgprLoopCounterL]              // quotient+1
s_add_u32 s17, s17, s[sgprGSUSumIdx+1]             // quotient*GSUSumIdx+remainder
s_mul_i32 s16, s16, s[sgprGSUSumIdx]               // (quotient+1)*GSUSumIdx
s_cmp_lt_u32 s[sgprGSUSumIdx], s[sgprGSUSumIdx+1]  // gsuSumIdx < numIterPerWgRemainder
s_cselect_b32 s16, s16, s17                        // (quotient+1)*GSUSumIdx if needed
s_mul_hi_u32 s17, s16, 64                          // gsuOffset = DepthU*accumulatedNumOfLoopCounterL
s_mul_i32 s16, s16, 64                             // gsuOffset = DepthU*accumulatedNumOfLoopCounterL
label_GSUC_B_End:
s_add_u32 s18, s18, s16                            // accum GsuOffset term to tilestart
s_addc_u32 s19, s19, s17                           // accum GsuOffset term to tilestart
s_mov_b64 s[sgprShadowLimitB+0:sgprShadowLimitB+0+1], 1 // Init tensor size
s_lshr_b32 s16, s[sgprSizeL], 0x1                  // (size/2)
s_delay_alu instid0(SALU_CYCLE_1)
s_sub_u32 s16, s16, 1                              // (size/2-1)
s_delay_alu instid0(SALU_CYCLE_1)
s_mul_hi_u32 s17, constStrideBL, s16               // stride x (size-1)
s_mul_i32 s16, constStrideBL, s16                  // stride x (size-1)
s_add_u32 s[sgprShadowLimitB+0], s[sgprShadowLimitB+0], s16 // sum tensor size
s_addc_u32 s[sgprShadowLimitB+1], s[sgprShadowLimitB+1], s17 // sum tensor size
s_sub_u32 s16, s[sgprSizeJ], 1                     // (size-1)
s_mul_hi_u32 s17, s[sgprStrideB1J], s16            // stride x (size-1)
s_mul_i32 s16, s[sgprStrideB1J], s16               // stride x (size-1)
s_delay_alu instid0(SALU_CYCLE_1)
s_add_u32 s[sgprShadowLimitB+0], s[sgprShadowLimitB+0], s16 // sum tensor size
s_addc_u32 s[sgprShadowLimitB+1], s[sgprShadowLimitB+1], s17 // sum tensor size
s_sub_u32 s[sgprShadowLimitB+0], s[sgprShadowLimitB+0], s18 // sub tileStart
s_subb_u32 s[sgprShadowLimitB+1], s[sgprShadowLimitB+1], s19 // sub tileStart
                                                   // Set limit to use bytes (bpe is 1, do nothing)
s_add_u32 s[sgprShadowLimitB+0], s[sgprShadowLimitB+0], 16 // extend limit for pre-pad
s_addc_u32 s[sgprShadowLimitB+1], s[sgprShadowLimitB+1], 0 // extend limit for pre-pad
s_delay_alu instid0(SALU_CYCLE_1)
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
s_sub_u32 s[sgprSrdB+0], s[sgprSrdB+0], 16         // pre-pad to make room for possible pointer shift
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
s_delay_alu instid0(SALU_CYCLE_1)
s_lshl_b32 s16, s16, 25
s_and_b32 s[sgprSrdB+1], s[sgprSrdB+1], 33554431
s_delay_alu instid0(SALU_CYCLE_1)
s_or_b32 s[sgprSrdB+1], s[sgprSrdB+1], s16
s_lshr_b32 s[sgprSrdB+2], s[sgprSrdB+2], 7

/* global read addresses: final offsets a */
/* ============================================================= */

/* Global Offset A */
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mul_lo_u32 v31, s[sgprStrideAL], v25             // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetA+0], vcc_lo, v20, v31 // accumulate K lower
s_delay_alu instid0(VALU_DEP_1)
v_add_nc_u32 v[vgprGlobalReadOffsetA+0], 0x10, v[vgprGlobalReadOffsetA+0] // add prepad for pointer shift

/* Global Offset A (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset A */
v_mul_lo_u32 v31, s[sgprStrideAL], v26             // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetA+1], vcc_lo, v20, v31 // accumulate K lower
s_delay_alu instid0(VALU_DEP_1)
v_add_nc_u32 v[vgprGlobalReadOffsetA+1], 0x10, v[vgprGlobalReadOffsetA+1] // add prepad for pointer shift

/* Global Offset A (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset A */
v_mul_lo_u32 v31, s[sgprStrideAL], v27             // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetA+2], vcc_lo, v20, v31 // accumulate K lower
s_delay_alu instid0(VALU_DEP_1)
v_add_nc_u32 v[vgprGlobalReadOffsetA+2], 0x10, v[vgprGlobalReadOffsetA+2] // add prepad for pointer shift

/* Global Offset A (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset A */
v_mul_lo_u32 v31, s[sgprStrideAL], v28             // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetA+3], vcc_lo, v20, v31 // accumulate K lower
s_delay_alu instid0(VALU_DEP_1)
v_add_nc_u32 v[vgprGlobalReadOffsetA+3], 0x10, v[vgprGlobalReadOffsetA+3] // add prepad for pointer shift

/* Global Offset A (end) */
                                                   //  (bpe is 1, do nothing)
/* ============================================================= */

/* global read addresses: final offsets metadata */
/* ============================================================= */

/* Global Offset Metadata */
v_mul_lo_u32 v25, s[sgprStrideMetadata1J], v21     // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetMetadata+0], vcc_lo, v29, v25 // accumulate K lower
s_delay_alu instid0(VALU_DEP_1)
v_add_nc_u32 v[vgprGlobalReadOffsetMetadata+0], 0x8, v[vgprGlobalReadOffsetMetadata+0] // add prepad for pointer shift

/* Global Offset Metadata (end) */
                                                   //  (bpe is 1, do nothing)
/* ============================================================= */

/* global read addresses: final offsets b */
/* ============================================================= */

/* Global Offset B */
v_mul_lo_u32 v20, s[sgprStrideB1J], v23            // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetB+0], vcc_lo, v30, v20 // accumulate K lower
s_delay_alu instid0(VALU_DEP_1)
v_add_nc_u32 v[vgprGlobalReadOffsetB+0], 0x10, v[vgprGlobalReadOffsetB+0] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)

/* Global Offset B */
v_mul_lo_u32 v20, s[sgprStrideB1J], v24            // mul d1 lower
v_add_co_u32 v[vgprGlobalReadOffsetB+1], vcc_lo, v30, v20 // accumulate K lower
s_delay_alu instid0(VALU_DEP_1)
v_add_nc_u32 v[vgprGlobalReadOffsetB+1], 0x10, v[vgprGlobalReadOffsetB+1] // add prepad for pointer shift

/* Global Offset B (end) */
                                                   //  (bpe is 1, do nothing)
/* ============================================================= */

/* global read addresses: increments a */
s_and_b32 s17, s[sgprGSU], 0x3fff                  // Restore GSU
s_mov_b32 s[sgprGlobalReadIncsA+0], 128            // GSU*DepthU*Bpe*MI_dim(1)
s_delay_alu instid0(SALU_CYCLE_1)
s_mul_i32 s17, s17, s[sgprGlobalReadIncsA+0]       // GSU*DepthU*Bpe*MI_dim(1)
s_and_b32 s16, s[sgprGSU], 0x8000                  // SCC = (GSUC == 1) ?
s_cmov_b32 s17, 128                                // DepthU*Bpe if GSUC = 1
s_mul_i32 s[sgprGlobalReadIncsA+0], s17, s[sgprStrideAL] // incrA unrollIdx)

/* global read addresses: increments metadata */
s_and_b32 s17, s[sgprGSU], 0x3fff                  // Restore GSU
s_mov_b32 s[sgprGlobalReadIncsMetadata+0], 16      // GSU*DepthU*Bpe*MI_dim(1)
s_delay_alu instid0(SALU_CYCLE_1)
s_mul_i32 s17, s17, s[sgprGlobalReadIncsMetadata+0] // GSU*DepthU*Bpe*MI_dim(1)
s_and_b32 s16, s[sgprGSU], 0x8000                  // SCC = (GSUC == 1) ?
s_cselect_b32 s[sgprGlobalReadIncsMetadata+0], s[sgprGlobalReadIncsMetadata+0], s17 // incrMetadata (unrollIdx)

/* global read addresses: increments b */
s_and_b32 s17, s[sgprGSU], 0x3fff                  // Restore GSU
s_mov_b32 s[sgprGlobalReadIncsB+0], 64             // GSU*DepthU*Bpe*MI_dim(1)
s_delay_alu instid0(SALU_CYCLE_1)
s_mul_i32 s17, s17, s[sgprGlobalReadIncsB+0]       // GSU*DepthU*Bpe*MI_dim(1)
s_and_b32 s16, s[sgprGSU], 0x8000                  // SCC = (GSUC == 1) ?
s_cselect_b32 s[sgprGlobalReadIncsB+0], s[sgprGlobalReadIncsB+0], s17 // incrB (unrollIdx)
/* declare loop num iterations */
s_lshr_b32 s[sgprLoopCounterL], s[sgprSizesSum+0], 7 // s[sgprLoopCounterL] = s[sgprSizesSum+0] / 128
s_and_b32 s16, s[sgprGSU], 0x3fff                  // Restore GSU
s_delay_alu instid0(SALU_CYCLE_1)
s_cmp_eq_u32 s16, 1                                // GSU == 1 ?
s_cbranch_scc1 label_GSU_1                         // branch if GSU == 1
s_and_b32 s[sgprGSUSumIdx+1], s[sgprGSU], 0x3fff   // Restore GSU
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cvt_f32_u32 v0, s[sgprGSUSumIdx+1]               // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
s_delay_alu instid0(VALU_DEP_1)
v_rcp_iflag_f32 v0, v0                             // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
v_cvt_f32_u32 v1, s[sgprLoopCounterL]              // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
s_delay_alu instid0(VALU_DEP_1)
v_mul_f32 v0, v0, v1                               // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
s_delay_alu instid0(VALU_DEP_1)
v_cvt_u32_f32 v0, v0                               // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
v_mul_u32_u24 v1, v0, s[sgprGSUSumIdx+1]           // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
v_sub_nc_u32 v1, s[sgprLoopCounterL], v1           // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
v_cmp_eq_u32 vcc_lo, v1, s[sgprGSUSumIdx+1]        // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
s_mov_b32 exec_lo, vcc_lo                          // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
s_delay_alu instid0(VALU_DEP_4)
v_add_nc_u32 v0, 1, v0                             // s[sgprLoopCounterL] = s[sgprLoopCounterL] / s[sgprGSUSumIdx+1]
v_mov_b32 v1, 0                                    // s[sgprGSUSumIdx+1] = s[sgprLoopCounterL] % s[sgprGSUSumIdx+1]
s_mov_b32 exec_lo, -1                              // Reset exec
v_cmp_gt_u32 vcc_lo, v1, s[sgprGSUSumIdx+1]        // overflow happened in remainder
s_mov_b32 exec_lo, vcc_lo                          // overflow happened in remainder
s_delay_alu instid0(VALU_DEP_3)
v_sub_nc_u32 v0, v0, 1                             // quotient - 1
v_mul_u32_u24 v1, v0, s[sgprGSUSumIdx+1]           // re-calculate remainder
v_sub_nc_u32 v1, s[sgprLoopCounterL], v1           // re-calculate remainder
s_mov_b32 exec_lo, -1                              // Reset exec
s_delay_alu instid0(VALU_DEP_3)
v_readfirstlane_b32 s[sgprLoopCounterL], v0        // quotient
s_delay_alu instid0(VALU_DEP_2)
v_readfirstlane_b32 s[sgprGSUSumIdx+1], v1         // remainder
s_add_u32 s16, 1, s[sgprLoopCounterL]              // tmp<-numIterMyWg+1
s_cmp_lt_u32 s[sgprGSUSumIdx], s[sgprGSUSumIdx+1]  // gsuSumIdx < numIterPerWgRemainder
s_cmov_b32 s[sgprLoopCounterL], s16                // numIterMyWg++ if needed
label_GSU_1:
s_mov_b32 s[sgprOrigLoopCounter], s[sgprLoopCounterL] // copy loop counter
s_and_b32 s18, s[sgprStaggerU], 0x1f00
s_delay_alu instid0(SALU_CYCLE_1)
s_lshr_b32 s18, s18, 0x8
s_and_b32 s19, s[sgprStaggerU], 0xe000
s_and_b32 s[sgprStaggerU], s[sgprStaggerU], 0xff
s_delay_alu instid0(SALU_CYCLE_1)
s_mov_b32 s16, s[sgprStaggerU]                     // init staggerU
label_beginStaggerUIter:
s_delay_alu instid0(SALU_CYCLE_1)
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
s_delay_alu instid0(SALU_CYCLE_1)
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
s_delay_alu instid0(SALU_CYCLE_1)
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
s_delay_alu instid0(SALU_CYCLE_1)
s_cmp_eq_u32 s[sgprShadowLimitA+1], 0              // are we within 2^32?
s_cselect_b32 s[sgprSrdA+2], s[sgprShadowLimitA+0], BufferLimit // Move shadow to real if we are within 2^32
// Shift num records for gfx125x
s_and_b32 s19, s[sgprSrdA+2], 127
s_delay_alu instid0(SALU_CYCLE_1)
s_lshl_b32 s19, s19, 25
s_and_b32 s[sgprSrdA+1], s[sgprSrdA+1], 33554431
s_delay_alu instid0(SALU_CYCLE_1)
s_or_b32 s[sgprSrdA+1], s[sgprSrdA+1], s19
s_lshr_b32 s[sgprSrdA+2], s[sgprSrdA+2], 7

/* addr += (StaggerUIter) * GlobalReadIncsMetadata+0 */
s_mul_hi_i32 s17, s[sgprStaggerUIter], s[sgprGlobalReadIncsMetadata+0] //  stagger byte offset
s_mul_i32 s16, s[sgprStaggerUIter], s[sgprGlobalReadIncsMetadata+0] //  stagger byte offset
s_mul_hi_i32 s[sgprWrapUMetadata+1], s[sgprLoopCounterL], s[sgprGlobalReadIncsMetadata+0] // Number of bytes accessed by the unroll loop
s_mul_i32 s[sgprWrapUMetadata+0], s[sgprLoopCounterL], s[sgprGlobalReadIncsMetadata+0] // Number of bytes accessed by the unroll loop
s_mov_b32 s20, s[sgprGlobalReadIncsMetadata+0]
s_mov_b32 s21, 0
s_sub_u64 s[sgprWrapUMetadata:sgprWrapUMetadata+1], s[20:21], s[sgprWrapUMetadata:sgprWrapUMetadata+1] // increment-WrapU
s_add_u32 s[sgprSrdMetadata+0], s[sgprSrdMetadata+0], s16 // gra SRD += inc(lower)
s_addc_u32 s[sgprSrdMetadata+1], s[sgprSrdMetadata+1], s17 // gra SRD += inc(upper)
s_sub_u32 s[sgprShadowLimitMetadata+0], s[sgprShadowLimitMetadata+0], s16 // limit -= inc)
s_subb_u32 s[sgprShadowLimitMetadata+1], s[sgprShadowLimitMetadata+1], s17 // limit -= inc)
s_delay_alu instid0(SALU_CYCLE_1)
s_cmp_eq_u32 s[sgprShadowLimitMetadata+1], 0       // are we within 2^32?
s_cselect_b32 s[sgprSrdMetadata+2], s[sgprShadowLimitMetadata+0], BufferLimit // Move shadow to real if we are within 2^32
// Shift num records for gfx125x
s_and_b32 s19, s[sgprSrdMetadata+2], 127
s_delay_alu instid0(SALU_CYCLE_1)
s_lshl_b32 s19, s19, 25
s_and_b32 s[sgprSrdMetadata+1], s[sgprSrdMetadata+1], 33554431
s_delay_alu instid0(SALU_CYCLE_1)
s_or_b32 s[sgprSrdMetadata+1], s[sgprSrdMetadata+1], s19
s_lshr_b32 s[sgprSrdMetadata+2], s[sgprSrdMetadata+2], 7

/* addr += (StaggerUIter) * GlobalReadIncsB+0 */
s_mul_hi_i32 s17, s[sgprStaggerUIter], s[sgprGlobalReadIncsB+0] //  stagger byte offset
s_mul_i32 s16, s[sgprStaggerUIter], s[sgprGlobalReadIncsB+0] //  stagger byte offset
s_mul_hi_i32 s[sgprWrapUB+1], s[sgprLoopCounterL], s[sgprGlobalReadIncsB+0] // Number of bytes accessed by the unroll loop
s_mul_i32 s[sgprWrapUB+0], s[sgprLoopCounterL], s[sgprGlobalReadIncsB+0] // Number of bytes accessed by the unroll loop
s_mov_b32 s20, s[sgprGlobalReadIncsB+0]
s_mov_b32 s21, 0
s_sub_u64 s[sgprWrapUB:sgprWrapUB+1], s[20:21], s[sgprWrapUB:sgprWrapUB+1] // increment-WrapU
s_add_u32 s[sgprSrdB+0], s[sgprSrdB+0], s16        // gra SRD += inc(lower)
s_addc_u32 s[sgprSrdB+1], s[sgprSrdB+1], s17       // gra SRD += inc(upper)
s_sub_u32 s[sgprShadowLimitB+0], s[sgprShadowLimitB+0], s16 // limit -= inc)
s_subb_u32 s[sgprShadowLimitB+1], s[sgprShadowLimitB+1], s17 // limit -= inc)
s_delay_alu instid0(SALU_CYCLE_1)
s_cmp_eq_u32 s[sgprShadowLimitB+1], 0              // are we within 2^32?
s_cselect_b32 s[sgprSrdB+2], s[sgprShadowLimitB+0], BufferLimit // Move shadow to real if we are within 2^32
// Shift num records for gfx125x
s_and_b32 s19, s[sgprSrdB+2], 127
s_delay_alu instid0(SALU_CYCLE_1)
s_lshl_b32 s19, s19, 25
s_and_b32 s[sgprSrdB+1], s[sgprSrdB+1], 33554431
s_delay_alu instid0(SALU_CYCLE_1)
s_or_b32 s[sgprSrdB+1], s[sgprSrdB+1], s19
s_lshr_b32 s[sgprSrdB+2], s[sgprSrdB+2], 7
s_add_u32 s[sgprStaggerUIter], s[sgprStaggerUIter], 2 // Subtract (PGR-1); StaggerUIter now contains target iteration to wrap
/* local read addresses: init pointers a */

/* localReadInitPointers */
/* local read addresses: init pointers metadata */

/* localReadInitPointers */
/* local read addresses: init pointers b */

/* localReadInitPointers */

/* prefetch: global -> local */
s_cmp_eq_u32 s[sgprLoopCounterL], 0                // at last iteration?
s_cbranch_scc1 label_ShadowInitStart               // skip to ShadowInitStart iter b/c numIter==0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
buffer_load_b128 v[vgprG2LA+0:vgprG2LA+0+3], v[vgprGlobalReadOffsetA+0], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_0_0
buffer_load_b128 v[vgprG2LA+4:vgprG2LA+4+3], v[vgprGlobalReadOffsetA+1], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_1_0
buffer_load_b128 v[vgprG2LA+8:vgprG2LA+8+3], v[vgprGlobalReadOffsetA+2], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_2_0
buffer_load_b128 v[vgprG2LA+12:vgprG2LA+12+3], v[vgprGlobalReadOffsetA+3], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_3_0
buffer_load_b128 v[vgprG2LB+0:vgprG2LB+0+3], v[vgprGlobalReadOffsetB+0], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_0_0
buffer_load_b128 v[vgprG2LB+4:vgprG2LB+4+3], v[vgprGlobalReadOffsetB+1], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_1_0
buffer_load_b64 v[vgprG2LMetadata+0:vgprG2LMetadata+0+1], v[vgprGlobalReadOffsetMetadata+0], s[sgprSrdMetadata:sgprSrdMetadata+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_0_0

/* global read inc A loopL */
s_add_u32 s18, s[sgprLoopCounterL], 1              // remove pf(1)
s_cmp_eq_u32 s[sgprStaggerUIter], s18              // Is this wrapIter? (pf)
s_cselect_b32 s16, s[sgprWrapUA+0], s[sgprGlobalReadIncsA+0] // incLower <- ?
s_cselect_b32 s17, s[sgprWrapUA+1], 0              // incUpper <- ?
s_add_u32 s[sgprSrdA+0], s[sgprSrdA+0], s16        // gra SRD += inc(lower)
s_addc_u32 s[sgprSrdA+1], s[sgprSrdA+1], s17       // gra SRD += inc(upper)
s_sub_u32 s[sgprShadowLimitA+0], s[sgprShadowLimitA+0], s16 // limit -= inc)
s_subb_u32 s[sgprShadowLimitA+1], s[sgprShadowLimitA+1], s17 // limit -= inc)
s_delay_alu instid0(SALU_CYCLE_1)
s_cmp_eq_u32 s[sgprShadowLimitA+1], 0              // are we within 2^32?
s_cselect_b32 s[sgprSrdA+2], s[sgprShadowLimitA+0], BufferLimit // Move shadow to real if we are within 2^32
// Shift num records for gfx125x
s_delay_alu instid0(SALU_CYCLE_1)
s_and_b32 s20, s[sgprSrdA+2], 127
s_delay_alu instid0(SALU_CYCLE_1)
s_lshl_b32 s20, s20, 25
s_and_b32 s[sgprSrdA+1], s[sgprSrdA+1], 33554431
s_delay_alu instid0(SALU_CYCLE_1)
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
s_delay_alu instid0(SALU_CYCLE_1)
s_cmp_eq_u32 s[sgprShadowLimitB+1], 0              // are we within 2^32?
s_cselect_b32 s[sgprSrdB+2], s[sgprShadowLimitB+0], BufferLimit // Move shadow to real if we are within 2^32
// Shift num records for gfx125x
s_delay_alu instid0(SALU_CYCLE_1)
s_and_b32 s20, s[sgprSrdB+2], 127
s_delay_alu instid0(SALU_CYCLE_1)
s_lshl_b32 s20, s20, 25
s_and_b32 s[sgprSrdB+1], s[sgprSrdB+1], 33554431
s_delay_alu instid0(SALU_CYCLE_1)
s_or_b32 s[sgprSrdB+1], s[sgprSrdB+1], s20
s_lshr_b32 s[sgprSrdB+2], s[sgprSrdB+2], 7
s_cmp_eq_u32 s[sgprStaggerUIter], s18              // Is this wrapIter? (pf)
s_cselect_b32 s16, s[sgprWrapUMetadata+0], s[sgprGlobalReadIncsMetadata+0] // incLower <- ?
s_cselect_b32 s17, s[sgprWrapUMetadata+1], 0       // incUpper <- ?
s_add_u32 s[sgprSrdMetadata+0], s[sgprSrdMetadata+0], s16 // gra SRD += inc(lower)
s_addc_u32 s[sgprSrdMetadata+1], s[sgprSrdMetadata+1], s17 // gra SRD += inc(upper)
s_sub_u32 s[sgprShadowLimitMetadata+0], s[sgprShadowLimitMetadata+0], s16 // limit -= inc)
s_subb_u32 s[sgprShadowLimitMetadata+1], s[sgprShadowLimitMetadata+1], s17 // limit -= inc)
s_delay_alu instid0(SALU_CYCLE_1)
s_cmp_eq_u32 s[sgprShadowLimitMetadata+1], 0       // are we within 2^32?
s_cselect_b32 s[sgprSrdMetadata+2], s[sgprShadowLimitMetadata+0], BufferLimit // Move shadow to real if we are within 2^32
// Shift num records for gfx125x
s_delay_alu instid0(SALU_CYCLE_1)
s_and_b32 s20, s[sgprSrdMetadata+2], 127
s_delay_alu instid0(SALU_CYCLE_1)
s_lshl_b32 s20, s20, 25
s_and_b32 s[sgprSrdMetadata+1], s[sgprSrdMetadata+1], 33554431
s_delay_alu instid0(SALU_CYCLE_1)
s_or_b32 s[sgprSrdMetadata+1], s[sgprSrdMetadata+1], s20
s_lshr_b32 s[sgprSrdMetadata+2], s[sgprSrdMetadata+2], 7

/******************************************/
/* End setupNewTile                       */
/******************************************/
label_ShadowInitStart:
s_and_b32 s79, s[sgprGSU], 0x3fff                  // Restore GSU
s_delay_alu instid0(SALU_CYCLE_1)
s_cmp_eq_u32 s79, 1                                // GSU == 1 ?
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
s_and_b32 s79, s[sgprSrdD+2], 127
s_delay_alu instid0(SALU_CYCLE_1)
s_lshl_b32 s79, s79, 25
s_and_b32 s[sgprSrdD+1], s[sgprSrdD+1], 33554431
s_delay_alu instid0(SALU_CYCLE_1)
s_or_b32 s[sgprSrdD+1], s[sgprSrdD+1], s79
s_lshr_b32 s[sgprSrdD+2], s[sgprSrdD+2], 7

s_and_b32 s79, s[sgprGSU], 0x3fff                  // Restore GSU
s_delay_alu instid0(SALU_CYCLE_1)
s_cmp_eq_u32 s79, 1                                // GSU == 1 ?
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
s_and_b32 s79, s[sgprSrdC+2], 127
s_delay_alu instid0(SALU_CYCLE_1)
s_lshl_b32 s79, s79, 25
s_and_b32 s[sgprSrdC+1], s[sgprSrdC+1], 33554431
s_delay_alu instid0(SALU_CYCLE_1)
s_or_b32 s[sgprSrdC+1], s[sgprSrdC+1], s79
s_lshr_b32 s[sgprSrdC+2], s[sgprSrdC+2], 7


s_mul_i32 s82, MT1, s[sgprWorkGroup1]              // <- wg1*MT1
s_and_b32 s81, s[sgprGSU], 0x3fff                  // Restore GSU
s_mul_hi_u32 s81, s82, s[sgprStrideC1J]            // ScaleC s82 by Stride
s_mul_i32 s80, s82, s[sgprStrideC1J]               // ScaleC s82 by Stride
s_lshl_b64 s[80:81], s[80:81], s[sgprGSULog2BpeC]  // scale by bpe
s_add_u32 s[sgprSrdC+0], s[sgprSrdC+0], s80        // add lo to SRD
s_addc_u32 s[sgprSrdC+1], s[sgprSrdC+1], s81       // add hi to SRD
s_and_b32 s81, s[sgprGSU], 0x3fff                  // Restore GSU
s_mul_hi_u32 s81, s82, s[sgprStrideD1J]            // ScaleD s82 by Stride
s_mul_i32 s80, s82, s[sgprStrideD1J]               // ScaleD s82 by Stride
s_lshl_b64 s[80:81], s[80:81], s[sgprGSULog2BpeD]  // scale by bpe
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s80        // add lo to SRD
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], s81       // add hi to SRD

s_and_b32 s81, s[sgprGSU], 0x3fff                  // Restore GSU
s_cmp_eq_u32 s81, 1                                // GSU == 1 ?
s_cbranch_scc0 label_StridedBatchedGemmLoadC
s_cmp_eq_u32 s[sgprArgType], 3                     // ArgType == 3 for General Batched GEMM
s_cbranch_scc1 label_GeneralBatchedGemmLoadC
label_StridedBatchedGemmLoadC:  /// Computing the Batch Matrix's base address for Strided Batched GEMM
s_mul_hi_u32 s81, s[sgprWorkGroup2], s[sgprStrideCK] // ScaleC s[sgprWorkGroup2] by Stride
s_mul_i32 s80, s[sgprWorkGroup2], s[sgprStrideCK]  // ScaleC s[sgprWorkGroup2] by Stride
s_lshl_b64 s[80:81], s[80:81], s[sgprGSULog2BpeC]  // scale by bpe
s_add_u32 s[sgprSrdC+0], s[sgprSrdC+0], s80        // add lo to SRD
s_addc_u32 s[sgprSrdC+1], s[sgprSrdC+1], s81       // add hi to SRD
s_branch label_GeneralBatchedGemmLoadC_End
label_GeneralBatchedGemmLoadC:  /// Computing the Batch Matrix's base address for General Batched GEMM
s_mul_i32 s80, 8, s[sgprWorkGroup2]                // Compute stride in bytes into Pointer Array
s_add_u32 s80, s80, s[sgprAddressC+0]              // Offsetting to the location [Lower half of address]
s_addc_u32 s81, s[sgprAddressC+1], 0               // Offsetting to the location [Higher half of address]
s_load_b64 s[82:83], s[80:81], 0                   // Load the Matrix Address in the Pointer Array
s_wait_kmcnt 0                                     // Wait for the Matrix Address Load from the Pointer Array
s_add_u32 s[sgprSrdC+0], s[sgprSrdC+0], s82        // Offsetting within the Batch Matrix [Lower half of address]
s_addc_u32 s[sgprSrdC+1], s[sgprSrdC+1], s83       // Offsetting within the Batch Matrix [Higher half of address]
label_GeneralBatchedGemmLoadC_End:  /// End of label GeneralBatchedGemmLoadC
s_and_b32 s81, s[sgprGSU], 0x3fff                  // Restore GSU
s_cmp_eq_u32 s81, 1                                // GSU == 1 ?
s_cbranch_scc0 label_StridedBatchedGemmLoadD
s_cmp_eq_u32 s[sgprArgType], 3                     // ArgType == 3 for General Batched GEMM
s_cbranch_scc1 label_GeneralBatchedGemmLoadD
label_StridedBatchedGemmLoadD:  /// Computing the Batch Matrix's base address for Strided Batched GEMM
s_mul_hi_u32 s81, s[sgprWorkGroup2], s[sgprStrideDK] // ScaleD s[sgprWorkGroup2] by Stride
s_mul_i32 s80, s[sgprWorkGroup2], s[sgprStrideDK]  // ScaleD s[sgprWorkGroup2] by Stride
s_lshl_b64 s[80:81], s[80:81], s[sgprGSULog2BpeD]  // scale by bpe
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s80        // add lo to SRD
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], s81       // add hi to SRD
s_branch label_GeneralBatchedGemmLoadD_End
label_GeneralBatchedGemmLoadD:  /// Computing the Batch Matrix's base address for General Batched GEMM
s_mul_i32 s80, 8, s[sgprWorkGroup2]                // Compute stride in bytes into Pointer Array
s_add_u32 s80, s80, s[sgprAddressD+0]              // Offsetting to the location [Lower half of address]
s_addc_u32 s81, s[sgprAddressD+1], 0               // Offsetting to the location [Higher half of address]
s_load_b64 s[82:83], s[80:81], 0                   // Load the Matrix Address in the Pointer Array
s_wait_kmcnt 0                                     // Wait for the Matrix Address Load from the Pointer Array
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s82        // Offsetting within the Batch Matrix [Lower half of address]
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], s83       // Offsetting within the Batch Matrix [Higher half of address]
label_GeneralBatchedGemmLoadD_End:  /// End of label GeneralBatchedGemmLoadD

s_and_b32 s79, s[sgprGSU], 0x3fff                  // Restore GSU
s_delay_alu instid0(SALU_CYCLE_1)
s_cmp_eq_u32 s79, 1                                // GSU == 1 ?
s_cbranch_scc1 label_GSU_2                         // branch if GSU == 1
// GSU Output Buffer offset: Free0 + (Free1-1)*StrideC1J + (Free2-1)*StrideCK * GSUIdx * bpe%s
s_mul_hi_u32 s81, s[sgprSizesFree+0], s[sgprGSUSumIdx] // Free0
s_mul_i32 s80, s[sgprSizesFree+0], s[sgprGSUSumIdx] // Free0
s_sub_u32 s79, s[sgprSizesFree+1], 1               // Free1
s_mul_i32 s79, s79, s[sgprGSUSumIdx]               // Free1
s_mul_hi_u32 s82, s79, s[sgprStrideC1J]            // Free1
s_mul_i32 s79, s79, s[sgprStrideC1J]               // Free1
s_delay_alu instid0(SALU_CYCLE_1)
s_add_u32 s80, s80, s79                            // Free1
s_addc_u32 s81, s81, s82                           // Free1
s_sub_u32 s79, s[sgprSizesFree+2], 1               // Free2
s_mul_i32 s79, s79, s[sgprGSUSumIdx]               // Free2
s_mul_hi_u32 s82, s79, s[sgprStrideCK]             // Free2
s_mul_i32 s79, s79, s[sgprStrideCK]                // Free2
s_delay_alu instid0(SALU_CYCLE_1)
s_add_u32 s80, s80, s79                            // Free2
s_addc_u32 s81, s81, s82                           // Free2
s_lshl_b64 s[80:81], s[80:81], 2                   // scale by bpe
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s80        // add lo GSU offset to SRD
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], s81       // add hi GSU offset to SRD
label_GSU_2:
.set sgprGSULog2BpeC, UNDEF
.set sgprAddressC, UNDEF

/* initC: remove ValuC vgpr buffer [0...8) from pool */

/* initC: remove acc vgpr buffer [0...0) from pool */

/* initC: remove ValuA/B vgpr buffer [20...100) from pool */
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v[vgprValuC+0], 0                        // initC
v_mov_b32 v[vgprValuC+1], 0                        // initC
v_mov_b32 v[vgprValuC+2], 0                        // initC
v_mov_b32 v[vgprValuC+3], 0                        // initC
v_mov_b32 v[vgprValuC+4], 0                        // initC
v_mov_b32 v[vgprValuC+5], 0                        // initC
v_mov_b32 v[vgprValuC+6], 0                        // initC
v_mov_b32 v[vgprValuC+7], 0                        // initC
s_cmp_eq_u32 s[sgprLoopCounterL], 0                // at last iteration?

/* after InitC, skip to end of prefetch last iter if numIter==0 */

/* label_PrefetchGlobalLastIterEnd */
s_cbranch_scc0 label_NoBranch_T8JHFHKM7BO5OHXW     // Only branch on scc1
s_getpc_b64 s[80:81]                               // addr of next instr
s_add_i32 s82, label_PrefetchGlobalLastIterEnd, 4  // target branch offset
s_add_u32 s80, s80, s82                            // add target branch offset
s_addc_u32 s81, s81, 0                             // add high and carry
s_setpc_b64 s[80:81]                               // branch to label_PrefetchGlobalLastIterEnd
label_NoBranch_T8JHFHKM7BO5OHXW:
s_wait_loadcnt 0                                   // wait for global read

/* local write a */
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
ds_store_b128 v[vgprLocalWriteAddrA+0], v[vgprG2LA+0:vgprG2LA+0+3] offset:0 // lwoA_0_0_0_0 = (0*LSCA) + (0*LSPA)(*MT0I+PAD) = 0 sync LDS0
ds_store_b128 v[vgprLocalWriteAddrA+0], v[vgprG2LA+4:vgprG2LA+4+3] offset:544 // lwoA_0_0_1_0 = (0*LSCA) + (1*LSPA)(*MT0I+PAD) = 544 sync LDS0
ds_store_b128 v[vgprLocalWriteAddrA+0], v[vgprG2LA+8:vgprG2LA+8+3] offset:1088 // lwoA_0_0_2_0 = (0*LSCA) + (2*LSPA)(*MT0I+PAD) = 1088 sync LDS0
ds_store_b128 v[vgprLocalWriteAddrA+0], v[vgprG2LA+12:vgprG2LA+12+3] offset:1632 // lwoA_0_0_3_0 = (0*LSCA) + (3*LSPA)(*MT0I+PAD) = 1632 sync LDS0

/* local write b */
ds_store_b128 v[vgprLocalWriteAddrB+0], v[vgprG2LB+0:vgprG2LB+0+3] offset:0 // lwoB_0_0_0_0 = (0*LSCB)*(MT1J+PAD) + (0*LSPB) = 0 sync LDS0
ds_store_b128 v[vgprLocalWriteAddrB+0], v[vgprG2LB+4:vgprG2LB+4+3] offset:544 // lwoB_0_0_1_0 = (0*LSCB)*(MT1J+PAD) + (1*LSPB) = 544 sync LDS0
ds_store_b64 v[vgprLocalWriteAddrMetadata+0], v[vgprG2LMetadata+0:vgprG2LMetadata+0+1] offset:0 // lwoMetadata_0_0_0_0 = (0*LSCMetadata)*(MT1J+PAD) + (0*LSPMetadata) = 0 sync LDS0

/* local write swap a */

/* (EPS=1) local write swap internal offset -> 4096 */

/* local write swap b */

/* (EPS=1) local write swap internal offset -> 4096 */

/* (EPS=1) local write swap internal offset -> 4096 */
s_cmp_eq_u32 s[sgprLoopCounterL], 0x1              // PGR=2 but only 1 loop
s_cbranch_scc1 label_skipPGR2_1                    // PGR=2 but only 1 loop
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
buffer_load_b128 v[vgprG2LA+0:vgprG2LA+0+3], v[vgprGlobalReadOffsetA+0], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_0_0
buffer_load_b128 v[vgprG2LA+4:vgprG2LA+4+3], v[vgprGlobalReadOffsetA+1], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_1_0
buffer_load_b128 v[vgprG2LA+8:vgprG2LA+8+3], v[vgprGlobalReadOffsetA+2], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_2_0
buffer_load_b128 v[vgprG2LA+12:vgprG2LA+12+3], v[vgprGlobalReadOffsetA+3], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_3_0
buffer_load_b128 v[vgprG2LB+0:vgprG2LB+0+3], v[vgprGlobalReadOffsetB+0], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_0_0
buffer_load_b128 v[vgprG2LB+4:vgprG2LB+4+3], v[vgprGlobalReadOffsetB+1], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_1_0
buffer_load_b64 v[vgprG2LMetadata+0:vgprG2LMetadata+0+1], v[vgprGlobalReadOffsetMetadata+0], s[sgprSrdMetadata:sgprSrdMetadata+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_0_0
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
s_cbranch_scc1 label_LoopEndL_evenexit             // do not enter LoopL
.align 16
label_LoopBeginL:

/******************************************/
/* Unrolled Loop 1/2 - Begin              */
/******************************************/
s_wait_dscnt 0                                     // 1wait for local write <This is 1-cycle>
// Skip barrier: NumThreads=324sync for global read, PGR->LW needs sync

/* Begin Each Unroll: Check VGPR.checkin for INT8 LW */

/* iter 0 (reset local read pointers iteration)  (swap and reset local write pointers iteration)  (swap local read pointers iteration)  */
/*  grEndMfmaIndex:0, lwStartMfmaIndex:0, lwEndMfmaIndex:0  */
/*  numMfmaForLR:0, syncPlrMfmaIndex:0  */
/*  mfmaIndex:0  */
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0 <This is 2-cycle>
ds_load_u8 v[vgprValuA_X0_I0+0], v[vgprLocalReadAddrA+0] offset:0 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 3-cycle>
ds_load_u8 v[vgprValuA_X0_I0_D1+0], v[vgprLocalReadAddrA+0] offset:16 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 5-cycle>
ds_load_u8 v[vgprValuA_X0_I0_D2+0], v[vgprLocalReadAddrA+0] offset:32 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=2 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 7-cycle>
ds_load_u8 v[vgprValuA_X0_I0_D3+0], v[vgprLocalReadAddrA+0] offset:48 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=3 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 9-cycle>
ds_load_u8 v[vgprValuA_X0_I0+1], v[vgprLocalReadAddrA+0] offset:64 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=4 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 11-cycle>
ds_load_u8 v[vgprValuA_X0_I0_D1+1], v[vgprLocalReadAddrA+0] offset:80 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=5 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 13-cycle>
ds_load_u8 v[vgprValuA_X0_I0_D2+1], v[vgprLocalReadAddrA+0] offset:96 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=6 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 15-cycle>
ds_load_u8 v[vgprValuA_X0_I0_D3+1], v[vgprLocalReadAddrA+0] offset:112 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=7 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 17-cycle>
ds_load_u8 v[vgprValuA_X0_I0+2], v[vgprLocalReadAddrA+0] offset:128 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=8 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 19-cycle>
ds_load_u8 v[vgprValuA_X0_I0_D1+2], v[vgprLocalReadAddrA+0] offset:144 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=9 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 21-cycle>
ds_load_u8 v[vgprValuA_X0_I0_D2+2], v[vgprLocalReadAddrA+0] offset:160 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=10 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 23-cycle>
ds_load_u8 v[vgprValuA_X0_I0_D3+2], v[vgprLocalReadAddrA+0] offset:176 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=11 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 25-cycle>
ds_load_u8 v[vgprValuA_X0_I0+3], v[vgprLocalReadAddrA+0] offset:192 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=12 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 27-cycle>
ds_load_u8 v[vgprValuA_X0_I0_D1+3], v[vgprLocalReadAddrA+0] offset:208 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=13 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 29-cycle>
ds_load_u8 v[vgprValuA_X0_I0_D2+3], v[vgprLocalReadAddrA+0] offset:224 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=14 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 31-cycle>
ds_load_u8 v[vgprValuA_X0_I0_D3+3], v[vgprLocalReadAddrA+0] offset:240 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=15 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 33-cycle>
ds_load_u8 v[vgprValuA_X0_I0+4], v[vgprLocalReadAddrA+0] offset:272 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=16 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 35-cycle>
ds_load_u8 v[vgprValuA_X0_I0_D1+4], v[vgprLocalReadAddrA+0] offset:288 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=17 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 37-cycle>
ds_load_u8 v[vgprValuA_X0_I0_D2+4], v[vgprLocalReadAddrA+0] offset:304 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=18 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 39-cycle>
ds_load_u8 v[vgprValuA_X0_I0_D3+4], v[vgprLocalReadAddrA+0] offset:320 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=19 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 41-cycle>
ds_load_u8 v[vgprValuA_X0_I0+5], v[vgprLocalReadAddrA+0] offset:336 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=20 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 43-cycle>
ds_load_u8 v[vgprValuA_X0_I0_D1+5], v[vgprLocalReadAddrA+0] offset:352 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=21 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 45-cycle>
ds_load_u8 v[vgprValuA_X0_I0_D2+5], v[vgprLocalReadAddrA+0] offset:368 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=22 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 47-cycle>
ds_load_u8 v[vgprValuA_X0_I0_D3+5], v[vgprLocalReadAddrA+0] offset:384 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=23 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 49-cycle>
ds_load_u8 v[vgprValuA_X0_I0+6], v[vgprLocalReadAddrA+0] offset:400 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=24 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 51-cycle>
ds_load_u8 v[vgprValuA_X0_I0_D1+6], v[vgprLocalReadAddrA+0] offset:416 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=25 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 53-cycle>
ds_load_u8 v[vgprValuA_X0_I0_D2+6], v[vgprLocalReadAddrA+0] offset:432 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=26 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 55-cycle>
ds_load_u8 v[vgprValuA_X0_I0_D3+6], v[vgprLocalReadAddrA+0] offset:448 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=27 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 57-cycle>
ds_load_u8 v[vgprValuA_X0_I0+7], v[vgprLocalReadAddrA+0] offset:464 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=28 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 59-cycle>
ds_load_u8 v[vgprValuA_X0_I0_D1+7], v[vgprLocalReadAddrA+0] offset:480 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=29 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 61-cycle>
ds_load_u8 v[vgprValuA_X0_I0_D2+7], v[vgprLocalReadAddrA+0] offset:496 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=30 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 63-cycle>
ds_load_u8 v[vgprValuA_X0_I0_D3+7], v[vgprLocalReadAddrA+0] offset:512 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=31 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 65-cycle>
ds_load_u8 v[vgprValuA_X0_I0+8], v[vgprLocalReadAddrA+0] offset:1088 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=32 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 67-cycle>
ds_load_u8 v[vgprValuA_X0_I0_D1+8], v[vgprLocalReadAddrA+0] offset:1104 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=33 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 69-cycle>
ds_load_u8 v[vgprValuA_X0_I0_D2+8], v[vgprLocalReadAddrA+0] offset:1120 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=34 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 71-cycle>
ds_load_u8 v[vgprValuA_X0_I0_D3+8], v[vgprLocalReadAddrA+0] offset:1136 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=35 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 73-cycle>
ds_load_u8 v[vgprValuA_X0_I0+9], v[vgprLocalReadAddrA+0] offset:1152 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=36 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 75-cycle>
ds_load_u8 v[vgprValuA_X0_I0_D1+9], v[vgprLocalReadAddrA+0] offset:1168 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=37 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 77-cycle>
ds_load_u8 v[vgprValuA_X0_I0_D2+9], v[vgprLocalReadAddrA+0] offset:1184 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=38 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 79-cycle>
ds_load_u8 v[vgprValuA_X0_I0_D3+9], v[vgprLocalReadAddrA+0] offset:1200 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=39 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 81-cycle>
ds_load_u8 v[vgprValuA_X0_I0+10], v[vgprLocalReadAddrA+0] offset:1216 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=40 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 83-cycle>
ds_load_u8 v[vgprValuA_X0_I0_D1+10], v[vgprLocalReadAddrA+0] offset:1232 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=41 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 85-cycle>
ds_load_u8 v[vgprValuA_X0_I0_D2+10], v[vgprLocalReadAddrA+0] offset:1248 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=42 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 87-cycle>
ds_load_u8 v[vgprValuA_X0_I0_D3+10], v[vgprLocalReadAddrA+0] offset:1264 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=43 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 89-cycle>
ds_load_u8 v[vgprValuA_X0_I0+11], v[vgprLocalReadAddrA+0] offset:1280 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=44 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 91-cycle>
ds_load_u8 v[vgprValuA_X0_I0_D1+11], v[vgprLocalReadAddrA+0] offset:1296 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=45 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 93-cycle>
ds_load_u8 v[vgprValuA_X0_I0_D2+11], v[vgprLocalReadAddrA+0] offset:1312 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=46 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 95-cycle>
ds_load_u8 v[vgprValuA_X0_I0_D3+11], v[vgprLocalReadAddrA+0] offset:1328 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=47 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 97-cycle>
ds_load_u8 v[vgprValuA_X0_I0+12], v[vgprLocalReadAddrA+0] offset:1360 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=48 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 99-cycle>
ds_load_u8 v[vgprValuA_X0_I0_D1+12], v[vgprLocalReadAddrA+0] offset:1376 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=49 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 101-cycle>
ds_load_u8 v[vgprValuA_X0_I0_D2+12], v[vgprLocalReadAddrA+0] offset:1392 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=50 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 103-cycle>
ds_load_u8 v[vgprValuA_X0_I0_D3+12], v[vgprLocalReadAddrA+0] offset:1408 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=51 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 105-cycle>
ds_load_u8 v[vgprValuA_X0_I0+13], v[vgprLocalReadAddrA+0] offset:1424 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=52 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 107-cycle>
ds_load_u8 v[vgprValuA_X0_I0_D1+13], v[vgprLocalReadAddrA+0] offset:1440 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=53 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 109-cycle>
ds_load_u8 v[vgprValuA_X0_I0_D2+13], v[vgprLocalReadAddrA+0] offset:1456 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=54 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 111-cycle>
ds_load_u8 v[vgprValuA_X0_I0_D3+13], v[vgprLocalReadAddrA+0] offset:1472 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=55 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 113-cycle>
ds_load_u8 v[vgprValuA_X0_I0+14], v[vgprLocalReadAddrA+0] offset:1488 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=56 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 115-cycle>
ds_load_u8 v[vgprValuA_X0_I0_D1+14], v[vgprLocalReadAddrA+0] offset:1504 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=57 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 117-cycle>
ds_load_u8 v[vgprValuA_X0_I0_D2+14], v[vgprLocalReadAddrA+0] offset:1520 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=58 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 119-cycle>
ds_load_u8 v[vgprValuA_X0_I0_D3+14], v[vgprLocalReadAddrA+0] offset:1536 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=59 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 121-cycle>
ds_load_u8 v[vgprValuA_X0_I0+15], v[vgprLocalReadAddrA+0] offset:1552 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=60 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 123-cycle>
ds_load_u8 v[vgprValuA_X0_I0_D1+15], v[vgprLocalReadAddrA+0] offset:1568 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=61 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 125-cycle>
ds_load_u8 v[vgprValuA_X0_I0_D2+15], v[vgprLocalReadAddrA+0] offset:1584 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=62 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 127-cycle>
ds_load_u8 v[vgprValuA_X0_I0_D3+15], v[vgprLocalReadAddrA+0] offset:1600 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=63 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 129-cycle>
ds_load_b64 v[vgprValuMetadata_X0_I0+0:vgprValuMetadata_X0_I0+0+1], v[vgprLocalReadAddrMetadata+0] offset:0 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 131-cycle>
ds_load_b128 v[vgprValuB_X0_I0+0:vgprValuB_X0_I0+0+3], v[vgprLocalReadAddrB+0] offset:0 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 133-cycle>
ds_load_b128 v[vgprValuB_X0_I0+4:vgprValuB_X0_I0+4+3], v[vgprLocalReadAddrB+0] offset:32 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS0 <This is 135-cycle>

/* global read inc A loopL */
s_cmp_eq_u32 s[sgprLoopCounterL], s[sgprStaggerUIter] // Is this the wrapIter? <This is 136-cycle>
s_cselect_b32 s80, s[sgprWrapUA+0], s[sgprGlobalReadIncsA+0] // incLower <- ? <This is 137-cycle>
s_cselect_b32 s81, s[sgprWrapUA+1], 0              // incUpper <- ? <This is 138-cycle>
s_add_u32 s[sgprSrdA+0], s[sgprSrdA+0], s80        // gra SRD += inc(lower) <This is 139-cycle>
s_addc_u32 s[sgprSrdA+1], s[sgprSrdA+1], s81       // gra SRD += inc(upper) <This is 140-cycle>
s_sub_u32 s[sgprShadowLimitA+0], s[sgprShadowLimitA+0], s80 // limit -= inc) <This is 141-cycle>
s_subb_u32 s[sgprShadowLimitA+1], s[sgprShadowLimitA+1], s81 // limit -= inc) <This is 142-cycle>
s_cmp_eq_u32 s[sgprShadowLimitA+1], 0              // are we within 2^32? <This is 143-cycle>
s_cselect_b32 s[sgprSrdA+2], s[sgprShadowLimitA+0], BufferLimit // Move shadow to real if we are within 2^32 <This is 144-cycle>
// Shift num records for gfx125x
s_and_b32 s8, s[sgprSrdA+2], 127                   // <This is 145-cycle>
s_lshl_b32 s8, s8, 25                              // <This is 146-cycle>
s_and_b32 s[sgprSrdA+1], s[sgprSrdA+1], 33554431   // <This is 147-cycle>
s_or_b32 s[sgprSrdA+1], s[sgprSrdA+1], s8          // <This is 148-cycle>
s_lshr_b32 s[sgprSrdA+2], s[sgprSrdA+2], 7         // <This is 149-cycle>

/* global read inc B loopL */
s_cmp_eq_u32 s[sgprLoopCounterL], s[sgprStaggerUIter] // Is this the wrapIter? <This is 150-cycle>
s_cselect_b32 s80, s[sgprWrapUB+0], s[sgprGlobalReadIncsB+0] // incLower <- ? <This is 151-cycle>
s_cselect_b32 s81, s[sgprWrapUB+1], 0              // incUpper <- ? <This is 152-cycle>
s_add_u32 s[sgprSrdB+0], s[sgprSrdB+0], s80        // gra SRD += inc(lower) <This is 153-cycle>
s_addc_u32 s[sgprSrdB+1], s[sgprSrdB+1], s81       // gra SRD += inc(upper) <This is 154-cycle>
s_sub_u32 s[sgprShadowLimitB+0], s[sgprShadowLimitB+0], s80 // limit -= inc) <This is 155-cycle>
s_subb_u32 s[sgprShadowLimitB+1], s[sgprShadowLimitB+1], s81 // limit -= inc) <This is 156-cycle>
s_cmp_eq_u32 s[sgprShadowLimitB+1], 0              // are we within 2^32? <This is 157-cycle>
s_cselect_b32 s[sgprSrdB+2], s[sgprShadowLimitB+0], BufferLimit // Move shadow to real if we are within 2^32 <This is 158-cycle>
// Shift num records for gfx125x
s_and_b32 s8, s[sgprSrdB+2], 127                   // <This is 159-cycle>
s_lshl_b32 s8, s8, 25                              // <This is 160-cycle>
s_and_b32 s[sgprSrdB+1], s[sgprSrdB+1], 33554431   // <This is 161-cycle>
s_or_b32 s[sgprSrdB+1], s[sgprSrdB+1], s8          // <This is 162-cycle>
s_lshr_b32 s[sgprSrdB+2], s[sgprSrdB+2], 7         // <This is 163-cycle>
s_cmp_eq_u32 s[sgprLoopCounterL], s[sgprStaggerUIter] // Is this the wrapIter? <This is 164-cycle>
s_cselect_b32 s80, s[sgprWrapUMetadata+0], s[sgprGlobalReadIncsMetadata+0] // incLower <- ? <This is 165-cycle>
s_cselect_b32 s81, s[sgprWrapUMetadata+1], 0       // incUpper <- ? <This is 166-cycle>
s_add_u32 s[sgprSrdMetadata+0], s[sgprSrdMetadata+0], s80 // gra SRD += inc(lower) <This is 167-cycle>
s_addc_u32 s[sgprSrdMetadata+1], s[sgprSrdMetadata+1], s81 // gra SRD += inc(upper) <This is 168-cycle>
s_sub_u32 s[sgprShadowLimitMetadata+0], s[sgprShadowLimitMetadata+0], s80 // limit -= inc) <This is 169-cycle>
s_subb_u32 s[sgprShadowLimitMetadata+1], s[sgprShadowLimitMetadata+1], s81 // limit -= inc) <This is 170-cycle>
s_cmp_eq_u32 s[sgprShadowLimitMetadata+1], 0       // are we within 2^32? <This is 171-cycle>
s_cselect_b32 s[sgprSrdMetadata+2], s[sgprShadowLimitMetadata+0], BufferLimit // Move shadow to real if we are within 2^32 <This is 172-cycle>
// Shift num records for gfx125x
s_and_b32 s8, s[sgprSrdMetadata+2], 127            // <This is 173-cycle>
s_lshl_b32 s8, s8, 25                              // <This is 174-cycle>
s_and_b32 s[sgprSrdMetadata+1], s[sgprSrdMetadata+1], 33554431 // <This is 175-cycle>
s_or_b32 s[sgprSrdMetadata+1], s[sgprSrdMetadata+1], s8 // <This is 176-cycle>
s_lshr_b32 s[sgprSrdMetadata+2], s[sgprSrdMetadata+2], 7 // <This is 177-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 6                                   // wait for global read before writing to local <This is 178-cycle>
ds_store_b128 v[vgprLocalWriteAddrA+0], v[vgprG2LA+0:vgprG2LA+0+3] offset:4096 // lwoA_0_0_0_0 = (0*LSCA) + (0*LSPA)(*MT0I+PAD) = 4096 sync LDS1 <This is 178-cycle>
buffer_load_b128 v[vgprG2LA+0:vgprG2LA+0+3], v[vgprGlobalReadOffsetA+0], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_0_0 <This is 191-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 6                                   // wait for global read before writing to local <This is 192-cycle>
ds_store_b128 v[vgprLocalWriteAddrA+0], v[vgprG2LA+4:vgprG2LA+4+3] offset:4640 // lwoA_0_0_1_0 = (0*LSCA) + (1*LSPA)(*MT0I+PAD) = 4640 sync LDS1 <This is 192-cycle>
buffer_load_b128 v[vgprG2LA+4:vgprG2LA+4+3], v[vgprGlobalReadOffsetA+1], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_1_0 <This is 205-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 6                                   // wait for global read before writing to local <This is 206-cycle>
ds_store_b128 v[vgprLocalWriteAddrA+0], v[vgprG2LA+8:vgprG2LA+8+3] offset:5184 // lwoA_0_0_2_0 = (0*LSCA) + (2*LSPA)(*MT0I+PAD) = 5184 sync LDS1 <This is 206-cycle>
buffer_load_b128 v[vgprG2LA+8:vgprG2LA+8+3], v[vgprGlobalReadOffsetA+2], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_2_0 <This is 219-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 6                                   // wait for global read before writing to local <This is 220-cycle>
ds_store_b128 v[vgprLocalWriteAddrA+0], v[vgprG2LA+12:vgprG2LA+12+3] offset:5728 // lwoA_0_0_3_0 = (0*LSCA) + (3*LSPA)(*MT0I+PAD) = 5728 sync LDS1 <This is 220-cycle>
buffer_load_b128 v[vgprG2LA+12:vgprG2LA+12+3], v[vgprGlobalReadOffsetA+3], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_3_0 <This is 233-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 6                                   // wait for global read before writing to local <This is 234-cycle>
ds_store_b128 v[vgprLocalWriteAddrB+0], v[vgprG2LB+0:vgprG2LB+0+3] offset:4096 // lwoB_0_0_0_0 = (0*LSCB)*(MT1J+PAD) + (0*LSPB) = 4096 sync LDS1 <This is 234-cycle>
buffer_load_b128 v[vgprG2LB+0:vgprG2LB+0+3], v[vgprGlobalReadOffsetB+0], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_0_0 <This is 247-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 6                                   // wait for global read before writing to local <This is 248-cycle>
ds_store_b128 v[vgprLocalWriteAddrB+0], v[vgprG2LB+4:vgprG2LB+4+3] offset:4640 // lwoB_0_0_1_0 = (0*LSCB)*(MT1J+PAD) + (1*LSPB) = 4640 sync LDS1 <This is 248-cycle>
buffer_load_b128 v[vgprG2LB+4:vgprG2LB+4+3], v[vgprGlobalReadOffsetB+1], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_1_0 <This is 261-cycle>
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 6                                   // wait for global read before writing to local <This is 262-cycle>
ds_store_b64 v[vgprLocalWriteAddrMetadata+0], v[vgprG2LMetadata+0:vgprG2LMetadata+0+1] offset:4096 // lwoMetadata_0_0_0_0 = (0*LSCMetadata)*(MT1J+PAD) + (0*LSPMetadata) = 4096 sync LDS1 <This is 262-cycle>
buffer_load_b64 v[vgprG2LMetadata+0:vgprG2LMetadata+0+1], v[vgprGlobalReadOffsetMetadata+0], s[sgprSrdMetadata:sgprSrdMetadata+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_0_0 <This is 275-cycle>

/* local write swap offsets a */

/* (EPS=1) local write swap internal offset -> 0 */

/* local write swap offsets b */

/* (EPS=1) local write swap internal offset -> 0 */

/* (EPS=1) local write swap internal offset -> 0 */

/* local read swap offsets a */

/* local read swap internal offset -> 4096 */

/* local read swap offsets metadata */

/* local read swap internal offset -> 4096 */

/* local read swap offsets b */

/* local read swap internal offset -> 4096 */

/* local read init pointers a */

/* localReadInitPointers */

/* local read init pointers metadata */

/* localReadInitPointers */

/* local read init pointers b */

/* localReadInitPointers */
s_wait_dscnt 7                                     // Wait for dependent lr <This is 276-cycle>
/* pack scheduling: packAIdx:48, packBIdx:0, packMIdx:0 */
v_lshl_or_b32 v[vgprValuA_X0_I0+0], v[vgprValuA_X0_I0_D1+0], 8, v[vgprValuA_X0_I0+0] // pack two int8 Vgpr to one half Vgpr <This is 277-cycle>
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+0], v[vgprValuA_X0_I0_D3+0], 8, v[vgprValuA_X0_I0_D2+0] // pack two int8 Vgpr to one half Vgpr <This is 278-cycle>
s_delay_alu instid0(VALU_DEP_1)                    // <This is 279-cycle>
v_lshl_or_b32 v[vgprValuA_X0_I0+0], v[vgprValuA_X0_I0_D2+0], 0x10, v[vgprValuA_X0_I0+0] // pack two half Vgpr to one Vgpr <This is 280-cycle>
v_lshl_or_b32 v[vgprValuA_X0_I0+1], v[vgprValuA_X0_I0_D1+1], 8, v[vgprValuA_X0_I0+1] // pack two int8 Vgpr to one half Vgpr <This is 281-cycle>
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+1], v[vgprValuA_X0_I0_D3+1], 8, v[vgprValuA_X0_I0_D2+1] // pack two int8 Vgpr to one half Vgpr <This is 282-cycle>
s_delay_alu instid0(VALU_DEP_1)                    // <This is 283-cycle>
v_lshl_or_b32 v[vgprValuA_X0_I0+1], v[vgprValuA_X0_I0_D2+1], 0x10, v[vgprValuA_X0_I0+1] // pack two half Vgpr to one Vgpr <This is 284-cycle>
v_lshl_or_b32 v[vgprValuA_X0_I0+2], v[vgprValuA_X0_I0_D1+2], 8, v[vgprValuA_X0_I0+2] // pack two int8 Vgpr to one half Vgpr <This is 285-cycle>
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+2], v[vgprValuA_X0_I0_D3+2], 8, v[vgprValuA_X0_I0_D2+2] // pack two int8 Vgpr to one half Vgpr <This is 286-cycle>
s_delay_alu instid0(VALU_DEP_1)                    // <This is 287-cycle>
v_lshl_or_b32 v[vgprValuA_X0_I0+2], v[vgprValuA_X0_I0_D2+2], 0x10, v[vgprValuA_X0_I0+2] // pack two half Vgpr to one Vgpr <This is 288-cycle>
v_lshl_or_b32 v[vgprValuA_X0_I0+3], v[vgprValuA_X0_I0_D1+3], 8, v[vgprValuA_X0_I0+3] // pack two int8 Vgpr to one half Vgpr <This is 289-cycle>
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+3], v[vgprValuA_X0_I0_D3+3], 8, v[vgprValuA_X0_I0_D2+3] // pack two int8 Vgpr to one half Vgpr <This is 290-cycle>
s_delay_alu instid0(VALU_DEP_1)                    // <This is 291-cycle>
v_lshl_or_b32 v[vgprValuA_X0_I0+3], v[vgprValuA_X0_I0_D2+3], 0x10, v[vgprValuA_X0_I0+3] // pack two half Vgpr to one Vgpr <This is 292-cycle>
v_lshl_or_b32 v[vgprValuA_X0_I0+4], v[vgprValuA_X0_I0_D1+4], 8, v[vgprValuA_X0_I0+4] // pack two int8 Vgpr to one half Vgpr <This is 293-cycle>
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+4], v[vgprValuA_X0_I0_D3+4], 8, v[vgprValuA_X0_I0_D2+4] // pack two int8 Vgpr to one half Vgpr <This is 294-cycle>
s_delay_alu instid0(VALU_DEP_1)                    // <This is 295-cycle>
v_lshl_or_b32 v[vgprValuA_X0_I0+4], v[vgprValuA_X0_I0_D2+4], 0x10, v[vgprValuA_X0_I0+4] // pack two half Vgpr to one Vgpr <This is 296-cycle>
v_lshl_or_b32 v[vgprValuA_X0_I0+5], v[vgprValuA_X0_I0_D1+5], 8, v[vgprValuA_X0_I0+5] // pack two int8 Vgpr to one half Vgpr <This is 297-cycle>
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+5], v[vgprValuA_X0_I0_D3+5], 8, v[vgprValuA_X0_I0_D2+5] // pack two int8 Vgpr to one half Vgpr <This is 298-cycle>
s_delay_alu instid0(VALU_DEP_1)                    // <This is 299-cycle>
v_lshl_or_b32 v[vgprValuA_X0_I0+5], v[vgprValuA_X0_I0_D2+5], 0x10, v[vgprValuA_X0_I0+5] // pack two half Vgpr to one Vgpr <This is 300-cycle>
v_lshl_or_b32 v[vgprValuA_X0_I0+6], v[vgprValuA_X0_I0_D1+6], 8, v[vgprValuA_X0_I0+6] // pack two int8 Vgpr to one half Vgpr <This is 301-cycle>
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+6], v[vgprValuA_X0_I0_D3+6], 8, v[vgprValuA_X0_I0_D2+6] // pack two int8 Vgpr to one half Vgpr <This is 302-cycle>
s_delay_alu instid0(VALU_DEP_1)                    // <This is 303-cycle>
v_lshl_or_b32 v[vgprValuA_X0_I0+6], v[vgprValuA_X0_I0_D2+6], 0x10, v[vgprValuA_X0_I0+6] // pack two half Vgpr to one Vgpr <This is 304-cycle>
v_lshl_or_b32 v[vgprValuA_X0_I0+7], v[vgprValuA_X0_I0_D1+7], 8, v[vgprValuA_X0_I0+7] // pack two int8 Vgpr to one half Vgpr <This is 305-cycle>
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+7], v[vgprValuA_X0_I0_D3+7], 8, v[vgprValuA_X0_I0_D2+7] // pack two int8 Vgpr to one half Vgpr <This is 306-cycle>
s_delay_alu instid0(VALU_DEP_1)                    // <This is 307-cycle>
v_lshl_or_b32 v[vgprValuA_X0_I0+7], v[vgprValuA_X0_I0_D2+7], 0x10, v[vgprValuA_X0_I0+7] // pack two half Vgpr to one Vgpr <This is 308-cycle>
v_lshl_or_b32 v[vgprValuA_X0_I0+8], v[vgprValuA_X0_I0_D1+8], 8, v[vgprValuA_X0_I0+8] // pack two int8 Vgpr to one half Vgpr <This is 309-cycle>
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+8], v[vgprValuA_X0_I0_D3+8], 8, v[vgprValuA_X0_I0_D2+8] // pack two int8 Vgpr to one half Vgpr <This is 310-cycle>
s_delay_alu instid0(VALU_DEP_1)                    // <This is 311-cycle>
v_lshl_or_b32 v[vgprValuA_X0_I0+8], v[vgprValuA_X0_I0_D2+8], 0x10, v[vgprValuA_X0_I0+8] // pack two half Vgpr to one Vgpr <This is 312-cycle>
v_lshl_or_b32 v[vgprValuA_X0_I0+9], v[vgprValuA_X0_I0_D1+9], 8, v[vgprValuA_X0_I0+9] // pack two int8 Vgpr to one half Vgpr <This is 313-cycle>
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+9], v[vgprValuA_X0_I0_D3+9], 8, v[vgprValuA_X0_I0_D2+9] // pack two int8 Vgpr to one half Vgpr <This is 314-cycle>
s_delay_alu instid0(VALU_DEP_1)                    // <This is 315-cycle>
v_lshl_or_b32 v[vgprValuA_X0_I0+9], v[vgprValuA_X0_I0_D2+9], 0x10, v[vgprValuA_X0_I0+9] // pack two half Vgpr to one Vgpr <This is 316-cycle>
v_lshl_or_b32 v[vgprValuA_X0_I0+10], v[vgprValuA_X0_I0_D1+10], 8, v[vgprValuA_X0_I0+10] // pack two int8 Vgpr to one half Vgpr <This is 317-cycle>
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+10], v[vgprValuA_X0_I0_D3+10], 8, v[vgprValuA_X0_I0_D2+10] // pack two int8 Vgpr to one half Vgpr <This is 318-cycle>
s_delay_alu instid0(VALU_DEP_1)                    // <This is 319-cycle>
v_lshl_or_b32 v[vgprValuA_X0_I0+10], v[vgprValuA_X0_I0_D2+10], 0x10, v[vgprValuA_X0_I0+10] // pack two half Vgpr to one Vgpr <This is 320-cycle>
v_lshl_or_b32 v[vgprValuA_X0_I0+11], v[vgprValuA_X0_I0_D1+11], 8, v[vgprValuA_X0_I0+11] // pack two int8 Vgpr to one half Vgpr <This is 321-cycle>
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+11], v[vgprValuA_X0_I0_D3+11], 8, v[vgprValuA_X0_I0_D2+11] // pack two int8 Vgpr to one half Vgpr <This is 322-cycle>
s_delay_alu instid0(VALU_DEP_1)                    // <This is 323-cycle>
v_lshl_or_b32 v[vgprValuA_X0_I0+11], v[vgprValuA_X0_I0_D2+11], 0x10, v[vgprValuA_X0_I0+11] // pack two half Vgpr to one Vgpr <This is 324-cycle>
v_lshl_or_b32 v[vgprValuA_X0_I0+12], v[vgprValuA_X0_I0_D1+12], 8, v[vgprValuA_X0_I0+12] // pack two int8 Vgpr to one half Vgpr <This is 325-cycle>
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+12], v[vgprValuA_X0_I0_D3+12], 8, v[vgprValuA_X0_I0_D2+12] // pack two int8 Vgpr to one half Vgpr <This is 326-cycle>
s_delay_alu instid0(VALU_DEP_1)                    // <This is 327-cycle>
v_lshl_or_b32 v[vgprValuA_X0_I0+12], v[vgprValuA_X0_I0_D2+12], 0x10, v[vgprValuA_X0_I0+12] // pack two half Vgpr to one Vgpr <This is 328-cycle>
v_lshl_or_b32 v[vgprValuA_X0_I0+13], v[vgprValuA_X0_I0_D1+13], 8, v[vgprValuA_X0_I0+13] // pack two int8 Vgpr to one half Vgpr <This is 329-cycle>
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+13], v[vgprValuA_X0_I0_D3+13], 8, v[vgprValuA_X0_I0_D2+13] // pack two int8 Vgpr to one half Vgpr <This is 330-cycle>
s_delay_alu instid0(VALU_DEP_1)                    // <This is 331-cycle>
v_lshl_or_b32 v[vgprValuA_X0_I0+13], v[vgprValuA_X0_I0_D2+13], 0x10, v[vgprValuA_X0_I0+13] // pack two half Vgpr to one Vgpr <This is 332-cycle>
v_lshl_or_b32 v[vgprValuA_X0_I0+14], v[vgprValuA_X0_I0_D1+14], 8, v[vgprValuA_X0_I0+14] // pack two int8 Vgpr to one half Vgpr <This is 333-cycle>
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+14], v[vgprValuA_X0_I0_D3+14], 8, v[vgprValuA_X0_I0_D2+14] // pack two int8 Vgpr to one half Vgpr <This is 334-cycle>
s_delay_alu instid0(VALU_DEP_1)                    // <This is 335-cycle>
v_lshl_or_b32 v[vgprValuA_X0_I0+14], v[vgprValuA_X0_I0_D2+14], 0x10, v[vgprValuA_X0_I0+14] // pack two half Vgpr to one Vgpr <This is 336-cycle>
v_lshl_or_b32 v[vgprValuA_X0_I0+15], v[vgprValuA_X0_I0_D1+15], 8, v[vgprValuA_X0_I0+15] // pack two int8 Vgpr to one half Vgpr <This is 337-cycle>
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+15], v[vgprValuA_X0_I0_D3+15], 8, v[vgprValuA_X0_I0_D2+15] // pack two int8 Vgpr to one half Vgpr <This is 338-cycle>
s_delay_alu instid0(VALU_DEP_1)                    // <This is 339-cycle>
v_lshl_or_b32 v[vgprValuA_X0_I0+15], v[vgprValuA_X0_I0_D2+15], 0x10, v[vgprValuA_X0_I0+15] // pack two half Vgpr to one Vgpr <This is 340-cycle>
/* pack scheduling: curPackIdx:48, numPack:48, instPackLast:['A', 'A'] */
s_nop 1                                            // VALU packing writes to be consumed by matrix instruction <This is 341-cycle>
v_swmmac_f32_16x16x128_fp8_fp8 v[vgprValuC+0:vgprValuC+0+7], v[vgprValuB_X0_I0+0+0+0:vgprValuB_X0_I0+0+0+0+7], v[vgprValuA_X0_I0+0+0+0:vgprValuA_X0_I0+0+0+0+15], v[vgprValuMetadata_X0_I0+0+0+0:vgprValuMetadata_X0_I0+0+0+0+1] matrix_a_reuse matrix_b_reuse // left value = v[0+0:7+0] <This is 342-cycle>
/* numPrefetchIter=0 */
/* dataAtIterA=0 numReadsIterA=1 skipReadsIterA=0 readsPerIterA=64 */
/* dataAtIterB=0 numReadsIterB=1 skipReadsIterB=0 readsPerIterB=2 */
/* dataAtIterMetadata=0 numReadsIterMetadata=1 skipReadsIterMetadata=0 readsPerIterMetadata=1 */

/******************************************/
/* Unrolled Loop - End 1/2                */
/******************************************/

/* closeLoop loopL finalLoop=0 tailLoop=0 */
s_sub_u32 s[sgprLoopCounterL], s[sgprLoopCounterL], 1 // dec counterL <This is 342-cycle>
s_delay_alu instid0(SALU_CYCLE_1)                  // <This is 342-cycle>
s_cmp_eq_i32 s[sgprLoopCounterL], 0x2              // counterL==2 <This is 342-cycle>
s_cbranch_scc1 label_LoopEndL_oddexit              // exit LoopL <This is 342-cycle>

/******************************************/
/* Unrolled Loop 2/2 - Begin              */
/******************************************/
s_wait_dscnt 0                                     // 1wait for local write
// Skip barrier: NumThreads=324sync for global read, PGR->LW needs sync

/* Begin Each Unroll: Check VGPR.checkin for INT8 LW */

/* iter 0 (reset local read pointers iteration)  (swap and reset local write pointers iteration)  (swap local read pointers iteration)  */
/*  grEndMfmaIndex:0, lwStartMfmaIndex:0, lwEndMfmaIndex:0  */
/*  numMfmaForLR:0, syncPlrMfmaIndex:0  */
/*  mfmaIndex:0  */
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
ds_load_u8 v[vgprValuA_X0_I0+0], v[vgprLocalReadAddrA+0] offset:4096 // L -> Reg lro=0 swapByteOffset=4096 ti=16 vIdx=0 eIdx=0 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D1+0], v[vgprLocalReadAddrA+0] offset:4112 // L -> Reg lro=0 swapByteOffset=4096 ti=16 vIdx=0 eIdx=0 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D2+0], v[vgprLocalReadAddrA+0] offset:4128 // L -> Reg lro=0 swapByteOffset=4096 ti=16 vIdx=0 eIdx=0 rIdx=2 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D3+0], v[vgprLocalReadAddrA+0] offset:4144 // L -> Reg lro=0 swapByteOffset=4096 ti=16 vIdx=0 eIdx=0 rIdx=3 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0+1], v[vgprLocalReadAddrA+0] offset:4160 // L -> Reg lro=0 swapByteOffset=4096 ti=16 vIdx=0 eIdx=0 rIdx=4 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D1+1], v[vgprLocalReadAddrA+0] offset:4176 // L -> Reg lro=0 swapByteOffset=4096 ti=16 vIdx=0 eIdx=0 rIdx=5 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D2+1], v[vgprLocalReadAddrA+0] offset:4192 // L -> Reg lro=0 swapByteOffset=4096 ti=16 vIdx=0 eIdx=0 rIdx=6 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D3+1], v[vgprLocalReadAddrA+0] offset:4208 // L -> Reg lro=0 swapByteOffset=4096 ti=16 vIdx=0 eIdx=0 rIdx=7 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0+2], v[vgprLocalReadAddrA+0] offset:4224 // L -> Reg lro=0 swapByteOffset=4096 ti=16 vIdx=0 eIdx=0 rIdx=8 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D1+2], v[vgprLocalReadAddrA+0] offset:4240 // L -> Reg lro=0 swapByteOffset=4096 ti=16 vIdx=0 eIdx=0 rIdx=9 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D2+2], v[vgprLocalReadAddrA+0] offset:4256 // L -> Reg lro=0 swapByteOffset=4096 ti=16 vIdx=0 eIdx=0 rIdx=10 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D3+2], v[vgprLocalReadAddrA+0] offset:4272 // L -> Reg lro=0 swapByteOffset=4096 ti=16 vIdx=0 eIdx=0 rIdx=11 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0+3], v[vgprLocalReadAddrA+0] offset:4288 // L -> Reg lro=0 swapByteOffset=4096 ti=16 vIdx=0 eIdx=0 rIdx=12 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D1+3], v[vgprLocalReadAddrA+0] offset:4304 // L -> Reg lro=0 swapByteOffset=4096 ti=16 vIdx=0 eIdx=0 rIdx=13 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D2+3], v[vgprLocalReadAddrA+0] offset:4320 // L -> Reg lro=0 swapByteOffset=4096 ti=16 vIdx=0 eIdx=0 rIdx=14 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D3+3], v[vgprLocalReadAddrA+0] offset:4336 // L -> Reg lro=0 swapByteOffset=4096 ti=16 vIdx=0 eIdx=0 rIdx=15 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0+4], v[vgprLocalReadAddrA+0] offset:4368 // L -> Reg lro=0 swapByteOffset=4096 ti=16 vIdx=0 eIdx=0 rIdx=16 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D1+4], v[vgprLocalReadAddrA+0] offset:4384 // L -> Reg lro=0 swapByteOffset=4096 ti=16 vIdx=0 eIdx=0 rIdx=17 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D2+4], v[vgprLocalReadAddrA+0] offset:4400 // L -> Reg lro=0 swapByteOffset=4096 ti=16 vIdx=0 eIdx=0 rIdx=18 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D3+4], v[vgprLocalReadAddrA+0] offset:4416 // L -> Reg lro=0 swapByteOffset=4096 ti=16 vIdx=0 eIdx=0 rIdx=19 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0+5], v[vgprLocalReadAddrA+0] offset:4432 // L -> Reg lro=0 swapByteOffset=4096 ti=16 vIdx=0 eIdx=0 rIdx=20 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D1+5], v[vgprLocalReadAddrA+0] offset:4448 // L -> Reg lro=0 swapByteOffset=4096 ti=16 vIdx=0 eIdx=0 rIdx=21 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D2+5], v[vgprLocalReadAddrA+0] offset:4464 // L -> Reg lro=0 swapByteOffset=4096 ti=16 vIdx=0 eIdx=0 rIdx=22 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D3+5], v[vgprLocalReadAddrA+0] offset:4480 // L -> Reg lro=0 swapByteOffset=4096 ti=16 vIdx=0 eIdx=0 rIdx=23 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0+6], v[vgprLocalReadAddrA+0] offset:4496 // L -> Reg lro=0 swapByteOffset=4096 ti=16 vIdx=0 eIdx=0 rIdx=24 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D1+6], v[vgprLocalReadAddrA+0] offset:4512 // L -> Reg lro=0 swapByteOffset=4096 ti=16 vIdx=0 eIdx=0 rIdx=25 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D2+6], v[vgprLocalReadAddrA+0] offset:4528 // L -> Reg lro=0 swapByteOffset=4096 ti=16 vIdx=0 eIdx=0 rIdx=26 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D3+6], v[vgprLocalReadAddrA+0] offset:4544 // L -> Reg lro=0 swapByteOffset=4096 ti=16 vIdx=0 eIdx=0 rIdx=27 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0+7], v[vgprLocalReadAddrA+0] offset:4560 // L -> Reg lro=0 swapByteOffset=4096 ti=16 vIdx=0 eIdx=0 rIdx=28 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D1+7], v[vgprLocalReadAddrA+0] offset:4576 // L -> Reg lro=0 swapByteOffset=4096 ti=16 vIdx=0 eIdx=0 rIdx=29 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D2+7], v[vgprLocalReadAddrA+0] offset:4592 // L -> Reg lro=0 swapByteOffset=4096 ti=16 vIdx=0 eIdx=0 rIdx=30 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D3+7], v[vgprLocalReadAddrA+0] offset:4608 // L -> Reg lro=0 swapByteOffset=4096 ti=16 vIdx=0 eIdx=0 rIdx=31 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0+8], v[vgprLocalReadAddrA+0] offset:5184 // L -> Reg lro=0 swapByteOffset=4096 ti=16 vIdx=0 eIdx=0 rIdx=32 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D1+8], v[vgprLocalReadAddrA+0] offset:5200 // L -> Reg lro=0 swapByteOffset=4096 ti=16 vIdx=0 eIdx=0 rIdx=33 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D2+8], v[vgprLocalReadAddrA+0] offset:5216 // L -> Reg lro=0 swapByteOffset=4096 ti=16 vIdx=0 eIdx=0 rIdx=34 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D3+8], v[vgprLocalReadAddrA+0] offset:5232 // L -> Reg lro=0 swapByteOffset=4096 ti=16 vIdx=0 eIdx=0 rIdx=35 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0+9], v[vgprLocalReadAddrA+0] offset:5248 // L -> Reg lro=0 swapByteOffset=4096 ti=16 vIdx=0 eIdx=0 rIdx=36 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D1+9], v[vgprLocalReadAddrA+0] offset:5264 // L -> Reg lro=0 swapByteOffset=4096 ti=16 vIdx=0 eIdx=0 rIdx=37 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D2+9], v[vgprLocalReadAddrA+0] offset:5280 // L -> Reg lro=0 swapByteOffset=4096 ti=16 vIdx=0 eIdx=0 rIdx=38 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D3+9], v[vgprLocalReadAddrA+0] offset:5296 // L -> Reg lro=0 swapByteOffset=4096 ti=16 vIdx=0 eIdx=0 rIdx=39 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0+10], v[vgprLocalReadAddrA+0] offset:5312 // L -> Reg lro=0 swapByteOffset=4096 ti=16 vIdx=0 eIdx=0 rIdx=40 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D1+10], v[vgprLocalReadAddrA+0] offset:5328 // L -> Reg lro=0 swapByteOffset=4096 ti=16 vIdx=0 eIdx=0 rIdx=41 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D2+10], v[vgprLocalReadAddrA+0] offset:5344 // L -> Reg lro=0 swapByteOffset=4096 ti=16 vIdx=0 eIdx=0 rIdx=42 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D3+10], v[vgprLocalReadAddrA+0] offset:5360 // L -> Reg lro=0 swapByteOffset=4096 ti=16 vIdx=0 eIdx=0 rIdx=43 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0+11], v[vgprLocalReadAddrA+0] offset:5376 // L -> Reg lro=0 swapByteOffset=4096 ti=16 vIdx=0 eIdx=0 rIdx=44 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D1+11], v[vgprLocalReadAddrA+0] offset:5392 // L -> Reg lro=0 swapByteOffset=4096 ti=16 vIdx=0 eIdx=0 rIdx=45 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D2+11], v[vgprLocalReadAddrA+0] offset:5408 // L -> Reg lro=0 swapByteOffset=4096 ti=16 vIdx=0 eIdx=0 rIdx=46 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D3+11], v[vgprLocalReadAddrA+0] offset:5424 // L -> Reg lro=0 swapByteOffset=4096 ti=16 vIdx=0 eIdx=0 rIdx=47 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0+12], v[vgprLocalReadAddrA+0] offset:5456 // L -> Reg lro=0 swapByteOffset=4096 ti=16 vIdx=0 eIdx=0 rIdx=48 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D1+12], v[vgprLocalReadAddrA+0] offset:5472 // L -> Reg lro=0 swapByteOffset=4096 ti=16 vIdx=0 eIdx=0 rIdx=49 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D2+12], v[vgprLocalReadAddrA+0] offset:5488 // L -> Reg lro=0 swapByteOffset=4096 ti=16 vIdx=0 eIdx=0 rIdx=50 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D3+12], v[vgprLocalReadAddrA+0] offset:5504 // L -> Reg lro=0 swapByteOffset=4096 ti=16 vIdx=0 eIdx=0 rIdx=51 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0+13], v[vgprLocalReadAddrA+0] offset:5520 // L -> Reg lro=0 swapByteOffset=4096 ti=16 vIdx=0 eIdx=0 rIdx=52 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D1+13], v[vgprLocalReadAddrA+0] offset:5536 // L -> Reg lro=0 swapByteOffset=4096 ti=16 vIdx=0 eIdx=0 rIdx=53 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D2+13], v[vgprLocalReadAddrA+0] offset:5552 // L -> Reg lro=0 swapByteOffset=4096 ti=16 vIdx=0 eIdx=0 rIdx=54 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D3+13], v[vgprLocalReadAddrA+0] offset:5568 // L -> Reg lro=0 swapByteOffset=4096 ti=16 vIdx=0 eIdx=0 rIdx=55 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0+14], v[vgprLocalReadAddrA+0] offset:5584 // L -> Reg lro=0 swapByteOffset=4096 ti=16 vIdx=0 eIdx=0 rIdx=56 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D1+14], v[vgprLocalReadAddrA+0] offset:5600 // L -> Reg lro=0 swapByteOffset=4096 ti=16 vIdx=0 eIdx=0 rIdx=57 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D2+14], v[vgprLocalReadAddrA+0] offset:5616 // L -> Reg lro=0 swapByteOffset=4096 ti=16 vIdx=0 eIdx=0 rIdx=58 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D3+14], v[vgprLocalReadAddrA+0] offset:5632 // L -> Reg lro=0 swapByteOffset=4096 ti=16 vIdx=0 eIdx=0 rIdx=59 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0+15], v[vgprLocalReadAddrA+0] offset:5648 // L -> Reg lro=0 swapByteOffset=4096 ti=16 vIdx=0 eIdx=0 rIdx=60 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D1+15], v[vgprLocalReadAddrA+0] offset:5664 // L -> Reg lro=0 swapByteOffset=4096 ti=16 vIdx=0 eIdx=0 rIdx=61 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D2+15], v[vgprLocalReadAddrA+0] offset:5680 // L -> Reg lro=0 swapByteOffset=4096 ti=16 vIdx=0 eIdx=0 rIdx=62 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D3+15], v[vgprLocalReadAddrA+0] offset:5696 // L -> Reg lro=0 swapByteOffset=4096 ti=16 vIdx=0 eIdx=0 rIdx=63 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_b64 v[vgprValuMetadata_X0_I0+0:vgprValuMetadata_X0_I0+0+1], v[vgprLocalReadAddrMetadata+0] offset:4096 // L -> Reg lro=0 swapByteOffset=4096 ti=16 vIdx=0 eIdx=0 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_b128 v[vgprValuB_X0_I0+0:vgprValuB_X0_I0+0+3], v[vgprLocalReadAddrB+0] offset:4096 // L -> Reg lro=0 swapByteOffset=4096 ti=16 vIdx=0 eIdx=0 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_b128 v[vgprValuB_X0_I0+4:vgprValuB_X0_I0+4+3], v[vgprLocalReadAddrB+0] offset:4128 // L -> Reg lro=0 swapByteOffset=4096 ti=16 vIdx=0 eIdx=0 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS1

/* global read inc A loopL */
s_cmp_eq_u32 s[sgprLoopCounterL], s[sgprStaggerUIter] // Is this the wrapIter?
s_cselect_b32 s80, s[sgprWrapUA+0], s[sgprGlobalReadIncsA+0] // incLower <- ?
s_cselect_b32 s81, s[sgprWrapUA+1], 0              // incUpper <- ?
s_add_u32 s[sgprSrdA+0], s[sgprSrdA+0], s80        // gra SRD += inc(lower)
s_addc_u32 s[sgprSrdA+1], s[sgprSrdA+1], s81       // gra SRD += inc(upper)
s_sub_u32 s[sgprShadowLimitA+0], s[sgprShadowLimitA+0], s80 // limit -= inc)
s_subb_u32 s[sgprShadowLimitA+1], s[sgprShadowLimitA+1], s81 // limit -= inc)
s_cmp_eq_u32 s[sgprShadowLimitA+1], 0              // are we within 2^32?
s_cselect_b32 s[sgprSrdA+2], s[sgprShadowLimitA+0], BufferLimit // Move shadow to real if we are within 2^32
// Shift num records for gfx125x
s_and_b32 s8, s[sgprSrdA+2], 127
s_lshl_b32 s8, s8, 25
s_and_b32 s[sgprSrdA+1], s[sgprSrdA+1], 33554431
s_or_b32 s[sgprSrdA+1], s[sgprSrdA+1], s8
s_lshr_b32 s[sgprSrdA+2], s[sgprSrdA+2], 7

/* global read inc B loopL */
s_cmp_eq_u32 s[sgprLoopCounterL], s[sgprStaggerUIter] // Is this the wrapIter?
s_cselect_b32 s80, s[sgprWrapUB+0], s[sgprGlobalReadIncsB+0] // incLower <- ?
s_cselect_b32 s81, s[sgprWrapUB+1], 0              // incUpper <- ?
s_add_u32 s[sgprSrdB+0], s[sgprSrdB+0], s80        // gra SRD += inc(lower)
s_addc_u32 s[sgprSrdB+1], s[sgprSrdB+1], s81       // gra SRD += inc(upper)
s_sub_u32 s[sgprShadowLimitB+0], s[sgprShadowLimitB+0], s80 // limit -= inc)
s_subb_u32 s[sgprShadowLimitB+1], s[sgprShadowLimitB+1], s81 // limit -= inc)
s_cmp_eq_u32 s[sgprShadowLimitB+1], 0              // are we within 2^32?
s_cselect_b32 s[sgprSrdB+2], s[sgprShadowLimitB+0], BufferLimit // Move shadow to real if we are within 2^32
// Shift num records for gfx125x
s_and_b32 s8, s[sgprSrdB+2], 127
s_lshl_b32 s8, s8, 25
s_and_b32 s[sgprSrdB+1], s[sgprSrdB+1], 33554431
s_or_b32 s[sgprSrdB+1], s[sgprSrdB+1], s8
s_lshr_b32 s[sgprSrdB+2], s[sgprSrdB+2], 7
s_cmp_eq_u32 s[sgprLoopCounterL], s[sgprStaggerUIter] // Is this the wrapIter?
s_cselect_b32 s80, s[sgprWrapUMetadata+0], s[sgprGlobalReadIncsMetadata+0] // incLower <- ?
s_cselect_b32 s81, s[sgprWrapUMetadata+1], 0       // incUpper <- ?
s_add_u32 s[sgprSrdMetadata+0], s[sgprSrdMetadata+0], s80 // gra SRD += inc(lower)
s_addc_u32 s[sgprSrdMetadata+1], s[sgprSrdMetadata+1], s81 // gra SRD += inc(upper)
s_sub_u32 s[sgprShadowLimitMetadata+0], s[sgprShadowLimitMetadata+0], s80 // limit -= inc)
s_subb_u32 s[sgprShadowLimitMetadata+1], s[sgprShadowLimitMetadata+1], s81 // limit -= inc)
s_cmp_eq_u32 s[sgprShadowLimitMetadata+1], 0       // are we within 2^32?
s_cselect_b32 s[sgprSrdMetadata+2], s[sgprShadowLimitMetadata+0], BufferLimit // Move shadow to real if we are within 2^32
// Shift num records for gfx125x
s_and_b32 s8, s[sgprSrdMetadata+2], 127
s_lshl_b32 s8, s8, 25
s_and_b32 s[sgprSrdMetadata+1], s[sgprSrdMetadata+1], 33554431
s_or_b32 s[sgprSrdMetadata+1], s[sgprSrdMetadata+1], s8
s_lshr_b32 s[sgprSrdMetadata+2], s[sgprSrdMetadata+2], 7
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 6                                   // wait for global read before writing to local
ds_store_b128 v[vgprLocalWriteAddrA+0], v[vgprG2LA+0:vgprG2LA+0+3] offset:0 // lwoA_0_0_0_0 = (0*LSCA) + (0*LSPA)(*MT0I+PAD) = 0 sync LDS0
buffer_load_b128 v[vgprG2LA+0:vgprG2LA+0+3], v[vgprGlobalReadOffsetA+0], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_0_0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 6                                   // wait for global read before writing to local
ds_store_b128 v[vgprLocalWriteAddrA+0], v[vgprG2LA+4:vgprG2LA+4+3] offset:544 // lwoA_0_0_1_0 = (0*LSCA) + (1*LSPA)(*MT0I+PAD) = 544 sync LDS0
buffer_load_b128 v[vgprG2LA+4:vgprG2LA+4+3], v[vgprGlobalReadOffsetA+1], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_1_0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 6                                   // wait for global read before writing to local
ds_store_b128 v[vgprLocalWriteAddrA+0], v[vgprG2LA+8:vgprG2LA+8+3] offset:1088 // lwoA_0_0_2_0 = (0*LSCA) + (2*LSPA)(*MT0I+PAD) = 1088 sync LDS0
buffer_load_b128 v[vgprG2LA+8:vgprG2LA+8+3], v[vgprGlobalReadOffsetA+2], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_2_0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 6                                   // wait for global read before writing to local
ds_store_b128 v[vgprLocalWriteAddrA+0], v[vgprG2LA+12:vgprG2LA+12+3] offset:1632 // lwoA_0_0_3_0 = (0*LSCA) + (3*LSPA)(*MT0I+PAD) = 1632 sync LDS0
buffer_load_b128 v[vgprG2LA+12:vgprG2LA+12+3], v[vgprGlobalReadOffsetA+3], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_3_0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 6                                   // wait for global read before writing to local
ds_store_b128 v[vgprLocalWriteAddrB+0], v[vgprG2LB+0:vgprG2LB+0+3] offset:0 // lwoB_0_0_0_0 = (0*LSCB)*(MT1J+PAD) + (0*LSPB) = 0 sync LDS0
buffer_load_b128 v[vgprG2LB+0:vgprG2LB+0+3], v[vgprGlobalReadOffsetB+0], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_0_0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 6                                   // wait for global read before writing to local
ds_store_b128 v[vgprLocalWriteAddrB+0], v[vgprG2LB+4:vgprG2LB+4+3] offset:544 // lwoB_0_0_1_0 = (0*LSCB)*(MT1J+PAD) + (1*LSPB) = 544 sync LDS0
buffer_load_b128 v[vgprG2LB+4:vgprG2LB+4+3], v[vgprGlobalReadOffsetB+1], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_1_0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 6                                   // wait for global read before writing to local
ds_store_b64 v[vgprLocalWriteAddrMetadata+0], v[vgprG2LMetadata+0:vgprG2LMetadata+0+1] offset:0 // lwoMetadata_0_0_0_0 = (0*LSCMetadata)*(MT1J+PAD) + (0*LSPMetadata) = 0 sync LDS0
buffer_load_b64 v[vgprG2LMetadata+0:vgprG2LMetadata+0+1], v[vgprGlobalReadOffsetMetadata+0], s[sgprSrdMetadata:sgprSrdMetadata+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // G -> Reg 0_0_0_0

/* local write swap offsets a */

/* (EPS=1) local write swap internal offset -> 4096 */

/* local write swap offsets b */

/* (EPS=1) local write swap internal offset -> 4096 */

/* (EPS=1) local write swap internal offset -> 4096 */

/* local read swap offsets a */

/* local read swap internal offset -> 0 */

/* local read swap offsets metadata */

/* local read swap internal offset -> 0 */

/* local read swap offsets b */

/* local read swap internal offset -> 0 */

/* local read init pointers a */

/* localReadInitPointers */

/* local read init pointers metadata */

/* localReadInitPointers */

/* local read init pointers b */

/* localReadInitPointers */
s_wait_dscnt 7                                     // Wait for dependent lr
/* pack scheduling: packAIdx:48, packBIdx:0, packMIdx:0 */
v_lshl_or_b32 v[vgprValuA_X0_I0+0], v[vgprValuA_X0_I0_D1+0], 8, v[vgprValuA_X0_I0+0] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+0], v[vgprValuA_X0_I0_D3+0], 8, v[vgprValuA_X0_I0_D2+0] // pack two int8 Vgpr to one half Vgpr
s_delay_alu instid0(VALU_DEP_1)
v_lshl_or_b32 v[vgprValuA_X0_I0+0], v[vgprValuA_X0_I0_D2+0], 0x10, v[vgprValuA_X0_I0+0] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+1], v[vgprValuA_X0_I0_D1+1], 8, v[vgprValuA_X0_I0+1] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+1], v[vgprValuA_X0_I0_D3+1], 8, v[vgprValuA_X0_I0_D2+1] // pack two int8 Vgpr to one half Vgpr
s_delay_alu instid0(VALU_DEP_1)
v_lshl_or_b32 v[vgprValuA_X0_I0+1], v[vgprValuA_X0_I0_D2+1], 0x10, v[vgprValuA_X0_I0+1] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+2], v[vgprValuA_X0_I0_D1+2], 8, v[vgprValuA_X0_I0+2] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+2], v[vgprValuA_X0_I0_D3+2], 8, v[vgprValuA_X0_I0_D2+2] // pack two int8 Vgpr to one half Vgpr
s_delay_alu instid0(VALU_DEP_1)
v_lshl_or_b32 v[vgprValuA_X0_I0+2], v[vgprValuA_X0_I0_D2+2], 0x10, v[vgprValuA_X0_I0+2] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+3], v[vgprValuA_X0_I0_D1+3], 8, v[vgprValuA_X0_I0+3] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+3], v[vgprValuA_X0_I0_D3+3], 8, v[vgprValuA_X0_I0_D2+3] // pack two int8 Vgpr to one half Vgpr
s_delay_alu instid0(VALU_DEP_1)
v_lshl_or_b32 v[vgprValuA_X0_I0+3], v[vgprValuA_X0_I0_D2+3], 0x10, v[vgprValuA_X0_I0+3] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+4], v[vgprValuA_X0_I0_D1+4], 8, v[vgprValuA_X0_I0+4] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+4], v[vgprValuA_X0_I0_D3+4], 8, v[vgprValuA_X0_I0_D2+4] // pack two int8 Vgpr to one half Vgpr
s_delay_alu instid0(VALU_DEP_1)
v_lshl_or_b32 v[vgprValuA_X0_I0+4], v[vgprValuA_X0_I0_D2+4], 0x10, v[vgprValuA_X0_I0+4] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+5], v[vgprValuA_X0_I0_D1+5], 8, v[vgprValuA_X0_I0+5] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+5], v[vgprValuA_X0_I0_D3+5], 8, v[vgprValuA_X0_I0_D2+5] // pack two int8 Vgpr to one half Vgpr
s_delay_alu instid0(VALU_DEP_1)
v_lshl_or_b32 v[vgprValuA_X0_I0+5], v[vgprValuA_X0_I0_D2+5], 0x10, v[vgprValuA_X0_I0+5] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+6], v[vgprValuA_X0_I0_D1+6], 8, v[vgprValuA_X0_I0+6] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+6], v[vgprValuA_X0_I0_D3+6], 8, v[vgprValuA_X0_I0_D2+6] // pack two int8 Vgpr to one half Vgpr
s_delay_alu instid0(VALU_DEP_1)
v_lshl_or_b32 v[vgprValuA_X0_I0+6], v[vgprValuA_X0_I0_D2+6], 0x10, v[vgprValuA_X0_I0+6] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+7], v[vgprValuA_X0_I0_D1+7], 8, v[vgprValuA_X0_I0+7] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+7], v[vgprValuA_X0_I0_D3+7], 8, v[vgprValuA_X0_I0_D2+7] // pack two int8 Vgpr to one half Vgpr
s_delay_alu instid0(VALU_DEP_1)
v_lshl_or_b32 v[vgprValuA_X0_I0+7], v[vgprValuA_X0_I0_D2+7], 0x10, v[vgprValuA_X0_I0+7] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+8], v[vgprValuA_X0_I0_D1+8], 8, v[vgprValuA_X0_I0+8] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+8], v[vgprValuA_X0_I0_D3+8], 8, v[vgprValuA_X0_I0_D2+8] // pack two int8 Vgpr to one half Vgpr
s_delay_alu instid0(VALU_DEP_1)
v_lshl_or_b32 v[vgprValuA_X0_I0+8], v[vgprValuA_X0_I0_D2+8], 0x10, v[vgprValuA_X0_I0+8] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+9], v[vgprValuA_X0_I0_D1+9], 8, v[vgprValuA_X0_I0+9] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+9], v[vgprValuA_X0_I0_D3+9], 8, v[vgprValuA_X0_I0_D2+9] // pack two int8 Vgpr to one half Vgpr
s_delay_alu instid0(VALU_DEP_1)
v_lshl_or_b32 v[vgprValuA_X0_I0+9], v[vgprValuA_X0_I0_D2+9], 0x10, v[vgprValuA_X0_I0+9] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+10], v[vgprValuA_X0_I0_D1+10], 8, v[vgprValuA_X0_I0+10] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+10], v[vgprValuA_X0_I0_D3+10], 8, v[vgprValuA_X0_I0_D2+10] // pack two int8 Vgpr to one half Vgpr
s_delay_alu instid0(VALU_DEP_1)
v_lshl_or_b32 v[vgprValuA_X0_I0+10], v[vgprValuA_X0_I0_D2+10], 0x10, v[vgprValuA_X0_I0+10] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+11], v[vgprValuA_X0_I0_D1+11], 8, v[vgprValuA_X0_I0+11] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+11], v[vgprValuA_X0_I0_D3+11], 8, v[vgprValuA_X0_I0_D2+11] // pack two int8 Vgpr to one half Vgpr
s_delay_alu instid0(VALU_DEP_1)
v_lshl_or_b32 v[vgprValuA_X0_I0+11], v[vgprValuA_X0_I0_D2+11], 0x10, v[vgprValuA_X0_I0+11] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+12], v[vgprValuA_X0_I0_D1+12], 8, v[vgprValuA_X0_I0+12] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+12], v[vgprValuA_X0_I0_D3+12], 8, v[vgprValuA_X0_I0_D2+12] // pack two int8 Vgpr to one half Vgpr
s_delay_alu instid0(VALU_DEP_1)
v_lshl_or_b32 v[vgprValuA_X0_I0+12], v[vgprValuA_X0_I0_D2+12], 0x10, v[vgprValuA_X0_I0+12] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+13], v[vgprValuA_X0_I0_D1+13], 8, v[vgprValuA_X0_I0+13] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+13], v[vgprValuA_X0_I0_D3+13], 8, v[vgprValuA_X0_I0_D2+13] // pack two int8 Vgpr to one half Vgpr
s_delay_alu instid0(VALU_DEP_1)
v_lshl_or_b32 v[vgprValuA_X0_I0+13], v[vgprValuA_X0_I0_D2+13], 0x10, v[vgprValuA_X0_I0+13] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+14], v[vgprValuA_X0_I0_D1+14], 8, v[vgprValuA_X0_I0+14] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+14], v[vgprValuA_X0_I0_D3+14], 8, v[vgprValuA_X0_I0_D2+14] // pack two int8 Vgpr to one half Vgpr
s_delay_alu instid0(VALU_DEP_1)
v_lshl_or_b32 v[vgprValuA_X0_I0+14], v[vgprValuA_X0_I0_D2+14], 0x10, v[vgprValuA_X0_I0+14] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+15], v[vgprValuA_X0_I0_D1+15], 8, v[vgprValuA_X0_I0+15] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+15], v[vgprValuA_X0_I0_D3+15], 8, v[vgprValuA_X0_I0_D2+15] // pack two int8 Vgpr to one half Vgpr
s_delay_alu instid0(VALU_DEP_1)
v_lshl_or_b32 v[vgprValuA_X0_I0+15], v[vgprValuA_X0_I0_D2+15], 0x10, v[vgprValuA_X0_I0+15] // pack two half Vgpr to one Vgpr
/* pack scheduling: curPackIdx:48, numPack:48, instPackLast:['A', 'A'] */
s_nop 1                                            // VALU packing writes to be consumed by matrix instruction
v_swmmac_f32_16x16x128_fp8_fp8 v[vgprValuC+0:vgprValuC+0+7], v[vgprValuB_X0_I0+0+0+0:vgprValuB_X0_I0+0+0+0+7], v[vgprValuA_X0_I0+0+0+0:vgprValuA_X0_I0+0+0+0+15], v[vgprValuMetadata_X0_I0+0+0+0:vgprValuMetadata_X0_I0+0+0+0+1] matrix_a_reuse matrix_b_reuse // left value = v[0+0:7+0]
/* numPrefetchIter=0 */
/* dataAtIterA=0 numReadsIterA=1 skipReadsIterA=0 readsPerIterA=64 */
/* dataAtIterB=0 numReadsIterB=1 skipReadsIterB=0 readsPerIterB=2 */
/* dataAtIterMetadata=0 numReadsIterMetadata=1 skipReadsIterMetadata=0 readsPerIterMetadata=1 */

/******************************************/
/* Unrolled Loop - End 2/2 (final)        */
/******************************************/

/* closeLoop loopL finalLoop=1 tailLoop=0 */
s_sub_u32 s[sgprLoopCounterL], s[sgprLoopCounterL], 1 // dec counterL
s_delay_alu instid0(SALU_CYCLE_1)
s_cmp_eq_i32 s[sgprLoopCounterL], 0x2              // counterL==2
s_cbranch_scc0 label_LoopBeginL                    // restart LoopL
label_LoopEndL_evenexit:  /// unroll loop eveniter exit
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_xor_b32 v[vgprLocalWriteAddrA], 0x1000, v[vgprLocalWriteAddrA] // swap Red Blk
v_xor_b32 v[vgprLocalWriteAddrB], 0x1000, v[vgprLocalWriteAddrB] // swap Red Blk
v_xor_b32 v[vgprLocalWriteAddrMetadata], 0x1000, v[vgprLocalWriteAddrMetadata] // swap Red Blk

/* (EPS=1) local write swap internal offset -> 0 */

/* (EPS=1) local write swap internal offset -> 0 */

/* (EPS=1) local write swap internal offset -> 0 */
s_branch label_LoopEndL                            // exit unroll loopL (and skip second exit code)
label_LoopEndL_oddexit:  /// unroll loop odditer exit

/* Select high bank of LDS */
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_xor_b32 v[vgprLocalReadAddrA], 0x1000, v[vgprLocalReadAddrA] // swap Red Blk
v_xor_b32 v[vgprLocalReadAddrB], 0x1000, v[vgprLocalReadAddrB] // swap Red Blk
v_xor_b32 v[vgprLocalReadAddrMetadata], 0x1000, v[vgprLocalReadAddrMetadata] // swap Red Blk
label_LoopEndL:

/* Before NLL: Check VGPR.checkin for INT8 LW */

/******************************************/
/* Ord. NoGlobalLoadLoop_1 - Begin        */
/******************************************/
s_wait_dscnt 0                                     // 4wait for local write
// Skip barrier: NumThreads=32wait for local write done, sync

/* iter 0 (reset local read pointers iteration)  (swap and reset local write pointers iteration)  (swap local read pointers iteration)  */
/*  grEndMfmaIndex:0, lwStartMfmaIndex:0, lwEndMfmaIndex:0  */
/*  numMfmaForLR:0, syncPlrMfmaIndex:0  */
/*  mfmaIndex:0  */
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
ds_load_u8 v[vgprValuA_X0_I0+0], v[vgprLocalReadAddrA+0] offset:0 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D1+0], v[vgprLocalReadAddrA+0] offset:16 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D2+0], v[vgprLocalReadAddrA+0] offset:32 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=2 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D3+0], v[vgprLocalReadAddrA+0] offset:48 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=3 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0+1], v[vgprLocalReadAddrA+0] offset:64 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=4 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D1+1], v[vgprLocalReadAddrA+0] offset:80 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=5 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D2+1], v[vgprLocalReadAddrA+0] offset:96 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=6 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D3+1], v[vgprLocalReadAddrA+0] offset:112 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=7 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0+2], v[vgprLocalReadAddrA+0] offset:128 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=8 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D1+2], v[vgprLocalReadAddrA+0] offset:144 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=9 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D2+2], v[vgprLocalReadAddrA+0] offset:160 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=10 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D3+2], v[vgprLocalReadAddrA+0] offset:176 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=11 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0+3], v[vgprLocalReadAddrA+0] offset:192 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=12 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D1+3], v[vgprLocalReadAddrA+0] offset:208 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=13 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D2+3], v[vgprLocalReadAddrA+0] offset:224 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=14 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D3+3], v[vgprLocalReadAddrA+0] offset:240 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=15 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0+4], v[vgprLocalReadAddrA+0] offset:272 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=16 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D1+4], v[vgprLocalReadAddrA+0] offset:288 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=17 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D2+4], v[vgprLocalReadAddrA+0] offset:304 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=18 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D3+4], v[vgprLocalReadAddrA+0] offset:320 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=19 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0+5], v[vgprLocalReadAddrA+0] offset:336 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=20 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D1+5], v[vgprLocalReadAddrA+0] offset:352 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=21 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D2+5], v[vgprLocalReadAddrA+0] offset:368 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=22 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D3+5], v[vgprLocalReadAddrA+0] offset:384 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=23 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0+6], v[vgprLocalReadAddrA+0] offset:400 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=24 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D1+6], v[vgprLocalReadAddrA+0] offset:416 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=25 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D2+6], v[vgprLocalReadAddrA+0] offset:432 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=26 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D3+6], v[vgprLocalReadAddrA+0] offset:448 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=27 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0+7], v[vgprLocalReadAddrA+0] offset:464 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=28 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D1+7], v[vgprLocalReadAddrA+0] offset:480 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=29 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D2+7], v[vgprLocalReadAddrA+0] offset:496 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=30 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D3+7], v[vgprLocalReadAddrA+0] offset:512 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=31 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0+8], v[vgprLocalReadAddrA+0] offset:1088 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=32 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D1+8], v[vgprLocalReadAddrA+0] offset:1104 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=33 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D2+8], v[vgprLocalReadAddrA+0] offset:1120 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=34 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D3+8], v[vgprLocalReadAddrA+0] offset:1136 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=35 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0+9], v[vgprLocalReadAddrA+0] offset:1152 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=36 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D1+9], v[vgprLocalReadAddrA+0] offset:1168 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=37 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D2+9], v[vgprLocalReadAddrA+0] offset:1184 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=38 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D3+9], v[vgprLocalReadAddrA+0] offset:1200 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=39 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0+10], v[vgprLocalReadAddrA+0] offset:1216 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=40 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D1+10], v[vgprLocalReadAddrA+0] offset:1232 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=41 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D2+10], v[vgprLocalReadAddrA+0] offset:1248 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=42 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D3+10], v[vgprLocalReadAddrA+0] offset:1264 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=43 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0+11], v[vgprLocalReadAddrA+0] offset:1280 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=44 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D1+11], v[vgprLocalReadAddrA+0] offset:1296 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=45 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D2+11], v[vgprLocalReadAddrA+0] offset:1312 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=46 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D3+11], v[vgprLocalReadAddrA+0] offset:1328 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=47 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0+12], v[vgprLocalReadAddrA+0] offset:1360 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=48 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D1+12], v[vgprLocalReadAddrA+0] offset:1376 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=49 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D2+12], v[vgprLocalReadAddrA+0] offset:1392 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=50 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D3+12], v[vgprLocalReadAddrA+0] offset:1408 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=51 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0+13], v[vgprLocalReadAddrA+0] offset:1424 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=52 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D1+13], v[vgprLocalReadAddrA+0] offset:1440 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=53 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D2+13], v[vgprLocalReadAddrA+0] offset:1456 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=54 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D3+13], v[vgprLocalReadAddrA+0] offset:1472 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=55 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0+14], v[vgprLocalReadAddrA+0] offset:1488 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=56 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D1+14], v[vgprLocalReadAddrA+0] offset:1504 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=57 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D2+14], v[vgprLocalReadAddrA+0] offset:1520 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=58 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D3+14], v[vgprLocalReadAddrA+0] offset:1536 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=59 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0+15], v[vgprLocalReadAddrA+0] offset:1552 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=60 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D1+15], v[vgprLocalReadAddrA+0] offset:1568 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=61 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D2+15], v[vgprLocalReadAddrA+0] offset:1584 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=62 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D3+15], v[vgprLocalReadAddrA+0] offset:1600 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=63 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_b64 v[vgprValuMetadata_X0_I0+0:vgprValuMetadata_X0_I0+0+1], v[vgprLocalReadAddrMetadata+0] offset:0 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_b128 v[vgprValuB_X0_I0+0:vgprValuB_X0_I0+0+3], v[vgprLocalReadAddrB+0] offset:0 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_b128 v[vgprValuB_X0_I0+4:vgprValuB_X0_I0+4+3], v[vgprLocalReadAddrB+0] offset:32 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS0

/* global read inc A loopL */
s_cmp_eq_u32 s[sgprLoopCounterL], s[sgprStaggerUIter] // Is this the wrapIter?
s_cselect_b32 s80, s[sgprWrapUA+0], s[sgprGlobalReadIncsA+0] // incLower <- ?
s_cselect_b32 s81, s[sgprWrapUA+1], 0              // incUpper <- ?
s_add_u32 s[sgprSrdA+0], s[sgprSrdA+0], s80        // gra SRD += inc(lower)
s_addc_u32 s[sgprSrdA+1], s[sgprSrdA+1], s81       // gra SRD += inc(upper)
s_sub_u32 s[sgprShadowLimitA+0], s[sgprShadowLimitA+0], s80 // limit -= inc)
s_subb_u32 s[sgprShadowLimitA+1], s[sgprShadowLimitA+1], s81 // limit -= inc)
s_cmp_eq_u32 s[sgprShadowLimitA+1], 0              // are we within 2^32?
s_cselect_b32 s[sgprSrdA+2], s[sgprShadowLimitA+0], BufferLimit // Move shadow to real if we are within 2^32
// Shift num records for gfx125x
s_and_b32 s8, s[sgprSrdA+2], 127
s_lshl_b32 s8, s8, 25
s_and_b32 s[sgprSrdA+1], s[sgprSrdA+1], 33554431
s_or_b32 s[sgprSrdA+1], s[sgprSrdA+1], s8
s_lshr_b32 s[sgprSrdA+2], s[sgprSrdA+2], 7

/* global read inc B loopL */
s_cmp_eq_u32 s[sgprLoopCounterL], s[sgprStaggerUIter] // Is this the wrapIter?
s_cselect_b32 s80, s[sgprWrapUB+0], s[sgprGlobalReadIncsB+0] // incLower <- ?
s_cselect_b32 s81, s[sgprWrapUB+1], 0              // incUpper <- ?
s_add_u32 s[sgprSrdB+0], s[sgprSrdB+0], s80        // gra SRD += inc(lower)
s_addc_u32 s[sgprSrdB+1], s[sgprSrdB+1], s81       // gra SRD += inc(upper)
s_sub_u32 s[sgprShadowLimitB+0], s[sgprShadowLimitB+0], s80 // limit -= inc)
s_subb_u32 s[sgprShadowLimitB+1], s[sgprShadowLimitB+1], s81 // limit -= inc)
s_cmp_eq_u32 s[sgprShadowLimitB+1], 0              // are we within 2^32?
s_cselect_b32 s[sgprSrdB+2], s[sgprShadowLimitB+0], BufferLimit // Move shadow to real if we are within 2^32
// Shift num records for gfx125x
s_and_b32 s8, s[sgprSrdB+2], 127
s_lshl_b32 s8, s8, 25
s_and_b32 s[sgprSrdB+1], s[sgprSrdB+1], 33554431
s_or_b32 s[sgprSrdB+1], s[sgprSrdB+1], s8
s_lshr_b32 s[sgprSrdB+2], s[sgprSrdB+2], 7
s_cmp_eq_u32 s[sgprLoopCounterL], s[sgprStaggerUIter] // Is this the wrapIter?
s_cselect_b32 s80, s[sgprWrapUMetadata+0], s[sgprGlobalReadIncsMetadata+0] // incLower <- ?
s_cselect_b32 s81, s[sgprWrapUMetadata+1], 0       // incUpper <- ?
s_add_u32 s[sgprSrdMetadata+0], s[sgprSrdMetadata+0], s80 // gra SRD += inc(lower)
s_addc_u32 s[sgprSrdMetadata+1], s[sgprSrdMetadata+1], s81 // gra SRD += inc(upper)
s_sub_u32 s[sgprShadowLimitMetadata+0], s[sgprShadowLimitMetadata+0], s80 // limit -= inc)
s_subb_u32 s[sgprShadowLimitMetadata+1], s[sgprShadowLimitMetadata+1], s81 // limit -= inc)
s_cmp_eq_u32 s[sgprShadowLimitMetadata+1], 0       // are we within 2^32?
s_cselect_b32 s[sgprSrdMetadata+2], s[sgprShadowLimitMetadata+0], BufferLimit // Move shadow to real if we are within 2^32
// Shift num records for gfx125x
s_and_b32 s8, s[sgprSrdMetadata+2], 127
s_lshl_b32 s8, s8, 25
s_and_b32 s[sgprSrdMetadata+1], s[sgprSrdMetadata+1], 33554431
s_or_b32 s[sgprSrdMetadata+1], s[sgprSrdMetadata+1], s8
s_lshr_b32 s[sgprSrdMetadata+2], s[sgprSrdMetadata+2], 7
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 6                                   // wait for global read before writing to local
ds_store_b128 v[vgprLocalWriteAddrA+0], v[vgprG2LA+0:vgprG2LA+0+3] offset:0 // lwoA_0_0_0_0 = (0*LSCA) + (0*LSPA)(*MT0I+PAD) = 0 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 5                                   // wait for global read before writing to local
ds_store_b128 v[vgprLocalWriteAddrA+0], v[vgprG2LA+4:vgprG2LA+4+3] offset:544 // lwoA_0_0_1_0 = (0*LSCA) + (1*LSPA)(*MT0I+PAD) = 544 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 4                                   // wait for global read before writing to local
ds_store_b128 v[vgprLocalWriteAddrA+0], v[vgprG2LA+8:vgprG2LA+8+3] offset:1088 // lwoA_0_0_2_0 = (0*LSCA) + (2*LSPA)(*MT0I+PAD) = 1088 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 3                                   // wait for global read before writing to local
ds_store_b128 v[vgprLocalWriteAddrA+0], v[vgprG2LA+12:vgprG2LA+12+3] offset:1632 // lwoA_0_0_3_0 = (0*LSCA) + (3*LSPA)(*MT0I+PAD) = 1632 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 2                                   // wait for global read before writing to local
ds_store_b128 v[vgprLocalWriteAddrB+0], v[vgprG2LB+0:vgprG2LB+0+3] offset:0 // lwoB_0_0_0_0 = (0*LSCB)*(MT1J+PAD) + (0*LSPB) = 0 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 1                                   // wait for global read before writing to local
ds_store_b128 v[vgprLocalWriteAddrB+0], v[vgprG2LB+4:vgprG2LB+4+3] offset:544 // lwoB_0_0_1_0 = (0*LSCB)*(MT1J+PAD) + (1*LSPB) = 544 sync LDS0
/* sched write - iter 0 writesPerItem=1 */
s_wait_loadcnt 0                                   // wait for global read before writing to local
ds_store_b64 v[vgprLocalWriteAddrMetadata+0], v[vgprG2LMetadata+0:vgprG2LMetadata+0+1] offset:0 // lwoMetadata_0_0_0_0 = (0*LSCMetadata)*(MT1J+PAD) + (0*LSPMetadata) = 0 sync LDS0

/* local write swap offsets a */

/* (EPS=1) local write swap internal offset -> 4096 */

/* local write swap offsets b */

/* (EPS=1) local write swap internal offset -> 4096 */

/* (EPS=1) local write swap internal offset -> 4096 */

/* local read swap offsets a */
v_xor_b32 v[vgprLocalReadAddrA], 0x1000, v[vgprLocalReadAddrA] // swap Red Blk

/* local read swap offsets b */
v_xor_b32 v[vgprLocalReadAddrB], 0x1000, v[vgprLocalReadAddrB] // swap Red Blk

/* local read swap offsets metadata */
v_xor_b32 v[vgprLocalReadAddrMetadata], 0x1000, v[vgprLocalReadAddrMetadata] // swap Red Blk

/* local read init pointers a */

/* localReadInitPointers */

/* local read init pointers b */

/* localReadInitPointers */

/* local read init pointers metadata */

/* localReadInitPointers */
s_wait_dscnt 7                                     // Wait for dependent lr
/* pack scheduling: packAIdx:48, packBIdx:0, packMIdx:0 */
v_lshl_or_b32 v[vgprValuA_X0_I0+0], v[vgprValuA_X0_I0_D1+0], 8, v[vgprValuA_X0_I0+0] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+0], v[vgprValuA_X0_I0_D3+0], 8, v[vgprValuA_X0_I0_D2+0] // pack two int8 Vgpr to one half Vgpr
s_delay_alu instid0(VALU_DEP_1)
v_lshl_or_b32 v[vgprValuA_X0_I0+0], v[vgprValuA_X0_I0_D2+0], 0x10, v[vgprValuA_X0_I0+0] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+1], v[vgprValuA_X0_I0_D1+1], 8, v[vgprValuA_X0_I0+1] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+1], v[vgprValuA_X0_I0_D3+1], 8, v[vgprValuA_X0_I0_D2+1] // pack two int8 Vgpr to one half Vgpr
s_delay_alu instid0(VALU_DEP_1)
v_lshl_or_b32 v[vgprValuA_X0_I0+1], v[vgprValuA_X0_I0_D2+1], 0x10, v[vgprValuA_X0_I0+1] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+2], v[vgprValuA_X0_I0_D1+2], 8, v[vgprValuA_X0_I0+2] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+2], v[vgprValuA_X0_I0_D3+2], 8, v[vgprValuA_X0_I0_D2+2] // pack two int8 Vgpr to one half Vgpr
s_delay_alu instid0(VALU_DEP_1)
v_lshl_or_b32 v[vgprValuA_X0_I0+2], v[vgprValuA_X0_I0_D2+2], 0x10, v[vgprValuA_X0_I0+2] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+3], v[vgprValuA_X0_I0_D1+3], 8, v[vgprValuA_X0_I0+3] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+3], v[vgprValuA_X0_I0_D3+3], 8, v[vgprValuA_X0_I0_D2+3] // pack two int8 Vgpr to one half Vgpr
s_delay_alu instid0(VALU_DEP_1)
v_lshl_or_b32 v[vgprValuA_X0_I0+3], v[vgprValuA_X0_I0_D2+3], 0x10, v[vgprValuA_X0_I0+3] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+4], v[vgprValuA_X0_I0_D1+4], 8, v[vgprValuA_X0_I0+4] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+4], v[vgprValuA_X0_I0_D3+4], 8, v[vgprValuA_X0_I0_D2+4] // pack two int8 Vgpr to one half Vgpr
s_delay_alu instid0(VALU_DEP_1)
v_lshl_or_b32 v[vgprValuA_X0_I0+4], v[vgprValuA_X0_I0_D2+4], 0x10, v[vgprValuA_X0_I0+4] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+5], v[vgprValuA_X0_I0_D1+5], 8, v[vgprValuA_X0_I0+5] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+5], v[vgprValuA_X0_I0_D3+5], 8, v[vgprValuA_X0_I0_D2+5] // pack two int8 Vgpr to one half Vgpr
s_delay_alu instid0(VALU_DEP_1)
v_lshl_or_b32 v[vgprValuA_X0_I0+5], v[vgprValuA_X0_I0_D2+5], 0x10, v[vgprValuA_X0_I0+5] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+6], v[vgprValuA_X0_I0_D1+6], 8, v[vgprValuA_X0_I0+6] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+6], v[vgprValuA_X0_I0_D3+6], 8, v[vgprValuA_X0_I0_D2+6] // pack two int8 Vgpr to one half Vgpr
s_delay_alu instid0(VALU_DEP_1)
v_lshl_or_b32 v[vgprValuA_X0_I0+6], v[vgprValuA_X0_I0_D2+6], 0x10, v[vgprValuA_X0_I0+6] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+7], v[vgprValuA_X0_I0_D1+7], 8, v[vgprValuA_X0_I0+7] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+7], v[vgprValuA_X0_I0_D3+7], 8, v[vgprValuA_X0_I0_D2+7] // pack two int8 Vgpr to one half Vgpr
s_delay_alu instid0(VALU_DEP_1)
v_lshl_or_b32 v[vgprValuA_X0_I0+7], v[vgprValuA_X0_I0_D2+7], 0x10, v[vgprValuA_X0_I0+7] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+8], v[vgprValuA_X0_I0_D1+8], 8, v[vgprValuA_X0_I0+8] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+8], v[vgprValuA_X0_I0_D3+8], 8, v[vgprValuA_X0_I0_D2+8] // pack two int8 Vgpr to one half Vgpr
s_delay_alu instid0(VALU_DEP_1)
v_lshl_or_b32 v[vgprValuA_X0_I0+8], v[vgprValuA_X0_I0_D2+8], 0x10, v[vgprValuA_X0_I0+8] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+9], v[vgprValuA_X0_I0_D1+9], 8, v[vgprValuA_X0_I0+9] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+9], v[vgprValuA_X0_I0_D3+9], 8, v[vgprValuA_X0_I0_D2+9] // pack two int8 Vgpr to one half Vgpr
s_delay_alu instid0(VALU_DEP_1)
v_lshl_or_b32 v[vgprValuA_X0_I0+9], v[vgprValuA_X0_I0_D2+9], 0x10, v[vgprValuA_X0_I0+9] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+10], v[vgprValuA_X0_I0_D1+10], 8, v[vgprValuA_X0_I0+10] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+10], v[vgprValuA_X0_I0_D3+10], 8, v[vgprValuA_X0_I0_D2+10] // pack two int8 Vgpr to one half Vgpr
s_delay_alu instid0(VALU_DEP_1)
v_lshl_or_b32 v[vgprValuA_X0_I0+10], v[vgprValuA_X0_I0_D2+10], 0x10, v[vgprValuA_X0_I0+10] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+11], v[vgprValuA_X0_I0_D1+11], 8, v[vgprValuA_X0_I0+11] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+11], v[vgprValuA_X0_I0_D3+11], 8, v[vgprValuA_X0_I0_D2+11] // pack two int8 Vgpr to one half Vgpr
s_delay_alu instid0(VALU_DEP_1)
v_lshl_or_b32 v[vgprValuA_X0_I0+11], v[vgprValuA_X0_I0_D2+11], 0x10, v[vgprValuA_X0_I0+11] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+12], v[vgprValuA_X0_I0_D1+12], 8, v[vgprValuA_X0_I0+12] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+12], v[vgprValuA_X0_I0_D3+12], 8, v[vgprValuA_X0_I0_D2+12] // pack two int8 Vgpr to one half Vgpr
s_delay_alu instid0(VALU_DEP_1)
v_lshl_or_b32 v[vgprValuA_X0_I0+12], v[vgprValuA_X0_I0_D2+12], 0x10, v[vgprValuA_X0_I0+12] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+13], v[vgprValuA_X0_I0_D1+13], 8, v[vgprValuA_X0_I0+13] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+13], v[vgprValuA_X0_I0_D3+13], 8, v[vgprValuA_X0_I0_D2+13] // pack two int8 Vgpr to one half Vgpr
s_delay_alu instid0(VALU_DEP_1)
v_lshl_or_b32 v[vgprValuA_X0_I0+13], v[vgprValuA_X0_I0_D2+13], 0x10, v[vgprValuA_X0_I0+13] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+14], v[vgprValuA_X0_I0_D1+14], 8, v[vgprValuA_X0_I0+14] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+14], v[vgprValuA_X0_I0_D3+14], 8, v[vgprValuA_X0_I0_D2+14] // pack two int8 Vgpr to one half Vgpr
s_delay_alu instid0(VALU_DEP_1)
v_lshl_or_b32 v[vgprValuA_X0_I0+14], v[vgprValuA_X0_I0_D2+14], 0x10, v[vgprValuA_X0_I0+14] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+15], v[vgprValuA_X0_I0_D1+15], 8, v[vgprValuA_X0_I0+15] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+15], v[vgprValuA_X0_I0_D3+15], 8, v[vgprValuA_X0_I0_D2+15] // pack two int8 Vgpr to one half Vgpr
s_delay_alu instid0(VALU_DEP_1)
v_lshl_or_b32 v[vgprValuA_X0_I0+15], v[vgprValuA_X0_I0_D2+15], 0x10, v[vgprValuA_X0_I0+15] // pack two half Vgpr to one Vgpr
/* pack scheduling: curPackIdx:48, numPack:48, instPackLast:['A', 'A'] */
s_nop 1                                            // VALU packing writes to be consumed by matrix instruction
v_swmmac_f32_16x16x128_fp8_fp8 v[vgprValuC+0:vgprValuC+0+7], v[vgprValuB_X0_I0+0+0+0:vgprValuB_X0_I0+0+0+0+7], v[vgprValuA_X0_I0+0+0+0:vgprValuA_X0_I0+0+0+0+15], v[vgprValuMetadata_X0_I0+0+0+0:vgprValuMetadata_X0_I0+0+0+0+1] matrix_a_reuse matrix_b_reuse // left value = v[0+0:7+0]
/* numPrefetchIter=0 */
/* dataAtIterA=0 numReadsIterA=1 skipReadsIterA=0 readsPerIterA=64 */
/* dataAtIterB=0 numReadsIterB=1 skipReadsIterB=0 readsPerIterB=2 */
/* dataAtIterMetadata=0 numReadsIterMetadata=1 skipReadsIterMetadata=0 readsPerIterMetadata=1 */
label_toPGR1:
s_and_b32 s8, s[sgprGSU], 0x3fff                   // Restore GSU
s_delay_alu instid0(SALU_CYCLE_1)
s_cmp_eq_u32 s8, 1                                 // GSU == 1 ?
s_cbranch_scc0 label_GSU_3                         // branch if GSU != 1

/******************************************/
/* Opt. NoLoadLoop - Begin                */
/******************************************/
s_mov_b32 s8, 0
s_cmp_eq_u32 s[sgprBeta], s8                       // Beta == 0
s_cbranch_scc0 label_OptNLL_End

s_cmp_eq_u32 s[sgprAlpha], 1.0                     // Alpha == 1.0 ?

/* branch if alpha != 1 */
s_cbranch_scc0 label_OptNLL_End


/* Edge/NonEdge store path check (M): Size % 16 > 0 -> Edge store; else -> NonEdge store */
s_and_b32 s80, 15, s[sgprSizeI]                    // s80 = s[sgprSizeI] % 16
s_add_u32 s81, -0x1, s[sgprNumWorkGroups0]
s_cmp_ge_u32 s[sgprWorkGroup0], s81                // wg0 >= nwg0-1 ?
s_cselect_b32 s80, s80, 0                          // set rem
s_mov_b32 s8, 0
s_cmp_gt_u32 s80, s8                               // rem > 0

/* jump if edges required */
s_cbranch_scc1 label_OptNLL_End

/* Edge/NonEdge store path check (N (isSize1)): Size % 16 > 0 -> Edge store; else -> NonEdge store */
s_and_b32 s80, 15, s[sgprSizeJ]                    // s80 = s[sgprSizeJ] % 16
s_add_u32 s81, -0x1, s[sgprNumWorkGroups1]
s_cmp_ge_u32 s[sgprWorkGroup1], s81                // wg1 >= nwg1-1
s_cselect_b32 s80, s80, 0                          // set rem
s_mov_b32 s8, 0
s_cmp_gt_u32 s80, s8                               // rem > 0

/* jump if edges required */
s_cbranch_scc1 label_OptNLL_End

s_and_b32 s81, 127, s[sgprSizesSum+0]              // s81 = s[sgprSizesSum+0] % 128
s_cmp_eq_u32 s81, 0                                // numIterL == 0

/* skip if tail loop required */
s_cbranch_scc0 label_OptNLL_End
s_wait_dscnt 0                                     // 4wait for local write
// Skip barrier: NumThreads=32wait for local write done, sync

/* iter 0 (last unrolled loop) */
/*  grEndMfmaIndex:0, lwStartMfmaIndex:0, lwEndMfmaIndex:0  */
/*  numMfmaForLR:0, syncPlrMfmaIndex:0  */
/*  mfmaIndex:0  */
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
ds_load_u8 v[vgprValuA_X0_I0+0], v[vgprLocalReadAddrA+0] offset:0 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D1+0], v[vgprLocalReadAddrA+0] offset:16 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D2+0], v[vgprLocalReadAddrA+0] offset:32 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=2 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D3+0], v[vgprLocalReadAddrA+0] offset:48 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=3 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0+1], v[vgprLocalReadAddrA+0] offset:64 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=4 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D1+1], v[vgprLocalReadAddrA+0] offset:80 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=5 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D2+1], v[vgprLocalReadAddrA+0] offset:96 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=6 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D3+1], v[vgprLocalReadAddrA+0] offset:112 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=7 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0+2], v[vgprLocalReadAddrA+0] offset:128 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=8 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D1+2], v[vgprLocalReadAddrA+0] offset:144 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=9 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D2+2], v[vgprLocalReadAddrA+0] offset:160 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=10 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D3+2], v[vgprLocalReadAddrA+0] offset:176 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=11 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0+3], v[vgprLocalReadAddrA+0] offset:192 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=12 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D1+3], v[vgprLocalReadAddrA+0] offset:208 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=13 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D2+3], v[vgprLocalReadAddrA+0] offset:224 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=14 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D3+3], v[vgprLocalReadAddrA+0] offset:240 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=15 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0+4], v[vgprLocalReadAddrA+0] offset:272 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=16 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D1+4], v[vgprLocalReadAddrA+0] offset:288 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=17 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D2+4], v[vgprLocalReadAddrA+0] offset:304 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=18 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D3+4], v[vgprLocalReadAddrA+0] offset:320 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=19 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0+5], v[vgprLocalReadAddrA+0] offset:336 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=20 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D1+5], v[vgprLocalReadAddrA+0] offset:352 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=21 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D2+5], v[vgprLocalReadAddrA+0] offset:368 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=22 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D3+5], v[vgprLocalReadAddrA+0] offset:384 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=23 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0+6], v[vgprLocalReadAddrA+0] offset:400 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=24 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D1+6], v[vgprLocalReadAddrA+0] offset:416 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=25 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D2+6], v[vgprLocalReadAddrA+0] offset:432 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=26 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D3+6], v[vgprLocalReadAddrA+0] offset:448 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=27 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0+7], v[vgprLocalReadAddrA+0] offset:464 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=28 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D1+7], v[vgprLocalReadAddrA+0] offset:480 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=29 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D2+7], v[vgprLocalReadAddrA+0] offset:496 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=30 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D3+7], v[vgprLocalReadAddrA+0] offset:512 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=31 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0+8], v[vgprLocalReadAddrA+0] offset:1088 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=32 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D1+8], v[vgprLocalReadAddrA+0] offset:1104 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=33 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D2+8], v[vgprLocalReadAddrA+0] offset:1120 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=34 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D3+8], v[vgprLocalReadAddrA+0] offset:1136 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=35 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0+9], v[vgprLocalReadAddrA+0] offset:1152 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=36 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D1+9], v[vgprLocalReadAddrA+0] offset:1168 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=37 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D2+9], v[vgprLocalReadAddrA+0] offset:1184 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=38 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D3+9], v[vgprLocalReadAddrA+0] offset:1200 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=39 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0+10], v[vgprLocalReadAddrA+0] offset:1216 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=40 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D1+10], v[vgprLocalReadAddrA+0] offset:1232 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=41 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D2+10], v[vgprLocalReadAddrA+0] offset:1248 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=42 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D3+10], v[vgprLocalReadAddrA+0] offset:1264 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=43 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0+11], v[vgprLocalReadAddrA+0] offset:1280 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=44 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D1+11], v[vgprLocalReadAddrA+0] offset:1296 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=45 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D2+11], v[vgprLocalReadAddrA+0] offset:1312 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=46 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D3+11], v[vgprLocalReadAddrA+0] offset:1328 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=47 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0+12], v[vgprLocalReadAddrA+0] offset:1360 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=48 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D1+12], v[vgprLocalReadAddrA+0] offset:1376 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=49 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D2+12], v[vgprLocalReadAddrA+0] offset:1392 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=50 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D3+12], v[vgprLocalReadAddrA+0] offset:1408 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=51 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0+13], v[vgprLocalReadAddrA+0] offset:1424 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=52 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D1+13], v[vgprLocalReadAddrA+0] offset:1440 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=53 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D2+13], v[vgprLocalReadAddrA+0] offset:1456 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=54 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D3+13], v[vgprLocalReadAddrA+0] offset:1472 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=55 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0+14], v[vgprLocalReadAddrA+0] offset:1488 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=56 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D1+14], v[vgprLocalReadAddrA+0] offset:1504 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=57 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D2+14], v[vgprLocalReadAddrA+0] offset:1520 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=58 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D3+14], v[vgprLocalReadAddrA+0] offset:1536 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=59 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0+15], v[vgprLocalReadAddrA+0] offset:1552 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=60 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D1+15], v[vgprLocalReadAddrA+0] offset:1568 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=61 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D2+15], v[vgprLocalReadAddrA+0] offset:1584 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=62 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D3+15], v[vgprLocalReadAddrA+0] offset:1600 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=63 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_b64 v[vgprValuMetadata_X0_I0+0:vgprValuMetadata_X0_I0+0+1], v[vgprLocalReadAddrMetadata+0] offset:0 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_b128 v[vgprValuB_X0_I0+0:vgprValuB_X0_I0+0+3], v[vgprLocalReadAddrB+0] offset:0 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_b128 v[vgprValuB_X0_I0+4:vgprValuB_X0_I0+4+3], v[vgprLocalReadAddrB+0] offset:32 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS1
s_wait_dscnt 0                                     // Wait for dependent lr
/* pack scheduling: packAIdx:48, packBIdx:0, packMIdx:0 */
v_lshl_or_b32 v[vgprValuA_X0_I0+0], v[vgprValuA_X0_I0_D1+0], 8, v[vgprValuA_X0_I0+0] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+0], v[vgprValuA_X0_I0_D3+0], 8, v[vgprValuA_X0_I0_D2+0] // pack two int8 Vgpr to one half Vgpr
s_delay_alu instid0(VALU_DEP_1)
v_lshl_or_b32 v[vgprValuA_X0_I0+0], v[vgprValuA_X0_I0_D2+0], 0x10, v[vgprValuA_X0_I0+0] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+1], v[vgprValuA_X0_I0_D1+1], 8, v[vgprValuA_X0_I0+1] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+1], v[vgprValuA_X0_I0_D3+1], 8, v[vgprValuA_X0_I0_D2+1] // pack two int8 Vgpr to one half Vgpr
s_delay_alu instid0(VALU_DEP_1)
v_lshl_or_b32 v[vgprValuA_X0_I0+1], v[vgprValuA_X0_I0_D2+1], 0x10, v[vgprValuA_X0_I0+1] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+2], v[vgprValuA_X0_I0_D1+2], 8, v[vgprValuA_X0_I0+2] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+2], v[vgprValuA_X0_I0_D3+2], 8, v[vgprValuA_X0_I0_D2+2] // pack two int8 Vgpr to one half Vgpr
s_delay_alu instid0(VALU_DEP_1)
v_lshl_or_b32 v[vgprValuA_X0_I0+2], v[vgprValuA_X0_I0_D2+2], 0x10, v[vgprValuA_X0_I0+2] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+3], v[vgprValuA_X0_I0_D1+3], 8, v[vgprValuA_X0_I0+3] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+3], v[vgprValuA_X0_I0_D3+3], 8, v[vgprValuA_X0_I0_D2+3] // pack two int8 Vgpr to one half Vgpr
s_delay_alu instid0(VALU_DEP_1)
v_lshl_or_b32 v[vgprValuA_X0_I0+3], v[vgprValuA_X0_I0_D2+3], 0x10, v[vgprValuA_X0_I0+3] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+4], v[vgprValuA_X0_I0_D1+4], 8, v[vgprValuA_X0_I0+4] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+4], v[vgprValuA_X0_I0_D3+4], 8, v[vgprValuA_X0_I0_D2+4] // pack two int8 Vgpr to one half Vgpr
s_delay_alu instid0(VALU_DEP_1)
v_lshl_or_b32 v[vgprValuA_X0_I0+4], v[vgprValuA_X0_I0_D2+4], 0x10, v[vgprValuA_X0_I0+4] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+5], v[vgprValuA_X0_I0_D1+5], 8, v[vgprValuA_X0_I0+5] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+5], v[vgprValuA_X0_I0_D3+5], 8, v[vgprValuA_X0_I0_D2+5] // pack two int8 Vgpr to one half Vgpr
s_delay_alu instid0(VALU_DEP_1)
v_lshl_or_b32 v[vgprValuA_X0_I0+5], v[vgprValuA_X0_I0_D2+5], 0x10, v[vgprValuA_X0_I0+5] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+6], v[vgprValuA_X0_I0_D1+6], 8, v[vgprValuA_X0_I0+6] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+6], v[vgprValuA_X0_I0_D3+6], 8, v[vgprValuA_X0_I0_D2+6] // pack two int8 Vgpr to one half Vgpr
s_delay_alu instid0(VALU_DEP_1)
v_lshl_or_b32 v[vgprValuA_X0_I0+6], v[vgprValuA_X0_I0_D2+6], 0x10, v[vgprValuA_X0_I0+6] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+7], v[vgprValuA_X0_I0_D1+7], 8, v[vgprValuA_X0_I0+7] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+7], v[vgprValuA_X0_I0_D3+7], 8, v[vgprValuA_X0_I0_D2+7] // pack two int8 Vgpr to one half Vgpr
s_delay_alu instid0(VALU_DEP_1)
v_lshl_or_b32 v[vgprValuA_X0_I0+7], v[vgprValuA_X0_I0_D2+7], 0x10, v[vgprValuA_X0_I0+7] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+8], v[vgprValuA_X0_I0_D1+8], 8, v[vgprValuA_X0_I0+8] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+8], v[vgprValuA_X0_I0_D3+8], 8, v[vgprValuA_X0_I0_D2+8] // pack two int8 Vgpr to one half Vgpr
s_delay_alu instid0(VALU_DEP_1)
v_lshl_or_b32 v[vgprValuA_X0_I0+8], v[vgprValuA_X0_I0_D2+8], 0x10, v[vgprValuA_X0_I0+8] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+9], v[vgprValuA_X0_I0_D1+9], 8, v[vgprValuA_X0_I0+9] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+9], v[vgprValuA_X0_I0_D3+9], 8, v[vgprValuA_X0_I0_D2+9] // pack two int8 Vgpr to one half Vgpr
s_delay_alu instid0(VALU_DEP_1)
v_lshl_or_b32 v[vgprValuA_X0_I0+9], v[vgprValuA_X0_I0_D2+9], 0x10, v[vgprValuA_X0_I0+9] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+10], v[vgprValuA_X0_I0_D1+10], 8, v[vgprValuA_X0_I0+10] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+10], v[vgprValuA_X0_I0_D3+10], 8, v[vgprValuA_X0_I0_D2+10] // pack two int8 Vgpr to one half Vgpr
s_delay_alu instid0(VALU_DEP_1)
v_lshl_or_b32 v[vgprValuA_X0_I0+10], v[vgprValuA_X0_I0_D2+10], 0x10, v[vgprValuA_X0_I0+10] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+11], v[vgprValuA_X0_I0_D1+11], 8, v[vgprValuA_X0_I0+11] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+11], v[vgprValuA_X0_I0_D3+11], 8, v[vgprValuA_X0_I0_D2+11] // pack two int8 Vgpr to one half Vgpr
s_delay_alu instid0(VALU_DEP_1)
v_lshl_or_b32 v[vgprValuA_X0_I0+11], v[vgprValuA_X0_I0_D2+11], 0x10, v[vgprValuA_X0_I0+11] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+12], v[vgprValuA_X0_I0_D1+12], 8, v[vgprValuA_X0_I0+12] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+12], v[vgprValuA_X0_I0_D3+12], 8, v[vgprValuA_X0_I0_D2+12] // pack two int8 Vgpr to one half Vgpr
s_delay_alu instid0(VALU_DEP_1)
v_lshl_or_b32 v[vgprValuA_X0_I0+12], v[vgprValuA_X0_I0_D2+12], 0x10, v[vgprValuA_X0_I0+12] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+13], v[vgprValuA_X0_I0_D1+13], 8, v[vgprValuA_X0_I0+13] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+13], v[vgprValuA_X0_I0_D3+13], 8, v[vgprValuA_X0_I0_D2+13] // pack two int8 Vgpr to one half Vgpr
s_delay_alu instid0(VALU_DEP_1)
v_lshl_or_b32 v[vgprValuA_X0_I0+13], v[vgprValuA_X0_I0_D2+13], 0x10, v[vgprValuA_X0_I0+13] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+14], v[vgprValuA_X0_I0_D1+14], 8, v[vgprValuA_X0_I0+14] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+14], v[vgprValuA_X0_I0_D3+14], 8, v[vgprValuA_X0_I0_D2+14] // pack two int8 Vgpr to one half Vgpr
s_delay_alu instid0(VALU_DEP_1)
v_lshl_or_b32 v[vgprValuA_X0_I0+14], v[vgprValuA_X0_I0_D2+14], 0x10, v[vgprValuA_X0_I0+14] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+15], v[vgprValuA_X0_I0_D1+15], 8, v[vgprValuA_X0_I0+15] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+15], v[vgprValuA_X0_I0_D3+15], 8, v[vgprValuA_X0_I0_D2+15] // pack two int8 Vgpr to one half Vgpr
s_delay_alu instid0(VALU_DEP_1)
v_lshl_or_b32 v[vgprValuA_X0_I0+15], v[vgprValuA_X0_I0_D2+15], 0x10, v[vgprValuA_X0_I0+15] // pack two half Vgpr to one Vgpr
/* pack scheduling: curPackIdx:48, numPack:48, instPackLast:['A', 'A'] */
s_nop 1                                            // VALU packing writes to be consumed by matrix instruction
v_swmmac_f32_16x16x128_fp8_fp8 v[vgprValuC+0:vgprValuC+0+7], v[vgprValuB_X0_I0+0+0+0:vgprValuB_X0_I0+0+0+0+7], v[vgprValuA_X0_I0+0+0+0:vgprValuA_X0_I0+0+0+0+15], v[vgprValuMetadata_X0_I0+0+0+0:vgprValuMetadata_X0_I0+0+0+0+1] // left value = v[0+0:7+0]
/* numPrefetchIter=0 */
/* dataAtIterA=0 numReadsIterA=1 skipReadsIterA=0 readsPerIterA=64 */
/* dataAtIterB=0 numReadsIterB=1 skipReadsIterB=0 readsPerIterB=2 */
/* dataAtIterMetadata=0 numReadsIterMetadata=1 skipReadsIterMetadata=0 readsPerIterMetadata=1 */
label_toPGR1end_OptNLL:
/* Stores for OptNLL */
label_Summation_End_OptNLL:
/* endSummation: add vgpr [8...126) to pool */
/* load store sgprs */
.set sgprAddressScaleAlphaVec, 60
.set sgprAddressBias, 62
.set sgprBiasType, 64
.set sgprBiasStride, 65
.set sgprFactorDim, 66
.set sgpractivationAlpha, 67
.set sgpractivationBeta, 68
.set sgprActivationType, 69
/* Check if custom structure pointer is null */
s_cmp_eq_u32 s[sgprArgType], 2                     // ArgType == 2 ?
s_cbranch_scc1 label_LoadExternalEpilogueStruct    // branch if ArgType == 2
s_load_b256 s[60:67], s[sgprKernArgAddress:sgprKernArgAddress+1], 104 // 104
s_load_b64 s[68:69], s[sgprKernArgAddress:sgprKernArgAddress+1], 136 // 136
s_branch label_LoadExternalEpilogueStructEnd
label_LoadExternalEpilogueStruct:
s_load_b128 s[60:63], s[sgprKernArgAddress:sgprKernArgAddress+1], 160 // 160
s_load_b64 s[64:65], s[sgprKernArgAddress:sgprKernArgAddress+1], 176 // 176
s_load_b32 s66, s[sgprKernArgAddress:sgprKernArgAddress+1], 184 // 184
s_load_b32 s67, s[sgprKernArgAddress:sgprKernArgAddress+1], 204 // 204
s_load_b64 s[68:69], s[sgprKernArgAddress:sgprKernArgAddress+1], 208 // 208
label_LoadExternalEpilogueStructEnd:
.set sgprSrdScaleAlphaVec, 24
.set sgprSrdBias, 28

/* Mapping of Acc register -> C Vgpr register */

/* Multiply MI out register with Alpha -> C Vgpr register */
/* computeStoreVgprs */
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_lshrrev_b32 v12, 5, v[vgprSerial]                // 12 = Serial / 32
v_lshrrev_b32 v13, 0, v12                          // 13 = 12 / 1
v_mul_lo_u32 v13, 0x10, v13                        // wave coordination offset 1
v_and_b32 v9, 31, v[vgprSerial]                    // v9 = v[vgprSerial] % 32
v_lshrrev_b32 v9, 4, v9                            // 9 = 9 / 16
v_lshlrev_b32 v9, 3, v9                            // thread0 * continuous_output
v_add_lshl_u32 v9, v13, v9, 0                      // coordination 1 = vwB *(wave_id1 + tid1)
v_mul_lo_u32 v10, v9, s[sgprStrideC1J]             //  offset 1
v_mul_lo_u32 v11, v9, s[sgprStrideD1J]             //  offset 1
v_and_b32 v8, 0, v12                               // v8 = v12 % 1
v_mul_lo_u32 v8, 0x10, v8                          // wave coordination offset 0
v_and_b32 v13, 15, v[vgprSerial]                   // v13 = v[vgprSerial] % 16
s_delay_alu instid0(VALU_DEP_1)
v_add_lshl_u32 v8, v13, v8, 0                      // coordination 0 = vwA * (wave_id0 + tid0)
s_mul_i32 s8, 16, s[sgprWorkGroup0]                // wgp0 * MT0
s_delay_alu instid0(NO_DEP)
v_add_nc_u32 v8, s8, v8                            // coord 0 = (tid0/MI_m)*4 + waveG0*MIB_m + MT0*SG0
s_mul_i32 s8, 16, s[sgprWorkGroup1]                // wgp1 * MT1
s_delay_alu instid0(NO_DEP)
v_add_nc_u32 v9, s8, v9                            // coord 1 = (tid0%MI_m) + waveG1*MIB_n + MT1*SG1

/******************************************/
/* Global Write Elements                  */
/******************************************/
s_wait_kmcnt 0                                     // wait for 40 bytes of kern args.
s_mov_b32 s11, 0
s_cmp_eq_u32 s[sgprFactorDim], s11                 // FactorDim == 0
s_cselect_b32 s8, s[sgprSizeI], s[sgprSizeJ]
s_mov_b64 s[sgprSrdScaleAlphaVec+0:sgprSrdScaleAlphaVec+0+1], s[sgprAddressScaleAlphaVec+0:sgprAddressScaleAlphaVec+0+1] // init SRD base address
s_mov_b32 s[sgprSrdScaleAlphaVec+3], Srd127_96     // Set bits 127_96 in post-loop SRD
s_cmp_eq_u64 s[sgprAddressScaleAlphaVec+0:sgprAddressScaleAlphaVec+0+1], 0 // AddressScaleAlphaVec == 0 (null) ?
s_cselect_b32 s[sgprSrdScaleAlphaVec+2], 0, s8     // num_records = (Address == 0) ? 0 : len

s_mul_i32 s[sgprSrdScaleAlphaVec+2], 0x4, s[sgprSrdScaleAlphaVec+2] // ScaleAlphaVec scaled by BPE
s_add_u32 s8, s[sgprWorkGroup2], 0x1
s_mul_i32 s8, s[sgprBiasStride], s8                // stride * (wg+1)
s_delay_alu instid0(SALU_CYCLE_1)
s_cmp_eq_u32 s8, 0                                 // bias stride = 0?
s_cbranch_scc0 label_Dont_Set_BiasStride
s_mov_b32 s11, 0
s_cmp_eq_u32 s[sgprFactorDim], s11                 // FactorDim == 0
s_cselect_b32 s8, s[sgprSizeI], s[sgprSizeJ]
label_Dont_Set_BiasStride:
s_mov_b64 s[sgprSrdBias+0:sgprSrdBias+0+1], s[sgprAddressBias+0:sgprAddressBias+0+1] // init SRD base address
s_mov_b32 s[sgprSrdBias+3], Srd127_96              // Set bits 127_96 in post-loop SRD
s_cmp_eq_u64 s[sgprAddressBias+0:sgprAddressBias+0+1], 0 // AddressBias == 0 (null) ?
s_cselect_b32 s[sgprSrdBias+2], 0, s8              // num_records = (Address == 0) ? 0 : len

label_Load_FactorDim_0:
s_mov_b32 s8, 0
s_cmp_lg_u32 s[sgprFactorDim], s8                  // FactorDim != 0
s_cbranch_scc1 label_Load_FactorDim_1              // Branch if true
label_Load_Biasf32_0:
s_mov_b32 s8, 0
s_cmp_lg_u32 s[sgprBiasType], s8                   // BiasType != 0
s_cbranch_scc1 label_Load_Biasbf16_0               // Branch if true

/******************************************/
/* Read vector to LDS                     */
/******************************************/
s_mul_i32 s8, 16, s[sgprWorkGroup0]                // wgp0 * MT0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_add_nc_u32 v16, s8, v[vgprSerial]                // coord 0 = wgp0 * MT0 + thread offset
s_mul_i32 s[sgprSrdBias+2], 0x4, s[sgprSrdBias+2]  // scaled by BPE
// Shift num records for gfx125x
s_and_b32 s8, s[sgprSrdBias+2], 127
s_delay_alu instid0(SALU_CYCLE_1)
s_lshl_b32 s8, s8, 25
s_and_b32 s[sgprSrdBias+1], s[sgprSrdBias+1], 33554431
s_delay_alu instid0(SALU_CYCLE_1)
s_or_b32 s[sgprSrdBias+1], s[sgprSrdBias+1], s8
s_lshr_b32 s[sgprSrdBias+2], s[sgprSrdBias+2], 7
s_mul_i32 s8, s[sgprBiasStride], s[sgprWorkGroup2] // Stride * WG
s_delay_alu instid0(NO_DEP)
v_add_nc_u32 v14, s8, v16                          // coord 0 = wgp0 * MT0 + thread offset + Stride * WG
s_delay_alu instid0(VALU_DEP_1)
v_lshlrev_b32 v14, 0x2, v14                        // Global bias address scaled by BPE
s_delay_alu instid0(VALU_DEP_3)
v_lshlrev_b32 v15, 0x2, v16                        // Global scaleAlpha address scaled by BPE
s_mul_i32 s8, 16, s[sgprWorkGroup1]                // wgp1 * MT1
v_add_nc_u32 v16, s8, v[vgprSerial]                // coord 1 = wgp1 * MT1 + thread offset
buffer_load_b32 v12, v14, s[sgprSrdBias:sgprSrdBias+3], null offen offset:0 // Load Bias
buffer_load_b32 v13, v15, s[sgprSrdScaleAlphaVec:sgprSrdScaleAlphaVec+3], null offen offset:0 // Load ScaleAlphaVec
v_lshlrev_b32 v16, 0x2, v[vgprSerial]              // Local address scaled by BPE
s_barrier_signal -1
s_barrier_wait -1                                  // wait for all global loads.
s_wait_loadcnt 1                                   // wait for global load
ds_store_b32 v16, v12 offset:0                     // store bias
v_cmp_gt_u32 s[sgprAddressScaleAlphaVec], s[sgprSrdScaleAlphaVec+2], 0 //  == 0 ?
s_wait_loadcnt 0                                   // wait for global load
v_cndmask_b32 v13, 1.0, v13, s[sgprAddressScaleAlphaVec] // 1. mul 1 if 0
ds_store_b32 v16, v13 offset:128                   // store scaleAlpha
s_branch label_Load_Bias_End                       // Branch to load bias end
label_Load_Biasbf16_0:
s_mov_b32 s8, 7
s_cmp_lg_u32 s[sgprBiasType], s8                   // BiasType != 7
s_cbranch_scc1 label_Load_Bias_End                 // Branch if true

/******************************************/
/* Read vector to LDS                     */
/******************************************/
s_mul_i32 s8, 16, s[sgprWorkGroup0]                // wgp0 * MT0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_add_nc_u32 v16, s8, v[vgprSerial]                // coord 0 = wgp0 * MT0 + thread offset
s_mul_i32 s[sgprSrdBias+2], 0x2, s[sgprSrdBias+2]  // scaled by BPE
// Shift num records for gfx125x
s_and_b32 s8, s[sgprSrdBias+2], 127
s_delay_alu instid0(SALU_CYCLE_1)
s_lshl_b32 s8, s8, 25
s_and_b32 s[sgprSrdBias+1], s[sgprSrdBias+1], 33554431
s_delay_alu instid0(SALU_CYCLE_1)
s_or_b32 s[sgprSrdBias+1], s[sgprSrdBias+1], s8
s_lshr_b32 s[sgprSrdBias+2], s[sgprSrdBias+2], 7
s_mul_i32 s8, s[sgprBiasStride], s[sgprWorkGroup2] // Stride * WG
s_delay_alu instid0(NO_DEP)
v_add_nc_u32 v14, s8, v16                          // coord 0 = wgp0 * MT0 + thread offset + Stride * WG
s_delay_alu instid0(VALU_DEP_1)
v_lshlrev_b32 v14, 0x1, v14                        // Global bias address scaled by BPE
s_delay_alu instid0(VALU_DEP_3)
v_lshlrev_b32 v15, 0x2, v16                        // Global scaleAlpha address scaled by BPE
s_mul_i32 s8, 16, s[sgprWorkGroup1]                // wgp1 * MT1
v_add_nc_u32 v16, s8, v[vgprSerial]                // coord 1 = wgp1 * MT1 + thread offset
buffer_load_d16_b16 v12, v14, s[sgprSrdBias:sgprSrdBias+3], null offen offset:0 // Load Bias
buffer_load_b32 v13, v15, s[sgprSrdScaleAlphaVec:sgprSrdScaleAlphaVec+3], null offen offset:0 // Load ScaleAlphaVec
v_lshlrev_b32 v16, 0x2, v[vgprSerial]              // Local address scaled by BPE
s_barrier_signal -1
s_barrier_wait -1                                  // wait for all global loads.
s_wait_loadcnt 1                                   // wait for global load
v_cvt_f32_bf16 v12, v12.l op_sel:[0]               // cvt bf16 to f32
ds_store_b32 v16, v12 offset:0                     // store bias
v_cmp_gt_u32 s[sgprAddressScaleAlphaVec], s[sgprSrdScaleAlphaVec+2], 0 //  == 0 ?
s_wait_loadcnt 0                                   // wait for global load
v_cndmask_b32 v13, 1.0, v13, s[sgprAddressScaleAlphaVec] // 1. mul 1 if 0
ds_store_b32 v16, v13 offset:128                   // store scaleAlpha
s_branch label_Load_Bias_End                       // Branch to load bias end
label_Load_FactorDim_1:
label_Load_Biasf32_1:
s_mov_b32 s8, 0
s_cmp_lg_u32 s[sgprBiasType], s8                   // BiasType != 0
s_cbranch_scc1 label_Load_Biasbf16_1               // Branch if true

/******************************************/
/* Read vector to LDS                     */
/******************************************/
s_mul_i32 s8, 16, s[sgprWorkGroup1]                // wgp1 * MT1
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_add_nc_u32 v16, s8, v[vgprSerial]                // coord 1 = wgp1 * MT1 + thread offset
s_mul_i32 s[sgprSrdBias+2], 0x4, s[sgprSrdBias+2]  // scaled by BPE
// Shift num records for gfx125x
s_and_b32 s8, s[sgprSrdBias+2], 127
s_delay_alu instid0(SALU_CYCLE_1)
s_lshl_b32 s8, s8, 25
s_and_b32 s[sgprSrdBias+1], s[sgprSrdBias+1], 33554431
s_delay_alu instid0(SALU_CYCLE_1)
s_or_b32 s[sgprSrdBias+1], s[sgprSrdBias+1], s8
s_lshr_b32 s[sgprSrdBias+2], s[sgprSrdBias+2], 7
s_mul_i32 s8, s[sgprBiasStride], s[sgprWorkGroup2] // Stride * WG
s_delay_alu instid0(NO_DEP)
v_add_nc_u32 v14, s8, v16                          // coord 1 = wgp1 * MT1 + thread offset + Stride * WG
s_delay_alu instid0(VALU_DEP_1)
v_lshlrev_b32 v14, 0x2, v14                        // Global bias address scaled by BPE
s_delay_alu instid0(VALU_DEP_3)
v_lshlrev_b32 v15, 0x2, v16                        // Global scaleAlpha address scaled by BPE
s_mul_i32 s8, 16, s[sgprWorkGroup0]                // wgp0 * MT0
v_add_nc_u32 v16, s8, v[vgprSerial]                // coord 0 = wgp0 * MT0 + thread offset
buffer_load_b32 v12, v14, s[sgprSrdBias:sgprSrdBias+3], null offen offset:0 // Load Bias
buffer_load_b32 v13, v15, s[sgprSrdScaleAlphaVec:sgprSrdScaleAlphaVec+3], null offen offset:0 // Load ScaleAlphaVec
v_lshlrev_b32 v16, 0x2, v[vgprSerial]              // Local address scaled by BPE
s_barrier_signal -1
s_barrier_wait -1                                  // wait for all global loads.
s_wait_loadcnt 1                                   // wait for global load
ds_store_b32 v16, v12 offset:0                     // store bias
v_cmp_gt_u32 s[sgprAddressScaleAlphaVec], s[sgprSrdScaleAlphaVec+2], 0 //  == 0 ?
s_wait_loadcnt 0                                   // wait for global load
v_cndmask_b32 v13, 1.0, v13, s[sgprAddressScaleAlphaVec] // 1. mul 1 if 0
ds_store_b32 v16, v13 offset:128                   // store scaleAlpha
s_branch label_Load_Bias_End                       // Branch to load bias end
label_Load_Biasbf16_1:
s_mov_b32 s8, 7
s_cmp_lg_u32 s[sgprBiasType], s8                   // BiasType != 7
s_cbranch_scc1 label_Load_Bias_End                 // Branch if true

/******************************************/
/* Read vector to LDS                     */
/******************************************/
s_mul_i32 s8, 16, s[sgprWorkGroup1]                // wgp1 * MT1
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_add_nc_u32 v16, s8, v[vgprSerial]                // coord 1 = wgp1 * MT1 + thread offset
s_mul_i32 s[sgprSrdBias+2], 0x2, s[sgprSrdBias+2]  // scaled by BPE
// Shift num records for gfx125x
s_and_b32 s8, s[sgprSrdBias+2], 127
s_delay_alu instid0(SALU_CYCLE_1)
s_lshl_b32 s8, s8, 25
s_and_b32 s[sgprSrdBias+1], s[sgprSrdBias+1], 33554431
s_delay_alu instid0(SALU_CYCLE_1)
s_or_b32 s[sgprSrdBias+1], s[sgprSrdBias+1], s8
s_lshr_b32 s[sgprSrdBias+2], s[sgprSrdBias+2], 7
s_mul_i32 s8, s[sgprBiasStride], s[sgprWorkGroup2] // Stride * WG
s_delay_alu instid0(NO_DEP)
v_add_nc_u32 v14, s8, v16                          // coord 1 = wgp1 * MT1 + thread offset + Stride * WG
s_delay_alu instid0(VALU_DEP_1)
v_lshlrev_b32 v14, 0x1, v14                        // Global bias address scaled by BPE
s_delay_alu instid0(VALU_DEP_3)
v_lshlrev_b32 v15, 0x2, v16                        // Global scaleAlpha address scaled by BPE
s_mul_i32 s8, 16, s[sgprWorkGroup0]                // wgp0 * MT0
v_add_nc_u32 v16, s8, v[vgprSerial]                // coord 0 = wgp0 * MT0 + thread offset
buffer_load_d16_b16 v12, v14, s[sgprSrdBias:sgprSrdBias+3], null offen offset:0 // Load Bias
buffer_load_b32 v13, v15, s[sgprSrdScaleAlphaVec:sgprSrdScaleAlphaVec+3], null offen offset:0 // Load ScaleAlphaVec
v_lshlrev_b32 v16, 0x2, v[vgprSerial]              // Local address scaled by BPE
s_barrier_signal -1
s_barrier_wait -1                                  // wait for all global loads.
s_wait_loadcnt 1                                   // wait for global load
v_cvt_f32_bf16 v12, v12.l op_sel:[0]               // cvt bf16 to f32
ds_store_b32 v16, v12 offset:0                     // store bias
v_cmp_gt_u32 s[sgprAddressScaleAlphaVec], s[sgprSrdScaleAlphaVec+2], 0 //  == 0 ?
s_wait_loadcnt 0                                   // wait for global load
v_cndmask_b32 v13, 1.0, v13, s[sgprAddressScaleAlphaVec] // 1. mul 1 if 0
ds_store_b32 v16, v13 offset:128                   // store scaleAlpha
s_branch label_Load_Bias_End                       // Branch to load bias end
label_Load_Bias_End:
.set sgprAddressScaleAlphaVec, UNDEF
.set sgprSrdScaleAlphaVec, UNDEF
s_mov_b32 s8, 1
s_cmp_eq_u32 s[sgprActivationType], s8             // activationType == 1
s_cbranch_scc1 label_To_Activation_Abs_VW1         // Branch if true
s_mov_b32 s8, 2
s_cmp_eq_u32 s[sgprActivationType], s8             // activationType == 2
s_cbranch_scc1 label_To_Activation_Clippedrelu_VW1 // Branch if true
s_mov_b32 s8, 3
s_cmp_eq_u32 s[sgprActivationType], s8             // activationType == 3
s_cbranch_scc1 label_To_Activation_Gelu_VW1        // Branch if true
s_mov_b32 s8, 4
s_cmp_eq_u32 s[sgprActivationType], s8             // activationType == 4
s_cbranch_scc1 label_To_Activation_Leakyrelu_VW1   // Branch if true
s_mov_b32 s8, 5
s_cmp_eq_u32 s[sgprActivationType], s8             // activationType == 5
s_cbranch_scc1 label_To_Activation_Relu_VW1        // Branch if true
s_mov_b32 s8, 6
s_cmp_eq_u32 s[sgprActivationType], s8             // activationType == 6
s_cbranch_scc1 label_To_Activation_Sigmoid_VW1     // Branch if true
s_mov_b32 s8, 7
s_cmp_eq_u32 s[sgprActivationType], s8             // activationType == 7
s_cbranch_scc1 label_To_Activation_Tanh_VW1        // Branch if true
s_mov_b32 s8, 10
s_cmp_eq_u32 s[sgprActivationType], s8             // activationType == 10
s_cbranch_scc1 label_To_Activation_Geluscaling_VW1 // Branch if true
s_mov_b32 s8, 11
s_cmp_eq_u32 s[sgprActivationType], s8             // activationType == 11
s_cbranch_scc1 label_To_Activation_Silu_VW1        // Branch if true
s_mov_b32 s8, 12
s_cmp_eq_u32 s[sgprActivationType], s8             // activationType == 12
s_cbranch_scc1 label_To_Activation_Swish_VW1       // Branch if true
s_mov_b32 s8, 13
s_cmp_eq_u32 s[sgprActivationType], s8             // activationType == 13
s_cbranch_scc1 label_To_Activation_Clamp_VW1       // Branch if true
label_To_Activation_None_VW1:
s_getpc_b64 s[12:13]                               // addr of next instr
s_add_i32 s8, label_Activation_None_VW1, 4         // target branch offset
s_add_u32 s12, s12, s8                             // add target branch offset
s_addc_u32 s13, s13, 0                             // add high and carry
s_branch label_ActivationSetPCAddrEnd
label_To_Activation_Abs_VW1:
s_getpc_b64 s[12:13]                               // addr of next instr
s_add_i32 s8, label_Activation_Abs_VW1, 4          // target branch offset
s_delay_alu instid0(SALU_CYCLE_1)
s_add_u32 s12, s12, s8                             // add target branch offset
s_addc_u32 s13, s13, 0                             // add high and carry
s_branch label_ActivationSetPCAddrEnd
label_To_Activation_Clippedrelu_VW1:
s_getpc_b64 s[12:13]                               // addr of next instr
s_add_i32 s8, label_Activation_Clippedrelu_VW1, 4  // target branch offset
s_delay_alu instid0(SALU_CYCLE_1)
s_add_u32 s12, s12, s8                             // add target branch offset
s_addc_u32 s13, s13, 0                             // add high and carry
s_branch label_ActivationSetPCAddrEnd
label_To_Activation_Gelu_VW1:
s_getpc_b64 s[12:13]                               // addr of next instr
s_add_i32 s8, label_Activation_Gelu_VW1, 4         // target branch offset
s_delay_alu instid0(SALU_CYCLE_1)
s_add_u32 s12, s12, s8                             // add target branch offset
s_addc_u32 s13, s13, 0                             // add high and carry
s_branch label_ActivationSetPCAddrEnd
label_To_Activation_Leakyrelu_VW1:
s_getpc_b64 s[12:13]                               // addr of next instr
s_add_i32 s8, label_Activation_Leakyrelu_VW1, 4    // target branch offset
s_delay_alu instid0(SALU_CYCLE_1)
s_add_u32 s12, s12, s8                             // add target branch offset
s_addc_u32 s13, s13, 0                             // add high and carry
s_branch label_ActivationSetPCAddrEnd
label_To_Activation_Relu_VW1:
s_getpc_b64 s[12:13]                               // addr of next instr
s_add_i32 s8, label_Activation_Relu_VW1, 4         // target branch offset
s_delay_alu instid0(SALU_CYCLE_1)
s_add_u32 s12, s12, s8                             // add target branch offset
s_addc_u32 s13, s13, 0                             // add high and carry
s_branch label_ActivationSetPCAddrEnd
label_To_Activation_Sigmoid_VW1:
s_getpc_b64 s[12:13]                               // addr of next instr
s_add_i32 s8, label_Activation_Sigmoid_VW1, 4      // target branch offset
s_delay_alu instid0(SALU_CYCLE_1)
s_add_u32 s12, s12, s8                             // add target branch offset
s_addc_u32 s13, s13, 0                             // add high and carry
s_branch label_ActivationSetPCAddrEnd
label_To_Activation_Tanh_VW1:
s_getpc_b64 s[12:13]                               // addr of next instr
s_add_i32 s8, label_Activation_Tanh_VW1, 4         // target branch offset
s_delay_alu instid0(SALU_CYCLE_1)
s_add_u32 s12, s12, s8                             // add target branch offset
s_addc_u32 s13, s13, 0                             // add high and carry
s_branch label_ActivationSetPCAddrEnd
label_To_Activation_Geluscaling_VW1:
s_getpc_b64 s[12:13]                               // addr of next instr
s_add_i32 s8, label_Activation_Geluscaling_VW1, 4  // target branch offset
s_delay_alu instid0(SALU_CYCLE_1)
s_add_u32 s12, s12, s8                             // add target branch offset
s_addc_u32 s13, s13, 0                             // add high and carry
s_branch label_ActivationSetPCAddrEnd
label_To_Activation_Silu_VW1:
s_getpc_b64 s[12:13]                               // addr of next instr
s_add_i32 s8, label_Activation_Silu_VW1, 4         // target branch offset
s_delay_alu instid0(SALU_CYCLE_1)
s_add_u32 s12, s12, s8                             // add target branch offset
s_addc_u32 s13, s13, 0                             // add high and carry
s_branch label_ActivationSetPCAddrEnd
label_To_Activation_Swish_VW1:
s_getpc_b64 s[12:13]                               // addr of next instr
s_add_i32 s8, label_Activation_Swish_VW1, 4        // target branch offset
s_delay_alu instid0(SALU_CYCLE_1)
s_add_u32 s12, s12, s8                             // add target branch offset
s_addc_u32 s13, s13, 0                             // add high and carry
s_branch label_ActivationSetPCAddrEnd
label_To_Activation_Clamp_VW1:
s_getpc_b64 s[12:13]                               // addr of next instr
s_add_i32 s8, label_Activation_Clamp_VW1, 4        // target branch offset
s_delay_alu instid0(SALU_CYCLE_1)
s_add_u32 s12, s12, s8                             // add target branch offset
s_addc_u32 s13, s13, 0                             // add high and carry
s_branch label_ActivationSetPCAddrEnd
label_ActivationSetPCAddrEnd:
label_GW_B0_OptNLL_MB:
s_mov_b32 s8, 0
s_cmp_eq_u32 s[sgprFactorDim], s8                  // FactorDim == 0
s_cbranch_scc0 label_GW_B0_FD1_OptNLL_MB           // Branch if FactorDim is not zero

label_GW_B0_FD0_OptNLL_MB:
label_GW_B0_FD0_VW1_OptNLL_MB_Then:

/* edge=0, allocate 1 sgpr. perBatchTmpS=1 perBatchMaskS=0 perElementMaskS=0 elementsPerBatch=76 */
/* optSingleColVgpr=1 optSharedColVgpr=0 optSGPRUsage=BufferLoad_Mask optSrdIncForRow=1 factorDim=0 */

/******************************************/
/* Global Write Batch #0 (d1,d0,vc1,vc0) = */
/*    (0,0,0,0:vw1); (0,0,1,0:vw1); (0,0,2,0:vw1); (0,0,3,0:vw1); (0,0,4,0:vw1); (0,0,5,0:vw1); (0,0,6,0:vw1); (0,0,7,0:vw1) */
/******************************************/

/* calc coords, apply mask, and issue loads (if necessary) */
/* (d1,vc1,d0,vc0)=(0,0,0,0) */
s_mul_i32 s8, 16, s[sgprWorkGroup0]                // wgp0 * MT0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_sub_nc_u32 v21, v8, s8
s_delay_alu instid0(VALU_DEP_1)
v_lshlrev_b32 v21, 0x2, v21                        // Bias address scaled by BPE
s_wait_dscnt 0                                     // Wait for LDS write
s_barrier_signal -1
s_barrier_wait -1                                  // LDS write barrier
ds_load_b32 v30, v21 offset:0                      // load Bias
ds_load_b32 v31, v21 offset:128                    // load scaleAlpha
/* (d1,vc1,d0,vc0)=(0,1,0,0) */
/* (d1,vc1,d0,vc0)=(0,2,0,0) */
/* (d1,vc1,d0,vc0)=(0,3,0,0) */
/* (d1,vc1,d0,vc0)=(0,4,0,0) */
/* (d1,vc1,d0,vc0)=(0,5,0,0) */
/* (d1,vc1,d0,vc0)=(0,6,0,0) */
/* (d1,vc1,d0,vc0)=(0,7,0,0) */
v_add_lshl_u32 v19, v11, v8, 1                     // optSingleColVgpr scaleToBpe: sharedAddrVgpr <- cinRowPtr + coord0, scaled by BPE. BSHERE:coord0=8, coord0Vgpr=8 (multiple bpe)
v_mov_b32 v[vgprValuC+22], v[vgprValuC+0]          // copy MI out reg to vreg[0]
v_mov_b32 v[vgprValuC+23], v[vgprValuC+1]          // copy MI out reg to vreg[1]
v_mov_b32 v[vgprValuC+24], v[vgprValuC+2]          // copy MI out reg to vreg[2]
v_mov_b32 v[vgprValuC+25], v[vgprValuC+3]          // copy MI out reg to vreg[3]
v_mov_b32 v[vgprValuC+26], v[vgprValuC+4]          // copy MI out reg to vreg[4]
v_mov_b32 v[vgprValuC+27], v[vgprValuC+5]          // copy MI out reg to vreg[5]
v_mov_b32 v[vgprValuC+28], v[vgprValuC+6]          // copy MI out reg to vreg[6]
v_mov_b32 v[vgprValuC+29], v[vgprValuC+7]          // copy MI out reg to vreg[7]

/* apply mask, calc new C and issue writes */
v_mov_b32 v16, 0xffff0000                          // mask for pack two bfloat16 element to 32bit
v_mov_b32 v17, 0x7fff0000                          // fp32 Nan
v_mov_b32 v18, 0x7fff                              // rounding bias for bfloat16

s_wait_dscnt 0                                     // dscnt(0) = 2 - 1 (bias) - 1 (scaleAlphaVec) (interleaved)
v_mul_f32 v[vgprValuC+22], v31, v[vgprValuC+22]    // *= ScaleAlphaVecVMul
v_add_f32 v12, v30, v[vgprValuC+22]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v22, v12
v_cvt_pk_bf16_f32 v22, v[vgprValuC+22], v[vgprValuC+22] // convert C to bf16 in gwvw==1
buffer_store_b16 v22, v19, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_mul_f32 v[vgprValuC+23], v31, v[vgprValuC+23]    // *= ScaleAlphaVecVMul
v_add_f32 v12, v30, v[vgprValuC+23]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v23, v12
v_cvt_pk_bf16_f32 v23, v[vgprValuC+23], v[vgprValuC+23] // convert C to bf16 in gwvw==1
s_lshl_b32 s8, s[sgprStrideD1J], 1                 // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s8         // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_store_b16 v23, v19, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_mul_f32 v[vgprValuC+24], v31, v[vgprValuC+24]    // *= ScaleAlphaVecVMul
v_add_f32 v12, v30, v[vgprValuC+24]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v24, v12
v_cvt_pk_bf16_f32 v24, v[vgprValuC+24], v[vgprValuC+24] // convert C to bf16 in gwvw==1
s_lshl_b32 s8, s[sgprStrideD1J], 1                 // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s8         // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_store_b16 v24, v19, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_mul_f32 v[vgprValuC+25], v31, v[vgprValuC+25]    // *= ScaleAlphaVecVMul
v_add_f32 v12, v30, v[vgprValuC+25]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v25, v12
v_cvt_pk_bf16_f32 v25, v[vgprValuC+25], v[vgprValuC+25] // convert C to bf16 in gwvw==1
s_lshl_b32 s8, s[sgprStrideD1J], 1                 // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s8         // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_store_b16 v25, v19, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_mul_f32 v[vgprValuC+26], v31, v[vgprValuC+26]    // *= ScaleAlphaVecVMul
v_add_f32 v12, v30, v[vgprValuC+26]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v26, v12
v_cvt_pk_bf16_f32 v26, v[vgprValuC+26], v[vgprValuC+26] // convert C to bf16 in gwvw==1
s_lshl_b32 s8, s[sgprStrideD1J], 1                 // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s8         // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_store_b16 v26, v19, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_mul_f32 v[vgprValuC+27], v31, v[vgprValuC+27]    // *= ScaleAlphaVecVMul
v_add_f32 v12, v30, v[vgprValuC+27]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v27, v12
v_cvt_pk_bf16_f32 v27, v[vgprValuC+27], v[vgprValuC+27] // convert C to bf16 in gwvw==1
s_lshl_b32 s8, s[sgprStrideD1J], 1                 // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s8         // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_store_b16 v27, v19, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_mul_f32 v[vgprValuC+28], v31, v[vgprValuC+28]    // *= ScaleAlphaVecVMul
v_add_f32 v12, v30, v[vgprValuC+28]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v28, v12
v_cvt_pk_bf16_f32 v28, v[vgprValuC+28], v[vgprValuC+28] // convert C to bf16 in gwvw==1
s_lshl_b32 s8, s[sgprStrideD1J], 1                 // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s8         // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_store_b16 v28, v19, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_mul_f32 v[vgprValuC+29], v31, v[vgprValuC+29]    // *= ScaleAlphaVecVMul
v_add_f32 v12, v30, v[vgprValuC+29]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v29, v12
v_cvt_pk_bf16_f32 v29, v[vgprValuC+29], v[vgprValuC+29] // convert C to bf16 in gwvw==1
s_lshl_b32 s8, s[sgprStrideD1J], 1                 // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s8         // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_store_b16 v29, v19, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_nop 0                                            // 1 wait state required when next inst writes vgprs held by previous dwordx4 store inst
s_branch label_GW_End
label_GW_B0_FD1_OptNLL_MB:
label_GW_B0_FD1_VW1_OptNLL_MB_Then:

/* edge=0, allocate 1 sgpr. perBatchTmpS=1 perBatchMaskS=0 perElementMaskS=0 elementsPerBatch=76 */
/* optSingleColVgpr=1 optSharedColVgpr=0 optSGPRUsage=BufferLoad_Mask optSrdIncForRow=1 factorDim=1 */

/******************************************/
/* Global Write Batch #0 (d1,d0,vc1,vc0) = */
/*    (0,0,0,0:vw1); (0,0,1,0:vw1); (0,0,2,0:vw1); (0,0,3,0:vw1); (0,0,4,0:vw1); (0,0,5,0:vw1); (0,0,6,0:vw1); (0,0,7,0:vw1) */
/******************************************/

/* calc coords, apply mask, and issue loads (if necessary) */
/* (d1,vc1,d0,vc0)=(0,0,0,0) */
s_mul_i32 s8, 16, s[sgprWorkGroup1]                // wgp1 * MT1
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_sub_nc_u32 v21, v9, s8
s_delay_alu instid0(VALU_DEP_1)
v_lshlrev_b32 v21, 0x2, v21                        // Bias address scaled by BPE
s_wait_dscnt 0                                     // Wait for LDS write
s_barrier_signal -1
s_barrier_wait -1                                  // LDS write barrier
ds_load_b32 v30, v21 offset:0                      // load Bias
ds_load_b32 v31, v21 offset:128                    // load scaleAlpha
/* (d1,vc1,d0,vc0)=(0,1,0,0) */
ds_load_b32 v32, v21 offset:4                      // load Bias
ds_load_b32 v33, v21 offset:132                    // load scaleAlpha
/* (d1,vc1,d0,vc0)=(0,2,0,0) */
ds_load_b32 v34, v21 offset:8                      // load Bias
ds_load_b32 v35, v21 offset:136                    // load scaleAlpha
/* (d1,vc1,d0,vc0)=(0,3,0,0) */
ds_load_b32 v36, v21 offset:12                     // load Bias
ds_load_b32 v37, v21 offset:140                    // load scaleAlpha
/* (d1,vc1,d0,vc0)=(0,4,0,0) */
ds_load_b32 v38, v21 offset:16                     // load Bias
ds_load_b32 v39, v21 offset:144                    // load scaleAlpha
/* (d1,vc1,d0,vc0)=(0,5,0,0) */
ds_load_b32 v40, v21 offset:20                     // load Bias
ds_load_b32 v41, v21 offset:148                    // load scaleAlpha
/* (d1,vc1,d0,vc0)=(0,6,0,0) */
ds_load_b32 v42, v21 offset:24                     // load Bias
ds_load_b32 v43, v21 offset:152                    // load scaleAlpha
/* (d1,vc1,d0,vc0)=(0,7,0,0) */
ds_load_b32 v44, v21 offset:28                     // load Bias
ds_load_b32 v45, v21 offset:156                    // load scaleAlpha
v_add_lshl_u32 v19, v11, v8, 1                     // optSingleColVgpr scaleToBpe: sharedAddrVgpr <- cinRowPtr + coord0, scaled by BPE. BSHERE:coord0=8, coord0Vgpr=8 (multiple bpe)
v_mov_b32 v[vgprValuC+22], v[vgprValuC+0]          // copy MI out reg to vreg[0]
v_mov_b32 v[vgprValuC+23], v[vgprValuC+1]          // copy MI out reg to vreg[1]
v_mov_b32 v[vgprValuC+24], v[vgprValuC+2]          // copy MI out reg to vreg[2]
v_mov_b32 v[vgprValuC+25], v[vgprValuC+3]          // copy MI out reg to vreg[3]
v_mov_b32 v[vgprValuC+26], v[vgprValuC+4]          // copy MI out reg to vreg[4]
v_mov_b32 v[vgprValuC+27], v[vgprValuC+5]          // copy MI out reg to vreg[5]
v_mov_b32 v[vgprValuC+28], v[vgprValuC+6]          // copy MI out reg to vreg[6]
v_mov_b32 v[vgprValuC+29], v[vgprValuC+7]          // copy MI out reg to vreg[7]

/* apply mask, calc new C and issue writes */
v_mov_b32 v16, 0xffff0000                          // mask for pack two bfloat16 element to 32bit
v_mov_b32 v17, 0x7fff0000                          // fp32 Nan
v_mov_b32 v18, 0x7fff                              // rounding bias for bfloat16

s_wait_dscnt 14                                    // dscnt(14) = 16 - 1 (bias) - 1 (scaleAlphaVec) (interleaved)
v_mul_f32 v[vgprValuC+22], v31, v[vgprValuC+22]    // *= ScaleAlphaVecVMul
v_add_f32 v12, v30, v[vgprValuC+22]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v22, v12
v_cvt_pk_bf16_f32 v22, v[vgprValuC+22], v[vgprValuC+22] // convert C to bf16 in gwvw==1
buffer_store_b16 v22, v19, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_dscnt 12                                    // dscnt(12) = 16 - 2 (bias) - 2 (scaleAlphaVec) (interleaved)
v_mul_f32 v[vgprValuC+23], v33, v[vgprValuC+23]    // *= ScaleAlphaVecVMul
v_add_f32 v12, v32, v[vgprValuC+23]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v23, v12
v_cvt_pk_bf16_f32 v23, v[vgprValuC+23], v[vgprValuC+23] // convert C to bf16 in gwvw==1
s_lshl_b32 s8, s[sgprStrideD1J], 1                 // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s8         // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_store_b16 v23, v19, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_dscnt 10                                    // dscnt(10) = 16 - 3 (bias) - 3 (scaleAlphaVec) (interleaved)
v_mul_f32 v[vgprValuC+24], v35, v[vgprValuC+24]    // *= ScaleAlphaVecVMul
v_add_f32 v12, v34, v[vgprValuC+24]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v24, v12
v_cvt_pk_bf16_f32 v24, v[vgprValuC+24], v[vgprValuC+24] // convert C to bf16 in gwvw==1
s_lshl_b32 s8, s[sgprStrideD1J], 1                 // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s8         // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_store_b16 v24, v19, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_dscnt 8                                     // dscnt(8) = 16 - 4 (bias) - 4 (scaleAlphaVec) (interleaved)
v_mul_f32 v[vgprValuC+25], v37, v[vgprValuC+25]    // *= ScaleAlphaVecVMul
v_add_f32 v12, v36, v[vgprValuC+25]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v25, v12
v_cvt_pk_bf16_f32 v25, v[vgprValuC+25], v[vgprValuC+25] // convert C to bf16 in gwvw==1
s_lshl_b32 s8, s[sgprStrideD1J], 1                 // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s8         // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_store_b16 v25, v19, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_dscnt 6                                     // dscnt(6) = 16 - 5 (bias) - 5 (scaleAlphaVec) (interleaved)
v_mul_f32 v[vgprValuC+26], v39, v[vgprValuC+26]    // *= ScaleAlphaVecVMul
v_add_f32 v12, v38, v[vgprValuC+26]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v26, v12
v_cvt_pk_bf16_f32 v26, v[vgprValuC+26], v[vgprValuC+26] // convert C to bf16 in gwvw==1
s_lshl_b32 s8, s[sgprStrideD1J], 1                 // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s8         // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_store_b16 v26, v19, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_dscnt 4                                     // dscnt(4) = 16 - 6 (bias) - 6 (scaleAlphaVec) (interleaved)
v_mul_f32 v[vgprValuC+27], v41, v[vgprValuC+27]    // *= ScaleAlphaVecVMul
v_add_f32 v12, v40, v[vgprValuC+27]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v27, v12
v_cvt_pk_bf16_f32 v27, v[vgprValuC+27], v[vgprValuC+27] // convert C to bf16 in gwvw==1
s_lshl_b32 s8, s[sgprStrideD1J], 1                 // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s8         // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_store_b16 v27, v19, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_dscnt 2                                     // dscnt(2) = 16 - 7 (bias) - 7 (scaleAlphaVec) (interleaved)
v_mul_f32 v[vgprValuC+28], v43, v[vgprValuC+28]    // *= ScaleAlphaVecVMul
v_add_f32 v12, v42, v[vgprValuC+28]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v28, v12
v_cvt_pk_bf16_f32 v28, v[vgprValuC+28], v[vgprValuC+28] // convert C to bf16 in gwvw==1
s_lshl_b32 s8, s[sgprStrideD1J], 1                 // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s8         // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_store_b16 v28, v19, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_dscnt 0                                     // dscnt(0) = 16 - 8 (bias) - 8 (scaleAlphaVec) (interleaved)
v_mul_f32 v[vgprValuC+29], v45, v[vgprValuC+29]    // *= ScaleAlphaVecVMul
v_add_f32 v12, v44, v[vgprValuC+29]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v29, v12
v_cvt_pk_bf16_f32 v29, v[vgprValuC+29], v[vgprValuC+29] // convert C to bf16 in gwvw==1
s_lshl_b32 s8, s[sgprStrideD1J], 1                 // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s8         // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_store_b16 v29, v19, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_nop 0                                            // 1 wait state required when next inst writes vgprs held by previous dwordx4 store inst
s_branch label_GW_End
label_GW_End:

s_endpgm                                           // Kernel End
label_OptNLL_End:
label_GSU_3:

/******************************************/
/* Ord. NoLoadLoop - Begin                */
/******************************************/
s_wait_dscnt 0                                     // 4wait for local write
// Skip barrier: NumThreads=32wait for local write done, sync

/* iter 0 (last unrolled loop) */
/*  grEndMfmaIndex:0, lwStartMfmaIndex:0, lwEndMfmaIndex:0  */
/*  numMfmaForLR:0, syncPlrMfmaIndex:0  */
/*  mfmaIndex:0  */
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
ds_load_u8 v[vgprValuA_X0_I0+0], v[vgprLocalReadAddrA+0] offset:0 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D1+0], v[vgprLocalReadAddrA+0] offset:16 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D2+0], v[vgprLocalReadAddrA+0] offset:32 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=2 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D3+0], v[vgprLocalReadAddrA+0] offset:48 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=3 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0+1], v[vgprLocalReadAddrA+0] offset:64 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=4 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D1+1], v[vgprLocalReadAddrA+0] offset:80 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=5 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D2+1], v[vgprLocalReadAddrA+0] offset:96 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=6 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D3+1], v[vgprLocalReadAddrA+0] offset:112 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=7 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0+2], v[vgprLocalReadAddrA+0] offset:128 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=8 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D1+2], v[vgprLocalReadAddrA+0] offset:144 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=9 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D2+2], v[vgprLocalReadAddrA+0] offset:160 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=10 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D3+2], v[vgprLocalReadAddrA+0] offset:176 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=11 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0+3], v[vgprLocalReadAddrA+0] offset:192 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=12 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D1+3], v[vgprLocalReadAddrA+0] offset:208 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=13 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D2+3], v[vgprLocalReadAddrA+0] offset:224 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=14 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D3+3], v[vgprLocalReadAddrA+0] offset:240 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=15 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0+4], v[vgprLocalReadAddrA+0] offset:272 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=16 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D1+4], v[vgprLocalReadAddrA+0] offset:288 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=17 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D2+4], v[vgprLocalReadAddrA+0] offset:304 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=18 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D3+4], v[vgprLocalReadAddrA+0] offset:320 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=19 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0+5], v[vgprLocalReadAddrA+0] offset:336 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=20 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D1+5], v[vgprLocalReadAddrA+0] offset:352 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=21 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D2+5], v[vgprLocalReadAddrA+0] offset:368 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=22 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D3+5], v[vgprLocalReadAddrA+0] offset:384 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=23 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0+6], v[vgprLocalReadAddrA+0] offset:400 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=24 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D1+6], v[vgprLocalReadAddrA+0] offset:416 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=25 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D2+6], v[vgprLocalReadAddrA+0] offset:432 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=26 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D3+6], v[vgprLocalReadAddrA+0] offset:448 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=27 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0+7], v[vgprLocalReadAddrA+0] offset:464 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=28 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D1+7], v[vgprLocalReadAddrA+0] offset:480 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=29 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D2+7], v[vgprLocalReadAddrA+0] offset:496 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=30 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D3+7], v[vgprLocalReadAddrA+0] offset:512 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=31 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0+8], v[vgprLocalReadAddrA+0] offset:1088 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=32 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D1+8], v[vgprLocalReadAddrA+0] offset:1104 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=33 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D2+8], v[vgprLocalReadAddrA+0] offset:1120 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=34 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D3+8], v[vgprLocalReadAddrA+0] offset:1136 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=35 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0+9], v[vgprLocalReadAddrA+0] offset:1152 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=36 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D1+9], v[vgprLocalReadAddrA+0] offset:1168 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=37 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D2+9], v[vgprLocalReadAddrA+0] offset:1184 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=38 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D3+9], v[vgprLocalReadAddrA+0] offset:1200 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=39 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0+10], v[vgprLocalReadAddrA+0] offset:1216 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=40 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D1+10], v[vgprLocalReadAddrA+0] offset:1232 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=41 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D2+10], v[vgprLocalReadAddrA+0] offset:1248 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=42 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D3+10], v[vgprLocalReadAddrA+0] offset:1264 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=43 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0+11], v[vgprLocalReadAddrA+0] offset:1280 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=44 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D1+11], v[vgprLocalReadAddrA+0] offset:1296 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=45 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D2+11], v[vgprLocalReadAddrA+0] offset:1312 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=46 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D3+11], v[vgprLocalReadAddrA+0] offset:1328 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=47 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0+12], v[vgprLocalReadAddrA+0] offset:1360 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=48 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D1+12], v[vgprLocalReadAddrA+0] offset:1376 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=49 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D2+12], v[vgprLocalReadAddrA+0] offset:1392 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=50 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D3+12], v[vgprLocalReadAddrA+0] offset:1408 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=51 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0+13], v[vgprLocalReadAddrA+0] offset:1424 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=52 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D1+13], v[vgprLocalReadAddrA+0] offset:1440 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=53 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D2+13], v[vgprLocalReadAddrA+0] offset:1456 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=54 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D3+13], v[vgprLocalReadAddrA+0] offset:1472 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=55 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0+14], v[vgprLocalReadAddrA+0] offset:1488 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=56 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D1+14], v[vgprLocalReadAddrA+0] offset:1504 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=57 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D2+14], v[vgprLocalReadAddrA+0] offset:1520 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=58 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D3+14], v[vgprLocalReadAddrA+0] offset:1536 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=59 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0+15], v[vgprLocalReadAddrA+0] offset:1552 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=60 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D1+15], v[vgprLocalReadAddrA+0] offset:1568 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=61 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D2+15], v[vgprLocalReadAddrA+0] offset:1584 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=62 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_u8 v[vgprValuA_X0_I0_D3+15], v[vgprLocalReadAddrA+0] offset:1600 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=63 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_b64 v[vgprValuMetadata_X0_I0+0:vgprValuMetadata_X0_I0+0+1], v[vgprLocalReadAddrMetadata+0] offset:0 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_b128 v[vgprValuB_X0_I0+0:vgprValuB_X0_I0+0+3], v[vgprLocalReadAddrB+0] offset:0 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS1
ds_load_b128 v[vgprValuB_X0_I0+4:vgprValuB_X0_I0+4+3], v[vgprLocalReadAddrB+0] offset:32 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS1
s_wait_dscnt 0                                     // Wait for dependent lr
/* pack scheduling: packAIdx:48, packBIdx:0, packMIdx:0 */
v_lshl_or_b32 v[vgprValuA_X0_I0+0], v[vgprValuA_X0_I0_D1+0], 8, v[vgprValuA_X0_I0+0] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+0], v[vgprValuA_X0_I0_D3+0], 8, v[vgprValuA_X0_I0_D2+0] // pack two int8 Vgpr to one half Vgpr
s_delay_alu instid0(VALU_DEP_1)
v_lshl_or_b32 v[vgprValuA_X0_I0+0], v[vgprValuA_X0_I0_D2+0], 0x10, v[vgprValuA_X0_I0+0] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+1], v[vgprValuA_X0_I0_D1+1], 8, v[vgprValuA_X0_I0+1] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+1], v[vgprValuA_X0_I0_D3+1], 8, v[vgprValuA_X0_I0_D2+1] // pack two int8 Vgpr to one half Vgpr
s_delay_alu instid0(VALU_DEP_1)
v_lshl_or_b32 v[vgprValuA_X0_I0+1], v[vgprValuA_X0_I0_D2+1], 0x10, v[vgprValuA_X0_I0+1] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+2], v[vgprValuA_X0_I0_D1+2], 8, v[vgprValuA_X0_I0+2] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+2], v[vgprValuA_X0_I0_D3+2], 8, v[vgprValuA_X0_I0_D2+2] // pack two int8 Vgpr to one half Vgpr
s_delay_alu instid0(VALU_DEP_1)
v_lshl_or_b32 v[vgprValuA_X0_I0+2], v[vgprValuA_X0_I0_D2+2], 0x10, v[vgprValuA_X0_I0+2] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+3], v[vgprValuA_X0_I0_D1+3], 8, v[vgprValuA_X0_I0+3] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+3], v[vgprValuA_X0_I0_D3+3], 8, v[vgprValuA_X0_I0_D2+3] // pack two int8 Vgpr to one half Vgpr
s_delay_alu instid0(VALU_DEP_1)
v_lshl_or_b32 v[vgprValuA_X0_I0+3], v[vgprValuA_X0_I0_D2+3], 0x10, v[vgprValuA_X0_I0+3] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+4], v[vgprValuA_X0_I0_D1+4], 8, v[vgprValuA_X0_I0+4] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+4], v[vgprValuA_X0_I0_D3+4], 8, v[vgprValuA_X0_I0_D2+4] // pack two int8 Vgpr to one half Vgpr
s_delay_alu instid0(VALU_DEP_1)
v_lshl_or_b32 v[vgprValuA_X0_I0+4], v[vgprValuA_X0_I0_D2+4], 0x10, v[vgprValuA_X0_I0+4] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+5], v[vgprValuA_X0_I0_D1+5], 8, v[vgprValuA_X0_I0+5] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+5], v[vgprValuA_X0_I0_D3+5], 8, v[vgprValuA_X0_I0_D2+5] // pack two int8 Vgpr to one half Vgpr
s_delay_alu instid0(VALU_DEP_1)
v_lshl_or_b32 v[vgprValuA_X0_I0+5], v[vgprValuA_X0_I0_D2+5], 0x10, v[vgprValuA_X0_I0+5] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+6], v[vgprValuA_X0_I0_D1+6], 8, v[vgprValuA_X0_I0+6] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+6], v[vgprValuA_X0_I0_D3+6], 8, v[vgprValuA_X0_I0_D2+6] // pack two int8 Vgpr to one half Vgpr
s_delay_alu instid0(VALU_DEP_1)
v_lshl_or_b32 v[vgprValuA_X0_I0+6], v[vgprValuA_X0_I0_D2+6], 0x10, v[vgprValuA_X0_I0+6] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+7], v[vgprValuA_X0_I0_D1+7], 8, v[vgprValuA_X0_I0+7] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+7], v[vgprValuA_X0_I0_D3+7], 8, v[vgprValuA_X0_I0_D2+7] // pack two int8 Vgpr to one half Vgpr
s_delay_alu instid0(VALU_DEP_1)
v_lshl_or_b32 v[vgprValuA_X0_I0+7], v[vgprValuA_X0_I0_D2+7], 0x10, v[vgprValuA_X0_I0+7] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+8], v[vgprValuA_X0_I0_D1+8], 8, v[vgprValuA_X0_I0+8] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+8], v[vgprValuA_X0_I0_D3+8], 8, v[vgprValuA_X0_I0_D2+8] // pack two int8 Vgpr to one half Vgpr
s_delay_alu instid0(VALU_DEP_1)
v_lshl_or_b32 v[vgprValuA_X0_I0+8], v[vgprValuA_X0_I0_D2+8], 0x10, v[vgprValuA_X0_I0+8] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+9], v[vgprValuA_X0_I0_D1+9], 8, v[vgprValuA_X0_I0+9] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+9], v[vgprValuA_X0_I0_D3+9], 8, v[vgprValuA_X0_I0_D2+9] // pack two int8 Vgpr to one half Vgpr
s_delay_alu instid0(VALU_DEP_1)
v_lshl_or_b32 v[vgprValuA_X0_I0+9], v[vgprValuA_X0_I0_D2+9], 0x10, v[vgprValuA_X0_I0+9] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+10], v[vgprValuA_X0_I0_D1+10], 8, v[vgprValuA_X0_I0+10] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+10], v[vgprValuA_X0_I0_D3+10], 8, v[vgprValuA_X0_I0_D2+10] // pack two int8 Vgpr to one half Vgpr
s_delay_alu instid0(VALU_DEP_1)
v_lshl_or_b32 v[vgprValuA_X0_I0+10], v[vgprValuA_X0_I0_D2+10], 0x10, v[vgprValuA_X0_I0+10] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+11], v[vgprValuA_X0_I0_D1+11], 8, v[vgprValuA_X0_I0+11] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+11], v[vgprValuA_X0_I0_D3+11], 8, v[vgprValuA_X0_I0_D2+11] // pack two int8 Vgpr to one half Vgpr
s_delay_alu instid0(VALU_DEP_1)
v_lshl_or_b32 v[vgprValuA_X0_I0+11], v[vgprValuA_X0_I0_D2+11], 0x10, v[vgprValuA_X0_I0+11] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+12], v[vgprValuA_X0_I0_D1+12], 8, v[vgprValuA_X0_I0+12] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+12], v[vgprValuA_X0_I0_D3+12], 8, v[vgprValuA_X0_I0_D2+12] // pack two int8 Vgpr to one half Vgpr
s_delay_alu instid0(VALU_DEP_1)
v_lshl_or_b32 v[vgprValuA_X0_I0+12], v[vgprValuA_X0_I0_D2+12], 0x10, v[vgprValuA_X0_I0+12] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+13], v[vgprValuA_X0_I0_D1+13], 8, v[vgprValuA_X0_I0+13] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+13], v[vgprValuA_X0_I0_D3+13], 8, v[vgprValuA_X0_I0_D2+13] // pack two int8 Vgpr to one half Vgpr
s_delay_alu instid0(VALU_DEP_1)
v_lshl_or_b32 v[vgprValuA_X0_I0+13], v[vgprValuA_X0_I0_D2+13], 0x10, v[vgprValuA_X0_I0+13] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+14], v[vgprValuA_X0_I0_D1+14], 8, v[vgprValuA_X0_I0+14] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+14], v[vgprValuA_X0_I0_D3+14], 8, v[vgprValuA_X0_I0_D2+14] // pack two int8 Vgpr to one half Vgpr
s_delay_alu instid0(VALU_DEP_1)
v_lshl_or_b32 v[vgprValuA_X0_I0+14], v[vgprValuA_X0_I0_D2+14], 0x10, v[vgprValuA_X0_I0+14] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+15], v[vgprValuA_X0_I0_D1+15], 8, v[vgprValuA_X0_I0+15] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+15], v[vgprValuA_X0_I0_D3+15], 8, v[vgprValuA_X0_I0_D2+15] // pack two int8 Vgpr to one half Vgpr
s_delay_alu instid0(VALU_DEP_1)
v_lshl_or_b32 v[vgprValuA_X0_I0+15], v[vgprValuA_X0_I0_D2+15], 0x10, v[vgprValuA_X0_I0+15] // pack two half Vgpr to one Vgpr
/* pack scheduling: curPackIdx:48, numPack:48, instPackLast:['A', 'A'] */
s_nop 1                                            // VALU packing writes to be consumed by matrix instruction
v_swmmac_f32_16x16x128_fp8_fp8 v[vgprValuC+0:vgprValuC+0+7], v[vgprValuB_X0_I0+0+0+0:vgprValuB_X0_I0+0+0+0+7], v[vgprValuA_X0_I0+0+0+0:vgprValuA_X0_I0+0+0+0+15], v[vgprValuMetadata_X0_I0+0+0+0:vgprValuMetadata_X0_I0+0+0+0+1] matrix_b_reuse // left value = v[0+0:7+0]
/* numPrefetchIter=0 */
/* dataAtIterA=0 numReadsIterA=1 skipReadsIterA=0 readsPerIterA=64 */
/* dataAtIterB=0 numReadsIterB=1 skipReadsIterB=0 readsPerIterB=2 */
/* dataAtIterMetadata=0 numReadsIterMetadata=1 skipReadsIterMetadata=0 readsPerIterMetadata=1 */
label_toPGR1end_OrdNLL:
label_PrefetchGlobalLastIterEnd:

/* Tail: add ValuA/B vgpr buffer [20...100) to pool */

/* Tail: add address/G2L vgpr [100...126) to pool */

/******************************************/
/* Tail Loop                              */
/******************************************/

/* local write reset offsets a */
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_and_b32 v[vgprLocalWriteAddrA], 0xf00fff, v[vgprLocalWriteAddrA] // reset to Red

/* local write reset offsets b */
v_and_b32 v[vgprLocalWriteAddrB], 0xf00fff, v[vgprLocalWriteAddrB] // reset to Red
v_and_b32 v[vgprLocalWriteAddrMetadata+0], 0xf00fff, v[vgprLocalWriteAddrMetadata+0] // reset to Red
/* Check out VGPR (numG2LA,numG2LB,numG2LMXSA,numG2LMXSB,numG2LMetadata) = (16,8,0,0,2) */
.set vgprG2LA_BASE, 20
.set vgprG2LA, vgprG2LA_BASE+0
.set vgprG2LB_BASE, 36
.set vgprG2LB, vgprG2LB_BASE+0
.set vgprG2LMetadata, 44

/* remove stagger offsets for tail loop */
s_cmp_eq_u32 s[sgprOrigLoopCounter], 0             // skip if main loop was not executed
s_cbranch_scc1 label_SkipRemoveStagger             // skip removeStagger
//  removeStagger A
s_sub_i32 s80, 3, s[sgprStaggerUIter]
s_delay_alu instid0(SALU_CYCLE_1)
s_cmp_ge_i32 s80, 0
s_cbranch_scc0 label_Negative_S4FDBQ587JJL6NOU
s_mul_hi_u32 s81, s80, s[sgprGlobalReadIncsA+0]    // start offset S in bytes
s_mul_i32 s80, s80, s[sgprGlobalReadIncsA+0]       // start offset S in bytes
s_branch label_MultiplyDone_L43KTIIJOOEN7J6P
label_Negative_S4FDBQ587JJL6NOU:
s_abs_i32 s80, s80
s_mul_hi_u32 s81, s80, s[sgprGlobalReadIncsA+0]    // start offset S in bytes
s_mul_i32 s80, s80, s[sgprGlobalReadIncsA+0]       // start offset S in bytes
s_delay_alu instid0(SALU_CYCLE_1)
s_xor_b32 s80, s80, 0xffffffff
s_xor_b32 s81, s81, 0xffffffff
s_add_u32 s80, s80, 0x1
s_addc_u32 s81, s81, 0
label_MultiplyDone_L43KTIIJOOEN7J6P:
s_sub_u64 s[80:81], s[80:81], s[sgprWrapUA:sgprWrapUA+1] // S - WrapU
s_add_u32 s[sgprSrdA+0], s[sgprSrdA+0], s80        // gra SRD += inc(lower)
s_addc_u32 s[sgprSrdA+1], s[sgprSrdA+1], s81       // gra SRD += inc(upper)
s_sub_u32 s[sgprShadowLimitA+0], s[sgprShadowLimitA+0], s80 // limit -= inc)
s_subb_u32 s[sgprShadowLimitA+1], s[sgprShadowLimitA+1], s81 // limit -= inc)
s_delay_alu instid0(SALU_CYCLE_1)
s_cmp_eq_u32 s[sgprShadowLimitA+1], 0              // are we within 2^32?
s_cselect_b32 s[sgprSrdA+2], s[sgprShadowLimitA+0], BufferLimit // Move shadow to real if we are within 2^32
// Shift num records for gfx125x
s_and_b32 s8, s[sgprSrdA+2], 127
s_delay_alu instid0(SALU_CYCLE_1)
s_lshl_b32 s8, s8, 25
s_and_b32 s[sgprSrdA+1], s[sgprSrdA+1], 33554431
s_delay_alu instid0(SALU_CYCLE_1)
s_or_b32 s[sgprSrdA+1], s[sgprSrdA+1], s8
s_lshr_b32 s[sgprSrdA+2], s[sgprSrdA+2], 7
//  removeStagger B
s_sub_i32 s80, 3, s[sgprStaggerUIter]
s_delay_alu instid0(SALU_CYCLE_1)
s_cmp_ge_i32 s80, 0
s_cbranch_scc0 label_Negative_UR8VN3A1SJCPC6PO
s_mul_hi_u32 s81, s80, s[sgprGlobalReadIncsB+0]    // start offset S in bytes
s_mul_i32 s80, s80, s[sgprGlobalReadIncsB+0]       // start offset S in bytes
s_branch label_MultiplyDone_HYY06MPL0TYYIAT2
label_Negative_UR8VN3A1SJCPC6PO:
s_abs_i32 s80, s80
s_mul_hi_u32 s81, s80, s[sgprGlobalReadIncsB+0]    // start offset S in bytes
s_mul_i32 s80, s80, s[sgprGlobalReadIncsB+0]       // start offset S in bytes
s_delay_alu instid0(SALU_CYCLE_1)
s_xor_b32 s80, s80, 0xffffffff
s_xor_b32 s81, s81, 0xffffffff
s_add_u32 s80, s80, 0x1
s_addc_u32 s81, s81, 0
label_MultiplyDone_HYY06MPL0TYYIAT2:
s_sub_u64 s[80:81], s[80:81], s[sgprWrapUB:sgprWrapUB+1] // S - WrapU
s_add_u32 s[sgprSrdB+0], s[sgprSrdB+0], s80        // gra SRD += inc(lower)
s_addc_u32 s[sgprSrdB+1], s[sgprSrdB+1], s81       // gra SRD += inc(upper)
s_sub_u32 s[sgprShadowLimitB+0], s[sgprShadowLimitB+0], s80 // limit -= inc)
s_subb_u32 s[sgprShadowLimitB+1], s[sgprShadowLimitB+1], s81 // limit -= inc)
s_delay_alu instid0(SALU_CYCLE_1)
s_cmp_eq_u32 s[sgprShadowLimitB+1], 0              // are we within 2^32?
s_cselect_b32 s[sgprSrdB+2], s[sgprShadowLimitB+0], BufferLimit // Move shadow to real if we are within 2^32
// Shift num records for gfx125x
s_and_b32 s8, s[sgprSrdB+2], 127
s_delay_alu instid0(SALU_CYCLE_1)
s_lshl_b32 s8, s8, 25
s_and_b32 s[sgprSrdB+1], s[sgprSrdB+1], 33554431
s_delay_alu instid0(SALU_CYCLE_1)
s_or_b32 s[sgprSrdB+1], s[sgprSrdB+1], s8
s_lshr_b32 s[sgprSrdB+2], s[sgprSrdB+2], 7
s_sub_i32 s80, 3, s[sgprStaggerUIter]
s_delay_alu instid0(SALU_CYCLE_1)
s_cmp_ge_i32 s80, 0
s_cbranch_scc0 label_Negative_8S4L1KCK9VFC7AQU
s_mul_hi_u32 s81, s80, s[sgprGlobalReadIncsMetadata+0] // start offset S in bytes
s_mul_i32 s80, s80, s[sgprGlobalReadIncsMetadata+0] // start offset S in bytes
s_branch label_MultiplyDone_ZU0B7F2XE71N7LVL
label_Negative_8S4L1KCK9VFC7AQU:
s_abs_i32 s80, s80
s_mul_hi_u32 s81, s80, s[sgprGlobalReadIncsMetadata+0] // start offset S in bytes
s_mul_i32 s80, s80, s[sgprGlobalReadIncsMetadata+0] // start offset S in bytes
s_delay_alu instid0(SALU_CYCLE_1)
s_xor_b32 s80, s80, 0xffffffff
s_xor_b32 s81, s81, 0xffffffff
s_add_u32 s80, s80, 0x1
s_addc_u32 s81, s81, 0
label_MultiplyDone_ZU0B7F2XE71N7LVL:
s_sub_u32 s80, s80, s[sgprWrapUMetadata]           // S - WrapU
s_subb_u32 s81, s81, s[sgprWrapUMetadata+1]        // S - WrapU
s_add_u32 s[sgprSrdMetadata+0], s[sgprSrdMetadata+0], s80 // gra SRD += inc(lower)
s_addc_u32 s[sgprSrdMetadata+1], s[sgprSrdMetadata+1], s81 // gra SRD += inc(upper)
s_sub_u32 s[sgprShadowLimitMetadata+0], s[sgprShadowLimitMetadata+0], s80 // limit -= inc)
s_subb_u32 s[sgprShadowLimitMetadata+1], s[sgprShadowLimitMetadata+1], s81 // limit -= inc)
s_delay_alu instid0(SALU_CYCLE_1)
s_cmp_eq_u32 s[sgprShadowLimitMetadata+1], 0       // are we within 2^32?
s_cselect_b32 s[sgprSrdMetadata+2], s[sgprShadowLimitMetadata+0], BufferLimit // Move shadow to real if we are within 2^32
// Shift num records for gfx125x
s_and_b32 s8, s[sgprSrdMetadata+2], 127
s_delay_alu instid0(SALU_CYCLE_1)
s_lshl_b32 s8, s8, 25
s_and_b32 s[sgprSrdMetadata+1], s[sgprSrdMetadata+1], 33554431
s_delay_alu instid0(SALU_CYCLE_1)
s_or_b32 s[sgprSrdMetadata+1], s[sgprSrdMetadata+1], s8
s_lshr_b32 s[sgprSrdMetadata+2], s[sgprSrdMetadata+2], 7
label_SkipRemoveStagger:

// numIterL = LOCAL_SPLITU * min(sizeL % LOCAL_DEPTHU, DEPTHU / LOCAL_SPLITU)
s_and_b32 s[sgprLoopCounterL], 127, s[sgprSizesSum+0] // s[sgprLoopCounterL] = s[sgprSizesSum+0] % 128
s_and_b32 s80, s[sgprGSU], 0x8000                  // SCC = (GSUC == 1) ?
s_cbranch_scc1 label_GSUC_TL                       // branch if GSUC == 1
s_cmp_lg_u32 s[sgprGSUSumIdx], s[sgprGSUSumIdx+1]  // gsuSumIdx == numIterPerWgRemainder
s_cmov_b32 s[sgprLoopCounterL], 0                  // numIter=0 if gsuSimIdx != numIterPerWgRemainder
s_branch label_GSUC_TL_End
label_GSUC_TL:
s_lshr_b32 s81, s[sgprSizesSum], 7                 // s81 = s[sgprSizesSum] / 128
s_and_b32 s82, s[sgprGSU], 0x3fff                  // Restore GSU
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cvt_f32_u32 v46, s82                             // s80 = s81 / s82
s_delay_alu instid0(VALU_DEP_1)
v_rcp_iflag_f32 v46, v46                           // s80 = s81 / s82
v_cvt_f32_u32 v47, s81                             // s80 = s81 / s82
s_delay_alu instid0(VALU_DEP_1)
v_mul_f32 v46, v46, v47                            // s80 = s81 / s82
s_delay_alu instid0(VALU_DEP_1)
v_cvt_u32_f32 v46, v46                             // s80 = s81 / s82
v_mul_u32_u24 v47, v46, s82                        // s80 = s81 / s82
v_sub_nc_u32 v47, s81, v47                         // s80 = s81 / s82
v_cmp_eq_u32 vcc_lo, v47, s82                      // s80 = s81 / s82
s_mov_b32 exec_lo, vcc_lo                          // s80 = s81 / s82
s_delay_alu instid0(VALU_DEP_4)
v_add_nc_u32 v46, 1, v46                           // s80 = s81 / s82
v_mov_b32 v47, 0                                   // s[sgprGSUSumIdx+1] = s81 % s82
s_mov_b32 exec_lo, -1                              // Reset exec
v_cmp_gt_u32 vcc_lo, v47, s82                      // overflow happened in remainder
s_mov_b32 exec_lo, vcc_lo                          // overflow happened in remainder
s_delay_alu instid0(VALU_DEP_3)
v_sub_nc_u32 v46, v46, 1                           // quotient - 1
v_mul_u32_u24 v47, v46, s82                        // re-calculate remainder
v_sub_nc_u32 v47, s81, v47                         // re-calculate remainder
s_mov_b32 exec_lo, -1                              // Reset exec
s_delay_alu instid0(VALU_DEP_3)
v_readfirstlane_b32 s80, v46                       // quotient
s_delay_alu instid0(VALU_DEP_2)
v_readfirstlane_b32 s[sgprGSUSumIdx+1], v47        // remainder
s_delay_alu instid0(SALU_CYCLE_1)
s_sub_u32 s81, s82, 1                              // GSU-1
s_cmp_eq_u32 s80, 0                                // quotient == 0
s_cselect_b32 s80, s[sgprGSUSumIdx+1], s81         // lastWg = (quotient==0) ? numIterPerWgRemainder : GSU-1
s_cmp_lg_u32 s[sgprGSUSumIdx], s80                 // gsuSumIdx == lastWg
s_cmov_b32 s[sgprLoopCounterL], 0                  // numIter=0 if gsuSumIdx != lastWg
label_GSUC_TL_End:
s_cmp_eq_u32 s[sgprLoopCounterL], 0                // numIterL == 0
s_mov_b32 s[sgprOrigLoopCounter], 0                // repurpose to count each localRead increment
s_cbranch_scc1 label_SkipTailLoopL                 // skip to end of tail loop b/c numIter==0

/* Update M0 for DTLDS */

/* Tail global read A */
/* g2l=0, load component 0 */
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
buffer_load_d16_u8 v[vgprG2LA+0+0], v[vgprGlobalReadOffsetA+0], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=0, load component 1 */
buffer_load_d16_u8 v46, v[vgprGlobalReadOffsetA+0], s[sgprSrdA:sgprSrdA+3], null offen offset:1 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=0, load component 2 */
buffer_load_d16_hi_u8 v47, v[vgprGlobalReadOffsetA+0], s[sgprSrdA:sgprSrdA+3], null offen offset:2 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=0, load component 3 */
buffer_load_d16_hi_u8 v48, v[vgprGlobalReadOffsetA+0], s[sgprSrdA:sgprSrdA+3], null offen offset:3 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=0, load component 4 */
buffer_load_d16_u8 v[vgprG2LA+0+1], v[vgprGlobalReadOffsetA+0], s[sgprSrdA:sgprSrdA+3], null offen offset:4 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=0, load component 5 */
buffer_load_d16_u8 v50, v[vgprGlobalReadOffsetA+0], s[sgprSrdA:sgprSrdA+3], null offen offset:5 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=0, load component 6 */
buffer_load_d16_hi_u8 v51, v[vgprGlobalReadOffsetA+0], s[sgprSrdA:sgprSrdA+3], null offen offset:6 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=0, load component 7 */
buffer_load_d16_hi_u8 v52, v[vgprGlobalReadOffsetA+0], s[sgprSrdA:sgprSrdA+3], null offen offset:7 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=0, load component 8 */
buffer_load_d16_u8 v[vgprG2LA+0+2], v[vgprGlobalReadOffsetA+0], s[sgprSrdA:sgprSrdA+3], null offen offset:8 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=0, load component 9 */
buffer_load_d16_u8 v54, v[vgprGlobalReadOffsetA+0], s[sgprSrdA:sgprSrdA+3], null offen offset:9 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=0, load component 10 */
buffer_load_d16_hi_u8 v55, v[vgprGlobalReadOffsetA+0], s[sgprSrdA:sgprSrdA+3], null offen offset:10 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=0, load component 11 */
buffer_load_d16_hi_u8 v56, v[vgprGlobalReadOffsetA+0], s[sgprSrdA:sgprSrdA+3], null offen offset:11 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=0, load component 12 */
buffer_load_d16_u8 v[vgprG2LA+0+3], v[vgprGlobalReadOffsetA+0], s[sgprSrdA:sgprSrdA+3], null offen offset:12 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=0, load component 13 */
buffer_load_d16_u8 v58, v[vgprGlobalReadOffsetA+0], s[sgprSrdA:sgprSrdA+3], null offen offset:13 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=0, load component 14 */
buffer_load_d16_hi_u8 v59, v[vgprGlobalReadOffsetA+0], s[sgprSrdA:sgprSrdA+3], null offen offset:14 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=0, load component 15 */
buffer_load_d16_hi_u8 v60, v[vgprGlobalReadOffsetA+0], s[sgprSrdA:sgprSrdA+3], null offen offset:15 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
s_wait_loadcnt 14
v_lshlrev_b32 v46, 0x8, v46                        // shift left to higher 8 bits
v_or_b32 v[vgprG2LA+0+0], v[vgprG2LA+0+0], v46     // pack a sub 8-bit with dest
s_wait_loadcnt 13
v_or_b32 v[vgprG2LA+0+0], v[vgprG2LA+0+0], v47     // pack a sub 8-bit with dest
s_wait_loadcnt 12
v_lshlrev_b32 v48, 0x8, v48                        // shift left to higher 8 bits
s_delay_alu instid0(VALU_DEP_1)
v_or_b32 v[vgprG2LA+0+0], v[vgprG2LA+0+0], v48     // pack a sub 8-bit with dest
s_wait_loadcnt 10
v_lshlrev_b32 v50, 0x8, v50                        // shift left to higher 8 bits
v_or_b32 v[vgprG2LA+0+1], v[vgprG2LA+0+1], v50     // pack a sub 8-bit with dest
s_wait_loadcnt 9
v_or_b32 v[vgprG2LA+0+1], v[vgprG2LA+0+1], v51     // pack a sub 8-bit with dest
s_wait_loadcnt 8
v_lshlrev_b32 v52, 0x8, v52                        // shift left to higher 8 bits
s_delay_alu instid0(VALU_DEP_1)
v_or_b32 v[vgprG2LA+0+1], v[vgprG2LA+0+1], v52     // pack a sub 8-bit with dest
s_wait_loadcnt 6
v_lshlrev_b32 v54, 0x8, v54                        // shift left to higher 8 bits
v_or_b32 v[vgprG2LA+0+2], v[vgprG2LA+0+2], v54     // pack a sub 8-bit with dest
s_wait_loadcnt 5
v_or_b32 v[vgprG2LA+0+2], v[vgprG2LA+0+2], v55     // pack a sub 8-bit with dest
s_wait_loadcnt 4
v_lshlrev_b32 v56, 0x8, v56                        // shift left to higher 8 bits
s_delay_alu instid0(VALU_DEP_1)
v_or_b32 v[vgprG2LA+0+2], v[vgprG2LA+0+2], v56     // pack a sub 8-bit with dest
s_wait_loadcnt 2
v_lshlrev_b32 v58, 0x8, v58                        // shift left to higher 8 bits
v_or_b32 v[vgprG2LA+0+3], v[vgprG2LA+0+3], v58     // pack a sub 8-bit with dest
s_wait_loadcnt 1
v_or_b32 v[vgprG2LA+0+3], v[vgprG2LA+0+3], v59     // pack a sub 8-bit with dest
s_wait_loadcnt 0
v_lshlrev_b32 v60, 0x8, v60                        // shift left to higher 8 bits
s_delay_alu instid0(VALU_DEP_1)
v_or_b32 v[vgprG2LA+0+3], v[vgprG2LA+0+3], v60     // pack a sub 8-bit with dest
/* g2l=4, load component 0 */
buffer_load_d16_u8 v[vgprG2LA+4+0], v[vgprGlobalReadOffsetA+1], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=4, load component 1 */
buffer_load_d16_u8 v46, v[vgprGlobalReadOffsetA+1], s[sgprSrdA:sgprSrdA+3], null offen offset:1 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=4, load component 2 */
buffer_load_d16_hi_u8 v47, v[vgprGlobalReadOffsetA+1], s[sgprSrdA:sgprSrdA+3], null offen offset:2 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=4, load component 3 */
buffer_load_d16_hi_u8 v48, v[vgprGlobalReadOffsetA+1], s[sgprSrdA:sgprSrdA+3], null offen offset:3 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=4, load component 4 */
buffer_load_d16_u8 v[vgprG2LA+4+1], v[vgprGlobalReadOffsetA+1], s[sgprSrdA:sgprSrdA+3], null offen offset:4 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=4, load component 5 */
buffer_load_d16_u8 v50, v[vgprGlobalReadOffsetA+1], s[sgprSrdA:sgprSrdA+3], null offen offset:5 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=4, load component 6 */
buffer_load_d16_hi_u8 v51, v[vgprGlobalReadOffsetA+1], s[sgprSrdA:sgprSrdA+3], null offen offset:6 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=4, load component 7 */
buffer_load_d16_hi_u8 v52, v[vgprGlobalReadOffsetA+1], s[sgprSrdA:sgprSrdA+3], null offen offset:7 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=4, load component 8 */
buffer_load_d16_u8 v[vgprG2LA+4+2], v[vgprGlobalReadOffsetA+1], s[sgprSrdA:sgprSrdA+3], null offen offset:8 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=4, load component 9 */
buffer_load_d16_u8 v54, v[vgprGlobalReadOffsetA+1], s[sgprSrdA:sgprSrdA+3], null offen offset:9 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=4, load component 10 */
buffer_load_d16_hi_u8 v55, v[vgprGlobalReadOffsetA+1], s[sgprSrdA:sgprSrdA+3], null offen offset:10 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=4, load component 11 */
buffer_load_d16_hi_u8 v56, v[vgprGlobalReadOffsetA+1], s[sgprSrdA:sgprSrdA+3], null offen offset:11 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=4, load component 12 */
buffer_load_d16_u8 v[vgprG2LA+4+3], v[vgprGlobalReadOffsetA+1], s[sgprSrdA:sgprSrdA+3], null offen offset:12 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=4, load component 13 */
buffer_load_d16_u8 v58, v[vgprGlobalReadOffsetA+1], s[sgprSrdA:sgprSrdA+3], null offen offset:13 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=4, load component 14 */
buffer_load_d16_hi_u8 v59, v[vgprGlobalReadOffsetA+1], s[sgprSrdA:sgprSrdA+3], null offen offset:14 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=4, load component 15 */
buffer_load_d16_hi_u8 v60, v[vgprGlobalReadOffsetA+1], s[sgprSrdA:sgprSrdA+3], null offen offset:15 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
s_wait_loadcnt 14
v_lshlrev_b32 v46, 0x8, v46                        // shift left to higher 8 bits
v_or_b32 v[vgprG2LA+4+0], v[vgprG2LA+4+0], v46     // pack a sub 8-bit with dest
s_wait_loadcnt 13
v_or_b32 v[vgprG2LA+4+0], v[vgprG2LA+4+0], v47     // pack a sub 8-bit with dest
s_wait_loadcnt 12
v_lshlrev_b32 v48, 0x8, v48                        // shift left to higher 8 bits
s_delay_alu instid0(VALU_DEP_1)
v_or_b32 v[vgprG2LA+4+0], v[vgprG2LA+4+0], v48     // pack a sub 8-bit with dest
s_wait_loadcnt 10
v_lshlrev_b32 v50, 0x8, v50                        // shift left to higher 8 bits
v_or_b32 v[vgprG2LA+4+1], v[vgprG2LA+4+1], v50     // pack a sub 8-bit with dest
s_wait_loadcnt 9
v_or_b32 v[vgprG2LA+4+1], v[vgprG2LA+4+1], v51     // pack a sub 8-bit with dest
s_wait_loadcnt 8
v_lshlrev_b32 v52, 0x8, v52                        // shift left to higher 8 bits
s_delay_alu instid0(VALU_DEP_1)
v_or_b32 v[vgprG2LA+4+1], v[vgprG2LA+4+1], v52     // pack a sub 8-bit with dest
s_wait_loadcnt 6
v_lshlrev_b32 v54, 0x8, v54                        // shift left to higher 8 bits
v_or_b32 v[vgprG2LA+4+2], v[vgprG2LA+4+2], v54     // pack a sub 8-bit with dest
s_wait_loadcnt 5
v_or_b32 v[vgprG2LA+4+2], v[vgprG2LA+4+2], v55     // pack a sub 8-bit with dest
s_wait_loadcnt 4
v_lshlrev_b32 v56, 0x8, v56                        // shift left to higher 8 bits
s_delay_alu instid0(VALU_DEP_1)
v_or_b32 v[vgprG2LA+4+2], v[vgprG2LA+4+2], v56     // pack a sub 8-bit with dest
s_wait_loadcnt 2
v_lshlrev_b32 v58, 0x8, v58                        // shift left to higher 8 bits
v_or_b32 v[vgprG2LA+4+3], v[vgprG2LA+4+3], v58     // pack a sub 8-bit with dest
s_wait_loadcnt 1
v_or_b32 v[vgprG2LA+4+3], v[vgprG2LA+4+3], v59     // pack a sub 8-bit with dest
s_wait_loadcnt 0
v_lshlrev_b32 v60, 0x8, v60                        // shift left to higher 8 bits
s_delay_alu instid0(VALU_DEP_1)
v_or_b32 v[vgprG2LA+4+3], v[vgprG2LA+4+3], v60     // pack a sub 8-bit with dest
/* g2l=8, load component 0 */
buffer_load_d16_u8 v[vgprG2LA+8+0], v[vgprGlobalReadOffsetA+2], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=8, load component 1 */
buffer_load_d16_u8 v46, v[vgprGlobalReadOffsetA+2], s[sgprSrdA:sgprSrdA+3], null offen offset:1 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=8, load component 2 */
buffer_load_d16_hi_u8 v47, v[vgprGlobalReadOffsetA+2], s[sgprSrdA:sgprSrdA+3], null offen offset:2 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=8, load component 3 */
buffer_load_d16_hi_u8 v48, v[vgprGlobalReadOffsetA+2], s[sgprSrdA:sgprSrdA+3], null offen offset:3 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=8, load component 4 */
buffer_load_d16_u8 v[vgprG2LA+8+1], v[vgprGlobalReadOffsetA+2], s[sgprSrdA:sgprSrdA+3], null offen offset:4 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=8, load component 5 */
buffer_load_d16_u8 v50, v[vgprGlobalReadOffsetA+2], s[sgprSrdA:sgprSrdA+3], null offen offset:5 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=8, load component 6 */
buffer_load_d16_hi_u8 v51, v[vgprGlobalReadOffsetA+2], s[sgprSrdA:sgprSrdA+3], null offen offset:6 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=8, load component 7 */
buffer_load_d16_hi_u8 v52, v[vgprGlobalReadOffsetA+2], s[sgprSrdA:sgprSrdA+3], null offen offset:7 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=8, load component 8 */
buffer_load_d16_u8 v[vgprG2LA+8+2], v[vgprGlobalReadOffsetA+2], s[sgprSrdA:sgprSrdA+3], null offen offset:8 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=8, load component 9 */
buffer_load_d16_u8 v54, v[vgprGlobalReadOffsetA+2], s[sgprSrdA:sgprSrdA+3], null offen offset:9 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=8, load component 10 */
buffer_load_d16_hi_u8 v55, v[vgprGlobalReadOffsetA+2], s[sgprSrdA:sgprSrdA+3], null offen offset:10 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=8, load component 11 */
buffer_load_d16_hi_u8 v56, v[vgprGlobalReadOffsetA+2], s[sgprSrdA:sgprSrdA+3], null offen offset:11 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=8, load component 12 */
buffer_load_d16_u8 v[vgprG2LA+8+3], v[vgprGlobalReadOffsetA+2], s[sgprSrdA:sgprSrdA+3], null offen offset:12 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=8, load component 13 */
buffer_load_d16_u8 v58, v[vgprGlobalReadOffsetA+2], s[sgprSrdA:sgprSrdA+3], null offen offset:13 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=8, load component 14 */
buffer_load_d16_hi_u8 v59, v[vgprGlobalReadOffsetA+2], s[sgprSrdA:sgprSrdA+3], null offen offset:14 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=8, load component 15 */
buffer_load_d16_hi_u8 v60, v[vgprGlobalReadOffsetA+2], s[sgprSrdA:sgprSrdA+3], null offen offset:15 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
s_wait_loadcnt 14
v_lshlrev_b32 v46, 0x8, v46                        // shift left to higher 8 bits
v_or_b32 v[vgprG2LA+8+0], v[vgprG2LA+8+0], v46     // pack a sub 8-bit with dest
s_wait_loadcnt 13
v_or_b32 v[vgprG2LA+8+0], v[vgprG2LA+8+0], v47     // pack a sub 8-bit with dest
s_wait_loadcnt 12
v_lshlrev_b32 v48, 0x8, v48                        // shift left to higher 8 bits
s_delay_alu instid0(VALU_DEP_1)
v_or_b32 v[vgprG2LA+8+0], v[vgprG2LA+8+0], v48     // pack a sub 8-bit with dest
s_wait_loadcnt 10
v_lshlrev_b32 v50, 0x8, v50                        // shift left to higher 8 bits
v_or_b32 v[vgprG2LA+8+1], v[vgprG2LA+8+1], v50     // pack a sub 8-bit with dest
s_wait_loadcnt 9
v_or_b32 v[vgprG2LA+8+1], v[vgprG2LA+8+1], v51     // pack a sub 8-bit with dest
s_wait_loadcnt 8
v_lshlrev_b32 v52, 0x8, v52                        // shift left to higher 8 bits
s_delay_alu instid0(VALU_DEP_1)
v_or_b32 v[vgprG2LA+8+1], v[vgprG2LA+8+1], v52     // pack a sub 8-bit with dest
s_wait_loadcnt 6
v_lshlrev_b32 v54, 0x8, v54                        // shift left to higher 8 bits
v_or_b32 v[vgprG2LA+8+2], v[vgprG2LA+8+2], v54     // pack a sub 8-bit with dest
s_wait_loadcnt 5
v_or_b32 v[vgprG2LA+8+2], v[vgprG2LA+8+2], v55     // pack a sub 8-bit with dest
s_wait_loadcnt 4
v_lshlrev_b32 v56, 0x8, v56                        // shift left to higher 8 bits
s_delay_alu instid0(VALU_DEP_1)
v_or_b32 v[vgprG2LA+8+2], v[vgprG2LA+8+2], v56     // pack a sub 8-bit with dest
s_wait_loadcnt 2
v_lshlrev_b32 v58, 0x8, v58                        // shift left to higher 8 bits
v_or_b32 v[vgprG2LA+8+3], v[vgprG2LA+8+3], v58     // pack a sub 8-bit with dest
s_wait_loadcnt 1
v_or_b32 v[vgprG2LA+8+3], v[vgprG2LA+8+3], v59     // pack a sub 8-bit with dest
s_wait_loadcnt 0
v_lshlrev_b32 v60, 0x8, v60                        // shift left to higher 8 bits
s_delay_alu instid0(VALU_DEP_1)
v_or_b32 v[vgprG2LA+8+3], v[vgprG2LA+8+3], v60     // pack a sub 8-bit with dest
/* g2l=12, load component 0 */
buffer_load_d16_u8 v[vgprG2LA+12+0], v[vgprGlobalReadOffsetA+3], s[sgprSrdA:sgprSrdA+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=12, load component 1 */
buffer_load_d16_u8 v46, v[vgprGlobalReadOffsetA+3], s[sgprSrdA:sgprSrdA+3], null offen offset:1 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=12, load component 2 */
buffer_load_d16_hi_u8 v47, v[vgprGlobalReadOffsetA+3], s[sgprSrdA:sgprSrdA+3], null offen offset:2 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=12, load component 3 */
buffer_load_d16_hi_u8 v48, v[vgprGlobalReadOffsetA+3], s[sgprSrdA:sgprSrdA+3], null offen offset:3 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=12, load component 4 */
buffer_load_d16_u8 v[vgprG2LA+12+1], v[vgprGlobalReadOffsetA+3], s[sgprSrdA:sgprSrdA+3], null offen offset:4 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=12, load component 5 */
buffer_load_d16_u8 v50, v[vgprGlobalReadOffsetA+3], s[sgprSrdA:sgprSrdA+3], null offen offset:5 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=12, load component 6 */
buffer_load_d16_hi_u8 v51, v[vgprGlobalReadOffsetA+3], s[sgprSrdA:sgprSrdA+3], null offen offset:6 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=12, load component 7 */
buffer_load_d16_hi_u8 v52, v[vgprGlobalReadOffsetA+3], s[sgprSrdA:sgprSrdA+3], null offen offset:7 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=12, load component 8 */
buffer_load_d16_u8 v[vgprG2LA+12+2], v[vgprGlobalReadOffsetA+3], s[sgprSrdA:sgprSrdA+3], null offen offset:8 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=12, load component 9 */
buffer_load_d16_u8 v54, v[vgprGlobalReadOffsetA+3], s[sgprSrdA:sgprSrdA+3], null offen offset:9 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=12, load component 10 */
buffer_load_d16_hi_u8 v55, v[vgprGlobalReadOffsetA+3], s[sgprSrdA:sgprSrdA+3], null offen offset:10 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=12, load component 11 */
buffer_load_d16_hi_u8 v56, v[vgprGlobalReadOffsetA+3], s[sgprSrdA:sgprSrdA+3], null offen offset:11 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=12, load component 12 */
buffer_load_d16_u8 v[vgprG2LA+12+3], v[vgprGlobalReadOffsetA+3], s[sgprSrdA:sgprSrdA+3], null offen offset:12 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=12, load component 13 */
buffer_load_d16_u8 v58, v[vgprGlobalReadOffsetA+3], s[sgprSrdA:sgprSrdA+3], null offen offset:13 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=12, load component 14 */
buffer_load_d16_hi_u8 v59, v[vgprGlobalReadOffsetA+3], s[sgprSrdA:sgprSrdA+3], null offen offset:14 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=12, load component 15 */
buffer_load_d16_hi_u8 v60, v[vgprGlobalReadOffsetA+3], s[sgprSrdA:sgprSrdA+3], null offen offset:15 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
s_wait_loadcnt 14
v_lshlrev_b32 v46, 0x8, v46                        // shift left to higher 8 bits
v_or_b32 v[vgprG2LA+12+0], v[vgprG2LA+12+0], v46   // pack a sub 8-bit with dest
s_wait_loadcnt 13
v_or_b32 v[vgprG2LA+12+0], v[vgprG2LA+12+0], v47   // pack a sub 8-bit with dest
s_wait_loadcnt 12
v_lshlrev_b32 v48, 0x8, v48                        // shift left to higher 8 bits
s_delay_alu instid0(VALU_DEP_1)
v_or_b32 v[vgprG2LA+12+0], v[vgprG2LA+12+0], v48   // pack a sub 8-bit with dest
s_wait_loadcnt 10
v_lshlrev_b32 v50, 0x8, v50                        // shift left to higher 8 bits
v_or_b32 v[vgprG2LA+12+1], v[vgprG2LA+12+1], v50   // pack a sub 8-bit with dest
s_wait_loadcnt 9
v_or_b32 v[vgprG2LA+12+1], v[vgprG2LA+12+1], v51   // pack a sub 8-bit with dest
s_wait_loadcnt 8
v_lshlrev_b32 v52, 0x8, v52                        // shift left to higher 8 bits
s_delay_alu instid0(VALU_DEP_1)
v_or_b32 v[vgprG2LA+12+1], v[vgprG2LA+12+1], v52   // pack a sub 8-bit with dest
s_wait_loadcnt 6
v_lshlrev_b32 v54, 0x8, v54                        // shift left to higher 8 bits
v_or_b32 v[vgprG2LA+12+2], v[vgprG2LA+12+2], v54   // pack a sub 8-bit with dest
s_wait_loadcnt 5
v_or_b32 v[vgprG2LA+12+2], v[vgprG2LA+12+2], v55   // pack a sub 8-bit with dest
s_wait_loadcnt 4
v_lshlrev_b32 v56, 0x8, v56                        // shift left to higher 8 bits
s_delay_alu instid0(VALU_DEP_1)
v_or_b32 v[vgprG2LA+12+2], v[vgprG2LA+12+2], v56   // pack a sub 8-bit with dest
s_wait_loadcnt 2
v_lshlrev_b32 v58, 0x8, v58                        // shift left to higher 8 bits
v_or_b32 v[vgprG2LA+12+3], v[vgprG2LA+12+3], v58   // pack a sub 8-bit with dest
s_wait_loadcnt 1
v_or_b32 v[vgprG2LA+12+3], v[vgprG2LA+12+3], v59   // pack a sub 8-bit with dest
s_wait_loadcnt 0
v_lshlrev_b32 v60, 0x8, v60                        // shift left to higher 8 bits
s_delay_alu instid0(VALU_DEP_1)
v_or_b32 v[vgprG2LA+12+3], v[vgprG2LA+12+3], v60   // pack a sub 8-bit with dest

/* Update M0 for DTLDS */

/* Tail global read B */
/* g2l=0, load component 0 */
buffer_load_d16_u8 v[vgprG2LB+0+0], v[vgprGlobalReadOffsetB+0], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=0, load component 1 */
buffer_load_d16_u8 v46, v[vgprGlobalReadOffsetB+0], s[sgprSrdB:sgprSrdB+3], null offen offset:1 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=0, load component 2 */
buffer_load_d16_hi_u8 v47, v[vgprGlobalReadOffsetB+0], s[sgprSrdB:sgprSrdB+3], null offen offset:2 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=0, load component 3 */
buffer_load_d16_hi_u8 v48, v[vgprGlobalReadOffsetB+0], s[sgprSrdB:sgprSrdB+3], null offen offset:3 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=0, load component 4 */
buffer_load_d16_u8 v[vgprG2LB+0+1], v[vgprGlobalReadOffsetB+0], s[sgprSrdB:sgprSrdB+3], null offen offset:4 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=0, load component 5 */
buffer_load_d16_u8 v50, v[vgprGlobalReadOffsetB+0], s[sgprSrdB:sgprSrdB+3], null offen offset:5 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=0, load component 6 */
buffer_load_d16_hi_u8 v51, v[vgprGlobalReadOffsetB+0], s[sgprSrdB:sgprSrdB+3], null offen offset:6 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=0, load component 7 */
buffer_load_d16_hi_u8 v52, v[vgprGlobalReadOffsetB+0], s[sgprSrdB:sgprSrdB+3], null offen offset:7 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=0, load component 8 */
buffer_load_d16_u8 v[vgprG2LB+0+2], v[vgprGlobalReadOffsetB+0], s[sgprSrdB:sgprSrdB+3], null offen offset:8 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=0, load component 9 */
buffer_load_d16_u8 v54, v[vgprGlobalReadOffsetB+0], s[sgprSrdB:sgprSrdB+3], null offen offset:9 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=0, load component 10 */
buffer_load_d16_hi_u8 v55, v[vgprGlobalReadOffsetB+0], s[sgprSrdB:sgprSrdB+3], null offen offset:10 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=0, load component 11 */
buffer_load_d16_hi_u8 v56, v[vgprGlobalReadOffsetB+0], s[sgprSrdB:sgprSrdB+3], null offen offset:11 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=0, load component 12 */
buffer_load_d16_u8 v[vgprG2LB+0+3], v[vgprGlobalReadOffsetB+0], s[sgprSrdB:sgprSrdB+3], null offen offset:12 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=0, load component 13 */
buffer_load_d16_u8 v58, v[vgprGlobalReadOffsetB+0], s[sgprSrdB:sgprSrdB+3], null offen offset:13 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=0, load component 14 */
buffer_load_d16_hi_u8 v59, v[vgprGlobalReadOffsetB+0], s[sgprSrdB:sgprSrdB+3], null offen offset:14 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=0, load component 15 */
buffer_load_d16_hi_u8 v60, v[vgprGlobalReadOffsetB+0], s[sgprSrdB:sgprSrdB+3], null offen offset:15 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
s_wait_loadcnt 14
v_lshlrev_b32 v46, 0x8, v46                        // shift left to higher 8 bits
v_or_b32 v[vgprG2LB+0+0], v[vgprG2LB+0+0], v46     // pack a sub 8-bit with dest
s_wait_loadcnt 13
v_or_b32 v[vgprG2LB+0+0], v[vgprG2LB+0+0], v47     // pack a sub 8-bit with dest
s_wait_loadcnt 12
v_lshlrev_b32 v48, 0x8, v48                        // shift left to higher 8 bits
s_delay_alu instid0(VALU_DEP_1)
v_or_b32 v[vgprG2LB+0+0], v[vgprG2LB+0+0], v48     // pack a sub 8-bit with dest
s_wait_loadcnt 10
v_lshlrev_b32 v50, 0x8, v50                        // shift left to higher 8 bits
v_or_b32 v[vgprG2LB+0+1], v[vgprG2LB+0+1], v50     // pack a sub 8-bit with dest
s_wait_loadcnt 9
v_or_b32 v[vgprG2LB+0+1], v[vgprG2LB+0+1], v51     // pack a sub 8-bit with dest
s_wait_loadcnt 8
v_lshlrev_b32 v52, 0x8, v52                        // shift left to higher 8 bits
s_delay_alu instid0(VALU_DEP_1)
v_or_b32 v[vgprG2LB+0+1], v[vgprG2LB+0+1], v52     // pack a sub 8-bit with dest
s_wait_loadcnt 6
v_lshlrev_b32 v54, 0x8, v54                        // shift left to higher 8 bits
v_or_b32 v[vgprG2LB+0+2], v[vgprG2LB+0+2], v54     // pack a sub 8-bit with dest
s_wait_loadcnt 5
v_or_b32 v[vgprG2LB+0+2], v[vgprG2LB+0+2], v55     // pack a sub 8-bit with dest
s_wait_loadcnt 4
v_lshlrev_b32 v56, 0x8, v56                        // shift left to higher 8 bits
s_delay_alu instid0(VALU_DEP_1)
v_or_b32 v[vgprG2LB+0+2], v[vgprG2LB+0+2], v56     // pack a sub 8-bit with dest
s_wait_loadcnt 2
v_lshlrev_b32 v58, 0x8, v58                        // shift left to higher 8 bits
v_or_b32 v[vgprG2LB+0+3], v[vgprG2LB+0+3], v58     // pack a sub 8-bit with dest
s_wait_loadcnt 1
v_or_b32 v[vgprG2LB+0+3], v[vgprG2LB+0+3], v59     // pack a sub 8-bit with dest
s_wait_loadcnt 0
v_lshlrev_b32 v60, 0x8, v60                        // shift left to higher 8 bits
s_delay_alu instid0(VALU_DEP_1)
v_or_b32 v[vgprG2LB+0+3], v[vgprG2LB+0+3], v60     // pack a sub 8-bit with dest
/* g2l=4, load component 0 */
buffer_load_d16_u8 v[vgprG2LB+4+0], v[vgprGlobalReadOffsetB+1], s[sgprSrdB:sgprSrdB+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=4, load component 1 */
buffer_load_d16_u8 v46, v[vgprGlobalReadOffsetB+1], s[sgprSrdB:sgprSrdB+3], null offen offset:1 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=4, load component 2 */
buffer_load_d16_hi_u8 v47, v[vgprGlobalReadOffsetB+1], s[sgprSrdB:sgprSrdB+3], null offen offset:2 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=4, load component 3 */
buffer_load_d16_hi_u8 v48, v[vgprGlobalReadOffsetB+1], s[sgprSrdB:sgprSrdB+3], null offen offset:3 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=4, load component 4 */
buffer_load_d16_u8 v[vgprG2LB+4+1], v[vgprGlobalReadOffsetB+1], s[sgprSrdB:sgprSrdB+3], null offen offset:4 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=4, load component 5 */
buffer_load_d16_u8 v50, v[vgprGlobalReadOffsetB+1], s[sgprSrdB:sgprSrdB+3], null offen offset:5 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=4, load component 6 */
buffer_load_d16_hi_u8 v51, v[vgprGlobalReadOffsetB+1], s[sgprSrdB:sgprSrdB+3], null offen offset:6 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=4, load component 7 */
buffer_load_d16_hi_u8 v52, v[vgprGlobalReadOffsetB+1], s[sgprSrdB:sgprSrdB+3], null offen offset:7 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=4, load component 8 */
buffer_load_d16_u8 v[vgprG2LB+4+2], v[vgprGlobalReadOffsetB+1], s[sgprSrdB:sgprSrdB+3], null offen offset:8 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=4, load component 9 */
buffer_load_d16_u8 v54, v[vgprGlobalReadOffsetB+1], s[sgprSrdB:sgprSrdB+3], null offen offset:9 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=4, load component 10 */
buffer_load_d16_hi_u8 v55, v[vgprGlobalReadOffsetB+1], s[sgprSrdB:sgprSrdB+3], null offen offset:10 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=4, load component 11 */
buffer_load_d16_hi_u8 v56, v[vgprGlobalReadOffsetB+1], s[sgprSrdB:sgprSrdB+3], null offen offset:11 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=4, load component 12 */
buffer_load_d16_u8 v[vgprG2LB+4+3], v[vgprGlobalReadOffsetB+1], s[sgprSrdB:sgprSrdB+3], null offen offset:12 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=4, load component 13 */
buffer_load_d16_u8 v58, v[vgprGlobalReadOffsetB+1], s[sgprSrdB:sgprSrdB+3], null offen offset:13 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=4, load component 14 */
buffer_load_d16_hi_u8 v59, v[vgprGlobalReadOffsetB+1], s[sgprSrdB:sgprSrdB+3], null offen offset:14 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=4, load component 15 */
buffer_load_d16_hi_u8 v60, v[vgprGlobalReadOffsetB+1], s[sgprSrdB:sgprSrdB+3], null offen offset:15 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
s_wait_loadcnt 14
v_lshlrev_b32 v46, 0x8, v46                        // shift left to higher 8 bits
v_or_b32 v[vgprG2LB+4+0], v[vgprG2LB+4+0], v46     // pack a sub 8-bit with dest
s_wait_loadcnt 13
v_or_b32 v[vgprG2LB+4+0], v[vgprG2LB+4+0], v47     // pack a sub 8-bit with dest
s_wait_loadcnt 12
v_lshlrev_b32 v48, 0x8, v48                        // shift left to higher 8 bits
s_delay_alu instid0(VALU_DEP_1)
v_or_b32 v[vgprG2LB+4+0], v[vgprG2LB+4+0], v48     // pack a sub 8-bit with dest
s_wait_loadcnt 10
v_lshlrev_b32 v50, 0x8, v50                        // shift left to higher 8 bits
v_or_b32 v[vgprG2LB+4+1], v[vgprG2LB+4+1], v50     // pack a sub 8-bit with dest
s_wait_loadcnt 9
v_or_b32 v[vgprG2LB+4+1], v[vgprG2LB+4+1], v51     // pack a sub 8-bit with dest
s_wait_loadcnt 8
v_lshlrev_b32 v52, 0x8, v52                        // shift left to higher 8 bits
s_delay_alu instid0(VALU_DEP_1)
v_or_b32 v[vgprG2LB+4+1], v[vgprG2LB+4+1], v52     // pack a sub 8-bit with dest
s_wait_loadcnt 6
v_lshlrev_b32 v54, 0x8, v54                        // shift left to higher 8 bits
v_or_b32 v[vgprG2LB+4+2], v[vgprG2LB+4+2], v54     // pack a sub 8-bit with dest
s_wait_loadcnt 5
v_or_b32 v[vgprG2LB+4+2], v[vgprG2LB+4+2], v55     // pack a sub 8-bit with dest
s_wait_loadcnt 4
v_lshlrev_b32 v56, 0x8, v56                        // shift left to higher 8 bits
s_delay_alu instid0(VALU_DEP_1)
v_or_b32 v[vgprG2LB+4+2], v[vgprG2LB+4+2], v56     // pack a sub 8-bit with dest
s_wait_loadcnt 2
v_lshlrev_b32 v58, 0x8, v58                        // shift left to higher 8 bits
v_or_b32 v[vgprG2LB+4+3], v[vgprG2LB+4+3], v58     // pack a sub 8-bit with dest
s_wait_loadcnt 1
v_or_b32 v[vgprG2LB+4+3], v[vgprG2LB+4+3], v59     // pack a sub 8-bit with dest
s_wait_loadcnt 0
v_lshlrev_b32 v60, 0x8, v60                        // shift left to higher 8 bits
s_delay_alu instid0(VALU_DEP_1)
v_or_b32 v[vgprG2LB+4+3], v[vgprG2LB+4+3], v60     // pack a sub 8-bit with dest
/* g2l=0, load component 0 */
v_mov_b32 v[vgprG2LMetadata+0+0], 0                // set to zero to avoid unexpected value
buffer_load_d16_u8 v[vgprG2LMetadata+0+0], v[vgprGlobalReadOffsetMetadata+0], s[sgprSrdMetadata:sgprSrdMetadata+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=0, load component 1 */
v_mov_b32 v46, 0                                   // set to zero to avoid unexpected value
buffer_load_d16_u8 v46, v[vgprGlobalReadOffsetMetadata+0], s[sgprSrdMetadata:sgprSrdMetadata+3], null offen offset:1 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=0, load component 2 */
v_mov_b32 v47, 0                                   // set to zero to avoid unexpected value
buffer_load_d16_hi_u8 v47, v[vgprGlobalReadOffsetMetadata+0], s[sgprSrdMetadata:sgprSrdMetadata+3], null offen offset:2 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=0, load component 3 */
v_mov_b32 v48, 0                                   // set to zero to avoid unexpected value
buffer_load_d16_hi_u8 v48, v[vgprGlobalReadOffsetMetadata+0], s[sgprSrdMetadata:sgprSrdMetadata+3], null offen offset:3 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=0, load component 4 */
v_mov_b32 v[vgprG2LMetadata+0+1], 0                // set to zero to avoid unexpected value
buffer_load_d16_u8 v[vgprG2LMetadata+0+1], v[vgprGlobalReadOffsetMetadata+0], s[sgprSrdMetadata:sgprSrdMetadata+3], null offen offset:4 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=0, load component 5 */
v_mov_b32 v50, 0                                   // set to zero to avoid unexpected value
buffer_load_d16_u8 v50, v[vgprGlobalReadOffsetMetadata+0], s[sgprSrdMetadata:sgprSrdMetadata+3], null offen offset:5 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=0, load component 6 */
v_mov_b32 v51, 0                                   // set to zero to avoid unexpected value
buffer_load_d16_hi_u8 v51, v[vgprGlobalReadOffsetMetadata+0], s[sgprSrdMetadata:sgprSrdMetadata+3], null offen offset:6 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
/* g2l=0, load component 7 */
v_mov_b32 v52, 0                                   // set to zero to avoid unexpected value
buffer_load_d16_hi_u8 v52, v[vgprGlobalReadOffsetMetadata+0], s[sgprSrdMetadata:sgprSrdMetadata+3], null offen offset:7 scope:SCOPE_CU th:TH_LOAD_RT // load one buffer value
s_wait_loadcnt 6
v_lshlrev_b32 v46, 0x8, v46                        // shift left to higher 8 bits
v_or_b32 v[vgprG2LMetadata+0+0], v[vgprG2LMetadata+0+0], v46 // pack a sub 8-bit with dest
s_wait_loadcnt 5
v_or_b32 v[vgprG2LMetadata+0+0], v[vgprG2LMetadata+0+0], v47 // pack a sub 8-bit with dest
s_wait_loadcnt 4
v_lshlrev_b32 v48, 0x8, v48                        // shift left to higher 8 bits
s_delay_alu instid0(VALU_DEP_1)
v_or_b32 v[vgprG2LMetadata+0+0], v[vgprG2LMetadata+0+0], v48 // pack a sub 8-bit with dest
s_wait_loadcnt 2
v_lshlrev_b32 v50, 0x8, v50                        // shift left to higher 8 bits
v_or_b32 v[vgprG2LMetadata+0+1], v[vgprG2LMetadata+0+1], v50 // pack a sub 8-bit with dest
s_wait_loadcnt 1
v_or_b32 v[vgprG2LMetadata+0+1], v[vgprG2LMetadata+0+1], v51 // pack a sub 8-bit with dest
s_wait_loadcnt 0
v_lshlrev_b32 v52, 0x8, v52                        // shift left to higher 8 bits
s_delay_alu instid0(VALU_DEP_1)
v_or_b32 v[vgprG2LMetadata+0+1], v[vgprG2LMetadata+0+1], v52 // pack a sub 8-bit with dest
s_wait_loadcnt 0                                   // 2wait for global read
// Skip barrier: NumThreads=32

/* local write a */
ds_store_b128 v[vgprLocalWriteAddrA+0], v[vgprG2LA+0:vgprG2LA+0+3] offset:0 // lwoA_0_0_0_0 = (0*LSCA) + (0*LSPA)(*MT0I+PAD) = 0 sync LDS0
ds_store_b128 v[vgprLocalWriteAddrA+0], v[vgprG2LA+4:vgprG2LA+4+3] offset:544 // lwoA_0_0_1_0 = (0*LSCA) + (1*LSPA)(*MT0I+PAD) = 544 sync LDS0
ds_store_b128 v[vgprLocalWriteAddrA+0], v[vgprG2LA+8:vgprG2LA+8+3] offset:1088 // lwoA_0_0_2_0 = (0*LSCA) + (2*LSPA)(*MT0I+PAD) = 1088 sync LDS0
ds_store_b128 v[vgprLocalWriteAddrA+0], v[vgprG2LA+12:vgprG2LA+12+3] offset:1632 // lwoA_0_0_3_0 = (0*LSCA) + (3*LSPA)(*MT0I+PAD) = 1632 sync LDS0

/* local write b */
ds_store_b128 v[vgprLocalWriteAddrB+0], v[vgprG2LB+0:vgprG2LB+0+3] offset:0 // lwoB_0_0_0_0 = (0*LSCB)*(MT1J+PAD) + (0*LSPB) = 0 sync LDS0
ds_store_b128 v[vgprLocalWriteAddrB+0], v[vgprG2LB+4:vgprG2LB+4+3] offset:544 // lwoB_0_0_1_0 = (0*LSCB)*(MT1J+PAD) + (1*LSPB) = 544 sync LDS0
ds_store_b64 v[vgprLocalWriteAddrMetadata+0], v[vgprG2LMetadata+0:vgprG2LMetadata+0+1] offset:0 // lwoMetadata_0_0_0_0 = (0*LSCMetadata)*(MT1J+PAD) + (0*LSPMetadata) = 0 sync LDS0

/* Recalc local read offsets */
s_wait_dscnt 0                                     // 5wait for local write
// Skip barrier: NumThreads=32Tail loop LW->LR, sync LDS0
.set vgprG2LA_BASE, UNDEF
.set vgprG2LA, UNDEF
.set vgprG2LB_BASE, UNDEF
.set vgprG2LB, UNDEF
.set vgprG2LMetadata, UNDEF
.set vgprValuA_X0_I0_BASE, 20
.set vgprValuA_X0_I0, vgprValuA_X0_I0_BASE+0
.set vgprValuA_X0_I0_D0_PACK, 36
.set vgprValuA_X0_I0_D1, vgprValuA_X0_I0_D0_PACK+0
.set vgprValuA_X0_I0_D2, vgprValuA_X0_I0_D0_PACK+16
.set vgprValuA_X0_I0_D3, vgprValuA_X0_I0_D0_PACK+32
.set vgprValuB_X0_I0_BASE, 84
.set vgprValuB_X0_I0, vgprValuB_X0_I0_BASE+0
.set vgprValuMetadata_X0_I0_BASE, 92
.set vgprValuMetadata_X0_I0, vgprValuMetadata_X0_I0_BASE+0
.set vgprPackTemp, 94

/* Tail: local read reset offsets a */

/* localReadResetOffsets */
/* handled internally */
v_and_b32 v[vgprLocalReadAddrA+0], 0xfff, v[vgprLocalReadAddrA+0] // reset Red,Blk -> Red

/* Tail: local read reset offsets b */

/* localReadResetOffsets */
/* handled internally */
v_and_b32 v[vgprLocalReadAddrB+0], 0xfff, v[vgprLocalReadAddrB+0] // reset Red,Blk -> Red

/* Tail: local read init pointers a */

/* localReadInitPointers */

/* Tail: local read init pointers b */

/* localReadInitPointers */

/* local read reset offsets metadata */

/* localReadResetOffsets */
/* handled internally */
v_and_b32 v[vgprLocalReadAddrMetadata+0], 0xfff, v[vgprLocalReadAddrMetadata+0] // reset Red,Blk -> Red

/* local read init pointers metadata */

/* localReadInitPointers */

/* tail loop: macs */
.align 16
label_TailLoopBeginL:

/* local read a */
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
ds_load_u8 v[vgprValuA_X0_I0+0], v[vgprLocalReadAddrA+0] offset:0 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D1+0], v[vgprLocalReadAddrA+0] offset:16 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D2+0], v[vgprLocalReadAddrA+0] offset:32 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=2 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D3+0], v[vgprLocalReadAddrA+0] offset:48 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=3 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0+1], v[vgprLocalReadAddrA+0] offset:64 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=4 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D1+1], v[vgprLocalReadAddrA+0] offset:80 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=5 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D2+1], v[vgprLocalReadAddrA+0] offset:96 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=6 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D3+1], v[vgprLocalReadAddrA+0] offset:112 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=7 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0+2], v[vgprLocalReadAddrA+0] offset:128 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=8 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D1+2], v[vgprLocalReadAddrA+0] offset:144 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=9 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D2+2], v[vgprLocalReadAddrA+0] offset:160 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=10 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D3+2], v[vgprLocalReadAddrA+0] offset:176 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=11 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0+3], v[vgprLocalReadAddrA+0] offset:192 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=12 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D1+3], v[vgprLocalReadAddrA+0] offset:208 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=13 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D2+3], v[vgprLocalReadAddrA+0] offset:224 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=14 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D3+3], v[vgprLocalReadAddrA+0] offset:240 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=15 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0+4], v[vgprLocalReadAddrA+0] offset:272 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=16 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D1+4], v[vgprLocalReadAddrA+0] offset:288 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=17 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D2+4], v[vgprLocalReadAddrA+0] offset:304 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=18 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D3+4], v[vgprLocalReadAddrA+0] offset:320 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=19 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0+5], v[vgprLocalReadAddrA+0] offset:336 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=20 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D1+5], v[vgprLocalReadAddrA+0] offset:352 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=21 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D2+5], v[vgprLocalReadAddrA+0] offset:368 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=22 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D3+5], v[vgprLocalReadAddrA+0] offset:384 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=23 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0+6], v[vgprLocalReadAddrA+0] offset:400 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=24 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D1+6], v[vgprLocalReadAddrA+0] offset:416 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=25 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D2+6], v[vgprLocalReadAddrA+0] offset:432 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=26 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D3+6], v[vgprLocalReadAddrA+0] offset:448 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=27 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0+7], v[vgprLocalReadAddrA+0] offset:464 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=28 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D1+7], v[vgprLocalReadAddrA+0] offset:480 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=29 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D2+7], v[vgprLocalReadAddrA+0] offset:496 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=30 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D3+7], v[vgprLocalReadAddrA+0] offset:512 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=31 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0+8], v[vgprLocalReadAddrA+0] offset:1088 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=32 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D1+8], v[vgprLocalReadAddrA+0] offset:1104 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=33 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D2+8], v[vgprLocalReadAddrA+0] offset:1120 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=34 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D3+8], v[vgprLocalReadAddrA+0] offset:1136 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=35 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0+9], v[vgprLocalReadAddrA+0] offset:1152 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=36 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D1+9], v[vgprLocalReadAddrA+0] offset:1168 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=37 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D2+9], v[vgprLocalReadAddrA+0] offset:1184 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=38 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D3+9], v[vgprLocalReadAddrA+0] offset:1200 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=39 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0+10], v[vgprLocalReadAddrA+0] offset:1216 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=40 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D1+10], v[vgprLocalReadAddrA+0] offset:1232 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=41 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D2+10], v[vgprLocalReadAddrA+0] offset:1248 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=42 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D3+10], v[vgprLocalReadAddrA+0] offset:1264 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=43 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0+11], v[vgprLocalReadAddrA+0] offset:1280 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=44 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D1+11], v[vgprLocalReadAddrA+0] offset:1296 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=45 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D2+11], v[vgprLocalReadAddrA+0] offset:1312 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=46 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D3+11], v[vgprLocalReadAddrA+0] offset:1328 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=47 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0+12], v[vgprLocalReadAddrA+0] offset:1360 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=48 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D1+12], v[vgprLocalReadAddrA+0] offset:1376 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=49 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D2+12], v[vgprLocalReadAddrA+0] offset:1392 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=50 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D3+12], v[vgprLocalReadAddrA+0] offset:1408 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=51 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0+13], v[vgprLocalReadAddrA+0] offset:1424 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=52 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D1+13], v[vgprLocalReadAddrA+0] offset:1440 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=53 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D2+13], v[vgprLocalReadAddrA+0] offset:1456 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=54 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D3+13], v[vgprLocalReadAddrA+0] offset:1472 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=55 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0+14], v[vgprLocalReadAddrA+0] offset:1488 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=56 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D1+14], v[vgprLocalReadAddrA+0] offset:1504 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=57 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D2+14], v[vgprLocalReadAddrA+0] offset:1520 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=58 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D3+14], v[vgprLocalReadAddrA+0] offset:1536 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=59 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0+15], v[vgprLocalReadAddrA+0] offset:1552 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=60 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D1+15], v[vgprLocalReadAddrA+0] offset:1568 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=61 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D2+15], v[vgprLocalReadAddrA+0] offset:1584 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=62 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_u8 v[vgprValuA_X0_I0_D3+15], v[vgprLocalReadAddrA+0] offset:1600 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=63 oIdx=0 buffer=0 iui=0 sync LDS0

/* local read metadata */
ds_load_b64 v[vgprValuMetadata_X0_I0+0:vgprValuMetadata_X0_I0+0+1], v[vgprLocalReadAddrMetadata+0] offset:0 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS0

/* local read b */
ds_load_b128 v[vgprValuB_X0_I0+0:vgprValuB_X0_I0+0+3], v[vgprLocalReadAddrB+0] offset:0 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=0 oIdx=0 buffer=0 iui=0 sync LDS0
ds_load_b128 v[vgprValuB_X0_I0+4:vgprValuB_X0_I0+4+3], v[vgprLocalReadAddrB+0] offset:32 // L -> Reg lro=0 swapByteOffset=0 ti=16 vIdx=0 eIdx=0 rIdx=1 oIdx=0 buffer=0 iui=0 sync LDS0

/* local read inc a */
/* Adding additional 128 pad since cumulative inc has reached 256 */
s_mov_b32 s8, 2176                                 // inc
v_add_co_u32 v[vgprLocalReadAddrA+0], vcc_lo, s8, v[vgprLocalReadAddrA+0] // lrA += 2048 ((MT+PAD)*bpeDS)

/* local read inc metadata */
s_mov_b32 s8, 16                                   // inc
v_add_co_u32 v[vgprLocalReadAddrMetadata+0], vcc_lo, s8, v[vgprLocalReadAddrMetadata+0] // lrMetadata += 16 (bpeDS)

/* local read inc b */
s_mov_b32 s8, 64                                   // inc
v_add_co_u32 v[vgprLocalReadAddrB+0], vcc_lo, s8, v[vgprLocalReadAddrB+0] // lrB += 64 (bpeDS)
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
v_lshl_or_b32 v[vgprValuA_X0_I0+8], v[vgprValuA_X0_I0_D1+8], 8, v[vgprValuA_X0_I0+8] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+8], v[vgprValuA_X0_I0_D3+8], 8, v[vgprValuA_X0_I0_D2+8] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+8], v[vgprValuA_X0_I0_D2+8], 0x10, v[vgprValuA_X0_I0+8] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+9], v[vgprValuA_X0_I0_D1+9], 8, v[vgprValuA_X0_I0+9] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+9], v[vgprValuA_X0_I0_D3+9], 8, v[vgprValuA_X0_I0_D2+9] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+9], v[vgprValuA_X0_I0_D2+9], 0x10, v[vgprValuA_X0_I0+9] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+10], v[vgprValuA_X0_I0_D1+10], 8, v[vgprValuA_X0_I0+10] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+10], v[vgprValuA_X0_I0_D3+10], 8, v[vgprValuA_X0_I0_D2+10] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+10], v[vgprValuA_X0_I0_D2+10], 0x10, v[vgprValuA_X0_I0+10] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+11], v[vgprValuA_X0_I0_D1+11], 8, v[vgprValuA_X0_I0+11] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+11], v[vgprValuA_X0_I0_D3+11], 8, v[vgprValuA_X0_I0_D2+11] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+11], v[vgprValuA_X0_I0_D2+11], 0x10, v[vgprValuA_X0_I0+11] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+12], v[vgprValuA_X0_I0_D1+12], 8, v[vgprValuA_X0_I0+12] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+12], v[vgprValuA_X0_I0_D3+12], 8, v[vgprValuA_X0_I0_D2+12] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+12], v[vgprValuA_X0_I0_D2+12], 0x10, v[vgprValuA_X0_I0+12] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+13], v[vgprValuA_X0_I0_D1+13], 8, v[vgprValuA_X0_I0+13] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+13], v[vgprValuA_X0_I0_D3+13], 8, v[vgprValuA_X0_I0_D2+13] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+13], v[vgprValuA_X0_I0_D2+13], 0x10, v[vgprValuA_X0_I0+13] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+14], v[vgprValuA_X0_I0_D1+14], 8, v[vgprValuA_X0_I0+14] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+14], v[vgprValuA_X0_I0_D3+14], 8, v[vgprValuA_X0_I0_D2+14] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+14], v[vgprValuA_X0_I0_D2+14], 0x10, v[vgprValuA_X0_I0+14] // pack two half Vgpr to one Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+15], v[vgprValuA_X0_I0_D1+15], 8, v[vgprValuA_X0_I0+15] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0_D2+15], v[vgprValuA_X0_I0_D3+15], 8, v[vgprValuA_X0_I0_D2+15] // pack two int8 Vgpr to one half Vgpr
v_lshl_or_b32 v[vgprValuA_X0_I0+15], v[vgprValuA_X0_I0_D2+15], 0x10, v[vgprValuA_X0_I0+15] // pack two half Vgpr to one Vgpr
v_and_b32 v95, 31, v[vgprSerial]                   // v95 = v[vgprSerial] % 32
v_lshrrev_b32 v95, 4, v95                          // 95 = 95 / 16
v_lshlrev_b32 v95, 4, v95                          // v95 = v95 * 16
v_add_nc_u32 v96, v95, 0
v_cmp_ge_i32 s80, v96, s[sgprLoopCounterL]         // check K index >= Size L
v_cndmask_b32 v[vgprValuA_X0_I0+0+0+0+0], v[vgprValuA_X0_I0+0+0+0+0], 0, s80 // set 0 if K_idx >= sizeL
v_cndmask_b32 v[vgprValuA_X0_I0+0+0+0+1], v[vgprValuA_X0_I0+0+0+0+1], 0, s80 // set 0 if K_idx >= sizeL
s_delay_alu instid0(VALU_DEP_4)
v_add_nc_u32 v96, v96, 8                           // add part of K
v_cmp_ge_i32 s80, v96, s[sgprLoopCounterL]         // check K index >= Size L
v_cndmask_b32 v[vgprValuA_X0_I0+0+0+0+2], v[vgprValuA_X0_I0+0+0+0+2], 0, s80 // set 0 if K_idx >= sizeL
v_cndmask_b32 v[vgprValuA_X0_I0+0+0+0+3], v[vgprValuA_X0_I0+0+0+0+3], 0, s80 // set 0 if K_idx >= sizeL
s_delay_alu instid0(VALU_DEP_4)
v_add_nc_u32 v96, v96, 8                           // add part of K
v_cmp_ge_i32 s80, v96, s[sgprLoopCounterL]         // check K index >= Size L
v_cndmask_b32 v[vgprValuA_X0_I0+0+0+0+4], v[vgprValuA_X0_I0+0+0+0+4], 0, s80 // set 0 if K_idx >= sizeL
v_cndmask_b32 v[vgprValuA_X0_I0+0+0+0+5], v[vgprValuA_X0_I0+0+0+0+5], 0, s80 // set 0 if K_idx >= sizeL
s_delay_alu instid0(VALU_DEP_4)
v_add_nc_u32 v96, v96, 8                           // add part of K
v_cmp_ge_i32 s80, v96, s[sgprLoopCounterL]         // check K index >= Size L
v_cndmask_b32 v[vgprValuA_X0_I0+0+0+0+6], v[vgprValuA_X0_I0+0+0+0+6], 0, s80 // set 0 if K_idx >= sizeL
v_cndmask_b32 v[vgprValuA_X0_I0+0+0+0+7], v[vgprValuA_X0_I0+0+0+0+7], 0, s80 // set 0 if K_idx >= sizeL
s_delay_alu instid0(VALU_DEP_4)
v_add_nc_u32 v96, v96, 40                          // add part of K (block offset + group offset)
v_cmp_ge_i32 s80, v96, s[sgprLoopCounterL]         // check K index >= Size L
v_cndmask_b32 v[vgprValuA_X0_I0+0+0+0+8], v[vgprValuA_X0_I0+0+0+0+8], 0, s80 // set 0 if K_idx >= sizeL
v_cndmask_b32 v[vgprValuA_X0_I0+0+0+0+9], v[vgprValuA_X0_I0+0+0+0+9], 0, s80 // set 0 if K_idx >= sizeL
s_delay_alu instid0(VALU_DEP_4)
v_add_nc_u32 v96, v96, 8                           // add part of K
v_cmp_ge_i32 s80, v96, s[sgprLoopCounterL]         // check K index >= Size L
v_cndmask_b32 v[vgprValuA_X0_I0+0+0+0+10], v[vgprValuA_X0_I0+0+0+0+10], 0, s80 // set 0 if K_idx >= sizeL
v_cndmask_b32 v[vgprValuA_X0_I0+0+0+0+11], v[vgprValuA_X0_I0+0+0+0+11], 0, s80 // set 0 if K_idx >= sizeL
s_delay_alu instid0(VALU_DEP_4)
v_add_nc_u32 v96, v96, 8                           // add part of K
v_cmp_ge_i32 s80, v96, s[sgprLoopCounterL]         // check K index >= Size L
v_cndmask_b32 v[vgprValuA_X0_I0+0+0+0+12], v[vgprValuA_X0_I0+0+0+0+12], 0, s80 // set 0 if K_idx >= sizeL
v_cndmask_b32 v[vgprValuA_X0_I0+0+0+0+13], v[vgprValuA_X0_I0+0+0+0+13], 0, s80 // set 0 if K_idx >= sizeL
s_delay_alu instid0(VALU_DEP_4)
v_add_nc_u32 v96, v96, 8                           // add part of K
v_cmp_ge_i32 s80, v96, s[sgprLoopCounterL]         // check K index >= Size L
v_cndmask_b32 v[vgprValuA_X0_I0+0+0+0+14], v[vgprValuA_X0_I0+0+0+0+14], 0, s80 // set 0 if K_idx >= sizeL
v_cndmask_b32 v[vgprValuA_X0_I0+0+0+0+15], v[vgprValuA_X0_I0+0+0+0+15], 0, s80 // set 0 if K_idx >= sizeL
v_and_b32 v95, 31, v[vgprSerial]                   // v95 = v[vgprSerial] % 32
v_lshrrev_b32 v95, 4, v95                          // 95 = 95 / 16
v_lshlrev_b32 v95, 5, v95                          // v95 = v95 * 32
v_add_nc_u32 v96, v95, 0
v_cmp_ge_i32 s80, v96, s[sgprLoopCounterL]         // check K index >= Size L
v_cndmask_b32 v[vgprValuB_X0_I0+0+0+0+0], v[vgprValuB_X0_I0+0+0+0+0], 0, s80 // set 0 if K_idx >= sizeL
s_delay_alu instid0(VALU_DEP_3)
v_add_nc_u32 v96, v96, 8                           // add part of K
v_cmp_ge_i32 s80, v96, s[sgprLoopCounterL]         // check K index >= Size L
v_cndmask_b32 v[vgprValuB_X0_I0+0+0+0+1], v[vgprValuB_X0_I0+0+0+0+1], 0, s80 // set 0 if K_idx >= sizeL
s_delay_alu instid0(VALU_DEP_3)
v_add_nc_u32 v96, v96, 8                           // add part of K
v_cmp_ge_i32 s80, v96, s[sgprLoopCounterL]         // check K index >= Size L
v_cndmask_b32 v[vgprValuB_X0_I0+0+0+0+2], v[vgprValuB_X0_I0+0+0+0+2], 0, s80 // set 0 if K_idx >= sizeL
s_delay_alu instid0(VALU_DEP_3)
v_add_nc_u32 v96, v96, 8                           // add part of K
v_cmp_ge_i32 s80, v96, s[sgprLoopCounterL]         // check K index >= Size L
v_cndmask_b32 v[vgprValuB_X0_I0+0+0+0+3], v[vgprValuB_X0_I0+0+0+0+3], 0, s80 // set 0 if K_idx >= sizeL
s_delay_alu instid0(VALU_DEP_3)
v_add_nc_u32 v96, v96, 40                          // add part of K (block offset + group offset)
v_cmp_ge_i32 s80, v96, s[sgprLoopCounterL]         // check K index >= Size L
v_cndmask_b32 v[vgprValuB_X0_I0+0+0+0+4], v[vgprValuB_X0_I0+0+0+0+4], 0, s80 // set 0 if K_idx >= sizeL
s_delay_alu instid0(VALU_DEP_3)
v_add_nc_u32 v96, v96, 8                           // add part of K
v_cmp_ge_i32 s80, v96, s[sgprLoopCounterL]         // check K index >= Size L
v_cndmask_b32 v[vgprValuB_X0_I0+0+0+0+5], v[vgprValuB_X0_I0+0+0+0+5], 0, s80 // set 0 if K_idx >= sizeL
s_delay_alu instid0(VALU_DEP_3)
v_add_nc_u32 v96, v96, 8                           // add part of K
v_cmp_ge_i32 s80, v96, s[sgprLoopCounterL]         // check K index >= Size L
v_cndmask_b32 v[vgprValuB_X0_I0+0+0+0+6], v[vgprValuB_X0_I0+0+0+0+6], 0, s80 // set 0 if K_idx >= sizeL
s_delay_alu instid0(VALU_DEP_3)
v_add_nc_u32 v96, v96, 8                           // add part of K
v_cmp_ge_i32 s80, v96, s[sgprLoopCounterL]         // check K index >= Size L
v_cndmask_b32 v[vgprValuB_X0_I0+0+0+0+7], v[vgprValuB_X0_I0+0+0+0+7], 0, s80 // set 0 if K_idx >= sizeL
s_and_b32 s79, s[sgprLoopCounterL], 7              // get inputs for edge thread
s_delay_alu instid0(SALU_CYCLE_1)
s_sub_u32 s79, 8, s79                              // use shift to fill 0 for outside element
s_delay_alu instid0(SALU_CYCLE_1)
s_lshl_b32 s79, s79, 3                             // use shift to fill 0 for outside element
v_lshlrev_b64 v[98:99], s79, v[vgprValuA_X0_I0+0+0+0+0:vgprValuA_X0_I0+0+0+0+0+1]
v_lshlrev_b64 v[100:101], s79, v[vgprValuA_X0_I0+0+0+0+2:vgprValuA_X0_I0+0+0+0+2+1]
v_lshlrev_b64 v[102:103], s79, v[vgprValuA_X0_I0+0+0+0+4:vgprValuA_X0_I0+0+0+0+4+1]
v_lshlrev_b64 v[104:105], s79, v[vgprValuA_X0_I0+0+0+0+6:vgprValuA_X0_I0+0+0+0+6+1]
v_lshlrev_b64 v[106:107], s79, v[vgprValuA_X0_I0+0+0+0+8:vgprValuA_X0_I0+0+0+0+8+1]
v_lshlrev_b64 v[108:109], s79, v[vgprValuA_X0_I0+0+0+0+10:vgprValuA_X0_I0+0+0+0+10+1]
v_lshlrev_b64 v[110:111], s79, v[vgprValuA_X0_I0+0+0+0+12:vgprValuA_X0_I0+0+0+0+12+1]
v_lshlrev_b64 v[112:113], s79, v[vgprValuA_X0_I0+0+0+0+14:vgprValuA_X0_I0+0+0+0+14+1]
v_add_nc_u32 v96, v95, 8                           // add part of K: 64 bit groupd
v_cmp_ge_i32 s80, v96, s[sgprLoopCounterL]         // check K index >= Size L
v_cndmask_b32 v[vgprValuA_X0_I0+0+0+0+0], v[vgprValuA_X0_I0+0+0+0+0], v98, s80
v_cmp_ge_i32 s80, v96, s[sgprLoopCounterL]         // check K index >= Size L
v_cndmask_b32 v[vgprValuA_X0_I0+0+0+0+1], v[vgprValuA_X0_I0+0+0+0+1], v99, s80
v_add_nc_u32 v96, v96, 8                           // add part of K: 64 bit groupd
v_cmp_ge_i32 s80, v96, s[sgprLoopCounterL]         // check K index >= Size L
v_cndmask_b32 v[vgprValuA_X0_I0+0+0+0+2], v[vgprValuA_X0_I0+0+0+0+2], v100, s80
v_cmp_ge_i32 s80, v96, s[sgprLoopCounterL]         // check K index >= Size L
v_cndmask_b32 v[vgprValuA_X0_I0+0+0+0+3], v[vgprValuA_X0_I0+0+0+0+3], v101, s80
v_add_nc_u32 v96, v96, 24                          // add part of K: 64 bit groupd
v_cmp_ge_i32 s80, v96, s[sgprLoopCounterL]         // check K index >= Size L
v_cndmask_b32 v[vgprValuA_X0_I0+0+0+0+4], v[vgprValuA_X0_I0+0+0+0+4], v102, s80
v_cmp_ge_i32 s80, v96, s[sgprLoopCounterL]         // check K index >= Size L
v_cndmask_b32 v[vgprValuA_X0_I0+0+0+0+5], v[vgprValuA_X0_I0+0+0+0+5], v103, s80
v_add_nc_u32 v96, v96, 8                           // add part of K: 64 bit groupd
v_cmp_ge_i32 s80, v96, s[sgprLoopCounterL]         // check K index >= Size L
v_cndmask_b32 v[vgprValuA_X0_I0+0+0+0+6], v[vgprValuA_X0_I0+0+0+0+6], v104, s80
v_cmp_ge_i32 s80, v96, s[sgprLoopCounterL]         // check K index >= Size L
v_cndmask_b32 v[vgprValuA_X0_I0+0+0+0+7], v[vgprValuA_X0_I0+0+0+0+7], v105, s80
v_add_nc_u32 v96, v96, 24                          // add part of K: 64 bit groupd
v_cmp_ge_i32 s80, v96, s[sgprLoopCounterL]         // check K index >= Size L
v_cndmask_b32 v[vgprValuA_X0_I0+0+0+0+8], v[vgprValuA_X0_I0+0+0+0+8], v106, s80
v_cmp_ge_i32 s80, v96, s[sgprLoopCounterL]         // check K index >= Size L
v_cndmask_b32 v[vgprValuA_X0_I0+0+0+0+9], v[vgprValuA_X0_I0+0+0+0+9], v107, s80
v_add_nc_u32 v96, v96, 8                           // add part of K: 64 bit groupd
v_cmp_ge_i32 s80, v96, s[sgprLoopCounterL]         // check K index >= Size L
v_cndmask_b32 v[vgprValuA_X0_I0+0+0+0+10], v[vgprValuA_X0_I0+0+0+0+10], v108, s80
v_cmp_ge_i32 s80, v96, s[sgprLoopCounterL]         // check K index >= Size L
v_cndmask_b32 v[vgprValuA_X0_I0+0+0+0+11], v[vgprValuA_X0_I0+0+0+0+11], v109, s80
v_add_nc_u32 v96, v96, 24                          // add part of K: 64 bit groupd
v_cmp_ge_i32 s80, v96, s[sgprLoopCounterL]         // check K index >= Size L
v_cndmask_b32 v[vgprValuA_X0_I0+0+0+0+12], v[vgprValuA_X0_I0+0+0+0+12], v110, s80
v_cmp_ge_i32 s80, v96, s[sgprLoopCounterL]         // check K index >= Size L
v_cndmask_b32 v[vgprValuA_X0_I0+0+0+0+13], v[vgprValuA_X0_I0+0+0+0+13], v111, s80
v_add_nc_u32 v96, v96, 8                           // add part of K: 64 bit groupd
v_cmp_ge_i32 s80, v96, s[sgprLoopCounterL]         // check K index >= Size L
v_cndmask_b32 v[vgprValuA_X0_I0+0+0+0+14], v[vgprValuA_X0_I0+0+0+0+14], v112, s80
v_cmp_ge_i32 s80, v96, s[sgprLoopCounterL]         // check K index >= Size L
v_cndmask_b32 v[vgprValuA_X0_I0+0+0+0+15], v[vgprValuA_X0_I0+0+0+0+15], v113, s80
v_lshlrev_b64 v[98:99], s79, v[vgprValuB_X0_I0+0+0+0+0:vgprValuB_X0_I0+0+0+0+0+1]
v_lshlrev_b64 v[100:101], s79, v[vgprValuB_X0_I0+0+0+0+2:vgprValuB_X0_I0+0+0+0+2+1]
v_lshlrev_b64 v[102:103], s79, v[vgprValuB_X0_I0+0+0+0+4:vgprValuB_X0_I0+0+0+0+4+1]
v_lshlrev_b64 v[104:105], s79, v[vgprValuB_X0_I0+0+0+0+6:vgprValuB_X0_I0+0+0+0+6+1]
v_add_nc_u32 v96, v95, 8                           // add part of K: 64 bits group
v_cmp_ge_i32 s80, v96, s[sgprLoopCounterL]         // check K index >= Size L
v_cndmask_b32 v[vgprValuB_X0_I0+0+0+0+0], v[vgprValuB_X0_I0+0+0+0+0], v98, s80
v_cmp_ge_i32 s80, v96, s[sgprLoopCounterL]         // check K index >= Size L
v_cndmask_b32 v[vgprValuB_X0_I0+0+0+0+1], v[vgprValuB_X0_I0+0+0+0+1], v99, s80
v_add_nc_u32 v96, v96, 8                           // add part of K: 64 bits group
v_cmp_ge_i32 s80, v96, s[sgprLoopCounterL]         // check K index >= Size L
v_cndmask_b32 v[vgprValuB_X0_I0+0+0+0+2], v[vgprValuB_X0_I0+0+0+0+2], v100, s80
v_cmp_ge_i32 s80, v96, s[sgprLoopCounterL]         // check K index >= Size L
v_cndmask_b32 v[vgprValuB_X0_I0+0+0+0+3], v[vgprValuB_X0_I0+0+0+0+3], v101, s80
v_add_nc_u32 v96, v96, 24                          // add part of K: 64 bit groupd
v_cmp_ge_i32 s80, v96, s[sgprLoopCounterL]         // check K index >= Size L
v_cndmask_b32 v[vgprValuB_X0_I0+0+0+0+4], v[vgprValuB_X0_I0+0+0+0+4], v102, s80
v_cmp_ge_i32 s80, v96, s[sgprLoopCounterL]         // check K index >= Size L
v_cndmask_b32 v[vgprValuB_X0_I0+0+0+0+5], v[vgprValuB_X0_I0+0+0+0+5], v103, s80
v_add_nc_u32 v96, v96, 8                           // add part of K: 64 bits group
v_cmp_ge_i32 s80, v96, s[sgprLoopCounterL]         // check K index >= Size L
v_cndmask_b32 v[vgprValuB_X0_I0+0+0+0+6], v[vgprValuB_X0_I0+0+0+0+6], v104, s80
v_cmp_ge_i32 s80, v96, s[sgprLoopCounterL]         // check K index >= Size L
v_cndmask_b32 v[vgprValuB_X0_I0+0+0+0+7], v[vgprValuB_X0_I0+0+0+0+7], v105, s80
label_TailLoop_SkipZeroOutMask_J5DQFVGFWLXU2DUR:
s_nop 1
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_swmmac_f32_16x16x128_fp8_fp8 v[vgprValuC+0:vgprValuC+0+7], v[vgprValuB_X0_I0+0+0+0:vgprValuB_X0_I0+0+0+0+7], v[vgprValuA_X0_I0+0+0+0:vgprValuA_X0_I0+0+0+0+15], v[vgprValuMetadata_X0_I0+0+0+0:vgprValuMetadata_X0_I0+0+0+0+1] // left value = v[0+0:7+0]

/* closeLoop loopL finalLoop=1 tailLoop=1 */
s_sub_i32 s[sgprLoopCounterL], s[sgprLoopCounterL], 0x80 // dec counterL (tailLoop)
s_add_u32 s[sgprOrigLoopCounter], s[sgprOrigLoopCounter], 0x80 // inc counterL
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
.set vgprValuMetadata_X0_I0_BASE, UNDEF
.set vgprValuMetadata_X0_I0, UNDEF
.set vgprPackTemp, UNDEF

/* Tail: add MISC Vgpr [8...20) to pool */

/* Tail: add LocalReadAddrA Vgpr [126...127) to pool */
label_Summation_End_DLSAQLEVYLOBCPNL:
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
.set sgprSrdMetadata, UNDEF
.set sgprShadowLimitA, UNDEF
.set sgprShadowLimitB, UNDEF
.set sgprShadowLimitMetadata, UNDEF
.set sgprWrapUA, UNDEF
.set sgprWrapUB, UNDEF
.set sgprWrapUMetadata, UNDEF
.set sgprGlobalReadIncsA, UNDEF
.set sgprGlobalReadIncsB, UNDEF
.set sgprGlobalReadIncsMetadata, UNDEF
/* load store sgprs */
.set sgprAddressScaleAlphaVec, 60
.set sgprAddressBias, 62
.set sgprBiasType, 64
.set sgprBiasStride, 65
.set sgprFactorDim, 66
.set sgpractivationAlpha, 67
.set sgpractivationBeta, 68
.set sgprActivationType, 69
s_and_b32 s8, s[sgprGSU], 0x3fff                   // Restore GSU
s_delay_alu instid0(SALU_CYCLE_1)
s_cmp_eq_u32 s8, 1                                 // GSU == 1 ?
s_cbranch_scc0 label_GSU_4                         // branch if GSU != 1
/* Check if custom structure pointer is null */
s_cmp_eq_u32 s[sgprArgType], 2                     // ArgType == 2 ?
s_cbranch_scc1 label_LoadExternalEpilogueStruct_1  // branch if ArgType == 2
s_load_b256 s[60:67], s[sgprKernArgAddress:sgprKernArgAddress+1], 104 // 104
s_load_b64 s[68:69], s[sgprKernArgAddress:sgprKernArgAddress+1], 136 // 136
s_branch label_LoadExternalEpilogueStructEnd_1
label_LoadExternalEpilogueStruct_1:
s_load_b128 s[60:63], s[sgprKernArgAddress:sgprKernArgAddress+1], 160 // 160
s_load_b64 s[64:65], s[sgprKernArgAddress:sgprKernArgAddress+1], 176 // 176
s_load_b32 s66, s[sgprKernArgAddress:sgprKernArgAddress+1], 184 // 184
s_load_b32 s67, s[sgprKernArgAddress:sgprKernArgAddress+1], 204 // 204
s_load_b64 s[68:69], s[sgprKernArgAddress:sgprKernArgAddress+1], 208 // 208
label_LoadExternalEpilogueStructEnd_1:
label_GSU_4:
.set sgprSrdScaleAlphaVec, 24
.set sgprSrdBias, 28

/* Mapping of Acc register -> C Vgpr register */

/* Multiply MI out register with Alpha -> C Vgpr register */

/* shift vector components d0 */
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v11, s[sgprWorkGroup0]
s_delay_alu instid0(VALU_DEP_1)
v_mul_i32_i24 v11, -0x10, v11                      // wg*MT
v_add_co_u32 v11, vcc_lo, s[sgprSizesFree+0], v11  // wgMT = Size - wg*MT
v_mov_b32 v12, 0x10                                // MT
s_delay_alu instid0(VALU_DEP_1)
v_cmp_lt_u32 s8, v11, v12                          // wgMT < MT
s_delay_alu instid0(VALU_DEP_1)
v_cndmask_b32 v11, v12, v11, s8                    // wgMT = (wgMT < MT) ? wgMT : MT
v_lshrrev_b32 v13, 5, v[vgprSerial]                // 13 = Serial / 32
v_and_b32 v13, 0, v13                              // v13 = v13 % 1
v_lshrrev_b32 v14, 4, v11                          // 14 = 11 / 16
v_and_b32 v14, 0, v14                              // v14 = v14 % 1
v_cmp_eq_u32 s8, v14, v13                          // wave_id == block_belong_to_wave?
s_delay_alu instid0(VALU_DEP_1)
v_cndmask_b32 v11, v12, v11, s8                    // wgMT = (wgMT < MT) ? wgMT : MT

/* mbReg: which mb block need to shift, mb(matrixInstCoal(16) * VectorWidth(1)) */
v_lshrrev_b32 v12, 4, v11                          // 12 = 11 / 16
v_lshlrev_b32 v14, 0, v13                          // v14 = v13 * 1
v_sub_nc_u32 v12, v12, v14

/* gbReg: glvw block id */
v_lshrrev_b32 v14, 4, v11                          // 14 = 11 / 16

/* tgbReg: glvw block id */
v_lshrrev_b32 v15, 0, v[vgprSerial]                // 15 = Serial / 1
v_and_b32 v15, 15, v15                             // v15 = v15 % 16
                                                   // v15 = v15 * 1 (multiplier is 1, do nothing)
v_lshrrev_b32 v15, 4, v15                          // 15 = 15 / 16
                                                   // v13 = v13 * 1 (multiplier is 1, do nothing)
v_add_co_u32 v15, vcc_lo, v13, v15                 // tgbReg = (tid_coal * continOut) / GLVW
v_sub_nc_u32 v14, v14, v15

/* vwReg: glvw in which vw block? */
s_delay_alu instid0(VALU_DEP_4)
v_and_b32 v13, 0, v11                              // permute register between threads
s_delay_alu instid0(VALU_DEP_1)
v_lshrrev_b32 v13, 4, v13                          // permute register between threads

/* rReg : reminder of M_size % GlobalReadVectorWidth */
v_and_b32 v15, 15, v11                             // v15 = v11 % 16
s_delay_alu instid0(VALU_DEP_4)
v_cmp_eq_u32 vcc_lo, v15, 0x1                      // wgMT%VW == 1
s_cbranch_vccnz label_ShiftVectorComponents0_GLVW1 // branch to shift d0 r=1
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cmp_eq_u32 vcc_lo, v15, 0x2                      // wgMT%VW == 2
s_cbranch_vccnz label_ShiftVectorComponents0_GLVW2 // branch to shift d0 r=2
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cmp_eq_u32 vcc_lo, v15, 0x3                      // wgMT%VW == 3
s_cbranch_vccnz label_ShiftVectorComponents0_GLVW3 // branch to shift d0 r=3
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cmp_eq_u32 vcc_lo, v15, 0x4                      // wgMT%VW == 4
s_cbranch_vccnz label_ShiftVectorComponents0_GLVW4 // branch to shift d0 r=4
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cmp_eq_u32 vcc_lo, v15, 0x5                      // wgMT%VW == 5
s_cbranch_vccnz label_ShiftVectorComponents0_GLVW5 // branch to shift d0 r=5
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cmp_eq_u32 vcc_lo, v15, 0x6                      // wgMT%VW == 6
s_cbranch_vccnz label_ShiftVectorComponents0_GLVW6 // branch to shift d0 r=6
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cmp_eq_u32 vcc_lo, v15, 0x7                      // wgMT%VW == 7
s_cbranch_vccnz label_ShiftVectorComponents0_GLVW7 // branch to shift d0 r=7
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cmp_eq_u32 vcc_lo, v15, 0x8                      // wgMT%VW == 8
s_cbranch_vccnz label_ShiftVectorComponents0_GLVW8 // branch to shift d0 r=8
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cmp_eq_u32 vcc_lo, v15, 0x9                      // wgMT%VW == 9
s_cbranch_vccnz label_ShiftVectorComponents0_GLVW9 // branch to shift d0 r=9
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cmp_eq_u32 vcc_lo, v15, 0xa                      // wgMT%VW == 10
s_cbranch_vccnz label_ShiftVectorComponents0_GLVW10 // branch to shift d0 r=10
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cmp_eq_u32 vcc_lo, v15, 0xb                      // wgMT%VW == 11
s_cbranch_vccnz label_ShiftVectorComponents0_GLVW11 // branch to shift d0 r=11
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cmp_eq_u32 vcc_lo, v15, 0xc                      // wgMT%VW == 12
s_cbranch_vccnz label_ShiftVectorComponents0_GLVW12 // branch to shift d0 r=12
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cmp_eq_u32 vcc_lo, v15, 0xd                      // wgMT%VW == 13
s_cbranch_vccnz label_ShiftVectorComponents0_GLVW13 // branch to shift d0 r=13
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cmp_eq_u32 vcc_lo, v15, 0xe                      // wgMT%VW == 14
s_cbranch_vccnz label_ShiftVectorComponents0_GLVW14 // branch to shift d0 r=14
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cmp_eq_u32 vcc_lo, v15, 0xf                      // wgMT%VW == 15
s_cbranch_vccnz label_ShiftVectorComponents0_GLVW15 // branch to shift d0 r=15

/* no shifting */
s_branch label_ShiftVectorComponents0_GLVW0

/******************************************/
/* shift d0 r=1                           */
/******************************************/
label_ShiftVectorComponents0_GLVW1:
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cmp_eq_u32 vcc_lo, v12, 0x0

/* branch to shift d0 r1 mb0 */
s_cbranch_vccnz label_ShiftVectorComponents0_GLVW1_BM0

/******************************************/
/* shift d0 r=2                           */
/******************************************/
label_ShiftVectorComponents0_GLVW2:
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cmp_eq_u32 vcc_lo, v12, 0x0

/* branch to shift d0 r2 mb0 */
s_cbranch_vccnz label_ShiftVectorComponents0_GLVW2_BM0

/******************************************/
/* shift d0 r=3                           */
/******************************************/
label_ShiftVectorComponents0_GLVW3:
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cmp_eq_u32 vcc_lo, v12, 0x0

/* branch to shift d0 r3 mb0 */
s_cbranch_vccnz label_ShiftVectorComponents0_GLVW3_BM0

/******************************************/
/* shift d0 r=4                           */
/******************************************/
label_ShiftVectorComponents0_GLVW4:
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cmp_eq_u32 vcc_lo, v12, 0x0

/* branch to shift d0 r4 mb0 */
s_cbranch_vccnz label_ShiftVectorComponents0_GLVW4_BM0

/******************************************/
/* shift d0 r=5                           */
/******************************************/
label_ShiftVectorComponents0_GLVW5:
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cmp_eq_u32 vcc_lo, v12, 0x0

/* branch to shift d0 r5 mb0 */
s_cbranch_vccnz label_ShiftVectorComponents0_GLVW5_BM0

/******************************************/
/* shift d0 r=6                           */
/******************************************/
label_ShiftVectorComponents0_GLVW6:
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cmp_eq_u32 vcc_lo, v12, 0x0

/* branch to shift d0 r6 mb0 */
s_cbranch_vccnz label_ShiftVectorComponents0_GLVW6_BM0

/******************************************/
/* shift d0 r=7                           */
/******************************************/
label_ShiftVectorComponents0_GLVW7:
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cmp_eq_u32 vcc_lo, v12, 0x0

/* branch to shift d0 r7 mb0 */
s_cbranch_vccnz label_ShiftVectorComponents0_GLVW7_BM0

/******************************************/
/* shift d0 r=8                           */
/******************************************/
label_ShiftVectorComponents0_GLVW8:
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cmp_eq_u32 vcc_lo, v12, 0x0

/* branch to shift d0 r8 mb0 */
s_cbranch_vccnz label_ShiftVectorComponents0_GLVW8_BM0

/******************************************/
/* shift d0 r=9                           */
/******************************************/
label_ShiftVectorComponents0_GLVW9:
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cmp_eq_u32 vcc_lo, v12, 0x0

/* branch to shift d0 r9 mb0 */
s_cbranch_vccnz label_ShiftVectorComponents0_GLVW9_BM0

/******************************************/
/* shift d0 r=10                          */
/******************************************/
label_ShiftVectorComponents0_GLVW10:
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cmp_eq_u32 vcc_lo, v12, 0x0

/* branch to shift d0 r10 mb0 */
s_cbranch_vccnz label_ShiftVectorComponents0_GLVW10_BM0

/******************************************/
/* shift d0 r=11                          */
/******************************************/
label_ShiftVectorComponents0_GLVW11:
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cmp_eq_u32 vcc_lo, v12, 0x0

/* branch to shift d0 r11 mb0 */
s_cbranch_vccnz label_ShiftVectorComponents0_GLVW11_BM0

/******************************************/
/* shift d0 r=12                          */
/******************************************/
label_ShiftVectorComponents0_GLVW12:
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cmp_eq_u32 vcc_lo, v12, 0x0

/* branch to shift d0 r12 mb0 */
s_cbranch_vccnz label_ShiftVectorComponents0_GLVW12_BM0

/******************************************/
/* shift d0 r=13                          */
/******************************************/
label_ShiftVectorComponents0_GLVW13:
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cmp_eq_u32 vcc_lo, v12, 0x0

/* branch to shift d0 r13 mb0 */
s_cbranch_vccnz label_ShiftVectorComponents0_GLVW13_BM0

/******************************************/
/* shift d0 r=14                          */
/******************************************/
label_ShiftVectorComponents0_GLVW14:
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cmp_eq_u32 vcc_lo, v12, 0x0

/* branch to shift d0 r14 mb0 */
s_cbranch_vccnz label_ShiftVectorComponents0_GLVW14_BM0

/******************************************/
/* shift d0 r=15                          */
/******************************************/
label_ShiftVectorComponents0_GLVW15:
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cmp_eq_u32 vcc_lo, v12, 0x0

/* branch to shift d0 r15 mb0 */
s_cbranch_vccnz label_ShiftVectorComponents0_GLVW15_BM0

/******************************************/
/* shift d0 r=1 mb=0                      */
/******************************************/
label_ShiftVectorComponents0_GLVW1_BM0:  /// r1 mb0
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cmp_eq_u32 vcc_lo, v13, 0x0

/* branch to shift d0 r1 mb0 vw0 */
s_cbranch_vccnz label_ShiftVectorComponents0_GLVW1_BM0_VW0

/******************************************/
/* shift d0 r=2 mb=0                      */
/******************************************/
label_ShiftVectorComponents0_GLVW2_BM0:  /// r2 mb0
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cmp_eq_u32 vcc_lo, v13, 0x0

/* branch to shift d0 r2 mb0 vw0 */
s_cbranch_vccnz label_ShiftVectorComponents0_GLVW2_BM0_VW0

/******************************************/
/* shift d0 r=3 mb=0                      */
/******************************************/
label_ShiftVectorComponents0_GLVW3_BM0:  /// r3 mb0
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cmp_eq_u32 vcc_lo, v13, 0x0

/* branch to shift d0 r3 mb0 vw0 */
s_cbranch_vccnz label_ShiftVectorComponents0_GLVW3_BM0_VW0

/******************************************/
/* shift d0 r=4 mb=0                      */
/******************************************/
label_ShiftVectorComponents0_GLVW4_BM0:  /// r4 mb0
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cmp_eq_u32 vcc_lo, v13, 0x0

/* branch to shift d0 r4 mb0 vw0 */
s_cbranch_vccnz label_ShiftVectorComponents0_GLVW4_BM0_VW0

/******************************************/
/* shift d0 r=5 mb=0                      */
/******************************************/
label_ShiftVectorComponents0_GLVW5_BM0:  /// r5 mb0
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cmp_eq_u32 vcc_lo, v13, 0x0

/* branch to shift d0 r5 mb0 vw0 */
s_cbranch_vccnz label_ShiftVectorComponents0_GLVW5_BM0_VW0

/******************************************/
/* shift d0 r=6 mb=0                      */
/******************************************/
label_ShiftVectorComponents0_GLVW6_BM0:  /// r6 mb0
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cmp_eq_u32 vcc_lo, v13, 0x0

/* branch to shift d0 r6 mb0 vw0 */
s_cbranch_vccnz label_ShiftVectorComponents0_GLVW6_BM0_VW0

/******************************************/
/* shift d0 r=7 mb=0                      */
/******************************************/
label_ShiftVectorComponents0_GLVW7_BM0:  /// r7 mb0
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cmp_eq_u32 vcc_lo, v13, 0x0

/* branch to shift d0 r7 mb0 vw0 */
s_cbranch_vccnz label_ShiftVectorComponents0_GLVW7_BM0_VW0

/******************************************/
/* shift d0 r=8 mb=0                      */
/******************************************/
label_ShiftVectorComponents0_GLVW8_BM0:  /// r8 mb0
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cmp_eq_u32 vcc_lo, v13, 0x0

/* branch to shift d0 r8 mb0 vw0 */
s_cbranch_vccnz label_ShiftVectorComponents0_GLVW8_BM0_VW0

/******************************************/
/* shift d0 r=9 mb=0                      */
/******************************************/
label_ShiftVectorComponents0_GLVW9_BM0:  /// r9 mb0
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cmp_eq_u32 vcc_lo, v13, 0x0

/* branch to shift d0 r9 mb0 vw0 */
s_cbranch_vccnz label_ShiftVectorComponents0_GLVW9_BM0_VW0

/******************************************/
/* shift d0 r=10 mb=0                     */
/******************************************/
label_ShiftVectorComponents0_GLVW10_BM0:  /// r10 mb0
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cmp_eq_u32 vcc_lo, v13, 0x0

/* branch to shift d0 r10 mb0 vw0 */
s_cbranch_vccnz label_ShiftVectorComponents0_GLVW10_BM0_VW0

/******************************************/
/* shift d0 r=11 mb=0                     */
/******************************************/
label_ShiftVectorComponents0_GLVW11_BM0:  /// r11 mb0
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cmp_eq_u32 vcc_lo, v13, 0x0

/* branch to shift d0 r11 mb0 vw0 */
s_cbranch_vccnz label_ShiftVectorComponents0_GLVW11_BM0_VW0

/******************************************/
/* shift d0 r=12 mb=0                     */
/******************************************/
label_ShiftVectorComponents0_GLVW12_BM0:  /// r12 mb0
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cmp_eq_u32 vcc_lo, v13, 0x0

/* branch to shift d0 r12 mb0 vw0 */
s_cbranch_vccnz label_ShiftVectorComponents0_GLVW12_BM0_VW0

/******************************************/
/* shift d0 r=13 mb=0                     */
/******************************************/
label_ShiftVectorComponents0_GLVW13_BM0:  /// r13 mb0
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cmp_eq_u32 vcc_lo, v13, 0x0

/* branch to shift d0 r13 mb0 vw0 */
s_cbranch_vccnz label_ShiftVectorComponents0_GLVW13_BM0_VW0

/******************************************/
/* shift d0 r=14 mb=0                     */
/******************************************/
label_ShiftVectorComponents0_GLVW14_BM0:  /// r14 mb0
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cmp_eq_u32 vcc_lo, v13, 0x0

/* branch to shift d0 r14 mb0 vw0 */
s_cbranch_vccnz label_ShiftVectorComponents0_GLVW14_BM0_VW0

/******************************************/
/* shift d0 r=15 mb=0                     */
/******************************************/
label_ShiftVectorComponents0_GLVW15_BM0:  /// r15 mb0
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cmp_eq_u32 vcc_lo, v13, 0x0

/* branch to shift d0 r15 mb0 vw0 */
s_cbranch_vccnz label_ShiftVectorComponents0_GLVW15_BM0_VW0

/******************************************/
/* shift d0 r=1 mb=0 vw0                  */
/******************************************/
label_ShiftVectorComponents0_GLVW1_BM0_VW0:  /// r1 mb0 vw0
s_mov_b32 s8, 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
s_delay_alu instid0(NO_DEP)
v_cmp_eq_u32 s8, v14, s8                           // is thread in edge glvw region
s_mov_b32 exec_lo, s8                              // is thread in edge glvw region
v_and_b32 v8, 31, v[vgprSerial]                    // permute register between threads
s_delay_alu instid0(VALU_DEP_1)
v_lshlrev_b32 v8, 2, v8                            // permute register between threads
v_mov_b32 v15, v[vgprValuC+0]                      // glvw 1 mb 0 tt1 0 r 0
ds_bpermute_b32 v15, v8, v15 offset:60             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+0], v15
v_mov_b32 v15, v[vgprValuC+1]                      // glvw 1 mb 0 tt1 1 r 0
ds_bpermute_b32 v15, v8, v15 offset:60             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+1], v15
v_mov_b32 v15, v[vgprValuC+2]                      // glvw 1 mb 0 tt1 2 r 0
ds_bpermute_b32 v15, v8, v15 offset:60             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+2], v15
v_mov_b32 v15, v[vgprValuC+3]                      // glvw 1 mb 0 tt1 3 r 0
ds_bpermute_b32 v15, v8, v15 offset:60             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+3], v15
v_mov_b32 v15, v[vgprValuC+4]                      // glvw 1 mb 0 tt1 4 r 0
ds_bpermute_b32 v15, v8, v15 offset:60             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+4], v15
v_mov_b32 v15, v[vgprValuC+5]                      // glvw 1 mb 0 tt1 5 r 0
ds_bpermute_b32 v15, v8, v15 offset:60             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+5], v15
v_mov_b32 v15, v[vgprValuC+6]                      // glvw 1 mb 0 tt1 6 r 0
ds_bpermute_b32 v15, v8, v15 offset:60             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+6], v15
v_mov_b32 v15, v[vgprValuC+7]                      // glvw 1 mb 0 tt1 7 r 0
ds_bpermute_b32 v15, v8, v15 offset:60             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+7], v15
s_mov_b32 s8, 0xFFFFFFFF                           // to restore all threads active
s_delay_alu instid0(SALU_CYCLE_1)
s_or_saveexec_b32 vcc_lo, s8                       // all threads active

/* no shifting */
s_branch label_ShiftVectorComponents0_GLVW0


/******************************************/
/* shift d0 r=2 mb=0 vw0                  */
/******************************************/
label_ShiftVectorComponents0_GLVW2_BM0_VW0:  /// r2 mb0 vw0
s_mov_b32 s8, 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
s_delay_alu instid0(NO_DEP)
v_cmp_eq_u32 s8, v14, s8                           // is thread in edge glvw region
s_mov_b32 exec_lo, s8                              // is thread in edge glvw region
v_and_b32 v8, 31, v[vgprSerial]                    // permute register between threads
s_delay_alu instid0(VALU_DEP_1)
v_lshlrev_b32 v8, 2, v8                            // permute register between threads
v_mov_b32 v15, v[vgprValuC+0]                      // glvw 2 mb 0 tt1 0 r 0
ds_bpermute_b32 v15, v8, v15 offset:56             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+0], v15
v_mov_b32 v15, v[vgprValuC+1]                      // glvw 2 mb 0 tt1 1 r 0
ds_bpermute_b32 v15, v8, v15 offset:56             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+1], v15
v_mov_b32 v15, v[vgprValuC+2]                      // glvw 2 mb 0 tt1 2 r 0
ds_bpermute_b32 v15, v8, v15 offset:56             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+2], v15
v_mov_b32 v15, v[vgprValuC+3]                      // glvw 2 mb 0 tt1 3 r 0
ds_bpermute_b32 v15, v8, v15 offset:56             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+3], v15
v_mov_b32 v15, v[vgprValuC+4]                      // glvw 2 mb 0 tt1 4 r 0
ds_bpermute_b32 v15, v8, v15 offset:56             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+4], v15
v_mov_b32 v15, v[vgprValuC+5]                      // glvw 2 mb 0 tt1 5 r 0
ds_bpermute_b32 v15, v8, v15 offset:56             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+5], v15
v_mov_b32 v15, v[vgprValuC+6]                      // glvw 2 mb 0 tt1 6 r 0
ds_bpermute_b32 v15, v8, v15 offset:56             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+6], v15
v_mov_b32 v15, v[vgprValuC+7]                      // glvw 2 mb 0 tt1 7 r 0
ds_bpermute_b32 v15, v8, v15 offset:56             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+7], v15
s_mov_b32 s8, 0xFFFFFFFF                           // to restore all threads active
s_delay_alu instid0(SALU_CYCLE_1)
s_or_saveexec_b32 vcc_lo, s8                       // all threads active

/* no shifting */
s_branch label_ShiftVectorComponents0_GLVW0


/******************************************/
/* shift d0 r=3 mb=0 vw0                  */
/******************************************/
label_ShiftVectorComponents0_GLVW3_BM0_VW0:  /// r3 mb0 vw0
s_mov_b32 s8, 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
s_delay_alu instid0(NO_DEP)
v_cmp_eq_u32 s8, v14, s8                           // is thread in edge glvw region
s_mov_b32 exec_lo, s8                              // is thread in edge glvw region
v_and_b32 v8, 31, v[vgprSerial]                    // permute register between threads
s_delay_alu instid0(VALU_DEP_1)
v_lshlrev_b32 v8, 2, v8                            // permute register between threads
v_mov_b32 v15, v[vgprValuC+0]                      // glvw 3 mb 0 tt1 0 r 0
ds_bpermute_b32 v15, v8, v15 offset:52             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+0], v15
v_mov_b32 v15, v[vgprValuC+1]                      // glvw 3 mb 0 tt1 1 r 0
ds_bpermute_b32 v15, v8, v15 offset:52             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+1], v15
v_mov_b32 v15, v[vgprValuC+2]                      // glvw 3 mb 0 tt1 2 r 0
ds_bpermute_b32 v15, v8, v15 offset:52             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+2], v15
v_mov_b32 v15, v[vgprValuC+3]                      // glvw 3 mb 0 tt1 3 r 0
ds_bpermute_b32 v15, v8, v15 offset:52             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+3], v15
v_mov_b32 v15, v[vgprValuC+4]                      // glvw 3 mb 0 tt1 4 r 0
ds_bpermute_b32 v15, v8, v15 offset:52             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+4], v15
v_mov_b32 v15, v[vgprValuC+5]                      // glvw 3 mb 0 tt1 5 r 0
ds_bpermute_b32 v15, v8, v15 offset:52             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+5], v15
v_mov_b32 v15, v[vgprValuC+6]                      // glvw 3 mb 0 tt1 6 r 0
ds_bpermute_b32 v15, v8, v15 offset:52             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+6], v15
v_mov_b32 v15, v[vgprValuC+7]                      // glvw 3 mb 0 tt1 7 r 0
ds_bpermute_b32 v15, v8, v15 offset:52             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+7], v15
s_mov_b32 s8, 0xFFFFFFFF                           // to restore all threads active
s_delay_alu instid0(SALU_CYCLE_1)
s_or_saveexec_b32 vcc_lo, s8                       // all threads active

/* no shifting */
s_branch label_ShiftVectorComponents0_GLVW0


/******************************************/
/* shift d0 r=4 mb=0 vw0                  */
/******************************************/
label_ShiftVectorComponents0_GLVW4_BM0_VW0:  /// r4 mb0 vw0
s_mov_b32 s8, 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
s_delay_alu instid0(NO_DEP)
v_cmp_eq_u32 s8, v14, s8                           // is thread in edge glvw region
s_mov_b32 exec_lo, s8                              // is thread in edge glvw region
v_and_b32 v8, 31, v[vgprSerial]                    // permute register between threads
s_delay_alu instid0(VALU_DEP_1)
v_lshlrev_b32 v8, 2, v8                            // permute register between threads
v_mov_b32 v15, v[vgprValuC+0]                      // glvw 4 mb 0 tt1 0 r 0
ds_bpermute_b32 v15, v8, v15 offset:48             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+0], v15
v_mov_b32 v15, v[vgprValuC+1]                      // glvw 4 mb 0 tt1 1 r 0
ds_bpermute_b32 v15, v8, v15 offset:48             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+1], v15
v_mov_b32 v15, v[vgprValuC+2]                      // glvw 4 mb 0 tt1 2 r 0
ds_bpermute_b32 v15, v8, v15 offset:48             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+2], v15
v_mov_b32 v15, v[vgprValuC+3]                      // glvw 4 mb 0 tt1 3 r 0
ds_bpermute_b32 v15, v8, v15 offset:48             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+3], v15
v_mov_b32 v15, v[vgprValuC+4]                      // glvw 4 mb 0 tt1 4 r 0
ds_bpermute_b32 v15, v8, v15 offset:48             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+4], v15
v_mov_b32 v15, v[vgprValuC+5]                      // glvw 4 mb 0 tt1 5 r 0
ds_bpermute_b32 v15, v8, v15 offset:48             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+5], v15
v_mov_b32 v15, v[vgprValuC+6]                      // glvw 4 mb 0 tt1 6 r 0
ds_bpermute_b32 v15, v8, v15 offset:48             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+6], v15
v_mov_b32 v15, v[vgprValuC+7]                      // glvw 4 mb 0 tt1 7 r 0
ds_bpermute_b32 v15, v8, v15 offset:48             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+7], v15
s_mov_b32 s8, 0xFFFFFFFF                           // to restore all threads active
s_delay_alu instid0(SALU_CYCLE_1)
s_or_saveexec_b32 vcc_lo, s8                       // all threads active

/* no shifting */
s_branch label_ShiftVectorComponents0_GLVW0


/******************************************/
/* shift d0 r=5 mb=0 vw0                  */
/******************************************/
label_ShiftVectorComponents0_GLVW5_BM0_VW0:  /// r5 mb0 vw0
s_mov_b32 s8, 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
s_delay_alu instid0(NO_DEP)
v_cmp_eq_u32 s8, v14, s8                           // is thread in edge glvw region
s_mov_b32 exec_lo, s8                              // is thread in edge glvw region
v_and_b32 v8, 31, v[vgprSerial]                    // permute register between threads
s_delay_alu instid0(VALU_DEP_1)
v_lshlrev_b32 v8, 2, v8                            // permute register between threads
v_mov_b32 v15, v[vgprValuC+0]                      // glvw 5 mb 0 tt1 0 r 0
ds_bpermute_b32 v15, v8, v15 offset:44             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+0], v15
v_mov_b32 v15, v[vgprValuC+1]                      // glvw 5 mb 0 tt1 1 r 0
ds_bpermute_b32 v15, v8, v15 offset:44             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+1], v15
v_mov_b32 v15, v[vgprValuC+2]                      // glvw 5 mb 0 tt1 2 r 0
ds_bpermute_b32 v15, v8, v15 offset:44             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+2], v15
v_mov_b32 v15, v[vgprValuC+3]                      // glvw 5 mb 0 tt1 3 r 0
ds_bpermute_b32 v15, v8, v15 offset:44             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+3], v15
v_mov_b32 v15, v[vgprValuC+4]                      // glvw 5 mb 0 tt1 4 r 0
ds_bpermute_b32 v15, v8, v15 offset:44             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+4], v15
v_mov_b32 v15, v[vgprValuC+5]                      // glvw 5 mb 0 tt1 5 r 0
ds_bpermute_b32 v15, v8, v15 offset:44             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+5], v15
v_mov_b32 v15, v[vgprValuC+6]                      // glvw 5 mb 0 tt1 6 r 0
ds_bpermute_b32 v15, v8, v15 offset:44             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+6], v15
v_mov_b32 v15, v[vgprValuC+7]                      // glvw 5 mb 0 tt1 7 r 0
ds_bpermute_b32 v15, v8, v15 offset:44             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+7], v15
s_mov_b32 s8, 0xFFFFFFFF                           // to restore all threads active
s_delay_alu instid0(SALU_CYCLE_1)
s_or_saveexec_b32 vcc_lo, s8                       // all threads active

/* no shifting */
s_branch label_ShiftVectorComponents0_GLVW0


/******************************************/
/* shift d0 r=6 mb=0 vw0                  */
/******************************************/
label_ShiftVectorComponents0_GLVW6_BM0_VW0:  /// r6 mb0 vw0
s_mov_b32 s8, 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
s_delay_alu instid0(NO_DEP)
v_cmp_eq_u32 s8, v14, s8                           // is thread in edge glvw region
s_mov_b32 exec_lo, s8                              // is thread in edge glvw region
v_and_b32 v8, 31, v[vgprSerial]                    // permute register between threads
s_delay_alu instid0(VALU_DEP_1)
v_lshlrev_b32 v8, 2, v8                            // permute register between threads
v_mov_b32 v15, v[vgprValuC+0]                      // glvw 6 mb 0 tt1 0 r 0
ds_bpermute_b32 v15, v8, v15 offset:40             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+0], v15
v_mov_b32 v15, v[vgprValuC+1]                      // glvw 6 mb 0 tt1 1 r 0
ds_bpermute_b32 v15, v8, v15 offset:40             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+1], v15
v_mov_b32 v15, v[vgprValuC+2]                      // glvw 6 mb 0 tt1 2 r 0
ds_bpermute_b32 v15, v8, v15 offset:40             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+2], v15
v_mov_b32 v15, v[vgprValuC+3]                      // glvw 6 mb 0 tt1 3 r 0
ds_bpermute_b32 v15, v8, v15 offset:40             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+3], v15
v_mov_b32 v15, v[vgprValuC+4]                      // glvw 6 mb 0 tt1 4 r 0
ds_bpermute_b32 v15, v8, v15 offset:40             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+4], v15
v_mov_b32 v15, v[vgprValuC+5]                      // glvw 6 mb 0 tt1 5 r 0
ds_bpermute_b32 v15, v8, v15 offset:40             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+5], v15
v_mov_b32 v15, v[vgprValuC+6]                      // glvw 6 mb 0 tt1 6 r 0
ds_bpermute_b32 v15, v8, v15 offset:40             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+6], v15
v_mov_b32 v15, v[vgprValuC+7]                      // glvw 6 mb 0 tt1 7 r 0
ds_bpermute_b32 v15, v8, v15 offset:40             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+7], v15
s_mov_b32 s8, 0xFFFFFFFF                           // to restore all threads active
s_delay_alu instid0(SALU_CYCLE_1)
s_or_saveexec_b32 vcc_lo, s8                       // all threads active

/* no shifting */
s_branch label_ShiftVectorComponents0_GLVW0


/******************************************/
/* shift d0 r=7 mb=0 vw0                  */
/******************************************/
label_ShiftVectorComponents0_GLVW7_BM0_VW0:  /// r7 mb0 vw0
s_mov_b32 s8, 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
s_delay_alu instid0(NO_DEP)
v_cmp_eq_u32 s8, v14, s8                           // is thread in edge glvw region
s_mov_b32 exec_lo, s8                              // is thread in edge glvw region
v_and_b32 v8, 31, v[vgprSerial]                    // permute register between threads
s_delay_alu instid0(VALU_DEP_1)
v_lshlrev_b32 v8, 2, v8                            // permute register between threads
v_mov_b32 v15, v[vgprValuC+0]                      // glvw 7 mb 0 tt1 0 r 0
ds_bpermute_b32 v15, v8, v15 offset:36             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+0], v15
v_mov_b32 v15, v[vgprValuC+1]                      // glvw 7 mb 0 tt1 1 r 0
ds_bpermute_b32 v15, v8, v15 offset:36             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+1], v15
v_mov_b32 v15, v[vgprValuC+2]                      // glvw 7 mb 0 tt1 2 r 0
ds_bpermute_b32 v15, v8, v15 offset:36             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+2], v15
v_mov_b32 v15, v[vgprValuC+3]                      // glvw 7 mb 0 tt1 3 r 0
ds_bpermute_b32 v15, v8, v15 offset:36             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+3], v15
v_mov_b32 v15, v[vgprValuC+4]                      // glvw 7 mb 0 tt1 4 r 0
ds_bpermute_b32 v15, v8, v15 offset:36             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+4], v15
v_mov_b32 v15, v[vgprValuC+5]                      // glvw 7 mb 0 tt1 5 r 0
ds_bpermute_b32 v15, v8, v15 offset:36             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+5], v15
v_mov_b32 v15, v[vgprValuC+6]                      // glvw 7 mb 0 tt1 6 r 0
ds_bpermute_b32 v15, v8, v15 offset:36             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+6], v15
v_mov_b32 v15, v[vgprValuC+7]                      // glvw 7 mb 0 tt1 7 r 0
ds_bpermute_b32 v15, v8, v15 offset:36             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+7], v15
s_mov_b32 s8, 0xFFFFFFFF                           // to restore all threads active
s_delay_alu instid0(SALU_CYCLE_1)
s_or_saveexec_b32 vcc_lo, s8                       // all threads active

/* no shifting */
s_branch label_ShiftVectorComponents0_GLVW0


/******************************************/
/* shift d0 r=8 mb=0 vw0                  */
/******************************************/
label_ShiftVectorComponents0_GLVW8_BM0_VW0:  /// r8 mb0 vw0
s_mov_b32 s8, 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
s_delay_alu instid0(NO_DEP)
v_cmp_eq_u32 s8, v14, s8                           // is thread in edge glvw region
s_mov_b32 exec_lo, s8                              // is thread in edge glvw region
v_and_b32 v8, 31, v[vgprSerial]                    // permute register between threads
s_delay_alu instid0(VALU_DEP_1)
v_lshlrev_b32 v8, 2, v8                            // permute register between threads
v_mov_b32 v15, v[vgprValuC+0]                      // glvw 8 mb 0 tt1 0 r 0
ds_bpermute_b32 v15, v8, v15 offset:32             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+0], v15
v_mov_b32 v15, v[vgprValuC+1]                      // glvw 8 mb 0 tt1 1 r 0
ds_bpermute_b32 v15, v8, v15 offset:32             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+1], v15
v_mov_b32 v15, v[vgprValuC+2]                      // glvw 8 mb 0 tt1 2 r 0
ds_bpermute_b32 v15, v8, v15 offset:32             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+2], v15
v_mov_b32 v15, v[vgprValuC+3]                      // glvw 8 mb 0 tt1 3 r 0
ds_bpermute_b32 v15, v8, v15 offset:32             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+3], v15
v_mov_b32 v15, v[vgprValuC+4]                      // glvw 8 mb 0 tt1 4 r 0
ds_bpermute_b32 v15, v8, v15 offset:32             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+4], v15
v_mov_b32 v15, v[vgprValuC+5]                      // glvw 8 mb 0 tt1 5 r 0
ds_bpermute_b32 v15, v8, v15 offset:32             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+5], v15
v_mov_b32 v15, v[vgprValuC+6]                      // glvw 8 mb 0 tt1 6 r 0
ds_bpermute_b32 v15, v8, v15 offset:32             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+6], v15
v_mov_b32 v15, v[vgprValuC+7]                      // glvw 8 mb 0 tt1 7 r 0
ds_bpermute_b32 v15, v8, v15 offset:32             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+7], v15
s_mov_b32 s8, 0xFFFFFFFF                           // to restore all threads active
s_delay_alu instid0(SALU_CYCLE_1)
s_or_saveexec_b32 vcc_lo, s8                       // all threads active

/* no shifting */
s_branch label_ShiftVectorComponents0_GLVW0


/******************************************/
/* shift d0 r=9 mb=0 vw0                  */
/******************************************/
label_ShiftVectorComponents0_GLVW9_BM0_VW0:  /// r9 mb0 vw0
s_mov_b32 s8, 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
s_delay_alu instid0(NO_DEP)
v_cmp_eq_u32 s8, v14, s8                           // is thread in edge glvw region
s_mov_b32 exec_lo, s8                              // is thread in edge glvw region
v_and_b32 v8, 31, v[vgprSerial]                    // permute register between threads
s_delay_alu instid0(VALU_DEP_1)
v_lshlrev_b32 v8, 2, v8                            // permute register between threads
v_mov_b32 v15, v[vgprValuC+0]                      // glvw 9 mb 0 tt1 0 r 0
ds_bpermute_b32 v15, v8, v15 offset:28             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+0], v15
v_mov_b32 v15, v[vgprValuC+1]                      // glvw 9 mb 0 tt1 1 r 0
ds_bpermute_b32 v15, v8, v15 offset:28             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+1], v15
v_mov_b32 v15, v[vgprValuC+2]                      // glvw 9 mb 0 tt1 2 r 0
ds_bpermute_b32 v15, v8, v15 offset:28             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+2], v15
v_mov_b32 v15, v[vgprValuC+3]                      // glvw 9 mb 0 tt1 3 r 0
ds_bpermute_b32 v15, v8, v15 offset:28             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+3], v15
v_mov_b32 v15, v[vgprValuC+4]                      // glvw 9 mb 0 tt1 4 r 0
ds_bpermute_b32 v15, v8, v15 offset:28             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+4], v15
v_mov_b32 v15, v[vgprValuC+5]                      // glvw 9 mb 0 tt1 5 r 0
ds_bpermute_b32 v15, v8, v15 offset:28             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+5], v15
v_mov_b32 v15, v[vgprValuC+6]                      // glvw 9 mb 0 tt1 6 r 0
ds_bpermute_b32 v15, v8, v15 offset:28             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+6], v15
v_mov_b32 v15, v[vgprValuC+7]                      // glvw 9 mb 0 tt1 7 r 0
ds_bpermute_b32 v15, v8, v15 offset:28             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+7], v15
s_mov_b32 s8, 0xFFFFFFFF                           // to restore all threads active
s_delay_alu instid0(SALU_CYCLE_1)
s_or_saveexec_b32 vcc_lo, s8                       // all threads active

/* no shifting */
s_branch label_ShiftVectorComponents0_GLVW0


/******************************************/
/* shift d0 r=10 mb=0 vw0                 */
/******************************************/
label_ShiftVectorComponents0_GLVW10_BM0_VW0:  /// r10 mb0 vw0
s_mov_b32 s8, 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
s_delay_alu instid0(NO_DEP)
v_cmp_eq_u32 s8, v14, s8                           // is thread in edge glvw region
s_mov_b32 exec_lo, s8                              // is thread in edge glvw region
v_and_b32 v8, 31, v[vgprSerial]                    // permute register between threads
s_delay_alu instid0(VALU_DEP_1)
v_lshlrev_b32 v8, 2, v8                            // permute register between threads
v_mov_b32 v15, v[vgprValuC+0]                      // glvw 10 mb 0 tt1 0 r 0
ds_bpermute_b32 v15, v8, v15 offset:24             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+0], v15
v_mov_b32 v15, v[vgprValuC+1]                      // glvw 10 mb 0 tt1 1 r 0
ds_bpermute_b32 v15, v8, v15 offset:24             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+1], v15
v_mov_b32 v15, v[vgprValuC+2]                      // glvw 10 mb 0 tt1 2 r 0
ds_bpermute_b32 v15, v8, v15 offset:24             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+2], v15
v_mov_b32 v15, v[vgprValuC+3]                      // glvw 10 mb 0 tt1 3 r 0
ds_bpermute_b32 v15, v8, v15 offset:24             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+3], v15
v_mov_b32 v15, v[vgprValuC+4]                      // glvw 10 mb 0 tt1 4 r 0
ds_bpermute_b32 v15, v8, v15 offset:24             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+4], v15
v_mov_b32 v15, v[vgprValuC+5]                      // glvw 10 mb 0 tt1 5 r 0
ds_bpermute_b32 v15, v8, v15 offset:24             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+5], v15
v_mov_b32 v15, v[vgprValuC+6]                      // glvw 10 mb 0 tt1 6 r 0
ds_bpermute_b32 v15, v8, v15 offset:24             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+6], v15
v_mov_b32 v15, v[vgprValuC+7]                      // glvw 10 mb 0 tt1 7 r 0
ds_bpermute_b32 v15, v8, v15 offset:24             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+7], v15
s_mov_b32 s8, 0xFFFFFFFF                           // to restore all threads active
s_delay_alu instid0(SALU_CYCLE_1)
s_or_saveexec_b32 vcc_lo, s8                       // all threads active

/* no shifting */
s_branch label_ShiftVectorComponents0_GLVW0


/******************************************/
/* shift d0 r=11 mb=0 vw0                 */
/******************************************/
label_ShiftVectorComponents0_GLVW11_BM0_VW0:  /// r11 mb0 vw0
s_mov_b32 s8, 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
s_delay_alu instid0(NO_DEP)
v_cmp_eq_u32 s8, v14, s8                           // is thread in edge glvw region
s_mov_b32 exec_lo, s8                              // is thread in edge glvw region
v_and_b32 v8, 31, v[vgprSerial]                    // permute register between threads
s_delay_alu instid0(VALU_DEP_1)
v_lshlrev_b32 v8, 2, v8                            // permute register between threads
v_mov_b32 v15, v[vgprValuC+0]                      // glvw 11 mb 0 tt1 0 r 0
ds_bpermute_b32 v15, v8, v15 offset:20             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+0], v15
v_mov_b32 v15, v[vgprValuC+1]                      // glvw 11 mb 0 tt1 1 r 0
ds_bpermute_b32 v15, v8, v15 offset:20             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+1], v15
v_mov_b32 v15, v[vgprValuC+2]                      // glvw 11 mb 0 tt1 2 r 0
ds_bpermute_b32 v15, v8, v15 offset:20             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+2], v15
v_mov_b32 v15, v[vgprValuC+3]                      // glvw 11 mb 0 tt1 3 r 0
ds_bpermute_b32 v15, v8, v15 offset:20             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+3], v15
v_mov_b32 v15, v[vgprValuC+4]                      // glvw 11 mb 0 tt1 4 r 0
ds_bpermute_b32 v15, v8, v15 offset:20             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+4], v15
v_mov_b32 v15, v[vgprValuC+5]                      // glvw 11 mb 0 tt1 5 r 0
ds_bpermute_b32 v15, v8, v15 offset:20             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+5], v15
v_mov_b32 v15, v[vgprValuC+6]                      // glvw 11 mb 0 tt1 6 r 0
ds_bpermute_b32 v15, v8, v15 offset:20             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+6], v15
v_mov_b32 v15, v[vgprValuC+7]                      // glvw 11 mb 0 tt1 7 r 0
ds_bpermute_b32 v15, v8, v15 offset:20             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+7], v15
s_mov_b32 s8, 0xFFFFFFFF                           // to restore all threads active
s_delay_alu instid0(SALU_CYCLE_1)
s_or_saveexec_b32 vcc_lo, s8                       // all threads active

/* no shifting */
s_branch label_ShiftVectorComponents0_GLVW0


/******************************************/
/* shift d0 r=12 mb=0 vw0                 */
/******************************************/
label_ShiftVectorComponents0_GLVW12_BM0_VW0:  /// r12 mb0 vw0
s_mov_b32 s8, 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
s_delay_alu instid0(NO_DEP)
v_cmp_eq_u32 s8, v14, s8                           // is thread in edge glvw region
s_mov_b32 exec_lo, s8                              // is thread in edge glvw region
v_and_b32 v8, 31, v[vgprSerial]                    // permute register between threads
s_delay_alu instid0(VALU_DEP_1)
v_lshlrev_b32 v8, 2, v8                            // permute register between threads
v_mov_b32 v15, v[vgprValuC+0]                      // glvw 12 mb 0 tt1 0 r 0
ds_bpermute_b32 v15, v8, v15 offset:16             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+0], v15
v_mov_b32 v15, v[vgprValuC+1]                      // glvw 12 mb 0 tt1 1 r 0
ds_bpermute_b32 v15, v8, v15 offset:16             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+1], v15
v_mov_b32 v15, v[vgprValuC+2]                      // glvw 12 mb 0 tt1 2 r 0
ds_bpermute_b32 v15, v8, v15 offset:16             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+2], v15
v_mov_b32 v15, v[vgprValuC+3]                      // glvw 12 mb 0 tt1 3 r 0
ds_bpermute_b32 v15, v8, v15 offset:16             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+3], v15
v_mov_b32 v15, v[vgprValuC+4]                      // glvw 12 mb 0 tt1 4 r 0
ds_bpermute_b32 v15, v8, v15 offset:16             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+4], v15
v_mov_b32 v15, v[vgprValuC+5]                      // glvw 12 mb 0 tt1 5 r 0
ds_bpermute_b32 v15, v8, v15 offset:16             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+5], v15
v_mov_b32 v15, v[vgprValuC+6]                      // glvw 12 mb 0 tt1 6 r 0
ds_bpermute_b32 v15, v8, v15 offset:16             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+6], v15
v_mov_b32 v15, v[vgprValuC+7]                      // glvw 12 mb 0 tt1 7 r 0
ds_bpermute_b32 v15, v8, v15 offset:16             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+7], v15
s_mov_b32 s8, 0xFFFFFFFF                           // to restore all threads active
s_delay_alu instid0(SALU_CYCLE_1)
s_or_saveexec_b32 vcc_lo, s8                       // all threads active

/* no shifting */
s_branch label_ShiftVectorComponents0_GLVW0


/******************************************/
/* shift d0 r=13 mb=0 vw0                 */
/******************************************/
label_ShiftVectorComponents0_GLVW13_BM0_VW0:  /// r13 mb0 vw0
s_mov_b32 s8, 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
s_delay_alu instid0(NO_DEP)
v_cmp_eq_u32 s8, v14, s8                           // is thread in edge glvw region
s_mov_b32 exec_lo, s8                              // is thread in edge glvw region
v_and_b32 v8, 31, v[vgprSerial]                    // permute register between threads
s_delay_alu instid0(VALU_DEP_1)
v_lshlrev_b32 v8, 2, v8                            // permute register between threads
v_mov_b32 v15, v[vgprValuC+0]                      // glvw 13 mb 0 tt1 0 r 0
ds_bpermute_b32 v15, v8, v15 offset:12             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+0], v15
v_mov_b32 v15, v[vgprValuC+1]                      // glvw 13 mb 0 tt1 1 r 0
ds_bpermute_b32 v15, v8, v15 offset:12             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+1], v15
v_mov_b32 v15, v[vgprValuC+2]                      // glvw 13 mb 0 tt1 2 r 0
ds_bpermute_b32 v15, v8, v15 offset:12             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+2], v15
v_mov_b32 v15, v[vgprValuC+3]                      // glvw 13 mb 0 tt1 3 r 0
ds_bpermute_b32 v15, v8, v15 offset:12             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+3], v15
v_mov_b32 v15, v[vgprValuC+4]                      // glvw 13 mb 0 tt1 4 r 0
ds_bpermute_b32 v15, v8, v15 offset:12             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+4], v15
v_mov_b32 v15, v[vgprValuC+5]                      // glvw 13 mb 0 tt1 5 r 0
ds_bpermute_b32 v15, v8, v15 offset:12             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+5], v15
v_mov_b32 v15, v[vgprValuC+6]                      // glvw 13 mb 0 tt1 6 r 0
ds_bpermute_b32 v15, v8, v15 offset:12             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+6], v15
v_mov_b32 v15, v[vgprValuC+7]                      // glvw 13 mb 0 tt1 7 r 0
ds_bpermute_b32 v15, v8, v15 offset:12             // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+7], v15
s_mov_b32 s8, 0xFFFFFFFF                           // to restore all threads active
s_delay_alu instid0(SALU_CYCLE_1)
s_or_saveexec_b32 vcc_lo, s8                       // all threads active

/* no shifting */
s_branch label_ShiftVectorComponents0_GLVW0


/******************************************/
/* shift d0 r=14 mb=0 vw0                 */
/******************************************/
label_ShiftVectorComponents0_GLVW14_BM0_VW0:  /// r14 mb0 vw0
s_mov_b32 s8, 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
s_delay_alu instid0(NO_DEP)
v_cmp_eq_u32 s8, v14, s8                           // is thread in edge glvw region
s_mov_b32 exec_lo, s8                              // is thread in edge glvw region
v_and_b32 v8, 31, v[vgprSerial]                    // permute register between threads
s_delay_alu instid0(VALU_DEP_1)
v_lshlrev_b32 v8, 2, v8                            // permute register between threads
v_mov_b32 v15, v[vgprValuC+0]                      // glvw 14 mb 0 tt1 0 r 0
ds_bpermute_b32 v15, v8, v15 offset:8              // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+0], v15
v_mov_b32 v15, v[vgprValuC+1]                      // glvw 14 mb 0 tt1 1 r 0
ds_bpermute_b32 v15, v8, v15 offset:8              // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+1], v15
v_mov_b32 v15, v[vgprValuC+2]                      // glvw 14 mb 0 tt1 2 r 0
ds_bpermute_b32 v15, v8, v15 offset:8              // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+2], v15
v_mov_b32 v15, v[vgprValuC+3]                      // glvw 14 mb 0 tt1 3 r 0
ds_bpermute_b32 v15, v8, v15 offset:8              // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+3], v15
v_mov_b32 v15, v[vgprValuC+4]                      // glvw 14 mb 0 tt1 4 r 0
ds_bpermute_b32 v15, v8, v15 offset:8              // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+4], v15
v_mov_b32 v15, v[vgprValuC+5]                      // glvw 14 mb 0 tt1 5 r 0
ds_bpermute_b32 v15, v8, v15 offset:8              // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+5], v15
v_mov_b32 v15, v[vgprValuC+6]                      // glvw 14 mb 0 tt1 6 r 0
ds_bpermute_b32 v15, v8, v15 offset:8              // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+6], v15
v_mov_b32 v15, v[vgprValuC+7]                      // glvw 14 mb 0 tt1 7 r 0
ds_bpermute_b32 v15, v8, v15 offset:8              // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+7], v15
s_mov_b32 s8, 0xFFFFFFFF                           // to restore all threads active
s_delay_alu instid0(SALU_CYCLE_1)
s_or_saveexec_b32 vcc_lo, s8                       // all threads active

/* no shifting */
s_branch label_ShiftVectorComponents0_GLVW0


/******************************************/
/* shift d0 r=15 mb=0 vw0                 */
/******************************************/
label_ShiftVectorComponents0_GLVW15_BM0_VW0:  /// r15 mb0 vw0
s_mov_b32 s8, 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
s_delay_alu instid0(NO_DEP)
v_cmp_eq_u32 s8, v14, s8                           // is thread in edge glvw region
s_mov_b32 exec_lo, s8                              // is thread in edge glvw region
v_and_b32 v8, 31, v[vgprSerial]                    // permute register between threads
s_delay_alu instid0(VALU_DEP_1)
v_lshlrev_b32 v8, 2, v8                            // permute register between threads
v_mov_b32 v15, v[vgprValuC+0]                      // glvw 15 mb 0 tt1 0 r 0
ds_bpermute_b32 v15, v8, v15 offset:4              // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+0], v15
v_mov_b32 v15, v[vgprValuC+1]                      // glvw 15 mb 0 tt1 1 r 0
ds_bpermute_b32 v15, v8, v15 offset:4              // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+1], v15
v_mov_b32 v15, v[vgprValuC+2]                      // glvw 15 mb 0 tt1 2 r 0
ds_bpermute_b32 v15, v8, v15 offset:4              // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+2], v15
v_mov_b32 v15, v[vgprValuC+3]                      // glvw 15 mb 0 tt1 3 r 0
ds_bpermute_b32 v15, v8, v15 offset:4              // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+3], v15
v_mov_b32 v15, v[vgprValuC+4]                      // glvw 15 mb 0 tt1 4 r 0
ds_bpermute_b32 v15, v8, v15 offset:4              // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+4], v15
v_mov_b32 v15, v[vgprValuC+5]                      // glvw 15 mb 0 tt1 5 r 0
ds_bpermute_b32 v15, v8, v15 offset:4              // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+5], v15
v_mov_b32 v15, v[vgprValuC+6]                      // glvw 15 mb 0 tt1 6 r 0
ds_bpermute_b32 v15, v8, v15 offset:4              // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+6], v15
v_mov_b32 v15, v[vgprValuC+7]                      // glvw 15 mb 0 tt1 7 r 0
ds_bpermute_b32 v15, v8, v15 offset:4              // permute edge values
s_wait_dscnt 0                                     // (Wait all)
s_wait_kmcnt 0                                     // (Wait all)
s_wait_loadcnt 0                                   // (Wait all)
s_wait_storecnt 0                                  // (Wait all)
s_delay_alu instid0(VALU_DEP_1)
v_mov_b32 v[vgprValuC+7], v15
s_mov_b32 s8, 0xFFFFFFFF                           // to restore all threads active
s_delay_alu instid0(SALU_CYCLE_1)
s_or_saveexec_b32 vcc_lo, s8                       // all threads active

/* no shifting */
s_branch label_ShiftVectorComponents0_GLVW0

label_ShiftVectorComponents0_GLVW0:  /// end shift0

/* not-LocalSplitU: global write indices */
/* computeStoreVgprs */
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_lshrrev_b32 v12, 5, v[vgprSerial]                // 12 = Serial / 32
v_lshrrev_b32 v13, 0, v12                          // 13 = 12 / 1
v_mul_lo_u32 v13, 0x10, v13                        // wave coordination offset 1
v_and_b32 v9, 31, v[vgprSerial]                    // v9 = v[vgprSerial] % 32
v_lshrrev_b32 v9, 4, v9                            // 9 = 9 / 16
v_lshlrev_b32 v9, 3, v9                            // thread0 * continuous_output
v_add_lshl_u32 v9, v13, v9, 0                      // coordination 1 = vwB *(wave_id1 + tid1)
v_mul_lo_u32 v10, v9, s[sgprStrideC1J]             //  offset 1
v_mul_lo_u32 v11, v9, s[sgprStrideD1J]             //  offset 1
v_and_b32 v8, 0, v12                               // v8 = v12 % 1
v_mul_lo_u32 v8, 0x10, v8                          // wave coordination offset 0
v_and_b32 v13, 15, v[vgprSerial]                   // v13 = v[vgprSerial] % 16
s_delay_alu instid0(VALU_DEP_1)
v_add_lshl_u32 v8, v13, v8, 0                      // coordination 0 = vwA * (wave_id0 + tid0)
s_mul_i32 s8, 16, s[sgprWorkGroup0]                // wgp0 * MT0
s_delay_alu instid0(NO_DEP)
v_add_nc_u32 v8, s8, v8                            // coord 0 = (tid0/MI_m)*4 + waveG0*MIB_m + MT0*SG0
s_mul_i32 s8, 16, s[sgprWorkGroup1]                // wgp1 * MT1
s_delay_alu instid0(NO_DEP)
v_add_nc_u32 v9, s8, v9                            // coord 1 = (tid0%MI_m) + waveG1*MIB_n + MT1*SG1

/* not-LocalSplitU: global write */

/******************************************/
/* Global Write Elements                  */
/******************************************/
s_wait_kmcnt 0                                     // wait for 40 bytes of kern args.
s_and_b32 s8, s[sgprGSU], 0x3fff                   // Restore GSU
s_delay_alu instid0(SALU_CYCLE_1)
s_cmp_eq_u32 s8, 1                                 // GSU == 1 ?
s_cbranch_scc1 label_GSU_5                         // branch if GSU == 1
.set sgprAddressScaleAlphaVec, UNDEF
.set sgprSrdScaleAlphaVec, UNDEF
label_GW_B0_MB:
s_mov_b32 s8, 0
s_cmp_eq_u32 s[sgprFactorDim], s8                  // FactorDim == 0
s_cbranch_scc0 label_GW_B0_FD1_MB                  // Branch if FactorDim is not zero

label_GW_B0_FD0_MB:

/* Edge/NonEdge store path check (M): Size % 16 > 0 -> Edge store; else -> NonEdge store */
s_and_b32 s24, 15, s[sgprSizeI]                    // s24 = s[sgprSizeI] % 16
s_add_u32 s25, -0x1, s[sgprNumWorkGroups0]
s_cmp_ge_u32 s[sgprWorkGroup0], s25                // wg0 >= nwg0-1 ?
s_cselect_b32 s24, s24, 0                          // set rem
s_mov_b32 s8, 0
s_cmp_gt_u32 s24, s8                               // rem > 0
s_cbranch_scc1 label_GW_B0_FD0_VW1_MB_Else         // jump if edges required

/* Edge/NonEdge store path check (N (isSize1)): Size % 16 > 0 -> Edge store; else -> NonEdge store */
s_and_b32 s24, 15, s[sgprSizeJ]                    // s24 = s[sgprSizeJ] % 16
s_add_u32 s25, -0x1, s[sgprNumWorkGroups1]
s_cmp_ge_u32 s[sgprWorkGroup1], s25                // wg1 >= nwg1-1
s_cselect_b32 s24, s24, 0                          // set rem
s_mov_b32 s8, 0
s_cmp_gt_u32 s24, s8                               // rem > 0
s_cbranch_scc1 label_GW_B0_FD0_VW1_MB_Then         // jump if edges required
label_GW_B0_FD0_VW1_MB_NonEdge:

/* edge=0, allocate 1 sgpr. perBatchTmpS=1 perBatchMaskS=0 perElementMaskS=0 elementsPerBatch=234 */
/* optSingleColVgpr=1 optSharedColVgpr=0 optSGPRUsage=BufferLoad_Mask optSrdIncForRow=1 factorDim=0 */

/******************************************/
/* Global Write Batch #0 (d1,d0,vc1,vc0) = */
/*    (0,0,0,0:vw1); (0,0,1,0:vw1); (0,0,2,0:vw1); (0,0,3,0:vw1); (0,0,4,0:vw1); (0,0,5,0:vw1); (0,0,6,0:vw1); (0,0,7,0:vw1) */
/******************************************/

/* calc coords, apply mask, and issue loads (if necessary) */
/* (d1,vc1,d0,vc0)=(0,0,0,0) */
/* (d1,vc1,d0,vc0)=(0,1,0,0) */
/* (d1,vc1,d0,vc0)=(0,2,0,0) */
/* (d1,vc1,d0,vc0)=(0,3,0,0) */
/* (d1,vc1,d0,vc0)=(0,4,0,0) */
/* (d1,vc1,d0,vc0)=(0,5,0,0) */
/* (d1,vc1,d0,vc0)=(0,6,0,0) */
/* (d1,vc1,d0,vc0)=(0,7,0,0) */
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_add_lshl_u32 v19, v11, v8, 2                     // optSingleColVgpr scaleToBpe: sharedAddrVgpr <- cinRowPtr + coord0, scaled by BPE. BSHERE:coord0=8, coord0Vgpr=8 (multiple bpe)

/* rC *= alpha batchElements=[(0, 0, 0, 0), (0, 0, 1, 0), (0, 0, 2, 0), (0, 0, 3, 0), (0, 0, 4, 0), (0, 0, 5, 0), (0, 0, 6, 0), (0, 0, 7, 0)] */
v_mov_b32 v[vgprValuC+21], v[vgprValuC+0]          // Rearrange MI out reg
v_mov_b32 v[vgprValuC+22], v[vgprValuC+1]          // Rearrange MI out reg
v_mov_b32 v[vgprValuC+23], v[vgprValuC+2]          // Rearrange MI out reg
v_mov_b32 v[vgprValuC+24], v[vgprValuC+3]          // Rearrange MI out reg
v_mov_b32 v[vgprValuC+25], v[vgprValuC+4]          // Rearrange MI out reg
v_mov_b32 v[vgprValuC+26], v[vgprValuC+5]          // Rearrange MI out reg
v_mov_b32 v[vgprValuC+27], v[vgprValuC+6]          // Rearrange MI out reg
v_mov_b32 v[vgprValuC+28], v[vgprValuC+7]          // Rearrange MI out reg

/* apply mask, calc new C and issue writes */
buffer_store_b32 v21, v19, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_lshl_b32 s8, s[sgprStrideD1J], 2                 // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s8         // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_store_b32 v22, v19, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_lshl_b32 s8, s[sgprStrideD1J], 2                 // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s8         // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_store_b32 v23, v19, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_lshl_b32 s8, s[sgprStrideD1J], 2                 // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s8         // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_store_b32 v24, v19, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_lshl_b32 s8, s[sgprStrideD1J], 2                 // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s8         // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_store_b32 v25, v19, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_lshl_b32 s8, s[sgprStrideD1J], 2                 // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s8         // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_store_b32 v26, v19, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_lshl_b32 s8, s[sgprStrideD1J], 2                 // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s8         // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_store_b32 v27, v19, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_lshl_b32 s8, s[sgprStrideD1J], 2                 // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s8         // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_store_b32 v28, v19, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_nop 0                                            // 1 wait state required when next inst writes vgprs held by previous dwordx4 store inst
s_branch label_GW_End_1
label_GW_B0_FD0_VW1_MB_NonEdgeEnd:
label_GW_B0_FD0_VW1_MB_Else:
label_GW_B0_FD0_VW1_MB_Then:

/* edge=1, allocate 3 sgpr. perBatchTmpS=2 perBatchMaskS=1 perElementMaskS=0 elementsPerBatch=118 */
/* optSingleColVgpr=0 optSharedColVgpr=0 optSGPRUsage=BufferLoad_Edge_Mask optSrdIncForRow=0 factorDim=0 */

/******************************************/
/* Global Write Edge Batch #0 (d1,d0,vc1,vc0) = */
/*    (0,0,0,0:vw1); (0,0,1,0:vw1); (0,0,2,0:vw1); (0,0,3,0:vw1); (0,0,4,0:vw1); (0,0,5,0:vw1); (0,0,6,0:vw1); (0,0,7,0:vw1) */
/******************************************/

/* calc coords, apply mask, and issue loads (if necessary) */
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v14, BufferOOB
/* (d1,vc1,d0,vc0)=(0,0,0,0) */
v_cmp_lt_u32 s24, v8, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s26, v9, s[sgprSizeJ]                 // coord1 < size1
s_delay_alu instid0(NO_DEP)
s_and_b32 s26, s24, s26                            // in0 && in1
v_add_lshl_u32 v27, v11, v8, 2                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v27, v14, v27, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,0,0) */
v_add_co_u32 v9, vcc_lo, v9, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v10, v10, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v11, v11, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s24, v8, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s26, v9, s[sgprSizeJ]                 // coord1 < size1
s_delay_alu instid0(NO_DEP)
s_and_b32 s26, s24, s26                            // in0 && in1
v_add_lshl_u32 v28, v11, v8, 2                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v28, v14, v28, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,0,0) */
v_add_co_u32 v9, vcc_lo, v9, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v10, v10, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v11, v11, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s24, v8, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s26, v9, s[sgprSizeJ]                 // coord1 < size1
s_delay_alu instid0(NO_DEP)
s_and_b32 s26, s24, s26                            // in0 && in1
v_add_lshl_u32 v29, v11, v8, 2                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v29, v14, v29, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,0,0) */
v_add_co_u32 v9, vcc_lo, v9, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v10, v10, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v11, v11, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s24, v8, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s26, v9, s[sgprSizeJ]                 // coord1 < size1
s_delay_alu instid0(NO_DEP)
s_and_b32 s26, s24, s26                            // in0 && in1
v_add_lshl_u32 v30, v11, v8, 2                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v30, v14, v30, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,4,0,0) */
v_add_co_u32 v9, vcc_lo, v9, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v10, v10, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v11, v11, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s24, v8, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s26, v9, s[sgprSizeJ]                 // coord1 < size1
s_delay_alu instid0(NO_DEP)
s_and_b32 s26, s24, s26                            // in0 && in1
v_add_lshl_u32 v31, v11, v8, 2                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v31, v14, v31, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,5,0,0) */
v_add_co_u32 v9, vcc_lo, v9, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v10, v10, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v11, v11, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s24, v8, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s26, v9, s[sgprSizeJ]                 // coord1 < size1
s_delay_alu instid0(NO_DEP)
s_and_b32 s26, s24, s26                            // in0 && in1
v_add_lshl_u32 v32, v11, v8, 2                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v32, v14, v32, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,6,0,0) */
v_add_co_u32 v9, vcc_lo, v9, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v10, v10, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v11, v11, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s24, v8, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s26, v9, s[sgprSizeJ]                 // coord1 < size1
s_delay_alu instid0(NO_DEP)
s_and_b32 s26, s24, s26                            // in0 && in1
v_add_lshl_u32 v33, v11, v8, 2                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v33, v14, v33, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,7,0,0) */
v_add_co_u32 v9, vcc_lo, v9, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v10, v10, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v11, v11, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s24, v8, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s26, v9, s[sgprSizeJ]                 // coord1 < size1
s_delay_alu instid0(NO_DEP)
s_and_b32 s26, s24, s26                            // in0 && in1
v_add_lshl_u32 v34, v11, v8, 2                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v34, v14, v34, s26                   // LDD clip if OOB. offset

/* rC *= alpha batchElements=[(0, 0, 0, 0), (0, 0, 1, 0), (0, 0, 2, 0), (0, 0, 3, 0), (0, 0, 4, 0), (0, 0, 5, 0), (0, 0, 6, 0), (0, 0, 7, 0)] */
v_mov_b32 v[vgprValuC+19], v[vgprValuC+0]          // Rearrange MI out reg
v_mov_b32 v[vgprValuC+20], v[vgprValuC+1]          // Rearrange MI out reg
v_mov_b32 v[vgprValuC+21], v[vgprValuC+2]          // Rearrange MI out reg
v_mov_b32 v[vgprValuC+22], v[vgprValuC+3]          // Rearrange MI out reg
v_mov_b32 v[vgprValuC+23], v[vgprValuC+4]          // Rearrange MI out reg
v_mov_b32 v[vgprValuC+24], v[vgprValuC+5]          // Rearrange MI out reg
v_mov_b32 v[vgprValuC+25], v[vgprValuC+6]          // Rearrange MI out reg
v_mov_b32 v[vgprValuC+26], v[vgprValuC+7]          // Rearrange MI out reg

/* apply mask, calc new C and issue writes */
buffer_store_b32 v19, v27, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v20, v28, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v21, v29, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v22, v30, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v23, v31, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v24, v32, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v25, v33, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v26, v34, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_nop 0                                            // 1 wait state required when next inst writes vgprs held by previous dwordx4 store inst
s_branch label_GW_End_1
label_GW_B0_FD1_MB:

/* Edge/NonEdge store path check (M): Size % 16 > 0 -> Edge store; else -> NonEdge store */
s_and_b32 s24, 15, s[sgprSizeI]                    // s24 = s[sgprSizeI] % 16
s_add_u32 s25, -0x1, s[sgprNumWorkGroups0]
s_cmp_ge_u32 s[sgprWorkGroup0], s25                // wg0 >= nwg0-1 ?
s_cselect_b32 s24, s24, 0                          // set rem
s_mov_b32 s8, 0
s_cmp_gt_u32 s24, s8                               // rem > 0
s_cbranch_scc1 label_GW_B0_FD1_VW1_MB_Else         // jump if edges required

/* Edge/NonEdge store path check (N (isSize1)): Size % 16 > 0 -> Edge store; else -> NonEdge store */
s_and_b32 s24, 15, s[sgprSizeJ]                    // s24 = s[sgprSizeJ] % 16
s_add_u32 s25, -0x1, s[sgprNumWorkGroups1]
s_cmp_ge_u32 s[sgprWorkGroup1], s25                // wg1 >= nwg1-1
s_cselect_b32 s24, s24, 0                          // set rem
s_mov_b32 s8, 0
s_cmp_gt_u32 s24, s8                               // rem > 0
s_cbranch_scc1 label_GW_B0_FD1_VW1_MB_Then         // jump if edges required
label_GW_B0_FD1_VW1_MB_NonEdge:

/* edge=0, allocate 1 sgpr. perBatchTmpS=1 perBatchMaskS=0 perElementMaskS=0 elementsPerBatch=234 */
/* optSingleColVgpr=1 optSharedColVgpr=0 optSGPRUsage=BufferLoad_Mask optSrdIncForRow=1 factorDim=1 */

/******************************************/
/* Global Write Batch #0 (d1,d0,vc1,vc0) = */
/*    (0,0,0,0:vw1); (0,0,1,0:vw1); (0,0,2,0:vw1); (0,0,3,0:vw1); (0,0,4,0:vw1); (0,0,5,0:vw1); (0,0,6,0:vw1); (0,0,7,0:vw1) */
/******************************************/

/* calc coords, apply mask, and issue loads (if necessary) */
/* (d1,vc1,d0,vc0)=(0,0,0,0) */
/* (d1,vc1,d0,vc0)=(0,1,0,0) */
/* (d1,vc1,d0,vc0)=(0,2,0,0) */
/* (d1,vc1,d0,vc0)=(0,3,0,0) */
/* (d1,vc1,d0,vc0)=(0,4,0,0) */
/* (d1,vc1,d0,vc0)=(0,5,0,0) */
/* (d1,vc1,d0,vc0)=(0,6,0,0) */
/* (d1,vc1,d0,vc0)=(0,7,0,0) */
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_add_lshl_u32 v19, v11, v8, 2                     // optSingleColVgpr scaleToBpe: sharedAddrVgpr <- cinRowPtr + coord0, scaled by BPE. BSHERE:coord0=8, coord0Vgpr=8 (multiple bpe)

/* rC *= alpha batchElements=[(0, 0, 0, 0), (0, 0, 1, 0), (0, 0, 2, 0), (0, 0, 3, 0), (0, 0, 4, 0), (0, 0, 5, 0), (0, 0, 6, 0), (0, 0, 7, 0)] */
v_mov_b32 v[vgprValuC+21], v[vgprValuC+0]          // Rearrange MI out reg
v_mov_b32 v[vgprValuC+22], v[vgprValuC+1]          // Rearrange MI out reg
v_mov_b32 v[vgprValuC+23], v[vgprValuC+2]          // Rearrange MI out reg
v_mov_b32 v[vgprValuC+24], v[vgprValuC+3]          // Rearrange MI out reg
v_mov_b32 v[vgprValuC+25], v[vgprValuC+4]          // Rearrange MI out reg
v_mov_b32 v[vgprValuC+26], v[vgprValuC+5]          // Rearrange MI out reg
v_mov_b32 v[vgprValuC+27], v[vgprValuC+6]          // Rearrange MI out reg
v_mov_b32 v[vgprValuC+28], v[vgprValuC+7]          // Rearrange MI out reg

/* apply mask, calc new C and issue writes */
buffer_store_b32 v21, v19, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_lshl_b32 s8, s[sgprStrideD1J], 2                 // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s8         // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_store_b32 v22, v19, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_lshl_b32 s8, s[sgprStrideD1J], 2                 // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s8         // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_store_b32 v23, v19, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_lshl_b32 s8, s[sgprStrideD1J], 2                 // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s8         // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_store_b32 v24, v19, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_lshl_b32 s8, s[sgprStrideD1J], 2                 // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s8         // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_store_b32 v25, v19, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_lshl_b32 s8, s[sgprStrideD1J], 2                 // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s8         // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_store_b32 v26, v19, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_lshl_b32 s8, s[sgprStrideD1J], 2                 // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s8         // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_store_b32 v27, v19, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_lshl_b32 s8, s[sgprStrideD1J], 2                 // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s8         // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_store_b32 v28, v19, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_nop 0                                            // 1 wait state required when next inst writes vgprs held by previous dwordx4 store inst
s_branch label_GW_End_1
label_GW_B0_FD1_VW1_MB_NonEdgeEnd:
label_GW_B0_FD1_VW1_MB_Else:
label_GW_B0_FD1_VW1_MB_Then:

/* edge=1, allocate 3 sgpr. perBatchTmpS=2 perBatchMaskS=1 perElementMaskS=0 elementsPerBatch=118 */
/* optSingleColVgpr=0 optSharedColVgpr=0 optSGPRUsage=BufferLoad_Edge_Mask optSrdIncForRow=0 factorDim=1 */

/******************************************/
/* Global Write Edge Batch #0 (d1,d0,vc1,vc0) = */
/*    (0,0,0,0:vw1); (0,0,1,0:vw1); (0,0,2,0:vw1); (0,0,3,0:vw1); (0,0,4,0:vw1); (0,0,5,0:vw1); (0,0,6,0:vw1); (0,0,7,0:vw1) */
/******************************************/

/* calc coords, apply mask, and issue loads (if necessary) */
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v14, BufferOOB
/* (d1,vc1,d0,vc0)=(0,0,0,0) */
v_cmp_lt_u32 s24, v8, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s26, v9, s[sgprSizeJ]                 // coord1 < size1
s_delay_alu instid0(NO_DEP)
s_and_b32 s26, s24, s26                            // in0 && in1
v_add_lshl_u32 v27, v11, v8, 2                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v27, v14, v27, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,0,0) */
v_add_co_u32 v9, vcc_lo, v9, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v10, v10, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v11, v11, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s24, v8, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s26, v9, s[sgprSizeJ]                 // coord1 < size1
s_delay_alu instid0(NO_DEP)
s_and_b32 s26, s24, s26                            // in0 && in1
v_add_lshl_u32 v28, v11, v8, 2                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v28, v14, v28, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,0,0) */
v_add_co_u32 v9, vcc_lo, v9, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v10, v10, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v11, v11, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s24, v8, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s26, v9, s[sgprSizeJ]                 // coord1 < size1
s_delay_alu instid0(NO_DEP)
s_and_b32 s26, s24, s26                            // in0 && in1
v_add_lshl_u32 v29, v11, v8, 2                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v29, v14, v29, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,0,0) */
v_add_co_u32 v9, vcc_lo, v9, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v10, v10, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v11, v11, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s24, v8, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s26, v9, s[sgprSizeJ]                 // coord1 < size1
s_delay_alu instid0(NO_DEP)
s_and_b32 s26, s24, s26                            // in0 && in1
v_add_lshl_u32 v30, v11, v8, 2                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v30, v14, v30, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,4,0,0) */
v_add_co_u32 v9, vcc_lo, v9, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v10, v10, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v11, v11, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s24, v8, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s26, v9, s[sgprSizeJ]                 // coord1 < size1
s_delay_alu instid0(NO_DEP)
s_and_b32 s26, s24, s26                            // in0 && in1
v_add_lshl_u32 v31, v11, v8, 2                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v31, v14, v31, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,5,0,0) */
v_add_co_u32 v9, vcc_lo, v9, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v10, v10, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v11, v11, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s24, v8, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s26, v9, s[sgprSizeJ]                 // coord1 < size1
s_delay_alu instid0(NO_DEP)
s_and_b32 s26, s24, s26                            // in0 && in1
v_add_lshl_u32 v32, v11, v8, 2                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v32, v14, v32, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,6,0,0) */
v_add_co_u32 v9, vcc_lo, v9, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v10, v10, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v11, v11, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s24, v8, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s26, v9, s[sgprSizeJ]                 // coord1 < size1
s_delay_alu instid0(NO_DEP)
s_and_b32 s26, s24, s26                            // in0 && in1
v_add_lshl_u32 v33, v11, v8, 2                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v33, v14, v33, s26                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,7,0,0) */
v_add_co_u32 v9, vcc_lo, v9, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v10, v10, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v11, v11, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s24, v8, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s26, v9, s[sgprSizeJ]                 // coord1 < size1
s_delay_alu instid0(NO_DEP)
s_and_b32 s26, s24, s26                            // in0 && in1
v_add_lshl_u32 v34, v11, v8, 2                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v34, v14, v34, s26                   // LDD clip if OOB. offset

/* rC *= alpha batchElements=[(0, 0, 0, 0), (0, 0, 1, 0), (0, 0, 2, 0), (0, 0, 3, 0), (0, 0, 4, 0), (0, 0, 5, 0), (0, 0, 6, 0), (0, 0, 7, 0)] */
v_mov_b32 v[vgprValuC+19], v[vgprValuC+0]          // Rearrange MI out reg
v_mov_b32 v[vgprValuC+20], v[vgprValuC+1]          // Rearrange MI out reg
v_mov_b32 v[vgprValuC+21], v[vgprValuC+2]          // Rearrange MI out reg
v_mov_b32 v[vgprValuC+22], v[vgprValuC+3]          // Rearrange MI out reg
v_mov_b32 v[vgprValuC+23], v[vgprValuC+4]          // Rearrange MI out reg
v_mov_b32 v[vgprValuC+24], v[vgprValuC+5]          // Rearrange MI out reg
v_mov_b32 v[vgprValuC+25], v[vgprValuC+6]          // Rearrange MI out reg
v_mov_b32 v[vgprValuC+26], v[vgprValuC+7]          // Rearrange MI out reg

/* apply mask, calc new C and issue writes */
buffer_store_b32 v19, v27, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v20, v28, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v21, v29, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v22, v30, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v23, v31, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v24, v32, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v25, v33, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
buffer_store_b32 v26, v34, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_nop 0                                            // 1 wait state required when next inst writes vgprs held by previous dwordx4 store inst
s_branch label_GW_End_1
label_GW_End_1:
s_getpc_b64 s[24:25]                               // addr of next instr
s_add_i32 s26, label_KernelEnd, 4                  // target branch offset
s_add_u32 s24, s24, s26                            // add target branch offset
s_addc_u32 s25, s25, 0                             // add high and carry
s_setpc_b64 s[24:25]                               // branch to label_KernelEnd
label_GSU_5:
.set sgprAddressScaleAlphaVec, 60
.set sgprSrdScaleAlphaVec, 24
s_mov_b32 s11, 0
s_cmp_eq_u32 s[sgprFactorDim], s11                 // FactorDim == 0
s_cselect_b32 s8, s[sgprSizeI], s[sgprSizeJ]
s_mov_b64 s[sgprSrdScaleAlphaVec+0:sgprSrdScaleAlphaVec+0+1], s[sgprAddressScaleAlphaVec+0:sgprAddressScaleAlphaVec+0+1] // init SRD base address
s_mov_b32 s[sgprSrdScaleAlphaVec+3], Srd127_96     // Set bits 127_96 in post-loop SRD
s_cmp_eq_u64 s[sgprAddressScaleAlphaVec+0:sgprAddressScaleAlphaVec+0+1], 0 // AddressScaleAlphaVec == 0 (null) ?
s_cselect_b32 s[sgprSrdScaleAlphaVec+2], 0, s8     // num_records = (Address == 0) ? 0 : len

s_mul_i32 s[sgprSrdScaleAlphaVec+2], 0x4, s[sgprSrdScaleAlphaVec+2] // ScaleAlphaVec scaled by BPE
s_add_u32 s8, s[sgprWorkGroup2], 0x1
s_mul_i32 s8, s[sgprBiasStride], s8                // stride * (wg+1)
s_delay_alu instid0(SALU_CYCLE_1)
s_cmp_eq_u32 s8, 0                                 // bias stride = 0?
s_cbranch_scc0 label_Dont_Set_BiasStride_1
s_mov_b32 s11, 0
s_cmp_eq_u32 s[sgprFactorDim], s11                 // FactorDim == 0
s_cselect_b32 s8, s[sgprSizeI], s[sgprSizeJ]
label_Dont_Set_BiasStride_1:
s_mov_b64 s[sgprSrdBias+0:sgprSrdBias+0+1], s[sgprAddressBias+0:sgprAddressBias+0+1] // init SRD base address
s_mov_b32 s[sgprSrdBias+3], Srd127_96              // Set bits 127_96 in post-loop SRD
s_cmp_eq_u64 s[sgprAddressBias+0:sgprAddressBias+0+1], 0 // AddressBias == 0 (null) ?
s_cselect_b32 s[sgprSrdBias+2], 0, s8              // num_records = (Address == 0) ? 0 : len

label_Load_FactorDim_0_2:
s_mov_b32 s8, 0
s_cmp_lg_u32 s[sgprFactorDim], s8                  // FactorDim != 0
s_cbranch_scc1 label_Load_FactorDim_1_2            // Branch if true
label_Load_Biasf32_0_1:
s_mov_b32 s8, 0
s_cmp_lg_u32 s[sgprBiasType], s8                   // BiasType != 0
s_cbranch_scc1 label_Load_Biasbf16_0_1             // Branch if true

/******************************************/
/* Read vector to LDS                     */
/******************************************/
s_mul_i32 s8, 16, s[sgprWorkGroup0]                // wgp0 * MT0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_add_nc_u32 v16, s8, v[vgprSerial]                // coord 0 = wgp0 * MT0 + thread offset
s_mul_i32 s[sgprSrdBias+2], 0x4, s[sgprSrdBias+2]  // scaled by BPE
// Shift num records for gfx125x
s_and_b32 s8, s[sgprSrdBias+2], 127
s_delay_alu instid0(SALU_CYCLE_1)
s_lshl_b32 s8, s8, 25
s_and_b32 s[sgprSrdBias+1], s[sgprSrdBias+1], 33554431
s_delay_alu instid0(SALU_CYCLE_1)
s_or_b32 s[sgprSrdBias+1], s[sgprSrdBias+1], s8
s_lshr_b32 s[sgprSrdBias+2], s[sgprSrdBias+2], 7
s_mul_i32 s8, s[sgprBiasStride], s[sgprWorkGroup2] // Stride * WG
s_delay_alu instid0(NO_DEP)
v_add_nc_u32 v14, s8, v16                          // coord 0 = wgp0 * MT0 + thread offset + Stride * WG
s_delay_alu instid0(VALU_DEP_1)
v_lshlrev_b32 v14, 0x2, v14                        // Global bias address scaled by BPE
s_delay_alu instid0(VALU_DEP_3)
v_lshlrev_b32 v15, 0x2, v16                        // Global scaleAlpha address scaled by BPE
s_mul_i32 s8, 16, s[sgprWorkGroup1]                // wgp1 * MT1
v_add_nc_u32 v16, s8, v[vgprSerial]                // coord 1 = wgp1 * MT1 + thread offset
buffer_load_b32 v12, v14, s[sgprSrdBias:sgprSrdBias+3], null offen offset:0 // Load Bias
buffer_load_b32 v13, v15, s[sgprSrdScaleAlphaVec:sgprSrdScaleAlphaVec+3], null offen offset:0 // Load ScaleAlphaVec
v_lshlrev_b32 v16, 0x2, v[vgprSerial]              // Local address scaled by BPE
s_barrier_signal -1
s_barrier_wait -1                                  // wait for all global loads.
s_wait_loadcnt 1                                   // wait for global load
ds_store_b32 v16, v12 offset:0                     // store bias
v_cmp_gt_u32 s[sgprAddressScaleAlphaVec], s[sgprSrdScaleAlphaVec+2], 0 //  == 0 ?
s_wait_loadcnt 0                                   // wait for global load
v_cndmask_b32 v13, 1.0, v13, s[sgprAddressScaleAlphaVec] // 1. mul 1 if 0
ds_store_b32 v16, v13 offset:128                   // store scaleAlpha
s_branch label_Load_Bias_End_1                     // Branch to load bias end
label_Load_Biasbf16_0_1:
s_mov_b32 s8, 7
s_cmp_lg_u32 s[sgprBiasType], s8                   // BiasType != 7
s_cbranch_scc1 label_Load_Bias_End_1               // Branch if true

/******************************************/
/* Read vector to LDS                     */
/******************************************/
s_mul_i32 s8, 16, s[sgprWorkGroup0]                // wgp0 * MT0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_add_nc_u32 v16, s8, v[vgprSerial]                // coord 0 = wgp0 * MT0 + thread offset
s_mul_i32 s[sgprSrdBias+2], 0x2, s[sgprSrdBias+2]  // scaled by BPE
// Shift num records for gfx125x
s_and_b32 s8, s[sgprSrdBias+2], 127
s_delay_alu instid0(SALU_CYCLE_1)
s_lshl_b32 s8, s8, 25
s_and_b32 s[sgprSrdBias+1], s[sgprSrdBias+1], 33554431
s_delay_alu instid0(SALU_CYCLE_1)
s_or_b32 s[sgprSrdBias+1], s[sgprSrdBias+1], s8
s_lshr_b32 s[sgprSrdBias+2], s[sgprSrdBias+2], 7
s_mul_i32 s8, s[sgprBiasStride], s[sgprWorkGroup2] // Stride * WG
s_delay_alu instid0(NO_DEP)
v_add_nc_u32 v14, s8, v16                          // coord 0 = wgp0 * MT0 + thread offset + Stride * WG
s_delay_alu instid0(VALU_DEP_1)
v_lshlrev_b32 v14, 0x1, v14                        // Global bias address scaled by BPE
s_delay_alu instid0(VALU_DEP_3)
v_lshlrev_b32 v15, 0x2, v16                        // Global scaleAlpha address scaled by BPE
s_mul_i32 s8, 16, s[sgprWorkGroup1]                // wgp1 * MT1
v_add_nc_u32 v16, s8, v[vgprSerial]                // coord 1 = wgp1 * MT1 + thread offset
buffer_load_d16_b16 v12, v14, s[sgprSrdBias:sgprSrdBias+3], null offen offset:0 // Load Bias
buffer_load_b32 v13, v15, s[sgprSrdScaleAlphaVec:sgprSrdScaleAlphaVec+3], null offen offset:0 // Load ScaleAlphaVec
v_lshlrev_b32 v16, 0x2, v[vgprSerial]              // Local address scaled by BPE
s_barrier_signal -1
s_barrier_wait -1                                  // wait for all global loads.
s_wait_loadcnt 1                                   // wait for global load
v_cvt_f32_bf16 v12, v12.l op_sel:[0]               // cvt bf16 to f32
ds_store_b32 v16, v12 offset:0                     // store bias
v_cmp_gt_u32 s[sgprAddressScaleAlphaVec], s[sgprSrdScaleAlphaVec+2], 0 //  == 0 ?
s_wait_loadcnt 0                                   // wait for global load
v_cndmask_b32 v13, 1.0, v13, s[sgprAddressScaleAlphaVec] // 1. mul 1 if 0
ds_store_b32 v16, v13 offset:128                   // store scaleAlpha
s_branch label_Load_Bias_End_1                     // Branch to load bias end
label_Load_FactorDim_1_2:
label_Load_Biasf32_1_1:
s_mov_b32 s8, 0
s_cmp_lg_u32 s[sgprBiasType], s8                   // BiasType != 0
s_cbranch_scc1 label_Load_Biasbf16_1_1             // Branch if true

/******************************************/
/* Read vector to LDS                     */
/******************************************/
s_mul_i32 s8, 16, s[sgprWorkGroup1]                // wgp1 * MT1
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_add_nc_u32 v16, s8, v[vgprSerial]                // coord 1 = wgp1 * MT1 + thread offset
s_mul_i32 s[sgprSrdBias+2], 0x4, s[sgprSrdBias+2]  // scaled by BPE
// Shift num records for gfx125x
s_and_b32 s8, s[sgprSrdBias+2], 127
s_delay_alu instid0(SALU_CYCLE_1)
s_lshl_b32 s8, s8, 25
s_and_b32 s[sgprSrdBias+1], s[sgprSrdBias+1], 33554431
s_delay_alu instid0(SALU_CYCLE_1)
s_or_b32 s[sgprSrdBias+1], s[sgprSrdBias+1], s8
s_lshr_b32 s[sgprSrdBias+2], s[sgprSrdBias+2], 7
s_mul_i32 s8, s[sgprBiasStride], s[sgprWorkGroup2] // Stride * WG
s_delay_alu instid0(NO_DEP)
v_add_nc_u32 v14, s8, v16                          // coord 1 = wgp1 * MT1 + thread offset + Stride * WG
s_delay_alu instid0(VALU_DEP_1)
v_lshlrev_b32 v14, 0x2, v14                        // Global bias address scaled by BPE
s_delay_alu instid0(VALU_DEP_3)
v_lshlrev_b32 v15, 0x2, v16                        // Global scaleAlpha address scaled by BPE
s_mul_i32 s8, 16, s[sgprWorkGroup0]                // wgp0 * MT0
v_add_nc_u32 v16, s8, v[vgprSerial]                // coord 0 = wgp0 * MT0 + thread offset
buffer_load_b32 v12, v14, s[sgprSrdBias:sgprSrdBias+3], null offen offset:0 // Load Bias
buffer_load_b32 v13, v15, s[sgprSrdScaleAlphaVec:sgprSrdScaleAlphaVec+3], null offen offset:0 // Load ScaleAlphaVec
v_lshlrev_b32 v16, 0x2, v[vgprSerial]              // Local address scaled by BPE
s_barrier_signal -1
s_barrier_wait -1                                  // wait for all global loads.
s_wait_loadcnt 1                                   // wait for global load
ds_store_b32 v16, v12 offset:0                     // store bias
v_cmp_gt_u32 s[sgprAddressScaleAlphaVec], s[sgprSrdScaleAlphaVec+2], 0 //  == 0 ?
s_wait_loadcnt 0                                   // wait for global load
v_cndmask_b32 v13, 1.0, v13, s[sgprAddressScaleAlphaVec] // 1. mul 1 if 0
ds_store_b32 v16, v13 offset:128                   // store scaleAlpha
s_branch label_Load_Bias_End_1                     // Branch to load bias end
label_Load_Biasbf16_1_1:
s_mov_b32 s8, 7
s_cmp_lg_u32 s[sgprBiasType], s8                   // BiasType != 7
s_cbranch_scc1 label_Load_Bias_End_1               // Branch if true

/******************************************/
/* Read vector to LDS                     */
/******************************************/
s_mul_i32 s8, 16, s[sgprWorkGroup1]                // wgp1 * MT1
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_add_nc_u32 v16, s8, v[vgprSerial]                // coord 1 = wgp1 * MT1 + thread offset
s_mul_i32 s[sgprSrdBias+2], 0x2, s[sgprSrdBias+2]  // scaled by BPE
// Shift num records for gfx125x
s_and_b32 s8, s[sgprSrdBias+2], 127
s_delay_alu instid0(SALU_CYCLE_1)
s_lshl_b32 s8, s8, 25
s_and_b32 s[sgprSrdBias+1], s[sgprSrdBias+1], 33554431
s_delay_alu instid0(SALU_CYCLE_1)
s_or_b32 s[sgprSrdBias+1], s[sgprSrdBias+1], s8
s_lshr_b32 s[sgprSrdBias+2], s[sgprSrdBias+2], 7
s_mul_i32 s8, s[sgprBiasStride], s[sgprWorkGroup2] // Stride * WG
s_delay_alu instid0(NO_DEP)
v_add_nc_u32 v14, s8, v16                          // coord 1 = wgp1 * MT1 + thread offset + Stride * WG
s_delay_alu instid0(VALU_DEP_1)
v_lshlrev_b32 v14, 0x1, v14                        // Global bias address scaled by BPE
s_delay_alu instid0(VALU_DEP_3)
v_lshlrev_b32 v15, 0x2, v16                        // Global scaleAlpha address scaled by BPE
s_mul_i32 s8, 16, s[sgprWorkGroup0]                // wgp0 * MT0
v_add_nc_u32 v16, s8, v[vgprSerial]                // coord 0 = wgp0 * MT0 + thread offset
buffer_load_d16_b16 v12, v14, s[sgprSrdBias:sgprSrdBias+3], null offen offset:0 // Load Bias
buffer_load_b32 v13, v15, s[sgprSrdScaleAlphaVec:sgprSrdScaleAlphaVec+3], null offen offset:0 // Load ScaleAlphaVec
v_lshlrev_b32 v16, 0x2, v[vgprSerial]              // Local address scaled by BPE
s_barrier_signal -1
s_barrier_wait -1                                  // wait for all global loads.
s_wait_loadcnt 1                                   // wait for global load
v_cvt_f32_bf16 v12, v12.l op_sel:[0]               // cvt bf16 to f32
ds_store_b32 v16, v12 offset:0                     // store bias
v_cmp_gt_u32 s[sgprAddressScaleAlphaVec], s[sgprSrdScaleAlphaVec+2], 0 //  == 0 ?
s_wait_loadcnt 0                                   // wait for global load
v_cndmask_b32 v13, 1.0, v13, s[sgprAddressScaleAlphaVec] // 1. mul 1 if 0
ds_store_b32 v16, v13 offset:128                   // store scaleAlpha
s_branch label_Load_Bias_End_1                     // Branch to load bias end
label_Load_Bias_End_1:
.set sgprAddressScaleAlphaVec, UNDEF
.set sgprSrdScaleAlphaVec, UNDEF
s_mov_b32 s8, 1
s_cmp_eq_u32 s[sgprActivationType], s8             // activationType == 1
s_cbranch_scc1 label_To_Activation_Abs_VW1_1       // Branch if true
s_mov_b32 s8, 2
s_cmp_eq_u32 s[sgprActivationType], s8             // activationType == 2
s_cbranch_scc1 label_To_Activation_Clippedrelu_VW1_1 // Branch if true
s_mov_b32 s8, 3
s_cmp_eq_u32 s[sgprActivationType], s8             // activationType == 3
s_cbranch_scc1 label_To_Activation_Gelu_VW1_1      // Branch if true
s_mov_b32 s8, 4
s_cmp_eq_u32 s[sgprActivationType], s8             // activationType == 4
s_cbranch_scc1 label_To_Activation_Leakyrelu_VW1_1 // Branch if true
s_mov_b32 s8, 5
s_cmp_eq_u32 s[sgprActivationType], s8             // activationType == 5
s_cbranch_scc1 label_To_Activation_Relu_VW1_1      // Branch if true
s_mov_b32 s8, 6
s_cmp_eq_u32 s[sgprActivationType], s8             // activationType == 6
s_cbranch_scc1 label_To_Activation_Sigmoid_VW1_1   // Branch if true
s_mov_b32 s8, 7
s_cmp_eq_u32 s[sgprActivationType], s8             // activationType == 7
s_cbranch_scc1 label_To_Activation_Tanh_VW1_1      // Branch if true
s_mov_b32 s8, 10
s_cmp_eq_u32 s[sgprActivationType], s8             // activationType == 10
s_cbranch_scc1 label_To_Activation_Geluscaling_VW1_1 // Branch if true
s_mov_b32 s8, 11
s_cmp_eq_u32 s[sgprActivationType], s8             // activationType == 11
s_cbranch_scc1 label_To_Activation_Silu_VW1_1      // Branch if true
s_mov_b32 s8, 12
s_cmp_eq_u32 s[sgprActivationType], s8             // activationType == 12
s_cbranch_scc1 label_To_Activation_Swish_VW1_1     // Branch if true
s_mov_b32 s8, 13
s_cmp_eq_u32 s[sgprActivationType], s8             // activationType == 13
s_cbranch_scc1 label_To_Activation_Clamp_VW1_1     // Branch if true
label_To_Activation_None_VW1_1:
s_getpc_b64 s[12:13]                               // addr of next instr
s_add_i32 s8, label_Activation_None_VW1, 4         // target branch offset
s_add_u32 s12, s12, s8                             // add target branch offset
s_addc_u32 s13, s13, 0                             // add high and carry
s_branch label_ActivationSetPCAddrEnd_1
label_To_Activation_Abs_VW1_1:
s_getpc_b64 s[12:13]                               // addr of next instr
s_add_i32 s8, label_Activation_Abs_VW1, 4          // target branch offset
s_delay_alu instid0(SALU_CYCLE_1)
s_add_u32 s12, s12, s8                             // add target branch offset
s_addc_u32 s13, s13, 0                             // add high and carry
s_branch label_ActivationSetPCAddrEnd_1
label_To_Activation_Clippedrelu_VW1_1:
s_getpc_b64 s[12:13]                               // addr of next instr
s_add_i32 s8, label_Activation_Clippedrelu_VW1, 4  // target branch offset
s_delay_alu instid0(SALU_CYCLE_1)
s_add_u32 s12, s12, s8                             // add target branch offset
s_addc_u32 s13, s13, 0                             // add high and carry
s_branch label_ActivationSetPCAddrEnd_1
label_To_Activation_Gelu_VW1_1:
s_getpc_b64 s[12:13]                               // addr of next instr
s_add_i32 s8, label_Activation_Gelu_VW1, 4         // target branch offset
s_delay_alu instid0(SALU_CYCLE_1)
s_add_u32 s12, s12, s8                             // add target branch offset
s_addc_u32 s13, s13, 0                             // add high and carry
s_branch label_ActivationSetPCAddrEnd_1
label_To_Activation_Leakyrelu_VW1_1:
s_getpc_b64 s[12:13]                               // addr of next instr
s_add_i32 s8, label_Activation_Leakyrelu_VW1, 4    // target branch offset
s_delay_alu instid0(SALU_CYCLE_1)
s_add_u32 s12, s12, s8                             // add target branch offset
s_addc_u32 s13, s13, 0                             // add high and carry
s_branch label_ActivationSetPCAddrEnd_1
label_To_Activation_Relu_VW1_1:
s_getpc_b64 s[12:13]                               // addr of next instr
s_add_i32 s8, label_Activation_Relu_VW1, 4         // target branch offset
s_delay_alu instid0(SALU_CYCLE_1)
s_add_u32 s12, s12, s8                             // add target branch offset
s_addc_u32 s13, s13, 0                             // add high and carry
s_branch label_ActivationSetPCAddrEnd_1
label_To_Activation_Sigmoid_VW1_1:
s_getpc_b64 s[12:13]                               // addr of next instr
s_add_i32 s8, label_Activation_Sigmoid_VW1, 4      // target branch offset
s_delay_alu instid0(SALU_CYCLE_1)
s_add_u32 s12, s12, s8                             // add target branch offset
s_addc_u32 s13, s13, 0                             // add high and carry
s_branch label_ActivationSetPCAddrEnd_1
label_To_Activation_Tanh_VW1_1:
s_getpc_b64 s[12:13]                               // addr of next instr
s_add_i32 s8, label_Activation_Tanh_VW1, 4         // target branch offset
s_delay_alu instid0(SALU_CYCLE_1)
s_add_u32 s12, s12, s8                             // add target branch offset
s_addc_u32 s13, s13, 0                             // add high and carry
s_branch label_ActivationSetPCAddrEnd_1
label_To_Activation_Geluscaling_VW1_1:
s_getpc_b64 s[12:13]                               // addr of next instr
s_add_i32 s8, label_Activation_Geluscaling_VW1, 4  // target branch offset
s_delay_alu instid0(SALU_CYCLE_1)
s_add_u32 s12, s12, s8                             // add target branch offset
s_addc_u32 s13, s13, 0                             // add high and carry
s_branch label_ActivationSetPCAddrEnd_1
label_To_Activation_Silu_VW1_1:
s_getpc_b64 s[12:13]                               // addr of next instr
s_add_i32 s8, label_Activation_Silu_VW1, 4         // target branch offset
s_delay_alu instid0(SALU_CYCLE_1)
s_add_u32 s12, s12, s8                             // add target branch offset
s_addc_u32 s13, s13, 0                             // add high and carry
s_branch label_ActivationSetPCAddrEnd_1
label_To_Activation_Swish_VW1_1:
s_getpc_b64 s[12:13]                               // addr of next instr
s_add_i32 s8, label_Activation_Swish_VW1, 4        // target branch offset
s_delay_alu instid0(SALU_CYCLE_1)
s_add_u32 s12, s12, s8                             // add target branch offset
s_addc_u32 s13, s13, 0                             // add high and carry
s_branch label_ActivationSetPCAddrEnd_1
label_To_Activation_Clamp_VW1_1:
s_getpc_b64 s[12:13]                               // addr of next instr
s_add_i32 s8, label_Activation_Clamp_VW1, 4        // target branch offset
s_delay_alu instid0(SALU_CYCLE_1)
s_add_u32 s12, s12, s8                             // add target branch offset
s_addc_u32 s13, s13, 0                             // add high and carry
s_branch label_ActivationSetPCAddrEnd_1
label_ActivationSetPCAddrEnd_1:
s_mov_b32 s11, 0
s_cmp_eq_u32 s[sgprBeta], s11                      // Beta == 0
s_cbranch_scc0 label_GW_B1_GSU1                    // Branch if Beta is not zero

label_GW_B0_GSU1:
s_mov_b32 s8, 0
s_cmp_eq_u32 s[sgprFactorDim], s8                  // FactorDim == 0
s_cbranch_scc0 label_GW_B0_FD1_GSU1                // Branch if FactorDim is not zero

label_GW_B0_FD0_GSU1:

/* Edge/NonEdge store path check (M): Size % 16 > 0 -> Edge store; else -> NonEdge store */
s_and_b32 s38, 15, s[sgprSizeI]                    // s38 = s[sgprSizeI] % 16
s_add_u32 s39, -0x1, s[sgprNumWorkGroups0]
s_cmp_ge_u32 s[sgprWorkGroup0], s39                // wg0 >= nwg0-1 ?
s_cselect_b32 s38, s38, 0                          // set rem
s_mov_b32 s8, 0
s_cmp_gt_u32 s38, s8                               // rem > 0
s_cbranch_scc1 label_GW_B0_FD0_VW1_GSU1_Else       // jump if edges required

/* Edge/NonEdge store path check (N (isSize1)): Size % 16 > 0 -> Edge store; else -> NonEdge store */
s_and_b32 s38, 15, s[sgprSizeJ]                    // s38 = s[sgprSizeJ] % 16
s_add_u32 s39, -0x1, s[sgprNumWorkGroups1]
s_cmp_ge_u32 s[sgprWorkGroup1], s39                // wg1 >= nwg1-1
s_cselect_b32 s38, s38, 0                          // set rem
s_mov_b32 s8, 0
s_cmp_gt_u32 s38, s8                               // rem > 0
s_cbranch_scc1 label_GW_B0_FD0_VW1_GSU1_Then       // jump if edges required
label_GW_B0_FD0_VW1_GSU1_NonEdge:

/* edge=0, allocate 1 sgpr. perBatchTmpS=1 perBatchMaskS=0 perElementMaskS=0 elementsPerBatch=77 */
/* optSingleColVgpr=1 optSharedColVgpr=0 optSGPRUsage=BufferLoad_Mask optSrdIncForRow=1 factorDim=0 */

/******************************************/
/* Global Write Batch #0 (d1,d0,vc1,vc0) = */
/*    (0,0,0,0:vw1); (0,0,1,0:vw1); (0,0,2,0:vw1); (0,0,3,0:vw1); (0,0,4,0:vw1); (0,0,5,0:vw1); (0,0,6,0:vw1); (0,0,7,0:vw1) */
/******************************************/

/* calc coords, apply mask, and issue loads (if necessary) */
/* (d1,vc1,d0,vc0)=(0,0,0,0) */
s_mul_i32 s8, 16, s[sgprWorkGroup0]                // wgp0 * MT0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_sub_nc_u32 v21, v8, s8
s_delay_alu instid0(VALU_DEP_1)
v_lshlrev_b32 v21, 0x2, v21                        // Bias address scaled by BPE
s_wait_dscnt 0                                     // Wait for LDS write
s_barrier_signal -1
s_barrier_wait -1                                  // LDS write barrier
ds_load_b32 v30, v21 offset:0                      // load Bias
ds_load_b32 v31, v21 offset:128                    // load scaleAlpha
/* (d1,vc1,d0,vc0)=(0,1,0,0) */
/* (d1,vc1,d0,vc0)=(0,2,0,0) */
/* (d1,vc1,d0,vc0)=(0,3,0,0) */
/* (d1,vc1,d0,vc0)=(0,4,0,0) */
/* (d1,vc1,d0,vc0)=(0,5,0,0) */
/* (d1,vc1,d0,vc0)=(0,6,0,0) */
/* (d1,vc1,d0,vc0)=(0,7,0,0) */
v_add_lshl_u32 v19, v11, v8, 1                     // optSingleColVgpr scaleToBpe: sharedAddrVgpr <- cinRowPtr + coord0, scaled by BPE. BSHERE:coord0=8, coord0Vgpr=8 (multiple bpe)

/* rC *= alpha batchElements=[(0, 0, 0, 0), (0, 0, 1, 0), (0, 0, 2, 0), (0, 0, 3, 0), (0, 0, 4, 0), (0, 0, 5, 0), (0, 0, 6, 0), (0, 0, 7, 0)] */
v_mul_f32 v[vgprValuC+22], s[sgprAlpha], v[vgprValuC+0] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+23], s[sgprAlpha], v[vgprValuC+1] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+24], s[sgprAlpha], v[vgprValuC+2] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+25], s[sgprAlpha], v[vgprValuC+3] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+26], s[sgprAlpha], v[vgprValuC+4] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+27], s[sgprAlpha], v[vgprValuC+5] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+28], s[sgprAlpha], v[vgprValuC+6] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+29], s[sgprAlpha], v[vgprValuC+7] // Multiply MI out reg with alpha

/* apply mask, calc new C and issue writes */
v_mov_b32 v16, 0xffff0000                          // mask for pack two bfloat16 element to 32bit
v_mov_b32 v17, 0x7fff0000                          // fp32 Nan
v_mov_b32 v18, 0x7fff                              // rounding bias for bfloat16

s_wait_dscnt 0                                     // dscnt(0) = 2 - 1 (bias) - 1 (scaleAlphaVec) (interleaved)
v_mul_f32 v[vgprValuC+22], v31, v[vgprValuC+22]    // *= ScaleAlphaVecVMul
v_add_f32 v12, v30, v[vgprValuC+22]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v22, v12
v_cvt_pk_bf16_f32 v22, v[vgprValuC+22], v[vgprValuC+22] // convert C to bf16 in gwvw==1
buffer_store_b16 v22, v19, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_mul_f32 v[vgprValuC+23], v31, v[vgprValuC+23]    // *= ScaleAlphaVecVMul
v_add_f32 v12, v30, v[vgprValuC+23]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v23, v12
v_cvt_pk_bf16_f32 v23, v[vgprValuC+23], v[vgprValuC+23] // convert C to bf16 in gwvw==1
s_lshl_b32 s8, s[sgprStrideD1J], 1                 // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s8         // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_store_b16 v23, v19, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_mul_f32 v[vgprValuC+24], v31, v[vgprValuC+24]    // *= ScaleAlphaVecVMul
v_add_f32 v12, v30, v[vgprValuC+24]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v24, v12
v_cvt_pk_bf16_f32 v24, v[vgprValuC+24], v[vgprValuC+24] // convert C to bf16 in gwvw==1
s_lshl_b32 s8, s[sgprStrideD1J], 1                 // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s8         // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_store_b16 v24, v19, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_mul_f32 v[vgprValuC+25], v31, v[vgprValuC+25]    // *= ScaleAlphaVecVMul
v_add_f32 v12, v30, v[vgprValuC+25]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v25, v12
v_cvt_pk_bf16_f32 v25, v[vgprValuC+25], v[vgprValuC+25] // convert C to bf16 in gwvw==1
s_lshl_b32 s8, s[sgprStrideD1J], 1                 // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s8         // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_store_b16 v25, v19, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_mul_f32 v[vgprValuC+26], v31, v[vgprValuC+26]    // *= ScaleAlphaVecVMul
v_add_f32 v12, v30, v[vgprValuC+26]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v26, v12
v_cvt_pk_bf16_f32 v26, v[vgprValuC+26], v[vgprValuC+26] // convert C to bf16 in gwvw==1
s_lshl_b32 s8, s[sgprStrideD1J], 1                 // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s8         // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_store_b16 v26, v19, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_mul_f32 v[vgprValuC+27], v31, v[vgprValuC+27]    // *= ScaleAlphaVecVMul
v_add_f32 v12, v30, v[vgprValuC+27]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v27, v12
v_cvt_pk_bf16_f32 v27, v[vgprValuC+27], v[vgprValuC+27] // convert C to bf16 in gwvw==1
s_lshl_b32 s8, s[sgprStrideD1J], 1                 // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s8         // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_store_b16 v27, v19, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_mul_f32 v[vgprValuC+28], v31, v[vgprValuC+28]    // *= ScaleAlphaVecVMul
v_add_f32 v12, v30, v[vgprValuC+28]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v28, v12
v_cvt_pk_bf16_f32 v28, v[vgprValuC+28], v[vgprValuC+28] // convert C to bf16 in gwvw==1
s_lshl_b32 s8, s[sgprStrideD1J], 1                 // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s8         // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_store_b16 v28, v19, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_mul_f32 v[vgprValuC+29], v31, v[vgprValuC+29]    // *= ScaleAlphaVecVMul
v_add_f32 v12, v30, v[vgprValuC+29]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v29, v12
v_cvt_pk_bf16_f32 v29, v[vgprValuC+29], v[vgprValuC+29] // convert C to bf16 in gwvw==1
s_lshl_b32 s8, s[sgprStrideD1J], 1                 // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s8         // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_store_b16 v29, v19, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_nop 0                                            // 1 wait state required when next inst writes vgprs held by previous dwordx4 store inst
s_branch label_GW_End_2
label_GW_B0_FD0_VW1_GSU1_NonEdgeEnd:
label_GW_B0_FD0_VW1_GSU1_Else:
label_GW_B0_FD0_VW1_GSU1_Then:

/* edge=1, allocate 3 sgpr. perBatchTmpS=2 perBatchMaskS=1 perElementMaskS=0 elementsPerBatch=46 */
/* optSingleColVgpr=0 optSharedColVgpr=0 optSGPRUsage=BufferLoad_Edge_Mask optSrdIncForRow=0 factorDim=0 */

/******************************************/
/* Global Write Edge Batch #0 (d1,d0,vc1,vc0) = */
/*    (0,0,0,0:vw1); (0,0,1,0:vw1); (0,0,2,0:vw1); (0,0,3,0:vw1); (0,0,4,0:vw1); (0,0,5,0:vw1); (0,0,6,0:vw1); (0,0,7,0:vw1) */
/******************************************/

/* calc coords, apply mask, and issue loads (if necessary) */
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v14, BufferOOB
/* (d1,vc1,d0,vc0)=(0,0,0,0) */
v_cmp_lt_u32 s38, v8, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s40, v9, s[sgprSizeJ]                 // coord1 < size1
s_delay_alu instid0(NO_DEP)
s_and_b32 s40, s38, s40                            // in0 && in1
s_mul_i32 s38, 16, s[sgprWorkGroup0]               // wgp0 * MT0
v_sub_nc_u32 v30, v8, s38
s_delay_alu instid0(VALU_DEP_1)
v_lshlrev_b32 v30, 0x2, v30                        // Bias address scaled by BPE
s_wait_dscnt 0                                     // Wait for LDS write
s_barrier_signal -1
s_barrier_wait -1                                  // LDS write barrier
ds_load_b32 v27, v30 offset:0                      // load Bias
ds_load_b32 v28, v30 offset:128                    // load scaleAlpha
v_add_lshl_u32 v29, v11, v8, 1                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v29, v14, v29, s40                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,0,0) */
v_add_co_u32 v9, vcc_lo, v9, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v10, v10, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v11, v11, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s38, v8, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s40, v9, s[sgprSizeJ]                 // coord1 < size1
s_delay_alu instid0(NO_DEP)
s_and_b32 s40, s38, s40                            // in0 && in1
s_mul_i32 s38, 16, s[sgprWorkGroup0]               // wgp0 * MT0
v_sub_nc_u32 v32, v8, s38
s_delay_alu instid0(VALU_DEP_1)
v_lshlrev_b32 v32, 0x2, v32                        // Bias address scaled by BPE
v_add_lshl_u32 v31, v11, v8, 1                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v31, v14, v31, s40                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,0,0) */
v_add_co_u32 v9, vcc_lo, v9, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v10, v10, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v11, v11, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s38, v8, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s40, v9, s[sgprSizeJ]                 // coord1 < size1
s_delay_alu instid0(NO_DEP)
s_and_b32 s40, s38, s40                            // in0 && in1
s_mul_i32 s38, 16, s[sgprWorkGroup0]               // wgp0 * MT0
v_sub_nc_u32 v34, v8, s38
s_delay_alu instid0(VALU_DEP_1)
v_lshlrev_b32 v34, 0x2, v34                        // Bias address scaled by BPE
v_add_lshl_u32 v33, v11, v8, 1                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v33, v14, v33, s40                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,0,0) */
v_add_co_u32 v9, vcc_lo, v9, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v10, v10, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v11, v11, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s38, v8, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s40, v9, s[sgprSizeJ]                 // coord1 < size1
s_delay_alu instid0(NO_DEP)
s_and_b32 s40, s38, s40                            // in0 && in1
s_mul_i32 s38, 16, s[sgprWorkGroup0]               // wgp0 * MT0
v_sub_nc_u32 v36, v8, s38
s_delay_alu instid0(VALU_DEP_1)
v_lshlrev_b32 v36, 0x2, v36                        // Bias address scaled by BPE
v_add_lshl_u32 v35, v11, v8, 1                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v35, v14, v35, s40                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,4,0,0) */
v_add_co_u32 v9, vcc_lo, v9, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v10, v10, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v11, v11, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s38, v8, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s40, v9, s[sgprSizeJ]                 // coord1 < size1
s_delay_alu instid0(NO_DEP)
s_and_b32 s40, s38, s40                            // in0 && in1
s_mul_i32 s38, 16, s[sgprWorkGroup0]               // wgp0 * MT0
v_sub_nc_u32 v38, v8, s38
s_delay_alu instid0(VALU_DEP_1)
v_lshlrev_b32 v38, 0x2, v38                        // Bias address scaled by BPE
v_add_lshl_u32 v37, v11, v8, 1                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v37, v14, v37, s40                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,5,0,0) */
v_add_co_u32 v9, vcc_lo, v9, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v10, v10, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v11, v11, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s38, v8, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s40, v9, s[sgprSizeJ]                 // coord1 < size1
s_delay_alu instid0(NO_DEP)
s_and_b32 s40, s38, s40                            // in0 && in1
s_mul_i32 s38, 16, s[sgprWorkGroup0]               // wgp0 * MT0
v_sub_nc_u32 v40, v8, s38
s_delay_alu instid0(VALU_DEP_1)
v_lshlrev_b32 v40, 0x2, v40                        // Bias address scaled by BPE
v_add_lshl_u32 v39, v11, v8, 1                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v39, v14, v39, s40                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,6,0,0) */
v_add_co_u32 v9, vcc_lo, v9, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v10, v10, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v11, v11, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s38, v8, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s40, v9, s[sgprSizeJ]                 // coord1 < size1
s_delay_alu instid0(NO_DEP)
s_and_b32 s40, s38, s40                            // in0 && in1
s_mul_i32 s38, 16, s[sgprWorkGroup0]               // wgp0 * MT0
v_sub_nc_u32 v42, v8, s38
s_delay_alu instid0(VALU_DEP_1)
v_lshlrev_b32 v42, 0x2, v42                        // Bias address scaled by BPE
v_add_lshl_u32 v41, v11, v8, 1                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v41, v14, v41, s40                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,7,0,0) */
v_add_co_u32 v9, vcc_lo, v9, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v10, v10, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v11, v11, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s38, v8, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s40, v9, s[sgprSizeJ]                 // coord1 < size1
s_delay_alu instid0(NO_DEP)
s_and_b32 s40, s38, s40                            // in0 && in1
s_mul_i32 s38, 16, s[sgprWorkGroup0]               // wgp0 * MT0
v_sub_nc_u32 v44, v8, s38
s_delay_alu instid0(VALU_DEP_1)
v_lshlrev_b32 v44, 0x2, v44                        // Bias address scaled by BPE
v_add_lshl_u32 v43, v11, v8, 1                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v43, v14, v43, s40                   // LDD clip if OOB. offset

/* rC *= alpha batchElements=[(0, 0, 0, 0), (0, 0, 1, 0), (0, 0, 2, 0), (0, 0, 3, 0), (0, 0, 4, 0), (0, 0, 5, 0), (0, 0, 6, 0), (0, 0, 7, 0)] */
v_mul_f32 v[vgprValuC+19], s[sgprAlpha], v[vgprValuC+0] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+20], s[sgprAlpha], v[vgprValuC+1] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+21], s[sgprAlpha], v[vgprValuC+2] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+22], s[sgprAlpha], v[vgprValuC+3] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+23], s[sgprAlpha], v[vgprValuC+4] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+24], s[sgprAlpha], v[vgprValuC+5] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+25], s[sgprAlpha], v[vgprValuC+6] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+26], s[sgprAlpha], v[vgprValuC+7] // Multiply MI out reg with alpha
s_wait_dscnt 0                                     // wait for Bias LDS, ScaleAlphaVec

/* apply mask, calc new C and issue writes */
v_mov_b32 v16, 0xffff0000                          // mask for pack two bfloat16 element to 32bit
v_mov_b32 v17, 0x7fff0000                          // fp32 Nan
v_mov_b32 v18, 0x7fff                              // rounding bias for bfloat16
v_mul_f32 v[vgprValuC+19], v28, v[vgprValuC+19]    // *= ScaleAlphaVecVMul
v_add_f32 v12, v27, v[vgprValuC+19]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v19, v12
v_cvt_pk_bf16_f32 v19, v[vgprValuC+19], v[vgprValuC+19] // convert C to bf16 in gwvw==1
buffer_store_b16 v19, v29, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_mul_f32 v[vgprValuC+20], v28, v[vgprValuC+20]    // *= ScaleAlphaVecVMul
v_add_f32 v12, v27, v[vgprValuC+20]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v20, v12
v_cvt_pk_bf16_f32 v20, v[vgprValuC+20], v[vgprValuC+20] // convert C to bf16 in gwvw==1
buffer_store_b16 v20, v31, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_mul_f32 v[vgprValuC+21], v28, v[vgprValuC+21]    // *= ScaleAlphaVecVMul
v_add_f32 v12, v27, v[vgprValuC+21]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v21, v12
v_cvt_pk_bf16_f32 v21, v[vgprValuC+21], v[vgprValuC+21] // convert C to bf16 in gwvw==1
buffer_store_b16 v21, v33, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_mul_f32 v[vgprValuC+22], v28, v[vgprValuC+22]    // *= ScaleAlphaVecVMul
v_add_f32 v12, v27, v[vgprValuC+22]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v22, v12
v_cvt_pk_bf16_f32 v22, v[vgprValuC+22], v[vgprValuC+22] // convert C to bf16 in gwvw==1
buffer_store_b16 v22, v35, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_mul_f32 v[vgprValuC+23], v28, v[vgprValuC+23]    // *= ScaleAlphaVecVMul
v_add_f32 v12, v27, v[vgprValuC+23]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v23, v12
v_cvt_pk_bf16_f32 v23, v[vgprValuC+23], v[vgprValuC+23] // convert C to bf16 in gwvw==1
buffer_store_b16 v23, v37, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_mul_f32 v[vgprValuC+24], v28, v[vgprValuC+24]    // *= ScaleAlphaVecVMul
v_add_f32 v12, v27, v[vgprValuC+24]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v24, v12
v_cvt_pk_bf16_f32 v24, v[vgprValuC+24], v[vgprValuC+24] // convert C to bf16 in gwvw==1
buffer_store_b16 v24, v39, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_mul_f32 v[vgprValuC+25], v28, v[vgprValuC+25]    // *= ScaleAlphaVecVMul
v_add_f32 v12, v27, v[vgprValuC+25]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v25, v12
v_cvt_pk_bf16_f32 v25, v[vgprValuC+25], v[vgprValuC+25] // convert C to bf16 in gwvw==1
buffer_store_b16 v25, v41, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_mul_f32 v[vgprValuC+26], v28, v[vgprValuC+26]    // *= ScaleAlphaVecVMul
v_add_f32 v12, v27, v[vgprValuC+26]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v26, v12
v_cvt_pk_bf16_f32 v26, v[vgprValuC+26], v[vgprValuC+26] // convert C to bf16 in gwvw==1
buffer_store_b16 v26, v43, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_nop 0                                            // 1 wait state required when next inst writes vgprs held by previous dwordx4 store inst
s_branch label_GW_End_2
label_GW_B0_FD1_GSU1:

/* Edge/NonEdge store path check (M): Size % 16 > 0 -> Edge store; else -> NonEdge store */
s_and_b32 s38, 15, s[sgprSizeI]                    // s38 = s[sgprSizeI] % 16
s_add_u32 s39, -0x1, s[sgprNumWorkGroups0]
s_cmp_ge_u32 s[sgprWorkGroup0], s39                // wg0 >= nwg0-1 ?
s_cselect_b32 s38, s38, 0                          // set rem
s_mov_b32 s8, 0
s_cmp_gt_u32 s38, s8                               // rem > 0
s_cbranch_scc1 label_GW_B0_FD1_VW1_GSU1_Else       // jump if edges required

/* Edge/NonEdge store path check (N (isSize1)): Size % 16 > 0 -> Edge store; else -> NonEdge store */
s_and_b32 s38, 15, s[sgprSizeJ]                    // s38 = s[sgprSizeJ] % 16
s_add_u32 s39, -0x1, s[sgprNumWorkGroups1]
s_cmp_ge_u32 s[sgprWorkGroup1], s39                // wg1 >= nwg1-1
s_cselect_b32 s38, s38, 0                          // set rem
s_mov_b32 s8, 0
s_cmp_gt_u32 s38, s8                               // rem > 0
s_cbranch_scc1 label_GW_B0_FD1_VW1_GSU1_Then       // jump if edges required
label_GW_B0_FD1_VW1_GSU1_NonEdge:

/* edge=0, allocate 1 sgpr. perBatchTmpS=1 perBatchMaskS=0 perElementMaskS=0 elementsPerBatch=77 */
/* optSingleColVgpr=1 optSharedColVgpr=0 optSGPRUsage=BufferLoad_Mask optSrdIncForRow=1 factorDim=1 */

/******************************************/
/* Global Write Batch #0 (d1,d0,vc1,vc0) = */
/*    (0,0,0,0:vw1); (0,0,1,0:vw1); (0,0,2,0:vw1); (0,0,3,0:vw1); (0,0,4,0:vw1); (0,0,5,0:vw1); (0,0,6,0:vw1); (0,0,7,0:vw1) */
/******************************************/

/* calc coords, apply mask, and issue loads (if necessary) */
/* (d1,vc1,d0,vc0)=(0,0,0,0) */
s_mul_i32 s8, 16, s[sgprWorkGroup1]                // wgp1 * MT1
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_sub_nc_u32 v21, v9, s8
s_delay_alu instid0(VALU_DEP_1)
v_lshlrev_b32 v21, 0x2, v21                        // Bias address scaled by BPE
s_wait_dscnt 0                                     // Wait for LDS write
s_barrier_signal -1
s_barrier_wait -1                                  // LDS write barrier
ds_load_b32 v30, v21 offset:0                      // load Bias
ds_load_b32 v31, v21 offset:128                    // load scaleAlpha
/* (d1,vc1,d0,vc0)=(0,1,0,0) */
ds_load_b32 v32, v21 offset:4                      // load Bias
ds_load_b32 v33, v21 offset:132                    // load scaleAlpha
/* (d1,vc1,d0,vc0)=(0,2,0,0) */
ds_load_b32 v34, v21 offset:8                      // load Bias
ds_load_b32 v35, v21 offset:136                    // load scaleAlpha
/* (d1,vc1,d0,vc0)=(0,3,0,0) */
ds_load_b32 v36, v21 offset:12                     // load Bias
ds_load_b32 v37, v21 offset:140                    // load scaleAlpha
/* (d1,vc1,d0,vc0)=(0,4,0,0) */
ds_load_b32 v38, v21 offset:16                     // load Bias
ds_load_b32 v39, v21 offset:144                    // load scaleAlpha
/* (d1,vc1,d0,vc0)=(0,5,0,0) */
ds_load_b32 v40, v21 offset:20                     // load Bias
ds_load_b32 v41, v21 offset:148                    // load scaleAlpha
/* (d1,vc1,d0,vc0)=(0,6,0,0) */
ds_load_b32 v42, v21 offset:24                     // load Bias
ds_load_b32 v43, v21 offset:152                    // load scaleAlpha
/* (d1,vc1,d0,vc0)=(0,7,0,0) */
ds_load_b32 v44, v21 offset:28                     // load Bias
ds_load_b32 v45, v21 offset:156                    // load scaleAlpha
v_add_lshl_u32 v19, v11, v8, 1                     // optSingleColVgpr scaleToBpe: sharedAddrVgpr <- cinRowPtr + coord0, scaled by BPE. BSHERE:coord0=8, coord0Vgpr=8 (multiple bpe)

/* rC *= alpha batchElements=[(0, 0, 0, 0), (0, 0, 1, 0), (0, 0, 2, 0), (0, 0, 3, 0), (0, 0, 4, 0), (0, 0, 5, 0), (0, 0, 6, 0), (0, 0, 7, 0)] */
v_mul_f32 v[vgprValuC+22], s[sgprAlpha], v[vgprValuC+0] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+23], s[sgprAlpha], v[vgprValuC+1] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+24], s[sgprAlpha], v[vgprValuC+2] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+25], s[sgprAlpha], v[vgprValuC+3] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+26], s[sgprAlpha], v[vgprValuC+4] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+27], s[sgprAlpha], v[vgprValuC+5] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+28], s[sgprAlpha], v[vgprValuC+6] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+29], s[sgprAlpha], v[vgprValuC+7] // Multiply MI out reg with alpha

/* apply mask, calc new C and issue writes */
v_mov_b32 v16, 0xffff0000                          // mask for pack two bfloat16 element to 32bit
v_mov_b32 v17, 0x7fff0000                          // fp32 Nan
v_mov_b32 v18, 0x7fff                              // rounding bias for bfloat16

s_wait_dscnt 14                                    // dscnt(14) = 16 - 1 (bias) - 1 (scaleAlphaVec) (interleaved)
v_mul_f32 v[vgprValuC+22], v31, v[vgprValuC+22]    // *= ScaleAlphaVecVMul
v_add_f32 v12, v30, v[vgprValuC+22]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v22, v12
v_cvt_pk_bf16_f32 v22, v[vgprValuC+22], v[vgprValuC+22] // convert C to bf16 in gwvw==1
s_wait_xcnt 0
s_prefetch_inst_pc_rel 0, null, 31
buffer_store_b16 v22, v19, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_dscnt 12                                    // dscnt(12) = 16 - 2 (bias) - 2 (scaleAlphaVec) (interleaved)
v_mul_f32 v[vgprValuC+23], v33, v[vgprValuC+23]    // *= ScaleAlphaVecVMul
v_add_f32 v12, v32, v[vgprValuC+23]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v23, v12
v_cvt_pk_bf16_f32 v23, v[vgprValuC+23], v[vgprValuC+23] // convert C to bf16 in gwvw==1
s_lshl_b32 s8, s[sgprStrideD1J], 1                 // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s8         // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_store_b16 v23, v19, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_dscnt 10                                    // dscnt(10) = 16 - 3 (bias) - 3 (scaleAlphaVec) (interleaved)
v_mul_f32 v[vgprValuC+24], v35, v[vgprValuC+24]    // *= ScaleAlphaVecVMul
v_add_f32 v12, v34, v[vgprValuC+24]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v24, v12
v_cvt_pk_bf16_f32 v24, v[vgprValuC+24], v[vgprValuC+24] // convert C to bf16 in gwvw==1
s_lshl_b32 s8, s[sgprStrideD1J], 1                 // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s8         // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_store_b16 v24, v19, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_dscnt 8                                     // dscnt(8) = 16 - 4 (bias) - 4 (scaleAlphaVec) (interleaved)
v_mul_f32 v[vgprValuC+25], v37, v[vgprValuC+25]    // *= ScaleAlphaVecVMul
v_add_f32 v12, v36, v[vgprValuC+25]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v25, v12
v_cvt_pk_bf16_f32 v25, v[vgprValuC+25], v[vgprValuC+25] // convert C to bf16 in gwvw==1
s_lshl_b32 s8, s[sgprStrideD1J], 1                 // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s8         // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_store_b16 v25, v19, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_dscnt 6                                     // dscnt(6) = 16 - 5 (bias) - 5 (scaleAlphaVec) (interleaved)
v_mul_f32 v[vgprValuC+26], v39, v[vgprValuC+26]    // *= ScaleAlphaVecVMul
v_add_f32 v12, v38, v[vgprValuC+26]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v26, v12
v_cvt_pk_bf16_f32 v26, v[vgprValuC+26], v[vgprValuC+26] // convert C to bf16 in gwvw==1
s_lshl_b32 s8, s[sgprStrideD1J], 1                 // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s8         // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_store_b16 v26, v19, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_dscnt 4                                     // dscnt(4) = 16 - 6 (bias) - 6 (scaleAlphaVec) (interleaved)
v_mul_f32 v[vgprValuC+27], v41, v[vgprValuC+27]    // *= ScaleAlphaVecVMul
v_add_f32 v12, v40, v[vgprValuC+27]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v27, v12
v_cvt_pk_bf16_f32 v27, v[vgprValuC+27], v[vgprValuC+27] // convert C to bf16 in gwvw==1
s_lshl_b32 s8, s[sgprStrideD1J], 1                 // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s8         // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_store_b16 v27, v19, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_dscnt 2                                     // dscnt(2) = 16 - 7 (bias) - 7 (scaleAlphaVec) (interleaved)
v_mul_f32 v[vgprValuC+28], v43, v[vgprValuC+28]    // *= ScaleAlphaVecVMul
v_add_f32 v12, v42, v[vgprValuC+28]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v28, v12
v_cvt_pk_bf16_f32 v28, v[vgprValuC+28], v[vgprValuC+28] // convert C to bf16 in gwvw==1
s_lshl_b32 s8, s[sgprStrideD1J], 1                 // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s8         // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_store_b16 v28, v19, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_dscnt 0                                     // dscnt(0) = 16 - 8 (bias) - 8 (scaleAlphaVec) (interleaved)
v_mul_f32 v[vgprValuC+29], v45, v[vgprValuC+29]    // *= ScaleAlphaVecVMul
v_add_f32 v12, v44, v[vgprValuC+29]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v29, v12
v_cvt_pk_bf16_f32 v29, v[vgprValuC+29], v[vgprValuC+29] // convert C to bf16 in gwvw==1
s_lshl_b32 s8, s[sgprStrideD1J], 1                 // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s8         // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_store_b16 v29, v19, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_nop 0                                            // 1 wait state required when next inst writes vgprs held by previous dwordx4 store inst
s_branch label_GW_End_2
label_GW_B0_FD1_VW1_GSU1_NonEdgeEnd:
label_GW_B0_FD1_VW1_GSU1_Else:
label_GW_B0_FD1_VW1_GSU1_Then:

/* edge=1, allocate 3 sgpr. perBatchTmpS=2 perBatchMaskS=1 perElementMaskS=0 elementsPerBatch=46 */
/* optSingleColVgpr=0 optSharedColVgpr=0 optSGPRUsage=BufferLoad_Edge_Mask optSrdIncForRow=0 factorDim=1 */

/******************************************/
/* Global Write Edge Batch #0 (d1,d0,vc1,vc0) = */
/*    (0,0,0,0:vw1); (0,0,1,0:vw1); (0,0,2,0:vw1); (0,0,3,0:vw1); (0,0,4,0:vw1); (0,0,5,0:vw1); (0,0,6,0:vw1); (0,0,7,0:vw1) */
/******************************************/

/* calc coords, apply mask, and issue loads (if necessary) */
s_wait_xcnt 0
s_prefetch_inst_pc_rel 0, null, 31
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v14, BufferOOB
/* (d1,vc1,d0,vc0)=(0,0,0,0) */
v_cmp_lt_u32 s38, v8, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s40, v9, s[sgprSizeJ]                 // coord1 < size1
s_delay_alu instid0(NO_DEP)
s_and_b32 s40, s38, s40                            // in0 && in1
s_mul_i32 s38, 16, s[sgprWorkGroup1]               // wgp1 * MT1
v_sub_nc_u32 v30, v9, s38
s_delay_alu instid0(VALU_DEP_1)
v_lshlrev_b32 v30, 0x2, v30                        // Bias address scaled by BPE
s_wait_dscnt 0                                     // Wait for LDS write
s_barrier_signal -1
s_barrier_wait -1                                  // LDS write barrier
ds_load_b32 v27, v30 offset:0                      // load Bias
ds_load_b32 v28, v30 offset:128                    // load scaleAlpha
v_add_lshl_u32 v29, v11, v8, 1                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v29, v14, v29, s40                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,0,0) */
v_add_co_u32 v9, vcc_lo, v9, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v10, v10, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v11, v11, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s38, v8, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s40, v9, s[sgprSizeJ]                 // coord1 < size1
s_delay_alu instid0(NO_DEP)
s_and_b32 s40, s38, s40                            // in0 && in1
s_mul_i32 s38, 16, s[sgprWorkGroup1]               // wgp1 * MT1
v_sub_nc_u32 v34, v9, s38
s_delay_alu instid0(VALU_DEP_1)
v_lshlrev_b32 v34, 0x2, v34                        // Bias address scaled by BPE
ds_load_b32 v31, v34 offset:0                      // load Bias
ds_load_b32 v32, v34 offset:128                    // load scaleAlpha
v_add_lshl_u32 v33, v11, v8, 1                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v33, v14, v33, s40                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,0,0) */
v_add_co_u32 v9, vcc_lo, v9, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v10, v10, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v11, v11, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s38, v8, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s40, v9, s[sgprSizeJ]                 // coord1 < size1
s_delay_alu instid0(NO_DEP)
s_and_b32 s40, s38, s40                            // in0 && in1
s_mul_i32 s38, 16, s[sgprWorkGroup1]               // wgp1 * MT1
v_sub_nc_u32 v38, v9, s38
s_delay_alu instid0(VALU_DEP_1)
v_lshlrev_b32 v38, 0x2, v38                        // Bias address scaled by BPE
ds_load_b32 v35, v38 offset:0                      // load Bias
ds_load_b32 v36, v38 offset:128                    // load scaleAlpha
v_add_lshl_u32 v37, v11, v8, 1                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v37, v14, v37, s40                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,0,0) */
v_add_co_u32 v9, vcc_lo, v9, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v10, v10, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v11, v11, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s38, v8, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s40, v9, s[sgprSizeJ]                 // coord1 < size1
s_delay_alu instid0(NO_DEP)
s_and_b32 s40, s38, s40                            // in0 && in1
s_mul_i32 s38, 16, s[sgprWorkGroup1]               // wgp1 * MT1
v_sub_nc_u32 v42, v9, s38
s_delay_alu instid0(VALU_DEP_1)
v_lshlrev_b32 v42, 0x2, v42                        // Bias address scaled by BPE
ds_load_b32 v39, v42 offset:0                      // load Bias
ds_load_b32 v40, v42 offset:128                    // load scaleAlpha
v_add_lshl_u32 v41, v11, v8, 1                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v41, v14, v41, s40                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,4,0,0) */
v_add_co_u32 v9, vcc_lo, v9, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v10, v10, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v11, v11, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s38, v8, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s40, v9, s[sgprSizeJ]                 // coord1 < size1
s_delay_alu instid0(NO_DEP)
s_and_b32 s40, s38, s40                            // in0 && in1
s_mul_i32 s38, 16, s[sgprWorkGroup1]               // wgp1 * MT1
v_sub_nc_u32 v46, v9, s38
s_delay_alu instid0(VALU_DEP_1)
v_lshlrev_b32 v46, 0x2, v46                        // Bias address scaled by BPE
ds_load_b32 v43, v46 offset:0                      // load Bias
ds_load_b32 v44, v46 offset:128                    // load scaleAlpha
v_add_lshl_u32 v45, v11, v8, 1                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v45, v14, v45, s40                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,5,0,0) */
v_add_co_u32 v9, vcc_lo, v9, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v10, v10, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v11, v11, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s38, v8, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s40, v9, s[sgprSizeJ]                 // coord1 < size1
s_delay_alu instid0(NO_DEP)
s_and_b32 s40, s38, s40                            // in0 && in1
s_mul_i32 s38, 16, s[sgprWorkGroup1]               // wgp1 * MT1
v_sub_nc_u32 v50, v9, s38
s_delay_alu instid0(VALU_DEP_1)
v_lshlrev_b32 v50, 0x2, v50                        // Bias address scaled by BPE
ds_load_b32 v47, v50 offset:0                      // load Bias
ds_load_b32 v48, v50 offset:128                    // load scaleAlpha
v_add_lshl_u32 v49, v11, v8, 1                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v49, v14, v49, s40                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,6,0,0) */
v_add_co_u32 v9, vcc_lo, v9, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v10, v10, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v11, v11, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s38, v8, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s40, v9, s[sgprSizeJ]                 // coord1 < size1
s_delay_alu instid0(NO_DEP)
s_and_b32 s40, s38, s40                            // in0 && in1
s_mul_i32 s38, 16, s[sgprWorkGroup1]               // wgp1 * MT1
v_sub_nc_u32 v54, v9, s38
s_delay_alu instid0(VALU_DEP_1)
v_lshlrev_b32 v54, 0x2, v54                        // Bias address scaled by BPE
ds_load_b32 v51, v54 offset:0                      // load Bias
ds_load_b32 v52, v54 offset:128                    // load scaleAlpha
v_add_lshl_u32 v53, v11, v8, 1                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v53, v14, v53, s40                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,7,0,0) */
v_add_co_u32 v9, vcc_lo, v9, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v10, v10, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v11, v11, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s38, v8, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s40, v9, s[sgprSizeJ]                 // coord1 < size1
s_delay_alu instid0(NO_DEP)
s_and_b32 s40, s38, s40                            // in0 && in1
s_mul_i32 s38, 16, s[sgprWorkGroup1]               // wgp1 * MT1
v_sub_nc_u32 v58, v9, s38
s_delay_alu instid0(VALU_DEP_1)
v_lshlrev_b32 v58, 0x2, v58                        // Bias address scaled by BPE
ds_load_b32 v55, v58 offset:0                      // load Bias
ds_load_b32 v56, v58 offset:128                    // load scaleAlpha
v_add_lshl_u32 v57, v11, v8, 1                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v57, v14, v57, s40                   // LDD clip if OOB. offset

/* rC *= alpha batchElements=[(0, 0, 0, 0), (0, 0, 1, 0), (0, 0, 2, 0), (0, 0, 3, 0), (0, 0, 4, 0), (0, 0, 5, 0), (0, 0, 6, 0), (0, 0, 7, 0)] */
v_mul_f32 v[vgprValuC+19], s[sgprAlpha], v[vgprValuC+0] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+20], s[sgprAlpha], v[vgprValuC+1] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+21], s[sgprAlpha], v[vgprValuC+2] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+22], s[sgprAlpha], v[vgprValuC+3] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+23], s[sgprAlpha], v[vgprValuC+4] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+24], s[sgprAlpha], v[vgprValuC+5] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+25], s[sgprAlpha], v[vgprValuC+6] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+26], s[sgprAlpha], v[vgprValuC+7] // Multiply MI out reg with alpha
s_wait_dscnt 0                                     // wait for Bias LDS, ScaleAlphaVec

/* apply mask, calc new C and issue writes */
v_mov_b32 v16, 0xffff0000                          // mask for pack two bfloat16 element to 32bit
v_mov_b32 v17, 0x7fff0000                          // fp32 Nan
v_mov_b32 v18, 0x7fff                              // rounding bias for bfloat16
v_mul_f32 v[vgprValuC+19], v28, v[vgprValuC+19]    // *= ScaleAlphaVecVMul
v_add_f32 v12, v27, v[vgprValuC+19]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v19, v12
v_cvt_pk_bf16_f32 v19, v[vgprValuC+19], v[vgprValuC+19] // convert C to bf16 in gwvw==1
buffer_store_b16 v19, v29, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_mul_f32 v[vgprValuC+20], v32, v[vgprValuC+20]    // *= ScaleAlphaVecVMul
v_add_f32 v12, v31, v[vgprValuC+20]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v20, v12
v_cvt_pk_bf16_f32 v20, v[vgprValuC+20], v[vgprValuC+20] // convert C to bf16 in gwvw==1
buffer_store_b16 v20, v33, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_mul_f32 v[vgprValuC+21], v36, v[vgprValuC+21]    // *= ScaleAlphaVecVMul
v_add_f32 v12, v35, v[vgprValuC+21]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v21, v12
v_cvt_pk_bf16_f32 v21, v[vgprValuC+21], v[vgprValuC+21] // convert C to bf16 in gwvw==1
buffer_store_b16 v21, v37, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_mul_f32 v[vgprValuC+22], v40, v[vgprValuC+22]    // *= ScaleAlphaVecVMul
v_add_f32 v12, v39, v[vgprValuC+22]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v22, v12
v_cvt_pk_bf16_f32 v22, v[vgprValuC+22], v[vgprValuC+22] // convert C to bf16 in gwvw==1
buffer_store_b16 v22, v41, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_mul_f32 v[vgprValuC+23], v44, v[vgprValuC+23]    // *= ScaleAlphaVecVMul
v_add_f32 v12, v43, v[vgprValuC+23]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v23, v12
v_cvt_pk_bf16_f32 v23, v[vgprValuC+23], v[vgprValuC+23] // convert C to bf16 in gwvw==1
buffer_store_b16 v23, v45, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_mul_f32 v[vgprValuC+24], v48, v[vgprValuC+24]    // *= ScaleAlphaVecVMul
v_add_f32 v12, v47, v[vgprValuC+24]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v24, v12
v_cvt_pk_bf16_f32 v24, v[vgprValuC+24], v[vgprValuC+24] // convert C to bf16 in gwvw==1
buffer_store_b16 v24, v49, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_mul_f32 v[vgprValuC+25], v52, v[vgprValuC+25]    // *= ScaleAlphaVecVMul
v_add_f32 v12, v51, v[vgprValuC+25]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v25, v12
v_cvt_pk_bf16_f32 v25, v[vgprValuC+25], v[vgprValuC+25] // convert C to bf16 in gwvw==1
buffer_store_b16 v25, v53, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_mul_f32 v[vgprValuC+26], v56, v[vgprValuC+26]    // *= ScaleAlphaVecVMul
v_add_f32 v12, v55, v[vgprValuC+26]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v26, v12
v_cvt_pk_bf16_f32 v26, v[vgprValuC+26], v[vgprValuC+26] // convert C to bf16 in gwvw==1
buffer_store_b16 v26, v57, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_nop 0                                            // 1 wait state required when next inst writes vgprs held by previous dwordx4 store inst
s_branch label_GW_End_2
label_GW_B1_GSU1:
s_wait_xcnt 0
s_prefetch_inst_pc_rel 0, null, 31
s_mov_b32 s8, 0
s_cmp_eq_u32 s[sgprFactorDim], s8                  // FactorDim == 0
s_cbranch_scc0 label_GW_B1_FD1_GSU1                // Branch if FactorDim is not zero

label_GW_B1_FD0_GSU1:

/* Edge/NonEdge store path check (M): Size % 16 > 0 -> Edge store; else -> NonEdge store */
s_wait_xcnt 0
s_prefetch_inst_pc_rel 0, null, 31
s_and_b32 s38, 15, s[sgprSizeI]                    // s38 = s[sgprSizeI] % 16
s_add_u32 s39, -0x1, s[sgprNumWorkGroups0]
s_cmp_ge_u32 s[sgprWorkGroup0], s39                // wg0 >= nwg0-1 ?
s_cselect_b32 s38, s38, 0                          // set rem
s_mov_b32 s8, 0
s_cmp_gt_u32 s38, s8                               // rem > 0
s_cbranch_scc1 label_GW_B1_FD0_VW1_GSU1_Else       // jump if edges required

/* Edge/NonEdge store path check (N (isSize1)): Size % 16 > 0 -> Edge store; else -> NonEdge store */
s_wait_xcnt 0
s_prefetch_inst_pc_rel 0, null, 31
s_and_b32 s38, 15, s[sgprSizeJ]                    // s38 = s[sgprSizeJ] % 16
s_add_u32 s39, -0x1, s[sgprNumWorkGroups1]
s_cmp_ge_u32 s[sgprWorkGroup1], s39                // wg1 >= nwg1-1
s_cselect_b32 s38, s38, 0                          // set rem
s_mov_b32 s8, 0
s_cmp_gt_u32 s38, s8                               // rem > 0
s_cbranch_scc1 label_GW_B1_FD0_VW1_GSU1_Then       // jump if edges required
label_GW_B1_FD0_VW1_GSU1_NonEdge:

/* edge=0, allocate 1 sgpr. perBatchTmpS=1 perBatchMaskS=0 perElementMaskS=0 elementsPerBatch=58 */
/* optSingleColVgpr=1 optSharedColVgpr=0 optSGPRUsage=BufferLoad_Mask optSrdIncForRow=1 factorDim=0 */

/******************************************/
/* Global Write Beta Batch #0 (d1,d0,vc1,vc0) = */
/*    (0,0,0,0:vw1); (0,0,1,0:vw1); (0,0,2,0:vw1); (0,0,3,0:vw1); (0,0,4,0:vw1); (0,0,5,0:vw1); (0,0,6,0:vw1); (0,0,7,0:vw1) */
/******************************************/

/* calc coords, apply mask, and issue loads (if necessary) */
/* (d1,vc1,d0,vc0)=(0,0,0,0) */
s_wait_xcnt 0
s_prefetch_inst_pc_rel 0, null, 31
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_add_lshl_u32 v20, v10, v8, 1                     // optSingleColVgpr scaleToBpe: sharedAddrVgpr <- cinRowPtr + coord0, scaled by BPE. BSHERE:coord0=8, coord0Vgpr=8 (multiple bpe)
buffer_load_d16_b16 v30, v20, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_mul_i32 s8, 16, s[sgprWorkGroup0]                // wgp0 * MT0
v_sub_nc_u32 v21, v8, s8
s_delay_alu instid0(VALU_DEP_1)
v_lshlrev_b32 v21, 0x2, v21                        // Bias address scaled by BPE
s_wait_dscnt 0                                     // Wait for LDS write
s_barrier_signal -1
s_barrier_wait -1                                  // LDS write barrier
ds_load_b32 v31, v21 offset:0                      // load Bias
ds_load_b32 v32, v21 offset:128                    // load scaleAlpha
/* (d1,vc1,d0,vc0)=(0,1,0,0) */
s_lshl_b32 s8, s[sgprStrideC1J], 1                 // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdC+0], s[sgprSrdC+0], s8         // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdC+1], s[sgprSrdC+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_load_d16_b16 v33, v20, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
/* (d1,vc1,d0,vc0)=(0,2,0,0) */
s_lshl_b32 s8, s[sgprStrideC1J], 1                 // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdC+0], s[sgprSrdC+0], s8         // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdC+1], s[sgprSrdC+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_load_d16_b16 v34, v20, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
/* (d1,vc1,d0,vc0)=(0,3,0,0) */
s_lshl_b32 s8, s[sgprStrideC1J], 1                 // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdC+0], s[sgprSrdC+0], s8         // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdC+1], s[sgprSrdC+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_load_d16_b16 v35, v20, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
/* (d1,vc1,d0,vc0)=(0,4,0,0) */
s_lshl_b32 s8, s[sgprStrideC1J], 1                 // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdC+0], s[sgprSrdC+0], s8         // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdC+1], s[sgprSrdC+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_load_d16_b16 v36, v20, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
/* (d1,vc1,d0,vc0)=(0,5,0,0) */
s_lshl_b32 s8, s[sgprStrideC1J], 1                 // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdC+0], s[sgprSrdC+0], s8         // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdC+1], s[sgprSrdC+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_load_d16_b16 v37, v20, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
/* (d1,vc1,d0,vc0)=(0,6,0,0) */
s_lshl_b32 s8, s[sgprStrideC1J], 1                 // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdC+0], s[sgprSrdC+0], s8         // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdC+1], s[sgprSrdC+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_load_d16_b16 v38, v20, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
/* (d1,vc1,d0,vc0)=(0,7,0,0) */
s_lshl_b32 s8, s[sgprStrideC1J], 1                 // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdC+0], s[sgprSrdC+0], s8         // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdC+1], s[sgprSrdC+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_load_d16_b16 v39, v20, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
v_add_lshl_u32 v19, v11, v8, 1                     // optSingleColVgpr scaleToBpe: sharedAddrVgpr <- cinRowPtr + coord0, scaled by BPE. BSHERE:coord0=8, coord0Vgpr=8 (multiple bpe)

/* rC *= alpha batchElements=[(0, 0, 0, 0), (0, 0, 1, 0), (0, 0, 2, 0), (0, 0, 3, 0), (0, 0, 4, 0), (0, 0, 5, 0), (0, 0, 6, 0), (0, 0, 7, 0)] */
v_mul_f32 v[vgprValuC+22], s[sgprAlpha], v[vgprValuC+0] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+23], s[sgprAlpha], v[vgprValuC+1] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+24], s[sgprAlpha], v[vgprValuC+2] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+25], s[sgprAlpha], v[vgprValuC+3] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+26], s[sgprAlpha], v[vgprValuC+4] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+27], s[sgprAlpha], v[vgprValuC+5] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+28], s[sgprAlpha], v[vgprValuC+6] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+29], s[sgprAlpha], v[vgprValuC+7] // Multiply MI out reg with alpha

/* apply mask, calc new C and issue writes */
v_mov_b32 v16, 0xffff0000                          // mask for pack two bfloat16 element to 32bit
v_mov_b32 v17, 0x7fff0000                          // fp32 Nan
v_mov_b32 v18, 0x7fff                              // rounding bias for bfloat16

s_wait_dscnt 0                                     // vlcnt(7) = 8 - 1 (beta) dscnt(0) = 2 - 1 (bias) - 1 (scaleAlphaVec) (interleaved)
s_wait_loadcnt 7                                   // vlcnt(7) = 8 - 1 (beta) dscnt(0) = 2 - 1 (bias) - 1 (scaleAlphaVec) (interleaved)
v_mul_f32 v[vgprValuC+22], v32, v[vgprValuC+22]    // *= ScaleAlphaVecVMul
v_cvt_f32_bf16 v12, v30.l op_sel:[0]               // cvt bf16 to f32
v_fmac_f32 v[vgprValuC+22], v12, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_add_f32 v12, v31, v[vgprValuC+22]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v22, v12
v_cvt_pk_bf16_f32 v22, v[vgprValuC+22], v[vgprValuC+22] // convert C to bf16 in gwvw==1
buffer_store_b16 v22, v19, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_loadcnt 6                                   // vlcnt(6) = 8 - 2 (beta) (interleaved)
v_mul_f32 v[vgprValuC+23], v32, v[vgprValuC+23]    // *= ScaleAlphaVecVMul
v_cvt_f32_bf16 v12, v33.l op_sel:[0]               // cvt bf16 to f32
v_fmac_f32 v[vgprValuC+23], v12, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_add_f32 v12, v31, v[vgprValuC+23]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v23, v12
v_cvt_pk_bf16_f32 v23, v[vgprValuC+23], v[vgprValuC+23] // convert C to bf16 in gwvw==1
s_lshl_b32 s8, s[sgprStrideD1J], 1                 // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s8         // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_store_b16 v23, v19, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_loadcnt 5                                   // vlcnt(5) = 8 - 3 (beta) (interleaved)
v_mul_f32 v[vgprValuC+24], v32, v[vgprValuC+24]    // *= ScaleAlphaVecVMul
v_cvt_f32_bf16 v12, v34.l op_sel:[0]               // cvt bf16 to f32
v_fmac_f32 v[vgprValuC+24], v12, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_add_f32 v12, v31, v[vgprValuC+24]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v24, v12
v_cvt_pk_bf16_f32 v24, v[vgprValuC+24], v[vgprValuC+24] // convert C to bf16 in gwvw==1
s_lshl_b32 s8, s[sgprStrideD1J], 1                 // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s8         // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_store_b16 v24, v19, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_loadcnt 4                                   // vlcnt(4) = 8 - 4 (beta) (interleaved)
v_mul_f32 v[vgprValuC+25], v32, v[vgprValuC+25]    // *= ScaleAlphaVecVMul
v_cvt_f32_bf16 v12, v35.l op_sel:[0]               // cvt bf16 to f32
v_fmac_f32 v[vgprValuC+25], v12, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_add_f32 v12, v31, v[vgprValuC+25]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v25, v12
v_cvt_pk_bf16_f32 v25, v[vgprValuC+25], v[vgprValuC+25] // convert C to bf16 in gwvw==1
s_lshl_b32 s8, s[sgprStrideD1J], 1                 // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s8         // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_store_b16 v25, v19, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_loadcnt 3                                   // vlcnt(3) = 8 - 5 (beta) (interleaved)
v_mul_f32 v[vgprValuC+26], v32, v[vgprValuC+26]    // *= ScaleAlphaVecVMul
v_cvt_f32_bf16 v12, v36.l op_sel:[0]               // cvt bf16 to f32
v_fmac_f32 v[vgprValuC+26], v12, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_add_f32 v12, v31, v[vgprValuC+26]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v26, v12
v_cvt_pk_bf16_f32 v26, v[vgprValuC+26], v[vgprValuC+26] // convert C to bf16 in gwvw==1
s_lshl_b32 s8, s[sgprStrideD1J], 1                 // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s8         // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_store_b16 v26, v19, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_loadcnt 2                                   // vlcnt(2) = 8 - 6 (beta) (interleaved)
v_mul_f32 v[vgprValuC+27], v32, v[vgprValuC+27]    // *= ScaleAlphaVecVMul
v_cvt_f32_bf16 v12, v37.l op_sel:[0]               // cvt bf16 to f32
v_fmac_f32 v[vgprValuC+27], v12, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_add_f32 v12, v31, v[vgprValuC+27]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v27, v12
v_cvt_pk_bf16_f32 v27, v[vgprValuC+27], v[vgprValuC+27] // convert C to bf16 in gwvw==1
s_lshl_b32 s8, s[sgprStrideD1J], 1                 // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s8         // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_store_b16 v27, v19, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_loadcnt 1                                   // vlcnt(1) = 8 - 7 (beta) (interleaved)
v_mul_f32 v[vgprValuC+28], v32, v[vgprValuC+28]    // *= ScaleAlphaVecVMul
v_cvt_f32_bf16 v12, v38.l op_sel:[0]               // cvt bf16 to f32
v_fmac_f32 v[vgprValuC+28], v12, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_add_f32 v12, v31, v[vgprValuC+28]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v28, v12
v_cvt_pk_bf16_f32 v28, v[vgprValuC+28], v[vgprValuC+28] // convert C to bf16 in gwvw==1
s_lshl_b32 s8, s[sgprStrideD1J], 1                 // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s8         // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_store_b16 v28, v19, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_loadcnt 0                                   // vlcnt(0) = 8 - 8 (beta) (interleaved)
v_mul_f32 v[vgprValuC+29], v32, v[vgprValuC+29]    // *= ScaleAlphaVecVMul
v_cvt_f32_bf16 v12, v39.l op_sel:[0]               // cvt bf16 to f32
v_fmac_f32 v[vgprValuC+29], v12, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_add_f32 v12, v31, v[vgprValuC+29]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v29, v12
v_cvt_pk_bf16_f32 v29, v[vgprValuC+29], v[vgprValuC+29] // convert C to bf16 in gwvw==1
s_lshl_b32 s8, s[sgprStrideD1J], 1                 // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s8         // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_store_b16 v29, v19, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_nop 0                                            // 1 wait state required when next inst writes vgprs held by previous dwordx4 store inst
s_branch label_GW_End_2
label_GW_B1_FD0_VW1_GSU1_NonEdgeEnd:
label_GW_B1_FD0_VW1_GSU1_Else:
label_GW_B1_FD0_VW1_GSU1_Then:

/* edge=1, allocate 3 sgpr. perBatchTmpS=2 perBatchMaskS=1 perElementMaskS=0 elementsPerBatch=39 */
/* optSingleColVgpr=0 optSharedColVgpr=0 optSGPRUsage=BufferLoad_Edge_Mask optSrdIncForRow=0 factorDim=0 */

/******************************************/
/* Global Write Beta Edge Batch #0 (d1,d0,vc1,vc0) = */
/*    (0,0,0,0:vw1); (0,0,1,0:vw1); (0,0,2,0:vw1); (0,0,3,0:vw1); (0,0,4,0:vw1); (0,0,5,0:vw1); (0,0,6,0:vw1); (0,0,7,0:vw1) */
/******************************************/

/* calc coords, apply mask, and issue loads (if necessary) */
s_wait_xcnt 0
s_prefetch_inst_pc_rel 0, null, 31
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v14, BufferOOB
/* (d1,vc1,d0,vc0)=(0,0,0,0) */
v_cmp_lt_u32 s38, v8, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s40, v9, s[sgprSizeJ]                 // coord1 < size1
s_delay_alu instid0(NO_DEP)
s_and_b32 s40, s38, s40                            // in0 && in1
v_add_lshl_u32 v30, v10, v8, 1                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v30, v14, v30, s40                   // LDC clip if OOB. offset
buffer_load_d16_b16 v27, v30, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_mul_i32 s38, 16, s[sgprWorkGroup0]               // wgp0 * MT0
v_sub_nc_u32 v31, v8, s38
s_delay_alu instid0(VALU_DEP_1)
v_lshlrev_b32 v31, 0x2, v31                        // Bias address scaled by BPE
s_wait_dscnt 0                                     // Wait for LDS write
s_barrier_signal -1
s_barrier_wait -1                                  // LDS write barrier
ds_load_b32 v28, v31 offset:0                      // load Bias
ds_load_b32 v29, v31 offset:128                    // load scaleAlpha
v_add_lshl_u32 v30, v11, v8, 1                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v30, v14, v30, s40                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,0,0) */
v_add_co_u32 v9, vcc_lo, v9, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v10, v10, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v11, v11, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s38, v8, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s40, v9, s[sgprSizeJ]                 // coord1 < size1
s_delay_alu instid0(NO_DEP)
s_and_b32 s40, s38, s40                            // in0 && in1
v_add_lshl_u32 v33, v10, v8, 1                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v33, v14, v33, s40                   // LDC clip if OOB. offset
buffer_load_d16_b16 v32, v33, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_mul_i32 s38, 16, s[sgprWorkGroup0]               // wgp0 * MT0
v_sub_nc_u32 v34, v8, s38
s_delay_alu instid0(VALU_DEP_1)
v_lshlrev_b32 v34, 0x2, v34                        // Bias address scaled by BPE
v_add_lshl_u32 v33, v11, v8, 1                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v33, v14, v33, s40                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,0,0) */
v_add_co_u32 v9, vcc_lo, v9, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v10, v10, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v11, v11, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s38, v8, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s40, v9, s[sgprSizeJ]                 // coord1 < size1
s_delay_alu instid0(NO_DEP)
s_and_b32 s40, s38, s40                            // in0 && in1
v_add_lshl_u32 v36, v10, v8, 1                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v36, v14, v36, s40                   // LDC clip if OOB. offset
buffer_load_d16_b16 v35, v36, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_mul_i32 s38, 16, s[sgprWorkGroup0]               // wgp0 * MT0
v_sub_nc_u32 v37, v8, s38
s_delay_alu instid0(VALU_DEP_1)
v_lshlrev_b32 v37, 0x2, v37                        // Bias address scaled by BPE
v_add_lshl_u32 v36, v11, v8, 1                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v36, v14, v36, s40                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,0,0) */
v_add_co_u32 v9, vcc_lo, v9, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v10, v10, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v11, v11, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s38, v8, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s40, v9, s[sgprSizeJ]                 // coord1 < size1
s_delay_alu instid0(NO_DEP)
s_and_b32 s40, s38, s40                            // in0 && in1
v_add_lshl_u32 v39, v10, v8, 1                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v39, v14, v39, s40                   // LDC clip if OOB. offset
buffer_load_d16_b16 v38, v39, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_mul_i32 s38, 16, s[sgprWorkGroup0]               // wgp0 * MT0
v_sub_nc_u32 v40, v8, s38
s_delay_alu instid0(VALU_DEP_1)
v_lshlrev_b32 v40, 0x2, v40                        // Bias address scaled by BPE
v_add_lshl_u32 v39, v11, v8, 1                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v39, v14, v39, s40                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,4,0,0) */
v_add_co_u32 v9, vcc_lo, v9, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v10, v10, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v11, v11, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s38, v8, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s40, v9, s[sgprSizeJ]                 // coord1 < size1
s_delay_alu instid0(NO_DEP)
s_and_b32 s40, s38, s40                            // in0 && in1
v_add_lshl_u32 v42, v10, v8, 1                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v42, v14, v42, s40                   // LDC clip if OOB. offset
buffer_load_d16_b16 v41, v42, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_mul_i32 s38, 16, s[sgprWorkGroup0]               // wgp0 * MT0
v_sub_nc_u32 v43, v8, s38
s_delay_alu instid0(VALU_DEP_1)
v_lshlrev_b32 v43, 0x2, v43                        // Bias address scaled by BPE
v_add_lshl_u32 v42, v11, v8, 1                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v42, v14, v42, s40                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,5,0,0) */
v_add_co_u32 v9, vcc_lo, v9, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v10, v10, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v11, v11, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s38, v8, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s40, v9, s[sgprSizeJ]                 // coord1 < size1
s_delay_alu instid0(NO_DEP)
s_and_b32 s40, s38, s40                            // in0 && in1
v_add_lshl_u32 v45, v10, v8, 1                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v45, v14, v45, s40                   // LDC clip if OOB. offset
buffer_load_d16_b16 v44, v45, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_mul_i32 s38, 16, s[sgprWorkGroup0]               // wgp0 * MT0
v_sub_nc_u32 v46, v8, s38
s_delay_alu instid0(VALU_DEP_1)
v_lshlrev_b32 v46, 0x2, v46                        // Bias address scaled by BPE
v_add_lshl_u32 v45, v11, v8, 1                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v45, v14, v45, s40                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,6,0,0) */
v_add_co_u32 v9, vcc_lo, v9, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v10, v10, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v11, v11, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s38, v8, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s40, v9, s[sgprSizeJ]                 // coord1 < size1
s_delay_alu instid0(NO_DEP)
s_and_b32 s40, s38, s40                            // in0 && in1
v_add_lshl_u32 v48, v10, v8, 1                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v48, v14, v48, s40                   // LDC clip if OOB. offset
buffer_load_d16_b16 v47, v48, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_mul_i32 s38, 16, s[sgprWorkGroup0]               // wgp0 * MT0
v_sub_nc_u32 v49, v8, s38
s_delay_alu instid0(VALU_DEP_1)
v_lshlrev_b32 v49, 0x2, v49                        // Bias address scaled by BPE
v_add_lshl_u32 v48, v11, v8, 1                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v48, v14, v48, s40                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,7,0,0) */
v_add_co_u32 v9, vcc_lo, v9, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v10, v10, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v11, v11, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s38, v8, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s40, v9, s[sgprSizeJ]                 // coord1 < size1
s_delay_alu instid0(NO_DEP)
s_and_b32 s40, s38, s40                            // in0 && in1
v_add_lshl_u32 v51, v10, v8, 1                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v51, v14, v51, s40                   // LDC clip if OOB. offset
buffer_load_d16_b16 v50, v51, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_mul_i32 s38, 16, s[sgprWorkGroup0]               // wgp0 * MT0
v_sub_nc_u32 v52, v8, s38
s_delay_alu instid0(VALU_DEP_1)
v_lshlrev_b32 v52, 0x2, v52                        // Bias address scaled by BPE
v_add_lshl_u32 v51, v11, v8, 1                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v51, v14, v51, s40                   // LDD clip if OOB. offset

/* rC *= alpha batchElements=[(0, 0, 0, 0), (0, 0, 1, 0), (0, 0, 2, 0), (0, 0, 3, 0), (0, 0, 4, 0), (0, 0, 5, 0), (0, 0, 6, 0), (0, 0, 7, 0)] */
v_mul_f32 v[vgprValuC+19], s[sgprAlpha], v[vgprValuC+0] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+20], s[sgprAlpha], v[vgprValuC+1] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+21], s[sgprAlpha], v[vgprValuC+2] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+22], s[sgprAlpha], v[vgprValuC+3] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+23], s[sgprAlpha], v[vgprValuC+4] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+24], s[sgprAlpha], v[vgprValuC+5] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+25], s[sgprAlpha], v[vgprValuC+6] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+26], s[sgprAlpha], v[vgprValuC+7] // Multiply MI out reg with alpha
s_wait_dscnt 0                                     // wait for Beta, Bias LDS, ScaleAlphaVec
s_wait_loadcnt 0                                   // wait for Beta, Bias LDS, ScaleAlphaVec

/* apply mask, calc new C and issue writes */
v_mov_b32 v16, 0xffff0000                          // mask for pack two bfloat16 element to 32bit
v_mov_b32 v17, 0x7fff0000                          // fp32 Nan
v_mov_b32 v18, 0x7fff                              // rounding bias for bfloat16
v_mul_f32 v[vgprValuC+19], v29, v[vgprValuC+19]    // *= ScaleAlphaVecVMul
v_cvt_f32_bf16 v12, v27.l op_sel:[0]               // cvt bf16 to f32
v_fmac_f32 v[vgprValuC+19], v12, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_add_f32 v12, v28, v[vgprValuC+19]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v19, v12
v_cvt_pk_bf16_f32 v19, v[vgprValuC+19], v[vgprValuC+19] // convert C to bf16 in gwvw==1
buffer_store_b16 v19, v30, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_mul_f32 v[vgprValuC+20], v29, v[vgprValuC+20]    // *= ScaleAlphaVecVMul
v_cvt_f32_bf16 v12, v32.l op_sel:[0]               // cvt bf16 to f32
v_fmac_f32 v[vgprValuC+20], v12, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_add_f32 v12, v28, v[vgprValuC+20]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v20, v12
v_cvt_pk_bf16_f32 v20, v[vgprValuC+20], v[vgprValuC+20] // convert C to bf16 in gwvw==1
buffer_store_b16 v20, v33, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_mul_f32 v[vgprValuC+21], v29, v[vgprValuC+21]    // *= ScaleAlphaVecVMul
v_cvt_f32_bf16 v12, v35.l op_sel:[0]               // cvt bf16 to f32
v_fmac_f32 v[vgprValuC+21], v12, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_add_f32 v12, v28, v[vgprValuC+21]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v21, v12
v_cvt_pk_bf16_f32 v21, v[vgprValuC+21], v[vgprValuC+21] // convert C to bf16 in gwvw==1
buffer_store_b16 v21, v36, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_mul_f32 v[vgprValuC+22], v29, v[vgprValuC+22]    // *= ScaleAlphaVecVMul
v_cvt_f32_bf16 v12, v38.l op_sel:[0]               // cvt bf16 to f32
v_fmac_f32 v[vgprValuC+22], v12, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_add_f32 v12, v28, v[vgprValuC+22]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v22, v12
v_cvt_pk_bf16_f32 v22, v[vgprValuC+22], v[vgprValuC+22] // convert C to bf16 in gwvw==1
buffer_store_b16 v22, v39, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_mul_f32 v[vgprValuC+23], v29, v[vgprValuC+23]    // *= ScaleAlphaVecVMul
v_cvt_f32_bf16 v12, v41.l op_sel:[0]               // cvt bf16 to f32
v_fmac_f32 v[vgprValuC+23], v12, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_add_f32 v12, v28, v[vgprValuC+23]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v23, v12
v_cvt_pk_bf16_f32 v23, v[vgprValuC+23], v[vgprValuC+23] // convert C to bf16 in gwvw==1
buffer_store_b16 v23, v42, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_mul_f32 v[vgprValuC+24], v29, v[vgprValuC+24]    // *= ScaleAlphaVecVMul
v_cvt_f32_bf16 v12, v44.l op_sel:[0]               // cvt bf16 to f32
v_fmac_f32 v[vgprValuC+24], v12, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_add_f32 v12, v28, v[vgprValuC+24]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v24, v12
v_cvt_pk_bf16_f32 v24, v[vgprValuC+24], v[vgprValuC+24] // convert C to bf16 in gwvw==1
buffer_store_b16 v24, v45, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_mul_f32 v[vgprValuC+25], v29, v[vgprValuC+25]    // *= ScaleAlphaVecVMul
v_cvt_f32_bf16 v12, v47.l op_sel:[0]               // cvt bf16 to f32
v_fmac_f32 v[vgprValuC+25], v12, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_add_f32 v12, v28, v[vgprValuC+25]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v25, v12
v_cvt_pk_bf16_f32 v25, v[vgprValuC+25], v[vgprValuC+25] // convert C to bf16 in gwvw==1
buffer_store_b16 v25, v48, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_mul_f32 v[vgprValuC+26], v29, v[vgprValuC+26]    // *= ScaleAlphaVecVMul
v_cvt_f32_bf16 v12, v50.l op_sel:[0]               // cvt bf16 to f32
v_fmac_f32 v[vgprValuC+26], v12, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_add_f32 v12, v28, v[vgprValuC+26]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v26, v12
v_cvt_pk_bf16_f32 v26, v[vgprValuC+26], v[vgprValuC+26] // convert C to bf16 in gwvw==1
buffer_store_b16 v26, v51, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_nop 0                                            // 1 wait state required when next inst writes vgprs held by previous dwordx4 store inst
s_branch label_GW_End_2
label_GW_B1_FD1_GSU1:

/* Edge/NonEdge store path check (M): Size % 16 > 0 -> Edge store; else -> NonEdge store */
s_wait_xcnt 0
s_prefetch_inst_pc_rel 0, null, 31
s_and_b32 s38, 15, s[sgprSizeI]                    // s38 = s[sgprSizeI] % 16
s_add_u32 s39, -0x1, s[sgprNumWorkGroups0]
s_cmp_ge_u32 s[sgprWorkGroup0], s39                // wg0 >= nwg0-1 ?
s_cselect_b32 s38, s38, 0                          // set rem
s_mov_b32 s8, 0
s_cmp_gt_u32 s38, s8                               // rem > 0
s_cbranch_scc1 label_GW_B1_FD1_VW1_GSU1_Else       // jump if edges required

/* Edge/NonEdge store path check (N (isSize1)): Size % 16 > 0 -> Edge store; else -> NonEdge store */
s_wait_xcnt 0
s_prefetch_inst_pc_rel 0, null, 31
s_and_b32 s38, 15, s[sgprSizeJ]                    // s38 = s[sgprSizeJ] % 16
s_add_u32 s39, -0x1, s[sgprNumWorkGroups1]
s_cmp_ge_u32 s[sgprWorkGroup1], s39                // wg1 >= nwg1-1
s_cselect_b32 s38, s38, 0                          // set rem
s_mov_b32 s8, 0
s_cmp_gt_u32 s38, s8                               // rem > 0
s_cbranch_scc1 label_GW_B1_FD1_VW1_GSU1_Then       // jump if edges required
label_GW_B1_FD1_VW1_GSU1_NonEdge:

/* edge=0, allocate 1 sgpr. perBatchTmpS=1 perBatchMaskS=0 perElementMaskS=0 elementsPerBatch=58 */
/* optSingleColVgpr=1 optSharedColVgpr=0 optSGPRUsage=BufferLoad_Mask optSrdIncForRow=1 factorDim=1 */

/******************************************/
/* Global Write Beta Batch #0 (d1,d0,vc1,vc0) = */
/*    (0,0,0,0:vw1); (0,0,1,0:vw1); (0,0,2,0:vw1); (0,0,3,0:vw1); (0,0,4,0:vw1); (0,0,5,0:vw1); (0,0,6,0:vw1); (0,0,7,0:vw1) */
/******************************************/

/* calc coords, apply mask, and issue loads (if necessary) */
/* (d1,vc1,d0,vc0)=(0,0,0,0) */
s_wait_xcnt 0
s_prefetch_inst_pc_rel 0, null, 31
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_add_lshl_u32 v20, v10, v8, 1                     // optSingleColVgpr scaleToBpe: sharedAddrVgpr <- cinRowPtr + coord0, scaled by BPE. BSHERE:coord0=8, coord0Vgpr=8 (multiple bpe)
buffer_load_d16_b16 v30, v20, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_mul_i32 s8, 16, s[sgprWorkGroup1]                // wgp1 * MT1
v_sub_nc_u32 v21, v9, s8
s_delay_alu instid0(VALU_DEP_1)
v_lshlrev_b32 v21, 0x2, v21                        // Bias address scaled by BPE
s_wait_dscnt 0                                     // Wait for LDS write
s_barrier_signal -1
s_barrier_wait -1                                  // LDS write barrier
ds_load_b32 v31, v21 offset:0                      // load Bias
ds_load_b32 v32, v21 offset:128                    // load scaleAlpha
/* (d1,vc1,d0,vc0)=(0,1,0,0) */
s_lshl_b32 s8, s[sgprStrideC1J], 1                 // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdC+0], s[sgprSrdC+0], s8         // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdC+1], s[sgprSrdC+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_load_d16_b16 v33, v20, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
ds_load_b32 v34, v21 offset:4                      // load Bias
ds_load_b32 v35, v21 offset:132                    // load scaleAlpha
/* (d1,vc1,d0,vc0)=(0,2,0,0) */
s_lshl_b32 s8, s[sgprStrideC1J], 1                 // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdC+0], s[sgprSrdC+0], s8         // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdC+1], s[sgprSrdC+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_load_d16_b16 v36, v20, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
ds_load_b32 v37, v21 offset:8                      // load Bias
ds_load_b32 v38, v21 offset:136                    // load scaleAlpha
/* (d1,vc1,d0,vc0)=(0,3,0,0) */
s_lshl_b32 s8, s[sgprStrideC1J], 1                 // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdC+0], s[sgprSrdC+0], s8         // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdC+1], s[sgprSrdC+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_load_d16_b16 v39, v20, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
ds_load_b32 v40, v21 offset:12                     // load Bias
ds_load_b32 v41, v21 offset:140                    // load scaleAlpha
/* (d1,vc1,d0,vc0)=(0,4,0,0) */
s_lshl_b32 s8, s[sgprStrideC1J], 1                 // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdC+0], s[sgprSrdC+0], s8         // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdC+1], s[sgprSrdC+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_load_d16_b16 v42, v20, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
ds_load_b32 v43, v21 offset:16                     // load Bias
ds_load_b32 v44, v21 offset:144                    // load scaleAlpha
/* (d1,vc1,d0,vc0)=(0,5,0,0) */
s_lshl_b32 s8, s[sgprStrideC1J], 1                 // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdC+0], s[sgprSrdC+0], s8         // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdC+1], s[sgprSrdC+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_load_d16_b16 v45, v20, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
ds_load_b32 v46, v21 offset:20                     // load Bias
ds_load_b32 v47, v21 offset:148                    // load scaleAlpha
/* (d1,vc1,d0,vc0)=(0,6,0,0) */
s_lshl_b32 s8, s[sgprStrideC1J], 1                 // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdC+0], s[sgprSrdC+0], s8         // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdC+1], s[sgprSrdC+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_load_d16_b16 v48, v20, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
ds_load_b32 v49, v21 offset:24                     // load Bias
ds_load_b32 v50, v21 offset:152                    // load scaleAlpha
/* (d1,vc1,d0,vc0)=(0,7,0,0) */
s_lshl_b32 s8, s[sgprStrideC1J], 1                 // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdC+0], s[sgprSrdC+0], s8         // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdC+1], s[sgprSrdC+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_load_d16_b16 v51, v20, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
ds_load_b32 v52, v21 offset:28                     // load Bias
ds_load_b32 v53, v21 offset:156                    // load scaleAlpha
v_add_lshl_u32 v19, v11, v8, 1                     // optSingleColVgpr scaleToBpe: sharedAddrVgpr <- cinRowPtr + coord0, scaled by BPE. BSHERE:coord0=8, coord0Vgpr=8 (multiple bpe)

/* rC *= alpha batchElements=[(0, 0, 0, 0), (0, 0, 1, 0), (0, 0, 2, 0), (0, 0, 3, 0), (0, 0, 4, 0), (0, 0, 5, 0), (0, 0, 6, 0), (0, 0, 7, 0)] */
v_mul_f32 v[vgprValuC+22], s[sgprAlpha], v[vgprValuC+0] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+23], s[sgprAlpha], v[vgprValuC+1] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+24], s[sgprAlpha], v[vgprValuC+2] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+25], s[sgprAlpha], v[vgprValuC+3] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+26], s[sgprAlpha], v[vgprValuC+4] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+27], s[sgprAlpha], v[vgprValuC+5] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+28], s[sgprAlpha], v[vgprValuC+6] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+29], s[sgprAlpha], v[vgprValuC+7] // Multiply MI out reg with alpha

/* apply mask, calc new C and issue writes */
v_mov_b32 v16, 0xffff0000                          // mask for pack two bfloat16 element to 32bit
v_mov_b32 v17, 0x7fff0000                          // fp32 Nan
v_mov_b32 v18, 0x7fff                              // rounding bias for bfloat16

s_wait_dscnt 14                                    // vlcnt(7) = 8 - 1 (beta) dscnt(14) = 16 - 1 (bias) - 1 (scaleAlphaVec) (interleaved)
s_wait_loadcnt 7                                   // vlcnt(7) = 8 - 1 (beta) dscnt(14) = 16 - 1 (bias) - 1 (scaleAlphaVec) (interleaved)
v_mul_f32 v[vgprValuC+22], v32, v[vgprValuC+22]    // *= ScaleAlphaVecVMul
v_cvt_f32_bf16 v12, v30.l op_sel:[0]               // cvt bf16 to f32
v_fmac_f32 v[vgprValuC+22], v12, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_add_f32 v12, v31, v[vgprValuC+22]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v22, v12
v_cvt_pk_bf16_f32 v22, v[vgprValuC+22], v[vgprValuC+22] // convert C to bf16 in gwvw==1
buffer_store_b16 v22, v19, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_dscnt 12                                    // vlcnt(6) = 8 - 2 (beta) dscnt(12) = 16 - 2 (bias) - 2 (scaleAlphaVec) (interleaved)
s_wait_loadcnt 6                                   // vlcnt(6) = 8 - 2 (beta) dscnt(12) = 16 - 2 (bias) - 2 (scaleAlphaVec) (interleaved)
v_mul_f32 v[vgprValuC+23], v35, v[vgprValuC+23]    // *= ScaleAlphaVecVMul
v_cvt_f32_bf16 v12, v33.l op_sel:[0]               // cvt bf16 to f32
v_fmac_f32 v[vgprValuC+23], v12, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_add_f32 v12, v34, v[vgprValuC+23]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v23, v12
v_cvt_pk_bf16_f32 v23, v[vgprValuC+23], v[vgprValuC+23] // convert C to bf16 in gwvw==1
s_lshl_b32 s8, s[sgprStrideD1J], 1                 // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s8         // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_store_b16 v23, v19, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_dscnt 10                                    // vlcnt(5) = 8 - 3 (beta) dscnt(10) = 16 - 3 (bias) - 3 (scaleAlphaVec) (interleaved)
s_wait_loadcnt 5                                   // vlcnt(5) = 8 - 3 (beta) dscnt(10) = 16 - 3 (bias) - 3 (scaleAlphaVec) (interleaved)
v_mul_f32 v[vgprValuC+24], v38, v[vgprValuC+24]    // *= ScaleAlphaVecVMul
v_cvt_f32_bf16 v12, v36.l op_sel:[0]               // cvt bf16 to f32
v_fmac_f32 v[vgprValuC+24], v12, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_add_f32 v12, v37, v[vgprValuC+24]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v24, v12
v_cvt_pk_bf16_f32 v24, v[vgprValuC+24], v[vgprValuC+24] // convert C to bf16 in gwvw==1
s_lshl_b32 s8, s[sgprStrideD1J], 1                 // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s8         // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_store_b16 v24, v19, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_dscnt 8                                     // vlcnt(4) = 8 - 4 (beta) dscnt(8) = 16 - 4 (bias) - 4 (scaleAlphaVec) (interleaved)
s_wait_loadcnt 4                                   // vlcnt(4) = 8 - 4 (beta) dscnt(8) = 16 - 4 (bias) - 4 (scaleAlphaVec) (interleaved)
v_mul_f32 v[vgprValuC+25], v41, v[vgprValuC+25]    // *= ScaleAlphaVecVMul
v_cvt_f32_bf16 v12, v39.l op_sel:[0]               // cvt bf16 to f32
v_fmac_f32 v[vgprValuC+25], v12, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_add_f32 v12, v40, v[vgprValuC+25]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v25, v12
v_cvt_pk_bf16_f32 v25, v[vgprValuC+25], v[vgprValuC+25] // convert C to bf16 in gwvw==1
s_lshl_b32 s8, s[sgprStrideD1J], 1                 // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s8         // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_store_b16 v25, v19, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_dscnt 6                                     // vlcnt(3) = 8 - 5 (beta) dscnt(6) = 16 - 5 (bias) - 5 (scaleAlphaVec) (interleaved)
s_wait_loadcnt 3                                   // vlcnt(3) = 8 - 5 (beta) dscnt(6) = 16 - 5 (bias) - 5 (scaleAlphaVec) (interleaved)
v_mul_f32 v[vgprValuC+26], v44, v[vgprValuC+26]    // *= ScaleAlphaVecVMul
v_cvt_f32_bf16 v12, v42.l op_sel:[0]               // cvt bf16 to f32
v_fmac_f32 v[vgprValuC+26], v12, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_add_f32 v12, v43, v[vgprValuC+26]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v26, v12
v_cvt_pk_bf16_f32 v26, v[vgprValuC+26], v[vgprValuC+26] // convert C to bf16 in gwvw==1
s_lshl_b32 s8, s[sgprStrideD1J], 1                 // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s8         // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_store_b16 v26, v19, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_dscnt 4                                     // vlcnt(2) = 8 - 6 (beta) dscnt(4) = 16 - 6 (bias) - 6 (scaleAlphaVec) (interleaved)
s_wait_loadcnt 2                                   // vlcnt(2) = 8 - 6 (beta) dscnt(4) = 16 - 6 (bias) - 6 (scaleAlphaVec) (interleaved)
v_mul_f32 v[vgprValuC+27], v47, v[vgprValuC+27]    // *= ScaleAlphaVecVMul
v_cvt_f32_bf16 v12, v45.l op_sel:[0]               // cvt bf16 to f32
v_fmac_f32 v[vgprValuC+27], v12, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_add_f32 v12, v46, v[vgprValuC+27]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v27, v12
v_cvt_pk_bf16_f32 v27, v[vgprValuC+27], v[vgprValuC+27] // convert C to bf16 in gwvw==1
s_lshl_b32 s8, s[sgprStrideD1J], 1                 // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s8         // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_store_b16 v27, v19, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_dscnt 2                                     // vlcnt(1) = 8 - 7 (beta) dscnt(2) = 16 - 7 (bias) - 7 (scaleAlphaVec) (interleaved)
s_wait_loadcnt 1                                   // vlcnt(1) = 8 - 7 (beta) dscnt(2) = 16 - 7 (bias) - 7 (scaleAlphaVec) (interleaved)
v_mul_f32 v[vgprValuC+28], v50, v[vgprValuC+28]    // *= ScaleAlphaVecVMul
v_cvt_f32_bf16 v12, v48.l op_sel:[0]               // cvt bf16 to f32
v_fmac_f32 v[vgprValuC+28], v12, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_add_f32 v12, v49, v[vgprValuC+28]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v28, v12
v_cvt_pk_bf16_f32 v28, v[vgprValuC+28], v[vgprValuC+28] // convert C to bf16 in gwvw==1
s_lshl_b32 s8, s[sgprStrideD1J], 1                 // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s8         // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_store_b16 v28, v19, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D

s_wait_dscnt 0                                     // vlcnt(0) = 8 - 8 (beta) dscnt(0) = 16 - 8 (bias) - 8 (scaleAlphaVec) (interleaved)
s_wait_loadcnt 0                                   // vlcnt(0) = 8 - 8 (beta) dscnt(0) = 16 - 8 (bias) - 8 (scaleAlphaVec) (interleaved)
v_mul_f32 v[vgprValuC+29], v53, v[vgprValuC+29]    // *= ScaleAlphaVecVMul
v_cvt_f32_bf16 v12, v51.l op_sel:[0]               // cvt bf16 to f32
v_fmac_f32 v[vgprValuC+29], v12, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_add_f32 v12, v52, v[vgprValuC+29]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v29, v12
v_cvt_pk_bf16_f32 v29, v[vgprValuC+29], v[vgprValuC+29] // convert C to bf16 in gwvw==1
s_lshl_b32 s8, s[sgprStrideD1J], 1                 // incToNextRow: Scale by BPE
s_add_u32 s[sgprSrdD+0], s[sgprSrdD+0], s8         // incToNextRow: gra SRD += inc(lower)
s_addc_u32 s[sgprSrdD+1], s[sgprSrdD+1], 0         // incToNextRow: gra SRD += inc(upper)
buffer_store_b16 v29, v19, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_nop 0                                            // 1 wait state required when next inst writes vgprs held by previous dwordx4 store inst
s_branch label_GW_End_2
label_GW_B1_FD1_VW1_GSU1_NonEdgeEnd:
label_GW_B1_FD1_VW1_GSU1_Else:
label_GW_B1_FD1_VW1_GSU1_Then:

/* edge=1, allocate 3 sgpr. perBatchTmpS=2 perBatchMaskS=1 perElementMaskS=0 elementsPerBatch=39 */
/* optSingleColVgpr=0 optSharedColVgpr=0 optSGPRUsage=BufferLoad_Edge_Mask optSrdIncForRow=0 factorDim=1 */

/******************************************/
/* Global Write Beta Edge Batch #0 (d1,d0,vc1,vc0) = */
/*    (0,0,0,0:vw1); (0,0,1,0:vw1); (0,0,2,0:vw1); (0,0,3,0:vw1); (0,0,4,0:vw1); (0,0,5,0:vw1); (0,0,6,0:vw1); (0,0,7,0:vw1) */
/******************************************/

/* calc coords, apply mask, and issue loads (if necessary) */
s_wait_xcnt 0
s_prefetch_inst_pc_rel 0, null, 31
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v14, BufferOOB
/* (d1,vc1,d0,vc0)=(0,0,0,0) */
v_cmp_lt_u32 s38, v8, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s40, v9, s[sgprSizeJ]                 // coord1 < size1
s_delay_alu instid0(NO_DEP)
s_and_b32 s40, s38, s40                            // in0 && in1
v_add_lshl_u32 v30, v10, v8, 1                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v30, v14, v30, s40                   // LDC clip if OOB. offset
buffer_load_d16_b16 v27, v30, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_mul_i32 s38, 16, s[sgprWorkGroup1]               // wgp1 * MT1
v_sub_nc_u32 v31, v9, s38
s_delay_alu instid0(VALU_DEP_1)
v_lshlrev_b32 v31, 0x2, v31                        // Bias address scaled by BPE
s_wait_dscnt 0                                     // Wait for LDS write
s_barrier_signal -1
s_barrier_wait -1                                  // LDS write barrier
ds_load_b32 v28, v31 offset:0                      // load Bias
ds_load_b32 v29, v31 offset:128                    // load scaleAlpha
v_add_lshl_u32 v30, v11, v8, 1                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v30, v14, v30, s40                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,1,0,0) */
v_add_co_u32 v9, vcc_lo, v9, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v10, v10, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v11, v11, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s38, v8, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s40, v9, s[sgprSizeJ]                 // coord1 < size1
s_delay_alu instid0(NO_DEP)
s_and_b32 s40, s38, s40                            // in0 && in1
v_add_lshl_u32 v35, v10, v8, 1                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v35, v14, v35, s40                   // LDC clip if OOB. offset
buffer_load_d16_b16 v32, v35, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_mul_i32 s38, 16, s[sgprWorkGroup1]               // wgp1 * MT1
v_sub_nc_u32 v36, v9, s38
s_delay_alu instid0(VALU_DEP_1)
v_lshlrev_b32 v36, 0x2, v36                        // Bias address scaled by BPE
ds_load_b32 v33, v36 offset:0                      // load Bias
ds_load_b32 v34, v36 offset:128                    // load scaleAlpha
v_add_lshl_u32 v35, v11, v8, 1                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v35, v14, v35, s40                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,2,0,0) */
v_add_co_u32 v9, vcc_lo, v9, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v10, v10, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v11, v11, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s38, v8, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s40, v9, s[sgprSizeJ]                 // coord1 < size1
s_delay_alu instid0(NO_DEP)
s_and_b32 s40, s38, s40                            // in0 && in1
v_add_lshl_u32 v40, v10, v8, 1                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v40, v14, v40, s40                   // LDC clip if OOB. offset
buffer_load_d16_b16 v37, v40, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_mul_i32 s38, 16, s[sgprWorkGroup1]               // wgp1 * MT1
v_sub_nc_u32 v41, v9, s38
s_delay_alu instid0(VALU_DEP_1)
v_lshlrev_b32 v41, 0x2, v41                        // Bias address scaled by BPE
ds_load_b32 v38, v41 offset:0                      // load Bias
ds_load_b32 v39, v41 offset:128                    // load scaleAlpha
v_add_lshl_u32 v40, v11, v8, 1                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v40, v14, v40, s40                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,3,0,0) */
v_add_co_u32 v9, vcc_lo, v9, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v10, v10, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v11, v11, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s38, v8, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s40, v9, s[sgprSizeJ]                 // coord1 < size1
s_delay_alu instid0(NO_DEP)
s_and_b32 s40, s38, s40                            // in0 && in1
v_add_lshl_u32 v45, v10, v8, 1                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v45, v14, v45, s40                   // LDC clip if OOB. offset
buffer_load_d16_b16 v42, v45, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_mul_i32 s38, 16, s[sgprWorkGroup1]               // wgp1 * MT1
v_sub_nc_u32 v46, v9, s38
s_delay_alu instid0(VALU_DEP_1)
v_lshlrev_b32 v46, 0x2, v46                        // Bias address scaled by BPE
ds_load_b32 v43, v46 offset:0                      // load Bias
ds_load_b32 v44, v46 offset:128                    // load scaleAlpha
v_add_lshl_u32 v45, v11, v8, 1                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v45, v14, v45, s40                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,4,0,0) */
v_add_co_u32 v9, vcc_lo, v9, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v10, v10, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v11, v11, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s38, v8, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s40, v9, s[sgprSizeJ]                 // coord1 < size1
s_delay_alu instid0(NO_DEP)
s_and_b32 s40, s38, s40                            // in0 && in1
v_add_lshl_u32 v50, v10, v8, 1                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v50, v14, v50, s40                   // LDC clip if OOB. offset
buffer_load_d16_b16 v47, v50, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_mul_i32 s38, 16, s[sgprWorkGroup1]               // wgp1 * MT1
v_sub_nc_u32 v51, v9, s38
s_delay_alu instid0(VALU_DEP_1)
v_lshlrev_b32 v51, 0x2, v51                        // Bias address scaled by BPE
ds_load_b32 v48, v51 offset:0                      // load Bias
ds_load_b32 v49, v51 offset:128                    // load scaleAlpha
v_add_lshl_u32 v50, v11, v8, 1                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v50, v14, v50, s40                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,5,0,0) */
v_add_co_u32 v9, vcc_lo, v9, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v10, v10, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v11, v11, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s38, v8, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s40, v9, s[sgprSizeJ]                 // coord1 < size1
s_delay_alu instid0(NO_DEP)
s_and_b32 s40, s38, s40                            // in0 && in1
v_add_lshl_u32 v55, v10, v8, 1                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v55, v14, v55, s40                   // LDC clip if OOB. offset
buffer_load_d16_b16 v52, v55, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_mul_i32 s38, 16, s[sgprWorkGroup1]               // wgp1 * MT1
v_sub_nc_u32 v56, v9, s38
s_delay_alu instid0(VALU_DEP_1)
v_lshlrev_b32 v56, 0x2, v56                        // Bias address scaled by BPE
ds_load_b32 v53, v56 offset:0                      // load Bias
ds_load_b32 v54, v56 offset:128                    // load scaleAlpha
v_add_lshl_u32 v55, v11, v8, 1                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v55, v14, v55, s40                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,6,0,0) */
v_add_co_u32 v9, vcc_lo, v9, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v10, v10, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v11, v11, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s38, v8, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s40, v9, s[sgprSizeJ]                 // coord1 < size1
s_delay_alu instid0(NO_DEP)
s_and_b32 s40, s38, s40                            // in0 && in1
v_add_lshl_u32 v60, v10, v8, 1                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v60, v14, v60, s40                   // LDC clip if OOB. offset
buffer_load_d16_b16 v57, v60, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_mul_i32 s38, 16, s[sgprWorkGroup1]               // wgp1 * MT1
v_sub_nc_u32 v61, v9, s38
s_delay_alu instid0(VALU_DEP_1)
v_lshlrev_b32 v61, 0x2, v61                        // Bias address scaled by BPE
ds_load_b32 v58, v61 offset:0                      // load Bias
ds_load_b32 v59, v61 offset:128                    // load scaleAlpha
v_add_lshl_u32 v60, v11, v8, 1                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v60, v14, v60, s40                   // LDD clip if OOB. offset
/* (d1,vc1,d0,vc0)=(0,7,0,0) */
v_add_co_u32 v9, vcc_lo, v9, 1                     // coord1.1: coord1Vgpr += d1*sg1*VW + vc1

/* Fix for UseInitialStridesCD, emitAddressSetupCode */
v_add_nc_u32 v10, v10, s[sgprStrideC1J]            // ROWINC- Move cinRowPtr to next row
v_add_nc_u32 v11, v11, s[sgprStrideD1J]            // Move coutRowPtrD to next row
v_cmp_lt_u32 s38, v8, s[sgprSizeI]                 // coord0 < size0
v_cmp_lt_u32 s40, v9, s[sgprSizeJ]                 // coord1 < size1
s_delay_alu instid0(NO_DEP)
s_and_b32 s40, s38, s40                            // in0 && in1
v_add_lshl_u32 v65, v10, v8, 1                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v65, v14, v65, s40                   // LDC clip if OOB. offset
buffer_load_d16_b16 v62, v65, s[sgprSrdC:sgprSrdC+3], null offen offset:0 scope:SCOPE_CU th:TH_LOAD_RT // load C
s_mul_i32 s38, 16, s[sgprWorkGroup1]               // wgp1 * MT1
v_sub_nc_u32 v66, v9, s38
s_delay_alu instid0(VALU_DEP_1)
v_lshlrev_b32 v66, 0x2, v66                        // Bias address scaled by BPE
ds_load_b32 v63, v66 offset:0                      // load Bias
ds_load_b32 v64, v66 offset:128                    // load scaleAlpha
v_add_lshl_u32 v65, v11, v8, 1                     // scaleToBpe: accumulate d0 lower and *= bpe into Cin addr (multiple bpe)
v_cndmask_b32 v65, v14, v65, s40                   // LDD clip if OOB. offset

/* rC *= alpha batchElements=[(0, 0, 0, 0), (0, 0, 1, 0), (0, 0, 2, 0), (0, 0, 3, 0), (0, 0, 4, 0), (0, 0, 5, 0), (0, 0, 6, 0), (0, 0, 7, 0)] */
v_mul_f32 v[vgprValuC+19], s[sgprAlpha], v[vgprValuC+0] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+20], s[sgprAlpha], v[vgprValuC+1] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+21], s[sgprAlpha], v[vgprValuC+2] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+22], s[sgprAlpha], v[vgprValuC+3] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+23], s[sgprAlpha], v[vgprValuC+4] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+24], s[sgprAlpha], v[vgprValuC+5] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+25], s[sgprAlpha], v[vgprValuC+6] // Multiply MI out reg with alpha
v_mul_f32 v[vgprValuC+26], s[sgprAlpha], v[vgprValuC+7] // Multiply MI out reg with alpha
s_wait_dscnt 0                                     // wait for Beta, Bias LDS, ScaleAlphaVec
s_wait_loadcnt 0                                   // wait for Beta, Bias LDS, ScaleAlphaVec

/* apply mask, calc new C and issue writes */
v_mov_b32 v16, 0xffff0000                          // mask for pack two bfloat16 element to 32bit
v_mov_b32 v17, 0x7fff0000                          // fp32 Nan
v_mov_b32 v18, 0x7fff                              // rounding bias for bfloat16
v_mul_f32 v[vgprValuC+19], v29, v[vgprValuC+19]    // *= ScaleAlphaVecVMul
v_cvt_f32_bf16 v12, v27.l op_sel:[0]               // cvt bf16 to f32
v_fmac_f32 v[vgprValuC+19], v12, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_add_f32 v12, v28, v[vgprValuC+19]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v19, v12
v_cvt_pk_bf16_f32 v19, v[vgprValuC+19], v[vgprValuC+19] // convert C to bf16 in gwvw==1
buffer_store_b16 v19, v30, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_mul_f32 v[vgprValuC+20], v34, v[vgprValuC+20]    // *= ScaleAlphaVecVMul
v_cvt_f32_bf16 v12, v32.l op_sel:[0]               // cvt bf16 to f32
v_fmac_f32 v[vgprValuC+20], v12, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_add_f32 v12, v33, v[vgprValuC+20]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v20, v12
v_cvt_pk_bf16_f32 v20, v[vgprValuC+20], v[vgprValuC+20] // convert C to bf16 in gwvw==1
buffer_store_b16 v20, v35, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_mul_f32 v[vgprValuC+21], v39, v[vgprValuC+21]    // *= ScaleAlphaVecVMul
v_cvt_f32_bf16 v12, v37.l op_sel:[0]               // cvt bf16 to f32
v_fmac_f32 v[vgprValuC+21], v12, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_add_f32 v12, v38, v[vgprValuC+21]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v21, v12
v_cvt_pk_bf16_f32 v21, v[vgprValuC+21], v[vgprValuC+21] // convert C to bf16 in gwvw==1
buffer_store_b16 v21, v40, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_mul_f32 v[vgprValuC+22], v44, v[vgprValuC+22]    // *= ScaleAlphaVecVMul
v_cvt_f32_bf16 v12, v42.l op_sel:[0]               // cvt bf16 to f32
v_fmac_f32 v[vgprValuC+22], v12, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_add_f32 v12, v43, v[vgprValuC+22]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v22, v12
v_cvt_pk_bf16_f32 v22, v[vgprValuC+22], v[vgprValuC+22] // convert C to bf16 in gwvw==1
buffer_store_b16 v22, v45, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_mul_f32 v[vgprValuC+23], v49, v[vgprValuC+23]    // *= ScaleAlphaVecVMul
v_cvt_f32_bf16 v12, v47.l op_sel:[0]               // cvt bf16 to f32
v_fmac_f32 v[vgprValuC+23], v12, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_add_f32 v12, v48, v[vgprValuC+23]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v23, v12
v_cvt_pk_bf16_f32 v23, v[vgprValuC+23], v[vgprValuC+23] // convert C to bf16 in gwvw==1
buffer_store_b16 v23, v50, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_mul_f32 v[vgprValuC+24], v54, v[vgprValuC+24]    // *= ScaleAlphaVecVMul
v_cvt_f32_bf16 v12, v52.l op_sel:[0]               // cvt bf16 to f32
v_fmac_f32 v[vgprValuC+24], v12, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_add_f32 v12, v53, v[vgprValuC+24]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v24, v12
v_cvt_pk_bf16_f32 v24, v[vgprValuC+24], v[vgprValuC+24] // convert C to bf16 in gwvw==1
buffer_store_b16 v24, v55, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_mul_f32 v[vgprValuC+25], v59, v[vgprValuC+25]    // *= ScaleAlphaVecVMul
v_cvt_f32_bf16 v12, v57.l op_sel:[0]               // cvt bf16 to f32
v_fmac_f32 v[vgprValuC+25], v12, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_add_f32 v12, v58, v[vgprValuC+25]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v25, v12
v_cvt_pk_bf16_f32 v25, v[vgprValuC+25], v[vgprValuC+25] // convert C to bf16 in gwvw==1
buffer_store_b16 v25, v60, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
v_mul_f32 v[vgprValuC+26], v64, v[vgprValuC+26]    // *= ScaleAlphaVecVMul
v_cvt_f32_bf16 v12, v62.l op_sel:[0]               // cvt bf16 to f32
v_fmac_f32 v[vgprValuC+26], v12, s[sgprBeta]       // finalSum = sum*alpha + C*beta
v_add_f32 v12, v63, v[vgprValuC+26]                // C += bias
s_swappc_b64 s[24:25], s[12:13]
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mov_b32 v26, v12
v_cvt_pk_bf16_f32 v26, v[vgprValuC+26], v[vgprValuC+26] // convert C to bf16 in gwvw==1
buffer_store_b16 v26, v65, s[sgprSrdD:sgprSrdD+3], null offen offset:0 scope:SCOPE_CU th:TH_STORE_RT // store D
s_nop 0                                            // 1 wait state required when next inst writes vgprs held by previous dwordx4 store inst
s_branch label_GW_End_2
label_GW_End_2:
label_KernelEnd:
s_wait_xcnt 0
s_prefetch_inst_pc_rel 0, null, 31
s_endpgm                                           // Kernel End
label_ASM_End:  /// The end of the kernel
label_Activation_None_VW1:
s_wait_xcnt 0
s_prefetch_inst_pc_rel 0, null, 31
s_setpc_b64 s[24:25]
label_Activation_Abs_VW1:
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_and_b32 v12, 0x7fffffff, v12                     // Remove sign bit
s_setpc_b64 s[24:25]
label_Activation_Clippedrelu_VW1:
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_cmp_gt_f32 vcc_lo, v12, s[sgpractivationAlpha]   // x > alpha ?
v_min_f32 v12, s[sgpractivationBeta], v12          // min(x, beta)
v_min_f32 v13, s[sgpractivationBeta], 0.0          // min(0, beta)
s_delay_alu instid0(VALU_DEP_1)
v_cndmask_b32 v12, v13, v12, vcc_lo                // set x to min(0, beta) if <= alpha
s_setpc_b64 s[24:25]
label_Activation_Gelu_VW1:
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mul_f32 v13, 0x3d372713, v12                     // k1 * x
v_fma_f32 v13, v12, v13, 1.0                       // 1 + (k1 * x * x)
v_mul_f32 v13, v12, v13                            // x * (1 + k1 * x * x)
v_mul_f32 v13, 0x40135761, v13                     //  (fused 2.302208)
s_delay_alu instid0(VALU_DEP_1)
v_exp_f32 v13, v13                                 // exp step 2
s_nop 0                                            // 1 wait states
v_add_f32 v13, 1.0, v13                            // e^2x + 1
s_delay_alu instid0(VALU_DEP_1)
v_rcp_f32 v13, v13                                 // 1 / (e^2x + 1)
s_nop 0                                            // 1 wait states
s_delay_alu instid0(VALU_DEP_1)
v_fma_f32 v13, -2.0, v13, 2.0                      //  ( + 1 (fused))
v_mul_f32 v13, v12, v13                            // x * (1 + tanh(...))
s_delay_alu instid0(VALU_DEP_1)
v_mul_f32 v12, 0.5, v13                            // 0.5 * x * (1 + tanh(...))
s_setpc_b64 s[24:25]
label_Activation_Leakyrelu_VW1:
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mul_f32 v13, s[sgpractivationAlpha], v12         // tmp = x * alpha
v_cmp_ge_f32 vcc_lo, v12, 0.0                      // x >= 0 ?
v_cndmask_b32 v12, v13, v12, vcc_lo                // set x to tmp if < 0
s_setpc_b64 s[24:25]
label_Activation_Relu_VW1:
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_max_f32 v12, v12, 0                              // x = max(0, x)
s_setpc_b64 s[24:25]
label_Activation_Sigmoid_VW1:
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mul_f32 v12, 0xbfb8aa3b, v12                     //  (fused -1.442695)
s_delay_alu instid0(VALU_DEP_1)
v_exp_f32 v12, v12                                 // exp step 2
s_nop 0                                            // 1 wait states
v_add_f32 v12, 1.0, v12                            // 1 + exp(-x)
s_delay_alu instid0(VALU_DEP_1)
v_rcp_f32 v12, v12                                 // 1 / (1 + exp(-x))
s_nop 0                                            // 1 wait states
s_setpc_b64 s[24:25]
label_Activation_Tanh_VW1:
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mul_f32 v12, s[sgpractivationAlpha], v12         // x * alpha
v_mul_f32 v12, 0x4038aa3b, v12                     //  (fused 2)
s_delay_alu instid0(VALU_DEP_1)
v_exp_f32 v12, v12                                 // exp step 2
s_nop 0                                            // 1 wait states
s_delay_alu instid0(VALU_DEP_1)
v_add_f32 v12, 1.0, v12                            // e^2x + 1
s_delay_alu instid0(VALU_DEP_1)
v_rcp_f32 v12, v12                                 // 1 / (e^2x + 1)
s_nop 0                                            // 1 wait states
s_delay_alu instid0(VALU_DEP_1)
v_fma_f32 v12, -2.0, v12, 1.0                      // (-2) * (1 / (e^2x + 1)) + 1
v_mul_f32 v12, s[sgpractivationBeta], v12          // beta * tanh(x)
s_setpc_b64 s[24:25]
label_Activation_Geluscaling_VW1:
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mul_f32 v13, 0x3d372713, v12                     // k1 * x
v_fma_f32 v13, v12, v13, 1.0                       // 1 + (k1 * x * x)
v_mul_f32 v13, v12, v13                            // x * (1 + k1 * x * x)
v_mul_f32 v13, 0x40135761, v13                     //  (fused 2.302208)
s_delay_alu instid0(VALU_DEP_1)
v_exp_f32 v13, v13                                 // exp step 2
s_nop 0                                            // 1 wait states
v_add_f32 v13, 1.0, v13                            // e^2x + 1
s_delay_alu instid0(VALU_DEP_1)
v_rcp_f32 v13, v13                                 // 1 / (e^2x + 1)
s_nop 0                                            // 1 wait states
s_delay_alu instid0(VALU_DEP_1)
v_fma_f32 v13, -2.0, v13, 2.0                      //  ( + 1 (fused))
v_mul_f32 v13, v12, v13                            // x * (1 + tanh(...))
s_delay_alu instid0(VALU_DEP_1)
v_mul_f32 v13, 0.5, v13                            // 0.5 * x * (1 + tanh(...))
v_mul_f32 v12, s[sgpractivationAlpha], v13         // 0.5 * x * (1 + tanh(...)) * scale
s_setpc_b64 s[24:25]
label_Activation_Silu_VW1:
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mul_f32 v13, -1.4426950408889634, v12            //  (fused -1.442695)
s_delay_alu instid0(VALU_DEP_1)
v_exp_f32 v13, v13                                 // exp step 2
s_nop 0                                            // 1 wait states
s_delay_alu instid0(VALU_DEP_1)
v_add_f32 v13, 1.0, v13                            // 1 + exp(-x)
s_delay_alu instid0(VALU_DEP_1)
v_rcp_f32 v13, v13                                 // 1 / (1 + exp(-x))
s_nop 0                                            // 1 wait states
v_mul_f32 v12, v12, v13                            // x / (1 + exp(-x))
s_setpc_b64 s[24:25]
label_Activation_Swish_VW1:
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_mul_f32 v13, v12, s[sgpractivationAlpha]         // x * beta
s_delay_alu instid0(VALU_DEP_1)
v_mul_f32 v14, -1.4426950408889634, v13            //  (fused -1.442695)
s_delay_alu instid0(VALU_DEP_1)
v_exp_f32 v14, v14                                 // exp step 2
s_nop 0                                            // 1 wait states
s_delay_alu instid0(VALU_DEP_1)
v_add_f32 v14, 1.0, v14                            // 1 + exp(-x)
s_delay_alu instid0(VALU_DEP_1)
v_rcp_f32 v14, v14                                 // 1 / (1 + exp(-x))
s_nop 0                                            // 1 wait states
v_mul_f32 v12, v12, v14                            // x / (1 + exp(-x * beta))
s_setpc_b64 s[24:25]
label_Activation_Clamp_VW1:
s_nop 0
s_set_vgpr_msb 0                                   // src0: 0, src1: 0, src2: 0, dst: 0
v_min_f32 v12, s[sgpractivationBeta], v12          // min(x, beta)
v_max_f32 v12, s[sgpractivationAlpha], v12         // max(alpha, min(x, beta))
s_setpc_b64 s[24:25]
s_endpgm
