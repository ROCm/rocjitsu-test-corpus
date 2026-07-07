#define main kernel_corpus_hip_matmul_upstream_main
#include "../../../third_party/hip-matmul/matmul.hip"
#undef main

int main(int argc, char **argv) {
  applyMNKArgs(argc, argv);
  return kernel_corpus_hip_matmul_upstream_main();
}
