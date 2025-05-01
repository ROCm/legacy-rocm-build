#!/bin/bash

source "$(dirname "${BASH_SOURCE}")/compute_utils.sh"

printUsage() {
    echo
    echo "Usage: $(basename "${BASH_SOURCE}") [options ...] [make options]"
    echo
    echo "Options:"
    echo "  -c,  --clean              Clean output and delete all intermediate work"
    echo "  -r,  --release            Make a release build instead of a debug build"
    echo "  -a,  --address_sanitizer  Enable address sanitizer"
    echo "  -o,  --outdir <pkg_type>  Print path of output directory containing packages of type referred to by pkg_type"
    echo "  -s,  --static             Build static lib (.a).  build instead of dynamic/shared(.so) "
    echo "  -w,  --wheel              Creates python wheel package of hsa. It needs to be used along with -r option"
    echo "  -h,  --help               Prints this help"
    echo
    echo

    return 0
}

PROJ_NAME="rocr"
TARGET="build"
PACKAGE_ROOT="$(getPackageRoot)"
PACKAGE_SRC="$(getSrcPath)"
PACKAGE_LIB="$(getLibPath)"
PACKAGE_BIN="$(getBinPath)"
PACKAGE_DEB="$(getPackageRoot)/deb/$PROJ_NAME"
PACKAGE_RPM="$(getPackageRoot)/rpm/$PROJ_NAME"
MAKEARG=""
CORE_BUILD_DIR="$(getBuildPath hsa-core)"
ROCR_DEV_BUILD_DIR="$(getBuildPath hsa-rocr-dev)"
PREFIX_PATH="$PACKAGE_ROOT"
BUILD_TYPE="Debug"
SHARED_LIBS="ON"
CLEAN_OR_OUT=0;
MAKETARGET="deb"
PKGTYPE="deb"

unset HIP_DEVICE_LIB_PATH
unset ROCM_PATH

#parse the arguments
VALID_STR=`getopt -o hcraswo: --long help,clean,release,static,wheel,address_sanitizer,outdir: -- "$@"`
eval set -- "$VALID_STR"

while true ;
do
    #echo "parocessing $1"
    case "$1" in
        (-h | --help)
                printUsage ; exit 0;;
        (-c | --clean)
                TARGET="clean" ; ((CLEAN_OR_OUT|=1)) ; shift ;;
        (-r | --release)
                BUILD_TYPE="RelWithDebInfo" ; shift ;;
        (-a | --address_sanitizer)
                set_asan_env_vars
                set_address_sanitizer_on ; shift ;;
        (-s | --static)
                SHARED_LIBS="OFF" ; shift ;;
        (-w | --wheel)
                WHEEL_PACKAGE=true ; shift ;;
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

clean_hsa() {
    echo "Cleaning HSA"

    rm -rf "$CORE_BUILD_DIR"
    rm -rf "$PACKAGE_RPM"
    rm -rf "$PACKAGE_DEB"
    rm -f  "$PACKAGE_ROOT"/lib/libhsa-runtime*
    rm -rf "$PACKAGE_ROOT/lib/cmake/hsa-runtime64"
    rm -rf "$PACKAGE_ROOT/include/hsa"
    rm -rf "$PACKAGE_ROOT/share/doc/hsa-runtime64"
    # Remove when switching to flat directory layout.
    rm -rf "$PACKAGE_ROOT/hsa"
}


build_hsa_core() {
    echo "Build HSA"
    local coreMakeOpts="$DASH_JAY -C $CORE_BUILD_DIR"

    echo "$HSA_CORE_ROOT"

    if [ ! -d "$CORE_BUILD_DIR" ]; then
        mkdir -p "$CORE_BUILD_DIR"
        pushd "$CORE_BUILD_DIR"
        print_lib_type $SHARED_LIBS

        cmake $(rocm_cmake_params) \
            -DBUILD_SHARED_LIBS=$SHARED_LIBS \
            -DENABLE_LDCONFIG=OFF \
            $(rocm_common_cmake_params) \
            -DADDRESS_SANITIZER="$ADDRESS_SANITIZER" \
            "$HSA_CORE_ROOT"
        popd
    fi
    time cmake --build "$CORE_BUILD_DIR" -- $coreMakeOpts
    time cmake --build "$CORE_BUILD_DIR" -- $coreMakeOpts install
    time cmake --build "$CORE_BUILD_DIR" -- $coreMakeOpts package

    copy_if DEB "${CPACKGEN:-"DEB;RPM"}" "$PACKAGE_DEB" $CORE_BUILD_DIR/hsa-rocr*.deb
    copy_if RPM "${CPACKGEN:-"DEB;RPM"}" "$PACKAGE_RPM" $CORE_BUILD_DIR/hsa-rocr*.rpm
}

print_output_directory() {
    case ${PKGTYPE} in
        ("deb")
            echo ${PACKAGE_DEB};;
        ("rpm")
            echo ${PACKAGE_RPM};;
        (*)
            echo "Invalid package type \"${PKGTYPE}\" provided for -o" >&2; exit 1;;
    esac
    exit
}

case $TARGET in
    (clean)
        clean_hsa
        ;;
    (build)
        build_hsa_core
        build_wheel "$CORE_BUILD_DIR" "$PROJ_NAME"
        ;;
    (outdir)
        print_output_directory
        ;;
    (*)
        die "Invalid target $TARGET"
        ;;
esac

echo "Operation complete"
