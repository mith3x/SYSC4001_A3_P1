#!/usr/bin/env bash
set -euo pipefail

# build.sh - simple build helper for the interrupts simulator
# Usage:
#   ./build.sh            # builds all executables into ./bin
#   CXX=clang++ ./build.sh # use different compiler

CXX=${CXX:-g++}
CXXFLAGS=${CXXFLAGS:--std=c++17 -Wall -Wextra}
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "$ROOT_DIR/bin"

echo "Using compiler: $CXX"
echo "Compiler flags: $CXXFLAGS"

compile() {
  local src="$1"
  local out="$2"
  if [ ! -f "$src" ]; then
    echo "Warning: source file '$src' not found, skipping $out"
    return
  fi
  echo "Compiling $(basename "$src") -> $(basename "$out")"
  "$CXX" $CXXFLAGS "$src" -o "$out"
}

compile "$ROOT_DIR/interrupts_101262467_101236818_EP.cpp" "$ROOT_DIR/bin/interrupts_EP.exe"
compile "$ROOT_DIR/interrupts_101262467_101236818_RR.cpp" "$ROOT_DIR/bin/interrupts_RR.exe"
compile "$ROOT_DIR/interrupts_101262467_101236818_EP_RR.cpp" "$ROOT_DIR/bin/interrupts_EP_RR.exe"

echo "Build complete. Binaries are in: $ROOT_DIR/bin"
echo "Example: ./bin/interrupts_EP.exe input_files/test1.txt"

exit 0
