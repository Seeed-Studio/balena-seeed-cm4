# Due to an issue on CM3 we use FAT32 for boot partition on RaspberryPi boards
# See:
# https://www.raspberrypi.org/documentation/hardware/computemodule/cm-emmc-flashing.md
BALENA_BOOT_FAT32 = "1"

IMAGE_FSTYPES:append:rpi = " balenaos-img"

# Customize balenaos-img
BALENA_IMAGE_BOOTLOADER:rpi = "rpi-bootfiles"
BALENA_BOOT_PARTITION_FILES:rpi = " \
    u-boot.bin:/${SDIMG_KERNELIMAGE} \
    boot.scr:/boot.scr \
    bootfiles:/ \
    "

BALENA_ESSENTIAL_BOOT_FILES:append:raspberrypi4-64 = " \
    cmdline.txt  \
    config.txt  \
    fixup4cd.dat  \
    fixup4.dat  \
    fixup4x.dat  \
    start4cd.elf \
    start4.elf \
    start4x.elf \
    ${SDIMG_KERNELIMAGE} \
    ${KERNEL_IMAGETYPE} \
    "
do_rootfs[vardeps] += "${@oe.utils.conditional('SIGN_API','','','BALENA_ESSENTIAL_BOOT_FILES',d)}"


python overlay_dtbs_handler () {
    # Add all the dtb files programatically
    for soc_fam in d.getVar('SOC_FAMILY', True).split(':'):
        if soc_fam == 'rpi':
            f = open(d.getVar('DEPLOY_DIR_IMAGE') + '/overlays.txt', "r")
            kernel_devicetree = f.read()
            f.close
            # Sanity check. Should be removed once the issue is confirmed to be fixed
            debug_missing_dtbo = 'gpio-poweroff.dtbo'
            if not debug_missing_dtbo in kernel_devicetree:
                bb.fatal('Sanity check: ' + debug_missing_dtbo + ' not found in overlay list! Overlays list contents:' + kernel_devicetree)
            d.setVar('KERNEL_DEVICETREE', kernel_devicetree)
            resin_boot_partition_files=make_dtb_boot_files(d)
            for entry in resin_boot_partition_files.split(' '):
                if ';' in entry:
                    source = entry.split(';')[0]
                    dest = entry.split(';')[1]
                else:
                    source = entry
                    dest = entry
                d.appendVar('BALENA_BOOT_PARTITION_FILES', ' ' + source.strip() + ':/' + dest.strip())
            break
}

do_resin_boot_dirgen_and_deploy[prefuncs] += "overlay_dtbs_handler"

IMAGE_INSTALL:append:rpi = " u-boot"

do_resin_boot_dirgen_and_deploy[depends] += "virtual/kernel:do_install"

BALENA_BOOT_PARTITION_FILES:append:raspberrypi4-64 = " \
    rpi-eeprom/pieeprom-latest-stable.bin:/pieeprom-latest-stable.bin \
    rpi-eeprom/vl805-latest-stable.bin:/vl805-latest-stable.bin \
"

BALENA_BOOT_PARTITION_FILES:append:raspberrypi4-64 = "${@oe.utils.conditional('SIGN_API','','',' rpi-eeprom/pieeprom-latest-stable.sig:/pieeprom-latest-stable.sig',d)}"
IMAGE_INSTALL:append:raspberrypi4-64 = " \
	seeed-linux-dtoverlays \
    rs485-control-de \
	iperf3 \
	i2c-tools \
    "
inherit image-sign-rpi

