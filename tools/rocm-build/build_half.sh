#!/bin/bash

set -ex
source "$(dirname "${BASH_SOURCE[0]}")/compute_utils.sh"

set_component_src half

build_half() {
    echo "Start build"

    if [ "${ENABLE_STATIC_BUILDS}" == "true" ]; then
        ack_and_skip_static
    fi

    if [ "${ENABLE_ADDRESS_SANITIZER}" == "true" ]; then
         set_asan_env_vars
         set_address_sanitizer_on
         # ASAN packaging is not required for HALF, since its header only package
         # Setting the asan_cmake_params to false will disable ASAN packaging
         ASAN_CMAKE_PARAMS="false"
    fi
    mkdir -p "$BUILD_DIR" && cd "$BUILD_DIR"

    cmake \
        -DCMAKE_INSTALL_PREFIX="$ROCM_PATH" \
        -DCPACK_PACKAGING_INSTALL_PREFIX=${ROCM_PATH}\
        -DCPACK_SET_DESTDIR="OFF" \
        -DCPACK_RPM_PACKAGE_RELOCATABLE="ON" \
        -DBUILD_FILE_REORG_BACKWARD_COMPATIBILITY=OFF \
        "$COMPONENT_SRC"

    cmake --build "$BUILD_DIR" -- -j${PROC}
    cmake --build "$BUILD_DIR" -- package
    cmake --build "$BUILD_DIR" -- install

    rm -rf _CPack_Packages/ && find -name '*.o' -delete
    copy_if "${PKGTYPE}" "${CPACKGEN:-"DEB;RPM"}" "${PACKAGE_DIR}" "${BUILD_DIR}"/*."${PKGTYPE}"

    show_build_cache_stats
}

clean_half() {
    echo "Cleaning half build directory: ${BUILD_DIR} ${PACKAGE_DIR}"
    rm -rf "$BUILD_DIR" "$PACKAGE_DIR"
    echo "Done!"
}

stage2_command_args "$@"

case $TARGET in
    build) build_half; build_wheel ;;
    outdir) print_output_directory ;;
    clean) clean_half ;;
    *) die "Invalid target $TARGET" ;;
esac
