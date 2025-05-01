#!/bin/bash
source "${BASH_SOURCE%/*}/compute_utils.sh" || return
# Can't use -R or -r in here
remove_make_r_flags

printUsage() {
    echo
    echo "Usage: $(basename "${BASH_SOURCE}") [options ...]"
    echo
    echo "Options:"
    echo "  -c,  --clean              Clean output and delete all intermediate work"
    echo "  -p,  --package <type>     Specify packaging format"
    echo "  -r,  --release            Make a release build instead of a debug build"
    echo "  -a,  --address_sanitizer  Enable address sanitizer"
    echo "  -o,  --outdir <pkg_type>  Print path of output directory containing packages of
            type referred to by pkg_type"
    echo "  -s,  --static             Component/Build does not support static builds just accepting this param & ignore. No effect of the param on this build"
    echo "  -w,  --wheel              Creates python wheel package of rocm-gdb.
                                      It needs to be used along with -r option"
    echo "  -h,  --help               Prints this help"
    echo
    echo "Possible values for <type>:"
    echo "  deb -> Debian format (default)"
    echo "  rpm -> RPM format"
    echo

    return 0
}

toStdoutStderr(){
    printf '%s\n' "$@" >&2
    printf '%s\n' "$@"
}

linkFiles(){
    # Attempt to use hard links first for speed and save disk,
    # if that fails do a copy
    cp -lfR "$1" "$2" || cp -fR "$1" "$2"
}

## Build environment variables
PROJ_NAME=rocm-gdb
TARGET=build
MAKETARGET=deb                                  # Not currently used
BUILD_DIR=$(getBuildPath $PROJ_NAME)            # e.g. out/ubuntu.16.04/16.04/build/rocm-gdb
PACKAGE_DEB=$(getPackageRoot)/deb/$PROJ_NAME    # e.g. out/ubuntu.16.04/16.04/deb
PACKAGE_RPM=$(getPackageRoot)/rpm/$PROJ_NAME    # e.g. out/ubuntu.16.04/16.04/rpm
MAKE_OPTS="$DASH_JAY"                           # e.g. -j 56
BUG_URL="https://github.com/ROCm-Developer-Tools/ROCgdb/issues"
SHARED_LIBS="ON"
CLEAN_OR_OUT=0;
MAKETARGET="deb"
PKGTYPE="deb"
LDFLAGS="$LDFLAGS -Wl,--enable-new-dtags"
LIB_AMD_PYTHON="amdpythonlib.so"                #lib name which replaces required python lib
LIB_AMD_PYTHON_DIR_PATH=${ROCM_INSTALL_PATH}/lib


# A curated list of things to keep. It would be safer to have a list
# of things to remove, as failing to remove something is usually much
# less harmful than removeing too much.

tokeep=(
    main${ROCM_INSTALL_PATH}/bin/rocgdb
    main${ROCM_INSTALL_PATH}/bin/roccoremerge
    main${ROCM_INSTALL_PATH}/share/rocgdb/python/gdb/.*
    main${ROCM_INSTALL_PATH}/share/rocgdb/syscalls/amd64-linux.xml
    main${ROCM_INSTALL_PATH}/share/rocgdb/syscalls/gdb-syscalls.dtd
    main${ROCM_INSTALL_PATH}/share/rocgdb/syscalls/i386-linux.xml
    main${ROCM_INSTALL_PATH}/share/doc/rocgdb/NOTICES.txt
    main${ROCM_INSTALL_PATH}/share/doc/rocgdb/rocannotate.pdf
    main${ROCM_INSTALL_PATH}/share/doc/rocgdb/rocgdb.pdf
    main${ROCM_INSTALL_PATH}/share/doc/rocgdb/rocrefcard.pdf
    main${ROCM_INSTALL_PATH}/share/doc/rocgdb/rocstabs.pdf
    main${ROCM_INSTALL_PATH}/share/info/rocgdb/dir
    main${ROCM_INSTALL_PATH}/share/info/rocgdb/annotate.info
    main${ROCM_INSTALL_PATH}/share/info/rocgdb/gdb.info
    main${ROCM_INSTALL_PATH}/share/info/rocgdb/stabs.info
    main${ROCM_INSTALL_PATH}/share/man/man1/rocgdb.1
    main${ROCM_INSTALL_PATH}/share/man/man1/roccoremerge.1
    main${ROCM_INSTALL_PATH}/share/man/man5/rocgdbinit.5
    main${ROCM_INSTALL_PATH}/share/html/rocannotate/.*
    main${ROCM_INSTALL_PATH}/share/html/rocgdb/.*
    main${ROCM_INSTALL_PATH}/share/html/rocstabs/.*
)

keep_wanted_files(){
    (
        cd "$BUILD_DIR/package/"
        # generate the keep pattern as one name per line
        printf -v keeppattern '%s\n' "${tokeep[@]}"
        find main/opt -type f | grep -xv "$keeppattern" | xargs -r rm
        # prune empty directories
        find main/opt -type d -empty -delete
    )
    return 0
}

# Move to a function so that both package_deb and package_rpm can call
# and remove the depenency of package_rpm_tests on package_deb.
# Copy the required files to create a stand-alone testsuite.
copy_testsuite_files() {
(
dest="$BUILD_DIR/package/tests${ROCM_INSTALL_PATH}/test/gdb/"
cd "$ROCM_GDB_ROOT"
find \
    config.guess \
    config.sub \
    contrib/dg-extract-results.py \
    contrib/dg-extract-results.sh \
    gdb/contrib \
    gdb/disable-implicit-rules.mk \
    gdb/features \
    gdb/silent-rules.mk \
    gdb/testsuite \
    include/dwarf2.def \
    include/dwarf2.h \
    install-sh \
    -print0 | cpio -pdu0 "$dest"
)
}

clean() {
    echo "Cleaning $PROJ_NAME"

    rm -rf $BUILD_DIR
    rm -rf $PACKAGE_DEB
    rm -rf $PACKAGE_RPM
}

# set the lexically bound variable VERSION to the current version
# A passed parameter gives the default
# Note that this might need to be stripped further as it might have
# things like "-git" which is not acceptable as a version to rpm.
get_version(){
    VERSION=$(sed -n 's/^.*char version[^"]*"\([^"]*\)".*;.*/\1/p' $BUILD_DIR/gdb/version.c || : )
    VERSION=${VERSION:-$1}
}

package_deb(){
    # Package main binary.
    # TODO package documentation when we build some.
    mkdir -p "$BUILD_DIR/package/main/DEBIAN"
    # Extract version from build
    local VERSION
    get_version unknown
    # add upgrade related version sub-field
    VERSION="${VERSION}.${ROCM_LIBPATCH_VERSION}"

    #create postinstall and prerm
    grep -v '^# ' > "$BUILD_DIR/package/main/DEBIAN/postinst" <<EOF
#!/bin/sh

# Post-installation script commands
echo "Running post-installation script..."
mkdir -p $LIB_AMD_PYTHON_DIR_PATH
# Choosing the lowest version of the libpython3 installed.
PYTHON_LIB_INSTALLED=\$(find /lib/ -name 'libpython3*.so' | head -n 1)
echo "Installing rocm-gdb with [\$PYTHON_LIB_INSTALLED]."
ln -s \$PYTHON_LIB_INSTALLED $LIB_AMD_PYTHON_DIR_PATH/$LIB_AMD_PYTHON
echo "post-installation done."
EOF


    grep -v '^# ' > "$BUILD_DIR/package/main/DEBIAN/prerm" <<EOF
#!/bin/sh

# Pre-uninstallation script commands
echo "Running pre-uninstallation script..."
rm -f $LIB_AMD_PYTHON_DIR_PATH/$LIB_AMD_PYTHON
if [ -L "$LIB_AMD_PYTHON_DIR_PATH/$LIB_AMD_PYTHON" ] ; then
        echo " some rocm-gdb requisite libs could not be removed"
else
        echo " all requisite libs removed successfully "
fi
echo "pre-uninstallation done."
EOF

    chmod +x $BUILD_DIR/package/main/DEBIAN/prerm
    chmod +x $BUILD_DIR/package/main/DEBIAN/postinst

    # Create control file, with variable substitution.
    # Lines with # at the start are removed, to allow for comments
    mkdir "$BUILD_DIR/debian"
    grep -v '^# ' > "$BUILD_DIR/debian/control" <<EOF
# Required fields
Version: ${VERSION}-${CPACK_DEBIAN_PACKAGE_RELEASE}
Package: ${PROJ_NAME}
Source: ${PROJ_NAME}-src
Maintainer: ROCm Debugger Support <rocm-gdb.support@amd.com>
Description: ROCgdb
 This is ROCgdb, the AMD ROCm source-level debugger for Linux,
 based on GDB, the GNU source-level debugger.
# Optional fields
Section: utils
Architecture: amd64
Essential: no
Priority: optional
Depends: \${shlibs:Depends}, rocm-dbgapi, rocm-core, python3-dev
EOF

    # Use dpkg-shlibdeps to list shlib dependencies, the result is placed
    # in $BUILD_DIR/debian/substvars.
    (
	cd "$BUILD_DIR"
	if [[ $ASAN_BUILD == "yes" ]]
	then
		LD_LIBRARY_PATH=${ROCM_INSTALL_PATH}/lib/asan:$LD_LIBRARY_PATH
	fi
	dpkg-shlibdeps --ignore-missing-info  -e "$BUILD_DIR/package/main/${ROCM_INSTALL_PATH}/bin/rocgdb"
    )

    # Generate the final DEBIAN/control, and substitute the shlibs:Depends.
    # This is a bit unorthodox as we are only using bits and pieces of the
    # dpkg tools.
    (
    SHLIB_DEPS=$(grep "^shlibs:Depends" "$BUILD_DIR/debian/substvars" | \
			sed -e "s/shlibs:Depends=//")
    sed -E \
	    -e "/^#/d" \
	    -e "/^Source:/d" \
	    -e "s/\\$\{shlibs:Depends\}/$SHLIB_DEPS/" \
	    < debian/control > "$BUILD_DIR/package/main/DEBIAN/control"
    )

    mkdir -p "$OUT_DIR/deb/$PROJ_NAME"
    fakeroot dpkg-deb -Zgzip --build "$BUILD_DIR/package/main" "$OUT_DIR/deb/$PROJ_NAME"

    # Package the tests so they can be run on a test slave
    mkdir -p "$BUILD_DIR/package/tests/DEBIAN"
    mkdir -p "$BUILD_DIR/package/tests/${ROCM_INSTALL_PATH}/test/gdb"
    # Create control file, with variable substitution.
    # Lines with # at the start are removed, to allow for comments
    grep -v '^# ' > "$BUILD_DIR/package/tests/DEBIAN/control" <<EOF
# Required fields
Version: ${VERSION}-${CPACK_DEBIAN_PACKAGE_RELEASE}
Package: ${PROJ_NAME}-tests
Maintainer: ROCm Debugger Support <rocm-gdb.support@amd.com>
Description: ROCgdb tests
 Test Suite for ROCgdb
# Optional fields
Section: utils
Architecture: amd64
Essential: no
Priority: optional
# rocm-core as policy says everything to depend on rocm-core
Depends: ${PROJ_NAME} (=${VERSION}-${CPACK_DEBIAN_PACKAGE_RELEASE}), dejagnu, rocm-core, make
EOF

    copy_testsuite_files
    fakeroot dpkg-deb -Zgzip --build "$BUILD_DIR/package/tests" "$OUT_DIR/deb/$PROJ_NAME"
}

package_rpm(){
    # TODO, use this to package the tests as well. In the mean time hard code the package
    set -- rocm-gdb
    local packageDir="$BUILD_DIR/package_rpm/$1" # e.g. out/ubuntu-16.04/16.04/build/rocm-gdb/package_rpm/main
    local specFile="$packageDir/$1.spec"         # The generated spec file
    local packageRpm="$packageDir/rpm"           # The RPM infrastructure
    # Extract version from build. If more than one line matches then
    # expect failures. Solution is to find which version is the wanted one.
    local VERSION
    get_version 0.0.0
    # add upgrade related version sub-field
    VERSION=${VERSION}.${ROCM_LIBPATCH_VERSION}

    # get the __os_install_post macro, edit it to remove the python bytecode generation
    # rpm --showrc shows the default macros with priority level (-14) in this case
    # so remove everything before this macro, everything after it, remove the offending line,
    # and make it available as the ospost variable to insert into spec file
    local ospost="$(echo '%define __os_install_post \'
                    rpm --showrc | sed '1,/^-14: __os_install_post/d;
                                       /^-14:/,$d;/^%{nil}/!s/$/ \\/;
                                       /brp-python-bytecompile/d')"

    echo "specFile:        $specFile"
    echo "packageRpm:      $packageRpm"

    mkdir -p "$packageDir"

    # Create the spec file.
    # Allow comments in the generation of the specfile, may be overkill.
    grep -v '^## ' <<- EOF > $specFile
## Set up where this stuff goes
%define _topdir $packageRpm
%define _rpmfilename %%{ARCH}/%%{NAME}-${VERSION}-${CPACK_RPM_PACKAGE_RELEASE}%{?dist}.%%{ARCH}.rpm
## The __os_install_post macro on centos creates .pyc and .pyo objects
## by calling brp-python-bytecompile
## This then creates an issue as the script doesn't package these files
## override it
$ospost
##
Name: ${PROJ_NAME}
Group: Development/Tools/Debuggers
Summary: ROCm source-level debugger for Linux
## rpm requires the version to be dot separated numbers
Version: ${VERSION//-/_}
Release: ${CPACK_RPM_PACKAGE_RELEASE}%{?dist}
License: GPL
Prefix: ${ROCM_INSTALL_PATH}
Requires: rocm-core, rocm-dbgapi

%description
This is ROCgdb, the ROCm source-level debugger for Linux, based on
GDB, the GNU source-level debugger.

The ROCgdb documentation is available at:
https://github.com/RadeonOpenCompute/ROCm

## these things are commented out as they are not needed, but are
## left in for documentation.
# %prep
# : Should not need to do anything in prep
# %build
# : Should not need to do anything in build as make does that
# %clean
# : Should not need to do anything in clean
## This is the meat. Get a copy of the files from where we built them
## into the local RPM_BUILD_ROOT and left the defaults take over. Need
## to quote the dollar signs as we want rpm to expand them when it is
## run, rather than the shell when we build the spec file.
%install
rm -rf \$RPM_BUILD_ROOT
mkdir -p \$RPM_BUILD_ROOT
# Get a copy of the built tree.
cp -ar $BUILD_DIR/package/main/opt \$RPM_BUILD_ROOT/opt
## The file section is generated by walking the tree.
%files
EOF
    # Now generate the files
    find $BUILD_DIR/package/main/opt -type d | sed "s:$BUILD_DIR/package/main:%dir :" >> $specFile
    find $BUILD_DIR/package/main/opt ! -type d | sed "s:$BUILD_DIR/package/main::" >> $specFile

    rpmbuild --define "_topdir $packageRpm" -ba $specFile
    # Now copy it to final location
    mkdir -p "$PACKAGE_RPM"        # e.g. out/ubuntu-16.04/16.04/rpm/rocm-gdb
    mv $packageRpm/RPMS/x86_64/*.rpm "$PACKAGE_RPM"
}

package_rpm_tests(){
    # TODO, use this to package the tests as well. In the mean time hard code the package
    set -- rocm-gdb-tests
    local packageDir="$BUILD_DIR/package_rpm/$1" # e.g. out/ubuntu-16.04/16.04/build/rocm-gdb/package_rpm/main
    local specFile="$packageDir/$1.spec"         # The generated spec file
    local packageRpm="$packageDir/rpm"           # The RPM infrastructure
    # Extract version from build. If more than one line matches then
    # expect failures. Solution is to find which version is the wanted one.
    local VERSION
    get_version 0.0.0
    # add upgrade related version sub-field
    VERSION=${VERSION}.${ROCM_LIBPATCH_VERSION}
    local RELEASE=${CPACK_RPM_PACKAGE_RELEASE}%{?dist}

    echo "specFile:        $specFile"
    echo "packageRpm:      $packageRpm"

    mkdir -p "$packageRpm"

    # Create the spec file.
    # Allow comments in the generation of the specfile, may be overkill.
    local ospost="$(echo '%define __os_install_post \'
                    rpm --showrc | sed '1,/^-14: __os_install_post/d;
                                       /^-14:/,$d;/^%{nil}/!s/$/ \\/;
                                       /brp-python-bytecompile/d')"
    grep -v '^## ' <<- EOF > $specFile
## Set up where this stuff goes
%define _topdir $packageRpm
%define _rpmfilename %%{ARCH}/%%{NAME}-${VERSION}-${RELEASE}.%%{ARCH}.rpm
## The __os_install_post macro on centos creates .pyc and .pyo objects
## by calling brp-python-bytecompile
## This then creates an issue as the script doesn't package these files
## override it
$ospost
##
Name: ${PROJ_NAME}-tests
Group: Development/Tools/Debuggers
Summary: Tests for gdb enhanced to debug AMD GPUs
Version: ${VERSION//-/_}
Release: ${RELEASE}
License: GPL
Prefix: ${ROCM_INSTALL_PATH}
Requires: dejagnu, ${PROJ_NAME} = ${VERSION//-/_}-${RELEASE}, rocm-core, make

%description
Tests for ROCgdb

## these things are commented out as they are not needed, but are
## left in for documentation.
# %prep
# : Should not need to do anything in prep
# %build
# : Should not need to do anything in build as make does that
# %clean
# : Should not need to do anything in clean
## This is the meat. Get a copy of the files from where we built them
## into the local RPM_BUILD_ROOT and left the defaults take over. Need
## to quote the dollar signs as we want rpm to expand them when it is
## run, rather than the shell when we build the spec file.
%install
rm -rf \$RPM_BUILD_ROOT
mkdir -p \$RPM_BUILD_ROOT
# Get a copy of the built tree.
cp -ar $BUILD_DIR/package/tests/opt \$RPM_BUILD_ROOT/opt
## The file section is generated by walking the tree.
%files
## package everything in \$RPM_BUILD_ROOT/${ROCM_INSTALL_PATH}/test.
## A little excessive but this is just an internal test package
${ROCM_INSTALL_PATH}/test
EOF

    copy_testsuite_files

    # rpm wont resolve the dependency if the unversioned python (#!/usr/bin/python) is used.
    # /usr/bin/python - this file is not owned by any package.
    # So find and append the version to the /usr/bin/python as /usr/bin/python3
    # By updating this, the python3 requirement will be provided by the python3 package.
    find $BUILD_DIR/package/tests/opt -type f -exec sed -i '1s:^#! */usr/bin/python\>:&3:' {} +

    rpmbuild --define "_topdir $packageRpm" -ba $specFile
    # Now copy it to final location
    mkdir -p "$PACKAGE_RPM"        # e.g. out/ubuntu-16.04/16.04/rpm/rocm-gdb
    mv $packageRpm/RPMS/x86_64/*.rpm "$PACKAGE_RPM"
}

build() {
    if [ ! -e "$ROCM_GDB_ROOT/configure" ]
    then
        toStdoutStderr "No $ROCM_GDB_ROOT/configure file, skippping rocm-gdb"
        exit 0                        # This is not an error
    fi
    local pythonver=python3
    if [[ "$DISTRO_ID" == "ubuntu-18.04" ]]; then
        pythonver=python3.8
    fi
    # Workaround for rocm-gdb failure due to texlive on RHEL-9 & CentOS-9 SWDEV-339596
    if [[ "$DISTRO_ID" == "centos-9" ]] || [[ "$DISTRO_ID" == "rhel-9.0" ]]; then
        fmtutil-user --missing
    fi
    echo "Building $PROJ_NAME"
    mkdir -p "$BUILD_DIR"
    cd "$BUILD_DIR" || die "Failed to cd to '$BUILD_DIR'"
    # Build instructions taken from the README.ROCM with the addition
    # of --with-pkgversion
    #
    # The "new" way of specifying the path to the amd-dbgapi library is by
    # setting PKG_CONFIG_PATH.  The --with-amd-dbgapi flag is used to ensure
    # that if amd-dbgapi is not found, configure fails.
    #
    # --with-rocm-dbgapi is kept for now, to ease the transition.  It can be
    # removed once it is determined that we don't need to build source trees
    # using the "old" way.
    $ROCM_GDB_ROOT/configure --program-prefix=roc --prefix="${ROCM_INSTALL_PATH}" \
	--htmldir="\${prefix}/share/html" --pdfdir="\${prefix}/share/doc/rocgdb" \
	--infodir="\${prefix}/share/info/rocgdb" \
	--with-separate-debug-dir="\${prefix}/lib/debug:/usr/lib/debug" \
	--with-gdb-datadir="\${prefix}/share/rocgdb" --enable-64-bit-bfd \
	--with-bugurl="$BUG_URL" --with-pkgversion="${ROCM_BUILD_ID:-ROCm}" \
	--enable-targets="x86_64-linux-gnu,amdgcn-amd-amdhsa" \
	--disable-gas \
	--disable-gdbserver \
	--disable-gdbtk \
	--disable-gprofng \
	--disable-ld \
	--disable-shared \
	--disable-sim \
	--enable-tui \
	--with-amd-dbgapi \
	--with-expat \
	--with-lzma \
	--with-python=$pythonver \
	--with-rocm-dbgapi=$ROCM_INSTALL_PATH \
	--with-system-zlib \
	--with-zstd \
	--without-babeltrace \
	--without-guile \
	--without-intel-pt \
	--without-libunwind-ia64 \
	--without-xxhash \
	PKG_CONFIG_PATH="${ROCM_INSTALL_PATH}/share/pkgconfig" \
	LDFLAGS="$LDFLAGS"
    LD_RUN_PATH='${ORIGIN}/../lib' make $MAKE_OPTS

    if [[ "$DISTRO_ID" == "ubuntu"* ]]; then
        #changing the python lib requirement in the built gdb for ubuntu builds
        REPLACE_LIB_NAME=$(ldd -d $BUILD_DIR/gdb/gdb |awk '/libpython/{print $1}')
        echo "Replacing $REPLACE_LIB_NAME with $LIB_AMD_PYTHON"
        patchelf --replace-needed $REPLACE_LIB_NAME $LIB_AMD_PYTHON $BUILD_DIR/gdb/gdb
    fi

    mkdir -p $BUILD_DIR/package/main${ROCM_INSTALL_PATH}/{share/rocgdb,bin}
    # Install gdb
    make $MAKE_OPTS -C gdb DESTDIR=$BUILD_DIR/package/main install install-pdf install-html
    # Install binutils for coremerge and coremerge manpage.
    make $MAKE_OPTS -C binutils DESTDIR=$BUILD_DIR/package/main install
    # Add in the AMD licences file
    linkFiles $ROCM_GDB_ROOT/gdb/NOTICES.txt $BUILD_DIR/package/main${ROCM_INSTALL_PATH}/share/doc/rocgdb
    keep_wanted_files
    # If a variable CPACKGEN indicates only one type of packaging is required
    # then don't bother making the other. This variable is set up in compute_utils.sh
    # Default to building both package types if variable is not set
    # Use "[ var = value ] || ..." rather than "[ var != value ] &&" so expression
    # evaluates to true, and set -e does not cause script to exit.
    [ "${CPACKGEN}" = "DEB" ] || package_rpm && package_rpm_tests
    [ "${CPACKGEN}" = "RPM" ] || package_deb
}

# See if the code exists
print_output_directory() {
    case ${PKGTYPE} in
        ("deb")
            echo ${PACKAGE_DEB};;
        ("rpm")
            echo ${PACKAGE_RPM};;
        (*)
            echo "Invalid package type \"${PKGTYPE}\" provided for -o" >&2; exit 1;;
    esac
    exit
}

verifyEnvSetup

main(){

#parse the arguments
VALID_STR=`getopt -o hcraswo:p: --long help,clean,release,static,wheel,address_sanitizer,outdir:,package: -- "$@"`
eval set -- "$VALID_STR"

ASAN_BUILD="no"
while true ;
do
    #echo "parocessing $1"
    case "$1" in
        (-h | --help)
                printUsage ; exit 0;;
        (-c | --clean)
                TARGET="clean" ; ((CLEAN_OR_OUT|=1)) ; shift ;;
        (-r | --release)
                BUILD_TYPE="Release" ; shift ; MAKEARG="$MAKEARG REL=1" ;; # For compatability with other scripts
        (-a | --address_sanitizer)
                set_asan_env_vars
                set_address_sanitizer_on
		ASAN_BUILD="yes" ; shift ;;
        (-s | --static)
                ack_and_skip_static ;;
        (-w | --wheel)
                echo " Wheel"; WHEEL_PACKAGE=true ; shift;;
        (-o | --outdir)
                TARGET="outdir"; PKGTYPE=$2 ; OUT_DIR_SPECIFIED=1 ; ((CLEAN_OR_OUT|=2)) ; shift 2 ;;
        (-p | --package)                 #FIXME
                MAKETARGET="$2" ; shift 2;;
        # I think it would be better to use -- to indicate end of args
        # and insert an error message about unknown args at this point.
        --)     shift; break;; # end delimiter
        (*)
                echo " This should never come but just incase : UNEXPECTED ERROR Parm : [$1] ">&2 ; exit 20;;
    esac
done

# If building with Clang, we need to build in C++17 mode, to avoid some build problems
if [[ $CXX == *"clang++" ]]
then
    CXX="$CXX -std=gnu++17"
fi

RET_CONFLICT=1
check_conflicting_options $CLEAN_OR_OUT $PKGTYPE $MAKETARGET
if [ $RET_CONFLICT -ge 30 ]; then
   print_vars $API_NAME $TARGET $BUILD_TYPE $SHARED_LIBS $CLEAN_OR_OUT $PKGTYPE $MAKETARGET
   exit $RET_CONFLICT
fi

    case $TARGET in
        ("clean")
            clean
            ;;
        ("build")
            build
            build_wheel "$BUILD_DIR" "$PROJ_NAME"
            ;;
        ("outdir")
            print_output_directory
            ;;
        (*)
            die "Invalid target $TARGET"
            ;;
    esac

    echo "Operation complete"
}

# If this script is not being sourced, then run it.
if [ "$0" = "$BASH_SOURCE" ]
then
    main "$@"
else
    set +e                       # Undo the damage from compute_utils.sh
fi
