#!/bin/bash

source "$(dirname "${BASH_SOURCE}")/compute_utils.sh"

printUsage() {
    echo
    echo "Usage: $(basename "${BASH_SOURCE}") [options ...]"
    echo
    echo "Options:"
    echo "  -c,  --clean              Clean output and delete all intermediate work"
    echo "  -d,  --devstg             Build only stage1 meta packages. Without this
                                      option script builds both stg1 and stg2"
    echo "  -p,  --package <type>     Specify packaging format"
    echo "  -r,  --release            Make a release build instead of a debug build"
    echo "  -a,  --address_sanitizer  Enable address sanitizer"
    echo "  -o,  --outdir <pkg_type>  Print path of output directory containing packages of
                                      type referred to by pkg_type"
    echo "  -h,  --help               Prints this help"
    echo "  -w,  --wheel              Creates python wheel package of rocm meta packages. 
                                      It needs to be used along with -r option"
    echo "  -s,  --static             Enable Support for Generating Static Meta Packages"
    echo
    echo "Possible values for <type>:"
    echo "  deb -> Debian format (default)"
    echo "  rpm -> RPM format"
    echo

    return 0
}

## ROCm build (using CMake) environment variables
PROJ_NAME="meta"
PACKAGE_ROOT="$(getPackageRoot)"
ROCM_BUILD_DIR="$(getBuildPath $PROJ_NAME)"
ROCM_PACKAGE_DEB="$PACKAGE_ROOT/deb/$PROJ_NAME"
ROCM_PACKAGE_RPM="$PACKAGE_ROOT/rpm/$PROJ_NAME"
ROCM_MAKE_OPTS="$DASH_JAY -C $ROCM_BUILD_DIR"
#ROCM_DKMS_MAKE_OPTS="$DASH_JAY -C $ROCM_DKMS_BUILD_DIR"
#ROCM_DEV_MAKE_OPTS="$DASH_JAY -C $ROCM_DEV_BUILD_DIR"
BUILD_TYPE="Debug"
TARGET="build"
SHARED_LIBS="ON"
CLEAN_OR_OUT=0;
MAKETARGET="deb"
PKGTYPE="deb"
ADDRESS_SANITIZER=false
STG2_PKG_BUILD="true"


#parse the arguments
VALID_STR=`getopt -o dhcraswo:p: --long help,devstg,clean,release,static,wheel,address_sanitizer,outdir:,package: -- "$@"`
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
        (-d | --devstg )
                STG2_PKG_BUILD="false" ; shift ;;
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

# Generate the pkg list and its versions list as a ";" seperated string and export it to the ENV.
# These PKG_LIST and VER_LIST envs will be used as a LIST in cmake function in utils.cmake
gen_pkg_ver_list() {

    # for mi* and navi* these packages needs to be excluded because of compression problem
         # compute-firmware_5.18.0-kfd-compute-rocm-npi-mi*-720_all.deb
         # linux-headers-5.18.0-kfd-compute-rocm-npi-mi*-720_5.18.0-kfd-compute-rocm-npi-mi*-720-1_amd64.deb
         # linux-image-5.18.0-kfd-compute-rocm-npi-mi*-720_5.18.0-kfd-compute-rocm-npi-mi*-720-1_amd64.deb
         # linux-image-6.2.8-kfd-compute-rocm-npi-navi*-wip-41_6.2.8-kfd-compute-rocm-npi-navi*-wip-41-1_amd64.deb
    # So making the exclude filelist generic
    declare -a Exclfiles=( "compute-firmware_*kfd-compute-rocm-npi-*.deb"
                           "linux-headers-*kfd-compute-rocm-npi-*.deb"
                           "linux-image-*kfd-compute-rocm-npi-*.deb"
                         )

    #this package needs to be excluded always
    Exclfiles+=('*dbgsym*')

    PLIST=""
    VLIST=""
    search_dir="$PACKAGE_ROOT/$PACKAGEEXT"

    # exclude *dbgsym* pkg files from the search
    for file in $(find $search_dir/. -type f -name "*.$PACKAGEEXT" ! -name ${Exclfiles[3]}  ! -name ${Exclfiles[0]}  ! -name ${Exclfiles[1]} ! -name ${Exclfiles[2]} );
    do
        if [ "$PACKAGEEXT" == "deb" ]; then
            dpkg -I $file | grep 'Package:\|Version:' > tmpfile
            PLIST="$(awk '/Package:/{print $2}' tmpfile);$PLIST"
            VLIST="$(awk '/Version:/{print $2}' tmpfile);$VLIST"

        elif [ "$PACKAGEEXT" == "rpm" ]; then
            rpm -qip $file | grep 'Name\|Version\|Release' > tmpfile
            PLIST="$(awk '/Name/{print $3}' tmpfile);$PLIST"
            VLIST="$(awk '/Version/{print $3}' tmpfile)-$(awk '/Release/{print $3}' tmpfile);$VLIST"

        fi
    done

    [ -f tmpfile ] && rm tmpfile

    # export as ENV variable
    export PKG_LIST="$PLIST"
    export VER_LIST="$VLIST"
    echo " PKG_LIST=$PKG_LIST"
    echo " VER_LIST=$VER_LIST"

}

generate_files_from_json() {
    #Generate existing pkg list and corresponding version list.
    #To be used for meta package dependencies version assignment.
    gen_pkg_ver_list

   bash -c 'sudo pip3 install dataclasses'
   PY_MODULE="packaging_files_generator.py "
   pushd "$ROCM_ROOT/packaging"

   if ! pyret=$(python3 $PY_MODULE ) ; then
      echo "FATAL!!! Python exectued with errors..."
      echo "Cannot proceed now bailing out .."
      exit 3
   fi

   popd

}

clean_rocm() {
    rm -rf "$ROCM_BUILD_DIR"
    rm -rf "$ROCM_PACKAGE_DEB"
    rm -rf "$ROCM_PACKAGE_RPM"
}


clean_gen_files() {

    GEN_FILES=`find $ROCM_ROOT/ -regextype sed -iregex ".*\.[iu]\{0,\}gen$"`
    while IFS= read -r line ; do
       if [ ! -z "$line" ]; then
          rm  "$line"
       fi
    done <<< "$GEN_FILES"

}


verify_meta_dependencies(){

   #make package path
   pkg_path="$OUT_DIR/$PACKAGEEXT/meta"
   PY_MODULE="dependency_tester.py "
   #options required by dependency tester
   options=" --path=$pkg_path --jd=$JOB_DESIGNATOR  --lpv=$ROCM_LIBPATCH_VERSION --bid=$BUILD_ID "
   echo " options == $options "
   pushd "$ROCM_ROOT/packaging"

   pyret=$(python3 $PY_MODULE $options >> dependency_log.txt 2>&1 ) || true

   echo "========== begin : dependency_log ==========="
   cat dependency_log.txt
   echo "========== end : dependency_log ==========="
   popd
   echo " verify_meta_dependencies : over "
}


build_rocm() {
    echo "Building Meta packaging"

    if [ ! -d "$ROCM_BUILD_DIR" ]; then
        mkdir -p "$ROCM_BUILD_DIR"
    fi
    pushd "$ROCM_BUILD_DIR"
    cmake \
            -DCMAKE_VERBOSE_MAKEFILE=1 \
            $(rocm_common_cmake_params) \
            -DBUILD_SHARED_LIBS=$SHARED_LIBS \
            -DCMAKE_INSTALL_PREFIX="$PACKAGE_ROOT" \
            -DCPACK_PACKAGING_INSTALL_PREFIX="$ROCM_INSTALL_PATH" \
            -DCPACK_GENERATOR="${CPACKGEN:-"DEB;RPM"}" \
            -DROCM_VERSION="$ROCM_VERSION" \
            $ROCM_ROOT
    popd

    if [[ "$SHARED_LIBS" == "ON" ]]; then
        if [[ "$STG2_PKG_BUILD" == "true" ]]; then
           cmake --build "$ROCM_BUILD_DIR" -- $ROCM_MAKE_OPTS pkg_rocm
        else
           cmake --build "$ROCM_BUILD_DIR" -- $ROCM_MAKE_OPTS STAGE_1_Targets
        fi

        # Optional Meta Package
        if [[ "$ADDRESS_SANITIZER" == true ]]; then
           if [[ "$STG2_PKG_BUILD" == "true" ]]; then
              cmake --build "$ROCM_BUILD_DIR" -- $ROCM_MAKE_OPTS pkg_rocm_asan
           else
              cmake --build "$ROCM_BUILD_DIR" -- $ROCM_MAKE_OPTS ASAN_STAGE_1_Targets
           fi
        fi
    else
    # Optional Static Meta Package
        cmake --build "$ROCM_BUILD_DIR" -- $ROCM_MAKE_OPTS pkg_rocm_language_static_dev
        #stg2
        cmake --build "$ROCM_BUILD_DIR" -- $ROCM_MAKE_OPTS pkg_rocm_static_dev
    fi

    copy_if DEB "${CPACKGEN:-"DEB;RPM"}" "$ROCM_PACKAGE_DEB" $ROCM_BUILD_DIR/rocm*.deb
    copy_if RPM "${CPACKGEN:-"DEB;RPM"}" "$ROCM_PACKAGE_RPM" $ROCM_BUILD_DIR/rocm*.rpm
}

print_output_directory() {
     case ${PKGTYPE} in
         ("deb")
             echo ${ROCM_PACKAGE_DEB};;
         ("rpm")
             echo ${ROCM_PACKAGE_RPM};;
         (*)
             echo "Invalid package type \"${PKGTYPE}\" provided for -o" >&2; exit 1;;
     esac
     exit
}

verifyEnvSetup

case $TARGET in
    (clean) clean_rocm ;;
    (build) generate_files_from_json && build_rocm && verify_meta_dependencies ; build_wheel "$ROCM_BUILD_DIR" "$PROJ_NAME" ;;
    (outdir) print_output_directory ;;
        (*) die "Invalid target $TARGET" ;;
esac

clean_gen_files

echo "Operation complete"
