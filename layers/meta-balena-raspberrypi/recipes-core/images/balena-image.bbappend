include balena-image.inc

# Machine-specific dependencies for seeed-recomputer-r2x
do_rootfs[depends] += "${@oe.utils.conditional('MACHINE','seeed-recomputer-r2x',' virtual/balena-bootloader:do_deploy','',d)}"
do_image_balenaos_img[depends] += "${@oe.utils.conditional('MACHINE','seeed-recomputer-r2x',' virtual/balena-bootloader:do_deploy','',d)}"

# Machine-specific dependencies for seeed-recomputer-r22
do_rootfs[depends] += "${@oe.utils.conditional('MACHINE','seeed-recomputer-r22',' virtual/balena-bootloader:do_deploy','',d)}"
do_image_balenaos_img[depends] += "${@oe.utils.conditional('MACHINE','seeed-recomputer-r22',' virtual/balena-bootloader:do_deploy','',d)}"

# The CM4-based seeed machines (machines defined by the meta-seeed-cm4
# submodule) stage device tree overlays from the seeed-linux-dtoverlays
# deploy dir into the boot partition, so the boot dir generation must run
# after that deploy.
do_resin_boot_dirgen_and_deploy[depends] += "${@'seeed-linux-dtoverlays:do_deploy' if d.getVar('MACHINE') in ('seeed-recomputer-r100x', 'seeed-recomputer-r110x', 'seeed-reterminal', 'seeed-reterminal-DM', 'seeed-rerouter-cm4') else ''}"

# wrynose-era rootfs binaries are larger than the kirkstone-era cap
IMAGE_ROOTFS_MAXSIZE = "786432"
# r100x additionally stages the kernel bundle in resin-boot (the 1-bootfiles
# update hook syncs it to the boot partition on OS updates)
IMAGE_ROOTFS_MAXSIZE:seeed-recomputer-r100x = "917504"
IMAGE_ROOTFS_MAXSIZE:seeed-recomputer-r110x = "917504"
IMAGE_ROOTFS_MAXSIZE:seeed-reterminal = "917504"
# The pi5-based boards size the rootfs at 655360 (IMAGE_ROOTFS_SIZE:raspberrypi5)
# plus the 262144 KiB wrynose EXTRA_SPACE, i.e. 917504 KiB, which trips the
# 786432 cap in do_image_docker otherwise
IMAGE_ROOTFS_MAXSIZE:seeed-recomputer-r2x = "917504"
IMAGE_ROOTFS_MAXSIZE:seeed-recomputer-r22 = "917504"
IMAGE_ROOTFS_MAXSIZE:seeed-reterminal-DM = "917504"
# hostapp ext4 is sized from ROOTFS_SIZE but must also hold the docker
# image layers; wrynose-era content overflows the computed size
IMAGE_ROOTFS_EXTRA_SPACE = "262144"

# Docker repository names must be all lowercase; the upstream command tags
# the image with ${IMAGE_NAME}, which embeds the machine name, and
# seeed-reterminal-DM carries uppercase letters:
#   invalid reference format: repository name
#   (library/balena-image-seeed-reterminal-DM-...) must be lowercase
# Lowercase the tag on import; the deployed ${BALENA_DOCKER_IMG} file name
# is unchanged, so mkfs.hostapp and the release assets keep their names.
IMAGE_CMD:docker () {
    docker_tag="$(echo ${IMAGE_NAME} | tr '[:upper:]' '[:lower:]'):latest"
    ${IMAGE_CMD_TAR} -cv -C ${IMAGE_ROOTFS} . | DOCKER_API_VERSION=${BALENA_API_VERSION} docker import - "$docker_tag"
    DOCKER_API_VERSION=${BALENA_API_VERSION} docker save -o "${BALENA_DOCKER_IMG}" "$docker_tag"
    DOCKER_API_VERSION=${BALENA_API_VERSION} docker rmi "$docker_tag"
}
