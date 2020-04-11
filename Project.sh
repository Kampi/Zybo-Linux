#
# Project.sh
#
#  Copyright (C) Daniel Kampert, 2018
#	Website: www.kampis-elektroecke.de
#  File info: Project script for Zybo Linux project
#
# GNU GENERAL PUBLIC LICENSE:
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.
#
# Errors and omissions should be reported to DanielKampert@kampis-elektroecke.de
# 

#!/bin/bash

##### Project settings ####
export VER_VIVADO=2019.2
export VER_KERNEL=xlnx_rebase_v4.14_2018.3
export VER_UBOOT=xilinx-v2017.4
export VER_DT=xilinx-v2018.3
export YOCTO_BRANCH=morty
export TARGET_MACHINE=zedboard-zynq7

export BOOTLOADER=FSBL
export DESIGNNAME=System
export PROJECTNAME=SimpleLinux
export DEVICETREE=Bootargs
export ZYBO_BIF=Zybo.bif

export ROOTFS_QEMU=arm_ramdisk.image.gz

export PATH_VIVADO=/opt/Xilinx
export PATH_COMPILER=sdk/sysroots/x86_64-pokysdk-linux/usr/bin/arm-poky-linux-gnueabi/arm-poky-linux-gnueabi
###########################

#### Colors #####
Red="\033[0;31m"
Green="\033[0;32m"
Reset="\033[0m"
Yellow="\033[0;33m"
Cyan="\033[0;36m"
#################

# Current dir
export DIR_RPOJECT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Export the architecture, the cross compiler and the kernel sources
export ARCH=arm
export TYPE=armv7-a
export CPU=cortex-a9
export FPU=neon
export FLOAT_ABI=hard
export KDIR=${DIR_RPOJECT}/kernel/linux-xlnx
export CROSS_COMPILE=${DIR_RPOJECT}/${PATH_COMPILER}-
export SYSROOT=${DIR_RPOJECT}/sdk/sysroots/cortexa9hf-neon-poky-linux-gnueabi

# Add u-boot to path
export PATH=${PATH}:${DIR_RPOJECT}/u-boot/u-boot-xlnx/tools

# Source vivado settings
bash -c "source ${PATH_VIVADO}/Vivado/${VER_VIVADO}/settings64.sh"

# Parse the command line arguments
if [ $# -eq 1 ] 
	then
		if [ $1 == "-install" ]
			then
				echo -e ${Yellow}"Install packages..."${Reset}
				sudo yum update
				sudo yum -y install openssh-server git autoconf automake libtool python-pip gawk chrpath texinfo python3-pip tree --skip-broken
				sudo yum -y install dtc --skip-broken
				sudo yum -y install uboot-tools gcc gcc-c++ make ncurses-devel --skip-broken
				sudo yum -y install SDL-devel libncurses* openssl-devel gtk+-devel gtk2-devel libXtst libstdc++* dbus-glib alsa-lib-devel glib-devel libgcrypt-devel gmp-devel mpfr libX11 libmpc-devel zlib* --skip-broken

				echo -e ${Yellow}"Install python packages..."${Reset}
				python3 -m pip install --user django==1.8.7

				# Add run permissions to the scrips
				sudo chmod +x kernel/CompileKernel.sh
				sudo chmod +x u-boot/CompileUBoot.sh
				sudo chmod +x boot/CompileBoot.sh
				sudo chmod +x qemu/StartQemu.sh

				# Get the sources
				echo -e ${Yellow}"Fetch xilinx sources from git..."${Reset}
				cd kernel
				git clone https://github.com/Xilinx/linux-xlnx.git
				cd linux-xlnx
				git fetch && git fetch --tags
				git checkout ${VER_KERNEL}
				cd ${DIR_RPOJECT}

				cd u-boot
				git clone https://github.com/Xilinx/u-boot-xlnx.git
				cd u-boot-xlnx
				git fetch && git fetch --tags
				git checkout ${VER_UBOOT}
				cd ${DIR_RPOJECT}

				cd devicetree
				git clone https://github.com/Xilinx/device-tree-xlnx
				cd device-tree-xlnx
				git fetch && git fetch --tags
				git checkout ${VER_DT}
				cd ${DIR_RPOJECT}

				cd qemu
				git clone git://github.com/Xilinx/qemu.git
				cd qemu
				git submodule update --init dtc
				./configure --target-list="aarch64-softmmu,microblazeel-softmmu" --enable-fdt --disable-kvm --disable-xen
				make
				cd ${DIR_RPOJECT}

		elif [ $1 == "-compile" ]
			then	
				# Create build directory
				if [ ! -d build ]
				then	
					mkdir build
				fi

				# Create the bif file
				if [ -e boot/${ZYBO_BIF} ]
				then
					echo -e ${Red}"Zybo.bif exist! Skip generating..."${Reset}
				else
					echo -e ${Yellow}"Create bif file..."${Reset}
					echo "image : {" >> boot/${ZYBO_BIF}
					echo "        [bootloader]${DIR_RPOJECT}/vivado/$PROJECTNAME/software/${BOOTLOADER}/Debug/${BOOTLOADER}.elf" >> boot/${ZYBO_BIF}
					echo "	${DIR_RPOJECT}/vivado/${PROJECTNAME}/hardware/${DESIGNNAME}_wrapper.bit" >> boot/${ZYBO_BIF}
					echo "	${DIR_RPOJECT}/build/u-boot.elf" >> boot/${ZYBO_BIF}
					echo "}" >> boot/${ZYBO_BIF}
				fi

				# Run the scrips
				echo -e ${Yellow}"Compile u-boot..."${Reset}
				u-boot/CompileUBoot.sh
				echo -e ${Yellow}"Compile Kernel..."${Reset}
				kernel/CompileKernel.sh
				echo -e ${Yellow}"Generate boot file..."${Reset}
				boot/CompileBoot.sh

		elif [ $1 == "-qemu" ]
			then
				echo -e ${Yellow}"Run qemu..."${Reset}
				echo -e ${Yellow}"Use Ctrl-A and then X to exit"${Reset}
				${DIR_RPOJECT}/qemu/StartQemu.sh

		elif [ $1 == "-devicetree" ]
			then

				echo -e ${Yellow}"Generate device tree..."${Reset}}
				cp ${DIR_RPOJECT}/devicetree/* ${DIR_RPOJECT}/build
				${DIR_RPOJECT}/kernel/linux-xlnx/scripts/dtc/dtc -I dts -O dtb -o ${DIR_RPOJECT}/build/devicetree.dtb ${DIR_RPOJECT}/build/${DEVICETREE}.dts

		elif [ $1 == "-kernel" ]
			then
				echo -e ${Yellow}"Compile Linux kernel..."${Reset}
				kernel/CompileKernel.sh
		elif [ $1 == "-example" ]
			then
				echo -e	 ${Red}"rootfs not up to date!"${Reset}
				echo -e	 ${Yellow}"Copy example project to SD-Card..."${Reset}
				cp example/* /media/${USER}/boot/

		elif [ $1 == "-ramdisk" ]
			then
				echo -e	 ${Yellow}"Copy RAM disk example..."${Reset}

				# Copy all files to SD card and remove bif file
				cp example/ramdisk/* /media/${USER}/boot/

				if [ -e /media/${USER}/boot/${ZYBO_BIF} ]
					then
						rm /media/${USER}/boot/${ZYBO_BIF}
				fi

		elif [ $1 == "-yocto" ]
			then
				echo -e ${Red}"Under construction!"${Reset}
			
				# Install Yocto
				echo -e ${Yellow}"Download yocto sources..."${Reset}
				mkdir yocto
				cd yocto
				git clone git://git.yoctoproject.org/poky
				cd poky
				git checkout ${YOCTO_BRANCH}
						
				echo -e ${Yellow}"Download meta xilinx..."${Reset}
				git clone https://github.com/Xilinx/meta-xilinx.git
				cd meta-xilinx
				git checkout ${YOCTO_BRANCH}

				cd ${DIR_RPOJECT}

		elif [ $1 == "-h" ]
			then
				echo
				echo -e	${Cyan} "########################################################################"${Reset}
				echo -e	${Cyan} "# 			${Red}Zybo Linux project script${Cyan}				#"${Reset}
				echo -e	${Cyan} "# Please visit 							#"${Reset}
				echo -e	${Cyan} "#   	-> ${Yellow}https://gitlab.com/Kampi/Zybo-Linux/wiki${Cyan} 			#"${Reset}
				echo -e	${Cyan} "# for additional information or write an e-mail to: 			#"${Reset}
				echo -e	${Cyan} "# 	-> ${Yellow}DanielKampert@kampis-elektroecke${Cyan}		            	#"${Reset}
				echo -e	${Cyan} "########################################################################"${Reset}
				echo

				echo -e ${Green}" Compile script for Zybo Linux"${Reset}
				echo -e ${Yellow}" Basic options:"${Reset}
				echo -e ${Yellow}"	-install	Prepare your system for linux compilation."${Reset}
				echo -e ${Yellow}"	-compile	Compile a new linux project for Zybo. Please use '-install' at least one time before."${Reset}
				echo -e ${Yellow}"	-qemu		Run a qemu session to emulate the ZYNQ device."${Reset}
				echo -e ${Yellow}"	-devicetree	Compile a new device tree."${Reset}
				echo -e ${Yellow}"	-kernel		Compile a new Linux kernel."${Reset}
				echo -e ${Yellow}"	-example	Copy a prebuild example to your SD-Card."${Reset}
				echo -e ${Yellow}"	-ramdisk	Copy a RAM disk example to your SD-Card."${Reset}
				echo -e ${Yellow}"	-yocto		Setup the yocto build environment."${Reset}
		else
				echo -e ${Green}"Use '${BASH_SOURCE[0]} -h' for help."${Reset}
		fi
	else
		echo -e ${Yellow} "Build environment ready to use."${Reset}
fi
