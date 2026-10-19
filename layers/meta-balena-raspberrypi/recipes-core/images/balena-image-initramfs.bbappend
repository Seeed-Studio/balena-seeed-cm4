PACKAGE_INSTALL:remove:revpi = "initramfs-module-migrate"

PACKAGE_INSTALL:remove = "initramfs-module-recovery"

# wrynose-era initramfs binaries are larger than the kirkstone-era cap
IMAGE_ROOTFS_MAXSIZE = "131072"
IMAGE_ROOTFS_MAXSIZE:raspberrypi4-64 = "131072"
IMAGE_ROOTFS_MAXSIZE:raspberrypi5 = "131072"
