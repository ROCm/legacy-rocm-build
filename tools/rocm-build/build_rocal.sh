#!/bin/bash

set -ex
source "$(dirname "${BASH_SOURCE[0]}")/compute_utils.sh"

set_component_src rocAL

build_rocal() {

    if [ "$DISTRO_ID" = "mariner-2.0" ] || [ "$DISTRO_ID" = "azurelinux-3.0" ] ; then
        echo "Not building rocal for ${DISTRO_ID}. Exiting..."
        return 0
    fi

    echo "Start build"

    if [ "${ENABLE_STATIC_BUILDS}" == "true" ]; then
        ack_and_skip_static
    fi

    # Enable ASAN
    # Temporarily disable ASAN for rocal - SWDEV-471302
    #if [ "${ENABLE_ADDRESS_SANITIZER}" == "true" ]; then
    #    set_asan_env_vars
    #    set_address_sanitizer_on
    #fi
    pushd /tmp

    # PyBind11
    rm -rf pybind11
    git clone -b v2.11.1  https://github.com/pybind/pybind11
    cd pybind11 && mkdir build && cd build
    cmake -DDOWNLOAD_CATCH=ON -DDOWNLOAD_EIGEN=ON ../
    make -j$(nproc) && sudo make install
    cd ../..

    # Turbo JPEG
    rm -rf libjpeg-turbo
    git clone -b 3.0.2 https://github.com/libjpeg-turbo/libjpeg-turbo.git
    cd libjpeg-turbo && mkdir build && cd build
    cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=RELEASE -DENABLE_STATIC=FALSE -DCMAKE_INSTALL_DEFAULT_LIBDIR=lib -DWITH_JPEG8=TRUE ..
    make -j$(nproc) && sudo make install
    cd ../..

    # RapidJSON
    rm -rf rapidjson
    git clone https://github.com/Tencent/rapidjson.git
    cd rapidjson && mkdir build && cd build
    cmake .. && make -j$(nproc) && sudo make install
    popd

    mkdir -p $BUILD_DIR && cd $BUILD_DIR

    # python3 ../rocAL-setup.py

    if [[ "${DISTRO_ID}" == almalinux-8* ]]; then
        cmake -DPYTHON_VERSION_SUGGESTED=3.8 -DAMDRPP_PATH=$ROCM_PATH ${COMPONENT_SRC}
    else
        cmake -DAMDRPP_PATH=$ROCM_PATH ${COMPONENT_SRC}
    fi
    make -j8
    cmake --build . --target PyPackageInstall
    make package

    rm -rf _CPack_Packages/ && find -name '*.o' -delete
    copy_if "${PKGTYPE}" "${CPACKGEN:-"DEB;RPM"}" "${PACKAGE_DIR}" "${BUILD_DIR}"/*."${PKGTYPE}"
    show_build_cache_stats
}

clean_rocal() {
    echo "Cleaning rocAL build directory: ${BUILD_DIR} ${PACKAGE_DIR}"
    rm -rf "$BUILD_DIR" "$PACKAGE_DIR"
    echo "Done!"
}

stage2_command_args "$@"

case $TARGET in
    build) build_rocal; build_wheel ;;
    outdir) print_output_directory ;;
    clean) clean_rocal ;;
    *) die "Invalid target $TARGET" ;;
esac
