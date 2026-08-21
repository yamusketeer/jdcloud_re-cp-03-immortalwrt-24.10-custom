#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# Modify default IP
#sed -i 's/192.168.1.1/192.168.50.5/g' package/base-files/files/bin/config_generate

# Modify default theme
#sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# Modify hostname
#sed -i 's/OpenWrt/P3TERX-Router/g' package/base-files/files/bin/config_generate

# Force-remove default Chinese translation packages from feed definitions
find feeds/ -type f -name "Makefile" -exec sed -i 's/+luci-i18n-.*-zh-cn//g' {} +
find package/ -type f -name "Makefile" -exec sed -i 's/+luci-i18n-.*-zh-cn//g' {} +

# Prevent default Chinese settings from being selected
sed -i 's/CONFIG_LUCI_LANG_zh_Hans=y/# CONFIG_LUCI_LANG_zh_Hans is not set/' .config 2>/dev/null || true
sed -i 's/CONFIG_LUCI_LANG_zh-cn=y/# CONFIG_LUCI_LANG_zh-cn is not set/' .config 2>/dev/null || true

# Force disable ttyd and its LuCI interface
echo "CONFIG_PACKAGE_luci-app-ttyd=n" >> .config
echo "CONFIG_PACKAGE_ttyd=n" >> .config

# Force disable USB kernel modules and tools
cat << 'EOF' >> .config
CONFIG_PACKAGE_kmod-usb-core=n
CONFIG_PACKAGE_kmod-usb2=n
CONFIG_PACKAGE_kmod-usb3=n
CONFIG_PACKAGE_kmod-usb-ehci=n
CONFIG_PACKAGE_kmod-usb-xhci-hcd=n
CONFIG_PACKAGE_kmod-usb-xhci-mtk=n
CONFIG_PACKAGE_kmod-usb-net=n
CONFIG_PACKAGE_kmod-usb-net-cdc-ether=n
CONFIG_PACKAGE_kmod-usb-net-rndis=n
CONFIG_PACKAGE_kmod-usb-storage=n
CONFIG_PACKAGE_kmod-usb-storage-extras=n
CONFIG_PACKAGE_kmod-usb-storage-uas=n
CONFIG_PACKAGE_usbutils=n
CONFIG_PACKAGE_usbids=n
CONFIG_PACKAGE_automount=n
EOF
