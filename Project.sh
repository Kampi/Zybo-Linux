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
export VER_VIVADO=2018.2
export VER_KERNEL=xlnx_rebase_v4.14_2018.3
export VER_UBOOT=xilinx-v2017.4
export VER_DT=xilinx-v2018.3
export YOCTO_BRANCH=morty
export TARGET_MACHINE=zedboard-zynq7

export BOOTLOADER=FSBL
export DESIGNNAME=ProcessingSystem
export PROJECTNAME=ZyboLinux
export DEVICETREE=Bootargs
export ZYBO_BIF=Zybo.bif

export ROOTFS_QEMU=arm_ramdisk.image.gz

export PATH_VIVADO=/opt/Xilinx
export PATH_COMPILER=SDK/sysroots/x86_64-pokysdk-linux/usr/bin/arm-poky-linux-gnueabi/arm-poky-linux-gnueabi
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
export KDIR=${DIR_RPOJECT}/Kernel/linux-xlnx
export CROSS_COMPILE=${DIR_RPOJECT}/${PATH_COMPILER}-
export SYSROOT=${DIR_RPOJECT}/SDK/sysroots/cortexa9hf-neon-poky-linux-gnueabi

# Add u-boot to path
export PATH=${PATH}:${DIR_RPOJECT}/u-boot/u-boot-xlnx/tools

# Source vivado settings
bash -c "source ${PATH_VIVADO}/Vivado/${VER_VIVADO}/settings64.sh"

if [ $# -eq 1 ] 
	then
		if [ $1 == "-install" ]
			then
				echo -e ${Yellow}"Install packages..."${Reset}
				sudo apt-get update
				sudo apt-get -y install make git-core openssh-server git autoconf automake libtool python-pip gawk chrpath texinfo python3-pip tree
				# Uncomment if it doesn work				
				#sudo apt-get -y install linux-source linux-kernel-headers kernel-package
				sudo apt-get -y install u-boot-tools device-tree-compiler build-essential ncurses-dev
				sudo apt-get -y install libncursesw5 libncurses5 libncursesw5-dev libncursesw5-dbg libncurses5-dbg libncurses5-dev libncurses5:i386
				sudo apt-get -y install libsdl1.2-dev lib32z1 lib32ncurses5 libssl-dev libgtk2.0-0:i386 libxtst6:i386 gtk2-engines-murrine:i386 lib32stdc++6 libxt6:i386 
				sudo apt-get -y install libdbus-glib-1-2:i386 libasound2:i386 libstdc++6:i386 libglib2.0-dev libgcrypt20-dev libpixman-1-dev zlib1g-dev
				sudo apt-get -y install libgmp3-dev libmpfr-dev libx11-6 libx11-dev libmpc-dev zlibc

				# Install GCC 6
				sudo apt-get -y install software-properties-common
				sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test
				sudo apt-get update
				sudo apt-get -y install gcc-6 g++-6
				sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-6 60 --slave /usr/bin/g++ g++ /usr/bin/g++-6

				echo -e ${Yellow}"Install python packages..."${Reset}
				python3 -m pip install --user django==1.8.7

				# Add run permissions to the scrips
				sudo chmod +x Kernel/CompileKernel.sh
				sudo chmod +x u-boot/CompileUBoot.sh
				sudo chmod +x Boot/CompileBoot.sh
				sudo chmod +x Qemu/StartQemu.sh

				# Get the sources
				echo -e ${Yellow}"Fetch xilinx sources from git..."${Reset}
				cd Kernel
				git clone https://github.com/Xilinx/linux-xlnx.git
				git fetch && git fetch --tags
				git checkout ${VER_KERNEL}
				cd ${DIR_RPOJECT}

				cd u-boot
				git clone https://github.com/Xilinx/u-boot-xlnx.git
				cd u-boot-xlnx
				git fetch && git fetch --tags
				git checkout ${VER_UBOOT}
				cd ${DIR_RPOJECT}

				cd DeviceTree
				git clone https://github.com/Xilinx/device-tree-xlnx
				cd device-tree-xlnx
				git fetch && git fetch --tags
				git checkout ${VER_DT}
				cd ${DIR_RPOJECT}

				cd Qemu
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
				if [ -e Boot/${ZYBO_BIF} ]
				then
					echo -e ${Red}"Zybo.bif exist! Skip generating..."${Reset}
				else
					echo -e ${Yellow}"Create bif file..."${Reset}
					echo "image : {" >> Boot/${ZYBO_BIF}
					echo "        [bootloader]${DIR_RPOJECT}/Vivado/$PROJECTNAME/${PROJECTNAME}.sdk/${BOOTLOADER}/Debug/${BOOTLOADER}.elf" >> Boot/${ZYBO_BIF}
					echo "	${DIR_RPOJECT}/Vivado/${PROJECTNAME}/${PROJECTNAME}.sdk/${DESIGNNAME}_wrapper_hw_platform_0/${DESIGNNAME}_wrapper.bit" >> Boot/${ZYBO_BIF}
					echo "	${DIR_RPOJECT}/build/u-boot.elf" >> Boot/${ZYBO_BIF}
					echo "}" >> Boot/${ZYBO_BIF}
				fi

				# Run the scrips
				echo -e ${Yellow}"Compile u-boot..."${Reset}
				u-boot/CompileUBoot.sh
				echo -e ${Yellow}"Compile Kernel..."${Reset}
				Kernel/CompileKernel.sh
				echo -e ${Yellow}"Generate boot file..."${Reset}
				Boot/CompileBoot.sh

		elif [ $1 == "-qemu" ]
			then
				echo -e ${Yellow}"Run qemu..."${Reset}
				echo -e ${Yellow}"Use Ctrl-A and then X to exit"${Reset}
				${DIR_RPOJECT}/Qemu/StartQemu.sh

		elif [ $1 == "-devicetree" ]
			then

				echo -e ${Yellow}"Generate device tree..."${Reset}}
				${DIR_RPOJECT}/Kernel/linux-xlnx/scripts/dtc/dtc -I dts -O dtb -o ${DIR_RPOJECT}/build/devicetree.dtb ${DIR_RPOJECT}/Vivado/${PROJECTNAME}/${PROJECTNAME}.sdk/device_tree_bsp_0/${DEVICETREE}.dts
		elif [ $1 == "-kernel" ]
			then
				echo -e ${Yellow}"Compile Kernel..."${Reset}
				Kernel/CompileKernel.sh
		elif [ $1 == "-example" ]
			then
				echo -e	 ${Red}"rootfs not up to date!"${Reset}
				echo -e	 ${Yellow}"Copy example project to SD-Card..."${Reset}
				cp Example/boot/* /media/${USER}/boot/
				cp -R Example/root/* /media/${USER}/root/

		elif [ $1 == "-ramdisk" ]
			then
				echo -e	 ${Yellow}"Copy ram disk example..."${Reset}

				# Copy all files to sd-card and remove bif file
				cp Example/ramdisk/* /media/${USER}/boot/

				if [ -e /media/${USER}/boot/${ZYBO_BIF} ]
					then
					rm /media/${USER}/boot/${ZYBO_BIF}
				fi

		elif [ $1 == "-yocto" ]
			then
				echo -e ${Red}"Under construction!"${Reset}
			
				# Install Yocto
				echo -e ${Yellow}"Download yocto sources..."${Reset}
				mkdir Yocto
				cd Yocto
				git clone git://git.yoctoproject.org/poky
				cd poky
				git checkout ${YOCTO_BRANCH}
						
				echo -e ${Yellow}"Download meta xilinx..."${Reset}
				git clone https://github.com/Xilinx/meta-xilinx.git
				cd meta-xilinx
				git checkout ${YOCTO_BRANCH}

				pip install --user -r ${DIR_RPOJECT}Yocto/poky/bitbake/toaster-requirements.txt 


				cd ${DIR_RPOJECT}

		elif [ $1 == "-h" ]
			then
				echo
				echo -e	${Cyan} "########################################################################"${Reset}
				echo -e	${Cyan} "# 			${Red}Zybo Linux project script${Cyan}				#"${Reset}
				echo -e	${Cyan} "# Please visit 							#"${Reset}
				echo -e	${Cyan} "#   	-> ${Yellow}https://github.com/Kampi/Zybo-Linux/wiki${Cyan} 			#"${Reset}
				echo -e	${Cyan} "# for additional information, or write an e-mail to: 			#"${Reset}
				echo -e	${Cyan} "# 	-> ${Yellow}DanielKampert@kampis-elektroecke${Cyan}		            	#"${Reset}
				echo -e	${Cyan} "########################################################################"${Reset}
				echo

				echo -e ${Green}"Compile script for Zybo Linux"${Reset}
				echo -e ${Yellow}"Basic options:"${Reset}
				echo -e ${Yellow}"	-install	Prepare your system for linux compilation."${Reset}
				echo -e ${Yellow}"	-compile	Compile a new linux project for Zybo. Please use '-install' at least one time before."${Reset}
				echo -e ${Yellow}"	-qemu		Run a qemu session to emulate the ZYNQ device."${Reset}
				echo -e ${Yellow}"	-devicetree	Compile a new device tree."${Reset}
				echo -e ${Yellow}"	-kernel		Compile a new linux kernel."${Reset}
				echo -e ${Yellow}"	-example	Copy a prebuild example to your SD-Card."${Reset}
				echo -e ${Yellow}"	-ramdisk	Copy a ram disk example to your SD-Card."${Reset}
				echo -e ${Yellow}"	-yocto		Setup the yocto build environment."${Reset}
		else
				echo -e ${Green}"Use '${BASH_SOURCE[0]} -h' for help."${Reset}
		fi
	else
		echo -e ${Yellow}"Build environment ready to use."${Reset}
fi
