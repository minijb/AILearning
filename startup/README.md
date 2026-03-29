# Linux 个性化部署脚本

## 整体架构

```
startup/
├── setup.sh              # 主入口脚本
├── config/
│   ├── packages.conf     # 软件包列表（按用途分类）
│   ├── dotfiles.conf     # dotfiles 源目录配置
│   └── aur.conf          # AUR/第三方包配置
├── scripts/
│   ├── 01-system.sh       # 系统基础配置
│   ├── 02-packages.sh    # 软件包安装
│   ├── 03-dotfiles.sh    # dotfiles 部署
│   ├── 04-devtools.sh    # 开发工具配置
│   ├── 05-desktop.sh     # 桌面环境配置
│   └── 06-post.sh        # 收尾工作
└── logs/                 # 安装日志
```

## 各脚本功能说明

---

### 1. `setup.sh` — 主入口

```bash
#!/usr/bin/env bash
set -euo pipefail

# ── 配置区 ──────────────────────────────────────
DOTFILES_REPO="${DOTFILES_REPO:-}"          # dotfiles Git 仓库地址
INSTALL_LOG_DIR="$(dirname "$0")/logs"
TARGET_OS="$(detect_os)"                    # ubuntu | debian | fedora | arch | ...

# ── 函数 ────────────────────────────────────────
info()  { echo -e "\033[1;34m[INFO]\033[0m $*"; }
warn()  { echo -e "\033[1;33m[WARN]\033[0m $*"; }
error() { echo -e "\033[1;31m[ERROR]\033[0m $*" >&2; exit 1; }

detect_os() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        case "$ID" in
            ubuntu|debian)  echo "debian" ;;
            fedora|rhel)    echo "fedora" ;;
            arch|manjaro)   echo "arch"   ;;
            *)              echo "$ID"   ;;
        esac
    else
        error "无法识别操作系统"
    fi
}

need_root() {
    if [ "$(id -u)" -ne 0 ]; then
        error "请使用 sudo 或以 root 用户运行此脚本"
    fi
}

log() {
    local step="$1"
    local msg="$2"
    mkdir -p "$INSTALL_LOG_DIR"
    echo "[$(date '+%H:%M:%S')] $step | $msg" >> "$INSTALL_LOG_DIR/install.log"
    info "$step | $msg"
}

run_step() {
    local script="$1"
    local step_num
    step_num=$(echo "$script" | grep -oP '^\d+')
    if [ -f "$(dirname "$0")/scripts/$script" ]; then
        log "STEP-$step_num" "执行 $script"
        bash "$(dirname "$0")/scripts/$script" "$TARGET_OS" || {
            warn "步骤 $step_num 失败，继续下一项..."
        }
    fi
}

# ── 主流程 ──────────────────────────────────────
need_root

mkdir -p "$INSTALL_LOG_DIR"
info "=========================================="
info "  Linux 个性化部署脚本"
info "  检测系统: $TARGET_OS"
info "=========================================="
echo

# 交互式确认
read -p "是否继续安装? (y/N): " confirm
if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
    info "已取消安装"
    exit 0
fi

echo
run_step "01-system.sh"
run_step "02-packages.sh"
run_step "03-dotfiles.sh"
run_step "04-devtools.sh"
run_step "05-desktop.sh"
run_step "06-post.sh"

echo
info "=========================================="
info "  部署完成!"
info "  日志文件: $INSTALL_LOG_DIR/install.log"
info "=========================================="
```

---

### 2. `packages.conf` — 软件包列表

```conf
# ===== 基础工具 =====
# Debian/Ubuntu                | Fedora              | Arch
git,curl,wget,vim,tmux,zsh   | git,curl,wget,vim,tmux,zsh | git,curl,wget,vim,tmux,zsh
build-essential,libssl-dev  | @development-tools   | base-devel
flatpak                      | flatpak              | flatpak
software-properties-common   | dnf-plugins-core     | (n/a)

# ===== 开发工具 =====
# Debian/Ubuntu                          | Fedora                  | Arch
python3,pip,python3-venv              | python3,pip              | python,python-pip
docker.io,docker-compose              | docker,docker-compose   | docker,docker-compose
nodejs,npm                            | nodejs,npm              | nodejs,npm

# ===== 常用应用 =====
# Debian/Ubuntu                          | Fedora                  | Arch
code                                   | code                    | code
firefox,chromium-browser               | firefox                 | firefox,chromium
thunderbird |evolution                 | thunderbird             | thunderbird
libreoffice                            | libreoffice             | libreoffice
filezilla                              | filezilla               | filezilla
```

---

### 3. `scripts/02-packages.sh` — 软件包安装核心逻辑

```bash
#!/usr/bin/env bash
set -euo pipefail

TARGET_OS="$1"

# ── 读取软件包配置 ──────────────────────────────
read_packages() {
    local conf_file
    conf_file="$(dirname "$0")/../config/packages.conf"
    # 解析逻辑：将三列格式转为各 OS 的安装命令
    grep -v '^#' "$conf_file" | grep -v '^$' | while IFS='|' read -r debian_pkg fedora_pkg arch_pkg; do
        case "$TARGET_OS" in
            debian)
                [ -n "$debian_pkg" ] && echo "$debian_pkg" ;;
            fedora)
                [ -n "$fedora_pkg" ] && echo "$fedora_pkg" ;;
            arch)
                [ -n "$arch_pkg" ] && echo "$arch_pkg" ;;
        esac
    done
}

# ── 安装函数 ────────────────────────────────────
install_debian() {
    export DEBIAN_FRONTEND=noninteractive
    apt-get update
    while IFS='|' read -r debian_pkg _ _; do
        [ -z "$debian_pkg" ] || [[ "$debian_pkg" =~ ^# ]] && continue
        apt-get install -y $debian_pkg 2>/dev/null || true
    done < "$(dirname "$0")/../config/packages.conf"
}

install_fedora() {
    dnf check-update
    while IFS='|' read -r _ fedora_pkg _; do
        [ -z "$fedora_pkg" ] || [[ "$fedora_pkg" =~ ^# ]] && continue
        dnf install -y $fedora_pkg 2>/dev/null || true
    done < "$(dirname "$0")/../config/packages.conf"
}

install_arch() {
    while IFS='|' read -r _ _ arch_pkg; do
        [ -z "$arch_pkg" ] || [[ "$arch_pkg" =~ ^# ]] && continue
        pacman -Sy --noconfirm $arch_pkg 2>/dev/null || true
    done < "$(dirname "$0")/../config/packages.conf"
}

# ── 主逻辑 ─────────────────────────────────────
case "$TARGET_OS" in
    debian) install_debian ;;
    fedora) install_fedora ;;
    arch)   install_arch   ;;
    *)      echo "不支持的操作系统: $TARGET_OS" ;;
esac
```

---

### 4. `scripts/03-dotfiles.sh` — dotfiles 部署

```bash
#!/usr/bin/env bash
set -euo pipefail

TARGET_OS="$1"
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
SOURCE_DIR="$(dirname "$(dirname "$0")")/dotfiles"

deploy_dotfile() {
    local src="$1"
    local dst="$2"
    if [ -f "$src" ]; then
        mkdir -p "$(dirname "$dst")"
        cp -f "$src" "$dst"
        echo "  部署: $dst"
    fi
}

# ── 常用 dotfiles ───────────────────────────────
common_dotfiles=(
    "$HOME/.zshrc"
    "$HOME/.bashrc"
    "$HOME/.vimrc"
    "$HOME/.tmux.conf"
    "$HOME/.gitconfig"
    "$HOME/.config/starship.toml"
    "$HOME/.config/alacritty/alacritty.yml"
)

if [ -d "$SOURCE_DIR" ]; then
    for dotfile in "${common_dotfiles[@]}"; do
        src_path="$SOURCE_DIR/$(basename "$dotfile")"
        deploy_dotfile "$src_path" "$dotfile"
    done
elif [ -n "${DOTFILES_REPO:-}" ]; then
    git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
    cd "$DOTFILES_DIR"
    # 链接或复制 dotfiles
fi

# ── shell 切换 ──────────────────────────────────
if command -v zsh &>/dev/null; then
    if [ -f "$HOME/.zshrc" ]; then
        chsh -s "$(command -v zsh)" 2>/dev/null || true
        echo "已切换默认 shell 为 zsh"
    fi
fi
```

---

### 5. `scripts/06-post.sh` — 收尾

```bash
#!/usr/bin/env bash
set -euo pipefail

TARGET_OS="$1"

# ── 清理缓存 ───────────────────────────────────
info "清理系统缓存..."
if command -v apt-get &>/dev/null; then
    apt-get autoremove -y
    apt-get autoclean
elif command -v dnf &>/dev/null; then
    dnf clean all
elif command -v pacman &>/dev/null; then
    pacman -Sc --noconfirm
fi

# ── 生成安装报告 ────────────────────────────────
REPORT_FILE="$(dirname "$0")/../logs/install-report.txt"
{
    echo "=== 安装报告 ==="
    echo "日期: $(date)"
    echo "系统: $(uname -a)"
    echo ""
    echo "=== 已安装的关键软件 ==="
    for cmd in git vim zsh tmux docker code firefox; do
        if command -v "$cmd" &>/dev/null; then
            echo "  $cmd: $(command -v $cmd)"
        fi
    done
} > "$REPORT_FILE"
```

## 推荐的最佳实践

| 建议 | 说明 |
|------|------|
| **版本控制 dotfiles** | 用 Git 管理 `.zshrc`、`.vimrc` 等，放到 GitHub/Gitee |
| **模块化脚本** | 按功能拆成多个小脚本，方便单独调试和复用 |
| **幂等性设计** | 脚本可以多次运行而不破坏已有配置 |
| **日志记录** | 所有操作写入日志，方便排查问题 |
| **dry-run 模式** | 添加 `--dry-run` 参数预览会做什么，不实际安装 |
| **配置分离** | `packages.conf` 和脚本逻辑分离，改配置不改代码 |
| **支持多 OS** | 用 `detect_os` 统一抽象，一套脚本支持多种发行版 |
