#!/bin/bash

set -x


BUILD_COMPONENT="$1"
PACKAGEEXT=${PACKAGEEXT:-$2}
COMP_DIR=$(./${INFRA_REPO}/build_${BUILD_COMPONENT}.sh -o ${PACKAGEEXT})
TARGET_ARTI_URL=${TARGET_ARTI_URL:-$3}

if { [ "$DISTRO_ID" = "mariner-2.0" ] || [ "$DISTRO_ID" = "azurelinux-3.0" ]; } \
    && { [ "$BUILD_COMPONENT" = "rocprofiler-systems" ] || [ "$BUILD_COMPONENT" = "rocjpeg" ] || [ "$BUILD_COMPONENT" = "rocdecode" ] || [ "$BUILD_COMPONENT" = "rocal" ] || [ "$BUILD_COMPONENT" = "mivisionx" ]; };
then
    echo "Skip uploading packages for ${BUILD_COMPONENT} on ${DISTRO_ID} distro"
    exit 0
fi

if { [ "$DISTRO_ID" = "debian-10" ] ; } \
    && { [ "$BUILD_COMPONENT" = "rocdecode" ] || [ "$BUILD_COMPONENT" = "rocjpeg" ]; };
then
    echo "Skip uploading packages for ${BUILD_COMPONENT} on ${DISTRO_ID} distro"
    exit 0
fi

if [ "$DISTRO_ID" = centos-7 ] && [ "$BUILD_COMPONENT" = "rocprofiler-compute" ]; then
    echo "Skip uploading packages for ${BUILD_COMPONENT}  on Centos7 distro, due to python dependency"
    exit 0
fi

# Static supported components
STATIC_SUPPORTED_COMPONENTS="comgr devicelibs hip_on_rocclr hipblas hipblas-common hipcc hiprand hipsolver hipsparse lightning openmp_extras rocblas rocm rocm_smi_lib rocm-cmake rocm-core rocminfo rocprim rocprofiler-register rocr rocrand rocsolver rocsparse"
if [ "${ENABLE_STATIC_BUILDS}" == "true" ] && ! echo "$STATIC_SUPPORTED_COMPONENTS" | grep -qE "(^| )$BUILD_COMPONENT( |$)"; then
    echo "Static build is not enabled for $BUILD_COMPONENT ..skipping upload!!"
    exit 0
fi

[ -z "$JFROG_TOKEN" ] && echo "JFrog token is not set, skip uploading..." && exit 0
[ -z "$TARGET_ARTI_URL" ] && echo "Target URL is not set, skip uploading..." && exit 0
[ -z "$COMP_DIR" ] && echo "No packages in ${BUILD_COMPONENT}" && exit 0

PKG_NAME_LIST=( "${COMP_DIR}"/* )

#retry function take two arguments sytems cmd and attempt as input and retry the system cmd for given attempts times 30 seconds
function retry_sys_cmd() {
    local sys_cmd="$1"
    local -i attempts=$2
    local -i attempt_num=1
    echo "running system command: $sys_cmd"
    until $sys_cmd
    do
        if (( attempt_num == attempts ))
        then
            echo "Attempt $attempt_num failed and there are no more attempts left!"
            return 1
        else
            sleep_for=$(( attempt_num * 30 ))
            echo "Attempt $attempt_num failed! Trying again in $sleep_for seconds..."
            sleep $sleep_for
            (( attempt_num++ ))
        fi
    done
}

for pkg in "${PKG_NAME_LIST[@]}"; do
    #Do not upload any packages which does'nt have "asan" in its name for ASAN enabled builds
    if [[ "${ENABLE_ADDRESS_SANITIZER}" != "true" ]] || [[ "${pkg##*/}" =~ "-asan" ]]; then
        UPLOAD_SERVER=${TARGET_ARTI_URL}
        if [[ "${pkg##*.}" == whl ]]; then
            UPLOAD_SERVER=${WHEEL_ARTI_URL}
            if [[ "${pkg##*/}" =~ "_dbgsym" ]] || [[ "${pkg##*/}" =~ "_debuginfo" ]]; then
                echo "Discarding debug info wheel package. Continue with next package "
                continue
            fi
        fi
        if [[ "${pkg##*/}" =~ "-asan-dbgsym" ]] || [[ "${pkg##*/}" =~ "-tests-dbgsym" ]] || [[ "${pkg##*/}" =~ "-asan-debuginfo" ]] || [[ "${pkg##*/}" =~ "-tests-debuginfo" ]]; then
            # ROCMOPS-7047 , if we stop uploading the asan-dbgsym and tests-dbgsym package to artifactory the debug+rpath (asan-dbgsym-rpath)
            # and multi version (asan-dbgsym<rocm_version>_) package will stop getting created as well . They get created as part of version_pkgs job
            echo "skipping upload of asan-dbgsym/asan-debuginfo or tests-dbgsym/tests-debuginfo package ${pkg}. Continue with next package "
                continue
        fi
        echo "Uploading $pkg ..."
        curl_cmd="curl -H "X-JFrog-Art-Api:${JFROG_TOKEN}" \
                -X PUT "${UPLOAD_SERVER}/$(basename ${pkg})" \
                -T "${COMP_DIR}/$(basename ${pkg})""
        #calling retry function with 5 attempts sleep will be 30s, 60s, 90s, 120s - total of 5 attemps in 4 minutes
        if ! retry_sys_cmd "$curl_cmd" 5; then
            echo "Unable to upload $pkg ..." >&2 && exit 1
        fi
        echo "$pkg uploaded..."
    fi
done
