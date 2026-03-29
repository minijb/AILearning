#!/usr/bin/env bash
#================================================================
# 步骤 6: 收尾工作 & 生成报告
#================================================================
set -euo pipefail

TARGET_OS="$1"
LOG_DIR="$(dirname "$0")/../logs"

log_info() { echo -e "${BLUE}[INFO]${NC}  $1"; }
log_ok()   { echo -e "${GREEN}[OK]${NC}    $1"; }

REPORT_FILE="$LOG_DIR/install-report.txt"

# ── 清理缓存 ───────────────────────────────────
log_info "清理系统缓存..."
case "$TARGET_OS" in
    debian)
        apt-get autoremove -y -qq 2>/dev/null || true
        apt-get autoclean -qq 2>/dev/null || true
        ;;
    fedora)
        dnf clean all -q 2>/dev/null || true
        ;;
    arch|manjaro)
        pacman -Sc --noconfirm -q 2>/dev/null || true
        ;;
esac

# ── 生成安装报告 ────────────────────────────────
log_info "生成安装报告..."
{
    echo "========================================"
    echo "  Linux 部署安装报告"
    echo "========================================"
    echo "日期:       $(date '+%Y-%m-%d %H:%M:%S')"
    echo "主机名:     $(hostname)"
    echo "系统:       $(uname -a)"
    echo ""
    echo "========================================"
    echo "  已安装的关键命令"
    echo "========================================"
    for cmd in git curl wget vim zsh tmux python3 nodejs npm \
               docker code firefox htop tree jq starship; do
        if command -v "$cmd" &>/dev/null; then
            ver=$("$cmd" --version 2>/dev/null | head -1 || echo "installed")
            printf "  %-12s %s\n" "$cmd" "$ver"
        fi
    done
    echo ""
    echo "========================================"
    echo "  服务状态"
    echo "========================================"
    for svc in docker ssh; do
        if systemctl list-unit-files | grep -q "^$svc"; then
            status=$(systemctl is-active "$svc" 2>/dev/null || echo "inactive")
            printf "  %-12s %s\n" "$svc" "$status"
        fi
    done
    echo ""
    echo "========================================"
    echo "  下一步"
    echo "========================================"
    echo "  1. 重新登录以使 shell 切换和 docker 组生效"
    echo "  2. 如使用 i3/sway，请重启桌面会话"
    echo "  3. 检查 ~/.config 下的配置文件"
    echo "  4. 运行 zsh 或 source ~/.zshrc 加载新配置"
    echo ""
} > "$REPORT_FILE"

cat "$REPORT_FILE"
log_ok "收尾工作完成"
