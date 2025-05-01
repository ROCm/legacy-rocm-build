#!/bin/bash

source "$(dirname "${BASH_SOURCE}")/compute_utils.sh"

printUsage() {
    echo
    echo "Usage: ${BASH_SOURCE##*/} [options ...]"
    echo
    echo "Options:"
    echo "  -c,  --clean              Clean output and delete all intermediate work"
    echo "  -s,  --static             Build static lib (.a).  build instead of dynamic/shared(.so) "
    echo "  -p,  --package <type>     Specify packaging format"
    echo "  -r,  --release            Make a release build instead of a debug build"
    echo "  -a,  --address_sanitizer  Enable address sanitizer"
    echo "  -w,  --wheel              Creates python wheel package of rocprofiler-register. It needs to be used along with -r option"
    echo "  -o,  --outdir <pkg_type>  Print path of output directory containing packages of
    type referred to by pkg_type"
    echo "  -h,  --help               Prints this help"
    echo
    echo "Possible values for <type>:"
    echo "  deb -> Debian format (default)"
    echo "  rpm -> RPM format"
    echo

    return 0
}

## Build environment variables
API_NAME="rocprofiler-register"
PROJ_NAME="$API_NAME"
LIB_NAME="lib${API_NAME}"
TARGET="build"
MAKETARGET="deb"
PACKAGE_ROOT="$(getPackageRoot)"
PACKAGE_LIB="$(getLibPath)"
PACKAGE_INCLUDE="$(getIncludePath)"
BUILD_DIR="$(getBuildPath $API_NAME)"
PACKAGE_DEB="$(getPackageRoot)/deb/$API_NAME"
PACKAGE_RPM="$(getPackageRoot)/rpm/$API_NAME"
PACKAGE_PREFIX="$ROCM_INSTALL_PATH"
BUILD_TYPE="Debug"
MAKE_OPTS="$DASH_JAY -C $BUILD_DIR"
SHARED_LIBS="ON"
CLEAN_OR_OUT=0;
MAKETARGET="deb"
PKGTYPE="deb"


#parse the arguments
VALID_STR=`getopt -o hcraswo:p: --long help,clean,release,static,address_sanitizer,wheeloutdir:,package: -- "$@"`
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
                BUILD_TYPE="Release" ; shift ;;
        (-a | --address_sanitizer)
                set_asan_env_vars
                set_address_sanitizer_on ; shift ;;
        (-s | --static)
                SHARED_LIBS="OFF" ; shift ;;
        (-w | --wheel)
                WHEEL_PACKAGE=true ; shift ;;
        (-o | --outdir)
                TARGET="outdir"; PKGTYPE=$2 ; OUT_DIR_SPECIFIED=1 ; ((CLEAN_OR_OUT|=2)) ; shift 2 ;;
        (-p | --package)
                MAKETARGET="$2" ; shift 2;;
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

clean() {
    echo "Cleaning $PROJ_NAME"

    rm -rf "$BUILD_DIR"
    rm -rf "$PACKAGE_DEB"
    rm -rf "$PACKAGE_RPM"
    rm -rf "$PACKAGE_ROOT/${PROJ_NAME}"
    rm -rf "$PACKAGE_LIB/${LIB_NAME}"*
}

build() {
    echo "Building $PROJ_NAME"

    if [ ! -d "$BUILD_DIR" ]; then
        mkdir -p "$BUILD_DIR"
        pushd "$BUILD_DIR"
        print_lib_type $SHARED_LIBS
        cmake \
            $(rocm_cmake_params) \
            $(rocm_common_cmake_params) \
            -DBUILD_SHARED_LIBS=$SHARED_LIBS \
            -DENABLE_LDCONFIG=OFF \
            -DROCPROFILER_REGISTER_BUILD_CI=1 \
            -DROCPROFILER_REGISTER_BUILD_TESTS=1 \
            -DROCPROFILER_REGISTER_BUILD_SAMPLES=1 \
            "$ROCPROFILER_REGISTER_ROOT"
        popd
    fi
    cmake --build "$BUILD_DIR" -- $MAKE_OPTS
    cmake --build "$BUILD_DIR" -- $MAKE_OPTS install
    cmake --build "$BUILD_DIR" -- $MAKE_OPTS package

    copy_if DEB "${CPACKGEN:-"DEB;RPM"}" "$PACKAGE_DEB" "$BUILD_DIR/${API_NAME}"*.deb
    copy_if RPM "${CPACKGEN:-"DEB;RPM"}" "$PACKAGE_RPM" "$BUILD_DIR/${API_NAME}"*.rpm
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

verifyEnvSetup

case "$TARGET" in
    (clean) clean ;;
    (build) build; build_wheel "$BUILD_DIR" "$PROJ_NAME" ;;
    (outdir) print_output_directory ;;
    (*) die "Invalid target $TARGET" ;;
esac

echo "Operation complete"
