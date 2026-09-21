# meta-balena's pinned bullseye base image (balenalib/intel-nuc-debian:bullseye-20230328)
# started failing apt-get with 404s after Debian 11 LTS ended on 2026-08-31:
# the live mirrors delete superseded point releases while the index still
# advertises them. Mirror the fix from upstream meta-balena master
# (meta-balena#3938): fresh debian:bullseye-20260824 base and apt pointed at
# the snapshot.debian.org archive that matches it.
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
