#!/bin/bash

set -ex
source "$(dirname "${BASH_SOURCE[0]}")/compute_utils.sh"

set_component_src hipSPARSELt

disable_debug_package_generation
# if ENABLE_GPU_ARCH is set in env by Job parameter ENABLE_GPU_ARCH, then set GFX_ARCH to that value
if [ -n "$ENABLE_GPU_ARCH" ]; then
    set_gpu_arch "$ENABLE_GPU_ARCH"
else
    # gfx90a:xnack+;gfx90a:xnack-;gfx940;gfx941;gfx942
    set_gpu_arch "all"
fi
while [ "$1" != "" ];
do
    case $1 in
        -o  | --outdir )
            shift 1; PKGTYPE=$1 ; TARGET="outdir" ;;
        -c  | --clean )
            TARGET="clean" ;;
        *)
            break ;;
    esac
    shift 1
done

create_blis_link()
{
    #find the pre-installed blis library and create the link under $BUILD_DIR/deps/blis
    BLIS_REF_ROOT="$BUILD_DIR/deps/blis"
    mkdir -p "$BLIS_REF_ROOT"/include
    if [[ -e "/opt/AMD/aocl/aocl-linux-gcc-4.2.0/gcc/lib_ILP64/libblis-mt.a" ]]; then
        ln -sf /opt/AMD/aocl/aocl-linux-gcc-4.2.0/gcc/include_ILP64 ${BLIS_REF_ROOT}/include/blis
        ln -sf /opt/AMD/aocl/aocl-linux-gcc-4.2.0/gcc/lib_ILP64 ${BLIS_REF_ROOT}/lib
    elif [[ -e "/opt/AMD/aocl/aocl-linux-gcc-4.1.0/gcc/lib_ILP64/libblis-mt.a" ]]; then
        ln -sf /opt/AMD/aocl/aocl-linux-gcc-4.1.0/gcc/include_ILP64 ${BLIS_REF_ROOT}/include/blis
        ln -sf /opt/AMD/aocl/aocl-linux-gcc-4.1.0/gcc/lib_ILP64 ${BLIS_REF_ROOT}/lib
    elif [[ -e "/opt/AMD/aocl/aocl-linux-gcc-4.0.0/gcc/lib_ILP64/libblis-mt.a" ]]; then
        ln -sf /opt/AMD/aocl/aocl-linux-gcc-4.0.0/gcc/include_ILP64 ${BLIS_REF_ROOT}/include/blis
        ln -sf /opt/AMD/aocl/aocl-linux-gcc-4.0.0/gcc/lib_ILP64 ${BLIS_REF_ROOT}/lib
    elif [[ -e "/usr/local/lib/libblis.a" ]]; then
        ln -sf /usr/local/include/blis ${BLIS_REF_ROOT}/include/blis
        ln -sf /usr/local/lib ${BLIS_REF_ROOT}/lib
    else
        echo "error: BLIS lib not found."
    fi
}

build_hipsparselt() {
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
    if [ "${ENABLE_ADDRESS_SANITIZER}" == "true" ]; then
        create_blis_link
        EXTRA_CMAKE_OPTIONS="-DLINK_BLIS=ON -DBUILD_DIR=${BUILD_DIR}"
    fi

    init_rocm_common_cmake_params

    CXX=$(set_build_variables __CXX__) \
    cmake \
        ${LAUNCHER_FLAGS} \
         "${rocm_math_common_cmake_params[@]}" \
        -DTensile_LOGIC= \
        -DTensile_CODE_OBJECT_VERSION=default \
        -DTensile_CPU_THREADS= \
        -DTensile_LIBRARY_FORMAT=msgpack \
        -DBUILD_CLIENTS_SAMPLES=ON \
        -DBUILD_CLIENTS_TESTS=ON \
        -DBUILD_CLIENTS_BENCHMARKS=ON \
        -DCMAKE_INSTALL_PREFIX=${ROCM_PATH} \
        -DBUILD_ADDRESS_SANITIZER="${ADDRESS_SANITIZER}" \
        ${EXTRA_CMAKE_OPTIONS} \
        "$COMPONENT_SRC"

    cmake --build "$BUILD_DIR" -- -j${PROC}
    cmake --build "$BUILD_DIR" -- install
    cmake --build "$BUILD_DIR" -- package

    copy_if "${PKGTYPE}" "${CPACKGEN:-"DEB;RPM"}" "${PACKAGE_DIR}" "${BUILD_DIR}"/*."${PKGTYPE}"

    $SCCACHE_BIN -s || echo "Unable to display sccache stats"
}

clean_hipsparselt() {
    echo "Cleaning hipSPARSELt build directory: ${BUILD_DIR} ${PACKAGE_DIR}"
    rm -rf "$BUILD_DIR" "$PACKAGE_DIR"
    echo "Done!"
}

print_output_directory() {
    case ${PKGTYPE} in
        ("deb")
            echo ${DEB_PATH};;
        ("rpm")
            echo ${RPM_PATH};;
        (*)
            echo "Invalid package type \"${PKGTYPE}\" provided for -o" >&2; exit 1;;
    esac
    exit
}

case $TARGET in
    build) build_hipsparselt; build_wheel ;;
    outdir) print_output_directory ;;
    clean) clean_hipsparselt ;;
    *) die "Invalid target $TARGET" ;;
esac
