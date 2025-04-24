#!/bin/bash

set -e
set -o pipefail

TOPOLOGY_SYSFS_DIR=/sys/devices/virtual/kfd/kfd/topology/nodes

# Set python version
# TODO: Get the python version from build arguments
PY_COMMAND=python3.6
# Set a sensible default value for DASH_JAY in case none is provided
DASH_JAY=${DASH_JAY:-"-j $(nproc)"}

# Enable ccache by default unless requested otherwhise
if [[ "$ROCM_USE_CCACHE" != "0" ]] ; then
	for d in /usr/lib/ccache /usr/lib64/ccache ;do
		if [ -d "$d" ]; then
			PATH="$d:$PATH"
			break # Only add one ccache at most
		fi
	done
fi

# TODO: To be removed, once debug package issues are fixed
DISABLE_DEBUG_PACKAGE="false"
set_gdwarf_4() {
# In SLES and RHEL, debuginfo package is not getting generated
# Splitting debuginfo is getting failed(dwarf-5 unhandled) when compiler is set to clang.
# By default -gdwarf-5 is used for the compression of debug symbols
# So setting -gdwarf-4 as a quick fix
# TODO: -gdwarf-5 unhandling when compiler set to clang need to be fixed
    case "$DISTRO_ID" in
    (sles*|rhel*)
        SET_DWARF_VERSION_4="-gdwarf-4"
        ;;
    (*)
        SET_DWARF_VERSION_4=""
        ;;
    esac
}

# Print message to stderr
#   param message string to print on exit
# Example: printErr "file not found"
printErr() {
    echo "$@" 1>&2
}

# Print message to stderr and terminate current program
#   param message string to print on exit
# Example: die "Your program" has terminated
die() {
    printErr "FATAL: $@"
    exit 1
}

# Die if first argument is empty
#   param string to validate
#   param error message
# Example: die "$VARIABLE" "Your program" has terminated
dieIfEmpty() {
    if [ "$1" == "" ]; then
        shift
        die "$@"
    fi
}

# Get directory with build output package
# Precedence:
#       1. PWD
#       2. Caller's folder
#       3. Known build output folder
getPackageRoot() {
    local scriptPath=$(readlink -f $(dirname $BASH_SOURCE))
    local testFile="build.version"

    if [ -a "$PWD/$testFile" ]; then
        echo "$PWD"
    elif [ -a "$scriptPath/../$testFile" ]; then
        echo "$scriptPath/.."
    elif [ -a "$scriptPath/$testFile" ]; then
        echo "$scriptPath"
    elif [ ! -z "$OUT_DIR" ]; then
        echo "$OUT_DIR"
    else
        die "Failed to determine package directory"
    fi
}

# Get a list of directories containing the build output
# shared objects.
# Important: PWD takes precedence over build output folder
getLibPath() {
    local packageRoot="$(getPackageRoot)"
    dieIfEmpty "$packageRoot"
    echo "$packageRoot/lib"
}

# Get a list of directories containing the output executables
#     param binDir (optional) - package name
# Important: PWD takes precedence over build output folder
getBinPath() {
    local binDir="$1"
    local packageRoot=$(getPackageRoot)
    dieIfEmpty "$packageRoot"

    if [ "$binDir" == "" ]; then
        echo "$packageRoot/bin"
    else
        echo "$packageRoot/bin/$binDir"
    fi
}

# Get a list of directories containing the output source files
# Important: PWD takes precedence over build output folder
getSrcPath() {
    local packageRoot=$(getPackageRoot)
    dieIfEmpty "$packageRoot"
    echo "$packageRoot/src"
}

# Get a list of directories to place build output
#   param moduleName - name of the module for the build path
# Important: PWD takes precedence over build output folder
getBuildPath() {
    local moduleName="$1"
    local packageRoot=$(getPackageRoot)
    dieIfEmpty "$packageRoot"
    echo "$packageRoot/build/$moduleName"
}

# Get a list of directories containing the output etc files
# Important: PWD takes precedence over build output folder
getUtilsPath() {
    local packageRoot=$(getPackageRoot)
    dieIfEmpty "$packageRoot"
    echo "$packageRoot/utils"
}

# Get a list of directories containing the output include files
# Important: PWD takes precedence over build output folder
getIncludePath() {
    local packageRoot=$(getPackageRoot)
    dieIfEmpty "$packageRoot"
    echo "$packageRoot/include"
}

# Get the directory containing the cmake config files
getCmakePath() {
    local rocmInstallPath=${ROCM_INSTALL_PATH}
    local cmakePath="lib/cmake"
    if [ "$ASAN_CMAKE_PARAMS" == "true" ] ; then
        cmakePath="lib/asan/cmake"
    fi
    dieIfEmpty "$rocmInstallPath"
    echo "$rocmInstallPath/$cmakePath"
}

# Get a list of directories containing the output debian files
# Important: PWD takes precedence over build output folder
getDebPath() {
    local packageName="$1"
    dieIfEmpty "$packageName" "No valid package name specified"

    local packageRoot=$(getPackageRoot)
    dieIfEmpty "$packageRoot"

    echo "$packageRoot/deb/$packageName"
}

# Get a list of directories containing the output rpm files
# Important: PWD takes precedence over build output folder
getRpmPath() {
    local packageName="$1"
    dieIfEmpty "$packageName" "No valid package name specified"

    local packageRoot=$(getPackageRoot)
    dieIfEmpty "$packageRoot"

    echo "$packageRoot/rpm/$packageName"
}


verifyEnvSetup() {
    if [ -z "$OUT_DIR" ]; then
        die "Please source build/envsetup.sh first."
    fi
}

# Copy a file or directory to target location and show single line progress
progressCopy() {
    if [ -d "$1" ]; then
        rsync -a "$1"/* "$2"
    else
        rsync -a "$1" "$2"
    fi
}


#following three common functions have been written to addition of static libraries
print_lib_type() {
   if [ "$1" == "OFF" ];
   then
       echo " Building Archive "
   else
       echo " Building Shared Object "
   fi
}

check_conflicting_options() {
    # 1->CLEAN_OR_OUT 2->PKGTYPE 3->MAKETARGET
    RET_CONFLICT=0
    if [ $1 -ge 2 ]; then
       if [ "$2" != "deb" ] && [ "$2" != "rpm" ] && [ "$2" != "tar" ]; then
          echo " Wrong Param Passed for Package Type for the Outdir... "
          RET_CONFLICT=30
       fi
    fi
    # check Clean Vs Outdir
    if [ $1 -ge 3 ] && [ $RET_CONFLICT -eq 0 ] ; then
       echo " Clean & Out Both are sepcified.  Not accepted. Bailing .. "
       RET_CONFLICT=40
    fi
    if [ $RET_CONFLICT -eq 0 ] && [ "$3" != "deb" ] && [ "$3" != "rpm" ] && [ "$3" != "all" ] && [ "$3" != "tar" ]; then
       echo " Wrong Param Passed for Package Type... "
       RET_CONFLICT=50
    fi
}

# Set the LLVM directory path with respect to ROCM_PATH
# LLVM is installed in $ROCM_PATH/lib/llvm
ROCM_LLVMDIR="lib/llvm"

export ADDRESS_SANITIZER="OFF"
set_asan_env_vars() {
    export ADDRESS_SANITIZER="ON"
    # Flag to set cmake build params for ASAN builds
    ASAN_CMAKE_PARAMS="true"
    # Pass the LLVM bin path as the first parameter
    local LLVM_BIN_DIR=${1:-"${ROCM_INSTALL_PATH}/llvm/bin"}
    export CC="$LLVM_BIN_DIR/clang"
    export CXX="$LLVM_BIN_DIR/clang++"
    export FC="$LLVM_BIN_DIR/flang"
    export PATH="$PATH:$LLVM_BIN_DIR/"
    # get exact path to ASAN lib containing clang version
    ASAN_LIB_PATH=$(clang --print-file-name=libclang_rt.asan-x86_64.so)
    export LD_LIBRARY_PATH="${ASAN_LIB_PATH%/*}:${ROCM_PATH}/${ROCM_LLVMDIR}/lib:${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
    export ASAN_OPTIONS="detect_leaks=0"
}

set_address_sanitizer_on() {
    set_gdwarf_4
    export CFLAGS="-fsanitize=address -shared-libasan -g -gz $SET_DWARF_VERSION_4"
    export CXXFLAGS="-fsanitize=address -shared-libasan -g -gz $SET_DWARF_VERSION_4"
    export LDFLAGS="-Wl,--enable-new-dtags -fuse-ld=lld -fsanitize=address -shared-libasan -g -gz -Wl,--build-id=sha1 -L${ROCM_PATH}/${ROCM_LLVMDIR}/lib -L${ROCM_PATH}/lib/asan -L${ROCM_PATH}/${ROCM_LLVMDIR}/lib/asan"
}

rebuild_lapack() {
    wget -nv -O lapack-3.9.1.tar.gz \
        http://compute-artifactory.amd.com/artifactory/rocm-generic-thirdparty-deps/ubuntu/lapack-v3.9.1.tar.gz
    sh -c "echo 'd0085d2caf997ff39299c05d4bacb6f3d27001d25a4cc613d48c1f352b73e7e0 *lapack-3.9.1.tar.gz' | sha256sum -c"
    tar xzf lapack-3.9.1.tar.gz --one-top-level=lapack-src --strip-components 1
    rm lapack-3.9.1.tar.gz

    cmake -Slapack-src -Blapack-bld \
        ${LAUNCHER_FLAGS} \
        -DBUILD_TESTING=OFF \
        -DCBLAS=ON \
        -DLAPACKE=OFF
    cmake --build lapack-bld -- -j${PROC}
    sudo -E $(which cmake) --build lapack-bld -- install
    rm -rf lapack-src lapack-bld
}

ack_and_ignore_asan() {
    echo "-a parameter accepted but ignored"
}

ack_and_skip_static() {
    echo "-s parameter accepted but static build is not enabled for this component..skipping"
    exit 0
}

#debug function #dumping values in case of error to solve the same
print_vars() {
    echo " Status of Vars in $1 build "
    echo " TARGET= $2 "
    echo " BUILD_TYPE = $3 "
    echo " SHARED_LIBS = $4 "
    echo " CLEAN_OR_OUT = $5 "
    echo " PKGTYPE= $6 "
    echo " MAKETARGET = $7 "
}

# Provide this as a function, rather than a variable to delay the evaluation
# of variables. In particular we might want to put code in here which changes
# depending on if we are building with the address sanitizer or not
# Can do things like set the packaging type - no point in packaging RPM on debian and
# vica versa.
# Set CPACK_RPM_INSTALL_WITH_EXEC so it packages debug info for shared libraries.
rocm_common_cmake_params(){
    if [ "$BUILD_TYPE" = "RelWithDebInfo" ] ; then
	printf '%s ' "-DCPACK_RPM_DEBUGINFO_PACKAGE=TRUE" \
	       "-DCPACK_DEBIAN_DEBUGINFO_PACKAGE=TRUE" \
	       "-DCPACK_RPM_INSTALL_WITH_EXEC=TRUE" \
               # end of list comment or blank line
    fi
    printf '%s ' "-DROCM_DEP_ROCMCORE=ON" \
                 "-DCMAKE_EXE_LINKER_FLAGS_INIT=-Wl,--enable-new-dtags,--build-id=sha1,--rpath,$ROCM_EXE_RPATH" \
                 "-DCMAKE_SHARED_LINKER_FLAGS_INIT=-Wl,--enable-new-dtags,--build-id=sha1,--rpath,$ROCM_LIB_RPATH" \
                 "-DFILE_REORG_BACKWARD_COMPATIBILITY=OFF" \
                 "-DCPACK_RPM_PACKAGE_RELOCATABLE=ON" \
                 "-DCPACK_SET_DESTDIR=OFF" \
                 "-DINCLUDE_PATH_COMPATIBILITY=OFF" \
    # set lib directory to lib/asan for ASAN builds
    # Disable file reorg backward compatibilty for ASAN builds
    # ENABLE_ASAN_PACKAGING - Used for enabling ASAN packaging
    if [ "$ASAN_CMAKE_PARAMS" == "true" ] ; then
        local asan_common_cmake_params
        local ASAN_LIBDIR="lib/asan"
        local CMAKE_PATH=$(getCmakePath)
        asan_common_cmake_params=(
            "-DCMAKE_INSTALL_LIBDIR=$ASAN_LIBDIR"
            "-DCMAKE_PREFIX_PATH=$CMAKE_PATH;${ROCM_INSTALL_PATH}/$ASAN_LIBDIR;$ROCM_INSTALL_PATH/llvm;$ROCM_INSTALL_PATH"
            "-DENABLE_ASAN_PACKAGING=$ASAN_CMAKE_PARAMS"
            "-DCMAKE_SHARED_LINKER_FLAGS_INIT=-Wl,--enable-new-dtags,--build-id=sha1,--rpath,$ROCM_ASAN_LIB_RPATH"
        )
        printf '%s ' "${asan_common_cmake_params[@]}"
    else
        printf '%s ' "-DCMAKE_INSTALL_LIBDIR=lib" \
        # end of list comment or blank line
    fi
}

rocm_cmake_params() {
    local cmake_params

    cmake_params=(
        "-DCMAKE_PREFIX_PATH=${ROCM_INSTALL_PATH}/llvm;${ROCM_INSTALL_PATH}"
        "-DCMAKE_BUILD_TYPE=${BUILD_TYPE:-'RelWithDebInfo'}"
        "-DCMAKE_VERBOSE_MAKEFILE=1"
        "-DCPACK_GENERATOR=${CPACKGEN:-'DEB;RPM'}"
        "-DCMAKE_INSTALL_RPATH_USE_LINK_PATH=FALSE"
        "-DROCM_PATCH_VERSION=${ROCM_LIBPATCH_VERSION}"
        "-DCMAKE_INSTALL_PREFIX=${ROCM_INSTALL_PATH}"
        "-DCPACK_PACKAGING_INSTALL_PREFIX=${ROCM_INSTALL_PATH}"
    )

    printf '%s ' "${cmake_params[@]}"
}

copy_if() {
    local type=$1 selector=$2 dir=$3
    shift 3
    mkdir -p "$dir"
    if [[ "${selector,,}" =~ "${type,,}" ]] ; then
	cp -a "$@" "$dir"
    fi
    # handle ddeb files as well, renaming them on the way
    for f
    do
	case "$f" in
	    # Properly formed debian package name is a number of _ separated fields
	    # The first is the package name.
	    # Second is version number
	    # third is architecture
	    # Ensure we have at least one _ in the name
	    (*"_"*".deb")
		local deb=${f%.deb}
		local basename=${deb##*/}
		local dirname=${f%/*}
                # filename($f) can be either /some/path/pkgname.deb or pkgname.deb
                # If its pkgname.deb, then directory should be .
                [[ "$dirname" == "$f" ]] && dirname=.
		local pkgname=${basename%%_*}
		local pkgextra=${basename#*_}
		# cmake 3.22 creates the filename by replacing .deb with -dbgsym.ddeb
		# at least for hostcall. Mind you hostcall looks to be incorrectly packaged.
		if [ -e "${deb}-dbgsym.ddeb" ]
		then
		    dest=${deb##*/}
		    dest="${dest%%_*}-dbgsym_${dest#*_}"
		    cp -a "${deb}-dbgsym.ddeb" "$dir/${dest##*/}.deb"
		    # copying the -dbgsym package to build director as well , as it is used for uploading to artifactory
		    cp -a "${deb}-dbgsym.ddeb" "$BUILD_DIR/${dest##*/}.deb"
		fi
		# This is needed for comgr
		if [ -e "$dirname/${pkgname}-dbgsym_${pkgextra}.ddeb" ]
		then
		    cp "$dirname/${pkgname}-dbgsym_${pkgextra}.ddeb" "$dir/${pkgname}-dbgsym_${pkgextra}.deb"
		fi
		;;
	esac
    done
}


# Function to remove -r or -R from MAKEFLAGS
remove_make_r_flags(){
    local firstword='^[^ ]*'
    if [[ "$MAKEFLAGS" =~ ${firstword}r ]] ; then MAKEFLAGS=${MAKEFLAGS/r/} ; fi
    if [[ "$MAKEFLAGS" =~ ${firstword}R ]] ; then MAKEFLAGS=${MAKEFLAGS/R/} ; fi
}



# Functions to create wheel packages
install_wheel_prerequisites(){
    sudo  yum install -y cpio
    $PY_COMMAND -m pip install --upgrade pip
    $PY_COMMAND -m pip install --upgrade build wheel setuptools rpm
}
# Before calling create_wheel_packge, make sure to set the global variables
# Global variables: BUILD_SCRIPT_ROOT
create_wheel_package() {
    echo "Creating wheel package"
    local buildDir="$1"
    local projName="$2"
    local PKG_INFO="pkginfo"
    # Get package output directory from project name
    local packageDir="$(getRpmPath $projName)"
    local ROCM_WHEEL_DIR="${buildDir}/_wheel"
    # Remove the _wheel directory if already exist
    rm -rf $ROCM_WHEEL_DIR
    mkdir -p $ROCM_WHEEL_DIR
    # Copy the setup.py generator to build folder
    cp -f $BUILD_SCRIPT_ROOT/setup.py $ROCM_WHEEL_DIR
    pushd $ROCM_WHEEL_DIR

    local PKG_NAME_LIST=( "${packageDir}"/*.rpm )
    for pkg in "${PKG_NAME_LIST[@]}"; do
        if [[ "$pkg" =~ "-dbgsym" ]] || [[ "$pkg" =~ "-debuginfo" ]]; then
            echo "Discarding debug info wheel package. Continue with next package "
            continue
        fi
        pkgFiles=$(rpm -ql "$pkg")
        if [[ "$pkgFiles" =~ "contains no files" ]]; then
            echo "Package $pkg is empty."
            continue
        fi
        #Clean up any old files
        rm -rf opt usr  build $PKG_INFO
        cat << EOF > "$PKG_INFO"
PKG_NAME=$pkg
EOF
        # Currently only supports python3.6
        $PY_COMMAND -m build --wheel -n -C--global-option=--build-number -C--global-option=$BUILD_ID
    done
    # Copy the wheel created to RPM folder which will be uploaded to artifactory
    copy_if WHL "WHL" "$packageDir" "$ROCM_WHEEL_DIR"/dist/*.whl
    popd
}

# Function used by component build scripts for generating wheel package
# Wheel package will be created if WHEEL_PACKAGE is set
build_wheel() {
  if [[ "$WHEEL_PACKAGE" != "true" ]] || [[ "$SHARED_LIBS" == "OFF" ]] || [[ "$ENABLE_ADDRESS_SANITIZER" == "true" ]]; then
    echo "Wheel Package build disabled !!!!"
    return
  fi
  echo "Wheel Package build started !!!!"
  install_wheel_prerequisites
  # Input argument
  # $1 : Build directory
  # $2 : project name
  if [ -n "$1" ]; then
	  create_wheel_package "$1" "$2"
  else
	  create_wheel_package $BUILD_DIR "${PACKAGE_DIR##*/}"
  fi
}

# Set a variable to the value needed by cmake to use ninja if it is available
# If GEN_NINJA is already defined, even as the empty string, then leave the value alone
# Intended use in build_xxxx.sh is ${GEN_NINJA:+"$GEN_NINJA"} to cope with potentially weird values
# but in practice just ${GEN_NINJA} without quotes will be fine.
# e.g.            cmake -DCMAKE_BUILD_TYPE="$BUILD_TYPE" $GEN_NINJA
# If for some reason you wanted to build without ninja just export an empty GEN_NINJA variable
if [ "${GEN_NINJA+defined}" != "defined" ] && command -v ninja >/dev/null ; then
    GEN_NINJA=-GNinja
fi

# Install amdgpu-install-internal package required for running amdpgu-repo and
# set the repo for installing amdgpu static package
set_amdgpu_repo() {
    #if amdgpu-repo command doesn't exist, install it
    if ! command -v amdgpu-repo &> /dev/null
    then
        # From ROCm VERSION get the first two numbers eg 6.2.0 --> 6.2
        AMDGPU_INSTALL_VER=${ROCM_VERSION%%.${ROCM_VERSION#?.*.}}
        # Currently static builds are triggered in RHEL-8 OS. only yum install is used for time being
        # TODO: Should be modified to handle other OS as well
        BASE_URL="https://artifactory-cdn.amd.com/artifactory/list/amdgpu-rpm/rhel"
        sudo yum install -y "${BASE_URL}/amdgpu-install-internal-${AMDGPU_INSTALL_VER}_8-1.noarch.rpm"
    fi
    KERNEL_INFO_FILE_URL=http://rocm-ci.amd.com/job/$JOB_NAME/$BUILD_ID/artifact/amdgpu_kernel_info.txt
    RADEON_TIER=$(curl "${KERNEL_INFO_FILE_URL}") || die "Failed to set Linux core build number."
    AMDGPU_BUILD_OPT="--amdgpu-build=${RADEON_TIER}"
    for delay in 0 30 60 120
        do
            echo "Sleeping ${delay} seconds"
            sleep ${delay};
            sudo amdgpu-repo $AMDGPU_BUILD_OPT --rocm-build="${JOB_NAME}/${BUILD_ID}" && return 0
            echo "Attempt to update repo using amdgpu-repo failed, retrying..."
        done
    echo "All attempts for amdgpu-repo installation failed, fallback to local repo update and installation!"
    return 1
}

# Function will install drm static packages and its dependencies
install_drmStatic_lib(){
    if set_amdgpu_repo ; then
       sudo yum install -y libdrm-amdgpu-static
    else
       echo " amdgpu repo setting failed (rc=$?) "
       exit 60
    fi
}


# Set offload compress to ON by default
DISABLE_OFFLOAD_COMPRESSION="false"
setup_offload_compress(){
    # Enable offload compression based on the flag
    if [ "${DISABLE_OFFLOAD_COMPRESSION}" == "false" ] ; then
        export CFLAGS="$CFLAGS --offload-compress "
        export CXXFLAGS="$CXXFLAGS --offload-compress "
    else
        # Disable offload compression based on the flag
        export CFLAGS=${CFLAGS//" --offload-compress "/ }
        export CXXFLAGS=${CXXFLAGS//" --offload-compress "/ }
    fi
}

# Get CMAKE build flags for CMAKE build trigger
set_build_variables() {

    # Variables which changes based on build types ex:ASAN/STATIC Builds.
    # Note:
    # 1. __CXX__ Argument is for getting the equivalant cmake_cxx_flag_params
    #    which is clang++ for ASAN/STATIC builds and hipcc for rest all builds.
    # 2. __CC__ Argument is for getting the equivalant cmake_cc_flag_params
    #    which is clang for ASAN/STATIC builds and hipcc for rest all builds.
    # 3. Similarly the __CMAKE_CXX_COMPILER__ and __CMAKE_CC_COMPILER__ Arguments
    #    gives clang++, clang configuration for ASAN/STATIC and hipcc for rest of all builds.
    local cxx_flag_params
    local cc_flag_params
    local LLVM_BIN_DIR="$ROCM_PATH/lib/llvm/bin"
    local HIPCC_BIN_DIR="$ROCM_PATH/bin"

    # Set Variable based on build types
    if [ "${ENABLE_ADDRESS_SANITIZER}" == "true" ] || [ "${ENABLE_STATIC_BUILDS}" == "true" ] ; then
        cxx_flag_params="$LLVM_BIN_DIR/clang++"
        cc_flag_params="$LLVM_BIN_DIR/clang"
    else
        setup_offload_compress
        cxx_flag_params="$HIPCC_BIN_DIR/hipcc"
        cc_flag_params="$HIPCC_BIN_DIR/hipcc"
    fi

    case "$1" in
    ("__C_++__")
      printf "%s" "c++"
      ;;
    ("__G_++__")
      printf "%s" "g++"
      ;;
    ("__AMD_CLANG_++__")
      printf "%s" "amdclang++"
      ;;
    ("__HIP_CC__")
      printf "%s" "$HIPCC_BIN_DIR/hipcc"
      ;;
    ("__CLANG++__")
      printf "%s" "$LLVM_BIN_DIR/clang++"
      ;;
    ("__CLANG__")
      printf "%s" "$LLVM_BIN_DIR/clang"
      ;;
    ("__CXX__")
      printf "%s" "${cxx_flag_params}"
      ;;
     ("__CC__")
      printf "%s" "${cc_flag_params}"
      ;;
     ("__CMAKE_CC_PARAMS__")
      printf '%s ' "-DCMAKE_C_COMPILER=${cc_flag_params}"
      ;;
     ("__CMAKE_CXX_PARAMS__")
      printf '%s ' "-DCMAKE_CXX_COMPILER=${cxx_flag_params}"
      ;;
     (*)
      exit 1
      ;;
    esac
    exit
}

# Get the install directory name for libraries
getInstallLibDir() {
    local libDir="lib"
    if [ "${ENABLE_ADDRESS_SANITIZER}" == "true" ] ; then
        libDir="lib/asan"
    fi
    echo "$libDir"
}

# Hardcoding the default GPU_ARCH, but this will be overwritten by input from job param or by component build script
GFX_ARCH="gfx908;gfx90a:xnack-;gfx90a:xnack+;gfx1030;gfx1100;gfx1101;gfx1102;gfx942:xnack-;gfx942:xnack+;gfx1200;gfx1201"
if [ "${ENABLE_ADDRESS_SANITIZER}" == "true" ] ; then
    # updating Default GPU_ARCHS for ASAN builds
    GFX_ARCH="gfx90a:xnack+;gfx942:xnack+"
fi
# if ENABLE_GPU_ARCH Job parameter is set, then set GFX_ARCH to that value
if [ -n "$ENABLE_GPU_ARCH" ]; then
    GFX_ARCH="$ENABLE_GPU_ARCH"
fi
# Finally overwrite the GPU_ARCH with the value from the component build script, if set_gpu_arch is called
# We need to make sure where set_gpu_arch is called in the component build script,
# it should have if condition to check if GPU_ARCH is set by ENABLE_GPU_ARCH, so JOB LEVEL PARAM will have highest priority
set_gpu_arch(){
    GFX_ARCH="$1"
}

disable_debug_package_generation(){
    SET_DWARF_VERSION_4=""
    DISABLE_DEBUG_PACKAGE="true"
}

# Populate the common cmake params
rocm_math_common_cmake_params=()
init_rocm_common_cmake_params(){
  local retCmakeParams=${1:-rocm_math_common_cmake_params}
  local SET_BUILD_TYPE=${BUILD_TYPE:-'RelWithDebInfo'}
  local ASAN_LIBDIR="lib/asan"
  local CMAKE_PATH=$(getCmakePath)
# Common cmake parameters can be set
# component build scripts can use this function
  local cmake_params
  if [ "${ASAN_CMAKE_PARAMS}" == "true" ] ; then
    cmake_params=(
        "-DCMAKE_PREFIX_PATH=$CMAKE_PATH;${ROCM_PATH}/$ASAN_LIBDIR;$ROCM_PATH/llvm;$ROCM_PATH"
        "-DCMAKE_SHARED_LINKER_FLAGS_INIT=-Wl,--enable-new-dtags,--build-id=sha1,--rpath,$ROCM_ASAN_LIB_RPATH"
        "-DCMAKE_EXE_LINKER_FLAGS_INIT=-Wl,--enable-new-dtags,--build-id=sha1,--rpath,$ROCM_ASAN_EXE_RPATH"
        "-DENABLE_ASAN_PACKAGING=true"
    )
  else
    cmake_params=(
        "-DCMAKE_PREFIX_PATH=${ROCM_PATH}/llvm;${ROCM_PATH}"
        "-DCMAKE_SHARED_LINKER_FLAGS_INIT=-Wl,--enable-new-dtags,--build-id=sha1,--rpath,$ROCM_LIB_RPATH"
        "-DCMAKE_EXE_LINKER_FLAGS_INIT=-Wl,--enable-new-dtags,--build-id=sha1,--rpath,$ROCM_EXE_RPATH"
    )
  fi

  cmake_params+=(
      "-DCMAKE_VERBOSE_MAKEFILE=1"
      "-DCMAKE_BUILD_TYPE=${SET_BUILD_TYPE}"
      "-DCMAKE_INSTALL_RPATH_USE_LINK_PATH=FALSE"
      "-DCMAKE_INSTALL_PREFIX=${ROCM_PATH}"
      "-DCMAKE_PACKAGING_INSTALL_PREFIX=${ROCM_PATH}"
      "-DBUILD_FILE_REORG_BACKWARD_COMPATIBILITY=OFF"
      "-DROCM_SYMLINK_LIBS=OFF"
      "-DCPACK_PACKAGING_INSTALL_PREFIX=${ROCM_PATH}"
      "-DROCM_DISABLE_LDCONFIG=ON"
      "-DCPACK_SET_DESTDIR=OFF"
      "-DCPACK_RPM_PACKAGE_RELOCATABLE=ON"
      "-DROCM_PATH=${ROCM_PATH}"
  )
  #rocWMMa does not support gfx1030, so removing from default
  if [ "${COMPONENT_SRC}" == "$LIBS_WORK_DIR/rocWMMA" ]; then
    GFX_ARCH=$(echo $GFX_ARCH | sed 's/\(gfx1030;\)//g')
  fi
  #if component is not composable_kernel then only add -DAMDGPU_TARGETS, this is not supported for CK along with -DINSTANCES_ONLY
  if [ "${COMPONENT_SRC}" != "$LIBS_WORK_DIR/composable_kernel" ]; then
    cmake_params+=(
        "-DAMDGPU_TARGETS=${GFX_ARCH}"
    )
  fi

  #if component is not hipsparselt | hipblaslt | rocBLAS | composable_kernel, then only add below cmake params. as GPU_TARGETS and CMAKE_HIP_ARCHITECTURES are not supported for hipsparselt, hipblaslt and rocblas
  # in future after SWDEV-468293, below params is not needed for any component
  case "${COMPONENT_SRC}" in
    "${LIBS_WORK_DIR}/hipSPARSELt" | "${LIBS_WORK_DIR}/hipBLASLt" | "${LIBS_WORK_DIR}/rocBLAS" | "${LIBS_WORK_DIR}/composable_kernel")
        # Do nothing for these components
        ;;
    *)
        cmake_params+=(
            "-DGPU_TARGETS=${GFX_ARCH}"
            "-DCMAKE_HIP_ARCHITECTURES=${GFX_ARCH}"
        )
        ;;
  esac
  #TODO :remove if clause once debug related issues are fixed
  if [ "${DISABLE_DEBUG_PACKAGE}" == "true" ] ; then
    SET_BUILD_TYPE=Release
    cmake_params+=(
        "-DCPACK_DEBIAN_DEBUGINFO_PACKAGE=FALSE"
        "-DCPACK_RPM_DEBUGINFO_PACKAGE=FALSE"
        "-DCPACK_RPM_INSTALL_WITH_EXEC=FALSE"
        "-DCMAKE_BUILD_TYPE=${SET_BUILD_TYPE}"
    )
  elif [ "$SET_BUILD_TYPE" == "RelWithDebInfo" ] || [ "$SET_BUILD_TYPE" == "Debug" ]; then
    # RelWithDebinfo optimization level -O2 is having performance impact
    # So overriding the same to -O3
    set_gdwarf_4
    cmake_params+=(
        "-DCPACK_DEBIAN_DEBUGINFO_PACKAGE=TRUE"
        "-DCPACK_RPM_DEBUGINFO_PACKAGE=TRUE"
        "-DCPACK_RPM_INSTALL_WITH_EXEC=TRUE"
        "-DCMAKE_CXX_FLAGS_RELWITHDEBINFO=${SET_DWARF_VERSION_4} -O3 -g -DNDEBUG"
    )
  fi
  eval "${retCmakeParams}=( \"\${cmake_params[@]}\" ) "
}

# Setup a number of variables to specify where to find the source
# where to do the build and where to put the packages
# Note the PACKAGE_DIR downcases the package name
# This could be extended to do different things based on $1
set_component_src(){
    COMPONENT_SRC="$LIBS_WORK_DIR/$1"

    BUILD_DIR="$OUT_DIR/build/$1"
    DEB_PATH="$OUT_DIR/${PKGTYPE}/${1,,}"
    RPM_PATH="$OUT_DIR/${PKGTYPE}/${1,,}"
    PACKAGE_DIR="$OUT_DIR/${PKGTYPE}/${1,,}"
}

# Standard definition of function to print the package location.  If
# for some reason a custom version is needed then it can overwrite
# this definition
# TODO: Don't use a global PKGTYPE, pass the value in as a parameter
print_output_directory() {
    case ${1:-$PKGTYPE} in
        ("deb")
            echo ${DEB_PATH};;
        ("rpm")
            echo ${RPM_PATH};;
        (*)
            echo "Invalid package type \"${PKGTYPE}\" provided for -o" >&2; exit 1;;
    esac
    exit
}

# Standard argument processing
# Here to avoid repetition
TARGET="build"			# default target
stage2_command_args(){
    while [ "$1" != "" ];
    do
	case $1 in
            -o  | --outdir )
		shift 1; PKGTYPE=$1 ; TARGET="outdir" ;;
            -c  | --clean )
		TARGET="clean" ;;
            *)
		break ;;
	esac
	shift 1
    done
}

show_build_cache_stats(){
    if [ "$CCACHE_ENABLED" = "true" ] ; then
        if ! ccache -s; then
            echo "Unable to display sccache stats"
        fi
    fi
}
