/*
 * SevenSegment.c
 *
 *  Copyright (C) Daniel Kampert, 2018
 *	Website: www.kampis-elektroecke.de

  GNU GENERAL PUBLIC LICENSE:
  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program. If not, see <http://www.gnu.org/licenses/>.

  Errors and commissions should be reported to DanielKampert@kampis-elektroecke.de
 */

/** @file SevenSegment.c
 *  @brief This program implements a simple driver for the digilent seven segment display PMOD.
 *
 *  @author Daniel Kampert
 *  @bug No known bugs
 */

#include <linux/fs.h>
#include <linux/io.h>
#include <linux/init.h>
#include <linux/cdev.h>
#include <asm/uaccess.h>
#include <linux/device.h>
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/uaccess.h>
#include <linux/of_device.h>
#include <linux/of_address.h>
#include <linux/platform_device.h>

#define DEVICENAME		"Display"
#define SEGMENTMINOR	0

static ssize_t DriverWrite(struct file* Instanz, const char* Buffer, size_t ToWrite, loff_t* Offset);
static int DriverOpen(struct inode* geraete_datei, struct file* instanz);
static int DriverClose(struct inode* geraete_datei, struct file* instanz);
static int zynq_platform_device_probe(struct platform_device* pdev);
static int zynq_platform_device_remove(struct platform_device* pdev);

static dev_t DevNumber;
static struct cdev* DriverObject;
static struct class* DriverClass;
static struct device* SegmentDev;
static struct resource Ressource;
static void __iomem* Map;

static const struct of_device_id of_zynq_platform_device_match[] = {
	{ 
		.compatible = "xlnx,AXI-Segment-1.1"
	},
	{},
};

static struct platform_driver zynq_plaform_driver = {
	.probe      = zynq_platform_device_probe,
	.remove     = zynq_platform_device_remove,
	.driver     = {
		.name   = "SSD PMOD driver",
		.of_match_table = of_zynq_platform_device_match,
		.owner = THIS_MODULE,
	},
};

static struct file_operations FOPS = {
	.owner = THIS_MODULE,
	.write = DriverWrite,
	.open = DriverOpen, 
	.release = DriverClose,
};

MODULE_LICENSE("GPL");
MODULE_VERSION("1.0");
MODULE_AUTHOR("Daniel Kampert");
MODULE_DESCRIPTION("Kernel module for digilent seven segment PMOD");
MODULE_DEVICE_TABLE(of, of_zynq_platform_device_match);

int DriverOpen(struct inode* geraete_datei, struct file* instanz)
{
	dev_info(SegmentDev, "'DriverOpen' called...\n");

	return 0;
}

int DriverClose(struct inode* geraete_datei, struct file* instanz)
{
	dev_info(SegmentDev, "'DriverClose' called...\n");

	return 0;
}

ssize_t DriverWrite(struct file* Instanz, const char* Buffer, size_t ToWrite, loff_t* Offset)
{
	int Shift = 0x00;
	int Value = 0x00;
	int BCD = 0x00;
	ssize_t NotCopied;

	NotCopied = copy_from_user(&Value, Buffer, ToWrite);

   	while(Value > 0x00)
	{
      		BCD |= (Value % 0x0A) << (Shift++ << 0x02);
      		Value /= 0x0A;
   	}

	iowrite32(BCD, Map);

	return ToWrite - NotCopied;
}

int zynq_platform_device_probe(struct platform_device* pdev)
{
	if(of_address_to_resource(pdev->dev.of_node, 0, &Ressource))
	{
		dev_err(&pdev->dev, "of_address_to_resource");
		return -EINVAL;
	}

	if(!request_mem_region(Ressource.start, resource_size(&Ressource), "xlnx,AXI-Segment-1.1"))
	{
		dev_err(&pdev->dev, "request_mem_region");
		return -EINVAL;
	}

	Map = of_iomap(pdev->dev.of_node, 0);
	if(!Map) 
	{
		dev_err(&pdev->dev, "of_iomap");
		return -EINVAL;
	}

	dev_info(&pdev->dev, "res.start = %llx resource_size = %llx\n", (unsigned long long)Ressource.start, (unsigned long long)resource_size(&Ressource));

	if (alloc_chrdev_region(&DevNumber, SEGMENTMINOR, 1, DEVICENAME) < 0)
	{
		return -EIO;
	}

	DriverObject = cdev_alloc();
	if(DriverObject == NULL)
	{
		goto Jump_Free_DeviceNumber;
	}

	DriverObject->owner = THIS_MODULE;
	DriverObject->ops = &FOPS;

	if(cdev_add(DriverObject, DevNumber, 1))
	{
		goto Jump_Free_cdev;
	}

	DriverClass = class_create(THIS_MODULE, DEVICENAME);
	if(IS_ERR(DriverClass)) 
	{
		pr_err("No udev support!\n");
		goto Jump_Free_cdev;
	}

	SegmentDev = device_create(DriverClass, NULL, DevNumber, NULL, "%s", DEVICENAME);
	if(IS_ERR(SegmentDev)) 
	{
		pr_err("'device_create' failed!\n");
		goto Jump_Free_class;
	}

	return 0;

	Jump_Free_class:
		class_destroy(DriverClass);
	Jump_Free_cdev:
		kobject_put(&DriverObject->kobj);
	Jump_Free_DeviceNumber:
		unregister_chrdev_region(DevNumber, 1);
		return -EIO;
}

int zynq_platform_device_remove(struct platform_device* pdev)
{
	device_destroy(DriverClass, DevNumber);
	class_destroy(DriverClass);
	cdev_del(DriverObject);
	unregister_chrdev_region(DevNumber, 1);

	iounmap(Map);
	release_mem_region(Ressource.start, resource_size(&Ressource));

	return 0;
}

static int __init Init(void)
{
	printk("Load SSD PMOD driver...\n");

	return platform_driver_register(&zynq_plaform_driver);
}

static void __exit Exit(void)
{
	printk("Unload SSD PMOD driver...\n");

	platform_driver_unregister(&zynq_plaform_driver);
}

module_init(Init);
module_exit(Exit);

