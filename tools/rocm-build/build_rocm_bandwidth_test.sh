#!/bin/bash -x

source "$(dirname "${BASH_SOURCE}")/compute_utils.sh"

printUsage() {
    echo
    echo "Usage: $(basename "${BASH_SOURCE}") [options ...]"
    echo
    echo "Options:"
    echo "  -s,  --static             Component/Build does not support static builds just accepting this param & ignore. No effect of the param on this build"
    echo "  -c,  --clean              Clean output and delete all intermediate work"
    echo "  -p,  --package <type>     Specify packaging format"
    echo "  -r,  --release            Make a release build instead of a debug build"
    echo "  -a,  --address_sanitizer  Enable address sanitizer"
    echo "  -w,  --wheel              Creates python wheel package of bandwidth test.
                                      It needs to be used along with -r option"
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

#
# Build environment variables. The value of test
# root is imported from the envsetu.sh
#
PROJ_NAME="rocm_bandwidth_test"
TEST_BIN_DIR="$(getBinPath)"
TEST_NAME="rocm-bandwidth-test"
TEST_UTILS_DIR="$(getUtilsPath)"
TEST_SRC_DIR="$PROJ_NAME"
TEST_BLD_DIR="$(getBuildPath $TEST_SRC_DIR)"

#
# Env variables for packaging rocm_bandwidth_test
#
ROCM_PKG_PREFIX="$ROCM_INSTALL_PATH"
TEST_PKG_ROOT="$(getPackageRoot)"
TEST_PKG_DEB="$(getPackageRoot)/deb/$TEST_SRC_DIR"
TEST_PKG_RPM="$(getPackageRoot)/rpm/$TEST_SRC_DIR"

#
# Build the name of run script
#
RUN_SCRIPT=$(echo $(basename "${BASH_SOURCE}") | sed "s/build_/run_/")

#
# Specify the default build type as debug
# DASH_JAY - Bind number of threads to use value set
# by user in their shell config file (.bashrc)
#
TARGET="build"
MAKETARGET="all"
BUILD_TYPE="Debug"
MAKEARG="$DASH_JAY"
SHARED_LIBS="ON"
CLEAN_OR_OUT=0;
PKGTYPE="deb"


#parse the arguments
VALID_STR=`getopt -o hcraswo:p: --long help,clean,release,static,wheel,address_sanitizer,outdir:,package: -- "$@"`
eval set -- "$VALID_STR"

#
# Override default bindings if user specifies an option
#
while true ;
do
    #echo "parocessing $1"
    case "$1" in
        (-h | --help)
                printUsage ; exit 0;;
        (-c | --clean)
                TARGET="clean" ; ((CLEAN_OR_OUT|=1)) ; shift ;;
        (-r | --release)
                BUILD_TYPE="Release" ; MAKEARG="$MAKEARG REL=1" ;  shift ;;
        (-a | --address_sanitizer)
                set_asan_env_vars
                set_address_sanitizer_on ; shift ;;
        (-s | --static)
                ack_and_skip_static ;;
        (-w | --wheel)
                WHEEL_PACKAGE=true ; shift ;;
        (-o | --outdir)
                TARGET="outdir"; PKGTYPE=$2 ; OUT_DIR_SPECIFIED=1 ; ((CLEAN_OR_OUT|=2)) ; shift 2 ;;
        (-p | --package)
                MAKETARGET="$2" ; CPACKGEN="${2^^}" ; shift 2;;
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

#
# Clean the test build from system
#
clean_rocm_bandwidth_test() {
    echo "Cleaning $TEST_NAME"

    rm -rf $TEST_BLD_DIR
    rm -rf $TEST_PKG_DEB
    rm -rf $TEST_PKG_RPM
    rm -rf $TEST_BIN_DIR/$TEST_NAME
    rm -f  $TEST_UTILS_DIR/$RUN_SCRIPT
}

#
# Build the test by runninh cmake
#
build_rocm_bandwidth_test() {

    echo "Building $TEST_NAME"

    #
    # If build directory does not exist create it
    #
    if [ ! -d "$TEST_BLD_DIR" ]; then
        mkdir -p "$TEST_BLD_DIR"
        pushd "$TEST_BLD_DIR"

        cmake \
            -DCMAKE_BUILD_TYPE="$BUILD_TYPE"      \
            -DCMAKE_VERBOSE_MAKEFILE=1 \
            -DCMAKE_INSTALL_PREFIX="$TEST_PKG_ROOT" \
            -DCPACK_PACKAGING_INSTALL_PREFIX="$ROCM_INSTALL_PATH" \
            -DCMAKE_PREFIX_PATH="$ROCM_INSTALL_PATH" \
	    $(rocm_common_cmake_params) \
            -DCPACK_GENERATOR="${CPACKGEN:-"DEB;RPM"}" \
            -DROCM_PATCH_VERSION=$ROCM_LIBPATCH_VERSION \
            -DCMAKE_MODULE_PATH="$ROCM_BANDWIDTH_TEST_ROOT/cmake_modules" \
            -DADDRESS_SANITIZER="$ADDRESS_SANITIZER" \
            "$ROCM_BANDWIDTH_TEST_ROOT"

        # Go back to the directory you came from
        popd
    fi

    # Run the make cmd to build test
    echo "Building $TEST_NAME"
    cmake --build "$TEST_BLD_DIR" -- $MAKEARG -C $TEST_BLD_DIR

    # Run the make cmd to install test
    echo "Installing $TEST_NAME"
    cmake --build "$TEST_BLD_DIR" -- $MAKEARG -C $TEST_BLD_DIR install

    # Run the make cmd to package test
    echo "Packaging $TEST_NAME"
    cmake --build "$TEST_BLD_DIR" -- $MAKEARG -C $TEST_BLD_DIR package

    # Run the copy cmd to place test in bin folder
    mkdir -p "$TEST_BIN_DIR"
    echo "Copying $TEST_NAME to $TEST_BIN_DIR"
    progressCopy "$TEST_BLD_DIR/$TEST_NAME" "$TEST_BIN_DIR"

    # Run the copy cmd to place run script in utils folder
    mkdir -p "$TEST_UTILS_DIR"
    echo "Copying $RUN_SCRIPT to $TEST_UTILS_DIR"
    progressCopy "$SCRIPT_ROOT/$RUN_SCRIPT" "$TEST_UTILS_DIR"

    copy_if DEB "${CPACKGEN:-"DEB;RPM"}" "$TEST_PKG_DEB" $TEST_BLD_DIR/*.deb
    copy_if RPM "${CPACKGEN:-"DEB;RPM"}" "$TEST_PKG_RPM" $TEST_BLD_DIR/*.rpm

}

print_output_directory() {
    case ${PKGTYPE} in
        ("deb")
            echo ${TEST_PKG_DEB};;
        ("rpm")
            echo ${TEST_PKG_RPM};;
        (*)
            echo "Invalid package type \"${PKGTYPE}\" provided for -o" >&2; exit 1;;
    esac
    exit
}
verifyEnvSetup

case $TARGET in
    (clean) clean_rocm_bandwidth_test ;;
    (build) build_rocm_bandwidth_test; build_wheel "$TEST_BLD_DIR" "$PROJ_NAME" ;;
    (outdir) print_output_directory ;;
    (*) die "Invalid target $TARGET" ;;
esac

echo "Operation complete"
