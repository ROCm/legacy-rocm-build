#!/bin/bash

set -ex
source "$(dirname "${BASH_SOURCE[0]}")/compute_utils.sh"

PATH=${ROCM_PATH}/bin:$PATH
set_component_src rocFFT

build_rocfft() {
    echo "Start Build"

    if [ "${ENABLE_STATIC_BUILDS}" == "true" ]; then
        ack_and_skip_static
    fi

    cd $COMPONENT_SRC

    if [ "${ENABLE_ADDRESS_SANITIZER}" == "true" ]; then
         set_asan_env_vars
         set_address_sanitizer_on
    fi
    mkdir -p "$BUILD_DIR" && cd "$BUILD_DIR"
    init_rocm_common_cmake_params

    #Removed GPU ARCHS from here as it will be part of compute_utils.sh ROCMOPS-7302 & ROCMOPS-8091

    # Work around for HIP sources with C++ suffix, and force CXXFLAGS for both
    # HIP and C++ compiles
    CXX=$(set_build_variables __HIP_CC__) \
    cmake \
        ${LAUNCHER_FLAGS} \
        "${rocm_math_common_cmake_params[@]}" \
        -DUSE_HIP_CLANG=ON \
        -DHIP_COMPILER=clang  \
        -DBUILD_CLIENTS_SAMPLES=ON  \
        -DBUILD_CLIENTS_TESTS=ON \
        -DBUILD_CLIENTS_RIDER=ON  \
        "$COMPONENT_SRC"

    cmake --build "$BUILD_DIR" -- -j${PROC}
    cmake --build "$BUILD_DIR" -- install
    cmake --build "$BUILD_DIR" -- package

    rm -rf _CPack_Packages/ && find -name '*.o' -delete
    copy_if "${PKGTYPE}" "${CPACKGEN:-"DEB;RPM"}" "${PACKAGE_DIR}" "${BUILD_DIR}"/*."${PKGTYPE}"

    show_build_cache_stats
}

clean_rocfft() {
    echo "Cleaning rocFFT build directory: ${BUILD_DIR} ${PACKAGE_DIR}"
    rm -rf "$BUILD_DIR" "$PACKAGE_DIR"
    echo "Done!"
}

stage2_command_args "$@"

case $TARGET in
    build) build_rocfft; build_wheel ;;
    outdir) print_output_directory ;;
    clean) clean_rocfft ;;
    *) die "Invalid target $TARGET" ;;
esac
