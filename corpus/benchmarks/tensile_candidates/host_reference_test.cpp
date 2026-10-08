// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT
#include "host_reference.hpp"
#include <algorithm>
#include <cstddef>
#include <cstdint>
#include <exception>
#include <initializer_list>
#include <iostream>
#include <limits>
#include <numeric>
#include <stdexcept>
#include <string>
#include <vector>

namespace {
void require(bool value, const char *message) {
    if (!value)
        throw std::runtime_error(message);
}
enum class Fault {
    none,
    dropped,
    doubled,
    shiftedA,
    ignoredScales,
    ignoredScaleA,
    ignoredScaleB,
    reusedScaleA,
    scaleABlockNext,
    scaleABlockPrevious,
    scaleBBlockNext,
    scaleBBlockPrevious,
    scaleARowNext,
    scaleBColumnNext,
    swappedRows,
    swappedColumns
};

// Deliberately use a full scalar GEMM over decoded input bytes and canonical
// scale bytes. This does not use the production separable-reference formula.
std::vector<uint8_t> gemm(const candidate::HostReference &host, Fault fault = Fault::none,
                          size_t tile = 0) {
    std::vector<uint8_t> result(host.c.size());
    for (size_t j = 0; j < host.n; ++j)
        for (size_t i = 0; i < host.m; ++i) {
            double sum = 0;
            for (size_t l = 0; l < host.k; ++l) {
                const bool affected = l / 64 == tile;
                if (fault == Fault::dropped && affected)
                    continue;
                const size_t la = fault == Fault::shiftedA ? (l + tile * 64) % host.k : l;
                const size_t row =
                    fault == Fault::swappedRows && (i ^ tile) < host.m ? i ^ tile : i;
                const size_t column =
                    fault == Fault::swappedColumns && (j ^ tile) < host.n ? j ^ tile : j;
                const size_t ai = host.transA ? row * host.k + la : la * host.m + row;
                const size_t bi = host.transB ? l * host.n + column : column * host.k + l;
                double av = host.input(host.a, ai), bv = host.input(host.b, bi);
                if (host.mx && fault != Fault::ignoredScales) {
                    size_t aq = la / 32, bq = l / 32;
                    if (fault == Fault::scaleABlockNext)
                        aq = (aq + 1) % host.kBlocks;
                    if (fault == Fault::scaleABlockPrevious)
                        aq = (aq + host.kBlocks - 1) % host.kBlocks;
                    if (fault == Fault::scaleBBlockNext)
                        bq = (bq + 1) % host.kBlocks;
                    if (fault == Fault::scaleBBlockPrevious)
                        bq = (bq + host.kBlocks - 1) % host.kBlocks;
                    const size_t scaleRow =
                        fault == Fault::scaleARowNext ? (row + 1) % host.m : row;
                    const size_t scaleColumn =
                        fault == Fault::scaleBColumnNext ? (column + 1) % host.n : column;
                    if (fault != Fault::ignoredScaleA)
                        av *= float(
                            TensileLite::E8(host.canonicalScaleA[scaleRow * host.kBlocks + aq]));
                    if (fault != Fault::ignoredScaleB)
                        bv *= float(TensileLite::E8(
                            fault == Fault::reusedScaleA
                                ? host.canonicalScaleA[(scaleColumn % host.m) * host.kBlocks + bq]
                                : host.canonicalScaleB[scaleColumn * host.kBlocks + bq]));
                }
                sum += av * bv * (fault == Fault::doubled && affected ? 2 : 1);
            }
            host.putOutput(result, j * host.m + i,
                           float(sum) + host.beta * host.output(host.c, j * host.m + i));
        }
    return result;
}
void rejected(const candidate::HostReference &host, const std::vector<uint8_t> &output) {
    bool failed = false;
    try {
        host.validate(output);
    } catch (const std::runtime_error &) {
        failed = true;
    }
    require(failed, "corrupted output escaped full-output validation");
}
void packing() {
    // Fixed independent coordinate examples from the pinned layout contract.
    // gfx1250: [slow=3, fast=5] -> [K tiles=2, slow=3, lane=4].
    std::vector<uint8_t> natural(15);
    std::iota(natural.begin(), natural.end(), 1);
    require(candidate::packScales(natural, 3, 5, 2) ==
                std::vector<uint8_t>(
                    {1, 2, 3, 4, 6, 7, 8, 9, 11, 12, 13, 14, 5, 0, 0, 0, 10, 0, 0, 0, 15, 0, 0, 0}),
            "gfx1250 scale layout/padding mismatch");
    // gfx950 first output lanes enumerate row16 before row1 and K4 before K1.
    natural.resize(32 * 8);
    std::iota(natural.begin(), natural.end(), 0);
    const auto packed = candidate::packScales(natural, 32, 8, 1);
    const std::vector<uint8_t> prefix{0, 128, 4, 132, 8, 136, 12, 140, 16, 144, 20, 148};
    require(std::equal(prefix.begin(), prefix.end(), packed.begin()),
            "gfx950 scale permutation mismatch");
    for (int format : {1, 2}) {
        natural.assign(33 * 9, 127);
        const auto padded = candidate::packScales(natural, 33, 9, format);
        const size_t size = format == 1 ? 64 * 16 : 33 * 12;
        require(padded.size() == size, "incorrect padded scale allocation");
        require(std::count(padded.begin(), padded.end(), uint8_t(127)) == 33 * 9,
                "scale packing lost values or initialized padding as data");
        require(std::count(padded.begin(), padded.end(), uint8_t(0)) == size - 33 * 9,
                "scale packing padding is not zero");
    }
    bool failed = false;
    try {
        candidate::packScales(natural, 33, 9, 0);
    } catch (const std::invalid_argument &) {
        failed = true;
    }
    require(failed, "unsupported scale format accepted");
}
} // namespace

int main() {
    try {
        packing();
        for (const std::string variant :
             {"bf16_subtile", "bf16_streamk", "mxfp8_subtile", "mxfp4_streamk"}) {
            const bool mx = variant.find("mx") == 0;
            const int format = variant == "mxfp4_streamk" ? 2 : 1;
            for (size_t k : mx ? std::vector<size_t>{32, 96, 256, 4096}
                               : std::vector<size_t>{1, 34, 35, 36, 256, 4096, 65536}) {
                candidate::HostReference host(variant, 7, 9, k, format);
                host.validate(gemm(host));
                require(host.innerSum > 0, "K accumulation cancels");
                auto corrupted = gemm(host);
                host.putOutput(corrupted, 0, std::numeric_limits<float>::quiet_NaN());
                rejected(host, corrupted);
                if (k == 4096) {
                    for (size_t tile : {9, 25, 44, 60}) {
                        rejected(host, gemm(host, Fault::dropped, tile));
                        rejected(host, gemm(host, Fault::doubled, tile));
                        if (mx)
                            rejected(host, gemm(host, Fault::shiftedA, tile));
                    }
                    if (mx)
                        for (auto fault : {Fault::ignoredScales, Fault::ignoredScaleA,
                                           Fault::ignoredScaleB, Fault::reusedScaleA,
                                           Fault::scaleABlockNext, Fault::scaleABlockPrevious,
                                           Fault::scaleBBlockNext, Fault::scaleBBlockPrevious,
                                           Fault::scaleARowNext, Fault::scaleBColumnNext})
                            rejected(host, gemm(host, fault));
                }
            }
            // Thin matrices cross free-axis tile boundaries without an expensive
            // large square reference. Exchange complete tiles, including their scales.
            for (size_t tile : {64, 128}) {
                candidate::HostReference rows(variant, 129, 2, 256, format);
                rows.validate(gemm(rows));
                rejected(rows, gemm(rows, Fault::swappedRows, tile));
                candidate::HostReference columns(variant, 2, 129, 256, format);
                columns.validate(gemm(columns));
                rejected(columns, gemm(columns, Fault::swappedColumns, tile));
            }
        }
        std::cout << "Tensile host reference tests passed\n";
        return 0;
    } catch (const std::exception &error) {
        std::cerr << "Tensile host reference test: " << error.what() << '\n';
        return 1;
    }
}
