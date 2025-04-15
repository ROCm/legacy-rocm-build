#!/bin/bash

set -ex
source "$(dirname "${BASH_SOURCE[0]}")/compute_utils.sh"

PATH=${ROCM_PATH}/bin:$PATH
set_component_src rocSPARSE

build_rocsparse() {
    echo "Start build"
    cd $COMPONENT_SRC
    if [ "${ENABLE_ADDRESS_SANITIZER}" == "true" ]; then
        set_asan_env_vars
        set_address_sanitizer_on
        # updating GPU_ARCHS for ASAN build to supported gpu arch only SWDEV-479178
        #GPU_ARCHS="gfx90a:xnack+;gfx942:xnack+"#This will be part of compute_utils.sh ROCMOPS-7302 & ROCMOPS-8091
    fi
    SHARED_LIBS="ON"
    if [ "${ENABLE_STATIC_BUILDS}" == "true" ]; then
        SHARED_LIBS="OFF"
    fi

    MIRROR="http://compute-artifactory.amd.com/artifactory/list/rocm-generic-local/mathlib/sparse/"

    mkdir -p "$BUILD_DIR" && cd "$BUILD_DIR"

    # if ENABLE_GPU_ARCH is set in env by Job parameter ENABLE_GPU_ARCH, then set GFX_ARCH to that value. This will override any of the case values above
    if [ -n "$ENABLE_GPU_ARCH" ]; then
        #setting gfx arch as part of rocm_common_cmake_params
        set_gpu_arch "${ENABLE_GPU_ARCH}"
    fi

    init_rocm_common_cmake_params
    ROCSPARSE_TEST_MIRROR=$MIRROR \
    CXX=$(set_build_variables __CXX__)\
    CC=$(set_build_variables __CC__)\
    cmake \
        ${LAUNCHER_FLAGS} \
        "${rocm_math_common_cmake_params[@]}" \
        -DBUILD_SHARED_LIBS=$SHARED_LIBS \
        -DBUILD_CLIENTS_SAMPLES=ON \
        -DBUILD_CLIENTS_TESTS=ON \
        -DBUILD_CLIENTS_BENCHMARKS=ON \
        -DCMAKE_INSTALL_PREFIX=${ROCM_PATH} \
        -DBUILD_ADDRESS_SANITIZER="${ADDRESS_SANITIZER}" \
        -DCMAKE_MODULE_PATH="${ROCM_PATH}/lib/cmake/hip;${ROCM_PATH}/hip/cmake" \
        "$COMPONENT_SRC"

    cmake --build "$BUILD_DIR" -- -j${PROC}
    cmake --build "$BUILD_DIR" -- install
    cmake --build "$BUILD_DIR" -- package

    rm -rf _CPack_Packages/ && find -name '*.o' -delete
    copy_if "${PKGTYPE}" "${CPACKGEN:-"DEB;RPM"}" "${PACKAGE_DIR}" "${BUILD_DIR}"/*."${PKGTYPE}"

    show_build_cache_stats
}

clean_rocsparse() {
    echo "Cleaning rocSPARSE build directory: ${BUILD_DIR} ${PACKAGE_DIR}"
    rm -rf "$BUILD_DIR" "$PACKAGE_DIR"
    echo "Done!"
}

stage2_command_args "$@"

case $TARGET in
    build) build_rocsparse; build_wheel ;;
    outdir) print_output_directory ;;
    clean) clean_rocsparse ;;
    *) die "Invalid target $TARGET" ;;
esac
