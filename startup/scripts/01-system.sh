#!/usr/bin/env bash
#================================================================
# 步骤 1: 系统基础配置
#================================================================
set -euo pipefail

TARGET_OS="$1"
LOG_DIR="$(dirname "$0")/../logs"

log() { echo -e "${2:-[INFO]}  $1"; }

case "$TARGET_OS" in
    debian)
        log_info "更新 apt 索引..."
        apt-get update -qq
        ;;
    fedora)
        log_info "检查系统更新..."
        dnf check-update || true
        ;;
    arch|manjaro)
        log_info "更新 pacman 数据库..."
        pacman -Sy --noconfirm
        ;;
esac

# 安装基础工具
log_info "安装基础工具..."
BASE_TOOLS="git curl wget vim zsh tmux htop tree unzip zip jq"

case "$TARGET_OS" in
    debian)
        apt-get install -y -qq $BASE_TOOLS build-essential > /dev/null 2>&1
        ;;
    fedora)
        dnf install -y -q $BASE_TOOLS > /dev/null 2>&1
        ;;
    arch|manjaro)
        pacman -Sy --noconfirm --needed $BASE_TOOLS > /dev/null 2>&1
        ;;
esac

log "基础工具安装完成" "[OK]"
