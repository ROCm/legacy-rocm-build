#!/bin/bash

set -ex

source "$(dirname "${BASH_SOURCE[0]}")/compute_utils.sh"

set_component_src TransferBench

build_transferbench() {
    echo "Start build"

    if [ "${ENABLE_STATIC_BUILDS}" == "true" ]; then
        ack_and_skip_static
    fi

    mkdir -p "$BUILD_DIR" && cd "$BUILD_DIR"
    init_rocm_common_cmake_params

    CXX=$(set_build_variables __HIP_CC__) \
    cmake "${rocm_math_common_cmake_params[@]}" "$COMPONENT_SRC"
    make package

    rm -rf _CPack_Packages/ && find -name '*.o' -delete
    copy_if "${PKGTYPE}" "${CPACKGEN:-"DEB;RPM"}" "${PACKAGE_DIR}" "${BUILD_DIR}"/*."${PKGTYPE}"
    show_build_cache_stats
}

clean_transferbench() {
    echo "Cleaning TransferBench build directory: ${BUILD_DIR} ${PACKAGE_DIR}"
    rm -rf "$BUILD_DIR" "$PACKAGE_DIR"
    echo "Done!"
}

stage2_command_args "$@"

case $TARGET in
    build) build_transferbench; build_wheel ;;
    outdir) print_output_directory ;;
    clean) clean_transferbench ;;
    *) die "Invalid target $TARGET" ;;
esac
