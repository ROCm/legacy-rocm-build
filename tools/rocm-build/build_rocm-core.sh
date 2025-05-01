#!/bin/bash

source "$(dirname "${BASH_SOURCE}")/compute_utils.sh"

printUsage() {
    echo
    echo "Usage: $(basename "${BASH_SOURCE}") [options ...]"
    echo
    echo "Options:"
    echo "  -c,  --clean              Clean output and delete all intermediate work"
    echo "  -p,  --package <type>     Specify packaging format"
    echo "  -r,  --release            Make a release build instead of a debug build"
    echo "  -a,  --address_sanitizer  Enable address sanitizer"
    echo "  -o,  --outdir <pkg_type>  Print path of output directory containing packages of
                                      type referred to by pkg_type"
    echo "  -s,  --static             Build static lib (.a).  build instead of dynamic/shared(.so) "
    echo "  -w,  --wheel              Creates python wheel package of rocm-core. 
                                      It needs to be used along with -r option"
    echo "  -h,  --help               Prints this help"
    echo
    echo "Possible values for <type>:"
    echo "  deb -> Debian format (default)"
    echo "  rpm -> RPM format"
    echo

    return 0
}

## ROCm build (using CMake) environment variables
PROJ_NAME="rocm-core"
PACKAGE_ROOT="$(getPackageRoot)"
ROCM_CORE_BUILD_DIR="$(getBuildPath rocm_core)"
ROCM_CORE_PACKAGE_DEB="$(getPackageRoot)/deb/$PROJ_NAME"
ROCM_CORE_PACKAGE_RPM="$(getPackageRoot)/rpm/$PROJ_NAME"
ROCM_CORE_MAKE_OPTS="$DASH_JAY -C $ROCM_CORE_BUILD_DIR"
BUILD_TYPE="Debug"
TARGET="build"
SHARED_LIBS="ON"
CLEAN_OR_OUT=0;
MAKETARGET="deb"
PKGTYPE="deb"
ADDRESS_SANITIZER=false

#parse the arguments
VALID_STR=`getopt -o hcraswo:p: --long help,clean,release,static,address_sanitizer,outdir,wheel:,package: -- "$@"`
eval set -- "$VALID_STR"

while true ;
do
    case "$1" in
        (-h | --help)
                printUsage ; exit 0;;
        (-c | --clean)
                TARGET="clean" ; ((CLEAN_OR_OUT|=1)) ; shift ;;
        (-r | --release)
                BUILD_TYPE="Release" ; shift ;;
        (-a | --address_sanitizer)
                set_asan_env_vars
                set_address_sanitizer_on
                ADDRESS_SANITIZER=true ; shift ;;
        (-s | --static)
                SHARED_LIBS="OFF" ; shift ;;
        (-w | --wheel)
                WHEEL_PACKAGE=true ; shift ;;
        (-o | --outdir)
                TARGET="outdir"; PKGTYPE=$2 ; OUT_DIR_SPECIFIED=1 ; ((CLEAN_OR_OUT|=2)) ; shift 2 ;;
        (-p | --package )
                MAKETARGET=$2 ; shift 2 ;;
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


clean_rocm_core() {
    rm -rf "$ROCM_CORE_BUILD_DIR"
    rm -rf "$ROCM_CORE_PACKAGE_DEB"
    rm -rf "$ROCM_CORE_PACKAGE_RPM"
}

build_rocm_core() {
    echo "Building rocm-core "

    if [ ! -d "$ROCM_CORE_BUILD_DIR" ]; then
       mkdir -p "$ROCM_CORE_BUILD_DIR"
    fi
    pushd "$ROCM_CORE_BUILD_DIR"
    cmake \
            $(rocm_cmake_params) \
            $(rocm_common_cmake_params) \
            -DBUILD_SHARED_LIBS=$SHARED_LIBS \
            -DCPACK_DEBIAN_PACKAGE_RELEASE=$CPACK_DEBIAN_PACKAGE_RELEASE \
            -DCPACK_RPM_PACKAGE_RELEASE=$CPACK_RPM_PACKAGE_RELEASE \
            -DROCM_VERSION="$ROCM_VERSION" \
            -DBUILD_ID="$BUILD_ID" \
            $ROCM_CORE_ROOT

    make && make install && make package
    popd

    copy_if DEB "${CPACKGEN:-"DEB;RPM"}" "$ROCM_CORE_PACKAGE_DEB" $ROCM_CORE_BUILD_DIR/rocm*.deb
    copy_if RPM "${CPACKGEN:-"DEB;RPM"}" "$ROCM_CORE_PACKAGE_RPM" $ROCM_CORE_BUILD_DIR/rocm*.rpm
}

print_output_directory() {
    case ${PKGTYPE} in
         ("deb")
             echo ${ROCM_CORE_PACKAGE_DEB};;
         ("rpm")
             echo ${ROCM_CORE_PACKAGE_RPM};;
         (*)
             echo "Invalid package type \"${PKGTYPE}\" provided for -o" >&2; exit 1;;
    esac
    exit
}

verifyEnvSetup

case $TARGET in
    (clean)
        clean_rocm_core
        ;;
    (build)
        build_rocm_core
        build_wheel "$ROCM_CORE_BUILD_DIR" "$PROJ_NAME"
        ;;
    (outdir)
        print_output_directory
        ;;
    (*)
        die "Invalid target $TARGET"
        ;;
esac

echo "Operation complete"
