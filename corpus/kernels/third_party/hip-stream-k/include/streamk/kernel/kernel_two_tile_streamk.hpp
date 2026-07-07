/**
 * @copyright Copyright 2023 Advanced Micro Devices, Inc.
 */

#pragma once

#include <algorithm>

#include <hip/hip_ext.h>
#include <hip/hip_fp16.h>
#include <hip/hip_runtime.h>

#include <streamk/device/device_fma.hpp>
#include <streamk/device/device_read_write.hpp>
#include <streamk/device/device_locks.hpp>
#include <streamk/device/device_partials.hpp>
#include <streamk/device/device_common.hpp>
#include <streamk/device/device_fill.hpp>
#include <streamk/utils/mfma.hpp>

namespace streamk {

/**
 * @brief This is a HIP Prototype for the 2-Tiles Stream-K + DP Algorithm
 * outlined in Stream-K: Work-centric Parallel Decomposition for Dense
 * Matrix-Matrix Multiplication on the GPU by Osama et Al.
 */
template <uint32_t WAVE_SIZE,
          uint32_t NUM_THREADS,
          typename MACRO_TILE,
          typename WMMA,
          typename WAVE_TILE,
          typename WAVES,
          typename BLK,
          typename input_t,
          typename output_t,
          typename compute_t>
__global__ void __launch_bounds__(NUM_THREADS)
    two_tile_streamk_kernel(uint32_t m,
                            uint32_t n,
                            uint32_t k,
                            input_t const* a,
                            input_t const* b,
                            output_t const* c,
                            output_t* d,
                            uint32_t lda,
                            uint32_t ldb,
                            uint32_t ldc,
                            uint32_t ldd,
                            compute_t alpha,
                            compute_t beta,
                            int* flags,
                            compute_t* partials) {
  // TODO: Move this to arguments.
  using DataLayoutA = col_major;
  using DataLayoutB = row_major;
  using DataLayoutC = col_major;
  using DataLayoutLds = row_major;

  // Calculate the wave index.
  const int wave_idx = wave_index<WAVE_SIZE, WAVES::N>();

  // MFMA Fragments for A, B, C, D and accumulator.
  using MfmaFragA =
      fragment<matrix_a, WMMA::M, WMMA::N, WMMA::K, input_t, DataLayoutA>;
  using MfmaFragB =
      fragment<matrix_b, WMMA::M, WMMA::N, WMMA::K, input_t, DataLayoutB>;
  using MfmaFragC =
      fragment<accumulator, WMMA::M, WMMA::N, WMMA::K, output_t, DataLayoutC>;
  using MfmaFragD = MfmaFragC;
  using MfmaFragAcc =
      fragment<accumulator, WMMA::M, WMMA::N, WMMA::K, compute_t>;

  // Global read (MacroTile)
  using GRBuffA =
      fragment<matrix_a, MACRO_TILE::M, WMMA::N, WMMA::K, input_t, DataLayoutA>;
  using GRBuffB =
      fragment<matrix_b, WMMA::M, MACRO_TILE::N, WMMA::K, input_t, DataLayoutB>;

  // Local write of global buffers (macro tile)
  // - Must match Lds data layout.
  // - Lds has transposed B frags.
  using LWBuffA = ApplyDataLayout_t<GRBuffA, DataLayoutLds>;
  using LWBuffB = ApplyDataLayout_t<ApplyTranspose_t<GRBuffB>, DataLayoutLds>;

  // Local read (mfma frags)
  // - Must match Lds data layout.
  // - Lds has transposed B frags.
  using LRFragA = ApplyDataLayout_t<MfmaFragA, DataLayoutLds>;
  using LRFragB = ApplyDataLayout_t<ApplyTranspose_t<MfmaFragB>, DataLayoutLds>;

  // 1D global read coordinate setup
  using GRBuffAMap1d = GetDataLayout_t<GRBuffA>;
  using GRBuffBMap1d = GetDataLayout_t<GRBuffB>;

  /// Setup LDS addressing
  /// This kernel will use 2 separate LDS blocks for pipelining
  /// the input prefetching during the accumulation loop
  using LWBuffAShape = GetIOShape_t<LWBuffA>;
  using LWBuffBShape = GetIOShape_t<LWBuffB>;
  using LWBuffAMap1d = GetDataLayout_t<LWBuffA>;
  using LWBuffBMap1d = GetDataLayout_t<LWBuffB>;

  // 1D for C-reads and D-writes
  using Mapper1dC = GetDataLayout_t<MfmaFragC>;
  using Mapper1dD = GetDataLayout_t<MfmaFragD>;

  GRBuffA grBuffA;
  GRBuffB grBuffB;

  constexpr auto splitCountA =
      std::min(static_cast<uint32_t>(GetIOTraits_t<GRBuffA>::IOCount),
               static_cast<uint32_t>(GetIOTraits_t<LWBuffA>::IOCount));
  constexpr auto splitCountB =
      std::min(static_cast<uint32_t>(GetIOTraits_t<GRBuffB>::IOCount),
               static_cast<uint32_t>(GetIOTraits_t<LWBuffB>::IOCount));

  // Setup LDS Buffers.
  __shared__ input_t localMemHi[(MACRO_TILE::M + MACRO_TILE::N) * WMMA::K];
  __shared__ input_t localMemLo[(MACRO_TILE::M + MACRO_TILE::N) * WMMA::K];

  auto* ldsPtrLo = reinterpret_cast<input_t*>(localMemHi);
  auto* ldsPtrHi = reinterpret_cast<input_t*>(localMemLo);

  auto ldsWriteOffsetB = LWBuffAMap1d::fromMatrixCoord(
      make_coord2d(LWBuffAShape::BlockHeight, 0u), WMMA::K);
  auto ldsReadOffsetA = LWBuffAMap1d::fromMatrixCoord(
      make_coord2d(threadIdx.x / WAVE_SIZE * WAVE_TILE::M, 0u),
      WMMA::K);  // LDSWRITE OFFSET is 0
  auto ldsReadOffsetB =
      ldsWriteOffsetB +
      LWBuffBMap1d::fromMatrixCoord(
          make_coord2d(threadIdx.y * WAVE_TILE::N, 0u), WMMA::K);

  // Check if there's enough work for Data-Parallel + Stream-K.
  uint32_t numOutputTiles = number_of_output_tiles<MACRO_TILE>(m, n);
  bool bigEnough = numOutputTiles > gridDim.x;
  uint32_t numSK =
      bigEnough ? gridDim.x + numOutputTiles % gridDim.x : numOutputTiles;
  uint32_t dpTilesPerCTA =
      bigEnough ? (numOutputTiles - numSK) / gridDim.x : 0u;
  int gridSize = gridDim.x;

  // SK Tiles are distributed by 0 -> numSK - 1 over the CTAs
  // DP Tile numbers will start at numSK and go to numSk + dpTilesPerCTA -1 for
  // CTA 0. numSk + dpTilesPerCTA -> numSk + 2 * dpTilesPerCTA -1 for CTA 1,
  // etc.
  int dpShift = numSK + blockIdx.x * dpTilesPerCTA;
  int skItersPerCTA = numSK * iterations_per_tile<WMMA::K>(k) / (gridDim.x);
  int iter = blockIdx.x * skItersPerCTA;

  int iterEnd = iter + skItersPerCTA;

  {
    int extraIters = numSK * iterations_per_tile<WMMA::K>(k) % (gridDim.x);
    if (extraIters != 0) {
      if (blockIdx.x < extraIters) {
        iter = blockIdx.x * (skItersPerCTA + 1);
        iterEnd = iter + skItersPerCTA + 1;
      } else {
        iter = blockIdx.x * skItersPerCTA + extraIters;
        iterEnd = iter + skItersPerCTA;
      }
    }
  }

  // Stream-K's main-while loop.
  // As long as this CTA has work (iterations), keep consuming the work.
  while (iter < iterEnd) {
    int itersPerTile = iterations_per_tile<WMMA::K>(k);
    int tileId = iter / itersPerTile;
    int tileIter = tileId * itersPerTile;
    int tileIterEnd = tileIter + itersPerTile;

    // Perform the range of MAC iterations for this tile.
    int localIter = iter - tileIter;
    int localIterEnd = min(iterEnd, tileIterEnd) - tileIter;

    auto globalReadOffsetA = GRBuffAMap1d::fromMatrixCoord(
        make_coord2d(get<0>(macro_tile_coordinate<MACRO_TILE>(tileId, n)), 0u),
        lda);
    auto globalReadOffsetB = GRBuffBMap1d::fromMatrixCoord(
        make_coord2d(0u, get<1>(macro_tile_coordinate<MACRO_TILE>(tileId, n))),
        ldb);

    // Perform initial global pre-fetch
    global_read_cooperative<WAVES::MNK, splitCountA>(
        grBuffA, a + globalReadOffsetA + localIter * WMMA::K * lda, lda,
        wave_idx);
    global_read_cooperative<WAVES::MNK, splitCountB>(
        grBuffB, b + globalReadOffsetB + localIter * WMMA::K * ldb, ldb,
        wave_idx);

    /// Write global prefetch to LDS
    local_write_cooperative<WAVES::MNK, splitCountA>(
        ldsPtrLo, applyDataLayout<DataLayoutLds>(grBuffA), WMMA::K, wave_idx);
    local_write_cooperative<WAVES::MNK, splitCountB>(
        ldsPtrLo + ldsWriteOffsetB,
        applyDataLayout<DataLayoutLds>(applyTranspose(grBuffB)), WMMA::K,
        wave_idx);

    // Reset the accumulator
    MfmaFragAcc fragsAcc[BLK::M][BLK::N];
    fill<BLK>(fragsAcc, 0.0f);

    // Synchronize, so all threads see the memory
    __syncthreads();

    for (auto currentK = localIter; currentK < localIterEnd - 1; currentK++) {
      MfmaFragA fragsA[BLK::M];
      MfmaFragB fragsB[BLK::N];

      // local Read frags from first LDS Buffer
      local_read<false, BLK::M, WMMA::K, DataLayoutLds, DataLayoutA>(
          fragsA, ldsPtrLo + ldsReadOffsetA);
      local_read<true, BLK::N, WMMA::K, DataLayoutLds, DataLayoutB>(
          fragsB, ldsPtrLo + ldsReadOffsetB);

      // Prefetch next round of global
      global_read_cooperative<WAVES::MNK, splitCountA>(
          grBuffA, a + globalReadOffsetA + (currentK + 1) * WMMA::K * lda, lda,
          wave_idx);
      global_read_cooperative<WAVES::MNK, splitCountB>(
          grBuffB, b + globalReadOffsetB + (currentK + 1) * WMMA::K * ldb, ldb,
          wave_idx);

      // accum(A * B)
      mfma<BLK, WMMA, input_t, compute_t, DataLayoutA, DataLayoutB>(
          fragsAcc, fragsA, fragsB, fragsAcc);

      // Write prefetch to second LDS buffer
      local_write_cooperative<WAVES::MNK, splitCountA>(
          ldsPtrHi, applyDataLayout<DataLayoutLds>(grBuffA), WMMA::K, wave_idx);
      local_write_cooperative<WAVES::MNK, splitCountB>(
          ldsPtrHi + ldsWriteOffsetB,
          applyDataLayout<DataLayoutLds>(applyTranspose(grBuffB)), WMMA::K,
          wave_idx);

      // Make sure that all waves have finished reading / writing to lds.
      __syncthreads();

      // Swap LDS buffers!
      //std::swap(ldsPtrLo, ldsPtrHi);
      auto* temp = ldsPtrLo;
      ldsPtrLo = ldsPtrHi;
      ldsPtrHi = temp;
    }

    // Last MFMA-iteration (due to double-buffering).
    MfmaFragA fragsA[BLK::M];
    MfmaFragB fragsB[BLK::N];

    //  Local read mfma frags
    local_read<false, BLK::M, WMMA::K, DataLayoutLds, DataLayoutA>(
        fragsA, ldsPtrLo + ldsReadOffsetA);
    local_read<true, BLK::N, WMMA::K, DataLayoutLds, DataLayoutB>(
        fragsB, ldsPtrLo + ldsReadOffsetB);

    // accum(A * B)
    mfma<BLK, WMMA, input_t, compute_t, DataLayoutA, DataLayoutB>(
        fragsAcc, fragsA, fragsB, fragsAcc);

    // Fix-up condition.
    // If the current CTA did not "own" the tile (k_start =!= 0), it writes the
    // partials to a temporary buffer, and allows the owning-CTA perform the
    // reduction/fixup and write results to memory.
    if (iter != tileIter) {
      store_partials<BLK, MACRO_TILE, WMMA, WAVE_SIZE, WAVE_TILE, compute_t>(
          partials, blockIdx.x, fragsAcc);
      // Block-wide sync so all waves finish before lane 0 publishes the
      // flag; `unlock` is a release-ordered atomic store that pairs with
      // the acquire load in wait_for_unlock for cross-CU visibility.
      __syncthreads();
      unlock(flags + blockIdx.x);
    } else {
      // If fix-up is required, i.e. iteration end =!= tile's iteration end.
      // Then wait for the partials to become available and then accumulate in
      // current accumulators.
      if (iterEnd < tileIterEnd) {
        // Use iterEnd directly (the actual per-CTA stopping point);
        // computing `tileIter + localIterEnd` is equivalent in the absence
        // of double-buffer decrements but iterEnd is robust against any
        // future adjustments to localIterEnd.
        for (uint32_t end = iterEnd, ctaNext = blockIdx.x + 1;
             (end < tileIterEnd) && (ctaNext < gridDim.x);
             end += iterations_per_cta<MACRO_TILE>(m, n, k, ctaNext),
                      ctaNext++) {
          wait_for_unlock(flags + ctaNext);
          fixup_partials<BLK, MACRO_TILE, WMMA, WAVE_SIZE, WAVE_TILE,
                         compute_t>(partials, ctaNext, fragsAcc);
        }
      }

      auto waveTileCoord = macro_tile_coordinate<MACRO_TILE>(tileId, n) +
                           local_wave_offset<WAVE_SIZE, WAVE_TILE>();

      MfmaFragD fragsD[BLK::M][BLK::N];

#if USE_BETA
      // Stream-K section reads C from global so the alpha*acc + beta*C
      // path is well-defined.  Without this, an uninitialised fragsC was
      // multiplied by beta and could yield NaN even when beta == 0.
      MfmaFragC fragsC[BLK::M][BLK::N];
      global_read<BLK>(fragsC,
                       c + Mapper1dC::fromMatrixCoord(waveTileCoord, ldc), ldc);
      fma<BLK, WMMA, output_t, compute_t, DataLayoutC, DataLayoutC>(
          fragsD, alpha, fragsAcc, beta, fragsC);
#else
      fma<BLK, WMMA, output_t, compute_t, DataLayoutC>(fragsD, alpha, fragsAcc);
#endif

      // Write MFMA_D to global memory
      global_write<BLK>(d + Mapper1dD::fromMatrixCoord(waveTileCoord, ldd),
                        fragsD, ldd);
    }
    iter = tileIterEnd;
  }

  // Incremental global read address offsets
  auto kStepOffsetA =
      GRBuffAMap1d::fromMatrixCoord(make_coord2d(0u, WMMA::K), lda);
  auto kStepOffsetB =
      GRBuffBMap1d::fromMatrixCoord(make_coord2d(WMMA::K, 0u), ldb);

  // Data Parallel Section
  for (int tileId = dpShift; tileId < dpShift + dpTilesPerCTA; tileId++) {
    auto globalReadOffsetA = GRBuffAMap1d::fromMatrixCoord(
        make_coord2d(get<0>(macro_tile_coordinate<MACRO_TILE>(tileId, n)), 0u),
        lda);
    auto globalReadOffsetB = GRBuffBMap1d::fromMatrixCoord(
        make_coord2d(0u, get<1>(macro_tile_coordinate<MACRO_TILE>(tileId, n))),
        ldb);

    // Initial read of global memory
    global_read_cooperative<WAVES::MNK, splitCountA>(
        grBuffA, a + globalReadOffsetA, lda, wave_idx);
    global_read_cooperative<WAVES::MNK, splitCountB>(
        grBuffB, b + globalReadOffsetB, ldb, wave_idx);

    globalReadOffsetA += kStepOffsetA;
    globalReadOffsetB += kStepOffsetB;

    /// Write global prefetch to LDS
    /// Write global prefetch to LDS
    local_write_cooperative<WAVES::MNK, splitCountA>(
        ldsPtrLo, applyDataLayout<DataLayoutLds>(grBuffA), WMMA::K, wave_idx);
    local_write_cooperative<WAVES::MNK, splitCountB>(
        ldsPtrLo + ldsWriteOffsetB,
        applyDataLayout<DataLayoutLds>(applyTranspose(grBuffB)), WMMA::K,
        wave_idx);

    // Reset the accumulator
    MfmaFragAcc fragsAcc[BLK::M][BLK::N];
    fill<BLK>(fragsAcc, 0.0f);

    // Synchronize, so all threads see the memory
    __syncthreads();

    for (auto currentK = WMMA::K; currentK < k; currentK += WMMA::K) {
      MfmaFragA fragsA[BLK::M];
      MfmaFragB fragsB[BLK::N];

      // local Read frags from first LDS Buffer
      local_read<false, BLK::M, WMMA::K, DataLayoutLds, DataLayoutA>(
          fragsA, ldsPtrLo + ldsReadOffsetA);
      local_read<true, BLK::N, WMMA::K, DataLayoutLds, DataLayoutB>(
          fragsB, ldsPtrLo + ldsReadOffsetB);

      // Prefetch next round of global
      global_read_cooperative<WAVES::MNK, splitCountA>(
          grBuffA, a + globalReadOffsetA, lda, wave_idx);
      global_read_cooperative<WAVES::MNK, splitCountB>(
          grBuffB, b + globalReadOffsetB, ldb, wave_idx);

      globalReadOffsetA += kStepOffsetA;
      globalReadOffsetB += kStepOffsetB;

      // accum(A * B)
      mfma<BLK, WMMA, input_t, compute_t, DataLayoutA, DataLayoutB>(
          fragsAcc, fragsA, fragsB, fragsAcc);

      // Write prefetch to second LDS buffer
      local_write_cooperative<WAVES::MNK, splitCountA>(
          ldsPtrHi, applyDataLayout<DataLayoutLds>(grBuffA), WMMA::K, wave_idx);
      local_write_cooperative<WAVES::MNK, splitCountB>(
          ldsPtrHi + ldsWriteOffsetB,
          applyDataLayout<DataLayoutLds>(applyTranspose(grBuffB)), WMMA::K,
          wave_idx);

      // Make sure that all waves have finished reading / writing to lds.
      __syncthreads();

      // Swap LDS buffers!
      //std::swap(ldsPtrLo, ldsPtrHi);
      auto* temp = ldsPtrLo;
      ldsPtrLo = ldsPtrHi;
      ldsPtrHi = temp;
    }

    // Last MFMA-iteration (due to double-buffering).
    MfmaFragA fragsA[BLK::M];
    MfmaFragB fragsB[BLK::N];

    //  Local read mfma frags
    local_read<false, BLK::M, WMMA::K, DataLayoutLds, DataLayoutA>(
        fragsA, ldsPtrLo + ldsReadOffsetA);
    local_read<true, BLK::N, WMMA::K, DataLayoutLds, DataLayoutB>(
        fragsB, ldsPtrLo + ldsReadOffsetB);

    // accum(A * B)
    mfma<BLK, WMMA, input_t, compute_t, DataLayoutA, DataLayoutB>(
        fragsAcc, fragsA, fragsB, fragsAcc);

    auto waveTileCoord = macro_tile_coordinate<MACRO_TILE>(tileId, n) +
                         local_wave_offset<WAVE_SIZE, WAVE_TILE>();
    MfmaFragC fragsC[BLK::M][BLK::N];
    MfmaFragD fragsD[BLK::M][BLK::N];

    // Read global C into C's fragment
    global_read<BLK>(fragsC, c + Mapper1dC::fromMatrixCoord(waveTileCoord, ldc),
                     ldc);

    /// D = alpha * accum + beta * C
    fma<BLK, WMMA, output_t, compute_t, DataLayoutC, DataLayoutC>(
        fragsD, alpha, fragsAcc, beta, fragsC);

    // Write MFMA_D to global memory
    global_write<BLK>(d + Mapper1dD::fromMatrixCoord(waveTileCoord, ldd),
                      fragsD, ldd);
  }
}
}  // namespace streamk