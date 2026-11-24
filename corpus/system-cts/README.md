# VFIO system CTS

The [corpus workflow](../../.github/workflows/vfio-system-cts.yml) builds a
pinned rocjitsu with VFIO enabled and runs the real socket transport, launcher,
and CLI tests. These checks require local Unix sockets and a Linux host.

To run the same tests locally, set `ROCJITSU` and `CORPUS` to absolute source
paths and `BUILD` to a Release build directory.

```sh
cmake -S "$ROCJITSU" -B "$BUILD" -G Ninja -DCMAKE_BUILD_TYPE=Release \
  -DROCJITSU_ENABLE_VFIO=ON -DROCJITSU_SYSTEM_CTS_DIR="$CORPUS/corpus/system-cts"
cmake --build "$BUILD" --target rocjitsu_bin rocjitsu_shared vfio_system_cts
ctest --test-dir "$BUILD/tests/system-cts" --no-tests=error --output-on-failure
```
