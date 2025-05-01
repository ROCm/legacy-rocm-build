#!/bin/bash
set -ex

source "$(dirname "${BASH_SOURCE[0]}")/compute_utils.sh"

set_component_src hipRAND

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

build_hiprand() {
    echo "Start build"

    SHARED_LIBS="ON"
    if [ "${ENABLE_STATIC_BUILDS}" == "true" ]; then
        SHARED_LIBS="OFF"
    fi

    if [ "${ENABLE_ADDRESS_SANITIZER}" == "true" ]; then
         set_asan_env_vars
         set_address_sanitizer_on
    fi

    cd $COMPONENT_SRC

    remote_name=$(git remote show | head -n 1)
    [ "$remote_name" == "origin" ] || git remote rename "$remote_name" origin
    git submodule update --init --force

    mkdir "$BUILD_DIR" && cd "$BUILD_DIR"

    init_rocm_common_cmake_params

    CXX=$(set_build_variables __CXX__)\
    cmake \
        ${LAUNCHER_FLAGS} \
	    "${rocm_math_common_cmake_params[@]}" \
        -DBUILD_SHARED_LIBS=$SHARED_LIBS \
        -DBUILD_TEST=ON \
        -DBUILD_BENCHMARK=ON \
        -DBUILD_CRUSH_TEST=ON \
        -DDEPENDENCIES_FORCE_DOWNLOAD=ON \
        -DHIP_COMPILER=clang \
        -DCMAKE_MODULE_PATH="${ROCM_PATH}/lib/cmake/hip" \
        -DBUILD_ADDRESS_SANITIZER="${ADDRESS_SANITIZER}" \
        "$COMPONENT_SRC"

    cmake --build "$BUILD_DIR" -- -j${PROC}
    cmake --build "$BUILD_DIR" -- install
    cmake --build "$BUILD_DIR" -- package

    rm -rf _CPack_Packages/  && find -name '*.o' -delete
    copy_if "${PKGTYPE}" "${CPACKGEN:-"DEB;RPM"}" "${PACKAGE_DIR}" "${BUILD_DIR}"/*."${PKGTYPE}"
}

clean_hiprand() {
    echo "Cleaning hipRAND build directory: ${BUILD_DIR} ${PACKAGE_DIR}"
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
    build) build_hiprand; build_wheel ;;
    outdir) print_output_directory ;;
    clean) clean_hiprand ;;
    *) die "Invalid target $TARGET" ;;
esac
