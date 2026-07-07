// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT

#include "fpsan/fpsan.hpp"
#include "fpsan_test_common.hpp"

#include <cstdint>
#include <cstring>

using fpsan::cast;
using fpsan::Conversions;
using fpsan::Semantics;
using fpsan::Value;

namespace
{
    int run_cast_tests()
    {
#if FPSAN_HAS_FLOAT16
        {
            using H = Value<_Float16, Semantics::Triton, Conversions::Explicit>;
            FPSAN_ASSERT_EQ(cast<float>(H(_Float16(0))).fpsan_payload(), 0u);
            FPSAN_ASSERT_EQ(cast<float>(H(_Float16(1))).fpsan_payload(), 1u);
            FPSAN_ASSERT_EQ(cast<float>(H(_Float16(-1))).fpsan_payload(), 0xFFFFFFFFu);
        }
        {
            using H = Value<_Float16, Semantics::Triton, Conversions::Explicit>;
            for(int i = 0; i < (1 << 16); ++i)
            {
                _Float16     v;
                std::uint16_t b = static_cast<std::uint16_t>(i);
                std::memcpy(&v, &b, sizeof v);
                H    h(v);
                auto back = cast<_Float16>(cast<float>(h));
                FPSAN_ASSERT_EQ(back.fpsan_payload(), h.fpsan_payload());
            }
        }
        {
            using H = Value<_Float16, Semantics::Native, Conversions::Explicit>;
            using F = Value<float, Semantics::Native, Conversions::Explicit>;
            for(float x : {0.0f, 1.5f, -2.25f, 100.0f, 0.1f})
            {
                F f(x);
                FPSAN_ASSERT_EQ(bits_of(static_cast<_Float16>(cast<_Float16>(f))),
                                bits_of(static_cast<_Float16>(x)));
                H h(static_cast<_Float16>(x));
                FPSAN_ASSERT_EQ(bits_of(static_cast<float>(cast<float>(h))),
                                bits_of(static_cast<float>(static_cast<_Float16>(x))));
            }
        }
#endif
        return 0;
    }
} // namespace

int main()
{
    return run_cast_tests();
}
