#!/bin/bash

set -ex
source "$(dirname "${BASH_SOURCE[0]}")/compute_utils.sh"

set_component_src hipBLASLt

#not enabling the debug files by defalut
disable_debug_package_generation
# if ENABLE_GPU_ARCH is set in env by Job parameter ENABLE_GPU_ARCH, then set GFX_ARCH to that value
if [ -n "$ENABLE_GPU_ARCH" ]; then
    set_gpu_arch "$ENABLE_GPU_ARCH"
else
    # gfx90a:xnack+;gfx90a:xnack-;gfx940;gfx941;gfx942
    set_gpu_arch "all"
fi

build_hipblaslt() {
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

    # hipblaslt requiring Python 3.12.
    # Point CMake to that explicit location and adjust LD_LIBRARY_PATH.
    if [ "$DISTRO_ID" = "rhel-8.8" ] || [ "$DISTRO_NAME" == "sles" ] || \
        [ "$DISTRO_ID" = "rhel-9.1" ] || [ "$DISTRO_ID" = "almalinux-8.10" ] || \
        [ "$DISTRO_ID" = "debian-10" ]; then
        EXTRA_PYTHON_PATH=/opt/Python-3.12.7
        EXTRA_CMAKE_OPTIONS="-DPython_ROOT=/opt/Python-3.12.7"
        export LD_LIBRARY_PATH=${EXTRA_PYTHON_PATH}/lib
    fi

    init_rocm_common_cmake_params
    CXX=$(set_build_variables __CXX__)\
    cmake \
        ${LAUNCHER_FLAGS} \
         "${rocm_math_common_cmake_params[@]}" \
        -DTensile_LOGIC= \
        -DTensile_CODE_OBJECT_VERSION=default \
        -DTensile_CPU_THREADS=$((PROC / 4)) \
        -DTensile_LIBRARY_FORMAT=msgpack \
        -DBUILD_CLIENTS_SAMPLES=ON \
        -DBUILD_CLIENTS_TESTS=ON \
        -DLINK_BLIS=ON \
        -DBUILD_CLIENTS_BENCHMARKS=ON \
        -DBUILD_ADDRESS_SANITIZER="${ADDRESS_SANITIZER}" \
        ${EXTRA_CMAKE_OPTIONS} \
        "$COMPONENT_SRC"

    cmake --build "$BUILD_DIR" -- -j${PROC}
    cmake --build "$BUILD_DIR" -- install
    cmake --build "$BUILD_DIR" -- package

    rm -rf _CPack_Packages/ && find -name '*.o' -delete
    copy_if "${PKGTYPE}" "${CPACKGEN:-"DEB;RPM"}" "${PACKAGE_DIR}" "${BUILD_DIR}"/*."${PKGTYPE}"
    show_build_cache_stats
}

clean_hipblaslt() {
    echo "Cleaning hipBLASLt build directory: ${BUILD_DIR} ${PACKAGE_DIR}"
    rm -rf "$BUILD_DIR" "$PACKAGE_DIR"
    echo "Done!"
}

stage2_command_args "$@"

case $TARGET in
    build) build_hipblaslt; build_wheel ;;
    outdir) print_output_directory ;;
    clean) clean_hipblaslt ;;
    *) die "Invalid target $TARGET" ;;
esac
