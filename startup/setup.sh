#!/usr/bin/env bash
#================================================================
# Linux 个性化部署脚本 — 主入口
# 支持: Ubuntu / Debian / Fedora / Arch / Manjaro
#================================================================
set -euo pipefail

# ── 配置区（按需修改）───────────────────────────────────────
DOTFILES_REPO="${DOTFILES_REPO:-}"          # 例: https://github.com/你的用户名/dotfiles
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
INSTALL_LOG_DIR="$(dirname "$0")/logs"

# ── 颜色 ─────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; NC='\033[0m'

# ── 日志函数 ──────────────────────────────────────────────
log_info()  { echo -e "${BLUE}[INFO]${NC}  $*"; }
log_ok()    { echo -e "${GREEN}[OK]${NC}    $*"; }
log_warn()  { echo -e "${YELLOW}[WARN]${NC}  $*"; }
log_err()   { echo -e "${RED}[ERROR]${NC} $*"; }

log() {
    local step="$1"; local msg="$2"
    mkdir -p "$INSTALL_LOG_DIR"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$step] $msg" >> "$INSTALL_LOG_DIR/install.log"
}

# ── 系统检测 ──────────────────────────────────────────────
detect_os() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        case "$ID" in
            ubuntu|debian|pop)        echo "debian" ;;
            fedora|rhel|centos)       echo "fedora" ;;
            arch)                     echo "arch"   ;;
            manjaro)                  echo "manjaro" ;;
            opensuse*)                echo "suse"   ;;
            *)                        echo "$ID"   ;;
        esac
    else
        log_err "无法识别操作系统，退出"
        exit 1
    fi
}

check_root() {
    if [ "$(id -u)" -ne 0 ]; then
        log_err "请使用 sudo 或以 root 用户运行此脚本"
        exit 1
    fi
}

# ── 执行步骤脚本 ──────────────────────────────────────────
run_step() {
    local script="$1"
    local script_path
    script_path="$(dirname "$0")/scripts/$script"

    if [ ! -f "$script_path" ]; then
        log_warn "脚本不存在: $script，跳过"
        return 0
    fi

    log "STEP" ">>> 执行 $script"
    chmod +x "$script_path"
    bash "$script_path" "$TARGET_OS" || {
        log_warn "步骤 $script 执行失败或部分失败，继续下一项"
    }
    log "STEP" "<<< 完成 $script"
}

# ── 代理配置 ───────────────────────────────────────────────
SCRIPT_DIR="$(dirname "$0")"
PROXY_SCRIPT="$SCRIPT_DIR/scripts/00-proxy.sh"

configure_proxy_interactive() {
    echo
    echo -n "是否配置网络代理? [y/N]: "
    read -r want_proxy
    if [ "$want_proxy" = "y" ] || [ "$want_proxy" = "Y" ]; then
        # shellcheck source=/dev/null
        source "$PROXY_SCRIPT"
        configure_proxy
        # 将代理变量 export 到子进程
        [ -n "${PROXY_URL:-}" ] && {
            export http_proxy="$PROXY_URL"
            export https_proxy="$PROXY_URL"
            export HTTP_PROXY="$PROXY_URL"
            export HTTPS_PROXY="$PROXY_URL"
            export no_proxy="localhost,127.0.0.1"
            export NO_PROXY="localhost,127.0.0.1"
        }
    else
        source "$PROXY_SCRIPT"
        configure_proxy "skip"
    fi
}

# ── 主流程 ─────────────────────────────────────────────────
main() {
    TARGET_OS="$(detect_os)"
    mkdir -p "$INSTALL_LOG_DIR"

    echo
    echo "================================================"
    echo "      Linux 个性化部署脚本"
    echo "      检测系统: $TARGET_OS ($(grep PRETTY_NAME /etc/os-release | cut -d'"' -f2))"
    echo "================================================"
    echo

    check_root

    # 交互确认
    echo -n "即将开始安装，是否继续? [y/N]: "
    read -r confirm
    if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
        log_info "已取消安装"
        exit 0
    fi
    echo

    # 代理配置（在步骤执行前）
    configure_proxy_interactive
    echo

    log_info "开始部署..."
    echo

    # 按顺序执行各步骤脚本
    run_step "01-system.sh"
    run_step "02-packages.sh"
    run_step "03-dotfiles.sh"
    run_step "04-devtools.sh"
    run_step "05-desktop.sh"
    run_step "06-post.sh"

    echo
    echo "================================================"
    log_ok "部署完成!"
    echo "  日志文件: $INSTALL_LOG_DIR/install.log"
    echo "  报告文件: $INSTALL_LOG_DIR/install-report.txt"
    echo "================================================"
}

main "$@"
