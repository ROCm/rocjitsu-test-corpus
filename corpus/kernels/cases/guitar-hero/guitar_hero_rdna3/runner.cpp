#include "runner.hpp"

#include <iterator>

namespace {
constexpr const char *checkpoints[] = {
#include "checkpoints.inc"
};
} // namespace

int main(int argc, char **argv) {
  return guitar_hero::run(argc, argv,
                          {"guitar_hero_rdna3", "gfx1100",
                           "guitar_hero_rdna3.hsaco", checkpoints,
                           std::size(checkpoints)});
}
