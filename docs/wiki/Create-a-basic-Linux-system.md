# Create a basic Linux system

The following guide will help you install Linux on the ZYBO from Digilent.

## System prerequisite

Before you start, you have to run the `Project.sh` script to install all the required packages and prepare your system.

```bash
$ sudo chmod +x Project.sh
$ source Project.sh -install
```

If you install all packages before simply run

```bash
$ source Project.sh
```

to configure the build environment of your host PC.

## Create system design

### Using the Tcl script

1. Launch Vivado
2. Open the Tcl Console and navigate to the Tcl directory in `vivado` -> `project`.
3. Use `source SimpleLinux.tcl` in Tcl Console

### From scratch

1. Launch Vivado and create a new project.
2. Choose the `Zybo` or the `xc7z010clg400-1` as part.
3. Create a new block design with a [Processing System](https://www.xilinx.com/support/documentation/ip_documentation/processing_system7/v5_5/pg082-processing-system7.pdf). Use `Run Block Automation` for assistance.

![CreateBasicLinux(1)](img/CreateBasicLinux(1).png)

4. Optional: Use the `Zybo.xml` file inside the `docs` directory to configure the Processing System.
5. Add additional hardware.
6. Create the HDL Wrapper.
7. Generate a bitstream.
8. Export that bitstream.

## Build the device tree

1. Open Vitis.
2. Go to `Xilinx` -> `Repositories`, add the device tree folder to `Local Repositories` and close it with `Apply and Close`.
3. Go to `Xilinx` -> `Generate Device Tree` and add the path of the hardware (XSA) file as input and the `build` output directory.
4. Click `generate` to build the device tree.

> You can add additional device tree sources by copy them into the `devicetree` folder of the project directory. The build script will automatically copy them into the right directory.

## Create the First-stage boot loader

1. Open Vitis.
2. Go to `File` -> `New` -> `Application Project...` and create a new project with the title `FSBL`. Click `Next`.
3. Chose the window `Create a new platform from hardwar (XSA)` and add the exported bitstream. Clock `Next`.
4. Remove the tick from `Create boot components` and click `Next`.
5. Select `Zynq FSBL` and click `Finish`.

> Keep care of `#include` commands in the generated device tree files. You have to replace them with `/include/` (probably an issue by the Xilinx device tree generator).

## Build the boot files

Go to the base directory and run the build script with the `-compile` option

```bash
$ source Project.sh -compile
```

The script creates

- BOOT.bin
- uImage
- devicetree.dtb

## Booting up Linux

If the script finished successful and all files got generated, copy them into the `boot` partition of your [prepared](https://gitlab.com/Kampi/Zybo-Linux/wikis/Prepare-SD-Card) SD card.

```bash
$ cp build/BOOT.bin <SD-Card>/boot/BOOT.bin
$ cp build/devicetree.dtb <SD-Card>/boot/devicetree.dtb
$ cp build/uImage <SD-Card>/boot/uImage
```

Now copy the root filesystem to the SD card

```bash
$ tar -xvzf rootfs/Core-Image.tar.gz -C <SD-Card>/root/
```

You also can use the `uEnv.txt` file to configure u-boot

```bash
$ cp build/uEnv.txt <SD-Card>/boot/uEnv.txt
```

Place the jumper for the boot option on the ZYBO at the left position to enable the booting from SD card and power up your ZYBO. Your Linux should boot now!
