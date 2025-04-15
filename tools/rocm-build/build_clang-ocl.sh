#!/bin/bash

source "$(dirname "${BASH_SOURCE}")/compute_utils.sh"

printUsage() {
    echo
    echo "Usage: $(basename "${BASH_SOURCE}") [-c|-r|-h] [makeopts]"
    echo
    echo "Options:"
    echo "  -c,  --clean              Removes all clang-ocl build artifacts"
    echo "  -r,  --release            Build non-debug version clang-ocl (default is debug)"
    echo "  -a,  --address_sanitizer  Enable address sanitizer"
    echo "  -o,  --outdir <pkg_type>  Print path of output directory containing packages of
                                      type referred to by pkg_type"
    echo "  -h,  --help               Prints this help"
    echo "  -s,  --static             Supports static CI by accepting this param & not bailing out. No effect of the param though"
    echo

    return 0
}


TARGET="build"
CLANG_OCL_DEST="$(getBinPath)"
CLANG_OCL_SRC_ROOT="$CLANG_OCL_ROOT"
CLANG_OCL_BUILD_DIR="$(getBuildPath clang-ocl)"

MAKEARG="$DASH_JAY"
PACKAGE_ROOT="$(getPackageRoot)"
PACKAGE_UTILS="$(getUtilsPath)"
CLANG_OCL_PACKAGE_DEB="$PACKAGE_ROOT/deb/clang-ocl"
CLANG_OCL_PACKAGE_RPM="$PACKAGE_ROOT/rpm/clang-ocl"
BUILD_TYPE="Debug"
SHARED_LIBS="ON"
CLEAN_OR_OUT=0;
MAKETARGET="deb"
PKGTYPE="deb"


VALID_STR=`getopt -o hcraso:g: --long help,clean,release,clean,static,address_sanitizer,outdir:,gpu_list: -- "$@"`
eval set -- "$VALID_STR"

while true ;
do
    case "$1" in
        (-h | --help)
                printUsage ; exit 0;;
        (-c | --clean)
                TARGET="clean" ; ((CLEAN_OR_OUT|=1)) ; shift ;;
        (-r | --release)
                MAKEARG="$MAKEARG BUILD_TYPE=rel" ;  BUILD_TYPE="Release" ; shift ;;
        (-a | --address_sanitizer)
                set_asan_env_vars
                set_address_sanitizer_on ; shift ;;
        (-s | --static)
                SHARED_LIBS="OFF" ; shift ;;
        (-o | --outdir)
                TARGET="outdir"; PKGTYPE=$2 ; OUT_DIR_SPECIFIED=1 ; ((CLEAN_OR_OUT|=2)) ; shift 2 ;;
        (-g | --gpu_list )
                GPU_LIST=$2; shift 2 ;;
        --)     shift; break;;
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

clean_clang-ocl() {
    echo "Removing clang-ocl"
    rm -rf $CLANG_OCL_DEST/clang-ocl
    rm -rf $CLANG_OCL_BUILD_DIR
    rm -rf $CLANG_OCL_PACKAGE_DEB
    rm -rf $CLANG_OCL_PACKAGE_RPM
}

build_clang-ocl() {
    if [ ! -d "$CLANG_OCL_BUILD_DIR" ]; then
        mkdir -p $CLANG_OCL_BUILD_DIR
        pushd $CLANG_OCL_BUILD_DIR

        if [ -e $PACKAGE_ROOT/lib/bitcode/opencl.amdgcn.bc ]; then
            BC_DIR="$ROCM_INSTALL_PATH/lib"
        else
            BC_DIR="$ROCM_INSTALL_PATH/amdgcn/bitcode"
        fi

        cmake \
            $(rocm_cmake_params) \
            -DDISABLE_CHECKS="ON" \
            -DCLANG_BIN="$ROCM_INSTALL_PATH/llvm/bin" \
            -DBITCODE_DIR="$BC_DIR" \
	    $(rocm_common_cmake_params) \
            -DCPACK_SET_DESTDIR="OFF" \
            $CLANG_OCL_SRC_ROOT

        echo "Making clang-ocl:"
        cmake --build . -- $MAKEARG
        cmake --build . -- $MAKEARG install
        cmake --build . -- $MAKEARG package
        popd
    fi

    copy_if DEB "${CPACKGEN:-"DEB;RPM"}" "$CLANG_OCL_PACKAGE_DEB" $CLANG_OCL_BUILD_DIR/rocm-clang-ocl*.deb
    copy_if RPM "${CPACKGEN:-"DEB;RPM"}" "$CLANG_OCL_PACKAGE_RPM" $CLANG_OCL_BUILD_DIR/rocm-clang-ocl*.rpm
}


print_output_directory() {
     case ${PKGTYPE} in
         ("deb")
             echo ${CLANG_OCL_PACKAGE_DEB};;
         ("rpm")
             echo ${CLANG_OCL_PACKAGE_RPM};;
         (*)
             echo "Invalid package type \"${PKGTYPE}\" provided for -o" >&2; exit 1;;
     esac
     exit
}

case $TARGET in
    (clean) clean_clang-ocl ;;
    (build) build_clang-ocl ;;
   (outdir) print_output_directory ;;
        (*) die "Invalid target $TARGET" ;;
esac

echo "Operation complete"
exit 0

