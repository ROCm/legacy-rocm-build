#!/bin/bash

set -ex
source "$(dirname "${BASH_SOURCE[0]}")/compute_utils.sh"

set_component_src rocWMMA

build_rocwmma() {
    echo "Start build"

    if [ "${ENABLE_STATIC_BUILDS}" == "true" ]; then
        ack_and_skip_static
    fi

    # To check if rocwmma source is present
    if [ ! -e $COMPONENT_SRC/CMakeLists.txt ]; then
        echo "Skipping rocWMMA as source is not available"
        mkdir -p $COMPONENT_SRC
        exit 0
    fi

    if [ "${ENABLE_ADDRESS_SANITIZER}" == "true" ]; then
         set_asan_env_vars
         set_address_sanitizer_on
         # ASAN packaging is not required for rocWMMA, since its header only package
         # Setting the asan_cmake_params to false will disable ASAN packaging
         ASAN_CMAKE_PARAMS="false"
    fi
    mkdir -p $BUILD_DIR && cd $BUILD_DIR

    init_rocm_common_cmake_params
    CXX=$(set_build_variables __CXX__)\
    cmake \
        "${rocm_math_common_cmake_params[@]}" \
        ${LAUNCHER_FLAGS} \
        -DROCWMMA_BUILD_VALIDATION_TESTS=ON \
        -DROCWMMA_VALIDATE_WITH_ROCBLAS=ON \
        -DROCWMMA_BUILD_BENCHMARK_TESTS=ON \
        -DROCWMMA_BENCHMARK_WITH_ROCBLAS=ON \
        "$COMPONENT_SRC"

    cmake --build "$BUILD_DIR" -- -j${PROC}
    cmake --build "$BUILD_DIR" -- install
    cmake --build "$BUILD_DIR" -- package

    rm -rf _CPack_Packages/ && find -name '*.o' -delete
    copy_if "${PKGTYPE}" "${CPACKGEN:-"DEB;RPM"}" "${PACKAGE_DIR}" "${BUILD_DIR}"/*."${PKGTYPE}"
    show_build_cache_stats
}

clean_rocwmma() {
    echo "Cleaning rocWMMA build directory: ${BUILD_DIR} ${PACKAGE_DIR}"
    rm -rf "$BUILD_DIR" "$PACKAGE_DIR"
    echo "Done!"
}

stage2_command_args "$@"

case $TARGET in
    build) build_rocwmma; build_wheel ;;
    outdir) print_output_directory ;;
    clean) clean_rocwmma ;;
    *) die "Invalid target $TARGET" ;;
esac
