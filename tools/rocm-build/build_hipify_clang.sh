#!/bin/bash

source "$(dirname "${BASH_SOURCE}")/compute_utils.sh"

printUsage() {
    echo
    echo "Usage: $(basename "${BASH_SOURCE}") [options ...]"
    echo
    echo "Options:"
    echo "  -c,  --clean              Clean output and delete all intermediate work"
    echo "  -o,  --outdir <pkg_type>  Print path of output directory containing packages of
    type referred to by pkg_type"
    echo "  -r,  --release            Make a release build"
    echo "  -n,  --skip_hipify_tests  Skip hipify-clang testing"
    echo "  -a,  --address_sanitizer  Enable address sanitizer"
    echo "  -s,  --static             Component/Build does not support static builds just accepting this param & ignore. No effect of the param on this build"
    echo "  -i,  --clang_headers      Install clang headers"
    echo "  -w,  --wheel              Creates python wheel package of hipify-clang.
                                      It needs to be used along with -r option"
    echo "  -h,  --help               Prints this help"
    echo

    return 0
}

# Build Environmental Variables
PROJ_NAME="hipify"
TARGET="build"
MAKEOPTS="$DASH_JAY"
HIPIFY_CLANG_BUILD_DIR="$(getBuildPath $HIPIFY_ROOT)"
BUILD_TYPE="Debug"
PACKAGE_ROOT="$(getPackageRoot)"
HIPIFY_CLANG_HASH=""
LIGHTNING_PATH="$ROCM_INSTALL_PATH/llvm"
LIGHTNING_BUILD_PATH="$PACKAGE_ROOT/build/lightning"
RUN_HIPIFY_TESTS=false
CUDA_DEFAULT_VERSION="12.3.2"
CUDNN_DEFAULT_VERSION="9.2.0"
GCC_MIN_VERSION="9.2"
ADDRESS_SANITIZER=false
INSTALL_CLANG_HEADERS="OFF"
DEB_PATH="$(getDebPath hipify)"
RPM_PATH="$(getRpmPath hipify)"
SHARED_LIBS="ON"
CLEAN_OR_OUT=0;
MAKETARGET="deb"
PKGTYPE="deb"


#parse the arguments
VALID_STR=`getopt -o hcrnawsio: --long help,clean,release,skip_hipify_tests,wheel,static,address_sanitizer,clang_headers,outdir: -- "$@"`
eval set -- "$VALID_STR"

while true ;
do
    case "$1" in
        (-h | --help)
                printUsage ; exit 0;;
        (-c | --clean)
                TARGET="clean" ; ((CLEAN_OR_OUT|=1)) ; shift ;;
        (-r | --release)
                BUILD_TYPE="RelWithDebInfo" ; shift ;;
        (-n | --skip_hipify_tests)
                RUN_HIPIFY_TESTS=false; shift ;;
        (-a | --address_sanitizer)
                set_asan_env_vars
                set_address_sanitizer_on
                ADDRESS_SANITIZER=true ; shift ;;
        (-s | --static)
                ack_and_skip_static ;;
        (-w | --wheel)
                WHEEL_PACKAGE=true ; shift ;;
        (-i | --clang_headers)
                INSTALL_CLANG_HEADERS="ON" ; shift ;;
        (-o | --outdir)
                TARGET="outdir"; PKGTYPE=$2 ; OUT_DIR_SPECIFIED=1 ; ((CLEAN_OR_OUT|=2)) ; shift 2 ;;
        --)     shift; break;; # end delimiter
        (*)
                echo " This should never come but just incase : UNEXPECTED ERROR Parm : [$1] ">&2 ; exit 20;;
    esac

done

RET_CONFLICT=1
check_conflicting_options $CLEAN_OR_OUT $PKGTYPE $MAKETARGET
if [ $RET_CONFLICT -ge 30 ]; then
   print_vars $API_NAME $TARGET $BUILD_TYPE $SHARED_LIBS $CLEAN_OR_OUT $PKGTYPE $MAKETARGET
   exit $RET_CONFLICT
fi


clean_hipify() {
    echo "Cleaning hipify-clang"
    rm -rf "$HIPIFY_CLANG_BUILD_DIR"
    rm -rf "$DEB_PATH"
    rm -rf "$RPM_PATH"
}

package_hipify() {
    # set-up dirs
    if [ "$PACKAGEEXT" = "deb" ]; then
        rm -rf "$DEB_PATH"
        mkdir -p "$DEB_PATH"
    fi

    if [ "$PACKAGEEXT" = "rpm" ]; then
        rm -rf "$RPM_PATH"
        mkdir -p "$RPM_PATH"
    fi

    # make the pkg
    pushd "$HIPIFY_CLANG_BUILD_DIR"
    make $MAKEOPTS package_hipify-clang
    popd

    copy_if DEB "${CPACKGEN:-"DEB;RPM"}" "$DEB_PATH"  $HIPIFY_CLANG_BUILD_DIR/hipify*.deb
    copy_if RPM "${CPACKGEN:-"DEB;RPM"}" "$RPM_PATH"  $HIPIFY_CLANG_BUILD_DIR/hipify*.rpm
}

build_hipify() {
    echo "Building hipify-clang binaries"
    mkdir -p "$HIPIFY_CLANG_BUILD_DIR"

    pushd "$HIPIFY_CLANG_BUILD_DIR"

    # Check the installed GCC version
    INSTALLED_GCC_VERSION=$(gcc --version | head -n 1 | sed -E 's/[^0-9]*([0-9]+\.[0-9]+).*/\1/')
    if echo "$INSTALLED_GCC_VERSION $GCC_MIN_VERSION" | awk '{exit !($1 < $2)}'; then
        RUN_HIPIFY_TESTS=false
        echo "Minimum required GCC version: $GCC_MIN_VERSION"
        echo "Installed GCC version $INSTALLED_GCC_VERSION does not meet the minimum GCC version requirement."
        echo "Skipping hipify tests"
    fi

    if $ADDRESS_SANITIZER ; then
        echo "Skipping hipify tests becasue of Address Sanitizer"
        RUN_HIPIFY_TESTS=false
    fi

    if $RUN_HIPIFY_TESTS ; then
        # TODO: Add option for user defined cuda version?
        CUDA_VERSION="${CUDA_DEFAULT_VERSION}"
        CUDNN_VERSION="${CUDNN_DEFAULT_VERSION}"

        if [[ "$DISTRO_ID" == "rhel-8"* || "$DISTRO_NAME" == "sles" || "$DISTRO_ID" == "debian-10" ]]; then
            EXTRA_PYTHON_PATH=/opt/Python-3.8.13
            export LD_LIBRARY_PATH=${EXTRA_PYTHON_PATH}/lib:$LD_LIBRARY_PATH
        fi

        echo "Copy FileCheck into ROCM_INSTALL_PATH"
        cp "$LIGHTNING_BUILD_PATH/bin/FileCheck" "$LIGHTNING_PATH/bin/FileCheck"
    fi

    cmake \
        -DHIPIFY_CLANG_TESTS="$RUN_HIPIFY_TESTS" \
        -DCMAKE_BUILD_TYPE="$BUILD_TYPE" \
        $(rocm_common_cmake_params) \
        -DCMAKE_INSTALL_PREFIX="$ROCM_INSTALL_PATH" \
        -DCPACK_PACKAGING_INSTALL_PREFIX=$ROCM_INSTALL_PATH \
        -DCMAKE_PREFIX_PATH="$LIGHTNING_PATH" \
        -DADDRESS_SANITIZER="$ADDRESS_SANITIZER" \
        -DHIPIFY_INSTALL_CLANG_HEADERS="$INSTALL_CLANG_HEADERS" \
        -DCUDA_TOOLKIT_ROOT_DIR="/usr/local/cuda-${CUDA_DEFAULT_VERSION}" \
        -DCUDA_DNN_ROOT_DIR="/usr/local/cuDNN/${CUDNN_DEFAULT_VERSION}" \
        -DCUDA_CUB_ROOT_DIR="/usr/local/cuda-${CUDA_DEFAULT_VERSION}" \
        -DLLVM_EXTERNAL_LIT="${LIGHTNING_BUILD_PATH}/bin/llvm-lit" \
        $HIPIFY_ROOT

    if $RUN_HIPIFY_TESTS ; then
        echo "Running hipify tests"
        cmake --build . -- $MAKEOPTS test-hipify
    fi

    cmake --build . -- $MAKEOPTS install
    popd

    pushd "$HIPIFY_ROOT"
        HIPIFY_CLANG_HASH=`git describe --dirty --long --match [0-9]* --always`
    popd
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
    (clean)
        clean_hipify
        ;;
    (build)
        build_hipify
        package_hipify
        build_wheel "$HIPIFY_CLANG_BUILD_DIR" "$PROJ_NAME"
        ;;
    (outdir)
        print_output_directory
        ;;
    (*)
        die "Invalid target $TARGET"
        ;;
esac

echo "Operation complete"
