#!/bin/bash

# Copy all additional device tree sources
cp ${DIR_RPOJECT}/devicetree/* ${DIR_RPOJECT}/build 2>/dev/null

# Create BOOT.bin
${PATH_VIVADO}/Vitis/${VER_VIVADO}/bin/bootgen -w -image ${DIR_RPOJECT}/boot/${ZYBO_BIF} -o i ${DIR_RPOJECT}/build/BOOT.bin

# Create device tree
${DIR_RPOJECT}/kernel/linux-xlnx/scripts/dtc/dtc -I dts -O dtb -o ${DIR_RPOJECT}/build/devicetree.dtb ${DIR_RPOJECT}/build/${DEVICETREE}.dts

