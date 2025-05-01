#!/bin/bash

set -ex

source "$(dirname "${BASH_SOURCE[0]}")/compute_utils.sh"

# Temporarily disable Address Sanitizer
ENABLE_ADDRESS_SANITIZER=false

set_component_src composable_kernel
disable_debug_package_generation
# Set the GPU_ARCH_LIST to the supported GPUs needed after https://github.com/ROCm/composable_kernel/pull/1536/
GPU_ARCH_LIST="gfx908;gfx90a;gfx942;gfx1030;gfx1100;gfx1101;gfx1102;gfx1200;gfx1201"

build_miopen_ck() {
    echo "Start Building Composable Kernel"
    if [ "${ENABLE_ADDRESS_SANITIZER}" == "true" ]; then
       set_asan_env_vars
       set_address_sanitizer_on
       GPU_ARCH_LIST="gfx908:xnack+;gfx90a:xnack+;gfx942:xnack+"
    else
       unset_asan_env_vars
       set_address_sanitizer_off
    fi

    if [ "${ENABLE_STATIC_BUILDS}" == "true" ]; then
        GPU_ARCH_LIST="gfx942"
        ack_and_skip_static
    fi
    # if ENABLE_GPU_ARCH is set in env by Job parameter ENABLE_GPU_ARCH, then set GPU_ARCH_LIST to that value
    # This needs to be removed when CK aligns with other component and uses -DAMDGPU_TARGET or _DGPO_TARGET
    # then we can use set_gpu_arch from compure_helper.sh and get rid of all if clauses
    if [ -n "$ENABLE_GPU_ARCH" ]; then
        GPU_ARCH_LIST="$ENABLE_GPU_ARCH"
    fi
    # Latest CK requiring Python 3.8 as the minimum.
    # Point CMake to that explicit location and adjust LD_LIBRARY_PATH.
    PYTHON_VERSION_WORKAROUND=''
    echo "DISTRO_ID: ${DISTRO_ID}"
    if [ "$DISTRO_ID" = "rhel-8.8" ] || [ "$DISTRO_NAME" == "sles" ] || [ "$DISTRO_ID" = "debian-10" ]; then
        EXTRA_PYTHON_PATH=/opt/Python-3.8.13
        PYTHON_VERSION_WORKAROUND="-DCK_USE_ALTERNATIVE_PYTHON=${EXTRA_PYTHON_PATH}/bin/python3.8"
        # For the python interpreter we need to export LD_LIBRARY_PATH.
        export LD_LIBRARY_PATH=${EXTRA_PYTHON_PATH}/lib:$LD_LIBRARY_PATH
    fi

    cd $COMPONENT_SRC
    mkdir "$BUILD_DIR" && cd "$BUILD_DIR"
    init_rocm_common_cmake_params

    cmake \
        -DBUILD_DEV=OFF \
        "${rocm_math_common_cmake_params[@]}" \
        ${PYTHON_VERSION_WORKAROUND} \
        -DCPACK_GENERATOR="${PKGTYPE^^}" \
        -DCMAKE_CXX_COMPILER=$(set_build_variables __CLANG++__) \
        -DCMAKE_C_COMPILER=$(set_build_variables __CLANG__) \
        ${LAUNCHER_FLAGS} \
        -DGPU_ARCHS="${GPU_ARCH_LIST}" \
        "$COMPONENT_SRC"

    cmake --build . -- -j${PROC} package
    cmake --build "$BUILD_DIR" -- install

    copy_if "${PKGTYPE}" "${CPACKGEN:-"DEB;RPM"}" "${PACKAGE_DIR}" "${BUILD_DIR}"/*."${PKGTYPE}"
}

# Use the function to unset the LDFLAGS and CXXFLAGS
# specifically set for ASAN
unset_asan_env_vars() {
    ASAN_CMAKE_PARAMS="false"
    export ADDRESS_SANITIZER="OFF"
    export LD_LIBRARY_PATH=""
    export ASAN_OPTIONS=""
}

set_address_sanitizer_off() {
    export CFLAGS=""
    export CXXFLAGS=""
    export LDFLAGS=""
}

clean_miopen_ck() {
    echo "Cleaning MIOpen-CK build directory: ${BUILD_DIR} ${PACKAGE_DIR}"
    rm -rf "$BUILD_DIR" "$PACKAGE_DIR"
    echo "Done!"
}

stage2_command_args "$@"

case $TARGET in
    build) build_miopen_ck; build_wheel ;;
    outdir) print_output_directory ;;
    clean) clean_miopen_ck ;;
    *) die "Invalid target $TARGET" ;;
esac
