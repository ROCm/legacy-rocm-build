#!/bin/bash

set -ex
source "$(dirname "${BASH_SOURCE[0]}")/compute_utils.sh"

set_component_src MIVisionX
BUILD_DEV=ON

build_mivisionx() {

    if [ "$DISTRO_ID" = "mariner-2.0" ] || [ "$DISTRO_ID" = "azurelinux-3.0" ] ; then
        echo "Not building mivisionx for ${DISTRO_ID}. Exiting..."
        return 0
    fi

    echo "Start build"

    if [ "${ENABLE_STATIC_BUILDS}" == "true" ]; then
        ack_and_skip_static
    fi

    CXX=$(set_build_variables __AMD_CLANG_++__)
    mkdir -p $BUILD_DIR && cd $BUILD_DIR
    if [ "${ENABLE_ADDRESS_SANITIZER}" == "true" ]; then
       set_asan_env_vars
       set_address_sanitizer_on
       # Setting BUILD_DEV to OFF. This will prevent the installation of
       # header files, other files in share,libexec folder. ASAN pkg doesn't need this
       BUILD_DEV=OFF
    fi

    echo "C compiler: $CC"
    echo "CXX compiler: $CXX"

    init_rocm_common_cmake_params

    cmake \
        "${rocm_math_common_cmake_params[@]}" \
        -DROCM_PATH="$ROCM_PATH" \
        -DBUILD_DEV=$BUILD_DEV \
        -DCMAKE_INSTALL_LIBDIR=$(getInstallLibDir) \
        -DROCM_DEP_ROCMCORE=ON \
        -DROCAL_PYTHON=OFF \
        ${LAUNCHER_FLAGS} \
        "$COMPONENT_SRC"

    cmake --build "$BUILD_DIR" -- -j${PROC}
    cmake --build "$BUILD_DIR" -- install
    cpack -G ${PKGTYPE^^}

    rm -rf _CPack_Packages/ && find -name '*.o' -delete
    copy_if "${PKGTYPE}" "${CPACKGEN:-"DEB;RPM"}" "${PACKAGE_DIR}" "${BUILD_DIR}"/*."${PKGTYPE}"

    show_build_cache_stats
}

clean_mivisionx() {
    echo "Cleaning MIVisionX build directory: ${BUILD_DIR} ${PACKAGE_DIR}"
    rm -rf "$BUILD_DIR" "$PACKAGE_DIR"
    echo "Done!"
}

stage2_command_args "$@"

case $TARGET in
    build) build_mivisionx; build_wheel ;;
    outdir) print_output_directory ;;
    clean) clean_mivisionx ;;
    *) die "Invalid target $TARGET" ;;
esac
