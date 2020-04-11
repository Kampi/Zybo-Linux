# Home

Welcome to the **ZYBO-Linux** wiki!

This page contains information related to run Linux on the ZYNQ 7000 series platform.

Please write an e-mail to <DanielKampert@kampis-elektroecke.de> if you need some more detailed information.

## Run the example project

[Prepare](https://gitlab.com/Kampi/Zybo-Linux/wikis/Prepare-a-SD-Card) an SD card to run Linux on the ZYBO.

Navigate to `ZYBO-Linux` and run

```bash
$ sudo chmod +x Project.sh
$ source ./Project.sh -example
```

or

```bash
$ sudo chmod +x Project.sh
$ source ./Project.sh -ramdisk
```

Please check if you have write permissions for the `root` and `boot` partition of your SD card.

## Login

| **Login**	| root		|
|---------------|---------------|
| **Password** 	| 		|

## Maintainer

- [Daniel Kampert](mailto:DanielKampert@kampis-elektroecke.de)
