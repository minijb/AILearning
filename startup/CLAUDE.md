# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 概述

这是 Linux 个性化部署脚本仓库，用于在一台新 Linux 机器上自动完成开发环境配置。

## 运行方式

```bash
# 主入口（需要 root）
sudo ./setup.sh

# 单独运行某一步（传入 OS 类型：debian | fedora | arch | manjaro）
sudo bash scripts/03-dotfiles.sh debian

# 查看安装日志
cat logs/install.log
```

## 架构

```
setup.sh               # 主入口：检测 OS、交互确认、按序调用 scripts/
scripts/
  01-system.sh         # 系统基础配置（apt/dnf/pacman 更新 + 基础工具）
  02-packages.sh       # 软件包安装（开发工具、常用应用）
  03-dotfiles.sh       # dotfiles 部署（本地优先，否则从 DOTFILES_REPO 克隆）
  04-devtools.sh       # 开发工具配置（starship、oh-my-zsh、Docker、pip/npm 换源）
  05-desktop.sh        # 桌面环境配置（字体、目录结构、Git 全局配置）
  06-post.sh           # 收尾（缓存清理、生成安装报告）
config/                # 配置文件（留空，可按需添加 packages.conf 等）
dotfiles/              # dotfiles 源目录（由 scripts/03-dotfiles.sh 使用）
logs/                  # 安装日志和报告
```

## OS 检测逻辑

`detect_os()` 将多发行版映射为统一标识：
- `ubuntu/debian/pop` → `debian`
- `fedora/rhel/centos` → `fedora`
- `arch` → `arch`
- `manjaro` → `manjaro`
- `opensuse*` → `suse`

各步骤脚本通过 `$1` 接收此标识，用 `case` 分发不同包管理器的安装命令。

## 网络代理

`scripts/00-proxy.sh` 提供共享代理配置，各脚本 source 后使用。

**交互逻辑：**
- WSL：自动获取宿主机 IP（`/etc/resolv.conf` 中的 nameserver），仅询问端口
- 非 WSL：询问 IP 和端口

**代理变量：** `http_proxy` / `https_proxy` / `HTTP_PROXY` / `HTTPS_PROXY`（由 `setup.sh` export 到子进程）

**子脚本使用方式：**
```bash
source "$(dirname "$0")/00-proxy.sh"
configure_proxy "skip"      # 幂等，不重复弹窗
# 已有 $http_proxy 等变量，curl/git/npm 等自动继承
```

## 环境变量

| 变量 | 说明 |
|------|------|
| `DOTFILES_REPO` | dotfiles Git 仓库地址（用于克隆） |
| `DOTFILES_DIR` | dotfiles 目标目录，默认 `$HOME/dotfiles` |
| `GIT_NAME` | Git 全局用户名 |
| `GIT_EMAIL` | Git 全局邮箱 |

## 注意事项

- 脚本使用 `set -euo pipefail`，任何命令失败都会导致退出
- 步骤脚本失败后不会中断，而是记录警告后继续执行下一项
- `scripts/03-dotfiles.sh` 优先使用本地 `dotfiles/` 目录，仅在该目录为空时克隆 `DOTFILES_REPO`
- Docker 用户组修改需重新登录 shell 才生效
