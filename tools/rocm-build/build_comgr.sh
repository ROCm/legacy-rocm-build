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
    echo "  -h,  --help               Prints this help"
    echo "  -s,  --static             Build static lib (.a).  build instead of dynamic/shared(.so) "
    echo "  -w,  --wheel              Creates python wheel package of comgr. It needs to be used along with -r option"
    echo "  -l,  --link_llvm_static   Link to LLVM statically.  Default is to dynamically link to LLVM; requires that LLVM dylibs are created."
    echo
    echo "Possible values for <type>:"
    echo "  deb -> Debian format (default)"
    echo "  rpm -> RPM format"
    echo

    return 0
}

## Build environment variables
API_NAME=amd_comgr
PROJ_NAME=$API_NAME
LIB_NAME=lib${API_NAME}
TARGET=build
MAKETARGET=deb
PACKAGE_ROOT=$(getPackageRoot)
PACKAGE_LIB=$(getLibPath)
PACKAGE_INCLUDE=$(getIncludePath)
BUILD_DIR=$(getBuildPath $API_NAME)
PACKAGE_DEB=$PACKAGE_ROOT/deb/$PROJ_NAME
PACKAGE_RPM=$PACKAGE_ROOT/rpm/$PROJ_NAME
PACKAGE_PREFIX=$ROCM_INSTALL_PATH
BUILD_TYPE=Debug
MAKE_OPTS="$DASH_JAY CTEST_OUTPUT_ON_FAILURE=1 -C $BUILD_DIR"
VERBOSE_OPTS="AMD_COMGR_EMIT_VERBOSE_LOGS=1 AMD_COMGR_REDIRECT_LOGS=stdout"
SHARED_LIBS="ON"
CLEAN_OR_OUT=0;
PKGTYPE="deb"
MAKETARGET="deb"

# link to LLVM dynamicaly.  Default is to link to llvm dynamically.
# temporarily set this default to OFF until we resolve Issues
LINK_LLVM_DYLIB="OFF"

#parse the arguments
VALID_STR=`getopt -o hcraswlo:p: --long help,clean,release,address_sanitizer,static,wheel,link_llvm_static,outdir:,package: -- "$@"`
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
        (-l | --link_llvm_static)
                LINK_LLVM_DYLIB="OFF"; shift ;;
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

    rm -rf $BUILD_DIR
    rm -rf $PACKAGE_DEB
    rm -rf $PACKAGE_RPM
    rm -rf $PACKAGE_ROOT/${PROJ_NAME}
    rm -rf $PACKAGE_LIB/${LIB_NAME}*
}

build() {
    echo "Building $PROJ_NAME"

    mkdir -p "$BUILD_DIR"
    pushd "$BUILD_DIR"
    if [ "$SHARED_LIBS" == "OFF" ]
    then
       echo " Building Archive "
    else
       echo " Building Shared Object "
    fi

# Remove CTEST var once SWDEV-381396 is fixed
    cmake \
        $(rocm_cmake_params) \
        -DBUILD_SHARED_LIBS=$SHARED_LIBS \
        $(rocm_common_cmake_params) \
        -DCMAKE_DISABLE_FIND_PACKAGE_hip=TRUE \
        -DCMAKE_CTEST_ARGUMENTS="--exclude-regex;multithread_test" \
        -DLLVM_LINK_LLVM_DYLIB=$LINK_LLVM_DYLIB \
        -DLLVM_ENABLE_LIBCXX=$LINK_LLVM_DYLIB \
        $COMGR_ROOT

    popd
    cmake --build "$BUILD_DIR" -- $MAKE_OPTS
    cmake --build "$BUILD_DIR" -- $MAKE_OPTS $VERBOSE_OPTS test
    cmake --build "$BUILD_DIR" -- $MAKE_OPTS install
    cmake --build "$BUILD_DIR" -- $MAKE_OPTS package

    mkdir -p $PACKAGE_LIB
    cp -R $BUILD_DIR/${LIB_NAME}* $PACKAGE_LIB

    copy_if DEB "${CPACKGEN:-"DEB;RPM"}" "$PACKAGE_DEB" $BUILD_DIR/comgr*.deb
    copy_if RPM "${CPACKGEN:-"DEB;RPM"}" "$PACKAGE_RPM" $BUILD_DIR/comgr*.rpm
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

case $TARGET in
    (clean) clean ;;
    (build) build; build_wheel "$BUILD_DIR" "$PROJ_NAME" ;;
    (outdir) print_output_directory ;;
    (*) die "Invalid target $TARGET" ;;
esac

echo "Operation complete"
