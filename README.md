# ZYBO-Linux

## Table of Contents

- [ZYBO-Linux](#zybo-linux)
  - [Table of Contents](#table-of-contents)
  - [About](#about)
  - [Supported Versions](#supported-versions)
  - [Project directory structure](#project-directory-structure)
  - [History](#history)
  - [Maintainer](#maintainer)

## About

> This project is already under development!

This is a private repository with a full Linux project for the [Digilent ZYBO board](https://store.digilentinc.com/zybo-zynq-7000-arm-fpga-soc-trainer-board/).
In this repository, you will find all the necessary files to compile and run a Linux on your ZYBO.

Please check the [wiki](https://gitlab.com/Kampi/ZYBO-Linux/wikis/home) or write an e-mail to <DanielKampert@kampis-elektroecke.de> if you need some more detailed information.

You can find additional IP cores in my [IP repository](https://gitlab.com/Kampi/IP-Catalog).

## Supported Versions

| **Software** 		| **Version** 			|
|-----------------------|-------------------------------|
| CentOS 		| 7.6 				|
| Linux kernel 		| xlnx_rebase_v4.14_2018.3 	|
| u-boot 		| xilinx-v2017.4 		|
| Device tree 		| xilinx-v2018.3 		|
| Vivado 		| 2019.2 			|

## Project directory structure

- build : Output directory for all generated files. The directory contains the following files after you run a new build:

    | **File**             	| **Description**		|
    |---------------------------|-------------------------------|
    | uImage             	| Compiled Linux kernel		|
    | devicetree.dtb     	| Compiled device tree         	|
    | BOOT.bin           	| Compiled bitstream and FSBL  	|
    | u-boot.elf         	| Compiled u-boot bootloader   	|
    | uEnv.txt 			| Settings for u-boot          	|

- boot : All files to generate the `BOOT.bin` file.
- docs : Documentation for the project.
- devicetree : Complete device tree for the hardware and Xilinx device tree Generator. Please take a look at [GitHub](https://github.com/Xilinx/device-tree-xlnx) for more information.
- kernel : Linux kernel from Xilinx. Please take a look at [GitHub](https://github.com/Xilinx/linux-xlnx) for more information.
- qemu : Qemu virtual machine with start script. Please take a look at [GitHub](https://github.com/Xilinx/qemu) for more information.
- rootfs : File systems for the ZYBO Linux.
- example : RAM disk example.
- sdk : SDK (including cross compiler) for the whole project.
- software : Some software examples.
- u-boot : `u-boot` from Xilinx. Please take a look at [GitHub](https://github.com/Xilinx/u-boot-xlnx) for more information.
- vivado : Vivado projects with hardware and software configurations.
- yocto : This directory contains additional files for using Yocto.
- Project.sh : Use this script to handle the project easily.

## History

| Version   	| Description                  			| Date       	|
|---------------|-----------------------------------------------|---------------|
| 1.0       	| First release                			| 13.06.2019 	|
| 2.0       	| Change supported host OS to CentOS and add Vitis support		| 11.04.2020 	|

## Maintainer

- [Daniel Kampert](mailto:DanielKampert@kampis-elektroecke.de)
