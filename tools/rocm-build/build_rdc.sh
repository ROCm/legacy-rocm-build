#!/bin/bash

set -ex

### Set up RPATH for RDC to simplify finding RDC libraries. Please note that
### ROCm has a setup_env.sh script which already populates these variables.
### These variables are then used inside compute_utils.sh.
###
### We need to append additional paths to these variables BEFORE sourcing
### compute_utils.sh

# lib/rdc/librdc_rocp.so needs lib/librdc_bootstrap.so
# this also covers the ASAN usecase
ROCM_LIB_RPATH=$ROCM_LIB_RPATH:'$ORIGIN/..'
# grpc
ROCM_LIB_RPATH=$ROCM_LIB_RPATH:'$ORIGIN/rdc/grpc/lib'
ROCM_LIB_RPATH=$ROCM_LIB_RPATH:'$ORIGIN/grpc/lib'
# help RDC executables find RDC libraries
# lib/librdc_bootstrap.so.0 and grpc
ROCM_EXE_RPATH=$ROCM_EXE_RPATH:'$ORIGIN/../lib/rdc/grpc/lib'
if [ "${ENABLE_ADDRESS_SANITIZER}" == "true" ]; then
    ROCM_EXE_RPATH="$ROCM_ASAN_EXE_RPATH:$ROCM_EXE_RPATH"
fi

source "$(dirname "${BASH_SOURCE[0]}")/compute_utils.sh"

set_component_src rdc

# RDC
# BUILD ARGUMENTS
BUILD_DOCS="no"
GRPC_PROTOC_ROOT="${BUILD_DIR}/grpc"
GRPC_SEARCH_ROOT="/usr/grpc"
GRPC_DESIRED_VERSION="1.67.1" # do not include 'v'
# lib/librocm_smi64.so and lib/libamd_smi.so

# check if exact version of gRPC is installed
find_grpc() {
    grep -s -F "$GRPC_DESIRED_VERSION" ${GRPC_SEARCH_ROOT}/*/cmake/grpc/gRPCConfigVersion.cmake &&
        GRPC_PROTOC_ROOT=$GRPC_SEARCH_ROOT
}

build_rdc() {
    if ! find_grpc; then
        echo "ERROR: GRPC SEARCH FAILED!"
        echo "You are expected to have gRPC [${GRPC_DESIRED_VERSION}] in [${GRPC_SEARCH_ROOT}]"
        # Compiling gRPC as part of the RDC build takes too long and times out the build job
        return 1
    fi
    echo "gRPC [${GRPC_DESIRED_VERSION}] found!"

    if [ "${ENABLE_STATIC_BUILDS}" == "true" ]; then
        ack_and_skip_static
    fi

    CXX=$(set_build_variables __C_++__)
    if [ "${ENABLE_ADDRESS_SANITIZER}" == "true" ]; then
        set_asan_env_vars
        set_address_sanitizer_on
        # NOTE: Temp fix for ASAN failures SWDEV-515858
        export ASAN_OPTIONS="detect_leaks=0:new_delete_type_mismatch=0"
    fi

    echo "Building RDC"
    echo "RDC_BUILD_DIR: ${RDC_BUILD_DIR}"
    echo "GRPC_PROTOC_ROOT: ${GRPC_PROTOC_ROOT}"

    if [ "${ENABLE_ADDRESS_SANITIZER}" == "true" ]; then
        # NOTE: Temp workaround for libasan not being first in the library list.
        # libasan not being first causes ADDRESS_SANITIZER builds to fail.
        # This value is set by set_asan_env_vars. Which is only called when -a arg is passed.
        export LD_PRELOAD="$ASAN_LIB_PATH"
    fi

    echo "C compiler: $CC"
    echo "CXX compiler: $CXX"
    init_rocm_common_cmake_params
    if [ ! -d "$BUILD_DIR/rdc_libs" ]; then
        mkdir -p "$BUILD_DIR"
        pushd "$BUILD_DIR"
        cmake \
            -DGRPC_ROOT="$GRPC_PROTOC_ROOT" \
            -DGRPC_DESIRED_VERSION="$GRPC_DESIRED_VERSION" \
            -DCMAKE_MODULE_PATH="$COMPONENT_SRC/cmake_modules" \
            "${rocm_math_common_cmake_params[@]}" \
            -DCPACK_GENERATOR="${PKGTYPE^^}" \
            -DROCM_DIR=$ROCM_PATH \
            -DCPACK_PACKAGE_VERSION_MAJOR="1" \
            -DCPACK_PACKAGE_VERSION_MINOR="$ROCM_LIBPATCH_VERSION" \
            -DCPACK_PACKAGE_VERSION_PATCH="0" \
            -DADDRESS_SANITIZER="$ADDRESS_SANITIZER" \
            -DBUILD_TESTS=ON \
            -DBUILD_PROFILER=ON \
            -DBUILD_RVS=ON \
            -DCMAKE_SKIP_BUILD_RPATH=TRUE \
            "$COMPONENT_SRC"
        popd
    fi
    echo "Making rdc package:"
    cmake --build "$BUILD_DIR" -- -j${PROC}
    cmake --build "$BUILD_DIR" -- install

    if [ "${ENABLE_ADDRESS_SANITIZER}" == "true" ]; then
        # NOTE: Must disable LD_PRELOAD hack before packaging!
        # cmake fails with cryptic error on RHEL:
        #
        #    AddressSanitizer:DEADLYSIGNAL
        #    ==17083==ERROR: AddressSanitizer: stack-overflow on address ...
        #
        # The issue is likely in python3.6 cpack scripts
        unset LD_PRELOAD
    fi

    cmake --build "$BUILD_DIR" -- package

    copy_if "${PKGTYPE}" "${CPACKGEN:-"DEB;RPM"}" "${PACKAGE_DIR}" "${BUILD_DIR}"/*."${PKGTYPE}"

    if [ "$BUILD_DOCS" = "yes" ]; then
      echo "Building Docs"
      cmake --build "$BUILD_DIR" -- doc
      pushd "$BUILD_DIR"/latex
      cmake --build . --
      mv refman.pdf "$ROCM_PATH/rdc/RDC_Manual.pdf"
      popd
    fi
}

clean_rdc() {
    echo "Cleaning RDC build directory: ${BUILD_DIR} ${PACKAGE_DIR}"
    rm -rf "$BUILD_DIR" "$PACKAGE_DIR"
    return 0
}

stage2_command_args "$@"
disable_debug_package_generation

case $TARGET in
    clean) clean_rdc ;;
    build) build_rdc ;;
    outdir) print_output_directory ;;
    *) die "Invalid target $TARGET" ;;
esac

echo "Operation complete"
