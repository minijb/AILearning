# Commands 目录设计思路

## 一、概述

Commands（命令）是用户**主动调用**的快捷工作流入口，是 Skills 的快速执行版本。每个 Command 本质上是一个预定义的工作流模板，用户通过斜杠命令（`/command-name`）触发。

ECC 包含 **60 个命令**，覆盖从 TDD、规划、审查到持续学习的全流程。

---

## 二、Command 文件格式

```markdown
---
name: tdd
description: 完整 TDD 流程引导
command: true
---

# Test-Driven Development Command

## 实现说明

执行步骤...

## 使用方式

/tdd [功能描述]
```

`command: true` 标记表示这是一个可执行的斜杠命令。

---

## 三、核心命令详解

### 3.1 /tdd — 测试驱动开发

**最核心的命令**，完整执行 TDD 循环：

```markdown
# RED: 写一个会失败的测试
describe('UserService', () => {
  it('should hash password before saving', () => {
    const service = new UserService();
    const user = service.create({ email: 'test@example.com', password: 'secret123' });
    expect(user.passwordHash).not.toBe('secret123');
    expect(user.passwordHash).toMatch(/^\$2[aby]?\$\d{2}\$/);  // bcrypt 格式
  });
});

# GREEN: 写最少量代码让测试通过
class UserService {
  create(data: CreateUserDto) {
    return {
      ...data,
      passwordHash: bcrypt.hash(data.password, 10),
    };
  }
}

# REFACTOR: 重构（测试保持绿色）
// 提取接口、分隔关注点、清理命名
```

**TDD 的三个强制步骤**：
1. **RED**：先写测试（明确期望行为）
2. **GREEN**：写最少量代码（不追求完美）
3. **REFACTOR**：在测试保护下重构

### 3.2 /plan — 多模型协作规划

**设计亮点**：使用 Codex + Gemini 双模型并行分析，Codex 负责后端，Gemini 负责前端。

```markdown
## 工作流程

Phase 1: 全量上下文检索
  → ace-tool MCP 增强 prompt（如可用）
  → 语义检索项目上下文
  → 递归获取完整定义和签名

Phase 2: 多模型协作分析
  → Codex（后端权威）：技术可行性、架构影响
  → Gemini（前端权威）：UX impact、视觉设计
  → 等待两者完成（后台并行）

Phase 3: 跨模型交叉验证
  → 识别共识（强信号）
  → 识别分歧（需要权衡）
  → 互补优势

Phase 4: 生成实施计划（Claude 最终版）
  → 合成两模型分析
  → 保存到 .claude/plan/<feature-name>.md
  → **立即终止**（不自动执行）
```

**关键设计**：
- `/plan` **只规划，不执行**（用户批准后才执行）
- `SESSION_ID` handoff 用于后续 `/ccg:execute` 恢复
- 外部模型（Codex/Gemini）**零文件系统写权限**

### 3.3 /orchestrate — 多 Agent 串联编排

**定义**：顺序执行多个 Agent，形成完整工作流链。

```markdown
## 工作流类型

### feature（完整功能）
planner → tdd-guide → code-reviewer → security-reviewer

### bugfix（Bug 修复）
planner → tdd-guide → code-reviewer

### refactor（重构）
architect → code-reviewer → tdd-guide

### security（安全审查）
security-reviewer → code-reviewer → architect
```

**Agent 间 Handoff 文档格式**：
```markdown
## HANDOFF: [上一Agent] → [下一Agent]

### Context
[已完成工作的摘要]

### Findings
[关键发现或决策]

### Files Modified
[修改的文件列表]

### Open Questions
[未解决事项，传递给下一 Agent]

### Recommendations
[建议的下一步]
```

**最终报告格式**：
```markdown
ORCHESTRATION REPORT
====================
Workflow: feature
Task: Add user authentication
Agents: planner → tdd-guide → code-reviewer → security-reviewer

SUMMARY: [一句话总结]
FILES CHANGED: [文件列表]
TEST RESULTS: [测试结果]
SECURITY STATUS: [安全状态]
RECOMMENDATION: [SHIP / NEEDS WORK / BLOCKED]
```

### 3.4 /model-route — 模型选择建议

```markdown
## 路由启发式

- `haiku`: 确定性、低风险的机械性修改
- `sonnet`: 实现和重构的默认选择
- `opus`: 架构、深度审查、模糊需求

## 输出格式

- 推荐模型
- 置信度级别
- 为什么此模型合适
- 首个尝试失败后的备选模型
```

### 3.5 /skill-create — 从 Git 历史生成 Skill

**工作流程**：
```
1. 解析 Git 历史（提交、文件变更、模式）
2. 检测模式：
   - 提交约定（feat:/fix:前缀）
   - 文件共变更（总是同时变更的文件）
   - 工作流序列（重复的变更序列）
   - 架构（目录结构和命名约定）
   - 测试模式（测试文件位置、覆盖率）
3. 生成 SKILL.md 文件
4. 可选：同时生成 Instincts
```

### 3.6 /evolve — 本能演进

```markdown
## 演进规则

→ Command（用户调用）
  当本能描述用户显式请求的动作时
  示例：多个关于"创建新 X"的本能 → new-table command

→ Skill（自动触发）
  当本能描述应自动发生的行为时
  示例：prefer-functional + use-immutable + avoid-classes → functional-patterns skill

→ Agent（需要深度/隔离）
  当本能描述受益于隔离的复杂多步流程时
  示例：debug-check-logs + debug-isolate + debug-reproduce → debugger agent
```

### 3.7 /learn — 从会话提取模式

```markdown
## 提取内容

1. 错误解决模式（错误 → 根因 → 修复）
2. 调试技术（非显而易见的调试步骤）
3. 变通方案（库特性/API 限制/版本修复）
4. 项目特定模式（代码库约定、架构决策）

## 输出格式

~/.claude/skills/learned/[pattern-name].md：

# [描述性模式名称]

**提取日期：** [日期]
**上下文：** [适用场景简述]

## Problem
[解决的问题——要具体]

## Solution
[模式/技术/变通方案]

## Example
[代码示例（如适用）]

## When to Use
[触发条件]
```

### 3.8 /loop-start — 启动自主循环

```markdown
## 模式

- `sequential`: 顺序执行，有检查点
- `continuous-pr`: 持续创建 PR
- `rfc-dag`: RFC 有向无环图驱动
- `infinite`: 无限循环（需明确停止条件）

## 安全模式（默认）

必需检查：
- 验证首次循环迭代前测试通过
- 确保 ECC_HOOK_PROFILE 未被全局禁用
- 确保循环有明确停止条件

## 快速模式

减少门禁以提升速度（风险更高）
```

### 3.9 其他重要命令

| 命令 | 功能 |
|------|------|
| `/multi-plan` | 多特性并行规划 |
| `/multi-execute` | 多特性并行执行 |
| `/multi-backend` / `/multi-frontend` | 后端/前端并行开发 |
| `/verify` | 端到端验证 |
| `/quality-gate` | 质量门禁检查 |
| `/test-coverage` | 覆盖率分析 |
| `/context-budget` | 上下文预算评估 |
| `/prompt-optimize` | Prompt 优化 |
| `/instinct-status` | 查看学习本能状态 |
| `/instinct-export` / `/instinct-import` | 本能导入导出 |
| `/promote` | 本能晋升（项目→全局） |
| `/projects` | 列出所有项目及其本能数量 |

---

## 四、命令与 Agent 的关系

```
Commands（用户主动触发）
    ↓ 触发
Skills（场景自动激活）
    ↓ 编排
Agents（专家子代理执行）
    ↓ 依据
Rules（始终约束）
    ↓ 自动化
Hooks（生命周期事件）
```

**Commands 是入口，Agents 是执行者，Rules 是约束，Hooks 是护栏。**

---

## 五、设计亮点总结

### 5.1 命令的分层设计

ECC 的命令不是独立的，而是嵌入在更大的生态中：
- `/tdd` → 调用 `tdd-guide` Agent
- `/orchestrate` → 串联多个 Agent
- `/evolve` → 调用本能 CLI 工具
- `/skill-create` → 解析 Git 历史

这意味着 Commands 是**编排层**，而不是"一条命令做所有事"。

### 5.2 `/plan` 的双模型协作设计

使用 Codex（后端权威）+ Gemini（前端权威）双模型并行分析，是**互补优势**思维的极致应用：
- 后端关注技术可行性、架构
- 前端关注 UX、视觉
- Claude 作为仲裁者和计划综合者

### 5.3 停止条件的强制要求

`/loop-start` 要求必须有明确停止条件（`loop-operator` 定义了升级条件），这体现了 ECC 对**自主系统风险控制**的深刻理解：没有停止条件的循环是危险的。

### 5.4 本能驱动的命令生成

`/skill-create` 和 `/learn` 命令的设计，使得命令本身也可以从实际使用中**自我进化**——通过分析真实的工作流，自然涌现新的命令。

---

*基于 everything-claude-code/commands/ 目录深度分析*
