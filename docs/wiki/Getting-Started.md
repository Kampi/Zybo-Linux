# Getting started

If you boot the Linux system from the examples, you will have the following interfaces to access the system:

- Serial port (115200 Baud)
- TCP/IP (DHCP enabled)

I recommend using [PuTTY](https://www.putty.org/) for headless using.

## Generate an SSH-Key for your Zybo

Use the following steps to install a user-specific ssh key on your ZYBO. You don´t have to use a passphrase anymore when using ssh, scp, etc. to access the ZYBO from your host pc.

1. Open a terminal on your host pc
2. Execute the following command to generate an ssh key for the current user

```bash
$ ssh-keygen -t rsa
```

3. Type in your passphrase
4. Copy the generated `id_rsa.pub` file to your ZYBO

```bash
$ scp ~/.ssh/id_rsa.pub root@<IP>:/home/root
```

5. Open a terminal on your ZYBO
6. Create a new `~/.ssh` folder for the user root

```bash
$ mkdir ~/.ssh
```

7. Copy the content of the ssh-key to that folder and remove the key file

```bash
$ cat id_rsa.pub >> ~/.ssh/authorized_keys
$ chmod 700 ~/.ssh/authorized_keys
$ rm id_rsa.pub
```

From now on you can use the `scp` command from your host without using a passphrase.

## Compile 'Hello-World' examples

The project folder contains all necessary files to build your own embedded Linux applications for your Zybo.

1. Change to the example directory and run `make`:

```bash
$ cd software/HelloWorld/Application
$ make
```

2. Copy the compiled application to your Zybo:

```bash
$ scp HelloWorld root@<IP>:/home/root`
```

3. Change to your Zybo and run the program

```bash
root@Zybo:/# /home/root/HelloWorld
Hello World from Zybo!
```

### Use Yocto to compile 'Hello-World' kernel module

You can use the Yocto environment to compile your own kernel modules. The `yocto` folder contains an example layer to show the concept.

1. Copy the layer to the `poky` directory

```bash
$ cp -r yocto/Recipes/meta-HelloWorld yocto/poky/
```

2. Initialize the Yocto environment and add the layer

```bash
$ cd yocto/poky
$ source source oe-init-build-env
$ bitbake-layers add-layer "${DIR_RPOJECT}/yocto/poky/meta-HelloWorld"
```

3. Run `bitbake` to compile the module. Don´t forget to [configure](https://gitlab.com/Kampi/Zybo-Linux/wikis/Create%20the%20SDK#configure-yocto) Yocto for the Zynq device before you start the job.

```bash
$ bitbake HelloWorld-mod
Loading cache: 100% |############################################| Time: 0:00:00
Loaded 1339 entries from dependency cache.
Parsing recipes: 100% |##########################################| Time: 0:00:00
Parsing of 881 .bb files complete (879 cached, 2 parsed). 1339 targets, 78 skipped, 0 masked, 0 errors.
NOTE: There are 1 recipes to be removed from sysroot zedboard-zynq7, removing...
NOTE: Resolving any missing task queue dependencies

Build Configuration:
BB_VERSION        = "1.32.0"
BUILD_SYS         = "x86_64-linux"
NATIVELSBSTRING   = "universal"
TARGET_SYS        = "arm-poky-linux-gnueabi"
MACHINE           = "zedboard-zynq7"
DISTRO            = "poky"
DISTRO_VERSION    = "2.2.4"
TUNE_FEATURES     = "arm armv7a vfp thumb neon callconvention-hard cortexa9"
TARGET_FPU        = "hard"
meta
meta-poky
meta-yocto-bsp    = "morty:e56be3cee517c5262486136dbd6d649b68c3a8b7"
meta-xilinx       = "morty:1ddfc0ba94f597822e619395fa0b35fb322e26af"
meta-HelloWorld   = "morty:e56be3cee517c5262486136dbd6d649b68c3a8b7"

Initialising tasks: 100% |#######################################| Time: 0:00:02
NOTE: Executing SetScene Tasks
NOTE: Executing RunQueue Tasks
NOTE: Tasks Summary: Attempted 481 tasks of which 467 didn't need to be rerun and all succeeded.
```

4. Transfer the module to the ZYBO

```bash
$ scp tmp/work/zedboard_zynq7-poky-linux-gnueabi/HelloWorld-mod/0.1-r0/sysroot-destdir/lib/modules/4.6.0-xilinx-v2016.3/extra/HelloWorld.ko root@<IP>:/home/root
```

5. Test the module

```bash
root@zybo-zynq7:~# ls
HelloWorld.ko
root@zybo-zynq7:~# insmod HelloWorld.ko
[   65.676993] Hello Zybo!
root@zybo-zynq7:~# rmmod HelloWorld
[  110.926972] Goodbye Zybo!
```

> You have to check if the kernel version for your Zybo is the same version as Yocto is using. Otherwise, the module doesn´t get loaded! You can avoid this if you compile the kernel with Yocto too. So the kernel and the module will use the same sources.
