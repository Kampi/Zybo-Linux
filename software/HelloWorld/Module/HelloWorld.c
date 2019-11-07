#include <linux/init.h>
#include <linux/kernel.h>
#include <linux/module.h>

MODULE_LICENSE("GPL");
MODULE_VERSION("1.0");
MODULE_AUTHOR("Daniel Kampert");
MODULE_DESCRIPTION("Kernel module example");

static int __init Init(void)
{
	printk("Hello from Zybo!\n");
	return 0;
}

static void __exit Exit(void)
{
	printk("Goodbye from Zybo!\n");
}

module_init(Init);
module_exit(Exit);
