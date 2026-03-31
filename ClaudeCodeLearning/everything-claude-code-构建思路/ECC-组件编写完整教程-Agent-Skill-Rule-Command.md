# ECC 组件编写完整教程：Agent / Skill / Rule / Command

> 基于 everything-claude-code 源码分析，含完整模板与实际案例

---

## 目录

1. [组件总览与选型决策](#1-组件总览与选型决策)
2. [Agent 编写教程](#2-agent-编写教程)
3. [Skill 编写教程](#3-skill-编写教程)
4. [Rule 编写教程](#4-rule-编写教程)
5. [Command 编写教程](#5-command-编写教程)
6. [组件联动实战：为新项目编写完整工作流](#6-组件联动实战为新项目编写完整工作流)
7. [调试与发布](#7-调试与发布)

---

## 1. 组件总览与选型决策

### 四大组件的角色对比

| 组件 | 文件位置 | 性质 | 用户感知 | 触发方式 |
|------|----------|------|----------|----------|
| **Agent** | `agents/<name>.md` | 任务执行者 | 不可见 | Command 调用 / 显式委托 |
| **Skill** | `skills/<name>/SKILL.md` | 知识库 | 不可见 | Agent 内部引用 / 上下文激活 |
| **Rule** | `rules/<path>.md` | 全局约束 | 始终生效 | 自动加载 |
| **Command** | `commands/<name>.md` | 用户入口 | 可见（`/name`） | 用户直接调用 |

### 何时用哪个组件？

```
用户需要执行一个完整工作流（如 TDD）      → Command（入口）+ Agent（执行）+ Skill（知识）
Claude 需要在特定领域内自主决策           → Skill（知识库）
项目有始终强制遵守的规范                 → Rule（全局加载）
Claude 需要代为完成一个具体子任务        → Agent（可委托）
```

### 命名规范（强制）

| 组件 | 命名格式 | 示例 |
|------|----------|------|
| Agent | 小写 + 连字符 | `code-reviewer.md`、`security-reviewer.md` |
| Skill | 小写 + 连字符（目录名） | `tdd-workflow/SKILL.md`、`api-design/SKILL.md` |
| Rule | 小写 + 连字符 | `security.md`、`coding-style.md` |
| Command | 小写 + 连字符 | `plan.md`、`tdd.md` |

---

## 2. Agent 编写教程

### 2.1 Agent 的本质

Agent 是一个**可被委托的子任务执行者**。当 Command 需要执行复杂逻辑时，通过 `spawn Agent(name=xxx)` 将任务交给 Agent。Agent 可以调用工具（Read/Write/Edit/Bash 等），最终将结果返回给父级。

### 2.2 文件结构

```
agents/<name>.md          # 唯一文件，Markdown + YAML frontmatter
```

### 2.3 Frontmatter 字段（全部必需）

```yaml
---
name: <name>              # 小写 + 连字符，唯一标识符
description: <text>      # 描述何时调用，Claude 用此决定是否委托
tools: [<array>]          # Agent 可使用的工具列表
model: <sonnet|opus>      # 使用哪个模型
---
```

| 字段 | 可选值 | 选型建议 |
|------|--------|----------|
| `name` | 自由命名 | 与文件名一致 |
| `description` | 自由描述 | **关键字段**：描述越精准，Claude 越可能在正确场景下自动委托 |
| `tools` | `Read` `Write` `Edit` `Bash` `Grep` `Glob` `Task` 等 | 只给必要工具 |
| `model` | `sonnet`（执行型）、`opus`（规划/架构型） | 复杂推理用 opus |

### 2.4 Agent 内容结构

```
---
frontmatter
---
[第一行]: "You are a <role> specialist."
│
├── ## Your Role          # 角色定义：职责 + 边界
├── ## Workflow           # 工作流程（编号步骤）
├── ## Output Format      # 输出格式（返回给父级的内容）
├── ## Examples           # 完整示例（最重要！）
└── ## Best Practices / Anti-Patterns
```

### 2.5 完整模板

```markdown
---
name: <your-agent-name>
description: 描述这个 agent 何时被调用。越具体越好，Claude 据此决定是否委托。
              格式：[角色] + [职责] + [触发时机]
tools: ["Read", "Grep", "Glob", "Bash"]
model: sonnet
---

You are a [<role>] specialist.

## Your Role

- 核心职责1
- 核心职责2
- 边界：你不做什么（明确排除的职责）

## Workflow

### 1. [步骤名称]
做什么，怎么做。

### 2. [步骤名称]
...

## Output Format

描述你返回给调用者的内容格式。

## Examples

### Example: [具体场景]

**Input:** [用户/父级提供的输入]

**Action:**
1. [具体行动]
2. [具体行动]

**Output:**
```
[你返回的内容]
```

## Best Practices

- 最佳实践1
- 最佳实践2

## Anti-Patterns

- 反模式1（不要这样做）
- 反模式2
```

### 2.6 真实案例：`code-reviewer` agent

```markdown
---
name: code-reviewer
description: Expert code review specialist. Proactively reviews code for quality, security, and maintainability. Use immediately after writing or modifying code.
tools: ["Read", "Grep", "Glob", "Bash"]
model: sonnet
---

You are a senior code reviewer ensuring high standards of code quality and security.

## Review Process

When invoked:

1. **Gather context** — Run `git diff --staged` and `git diff` to see all changes.
2. **Understand scope** — Identify which files changed and how they connect.
3. **Read surrounding code** — Don't review changes in isolation.
4. **Apply review checklist** — Work through each category.
5. **Report findings** — Only report issues you are >80% sure about.

## Review Checklist

### Security (CRITICAL)
- Hardcoded credentials
- SQL injection
- XSS vulnerabilities
...

### Code Quality (HIGH)
...
```

**关键观察**：
- `description` 说明了触发时机：`immediately after writing or modifying code`
- 工具集只给读操作工具（不写代码，只审查）
- Workflow 分步骤，带编号
- Examples 是**最核心**的部分

### 2.7 Agent 选型原则

| 场景 | model | tools | 说明 |
|------|-------|-------|------|
| 架构设计、系统设计 | `opus` | `[Read, Grep, Glob]` | 深度推理，只读不写 |
| 代码审查、安全审查 | `sonnet` | `[Read, Grep, Glob, Bash]` | 执行审查，需要运行命令 |
| TDD 引导 | `sonnet` | `[Read, Write, Edit, Bash, Grep]` | 需要写文件和运行测试 |
| 规划 | `opus` | `[Read, Grep, Glob]` | 只读分析，不写代码 |

---

## 3. Skill 编写教程

### 3.1 Skill 的本质

Skill 是一个**被动知识库**。Claude Code 根据上下文自动加载相关 Skill，也可以在 Agent 内部用 `skill: <name>` 显式引用。Skill 不执行任务，只提供参考内容。

### 3.2 目录结构

```
skills/<skill-name>/
├── SKILL.md              # 必需：核心知识文件
├── examples/             # 可选：代码示例
│   ├── basic.ts
│   └── advanced.ts
└── references/           # 可选：外部参考资料
    └── links.md
```

### 3.3 Frontmatter 字段

```yaml
---
name: <skill-name>        # 小写 + 连字符，与目录名一致
description: <text>      # 一行描述，用于技能列表展示和自动激活判断
origin: ECC              # 来源：ECC / community / 项目名
tags: [<array>]          # 可选：标签数组
version: "1.0.0"         # 可选：版本号
---
```

### 3.4 Skill 内容结构

```
---
frontmatter
---
# 标题

## When to Activate       # 何时激活（关键！）
## Core Concepts           # 核心概念
## Code Examples           # 代码示例（最重要）
## Anti-Patterns           # 反模式
## Best Practices           # 最佳实践
## Related Skills           # 相关技能
```

### 3.5 完整模板

```markdown
---
name: your-skill-name
description: 简短描述：何时使用这个技能，用于什么任务
origin: ECC
---

# 技能标题

简要概述（1-2句话）。

## When to Activate

描述 Claude 应该在何时使用此技能。越具体越好。
- 场景1
- 场景2
- 场景3

## Core Concepts

### 概念1
解释 + 为什么重要。

### 概念2
...

## Code Examples

### 示例1：基础用法

```typescript
// 实际可运行的代码
function example() {
  // 带注释
}
```

### 示例2：进阶用法

```typescript
// 更复杂的场景
```

## Anti-Patterns

### 错误做法 ❌

```typescript
// 不要这样做
```

### 正确做法 ✅

```typescript
// 应该这样做
```

## Best Practices

- 做法1
- 做法2

## Related Skills

- `related-skill-1`
- `related-skill-2`
```

### 3.6 真实案例：完整的 `api-design` skill

```markdown
---
name: api-design
description: REST and GraphQL API design patterns, versioning, and best practices for building maintainable APIs.
origin: ECC
---

# API Design Patterns

## When to Activate

- Designing new API endpoints
- Reviewing existing API contracts
- Building REST or GraphQL APIs
- Adding API versioning

## RESTful Conventions

### URL Structure

| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET | /resources | List all resources |
| GET | /resources/:id | Get one resource |
| POST | /resources | Create resource |
| PUT | /resources/:id | Replace resource |
| PATCH | /resources/:id | Partial update |
| DELETE | /resources/:id | Delete resource |

### Response Format

```typescript
// Standard success response
interface ApiResponse<T> {
  success: true;
  data: T;
  meta?: {
    page: number;
    total: number;
  };
}

// Standard error response
interface ApiError {
  success: false;
  error: {
    code: string;     // e.g. "NOT_FOUND"
    message: string;
    details?: unknown;
  };
}
```

## Versioning Strategy

### URL Path Versioning (Recommended)

```
/api/v1/users
/api/v2/users
```

### Header Versioning (Alternative)

```http
Accept: application/vnd.myapi.v2+json
```

## Error Handling

| Status | When to Use |
|--------|-------------|
| 200 | Successful GET/PUT/PATCH |
| 201 | Successful POST (resource created) |
| 204 | Successful DELETE (no content) |
| 400 | Client error (validation failed) |
| 401 | Authentication required |
| 403 | Permission denied |
| 404 | Resource not found |
| 429 | Rate limit exceeded |
| 500 | Server error |

## Anti-Patterns

### ❌ Embedding business logic in routes

```typescript
// BAD
app.get('/users/:id/calculate-score', ...)

// GOOD: Separate concerns
app.get('/users/:id', ...)        // API
// Frontend calculates score from user data
```

### ❌ Inconsistent naming

```typescript
// BAD: Mixed conventions
getUserById()
fetch_all_users()
retrieveUser()

// GOOD: Consistent REST conventions
GET /users/{id}
GET /users?role=admin
```

## Best Practices

1. **Use nouns, not verbs** in URLs: `/users` not `/getUsers`
2. **Always version your API**: `/api/v1/`
3. **Return appropriate status codes**: Don't return 200 for errors
4. **Pagination for lists**: Never return unbounded lists
5. **Document with OpenAPI**: Keep spec in sync with implementation

## Related Skills

- `backend-patterns`
- `security-review`
```

### 3.7 Skill 分类与聚焦原则

| 类型 | 示例 | 聚焦建议 |
|------|------|----------|
| **语言标准** | `python-patterns`、`rust-patterns` | 只关注该语言的惯用法 |
| **框架模式** | `react-hook-patterns`、`fastapi-patterns` | 只关注该框架的约定 |
| **工作流** | `tdd-workflow`、`refactoring-workflow` | 步骤清晰，带检查清单 |
| **领域知识** | `api-design`、`security-review` | 参考性质，含决策树 |
| **工具集成** | `supabase-patterns`、`docker-patterns` | 配置模板 + 常见陷阱 |

**聚焦原则**：`api-design` ✅ 比 `backend-development` ✅ 好太多——越具体越容易被激活，越具体越实用。

### 3.8 Skill 引用方式

Agent 内部引用 Skill（两种位置）：

```markdown
## 其他说明

...关于这个话题的更多细节，参见 `skill: tdd-workflow`。

<!-- 或者在末尾作为详细参考 -->
<!-- 代码模板和 Mock patterns，详见 `skill: tdd-workflow` -->
```

上下文自动激活：Claude Code 会根据对话上下文自动加载相关 Skill，依赖 `description` 和 `When to Activate` 字段判断相关性。

---

## 4. Rule 编写教程

### 4.1 Rule 的本质

Rule 是**始终强制生效的全局约束**，不像 Agent/Skill 由上下文触发。Rule 通过 `CLAUDE.md` 引用后自动加载，覆盖所有 Agent 和 Skill 的行为。

### 4.2 目录结构

```
rules/
├── common/               # 语言无关（始终安装）
│   ├── coding-style.md
│   ├── git-workflow.md
│   ├── testing.md
│   ├── performance.md
│   ├── patterns.md
│   ├── hooks.md
│   ├── agents.md
│   └── security.md
├── typescript/           # TypeScript 特定（覆盖 common）
├── python/               # Python 特定
├── golang/               # Go 特定
├── rust/                 # Rust 特定
└── swift/                # Swift 特定
```

**优先级**：语言特定 Rule > Common Rule（特定覆盖通用）

### 4.3 Rule 内容格式

**Rule 没有 frontmatter**——是纯 Markdown 文件，结构更自由。

```markdown
# 规则标题

## 核心原则

描述要遵守的核心原则。

## 必须遵守的检查项

- [ ] 检查项1
- [ ] 检查项2

## 代码示例

### ✅ 正确做法

```typescript
// 带注释说明
```

### ❌ 错误做法

```typescript
// 说明为什么不正确
```

## 触发条件

在什么情况下这个规则适用。
```

### 4.4 完整模板

```markdown
# 规则标题

## 目的

这个规则解决什么问题。

## 核心要求

- 要求1
- 要求2

## 检查清单

提交/发布前必须确认：

- [ ] 清单项1
- [ ] 清单项2

## 正确示例

```[语言]
// 正确做法
```

## 错误示例

```[语言]
// 错误做法及原因
```

## 例外情况

哪些场景下此规则可以例外。
```

### 4.5 真实案例：`rules/common/security.md`

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
- Rotate any secrets that may have been exposed

## Security Response Protocol

If security issue found:
1. STOP immediately
2. Use **security-reviewer** agent
3. Fix CRITICAL issues before continuing
4. Rotate any exposed secrets
5. Review entire codebase for similar issues
```

**关键观察**：
- 无 frontmatter，纯 Markdown
- 检查清单用 `- [ ]` 格式
- 明确的操作步骤（Security Response Protocol）
- 引用具体工具（security-reviewer agent）

### 4.6 语言特定 Rule 示例

`rules/typescript/coding-style.md` 应以：

```markdown
> This file extends [common/coding-style.md](../common/coding-style.md)
> with TypeScript-specific content.
```

开头，明确声明继承关系，然后覆盖或补充 TypeScript 相关内容。

### 4.7 Rule 与 Skill 的核心区别

| 维度 | Rule | Skill |
|------|------|-------|
| 触发方式 | 始终加载 | 上下文激活 |
| 内容性质 | 约束 + 检查清单 | 知识 + 参考模板 |
| 长度 | 短（几百字） | 长（可达 500+ 行） |
| 更新频率 | 稳定 | 可能频繁更新 |

> **Rule 告诉你必须做什么；Skill 告诉你怎么做。**

---

## 5. Command 编写教程

### 5.1 Command 的本质

Command 是**用户入口**——用户输入 `/command-name` 触发。Command 不执行任务，而是激活对应的 Agent。

### 5.2 文件结构

```
commands/<name>.md          # 唯一文件，Markdown + YAML frontmatter
```

### 5.3 Frontmatter 字段

```yaml
---
description: 简短描述，展示在 /help 中
---
```

### 5.4 Command 内容结构

```
---
description: ...
---
# Title

## What This Command Does
## When to Use
## How It Works
## Example Usage
## Integration with Other Commands
## Related Agents
```

### 5.5 完整模板

```markdown
---
description: 一句话描述功能，在 /help 中展示
---

# Command Name

## What This Command Does

1. 第一步
2. 第二步
3. 第三步

## When to Use

- 场景1
- 场景2

## How It Works

描述这个命令的工作流程。

## Example Usage

```
User: /your-command [参数]

Claude:
[期望的输出格式]
```

## Integration with Other Commands

- `/other-command` - 做什么
- `/another-command` - 做什么

## Related Agents

This command invokes the `<agent-name>` agent provided by ECC.

For manual installs, the source file lives at: `agents/<agent-name>.md`
```

### 5.6 真实案例：`commands/tdd.md`（关键部分）

```markdown
---
description: Enforce test-driven development workflow. Scaffold interfaces, generate tests FIRST, then implement minimal code to pass. Ensure 80%+ coverage.
---

# TDD Command

This command invokes the **tdd-guide** agent to enforce test-driven development methodology.

## What This Command Does

1. **Scaffold Interfaces** - Define types/interfaces first
2. **Generate Tests First** - Write failing tests (RED)
3. **Implement Minimal Code** - Write just enough to pass (GREEN)
4. **Refactor** - Improve code while keeping tests green
5. **Verify Coverage** - Ensure 80%+ test coverage

## When to Use

Use `/tdd` when:
- Implementing new features
- Adding new functions/components
- Fixing bugs (write test that reproduces bug first)
...

## Related Agents

This command invokes the `tdd-guide` agent provided by ECC.
The related `tdd-workflow` skill is also bundled with ECC.

For manual installs, the source files live at:
- agents/tdd-guide.md
- skills/tdd-workflow/SKILL.md
```

**关键观察**：
- `description` 是用户看到的第一条信息，直接说明做什么
- `## Related Agents` 段标注了 agent 和 skill 的来源路径
- 包含完整 Example Usage，含期望输出格式

---

## 6. 组件联动实战：为新项目编写完整工作流

### 场景

为一个微服务项目编写完整的"数据库迁移工作流"组件集。

### Step 1：确定需要的组件

```
用户输入 /db-migrate
  └─→ Command: db-migrate.md           ← 用户入口
        └─→ Agent: db-migrate-agent.md  ← 任务执行
              └─→ Skill: db-migration   ← 知识库（迁移模式 + 风险检查）
```

### Step 2：编写 Skill（知识库，最底层）

```markdown
---
name: db-migration
description: Database migration best practices for schema changes, rollbacks, and zero-downtime deployments.
origin: ECC
---

# Database Migration Patterns

## When to Activate

- Creating database migrations
- Reviewing migration safety
- Rolling back failed migrations
- Planning zero-downtime schema changes

## Migration Safety Rules

### ZERO-DOWNTIME Checklist

- [ ] Column additions: ALWAYS have DEFAULT value
- [ ] Column renames: add new column → migrate data → drop old column (3-step)
- [ ] Column drops: remove all references first
- [ ] Index creation: use CONCURRENTLY in PostgreSQL
- [ ] Large table alterations: use online schema change tools

### NEVER DO ❌

```sql
-- NEVER: Drop column in same transaction as other changes
BEGIN;
ALTER TABLE users DROP COLUMN legacy_flag;
ALTER TABLE users ADD COLUMN new_flag BOOLEAN;
COMMIT;  -- 如果失败，两个都无法回滚

-- CORRECT: Separate migrations
-- Migration 1: Add new column
ALTER TABLE users ADD COLUMN new_flag BOOLEAN DEFAULT false;
-- Migration 2 (after deploy): Drop old column
ALTER TABLE users DROP COLUMN legacy_flag;
```

## Zero-Downtime Patterns

### Pattern: Expand-Contract

```
Phase 1 (Expand):    Add new column, keep old column
Phase 2 (Migrate):   Backfill data, deploy new code
Phase 3 (Contract):  Remove old column
```

### PostgreSQL: Safe Operations

```sql
-- ✅ SAFE: Adding column with default (PostgreSQL 11+)
ALTER TABLE orders ADD COLUMN status VARCHAR(20) DEFAULT 'pending';

-- ✅ SAFE: Creating index without locking
CREATE INDEX CONCURRENTLY idx_orders_status ON orders(status);

-- ✅ SAFE: Adding NOT NULL with check
ALTER TABLE orders ADD COLUMN paid BOOLEAN DEFAULT false;
ALTER TABLE orders ADD CONSTRAINT chk_paid CHECK (paid IS NOT NULL);
-- Then in separate migration:
ALTER TABLE orders ALTER COLUMN paid SET NOT NULL;
```

## Rollback Strategy

```sql
-- Migration up
CREATE TABLE backups (
  id SERIAL PRIMARY KEY,
  table_name VARCHAR(255),
  data JSONB,
  migrated_at TIMESTAMP DEFAULT NOW()
);

-- Rollback
-- 1. Stop application
-- 2. Restore from backups table
-- 3. Verify data
-- 4. Restart application
```

## Related Skills

- `database-migrations` (if exists)
- `postgresql-best-practices`
```

### Step 3：编写 Agent（执行层）

```markdown
---
name: db-migrate-agent
description: Database migration specialist. Creates safe, zero-downtime migrations with rollback plans. Use when adding tables, columns, indexes, or modifying existing schemas.
tools: ["Read", "Write", "Bash", "Glob"]
model: sonnet
---

You are a database migration specialist.

## Your Role

- Create safe database migrations
- Enforce zero-downtime patterns
- Provide rollback strategies
- Check for dangerous operations

## Migration Workflow

### 1. Analyze Current Schema

```bash
# PostgreSQL
psql $DATABASE_URL -c "\\d table_name"

# MySQL
mysql -u $USER -p $DATABASE -e "DESCRIBE table_name"
```

### 2. Design Migration

Follow the Expand-Contract pattern for all schema changes.

### 3. Create Migration File

```bash
# Rails
rails generate migration AddStatusToOrders

# Node (with knex)
knex migrate:make add_status_to_orders
```

### 4. Write Migration

Follow patterns from `skill: db-migration`.

### 5. Verify Safety

Run through the ZERO-DOWNTIME checklist.

## Output Format

```markdown
# Migration Plan: [description]

## Current Schema
[describe current state]

## Proposed Changes
[describe migration]

## Zero-Downtime Assessment
- [ ] Safe for zero-downtime deployment
- [ ] Requires maintenance window

## Rollback Plan
[step-by-step rollback instructions]

## Execution Order
1. ...
```

## Examples

### Example: Adding a NOT NULL Column

**Input:** Add `email_verified_at TIMESTAMP` to `users` table

**Action:**
1. Check current schema
2. Design 3-step expand-contract migration
3. Generate migration files
4. Provide rollback plan

**Output:**
```markdown
# Migration Plan: Add email_verified_at

## Zero-Downtime: YES

## Steps:
1. UP:   Add column (nullable, with default)
2. UP:   Backfill existing users (optional)
3. UP:   Add NOT NULL constraint (separate migration)
```

## Anti-Patterns

- Never drop columns in the same migration as other changes
- Never rename columns directly (use add→migrate→drop pattern)
- Never add NOT NULL without a default value on large tables
```

### Step 4：编写 Command（用户入口）

```markdown
---
description: Create safe, zero-downtime database migrations with rollback plans. Enforces expand-contract pattern for all schema changes.
---

# Database Migration Command

This command invokes the **db-migrate-agent** to create safe database migrations.

## What This Command Does

1. **Analyze current schema** — Understand existing structure
2. **Design migration** — Apply zero-downtime patterns
3. **Generate migration files** — Using your framework's tool
4. **Verify safety** — Run through zero-downtime checklist
5. **Document rollback** — Provide recovery plan

## When to Use

Use `/db-migrate` when:
- Adding new tables
- Adding/modifying/dropping columns
- Creating or dropping indexes
- Changing constraints
- Any schema modification

## How It Works

The db-migrate-agent will:

1. Analyze your current database schema
2. Design a safe migration following expand-contract pattern
3. Generate migration files using your framework (Rails/Knex/Prisma/Django)
4. Verify the migration is safe for zero-downtime deployment
5. Provide a complete rollback plan

## Example Usage

```
User: /db-migrate I need to add a `premium_expires_at` timestamp column to users

Agent:
# Migration Plan: Add premium_expires_at to users

## Zero-Downtime Assessment: ✅ SAFE

## Migration Steps:

### Step 1 (Zero-downtime):
ALTER TABLE users ADD COLUMN premium_expires_at TIMESTAMP DEFAULT NULL;

### Step 2 (After deploy, optional):
UPDATE users SET premium_expires_at = created_at + INTERVAL '30 days'
  WHERE is_premium = true AND premium_expires_at IS NULL;

### Step 3 (Separate migration, after full rollout):
ALTER TABLE users ALTER COLUMN premium_expires_at SET NOT NULL;

## Rollback:
ALTER TABLE users DROP COLUMN premium_expires_at;
```

## Related Agents

This command invokes the `db-migrate-agent` agent.

For manual installs, the source file lives at: `agents/db-migrate-agent.md`

## Related Skills

The related `db-migration` skill is bundled with this command.

## Integration with Other Commands

- Use `/plan` first to understand full feature scope
- Use `/tdd` to add tests for migration logic
- Use `/code-review` to review migration safety
```

### Step 5：注册到 plugin.json

```json
{
  "version": "1.0.0",
  "name": "db-migration-workflow",
  "agents": [
    "./agents/db-migrate-agent.md"
  ],
  "commands": [
    "./commands/db-migrate.md"
  ],
  "skills": [
    "./skills/db-migration/"
  ]
}
```

### 联动总览

```
用户 /db-migrate
  │
  ▼
Command: commands/db-migrate.md
  "This command invokes the db-migrate-agent"
  │
  ▼
Agent: agents/db-migrate-agent.md
  tools: [Read, Write, Bash, Glob]
  model: sonnet
  "Follow patterns from skill: db-migration"
  │
  ▼
Skill: skills/db-migration/SKILL.md
  提供: PostgreSQL/MySQL 安全模式
  提供: Expand-Contract 模板
  提供: Rollback 策略
  │
  ▼
Claude 实际执行迁移
```

---

## 7. 调试与发布

### 7.1 本地测试

```bash
# Skill 测试：复制到本地后触发
cp -r skills/your-skill ~/.claude/skills/
claude
# → 输入触发场景，看是否激活

# Agent 测试：直接调用
# → 在对话中: /your-command
```

### 7.2 验证检查清单

**Agent 验证：**
- [ ] frontmatter `name`、`description`、`tools`、`model` 全部填写
- [ ] `description` 描述了触发时机
- [ ] 包含完整 Example（含 Input/Action/Output）
- [ ] 工具集只包含必要工具

**Skill 验证：**
- [ ] frontmatter `name`、`description` 填写
- [ ] `When to Activate` 描述清晰
- [ ] Code Examples 附语言标识
- [ ] 代码示例经过验证（可运行）
- [ ] 包含 Anti-Patterns

**Rule 验证：**
- [ ] 无 frontmatter（纯 Markdown）
- [ ] 包含检查清单（`- [ ]` 格式）
- [ ] 有正确/错误示例对比

**Command 验证：**
- [ ] frontmatter `description` 填写
- [ ] `## Related Agents` 标注来源路径
- [ ] Example Usage 展示期望输出格式

### 7.3 提交格式（conventional commits）

```bash
git commit -m "feat(agents): add db-migrate-agent for zero-downtime migrations"
git commit -m "feat(skills): add db-migration patterns skill"
git commit -m "feat(commands): add /db-migrate command"
git commit -m "feat(rules): add database-migration safety rules"
```

### 7.4 发布到 ECC

```bash
# 1. Fork
gh repo fork affaan-m/everything-claude-code --clone

# 2. 创建分支
git checkout -b feat/skill-db-migration

# 3. 添加文件
mkdir -p skills/db-migration

# 4. 提交
git add skills/db-migration/
git commit -m "feat(skills): add db-migration patterns skill"

# 5. Push 并创建 PR
git push -u origin feat/skill-db-migration
gh pr create --title "feat(skills): add db-migration patterns" --body "..."
```

PR 模板内容：

```markdown
## Summary
描述这个组件做什么，为什么有价值。

## Skill Type
- [ ] Language standards
- [ ] Framework patterns
- [ ] Workflow
- [ ] Domain knowledge
- [ ] Tool integration

## Testing
我是如何在本地测试的。

## Checklist
- [ ] YAML frontmatter 有效
- [ ] 代码示例可运行
- [ ] 遵循指南规范
- [ ] 无敏感数据
```

---

## 附录：各组件字段速查

### Agent frontmatter

```yaml
---
name: string        # 必需：小写+连字符
description: string # 必需：描述触发时机
tools: array        # 必需：工具列表
model: string       # 必需：sonnet | opus
---
```

### Skill frontmatter

```yaml
---
name: string        # 必需
description: string  # 必需
origin: string       # 可选（建议填）
tags: array          # 可选
version: string      # 可选
---
```

### Command frontmatter

```yaml
---
description: string  # 必需
---
```

### Rule

**无 frontmatter**，纯 Markdown 文件。
