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
