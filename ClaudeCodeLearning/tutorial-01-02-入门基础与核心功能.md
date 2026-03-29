# 阶段一&二：入门基础 + 核心功能

> 本教程将带你从零开始掌握 Claude Code，从安装启动到核心文件操作，循序渐进打好基础。

---

## 目录

- [阶段一&二：入门基础 + 核心功能](#阶段一二入门基础--核心功能)
  - [目录](#目录)
  - [第一章：Claude Code 概述](#第一章claude-code-概述)
    - [1.1 什么是 Claude Code](#11-什么是-claude-code)
    - [1.2 核心定位与价值](#12-核心定位与价值)
    - [1.3 能做什么——典型场景](#13-能做什么典型场景)
  - [第二章：安装与启动](#第二章安装与启动)
    - [2.1 环境要求](#21-环境要求)
    - [2.2 安装方式](#22-安装方式)
    - [2.3 启动模式](#23-启动模式)
    - [2.4 退出方式](#24-退出方式)
  - [第三章：基础交互与模式](#第三章基础交互与模式)
    - [3.1 交互模式详解](#31-交互模式详解)
    - [3.2 命令行参数](#32-命令行参数)
    - [3.3 模型选择](#33-模型选择)
    - [3.4 环境变量配置](#34-环境变量配置)
  - [第四章：核心功能——文件操作](#第四章核心功能文件操作)
    - [4.1 文件读取 (Read)](#41-文件读取-read)
    - [4.2 文件编辑 (Edit)](#42-文件编辑-edit)
    - [4.3 文件写入 (Write)](#43-文件写入-write)
    - [4.4 文件搜索 (Glob)](#44-文件搜索-glob)
    - [4.5 内容搜索 (Grep)](#45-内容搜索-grep)
  - [第五章：终端与 Git 操作](#第五章终端与-git-操作)
    - [5.1 Bash 终端执行](#51-bash-终端执行)
    - [5.2 Git 基础操作](#52-git-基础操作)
    - [5.3 实用的 Git 工作流](#53-实用的-git-工作流)
  - [第六章：Web 能力](#第六章web-能力)
    - [6.1 WebSearch 网络搜索](#61-websearch-网络搜索)
    - [6.2 WebFetch 网页获取](#62-webfetch-网页获取)
  - [第七章：项目分析与代码生成](#第七章项目分析与代码生成)
    - [7.1 Claude Code 如何理解项目](#71-claude-code-如何理解项目)
    - [7.2 代码生成技巧](#72-代码生成技巧)
    - [7.3 代码审查与解释](#73-代码审查与解释)
  - [实践练习](#实践练习)
    - [练习一：安装并启动](#练习一安装并启动)
    - [练习二：文件操作实战](#练习二文件操作实战)
    - [练习三：Git 工作流](#练习三git-工作流)

---

## 第一章：Claude Code 概述

### 1.1 什么是 Claude Code

Claude Code 是 Anthropic 官方推出的 **AI 编程助手**，运行在命令行界面，通过自然语言与开发者交互。

它的核心基于 Claude 大语言模型，专门针对编程场景进行了优化，能够理解代码逻辑、执行终端命令、操作文件系统。

```
┌─────────────────────────────────────────────────────────┐
│                     Claude Code                          │
│                                                         │
│  自然语言 ──► 理解意图 ──► 执行工具 ──► 返回结果        │
│                                                         │
│  工具能力：Read / Write / Edit / Bash / Git / Web       │
└─────────────────────────────────────────────────────────┘
```

### 1.2 核心定位与价值

| 维度 | 说明 |
|------|------|
| **编程辅助** | 代码生成、重构、调试、测试 |
| **终端集成** | 直接执行 shell 命令，无需切换窗口 |
| **上下文理解** | 理解整个项目结构，不只是单个文件 |
| **多工具协作** | 读写文件、执行命令、搜索网络一气呵成 |

### 1.3 能做什么——典型场景

```
📝 代码生成
   "用 TypeScript 写一个深拷贝函数"
   "创建一个 React Hook useLocalStorage"

🔍 代码审查
   "帮我审查 src/api/user.ts 的安全性"
   "检查这个函数的内存泄漏风险"

🐛 调试排错
   "npm run dev 报错了，请帮忙分析"
   [粘贴错误日志]

📦 项目初始化
   "创建一个 Express + TypeScript REST API 项目"
   "用 Vite 初始化一个 Vue 3 项目"

🧪 测试编写
   "为这个函数写单元测试，覆盖边界情况"

📚 文档生成
   "为这个组件生成 JSDoc 注释"
   "写一份 API 接口文档"

🔀 Git 操作
   "帮我创建一个规范的提交信息"
   "查看这个分支相比 main 有什么变更"
```

---

## 第二章：安装与启动

### 2.1 环境要求

- **Node.js**：v18 或更高版本
- **npm** 或 **yarn** 包管理器
- 支持的操作系统：macOS、Linux、Windows (WSL)

### 2.2 安装方式

**方式一：npm 全局安装（推荐）**

```bash
npm install -g @anthropic-ai/claude-code
```

**方式二：验证安装**

```bash
# 检查版本
claude --version

# 查看帮助
claude --help
```

### 2.3 启动模式

Claude Code 支持多种启动模式：

#### 交互模式（最常用）

```bash
claude
```

进入交互式对话界面，可以连续对话：

```
$ claude
Welcome to Claude Code. Type /help for available commands.

You: 帮我创建一个 hello.py 文件
Claude: [创建文件...]

You: 添加一个打印九九乘法表的功能
Claude: [编辑文件...]
```

#### 单次命令模式

```bash
claude "你的指令"
```

执行完指令后自动退出，适合脚本调用：

```bash
claude "创建一个计算器组件"
claude "解释 src/utils/format.ts 的作用"
```

#### 安静模式

```bash
claude --quiet "指令"
```

减少不必要的输出，只返回核心结果：

```bash
claude --quiet "解释这段代码的作用"
# 直接输出解释，不显示思考过程
```

#### 指定模型

```bash
# 使用 Opus（最强大）
claude --model opus "设计一个微服务架构"

# 使用 Sonnet（平衡，推荐默认）
claude --model sonnet "修复这个 bug"

# 使用 Haiku（快速）
claude --model haiku "添加一行注释"
```

#### 只打印模式

```bash
claude --print-only "指令"
```

不进入交互模式，直接打印结果后退出：

```bash
claude --print-only "生成一个 loading 组件"
```

#### 指定项目目录

```bash
cd /path/to/project
claude
# Claude Code 自动识别当前目录作为项目根目录
```

### 2.4 退出方式

```bash
# 方式一：输入命令
exit
# 或
quit

# 方式二：快捷键
Ctrl+C  (按两次)
```

---

## 第三章：基础交互与模式

### 3.1 交互模式详解

**交互模式的工作流程：**

```
用户输入 ──► Claude Code 理解 ──► 调用工具 ──► 返回结果 ──► 等待下一轮输入
```

**交互模式的优势：**
- 可以多轮对话，逐步完善需求
- 上下文自动保留，便于复杂任务
- 可以中途调整方向

### 3.2 命令行参数完整列表

| 参数 | 说明 | 示例 |
|------|------|------|
| 无参数 | 进入交互模式 | `claude` |
| `--model <model>` | 选择模型 | `claude --model opus` |
| `--quiet` | 安静模式，减少输出 | `claude --quiet "..."` |
| `--print-only` | 只打印结果不交互 | `claude --print-only "..."` |
| `--verbose` | 详细输出（调试用） | `claude --verbose "..."` |
| `--version` | 显示版本 | `claude --version` |
| `--help` | 显示帮助 | `claude --help` |

### 3.3 模型选择

| 模型 | 适用场景 | 推荐度 |
|------|----------|--------|
| **opus** | 复杂架构设计、大规模重构、深度代码分析 | ⭐⭐⭐ |
| **sonnet** | 日常编程任务（**推荐默认**） | ⭐⭐⭐⭐⭐ |
| **haiku** | 简单快速任务、代码注释、格式化 | ⭐⭐⭐ |

**选择建议：**

```
简单任务（< 5分钟）
  └── Haiku：快速响应，节省成本

日常开发
  └── Sonnet：平衡性能和效果

复杂任务（架构设计、大规模重构）
  └── Opus：深度思考，能力最强
```

**在对话中切换模型：**

```bash
/model opus   # 切换到 Opus
/model sonnet # 切换到 Sonnet
/model haiku  # 切换到 Haiku
```

### 3.4 环境变量配置

在 `~/.claude/settings.json` 中配置：

```json
{
  "env": {
    "ANTHROPIC_AUTH_TOKEN": "your-api-token",
    "ANTHROPIC_BASE_URL": "http://127.0.0.1:15721"
  }
}
```

**获取 API Token：**
1. 访问 [ Anthropic Console ](https://console.anthropic.com/)
2. 创建 API Key
3. 妥善保存，不要泄露

---

## 第四章：核心功能——文件操作

Claude Code 内置了强大的文件操作工具，是日常开发中最常用的功能。

### 4.1 文件读取 (Read)

**功能：** 读取文件内容，支持大文件分页

**基本语法：**

```
Read:
  file_path: "/path/to/file"
  limit: 100      # 可选，限制读取行数
  offset: 0       # 可选，从第几行开始
```

**使用示例：**

```
# 读取整个文件
"请读取 src/utils/helpers.ts 文件"

# 读取前 50 行
"读取 package.json 的前 50 行"

# 读取指定范围
"读取 src/App.tsx 第 100-150 行"
```

**实际使用场景：**

```bash
# 让 Claude Code 分析代码
"分析 src/api/user.ts 中的认证逻辑"

# 查看错误日志
"读取 /var/log/error.log 最后 100 行"

# 查看配置
"帮我检查 tsconfig.json 的编译选项"
```

### 4.2 文件编辑 (Edit)

**功能：** 精确修改文件的特定部分

**基本语法：**

```
Edit:
  file_path: "/path/to/file"
  old_string: "要替换的原文"
  new_string: "替换后的内容"
  replace_all: false  # 是否全部替换
```

**编辑技巧：**

#### 技巧一：提供足够的上下文

```bash
# ❌ 不好：上下文不足，可能匹配到多处
old_string: "return result"

# ✅ 好：提供足够的上下文确保唯一匹配
old_string: "function calculateSum(arr) {\n  return result\n}"
```

#### 技巧二：包含缩进和换行

```bash
# 包含缩进
old_string: "  const name = 'test'\n  console.log(name)"

# 包含换行符 \n
```

#### 技巧三：使用 replace_all 批量替换

```bash
# 单次替换
Edit: old_string="var " new_string="let " replace_all=false

# 全部替换
Edit: old_string="console.log" new_string="logger.info" replace_all=true
```

**常见编辑场景：**

```bash
# 添加代码
"在 calculateSum 函数后添加一个新函数 calculateAverage"

# 修改代码
"将这里的 for 循环改写成 while 循环"

# 删除代码
"删除这段注释代码"

# 重命名
"将变量名 userName 改名为 fullName"
```

### 4.3 文件写入 (Write)

**功能：** 创建新文件或完整覆盖已有文件

**基本语法：**

```
Write:
  file_path: "/path/to/file"
  content: "文件内容"
```

**使用场景：**

```bash
# 创建新组件
"创建一个 React 组件 src/components/Button.tsx"

# 创建配置文件
"创建一个 tsconfig.json"

# 创建测试文件
"为 src/utils/format.ts 创建单元测试"
```

**注意事项：**

> ⚠️ Write 会完全覆盖文件内容！如果只想修改部分内容，请使用 Edit。

```bash
# ❌ 危险：会覆盖整个文件
"写入新的 package.json"

# ✅ 安全：先读取，修改后再写入
"读取现有的 package.json，然后添加一个新脚本"
```

### 4.4 文件搜索 (Glob)

**功能：** 使用 glob 模式匹配查找文件

**基本语法：**

```
Glob:
  pattern: "**/*.ts"     # 匹配模式
  path: "/path/to/dir"   # 搜索目录（可选）
```

**常用模式：**

| 模式 | 含义 | 示例 |
|------|------|------|
| `*.ts` | 根目录的 .ts 文件 | `package.json` |
| `**/*.ts` | 所有 .ts 文件（递归） | `src/a.ts`, `src/b/c.ts` |
| `src/**/*` | src 目录下所有文件 | |
| `**/index.*` | 所有名为 index 的文件 | |
| `!*.test.ts` | 排除测试文件 | |

**使用示例：**

```bash
# 查找所有 TypeScript 文件
"找出项目中所有的 .ts 文件"

# 查找组件文件
"查找 src/components 下的所有组件"

# 查找配置文件
"列出根目录下的所有配置文件"

# 排除测试文件
"找出 src 下的业务代码（排除测试）"
```

**实际应用：**

```bash
# 批量修改前的调研
"用 Glob 找出所有需要迁移的 React class 组件"

# 了解项目结构
"用 Glob 展示项目的完整目录结构"
```

### 4.5 内容搜索 (Grep)

**功能：** 正则表达式搜索文件内容

**基本语法：**

```
Grep:
  path: "/path/to/dir"           # 搜索目录
  pattern: "正则表达式"            # 搜索模式
  output_mode: "content"         # 输出模式
  context: 3                     # 显示上下文行数
```

**输出模式：**

| 模式 | 说明 |
|------|------|
| `content` | 显示匹配行的内容和行号 |
| `files_with_matches` | 只返回文件名 |
| `count` | 返回匹配次数 |

**常用示例：**

```bash
# 搜索函数定义
"用 Grep 搜索所有 useEffect 的调用"

# 搜索敏感信息（安全检查）
"搜索代码中是否有 hardcoded 的 API key"

# 正则搜索
"用正则搜索所有邮箱格式的字符串"

# 排除文件类型
"在 src 目录下搜索，排除 node_modules 和测试文件"
```

**高级用法：**

```bash
# 搜索并显示上下文
"搜索 getUser 函数，显示前后各 3 行代码"

# 多模式搜索
"搜索包含 'TODO' 或 'FIXME' 的代码"

# 搜索特定文件类型
"只搜索 .ts 和 .tsx 文件中的 'export default'"
```

---

## 第五章：终端与 Git 操作

### 5.1 Bash 终端执行

**功能：** 执行 shell 命令

**使用场景：**

```bash
# 安装依赖
"运行 npm install 安装依赖"

# 构建项目
"执行 npm run build 构建项目"

# 运行脚本
"执行 npm run test 运行测试"

# 启动服务
"在 3000 端口启动开发服务器"
```

**常用命令：**

```bash
# 包管理器
npm install / yarn add / pnpm add
npm run dev / npm start / npm test
npm run build

# 文件操作
ls -la / mkdir -p / rm -rf
cp -r / mv / cat

# Git 操作（详见下一节）
git status / git add / git commit
```

**实用技巧：**

```bash
# 组合命令
"先安装依赖，然后运行构建"

# 后台运行
"在后台启动开发服务器"

# 查看输出
"运行测试并查看测试覆盖率"
```

### 5.2 Git 基础操作

Claude Code 可以帮助你完成大多数 Git 操作：

| 操作 | Claude Code 能做什么 |
|------|---------------------|
| 查看状态 | `git status` 并解释当前状态 |
| 查看差异 | `git diff` 并解释变更内容 |
| 查看历史 | `git log` 并总结提交历史 |
| 创建提交 | 生成规范的提交信息 |
| 分支管理 | 创建、切换、删除分支 |
| 冲突解决 | 帮助理解和解决合并冲突 |

**使用示例：**

```bash
# 查看当前状态
"运行 git status 并解释当前状态"

# 查看变更
"用 git diff 查看有哪些文件被修改了"

# 创建提交
"帮我创建一个提交，描述刚才的修改"
# Claude 会自动分析变更并生成规范的提交信息

# 分支操作
"创建一个新分支 feature/user-auth"

# 查看历史
"查看最近 10 个提交并总结"
```

### 5.3 实用的 Git 工作流

**工作流一：日常开发提交流程**

```bash
# 1. 查看当前状态
"git status"

# 2. 查看变更内容
"git diff"

# 3. 添加文件
"git add src/"

# 4. 创建提交（Claude 自动生成规范信息）
"创建一个提交，描述新增了用户认证功能"
```

**工作流二：PR 前的代码审查**

```bash
# 1. 查看分支差异
"对比 feature/login 和 main 分支的差异"

# 2. 审查代码质量
"审查 feature/login 分支的代码"

# 3. 运行测试
"确保 feature/login 分支所有测试通过"
```

**工作流三：解决合并冲突**

```bash
# 1. 查看冲突文件
"列出所有冲突文件"

# 2. 分析冲突原因
"分析 src/a.ts 和 src/b.ts 的冲突"

# 3. 解决冲突
"帮我解决这些冲突，保留两边的合理修改"
```

---

## 第六章：Web 能力

### 6.1 WebSearch 网络搜索

**功能：** 搜索网络获取最新信息

**使用场景：**

```bash
# 搜索最新技术
"搜索 React 19 的新特性"

# 查找解决方案
"搜索如何解决 npm install 报错 EACCES"

# 获取官方文档
"搜索 TypeScript 5.0 的官方文档"
```

**注意事项：**

> WebSearch 会使用搜索引擎，可能需要几秒钟。适合获取实时信息。

### 6.2 WebFetch 网页获取

**功能：** 获取指定网页的完整内容

**使用场景：**

```bash
# 获取官方文档
"获取 https://react.dev/docs 的内容"

# 提取文章信息
"获取这篇博客文章的主要内容"

# 查阅 API 文档
"获取某个 npm 包的使用文档"
```

---

## 第七章：项目分析与代码生成

### 7.1 Claude Code 如何理解项目

Claude Code 会自动分析项目结构：

```
项目根目录
├── src/                 # 源代码
├── tests/               # 测试文件
├── docs/                # 文档
├── package.json         # 项目配置
├── tsconfig.json        # TS 配置
└── CLAUDE.md           # 项目说明文档（可选）
```

**帮助 Claude 更好地理解项目：**

```bash
# 方式一：直接说明
"这是一个 Next.js 14 App Router 项目"

# 方式二：创建 CLAUDE.md
"帮我创建一个 CLAUDE.md 文档描述这个项目"
```

### 7.2 代码生成技巧

**技巧一：提供具体的需求**

```bash
# ❌ 模糊
"创建一个工具函数"

# ✅ 明确
"创建一个 formatDate 函数，接收 Date 对象，输出格式 YYYY-MM-DD HH:mm:ss"
```

**技巧二：指定技术栈和约束**

```bash
"用 TypeScript strict 模式写一个深拷贝函数"
"创建一个 React Hook，要求：
 - 接受 key 和初始值
 - 自动同步 localStorage
 - 返回 [value, setValue]"
```

**技巧三：提供示例**

```bash
"创建一个九九乘法表的生成函数
 示例输入：9
 示例输出：
 1x1=1
 1x2=2 2x2=4
 1x3=3 2x3=6 3x3=9"
```

### 7.3 代码审查与解释

```bash
# 解释代码逻辑
"解释 src/utils/algorithm.ts 中的排序算法"

# 审查代码质量
"审查 src/api/user.ts，关注：
 - 安全性
 - 错误处理
 - 性能问题"

# 找出潜在问题
"检查这段代码有没有内存泄漏风险"
```

---

## 实践练习

### 练习一：安装并启动

**目标：** 完成 Claude Code 的安装和基础操作

**任务清单：**

1. ✅ 检查 Node.js 环境
   ```bash
   node --version  # 需要 v18+
   npm --version
   ```

2. ✅ 安装 Claude Code
   ```bash
   npm install -g @anthropic-ai/claude-code
   ```

3. ✅ 启动交互模式
   ```bash
   claude
   ```

4. ✅ 尝试各种模式
   ```bash
   claude --print-only "你好，这是一个测试"
   claude --model haiku "快速回答：什么是 TypeScript"
   claude --help
   ```

5. ✅ 切换模型
   ```
   /model opus
   /model sonnet
   /model haiku
   ```

### 练习二：文件操作实战

**目标：** 掌握 Claude Code 的文件操作能力

**任务清单：**

1. ✅ 创建新文件
   ```
   "创建一个 hello.py 文件，内容是打印 Hello World"
   ```

2. ✅ 读取文件
   ```
   "读取刚才创建的 hello.py 文件"
   ```

3. ✅ 编辑文件
   ```
   "在 hello.py 中添加一个函数，计算两个数的和"
   ```

4. ✅ 文件搜索
   ```
   "用 Glob 搜索当前目录下所有 .py 文件"
   ```

5. ✅ 内容搜索
   ```
   "用 Grep 搜索 hello.py 中的 def 关键字"
   ```

### 练习三：Git 工作流

**目标：** 体验 Claude Code 辅助的 Git 操作

**任务清单：**

1. ✅ 查看状态
   ```
   "运行 git status"
   ```

2. ✅ 查看差异
   ```
   "运行 git diff 查看变更"
   ```

3. ✅ 创建提交
   ```
   "创建一个提交，使用规范的提交信息"
   ```

4. ✅ 查看历史
   ```
   "查看最近 5 个提交并总结"
   ```

---

## 下一步

完成本教程后，你已经掌握了 Claude Code 的基础能力。接下来可以学习：

- **阶段三：Agent 智能体** — 如何并行处理复杂任务
- **阶段四：Skill 技能** — 使用内置技能提升效率
- **阶段五：斜杠命令** — 熟练使用快捷命令

---

*本教程是 Claude Code 系统学习系列的第一部分。*
