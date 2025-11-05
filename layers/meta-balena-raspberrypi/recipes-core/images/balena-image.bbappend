include balena-image.inc

# Machine-specific dependencies for seeed-recomputer-r2x
do_rootfs[depends] += "${@oe.utils.conditional('MACHINE','seeed-recomputer-r2x',' virtual/balena-bootloader:do_deploy','',d)}"
do_image_balenaos_img[depends] += "${@oe.utils.conditional('MACHINE','seeed-recomputer-r2x',' virtual/balena-bootloader:do_deploy','',d)}"

# Machine-specific dependencies for seeed-recomputer-r22
do_rootfs[depends] += "${@oe.utils.conditional('MACHINE','seeed-recomputer-r22',' virtual/balena-bootloader:do_deploy','',d)}"
do_image_balenaos_img[depends] += "${@oe.utils.conditional('MACHINE','seeed-recomputer-r22',' virtual/balena-bootloader:do_deploy','',d)}"
