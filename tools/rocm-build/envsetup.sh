#!/bin/bash

set_WORK_ROOT(){
    [ -n "$WORK_ROOT" ] && return 0
    export WORK_ROOT=$PWD
    while :; do
	[ -d "$WORK_ROOT/.repo/manifests" ] && return 0
        WORK_ROOT=$WORK_ROOT/..
	( cd -P "$WORK_ROOT" &&  [ "$PWD" != "/" ] ) || break
    done
    echo "Unable to find a .repo/manifests directory above '$PWD'" >&2
    unset WORK_ROOT		# No point in saying we have one when we don't
    return 1
}
set_WORK_ROOT || exit 2

if [ "$DASH_JAY" == "" ]; then
    if [ -x "$(command -v nproc)" ]; then
        export DASH_JAY="-j $(nproc)"
    else
        export DASH_JAY="-j 4"
    fi
fi

# explanation of JOB_DESIGNATOR states:
# exists, empty string -> originated from release job, pass thru a null string
# exists, non-empty -> originated from other CI job, use as set, example: "dnnhc."
# does not exist -> dev or non-CI build, got to this point without instantiation
# so assign a default value: "local."
export JOB_DESIGNATOR="${JOB_DESIGNATOR-"local."}"
echo "JOB_DESIGNATOR=${JOB_DESIGNATOR}"

# explanation of SLES_BUILD_ID_PREFIX states:
# exists, non-empty -> originated from sles job, use as set, example: "sles151."
# exists, empty string -> originated from non-sles job, pass thru a null string
# does not exist -> got to this point without instantiation so a default null string: ""
export SLES_BUILD_ID_PREFIX
echo "SLES_BUILD_ID_PREFIX=${SLES_BUILD_ID_PREFIX}"

if [ -z "${BUILD_ID}" ]; then
    export BUILD_ID=9999
fi

if [ -n "${JOB_NAME}" ]; then
    export ROCM_BUILD_ID=${JOB_NAME/compute-/}-${BUILD_ID}
fi

source /etc/os-release
#re-export the variables with less generic names
export DISTRO_NAME=$ID
export DISTRO_RELEASE=$VERSION_ID
export DISTRO_ID=$ID-$VERSION_ID


# Enable wheel package for Almainux-8 mainline builds
# Currently no wheel package required for static and ASAN builds
if [[ "${DISTRO_ID}" == almalinux-8* ]] && [[ "${ENABLE_ADDRESS_SANITIZER}" != "true" ]] && [[ "${ENABLE_STATIC_BUILD}" != "true" ]]; then
    export WHEEL_PACKAGE=true
else
    unset WHEEL_PACKAGE
fi

case "${DISTRO_NAME}" in
    ("ubuntu") export CPACKGEN=DEB PACKAGEEXT=deb PKGTYPE=deb ROCM_PKGTYPE=DEB ;;
    ("centos") export CPACKGEN=RPM PACKAGEEXT=rpm PKGTYPE=rpm ROCM_PKGTYPE=RPM ;;
    ("sles") export CPACKGEN=RPM PACKAGEEXT=rpm PKGTYPE=rpm ROCM_PKGTYPE=RPM ;;
    ("rhel") export CPACKGEN=RPM PACKAGEEXT=rpm PKGTYPE=rpm ROCM_PKGTYPE=RPM ;;
    ("mariner") export CPACKGEN=RPM PACKAGEEXT=rpm PKGTYPE=rpm ROCM_PKGTYPE=RPM ;;
    ("azurelinux") export CPACKGEN=RPM PACKAGEEXT=rpm PKGTYPE=rpm ROCM_PKGTYPE=RPM ;;
    ("almalinux") export CPACKGEN=RPM PACKAGEEXT=rpm PKGTYPE=rpm ROCM_PKGTYPE=RPM ;;
    ("debian") export CPACKGEN=DEB PACKAGEEXT=deb PKGTYPE=deb ROCM_PKGTYPE=DEB ;;
esac

# set up package file name variables for CPACK_GENERATOR
# rpm packages name are set with jenkins job designator and build no
# deb package is appendeded with OS version as well
export CPACK_DEBIAN_PACKAGE_RELEASE="${JOB_DESIGNATOR}${SLES_BUILD_ID_PREFIX}${BUILD_ID}~$VERSION_ID"
export CPACK_RPM_PACKAGE_RELEASE="${JOB_DESIGNATOR}${SLES_BUILD_ID_PREFIX}${BUILD_ID}"

export SCRIPT_PATH=$WORK_ROOT/brahma-utils/kfd-tools/scripts
export ENV_PATH=$SCRIPT_PATH/hsaThunk.env
OUT_DIR="${OUT_DIR:=$WORK_ROOT/out/$DISTRO_ID/$DISTRO_RELEASE}"
export OUT_DIR
export RT_TMP=$OUT_DIR/tmp/rt

# Unused
# export ROCM_VERSION=$(git --git-dir=$WORK_ROOT/.repo/manifests/.git describe --always)

#source transform, for things like ocl_lc
export SRC_TF_ROOT=$OUT_DIR/srctf

# Read ROCm Version and calculate ROCm libpatch version from rocm_version.txt
# Using logic from calculateRocmPatchVersion() in common.gvy
get_rocm_libpatch_version() {
    rocm_version=$1
    if [[ "${rocm_version}" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        libpatch_version=${rocm_version//\./0}
        echo "${libpatch_version}"
    else
        echo "Invalid ROCm Version: ${rocm_version}"
        exit 10
    fi
}

# Read the default ROCm version from rocm_version.txt if the ROCM_VERSION
# variable is either not set, empty or only contains spaces.
if [ -f "${BUILD_SCRIPT_ROOT}/rocm_version.txt" ] && [ -z $ROCM_VERSION ]; then
    ROCM_VERSION="$(cat ${BUILD_SCRIPT_ROOT}/rocm_version.txt)"
fi

# ROCM variables
# ROCM_VERSION and ROCM_LIBPATCH_VERSION are changed: Eg:"3.3.0" ~= 30300
#default ROCM_VERSION: 9.99.99 and ROCM_LIBPATCH_VERSION: 99999 if not set
: ${ROCM_VERSION:="9.99.99"}
ROCM_LIBPATCH_VERSION=$(get_rocm_libpatch_version $ROCM_VERSION)
echo "ROCM_VERSION=${ROCM_VERSION}"
echo "ROCM_LIBPATCH_VERSION=${ROCM_LIBPATCH_VERSION}"
export ROCM_VERSION ROCM_LIBPATCH_VERSION

# Previously we would put the job number into the ROCM_INSTALL_PATH
# This interacted badly with our desire to reuse builds, a it ment every build was unique
export ROCM_INSTALL_PATH="/opt/rocm-${ROCM_VERSION}"

# Setting the ROCM_INSTALL_PATH id to Last Know Good build ID, PSDB incremental built packages will install into /opt/rocm-<parent build ID>
# No longer applicable, as we no longer have the job number in the ROCM_INSTALL_PATH

if [ -n "${AFAR_VERSION}" ]; then
    # multi-version (side-by-side) install for Advanced Feature Access Release (AFAR)
    # suggested AFAR_VERSION: "afar001"
    # Hopefully this is correct for AFAR
    ROCM_INSTALL_PATH="/opt/rocm-${AFAR_VERSION##-}"
fi

if [[ "${ENABLE_STATIC_BUILDS}" == true ]]; then
    # For static builds add a -static post fix in rocm folder
    export ROCM_INSTALL_PATH="${ROCM_INSTALL_PATH}-static"
fi

echo "Setting ROCM_INSTALL_PATH=${ROCM_INSTALL_PATH}"

export ROCM_PATH="$ROCM_INSTALL_PATH"
export ROCM_LIBPATH=""
export DEVTOOLSET_LIBPATH="/opt/rh/devtoolset-7/root/usr/lib64;/opt/rh/devtoolset-7/root/usr/lib"

# Source directories
# TODO: We should have autodiscoverable makefiles
export DIST_NO_DEBUG=yes
export OPENCL_MAINLINE=1
# export P4_ROOT=$WORK_ROOT/p4
# export RT_ROOT=$P4_ROOT/driver/
export FW_ROOT=$WORK_ROOT/brahma-utils/firmware/deb-pkgs
# export HSA_ROOT=$WORK_ROOT/hsa
export HSA_SOURCE_ROOT=$WORK_ROOT/ROCR-Runtime
# export HSA_CLOSED_SOURCE_ROOT=$WORK_ROOT/p4/driver
export HSA_OPENSOURCE_ROOT=$HSA_SOURCE_ROOT/src
# export ROCR_ROOT=$HSA_ROOT/rocr-runtime
export ROCR_ROOT=$WORK_ROOT/ROCR-Runtime
export ROCRTST_ROOT=$HSA_SOURCE_ROOT/rocrtst
export HSA_CORE_ROOT=$HSA_OPENSOURCE_ROOT
export HSA_IMAGE_ROOT=$HSA_OPENSOURCE_ROOT/hsa-ext-image
export HSA_FINALIZE_ROOT=$HSA_OPENSOURCE_ROOT/hsa-ext-finalize
export HSA_TOOLS_ROOT=$HSA_OPENSOURCE_ROOT/hsa-runtime-tools
# export HSA_RT_ROOT=$RT_ROOT/drivers/hsa/runtime
# export OCL_RT_ROOT=$RT_ROOT/drivers/opencl
# export OCL_RT_STG_ROOT=$P4_ROOT/opencl
export OCL_RT_SRC_TF_ROOT=$SRC_TF_ROOT/ocl_lc
export KERNEL_ROOT=$WORK_ROOT/kernel
export SCRIPT_ROOT=$WORK_ROOT/build
export BUILD_SCRIPT_ROOT=$WORK_ROOT/ROCm/tools/rocm-build
export TEST_SCRIPT_ROOT=$WORK_ROOT/MLSEQA_TestRepo
export THUNK_ROOT=$WORK_ROOT/ROCT-Thunk-Interface
export AMDGPURASTOOL_ROOT=$WORK_ROOT/amdgpuras-tool
export AQLPROFILE_ROOT=$WORK_ROOT/aqlprofile
export ROCPROFILER_ROOT=$WORK_ROOT/rocprofiler
export ROCTRACER_ROOT=$WORK_ROOT/roctracer
export ROCPROFILER_REGISTER_ROOT=$WORK_ROOT/rocprofiler-register
export ROCPROFILER_SDK_ROOT=$WORK_ROOT/rocprofiler-sdk
export ROCPROFILER_COMPUTE_ROOT=$WORK_ROOT/rocprofiler-compute
export ROCPROFILER_SYSTEMS_ROOT=$WORK_ROOT/rocprofiler-systems
export UTILS_ROOT=$WORK_ROOT/rocm-utils
export KFDTEST_ROOT=$THUNK_ROOT/tests/kfdtest
# export HSA_SAMPLES_ROOT=$RT_ROOT/drivers/hsa/runtime/samples
# export CHIMEX_ROOT=$WORK_ROOT/benchmarks/chimex
# export AMDP2P_ROOT=$WORK_ROOT/drivers/amdp2p
# export HIP_ROOT=$WORK_ROOT/HIP
# export HIP_VDI_ROCM_SRC_TF_ROOT=$SRC_TF_ROOT/hip_vdi_rocm
# export HIP_VDI_PAL_SRC_TF_ROOT=$SRC_TF_ROOT/hip_vdi_pal
# export HIP_SAMPLES_ROOT=$WORK_ROOT/HIP-Examples
# export HIP_PRIVATE_SAMPLES_ROOT=$WORK_ROOT/hip-examples-private
export HIPIFY_ROOT=$WORK_ROOT/HIPIFY
# export GPUBURN_ROOT=$WORK_ROOT/tests/gpuburn
# export HSAPROFILER_TEST_ROOT=$WORK_ROOT/dev-tools/RCP-Internal/Src/Tests/HSAFoundationProfileAPITest
# export HSATESTCOMMON_ROOT=$WORK_ROOT/dev-tools/Common/Src/HSATestCommon
# export HSATESTGTEST_ROOT=$WORK_ROOT/dev-tools/Common/Lib/Ext/GoogleTest1.8/googletest
# export SMI_ROOT=$WORK_ROOT/rocm-smi
export AMD_SMI_LIB_ROOT=$WORK_ROOT/amdsmi
export ROCM_SMI_LIB_ROOT=$WORK_ROOT/rocm_smi_lib
export RSMITST_ROOT=$ROCM_SMI_LIB_ROOT/tests/rocm_smi_test
export LLVM_PROJECT_ROOT=$WORK_ROOT/llvm-project
export LLVM_ROOT=$LLVM_PROJECT_ROOT/llvm
export CLANG_ROOT=$LLVM_PROJECT_ROOT/clang
export LLD_ROOT=$LLVM_PROJECT_ROOT/lld
export HIPCC_ROOT=$LLVM_PROJECT_ROOT/amd/hipcc
export DEVICELIBS_ROOT=$LLVM_PROJECT_ROOT/amd/device-libs
export DKMS_ROOT=$WORK_ROOT/drivers/linux-dkms
export ROCM_ROOT=$WORK_ROOT/meta
export ROCM_CORE_ROOT=$WORK_ROOT/rocm-core
export ROCM_DEV_ROOT=$WORK_ROOT/meta/rocm-dev
export ROCM_CMAKE_ROOT=$WORK_ROOT/rocm-cmake
export ROCM_BANDWIDTH_TEST_ROOT=$WORK_ROOT/rocm_bandwidth_test
export ROCMINFO_ROOT=$WORK_ROOT/rocminfo
export ROCR_DEBUG_AGENT_ROOT=$WORK_ROOT/rocr_debug_agent
export COMGR_ROOT=$LLVM_PROJECT_ROOT/amd/comgr
export COMGR_LIB_PATH=$OUT_DIR/build/amd_comgr
# export HOSTCALL_ROOT=$WORK_ROOT/hostcall
export RCCL_ROOT=$WORK_ROOT/rccl
export ROCM_DBGAPI_ROOT=$WORK_ROOT/ROCdbgapi
export ROCM_GDB_ROOT=$WORK_ROOT/ROCgdb
# export ROCclr_ROOT=$WORK_ROOT/vdi
export HIP_ON_ROCclr_ROOT=$WORK_ROOT/hip
export HIPAMD_ROOT=$WORK_ROOT/hipamd
export HIP_CATCH_TESTS_ROOT=$WORK_ROOT/hip-tests
# export OPENCL_ON_ROCclr_ROOT=$WORK_ROOT/opencl-on-vdi
export CLR_ROOT=$WORK_ROOT/clr
export OPENCL_CTS_ROOT=$WORK_ROOT/OpenCL-CTS
export OPENCL_ICD_LOADER_ROOT=$WORK_ROOT/OpenCL-ICD-Loader
export OPENCL_HEADERS_ROOT=$WORK_ROOT/OpenCL-Headers
export OPENCL_CLHPP_ROOT=$WORK_ROOT/OpenCL-CLHPP
export AOMP_REPOS=$WORK_ROOT/openmp-extras
export HIPOTHER_ROOT=$WORK_ROOT/hipother

# For libraries $ORIGIN
# For binaries $ORIGIN/../lib
export ROCM_LIB_RPATH='$ORIGIN'
export ROCM_EXE_RPATH='$ORIGIN/../lib'

# For ASAN Libraries since the asan lib path is lib/asan/
export ROCM_ASAN_LIB_RPATH='$ORIGIN:$ORIGIN/..'
export ROCM_ASAN_EXE_RPATH="\$ORIGIN/../lib/asan:\$ORIGIN/../lib"

# Intermediate output directories for projects without build output relocation
export FW_OUT=$WORK_ROOT/brahma-utils/firmware/deb-pkgs

export PATH=$PATH:$SCRIPT_ROOT
if [ -e "$SCRIPT_PATH/hsaThunk.util" ]; then
    source $SCRIPT_PATH/hsaThunk.util $ENV_PATH $WORK_ROOT
fi

# From setup_env.sh
export BUILD_TYPE=Release
export LIBS_WORK_DIR=$WORK_ROOT
export BUILD_ARTIFACTS=$OUT_DIR/$PACKAGEEXT

export HIPCC_COMPILE_FLAGS_APPEND="-O3 -Wno-format-nonliteral -parallel-jobs=4"
export HIPCC_LINK_FLAGS_APPEND="-O3 -parallel-jobs=4"

export PATH="${ROCM_PATH}/bin:${ROCM_PATH}/lib/llvm/bin:${PATH}:${HOME}/.local/bin"

export LC_ALL=C.UTF-8
export LANG=C.UTF-8

export PROC=${PROC:-"$(nproc)"}
# export RELEASE_FLAG=${RELEASE_FLAG:-"-r"}
export SUDO=sudo
export PATH=/usr/local/bin:${PATH}:/sbin:/bin
export CCACHE_DIR=${HOME}/.ccache

# set ccache environment variable for math libraries
if [[ "${CCACHE_ENABLED}" != "false" ]]; then
    export LAUNCHER_FLAGS="-DCMAKE_CXX_COMPILER_LAUNCHER=/usr/local/bin/ccache -DCMAKE_C_COMPILER_LAUNCHER=/usr/local/bin/ccache"
    export CCACHE_COMPILERCHECK=none
    export CCACHE_EXTRAFILES=${OUT_DIR}/rocm_compilers_hash_file
fi
