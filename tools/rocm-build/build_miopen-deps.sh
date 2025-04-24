#!/bin/bash

set -ex
source "$(dirname "${BASH_SOURCE[0]}")/compute_utils.sh"

set_component_src MIOpen

build_miopen_mlir() {
    echo "Building rocMLIR"
    mlir_commit="$1"
    if [ -z "$mlir_commit" ]; then
        echo "rocMLIR entry was not found in requirements.txt"
        return
    fi
    mkdir -p /var/tmp/rocMLIR && cd /var/tmp/rocMLIR
    wget -nv "https://www.github.com/ROCmSoftwarePlatform/rocMLIR/archive/${mlir_commit}.tar.gz"
    tar -xzf "${mlir_commit}.tar.gz"
    cd "rocMLIR-${mlir_commit}"
    mkdir build && cd build
    cmake \
        -G Ninja \
        -DCMAKE_C_COMPILER="$(set_build_variables __CLANG__)" \
        -DCMAKE_CXX_COMPILER="$(set_build_variables __CLANG++__)" \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_PREFIX_PATH="${ROCM_PATH};${HOME}/miopen-deps" \
        -DCMAKE_INSTALL_PREFIX="$ROCM_PATH" \
        -DBUILD_FAT_LIBROCKCOMPILER=1 \
        ..
    cmake --build . -- librockCompiler -j${PROC}
    cmake --build . -- install

    rm -rf _CPack_Packages/ && find -name '*.o' -delete
    
    echo "Finished building rocMLIR"
}

clean_miopen_mlir() {
    echo "Cleaning rocMLIR"
    rm -rf /var/tmp/rocMLIR
}

build_miopen_deps() {
    echo "Start build"
    cd "$COMPONENT_SRC"

    # Commenting the rocMLIR & composable_kernel from requirements.txt
    sed -i '/ROCm\/rocMLIR@\|ROCm\/composable_kernel@/s/^/#/' requirements.txt
    # Extract MLIR commit from requirements.txt
    MLIR_COMMIT="$(awk '/rocMLIR/ {split($1, s, "@"); print s[2]}' requirements.txt)"


    pip3 install https://github.com/RadeonOpenCompute/rbuild/archive/master.tar.gz
    PATH="${PATH}:${ROCM_PATH}:${HOME}/.local/bin" rbuild prepare -d "$HOME/miopen-deps" --cxx="$(set_build_variables __CLANG++__)" --cc "$(set_build_variables __CLANG__)"
    build_miopen_mlir "$MLIR_COMMIT"

    show_build_cache_stats
}

clean_miopen_deps() {
    echo "Cleaning MIOpen-Deps build directory: ${BUILD_DIR}"
    rm -rf "$BUILD_DIR"
    clean_miopen_mlir
    echo "Done!"
}

stage2_command_args "$@"

case $TARGET in
    build) build_miopen_deps ;;
    outdir) ;;
    clean) clean_miopen_deps ;;
    *) die "Invalid target $TARGET" ;;
esac
