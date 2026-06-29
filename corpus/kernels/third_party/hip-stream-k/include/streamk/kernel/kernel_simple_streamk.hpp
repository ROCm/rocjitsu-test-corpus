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

#define DOUBLE_BUFFER 1
#define CEIL_SUPPORT 0

/**
 * @brief This is a HIP Prototype for the Basic Stream-K Algorithm outlined in
 * Stream-K: Work-centric Parallel Decomposition for Dense Matrix-Matrix
 * Multiplication on the GPU by Osama et Al.
 *
 * @tparam input_t
 * @tparam output_t
 * @tparam compute_t
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
    simple_streamk_kernel(uint32_t m,
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
                          streamk_schedule_t<MACRO_TILE, compute_t> sk) {
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

  // Stream-K setup, figure out the iterations.
  sk.compute_sk_meta();

  // Stream-K's main-while loop.
  // As long as this CTA has work (iterations), keep consuming the work.
  while (sk.iter < sk.iter_end) {
    sk.compute_sk_iteration_data();
    sk.compute_sk_local_data();

    auto globalReadOffsetA = GRBuffAMap1d::fromMatrixCoord(
        make_coord2d(get<0>(macro_tile_coordinate<MACRO_TILE>(sk.tile, n)), 0u),
        lda);
    auto globalReadOffsetB = GRBuffBMap1d::fromMatrixCoord(
        make_coord2d(0u, get<1>(macro_tile_coordinate<MACRO_TILE>(sk.tile, n))),
        ldb);

#if DOUBLE_BUFFER
    // Perform initial global pre-fetch
    global_read_cooperative<WAVES::MNK, splitCountA>(
        grBuffA, a + globalReadOffsetA + sk.local_iter * WMMA::K * lda, lda,
        wave_idx);
    global_read_cooperative<WAVES::MNK, splitCountB>(
        grBuffB, b + globalReadOffsetB + sk.local_iter * WMMA::K * ldb, ldb,
        wave_idx);

    /// Write global prefetch to LDS
    local_write_cooperative<WAVES::MNK, splitCountA>(
        ldsPtrLo, applyDataLayout<DataLayoutLds>(grBuffA), WMMA::K, wave_idx);
    local_write_cooperative<WAVES::MNK, splitCountB>(
        ldsPtrLo + ldsWriteOffsetB,
        applyDataLayout<DataLayoutLds>(applyTranspose(grBuffB)), WMMA::K,
        wave_idx);

    // Synchronize, so all threads see the memory
    __syncthreads();
#endif

    // Reset the accumulator
    MfmaFragAcc fragsAcc[BLK::M][BLK::N];
    fill<BLK>(fragsAcc, 0.0f);

#if DOUBLE_BUFFER
    sk.local_iter_end -= 1;
#endif

    // Accumulate A * B for all mfma frags in warp tile
    // Run one less iteration and fix it up later.
    for (auto currentK = sk.local_iter; currentK < sk.local_iter_end;
         currentK++) {
#if !(DOUBLE_BUFFER)
      // Fetch from global memory
      global_read_cooperative<WAVES::MNK, splitCountA>(
          grBuffA, a + globalReadOffsetA + currentK * WMMA::K * lda, lda,
          wave_idx);
      global_read_cooperative<WAVES::MNK, splitCountB>(
          grBuffB, b + globalReadOffsetB + currentK * WMMA::K * ldb, ldb,
          wave_idx);

      // Write to LDS buffer
      local_write_cooperative<WAVES::MNK, splitCountA>(
          ldsPtrLo, applyDataLayout<DataLayoutLds>(grBuffA), WMMA::K, wave_idx);
      local_write_cooperative<WAVES::MNK, splitCountB>(
          ldsPtrLo + ldsWriteOffsetB,
          applyDataLayout<DataLayoutLds>(applyTranspose(grBuffB)), WMMA::K,
          wave_idx);

      // Synchronize, so all threads see the memory
      __syncthreads();
#endif

      MfmaFragA fragsA[BLK::M];
      MfmaFragB fragsB[BLK::N];

      // local Read frags from LDS Buffer
      local_read<false, BLK::M, WMMA::K, DataLayoutLds, DataLayoutA>(
          fragsA, ldsPtrLo + ldsReadOffsetA);
      local_read<true, BLK::N, WMMA::K, DataLayoutLds, DataLayoutB>(
          fragsB, ldsPtrLo + ldsReadOffsetB);

#if DOUBLE_BUFFER
      // Prefetch next round of global
      global_read_cooperative<WAVES::MNK, splitCountA>(
          grBuffA, a + globalReadOffsetA + (currentK + 1) * WMMA::K * lda, lda,
          wave_idx);
      global_read_cooperative<WAVES::MNK, splitCountB>(
          grBuffB, b + globalReadOffsetB + (currentK + 1) * WMMA::K * ldb, ldb,
          wave_idx);
#endif
      // accum(A * B)
      mfma<BLK, WMMA, input_t, compute_t, DataLayoutA, DataLayoutB>(
          fragsAcc, fragsA, fragsB, fragsAcc);

#if DOUBLE_BUFFER
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
      auto* tmp = ldsPtrLo;
      ldsPtrLo = ldsPtrHi;
      ldsPtrHi = tmp;
#endif
    }

#if DOUBLE_BUFFER
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
#endif

    // Fix-up condition.
    // If the current CTA did not "own" the tile (k_start =!= 0), it writes the
    // partials to a temporary buffer, and allows the owning-CTA perform the
    // reduction/fixup and write results to memory.
    if (sk.iter != sk.tile_iter) {
      store_partials<BLK, MACRO_TILE, WMMA, WAVE_SIZE, WAVE_TILE, compute_t>(
          sk.partials, blockIdx.x, fragsAcc);
      // Block-wide sync so every wave's partials writes are issued before
      // lane 0 publishes the flag.  `unlock` is a release-ordered atomic
      // store, which makes those writes visible at L2 to any CU that later
      // observes the flag with an acquire load (wait_for_unlock).
      __syncthreads();
      unlock(sk.flags + blockIdx.x);
    } else {
      // If fix-up is required, i.e. iteration end =!= tile's iteration end.
      // Then wait for the partials to become available and then accumulate in
      // current accumulators.
      if (sk.iter_end < sk.tile_iter_end) {
        // NOTE: use sk.iter_end (the actual per-CTA stopping point) rather
        // than sk.local_iter_end here, because DOUBLE_BUFFER decremented
        // local_iter_end above.  Using the decremented value caused this
        // owner to spin on partials from CTAs that were never actually
        // assigned as helpers, deadlocking the grid.
        for (uint32_t end = sk.iter_end, ctaNext = blockIdx.x + 1;
             (end < sk.tile_iter_end) && (ctaNext < gridDim.x);
             end += sk.iters_per_cta, ctaNext++) {
          wait_for_unlock(sk.flags + ctaNext);
          fixup_partials<BLK, MACRO_TILE, WMMA, WAVE_SIZE, WAVE_TILE,
                         compute_t>(sk.partials, ctaNext, fragsAcc);
        }
      }

      auto waveTileCoord = macro_tile_coordinate<MACRO_TILE>(sk.tile, n) +
                           local_wave_offset<WAVE_SIZE, WAVE_TILE>();

      MfmaFragD fragsD[BLK::M][BLK::N];

#if USE_BETA
      MfmaFragC fragsC[BLK::M][BLK::N];

      // Read global C into C's fragment
      global_read<BLK>(fragsC,
                       c + Mapper1dC::fromMatrixCoord(waveTileCoord, ldc), ldc);

      /// D = alpha * accum + beta * C
      fma<BLK, WMMA, output_t, compute_t, DataLayoutC, DataLayoutC>(
          fragsD, alpha, fragsAcc, beta, fragsC);
#else
      fma<BLK, WMMA, output_t, compute_t, DataLayoutC>(fragsD, alpha, fragsAcc);
#endif

      // Write MFMA_D to global memory
      global_write<BLK>(d + Mapper1dD::fromMatrixCoord(waveTileCoord, ldd),
                        fragsD, ldd);
    }
    sk.iter = sk.tile_iter_end;
  }
}

}  // namespace streamk