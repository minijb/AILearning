# Agents 目录设计思路

## 一、概述

ECC 的 Agents 目录包含 **30 个专家子代理**，每个 Agent 是一个 Markdown 文件，通过 YAML frontmatter 定义元数据（`name`、`description`、`tools`、`model`）。这些 Agent 是"专家中的专家"——它们不是通用助手，而是深度专精于某一领域的子代理。

---

## 二、Agent 文件格式

### 2.1 Frontmatter 元数据

```yaml
---
name: code-reviewer              # 唯一标识符
description: 代码审查专家...      # 用于自动调度决策（关键！）
tools: ["Read", "Grep", "Glob", "Bash", "Edit"]  # 允许的工具列表
model: sonnet                    # 推荐模型（sonnet/opus/haiku）
color: blue                      # 可选：UI 显示颜色
---
```

**自动调度原理**：Claude Code 根据 `description` 字段的内容判断何时应该调用哪个 Agent。描述越精准，调度越准确。

### 2.2 内容结构

每个 Agent 文件包含：
1. **Role Definition**：Agent 的身份定义
2. **Responsibilities**：核心职责列表
3. **Workflow**：执行流程（步骤化）
4. **Output Format**：标准化输出格式
5. **Examples**（可选）：使用示例

---

## 三、Agent 分类与职责

### 3.1 审查类 Agent（Reviewer）

| Agent | 语言/领域 | 特点 |
|-------|---------|------|
| `code-reviewer.md` | 通用 | 80%+ 置信度才报告，严重性分级（CRITICAL→LOW） |
| `security-reviewer.md` | 通用 | OWASP Top 10 检查、漏洞模式表 |
| `tdd-guide.md` | 通用 | RED→GREEN→REFACTOR 循环、80% 覆盖率要求 |
| `go-reviewer.md` | Go | Go 特定审查（defer/goroutine/接口） |
| `rust-reviewer.md` | Rust | Rust 特定审查（生命周期/所有权） |
| `cpp-reviewer.md` | C++ | C++ 特定审查（RAII/模板/内存管理） |
| `python-reviewer.md` | Python | Python 特定审查（GIL/类型提示） |
| `java-reviewer.md` | Java | Java 特定审查 |
| `kotlin-reviewer.md` | Kotlin | Kotlin 特定审查 |
| `typescript-reviewer.md` | TypeScript | TypeScript 特定审查 |
| `database-reviewer.md` | 数据库 | SQL 审查、索引分析 |
| `healthcare-reviewer.md` | 医疗 | HIPAA 合规、PHI 处理 |
| `flutter-reviewer.md` | Flutter | Flutter 特定审查 |

**code-reviewer 设计亮点**：
```markdown
## 置信度阈值
仅报告置信度 ≥ 80% 的问题。
置信度 < 80% → 静默忽略，不浪费用户时间。

## 严重性分级
- CRITICAL: 立即修复（安全漏洞、数据丢失风险）
- HIGH: 下一迭代修复
- MEDIUM: 代码审查期间讨论
- LOW: 建议改进（非阻塞）
```

**security-reviewer 设计亮点**：
```markdown
## 漏洞模式表
| 类型 | 模式 | 风险 |
|------|------|------|
| SQL注入 | 用户输入拼接SQL | CRITICAL |
| XSS | innerHTML/eval | HIGH |
| 硬编码凭证 | API_KEY/password明文 | CRITICAL |
| 不安全的随机数 | Math.random() | HIGH |
```

### 3.2 构建错误解决类 Agent（Build Resolver）

| Agent | 工具链 |
|-------|--------|
| `build-error-resolver.md` | 通用 |
| `go-build-resolver.md` | Go (go build/test) |
| `rust-build-resolver.md` | Cargo |
| `cpp-build-resolver.md` | g++/cmake |
| `java-build-resolver.md` | Gradle/Maven |
| `kotlin-build-resolver.md` | Gradle |
| `pytorch-build-resolver.md` | PyTorch |

**设计模式**：分析错误信息 → 分类错误类型 → 渐进式修复（一次修一个） → 验证

### 3.3 架构与规划类 Agent

| Agent | 职责 |
|-------|------|
| `planner.md` | 阶段性规划、风险评估、实现计划 |
| `architect.md` | 系统设计、架构决策（mermaid 图） |
| `harness-optimizer.md` | Agent 工具链配置优化（工具/Evals/路由） |

**planner 的工作流程**：
```
需求分析 → 依赖识别 → 风险评估 → 阶段分解 → 实现步骤
    ↓           ↓          ↓          ↓          ↓
  [理解意图]  [外部依赖]  [风险点]  [分步骤]  [每步交付物]
```

### 3.4 测试类 Agent

| Agent | 职责 |
|-------|------|
| `tdd-guide.md` | TDD 全流程引导 |
| `e2e-runner.md` | Playwright E2E 测试执行 |

**tdd-guide 的核心流程**：
```markdown
RED:   写一个会失败的测试（明确期望行为）
GREEN: 写最少量代码让测试通过（不追求完美）
REFACTOR: 重构代码，测试始终保持绿色
```

### 3.5 运营与维护类 Agent

| Agent | 职责 | 模型 |
|-------|------|------|
| `loop-operator.md` | 自主循环监控、停顿检测、恢复动作 | sonnet |
| `harness-optimizer.md` | Agent 工具链优化 | sonnet |
| `doc-updater.md` | 文档同步 | - |
| `refactor-cleaner.md` | 死代码清理 | - |
| `performance-optimizer.md` | 性能分析与优化（Bundle/内存/算法） | sonnet |

**loop-operator 的关键设计**：
```markdown
## 必需检查
- 质量门禁处于激活状态
- eval 基线存在
- 回滚路径存在
- 分支/worktree 隔离已配置

## 升级条件（满足任一即升级）
- 连续两个检查点无进展
- 相同堆栈跟踪的重复失败
- 成本漂移超出预算窗口
- 合并冲突阻塞队列
```

### 3.6 通信类 Agent

| Agent | 职责 |
|-------|------|
| `chief-of-staff.md` | 跨 5 渠道通信分类（Email/Slack/LINE/Messenger/Calendar） |

**4 级消息分类系统**：
```markdown
1. skip（自动归档）：来自 noreply/机器人/通知
2. info_only（仅摘要）：CC邮件、群公告
3. meeting_info（日历交叉）：包含会议链接和时间
4. action_required（起草回复）：需要回复的私信/@提及
```

### 3.7 文档类 Agent

| Agent | 工具 | 特点 |
|-------|------|------|
| `docs-lookup.md` | Context7 MCP | 实时文档查询，prompt injection 防护 |

---

## 四、Agent 间的编排关系

### 4.1 固定编排链（/orchestrate 命令）

```bash
# Feature 工作流
/orchestrate feature "用户认证功能"
# 等价于：
planner → tdd-guide → code-reviewer → security-reviewer

# Bugfix 工作流
planner → tdd-guide → code-reviewer

# Refactor 工作流
architect → code-reviewer → tdd-guide

# Security 工作流
security-reviewer → code-reviewer → architect
```

### 4.2 Agent 间 Handoff 文档格式

```markdown
## HANDOFF: [上一Agent] → [下一Agent]

### Context
[总结已完成的工作]

### Findings
[关键发现或决策]

### Files Modified
[修改的文件列表]

### Open Questions
[未解决的问题，传递给下一 Agent]

### Recommendations
[建议的下一步]
```

---

## 五、模型选择策略

| Agent 类型 | 推荐模型 | 原因 |
|-----------|---------|------|
| 复杂架构审查 | Opus | 深度推理，防止遗漏 |
| 通用代码审查 | Sonnet | 最佳性价比 |
| TDD 引导 | Sonnet | 平衡速度与质量 |
| 构建错误修复 | Sonnet | 快速响应 |
| 性能优化 | Sonnet | 分析与优化需要上下文 |
| 死代码清理 | Haiku | 简单机械操作 |
| 文档查询 | Haiku | 结构简单 |

---

## 六、设计亮点总结

### 6.1 Description 字段的自动调度价值

Agent 的 `description` 不只是注释，而是**自动路由决策的核心依据**。Claude Code 会根据 description 内容决定何时调用该 Agent。好的 description 应该：
- 明确使用场景（"当...时使用"）
- 列出核心职责
- 避免与其他 Agent 重叠

### 6.2 置信度阈值设计

`code-reviewer` 要求 80% 置信度才报告，这是一个重要的 UX 设计：
- **避免噪音**：减少低价值反馈对用户的干扰
- **阈值可调**：可按项目需求调整
- **分级输出**：低置信度问题可单独列出，由用户决定是否处理

### 6.3 严重性分级的实际价值

CRITICAL/HIGH/MEDIUM/LOW 分级使用户能快速定位最关键的问题：
- CRITICAL：立即阻断
- HIGH：下一迭代
- MEDIUM：审查时讨论
- LOW：可选改进

### 6.4 工具列表（allowlist）的安全价值

每个 Agent 的 `tools` 字段限制了可用工具：
- `chief-of-staff` 只用 Read/Grep/Glob/Bash/Edit（不写代码）
- `docs-lookup` 只用 MCP 工具（只读查询）
- 限制工具 = 降低误操作风险 = 专注执行

---

*基于 everything-claude-code/agents/ 目录深度分析*
