# Skills 目录设计思路

## 一、概述

Skills（技能）是 ECC 中定义 Claude 在特定场景下应该如何工作的核心组件。与 Agents 的"专家执行"不同，Skills 更侧重于**行为模式和领域知识**的沉淀。ECC 包含 135+ Skills，分为两大类：

1. **行为类 Skills**：编码标准、TDD 工作流、安全审查等
2. **学习系统 Skills**：`continuous-learning-v2` — 本能（Instinct）架构

---

## 二、Skill 文件格式

### 2.1 标准 Skill 结构

```markdown
---
name: tdd-workflow
description: Test-driven development workflow for new features
version: 1.0.0
---

# TDD Workflow

## When to Use
[在什么情况下激活此 Skill]

## How It Works
[具体的工作流程]

## Examples
[代码示例]
```

### 2.2 Continuous Learning v2.1 格式

```yaml
---
name: continuous-learning-v2
description: Instinct-based learning system...
origin: ECC
version: 2.1.0
---

# Continuous Learning v2.1 - Instinct-Based Architecture
```

---

## 三、Continuous Learning v2.1 — 核心学习系统

### 3.1 为什么需要本能（Instinct）架构？

**问题**：传统 Skill 系统是"手工编写"的，需要人工维护，学习是单向的（人→Claude）。

**解决方案**：通过 Hook 100% 可靠地捕获会话行为，自动生成带置信度的"本能"（Instinct），再聚类演进为完整的 Skill/Command/Agent。

> "v1 依赖 Skills 来观察，但 Skills 是概率性触发的——根据 Claude 的判断，触发率约为 50-80%。"
> Hook 以 **100% 确定性**触发，不遗漏任何模式。

### 3.2 本能（Instinct）模型

一个本能是一个小型学习单位：

```yaml
---
id: prefer-functional-style        # 唯一 ID
trigger: "when writing new functions"  # 触发条件
confidence: 0.7                     # 置信度 0.3–0.9
domain: "code-style"                # 领域标签
source: "session-observation"       # 来源
scope: project                     # 作用域：project/global
project_id: "a1b2c3d4e5f6"         # 项目哈希
project_name: "my-react-app"
---

# Prefer Functional Style

## Action
Use functional patterns over classes when appropriate.

## Evidence
- Observed 5 instances of functional pattern preference
- User corrected class-based approach to functional on 2025-01-15
```

**关键属性**：
- **Atomic**：一个本能 = 一个触发条件 + 一个行为
- **Confidence-weighted**：0.3 = 试探性建议，0.9 = 核心行为
- **Domain-tagged**：code-style / testing / git / debugging / workflow
- **Evidence-backed**：追踪创建该本能的原始观察
- **Scope-aware**：`project`（项目隔离）或 `global`（跨项目共享）

### 3.3 置信度评分机制

| 分数 | 含义 | 行为 |
|------|------|------|
| 0.3 | 试探性 | 仅建议，不强制 |
| 0.5 | 中等 | 相关时应用 |
| 0.7 | 强 | 自动批准应用 |
| 0.9 | 近乎确定 | 核心行为 |

**置信度上升条件**：
- 模式被反复观察到
- 用户未纠正建议的行为
- 其他来源的相似本能一致

**置信度下降条件**：
- 用户明确纠正行为
- 模式长时间未观察到
- 出现矛盾的证据

### 3.4 项目作用域隔离（v2.1 核心创新）

**问题**：v1 的本能是全局的，React 项目的模式会污染 Python 项目。

**解决方案**：
```
项目检测优先级：
1. CLAUDE_PROJECT_DIR 环境变量（最高优先级）
2. git remote get-url origin（哈希 → 便携式项目 ID）
3. git rev-parse --show-toplevel（降级：机器特定路径）
4. 全局降级（无项目 → 本能进入全局作用域）
```

每个项目获得 12 位哈希 ID（如 `a1b2c3d4e5f6`），跨机器的同一仓库共享相同 ID。

### 3.5 完整学习闭环流程

```
会话活动（PreToolUse/PostToolUse Hook 100% 捕获）
      ↓
项目检测（git remote / repo path → hash ID）
      ↓
+---------------------------------------------+
|  projects/<hash>/observations.jsonl          |
|  （prompts、工具调用、结果、项目 ID）          |
+---------------------------------------------+
      ↓
Haiku 后台 Agent 分析（轻量级，异步）
      ↓
模式检测：
  * 用户纠正 → 本能
  * 错误解决 → 本能
  * 重复工作流 → 本能
      ↓
创建/更新本能文件
+---------------------------------------------+
|  projects/<hash>/instincts/personal/        |
|  ~/.claude/homunculus/instincts/personal/   |（全局）
+---------------------------------------------+
      ↓
/evolve 聚类（相关本能 → Skill/Command/Agent）
/promote（项目本能 → 跨 2+ 项目验证后升级全局）
```

---

## 四、Evolution — 本能的演进

### 4.1 演进规则

| 本能聚类类型 | 产出 | 条件 |
|------------|------|------|
| **→ Command** | 用户主动调用的斜杠命令 | 多条本能描述用户显式请求的动作 |
| **→ Skill** | 自动触发的行为模式 | 模式匹配触发、错误处理响应、代码风格执行 |
| **→ Agent** | 需要深度/隔离的复杂多步流程 | 高置信度的大型本能集群（调试/重构/研究） |

### 4.2 本能晋升（Project → Global）

**自动晋升标准**：
- 相同本能 ID 出现在 2+ 个项目中
- 平均置信度 ≥ 0.8

**手动晋升**：
```bash
python3 instinct-cli.py promote prefer-explicit-errors
python3 instinct-cli.py promote --dry-run  # 预览
```

---

## 五、目录结构

```
~/.claude/homunculus/                    # 本能存储根目录
+-- identity.json                        # 用户画像、技术水平
+-- projects.json                        # 项目注册表（hash → 名称/路径/remote）
+-- observations.jsonl                   # 全局观察（降级fallback）
+-- instincts/
|   +-- personal/                        # 全局自动学习本能
|   +-- inherited/                        # 全局导入本能
+-- evolved/
|   +-- agents/                           # 全局演化出的 Agent
|   +-- skills/                           # 全局演化出的 Skill
|   +-- commands/                         # 全局演化出的 Command
+-- projects/
    +-- a1b2c3d4e5f6/                     # 项目哈希（来自 git remote URL）
    |   +-- project.json                   # 项目元数据（镜像）
    |   +-- observations.jsonl             # 观察数据流
    |   +-- observations.archive/           # 归档
    |   +-- instincts/
    |   |   +-- personal/                   # 项目自学的本能
    |   |   +-- inherited/                   # 项目导入的本能
    |   +-- evolved/
    |       +-- skills/
    |       +-- commands/
    |       +-- agents/
    +-- f6e5d4c3b2a1/                     # 另一个项目
        +-- ...
```

---

## 六、作用域决策指南

| 模式类型 | 推荐作用域 | 示例 |
|---------|----------|------|
| 语言/框架约定 | **project** | "Use React hooks"，"Follow Django REST patterns" |
| 文件结构偏好 | **project** | "Tests in `__tests__`/"，"Components in src/components/" |
| 代码风格 | **project** | "Use functional style"，"Prefer dataclasses" |
| 错误处理策略 | **project** | "Use Result type for errors" |
| 安全实践 | **global** | "Validate user input"，"Sanitize SQL" |
| 通用最佳实践 | **global** | "Write tests first"，"Always handle errors" |
| 工具工作流偏好 | **global** | "Grep before Edit"，"Read before Write" |
| Git 实践 | **global** | "Conventional commits"，"Small focused commits" |

---

## 七、隐私设计

- 观察数据存储在**本地机器**
- 项目本能**隔离存储**，不跨项目泄露
- 只能导出**本能（模式）**，不能导出原始观察数据或会话内容
- 用户完全控制导出和晋升操作

---

## 八、Skill 的使用位置策略

ECC 区分两类 Skill 存储位置：

| 位置 | 内容 | 说明 |
|------|------|------|
| `skills/`（ECC 内置） | 精心策划的 Skill | ECC 团队维护的高质量 Skill |
| `~/.claude/skills/` | 用户生成/导入的 Skill | 用户自己的积累 |

详见 `docs/SKILL-PLACEMENT-POLICY.md`。

---

## 九、设计亮点总结

### 9.1 Hook > Skill 的可靠性

> "v1 relied on skills to observe. Skills are probabilistic — they fire ~50-80% of the time based on Claude's judgment."
> Hooks fire **100% of the time**, deterministically.

这是 ECC 最深刻的设计洞察：**用确定性触发替代概率性触发**。

### 9.2 原子化 > 整体化

v1 直接生成完整 Skill，v2 生成原子本能再聚类。原子化的优势：
- 更细粒度的置信度跟踪
- 跨项目共享时选择性更强（只共享部分本能）
- 聚类过程更灵活

### 9.3 项目隔离防止知识污染

本能架构 v2.1 最大的改进：React 模式不会污染 Python 项目。跨项目共享通过显式晋升机制，避免了"通用但都不准"的问题。

### 9.4 渐进式演进

本能 → 聚类 → 演化 → 晋升，这是一条渐进式路径：
- 初期：轻量本能，修改成本低
- 中期：聚类形成 Skill/Command
- 成熟：晋升为全局规则

---

*基于 everything-claude-code/skills/ 目录深度分析*
