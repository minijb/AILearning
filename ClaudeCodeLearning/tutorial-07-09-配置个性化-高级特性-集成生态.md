# 阶段七至九：配置与个性化 + 高级特性 + 集成与生态

> 本教程涵盖 Claude Code 的配置系统、高级特性和生态集成。

---

## 目录

- [阶段七至九：配置与个性化 + 高级特性 + 集成与生态](#阶段七至九配置与个性化--高级特性--集成与生态)
  - [目录](#目录)
  - [第一章：配置与个性化](#第一章配置与个性化)
    - [1.1 配置文件结构](#11-配置文件结构)
    - [1.2 基础配置项](#12-基础配置项)
    - [1.3 权限配置](#13-权限配置)
    - [1.4 环境变量配置](#14-环境变量配置)
    - [1.5 允许的工具列表](#15-允许的工具列表)
  - [第二章：高级特性](#第二章高级特性)
    - [2.1 MCP 服务器](#21-mcp-服务器)
    - [2.2 Hooks 钩子机制](#22-hooks-钩子机制)
    - [2.3 CLAUDE.md 项目文档](#23-claudemd-项目文档)
    - [2.4 上下文管理](#24-上下文管理)
  - [第三章：集成与生态](#第三章集成与生态)
    - [3.1 IDE 集成](#31-ide-集成)
    - [3.2 GitHub 集成](#32-github-集成)
    - [3.3 CI/CD 集成](#33-cicd-集成)
    - [3.4 常用工作流集成](#34-常用工作流集成)
  - [实践练习](#实践练习)

---

## 第一章：配置与个性化

Claude Code 通过 `settings.json` 配置文件进行个性化设置，支持全局配置和项目级配置。

### 1.1 配置文件结构

**配置位置：**

| 位置 | 范围 | 说明 |
|------|------|------|
| `~/.claude/settings.json` | 全局 | 所有项目生效 |
| `<project>/.claude/settings.json` | 项目级 | 仅当前项目生效 |

**优先级：** 项目级 > 全局

**目录结构：**

```
~/.claude/                          # 全局配置
├── settings.json                   # 主配置文件
└── rules/                          # 全局规则
    ├── common/
    └── typescript/

project/
└── .claude/                       # 项目配置
    ├── settings.json              # 项目配置（覆盖全局）
    └── rules/                     # 项目规则
        ├── common/
        └── typescript/
```

**创建配置目录：**

```bash
# 全局配置
mkdir -p ~/.claude

# 项目配置
mkdir -p .claude
```

### 1.2 基础配置项

**settings.json 完整结构：**

```json
{
  "env": {
    "ANTHROPIC_AUTH_TOKEN": "your-token",
    "ANTHROPIC_BASE_URL": "http://127.0.0.1:15721"
  },
  "permissions": {
    "allow": ["Read", "Write", "Bash"],
    "deny": ["WebSearch"]
  },
  "mcpServers": {},
  "hooks": {},
  "allowed_tools": {}
}
```

**配置示例：**

```json
{
  "env": {
    "ANTHROPIC_AUTH_TOKEN": "sk-ant-...",
    "NODE_ENV": "development"
  }
}
```

### 1.3 权限配置

权限系统控制 Claude Code 可以使用哪些工具。

**权限类型：**

| 权限 | 功能 |
|------|------|
| `Read` | 读取文件 |
| `Write` | 写入文件 |
| `Edit` | 编辑文件 |
| `Bash` | 执行终端命令 |
| `Grep` | 搜索文件内容 |
| `Glob` | 搜索文件 |
| `WebSearch` | 网络搜索 |
| `WebFetch` | 获取网页内容 |
| `Agent` | 启动 Agent |

**配置示例：**

```json
{
  "permissions": {
    "allow": ["Read", "Write", "Edit", "Bash", "Grep", "Glob"],
    "deny": ["WebSearch", "WebFetch"]
  }
}
```

**安全建议：**

```
生产环境 ──► 严格限制权限
开发环境 ──► 适度开放权限

最小权限原则：
  ├── 只允许项目目录内的文件操作
  ├── 限制危险的 Bash 命令
  └── 禁用不必要的工具
```

**限制 Bash 命令示例：**

```json
{
  "permissions": {
    "allow": ["Read", "Write", "Edit"],
    "deny": ["Bash"]
  }
}
```

### 1.4 环境变量配置

在配置文件中设置环境变量，方便 Claude Code 访问敏感信息。

**配置示例：**

```json
{
  "env": {
    "MY_API_KEY": "sk-...",
    "DATABASE_URL": "postgresql://...",
    "NODE_ENV": "development"
  }
}
```

**使用方式：**

```bash
# Claude Code 可以直接使用这些变量
"使用 $MY_API_KEY 调用外部 API"
```

**注意事项：**

> ⚠️ 不要在配置文件中存储真正的密钥！建议使用 `.env` 文件或密钥管理服务。

**更安全的做法：**

```json
{
  "env": {
    "MY_API_KEY": {
      "command": "cat",
      "args": [".env"],
      "extract": "MY_API_KEY=(.*)"
    }
  }
}
```

### 1.5 允许的工具列表

**完整工具列表：**

```json
{
  "allowed_tools": {
    "Read": true,
    "Write": true,
    "Edit": true,
    "Bash": true,
    "Grep": true,
    "Glob": true,
    "WebFetch": true,
    "WebSearch": true,
    "Agent": true,
    "TaskCreate": true,
    "TaskList": true,
    "TaskGet": true,
    "TaskUpdate": true,
    "NotebookEdit": true
  }
}
```

---

## 第二章：高级特性

### 2.1 MCP 服务器

#### 什么是 MCP

Model Context Protocol (MCP) 是一种开放协议，使 AI 应用能够连接到外部数据源和工具。

```
┌─────────────────────────────────────────────────────────────┐
│                    Claude Code                               │
│                                                             │
│         MCP 协议 ──────────► MCP 服务器                      │
│              │                   │                          │
│              │                   ├── GitHub                 │
│              │                   ├── 文件系统               │
│              │                   ├── 数据库                 │
│              │                   └── Slack                  │
└─────────────────────────────────────────────────────────────┘
```

#### MCP 配置示例

**配置语法：**

```json
{
  "mcpServers": {
    "server-name": {
      "command": "npx",
      "args": ["-y", "@server/package", "/path/to/resource"],
      "env": {
        "ENV_VAR": "value"
      }
    }
  }
}
```

**常用 MCP 服务器：**

| 服务器 | 功能 | 安装命令 |
|--------|------|---------|
| `server-filesystem` | 文件系统访问 | `npx -y @modelcontextprotocol/server-filesystem` |
| `server-github` | GitHub API 操作 | `npx -y @modelcontextprotocol/server-github` |
| `server-memory` | 持久化记忆 | `npx -y @modelcontextprotocol/server-memory` |
| `server-slack` | Slack 集成 | `npx -y @modelcontextprotocol/server-slack` |
| `server-brave-search` | 网页搜索 | `npx -y @modelcontextprotocol/server-brave-search` |
| `server-sentry` | Sentry 错误追踪 | `npx -y @modelcontextprotocol/server-sentry` |

#### 实战配置

**文件系统服务器：**

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/home/user/projects"]
    }
  }
}
```

**GitHub 服务器：**

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "your-github-token"
      }
    }
  }
}
```

**使用 GitHub MCP：**

```bash
# 创建 Issue
"在当前仓库创建一个 Issue，标题是 '修复登录bug'"

# 管理 PR
"查看最近打开的 PR 并总结"

# 评论 PR
"在 PR #123 下添加评论：'LGTM'"
```

#### 自定义 MCP 服务器

如果现有 MCP 服务器不满足需求，可以开发自定义 MCP 服务器。

**基本结构：**

```javascript
// server.js
const { Server } = require('@modelcontextprotocol/sdk/server');
const { StdioServerTransport } = require('@modelcontextprotocol/sdk/server/stdio');

const server = new Server(
  {
    name: "my-custom-server",
    version: "1.0.0",
  },
  {
    capabilities: {
      tools: {},
      resources: {},
    },
  }
);

// 注册工具
server.setRequestHandler({ method: "tools/list" }, async () => {
  return {
    tools: [
      {
        name: "my_tool",
        description: "我的自定义工具",
        inputSchema: {
          type: "object",
          properties: {
            param: { type: "string" }
          }
        }
      }
    ]
  };
});

async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
}

main();
```

### 2.2 Hooks 钩子机制

Hooks 允许在工具执行前后自动运行脚本，实现自动化工作流。

#### 可用的钩子类型

| 钩子 | 触发时机 | 常见用途 |
|------|----------|----------|
| `PreToolUse` | 工具执行前 | 验证、日志、拦截 |
| `PostToolUse` | 工具执行后 | 后续处理、通知 |
| `PreCommand` | 命令执行前 | 环境检查、准备 |
| `PostCommand` | 命令执行后 | 格式化输出、通知 |
| `OnDiskToolUse` | 磁盘工具执行时 | 路径验证、权限检查 |

#### 配置示例

```json
{
  "hooks": {
    "PostCommand": {
      "command": "notify-send 'Claude Code' 'Command completed'",
      "description": "命令完成后发送桌面通知"
    },
    "PreCommand": {
      "command": "echo 'Starting...'",
      "description": "记录开始时间"
    },
    "PreToolUse": {
      "command": "logger.sh",
      "args": ["${toolName}", "${toolInput}"],
      "description": "记录工具调用日志"
    }
  }
}
```

#### 实用钩子场景

| 场景 | 钩子配置 |
|------|----------|
| 自动格式化 | `PostCommand` 运行 Prettier |
| 提交前检查 | `PreCommand` 验证代码风格 |
| 性能监控 | `PostCommand` 记录执行时间 |
| 团队通知 | `PostCommand` 发送 Slack 消息 |
| 日志记录 | `PreToolUse` 记录所有操作 |

**自动格式化钩子：**

```json
{
  "hooks": {
    "PostToolUse": {
      "toolNames": ["Edit", "Write"],
      "command": "npx prettier --write ${targetFile}",
      "description": "文件修改后自动格式化"
    }
  }
}
```

**Git 提交钩子：**

```json
{
  "hooks": {
    "PreCommand": {
      "command": "echo 'Running pre-commit checks...'",
      "description": "提交前检查"
    }
  }
}
```

**桌面通知钩子：**

```json
{
  "hooks": {
    "PostCommand": {
      "command": "osascript -e 'display notification \"Command completed\" with title \"Claude Code\"'",
      "description": "命令完成后发送 macOS 通知"
    }
  }
}
```

### 2.3 CLAUDE.md 项目文档

CLAUDE.md 是项目的说明文档，帮助 Claude Code 更好地理解项目。

#### 为什么需要 CLAUDE.md

```
不使用 CLAUDE.md：
  Claude: "我需要了解这个项目"
  用户: 需要反复说明项目结构、技术栈、约定...

使用 CLAUDE.md：
  Claude: 自动读取 CLAUDE.md
  用户: 直接开始工作
```

#### CLAUDE.md 位置

- 项目根目录：`./CLAUDE.md`
- Claude Code 自动查找并读取

#### CLAUDE.md 内容结构

```markdown
# 项目概述
这是一个 React + TypeScript 的电商后台管理系统

# 技术栈
- Frontend: React 18, TypeScript, Tailwind CSS
- Backend: Node.js, Express
- Database: PostgreSQL
- CI/CD: GitHub Actions

# 代码规范
- 使用 ESLint + Prettier
- 提交信息遵循 Conventional Commits
- 所有组件使用 functional component
- 使用 CSS Modules 进行样式管理

# 常用命令
- npm run dev: 启动开发服务器（端口 3000）
- npm run build: 生产构建
- npm test: 运行测试
- npm run lint: 代码检查

# 项目结构
- src/components/: UI 组件
- src/pages/: 页面组件
- src/api/: API 调用
- src/utils/: 工具函数
- src/hooks/: 自定义 Hooks

# 环境变量
- DATABASE_URL: 数据库连接
- API_URL: 后端 API 地址
```

#### CLAUDE.md 模板

```markdown
# [项目名称]

> 一句话描述项目

## 技术栈

| 类别 | 技术 |
|------|------|
| 前端框架 | |
| 后端框架 | |
| 数据库 | |
| 部署 | |

## 开发规范

### 代码规范
- [ ] ESLint + Prettier
- [ ] TypeScript strict 模式
- [ ] 提交信息格式

### Git 工作流
1. 从 main 创建功能分支
2. 开发完成后创建 PR
3. 至少 1 人 review
4. 合并到 main

## 常用命令

```bash
# 开发
npm run dev

# 构建
npm run build

# 测试
npm test

# 代码检查
npm run lint
```

## 项目结构

```
src/
├── components/   # UI 组件
├── pages/        # 页面
├── api/          # API 调用
├── hooks/        # 自定义 Hooks
└── utils/        # 工具函数
```

## 注意事项

- 不要修改 node_modules
- 敏感信息使用环境变量
- 大文件不超过 500 行
```

### 2.4 上下文管理

#### 上下文压缩

```bash
/compact
```

压缩对话历史，保留关键信息。

#### 清除对话

```bash
/clear
```

清除所有对话历史，但保留项目上下文。

#### 文件引用

```bash
# 引用单个文件
"分析 @src/utils/helpers.ts 的复杂度"

# 引用多个文件
"对比 @src/api/user.ts 和 @src/api/admin.ts 的实现"
```

#### 上下文优化技巧

| 技巧 | 方法 | 效果 |
|------|------|------|
| 定期压缩 | `/compact` | 保持上下文清爽 |
| 针对性清除 | `/clear` | 重新开始对话 |
| 引用文件 | `@file` | 减少解释成本 |
| 分步骤 | 多轮对话 | 分散上下文压力 |

---

## 第三章：集成与生态

### 3.1 IDE 集成

#### VS Code 集成

**安装步骤：**
1. 打开 VS Code Extensions
2. 搜索 "Claude"
3. 安装 Anthropic 官方扩展

**功能特性：**

| 功能 | 说明 |
|------|------|
| Inline Chat | 在编辑器中直接对话 |
| Quick Chat | 命令面板快速呼出 |
| Code Review | 选中代码进行审查 |
| Inline Diff | 查看修改的 inline diff |
| Terminal 集成 | 在终端中呼出 Claude Code |

**快捷键：**

| 快捷键 | 功能 |
|--------|------|
| `Cmd/Ctrl + Shift + A` | 打开 Claude Chat |
| `Cmd/Ctrl + Shift + C` | Inline Chat |
| `Cmd/Ctrl + Shift + L` | 选中代码后审查 |
| `Cmd/Ctrl + Shift + R` | 引用选中代码 |

**使用示例：**

```
# 在编辑器中直接提问
选中代码 → Cmd+Shift+C → "解释这段代码"

# Inline Diff
Claude 修改代码后 → 查看 inline diff → 确认或撤销
```

#### JetBrains 集成

**安装步骤：**
1. Settings > Plugins
2. 搜索 "Claude"
3. 安装后重启 IDE

**功能：** 与 VS Code 类似，深度集成 JetBrains 工具链。

#### 其他编辑器

| 编辑器 | 集成方式 |
|--------|---------|
| Neovim | 通过 LSP 或插件 (nvim-cmp) |
| Emacs | Via MCP 或 elisp 包 |
| Zed | 内置 Claude 集成 |
| Cursor | 内置 Claude 集成 |
| VS Code Insiders | 官方扩展 |

### 3.2 GitHub 集成

#### PR 审查

```bash
# 审查当前分支的 PR
/review

# 审查指定 PR
/review @https://github.com/user/repo/pull/123

# 审查文件变更
/review src/components/Button.tsx
```

**Claude Code PR 审查能力：**
- ✅ 分析代码变更
- ✅ 检查潜在问题
- ✅ 提出改进建议
- ✅ 评估代码质量
- ✅ 检查安全漏洞

#### GitHub MCP 服务器

配置 `server-github` 实现更深入的 GitHub 集成：

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "your-token"
      }
    }
  }
}
```

**GitHub MCP 功能：**

```bash
# Issue 管理
"创建一个 Issue：标题 '优化性能' 内容 '当前页面加载时间是 5s'"
"列出所有 open 的 bug Issue"

# PR 管理
"查看最近合并的 5 个 PR"
"在 PR #123 添加评论 'LGTM'"

# 仓库操作
"创建新分支 feature/login"
"查看仓库的 CI 状态"
```

### 3.3 CI/CD 集成

#### GitHub Actions

**在 CI 中使用 Claude Code：**

```yaml
# .github/workflows/code-review.yml
name: Claude Code Review

on:
  pull_request:
    types: [opened, synchronize]

jobs:
  review:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup Node
        uses: actions/setup-node@v4
        with:
          node-version: '20'

      - name: Install Claude Code
        run: npm install -g @anthropic-ai/claude-code

      - name: Run Claude Code Review
        env:
          ANTHROPIC_AUTH_TOKEN: ${{ secrets.ANTHROPIC_API_TOKEN }}
        run: |
          claude --print-only "/review"
```

**自动代码审查工作流：**

```yaml
name: Auto Review

on:
  pull_request:

jobs:
  review:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - uses: actions/setup-node@v4
        with:
          node-version: '20'

      - name: Install Claude Code
        run: npm install -g @anthropic-ai/claude-code

      - name: Claude Code Security Review
        env:
          ANTHROPIC_AUTH_TOKEN: ${{ secrets.ANTHROPIC_API_TOKEN }}
        run: claude --print-only "/security-review"

      - name: Claude Code Review
        env:
          ANTHROPIC_AUTH_TOKEN: ${{ secrets.ANTHROPIC_API_TOKEN }}
        run: claude --print-only "/review"
```

#### GitLab CI

```yaml
# .gitlab-ci.yml
claude-review:
  stage: review
  image: node:20
  script:
    - npm install -g @anthropic-ai/claude-code
    - claude --print-only "/review"
  environment:
    ANTHROPIC_AUTH_TOKEN: $ANTHROPIC_API_TOKEN
```

### 3.4 常用工作流集成

#### 通知集成

**Slack 通知：**

```json
{
  "hooks": {
    "PostCommand": {
      "command": "curl -X POST $SLACK_WEBHOOK -H 'Content-type: application/json' --data '{\"text\":\"Command completed\"}'",
      "description": "Slack 通知"
    }
  }
}
```

**钉钉通知：**

```json
{
  "hooks": {
    "PostCommand": {
      "command": "curl -d '{\"msgtype\":\"text\",\"text\":{\"content\":\"Claude Code 任务完成\"}}' $DINGTALK_WEBHOOK",
      "description": "钉钉通知"
    }
  }
}
```

#### 代码质量集成

**ESLint + Prettier：**

```json
{
  "hooks": {
    "PostToolUse": {
      "toolNames": ["Edit", "Write"],
      "command": "npx eslint --fix ${targetFile}",
      "description": "自动修复 ESLint 问题"
    }
  }
}
```

**测试集成：**

```json
{
  "hooks": {
    "PreCommand": {
      "command": "npm test -- --coverage",
      "description": "提交前运行测试"
    }
  }
}
```

#### 文档集成

**自动生成文档：**

```bash
# JSDoc 生成
"为 src/utils/helpers.ts 的所有函数生成 JSDoc 注释"

# README 更新
"检查 README 是否需要更新，补充缺失的信息"

# API 文档生成
"为这个 Express 项目生成 API 文档"
```

---

## 实践练习

### 练习一：配置个性化

**目标：** 配置适合你的 Claude Code 环境

**任务清单：**
1. ✅ 创建全局配置文件 `~/.claude/settings.json`
2. ✅ 配置基础权限
3. ✅ 设置环境变量
4. ✅ 创建项目级配置

### 练习二：高级特性

**目标：** 掌握高级特性

**任务清单：**
1. ✅ 配置一个 MCP 服务器（filesystem）
2. ✅ 设置一个 Hook（自动格式化）
3. ✅ 创建项目的 CLAUDE.md
4. ✅ 练习上下文管理

### 练习三：集成配置

**目标：** 配置开发环境集成

**任务清单：**
1. ✅ 在 VS Code 中安装 Claude 扩展
2. ✅ 配置 GitHub MCP 服务器
3. ✅ 创建 GitHub Actions 自动审查工作流

---

*本教程是 Claude Code 系统学习系列的第三部分。*
