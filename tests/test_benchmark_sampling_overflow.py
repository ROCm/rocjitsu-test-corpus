"""Bounded host controls for native iteration arithmetic (no device execution)."""

from pathlib import Path
import re
import subprocess

import pytest

ROOT = Path(__file__).resolve().parents[1] / "corpus/benchmarks"


@pytest.mark.parametrize("provider", ["full_tensile", "llama"])
def test_native_iteration_sum_does_not_overflow(tmp_path, provider):
    if provider == "full_tensile":
        code = r"""
#include "host.hpp"
#include <limits>
struct Stop {};
int main() {
    bool reached=false;
    try {
        full_tensile::measure(std::numeric_limits<int>::max(), 1,
            [&]{reached=true;throw Stop{};}, []{}, []{}, []{return 1LL;});
    } catch(const Stop&) {}
    return reached ? 0 : 1;
}
"""
    else:
        source = (ROOT / "llama/bounded-ops.cpp").read_text()
        # Compile the real loop header and serialized invocation expression,
        # stopping on its first iteration instead of running billions of graphs.
        loop_match = re.search(r"for \([^;]*iteration[^;]*;[^;]*;[^;]*\) \{", source)
        count_match = re.search(r'<< ",\\"graph_invocations\\":" << ([^\n]+)', source)
        assert loop_match and count_match, "native sampling control not found"
        loop, count = loop_match.group(), count_match.group(1)
        code = (
            "#include <cstdint>\n#include <limits>\nint main() {\n"
            + "int warmups=std::numeric_limits<int>::max(), samples=warmups;\n"
            + f"if (({count}) != 4294967294LL) return 2;\n"
            + loop
            + "\nreturn 0;\n}\nreturn 1;\n}\n"
        )
    host = tmp_path / "overflow.cpp"
    host.write_text(code)
    binary = tmp_path / "overflow"
    subprocess.run(
        [
            "c++",
            "-std=c++17",
            "-fsanitize=undefined",
            "-fno-sanitize-recover=undefined",
            "-I",
            str(ROOT / provider),
            str(host),
            "-o",
            str(binary),
        ],
        check=True,
    )
    subprocess.run([str(binary)], check=True, timeout=10)
