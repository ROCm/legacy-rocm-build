#!/bin/bash
source "$(dirname "${BASH_SOURCE}")/compute_utils.sh"
PROJ_NAME=opencl-cts
TARGET="build"
MAKEOPTS="$DASH_JAY"
BUILD_TYPE="Debug"
OPENCL_ICD_LOADER_BUILD_DIR="$(getBuildPath)/OpenCL-ICD-Loader"
OPENCL_CTS_BUILD_DIR="$(getBuildPath)/OpenCL-CTS"
PACKAGE_ROOT="$(getPackageRoot)"
PACKAGE_DEB="$PACKAGE_ROOT/deb/$PROJ_NAME"
PACKAGE_RPM="$PACKAGE_ROOT/rpm/$PROJ_NAME"
CLEAN_OR_OUT=0;
PKGTYPE="deb"
MAKETARGET="deb"

printUsage() {
    echo
    echo "Usage: $(basename "${BASH_SOURCE}") [options ...]"
    echo
    echo "Options:"
    echo "  -c,  --clean              Clean output and delete all intermediate work"
    echo "  -p,  --package <type>     Specify packaging format"
    echo "  -r,  --release            Make a release build instead of a debug build"
    echo "  -w,  --wheel              Creates python wheel package of opencl-cts. 
                                      It needs to be used along with -r option"
    echo "  -h,  --help               Prints this help"
    echo "  -o,  --outdir             Print path of output directory containing packages"
    echo "  -s,  --static             Component/Build does not support static builds just accepting this param & ignore. No effect of the param on this build"
    echo
    echo "Possible values for <type>:"
    echo "  deb -> Debian format (default)"
    echo "  rpm -> RPM format"
    echo
    return 0
}

RET_CONFLICT=1
check_conflicting_options $CLEAN_OR_OUT $PKGTYPE $MAKETARGET
if [ $RET_CONFLICT -ge 30 ]; then
   print_vars $TARGET $BUILD_TYPE $CLEAN_OR_OUT $PKGTYPE $MAKETARGET
   exit $RET_CONFLICT
fi

clean_opencl_cts() {
    echo "Cleaning $PROJ_NAME"
    rm -rf "$OPENCL_CTS_BUILD_DIR"
    rm -rf "$PACKAGE_DEB"
    rm -rf "$PACKAGE_RPM"
    rm -rf "$PACKAGE_ROOT/opencl-cts"
}

build_opencl_cts() {
    echo "Building $PROJ_NAME"
    mkdir -p "$OPENCL_CTS_BUILD_DIR"
    pushd "$OPENCL_CTS_BUILD_DIR"
    if [ ! -e Makefile ]; then
        cmake \
            -S "$OPENCL_CTS_ROOT" \
            $(rocm_cmake_params) \
            $(rocm_common_cmake_params) \
            -DCL_INCLUDE_DIR="$OPENCL_HEADERS_ROOT" \
            -DCL_LIB_DIR="$OPENCL_ICD_LOADER_BUILD_DIR" \
            -DOPENCL_LIBRARIES="-lOpenCL -lpthread" \
            -DGL_IS_SUPPORTED="ON"
    fi
    cmake --build . -- $MAKEOPTS
    popd
}

package_opencl_cts() {
    echo "Packaging $PROJ_NAME"
    pushd "$OPENCL_CTS_BUILD_DIR"
    cmake --build . -- package
    mkdir -p $PACKAGE_DEB
    mkdir -p $PACKAGE_RPM
    copy_if DEB "${CPACKGEN:-"DEB;RPM"}" "$PACKAGE_DEB" *.deb
    copy_if RPM "${CPACKGEN:-"DEB;RPM"}" "$PACKAGE_RPM" *.rpm
    popd
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

#parse the arguments
VALID_STR=`getopt -o hcraswlo:p: --long help,clean,release,static,outdir:,package: -- "$@"`
eval set -- "$VALID_STR"
while true ;
do
    case "$1" in
        (-c  | --clean )
            TARGET="clean" ; ((CLEAN_OR_OUT|=1)) ; shift ;;
        (-r  | --release )
            BUILD_TYPE="RelWithDebInfo" ; shift ;;
        (-h  | --help )
            printUsage ; exit 0 ;;
        (-a  | --address_sanitizer)
            ack_and_ignore_asan ; shift ;;
        (-w | --wheel)
                WHEEL_PACKAGE=true ; shift ;;
        (-o  | --outdir)
            TARGET="outdir"; PKGTYPE=$2 ; OUT_DIR_SPECIFIED=1 ; ((CLEAN_OR_OUT|=2)) ; shift 2 ;;
        (-p | --package)
            MAKETARGET="$2" ; shift 2;;
        (-s | --static)
            echo "-s parameter accepted but ignored" ; shift ;;
        --)     shift; break;; # end delimiter
        (*)
            echo " This should never come but just incase : UNEXPECTED ERROR Parm : [$1] ">&2 ; exit 20;;
    esac
done

case $TARGET in
    (clean) clean_opencl_cts ;;
    (build) build_opencl_cts ; package_opencl_cts; build_wheel "$OPENCL_ICD_LOADER_BUILD_DIR" "$PROJ_NAME";;
    (outdir) print_output_directory ;;
    (*) die "Invalid target $TARGET" ;;
esac

echo "Operation complete"
