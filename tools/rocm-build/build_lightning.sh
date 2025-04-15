#!/bin/bash

source "$(dirname "${BASH_SOURCE}")/compute_utils.sh"
export JOB_DESIGNATOR
export BUILD_ID
export SLES_BUILD_ID_PREFIX
export ROCM_LIBPATCH_VERSION

printUsage() {
    echo
    echo "Usage: $(basename "${BASH_SOURCE}") [options ...]"
    echo
    echo "Options:"
    echo "  -c,  --clean                 Clean output and delete all intermediate work"
    echo "  -d,  --debug                 Build a debug version of llvm (excludes packaging)"
    echo "  -r,  --release               Build a release version of the package"
    echo "  -a,  --address_sanitizer     Enable address sanitizer (enabled by default)"
    echo "  -A   --no_address_sanitizer  Disable address sanitizer"
    echo "  -s,  --static                Build static lib (.a).  build instead of dynamic/shared(.so) "
    echo "  -w,  --wheel                 Creates python wheel package of rocm-llvm. It needs to be used along with -r option"
    echo "  -l,  --build_llvm_static     Build LLVM libraries statically linked.  Default is to build dynamic linked libs"
    echo "  -o,  --outdir <pkg_type>     Print path of output directory containing packages of
                            type referred to by pkg_type"
    echo "  -B,  --build                 Build and install binary files into /opt/rocm folder"
    echo "  -P,  --package               Generate packages"
    echo "  -N,  --skip_lit_tests        Skip llvm lit testing (llvm lit testing is enabled by default)"
    echo "  -M,  --skip_man_pages        Skip llvm documentation generation (man pages and rocm-llvm-docs package generation is enabled by default)"
    echo "       --skip_utils            Skip installation of LLVM Utils (FileCheck, not, etc.)"
    echo "  -h,  --help                  Prints this help"
    echo "       --compiler_rt_debug     Build a debug version of runtimes"
    echo "       --compiler_rt_release   Build a release version of runtimes (enabled by default)"
    echo
    echo

    return 0
}

PROJ_NAME="lightning"
ROCM_LLVM_LIB_RPATH='\$ORIGIN'
ROCM_LLVM_EXE_RPATH='\$ORIGIN/../lib:\$ORIGIN/../../../lib'

PACKAGE_OUT="$(getPackageRoot)"
BUILD_PATH="$(getBuildPath $PROJ_NAME)"
DEB_PATH="$(getDebPath $PROJ_NAME)"
RPM_PATH="$(getRpmPath $PROJ_NAME)"
INSTALL_PATH="${ROCM_INSTALL_PATH}/lib/llvm"
LLVM_ROOT_LCL="${LLVM_ROOT}"

TARGET="all"
MAKEOPTS="$DASH_JAY"
# Default to build release with Assertions ON
BUILD_TYPE="Release"
COMPILER_RT_DEBUG="OFF"
# Enable assertions for all builds except release, nfar, and afar jobs.
case "${JOB_NAME}" in
   ( *"rel"*                  | \
     *"nfar"*                 )
       ENABLE_ASSERTIONS=0 ;;
     ( * )
       ENABLE_ASSERTIONS=1 ;;
esac
SHARED_LIBS="ON"

# Build LLVM libraries for dynamically linking.  Default is to build LLVM with statically linked libraries
BUILD_LLVM_DYLIB="OFF"

FLANG_NEW=0
CHK_FLANG=""
CLEAN_OR_OUT=0;
PKGTYPE="deb"
MAKETARGET="deb"

ASSERT_LLVM_VERSION_MAJOR=""
ASSERT_LLVM_VERSION_MINOR=""

SKIP_LIT_TESTS=0
BUILD_MANPAGES="ON"
LLVM_INSTALL_UTILS="ON"
STATIC_FLAG=

SANITIZER_AMDGPU=1

if [ -d "$WORK_ROOT/ROCR-Runtime/runtime/hsa-runtime/inc/" ]; then
    HSA_INC_PATH="$WORK_ROOT/ROCR-Runtime/runtime/hsa-runtime/inc/"
else
    HSA_INC_PATH="$WORK_ROOT/ROCR-Runtime/src/inc"
fi
COMGR_INC_PATH="$COMGR_ROOT/include"

#parse the arguments
VALID_STR=`getopt -o hcV:v:draAswlo:BPNM --long help,clean,assert_llvm_ver_major:,assert_llvm_ver_minor:,debug,release,address_sanitizer,no_address_sanitizer,static,build_llvm_static,wheel,build,package,skip_lit_tests,skip_man_pages,skip_utils,compiler_rt_debug,compiler_rt_release,outdir: -- "$@"`
eval set -- "$VALID_STR"

set_dwarf_version(){
  # In SLES and RHEL splitting debuginfo is getting failed(dwarf-5 unhandled) when compiler is set to clang.
  # By default -gdwarf-5 is used for the compression of debug symbols
  # So setting -gdwarf-4
  # SWDEV-462774: In RHEL/SLES with dwarf-4 enabled, seeing ASAN llvm build getting killed due to high memory usage.
  # So adding -gsplit-dwarf which splits the debug information into separate files to reduce memory usage during linking.
  case "$DISTRO_ID" in
    (sles*|rhel*)
       SET_DWARF_VERSION_4="-gdwarf-4 -gsplit-dwarf"
       ;;
    (*)
       SET_DWARF_VERSION_4=""
       ;;
  esac
  export CFLAGS="$CFLAGS $SET_DWARF_VERSION_4  "
  export CXXFLAGS="$CXXFLAGS $SET_DWARF_VERSION_4 "
  export ASMFLAGS="$ASMFLAGS $SET_DWARF_VERSION_4 "
}

while true ;
do
    #echo "processing $1"
    case "$1" in
        (-h | --help)
                printUsage ; exit 0;;
        (-c | --clean)
                TARGET="clean" ; ((CLEAN_OR_OUT|=1)) ; shift ;;
        (-V | --assert_llvm_ver_major)
                ASSERT_LLVM_VERSION_MAJOR=$2 ; shift 2 ;;
        (-v | --assert_llvm_ver_minor)
                ASSERT_LLVM_VERSION_MINOR=$2 ; shift 2 ;;
        (-d | --debug)
                BUILD_TYPE="Debug" ; shift ;;
        (-r | --release)
                BUILD_TYPE="Release" ; shift ;;
        (-a | --address_sanitizer)
                set_dwarf_version
                SANITIZER_AMDGPU=1 ; shift ;;
        (-A | --no_address_sanitizer)
                SANITIZER_AMDGPU=0 ;
                unset HSA_INC_PATH ;
                unset COMGR_INC_PATH ; shift ;;
        (-s | --static)
                SHARED_LIBS="OFF" ;
                STATIC_FLAG="-DBUILD_SHARED_LIBS=$SHARED_LIBS" ; shift ;;
        (-l | --build_llvm_static)
                BUILD_LLVM_DYLIB="OFF"; shift ;;
        (-w | --wheel)
                WHEEL_PACKAGE=true ; shift ;;
        (-o | --outdir)
                TARGET="outdir"; PKGTYPE=$2 ; OUT_DIR_SPECIFIED=1 ; ((CLEAN_OR_OUT|=2)) ; shift 2 ;;
        (-B | --build)
                TARGET="build"; shift ;;
        (-P | --package)
                TARGET="package"; shift ;;
        (-N | --skip_lit_tests)
                SKIP_LIT_TESTS=1; shift ;;
        (-M | --skip_man_pages)
                BUILD_MANPAGES="OFF"; shift ;;
        (--skip_utils)
                LLVM_INSTALL_UTILS="OFF"; shift ;;
        (--compiler_rt_debug)
                COMPILER_RT_DEBUG="ON"; shift ;;
        (--compiler_rt_release)
                COMPILER_RT_DEBUG="OFF"; shift ;;
        --)     shift; break;; # end delimiter
        (*)
                echo " This should not happen : UNEXPECTED ERROR Parm : [$1] ">&2 ; exit 20;;
    esac

done

RET_CONFLICT=1
check_conflicting_options $CLEAN_OR_OUT $PKGTYPE $MAKETARGET
if [ $RET_CONFLICT -ge 30 ]; then
   print_vars $API_NAME $TARGET $BUILD_TYPE $SHARED_LIBS $CLEAN_OR_OUT $PKGTYPE $MAKETARGET
   exit $RET_CONFLICT
fi

LLVM_PROJECTS="clang;lld;clang-tools-extra"
ENABLE_RUNTIMES="compiler-rt;libunwind"
BOOTSTRAPPING_BUILD_LIBCXX=0
BUILD_AMDCLANG="ON"
# build libcxx to support the amdclang binary
ENABLE_RUNTIMES="$ENABLE_RUNTIMES;libcxx;libcxxabi"
BOOTSTRAPPING_BUILD_LIBCXX=1

clean_lightning() {
    # Delete cmake output directory
    rm -rf "$BUILD_PATH"
    rm -rf "$DEB_PATH"
    rm -rf "$RPM_PATH"
}

# Collect LLVM/Clang git information for clang --version output.
# Include repo name, branch name and gitdate.
setup_llvm_info() {
    # Allow this function to fail repo and git commands, but not crash the build.
    set +e
    mkdir -p "$LLVM_ROOT_LCL"
    pushd "$LLVM_ROOT_LCL"
    # Initialize local variable. Does not include
    # LLVM_COMMIT_GITDATE and LLVM_REPO_INFO.
    local LLVM_REMOTE_NAME
    local LLVM_URL_NAME
    local LLVM_BRANCH_NAME
    local LLVM_URL_BRANCH

    # Release Build: set url to external repo.
    # Internal Build:  set url to actual url.
    if [[ "${JOB_NAME}" == *rel* ]]; then
      LLVM_URL_NAME="https://github.com/RadeonOpenCompute/llvm-project"
      # Release branch follows convention roc-X.Y.x according to CI.
      LLVM_BRANCH_NAME="roc-${ROCM_VERSION}"
      LLVM_URL_BRANCH="${LLVM_URL_NAME} ${LLVM_BRANCH_NAME}"
    else
      LLVM_REMOTE_NAME=$(git remote)
      LLVM_URL_NAME=$(git config --get remote."${LLVM_REMOTE_NAME}".url)
      # Parse the manifest to obtain upstream branch.
      LLVM_BRANCH_NAME=$(repo manifest | sed -n 's/.*path="external\/llvm-project".* upstream="\([^"]*\)".*/\1/p' )
      LLVM_URL_BRANCH="${LLVM_URL_NAME} ${LLVM_BRANCH_NAME}"
    fi

    # Obtain git date information based on UTC time.
    # Format date as yyuuw - [last two digits of year][work week][day of week].
    # Use xargs to remove trailing newline character.
    LLVM_COMMIT_GITDATE=$(git show -s --format=@%ct | xargs | date -f - --utc +%y%U%w)
    # Organize into REPO BRANCH GITDATE
    LLVM_REPO_INFO="${LLVM_URL_BRANCH} ${LLVM_COMMIT_GITDATE}"

    popd
    set -e
}

LLVM_VERSION_MAJOR=""
LLVM_VERSION_MINOR=""
LLVM_VERSION_PATCH=""
LLVM_VERSION_SUFFIX=""
get_llvm_version() {
    local LLVM_VERSIONS=($(awk '/set\(LLVM_VERSION/ {print substr($2,1,length($2)-1)}' ${LLVM_ROOT_LCL}/../cmake/Modules/LLVMVersion.cmake))
    if [ ${#LLVM_VERSIONS[@]} -eq 0 ]; then
        LLVM_VERSIONS=($(awk '/set\(LLVM_VERSION/ {print substr($2,1,length($2)-1)}' ${LLVM_ROOT_LCL}/CMakeLists.txt))
    fi
    LLVM_VERSION_MAJOR=${LLVM_VERSIONS[0]}
    LLVM_VERSION_MINOR=${LLVM_VERSIONS[1]}
    LLVM_VERSION_PATCH=${LLVM_VERSIONS[2]}
    LLVM_VERSION_SUFFIX=${LLVM_VERSIONS[3]}

    echo "Detected LLVM version from source: ${LLVM_VERSION_MAJOR}.${LLVM_VERSION_MINOR}.${LLVM_VERSION_PATCH}${LLVM_VERSION_SUFFIX}"
}

# Generate compiler config files with default ROCm settings
create_compiler_config_files() {
    local llvm_bin_dir="${INSTALL_PATH}/bin"
    local rocm_cfg="rocm.cfg"

    # rocm.cfg content
    {
        echo "-Wl,--enable-new-dtags"
        echo "--rocm-path='<CFGDIR>/../../..'"
        echo "-frtlib-add-rpath"
    } > "${llvm_bin_dir}/$rocm_cfg"

    local compiler_commands=("clang" "clang++" "clang-cpp" "clang-${LLVM_VERSION_MAJOR}" "clang-cl" )
    for i in "${compiler_commands[@]}"; do
        if [ -f "$llvm_bin_dir/$i" ]; then
            local config_file="${llvm_bin_dir}/${i}.cfg"
            echo "@${rocm_cfg}" > $config_file
        fi
    done

    if [ $FLANG_NEW -eq 1 ]; then
        local flang_commands=("flang" "flang-new" "flang-classic")
        for i in "${flang_commands[@]}"; do
            local config_file="${llvm_bin_dir}/${i}.cfg"
            echo "@${rocm_cfg}" > $config_file
        done
    fi
}

# Function to check if a list contains an element
# return true if $1 is in $2...
contains(){

    local target=$1 element
    shift
    for element ; do
        [ "$target" = "$element" ] && return 0
    done
    return 1
}

build_lightning() {
    # Obtain LLVM build information
    setup_llvm_info

    get_llvm_version
    if [ -n "${ASSERT_LLVM_VERSION_MAJOR}" ]; then
        echo "Assert LLVM major version: ${ASSERT_LLVM_VERSION_MAJOR}";
        if [ "${ASSERT_LLVM_VERSION_MAJOR}" != "${LLVM_VERSION_MAJOR}" ]; then
            echo "LLVM major version assertion failed, expected ${ASSERT_LLVM_VERSION_MAJOR} but detected ${LLVM_VERSION_MAJOR}!"
            exit 1;
        fi
    fi
    if [ -n "${ASSERT_LLVM_VERSION_MINOR}" ]; then
        echo "Assert LLVM minor version: ${ASSERT_LLVM_VERSION_MINOR}";
        if [ "${ASSERT_LLVM_VERSION_MINOR}" != "${LLVM_VERSION_MINOR}" ]; then
            echo "LLVM minor version assertion failed, expected ${ASSERT_LLVM_VERSION_MINOR} but detected ${LLVM_VERSION_MINOR}!"
            exit 1;
        fi
    fi

    # Upstream llvm option -DCLANG_DEFAULT_PIE_ON_LINUX changed to ON
    # by default however, it breaks ROCM builds on SLES/CentOS distros
    # so disabling it for now in lighting compiler builds.
    # Todo : this should be removed to follow the upstream's default.
    DISABLE_PIE=0

    # Find out distro / RHEL build here to adjust Python version for building LLVM if needed.
    case "$DISTRO_ID" in
    (rhel*|centos*)
       RHEL_BUILD=1
       ;;
    (*)
       RHEL_BUILD=0
       ;;
    esac

    # Special handling for Debian 10
    #  - gcc is too ancient and can't build LLVM, switch to clang-13 instead
    #  - zstd is severely out-of-date and can't support LLVM, disable it
    case "$DISTRO_ID" in
    (debian-10)
       BUILD_COMPILER_LINKER_FLAGS=("-DCMAKE_C_COMPILER=/usr/bin/clang-13"  "-DCMAKE_CXX_COMPILER=/usr/bin/clang++-13" "-DLLVM_USE_LINKER=lld")
       LLVM_COMPRESSION_FLAGS=("-DLLVM_ENABLE_ZLIB=ON" "-DLLVM_ENABLE_ZSTD=OFF")
       ;;
    (*)
       BUILD_COMPILER_LINKER_FLAGS=()
       LLVM_COMPRESSION_FLAGS=("-DLLVM_ENABLE_ZLIB=ON")
       ;;
    esac

    # Upstream moved to requiring Python 3.8 as the minimum.
    # Point CMake to that explicit location and adjust LD_LIBRARY_PATH.
    PYTHON_VERSION_WORKAROUND=''
    # TODO: Workshop the condition before landing, only to show
    # what needs to be done for the Python issue.
    echo "build_lightning DISTRO_ID: ${DISTRO_ID}"
    if [[ "$DISTRO_ID" == "rhel-8"* || "$DISTRO_NAME" == "sles" || "$DISTRO_ID" == "debian-10" ]]; then
      EXTRA_PYTHON_PATH=/opt/Python-3.8.13
      PYTHON_VERSION_WORKAROUND="-DPython3_EXECUTABLE=${EXTRA_PYTHON_PATH}/bin/python3.8"
      # For the python interpreter we need to export LD_LIBRARY_PATH.
      # XXX: This is only needed during CMake and ninja check-* targets, maybe we can limit scope further?
      export LD_LIBRARY_PATH=${EXTRA_PYTHON_PATH}/lib:$LD_LIBRARY_PATH
    fi

    # Start CMake Build
    mkdir -p "$BUILD_PATH"
    pushd "$BUILD_PATH"

    #Extra llvm cmake parameter can be passed from an environment variable EXTRA_LLVM_CMAKE_PARAMS
    #For example:
    #  export EXTRA_LLVM_CMAKE_PARAMS='-DLLVM_LIT_ARGS="-sv -j8" -DP2=1'
    #Alternatively, this variable can be prefixed to this script:
    #  EXTRA_LLVM_CMAKE_PARAMS='-DLLVM_LIT_ARGS="-sv -j8" -DP2=1' build_lightning.sh
    eval EXTRA_LLVM_CMAKE_PARAMS_ARRAY=($EXTRA_LLVM_CMAKE_PARAMS)

    if [ ! -e Makefile ]; then
        echo "Building LLVM CMake environment"
        LLVM_PROJECTS="$LLVM_PROJECTS;mlir"
        if [ -e "$LLVM_ROOT_LCL/../flang/EnableFlangBuild" ]; then
            FLANG_NEW=1
            LLVM_PROJECTS="$LLVM_PROJECTS;flang"
        else
            echo "NOT building project flang"
        fi
        set -x
        cmake $(rocm_cmake_params) ${GEN_NINJA} \
              ${STATIC_FLAG} \
              ${PYTHON_VERSION_WORKAROUND} \
              -DCMAKE_INSTALL_PREFIX="$INSTALL_PATH" \
              -DLLVM_TARGETS_TO_BUILD="AMDGPU;X86" \
              -DLLVM_ENABLE_PROJECTS="$LLVM_PROJECTS" \
              -DLLVM_ENABLE_RUNTIMES="$ENABLE_RUNTIMES" \
              -DLIBCXX_ENABLE_SHARED=OFF \
              -DLIBCXX_ENABLE_STATIC=ON \
              -DLIBCXX_INSTALL_LIBRARY=OFF \
              -DLIBCXX_INSTALL_HEADERS=OFF \
              -DLIBCXXABI_ENABLE_SHARED=OFF \
              -DLIBCXXABI_ENABLE_STATIC=ON \
              -DLIBCXXABI_INSTALL_STATIC_LIBRARY=OFF \
              -DLLVM_BUILD_DOCS="$BUILD_MANPAGES" \
              -DLLVM_ENABLE_SPHINX="$BUILD_MANPAGES" \
              -DSPHINX_WARNINGS_AS_ERRORS=OFF \
              -DSPHINX_OUTPUT_MAN="$BUILD_MANPAGES" \
              -DLLVM_ENABLE_ASSERTIONS="$ENABLE_ASSERTIONS" \
              -DLLVM_ENABLE_Z3_SOLVER=OFF \
              -DLLVM_ENABLE_ZLIB=ON \
              -DLLVM_AMDGPU_ALLOW_NPI_TARGETS=ON \
              -DCLANG_REPOSITORY_STRING="$LLVM_REPO_INFO" \
              -DCLANG_DEFAULT_PIE_ON_LINUX="$DISABLE_PIE" \
              -DCLANG_DEFAULT_LINKER=lld \
              -DCLANG_DEFAULT_RTLIB=compiler-rt \
              -DCLANG_DEFAULT_UNWINDLIB=libgcc \
              -DCLANG_ENABLE_AMDCLANG="$BUILD_AMDCLANG" \
              -DSANITIZER_AMDGPU="$SANITIZER_AMDGPU" \
              -DPACKAGE_VENDOR="AMD" \
              -DSANITIZER_HSA_INCLUDE_PATH="$HSA_INC_PATH" \
              -DSANITIZER_COMGR_INCLUDE_PATH="$COMGR_INC_PATH" \
              -DLLVM_BUILD_LLVM_DYLIB="$BUILD_LLVM_DYLIB" \
              -DLLVM_LINK_LLVM_DYLIB="$BUILD_LLVM_DYLIB" \
              -DLLVM_ENABLE_LIBCXX="$BUILD_LLVM_DYLIB" \
              -DCMAKE_SKIP_BUILD_RPATH=TRUE\
              -DCMAKE_SKIP_INSTALL_RPATH=TRUE\
              -DCMAKE_EXE_LINKER_FLAGS=-Wl,--enable-new-dtags,--build-id=sha1,--rpath,$ROCM_LLVM_EXE_RPATH \
              -DCMAKE_SHARED_LINKER_FLAGS=-Wl,--enable-new-dtags,--build-id=sha1,--rpath,$ROCM_LLVM_LIB_RPATH \
              -DROCM_LLVM_BACKWARD_COMPAT_LINK="$ROCM_INSTALL_PATH/llvm" \
              -DROCM_LLVM_BACKWARD_COMPAT_LINK_TARGET="./lib/llvm" \
              -DCLANG_LINK_FLANG_LEGACY=ON \
              -DFLANG_RUNTIME_F128_MATH_LIB=libquadmath \
              -DLIBOMPTARGET_BUILD_DEVICE_FORTRT=ON \
              -DCMAKE_CXX_STANDARD=17 \
              -DFLANG_INCLUDE_DOCS=OFF \
              -DLLVM_INSTALL_UTILS="$LLVM_INSTALL_UTILS" \
              -DCOMPILER_RT_DEBUG="$COMPILER_RT_DEBUG" \
              "${BUILD_COMPILER_LINKER_FLAGS[@]}" \
              "${LLVM_COMPRESSION_FLAGS[@]}" \
              "${EXTRA_LLVM_CMAKE_PARAMS_ARRAY[@]}" \
              "$LLVM_ROOT_LCL"
        set +x
        echo "CMake complete"
    fi

    echo "Building LLVM"

    if [ $BOOTSTRAPPING_BUILD_LIBCXX -eq 1 ]; then
        # The following is to do a bootstrap build of libc++ to support
        # amdclang, which needs the C++17 std::filesystem library
        # build clang first
        cmake --build . -- $MAKEOPTS clang lld compiler-rt
        # build libc++ and libcxxabi using the just-built clang
        cmake --build . -- $MAKEOPTS runtimes cxx
    fi

    # Remove these 12 lines
    echo "Workaround for race condition"
    # find make targets like clang_rt.asan-dynamic-ARCH-version-list
    # and prebuild them. ARCH will include x86_64 but might also
    # include i386, depending on the build environment.
    # TODO figure out why ubuntu 18 builds the i386, but sles, centos
    # and ubuntu 20 do not. If we can stop ubuntu 18 then it might
    # give us some speed.
    #for prebuild in $(make help | sed -n '/-version-list/s/^... //p') ; do
     #   make $MAKEOPTS $prebuild
    #done
    echo "End Workaround for race condition"
    cmake --build . -- $MAKEOPTS
    # FIXME: check-all would be better, but some tests require sys calls that
    # are not allowed in the CI dockers and so fail. Switch to check-all
    # when possible.
    # FIXME: disable testing on sles; a test is failing for unknown reasons
    # and breaking the sles build; keep it enabled everywhere else
    # FIXME: disable check-clang on rhel; python 3.8 issue
    # and breaking the rhel build; keep it enabled everywhere else
    if [ $SKIP_LIT_TESTS -eq 0 ]; then
        if [ $FLANG_NEW -eq 1 ]; then
            CHK_FLANG="check-flang"
        fi
        if [ $RHEL_BUILD -eq 1 ]; then
            cmake --build . -- $MAKEOPTS check-lld check-mlir
        elif [ "$DISTRO_NAME" != "sles" ]; then
            cmake --build . -- $MAKEOPTS check-llvm check-clang check-lld check-mlir $CHK_FLANG
        fi
    fi
    cmake --build . -- $MAKEOPTS clang-tidy
    cmake --build . -- $MAKEOPTS install

    popd
}

package_lightning_dynamic(){

    # do common stuff here:
    if [ "$BUILD_TYPE" == "Debug" ]; then
        return
    fi

    # Echos ${LLVM_VERSION_MAJOR}.${LLVM_VERSION_MINOR}.${LLVM_VERSION_PATCH}${LLVM_VERSION_SUFFIX}
    get_llvm_version
    # We require the LLVM major, minor and patch. Scrub the LLVM_VERSION_SUFFIX.
    local llvmParsedVersion="${LLVM_VERSION_MAJOR}.${LLVM_VERSION_MINOR}.${LLVM_VERSION_PATCH}"
    local packageName="rocm-llvm"
    local packageSummary="ROCm compiler"
    local packageSummaryLong="ROCm compiler based on LLVM $llvmParsedVersion"
    local installPath="$ROCM_INSTALL_PATH/lib/llvm/"

    # setup for rocm-llvm-core package
    if [ "$BUILD_LLVM_DYLIB" == "ON" ] ; then
      local packageNameCore="rocm-llvm-core"
      local packageSummaryCore="ROCm core compiler dylibs"
      local packageSummaryLongCore="ROCm compiler based on LLVM $llvmParsedVersion"
    fi

    local packageArch="amd64"
    local packageVersion="${llvmParsedVersion}.${LLVM_COMMIT_GITDATE}"
    local packageMaintainer="ROCm Compiler Support <rocm.compiler.support@amd.com>"
    local distBin="$INSTALL_PATH/bin"
    local distInc="$INSTALL_PATH/include"
    local distLib="$INSTALL_PATH/lib"
    local distMan="$INSTALL_PATH/share/man"
    local licenseDir="$ROCM_INSTALL_PATH/share/doc/$packageName"
    local licenseDirCore="$ROCM_INSTALL_PATH/share/doc/$packageNameCore"
    local packageDir="$BUILD_PATH/package"
    local backwardsCompatibleSymlink="$ROCM_INSTALL_PATH/llvm"

    # Debian specific
    local packageDeb="$packageDir/deb"
    local controlFile="$packageDeb/DEBIAN/control"
    local postinstFile="$packageDeb/DEBIAN/postinst"
    local prermFile="$packageDeb/DEBIAN/prerm"
    local specFile="$packageDir/$packageName.spec"
    local debDependencies="python3, libc6, libstdc++6|libstdc++8, libstdc++-5-dev|libstdc++-7-dev|libstdc++-11-dev, libgcc-5-dev|libgcc-7-dev|libgcc-11-dev, rocm-core"
    local debRecommends="gcc, g++, gcc-multilib, g++-multilib, rocm-device-libs"

    # RPM specific
    local packageRpm="$packageDir/rpm"
    local packageRpmCore="$packageDir/rpm"
    local specFile="$packageDir/$packageName.spec"
    local specFileCore="$packageDir/$packageNameCore.spec"
    local rpmRequires="rocm-core"
    if [ "$BUILD_LLVM_DYLIB" == "ON" ] ; then
        rpmRequires+=", rocm-llvm-core"
    fi
    local rpmRequiresCore="rocm-core"
    local rpmRecommends="gcc, gcc-c++, devtoolset-7-gcc-c++, rocm-device-libs"

    # Cleanup previous packages
    rm -rf "$packageDir"
    echo "rm -rf $packageDir"
    rm -rf "$DEB_PATH"

    local amd_compiler_commands=("amdclang" "amdclang++" "amdclang-cl" "amdclang-cpp" "amdflang" "amdflang-new" "amdflang-legacy" "amdflang-classic" "amdlld" "offload-arch")
    local amd_man_pages=("amdclang.1.gz" "amdclang++.1.gz" "flang.1.gz" "amdflang.1.gz")
    local man_pages=("bugpoint.1" "FileCheck.1" "llvm-ar.1" "llvm-cxxmap.1" "llvm-extract.1" "llvm-lipo.1" "llvm-otool.1" "llvm-readobj.1" "llvm-symbolizer.1" "tblgen.1"
                     "clang.1" "lit.1" "llvm-as.1" "llvm-diff.1" "llvm-ifs.1" "llvm-locstats.1" "llvm-pdbutil.1" "llvm-remarkutil.1" "llvm-tblgen.1" "clang-tblgen.1"
                     "llc.1" "llvm-bcanalyzer.1" "llvm-dis.1" "llvm-install-name-tool.1" "llvm-mca.1" "llvm-profdata.1" "llvm-size.1" "llvm-tli-checker.1" "diagtool.1"
                     "lldb-tblgen.1" "llvm-config.1" "llvm-dwarfdump.1" "llvm-lib.1" "llvm-nm.1" "llvm-profgen.1" "llvm-stress.1" "mlir-tblgen.1" "dsymutil.1" "lli.1"
                     "llvm-cov.1" "llvm-dwarfutil.1" "llvm-libtool-darwin.1" "llvm-objcopy.1" "llvm-ranlib.1" "llvm-strings.1" "opt.1" "extraclangtools.1" "llvm-addr2line.1"
                     "llvm-cxxfilt.1" "llvm-exegesis.1" "llvm-link.1" "llvm-objdump.1" "llvm-readelf.1" "llvm-strip.1")

    # Only build deb in Ubuntu environment
    if [ "$PACKAGEEXT" = "deb" ]; then
        # Debian packaging

        mkdir -p "$packageDeb/$installPath"
        mkdir -p "$(dirname $controlFile)"
        mkdir -p "$DEB_PATH"
        mkdir -p "$packageDeb/$licenseDir"

        # build the rocm-llvm-core package first:
        # we only need some .so files, and we're doing a MV so that they're not picked up in the next (rocm-llvm) package.
        if [ "$BUILD_LLVM_DYLIB" == "ON" ] ; then

          mkdir -p "$packageDeb/$licenseDirCore"

          # Copy the LICENSE file to rocm-core
          cp -r "$LLVM_ROOT_LCL/LICENSE.TXT" "$packageDeb/$licenseDirCore"

          cp -P "$distLib/libLLVM"*"so"* "$packageDeb/$installPath/"
          cp -P "$distLib/libFortran"*"so"* "$packageDeb/$installPath/"
          cp -P "$distLib/libclang"*"so"* "$packageDeb/$installPath/"

          echo "Package: $packageNameCore"  > $controlFile
          echo "Architecture: $packageArch" >> $controlFile
          echo "Section: devel" >> $controlFile
          echo "Priority: optional" >> $controlFile
          echo "Maintainer: $packageMaintainer" >> $controlFile
          echo "Version: ${packageVersion}.${ROCM_LIBPATCH_VERSION}-${JOB_DESIGNATOR}${BUILD_ID}~${DISTRO_RELEASE}" >> $controlFile
          echo "Release:    ${JOB_DESIGNATOR}${BUILD_ID}~${DISTRO_RELEASE}" >> $controlFile
          echo "Depends: $debDependencies" >> $controlFile
          echo "Recommends: $debRecommends" >> $controlFile
          echo "Description: $packageSummaryCore" >> $controlFile
          echo "  $packageSummaryLongCore" >> $controlFile

          fakeroot dpkg-deb -Zgzip --build $packageDeb \
          "${DEB_PATH}/${packageNameCore}_${packageVersion}.${ROCM_LIBPATCH_VERSION}-${JOB_DESIGNATOR}${BUILD_ID}~${DISTRO_RELEASE}_${packageArch}.deb"

          # clean up, get ready for rocm-llvm
          rm -rf "$controlFile"
          rm -rf "$packageDeb/$licenseDirCore"

          #remove the LLVM/Clang dylibs we already packaged in rocm-llvm-core
          rm -f "$packageDeb/$installPath/libLLVM"*"so"*
          rm -f "$packageDeb/$installPath/libFortran"*"so"*
          rm -f "$packageDeb/$installPath/libclang"*"so"*

          mkdir -p "$(dirname $controlFile)"

          # clean up dylibs we already packaged:
          rm -rf "$packageDeb/$installPath/*"

          # add this rocm-llvm-core package as a dependency for rocm-llvm
          debDependencies="${debDependencies}, ${packageNameCore}"
        fi  # end of building rocm-llvm-core package

        # now build rocm-llvm:
        # Install license file in rocm-llvm package .
        cp -r "$LLVM_ROOT_LCL/LICENSE.TXT" "$packageDeb/$licenseDir"
        cp -r "$distBin" "$packageDeb/$installPath/bin"
        cp -r "$distInc" "$packageDeb/$installPath/include"
        cp -r "$distLib" "$packageDeb/$installPath/lib"
        if [ "$BUILD_MANPAGES" == "ON" ]; then
            # zip the generated man pages before installing them in the package
            for i in "${man_pages[@]}"; do
                gzip -f "$distMan/man1/$i"
            done
            # Create symbolic links for amd man pages
            if [ -f "$distMan/man1/clang.1.gz" ]; then
                for i in "${amd_man_pages[@]}"; do
                    ln -sf "clang.1.gz" "$distMan/man1/$i"
                done
            fi
        fi
        cp -r "$distMan" "$packageDeb/$installPath/share"

        touch "$postinstFile" "$prermFile"
        echo "mkdir -p \"$ROCM_INSTALL_PATH/bin\"" >> $postinstFile
        for i in "${amd_compiler_commands[@]}"; do
            if [ -f "$packageDeb/$installPath/bin/$i" ]; then
                echo "ln -s \"../lib/llvm/bin/$i\" \"$ROCM_INSTALL_PATH/bin/$i\"" >> $postinstFile
                echo "rm -f \"$ROCM_INSTALL_PATH/bin/$i\"" >> $prermFile
            fi
        done
        echo "rmdir --ignore-fail-on-non-empty \"$ROCM_INSTALL_PATH/bin\"" >> $prermFile
        chmod 0555 "$postinstFile" "$prermFile"
        cp -P "$backwardsCompatibleSymlink" "$packageDeb/$ROCM_INSTALL_PATH"

        echo "Package: $packageName"  > $controlFile
        echo "Architecture: $packageArch" >> $controlFile
        echo "Section: devel" >> $controlFile
        echo "Priority: optional" >> $controlFile
        echo "Maintainer: $packageMaintainer" >> $controlFile
        echo "Version: ${packageVersion}.${ROCM_LIBPATCH_VERSION}-${JOB_DESIGNATOR}${BUILD_ID}~${DISTRO_RELEASE}" >> $controlFile
        echo "Release:    ${JOB_DESIGNATOR}${BUILD_ID}~${DISTRO_RELEASE}" >> $controlFile
        echo "Depends: $debDependencies" >> $controlFile
        echo "Recommends: $debRecommends" >> $controlFile
        echo "Description: $packageSummary" >> $controlFile
        echo "  $packageSummaryLong" >> $controlFile

        fakeroot dpkg-deb -Zgzip --build $packageDeb \
        "${DEB_PATH}/${packageName}_${packageVersion}.${ROCM_LIBPATCH_VERSION}-${JOB_DESIGNATOR}${BUILD_ID}~${DISTRO_RELEASE}_${packageArch}.deb"
    fi

    # Only build RPM in CentOS or SLES or RHEL or Mariner environment
    if [ "$PACKAGEEXT" = "rpm" ]; then
        # RPM packaging
        mkdir -p "$(dirname $specFile)"
        rm -rf "$RPM_PATH"
        mkdir -p "$RPM_PATH"

        # set up for rocm-llvm-core package
        if [ "$BUILD_LLVM_DYLIB" == "ON" ] ; then
          echo "Name:       $packageNameCore" > $specFileCore
          echo "Version:    ${packageVersion}.${ROCM_LIBPATCH_VERSION}" >> $specFileCore
          echo "Release:    ${JOB_DESIGNATOR}${SLES_BUILD_ID_PREFIX}${BUILD_ID}%{?dist}" >> $specFileCore
          echo "Summary:    $packageSummaryCore" >> $specFileCore
          echo "Group:      System Environment/Libraries" >> $specFileCore
          echo "License:    ASL 2.0 with exceptions" >> $specFileCore
          echo "Requires:   $rpmRequiresCore" >> $specFileCore

          echo "%description" >> $specFileCore
          echo "$packageSummaryLongCore" >> $specFileCore

          echo "%prep" >> $specFileCore
          echo "%setup -T -D -c -n $packageNameCore" >> $specFileCore

          echo "%install" >> $specFileCore
          echo "rm -rf \$RPM_BUILD_ROOT/$installPath" >> $specFileCore
          echo "mkdir -p  \$RPM_BUILD_ROOT/$installPath/lib" >> $specFileCore
          echo "mkdir -p  \$RPM_BUILD_ROOT/$licenseDirCore" >> $specFileCore

          echo "cp -R $LLVM_ROOT_LCL/LICENSE.TXT \$RPM_BUILD_ROOT/$licenseDirCore" >> $specFileCore

          echo "cp -RP $distLib/libLLVM*so* \$RPM_BUILD_ROOT/$installPath/lib/" >> $specFileCore
          echo "cp -RP $distLib/libFortran*so* \$RPM_BUILD_ROOT/$installPath/lib/" >> $specFileCore
          echo "cp -RP $distLib/libclang*so* \$RPM_BUILD_ROOT/$installPath/lib/" >> $specFileCore

          echo "%clean" >> $specFileCore
          echo "rm -rf \$RPM_BUILD_ROOT/$installPath" >> $specFileCore
          echo "%files " >> $specFileCore
          echo "%defattr(-,root,root,-)" >> $specFileCore
          # Note: In some OS like SLES, during upgrade rocm-core is getting upgraded first and followed by other packages
          # rocm-core cannot delete rocm-ver folder, since it contains files of other packages that are yet to be upgraded
          # To remove rocm-ver folder after upgrade the spec file of other packages should contain the rocm-ver directory
          # Otherwise after upgrade empty old rocm-ver folder will be left out.
          # If empty remove /opt/rocm-ver folder and its subdirectories created by rocm-llvm-core package
          echo "$ROCM_INSTALL_PATH" >> $specFileCore

          echo "%post" >> $specFileCore
          echo "%preun" >> $specFileCore
          echo "%postun" >> $specFileCore

          echo "rpmbuild --define _topdir $packageRpmCore -ba $specFileCore"
          rpmbuild --define "_topdir $packageRpmCore" -ba $specFileCore

          mv $packageRpm/RPMS/x86_64/*.rpm $RPM_PATH
        fi # end of building rocm-lllvm-core package

        # setup for rocm-llvm package
        echo "Name:       $packageName" > $specFile
        echo "Version:    ${packageVersion}.${ROCM_LIBPATCH_VERSION}" >> $specFile
        echo "Release:    ${JOB_DESIGNATOR}${SLES_BUILD_ID_PREFIX}${BUILD_ID}%{?dist}" >> $specFile
        echo "Summary:    $packageSummary" >> $specFile
        echo "Group:      System Environment/Libraries" >> $specFile
        echo "License:    ASL 2.0 with exceptions" >> $specFile
        echo "Requires:   $rpmRequires" >> $specFile
        # The following is commented as Centos 7 has a version of rpm
        # that does not understand it. When we no longer support Centos 7
        # then we should have a correct recommends line.
        #echo "Recommends: $rpmRecommends" >> $specFile

        echo "%description" >> $specFile
        echo "$packageSummaryLong" >> $specFile

        echo "%prep" >> $specFile
        echo "%setup -T -D -c -n $packageName" >> $specFile

        echo "%install" >> $specFile
        echo "rm -rf \$RPM_BUILD_ROOT/$installPath" >> $specFile
        echo "mkdir -p  \$RPM_BUILD_ROOT/$installPath/bin" >> $specFile
        echo "mkdir -p  \$RPM_BUILD_ROOT/$installPath/include" >> $specFile
        echo "mkdir -p  \$RPM_BUILD_ROOT/$installPath/lib" >> $specFile
        echo "mkdir -p  \$RPM_BUILD_ROOT/$installPath/share/man" >> $specFile
        echo "mkdir -p  \$RPM_BUILD_ROOT/$licenseDir" >> $specFile

        echo "cp -R $LLVM_ROOT_LCL/LICENSE.TXT \$RPM_BUILD_ROOT/$licenseDir" >> $specFile
        echo "cp -P $backwardsCompatibleSymlink \$RPM_BUILD_ROOT/$ROCM_INSTALL_PATH" >> $specFile
        echo "cp -R $distBin \$RPM_BUILD_ROOT/$installPath" >> $specFile
        echo "cp -R $distInc \$RPM_BUILD_ROOT/$installPath" >> $specFile
        echo "cp -R $distLib \$RPM_BUILD_ROOT/$installPath" >> $specFile
        if [ "$BUILD_MANPAGES" == "ON" ]; then
            # zip the generated man pages before installing them in the package
            for i in "${man_pages[@]}"; do
                echo "gzip -f $distMan/man1/$i" >> $specFile
            done
            # Create symbolic links for amd man pages
            if [ -f "$distMan/man1/clang.1.gz" ]; then
                for i in "${amd_man_pages[@]}"; do
                    echo "ln -sf clang.1.gz \"$distMan/man1/$i\"" >> $specFile
                done
            fi
        fi
        echo "cp -R $distMan \$RPM_BUILD_ROOT/$installPath/share" >> $specFile

        echo "%clean" >> $specFile
        echo "rm -rf \$RPM_BUILD_ROOT/$installPath" >> $specFile
        echo "%files " >> $specFile
        if [ "$BUILD_LLVM_DYLIB" == "ON" ] ; then
          echo "%exclude $installPath/lib/libLLVM*so*" >> $specFile
          echo "%exclude $installPath/lib/libFortran*so*" >> $specFile
          echo "%exclude $installPath/lib/libclang*so*" >> $specFile
        fi

        echo "%defattr(-,root,root,-)" >> $specFile
        # Note: In some OS like SLES, during upgrade rocm-core is getting upgraded first and followed by other packages
        # rocm-core cannot delete rocm-ver folder, since it contains files of other packages that are yet to be upgraded
        # To remove rocm-ver folder after upgrade the spec file of other packages should contain the rocm-ver directory
        # Otherwise after upgrade empty old rocm-ver folder will be left out.
        # If empty remove /opt/rocm-ver folder and its subdirectories created by rocm-llvm package
        echo "$ROCM_INSTALL_PATH" >> $specFile

        echo "%post" >> $specFile
        echo "mkdir -p \"$ROCM_INSTALL_PATH/bin\"" >> $specFile
        for i in "${amd_compiler_commands[@]}"; do
            if [ -f "$distBin/$i" ]; then
                echo "ln -sf ../lib/llvm/bin/$i \"$ROCM_INSTALL_PATH/bin/$i\"" >> $specFile
            fi
        done

        echo "%preun" >> $specFile
        for i in "${amd_compiler_commands[@]}"; do
            if [ -f "$distBin/$i" ]; then
                echo "rm -f \"$ROCM_INSTALL_PATH/bin/$i\"" >> $specFile
            fi
        done
        echo "rmdir --ignore-fail-on-non-empty \"$ROCM_INSTALL_PATH/bin\"" >> $specFile
        echo "%postun" >> $specFile

        rpmbuild --define "_topdir $packageRpm" -ba $specFile
        mv $packageRpm/RPMS/x86_64/*.rpm $RPM_PATH
    fi
}

package_lightning_static() {

    # do common stuff here:
    if [ "$BUILD_TYPE" == "Debug" ]; then
        return
    fi

    # Echo the LLVM version ${LLVM_VERSION_MAJOR}.${LLVM_VERSION_MINOR}.${LLVM_VERSION_PATCH}${LLVM_VERSION_SUFFIX}
    get_llvm_version
    # We require the LLVM major, minor and patch. Scrub the LLVM_VERSION_SUFFIX.
    local llvmParsedVersion="${LLVM_VERSION_MAJOR}.${LLVM_VERSION_MINOR}.${LLVM_VERSION_PATCH}"

    # setup for rocm-llvm package
    local packageName="rocm-llvm"
    local packageSummary="ROCm core compiler"
    local packageSummaryLong="ROCm core compiler based on LLVM $llvmParsedVersion"
    # setup for rocm-llvm-dev package
    if [ "$PACKAGEEXT" = "deb" ]; then
        local packageNameExtra="rocm-llvm-dev"
    else
        local packageNameExtra="rocm-llvm-devel"
    fi
    local packageSummaryExtra="ROCm compiler dev tools"
    local packageSummaryLongExtra="ROCm compiler dev tools and documentation, based on LLVM $llvmParsedVersion"
    local installPath="$ROCM_INSTALL_PATH/lib/llvm/"

    local packageArch="amd64"
    local packageVersion="${llvmParsedVersion}.${LLVM_COMMIT_GITDATE}"
    local packageMaintainer="ROCm Compiler Support <rocm.compiler.support@amd.com>"
    local distBin="$INSTALL_PATH/bin"
    local distInc="$INSTALL_PATH/include"
    local distLib="$INSTALL_PATH/lib"
    local distMan="$INSTALL_PATH/share/man"
    local licenseDir="$ROCM_INSTALL_PATH/share/doc/$packageName"
    local packageDir="$BUILD_PATH/package"
    local backwardsCompatibleSymlink="$ROCM_INSTALL_PATH/llvm"

    # Debian specific
    local packageDeb="$packageDir/deb"
    local controlFile="$packageDeb/DEBIAN/control"
    local postinstFile="$packageDeb/DEBIAN/postinst"
    local prermFile="$packageDeb/DEBIAN/prerm"
    local specFile="$packageDir/$packageName.spec"
    local debDependencies="python3, libc6, libstdc++6|libstdc++8, libstdc++-5-dev|libstdc++-7-dev|libstdc++-11-dev, libgcc-5-dev|libgcc-7-dev|libgcc-11-dev, rocm-core"
    local debRecommends="gcc, g++, gcc-multilib, g++-multilib, rocm-device-libs"

    # RPM specific
    local packageRpm="$packageDir/rpm"
    local packageRpmExtra="$packageDir/rpm"
    local specFile="$packageDir/$packageName.spec"
    local specFileExtra="$packageDir/$packageNameExtra.spec"
    local rpmRequires="rocm-core"
    local rpmRequiresExtra="rocm-core, $packageName"
    #local rpmRecommends="gcc, gcc-c++, devtoolset-7-gcc-c++, rocm-device-libs"
    local rpmRecommends="rocm-device-libs"

    # Cleanup previous packages
    rm -rf "$packageDir"
    echo "rm -rf $packageDir"
    rm -rf "$DEB_PATH"

    local amd_compiler_commands=("amdclang" "amdclang++" "amdclang-cl" "amdclang-cpp" "amdflang" "amdflang-new" "amdflang-legacy" "amdflang-classic" "amdlld" "offload-arch")
    local amd_man_pages=("amdclang.1.gz" "amdclang++.1.gz" "flang.1.gz" "amdflang.1.gz")
    local core_bin=("amd-llvm-spirv" "amdgpu-arch" "amdgpu-offload-arch" "amdlld" "amdllvm" "clang" "clang++" "clang-${LLVM_VERSION_MAJOR}" "clang-cl"
                    "clang-cpp" "clang-build-select-link" "clang-offload-bundler" "clang-offload-packager" "clang-offload-wrapper" "clang-linker-wrapper" "clang-nvlink-wrapper" "flang" "flang-new" "flang-legacy" "flang-classic" "llvm-symbolizer"
                    "ld64.lld" "ld.lld" "llc" "lld" "lld-link" "llvm-ar" "llvm-bitcode-strip" "llvm-dwarfdump" "llvm-install-name-tool"
                    "llvm-link" "llvm-mc" "llvm-objcopy" "llvm-objdump" "llvm-otool" "llvm-ranlib" "llvm-readelf" "llvm-readobj" "llvm-strip"
                    "nvidia-arch" "nvptx-arch" "offload-arch" "opt" "wasm-ld" "amdclang" "amdclang++" "amdclang-${LLVM_VERSION_MAJOR}" "amdclang-cl"
                    "amdclang-cpp" "amdflang" "amdflang-new" "amdflang-legacy" "amdflang-classic"
                    "clang++.cfg" "clang-${LLVM_VERSION_MAJOR}.cfg" "clang-cl.cfg" "clang-cpp.cfg" "clang.cfg" "rocm.cfg"
                    "flang.cfg" "flang-new.cfg" "flang-classic.cfg" )
    local core_lib=("libclang-cpp.so.${LLVM_VERSION_MAJOR}${LLVM_VERSION_SUFFIX}" "libclang-cpp.so" "libclang.so"
                    "libclang-cpp.so.${LLVM_VERSION_MAJOR}.${LLVM_VERSION_MINOR}${LLVM_VERSION_SUFFIX}"
                    "libclang.so.${LLVM_VERSION_MAJOR}${LLVM_VERSION_SUFFIX}"
                    "libclang.so.${LLVM_VERSION_MAJOR}.${LLVM_VERSION_MINOR}.${LLVM_VERSION_PATCH}${LLVM_VERSION_SUFFIX}"
                    "libFortranSemantics.a" "libFortranLower.a" "libFortranParser.a" "libFortranCommon.a"
                    "libFortranRuntime.a" "libFortranFloat128Math.a" "libFortranDecimal.a" "libFortranEvaluate.a")
    local core_man_pages=("llvm-otool.1" "llvm-readobj.1" "clang.1" "lit.1" "llc.1" "llvm-ar.1" "llvm-dwarfdump.1" "llvm-objcopy.1" "opt.1"
                          "llvm-link.1" "llvm-mc.1" "llvm-objdump.1" "llvm-ranlib.1" "llvm-readelf.1" "llvm-strip.1")
    local dev_man_pages=("bugpoint.1" "FileCheck.1" "llvm-cxxmap.1" "llvm-extract.1" "llvm-lipo.1" "llvm-symbolizer.1"
                           "tblgen.1" "llvm-as.1" "llvm-diff.1" "llvm-ifs.1" "llvm-locstats.1" "llvm-pdbutil.1" "llvm-remarkutil.1"
                           "llvm-tblgen.1" "clang-tblgen.1" "llvm-bcanalyzer.1" "llvm-dis.1" "llvm-install-name-tool.1" "llvm-mca.1"
                           "llvm-profdata.1" "llvm-size.1" "llvm-tli-checker.1" "diagtool.1" "lldb-tblgen.1" "llvm-config.1" "llvm-lib.1"
                           "llvm-nm.1" "llvm-opt-report.1" "llvm-profgen.1" "llvm-reduce.1" "llvm-stress.1" "mlir-tblgen.1" "dsymutil.1"
                           "lli.1" "llvm-cov.1" "llvm-dwarfutil.1" "llvm-libtool-darwin.1" "llvm-strings.1"
                           "extraclangtools.1" "llvm-addr2line.1" "llvm-cxxfilt.1" "llvm-exegesis.1" "scan-build.1")

    # Only build deb in Ubuntu environment
    if [ "$PACKAGEEXT" = "deb" ]; then
        # Debian packaging

        mkdir -p "$packageDeb/$installPath"
        mkdir "${controlFile%/*}"
        mkdir -p "$DEB_PATH"
        mkdir -p "$packageDeb/$licenseDir"

        # Build the static rocm-llvm package first:
        # We're doing a MV so that they're not picked up in the next (rocm-dev) package.

        # Install license file in rocm-llvm package.
        cp -r "$LLVM_ROOT_LCL/LICENSE.TXT" "$packageDeb/$licenseDir"

        # Copy the core binaries
        mkdir -p "$packageDeb/$installPath/bin"
        for i in "${core_bin[@]}"; do
            if [ -f "$distBin/$i" ]; then
                cp -d "$distBin"/$i "$packageDeb/$installPath/bin/"
            fi
        done
        # FIXME: At this point flang is pointing to flang-classic, which does
        # not exist yet (created later), and code above does not copy it
        # because it check if it exists first. Blindly copy flang for now.
        # Permanent fix will be merged into openmp-extras by moving symlink
        # creation there.
        if [ -h $distBin/flang ]; then
          cp -d "$distBin/flang" "$packageDeb/$installPath/bin/"
        fi

        # Copy the core libraries
        # TODO: Only copy llvm/lib/clang/X.0.0/include and llvm/lib/clang/X.0.0/lib/linux
        mkdir -p "$packageDeb/$installPath/lib/clang"
        cp -r "$distLib/clang/" "$packageDeb/$installPath/lib/"

        if [ $FLANG_NEW -eq 1 ]; then
          # flang-new mod files
          mkdir -p "$packageDeb/$installPath/include/flang"
          cp -r "$distInc/flang/" "$packageDeb/$installPath/include/"
        fi

        for i in "${core_lib[@]}"; do
            if [ -f "$distLib/$i" ]; then
                cp -dr "$distLib"/$i "$packageDeb/$installPath/lib"
            fi
        done

        # Copy core specific man pages
        if [ "$BUILD_MANPAGES" == "ON" ]; then
            mkdir -p "$packageDeb/$installPath/share/man1"
            # zip the generated man pages before installing them in the package
            for i in "${core_man_pages[@]}"; do
                if [ -f "$distMan/man1/$i" ]; then
                    gzip -f "$distMan/man1/$i"
                    cp -d "$distMan/man1/${i}.gz" "$packageDeb/$installPath/share/man1/"
                fi
            done
            # Create symbolic links for amd man pages
            if [ -f "$distMan/man1/clang.1.gz" ]; then
                for i in "${amd_man_pages[@]}"; do
                    ln -sf "clang.1.gz" "$distMan/man1/$i"
                    cp -d "$distMan/man1/${i}" "$packageDeb/$installPath/share/man1/"
                done
            fi
        fi

        touch "$postinstFile" "$prermFile"
        echo "mkdir -p \"$ROCM_INSTALL_PATH/bin\"" >> $postinstFile
        for i in "${amd_compiler_commands[@]}"; do
            if [ -f "$packageDeb/$installPath/bin/$i" ]; then
                echo "ln -s \"../lib/llvm/bin/$i\" \"$ROCM_INSTALL_PATH/bin/$i\"" >> $postinstFile
                echo "rm -f \"$ROCM_INSTALL_PATH/bin/$i\"" >> $prermFile
            fi
        done
        echo "rmdir --ignore-fail-on-non-empty \"$ROCM_INSTALL_PATH/bin\"" >> $prermFile
        chmod 0555 "$postinstFile" "$prermFile"
        if [ -h $backwardsCompatibleSymlink ]; then
          cp -P "$backwardsCompatibleSymlink" "$packageDeb/$ROCM_INSTALL_PATH"
        fi

        {
            echo "Package: $packageName"
            echo "Architecture: $packageArch"
            echo "Section: devel"
            echo "Priority: optional"
            echo "Maintainer: $packageMaintainer"
            echo "Version: ${packageVersion}.${ROCM_LIBPATCH_VERSION}-${JOB_DESIGNATOR}${BUILD_ID}~${DISTRO_RELEASE}"
            echo "Release:    ${JOB_DESIGNATOR}${BUILD_ID}~${DISTRO_RELEASE}"
            echo "Depends: $debDependencies"
            echo "Recommends: $debRecommends"
            echo "Description: $packageSummary"
            echo "  $packageSummaryLong"
        } >> "$controlFile"

        fakeroot dpkg-deb -Zgzip --build $packageDeb \
            "${DEB_PATH}/${packageName}_${packageVersion}.${ROCM_LIBPATCH_VERSION}-${JOB_DESIGNATOR}${BUILD_ID}~${DISTRO_RELEASE}_${packageArch}.deb"

        # clean up, get ready for rocm-llvm-dev
        rm -rf "$controlFile"
        rm -rf "$packageDeb"

        mkdir -p "$packageDeb/$installPath"
        mkdir "${controlFile%/*}"
        mkdir -p "$DEB_PATH"

        # now build rocm-llvm-dev:
        mkdir -p "$packageDeb/$installPath/bin"
        # Only copy binaries not packaged in core
        for i in "$distBin"/*; do
            bin=$(basename "$i")
            contains "$bin" "${core_bin[@]}" "${amd_compiler_commands[@]}" && continue
            cp -d "$i" "$packageDeb/$installPath/bin/"
        done

        # Only copy libraries not packaged in core
        for i in "$distLib"/*; do
            lib=$(basename "$i")
            contains "$lib" "${core_lib[@]}" && continue
            cp -dr "$i" "$packageDeb/$installPath/lib/"
        done
        # Remove dirs already packaged in rocm-llvm-core
        rm -rf "$packageDeb/$installPath/lib/clang"

        cp -r "$distInc" "$packageDeb/$installPath/include"

        if [ $FLANG_NEW -eq 1 ]; then
          rm -rf "$packageDeb/$installPath/include/flang"
        fi

        if [ "$BUILD_MANPAGES" == "ON" ]; then
            mkdir -p "$packageDeb/$installPath/share/man1"
            # zip the generated man pages before installing them in the package
            for i in "${dev_man_pages[@]}"; do
                if [ -f "$distMan/man1/$i" ]; then
                    gzip -f "$distMan/man1/$i"
                    cp -d "$distMan/man1/${i}.gz" "$packageDeb/$installPath/share/man1/"
                fi
            done
        fi

        # add this rocm-llvm package as a dependency for rocm-llvm-dev
        debDependencies="${debDependencies}, ${packageName}"

        echo "Package: $packageNameExtra"  > $controlFile
        echo "Architecture: $packageArch" >> $controlFile
        echo "Section: devel" >> $controlFile
        echo "Priority: optional" >> $controlFile
        echo "Maintainer: $packageMaintainer" >> $controlFile
        echo "Version: ${packageVersion}.${ROCM_LIBPATCH_VERSION}-${JOB_DESIGNATOR}${BUILD_ID}~${DISTRO_RELEASE}" >> $controlFile
        echo "Release:    ${JOB_DESIGNATOR}${BUILD_ID}~${DISTRO_RELEASE}" >> $controlFile
        echo "Depends: $debDependencies" >> $controlFile
        echo "Recommends: $debRecommends" >> $controlFile
        echo "Description: $packageSummaryExtra" >> $controlFile
        echo "  $packageSummaryLongExtra" >> $controlFile

        fakeroot dpkg-deb -Zgzip --build $packageDeb \
        "${DEB_PATH}/${packageNameExtra}_${packageVersion}.${ROCM_LIBPATCH_VERSION}-${JOB_DESIGNATOR}${BUILD_ID}~${DISTRO_RELEASE}_${packageArch}.deb"
    fi

    # Only build RPM in CentOS or SLES or RHEL or Mariner environment
    if [ "$PACKAGEEXT" = "rpm" ]; then
        # RPM packaging

        mkdir -p "$(dirname $specFile)"
        rm -rf "$RPM_PATH"
        mkdir -p "$RPM_PATH"

        # set up for rocm-llvm package
        echo "Name:       $packageName" >> $specFile
        echo "Version:    ${packageVersion}.${ROCM_LIBPATCH_VERSION}" >> $specFile
        echo "Release:    ${JOB_DESIGNATOR}${SLES_BUILD_ID_PREFIX}${BUILD_ID}%{?dist}" >> $specFile
        echo "Summary:    $packageSummary" >> $specFile
        echo "Group:      System Environment/Libraries" >> $specFile
        echo "License:    ASL 2.0 with exceptions" >> $specFile
        echo "Prefix:     $ROCM_INSTALL_PATH" >> $specFile
        echo "Requires:   $rpmRequires" >> $specFile
        if [[ "$DISTRO_ID" != "centos"* ]]; then
            echo "Recommends: $rpmRecommends" >> $specFile
        fi
        echo "%description" >> $specFile
        echo "$packageSummaryLong" >> $specFile

        echo "%prep" >> $specFile
        echo "%setup -T -D -c -n $packageName" >> $specFile

        echo "%install" >> $specFile
        echo "rm -rf \$RPM_BUILD_ROOT/$installPath" >> $specFile
        echo "mkdir -p  \$RPM_BUILD_ROOT/$installPath/bin" >> $specFile
        echo "mkdir -p  \$RPM_BUILD_ROOT/$licenseDir" >> $specFile

        # Install the license file to rocm-llvm
        echo "cp -R $LLVM_ROOT_LCL/LICENSE.TXT \$RPM_BUILD_ROOT/$licenseDir" >> $specFile
        if [ -h $backwardsCompatibleSymlink ]; then
          echo "cp -P $backwardsCompatibleSymlink \$RPM_BUILD_ROOT/$ROCM_INSTALL_PATH" >> $specFile
        fi

        # Copy the core binaries
        for i in "${core_bin[@]}"; do
            if [ -f "$distBin/$i" ]; then
                echo "cp -d \"$distBin\"/$i \$RPM_BUILD_ROOT/$installPath/bin/" >> $specFile
            fi
        done

        # FIXME: At this point flang is pointing to flang-classic, which does
        # not exist yet (created later), and code above does not copy it
        # because it check if it exists first. Blindly copy flang for now.
        # Permanent fix will be merged into openmp-extras by moving symlink
        # creation there.
        if [ -h $distBin/flang ]; then
          echo "cp -d \"$distBin/flang\" \$RPM_BUILD_ROOT/$installPath/bin/" >> $specFile
        fi

        # Copy the config files
        echo "cp -d \"$distBin\"/*.cfg \$RPM_BUILD_ROOT/$installPath/bin/" >> $specFile

        # Copy the core libraries
        # TODO: Only copy llvm/lib/clang/X.0.0/include and llvm/lib/clang/X.0.0/lib/linux
        echo "mkdir -p \$RPM_BUILD_ROOT/$installPath/lib/clang" >> $specFile
        echo "cp -R \"$distLib/clang/\" \$RPM_BUILD_ROOT/$installPath/lib/" >> $specFile

        if [ $FLANG_NEW -eq 1 ]; then
          # flang-new mod files
          echo "mkdir -p \$RPM_BUILD_ROOT/$installPath/include/flang" >> $specFile
          echo "cp -R \"$distInc/flang/\" \$RPM_BUILD_ROOT/$installPath/include/" >> $specFile
        fi

        for i in "${core_lib[@]}"; do
            if [ -f "$distLib/$i" ]; then
                echo "cp -dr \"$distLib\"/$i \$RPM_BUILD_ROOT/$installPath/lib/" >> $specFile
            fi
        done

        # Copy core specific man pages
        if [ "$BUILD_MANPAGES" == "ON" ]; then
            echo "mkdir -p  \$RPM_BUILD_ROOT/$installPath/share/man/man1" >> $specFile
            # zip the generated man pages before installing them in the package
            for i in "${core_man_pages[@]}"; do
                if [ -f "$distMan/man1/$i" ]; then
                    echo "gzip -f ${distMan}/man1/${i}" >> $specFile
                    echo "cp -d ${distMan}/man1/${i}.gz \$RPM_BUILD_ROOT/$installPath/share/man/man1/" >> $specFile
                fi
            done
            # Create symbolic links for amd man pages
            for i in "${amd_man_pages[@]}"; do
                echo "ln -sf clang.1.gz ${distMan}/man1/${i}" >> $specFile
                echo "cp -d ${distMan}/man1/${i} \$RPM_BUILD_ROOT/$installPath/share/man/man1/" >> $specFile
            done
        fi

        echo "%clean" >> $specFile
        echo "rm -rf \$RPM_BUILD_ROOT/$installPath" >> $specFile
        echo "%files " >> $specFile
        echo "%defattr(-,root,root,-)" >> $specFile
        # Note: In some OS like SLES, during upgrade rocm-core is getting upgraded first and followed by other packages
        # rocm-core cannot delete rocm-ver folder, since it contains files of other packages that are yet to be upgraded
        # To remove rocm-ver folder after upgrade the spec file of other packages should contain the rocm-ver directory
        # Otherwise after upgrade empty old rocm-ver folder will be left out.
        # If empty remove /opt/rocm-ver folder and its subdirectories created by rocm-llvm-core package
        {
            echo "$ROCM_INSTALL_PATH"

            echo "%post"
            echo "mkdir -p \"\$RPM_INSTALL_PREFIX0/bin\""
            for i in "${amd_compiler_commands[@]}"; do
                if [ -f "$distBin/$i" ]; then
                    echo "ln -sf ../lib/llvm/bin/$i \"\$RPM_INSTALL_PREFIX0/bin/$i\""
                fi
            done

            echo "%preun"
            for i in "${amd_compiler_commands[@]}"; do
                if [ -f "$distBin/$i" ]; then
                    echo "rm -f \"\$RPM_INSTALL_PREFIX0/bin/$i\""
                fi
            done
            echo "rmdir --ignore-fail-on-non-empty \"\$RPM_INSTALL_PREFIX0/bin\""

            echo "%postun"
        } >> "$specFile"

        echo "rpmbuild --define _topdir $packageRpm -ba $specFile"
        rpmbuild --define "_topdir $packageRpm" -ba $specFile

        mv $packageRpm/RPMS/x86_64/*.rpm $RPM_PATH

        # setup for rocm-llvm-dev package
        echo "Name:       $packageNameExtra" > $specFileExtra
        echo "Version:    ${packageVersion}.${ROCM_LIBPATCH_VERSION}" >> $specFileExtra
        echo "Release:    ${JOB_DESIGNATOR}${SLES_BUILD_ID_PREFIX}${BUILD_ID}%{?dist}" >> $specFileExtra
        echo "Summary:    $packageSummaryExtra" >> $specFileExtra
        echo "Group:      System Environment/Libraries" >> $specFileExtra
        echo "License:    ASL 2.0 with exceptions" >> $specFileExtra
        echo "Prefix:     $ROCM_INSTALL_PATH" >> $specFileExtra
        echo "Requires:   $rpmRequiresExtra" >> $specFileExtra
        # The following is commented as Centos 7 has a version of rpm
        # that does not understand it. When we no longer support Centos 7
        # then we should have a correct recommends line.
        #echo "Recommends: $rpmRecommends" >> $specFileExtra

        echo "%description" >> $specFileExtra
        echo "$packageSummaryLongExtra" >> $specFileExtra

        echo "%prep" >> $specFileExtra
        echo "%setup -T -D -c -n $packageNameExtra" >> $specFileExtra

        echo "%install" >> $specFileExtra
        echo "rm -rf \$RPM_BUILD_ROOT/$installPath" >> $specFileExtra
        echo "mkdir -p  \$RPM_BUILD_ROOT/$installPath/bin" >> $specFileExtra
        echo "mkdir -p  \$RPM_BUILD_ROOT/$installPath/include" >> $specFileExtra
        echo "mkdir -p  \$RPM_BUILD_ROOT/$installPath/lib" >> $specFileExtra

        echo "cp -P $backwardsCompatibleSymlink \$RPM_BUILD_ROOT/$ROCM_INSTALL_PATH" >> $specFileExtra

        # Only copy binaries not packaged in core
        for i in "$distBin"/*; do
            bin=$(basename "$i")
            contains "$bin" "${core_bin[@]}" "${amd_compiler_commands[@]}" && continue
            echo "cp -d \"$i\" \$RPM_BUILD_ROOT/$installPath/bin/" >> $specFileExtra
        done
        # Only copy libraries not packaged in core
        for i in "$distLib"/*; do
            lib=$(basename "$i")
            contains "$lib" "${core_lib[@]}" && continue
            echo "cp -dr \"$i\" \$RPM_BUILD_ROOT/$installPath/lib/" >> $specFileExtra
        done

        echo "cp -R $distInc \$RPM_BUILD_ROOT/$installPath" >> $specFileExtra
        # Remove dirs already packaged in rocm-llvm-core
        echo "rm -rf \$RPM_BUILD_ROOT/$installPath/lib/clang" >> $specFileExtra

        if [ $FLANG_NEW -eq 1 ]; then
          # Remove flang mods packaged in rocm-llvm-core
          echo "rm -rf \$RPM_BUILD_ROOT/$installPath/include/flang" >> $specFileExtra
        fi

        if [ "$BUILD_MANPAGES" == "ON" ]; then
            echo "mkdir -p  \$RPM_BUILD_ROOT/$installPath/share/man/man1" >> $specFileExtra
            # zip the generated man pages before installing them in the package
            for i in "${dev_man_pages[@]}"; do
                if [ -f "$distMan/man1/$i" ]; then
                    echo "gzip -f $distMan/man1/$i" >> $specFileExtra
                    echo "cp -d \"$distMan/man1/${i}.gz\" \$RPM_BUILD_ROOT/$installPath/share/man/man1/" >> $specFileExtra
                fi
            done
        fi

        echo "%clean" >> $specFileExtra
        echo "rm -rf \$RPM_BUILD_ROOT/$installPath" >> $specFileExtra
        echo "%files " >> $specFileExtra

        echo "%defattr(-,root,root,-)" >> $specFileExtra
        # Note: In some OS like SLES, during upgrade rocm-core is getting upgraded first and followed by other packages
        # rocm-core cannot delete rocm-ver folder, since it contains files of other packages that are yet to be upgraded
        # To remove rocm-ver folder after upgrade the spec file of other packages should contain the rocm-ver directory
        # Otherwise after upgrade empty old rocm-ver folder will be left out.
        # If empty remove /opt/rocm-ver folder and its subdirectories created by rocm-llvm package
        echo "$ROCM_INSTALL_PATH" >> $specFileExtra

        echo "%post" >> $specFileExtra
        echo "%preun" >> $specFileExtra
        echo "%postun" >> $specFileExtra

        rpmbuild --define "_topdir $packageRpmExtra" -ba $specFileExtra
        mv $packageRpmExtra/RPMS/x86_64/*.rpm $RPM_PATH
    fi
}

package_docs() {

    # do common stuff here:
    if [ "$BUILD_TYPE" == "Debug"  ]; then
        return
    fi

    if [ "$BUILD_MANPAGES" == "OFF" ]; then
        return
    fi

    # Echo the LLVM version ${LLVM_VERSION_MAJOR}.${LLVM_VERSION_MINOR}.${LLVM_VERSION_PATCH}${LLVM_VERSION_SUFFIX}
    get_llvm_version
    # We require the LLVM major, minor and patch. Scrub the LLVM_VERSION_SUFFIX.
    local llvmParsedVersion="${LLVM_VERSION_MAJOR}.${LLVM_VERSION_MINOR}.${LLVM_VERSION_PATCH}"

    local packageName="rocm-llvm-docs"
    local packageSummary="ROCm LLVM compiler documentation"
    local packageSummaryLong="Documenation for LLVM $llvmParsedVersion"

    local packageArch="amd64"
    local packageVersion="${llvmParsedVersion}.${LLVM_COMMIT_GITDATE}"
    local packageMaintainer="ROCm Compiler Support <rocm.compiler.support@amd.com>"
    local distDoc="$INSTALL_PATH/share/doc/LLVM"

    local licenseDir="$ROCM_INSTALL_PATH/share/doc/$packageName"
    local packageDir="$BUILD_PATH/package"

    # Debian specific
    local packageDeb="$packageDir/deb"
    local controlFile="$packageDeb/DEBIAN/control"
    local debDependencies="rocm-core"

    # RPM specific
    local packageRpm="$packageDir/rpm"
    local specFile="$packageDir/$packageName.spec"
    local rpmRequires="rocm-core"

    # Cleanup previous packages
    rm -rf "$packageDir"
    echo "rm -rf $packageDir"

    # Only build deb in Ubuntu environment
    if [ "$PACKAGEEXT" = "deb" ]; then

        # Debian packaging
        mkdir -p "$packageDeb/$licenseDir"
        mkdir "${controlFile%/*}"

        # Install license file in rocm-llvm-docs package.
        cp -r "$LLVM_ROOT_LCL/LICENSE.TXT" "$packageDeb/$licenseDir"

        # Copy the docs
        cp -r "$distDoc" "$packageDeb/$licenseDir"

        {
            echo "Package: $packageName"
            echo "Architecture: $packageArch"
            echo "Section: devel"
            echo "Priority: optional"
            echo "Maintainer: $packageMaintainer"
            echo "Version: ${packageVersion}.${ROCM_LIBPATCH_VERSION}-${JOB_DESIGNATOR}${BUILD_ID}~${DISTRO_RELEASE}"
            echo "Release:    ${JOB_DESIGNATOR}${BUILD_ID}~${DISTRO_RELEASE}"
            echo "Depends: $debDependencies"
            echo "Recommends: $debRecommends"
            echo "Description: $packageSummary"
            echo "  $packageSummaryLong"
        } >> "$controlFile"

        fakeroot dpkg-deb -Zgzip --build $packageDeb \
        "${DEB_PATH}/${packageName}_${packageVersion}.${ROCM_LIBPATCH_VERSION}-${JOB_DESIGNATOR}${BUILD_ID}~${DISTRO_RELEASE}_${packageArch}.deb"
    fi

    # Only build RPM in CentOS or SLES or RHEL or Mariner environment
    if [ "$PACKAGEEXT" = "rpm" ]; then

        # RPM packaging
        mkdir -p "$(dirname $specFile)"
        mkdir -p "$RPM_PATH"

        # set up for rocm-llvm-docs package
        echo "Name:       $packageName" > $specFile
        echo "Version:    ${packageVersion}.${ROCM_LIBPATCH_VERSION}" >> $specFile
        echo "Release:    ${JOB_DESIGNATOR}${SLES_BUILD_ID_PREFIX}${BUILD_ID}%{?dist}" >> $specFile
        echo "Summary:    $packageSummary" >> $specFile
        echo "Group:      System Environment/Libraries" >> $specFile
        echo "License:    ASL 2.0 with exceptions" >> $specFile
        echo "Prefix:     $ROCM_INSTALL_PATH" >> $specFile
        echo "Requires:   $rpmRequires" >> $specFile

        echo "%description" >> $specFile
        echo "$packageSummaryLong" >> $specFile

        echo "%prep" >> $specFile
        echo "%setup -T -D -c -n $packageName" >> $specFile

        echo "%install" >> $specFile
        echo "mkdir -p  \$RPM_BUILD_ROOT/$licenseDir" >> $specFile

        # Install the license file to rocm-llvm-docs
        echo "cp -R $LLVM_ROOT_LCL/LICENSE.TXT \$RPM_BUILD_ROOT/$licenseDir" >> $specFile

        # Copy the docs
        echo "cp -R \"$distDoc\" \$RPM_BUILD_ROOT/$licenseDir" >> $specFile

        echo "%clean" >> $specFile
        echo "%files " >> $specFile
        echo "%defattr(-,root,root,-)" >> $specFile

        echo "$ROCM_INSTALL_PATH" >> $specFile

        rpmbuild --define "_topdir $packageRpm" -ba $specFile
        mv $packageRpm/RPMS/x86_64/*.rpm $RPM_PATH

    fi

}

print_output_directory() {
    case ${PKGTYPE} in
        ("deb")
            echo ${DEB_PATH};;
        ("rpm")
            echo ${RPM_PATH};;
        (*)
            echo "Invalid package type \"${PKGTYPE}\" provided for -o" >&2; exit 1;;
    esac
    exit
}

build() {
    mkdir -p "${INSTALL_PATH}"
    build_lightning
    create_compiler_config_files
}

case $TARGET in
    (clean) clean_lightning ;;
    (all)
        time build
        time package_lightning_static
        time package_docs
        build_wheel "$BUILD_PATH" "$PROJ_NAME"
        ;;
    (build)
        build
        ;;
    (package)
        package_lightning_static
        package_docs
        ;;
    (outdir) print_output_directory ;;
    (*) die "Invalid target $TARGET" ;;
esac

echo "Operation complete"
