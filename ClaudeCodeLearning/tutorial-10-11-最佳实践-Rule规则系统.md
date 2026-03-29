# 阶段十至十一：最佳实践 + Rule 规则系统

> 本教程涵盖 Claude Code 的最佳实践指南和 Rule 规则系统，帮助你在团队中建立统一的编码标准。

---

## 目录

- [阶段十至十一：最佳实践 + Rule 规则系统](#阶段十至十一最佳实践--rule-规则系统)
  - [目录](#目录)
  - [第一章：最佳实践](#第一章最佳实践)
    - [1.1 安全最佳实践](#11-安全最佳实践)
    - [1.2 效率最佳实践](#12-效率最佳实践)
    - [1.3 提示词最佳实践](#13-提示词最佳实践)
    - [1.4 团队协作最佳实践](#14-团队协作最佳实践)
    - [1.5 常见使用场景](#15-常见使用场景)
  - [第二章：Rule 规则系统](#第二章rule-规则系统)
    - [2.1 什么是 Rule](#21-什么是-rule)
    - [2.2 Rule vs CLAUDE.md](#22-rule-vs-claudemd)
    - [2.3 Rule 目录结构](#23-rule-目录结构)
    - [2.4 配置文件位置](#24-配置文件位置)
    - [2.5 语法格式](#25-语法格式)
    - [2.6 常用规则类型](#26-常用规则类型)
    - [2.7 Rule、Hooks、Permissions 对比](#27-rulehookspermissions-对比)
    - [2.8 创建自定义 Rule](#28-创建自定义-rule)
  - [第三章：团队规则集](#第三章团队规则集)
    - [3.1 TypeScript 项目规则集](#31-typescript-项目规则集)
    - [3.2 Python 项目规则集](#32-python-项目规则集)
    - [3.3 Go 项目规则集](#33-go-项目规则集)
  - [实践练习](#实践练习)

---

## 第一章：最佳实践

### 1.1 安全最佳实践

安全是使用 AI 编程工具时最重要的考量。

#### 安全检查清单

| 检查项 | 说明 |
|--------|------|
| 环境变量 | 敏感信息不硬编码，使用环境变量 |
| 权限控制 | 只启用需要的工具，遵循最小权限原则 |
| 代码审查 | AI 生成代码需人工审核 |
| 危险操作确认 | 执行破坏性操作前确认 |
| 依赖安全 | 定期检查依赖漏洞 |

#### 敏感信息处理

```bash
# ❌ 危险：硬编码密钥
ANTHROPIC_API_KEY=sk-ant-xxxx

# ✅ 安全：使用环境变量
ANTHROPIC_API_KEY=$ANTHROPIC_API_KEY
```

#### 权限配置建议

```json
{
  "permissions": {
    "allow": ["Read", "Write", "Edit", "Bash", "Grep", "Glob"],
    "deny": ["WebSearch", "WebFetch"]
  }
}
```

#### AI 生成代码审查

```bash
# 始终执行以下审查
"审查刚才生成的代码，检查：
 1. 安全性（SQL注入、XSS等）
 2. 错误处理
 3. 边界情况
 4. 性能问题"
```

### 1.2 效率最佳实践

#### 提升效率的技巧

| 技巧 | 说明 | 效果 |
|------|------|------|
| 编写 CLAUDE.md | 帮助 AI 理解项目 | ⭐⭐⭐⭐⭐ |
| 提供上下文 | 明确指定文件和需求 | ⭐⭐⭐⭐⭐ |
| 分步骤执行 | 复杂任务分解 | ⭐⭐⭐⭐ |
| 选择合适模型 | 简单任务用 Sonnet/Haiku | ⭐⭐⭐ |
| 善用 Skill | 使用内置技能 | ⭐⭐⭐⭐ |
| 并行 Agent | 多任务并行处理 | ⭐⭐⭐⭐ |

#### CLAUDE.md 的价值

```
没有 CLAUDE.md：
  每个对话都需要解释：
  - 项目技术栈
  - 代码规范
  - 常用命令
  - 项目结构

有 CLAUDE.md：
  Claude 自动理解项目，直接开始工作
  节省 30%+ 的对话时间
```

### 1.3 提示词最佳实践

#### 清晰明确

| ❌ 不推荐 | ✅ 推荐 |
|---------|--------|
| "帮我看看" | "检查 src/api/user.ts 中的错误处理逻辑" |
| "修复它" | "修复 src/utils/format.ts 中的类型错误" |
| "写代码" | "用 TypeScript 写一个深拷贝函数" |
| "优化性能" | "优化 src/api/search.ts，使用缓存减少数据库查询" |

#### 提供上下文

```bash
# ❌ 模糊
"创建一个组件"

# ✅ 详细
"创建一个 React 组件 UserProfile，用于显示用户信息：
 - 接收 user: { id, name, email, avatar } 作为 props
 - 使用 Tailwind CSS 样式
 - 包含加载状态（显示 skeleton）和错误状态
 - 支持点击头像放大查看
 - 使用 TypeScript strict 模式"
```

#### 指定约束

```bash
"创建一个 HTTP 请求函数：
 - 使用 fetch API
 - 支持 timeout
 - 自动添加 Authorization header
 - 处理 401/403/500 错误
 - 返回类型使用泛型
 - 遵循项目现有的 API 风格"
```

#### 分步骤执行

对于复杂任务：

```bash
# 第一步：了解现状
"分析 src/api/ 目录下的文件结构"

# 第二步：设计方案
"基于分析，设计重构方案"

# 第三步：实施
"按照方案逐步重构"
```

### 1.4 团队协作最佳实践

#### 共享配置

| 配置项 | 共享方式 |
|--------|---------|
| CLAUDE.md | 放入代码仓库根目录 |
| Rules | 放入 `.claude/rules/` 目录 |
| settings.json | 模板放入代码仓库 |
| Hooks | 放入 `.claude/settings.json` |

#### 团队 CLAUDE.md 模板

```markdown
# [项目名称] - 团队规范

## 项目概述
[描述项目]

## 技术栈
- 前端：React 18 + TypeScript
- 后端：Node.js + Express
- 数据库：PostgreSQL

## 代码规范
- TypeScript strict 模式
- ESLint + Prettier
- 提交信息遵循 Conventional Commits
- 组件使用 functional component + Hooks

## Git 工作流
1. 从 main 创建功能分支
2. 开发完成后创建 PR
3. 需要至少 1 人 review
4. CI 通过后才能合并

## 安全要求
- 不在代码中硬编码密钥
- 所有 API 调用使用 HTTPS
- 用户输入必须验证
```

### 1.5 常见使用场景

#### 场景一：代码生成

```bash
# 基础
"创建一个 React Hook useDebounce，延迟指定毫秒后执行"

# 详细需求
"创建一个 React Hook useDebounce：
 - 接收 value 和 delay 参数
 - 返回防抖后的值
 - 使用 useEffect + setTimeout
 - 包含 cleanup
 - 编写 TypeScript 类型定义
 - 添加 JSDoc 注释"
```

#### 场景二：代码审查

```bash
# 基础
/review src/components/UserProfile.tsx

# 详细
"审查 src/api/user.ts：
 - 安全性（SQL注入、XSS、CSRF）
 - 错误处理
 - 输入验证
 - 性能问题
 - 代码可读性
 - 是否有硬编码信息"
```

#### 场景三：调试问题

```bash
# 提供错误信息
"npm run dev 报错了，请帮忙看看：
[错误日志]
/path/to/project/node_modules/vite/dist/node/index.js:21742:11: error: Failed to parse source

# 给出上下文
这是新克隆的项目，还没有安装依赖"
```

#### 场景四：项目初始化

```bash
# 完整需求
"创建一个新的 Express + TypeScript REST API 项目：
 - 使用 Express + TypeScript
 - 添加 ESLint + Prettier
 - 配置 Jest 测试
 - 创建标准目录结构
 - 包含用户 CRUD API 示例
 - 添加 Docker 配置
 - 编写 README"
```

#### 场景五：批量修改

```bash
# 批量迁移
/batch 将所有 React class 组件迁移到 functional component

# 批量添加类型
/batch 为所有 JavaScript 文件添加 TypeScript 类型定义

# 批量重构
/batch 将所有 callback 风格代码改写成 async/await"
```

#### 场景六：文档生成

```bash
# JSDoc
"为 src/utils/format.ts 中的所有函数生成 JSDoc 注释"

# API 文档
"为这个 Express 项目生成 API 文档（使用 OpenAPI 格式）"

# README 更新
"检查并更新项目 README，补充缺失的信息"
```

#### 场景七：测试编写

```bash
# 基础
"为 src/utils/format.ts 中的函数编写单元测试"

# 详细
"为 src/utils/format.ts 中的函数编写单元测试：
 - 测试所有公开函数
 - 包含边界情况
 - 使用 Jest
 - 覆盖率目标 80%+
 - 包含 describe 和 it 块"
```

#### 场景八：自动化工作流

```bash
# 组合命令
"运行 prettier 格式化代码，然后运行 eslint 检查，最后运行测试"

# CI 检查
"检查代码是否满足 CI 要求：
 - ESLint 通过
 - TypeScript 编译通过
 - 测试通过
 - 覆盖率达标"
```

---

## 第二章：Rule 规则系统

### 2.1 什么是 Rule

Rule 是 Claude Code 中的**强制执行指南系统**，用于定义项目级或全局的编码标准、约定和检查清单。

```
┌─────────────────────────────────────────────────────────────┐
│                      Rules 系统                              │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  rules/                                                     │
│  ├── common/              # 通用规则（所有项目）            │
│  │   ├── coding-style.md                                   │
│  │   ├── security.md                                       │
│  │   └── testing.md                                        │
│  │                                                           │
│  ├── typescript/          # TypeScript 特定规则              │
│  ├── python/              # Python 特定规则                  │
│  └── golang/              # Go 特定规则                      │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

#### Rule 的核心特点

| 特性 | 说明 |
|------|------|
| **强制执行** | Rules 是 Claude Code 工作时始终遵循的行为准则 |
| **分层配置** | 支持全局级、项目级、语言特定级配置 |
| **Markdown 格式** | 使用 Markdown 编写，支持 YAML frontmatter |
| **自动应用** | Claude Code 自动读取并遵循规则 |
| **优先级** | 语言特定规则 > 通用规则 |

### 2.2 Rule vs CLAUDE.md

| 特性 | CLAUDE.md | Rules |
|------|-----------|-------|
| **用途** | 项目上下文和通用指导 | 具体的行为标准和强制规则 |
| **范围** | 项目概述、工作流程、架构说明 | 编码风格、安全要求、测试标准 |
| **粒度** | 粗粒度、概述性 | 细粒度、可检查的具体要求 |
| **语言** | 自然语言描述 | Markdown 格式，包含代码示例 |
| **组织** | 单个文件 | 分层目录结构（common + 语言特定）|
| **优先级** | 一般指导 | **强制执行** |
| **触发方式** | 自动读取 | 始终生效，特定路径触发 |

**最佳实践：两者配合使用**

```
CLAUDE.md ──► 项目概述和上下文
  └── 项目简介、技术栈、架构说明

Rules ──► 具体编码规范
  └── 编码风格、安全检查、测试要求
```

### 2.3 Rule 目录结构

```
rules/
├── common/                      # 通用规则（适用于所有项目）
│   ├── coding-style.md          # 编码风格
│   ├── security.md              # 安全指南
│   ├── testing.md              # 测试要求
│   ├── patterns.md             # 设计模式
│   ├── git-workflow.md         # Git 工作流
│   ├── hooks.md                # 钩子配置
│   ├── development-workflow.md # 开发流程
│   └── performance.md          # 性能优化
│
├── typescript/                  # TypeScript/JavaScript 特定
│   ├── coding-style.md         # 继承 common/coding-style
│   ├── types.md                # 类型规范
│   └── react.md                # React 规范
│
├── python/                      # Python 特定
│   ├── coding-style.md
│   ├── types.md
│   └── django.md
│
├── golang/                      # Go 特定
│   ├── coding-style.md
│   └── error-handling.md
│
└── rust/                        # Rust 特定
    ├── coding-style.md
    └── memory.md
```

**优先级规则：** 语言特定规则 > 通用规则

```
处理 TypeScript 文件时：
  1. 应用 typescript/coding-style.md
  2. 应用 common/coding-style.md（作为基础）
```

### 2.4 配置文件位置

| 位置 | 范围 | 说明 |
|------|------|------|
| `~/.claude/rules/` | 全局 | 所有项目生效 |
| `<project>/.claude/rules/` | 项目级 | 仅当前项目生效 |

**安装命令：**

```bash
# 全局安装
mkdir -p ~/.claude/rules/common
mkdir -p ~/.claude/rules/typescript

# 项目级安装
mkdir -p .claude/rules
cp -r rules/common .claude/rules/
cp -r rules/typescript .claude/rules/
```

### 2.5 语法格式

Rules 使用 Markdown 格式，支持 YAML frontmatter 定义路径匹配。

**基本结构：**

```markdown
---
paths:
  - "**/*.ts"
  - "**/*.tsx"
  - "**/*.js"
  - "**/*.jsx"
---

# 标题

> 说明性引用

## 子标题

规则内容...
```

**路径匹配语法：**

```markdown
---
paths:
  # 所有文件
  - "**/*"

  # TypeScript 文件
  - "**/*.ts"
  - "**/*.tsx"

  # 特定目录
  - "src/**/*"
  - "!src/**/*.test.ts"  # 排除测试文件

  # 特定文件
  - "package.json"
---

# 规则内容
```

**继承语法：**

```markdown
# TypeScript 规则

> This file extends [common/coding-style.md](../common/coding-style.md)
> with TypeScript/JavaScript specific content.

## Additional Rules

TypeScript 特定规则...
```

### 2.6 常用规则类型

#### 2.6.1 编码风格规则

**通用编码风格**（`common/coding-style.md`）：

```markdown
# Coding Style Guidelines

## Immutability (CRITICAL)

ALWAYS create new objects, NEVER mutate existing ones:

```
// WRONG: 修改原对象
modify(original, field, value) → changes original in-place

// CORRECT: 返回新对象
update(original, field, value) → returns new copy with change
```

## File Organization

MANY SMALL FILES > FEW LARGE FILES:
- High cohesion, low coupling
- 200-400 lines typical, 800 max
- Split files when they exceed 500 lines

## Error Handling

ALWAYS handle errors comprehensively:
- Handle errors explicitly at every level
- Never silently swallow errors
- Provide meaningful error messages
- Log errors for debugging

## Naming Conventions

- Variables and functions: camelCase
- Classes and components: PascalCase
- Constants: UPPER_SNAKE_CASE
- Files: kebab-case (components破折号)
```

**TypeScript 特定规则**：

```markdown
# TypeScript Coding Style

> This file extends [common/coding-style.md](../common/coding-style.md)

## Types and Interfaces

Use types to make public APIs explicit:

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
- If you must use `any`, explain why

## Function Signatures

All exported functions MUST have explicit return types:

```typescript
// WRONG
export function calculateTotal(items: Item[]) {
  return items.reduce((sum, item) => sum + item.price, 0)
}

// CORRECT
export function calculateTotal(items: Item[]): number {
  return items.reduce((sum, item) => sum + item.price, 0)
}
```

## Imports

Organize imports in this order:
1. External packages
2. Internal packages
3. Relative imports

```typescript
// 1. External
import React from 'react'
import { useQuery } from 'react-query'

// 2. Internal
import { Button } from '@/components/ui'
import { formatDate } from '@/utils'

// 3. Relative
import { type User } from './types'
```
```

**Python 特定规则**：

```markdown
# Python Coding Style

> This file extends [common/coding-style.md](../common/coding-style.md)

## Standards

- Follow **PEP 8** conventions
- Use **type annotations** on all function signatures
- Maximum line length: 120 characters

## Type Annotations

```python
# WRONG
def process_user(user):
    return user.name

# CORRECT
def process_user(user: User) -> str:
    return user.name
```

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

## Docstrings

Use Google style docstrings:

```python
def calculate_total(items: list[Item]) -> float:
    """Calculate the total price of items.

    Args:
        items: List of items to calculate.

    Returns:
        Total price as a float.

    Raises:
        ValueError: If items is empty.
    """
    if not items:
        raise ValueError("Items cannot be empty")
    return sum(item.price for item in items)
```
```

#### 2.6.2 安全规则

**通用安全规则**（`common/security.md`）：

```markdown
# Security Guidelines

## Mandatory Security Checks

Before ANY commit or code generation:
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
- Rotate exposed secrets immediately

## Input Validation

```typescript
// WRONG: Trust user input
function getUser(id: string) {
  return db.query(`SELECT * FROM users WHERE id = ${id}`)
}

// CORRECT: Validate and use parameterized queries
function getUser(id: string) {
  if (!isValidUUID(id)) {
    throw new ValidationError('Invalid user ID')
  }
  return db.query('SELECT * FROM users WHERE id = $1', [id])
}
```

## Security Response Protocol

If security issue found:
1. STOP immediately
2. Fix CRITICAL issues before continuing
3. Rotate any exposed secrets
4. Review entire codebase for similar issues
5. Document the issue and fix
```

#### 2.6.3 测试规则

**通用测试规则**（`common/testing.md`）：

```markdown
# Testing Requirements

## Minimum Test Coverage: 80%

Test Types (ALL required):
1. **Unit Tests** - Individual functions, utilities, components
2. **Integration Tests** - API endpoints, database operations
3. **E2E Tests** - Critical user flows

## Test Naming

Use descriptive test names:

```typescript
// WRONG
test('test1')
it('testing the function')

// CORRECT
describe('formatDate', () => {
  it('formats date as YYYY-MM-DD')
  it('handles invalid date input')
  it('respects timezone settings')
})
```

## Test Structure

Follow AAA pattern:

```typescript
describe('calculateTotal', () => {
  it('sums all item prices', () => {
    // Arrange
    const items = [createItem(10), createItem(20)]

    // Act
    const result = calculateTotal(items)

    // Assert
    expect(result).toBe(30)
  })
})
```

## Test-Driven Development

MANDATORY workflow for new features:
1. Write test first (RED)
2. Run test - it should FAIL
3. Write minimal implementation (GREEN)
4. Run test - it should PASS
5. Refactor (IMPROVE)
6. Verify coverage (80%+)
```

#### 2.6.4 Git 工作流规则

**通用 Git 规则**（`common/git-workflow.md`）：

```markdown
# Git Workflow

## Commit Message Format

<type>: <description>

<optional body>

Types:
- feat: New feature
- fix: Bug fix
- refactor: Code refactoring
- docs: Documentation
- test: Tests
- chore: Maintenance
- perf: Performance
- ci: CI/CD

Examples:
```
feat: add user authentication

- Add JWT token validation
- Implement login/logout endpoints
- Add refresh token logic
```

## Pull Request Workflow

When creating PRs:
1. Analyze full commit history (not just latest commit)
2. Use `git diff [base-branch]...HEAD` to see all changes
3. Draft comprehensive PR summary
4. Include test plan with TODOs
5. Push with `-u` flag if new branch

## Branch Naming

Format: `<type>/<ticket>-<description>`

Examples:
- `feature/PROJ-123-user-login`
- `fix/PROJ-456-auth-bug`
- `chore/update-dependencies`
```

### 2.7 Rule、Hooks、Permissions 对比

#### 功能对比

| 特性 | Rules | Hooks | Permissions |
|------|-------|-------|-------------|
| **触发时机** | 始终生效 | 工具执行前后/会话结束 | 工具调用时 |
| **配置方式** | Markdown 文件 | JSON 配置文件 | settings.json |
| **用途** | 定义行为标准 | 自动化任务执行 | 控制工具访问 |
| **执行方式** | Claude Code 自动遵循 | 运行外部脚本/命令 | 阻止/允许执行 |
| **示例** | "80%测试覆盖率" | "编辑后自动格式化" | "禁止使用 rm -rf /" |
| **可中断** | 否 | 否 | 是（阻止执行）|

#### 三者协同关系

```
┌─────────────────────────────────────────────────────────────┐
│                    Claude Code Session                       │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Permissions ──────► 阻止/允许工具执行                       │
│         │           （如：禁止 WebSearch）                  │
│         ▼                                                     │
│  Rules ───────────► 定义工作时的行为标准                     │
│         │           （如：必须显式类型、80%覆盖率）          │
│         ▼                                                     │
│  Hooks ───────────► 工具执行前后触发自动化                   │
│                    （如：自动格式化、发送通知）              │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

#### 实际工作流程示例

1. **Permissions** 阻止执行危险命令
   ```json
   { "permissions": { "deny": ["Bash"] } }
   ```

2. **Rules** 指导遵循编码规范
   ```markdown
   # security.md
   - NEVER hardcode secrets
   - Validate all user inputs
   ```

3. **Hooks** 在编辑文件后自动格式化
   ```json
   {
     "hooks": {
       "PostToolUse": {
         "toolNames": ["Edit", "Write"],
         "command": "npx prettier --write ${targetFile}"
       }
     }
   }
   ```

### 2.8 创建自定义 Rule

#### 步骤一：创建目录结构

```bash
mkdir -p .claude/rules/common
mkdir -p .claude/rules/typescript
mkdir -p .claude/rules/python
```

#### 步骤二：编写规则文件

**`.claude/rules/common/coding-style.md`：**

```markdown
---
paths:
  - "**/*"
---

# Coding Style Guidelines

## Naming Conventions

- Use camelCase for variables and functions
- Use PascalCase for classes and components
- Use UPPER_SNAKE_CASE for constants
- Use kebab-case for file names (except components)

## File Organization

- Maximum 500 lines per file
- One component per file
- Group related functionality
```

**`.claude/rules/common/security.md`：**

```markdown
---
paths:
  - "**/*"
---

# Security Guidelines

## Hardcoded Secrets

NEVER hardcode secrets in source code:
- API keys
- Passwords
- Database URLs
- JWT secrets

ALWAYS use environment variables:

```bash
# WRONG
const apiKey = 'sk-xxx-xxx'

# CORRECT
const apiKey = process.env.API_KEY
```
```

#### 步骤三：测试规则

```bash
# 测试 Claude Code 是否遵循规则
claude

# 在对话中测试
"创建一个函数，包含一些规范问题"

# Claude 应该自动遵循规则
```

---

## 第三章：团队规则集

### 3.1 TypeScript 项目规则集

**目录结构：**

```
rules/
├── common/
│   ├── coding-style.md
│   ├── security.md
│   └── testing.md
└── typescript/
    ├── coding-style.md
    └── react.md
```

**TypeScript 规则模板：**

```markdown
---
paths:
  - "**/*.ts"
  - "**/*.tsx"
---

# TypeScript Coding Standards

## Type Safety

### Strict Mode
- Always use strict TypeScript
- No implicit any
- Strict null checks enabled

### Type Definitions

```typescript
// WRONG
export function getUser(id) {
  return db.query(id)
}

// CORRECT
export function getUser(id: string): Promise<User | null> {
  return db.query(id)
}
```

## Imports

```typescript
// Order matters:
import React from 'react'                    // 1. React
import { useState } from 'react'             // 2. React hooks
import { Button } from '@/components/ui'     // 3. Internal
import { formatDate } from './utils'        // 4. Relative
import type { User } from './types'          // 5. Types
```

## React Components

```typescript
// Functional components only
interface ButtonProps {
  label: string
  onClick: () => void
  variant?: 'primary' | 'secondary'
}

// Use React.FC sparingly, prefer explicit types
export function Button({ label, onClick, variant = 'primary' }: ButtonProps) {
  return (
    <button className={variant} onClick={onClick}>
      {label}
    </button>
  )
}
```

## Error Handling

```typescript
// Always handle errors
async function fetchUser(id: string): Promise<Result<User, Error>> {
  try {
    const user = await db.users.findById(id)
    return { ok: true, value: user }
  } catch (error) {
    return { ok: false, error: error as Error }
  }
}
```
```

### 3.2 Python 项目规则集

```markdown
---
paths:
  - "**/*.py"
---

# Python Coding Standards

## Type Annotations

All functions MUST have type annotations:

```python
# WRONG
def process_user(user):
    return user.name

# CORRECT
def process_user(user: User) -> str:
    return user.name
```

## Imports

Organize with isort:

```python
# Standard library
from typing import Optional
from datetime import datetime

# Third party
import pandas as pd
from fastapi import APIRouter

# Local
from app.models import User
from app.utils import format_date
```

## Docstrings

Google style docstrings:

```python
def calculate_total(items: list[Item], tax_rate: float = 0.1) -> float:
    """Calculate total price including tax.

    Args:
        items: List of items to calculate.
        tax_rate: Tax rate as decimal (default 0.1).

    Returns:
        Total price as float.

    Raises:
        ValueError: If items is empty.
    """
    if not items:
        raise ValueError("Items cannot be empty")
    return sum(item.price for item in items) * (1 + tax_rate)
```

## Testing

```python
import pytest

class TestCalculateTotal:
    def test_sums_prices(self):
        items = [Item(price=10), Item(price=20)]
        assert calculate_total(items) == 30

    def test_raises_on_empty(self):
        with pytest.raises(ValueError):
            calculate_total([])
```
```

### 3.3 Go 项目规则集

```markdown
---
paths:
  - "**/*.go"
---

# Go Coding Standards

## Formatting

- **gofmt** and **goimports** are mandatory — no style debates
- Run before commit: `gofmt -w . && goimports -w .`

## Error Handling

Always wrap errors with context:

```go
// WRONG
if err != nil {
    return err
}

// CORRECT
if err != nil {
    return fmt.Errorf("failed to create user: %w", err)
}
```

## Context Propagation

Pass context as first parameter:

```go
func GetUser(ctx context.Context, id string) (*User, error) {
    user, err := db.QueryContext(ctx, "SELECT * FROM users WHERE id = ?", id)
    if err != nil {
        return nil, fmt.Errorf("get user: %w", err)
    }
    return user, nil
}
```

## Testing

```go
func TestGetUser(t *testing.T) {
    t.Run("finds existing user", func(t *testing.T) {
        user, err := GetUser(context.Background(), "123")
        if err != nil {
            t.Fatalf("unexpected error: %v", err)
        }
        if user.Name != "John" {
            t.Errorf("expected name John, got %s", user.Name)
        }
    })
}
```

## Package Structure

```
internal/
├── handler/    # HTTP handlers
├── service/    # Business logic
├── repository/ # Data access
└── model/      # Data models
```
```

---

## 实践练习

### 练习一：安全规则

**目标：** 创建团队安全规则

**任务清单：**
1. ✅ 创建 `.claude/rules/common/security.md`
2. ✅ 添加硬编码检查规则
3. ✅ 添加输入验证规则
4. ✅ 测试 Claude Code 是否遵循规则

### 练习二：编码规范

**目标：** 为项目创建编码规范

**任务清单：**
1. ✅ 创建 TypeScript 项目规则
2. ✅ 定义命名规范
3. ✅ 定义文件组织规范
4. ✅ 测试 Claude Code 生成代码是否符合规范

### 练习三：团队规则集

**目标：** 建立团队统一的规则集

**任务清单：**
1. ✅ 创建 `rules/common/` 目录和基础规则
2. ✅ 根据项目语言创建特定规则
3. ✅ 创建 Git 工作流规则
4. ✅ 将规则集加入代码仓库

---

*本教程是 Claude Code 系统学习系列的第四部分。学完本教程后，你已经掌握了 Claude Code 的全部核心能力。*
