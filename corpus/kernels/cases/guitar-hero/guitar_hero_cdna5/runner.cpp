#include "runner.hpp"

namespace {
constexpr const char *checkpoints[] = {
#include "checkpoints.inc"
};
} // namespace

int main(int argc, char **argv) {
  return guitar_hero::run(argc, argv,
                          {"guitar_hero_cdna5", "gfx1250",
                           "guitar_hero_cdna5.hsaco", checkpoints,
                           std::size(checkpoints)});
}
