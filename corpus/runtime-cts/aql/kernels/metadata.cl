// Kernel ABI and kernarg preload reference:
// https://llvm.org/docs/AMDGPUUsage.html
// Purpose: Consume 32 changing scalar arguments across preload block boundaries.
// Build with 0, 1, 15, 16, 29 or 30 preloaded dwords. Scalars precede the output
// pointer so a one-dword preload is legal. The host verifies each descriptor.
__kernel void cts_work(uint a0, uint a1, uint a2, uint a3, uint a4, uint a5, uint a6, uint a7,
                       uint a8, uint a9, uint a10, uint a11, uint a12, uint a13, uint a14, uint a15,
                       uint a16, uint a17, uint a18, uint a19, uint a20, uint a21, uint a22,
                       uint a23, uint a24, uint a25, uint a26, uint a27, uint a28, uint a29,
                       uint a30, uint a31, __global uint* output, uint token) {
  output[0] = a0 + token * 1u;
  output[1] = a1 + token * 2u;
  output[2] = a2 + token * 3u;
  output[3] = a3 + token * 4u;
  output[4] = a4 + token * 5u;
  output[5] = a5 + token * 6u;
  output[6] = a6 + token * 7u;
  output[7] = a7 + token * 8u;
  output[8] = a8 + token * 9u;
  output[9] = a9 + token * 10u;
  output[10] = a10 + token * 11u;
  output[11] = a11 + token * 12u;
  output[12] = a12 + token * 13u;
  output[13] = a13 + token * 14u;
  output[14] = a14 + token * 15u;
  output[15] = a15 + token * 16u;
  output[16] = a16 + token * 17u;
  output[17] = a17 + token * 18u;
  output[18] = a18 + token * 19u;
  output[19] = a19 + token * 20u;
  output[20] = a20 + token * 21u;
  output[21] = a21 + token * 22u;
  output[22] = a22 + token * 23u;
  output[23] = a23 + token * 24u;
  output[24] = a24 + token * 25u;
  output[25] = a25 + token * 26u;
  output[26] = a26 + token * 27u;
  output[27] = a27 + token * 28u;
  output[28] = a28 + token * 29u;
  output[29] = a29 + token * 30u;
  output[30] = a30 + token * 31u;
  output[31] = a31 + token * 32u;
}
