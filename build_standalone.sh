#!/bin/bash

set -eux -o errtrace

this_dir="$(cd $(dirname $0) && pwd)"
repo_root="$(cd $this_dir && pwd)"
iree_install_dir="$repo_root/iree-install"
mlir_install_dir="$repo_root/mlir"
build_dir="$repo_root/build"


CMAKE_ARGS="\
  -GNinja \
  -DMLIR_DIR=$mlir_install_dir/lib/cmake/mlir \
  -DIREECompiler_DIR=$iree_install_dir/lib/cmake/IREE \
  -DIREERuntime_DIR=$iree_install_dir/lib/cmake/IREE \
  -DCMAKE_BUILD_TYPE=Release \
  -DIREE_ENABLE_ASSERTIONS=ON"

cmake $CMAKE_ARGS \
  -S $repo_root -B $build_dir

echo "Building all"
echo "------------"
cmake --build "$build_dir" -- -k 0
