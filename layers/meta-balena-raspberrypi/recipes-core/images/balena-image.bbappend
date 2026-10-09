include balena-image.inc

# Machine-specific dependencies for seeed-recomputer-r2x
do_rootfs[depends] += "${@oe.utils.conditional('MACHINE','seeed-recomputer-r2x',' virtual/balena-bootloader:do_deploy','',d)}"
do_image_balenaos_img[depends] += "${@oe.utils.conditional('MACHINE','seeed-recomputer-r2x',' virtual/balena-bootloader:do_deploy','',d)}"

# Machine-specific dependencies for seeed-recomputer-r22
do_rootfs[depends] += "${@oe.utils.conditional('MACHINE','seeed-recomputer-r22',' virtual/balena-bootloader:do_deploy','',d)}"
do_image_balenaos_img[depends] += "${@oe.utils.conditional('MACHINE','seeed-recomputer-r22',' virtual/balena-bootloader:do_deploy','',d)}"

# wrynose-era rootfs binaries are larger than the kirkstone-era cap
IMAGE_ROOTFS_MAXSIZE = "786432"
# r100x additionally stages the kernel bundle in resin-boot (the 1-bootfiles
# update hook syncs it to the boot partition on OS updates)
IMAGE_ROOTFS_MAXSIZE:seeed-recomputer-r100x = "917504"
IMAGE_ROOTFS_MAXSIZE:seeed-recomputer-r110x = "917504"
IMAGE_ROOTFS_MAXSIZE:seeed-reterminal = "917504"
# hostapp ext4 is sized from ROOTFS_SIZE but must also hold the docker
# image layers; wrynose-era content overflows the computed size
IMAGE_ROOTFS_EXTRA_SPACE = "262144"
