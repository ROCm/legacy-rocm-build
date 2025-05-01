#!/bin/bash
set -ex

source "$(dirname "${BASH_SOURCE[0]}")/compute_utils.sh"

set_component_src rocRAND

build_rocrand() {
    echo "Start build"

    SHARED_LIBS="ON"
    if [ "${ENABLE_STATIC_BUILDS}" == "true" ]; then
        SHARED_LIBS="OFF"
    fi

    #Removed GPU ARCHS from here as it will be part of compute_utils.sh ROCMOPS-7302 & ROCMOPS-8091
    if [ "${ENABLE_ADDRESS_SANITIZER}" == "true" ]; then
        set_asan_env_vars
        set_address_sanitizer_on
        # updating GPU_ARCHS for ASAN build to supported gpu arch only SWDEV-479178
        #GPU_ARCHS="gfx90a:xnack+;gfx942:xnack+"#This will be part of compute_utils.sh ROCMOPS-7302 & ROCMOPS-8091
    fi
    cd $COMPONENT_SRC && mkdir "$BUILD_DIR"

    git config --global --add safe.directory "$COMPONENT_SRC"
    # Rename the remote set by the repo tool to origin as
    # git submodule update looks for the remote origin.
    remote_name=$(git remote show | head -n 1)
    echo "remote name: $remote_name"
    [ "$remote_name" == "origin" ] || git remote rename "$remote_name" origin
    git remote -v
    git submodule update --init --force

    # if GPU_ENABLE_GPU_ARCHARCH is set in env by Job parameter ENABLE_GPU_ARCH, then set GFX_ARCH to that value. This will override any of the case values above
    if [ -n "$ENABLE_GPU_ARCH" ]; then
        #setting gfx arch as part of rocm_common_cmake_params
        set_gpu_arch "${ENABLE_GPU_ARCH}"
    fi

    init_rocm_common_cmake_params

    CXX=$(set_build_variables __CXX__)\
    cmake \
        ${LAUNCHER_FLAGS} \
        "${rocm_math_common_cmake_params[@]}" \
        -DBUILD_SHARED_LIBS=$SHARED_LIBS \
        -DBUILD_TEST=ON \
        -DBUILD_BENCHMARK=ON \
        -DBUILD_CRUSH_TEST=ON \
        -DDEPENDENCIES_FORCE_DOWNLOAD=OFF \
        -DHIP_COMPILER=clang \
        -DCMAKE_MODULE_PATH="${ROCM_PATH}/lib/cmake/hip" \
        -DBUILD_ADDRESS_SANITIZER="${ADDRESS_SANITIZER}" \
        -B "${BUILD_DIR}" \
        "$COMPONENT_SRC"

    cmake --build "$BUILD_DIR" -- -j${PROC}
    cmake --build "$BUILD_DIR" -- install
    cmake --build "$BUILD_DIR" -- package

    rm -rf _CPack_Packages/  && find -name '*.o' -delete
    copy_if "${PKGTYPE}" "${CPACKGEN:-"DEB;RPM"}" "${PACKAGE_DIR}" "${BUILD_DIR}"/*."${PKGTYPE}"

    show_build_cache_stats
}

clean_rocrand() {
    echo "Cleaning rocRAND build directory: ${BUILD_DIR} ${PACKAGE_DIR}"
    rm -rf "$BUILD_DIR" "$PACKAGE_DIR"
    echo "Done!"
}

stage2_command_args "$@"

case $TARGET in
    build) build_rocrand; build_wheel ;;
    outdir) print_output_directory ;;
    clean) clean_rocrand ;;
    *) die "Invalid target $TARGET" ;;
esac
