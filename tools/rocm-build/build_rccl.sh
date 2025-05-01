#!/bin/bash

set -ex
source "$(dirname "${BASH_SOURCE[0]}")/compute_utils.sh"

set_component_src rccl

build_rccl() {
    echo "Start build"

    if [ "${ENABLE_STATIC_BUILDS}" == "true" ]; then
        ack_and_skip_static
    fi

    mkdir -p $ROCM_PATH/.info/
    echo $ROCM_VERSION | tee $ROCM_PATH/.info/version

    if [ "${ENABLE_ADDRESS_SANITIZER}" == "true" ]; then
       set_asan_env_vars
       set_address_sanitizer_on
    fi

    mkdir -p $BUILD_DIR && cd $BUILD_DIR

    init_rocm_common_cmake_params

    CC=${ROCM_PATH}/bin/amdclang \
    CXX=$(set_build_variables __CXX__) \
    cmake \
        "${rocm_math_common_cmake_params[@]}" \
        -DHIP_COMPILER=clang \
        -DCMAKE_PREFIX_PATH="${ROCM_PATH};${ROCM_PATH}/share/rocm/cmake/" \
        ${LAUNCHER_FLAGS} \
        -DCPACK_GENERATOR="${PKGTYPE^^}" \
        -DROCM_PATCH_VERSION=$ROCM_LIBPATCH_VERSION \
        -DBUILD_ADDRESS_SANITIZER="${ADDRESS_SANITIZER}" \
        -DBUILD_TESTS=ON \
        "$COMPONENT_SRC"

    cmake --build "$BUILD_DIR" -- -j${PROC}
    cmake --build "$BUILD_DIR" -- package

    rm -rf _CPack_Packages/ && find -name '*.o' -delete
    copy_if "${PKGTYPE}" "${CPACKGEN:-"DEB;RPM"}" "${PACKAGE_DIR}" "${BUILD_DIR}"/*."${PKGTYPE}"

    show_build_cache_stats
}

clean_rccl() {
    echo "Cleaning rccl build directory: ${BUILD_DIR} ${PACKAGE_DIR}"
    rm -rf "$BUILD_DIR" "$PACKAGE_DIR"
    echo "Done!"
}

stage2_command_args "$@"

case $TARGET in
    build) build_rccl; build_wheel ;;
    outdir) print_output_directory ;;
    clean) clean_rccl ;;
    *) die "Invalid target $TARGET" ;;
esac
