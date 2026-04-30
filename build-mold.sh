#!/bin/bash

set -euxo pipefail

BUILD_CONFIG="${1:-"mold"}"
TIMESTAMP="${2:-"$(date +%s)"}"

export SOURCE_DATE_EPOCH="$TIMESTAMP"

cmake -S . -B build \
  -DCMAKE_BUILD_TYPE=Release \
  -DMOLD_MOSTLY_STATIC=ON \
  -DCMAKE_C_COMPILER=clang \
  -DCMAKE_CXX_COMPILER=clang++
cmake --build build -j "$(nproc)"
cmake --install build

cmake -S . -B build -DMOLD_USE_MOLD=ON
cmake --build build -j "$(nproc)"
cmake --install build --prefix "$BUILD_CONFIG" --strip

find "$BUILD_CONFIG" -exec \
  touch --no-dereference --date="@$TIMESTAMP" {} +
find "$BUILD_CONFIG" -print |
  sort |
  tar -cf - --no-recursion --files-from=- |
  gzip -9nc >"$BUILD_CONFIG.tar.gz"
rm -rf build "$BUILD_CONFIG"
