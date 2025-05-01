#!/bin/bash

set -ex
source "$(dirname "${BASH_SOURCE[0]}")/compute_utils.sh"

set_component_src MIOpen

PACKAGE_DIR=${PACKAGE_DIR%\/*}/miopen-hip
DEB_PATH=$PACKAGE_DIR
RPM_PATH=$PACKAGE_DIR

disable_debug_package_generation

build_miopen_hip() {
    echo "Start build"

    if [ "${ENABLE_STATIC_BUILDS}" == "true" ]; then
        ack_and_skip_static
    fi

    cd $COMPONENT_SRC
    git config --global --add safe.directory "$COMPONENT_SRC"
    checkout_lfs

    if [ "${ENABLE_ADDRESS_SANITIZER}" == "true" ]; then
       set_asan_env_vars
       set_address_sanitizer_on
   fi

    mkdir "$BUILD_DIR" && cd "$BUILD_DIR"
    init_rocm_common_cmake_params
    cmake \
        "${rocm_math_common_cmake_params[@]}" \
        -DMIOPEN_BACKEND=HIP \
        -DMIOPEN_OFFLINE_COMPILER_PATHS_V2=1 \
        -DCMAKE_CXX_COMPILER=$(set_build_variables __CLANG++__) \
        -DCMAKE_C_COMPILER=$(set_build_variables __CLANG__) \
        -DCMAKE_PREFIX_PATH="${ROCM_PATH};${ROCM_PATH}/hip;${HOME}/miopen-deps" \
        -DHIP_OC_COMPILER="${ROCM_PATH}/bin/clang-ocl" \
        -DMIOPEN_TEST_DISCRETE=OFF \
	"$COMPONENT_SRC"

    cmake --build "$BUILD_DIR" -- -j${PROC}
    cmake --build "$BUILD_DIR" -- install
    cmake --build "$BUILD_DIR" -- package

    rm -rf $BUILD_DIR/_CPack_Packages/ && find $BUILD_DIR -name '*.o' -delete
    copy_if "${PKGTYPE}" "${CPACKGEN:-"DEB;RPM"}" "${PACKAGE_DIR}" "${BUILD_DIR}"/*."${PKGTYPE}"

    show_build_cache_stats
}

clean_miopen_hip() {
    echo "Cleaning MIOpen-HIP build directory: ${BUILD_DIR} ${PACKAGE_DIR}"
    rm -rf "$BUILD_DIR" "$PACKAGE_DIR"
    echo "Done!"
}

checkout_lfs() {
    git lfs install --local --force
    git lfs pull --exclude=
}

stage2_command_args "$@"

case $TARGET in
    build) build_miopen_hip; build_wheel ;;
    outdir) print_output_directory ;;
    clean) clean_miopen_hip ;;
    *) die "Invalid target $TARGET" ;;
esac
