#!/bin/bash
set -ex
source "$(dirname "${BASH_SOURCE[0]}")/compute_utils.sh"
set_component_src rocDecode
BUILD_DEV=ON
build_rocdecode() {
    if [ "$DISTRO_ID" = "centos-7" ] || \
       [ "$DISTRO_ID" = "mariner-2.0" ] || \
       [ "$DISTRO_ID" = "azurelinux-3.0" ] || \
       [ "$DISTRO_ID" = "debian-10" ]; then
     echo "Not building rocDecode for ${DISTRO_ID}. Exiting..."
     return 0
    fi

    echo "Start build"

    if [ "${ENABLE_STATIC_BUILDS}" == "true" ]; then
        ack_and_skip_static
    fi

    mkdir -p $BUILD_DIR && cd $BUILD_DIR
    # for i in {1..5}; do
    #     python3 ../rocDecode-setup.py --developer OFF && break || {
    #         echo "Attempt $i failed! Retrying in $((i * 30)) seconds..."
    #         sleep $((i * 30))
    #     }
    # done
    # python3 ${COMPONENT_SRC}/rocDecode-setup.py --developer OFF

    init_rocm_common_cmake_params
    cmake \
        "${rocm_math_common_cmake_params[@]}" \
        -DROCM_DEP_ROCMCORE=ON \
        -DROCDECODE_ENABLE_ROCPROFILER_REGISTER=ON \
        "${COMPONENT_SRC}"

    cmake --build "$BUILD_DIR" -- -j${PROC}
    cmake --build "$BUILD_DIR" -- install
    cmake --build "$BUILD_DIR" -- package

    rm -rf _CPack_Packages/ && find -name '*.o' -delete
    copy_if "${PKGTYPE}" "${CPACKGEN:-"DEB;RPM"}" "${PACKAGE_DIR}" "${BUILD_DIR}"/*."${PKGTYPE}"
    show_build_cache_stats
}
clean_rocdecode() {
    echo "Cleaning rocDecode build directory: ${BUILD_DIR} ${PACKAGE_DIR}"
    rm -rf "$BUILD_DIR" "$PACKAGE_DIR"
    echo "Done!"
}
stage2_command_args "$@"
case $TARGET in
    build) build_rocdecode; build_wheel ;;
    outdir) print_output_directory ;;
    clean) clean_rocdecode ;;
    *) die "Invalid target $TARGET" ;;
esac
