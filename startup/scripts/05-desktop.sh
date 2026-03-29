#!/usr/bin/env bash
#================================================================
# 步骤 5: 桌面环境配置
#================================================================
set -euo pipefail

TARGET_OS="$1"

log_info() { echo -e "${BLUE}[INFO]${NC}  $1"; }
log_ok()   { echo -e "${GREEN}[OK]${NC}    $1"; }

# ── 字体安装 ────────────────────────────────────
install_fonts() {
    local font_dir="$HOME/.local/share/fonts"
    mkdir -p "$font_dir"

    # 下载 JetBrains Mono（常用等宽字体）
    local jbmono="$font_dir/JetBrainsMono.zip"
    if [ ! -d "$font_dir/JetBrainsMono" ]; then
        log_info "安装 JetBrains Mono 字体..."
        curl -fsSL "https://github.com/JetBrains/JetBrainsMono/releases/latest/download/JetBrainsMono.zip" \
            -o "$jbmono"
        unzip -q -o "$jbmono" -d "$font_dir"
        rm -f "$jbmono"
        fc-cache -f > /dev/null 2>&1
        log_ok "JetBrains Mono 安装完成"
    fi
}

install_fonts

# ── 创建常用目录结构 ────────────────────────────
log_info "创建目录结构..."
mkdir -p "$HOME"/{Projects,Downloads,Documents,Videos,Pictures,Screenshots}

# ── Git 全局配置 ───────────────────────────────
if command -v git &>/dev/null; then
    GIT_NAME="${GIT_NAME:-}"
    GIT_EMAIL="${GIT_EMAIL:-}"
    if [ -n "$GIT_NAME" ] && [ -n "$GIT_EMAIL" ]; then
        git config --global user.name  "$GIT_NAME"
        git config --global user.email "$GIT_EMAIL"
        log_ok "Git 全局配置完成: $GIT_NAME <$GIT_EMAIL>"
    else
        log_info "跳过 Git 全局配置（未设置 GIT_NAME/GIT_EMAIL）"
    fi
fi

log_info "桌面环境配置完成"
