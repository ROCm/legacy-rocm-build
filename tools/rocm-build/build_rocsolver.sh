#!/bin/bash

set -ex

source "$(dirname "${BASH_SOURCE[0]}")/compute_utils.sh"

set_component_src rocSOLVER

build_rocsolver() {
    echo "Start build"

    SHARED_LIBS="ON"

    if [ "${ENABLE_STATIC_BUILDS}" == "true" ]; then
        SHARED_LIBS="OFF"
    fi

    EXTRA_TESTS="ON"
    if [ "${ENABLE_ADDRESS_SANITIZER}" == "true" ]; then
        set_asan_env_vars
        set_address_sanitizer_on
        rebuild_lapack
        EXTRA_TESTS="OFF"
        # updating GPU_ARCHS for ASAN build to supported gpu arch only SWDEV-479178
        #GPU_ARCHS="gfx90a:xnack+;gfx942:xnack+"#This will be part of compute_utils.sh ROCMOPS-7302 & ROCMOPS-8091
    fi
    cd $COMPONENT_SRC

    mkdir -p "$BUILD_DIR" && cd "$BUILD_DIR"

    # if ENABLE_GPU_ARCH is set in env by Job parameter ENABLE_GPU_ARCH, then set GFX_ARCH to that value. This will override any of the case values above
    if [ -n "$ENABLE_GPU_ARCH" ]; then
        #setting gfx arch as part of rocm_common_cmake_params
        set_gpu_arch "${ENABLE_GPU_ARCH}"
    fi

    init_rocm_common_cmake_params
    CXX=$(set_build_variables __HIP_CC__) \
    cmake \
        ${LAUNCHER_FLAGS} \
        "${rocm_math_common_cmake_params[@]}" \
        -DBUILD_SHARED_LIBS=$SHARED_LIBS \
        -Drocblas_DIR="${ROCM_PATH}/rocblas/lib/cmake/rocblas" \
        -DBUILD_CLIENTS_TESTS=ON \
        -DBUILD_ADDRESS_SANITIZER="${ADDRESS_SANITIZER}" \
        -DBUILD_CLIENTS_BENCHMARKS=ON \
        -DBUILD_CLIENTS_SAMPLES=ON \
        -DBUILD_TESTING=ON \
        -DBUILD_CLIENTS_EXTRA_TESTS="${EXTRA_TESTS}" \
        "$COMPONENT_SRC"

    cmake --build "$BUILD_DIR" -- -j${PROC}
    cmake --build "$BUILD_DIR" -- install
    cmake --build "$BUILD_DIR" -- package

    rm -rf _CPack_Packages/ && find -name '*.o' -delete
    mkdir $PACKAGE_DIR && cp ${BUILD_DIR}/*.${PKGTYPE} $PACKAGE_DIR

    show_build_cache_stats
}

clean_rocsolver() {
    echo "Cleaning rocSOLVER build directory: ${BUILD_DIR} ${PACKAGE_DIR}"
    rm -rf "$BUILD_DIR" "$PACKAGE_DIR"
    echo "Done!"
}

stage2_command_args "$@"

case $TARGET in
    build) build_rocsolver; build_wheel ;;
    outdir) print_output_directory ;;
    clean) clean_rocsolver ;;
    *) die "Invalid target $TARGET" ;;
esac
