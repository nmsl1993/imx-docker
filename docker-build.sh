#!/bin/bash
#
# This script creates the yocto-ready docker image.
# The --build-arg options are used to pass data about the current user.
# Also, a tag is used for easy identification of the generated image.
#

# source the common variables
. ./env.sh



# main

if [ $# -ne 1 ]
    then
        docker build --tag "${DOCKER_IMAGE_TAG}" \
                     --build-arg "DOCKER_WORKDIR=${DOCKER_WORKDIR}" \
                     -f Dockerfile-Debian-13 \
                     .
    else
        docker build --tag "${DOCKER_IMAGE_TAG}" \
                     --build-arg "DOCKER_WORKDIR=${DOCKER_WORKDIR}" \
                     -f $1 \
                     .
fi
