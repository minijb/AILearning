#!/usr/bin/env bash
#================================================================
# 步骤 2: 软件包安装
#================================================================
set -euo pipefail

TARGET_OS="$1"
CONF_FILE="$(dirname "$0")/../config/packages.conf"
LOG_DIR="$(dirname "$0")/../logs"

log_info() { echo -e "${BLUE}[INFO]${NC}  $1"; }

install_packages() {
    local os_type="$1"; shift
    local pkgs=("$@")

    case "$os_type" in
        debian)
            apt-get install -y -qq "${pkgs[@]}" > /dev/null 2>&1 || \
            apt-get install -y "${pkgs[@]}"
            ;;
        fedora)
            dnf install -y -q "${pkgs[@]}" > /dev/null 2>&1 || \
            dnf install -y "${pkgs[@]}"
            ;;
        arch|manjaro)
            pacman -Sy --noconfirm --needed "${pkgs[@]}" > /dev/null 2>&1 || \
            pacman -Sy --noconfirm "${pkgs[@]}"
            ;;
    esac
}

log_info "开始安装软件包..."

# ── 开发工具 ────────────────────────────────────
install_packages "$TARGET_OS" \
    python3 python3-pip python3-venv \
    nodejs npm \
    clang llvm lldb cmake

# ── 常用应用 ────────────────────────────────────
install_packages "$TARGET_OS" \
    filezilla flameshot vlc

log_info "软件包安装完成"
