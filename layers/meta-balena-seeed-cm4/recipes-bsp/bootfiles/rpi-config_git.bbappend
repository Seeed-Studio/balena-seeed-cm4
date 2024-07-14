
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

do_deploy:append:fincm3() {
	# Use the Balena Fin device tree overlay
	echo "dtoverlay=balena-fin" >> ${DEPLOYDIR}/bootfiles/config.txt
}

do_deploy:append:npe-x500-m3() {
  # Use the NPE X500 M3 device tree overlay
  echo "dtoverlay=npe-x500-m3" >> ${DEPLOYDIR}/bootfiles/config.txt
}

do_deploy:append:revpi-connect() {
	# Use the RevPi Connect device tree overlay
	echo "dtoverlay=revpi-connect" >> ${DEPLOYDIR}/bootfiles/config.txt
}

do_deploy:append:revpi-connect-s() {
	# Use the RevPi Connect device tree overlay
	echo "dtoverlay=revpi-connect" >> ${DEPLOYDIR}/bootfiles/config.txt
        echo "dtoverlay=dwc2" >> ${DEPLOYDIR}/bootfiles/config.txt
        echo "dr_mode=host" >> ${DEPLOYDIR}/bootfiles/config.txt
}

# the RevPi Connect 4 features a HAT EEPROM and the overlay name to be used is available the EEPROM so no need for a dtoverlay statement for that
do_deploy:append:revpi-connect-4() {
	echo "dtoverlay=dwc2,dr_mode=host" >> ${DEPLOYDIR}/bootfiles/config.txt
}

do_deploy:append:raspberrypi3-unipi-neuron() {
	# Use the dt overlays required by the UniPi Neuron family of boards
	echo "dtoverlay=neuronee" >> ${DEPLOYDIR}/bootfiles/config.txt
	echo "dtoverlay=i2c-rtc,mcp7941x" >> ${DEPLOYDIR}/bootfiles/config.txt
	echo "dtoverlay=neuron-spi-new" >> ${DEPLOYDIR}/bootfiles/config.txt
}

do_deploy:append:raspberrypi4-superhub() {
	# Disable spi0
	sed -i '/dtparam=spi=on/ c\dtparam=spi=off' ${DEPLOYDIR}/bootfiles/config.txt

	# Use the dt overlays required by the raspberrypi4 superhub boards
	echo "dtparam=ant2" >> ${DEPLOYDIR}/bootfiles/config.txt
	echo "dtoverlay=dwc2,dr_mode=host" >> ${DEPLOYDIR}/bootfiles/config.txt
	echo "dtoverlay=i2c-rtc,pcf8563" >> ${DEPLOYDIR}/bootfiles/config.txt
	echo "dtoverlay=pca953x,pca9555" >> ${DEPLOYDIR}/bootfiles/config.txt
	echo "dtoverlay=pca953x,pca9555,addr=0x21" >> ${DEPLOYDIR}/bootfiles/config.txt
	echo "dtoverlay=pca953x,pca9555,addr=0x22" >> ${DEPLOYDIR}/bootfiles/config.txt
	echo "dtoverlay=uart3" >> ${DEPLOYDIR}/bootfiles/config.txt
	echo "dtoverlay=uart5" >> ${DEPLOYDIR}/bootfiles/config.txt
	echo "dtoverlay=ed-gpio-wdt" >> ${DEPLOYDIR}/bootfiles/config.txt
	echo "dtoverlay=ed-spi1-1cs" >> ${DEPLOYDIR}/bootfiles/config.txt
	echo "dtoverlay=ed-infineon-tpm" >> ${DEPLOYDIR}/bootfiles/config.txt
	echo "dtoverlay=ed-sdhost" >> ${DEPLOYDIR}/bootfiles/config.txt
}

do_deploy:append:raspberrypi4-unipi-neuron() {
	# Use the dt overlays required by the UniPi Neuron family of boards
	echo "dtoverlay=neuronee" >> ${DEPLOYDIR}/bootfiles/config.txt
	echo "dtoverlay=i2c-rtc,mcp7941x" >> ${DEPLOYDIR}/bootfiles/config.txt
	echo "dtoverlay=neuron-spi-new" >> ${DEPLOYDIR}/bootfiles/config.txt
}

do_deploy:append:revpi-core-3() {
    cat >> ${DEPLOYDIR}/bootfiles/config.txt << EOF

# serial port needs to be kept clean for RS485 communication
avoid_warnings=1

dtoverlay=revpi-core

EOF
    # prevent u-boot logging on uart
    sed -i 's/enable_uart=1//' ${DEPLOYDIR}/bootfiles/config.txt
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
        grep -q "^dtoverlay=reComputer-R100x,uart2$" $CONFIG || echo "dtoverlay=reComputer-R100x,uart2" >> $CONFIG
    else
        bbdebug 1 "No target device tree specified, check your MACHINE config"
    fi
}
