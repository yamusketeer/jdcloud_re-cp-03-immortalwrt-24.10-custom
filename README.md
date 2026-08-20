# JDCloud RE-CP-03 ImmortalWrt 24.10 固件构建项目

[![Build Status](https://github.com/Eivs/jdcloud_re-cp-03-immortalwrt-24.10/actions/workflows/builder.yml/badge.svg)](https://github.com/Eivs/jdcloud_re-cp-03-immortalwrt-24.10/actions/workflows/builder.yml)

A fork from Eivs/jdcloud_re-cp-03-immortalwrt-24.10

本项目基于 [P3TERX/Actions-OpenWrt](https://github.com/P3TERX/Actions-OpenWrt) 框架，专为 **JDCloud RE-CP-03** 路由器构建 ImmortalWrt 24.10 固件。

## 🎯 目标设备

- **设备型号**: JDCloud RE-CP-03 (京东云无线宝)
- **芯片平台**: MediaTek MT7986 (Filogic)
- **架构**: aarch64_cortex-a53
- **WiFi芯片**: MT7976 (AX6000)

## ✨ 主要特性

### 🔧 系统特性

- **基于**: ImmortalWrt 24.10 (Linux 6.6 内核)
- **源码仓库**: [padavanonly/immortalwrt-mt798x-6.6](https://github.com/padavanonly/immortalwrt-mt798x-6.6)
- **根文件系统**: 2048MB 分区大小
- **支持**: WiFi 6 (802.11ax)、双频并发、硬件加速

### 📦 预装软件包

#### 🌐 网络工具

- **科学上网**: <s>Passwall</s>
- **VPN服务**: WireGuard, <s>OpenVPN Server, IPSec VPN, ZeroTier</s>
- **网络管理**:
  - DDNS (支持阿里云、Cloudflare、DNSPOD等多家服务商)
  - <s>UPnP, Wake on LAN (含增强版)
  - SQM QoS 流量控制</s>
  - 带宽限速 (eqos-mtk)
  - 网络加速 (TurboACC-MTK)
  - <s>ARP绑定
- **网络监控**:
  - Netdata 实时监控
  - 流量统计 (nlbwmon)
  - 系统统计 (statistics)</s>
- **网络测试**: iperf3, tcping, tcpdump, mtr
- **安全工具**:
  - AdGuard Home 广告拦截
  - <s>BanIP 封禁工具
  - VLMCSD KMS服务器</s>

#### 🐳 容器化支持

- **Docker**: 完整的 Docker 环境
- **容器管理**: Dockerman Web界面
- **容器运行时**: containerd, runc, <s>podman</s>
- **容器编排**: docker-compose

#### 💾 存储与文件系统

- **文件系统**: ext4, f2fs, BTRFS 支持
- **存储工具**:
  - 自动挂载
  <s>- 分区管理 (diskman)</s>
  - USB存储支持
  - 多种分区工具 (fdisk, cfdisk, parted, gdisk)
- **文件系统工具**:
  - e2fsprogs (ext4工具)
  - f2fs-tools (F2FS工具)
  - btrfs-progs (BTRFS工具)

#### 🎨 Web界面主题

<s>- Argon 主题</s>
- Bootstrap Mod 主题
- Design 主题

#### 🛠️ 系统工具

- **终端**: <s>ttyd Web终端,</s> zsh shell
- **编辑器**: vim-fuller, nano
- **监控**:
  - htop 进程监控
  - 系统性能监控
  - 日志查看器
- **管理工具**:
  - <s>命令执行工具</s>
  - 定时任务管理
  - 高级重启管理
- **网络**:
  - <s>以太网唤醒</s>
  - 网络时间同步 (NTP)
- **其他**:
  - <s>Lucky 网络工具箱</s>
  - MT WiFi配置工具

## 🚀 使用方法

### 自动构建 (推荐)

1. **Fork 本仓库**到你的 GitHub 账户

2. **启动构建**:

   - 进入 Actions 页面
   - 选择 "jdcloud_re-cp-03-immortalwrt-24.10" 工作流
   - 点击 "Run workflow"
   - 配置构建参数:
     - `LAN IP Address`: 设置路由器登录IP (默认: 192.168.1.1)
     - `Not build luci-app-dockerman`: 是否跳过Docker管理器编译

3. **下载固件**:
   - 构建完成后在 Actions Artifacts 中下载
   - 或在 Releases 页面下载发布版本

### 本地构建

```bash
# 克隆源码
git clone https://github.com/padavanonly/immortalwrt-mt798x-6.6 -b openwrt-24.10-6.6 openwrt
cd openwrt

# 复制配置文件
cp ../feeds.conf.default ./feeds.conf.default
cp ../immortalwrt.config ./.config

# 执行自定义脚本
chmod +x ../diy-part1.sh ../diy-part2.sh
../diy-part1.sh

# 更新和安装 feeds
./scripts/feeds update -a
./scripts/feeds install -a

# 执行第二阶段自定义脚本
../diy-part2.sh

# 配置和编译
make defconfig
make download -j$(nproc)
make -j$(nproc) || make -j1 V=s
```

## 📁 项目文件说明

### 配置文件

- **`immortalwrt.config`**: 主要的构建配置文件，定义了所有要编译的软件包和内核选项
- **`feeds.conf.default`**: 软件源配置，定义了软件包的获取来源

### 自定义脚本

- **`diy-part1.sh`**: 第一阶段自定义脚本 (feeds 更新前执行)
  - 用于添加额外的软件源
  - 当前为模板，可根据需要取消注释相关行
- **`diy-part2.sh`**: 第二阶段自定义脚本 (feeds 更新后执行)
  - 用于修改默认配置
  - 支持修改默认IP、主题、主机名等

### GitHub Actions

- **`.github/workflows/builder.yml`**: 主构建工作流
- **`.github/workflows/delete-older-releases.yml`**: 清理旧版本工作流

## ⚙️ 自定义配置

### 修改默认设置

编辑 `diy-part2.sh` 文件，取消注释并修改相应行：

```bash
# 修改默认IP地址
sed -i 's/192.168.1.1/192.168.50.5/g' package/base-files/files/bin/config_generate

# 修改默认主题
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# 修改主机名
sed -i 's/OpenWrt/P3TERX-Router/g' package/base-files/files/bin/config_generate
```

### 添加软件源

编辑 `diy-part1.sh` 文件，添加额外的软件源：

```bash
# 添加 helloworld 软件源
echo 'src-git helloworld https://github.com/fw876/helloworld' >>feeds.conf.default

# 添加 passwall 软件源
echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall' >>feeds.conf.default
```

## 📋 固件信息

- **默认登录地址**: http://192.168.1.1 (可在构建时自定义)
- **默认用户名**: root
- **默认密码**: 无 (首次登录后请修改)
- **SSH**: 默认启用，端口 22

## ⚠️ 注意事项

1. **刷机风险**: 刷机有风险，请确保了解救砖方法
2. **备份**: 刷机前请备份原厂固件和配置
3. **兼容性**: 本固件专为 JDCloud RE-CP-03 设计，请勿用于其他设备
4. **更新**: 建议定期关注项目更新，获取最新功能和安全修复

## 🙏 致谢

- [P3TERX](https://github.com/P3TERX) - Actions-OpenWrt 框架
- [padavanonly](https://github.com/padavanonly) - ImmortalWrt MT798x 适配
- [ImmortalWrt](https://github.com/immortalwrt) - ImmortalWrt 项目
- [OpenWrt](https://openwrt.org/) - OpenWrt 项目

## 📄 许可证

本项目基于 [MIT License](LICENSE) 开源协议。

---

**免责声明**: 本项目仅供学习交流使用，刷机有风险，后果自负。
