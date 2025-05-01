#!/bin/bash

set -ex

source "$(dirname "${BASH_SOURCE[0]}")/compute_utils.sh"

stage2_command_args "$@"
build_rocm-dev(){
    $(dirname "${BASH_SOURCE[0]}")/build_rocm.sh -d
    mv ${OUT_DIR}/${PKGTYPE}/meta ${OUT_DIR}/${PKGTYPE}/rocm-dev
}


case $TARGET in
    build) build_rocm-dev ;;
    outdir) echo "${OUT_DIR}/${PKGTYPE}/rocm-dev" ;;
    clean) rm -rf ${OUT_DIR}/${PKGTYPE}/rocm-dev ;;
    *) die "Invalid target $TARGET" ;;
esac
