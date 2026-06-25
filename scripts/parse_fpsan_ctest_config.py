"""Parse FPSAN CTest JSON configs for tests/run_fpsan_ctest.sh."""

import json
import pathlib
import sys


def main(argv):
    if len(argv) != 2:
        raise SystemExit("usage: parse_fpsan_ctest_config.py CONFIG_JSON")

    config_path = pathlib.Path(argv[1])
    with config_path.open("r", encoding="utf-8") as f:
        config = json.load(f)

    if not isinstance(config, dict):
        raise SystemExit(f"{config_path} must be a JSON object")

    for field in ("config_name", "hip_architectures", "tests"):
        if field not in config:
            raise SystemExit(f"{config_path} is missing required field '{field}'")

    config_name = config["config_name"]
    hip_architectures = config["hip_architectures"]
    tests = config["tests"]

    if not isinstance(config_name, str) or not config_name:
        raise SystemExit(f"{config_path} has invalid config_name")
    if not isinstance(hip_architectures, list):
        raise SystemExit(f"{config_path} field hip_architectures must be a list")
    if not isinstance(tests, list):
        raise SystemExit(f"{config_path} field tests must be a list")

    for item in hip_architectures:
        if not isinstance(item, str) or not item:
            raise SystemExit(f"{config_path} has invalid hip_architecture entry")

    for test_name in tests:
        if not isinstance(test_name, str) or not test_name:
            raise SystemExit(f"{config_path} has invalid test entry")

    print(f"CONFIG_NAME={config_name}")
    print(f"HIP_ARCHITECTURES={';'.join(hip_architectures)}")
    for test_name in tests:
        print(f"TEST={test_name}")


if __name__ == "__main__":
    main(sys.argv)
