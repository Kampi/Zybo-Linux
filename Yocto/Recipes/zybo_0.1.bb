# Original recipe core-image-minimal 
SUMMARY = "A small image just capable of allowing a device to boot."

IMAGE_INSTALL = "packagegroup-core-boot ${ROOTFS_PKGMANAGE_BOOTSTRAP} ${CORE_IMAGE_EXTRA_INSTALL}"

IMAGE_LINGUAS = " "

LICENSE = "MIT"

inherit core-image

IMAGE_ROOTFS_SIZE ?= "8192"
IMAGE_ROOTFS_EXTRA_SPACE_append = "${@bb.utils.contains("DISTRO_FEATURES", "systemd", " + 4096", "" ,d)}"

SUMMARY = "Some receipe extras to for developing on the zybo."
DESCRIPTION = ""
LICENSE = "MIT"
IMAGE_INSTALL_append = " gdb gdb-dev openssh openssh-keygen openssh-scp openssh-ssh openssh-sshd "
