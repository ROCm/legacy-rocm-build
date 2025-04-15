#!/bin/bash

set -ex
source "$(dirname "${BASH_SOURCE[0]}")/compute_utils.sh"

set_component_src AMDMIGraphX

build_amdmigraphx() {
    echo "Start build"

    if [ "${ENABLE_STATIC_BUILDS}" == "true" ]; then
        ack_and_skip_static
    fi

    cd $COMPONENT_SRC

    if ! command -v rbuild &> /dev/null; then
        pip3 install https://github.com/RadeonOpenCompute/rbuild/archive/master.tar.gz
    fi

    # Remove CK
    xargs -d '\n' -a ${OUT_DIR}/ck.files rm -- || true

    if [ "${ENABLE_ADDRESS_SANITIZER}" == "true" ]; then
         set_asan_env_vars
         set_address_sanitizer_on
    fi

    init_rocm_common_cmake_params

    mkdir -p ${BUILD_DIR} && rm -rf ${BUILD_DIR}/* && mkdir -p ${HOME}/amdmigraphx && rm -rf ${HOME}/amdmigraphx/*
    rbuild package -d "${HOME}/amdmigraphx" -B "${BUILD_DIR}" \
        --cxx="$(set_build_variables __CLANG++__)" \
        --cc="$(set_build_variables __CLANG__)" \
        "${rocm_math_common_cmake_params[@]}" \
        -DCMAKE_MODULE_LINKER_FLAGS="-Wl,--enable-new-dtags,--build-id=sha1,--rpath,$ROCM_LIB_RPATH" \
        -DCMAKE_INSTALL_RPATH=""

    copy_if "${PKGTYPE}" "${CPACKGEN:-"DEB;RPM"}" "${PACKAGE_DIR}" "${BUILD_DIR}"/*."${PKGTYPE}"
    cd $BUILD_DIR && cmake --build . -- install -j${PROC}

    show_build_cache_stats
}

clean_amdmigraphx() {
    echo "Cleaning AMDMIGraphX build directory: ${BUILD_DIR} ${DEPS_DIR} ${PACKAGE_DIR}"
    rm -rf "$BUILD_DIR" "$DEPS_DIR" "$PACKAGE_DIR"
    echo "Done!"
}

stage2_command_args "$@"

case $TARGET in
    build) build_amdmigraphx; build_wheel ;;
    outdir) print_output_directory ;;
    clean) clean_amdmigraphx ;;
    *) die "Invalid target $TARGET" ;;
esac
