#!/bin/sh

# By default U-Boot loads DTB from a file named "system.dtb", so
# let's use a symlink with that name that points to the *first*
# devicetree listed in the config.

BOARD_DIR="$(dirname $0)"

FIRST_DT=$(sed -nr \
               -e 's|^BR2_LINUX_KERNEL_INTREE_DTS_NAME="xilinx/([-_/[:alnum:]\\.]*).*"$|\1|p' \
               ${BR2_CONFIG})

echo ${FIRST_DT}
[ -z "${FIRST_DT}" ] || ln -fs ${FIRST_DT}.dtb ${BINARIES_DIR}/system.dtb
${HOST_DIR}/bin/mkimage -c none -A arm -T script -d ${BOARD_DIR}/sdboot.cmd ${BINARIES_DIR}/boot.scr

support/scripts/genimage.sh -c ${BOARD_DIR}/genimage.cfg
