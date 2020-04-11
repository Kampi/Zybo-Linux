# Prepare a SD card

Follow these instructions to create an SD card for your ZYBO Linux.

1. Insert the SD card and get the label (i. e. `sdb`)

2. Get the SD card size

```bash
$ sudo fdisk -l /dev/sdb
Disk /dev/sdb: 8068 MB, 8068792320 bytes
249 heads, 62 sectors/track, 1020 cylinders, total 15759360 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000
Disk /dev/sdb doesn't contain a valid partition table
```

3. Calculate the new cylinder size

```bash
cylinders = <size> / 8225280 = 980 with <size> = 8068792320
```

4. Start the `fdisk` tool

```bash
$ sudo fdisk /dev/sdb
```

5. Configure sectors

```bash
Command (m for help): x
Expert command (m for help): h
Number of heads (1-256, default 30): 255
Expert command (m for help): s
Number of sectors (1-63, default 29): 63
Expert command (m for help): c
Number of cylinders (1-1048576, default 2286): <cylinders>
Command (m for help): r
```

6. Create partitions

```bash
Command (m for help): n
Partition type:
 p primary (0 primary, 0 extended, 4 free)
 e extended
Select (default p): p
Partition number (1-4, default 1): 1
First sector (2048-15759359, default 2048):
Using default value 2048
Last sector, +sectors or +size{K,M,G} (2048-15759359, default 15759359): +200M
Command (m for help): n
Partition type:
 p primary (1 primary, 0 extended, 3 free)
 e extended
Select (default p): p
Partition number (1-4, default 2): 2
First sector (411648-15759359, default 411648):
Using default value 411648
Last sector, +sectors or +size{K,M,G} (411648-15759359, default 15759359):
Using default value 15759359
```

7. Set bootable flag

```bash
Command (m for help): a
Partition number (1-4): 1
Command (m for help): t
Partition number (1-4): 1
Hex code (type L to list codes): c
Changed system type of partition 1 to c (W95 FAT32 (LBA))
Command (m for help): t
Partition number (1-4): 2
Hex code (type L to list codes): 83
```

8. Write all changes

```bash
Command (m for help): w
The partition table has been altered!
```

9. Format the partitions

```bash
$ sudo mkfs.vfat -F 32 -n boot /dev/sdb1
$ sudo mkfs.ext4 -L root /dev/sdb2
```

Please see [Xilinx Wiki](http://www.wiki.xilinx.com/Prepare+Boot+Medium) for more information.
