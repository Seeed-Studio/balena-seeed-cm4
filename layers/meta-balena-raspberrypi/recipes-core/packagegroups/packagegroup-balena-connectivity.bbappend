# The Seeed boards' WiFi/BT lives on the CM4 module and uses the
# rpidistro cyfmac / bluez-firmware packages. None of the generic
# connectivity firmwares match hardware these devices can have:
# the iwlwifi set is Intel (12 packages appended by meta-balena's
# wrynose layer), ralink/realtek/ti cover USB dongles the products
# never ship. Drop them from the image to keep it as lean as the
# standalone BSP images.
#
# wireless-regdb-static is kept: the CM4 radio needs the regulatory
# database for full channel coverage.
#
# Scoped per seeed machine so the other machines this family layer
# defines (unipi, revpi, nebra, fincm3, ...) keep their firmware set.
SEEED_UNUSED_CONNECTIVITY_FIRMWARES = " \
    linux-firmware-ath9k \
    linux-firmware-mt7601u \
    linux-firmware-ralink \
    linux-firmware-rtl8192cu \
    linux-firmware-rtl8192su \
    linux-firmware-rtl8723 \
    linux-firmware-rtl8723b-bt \
    linux-firmware-bcm43143 \
    linux-firmware-iwlwifi-135-6 \
    linux-firmware-iwlwifi-3160 \
    linux-firmware-iwlwifi-6000-4 \
    linux-firmware-iwlwifi-6000g2a-6 \
    linux-firmware-iwlwifi-6000g2b-6 \
    linux-firmware-iwlwifi-6050-5 \
    linux-firmware-iwlwifi-7260 \
    linux-firmware-iwlwifi-7265 \
    linux-firmware-iwlwifi-7265d \
    linux-firmware-iwlwifi-8000c \
    linux-firmware-iwlwifi-8265 \
    linux-firmware-iwlwifi-9260 \
    linux-firmware-rtl8188eu \
    linux-firmware-wl12xx \
    linux-firmware-wl18xx \
    "
CONNECTIVITY_FIRMWARES:remove:seeed-recomputer-r100x = " ${SEEED_UNUSED_CONNECTIVITY_FIRMWARES} "
CONNECTIVITY_FIRMWARES:remove:seeed-recomputer-r110x = " ${SEEED_UNUSED_CONNECTIVITY_FIRMWARES} "
CONNECTIVITY_FIRMWARES:remove:seeed-recomputer-r2x = " ${SEEED_UNUSED_CONNECTIVITY_FIRMWARES} "
CONNECTIVITY_FIRMWARES:remove:seeed-recomputer-r22 = " ${SEEED_UNUSED_CONNECTIVITY_FIRMWARES} "
CONNECTIVITY_FIRMWARES:remove:seeed-rerouter-cm4 = " ${SEEED_UNUSED_CONNECTIVITY_FIRMWARES} "
CONNECTIVITY_FIRMWARES:remove:seeed-reterminal = " ${SEEED_UNUSED_CONNECTIVITY_FIRMWARES} "
CONNECTIVITY_FIRMWARES:remove:seeed-reterminal-DM = " ${SEEED_UNUSED_CONNECTIVITY_FIRMWARES} "
