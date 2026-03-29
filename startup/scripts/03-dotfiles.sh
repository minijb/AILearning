#!/usr/bin/env bash
#================================================================
# 步骤 3: dotfiles 部署
#================================================================
set -euo pipefail

TARGET_OS="$1"
SOURCE_DIR="$(dirname "$0")/../dotfiles"
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"

log_info() { echo -e "${BLUE}[INFO]${NC}  $1"; }
log_ok()   { echo -e "${GREEN}[OK]${NC}    $1"; }

# ── 链接单个 dotfile ────────────────────────────
deploy() {
    local src="$1"; local dst="$2"
    if [ -f "$src" ]; then
        mkdir -p "$(dirname "$dst")"
        cp -f "$src" "$dst"
        log_ok "已部署: $dst"
    fi
}

# ── 优先使用本地 dotfiles 目录 ──────────────────
if [ -d "$SOURCE_DIR" ] && [ "$(ls -A "$SOURCE_DIR")" ]; then
    log_info "检测到本地 dotfiles，部署中..."
    deploy "$SOURCE_DIR/.zshrc"        "$HOME/.zshrc"
    deploy "$SOURCE_DIR/.vimrc"        "$HOME/.vimrc"
    deploy "$SOURCE_DIR/.tmux.conf"    "$HOME/.tmux.conf"
    deploy "$SOURCE_DIR/.gitconfig"     "$HOME/.gitconfig"
    deploy "$SOURCE_DIR/.gitignore"     "$HOME/.gitignore"

    # 配置目录
    for cfg_dir in starship alacritty i3 sxhkd; do
        if [ -d "$SOURCE_DIR/.config/$cfg_dir" ]; then
            mkdir -p "$HOME/.config/$cfg_dir"
            cp -rf "$SOURCE_DIR/.config/$cfg_dir/"* "$HOME/.config/$cfg_dir/"
            log_ok "已部署: ~/.config/$cfg_dir"
        fi
    done

# ── 否则从 Git 克隆 ─────────────────────────────
elif [ -n "${DOTFILES_REPO:-}" ]; then
    log_info "克隆 dotfiles 仓库..."
    git clone --depth 1 "$DOTFILES_REPO" "$DOTFILES_DIR"
    cd "$DOTFILES_DIR"
    log_ok "dotfiles 已克隆到 $DOTFILES_DIR"
    log_info "请手动运行安装脚本"
else
    log_info "未找到 dotfiles，跳过"
fi

# ── 切换默认 Shell ──────────────────────────────
if command -v zsh &>/dev/null && [ -f "$HOME/.zshrc" ]; then
    if [ "$SHELL" != "$(command -v zsh)" ]; then
        log_info "切换默认 shell 为 zsh..."
        chsh -s "$(command -v zsh)" 2>/dev/null || \
            log_info "请手动运行: chsh -s $(command -v zsh)"
    fi
fi

log_info "dotfiles 部署完成"
