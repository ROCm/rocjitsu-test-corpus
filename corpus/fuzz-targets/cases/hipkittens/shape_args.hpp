#pragma once

#include <cstdio>
#include <cstdlib>
#include <cstring>

struct HipKittensShape {
    int m;
    int n;
    int k;
};

inline bool parse_positive_int(const char *value, int &result) {
    char *end = nullptr;
    const long parsed = std::strtol(value, &end, 10);
    if (end == value || *end != '\0' || parsed <= 0) {
        return false;
    }
    result = static_cast<int>(parsed);
    return true;
}

inline const char *take_value(int argc, char **argv, int &index, const char *option, const char *inline_value) {
    if (inline_value != nullptr) {
        return inline_value;
    }
    if (index + 1 >= argc) {
        std::fprintf(stderr, "%s requires a positive integer\n", option);
        std::exit(1);
    }
    return argv[++index];
}

inline HipKittensShape parse_hipkittens_shape_args(
        int argc,
        char **argv,
        HipKittensShape defaults) {
    HipKittensShape shape = defaults;
    for (int i = 1; i < argc; ++i) {
        const char *arg = argv[i];
        const char *value = nullptr;
        int *field = nullptr;
        if (std::strcmp(arg, "-m") == 0 || std::strcmp(arg, "--m") == 0) {
            field = &shape.m;
        } else if (std::strncmp(arg, "--m=", 4) == 0) {
            field = &shape.m;
            value = arg + 4;
        } else if (std::strcmp(arg, "-n") == 0 || std::strcmp(arg, "--n") == 0) {
            field = &shape.n;
        } else if (std::strncmp(arg, "--n=", 4) == 0) {
            field = &shape.n;
            value = arg + 4;
        } else if (std::strcmp(arg, "-k") == 0 || std::strcmp(arg, "--k") == 0) {
            field = &shape.k;
        } else if (std::strncmp(arg, "--k=", 4) == 0) {
            field = &shape.k;
            value = arg + 4;
        } else {
            std::fprintf(stderr,
                "unknown argument: %s\n"
                "usage: %s [-m M|--m M] [-n N|--n N] [-k K|--k K]\n",
                arg, argv[0]);
            std::exit(1);
        }

        int parsed = 0;
        value = take_value(argc, argv, i, arg, value);
        if (!parse_positive_int(value, parsed)) {
            std::fprintf(stderr, "invalid %s value: %s\n", arg, value);
            std::exit(1);
        }
        *field = parsed;
    }
    return shape;
}

inline void require_hipkittens_compiled_shape(
        HipKittensShape actual,
        HipKittensShape compiled) {
    if (actual.m != compiled.m || actual.n != compiled.n || actual.k != compiled.k) {
        std::fprintf(stderr,
            "this HipKittens runner is compiled for m=%d n=%d k=%d; got m=%d n=%d k=%d\n",
            compiled.m, compiled.n, compiled.k, actual.m, actual.n, actual.k);
        std::exit(1);
    }
}
