#!/usr/bin/env bash
#================================================================
# 步骤 4: 开发工具配置
#================================================================
set -euo pipefail

TARGET_OS="$1"

log_info() { echo -e "${BLUE}[INFO]${NC}  $1"; }
log_ok()   { echo -e "${GREEN}[OK]${NC}    $1"; }

# ── 安装 starship 终端提示符 ───────────────────
if ! command -v starship &>/dev/null; then
    log_info "安装 starship..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y
    log_ok "starship 安装完成"
else
    log_ok "starship 已安装"
fi

# ── 安装 oh-my-zsh（可选）──────────────────────
if command -v zsh &>/dev/null && [ ! -d "$HOME/.oh-my-zsh" ]; then
    log_info "安装 oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    log_ok "oh-my-zsh 安装完成"
fi

# ── Docker 配置 ─────────────────────────────────
if command -v docker &>/dev/null; then
    log_info "配置 Docker..."
    if [ -S /var/run/docker.sock ]; then
        if ! groups "$USER" | grep -q docker; then
            usermod -aG docker "$USER" 2>/dev/null || true
            log_info "已将 $USER 加入 docker 用户组（需重新登录生效）"
        fi
    fi
fi

# ── pip 换源 ────────────────────────────────────
if command -v pip3 &>/dev/null; then
    PIP_CONFIG="$HOME/.config/pip/pip.conf"
    mkdir -p "$(dirname "$PIP_CONFIG")"
    if [ ! -f "$PIP_CONFIG" ]; then
        log_info "配置 pip 清华源..."
        cat > "$PIP_CONFIG" << 'EOF'
[global]
timeout = 10
index-url = https://pypi.tuna.tsinghua.edu.cn/simple
EOF
        log_ok "pip 换源完成"
    fi
fi

# ── npm 换源 ────────────────────────────────────
if command -v npm &>/dev/null; then
    npm config set registry https://registry.npmmirror.com
fi

log_info "开发工具配置完成"
