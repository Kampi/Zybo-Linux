#!/bin/bash

cd ${DIR_RPOJECT}/u-boot/u-boot-xlnx

make ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE} zynq_zybo_config
make ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE}

# Copy u-boot and configuration
cp u-boot ${DIR_RPOJECT}/build/u-boot.elf
cp ../uEnv.txt ${DIR_RPOJECT}/build/uEnv.txt

cd ${DIR_RPOJECT}
