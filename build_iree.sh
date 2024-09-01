#!/bin/bash

set -eux -o errtrace

this_dir="$(cd $(dirname $0) && pwd)"
repo_root="$(cd $this_dir && pwd)"
iree_dir="$(cd $repo_root/deps/iree && pwd)"
build_dir="$repo_root/iree-build"
install_dir="$repo_root/iree-install"
mkdir -p "$build_dir"
build_dir="$(cd $build_dir && pwd)"
cache_dir="${cache_dir:-}"

# Setup cache dir.
if [ -z "${cache_dir}" ]; then
  cache_dir="${repo_root}/.build-cache"
  mkdir -p "${cache_dir}"
  cache_dir="$(cd ${cache_dir} && pwd)"
fi
echo "Caching to ${cache_dir}"
mkdir -p "${cache_dir}/ccache"
mkdir -p "${cache_dir}/pip"

python="$(which python)"
echo "Using python: $python"

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  export CC=clang
  export CXX=clang++
  export CCACHE_COMPILERCHECK="string:$(clang --version)"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  export CCACHE_COMPILERCHECK="string:$(clang --version)"
elif [[ "$OSTYPE" == "msys"* ]]; then
  export CC=clang-cl.exe
  export CXX=clang-cl.exe
  export CCACHE_COMPILERCHECK="string:$(clang-cl.exe --version)"
fi

export CCACHE_DIR="${cache_dir}/ccache"
export CCACHE_MAXSIZE="700M"
export CMAKE_C_COMPILER_LAUNCHER=ccache
export CMAKE_CXX_COMPILER_LAUNCHER=ccache
export CCACHE_SLOPPINESS=include_file_ctime,include_file_mtime,time_macros

# Clear ccache stats.
ccache -z

cd $iree_dir
CMAKE_ARGS="\
  -GNinja \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=$install_dir \
  -DCMAKE_INSTALL_LIBDIR=lib \
  -DIREE_ERROR_ON_MISSING_SUBMODULES=OFF \
  -DIREE_ENABLE_ASSERTIONS=ON \
  -DIREE_BUILD_SAMPLES=OFF \
  -DIREE_BUILD_PYTHON_BINDINGS=ON \
  -DIREE_BUILD_BINDINGS_TFLITE=OFF \
  -DIREE_HAL_DRIVER_DEFAULTS=OFF \
  -DIREE_HAL_DRIVER_LOCAL_SYNC=ON \
  -DIREE_HAL_DRIVER_LOCAL_TASK=ON \
  -DIREE_TARGET_BACKEND_DEFAULTS=OFF \
  -DIREE_TARGET_BACKEND_LLVM_CPU=ON \
  -DIREE_INPUT_TOSA=OFF \
  -DIREE_INPUT_STABLEHLO=OFF \
  -DIREE_INPUT_TORCH=OFF \
  -DCMAKE_OBJECT_PATH_MAX=4096"

if [[ "$OSTYPE" != "darwin"* ]]; then
  cmake $CMAKE_ARGS \
    -DCMAKE_EXE_LINKER_FLAGS_INIT="-fuse-ld=lld" \
    -DCMAKE_SHARED_LINKER_FLAGS_INIT="-fuse-ld=lld" \
    -DCMAKE_MODULE_LINKER_FLAGS_INIT="-fuse-ld=lld" \
    -DCMAKE_C_COMPILER="${CC}" \
    -DCMAKE_CXX_COMPILER="${CXX}" \
    -DLLVM_TARGET_ARCH=X86 \
    -DLLVM_TARGETS_TO_BUILD=X86 \
    -S $iree_dir -B $build_dir
else
  cmake $CMAKE_ARGS \
    -S $iree_dir -B $build_dir
fi

echo "Building all"
echo "------------"
cmake --build "$build_dir" -- -k 0

echo "Installing"
echo "----------"
echo "Install to: $install_dir"
cmake --build "$build_dir" --target iree-install-dist

