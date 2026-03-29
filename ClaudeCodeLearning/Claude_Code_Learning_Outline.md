# Claude Code 系统学习大纲

> 本大纲旨在帮助开发者系统掌握 Claude Code 工具，从基础入门到高级应用，循序渐进地提升使用效率。

---

## 目录

- [阶段一：入门基础](#阶段一入门基础)
- [阶段二：核心功能](#阶段二核心功能)
- [阶段三：Agent 智能体](#阶段三agent-智能体)
- [阶段四：Skill 技能](#阶段四skill-技能)
- [阶段五：斜杠命令与交互](#阶段五斜杠命令与交互)
- [阶段六：工具详解](#阶段六工具详解)
- [阶段七：配置与个性化](#阶段七配置与个性化)
- [阶段八：高级特性](#阶段八高级特性)
- [阶段九：集成与生态](#阶段九集成与生态)
- [阶段十：最佳实践](#阶段十最佳实践)
- [阶段十一：Rule 规则系统](#阶段十一rule-规则系统)
- [附录：参考资料](#附录参考资料)

---

## 阶段一：入门基础

### 1.1 Claude Code 概述

| 知识点 | 内容 |
|--------|------|
| **什么是 Claude Code** | Anthropic 官方推出的 AI 编程助手，基于命令行运行 |
| **核心定位** | 自然语言编程、代码生成与编辑、终端命令执行 |
| **主要用途** | 代码编写与重构、调试与问题排查、代码审查、文档生成、测试编写、项目初始化 |

**学习目标**：理解 Claude Code 的定位和价值，了解它能做什么。

### 1.2 安装与启动

```bash
# 安装（通过 npm）
npm install -g @anthropic-ai/claude-code

# 启动交互模式
claude

# 单次命令模式
claude "你的指令"

# 退出方式
exit
# 或 Ctrl+C 两次
```

**学习目标**：
- 掌握 Claude Code 的安装方式
- 熟悉交互模式和单次命令模式的区别
- 能够正常启动和退出

### 1.3 基础交互

| 模式 | 命令示例 | 说明 |
|------|----------|------|
| 默认模式 | `claude` | 进入交互式对话 |
| 安静模式 | `claude --quiet "指令"` | 减少输出 |
| 指定模型 | `claude --model opus "复杂任务"` | 选择模型 |
| 只打印 | `claude --print-only "指令"` | 不进入交互 |

**学习目标**：
- 能够使用不同模式运行 Claude Code
- 了解 `--model`、`--quiet`、`--print-only` 等参数

### 1.4 模型选择

| 模型 | 适用场景 |
|------|----------|
| **opus** | 复杂任务、分析、架构设计 |
| **sonnet** | 日常编程任务（推荐默认） |
| **haiku** | 简单快速任务 |

**学习目标**：根据任务复杂度选择合适的模型。

### 1.5 第一个练习

**练习任务**：
1. 启动 Claude Code 并打个招呼
2. 询问 Claude Code 今天能帮你做什么
3. 让它解释一个简单的编程概念
4. 退出程序

---

## 阶段二：核心功能

### 2.1 代码生成与编辑

**核心能力**：
- 使用自然语言描述任务，Claude Code 自动生成代码
- 支持多种编程语言
- 能够理解项目上下文

**示例指令**：
```
"创建一个 Python 函数，计算斐波那契数列第 n 项"
"用 TypeScript 写一个 Promise 包装的 HTTP 请求函数"
"为这个 React 组件添加 TypeScript 类型定义"
```

**学习目标**：能够用自然语言描述编程需求并获得代码。

### 2.2 文件操作

**Claude Code 内置工具**：

| 操作 | 工具 | 示例 |
|------|------|------|
| 读取文件 | `Read` | `Read: file_path="/path/to/file.js"` |
| 编辑文件 | `Edit` | 精确替换指定内容 |
| 创建文件 | `Write` | 创建新文件或覆盖 |
| 搜索文件 | `Glob` | `Glob: pattern="**/*.ts"` |
| 搜索内容 | `Grep` | 正则表达式搜索 |

**学习目标**：
- 理解 Claude Code 如何操作文件
- 能够让 Claude Code 读取、编辑、创建文件

### 2.3 终端命令执行

**Bash 工具**：
- 执行 shell 命令
- 安装依赖
- 运行脚本
- Git 操作

```bash
# 示例
npm install
npm run build
git status
```

**学习目标**：能够通过 Claude Code 执行终端命令。

### 2.4 Git 操作

Claude Code 可以帮助完成：

| 操作 | 说明 |
|------|------|
| 查看状态 | `git status` |
| 查看差异 | `git diff` |
| 创建提交 | 自动生成提交信息 |
| 分支管理 | 创建、切换、删除分支 |
| 查看历史 | `git log` |

**学习目标**：
- 让 Claude Code 执行 Git 操作
- 利用 AI 生成规范的提交信息

### 2.5 Web 搜索与获取

| 工具 | 功能 |
|------|------|
| `WebSearch` | 搜索网络获取最新信息 |
| `WebFetch` | 获取指定网页内容 |

**学习目标**：能够获取最新的开发信息和技术文档。

### 2.6 项目分析

Claude Code 能够：
- 分析代码库结构
- 理解依赖关系
- 识别代码模式
- 解释代码逻辑

**学习目标**：能够分析不熟悉的代码库。

---

## 阶段三：Agent 智能体

### 3.1 什么是 Agent

Agent 是 Claude Code 中的强大功能，允许启动专门的 AI 子实例来处理特定任务。Agent 本质上是一个带有特定指令和上下文的独立 Claude 实例，可以并行执行代码编写、文件操作、终端命令等任务。

**核心优势**：
| 特性 | 说明 |
|------|------|
| **并行处理** | 可同时启动多个 Agent 处理独立任务 |
| **专注任务** | 每个 Agent 独立上下文，任务专注度高 |
| **独立执行** | Agent 可在后台运行，不阻塞主对话 |
| **资源隔离** | 独立的上下文窗口，互不干扰 |

**学习目标**：理解 Agent 的概念和价值。

### 3.2 Agent 类型详解

| Agent 类型 | 用途 | 典型场景 |
|-----------|------|----------|
| **general-purpose** | 通用任务处理 | 默认类型，适用于大多数任务 |
| **Plan** | 制定计划和分析 | 复杂项目架构设计、任务分解 |
| **Explore** | 探索性分析 | 代码库调研、需求分析、代码审查 |
| **claude-code-guide** | Claude Code 使用指导 | 学习如何使用 Claude Code |

#### Agent 工具调用

```
Agent:
  instruction: "你的具体指令"
  subagent_type: "general-purpose" | "Plan" | "Explore" | "claude-code-guide"
  maxTurns: 10
```

**参数说明**：

| 参数 | 类型 | 说明 |
|------|------|------|
| `instruction` | string | 给 Agent 的具体任务描述 |
| `subagent_type` | string | Agent 的工作模式/类型 |
| `maxTurns` | number | 最大交互轮数，限制执行时间 |
| `run_in_background` | boolean | 是否在后台运行（默认 false）|

**学习目标**：掌握 Agent 的使用方式和参数配置。

### 3.3 Agent 使用场景与示例

#### 场景 1：并行代码审查

```
Agent:
  instruction: "审查 src/api/user.ts 文件，关注安全性问题"
  subagent_type: "Explore"
```

#### 场景 2：制定项目计划

```
Agent:
  instruction: "为这个 React 项目制定测试策略，考虑单元测试、集成测试和 E2E 测试"
  subagent_type: "Plan"
```

#### 场景 3：复杂重构任务

```
Agent:
  instruction: "将所有 class 组件迁移到 functional component，保持功能不变"
  subagent_type: "general-purpose"
  maxTurns: 20
```

#### 场景 4：并行研究多个主题

```
# 同时研究 3 个独立技术方案
Agent: 研究方案 A - 调研 Redis 缓存方案
Agent: 研究方案 B - 调研 Memcached 方案
Agent: 研究方案 C - 调研本地缓存方案
```

### 3.4 Agent 与主对话的区别

| 特性 | 主对话 | Agent |
|------|--------|-------|
| **上下文** | 共享当前项目的完整上下文 | 独立上下文，可选择性继承 |
| **并行性** | 单线程对话 | 可并行启动多个 Agent |
| **任务专注度** | 多任务混合处理 | 单一任务专注处理 |
| **适用场景** | 日常对话、小任务 | 复杂任务、并行处理 |

**最佳实践**：
- 简单任务直接在主对话中处理
- 复杂任务使用 Agent 深入处理
- 独立任务并行使用多个 Agent 提升效率
- 使用 `maxTurns` 限制 Agent 执行时间

### 3.5 第一个 Agent 练习

**练习任务**：
1. 使用 `Explore` Agent 分析项目结构
2. 使用 `Plan` Agent 制定一个小功能开发计划
3. 尝试并行启动 2 个 Agent

---

## 阶段四：Skill 技能

### 4.1 什么是 Skill

Skill 是预定义的命令或提示模板，帮助用户快速执行特定类型的任务。Skills 可以是内置的，也可以是项目自定义的，简化了常见工作流程的执行。

### 4.2 内置 Skill 完整列表

| Skill | 功能 | 用法 |
|-------|------|------|
| `/simplify` | 审查变更代码，复用性/质量/效率检查 | 直接调用 |
| `/loop` | 定时循环执行命令或提示 | `/loop 5m 任务描述` |
| `/batch` | 大规模变更研究、规划和并行执行 | `/batch 任务描述` |
| `/claude-api` | 构建 Claude API 或 Anthropic SDK 应用 | 直接调用 |
| `/init` | 初始化新的 CLAUDE.md 项目文档 | 直接调用 |
| `/review` | 审查 Pull Request | `/review` 或 `@PR_URL` |
| `/security-review` | 对当前分支变更进行安全审查 | 直接调用 |
| `/pr-comments` | 获取 GitHub Pull Request 的评论 | `@PR_URL` |
| `/insights` | 生成 Claude Code 会话分析报告 | 直接调用 |
| `/statusline` | 设置 Claude Code 状态栏 UI | 直接调用 |

### 4.3 常用 Skill 详解

#### `/batch` - 批量并行任务

```
/batch 将所有 React class 组件迁移到 functional component
```

**参数**：
- 任务描述：需要执行的大规模变更

**特点**：
- 默认使用 5-30 个并行工作树代理
- 每个代理打开一个独立的 PR
- 适用于大规模代码迁移

**学习目标**：掌握批量并行处理大规模重构任务。

#### `/loop` - 定时循环任务

```
/loop 5m 总结最新的 AI 新闻
/loop 10m 检查错误日志并汇报异常
```

**参数**：
- 时间间隔：数字 + 单位
  - `m` = 分钟
  - `h` = 小时
- 任务描述：需要定期执行的任务

**特点**：
- 默认间隔：10 分钟
- 持续监控和报告
- 适用于轮询、监控任务

**学习目标**：能够设置定时任务监控变化。

#### `/review` - PR 审查

```
/review
/review @https://github.com/user/repo/pull/123
/review src/components/UserProfile.tsx
```

**审查内容**：
- 代码质量分析
- 潜在 Bug 检测
- 安全问题检查
- 性能优化建议
- 代码风格一致性

**学习目标**：熟练进行代码审查。

#### `/security-review` - 安全审查

```
/security-review
```

**审查范围**：
- SQL 注入风险
- XSS 漏洞检测
- 依赖安全问题
- 敏感信息暴露
- 认证授权问题

#### `/simplify` - 代码简化审查

```
/simplify
```

**审查内容**：
- 代码复用性分析
- 质量问题识别
- 效率优化建议
- 简化建议

#### `/insights` - 会话分析

```
/insights
```

**输出内容**：
- 对话次数统计
- 主要工作类型
- 使用最多的工具
- 效率建议

#### `/init` - 初始化 CLAUDE.md

```
/init
```

自动引导创建项目的 `CLAUDE.md` 文档。

### 4.4 Skill 使用场景对照表

| 场景 | 推荐 Skill |
|------|-----------|
| 大规模代码迁移 | `/batch` |
| 定时监控任务 | `/loop` |
| 代码审查 | `/review` |
| 安全审计 | `/security-review` |
| API 开发 | `/claude-api` |
| 项目初始化 | `/init` |
| 会话分析 | `/insights` |
| 代码质量 | `/simplify` |

### 4.5 自定义 Skill

在项目的 `.claude/` 目录中创建自定义 Skills。

**配置位置**：
- 全局：`~/.claude/settings.json`
- 项目级：`<project>/.claude/settings.json`

**自定义 Skill 示例**：

```json
{
  "skills": {
    "my-custom-skill": {
      "description": "执行代码格式化检查",
      "command": "npx eslint --fix src/",
      "prompt": "请运行 ESLint 并修复所有自动可修复的问题"
    }
  }
}
```

**学习目标**：
- 掌握常用内置 Skill 的使用
- 能够根据需要创建自定义 Skill

### 4.6 Skill 练习

**练习任务**：
1. 使用 `/review` 审查一个代码文件
2. 使用 `/loop 1m` 设置一个简短定时任务
3. 使用 `/insights` 查看当前会话分析

---

## 阶段五：斜杠命令与交互

### 5.1 斜杠命令完整列表

| 命令 | 功能 | 参数 |
|------|------|------|
| `/help` | 显示帮助信息 | 无 |
| `/clear` | 清除对话历史 | 无 |
| `/compact` | 压缩上下文，保留关键信息 | 无 |
| `/model` | 切换使用的模型 | `opus`/`sonnet`/`haiku` |
| `/exit` 或 `/quit` | 退出 Claude Code | 无 |
| `/feedback` | 提交功能请求或 Bug 报告 | 无 |
| `/review` | 代码审查 | 文件路径或 PR URL |
| `/security-review` | 安全审查 | 无 |
| `/debug` | 启用调试模式 | 无 |
| `/simplify` | 简化代码审查 | 无 |
| `/batch` | 批量并行任务 | 任务描述 |
| `/loop` | 定时循环任务 | 时间间隔 + 任务 |
| `/init` | 初始化 CLAUDE.md | 无 |
| `/insights` | 会话分析 | 无 |
| `/pr-comments` | 获取 PR 评论 | PR URL |
| `/statusline` | 状态栏设置 | 配置选项 |

### 5.2 核心命令详解

#### `/model` - 模型切换

```
/model opus      # 最强模型，适合复杂分析
/model sonnet    # 平衡模型，推荐日常使用
/model haiku     # 快速模型，适合简单任务
```

**学习目标**：根据任务复杂度选择合适的模型。

#### `/clear` - 清除对话

```
/clear
```
- 清除所有对话历史
- 保留项目上下文
- 重新开始对话

#### `/compact` - 上下文压缩

```
/compact
```
- 压缩对话历史
- 保留关键信息
- 释放上下文空间

#### `/debug` - 调试模式

```
/debug
```
- 启用详细日志输出
- 显示工具调用详情
- 帮助诊断问题

### 5.3 快捷键

| 快捷键 | 功能 |
|--------|------|
| `Ctrl+C` | 中断当前操作 |
| `Ctrl+C` (两次) | 退出 Claude Code |
| `Tab` | 自动补全命令 |
| `↑/↓` | 浏览命令历史 |
| `Ctrl+L` | 清屏 |

### 5.4 命令使用示例

**示例 1：完整代码审查工作流**
```
/review
@https://github.com/user/project/pull/456
```

**示例 2：定时监控任务**
```
/loop 10m 检查并总结最新的错误日志
```

**示例 3：批量代码重构**
```
/batch 将所有 enzyme 测试迁移到 React Testing Library
```

**示例 4：会话分析**
```
/insights
```

### 5.5 对话技巧

#### 有效的提示词

**好的示例**：
```
"在 src/utils/helpers.ts 中添加 formatDate 函数，接收 Date 对象返回 YYYY-MM-DD"
"这是一个 Next.js 14 项目，使用 App Router，创建对应的 API route"
"使用 TypeScript strict 模式，添加完整的类型注解"
```

**需要避免的**：
```
"帮我看看这个文件"        # 过于模糊
"修复错误"               # 缺乏上下文
"写个函数"               # 没有具体要求
```

#### 提供上下文

| 技巧 | 说明 |
|------|------|
| 指定文件路径 | 明确告诉 Claude Code 要操作哪个文件 |
| 说明技术栈 | 告知使用的框架和库 |
| 描述约束 | 如性能要求、代码规范 |
| 提供示例 | 展示期望的输入输出 |

#### 分步骤执行

对于复杂任务：
```
1. "首先了解项目结构，列出目录树"
2. "分析 api/user.ts 的主要功能"
3. "基于以上分析，列出需要修改的文件"
4. "从修改配置文件开始执行"
```

**学习目标**：
- 熟练使用常用斜杠命令
- 掌握有效的对话技巧

### 5.6 第一个练习

**练习任务**：
1. 使用 `/model` 切换不同模型
2. 使用 `/debug` 启用调试模式
3. 使用 `/clear` 清除对话历史
4. 使用 `/compact` 压缩上下文

---

## 阶段六：工具详解

#### Read - 读取文件

```
功能：读取文件内容，支持大文件分页
参数：
  - file_path: 文件路径
  - limit: 限制行数
  - offset: 起始行号
```

**使用场景**：
- 让 Claude Code 理解现有代码
- 分析错误日志
- 阅读文档

#### Edit - 编辑文件

```
功能：精确修改代码
参数：
  - file_path: 文件路径
  - old_string: 要替换的内容
  - new_string: 新内容
  - replace_all: 是否全部替换
```

**学习目标**：掌握精确修改代码的技巧。

#### Write - 写入文件

```
功能：创建新文件或完整覆盖
参数：
  - file_path: 文件路径
  - content: 文件内容
```

**使用场景**：
- 创建新组件
- 生成配置文件
- 写入测试文件

#### Glob - 文件搜索

```
功能：使用 glob 模式匹配文件
示例：
  - pattern="**/*.ts"     # 所有 TypeScript 文件
  - pattern="src/**/*"     # src 目录下所有文件
  - pattern="*.json"       # 根目录 JSON 文件
```

#### Grep - 内容搜索

```
功能：正则表达式搜索文件内容
参数：
  - path: 搜索目录
  - pattern: 正则表达式
  - output_mode: content/files_with_matches/count
```

### 3.2 斜杠命令（Slash Commands）

| 命令 | 功能 |
|------|------|
| `/help` | 获取帮助信息 |
| `/clear` | 清除对话历史 |
| `/compact` | 压缩上下文 |
| `/model` | 切换模型 |
| `/security-review` | 安全审查 |
| `/review` | 代码审查 |
| `/feedback` | 提交反馈 |
| `/loop` | 定时循环任务 |

**学习目标**：熟练使用常用斜杠命令。

### 3.3 对话技巧

#### 有效的提示词

**好的示例**：
```
"在 src/utils/helpers.ts 中添加 formatDate 函数，接收 Date 对象返回 YYYY-MM-DD"
"这是一个 Next.js 14 项目，使用 App Router，创建对应的 API route"
"使用 TypeScript strict 模式，添加完整的类型注解"
```

**需要避免的**：
```
"帮我看看这个文件"        # 过于模糊
"修复错误"               # 缺乏上下文
"写个函数"               # 没有具体要求
```

#### 提供上下文

| 技巧 | 说明 |
|------|------|
| 指定文件路径 | 明确告诉 Claude Code 要操作哪个文件 |
| 说明技术栈 | 告知使用的框架和库 |
| 描述约束 | 如性能要求、代码规范 |
| 提供示例 | 展示期望的输入输出 |

#### 分步骤执行

对于复杂任务：
```
1. "首先了解项目结构，列出目录树"
2. "分析 api/user.ts 的主要功能"
3. "基于以上分析，列出需要修改的文件"
4. "从修改配置文件开始执行"
```

---

## 阶段七：配置与个性化

### 7.1 配置文件结构

| 位置 | 范围 | 说明 |
|------|------|------|
| `~/.claude/settings.json` | 全局 | 所有项目生效 |
| `<project>/.claude/settings.json` | 项目级 | 仅当前项目生效 |

### 7.2 基础配置项

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
  "hooks": {}
}
```

**学习目标**：理解配置文件的结构和作用。

### 7.3 权限配置

```json
{
  "permissions": {
    "allow": ["Read", "Write", "Bash", "Edit"],
    "deny": ["WebSearch", "WebFetch"]
  }
}
```

**学习目标**：根据需要配置工具权限。

### 7.4 环境变量配置

```json
{
  "env": {
    "MY_API_KEY": "secret-key",
    "NODE_ENV": "development"
  }
}
```

**用途**：
- 设置 API 密钥
- 配置环境变量
- 管理敏感信息

### 7.5 允许的工具列表

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
    "WebSearch": true
  }
}
```

---

## 阶段八：高级特性

### 8.1 MCP 服务器

#### 什么是 MCP

Model Context Protocol (MCP) 是一种开放协议，使 AI 应用能够连接到外部数据源和工具。

#### MCP 配置示例

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/path/to/dir"]
    },
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

#### 常用 MCP 服务器

| 服务器 | 功能 |
|--------|------|
| `server-filesystem` | 文件系统访问 |
| `server-github` | GitHub API 操作 |
| `server-memory` | 持久化记忆 |
| `server-slack` | Slack 集成 |
| `server-brave-search` | 网页搜索 |

**学习目标**：
- 理解 MCP 协议的作用
- 能够配置 MCP 服务器
- 根据需求扩展功能

### 8.2 Hooks 钩子机制

#### 可用的钩子类型

| 钩子 | 触发时机 | 常见用途 |
|------|----------|----------|
| `PreToolUse` | 工具执行前 | 验证、日志、拦截 |
| `PostToolUse` | 工具执行后 | 后续处理、通知 |
| `PreCommand` | 命令执行前 | 环境检查、准备 |
| `PostCommand` | 命令执行后 | 格式化输出、通知 |

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
      "description": "记录开始"
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

**学习目标**：
- 理解 Hook 的工作原理
- 能够配置常用钩子
- 实现自动化工作流

### 8.3 CLAUDE.md 项目文档

在项目根目录创建 `CLAUDE.md`，帮助 Claude Code 更好地理解项目：

```markdown
# 项目概述
这是一个 React + TypeScript 的电商后台管理系统

# 技术栈
- Frontend: React 18, TypeScript, Tailwind CSS
- Backend: Node.js, Express
- Database: PostgreSQL

# 代码规范
- 使用 ESLint + Prettier
- 提交信息遵循 Conventional Commits
- 所有组件使用 functional component

# 常用命令
- npm run dev: 启动开发服务器
- npm run build: 生产构建
- npm test: 运行测试
```

**学习目标**：
- 理解 CLAUDE.md 的作用
- 能够编写有效的项目文档
- 为团队共享配置

### 8.4 上下文管理

| 技巧 | 命令 | 说明 |
|------|------|------|
| 清除历史 | `/clear` | 重新开始对话 |
| 压缩上下文 | `/compact` | 保留关键信息压缩长度 |
| 引用文件 | `@file` | 明确指定相关文件 |

**学习目标**：高效管理对话上下文，避免信息丢失。

### 8.5 定时循环任务

使用 `/loop` 命令定期执行任务：

```
/loop 5m 总结最新的 AI 新闻
```

**参数**：
- 时间间隔：数字 + 单位（m=分钟，h=小时）
- 默认间隔：10分钟

**学习目标**：能够设置定时任务监控变化。

---

## 阶段九：集成与生态

### 9.1 IDE 集成

#### VS Code 集成

**安装**：
1. 打开 Extensions
2. 搜索 "Claude"
3. 安装 Anthropic 官方扩展

**功能**：

| 功能 | 说明 |
|------|------|
| Inline Chat | 在编辑器中直接对话 |
| Quick Chat | 命令面板快速呼出 |
| Code Review | 选中代码进行审查 |
| Inline Diff | 查看修改的 inline diff |

**快捷键**：

| 快捷键 | 功能 |
|--------|------|
| `Cmd/Ctrl + Shift + A` | 打开 Claude Chat |
| `Cmd/Ctrl + Shift + C` | Inline Chat |
| `Cmd/Ctrl + Shift + L` | 选中代码后审查 |

#### JetBrains 集成

**安装**：
1. Settings > Plugins
2. 搜索 "Claude"
3. 安装后重启 IDE

**功能**：与 VS Code 类似，深度集成 JetBrains 工具链。

#### 其他编辑器

| 编辑器 | 集成方式 |
|--------|----------|
| Neovim | 通过 LSP 或插件 |
| Emacs | Via MCP 或 elisp 包 |
| Zed | 内置 Claude 集成 |
| Cursor | 内置 Claude 集成 |

**学习目标**：根据使用的 IDE 配置集成。

### 9.2 GitHub 集成

#### PR 审查

```
/review
@https://github.com/user/repo/pull/123
```

Claude Code 能够：
- 分析代码变更
- 检查潜在问题
- 提出改进建议
- 评估代码质量

#### GitHub MCP 服务器

配置 `server-github` 以访问：
- 创建和管理 Issue
- 评论 PR
- 查看仓库状态

### 9.3 常用工作流集成

| 集成 | 工具/服务 |
|------|-----------|
| CI/CD | GitHub Actions, GitLab CI |
| 通知 | Slack, Discord, 钉钉 |
| 代码质量 | ESLint, Prettier, SonarQube |
| 测试 | Jest, Pytest, JUnit |

---

## 阶段十：最佳实践

### 10.1 安全最佳实践

| 实践 | 说明 |
|------|------|
| 使用环境变量 | 敏感信息不硬编码 |
| 合理配置权限 | 只启用需要的工具 |
| 代码审查 | AI 生成代码需人工审核 |
| 危险操作确认 | 执行破坏性操作前确认 |

### 10.2 效率最佳实践

| 技巧 | 说明 |
|------|------|
| 编写 CLAUDE.md | 帮助 AI 理解项目 |
| 使用上下文 | 提供相关文件和问题背景 |
| 分步骤执行 | 复杂任务分解 |
| 选择合适模型 | 简单任务用 Sonnet/Haiku |

### 10.3 提示词最佳实践

#### 清晰明确

| 不推荐 | 推荐 |
|--------|------|
| "帮我看看" | "检查 src/api/user.ts 中的错误处理逻辑" |
| "修复它" | "修复 src/utils/format.ts 中的类型错误" |
| "写代码" | "用 TypeScript 写一个深拷贝函数" |

#### 提供上下文

```
❌ "创建一个组件"
✅ "创建一个 React 组件，用于显示用户头像
   - 接收 user 对象作为 props
   - 使用 Tailwind CSS
   - 包含加载状态和错误状态"
```

#### 指定约束

```
"使用 TypeScript strict 模式"
"遵循项目的 ESLint 规则"
"保持与现有代码风格一致"
```

### 10.4 团队协作

| 实践 | 说明 |
|------|------|
| 共享 CLAUDE.md | 统一项目约定 |
| 配置模板 | 团队共享的配置文件 |
| 代码规范 | 在 CLAUDE.md 中定义 |
| 文档规范 | 说明文档编写要求 |

### 7.5 常见使用场景

#### 场景 1：代码生成
```
"创建一个 React Hook useDebounce，延迟指定毫秒后执行"
```

#### 场景 2：代码审查
```
"/review"
分析 src/components/UserProfile.tsx 的代码质量和潜在问题
```

#### 场景 3：调试问题
```
npm run dev 报错了，请帮忙看看
[粘贴错误信息]
```

#### 场景 4：项目初始化
```
"创建一个新的 Express + TypeScript REST API 项目"
```

#### 场景 5：批量修改
```
"/batch 将所有 React class 组件迁移到 functional component"
```

#### 场景 6：文档生成
```
"为这个函数生成 JSDoc 注释"
```

#### 场景 7：测试编写
```
"为 src/utils/format.ts 中的函数编写单元测试"
```

#### 场景 8：自动化工作流
```
"运行 prettier 格式化代码，然后运行 eslint 检查"
```

---

## 阶段十一：Rule 规则系统

### 11.1 什么是 Rule

Rule（规则）是 Claude Code 中的**始终遵循的指南系统**，用于定义项目级或全局的编码标准、约定和检查清单。

**核心特点**：

| 特性 | 说明 |
|------|------|
| **强制执行** | Rules 是 Claude Code 工作时始终遵循的行为准则 |
| **分层配置** | 支持全局级、项目级、语言特定级配置 |
| **Markdown 格式** | 使用 Markdown 编写，支持 YAML frontmatter |
| **自动应用** | Claude Code 自动读取并遵循规则 |

**学习目标**：理解 Rule 的概念和作用。

### 11.2 Rule 与 CLAUDE.md 的区别

| 特性 | CLAUDE.md | Rules |
|------|-----------|-------|
| **用途** | 项目上下文和通用指导 | 具体的行为标准和强制规则 |
| **范围** | 项目概述、工作流程、架构说明 | 编码风格、安全要求、测试标准 |
| **粒度** | 粗粒度、概述性 | 细粒度、可检查的具体要求 |
| **语言** | 自然语言描述 | Markdown 格式，包含代码示例 |
| **组织** | 单个文件 | 分层目录结构（common + 语言特定） |
| **优先级** | 一般指导 | **强制执行** |

**最佳实践**：
- CLAUDE.md 用于项目概述和上下文
- Rules 用于具体的编码规范和检查清单
- 两者配合使用效果最佳

### 11.3 Rule 的目录结构

```
rules/
├── common/              # 通用规则（适用于所有项目）
│   ├── coding-style.md      # 编码风格
│   ├── security.md          # 安全指南
│   ├── testing.md           # 测试要求
│   ├── patterns.md          # 设计模式
│   ├── git-workflow.md      # Git 工作流
│   ├── hooks.md             # 钩子配置
│   ├── development-workflow.md  # 开发流程
│   └── performance.md       # 性能优化
├── typescript/          # TypeScript/JavaScript 特定
├── python/              # Python 特定
├── golang/              # Go 特定
├── rust/                # Rust 特定
├── java/                # Java 特定
└── ...                  # 其他语言
```

**优先级规则**：语言特定规则 > 通用规则

### 11.4 配置文件位置

| 位置 | 范围 | 说明 |
|------|------|------|
| `~/.claude/rules/` | 全局 | 所有项目生效 |
| `<project>/.claude/rules/` | 项目级 | 仅当前项目生效 |

**安装命令**：
```bash
# 全局安装
cp -r rules/common ~/.claude/rules/common
cp -r rules/typescript ~/.claude/rules/typescript

# 项目级安装
mkdir -p .claude/rules
cp -r rules/common .claude/rules/
```

### 11.5 语法格式

Rules 使用 Markdown 格式，支持 YAML frontmatter 定义路径匹配：

```markdown
---
paths:
  - "**/*.ts"
  - "**/*.tsx"
  - "**/*.js"
  - "**/*.jsx"
---
# TypeScript/JavaScript Coding Style

> This file extends [common/coding-style.md](../common/coding-style.md)
> with TypeScript/JavaScript specific content.

## Types and Interfaces

Use types to make public APIs explicit.
```

**编写规范**：
1. **通用规则**（common/）：不包含语言特定的代码示例
2. **语言特定规则**：必须引用对应的 common 规则
3. **文件命名**：小写字母，用连字符分隔

### 11.6 常用规则类型

#### 11.6.1 编码风格规则

**Common 编码风格**（`common/coding-style.md`）：

```markdown
# Coding Style

## Immutability (CRITICAL)

ALWAYS create new objects, NEVER mutate existing ones:

```
// Pseudocode
WRONG:  modify(original, field, value) → changes original in-place
CORRECT: update(original, field, value) → returns new copy with change
```

## File Organization

MANY SMALL FILES > FEW LARGE FILES:
- High cohesion, low coupling
- 200-400 lines typical, 800 max

## Error Handling

ALWAYS handle errors comprehensively:
- Handle errors explicitly at every level
- Never silently swallow errors
```

**TypeScript 特定规则**：

```markdown
## Types and Interfaces

Use types to make public APIs, shared models, and component props explicit.

```typescript
// WRONG: Exported function without explicit types
export function formatUser(user) {
  return `${user.firstName} ${user.lastName}`
}

// CORRECT: Explicit types on public APIs
interface User {
  firstName: string
  lastName: string
}

export function formatUser(user: User): string {
  return `${user.firstName} ${user.lastName}`
}
```

## Avoid `any`

- Avoid `any` in application code
- Use `unknown` for external or untrusted input, then narrow it safely
```

**Python 特定规则**：

```markdown
## Standards

- Follow **PEP 8** conventions
- Use **type annotations** on all function signatures

## Immutability

Prefer immutable data structures:

```python
from dataclasses import dataclass

@dataclass(frozen=True)
class User:
    name: str
    email: str
```

## Formatting

- **black** for code formatting
- **isort** for import sorting
- **ruff** for linting
```

**Go 特定规则**：

```markdown
## Formatting

- **gofmt** and **goimports** are mandatory — no style debates

## Error Handling

Always wrap errors with context:

```go
if err != nil {
    return fmt.Errorf("failed to create user: %w", err)
}
```
```

#### 11.6.2 安全规则

**Common 安全规则**（`common/security.md`）：

```markdown
# Security Guidelines

## Mandatory Security Checks

Before ANY commit:
- [ ] No hardcoded secrets (API keys, passwords, tokens)
- [ ] All user inputs validated
- [ ] SQL injection prevention (parameterized queries)
- [ ] XSS prevention (sanitized HTML)
- [ ] CSRF protection enabled
- [ ] Authentication/authorization verified
- [ ] Rate limiting on all endpoints
- [ ] Error messages don't leak sensitive data

## Secret Management

- NEVER hardcode secrets in source code
- ALWAYS use environment variables or a secret manager
- Validate that required secrets are present at startup

## Security Response Protocol

If security issue found:
1. STOP immediately
2. Use **security-reviewer** agent
3. Fix CRITICAL issues before continuing
4. Rotate any exposed secrets
5. Review entire codebase for similar issues
```

#### 11.6.3 测试规则

**Common 测试规则**（`common/testing.md`）：

```markdown
# Testing Requirements

## Minimum Test Coverage: 80%

Test Types (ALL required):
1. **Unit Tests** - Individual functions, utilities, components
2. **Integration Tests** - API endpoints, database operations
3. **E2E Tests** - Critical user flows

## Test-Driven Development

MANDATORY workflow:
1. Write test first (RED)
2. Run test - it should FAIL
3. Write minimal implementation (GREEN)
4. Run test - it should PASS
5. Refactor (IMPROVE)
6. Verify coverage (80%+)
```

#### 11.6.4 Git 工作流规则

**Common Git 规则**（`common/git-workflow.md`）：

```markdown
# Git Workflow

## Commit Message Format

<type>: <description>

<optional body>

Types: feat, fix, refactor, docs, test, chore, perf, ci

## Pull Request Workflow

When creating PRs:
1. Analyze full commit history (not just latest commit)
2. Use `git diff [base-branch]...HEAD` to see all changes
3. Draft comprehensive PR summary
4. Include test plan with TODOs
5. Push with `-u` flag if new branch
```

### 11.7 Rule、Hooks、Permissions 的区别与联系

#### 功能对比

| 特性 | Rules | Hooks | Permissions |
|------|-------|-------|-------------|
| **触发时机** | 始终生效 | 工具执行前后/会话结束 | 工具调用时 |
| **配置方式** | Markdown 文件 | JSON 配置文件 | settings.json |
| **用途** | 定义行为标准 | 自动化任务执行 | 控制工具访问 |
| **执行方式** | Claude Code 自动遵循 | 运行外部脚本/命令 | 阻止/允许执行 |
| **示例** | "80%测试覆盖率" | "编辑后自动格式化" | "禁止使用 Bash rm -rf" |

#### 三者协同关系

```
┌─────────────────────────────────────────────────────────────┐
│                    Claude Code Session                       │
├─────────────────────────────────────────────────────────────┤
│  Permissions ──────► 阻止/允许工具执行                      │
│         │                                                   │
│         ▼                                                   │
│  Rules ───────────► 定义工作时的行为标准                     │
│         │           （编码风格、安全检查、测试要求）           │
│         │                                                   │
│         ▼                                                   │
│  Hooks ───────────► 工具执行前后触发自动化                   │
│                    （格式化、验证、通知）                     │
└─────────────────────────────────────────────────────────────┘
```

#### 实际工作流程示例

1. **Permissions** 阻止执行危险命令（如 `rm -rf /`）
2. **Rules** 指导遵循编码规范（TypeScript 使用显式类型）
3. **Hooks** 在编辑文件后自动运行格式化工具

### 11.8 创建自定义 Rule

**步骤 1：创建目录结构**
```bash
mkdir -p .claude/rules/common
mkdir -p .claude/rules/typescript
```

**步骤 2：编写规则文件**
```bash
# .claude/rules/common/coding-style.md
---
paths:
  - "**/*"
---
# Coding Style Guidelines

## Naming Conventions

- Use camelCase for variables and functions
- Use PascalCase for classes and components
- Use UPPER_SNAKE_CASE for constants
```

**步骤 3：使用 /rules-distill 命令**

从 Skills 中提取规则：
```
/rules-distill
```

### 11.9 Rule 练习

**练习任务**：
1. 创建项目的 `.claude/rules/` 目录
2. 编写一个 `coding-style.md` 规则文件
3. 编写一个 `testing.md` 规则文件
4. 测试 Claude Code 是否遵循这些规则

**进阶任务**：
1. 为 TypeScript 项目创建完整的规则集
2. 为团队创建通用的安全规则
3. 配置 Git 工作流规则

---

## 附录：参考资料

### 官方资源

| 资源 | 链接 |
|------|------|
| Claude Code 官方文档 | https://code.claude.com/docs |
| Claude API 文档 | https://docs.anthropic.com |
| MCP 协议 | https://modelcontextprotocol.io |
| Anthropic 官网 | https://www.anthropic.com |

### GitHub

| 资源 | 链接 |
|------|------|
| Claude Code 仓库 | https://github.com/anthropics/claude-code |
| MCP 服务器集合 | https://github.com/modelcontextprotocol/servers |

### 学习路径建议

| 阶段 | 预计时间 | 重点 |
|------|----------|------|
| 阶段一：入门基础 | 1天 | 安装、基本交互 |
| 阶段二：核心功能 | 2-3天 | 文件操作、代码生成 |
| 阶段三：Agent 智能体 | 1-2天 | 并行处理、任务分配 |
| 阶段四：Skill 技能 | 1-2天 | 批量任务、定时循环 |
| 阶段五：斜杠命令与交互 | 1天 | 快捷命令、对话技巧 |
| 阶段六：工具详解 | 2-3天 | Read/Edit/Grep/Glob |
| 阶段七：配置与个性化 | 1-2天 | 配置文件、权限 |
| 阶段八：高级特性 | 3-5天 | MCP、Hooks、CLAUDE.md |
| 阶段九：集成与生态 | 2-3天 | IDE 集成、团队协作 |
| 阶段十：最佳实践 | 持续 | 不断优化和改进 |
| 阶段十一：Rule 规则系统 | 2-3天 | 编码规范、安全规则 |

### 版本历史

| 版本 | 日期 | 更新内容 |
|------|------|----------|
| 1.0 | 2026-03-28 | 初始版本，包含基础内容 |
| 1.1 | 2026-03-28 | 新增 Agent、Skill、Commands 详细教程 |
| 1.2 | 2026-03-28 | 新增 Rule 规则系统完整教程 |

---

*本大纲由 Claude Code 生成，旨在帮助开发者系统学习 Claude Code 工具。*
