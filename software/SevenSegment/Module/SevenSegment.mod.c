#include <linux/module.h>
#include <linux/vermagic.h>
#include <linux/compiler.h>

MODULE_INFO(vermagic, VERMAGIC_STRING);
MODULE_INFO(name, KBUILD_MODNAME);

__visible struct module __this_module
__attribute__((section(".gnu.linkonce.this_module"))) = {
	.name = KBUILD_MODNAME,
	.init = init_module,
#ifdef CONFIG_MODULE_UNLOAD
	.exit = cleanup_module,
#endif
	.arch = MODULE_ARCH_INIT,
};

static const struct modversion_info ____versions[]
__used
__attribute__((section("__versions"))) = {
	{ 0x64cd2ee2, __VMLINUX_SYMBOL_STR(module_layout) },
	{ 0xeb127095, __VMLINUX_SYMBOL_STR(platform_driver_unregister) },
	{ 0xd9ff87c, __VMLINUX_SYMBOL_STR(__platform_driver_register) },
	{ 0x822137e2, __VMLINUX_SYMBOL_STR(arm_heavy_mb) },
	{ 0xfa2a45e, __VMLINUX_SYMBOL_STR(__memzero) },
	{ 0x28cc25db, __VMLINUX_SYMBOL_STR(arm_copy_from_user) },
	{ 0x2196324, __VMLINUX_SYMBOL_STR(__aeabi_idiv) },
	{ 0xff178f6, __VMLINUX_SYMBOL_STR(__aeabi_idivmod) },
	{ 0x6ae5b6e8, __VMLINUX_SYMBOL_STR(device_create) },
	{ 0x4e251c31, __VMLINUX_SYMBOL_STR(kobject_put) },
	{ 0x27e1a049, __VMLINUX_SYMBOL_STR(printk) },
	{ 0x8044ba6a, __VMLINUX_SYMBOL_STR(__class_create) },
	{ 0xa3fefda0, __VMLINUX_SYMBOL_STR(cdev_add) },
	{ 0xb6b4d317, __VMLINUX_SYMBOL_STR(cdev_alloc) },
	{ 0x29537c9e, __VMLINUX_SYMBOL_STR(alloc_chrdev_region) },
	{ 0xd213c847, __VMLINUX_SYMBOL_STR(dev_err) },
	{ 0xfac44fb2, __VMLINUX_SYMBOL_STR(of_iomap) },
	{ 0x9416e1d8, __VMLINUX_SYMBOL_STR(__request_region) },
	{ 0xdeec0ec9, __VMLINUX_SYMBOL_STR(of_address_to_resource) },
	{ 0x460ffa5d, __VMLINUX_SYMBOL_STR(_dev_info) },
	{ 0xefd6cf06, __VMLINUX_SYMBOL_STR(__aeabi_unwind_cpp_pr0) },
	{ 0x85f74b00, __VMLINUX_SYMBOL_STR(iomem_resource) },
	{ 0x2ab3cc9d, __VMLINUX_SYMBOL_STR(__release_region) },
	{ 0xedc03953, __VMLINUX_SYMBOL_STR(iounmap) },
	{ 0x7485e15e, __VMLINUX_SYMBOL_STR(unregister_chrdev_region) },
	{ 0x38faf0a7, __VMLINUX_SYMBOL_STR(cdev_del) },
	{ 0x8b972ecd, __VMLINUX_SYMBOL_STR(class_destroy) },
	{ 0x6a67508d, __VMLINUX_SYMBOL_STR(device_destroy) },
};

static const char __module_depends[]
__used
__attribute__((section(".modinfo"))) =
"depends=";

MODULE_ALIAS("of:N*T*Cxlnx,AXI-Segment-1.1");
MODULE_ALIAS("of:N*T*Cxlnx,AXI-Segment-1.1C*");

MODULE_INFO(srcversion, "8F2101D4C8DCDF33FF76643");
