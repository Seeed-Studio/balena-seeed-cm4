
do_deploy:append() {
    # Enable i2c by default
    echo "dtparam=i2c_arm=on" >>${DEPLOYDIR}/bootfiles/config.txt
    # Enable SPI by default
    echo "dtparam=spi=on" >>${DEPLOYDIR}/bootfiles/config.txt
    # Disable firmware splash by default
    echo "disable_splash=1" >>${DEPLOYDIR}/bootfiles/config.txt
    # Disable firmware warnings showing in non-debug images
    if ! ${@bb.utils.contains('DISTRO_FEATURES','osdev-image','true','false',d)}; then
        echo "avoid_warnings=1" >>${DEPLOYDIR}/bootfiles/config.txt
    fi
    # Enable audio (loads snd_bcm2835)
    echo "dtparam=audio=on" >> ${DEPLOYDIR}/bootfiles/config.txt
}


# On Raspberry Pi 3 and Raspberry Pi Zero WiFi, serial ttyS0 console is only
# usable if ENABLE_UART = 1. On OS development images, we want serial console
# available, production devices can enable it with a configuration variable.
ENABLE_UART ?= "${@bb.utils.contains('DISTRO_FEATURES','osdev-image','1','0',d)}"

do_deploy:append() {
    CONFIG=${DEPLOYDIR}/${BOOTFILES_DIR_NAME}/config.txt
    grep -q "^dtoverlay=vc4-kms-v3d-pi4$" $CONFIG || echo "dtoverlay=vc4-kms-v3d-pi4" >> $CONFIG
    grep -q "^dtoverlay=dwc2,dr_mode=host$" $CONFIG || echo "dtoverlay=dwc2,dr_mode=host" >> $CONFIG
    grep -q "^enable_uart=1$" $CONFIG || echo "enable_uart=1" >> $CONFIG
    grep -q "^dtparam=spi=on$" $CONFIG || echo "dtparam=spi=on" >> $CONFIG
    
    if ${@bb.utils.contains('MACHINE', 'seeed-reterminal-plus', 'true', 'false', d)} \
        || ${@bb.utils.contains('MACHINE', 'seeed-reterminal-plus-mender', 'true', 'false', d)}; then
        grep -q "^dtoverlay=reTerminal-plus$" $CONFIG || echo "dtoverlay=reTerminal-plus" >> $CONFIG
        grep -q "^dtparam=i2c_vc=on$" $CONFIG || echo "dtparam=i2c_vc=on" >> $CONFIG
        grep -q "^dtoverlay=i2c3,pins_4_5$" $CONFIG || echo "dtoverlay=i2c3,pins_4_5" >> $CONFIG
    elif ${@bb.utils.contains('MACHINE', 'seeed-reterminal', 'true', 'false', d)} \
        || ${@bb.utils.contains('MACHINE', 'seeed-reterminal-mender', 'true', 'false', d)} \
        || ${@bb.utils.contains('MACHINE', 'dual-gbe-cm4', 'true', 'false', d)} \
        || ${@bb.utils.contains('MACHINE', 'dual-gbe-cm4-mender', 'true', 'false', d)}; then
        grep -q "^dtoverlay=i2c3,pins_4_5$" $CONFIG || echo "dtoverlay=i2c3,pins_4_5" >> $CONFIG
        grep -q "^dtoverlay=reTerminal,tp_rotate=1$" $CONFIG || echo "dtoverlay=reTerminal,tp_rotate=1" >> $CONFIG
    elif ${@bb.utils.contains('MACHINE', 'seeed-recomputer-r100x-mender', 'true', 'false', d)} \
        || ${@bb.utils.contains('MACHINE', 'seeed-recomputer-r100x', 'true', 'false', d)}; then
        grep -q "^dtparam=i2c_arm=on$" $CONFIG || echo "dtparam=i2c_arm=on" >> $CONFIG
        grep -q "^dtoverlay=i2c1,pins_44_45$" $CONFIG || echo "dtoverlay=i2c1,pins_44_45" >> $CONFIG
        grep -q "^dtoverlay=i2c3,pins_2_3$" $CONFIG || echo "dtoverlay=i2c3,pins_2_3" >> $CONFIG
        grep -q "^dtoverlay=i2c6,pins_22_23$" $CONFIG || echo "dtoverlay=i2c6,pins_22_23" >> $CONFIG
        grep -q "^dtoverlay=audremap,pins_18_19$" $CONFIG || echo "dtoverlay=audremap,pins_18_19" >> $CONFIG
        grep -q "^dtoverlay=uart2,pins_0_1$" $CONFIG || echo "dtoverlay=uart2,pins_0_1" >> $CONFIG
        grep -q "^dtoverlay=uart3,pins_4_5$" $CONFIG || echo "dtoverlay=uart3,pins_4_5" >> $CONFIG
        grep -q "^dtoverlay=uart5,pins_12_13$" $CONFIG || echo "dtoverlay=uart5,pins_12_13" >> $CONFIG
        grep -q "^dtoverlay=reComputer-R100x,uart2$" $CONFIG || echo "dtoverlay=reComputer-R100x,uart2" >> $CONFIG
    else
        bbdebug 1 "No target device tree specified, check your MACHINE config"
    fi
}
