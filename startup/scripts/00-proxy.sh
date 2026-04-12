#!/usr/bin/env bash
#================================================================
# 共享网络代理配置脚本
# 被其他脚本 source 使用，定义 proxy 相关的函数和变量
#================================================================

# ── WSL 检测 ─────────────────────────────────────────────────
is_wsl() {
    if [ -f /proc/version ]; then
        grep -qi 'microsoft\|wsl' /proc/version 2>/dev/null
    else
        return 1
    fi
}

# ── WSL 下获取宿主机 IP ───────────────────────────────────────
wsl_host_ip() {
    # /etc/resolv.conf 中的 nameserver 即 WSL 网关（宿主机 IP）
    grep nameserver /etc/resolv.conf 2>/dev/null | awk '{print $2}' | head -1
}

# ── 代理地址（export 后可供子进程使用）─────────────────────────
PROXY_SCHEME="http"
PROXY_IP=""
PROXY_PORT=""
PROXY_URL=""

# 若已配置过代理，跳过交互
_proxy_already_configured() {
    [ -n "${http_proxy:-}" ] || [ -n "${HTTP_PROXY:-}" ] || [ -n "${PROXY_URL:-}" ]
}

# ── 交互式配置代理 ────────────────────────────────────────────
configure_proxy() {
    local skip="${1:-}"

    echo
    echo "------------------------------------------------"
    echo "  网络代理配置"
    echo "------------------------------------------------"

    if _proxy_already_configured; then
        echo "  检测到已有代理: ${http_proxy:-${HTTP_PROXY:-}}"
        return 0
    fi

    if [ -n "$skip" ]; then
        echo "  ($skip，跳过)"
        return 0
    fi

    # 判断是否已在环境变量中设置
    if [ -n "${http_proxy:-}" ] || [ -n "${HTTP_PROXY:-}" ]; then
        echo "  检测到已有代理配置: ${http_proxy:-${HTTP_PROXY:-}}"
        read -r -p "  是否沿用该配置? [Y/n]: " ans
        ans="${ans:-Y}"
        if [ "$ans" = "y" ] || [ "$ans" = "Y" ]; then
            echo "  沿用现有配置"
            return 0
        fi
    fi

    if is_wsl; then
        PROXY_IP="$(wsl_host_ip)"
        echo "  [WSL 检测] 宿主机 IP: $PROXY_IP"
        read -r -p "  请输入代理端口 (如 7890，回车使用默认值 7890): " PROXY_PORT
        PROXY_PORT="${PROXY_PORT:-7890}"
    else
        read -r -p "  请输入代理 IP 地址: " PROXY_IP
        while [ -z "$PROXY_IP" ]; do
            read -r -p "  IP 不能为空，请重新输入: " PROXY_IP
        done
        read -r -p "  请输入代理端口 (如 7890): " PROXY_PORT
        while [ -z "$PROXY_PORT" ]; do
            read -r -p "  端口不能为空，请重新输入: " PROXY_PORT
        done
    fi

    PROXY_URL="${PROXY_SCHEME}://${PROXY_IP}:${PROXY_PORT}"
    echo "  代理地址: $PROXY_URL"

    export http_proxy="$PROXY_URL"
    export https_proxy="$PROXY_URL"
    export HTTP_PROXY="$PROXY_URL"
    export HTTPS_PROXY="$PROXY_URL"
    export no_proxy="localhost,127.0.0.1"
    export NO_PROXY="localhost,127.0.0.1"

    echo "  ✓ 代理环境变量已导出"
}

# ── 将代理写入 /etc/environment（系统级，需 root）──────────────
apply_proxy_system() {
    if [ -z "$PROXY_URL" ]; then
        return 0
    fi

    local env_file="/etc/environment"
    # 避免重复写入，先移除旧配置
    if [ -f "$env_file" ]; then
        sed -i '/_proxy=".*"/d' "$env_file" 2>/dev/null || true
    fi

    {
        echo "http_proxy=\"$PROXY_URL\""
        echo "https_proxy=\"$PROXY_URL\""
        echo "HTTP_PROXY=\"$PROXY_URL\""
        echo "HTTPS_PROXY=\"$PROXY_URL\""
    } >> "$env_file"

    echo "  ✓ 代理已写入 $env_file（需重启或重新登录生效）"
}

# ── 为指定命令设置代理并执行 ──────────────────────────────────
run_with_proxy() {
    local cmd="$1"; shift
    local old_http="$http_proxy"
    local old_https="$https_proxy"

    [ -n "$PROXY_URL" ] && {
        export http_proxy="$PROXY_URL"
        export https_proxy="$PROXY_URL"
    }

    "$cmd" "$@"
    local ret=$?

    export http_proxy="$old_http"
    export https_proxy="$old_https"

    return $ret
}
