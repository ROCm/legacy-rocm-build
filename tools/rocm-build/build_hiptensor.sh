#!/bin/bash

set -ex

source "$(dirname "${BASH_SOURCE[0]}")/compute_utils.sh"

set_component_src hipTensor
disable_debug_package_generation

build_hiptensor() {
    echo "Start build hipTensor"

    if [ "${ENABLE_STATIC_BUILDS}" == "true" ]; then
        ack_and_skip_static
    fi

    if [ "${ENABLE_ADDRESS_SANITIZER}" == "true" ]; then
        set_asan_env_vars
        set_address_sanitizer_on
    fi

    cd "$COMPONENT_SRC"
    mkdir -p "$BUILD_DIR" && cd "$BUILD_DIR"
    init_rocm_common_cmake_params

    cmake \
        -B "${BUILD_DIR}" \
        "${rocm_math_common_cmake_params[@]}" \
        "$(set_build_variables __CMAKE_CC_PARAMS__)" \
        "$(set_build_variables __CMAKE_CXX_PARAMS__)" \
        ${LAUNCHER_FLAGS} \
        "$COMPONENT_SRC"

    cmake --build "$BUILD_DIR" -- -j${PROC}
    cmake --build "$BUILD_DIR" -- install
    cmake --build "$BUILD_DIR" -- package

    rm -rf _CPack_Packages/ && find -name '*.o' -delete
    copy_if "${PKGTYPE}" "${CPACKGEN:-"DEB;RPM"}" "${PACKAGE_DIR}" "${BUILD_DIR}"/*."${PKGTYPE}"

    show_build_cache_stats
}

clean_hiptensor() {
    echo "Cleaning hipTensor build directory: ${BUILD_DIR} ${PACKAGE_DIR}"
    rm -rf "$BUILD_DIR" "$PACKAGE_DIR"
    echo "Done!"
}

stage2_command_args "$@"

case $TARGET in
    build) build_hiptensor; build_wheel ;;
    outdir) print_output_directory ;;
    clean) clean_hiptensor ;;
    *) die "Invalid target $TARGET" ;;
esac
