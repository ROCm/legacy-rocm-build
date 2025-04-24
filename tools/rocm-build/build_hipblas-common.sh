#!/bin/bash

set -ex

source "$(dirname "${BASH_SOURCE[0]}")/compute_utils.sh"

set_component_src hipBLAS-common

build_hipblas-common() {
    echo "Start build"

    CXX=$(set_build_variables __C_++__)
    cd $COMPONENT_SRC
    mkdir -p "$BUILD_DIR" && cd "$BUILD_DIR"

    echo "C compiler: $CC"
    echo "CXX compiler: $CXX"
    init_rocm_common_cmake_params
    cmake \
        "${rocm_math_common_cmake_params[@]}" \
        "$COMPONENT_SRC"
    cmake --build "$BUILD_DIR" -- install
    cmake --build "$BUILD_DIR" -- package

    rm -rf _CPack_Packages/ && find -name '*.o' -delete
    copy_if "${PKGTYPE}" "${CPACKGEN:-"DEB;RPM"}" "${PACKAGE_DIR}" "${BUILD_DIR}"/*."${PKGTYPE}"
    show_build_cache_stats
}

clean_hipblas-common() {
    echo "Cleaning hipBLAS-common build directory: ${BUILD_DIR} ${PACKAGE_DIR}"
    rm -rf "$BUILD_DIR" "$PACKAGE_DIR"
    echo "Done!"
}

stage2_command_args "$@"

case $TARGET in
    build) build_hipblas-common; build_wheel ;;
    outdir) print_output_directory ;;
    clean) clean_hipblas-common ;;
    *) die "Invalid target $TARGET" ;;
esac
