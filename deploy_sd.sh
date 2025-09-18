#!/bin/bash

set -e # exit on error inside the container
# source the common variables
. ./env.sh

if [ -z "$1" ]; then
    echo "Error: No argument supplied."
    exit 1
fi
if [ "$EUID" -ne 0 ]; then
    echo "Error: This script must be run as root or with sudo."
    exit 1
fi
SDCARD_BLKDEVICE="$1"
# Check if the block device is type 'mmcblk' or 'usb' or 'sd'
SDCARD_TYPE=$(udevadm info -q property -n ${SDCARD_BLKDEVICE} | grep -Po "(?<=ID_BUS=).*")
echo "SDCARD_TYPE: ${SDCARD_TYPE}"
if [ "${SDCARD_TYPE}" != "mmc" ] && [ "${SDCARD_TYPE}" != "usb" ] && [ "${SDCARD_TYPE}" != "sd" ]; then
    echo "Error: SDCARD_TYPE is not 'mmc', 'usb' or 'sd'"
    exit 1
fi
# Get the directory of the script
MACHINE_DIR=${IMX_RELEASE}/build_${DISTRO}/tmp/deploy/images/${MACHINE}
WIC_FILE=${MACHINE_DIR}/${IMAGES}-${MACHINE}.rootfs.wic.zst
if [ ! -f "${WIC_FILE}" ]; then
    echo "Error: WIC file not found at ${WIC_FILE}"
    exit 1
fi
echo "Fully erasing ${SDCARD_BLKDEVICE}!"
dd if=/dev/zero | pv -s 1000M | dd of=${SDCARD_BLKDEVICE} bs=1M count=$((1000*16)) status=none oflag=direct
sync
echo "Erasing done!"
echo "Flashing ${WIC_FILE} to ${SDCARD_BLKDEVICE}!"
#UNCOMPRESSED_SIZE=$(zstd -l $(readlink -f ${WIC_FILE}) | awk 'NR==2 {print $4}')
UNCOMPRESSED_SIZE=$(zstdcat ${WIC_FILE} | wc -c)
zstdcat ${WIC_FILE} | pv -s ${UNCOMPRESSED_SIZE} | dd of=${SDCARD_BLKDEVICE} bs=1M status=none oflag=direct
echo "syncing..."
sync
echo "Flashing done!"
exit 0
