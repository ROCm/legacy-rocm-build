#!/bin/bash

set -ex

source "$(dirname "${BASH_SOURCE[0]}")/compute_utils.sh"

set_component_src hipFFT

build_hipfft() {
    echo "Start build"

    if [ "${ENABLE_STATIC_BUILDS}" == "true" ]; then
        ack_and_skip_static
    fi

    if [ "${ENABLE_ADDRESS_SANITIZER}" == "true" ]; then
       set_asan_env_vars
       set_address_sanitizer_on
    fi

    cd $COMPONENT_SRC
    mkdir -p "$BUILD_DIR" && cd "$BUILD_DIR"
    init_rocm_common_cmake_params

    cmake \
        "$(set_build_variables __CMAKE_CXX_PARAMS__)" \
        ${LAUNCHER_FLAGS} \
	    "${rocm_math_common_cmake_params[@]}" \
        -DCMAKE_MODULE_PATH="${ROCM_PATH}/lib/cmake/hip" \
        -DCMAKE_SKIP_BUILD_RPATH=TRUE \
        -DBUILD_ADDRESS_SANITIZER="${ADDRESS_SANITIZER}" \
        -DBUILD_CLIENTS_TESTS=ON \
        -DBUILD_CLIENTS_SAMPLES=ON \
        -L \
        "$COMPONENT_SRC"

    cmake --build "$BUILD_DIR" -- -j${PROC}
    cmake --build "$BUILD_DIR" -- package

    rm -rf _CPack_Packages/ && find -name '*.o' -delete
    copy_if "${PKGTYPE}" "${CPACKGEN:-"DEB;RPM"}" "${PACKAGE_DIR}" "${BUILD_DIR}"/*."${PKGTYPE}"

    show_build_cache_stats
}

clean_hipfft() {
    echo "Cleaning hipFFT build directory: ${BUILD_DIR} ${PACKAGE_DIR}"
    rm -rf "$BUILD_DIR" "$PACKAGE_DIR"
    echo "Done!"
}

stage2_command_args "$@"

case $TARGET in
    build) build_hipfft; build_wheel ;;
    outdir) print_output_directory ;;
    clean) clean_hipfft ;;
    *) die "Invalid target $TARGET" ;;
esac
