#!/bin/sh

# include the linux device tree name corresponding to the desired
# configuration to the genimage configuration file

DTB="$(sed -n 's/^BR2_LINUX_KERNEL_INTREE_DTS_NAME="\([\/a-z0-9_ \-]*\)"$/\1/p' ${BR2_CONFIG})"
BOARD_DIR="$(dirname $0)"

${HOST_DIR}/bin/mkimage -c none -A arm -T script -d ${BOARD_DIR}/sdboot.cmd ${BINARIES_DIR}/boot.scr

GENIMAGE_CFG="$(mktemp --suffix genimage.cfg)"
GENIMAGE_TMP="${BUILD_DIR}/genimage.tmp"

sed -e "s/%DTBFILE%/${DTB}/" \
    ${BOARD_DIR}/genimage-template.cfg \
    > ${GENIMAGE_CFG}

rm -rf "${GENIMAGE_TMP}"

genimage \
    --rootpath "${TARGET_DIR}" \
    --tmppath "${GENIMAGE_TMP}" \
    --inputpath "${BINARIES_DIR}" \
    --outputpath "${BINARIES_DIR}" \
    --config "${GENIMAGE_CFG}"

rm -f ${GENIMAGE_CFG}
