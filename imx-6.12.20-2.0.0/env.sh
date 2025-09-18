#!/bin/bash
# Here are some default settings.
# Make sure DOCKER_WORKDIR is created and owned by current user.

# Docker

DOCKER_IMAGE_TAG="imx-yocto"
DOCKER_WORKDIR="/opt/yocto"

# Yocto

IMX_RELEASE="imx-6.12.20-2.0.0"

YOCTO_DIR="${DOCKER_WORKDIR}/${IMX_RELEASE}-build"

MACHINE="imx6ulevk"
DISTRO="fsl-imx-fb"
#IMAGES="imx-image-core"
IMAGES="fsl-image-mfgtool-initramfs"



REMOTE="https://github.com/nxp-imx/imx-manifest"
BRANCH="imx-linux-walnascar"
MANIFEST=${IMX_RELEASE}".xml"
