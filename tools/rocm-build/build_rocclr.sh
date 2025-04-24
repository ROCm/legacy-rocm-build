#!/bin/bash

source "$(dirname "${BASH_SOURCE}")/compute_utils.sh"
#// Currently, roccler does not supports .so but, this change makes this script future
#   ready & We shall not have to change anything at that time. Also its not doing deviating
#   from the current functionalities currently as well
printUsage() {
    echo
    echo "Usage: $(basename "${BASH_SOURCE}") [options ...] [make options]"
    echo
    echo "Options:"
    echo "  -h,  --help               Prints this help"
    echo "  -c,  --clean              Clean output and delete all intermediate work"
    echo "  -r,  --release            Make a release build instead of a debug build"
    echo "  -a,  --address_sanitizer  Enable address sanitizer"
    echo "  -s,  --static             Build static lib (.a).  build instead of dynamic/shared(.so) "
    echo "  -o,  --outdir <pkg_type>  Print path of output directory containing packages of type referred to by pkg_type"
    echo
    echo "Possible values for <type>:"
    echo "  deb -> Debian format (default)"
    echo "  rpm -> RPM format"
    echo

    return 0
}

MAKEOPTS="$DASH_JAY"

BUILD_PATH="$(getBuildPath rocclr)"

TARGET="build"
PACKAGE_ROOT="$(getPackageRoot)"
PACKAGE_DEB="$(getPackageRoot)/deb/rocclr"
PACKAGE_RPM="$(getPackageRoot)/rpm/rocclr"
CORE_BUILD_DIR="$(getBuildPath hsa-core)"
BUILD_TYPE="Debug"
SHARED_LIBS="ON"
CLEAN_OR_OUT=0;
MAKETARGET="deb"
PKGTYPE="deb"


#parse the arguments
VALID_STR=`getopt -o hcraso: --long help,clean,release,static,address_sanitizer,outdir: -- "$@"`
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
                set_address_sanitizer_on ; shift ;;
        (-s | --static)
                SHARED_LIBS="OFF" ; shift ;;
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


clean_rocclr() {
    # Delete cmake output directory
    rm -rf "$BUILD_PATH"
    rm -rf "$PACKAGE_DEB"
    rm -rf "$PACKAGE_RPM"
}

build_rocclr() {
    # rocclr is now a part of clr repo.
    # also it does not need to be built independently when build shared libs.
    # might be needed when building static libs. so leave it place for static libs.
    if [ "$SHARED_LIBS" = "ON" ]; then
        echo "rocclr not a standalone repo. skipping build" >&2
        echo "rocclr not a standalone repo. skipping build"
        exit 0  # This is not an error
    fi

    if [ ! -e "$CLR_ROOT/CMakeLists.txt" ]; then
        # We are in a branch that has migrated to clr repo
        _ROCclr_CMAKELIST_DIR="$CLR_ROOT"
    elif [ ! -e "$ROCclr_ROOT/CMakeLists.txt" ]; then
        # We seem to have hit a branch in which both the old and new repo don't exist
        echo "No $ROCclr_ROOT/CMakeLists.txt file, skipping rocclr" >&2
        echo "No $ROCclr_ROOT/CMakeLists.txt file, skipping rocclr"
        exit 0   # This is not an error
    else
        # We are in a branch that has not yet migrated to clr repo
        _ROCclr_CMAKELIST_DIR="$ROCclr_ROOT"
    fi
    echo "$_ROCclr_CMAKELIST_DIR"
    mkdir -p "$BUILD_PATH"
    pushd "$BUILD_PATH"
    print_lib_type $SHARED_LIBS
    if [ ! -e Makefile ]; then
        echo "Building ROCclr CMake environment"

        cmake -DUSE_COMGR_LIBRARY=ON \
            $(rocm_cmake_params) \
            -DBUILD_SHARED_LIBS=$SHARED_LIBS \
            -DLLVM_INCLUDES="$LLVM_ROOT/include" \
            $(rocm_common_cmake_params) \
            "$_ROCclr_CMAKELIST_DIR"

        echo "CMake complete"
    fi

    echo "Building ROCclr"
    cmake --build . -- $MAKEOPTS "VERBOSE=1"

    popd
}

# When use -o option, the code should directly exit.
# The rest part of the code will not execute.
# Otherwise, it will cause an error of the caller code.
case $TARGET in
    (clean) clean_rocclr ;;
    (build) build_rocclr ;;
    (outdir) exit ;;
    (*) die "Invalid target $TARGET" ;;
esac

echo "Operation complete"
