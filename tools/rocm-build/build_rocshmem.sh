#!/bin/bash

set -ex

source "$(dirname "${BASH_SOURCE[0]}")/compute_utils.sh"

set_component_src rocSHMEM

build_rocshmem() {

    if [ "${ENABLE_ADDRESS_SANITIZER}" == "true" ]; then
        echo "Skip building rocSHMEM becasue of Address Sanitizer"
        return 0
    fi

    if [ "${ENABLE_STATIC_BUILDS}" == "true" ]; then
        ack_and_skip_static
    fi

    echo "Start build rocSHMEM"

    #Build step
    cd $COMPONENT_SRC

    #PREREQ STEPS step
    # Install OMPI + UCC + UCX
    export _ROCM_DIR=$ROCM_INSTALL_PATH
    mkdir -p "$BUILD_DIR"/rocshmem
    export BUILD_DIR
    export MPI_HOME=$BUILD_DIR/install/ompi/

    # Update PATH and LD_LIBRARY_PATH
    # Change to your location, these will be deleted in install_dependencies.sh
    export PATH="$BUILD_DIR"/install/ucx/bin:$PATH
    export PATH="$BUILD_DIR"/install/ucc/bin:$PATH
    export PATH="$BUILD_DIR"/install//ompi/bin:$PATH

    export LD_LIBRARY_PATH="$BUILD_DIR"/install/ucx/lib:$LD_LIBRARY_PATH
    export LD_LIBRARY_PATH="$BUILD_DIR"/install/ucc/lib:$LD_LIBRARY_PATH
    export LD_LIBRARY_PATH="$BUILD_DIR"/install/ompi/lib:$LD_LIBRARY_PATH

    $COMPONENT_SRC/scripts/install_dependencies.sh

    cd "$BUILD_DIR"/rocshmem
    init_rocm_common_cmake_params

    CXX="$ROCM_ROOT"/bin/hipcc \
    cmake "${rocm_math_common_cmake_params[@]}"\
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=$ROCM_INSTALL_PATH \
        -DCMAKE_VERBOSE_MAKEFILE=OFF \
        -DDEBUG=OFF \
        -DPROFILE=OFF \
        -DUSE_GPU_IB=OFF \
        -DUSE_RO=OFF \
        -DUSE_DC=OFF \
        -DUSE_IPC=ON \
        -DUSE_COHERENT_HEAP=ON \
        -DUSE_THREADS=OFF \
        -DUSE_WF_COAL=OFF \
        -DUSE_SINGLE_NODE=ON \
        -DUSE_HOST_SIDE_HDP_FLUSH=OFF \
        $COMPONENT_SRC

    cmake --build "$BUILD_DIR"/rocshmem -- -j${PROC}
    cmake --build "$BUILD_DIR"/rocshmem -- install
    cmake --build "$BUILD_DIR"/rocshmem -- package

    rm -rf _CPack_Packages/ && find -name '*.o' -delete
    copy_if "${PKGTYPE}" "${CPACKGEN:-"deb;rpm"}" "${PACKAGE_DIR}" "${BUILD_DIR}"/rocshmem/*."${PKGTYPE}"

    show_build_cache_stats
}

clean_rocshmem() {
    echo "Cleaning rocSHMEM build directory: ${BUILD_DIR} ${PACKAGE_DIR}"
    rm -rf "$BUILD_DIR" "$PACKAGE_DIR"
    echo "Done!"
}

stage2_command_args "$@"

case $TARGET in
    build) build_rocshmem; build_wheel ;;
    outdir) print_output_directory ;;
    clean) clean_rocshmem ;;
    *) die "Invalid target $TARGET" ;;
esac