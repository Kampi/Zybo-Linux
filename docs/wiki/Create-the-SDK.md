# Create the SDK

Follow this guide to compile a new SDK (including cross compiler) for the Zybo. I use the [Yocto Project](https://www.yoctoproject.org/) to create the SDK for the Zybo.

## System prerequisite

At the beginning you have to source the project script with the `-yocto` option:

```bash
$ source Project.sh -yocto
```

The script creates all necessary folder and downloads the chosen branch for [poky](https://www.yoctoproject.org/software-item/poky/) and the meta-layer.

## Configure Yocto

Now you have to configure Yocto for the ZYBO. First source the Yocto build script to create the environment variables you need:

```bash
$ cd yocto/poky
$ source oe-init-build-env
```

Now add the Xilinx layer

```bash
$ bitbake-layers add-layer "${DIR_RPOJECT}/yocto/poky/meta-xilinx"
```

and add `zedboard-zynq7` as the target machine to `${DIR_RPOJECT}/yocto/poky/build/conf/local.conf`.

```bash
MACHINE ?= "zedboard-zynq7"
```

Save the changes and close the file.

## Compile and install the toolchain

Now run `bitbake meta-toolchain` to create the toolchain. The output should look like this

```bash
Parsing recipes: 100% |##########################################| Time: 0:00:51
Parsing of 880 .bb files complete (0 cached, 880 parsed). 1338 targets, 78 skipped, 0 masked, 0 errors.
NOTE: Resolving any missing task queue dependencies

Build Configuration:
BB_VERSION        = "1.32.0"
BUILD_SYS         = "x86_64-linux"
NATIVELSBSTRING   = "universal"
TARGET_SYS        = "arm-poky-linux-gnueabi"
MACHINE           = "zedboard-zynq7"
DISTRO            = "poky"
DISTRO_VERSION    = "2.2.4"
TUNE_FEATURES     = "arm armv7a vfp thumb neon       callconvention-hard       cortexa9"
TARGET_FPU        = "hard"
meta
meta-poky
meta-yocto-bsp    = "morty:e56be3cee517c5262486136dbd6d649b68c3a8b7"
meta-xilinx       = "morty:1ddfc0ba94f597822e619395fa0b35fb322e26af"
```

The whole procedure will take some time (~4 h on my PC). You will find a setup script at `../yocto/poky/build/tmp/deploy/sdk/` when the process has finished. Run this script:

```bash
$ ${DIR_RPOJECT}/yocto/poky/build/tmp/deploy/sdk/poky-glibc-x86_64-meta-toolchain-cortexa9hf-neon-toolchain-2.2.4.sh
Poky (Yocto Project Reference Distro) SDK installer version 2.2.4
=================================================================
Enter target directory for SDK (default: /opt/poky/2.2.4): 
```

Chose `${DIR_RPOJECT}/sdk` as the target directory. The SDK is ready to use now.

## Using the SDK

You have to source the `${DIR_RPOJECT}/sdk/environment-setup` file to setup all needed environment variables:

```bash
$ chmod +x environment-setup-cortexa9hf-neon-poky-linux-gnueabi
$ source ${DIR_RPOJECT}/sdk/environment-setup-cortexa9hf-neon-poky-linux-gnueabi
```

Now you can compile your code with one of the given compiler:

```bash
$ $CC <MyCode.c>
$ $CXX <MyCode.cpp>
$ $AS <MyCode.s>
```
