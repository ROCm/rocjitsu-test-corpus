/**
 * @copyright Copyright 2023 Advanced Micro Devices, Inc.
 */

#pragma once

#include <cstdlib>
#include <iostream>
#include <sstream>
#include <stdexcept>
#include <string>

#include <streamk/utils/device.hpp>

namespace streamk {

namespace detail {

inline bool parse_bool(const std::string& value) {
  if (value == "1" || value == "true" || value == "on" || value == "yes") {
    return true;
  }
  if (value == "0" || value == "false" || value == "off" || value == "no") {
    return false;
  }
  throw std::invalid_argument("invalid boolean value: " + value);
}

inline void print_help(const char* program) {
  std::cout << "Stream-K Library for GEMM\n\n"
            << "Usage: " << program << " [options]\n\n"
            << "Options:\n"
            << "  -h, --help              Print help\n"
            << "  -m <int>                Rows of A-Matrix (default: 3072)\n"
            << "  -n <int>                Columns of B-Matrix (default: 4096)\n"
            << "  -k <int>                Columns of A-Matrix (default: 4096)\n"
            << "  -g, --grid <int>        Grid size used for Stream-K approach\n"
            << "  -a, --alpha <float>     Alpha value to use (default: 1.0)\n"
            << "  -b, --beta <float>      Beta value to use (default: 0.0)\n"
            << "  -e, --epsilon <float>   Epsilon used for comparison (default: 1.0e-2)\n"
            << "      --validate[=bool]   Validate results with rocBLAS\n"
            << "  -v, --verbose[=bool]    Verbose output\n"
            << "      --num_runs <int>    Number of runs (default: 10)\n";
}

}  // namespace detail

template <typename compute_t>
struct parameters_t {
  int m = 3072;
  int n = 4096;
  int k = 4096;

  int grid;

  int num_runs = 10;
  compute_t alpha = 1.0f;
  compute_t beta = 0.0f;
  float epsilon = 1.0e-2f;

  bool validate = false;
  bool verbose = false;

  std::string toString()
  {
    std::stringstream retval; 
    retval << "GEMM:\n";
    retval << "\tM: " << m << "\n";
    retval << "\tN: " << n << "\n";
    retval << "\tK: " << k << "\n";
    retval << "\tgrid: " << grid << "\n";
    retval << "\talpha: " << alpha << "\n";
    retval << "\tbeta: " << beta << "\n";
    retval << "\tnum_runs: " << num_runs << "\n";
    retval << "\tepsilon: " << epsilon << "\n";
    retval << "\tvalidate: " << validate << "\n";
    retval << "\tverbose: " << verbose << "\n";
    return retval.str();
  }

  /**
   * @brief Construct a new parameters object and parse command line arguments.
   *
   * @param argc Number of command line arguments.
   * @param argv Command line arguments.
   */
  parameters_t(int argc, char** argv) {
    bool grid_set = false;

    for (int i = 1; i < argc; ++i) {
      std::string arg = argv[i];
      std::string value;
      const auto equals = arg.find('=');
      if (equals != std::string::npos) {
        value = arg.substr(equals + 1);
        arg = arg.substr(0, equals);
      }

      auto take_value = [&](const char* option) {
        if (!value.empty()) {
          return value;
        }
        if (i + 1 >= argc) {
          throw std::invalid_argument(std::string("missing value for ") + option);
        }
        return std::string(argv[++i]);
      };

      auto take_bool = [&]() {
        if (!value.empty()) {
          return detail::parse_bool(value);
        }
        return true;
      };

      if (arg == "-h" || arg == "--help") {
        detail::print_help(argv[0]);
        std::exit(0);
      } else if (arg == "-m" || arg == "--m") {
        m = std::stoi(take_value(arg.c_str()));
      } else if (arg == "-n" || arg == "--n") {
        n = std::stoi(take_value(arg.c_str()));
      } else if (arg == "-k" || arg == "--k") {
        k = std::stoi(take_value(arg.c_str()));
      } else if (arg == "-g" || arg == "--grid") {
        grid = std::stoi(take_value(arg.c_str()));
        grid_set = true;
      } else if (arg == "-a" || arg == "--alpha") {
        alpha = static_cast<compute_t>(std::stof(take_value(arg.c_str())));
      } else if (arg == "-b" || arg == "--beta") {
        beta = static_cast<compute_t>(std::stof(take_value(arg.c_str())));
      } else if (arg == "-e" || arg == "--epsilon") {
        epsilon = std::stof(take_value(arg.c_str()));
      } else if (arg == "--validate") {
        validate = take_bool();
      } else if (arg == "-v" || arg == "--verbose") {
        verbose = take_bool();
      } else if (arg == "--num_runs") {
        num_runs = std::stoi(take_value(arg.c_str()));
      } else {
        throw std::invalid_argument("unknown option: " + arg);
      }
    }

    if (!grid_set) {
      auto properties = device_properties();
      grid = properties.multiProcessorCount;
    }

    if(verbose)
      std::cout << toString() << std::endl;
  }
};

}  // namespace streamk