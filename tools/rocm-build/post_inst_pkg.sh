#!/bin/bash

set -x


UNTAR_COMPONENT_NAME=$1

# Static supported components
STATIC_SUPPORTED_COMPONENTS="comgr devicelibs hip_on_rocclr hipblas hipblas-common hipcc hiprand hipsolver hipsparse lightning openmp_extras rocblas rocm rocm_smi_lib rocm-cmake rocm-core rocminfo rocprim rocprofiler-register rocr rocrand rocsolver rocsparse"
if [ "${ENABLE_STATIC_BUILDS}" == "true" ] && ! echo "$STATIC_SUPPORTED_COMPONENTS" | grep -qE "(^| )$UNTAR_COMPONENT_NAME( |$)"; then
    echo "Static build is not enabled for $UNTAR_COMPONENT_NAME ..skipping!!"
    exit 0
fi

copy_pkg_files_to_rocm() {
    local comp_folder=$1
    local comp_pkg_name=$2

    cd "${OUT_DIR}/${PKGTYPE}/${comp_folder}"|| exit 2
    if [ "${PKGTYPE}" = 'deb' ]; then
        dpkg-deb -x ${comp_pkg_name}_*.deb pkg/
    else
        mkdir pkg && pushd pkg/ || exit 2
        if [[ "${comp_pkg_name}" != *-dev* ]]; then
            rpm2cpio ../${comp_pkg_name}-*.rpm | cpio -idmv
        else
            rpm2cpio ../${comp_pkg_name}el-*.rpm | cpio -idmv
        fi
        popd || exit 2
    fi
    ls ./pkg -alt
    ${SUDO} cp -r ./pkg${ROCM_PATH}/* "${ROCM_PATH}" || exit 2
    rm -rf pkg/
}

get_os_name() {
    local os_name
    os_name=$(grep -oP '^NAME="\K.*(?=")' < /etc/os-release)
    echo "${os_name,,}"
}

set_pkg_type() {
    local os_name
    os_name=$(grep -oP '^NAME="\K.*(?=")' < /etc/os-release)
    if [[ "${os_name,,}" == "ubuntu" || "${os_name,,}" == "debian gnu/linux" ]]; then
        echo "deb"
    else
        echo "rpm"
    fi
}

set_llvm_link() {
    local comp_folder=$1
    local comp_pkg_name=$2

    cd "${OUT_DIR}/${PKGTYPE}/${comp_folder}"|| exit 2
    if [ "${PKGTYPE}" = 'deb' ]; then
        dpkg-deb -e ${comp_pkg_name}_*.deb post/
        mkdir -p "${ROCM_PATH}/tmp_llvm"
	cp 'post/postinst' "${ROCM_PATH}/tmp_llvm"
	pushd "${ROCM_PATH}/tmp_llvm"
	bash -x postinst
	popd
	rm -rf "${ROCM_PATH}/tmp_llvm" post/
    fi
}

setup_rocm_compilers_hash_file() {
    local clang_version
    clang_version="$("${ROCM_PATH}/llvm/bin/clang" --version | head -n 1)"
    printf '%s: %s\n' 'clang version' "${clang_version}" | tee "${OUT_DIR}/rocm_compilers_hash_file"
}

PKGTYPE=$(set_pkg_type)

case $UNTAR_COMPONENT_NAME in
    (lightning)
        if [ "${CCACHE_ENABLED}" == "true" ] ; then
            setup_rocm_compilers_hash_file
        fi

        mkdir -p ${ROCM_PATH}/bin
        printf '%s\n' > ${ROCM_PATH}/bin/target.lst gfx900 gfx906 gfx908 gfx803 gfx1030

        if [ -e "${ROCM_PATH}/lib/llvm/bin/rocm.cfg" ]; then
            sed -i '/-frtlib-add-rpath/d' ${ROCM_PATH}/lib/llvm/bin/rocm.cfg
        elif [ -e "${ROCM_PATH}/llvm/bin/rocm.cfg" ]; then
            sed -i '/-frtlib-add-rpath/d' ${ROCM_PATH}/llvm/bin/rocm.cfg
        fi

	# set_llvm_link lightning rocm-llvm
    ln -s "${ROCM_PATH}/lib/llvm/bin/amdclang" "${ROCM_PATH}/bin/amdclang" || true
    ln -s "${ROCM_PATH}/lib/llvm/bin/amdclang++" "${ROCM_PATH}/bin/amdclang++" || true
        ;;
    (hipify_clang)
	chmod +x ${ROCM_PATH}/bin/hipify-perl
        ;;
    (hip_on_rocclr)
        rm -f ${ROCM_PATH}/bin/hipcc.bat
        # hack transferbench source code
        sed -i 's/^set (CMAKE_RUNTIME_OUTPUT_DIRECTORY ..)/#&/' "$WORK_ROOT/TransferBench/CMakeLists.txt"
        ;;
    (rocblas)
        if [ $ENABLE_ADDRESS_SANITIZER != 'true' ]; then
            pkgName=rocblas-dev
            if [ "${ENABLE_STATIC_BUILDS}" == "true" ]; then
                pkgName=rocblas-static-dev
            fi
            copy_pkg_files_to_rocm rocblas $pkgName
        fi
        ;;
    (composable_kernel)
	cd "${OUT_DIR}/${PKGTYPE}/composable_kernel"
        if [ "${PKGTYPE}" = 'deb' ]; then
            dpkg-deb -c composablekernel-dev*.deb | awk '{sub(/^\./, "", $6); print $6}' | tee ../../ck.files
        else
            rpm -qlp composablekernel-dev*.rpm | tee ../../ck.files
        fi
	    ;;
    (*)
        echo "post processing is not required for ${UNTAR_COMPONENT_NAME}"
        ;;
esac

