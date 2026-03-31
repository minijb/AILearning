# Superpowers 工作流拆解分析

> 基于 v5.0.6 源码分析，与 ECC 对比研究

---

## 目录

1. [项目概览](#1-项目概览)
2. [核心哲学对比](#2-核心哲学对比)
3. [组件架构拆解](#3-组件架构拆解)
4. [16 个 Skill 详解](#4-16-个-skill-详解)
5. [独特设计模式](#5-独特设计模式)
6. [多平台集成架构](#6-多平台集成架构)
7. [Hooks 系统](#7-hooks-系统)
8. [与 ECC 的关键差异](#8-与-ecc-的关键差异)
9. [Superpowers 的核心创新](#9-superpowers-的核心创新)

---

## 1. 项目概览

### 基本信息

| 字段 | 值 |
|------|-----|
| **名称** | Superpowers |
| **版本** | v5.0.6 |
| **作者** | Jesse Vincent |
| **性质** | 面向编码智能体的完整开发工作流 |
| **支持平台** | Claude Code、Codex、OpenCode、Gemini CLI、Cursor（5个） |
| **Skill 数量** | 16 个（全部活跃） |
| **Agent 数量** | 1 个（code-reviewer） |
| **Command 数量** | 3 个（**全部已废弃**） |

### 目录结构

```
superpowers/
├── skills/                    # 核心技能库（16个，全部是 Skill）
│   ├── using-superpowers/     # 引导技能（启动时注入）
│   ├── brainstorming/         # Socratic 设计精化
│   ├── writing-plans/         # 实施计划编写
│   ├── subagent-driven-development/  # 子智能体驱动开发
│   ├── test-driven-development/      # TDD
│   ├── systematic-debugging/          # 系统调试
│   ├── verification-before-completion/ # 证据先行
│   ├── requesting-code-review/        # 请求代码审查
│   ├── receiving-code-review/         # 接收代码审查
│   ├── using-git-worktrees/           # Git Worktree 隔离开发
│   ├── finishing-a-development-branch/ # 合并决策
│   ├── dispatching-parallel-agents/   # 并行子智能体
│   └── writing-skills/               # Skill 编写方法论
├── agents/
│   └── code-reviewer.md       # 唯一 Agent
├── commands/                   # 全部废弃
├── hooks/
│   ├── hooks.json              # Claude Code SessionStart Hook
│   ├── hooks-cursor.json       # Cursor SessionStart Hook
│   ├── session-start            # 启动钩子脚本
│   └── run-hook.cmd            # 跨平台 CMD/bash 包装器
├── .claude-plugin/             # Claude Code 插件
├── .cursor-plugin/             # Cursor 插件
├── .codex/                     # Codex 集成
├── .opencode/                  # OpenCode 集成
├── docs/
│   ├── plans/                  # 设计文档
│   └── testing.md              # Skill 集成测试方法
└── tests/                      # 集成测试
```

---

## 2. 核心哲学对比

### Superpowers 核心信条

```
"Systematic over ad-hoc"
"TDD-first"
"Evidence over claims"
"Complexity reduction"
"No placeholders"
```

### 哲学内核：铁律 + 证据 + 反合理化

ECC 的设计是**工具集**（大量可组合的技能/命令/规则），Superpowers 的设计是**纪律约束**（强制执行特定工作流，不给"偷懒"的机会）。

### 哲学对比表

| 维度 | Superpowers | ECC |
|------|------------|-----|
| **核心隐喻** | 工厂流水线（强制工序） | 工具箱（自由选取） |
| **TDD** | 铁律（Iron Law，无测试不写代码） | 可选（`/tdd` command 提供） |
| **代码审查** | 请求/接收双 Skill 约束 | `/code-review` command |
| **计划** | 必须完整代码，禁止 TODO 占位 | `/plan` command 可生成 TODO |
| **调试** | 系统化 4 阶段方法论 | `build-error-resolver` agent |
| **Agent vs Skill** | 以 Skill 为核心，Agent 极少 | Agent 丰富（30个），Skill 丰富（140+） |

---

## 3. 组件架构拆解

### 3.1 Superpowers 的极简组件策略

Superpowers 只用三种组件，且有意克制：

```
Skill（16个）   ← 主要机制，所有工作流都是 Skill
Agent（1个）    ← 最小化，只有 code-reviewer
Command（0个）  ← 全部废弃，以 Skill 为唯一入口
```

**废弃 Command 的理由**（从 `brainstorm.md` 可见）：

```markdown
# This command is deprecated

Use the `superpowers:brainstorming` skill instead.

Skills are the primary way to invoke Superpowers workflows.
```

这说明 Superpowers 的设计理念：**用户通过描述场景激活 Skill，而非记住特定命令**。

### 3.2 Agent：`code-reviewer`

```yaml
---
name: code-reviewer
model: inherit
description: Triggered when major project steps are completed and need review against plan/coding standards
---
```

**特点**：
- `model: inherit` —— 不指定模型，继承父级模型
- 不是独立入口，由 `requesting-code-review` skill 通过 `Task` 工具显式调用
- 6 维度审查：Plan Alignment / Code Quality / Architecture / Documentation / Issue ID / Communication Protocol
- 问题分级：**Critical > Important > Minor**（而非 H/M/L）

---

## 4. 16 个 Skill 详解

### 4.1 分类总览

```
Superpowers 16 Skill 分组

Meta（元技能）
├── using-superpowers        # 引导：强制技能调用
└── writing-skills           # 编写 Skill 的方法论

Execution（执行）
├── subagent-driven-development  # 子智能体驱动（推荐方式）
├── executing-plans            # 执行计划（无子智能体备选）
└── finishing-a-development-branch  # 分支完成决策

Design（设计）
├── brainstorming             # Socratic 设计精化
└── writing-plans            # 实施计划编写

Quality（质量）
├── test-driven-development   # TDD 铁律
├── systematic-debugging      # 4阶段调试
├── verification-before-completion  # 证据门禁
├── requesting-code-review    # 请求审查
└── receiving-code-review    # 接收审查反馈

Collaboration（协作）
├── dispatching-parallel-agents   # 并行调试
└── using-git-worktrees           # Worktree 隔离开发
```

---

### 4.2 核心 Skill 详细拆解

#### Skill 1：`using-superpowers`（引导技能）

**作用：** 每个会话启动时通过 SessionStart Hook 强制注入，是 Superpowers 的"宪法"。

**关键内容：**

```markdown
## SKILL INVOCATION REQUIREMENTS

Before responding to any user request, you MUST determine
if any Superpowers skills are relevant and invoke them FIRST.

<SKILL-CHECK>
1. Does the request match any "When to Activate" conditions?
2. If yes → invoke the skill BEFORE providing any other response
3. If no → proceed with your response
</SKILL-CHECK>
```

**内置反合理化表格：**

| 合理化借口 | 现实 |
|-----------|------|
| "这只是简单问题，不需要流程" | 简单问题更需要一致的方法论 |
| "我需要先了解更多上下文" | 可以先调用 Skill 再问问题 |
| "这次跳过，下次再用" | 下次也会跳过 |

**优先级声明：**
```
User CLAUDE.md/GEMINI.md > Superpowers Skills > Default System Prompt
```

---

#### Skill 2：`brainstorming`（设计精化）

**触发条件：** "Use when beginning a new feature, architectural decision, or complex implementation — before writing any code"

**9步流程（HARD-GATE 强制门禁）：**

```
1. Clarify Goals      → 用户要解决的核心问题是什么
2. Identify Users      → 谁会使用这个功能
3. Surface Assumptions → 列出所有假设
4. Explore Scope       → 包含什么，不包含什么
5. Sketch Solutions    → 提出 2-3 个方案
6. Evaluate Tradeoffs  → 权衡分析
7. Select Approach      → 选择方案
8. Define Success      → 如何衡量成功
9. Document Decision   → 记录决策

⚠️ HARD-GATE: 在设计被批准之前，不调用任何实现技能
```

**独特功能：** Visual Brainstorming Companion
- 内置 HTTP 服务器（Node.js）
- 将设计对话内容写入 HTML 文件
- 浏览器可交互操作，结果写回事件文件

---

#### Skill 3：`writing-plans`（计划编写）

**核心理念：** 完整代码，无占位符，2-5 分钟粒度。

```markdown
## THE NO-PLACEHOLDERS RULE

Every plan step must include COMPLETE CODE.
Never write: "// TODO: implement authentication"
Always write: Complete, working code for that step.
```

**计划文档结构：**
```
# Implementation Plan

## Context
## Goals
## Non-Goals
## Approach
## Task List (每个任务)

### Task N: [Task Name] (ETA: 2-5 min)
**File:** path/to/file.ts
**Complete code:**
```typescript
// 完整代码，无 TODO
```
**Verification:** [如何验证]
```

**计划末尾强制选择：**
```markdown
## Execution Method

Please choose one:
A. **Subagent-Driven (Recommended)** → 使用子智能体执行
B. **Inline Execution** → 直接在当前会话执行
```

---

#### Skill 4：`subagent-driven-development`（推荐执行方式）

**三阶段子智能体流程：**

```
任务拆分（由父智能体完成）
  │
  ▼
阶段1：Subagent - 实现者
  └─→ 写代码（完全按照计划执行）
  │
  ▼
阶段2：Subagent - 规格审查者
  └─→ 检查实现是否符合规格说明
  │
  ▼
阶段3：Subagent - 质量审查者
  └─→ 检查代码质量、安全性、最佳实践
  │
  ▼
结果回报给用户（父智能体）
```

**Agent 状态回报：**

```
DONE                    ← 成功完成
DONE_WITH_CONCERNS      ← 完成但有问题
BLOCKED                 ← 被阻塞，需要帮助
NEEDS_CONTEXT           ← 需要更多上下文
```

**模型分级策略：**

| 任务类型 | 模型选择 | 原因 |
|---------|---------|------|
| 机械性改写 | cheapest | 不需要深度推理 |
| 集成/连接 | standard | 需要理解上下文 |
| 架构/设计决策 | most capable | 需要复杂推理 |
| 审查/验证 | most capable | 需要严格标准 |

---

#### Skill 5：`test-driven-development`（TDD 铁律）

**Iron Law（绝对铁律）：**

```markdown
## THE IRON LAW

NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST

You may not write a single line of production code until
you have a failing test that describes the behavior you want.
```

**10+ 项反合理化表格：**

| 借口 | 现实 |
|------|------|
| "太简单不需要测试" | 简单代码也会坏，测试只需30秒 |
| "我之后再测试" | 通过的测试无法证明任何事情 |
| "测试太慢" | TDD 的速度来自短反馈循环 |
| "这是临时代码" | 临时代码也会进生产环境 |
| "我需要先理解需求" | 先写测试可以澄清需求 |

**红色旗帜（Red Flags — STOP）：**

```markdown
Red Flags — STOP. You are rationalizing.
- "I'll write tests later"
- "This is simple enough"
- "I need to see it work first"
```

---

#### Skill 6：`systematic-debugging`（系统调试）

**4阶段调试法：**

```
阶段1: Root Cause Tracing（根因追踪）
  └─ 追溯调用栈，找到真正的错误位置

阶段2: Pattern Analysis（模式分析）
  └─ 是否是已知模式（空指针、竞态、超时等）

阶段3: Hypothesis（假设）
  └─ 形成可验证的假设

阶段4: Implementation（修复）
  └─ 实施修复 + 验证
```

**关键原则：** 修复症状不如修复根因。如果一个问题反复出现，说明有更深层的问题。

---

#### Skill 7：`verification-before-completion`（证据门禁）

**核心原则：** 声称完成 ≠ 真正完成，必须有证据。

```markdown
## EVIDENCE GATE

Before claiming any work is complete, you MUST:

1. Run the actual tests → 截屏测试结果
2. Show the output → 显示命令输出
3. Show the results → 显示功能结果

NOT: "Tests should pass now"
YES: "Running tests... (shows actual output)"
```

---

#### Skill 8：`receiving-code-review`（接收审查）

**核心原则：** 禁止"表演性同意"。

```markdown
## THE NO-PERFORMATIVE-AGREEMENT RULE

When receiving code review feedback:

❌ 禁止: "You're absolutely right, I'll fix that right away"
✅ 正确: 如果同意 → 修复
          如果不同意 → 技术性地解释为什么

审查者的反馈可能是错的，工程师有责任技术性地辩护自己的决策。
```

---

#### Skill 9：`using-git-worktrees`（隔离开发）

**Worktree 工作流：**

```
1. 创建 worktree
2. 验证 .gitignore 是否正确配置
3. 安装依赖
4. 建立测试基线
5. 在隔离分支工作
6. 完成后决定：合并 / PR / 丢弃
```

**安全检查：**
```markdown
## Safety Verification Checklist

- [ ] .gitignore covers build artifacts
- [ ] No shared state between worktrees
- [ ] Tests pass in isolation
- [ ] Branch name follows convention
```

---

#### Skill 10：`finishing-a-development-branch`（分支完成决策）

**三选一决策树：**

```
开发完成?
├── 是
│     ├── 质量达标? → 合并 / PR
│     └── 不达标? → 继续工作或归档
└── 否 → 归档分支
```

**关键决策点：**
- 当前分支是否包含有价值的工作？
- 代码质量是否达标？
- 是否有未完成的 TODO 值得单独提 Issue？

---

#### Skill 11：`dispatching-parallel-agents`（并行调试）

**并发调试多个问题：**

```markdown
## When to Dispatch Parallel Agents

When multiple independent problems exist simultaneously:

1. Analyze each problem independently
2. Spawn separate agents for each
3. Each agent uses systematic-debugging
4. Aggregate results and verify
```

**注意：** 只有独立问题才能并行，有依赖关系的问题必须串行。

---

#### Skill 12：`writing-skills`（元技能）

**TDD 应用于文档编写：**

```markdown
## RED-GREEN-REFACTOR for SKILLS

RED: Write a skill with intentionally broken/incorrect content
      → Test with a real subagent
      → Agent will fail to follow correct patterns

GREEN: Fix the broken patterns
       → Make content accurate and enforceable
       → Test again

REFACTOR: Simplify, clarify, reduce
          → Remove redundancy
          → Make structure clearer
```

**Persuasion Principles（说服原则）：**
- 基于 Cialdini 研究：一致性、互惠、权威、稀缺、喜好、社会认同
- 用于让智能体遵守纪律而非"偷懒"

**压力测试：**
```markdown
## Pressure Testing

Test skills under realistic pressure:
- Time pressure (already spent 30 minutes)
- Sunk cost (already wrote lots of code)
- Exhaustion (many rounds of edits)

If a skill fails under pressure, it needs hardening.
```

---

## 5. 独特设计模式

### 5.1 铁律模式（Iron Law Pattern）

每个纪律性 Skill 都有 Iron Law：

```markdown
## THE IRON LAW

[绝对规则，不可违背]

任何情况下都不允许绕过此规则。
```

**作用：** 给智能体一个明确的"底线"，不允许合理化。

---

### 5.2 合理化表格模式（Rationalization Table Pattern）

```markdown
## Rationalization Table

| 智能体会说 | 真实原因 |
|-----------|---------|
| "这次跳过" | 偷懒/赶时间 |
| "太简单" | 不想写测试 |
| "我需要先..." | 拖延写代码 |
```

**作用：** 预先列出智能体可能找的借口，并逐条反驳，比事后纠正更有效。

---

### 5.3 红色旗帜模式（Red Flags Pattern）

```markdown
## Red Flags — STOP

以下想法出现时，意味着你在合理化。立即停止：
- [具体想法1]
- [具体想法2]
```

**作用：** 识别正在犯错的思维模式，主动停止。

---

### 5.4 HARD-GATE 强制门禁

```markdown
<HARD-GATE>

在完成此步骤之前，不允许进入下一步。

⚠️ 此门禁不可绕过
</HARD-GATE>
```

**与普通步骤的区别：** 普通步骤可能被跳过或简化，HARD-GATE 是绝对屏障。

---

### 5.5 SUBAGENT-STOP 标签

```markdown
<SUBAGENT-STOP>
子智能体请跳过此部分内容。
</SUBAGENT-STOP>
```

**作用：** 防止子智能体重复执行已在父级完成的工作。

---

### 5.6 证据门禁（Evidence Gate）

```markdown
## Evidence Gate

在声称工作完成前，必须提供：
- 实际命令输出
- 实际测试结果
- 实际功能截图/日志

禁止仅凭推测声称成功。
```

---

### 5.7 双阶段审查模式

```markdown
阶段1: Spec Reviewer
  └─ 这个实现是否符合规格说明？

阶段2: Code Quality Reviewer
  └─ 代码本身的质量、安全性、最佳实践
```

**优势：** 分离关注点，避免一个审查者同时处理多个问题导致遗漏。

---

### 5.8 4层纵深防御（Defense-in-Depth）

```markdown
## 4-Layer Defense Model

Layer 1: 入口验证（输入检查）
Layer 2: 业务逻辑验证（中间状态）
Layer 3: 环境守卫（环境变量、配置）
Layer 4: 调试检测（日志、断言）

目标：让 Bug 在结构上不可能存在，而非逐个修复。
```

---

## 6. 多平台集成架构

### 6.1 5平台支持概览

```
┌─────────────────────────────────────────────────────────┐
│                    Superpowers v5                       │
│               单一 Skill 库，5个平台适配                  │
└──────┬──────────┬──────────┬──────────┬──────────┬─────┘
       │          │          │          │          │
   Claude Code  Cursor    Codex     OpenCode   Gemini CLI
   ───────────  ──────    ─────     ───────    ──────────
```

### 6.2 各平台集成方式

| 平台 | 集成方式 | Skill 加载 | 子智能体支持 |
|------|----------|-----------|------------|
| **Claude Code** | `.claude-plugin/` + hooks | Native Skill 系统 | Yes（Task 工具） |
| **Cursor** | `.cursor-plugin/plugin.json` | Native Skill 系统 | Yes |
| **Codex** | `~/.codex/superpowers/skills` 符号链接 | Native skill discovery | Yes（`multi_agent = true`） |
| **OpenCode** | `.opencode/plugins/superpowers.js`（ESM 插件） | via plugin config | Partial（@mention 系统） |
| **Gemini CLI** | `gemini-extension.json` + `GEMINI.md` | via GEMINI.md references | No（无 Task 工具） |

### 6.3 OpenCode 插件架构（`superpowers.js`）

```javascript
// 核心机制：ESM 插件 + config hook + system transform
export default {
  name: 'superpowers',
  hooks: {
    // 注册 skills 路径，OpenCode 发现 skills 不需要符号链接
    'config': ({ configs }, { registerConfig }) => {
      configs.push({ skills: { paths: ['.../superpowers/skills'] } });
    },
    // 注入 bootstrap 内容（修复 agent reset bug #226）
    'experimental.chat.system.transform': (transform) => {
      // 在每次 agent 响应前注入 using-superpowers 内容
    }
  }
};
```

### 6.4 Gemini CLI 适配

```markdown
# GEMINI.md 内容（入口文件）

引用：
- skills/using-superpowers/SKILL.md
- references/gemini-tools.md（工具映射表）
```

工具映射示例：
```
Claude Code: TodoWrite    → Gemini: AI's TodoWrite
Claude Code: Task         → Gemini: (不可用)
Claude Code: Skill        → Gemini: 直接引用
```

---

## 7. Hooks 系统

### 7.1 Superpowers 的极简 Hook 设计

Superpowers **只有一个 Hook**：

```json
// hooks/hooks.json
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "startup|resume|clear|compact",
        "hooks": [
          { "type": "command", "command": "${CLAUDE_PLUGIN_ROOT}/hooks/session-start" }
        ]
      }
    ]
  }
}
```

**触发时机：** `startup` | `resume` | `clear` | `compact`

**唯一功能：** 启动时注入 `using-superpowers` 的内容到会话。

---

### 7.2 session-start 脚本解析

```bash
#!/usr/bin/env bash
# session-start 脚本功能

1. 读取 skills/using-superpowers/SKILL.md
2. 转义 JSON 特殊字符（纯 bash 实现，跨平台）
3. 输出平台特定格式：
   - Claude Code: { "hookSpecificOutput": { "additionalContext": "..." } }
   - Cursor:      { "additional_context": "..." }
4. TMUX 自动通知（如果可用）
```

**JSON 转义实现（纯 bash，无 sed/awk）：**

```bash
# 速度优化：单次 C 层替换 vs 逐字符循环
output="${output//\\/\\\\}"   # 反斜杠
output="${output//\"/\\\"}"   # 双引号
output="${output//$'\n'/\n}"  # 换行
output="${output//$' '/ }"    # 空格（防止解析问题）
```

---

### 7.3 run-hook.cmd 跨平台包装器

```batch
@echo off
goto :CMDBLOCK

:CMDBLOCK
bash "%~dp0%~1"
exit /b %errorlevel%

:CMDBLOCK
@echo off
setlocal
...
```

**原理：** `:CMDBLOCK` 是 CMD 的空标签，bash 将 `: << 'CMDBLOCK'` 视为空 heredoc——两种解释都合法。

---

## 8. 与 ECC 的关键差异

### 8.1 设计理念

| 维度 | Superpowers | ECC |
|------|------------|-----|
| **哲学** | 纪律约束（强制执行） | 工具箱（自由组合） |
| **复杂度** | 极简（16 Skill + 1 Agent） | 丰富（140+ Skill + 30 Agent + 60 Command） |
| **入口机制** | Skill + 上下文激活 | Slash Command（显式） |
| **强制性** | 高（Iron Law + HARD-GATE） | 中（建议性规范） |
| **工作流深度** | 深（每步都有方法论） | 宽（覆盖更多领域） |

### 8.2 组件数量对比

| 组件 | Superpowers | ECC |
|------|------------|-----|
| **Skill** | 16 | 140+ |
| **Agent** | 1 | 30 |
| **Command** | 0（全部废弃） | 60+（活跃） |
| **Rule** | 0 | 大量（common/ + 语言特定） |
| **Hook** | 1（SessionStart） | 14+（PreToolUse + PostToolUse + Stop + etc.） |

### 8.3 Skill 描述风格

**Superpowers（触发条件格式）：**
```yaml
description: "Use when beginning a new feature, architectural decision,
              or complex implementation — before writing any code"
```
→ 格式："Use when [触发条件] — [做什么]"

**ECC（可变格式）：**
```yaml
description: "Test-Driven Development workflow skill for writing
              reliable, well-tested code"
```
→ 格式：描述性，非触发条件

### 8.4 Skill 依赖关系

**Superpowers（强依赖）：**
```
using-superpowers
    └─ 强制调用其他相关 Skill

writing-plans
    └─ 末尾强制选择 subagent-driven-development 或 executing-plans

subagent-driven-development
    └─ 内部调用 requesting-code-review
```

**ECC（松散引用）：**
```
Command 引用 Agent（文字说明）
Agent 引用 Skill（skill: 标记）
无强制依赖链
```

---

## 9. Superpowers 的核心创新

### 9.1 以 Skill 为唯一入口

ECC 以 Command 为用户入口，Superpowers 完全废弃 Command，用户通过描述场景激活 Skill。好处是用户无需记忆命令，坏处是需要更好的 Skill 发现机制（通过 `using-superpowers` 实现）。

### 9.2 纪律约束机制

**Iron Law + Rationalization Table + Red Flags** 三位一体：

```
Iron Law          → 不可违背的底线
Rationalization Table → 预判借口并反驳
Red Flags         → 识别正在犯错的思维
```

这是 ECC 完全缺失的机制。ECC 的规范是"建议性的"，Superpowers 的规范是"强制性的"。

### 9.3 完整代码原则（No Placeholders）

Superplans 要求每个计划步骤包含完整代码，TODO/TBD 模式被明确禁止。这比 ECC 的 `/plan` 更有约束力，但需要更多前期工作。

### 9.4 证据门禁（Evidence Gate）

在声称完成前必须展示实际证据（命令输出、测试结果），而非推测。这是"证据驱动"哲学的具体实现。

### 9.5 TDD for Skills

将 TDD 方法论应用于 Skill 开发本身：
```
RED  → 故意写错误的内容
GREEN → 修复为正确内容
REFACTOR → 简化结构
```

### 9.6 模型分级策略

根据任务复杂度选择不同能力的模型（便宜任务用 cheap 模型，复杂任务用 most capable），而非一刀切的模型选择。

### 9.7 平台检测与适配

通过环境变量（`CURSOR_PLUGIN_ROOT` / `CLAUDE_PLUGIN_ROOT`）自动检测平台，输出不同格式的 Hook 结果，无需平台特定代码。

### 9.8 纯 Bash JSON 转义

不使用 sed/awk，改用 bash 参数替换（`${s//old/new}`），每种替换在 C 层单次完成，速度更快，且兼容 Windows Git Bash。

---

## 附录：Superpowers 快速参考

### Skill 触发速查

| 场景 | 调用的 Skill |
|------|-------------|
| 开始新功能 | `brainstorming` → `writing-plans` |
| 执行计划 | `subagent-driven-development` |
| 写代码 | `test-driven-development` |
| 调试问题 | `systematic-debugging` |
| 声称完成 | `verification-before-completion` |
| 请求审查 | `requesting-code-review` |
| 接收反馈 | `receiving-code-review` |
| 合并分支 | `finishing-a-development-branch` |
| 并行调试 | `dispatching-parallel-agents` |
| 隔离开发 | `using-git-worktrees` |
| 编写新 Skill | `writing-skills` |

### Agent 状态码

| 状态 | 含义 |
|------|------|
| `DONE` | 成功完成 |
| `DONE_WITH_CONCERNS` | 完成但有遗留问题 |
| `BLOCKED` | 被阻塞，需要人工介入 |
| `NEEDS_CONTEXT` | 需要更多上下文才能继续 |
