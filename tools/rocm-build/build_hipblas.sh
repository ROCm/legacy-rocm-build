#!/bin/bash

set -ex

source "$(dirname "${BASH_SOURCE[0]}")/compute_utils.sh"

set_component_src hipBLAS

build_hipblas() {
    echo "Start build"

    CXX=$(set_build_variables __G_++__)
    CXX_FLAG=
    if [ "${ENABLE_STATIC_BUILDS}" == "true" ]; then
        CXX=$(set_build_variables __AMD_CLANG_++__)
        CXX_FLAG=$(set_build_variables __CMAKE_CXX_PARAMS__)
    fi

    CLIENTS_SAMPLES="ON"
    if [ "${ENABLE_ADDRESS_SANITIZER}" == "true" ]; then
       set_asan_env_vars
       set_address_sanitizer_on
       # fixme: remove CLIENTS_SAMPLES=OFF once SWDEV-417076 is fixed
       CLIENTS_SAMPLES="OFF"
    fi

    SHARED_LIBS="ON"
    if [ "${ENABLE_STATIC_BUILDS}" == "true" ]; then
        SHARED_LIBS="OFF"
    fi

    echo "C compiler: $CC"
    echo "CXX compiler: $CXX"
    echo "FC compiler: $FC"

    cd $COMPONENT_SRC
    mkdir -p "$BUILD_DIR" && cd "$BUILD_DIR"

    if [ "${ENABLE_ADDRESS_SANITIZER}" == "true" ]; then
       rebuild_lapack
    fi

    init_rocm_common_cmake_params
    cmake \
        ${LAUNCHER_FLAGS} \
	    "${rocm_math_common_cmake_params[@]}" \
        -DUSE_CUDA=OFF \
        -DBUILD_SHARED_LIBS=$SHARED_LIBS \
	    -DBUILD_CLIENTS_TESTS=ON \
        -DBUILD_CLIENTS_BENCHMARKS=ON \
        -DBUILD_CLIENTS_SAMPLES="${CLIENTS_SAMPLES}" \
        -DBUILD_ADDRESS_SANITIZER="${ADDRESS_SANITIZER}" \
        ${CXX_FLAG} \
        "$COMPONENT_SRC"

    cmake --build "$BUILD_DIR" -- -j${PROC}
    cmake --build "$BUILD_DIR" -- install
    cmake --build "$BUILD_DIR" -- package

    rm -rf _CPack_Packages/ && find -name '*.o' -delete
    copy_if "${PKGTYPE}" "${CPACKGEN:-"DEB;RPM"}" "${PACKAGE_DIR}" "${BUILD_DIR}"/*."${PKGTYPE}"

    show_build_cache_stats
}

clean_hipblas() {
    echo "Cleaning hipBLAS build directory: ${BUILD_DIR} ${PACKAGE_DIR}"
    rm -rf "$BUILD_DIR" "$PACKAGE_DIR"
    echo "Done!"
}

stage2_command_args "$@"

case $TARGET in
    build) build_hipblas; build_wheel ;;
    outdir) print_output_directory ;;
    clean) clean_hipblas ;;
    *) die "Invalid target $TARGET" ;;
esac
