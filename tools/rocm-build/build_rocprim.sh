#!/bin/bash

set -ex

source "$(dirname "${BASH_SOURCE[0]}")/compute_utils.sh"

set_component_src rocPRIM

build_rocprim() {
    echo "Start build"

    cd $COMPONENT_SRC
    #  Temporary Fix as suggested in #SWDEV-314510
    if [ "${ENABLE_ADDRESS_SANITIZER}" == "true" ]; then
       #Set ASAN flags
       set_asan_env_vars
       set_address_sanitizer_on
       # ASAN packaging is not required for rocPRIM, since its header only package
       # Setting the asan_cmake_params to false will disable ASAN packaging
       ASAN_CMAKE_PARAMS="false"
    fi

    # Enable/Disable Static Flag to be used for
    # Package Dependecies during static/non-static builds
    SHARED_LIBS="ON"
    if [ "${ENABLE_STATIC_BUILDS}" == "true" ]; then
        SHARED_LIBS="OFF"
    fi

    mkdir -p "$BUILD_DIR" && cd "$BUILD_DIR"

    #Removed GPU ARCHS from here as it will be part of compute_utils.sh ROCMOPS-7302 & ROCMOPS-8091

    init_rocm_common_cmake_params
    CXX=$(set_build_variables __HIP_CC__) \
    cmake \
        ${LAUNCHER_FLAGS} \
        "${rocm_math_common_cmake_params[@]}" \
        -DBUILD_BENCHMARK=OFF \
        -DBUILD_TEST=ON \
        -DBUILD_SHARED_LIBS=$SHARED_LIBS \
        -DCMAKE_MODULE_PATH="${ROCM_PATH}/lib/cmake/hip;${ROCM_PATH}/hip/cmake" \
        "$COMPONENT_SRC"

    cmake --build "$BUILD_DIR" -- -j${PROC}
    cmake --build "$BUILD_DIR" -- install
    cmake --build "$BUILD_DIR" -- package

    rm -rf _CPack_Packages/ && find -name '*.o' -delete
    copy_if "${PKGTYPE}" "${CPACKGEN:-"DEB;RPM"}" "${PACKAGE_DIR}" "${BUILD_DIR}"/*."${PKGTYPE}"

    show_build_cache_stats
}

clean_rocprim() {
    echo "Cleaning rocPRIM build directory: ${BUILD_DIR} ${PACKAGE_DIR}"
    rm -rf "$BUILD_DIR" "$PACKAGE_DIR"
    echo "Done!"
}

stage2_command_args "$@"

case $TARGET in
    build) build_rocprim; build_wheel ;;
    outdir) print_output_directory ;;
    clean) clean_rocprim ;;
    *) die "Invalid target $TARGET" ;;
esac
