// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT

#include "race_test_support.hpp"

#include <cstdint>
#include <vector>

namespace {

using Gfx1250RaceTest = rocjitsu::test::RaceTestBase;
using rocjitsu::test::FindingCount;
using rocjitsu::test::RaceExpectation;
constexpr int kWave = 32;
constexpr int kTileBytes = kWave * sizeof(int);

// CDNA5 ISA (27 July 2026), 5.6: named counts count signals, while JOIN
// selects one notification channel. Builtins allocate the barrier objects in
// the kernel descriptor. Explicit asm keeps memory completion waits visible.
__device__ int wave() { return __builtin_amdgcn_readfirstlane(threadIdx.x) / kWave; }
__device__ int lane() { return threadIdx.x % kWave; }
__device__ uint32_t slot(int tile = 0) { return tile * kTileBytes + lane() * sizeof(int); }
__device__ void drain() { asm volatile("s_wait_dscnt 0" ::: "memory"); }
__device__ void workgroup() {
  asm volatile("s_barrier_signal -1\ns_barrier_wait -1" ::: "memory");
}
// Every positive operand waits on the currently joined named barrier (5.6.3).
__device__ void namedWait() { asm volatile("s_barrier_wait 1" ::: "memory"); }
__device__ void writeLds(uint32_t address, int value) {
  asm volatile("ds_store_b32 %0, %1" ::"v"(address), "v"(value) : "memory");
}
__device__ int readLds(uint32_t address) {
  int value;
  asm volatile("ds_load_b32 %0, %1\ns_wait_dscnt 0" : "=v"(value) : "v"(address) : "memory");
  return value;
}

std::vector<int> values(int first, int count = kWave) {
  std::vector<int> result(count);
  for (int i = 0; i < count; ++i)
    result[i] = first + i;
  return result;
}

constexpr RaceExpectation kReadConflict{
    .findings = FindingCount::One,
    .type = "LDS",
    .access = "read",
    .producer = "ds_store_b32",
    .consumer = "ds_load_b32",
};
constexpr RaceExpectation kWriteConflict{
    .findings = FindingCount::One,
    .type = "LDS",
    .access = "write",
    .producer = "ds_load_b32",
    .consumer = "ds_store_b32",
};

enum class Chain { Ordered, LateDrain, EarlyRelay, EarlyReader };

// A -> B -> C: B waits for A on ab, then signals bc; C reads A's tile.
// Neither A nor B needs to join the barrier it signals. The only workgroup
// rendezvous are before the write and after the read, so neither orders them.
template <Chain Mode>
__global__ __attribute__((amdgpu_flat_work_group_size(96, 96))) void
named_chain_kernel(int *out) {
  __shared__ __amdgpu_named_workgroup_barrier_t ab, bc;
  if (wave() == 0) {
    __builtin_amdgcn_s_barrier_init(&ab, 1);
    __builtin_amdgcn_s_barrier_init(&bc, 1);
  } else if (wave() == 1) {
    __builtin_amdgcn_s_barrier_join(&ab);
  } else {
    __builtin_amdgcn_s_barrier_join(&bc);
  }
  workgroup();
  if (wave() == 0) {
    writeLds(slot(), 100 + blockIdx.x * kWave + lane());
    if constexpr (Mode != Chain::LateDrain)
      drain();
    __builtin_amdgcn_s_barrier_signal_var(&ab, 0);
    if constexpr (Mode == Chain::LateDrain)
      drain();
  } else if (wave() == 1) {
    if constexpr (Mode == Chain::EarlyRelay)
      __builtin_amdgcn_s_barrier_signal_var(&bc, 0);
    namedWait();
    if constexpr (Mode != Chain::EarlyRelay)
      __builtin_amdgcn_s_barrier_signal_var(&bc, 0);
  } else {
    if constexpr (Mode != Chain::EarlyReader)
      namedWait();
    out[blockIdx.x * kWave + lane()] = readLds(slot());
    if constexpr (Mode == Chain::EarlyReader)
      namedWait();
  }
  workgroup();
}

TEST_F(Gfx1250RaceTest, named_chain) {
  int *out = allocFilled<int>(kWave, -7);
  named_chain_kernel<Chain::Ordered><<<1, 96, kTileBytes>>>(out);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectNoRace();
  ExpectValues(out, values(100));
}

TEST_F(Gfx1250RaceTest, named_chain_multiple_workgroups) {
  int *out = allocFilled<int>(8 * kWave, -7);
  named_chain_kernel<Chain::Ordered><<<8, 96, kTileBytes>>>(out);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectNoRace();
  ExpectValues(out, values(100, 8 * kWave));
}

TEST_F(Gfx1250RaceTest, named_chain_late_drain_race) {
  named_chain_kernel<Chain::LateDrain><<<1, 96, kTileBytes>>>(alloc<int>(kWave));
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectRace(kReadConflict);
}

TEST_F(Gfx1250RaceTest, named_chain_early_relay_race) {
  named_chain_kernel<Chain::EarlyRelay><<<1, 96, kTileBytes>>>(alloc<int>(kWave));
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectAnyRace({kReadConflict, kWriteConflict});
}

TEST_F(Gfx1250RaceTest, named_chain_early_reader_race) {
  named_chain_kernel<Chain::EarlyReader><<<1, 96, kTileBytes>>>(alloc<int>(kWave));
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectAnyRace({kReadConflict, kWriteConflict});
}

// C waits on its own unrelated barrier. Acquiring A's write in B must not
// remove that write from the history C still needs to check.
__global__ __attribute__((amdgpu_flat_work_group_size(96, 96))) void
named_outsider_kernel(int *out) {
  __shared__ __amdgpu_named_workgroup_barrier_t ab, unrelated;
  if (wave() == 0) {
    __builtin_amdgcn_s_barrier_init(&ab, 1);
    __builtin_amdgcn_s_barrier_init(&unrelated, 1);
  } else if (wave() == 1) {
    __builtin_amdgcn_s_barrier_join(&ab);
  } else {
    __builtin_amdgcn_s_barrier_join(&unrelated);
  }
  workgroup();
  if (wave() == 0) {
    writeLds(slot(), 100 + lane());
    drain();
    __builtin_amdgcn_s_barrier_signal_var(&ab, 0);
  } else if (wave() == 1) {
    namedWait();
    out[lane()] = readLds(slot());
  } else {
    __builtin_amdgcn_s_barrier_signal_var(&unrelated, 0);
    namedWait();
    out[kWave + lane()] = readLds(slot());
  }
  workgroup();
}

TEST_F(Gfx1250RaceTest, named_outsider_race) {
  int *out = allocFilled<int>(2 * kWave, -7);
  named_outsider_kernel<<<1, 96, kTileBytes>>>(out);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectAnyRace({kReadConflict, kWriteConflict});
  ExpectValues(out, values(100));
}

// One producer supplies two signals. Threshold two covers both writes even
// though only one wave signals; threshold one permits the second read too early.
template <int Count>
__global__ __attribute__((amdgpu_flat_work_group_size(64, 64))) void
named_two_signals_kernel(int *out) {
  __shared__ __amdgpu_named_workgroup_barrier_t ready;
  if (wave() == 0)
    __builtin_amdgcn_s_barrier_init(&ready, Count);
  else
    __builtin_amdgcn_s_barrier_join(&ready);
  workgroup();
  if (wave() == 0) {
    writeLds(slot(), 100 + lane());
    drain();
    __builtin_amdgcn_s_barrier_signal_var(&ready, 0);
    writeLds(slot(1), 200 + lane());
    drain();
    __builtin_amdgcn_s_barrier_signal_var(&ready, 0);
  } else {
    namedWait();
    out[lane()] = readLds(slot());
    out[kWave + lane()] = readLds(slot(1));
  }
  workgroup();
}

TEST_F(Gfx1250RaceTest, named_two_signals_one_producer) {
  int *out = allocFilled<int>(2 * kWave, -7);
  named_two_signals_kernel<2><<<1, 64, 2 * kTileBytes>>>(out);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectNoRace();
  ExpectValues(out, values(100));
  ExpectValues(out + kWave, values(200));
}

TEST_F(Gfx1250RaceTest, named_threshold_one_race) {
  int *out = allocFilled<int>(2 * kWave, -7);
  named_two_signals_kernel<1><<<1, 64, 2 * kTileBytes>>>(out);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectAnyRace({kReadConflict, kWriteConflict});
  ExpectValues(out, values(100));
}

// A signal and B's LEAVE together complete threshold two, in either order.
// With WriterLeaves, the write is completed before the necessary LEAVE;
// otherwise it is completed before the necessary signal. Both precede C's read.
template <bool WriterLeaves>
__global__ __attribute__((amdgpu_flat_work_group_size(96, 96))) void
named_leave_kernel(int *out) {
  __shared__ __amdgpu_named_workgroup_barrier_t ready;
  if (wave() == 0)
    __builtin_amdgcn_s_barrier_init(&ready, 2);
  __builtin_amdgcn_s_barrier_join(&ready);
  workgroup();
  if (wave() == (WriterLeaves ? 1 : 0)) {
    writeLds(slot(), 100 + lane());
    drain();
  }
  if (wave() == 0) {
    __builtin_amdgcn_s_barrier_signal_var(&ready, 0);
  } else if (wave() == 1) {
    asm volatile("s_barrier_leave\ns_wait_kmcnt 0" ::: "scc", "memory");
  } else {
    namedWait();
    out[lane()] = readLds(slot());
  }
  workgroup();
}

TEST_F(Gfx1250RaceTest, named_leave_completes_round) {
  int *out = allocFilled<int>(kWave, -7);
  named_leave_kernel<false><<<1, 96, kTileBytes>>>(out);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectNoRace();
  ExpectValues(out, values(100));
}

// JOIN clears an old completion bit, even when rejoining the same barrier.
// A waits at the second setup rendezvous until B has changed its membership;
// A's subsequent write must be covered by a fresh named completion.
template <int JoinMode>
__global__ __attribute__((amdgpu_flat_work_group_size(64, 64))) void
named_rejoin_kernel(int *out) {
  __shared__ __amdgpu_named_workgroup_barrier_t old, next;
  if (wave() == 0) {
    __builtin_amdgcn_s_barrier_init(&old, 1);
    __builtin_amdgcn_s_barrier_init(&next, 1);
  } else {
    __builtin_amdgcn_s_barrier_join(&old);
  }
  workgroup();
  if (wave() == 1) {
    __builtin_amdgcn_s_barrier_signal_var(&old, 0);
    if constexpr (JoinMode == 2)
      asm volatile("s_barrier_join 0" ::: "memory");
    if constexpr (JoinMode == 1)
      __builtin_amdgcn_s_barrier_join(&next);
    else
      __builtin_amdgcn_s_barrier_join(&old);
  }
  workgroup();
  if (wave() == 0) {
    writeLds(slot(), 100 + lane());
    drain();
    if constexpr (JoinMode == 1)
      __builtin_amdgcn_s_barrier_signal_var(&next, 0);
    else
      __builtin_amdgcn_s_barrier_signal_var(&old, 0);
  } else {
    namedWait();
    out[lane()] = readLds(slot());
  }
  workgroup();
}

TEST_F(Gfx1250RaceTest, named_rejoin_same_barrier) {
  int *out = allocFilled<int>(kWave, -7);
  named_rejoin_kernel<0><<<1, 64, kTileBytes>>>(out);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectNoRace();
  ExpectValues(out, values(100));
}

TEST_F(Gfx1250RaceTest, named_switch_joined_barrier) {
  int *out = allocFilled<int>(kWave, -7);
  named_rejoin_kernel<1><<<1, 64, kTileBytes>>>(out);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectNoRace();
  ExpectValues(out, values(100));
}

TEST_F(Gfx1250RaceTest, named_join_null_then_rejoin) {
  int *out = allocFilled<int>(kWave, -7);
  named_rejoin_kernel<2><<<1, 64, kTileBytes>>>(out);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectNoRace();
  ExpectValues(out, values(100));
}

// B sets its own ready bit before letting A write. An unconsumed old bit
// cannot prove A's later write is complete, even if a newer round also completes.
template <bool ConsumeOld, bool Reset = false>
__global__ __attribute__((amdgpu_flat_work_group_size(64, 64))) void
named_old_completion_kernel(int *out) {
  __shared__ __amdgpu_named_workgroup_barrier_t ready, go;
  if (wave() == 0) {
    __builtin_amdgcn_s_barrier_init(&ready, 1);
    __builtin_amdgcn_s_barrier_init(&go, 1);
    __builtin_amdgcn_s_barrier_join(&go);
  } else {
    __builtin_amdgcn_s_barrier_join(&ready);
  }
  workgroup();
  if (wave() == 0) {
    namedWait();
    writeLds(slot(), 100 + lane());
    drain();
    __builtin_amdgcn_s_barrier_signal_var(&ready, 0);
  } else {
    __builtin_amdgcn_s_barrier_signal_var(&ready, 0);
    if constexpr (ConsumeOld)
      namedWait();
    // INIT resets barrier counters, not a wave's pending completion bit.
    if constexpr (Reset)
      __builtin_amdgcn_s_barrier_init(&ready, 1);
    __builtin_amdgcn_s_barrier_signal_var(&go, 0);
    // Let A progress while B's old bit remains set. NOPs establish no
    // cross-wave ordering; only consuming a fresh completion makes this safe.
    asm volatile(".rept 32\ns_nop 0\n.endr" ::: "memory");
    namedWait();
    out[lane()] = readLds(slot());
  }
  workgroup();
}

TEST_F(Gfx1250RaceTest, named_old_completion_consumed) {
  int *out = allocFilled<int>(kWave, -7);
  named_old_completion_kernel<true><<<1, 64, kTileBytes>>>(out);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectNoRace();
  ExpectValues(out, values(100));
}

TEST_F(Gfx1250RaceTest, named_old_completion_race) {
  named_old_completion_kernel<false><<<1, 64, kTileBytes>>>(alloc<int>(kWave));
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectAnyRace({kReadConflict, kWriteConflict});
}

TEST_F(Gfx1250RaceTest, named_init_preserves_pending_completion_race) {
  named_old_completion_kernel<false, true><<<1, 64, kTileBytes>>>(alloc<int>(kWave));
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectAnyRace({kReadConflict, kWriteConflict});
}

// INIT discards the first arrival. SIGNAL with a nonzero count changes the
// threshold without discarding arrivals (5.6.3). Inspect the intermediate
// counter on the signalling wave, so the observation adds no cross-wave ordering.
template <bool Reset>
__global__ __attribute__((amdgpu_flat_work_group_size(64, 64))) void
named_count_change_kernel(int *out, int *counts) {
  __shared__ __amdgpu_named_workgroup_barrier_t ready;
  if (wave() == 0)
    __builtin_amdgcn_s_barrier_init(&ready, Reset ? 2 : 3);
  else
    __builtin_amdgcn_s_barrier_join(&ready);
  workgroup();
  if (wave() == 0) {
    __builtin_amdgcn_s_barrier_signal_var(&ready, 0);
    if constexpr (Reset)
      __builtin_amdgcn_s_barrier_init(&ready, 2);
    writeLds(slot(), 100 + lane());
    drain();
    if constexpr (Reset) {
      __builtin_amdgcn_s_barrier_signal_var(&ready, 0);
      // This kernel allocates only ready, hence its named barrier ID is 1.
      uint32_t state;
      asm volatile("s_get_barrier_state %0, 1\ns_wait_kmcnt 0" : "=s"(state)::"memory");
      if (lane() == 0)
        *counts = ((state >> 4) & 127) * 100 + ((state >> 16) & 127);
      __builtin_amdgcn_s_barrier_signal_var(&ready, 0);
    } else {
      __builtin_amdgcn_s_barrier_signal_var(&ready, 2);
    }
  } else {
    namedWait();
    out[lane()] = readLds(slot());
  }
  workgroup();
}

TEST_F(Gfx1250RaceTest, named_init_discards_arrivals) {
  int *out = allocFilled<int>(kWave, -7);
  int *counts = allocFilled<int>(1, -7);
  named_count_change_kernel<true><<<1, 64, kTileBytes>>>(out, counts);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectNoRace();
  ExpectValues(out, values(100));
  ExpectValues(counts, std::vector<int>{201});
}

TEST_F(Gfx1250RaceTest, named_signal_changes_threshold) {
  int *out = allocFilled<int>(kWave, -7);
  named_count_change_kernel<false><<<1, 64, kTileBytes>>>(out, nullptr);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectNoRace();
  ExpectValues(out, values(100));
}

constexpr int kRounds = 8;

// One producer, two consumers, one reusable tile. ready needs one signal;
// consumed needs two. The producer joins consumed, both consumers join ready.
// Each acknowledgement must follow its consumer's completed LDS read.
template <bool EarlyAck>
__global__ __attribute__((amdgpu_flat_work_group_size(96, 96))) void
named_broadcast_kernel(int *out) {
  __shared__ __amdgpu_named_workgroup_barrier_t ready, consumed;
  if (wave() == 0) {
    __builtin_amdgcn_s_barrier_init(&ready, 1);
    __builtin_amdgcn_s_barrier_init(&consumed, 2);
    __builtin_amdgcn_s_barrier_join(&consumed);
  } else {
    __builtin_amdgcn_s_barrier_join(&ready);
  }
  workgroup();
  for (int round = 0; round < kRounds; ++round) {
    if (wave() == 0) {
      writeLds(slot(), 1000 + round * kWave + lane());
      drain();
      __builtin_amdgcn_s_barrier_signal_var(&ready, 0);
      namedWait();
    } else {
      namedWait();
      const bool early = EarlyAck && wave() == 2 && round == 5;
      if (early)
        __builtin_amdgcn_s_barrier_signal_var(&consumed, 0);
      out[((wave() - 1) * kRounds + round) * kWave + lane()] = readLds(slot());
      if (!early)
        __builtin_amdgcn_s_barrier_signal_var(&consumed, 0);
    }
  }
  workgroup();
}

TEST_F(Gfx1250RaceTest, named_broadcast_reuse) {
  int *out = allocFilled<int>(2 * kRounds * kWave, -7);
  named_broadcast_kernel<false><<<1, 96, kTileBytes>>>(out);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectNoRace();
  ExpectValues(out, values(1000, kRounds * kWave));
  ExpectValues(out + kRounds * kWave, values(1000, kRounds * kWave));
}

TEST_F(Gfx1250RaceTest, named_broadcast_early_ack_race) {
  named_broadcast_kernel<true><<<1, 96, kTileBytes>>>(alloc<int>(2 * kRounds * kWave));
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectAnyRace({kReadConflict, kWriteConflict});
}

// Independent pairs reuse disjoint tiles without any workgroup rendezvous
// inside the loop. Neither pair acquires the other pair's LDS history.
template <bool CrossRead>
__global__ __attribute__((amdgpu_flat_work_group_size(128, 128))) void
named_independent_pairs_kernel(int *out) {
  __shared__ __amdgpu_named_workgroup_barrier_t ready[2], consumed[2];
  const int pair = wave() / 2;
  if (wave() == 0) {
    __builtin_amdgcn_s_barrier_init(&ready[0], 1);
    __builtin_amdgcn_s_barrier_init(&ready[1], 1);
    __builtin_amdgcn_s_barrier_init(&consumed[0], 1);
    __builtin_amdgcn_s_barrier_init(&consumed[1], 1);
  }
  if (wave() % 2 == 0)
    __builtin_amdgcn_s_barrier_join(&consumed[pair]);
  else
    __builtin_amdgcn_s_barrier_join(&ready[pair]);
  workgroup();
  for (int round = 0; round < kRounds; ++round) {
    if (wave() % 2 == 0) {
      writeLds(slot(pair), 1000 + (pair * kRounds + round) * kWave + lane());
      drain();
      __builtin_amdgcn_s_barrier_signal_var(&ready[pair], 0);
      namedWait();
    } else {
      namedWait();
      out[(pair * kRounds + round) * kWave + lane()] = readLds(slot(pair));
      if constexpr (CrossRead) {
        if (pair == 1 && round == 5)
          out[2 * kRounds * kWave + lane()] = readLds(slot(0));
      }
      __builtin_amdgcn_s_barrier_signal_var(&consumed[pair], 0);
    }
  }
  workgroup();
}

TEST_F(Gfx1250RaceTest, named_independent_pairs) {
  int *out = allocFilled<int>(2 * kRounds * kWave, -7);
  named_independent_pairs_kernel<false><<<1, 128, 2 * kTileBytes>>>(out);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectNoRace();
  ExpectValues(out, values(1000, 2 * kRounds * kWave));
}

TEST_F(Gfx1250RaceTest, named_independent_pairs_cross_read_race) {
  int *out = allocFilled<int>((2 * kRounds + 1) * kWave, -7);
  named_independent_pairs_kernel<true><<<1, 128, 2 * kTileBytes>>>(out);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  auto read = kReadConflict;
  auto write = kWriteConflict;
  read.findings = write.findings = FindingCount::OneOrMore;
  ExpectAnyRace({read, write});
  ExpectValues(out, values(1000, 2 * kRounds * kWave));
}

// A reads, B relays its arrival, C overwrites: the same transitive channel
// must protect an outstanding LDS read as well as publishing LDS writes.
template <bool LateDrain>
__global__ __attribute__((amdgpu_flat_work_group_size(96, 96))) void
named_chain_read_kernel(int *out) {
  __shared__ __amdgpu_named_workgroup_barrier_t ab, bc;
  if (wave() == 0) {
    __builtin_amdgcn_s_barrier_init(&ab, 1);
    __builtin_amdgcn_s_barrier_init(&bc, 1);
    writeLds(slot(), 100 + lane());
    drain();
  } else if (wave() == 1) {
    __builtin_amdgcn_s_barrier_join(&ab);
  } else {
    __builtin_amdgcn_s_barrier_join(&bc);
  }
  workgroup();
  if (wave() == 0) {
    int value;
    asm volatile("ds_load_b32 %0, %1" : "=v"(value) : "v"(slot()) : "memory");
    if constexpr (!LateDrain)
      drain();
    __builtin_amdgcn_s_barrier_signal_var(&ab, 0);
    if constexpr (LateDrain)
      drain();
    out[lane()] = value;
  } else if (wave() == 1) {
    namedWait();
    __builtin_amdgcn_s_barrier_signal_var(&bc, 0);
  } else {
    namedWait();
    writeLds(slot(), -1);
    drain();
  }
  workgroup();
}

TEST_F(Gfx1250RaceTest, named_chain_read_before_overwrite) {
  int *out = allocFilled<int>(kWave, -7);
  named_chain_read_kernel<false><<<1, 96, kTileBytes>>>(out);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectNoRace();
  ExpectValues(out, values(100));
}

TEST_F(Gfx1250RaceTest, named_chain_read_late_drain_race) {
  named_chain_read_kernel<true><<<1, 96, kTileBytes>>>(alloc<int>(kWave));
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectRace(kWriteConflict);
}

// JOIN 0 removes C's listener but preserves the threshold. A's first signal
// must leave count 1 of 2; B can read only after A's second write and signal.
__global__ __attribute__((amdgpu_flat_work_group_size(96, 96))) void
named_join_null_count_kernel(int *out, int *counts) {
  __shared__ __amdgpu_named_workgroup_barrier_t ready;
  if (wave() == 0)
    __builtin_amdgcn_s_barrier_init(&ready, 2);
  else
    __builtin_amdgcn_s_barrier_join(&ready);
  if (wave() == 2)
    asm volatile("s_barrier_join 0" ::: "memory");
  workgroup();
  if (wave() == 0) {
    __builtin_amdgcn_s_barrier_signal_var(&ready, 0);
    uint32_t state;
    asm volatile("s_get_barrier_state %0, 1\ns_wait_kmcnt 0" : "=s"(state)::"memory");
    if (lane() == 0)
      *counts = ((state >> 4) & 127) * 100 + ((state >> 16) & 127);
    writeLds(slot(), 100 + lane());
    drain();
    __builtin_amdgcn_s_barrier_signal_var(&ready, 0);
  } else if (wave() == 1) {
    namedWait();
    out[lane()] = readLds(slot());
  }
  workgroup();
}

TEST_F(Gfx1250RaceTest, named_join_null_preserves_threshold) {
  int *out = allocFilled<int>(kWave, -7);
  int *counts = allocFilled<int>(1, -7);
  named_join_null_count_kernel<<<1, 96, kTileBytes>>>(out, counts);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectNoRace();
  ExpectValues(out, values(100));
  ExpectValues(counts, std::vector<int>{201});
}

// B terminates without signalling or leaving. Its termination lowers the
// workgroup count to two but leaves the named threshold at two. A supplies
// both named signals, so this probe finishes without relying on a timeout.
__global__ __attribute__((amdgpu_flat_work_group_size(96, 96))) void
named_exit_count_kernel(int *out, int *counts) {
  __shared__ __amdgpu_named_workgroup_barrier_t ready;
  if (wave() == 0)
    __builtin_amdgcn_s_barrier_init(&ready, 2);
  else
    __builtin_amdgcn_s_barrier_join(&ready);
  workgroup();
  if (wave() == 1)
    return;
  if (wave() == 0) {
    uint32_t state;
    do {
      asm volatile("s_get_barrier_state %0, -1\ns_wait_kmcnt 0" : "=s"(state)::"memory");
    } while (((state >> 4) & 127) != 2);
    __builtin_amdgcn_s_barrier_signal_var(&ready, 0);
    asm volatile("s_get_barrier_state %0, 1\ns_wait_kmcnt 0" : "=s"(state)::"memory");
    if (lane() == 0)
      *counts = ((state >> 4) & 127) * 100 + ((state >> 16) & 127);
    writeLds(slot(), 100 + lane());
    drain();
    __builtin_amdgcn_s_barrier_signal_var(&ready, 0);
  } else {
    namedWait();
    out[lane()] = readLds(slot());
  }
  workgroup();
}

TEST_F(Gfx1250RaceTest, named_exit_preserves_threshold) {
  int *out = allocFilled<int>(kWave, -7);
  int *counts = allocFilled<int>(1, -7);
  named_exit_count_kernel<<<1, 96, kTileBytes>>>(out, counts);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectNoRace();
  ExpectValues(out, values(100));
  ExpectValues(counts, std::vector<int>{201});
}

} // namespace
