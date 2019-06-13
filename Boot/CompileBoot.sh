#!/bin/bash

# Create BOOT.bin
${PATH_VIVADO}/SDK/${VER_VIVADO}/bin/bootgen -w -image ${DIR_RPOJECT}/Boot/${ZYBO_BIF} -o i ${DIR_RPOJECT}/build/BOOT.bin

# Create device tree
${DIR_RPOJECT}/Kernel/linux-xlnx/scripts/dtc/dtc -I dts -O dtb -o ${DIR_RPOJECT}/build/devicetree.dtb ${DIR_RPOJECT}/Vivado/${PROJECTNAME}/${PROJECTNAME}.sdk/device_tree_bsp_0/${DEVICETREE}.dts

