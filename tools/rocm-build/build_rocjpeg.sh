#!/bin/bash
set -ex
source "$(dirname "${BASH_SOURCE[0]}")/compute_utils.sh"
set_component_src rocJPEG
BUILD_DEV=ON
build_rocjpeg() {
    if [ "$DISTRO_ID" = "centos-7" ] || [ "$DISTRO_ID" = "sles-15.4" ] || [ "$DISTRO_ID" = "azurelinux-3.0" ]  || [ "$DISTRO_ID" = "debian-10" ]; then
     echo "Not building rocJPEG for ${DISTRO_ID}. Exiting..." 
     return 0
    fi
    echo "Start build"

    if [ "${ENABLE_STATIC_BUILDS}" == "true" ]; then
        ack_and_skip_static
    fi

    mkdir -p $BUILD_DIR && cd $BUILD_DIR
    # python3 ../rocJPEG-setup.py

    cmake -DROCM_DEP_ROCMCORE=ON -DROCJPEG_ENABLE_ROCPROFILER_REGISTER=ON "$COMPONENT_SRC"
    make -j8
    make install
    make package

    cmake --build "$BUILD_DIR" -- -j${PROC}
    cpack -G ${PKGTYPE^^}
    rm -rf _CPack_Packages/ && find -name '*.o' -delete
    copy_if "${PKGTYPE}" "${CPACKGEN:-"DEB;RPM"}" "${PACKAGE_DIR}" "${BUILD_DIR}"/*."${PKGTYPE}"
    show_build_cache_stats
}
clean_rocjpeg() {
    echo "Cleaning rocJPEG build directory: ${BUILD_DIR} ${PACKAGE_DIR}"
    rm -rf "$BUILD_DIR" "$PACKAGE_DIR"
    echo "Done!"
}
stage2_command_args "$@"
case $TARGET in
    build) build_rocjpeg ;;
    outdir) print_output_directory ;;
    clean) clean_rocjpeg ;;
    *) die "Invalid target $TARGET" ;;
esac
