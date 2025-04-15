#!/bin/bash

set -ex

source "$(dirname "${BASH_SOURCE[0]}")/compute_utils.sh"

set_component_src rocBLAS
DEPS_DIR=${HOME}/rocblas

stage2_command_args "$@"
disable_debug_package_generation

build_rocblas() {
    echo "Start build"

    SHARED_LIBS="ON"
    if [ "${ENABLE_STATIC_BUILDS}" == "true" ]; then
        SHARED_LIBS="OFF"
    fi

    #Removed GPU ARCHS from here as it will be part of compute_utils.sh ROCMOPS-7302 & ROCMOPS-8091
    # Temporary workaround for rocBLAS to build with ASAN as suggested in #SWDEV-314505
    if [ "${ENABLE_ADDRESS_SANITIZER}" == "true" ]; then
        set_asan_env_vars
        set_address_sanitizer_on
        export ASAN_OPTIONS="detect_leaks=0:verify_asan_link_order=0"
        # updating GPU_ARCHS for ASAN build to supported gpu arch only SWDEV-479178
        #GPU_ARCHS="gfx90a:xnack+;gfx942:xnack+" #This will be part of compute_utils.sh ROCMOPS-7302 & ROCMOPS-8091
    fi
    LAZY_LOADING=ON
    SEPARATE_ARCHES=ON
    cd $COMPONENT_SRC

    CXX=$(set_build_variables __AMD_CLANG_++__)
    mkdir -p $DEPS_DIR && cp -r /usr/blis $DEPS_DIR
    mkdir -p "$BUILD_DIR" && cd "$BUILD_DIR"

    # if ENABLE_GPU_ARCH is set in env by Job parameter ENABLE_GPU_ARCH, then set GFX_ARCH to that value. This will override any of the case values above
    if [ -n "$ENABLE_GPU_ARCH" ]; then
        #setting gfx arch as part of rocm_common_cmake_params
        set_gpu_arch "${ENABLE_GPU_ARCH}"
    fi

    echo "C compiler: $CC"
    echo "CXX compiler: $CXX"

    init_rocm_common_cmake_params
    cmake \
        -DCMAKE_TOOLCHAIN_FILE=toolchain-linux.cmake \
        -DBUILD_DIR="${BUILD_DIR}" \
        "${rocm_math_common_cmake_params[@]}" \
        -DROCM_DIR="${ROCM_PATH}" \
        ${LAUNCHER_FLAGS} \
        -DBUILD_SHARED_LIBS=$SHARED_LIBS \
        -DCMAKE_PREFIX_PATH="${DEPS_DIR};${ROCM_PATH}" \
        -DBUILD_CLIENTS_TESTS=ON \
        -DBUILD_CLIENTS_BENCHMARKS=ON \
        -DBUILD_CLIENTS_SAMPLES=ON \
        -DLINK_BLIS=ON \
        -DTensile_CODE_OBJECT_VERSION=default \
        -DTensile_LOGIC=asm_full \
        -DTensile_SEPARATE_ARCHITECTURES="${SEPARATE_ARCHES}" \
        -DTensile_LAZY_LIBRARY_LOADING="${LAZY_LOADING}" \
        -DTensile_LIBRARY_FORMAT=msgpack \
        -DBUILD_ADDRESS_SANITIZER="${ADDRESS_SANITIZER}" \
        -DTENSILE_VENV_UPGRADE_PIP=ON \
        "$COMPONENT_SRC"

    cmake --build "$BUILD_DIR" -- -j${PROC}
    cmake --build "$BUILD_DIR" -- install
    cmake --build "$BUILD_DIR" -- package

    rm -rf _CPack_Packages/ && rm -rf ./library/src/build_tmp && find -name '*.o' -delete

    copy_if "${PKGTYPE}" "${CPACKGEN:-"DEB;RPM"}" "${PACKAGE_DIR}" "${BUILD_DIR}"/*."${PKGTYPE}"

    show_build_cache_stats
}

clean_rocblas() {
    echo "Cleaning rocBLAS build directory: ${BUILD_DIR} ${PACKAGE_DIR}"
    rm -rf "$BUILD_DIR" "$PACKAGE_DIR"
    echo "Done!"
}

case $TARGET in
    build) build_rocblas; build_wheel ;;
    outdir) print_output_directory ;;
    clean) clean_rocblas ;;
    *) die "Invalid target $TARGET" ;;
esac
