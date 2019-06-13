#!/bin/bash

${DIR_RPOJECT}/Qemu/qemu/aarch64-softmmu/qemu-system-aarch64 \
	-M arm-generic-fdt-7series \
	-machine linux=on \
	-serial /dev/null \
	-serial mon:stdio \
	-display none \
	-kernel ${DIR_RPOJECT}/build/uImage \
	-dtb ${DIR_RPOJECT}/build/devicetree.dtb \
	--initrd ${DIR_RPOJECT}/rootfs/${ROOTFS_QEMU}
