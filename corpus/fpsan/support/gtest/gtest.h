// Minimal GoogleTest-compatible surface for vendored FPSan tests.
// This is not GoogleTest; it only supports the assertion macros used by the
// migrated upstream test files.
#ifndef FPSAN_SUPPORT_GTEST_GTEST_H
#define FPSAN_SUPPORT_GTEST_GTEST_H

#include <cmath>
#include <cstdlib>
#include <iostream>
#include <string>
#include <utility>
#include <vector>

namespace testing
{
    class Test
    {
    };
} // namespace testing

namespace fpsan_gtest
{
    using TestFn = void (*)();

    struct TestCase
    {
        const char* suite;
        const char* name;
        TestFn      fn;
    };

    inline std::vector<TestCase>& registry()
    {
        static std::vector<TestCase> tests;
        return tests;
    }

    inline bool disabled_name(const char* name)
    {
        return std::string(name).rfind("DISABLED_", 0) == 0;
    }

    struct Registrar
    {
        Registrar(const char* suite, const char* name, TestFn fn)
        {
            if(!disabled_name(name))
                registry().push_back({suite, name, fn});
        }
    };

    struct Stream
    {
        template <class T>
        Stream& operator<<(const T&)
        {
            return *this;
        }
    };

    [[noreturn]] inline void fail(const char* file, int line)
    {
        std::cerr << "FAIL: " << file << ":" << line << "\n";
        std::exit(1);
    }

    template <class A, class B>
    Stream expect_eq(const A& a, const B& b, const char* file, int line)
    {
        if(!(a == b))
            fail(file, line);
        return {};
    }

    template <class A, class B>
    Stream expect_ne(const A& a, const B& b, const char* file, int line)
    {
        if(!(a != b))
            fail(file, line);
        return {};
    }

    template <class A, class B, class C>
    Stream expect_near(const A& a, const B& b, const C& tol, const char* file, int line)
    {
        if(std::fabs(static_cast<double>(a) - static_cast<double>(b)) > static_cast<double>(tol))
            fail(file, line);
        return {};
    }

    template <class A, class B>
    Stream expect_lt(const A& a, const B& b, const char* file, int line)
    {
        if(!(a < b))
            fail(file, line);
        return {};
    }

    template <class A, class B>
    Stream expect_le(const A& a, const B& b, const char* file, int line)
    {
        if(!(a <= b))
            fail(file, line);
        return {};
    }

    template <class A, class B>
    Stream expect_gt(const A& a, const B& b, const char* file, int line)
    {
        if(!(a > b))
            fail(file, line);
        return {};
    }

    template <class A, class B>
    Stream expect_ge(const A& a, const B& b, const char* file, int line)
    {
        if(!(a >= b))
            fail(file, line);
        return {};
    }

    inline Stream expect_true(bool v, const char* file, int line)
    {
        if(!v)
            fail(file, line);
        return {};
    }

    inline Stream expect_false(bool v, const char* file, int line)
    {
        if(v)
            fail(file, line);
        return {};
    }

    inline int run_all_tests()
    {
        for(const TestCase& test : registry())
            test.fn();
        return 0;
    }
} // namespace fpsan_gtest

#define FPSAN_GTEST_CONCAT2(a, b) a##b
#define FPSAN_GTEST_CONCAT(a, b) FPSAN_GTEST_CONCAT2(a, b)
#define TEST(suite, name) FPSAN_GTEST_TEST_IMPL(suite, name, __COUNTER__)
#define FPSAN_GTEST_TEST_IMPL(suite, name, id)                                    \
    static void FPSAN_GTEST_CONCAT(fpsan_gtest_test_, id)();                      \
    static ::fpsan_gtest::Registrar FPSAN_GTEST_CONCAT(fpsan_gtest_registrar_, id)( \
        #suite, #name, &FPSAN_GTEST_CONCAT(fpsan_gtest_test_, id));               \
    static void FPSAN_GTEST_CONCAT(fpsan_gtest_test_, id)()

#define EXPECT_EQ(a, b) ::fpsan_gtest::expect_eq((a), (b), __FILE__, __LINE__)
#define ASSERT_EQ(a, b) EXPECT_EQ(a, b)
#define EXPECT_NE(a, b) ::fpsan_gtest::expect_ne((a), (b), __FILE__, __LINE__)
#define ASSERT_NE(a, b) EXPECT_NE(a, b)
#define EXPECT_NEAR(a, b, tol) ::fpsan_gtest::expect_near((a), (b), (tol), __FILE__, __LINE__)
#define EXPECT_LT(a, b) ::fpsan_gtest::expect_lt((a), (b), __FILE__, __LINE__)
#define ASSERT_LT(a, b) EXPECT_LT(a, b)
#define EXPECT_LE(a, b) ::fpsan_gtest::expect_le((a), (b), __FILE__, __LINE__)
#define ASSERT_LE(a, b) EXPECT_LE(a, b)
#define EXPECT_GT(a, b) ::fpsan_gtest::expect_gt((a), (b), __FILE__, __LINE__)
#define ASSERT_GT(a, b) EXPECT_GT(a, b)
#define EXPECT_GE(a, b) ::fpsan_gtest::expect_ge((a), (b), __FILE__, __LINE__)
#define ASSERT_GE(a, b) EXPECT_GE(a, b)
#define EXPECT_TRUE(v) ::fpsan_gtest::expect_true(static_cast<bool>(v), __FILE__, __LINE__)
#define ASSERT_TRUE(v) EXPECT_TRUE(v)
#define EXPECT_FALSE(v) ::fpsan_gtest::expect_false(static_cast<bool>(v), __FILE__, __LINE__)
#define ASSERT_FALSE(v) EXPECT_FALSE(v)
#define SUCCEED() ::fpsan_gtest::Stream()

#define GTEST_SKIP() \
    if(true)         \
    return;          \
    else             \
        ::fpsan_gtest::Stream()

int main()
{
    return ::fpsan_gtest::run_all_tests();
}

#endif // FPSAN_SUPPORT_GTEST_GTEST_H
