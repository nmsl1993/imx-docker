#! /bin/bash
set -e # exit on error inside the container
# source the common variables
. ./env.sh

uuu -v ${IMX_RELEASE}/build_${DISTRO}/tmp/deploy/images/${MACHINE}/u-boot-${MACHINE}.imx