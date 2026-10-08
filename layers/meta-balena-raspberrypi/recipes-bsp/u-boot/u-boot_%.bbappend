# u-boot for balenaOS RPi devices is taken unmodified from OE-core
# (2026.01 on wrynose). History: this bbappend used to pin u-boot 2021.10
# (SRCREV/PV) to carry the 2022-era CM4 NVMe patch stack and the resin
# environment integration (env_resin.h + balena_check_crc32.c, which also
# relied on the common.h header removed in u-boot 2022.07).
# On CM4-based Seeed boards u-boot 2021.10 hangs immediately after the
# firmware loads it, and the resin env code no longer compiles against
# 2026.01, so both are dropped: the seeed-recomputer-r100x machine boots
# through the self-contained rpi-u-boot-scr boot.cmd.in (kernel loaded from
# the FAT boot partition) which needs no resin environment in u-boot.

# The boot partition file list expects extra_uEnv.txt in the deploy dir
# (previously created by resin-u-boot.bbclass). Ship it empty: the
# self-contained boot.cmd does not read u-boot env overrides.
do_deploy:append() {
    touch ${DEPLOYDIR}/extra_uEnv.txt
}
