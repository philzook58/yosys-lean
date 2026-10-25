# Build and test

Prerequisites for the default build: a C++20 compiler, CMake >= 3.28, Flex, Bison,
and Python >= 3.10. Tests additionally require Lean/Lake, Z3, and Icarus Verilog
(`iverilog`, `vvp`). Optional Verilator enables the original Ibex SystemVerilog
replay; otherwise tests explicitly report that check as skipped. sv2v is only needed
to regenerate the checked-in Ibex conversion, not for normal builds or tests. CMake downloads and builds the pinned Yosys and its library
submodules as a separate `ExternalProject`, without ABC or Slang. It does not
patch Yosys. Downloads and build artifacts stay under the build directory.

```sh
cmake -S . -B build
cmake --build build -j3
ctest --test-dir build --output-on-failure
```

Yosys is pinned to `3718f7f135dc25381c50f18e550bdc5f48663ec3` (0.70+186),
Lean to `leanprover/lean4:v4.35.0`. Native Yosys is required for C++ plugins;
the WASM distribution is not the build target. The plugin must be built using
the same Yosys headers and ABI as its host. The extra source include path is
needed because the pinned Yosys development-header bundle omits
`kernel/functional.h`. A matching existing checkout can be supplied with
`-DYOSYS_SOURCE_DIR=/path/to/yosys`; CMake then builds that checkout without
downloading or updating it. `YOSYS_BUILD_JOBS` controls the separate dependency
build's parallelism (default 3).

To use an existing native Yosys installation/build instead of fetching one:

```sh
cmake -S . -B build-local -DYOSYS_LEAN_BUILD_YOSYS=OFF \
  -DYOSYS_EXECUTABLE=/path/to/yosys -DYOSYS_CONFIG=/path/to/yosys-config \
  -DYOSYS_SOURCE_DIR=/path/to/matching/source
cmake --build build-local
```

Use `-DBUILD_TESTING=OFF` for a plugin-only build with no Lean, Z3, or Icarus
discovery. The dependency source override must already have its library
submodules populated; automatic downloads handle that in the default mode.

After source edits:

```sh
cmake --build build
ctest --test-dir build --output-on-failure
```

GitHub Actions builds on Ubuntu 24.04 and runs both CTest suites, including
Verilator replay. Yosys and Lean use the project pins; CI uses Z3 4.13.4.
`YOSYS_LEAN_TEST_TIMEOUT` controls each whole regression suite deadline
(default 900 seconds; CI allows 1800). Individual Lean checks keep their existing
memory limits and 120-second deadline. Failure logs are uploaded as CI artifacts.
