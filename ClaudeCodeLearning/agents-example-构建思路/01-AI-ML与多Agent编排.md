# agents_example 插件分类分析 — AI/ML 与多 Agent 编排

## 一、llm-application-dev — LLM 应用开发

### 1.1 插件概述

LLM 应用开发插件是 agents_example 中技能最密集的插件之一，包含 **8 个专业 Skill**，覆盖从 LangChain/LangGraph 架构到 RAG、Prompt 工程、Embedding、评估的全链路。

### 1.2 8 个专业 Skill

| Skill | 描述 | 核心内容 |
|-------|------|---------|
| `langchain-architecture` | LangGraph agent 架构（2026 标准） | StateGraph、ReAct、Plan-and-Execute、多 Agent |
| `prompt-engineering-patterns` | Prompt 性能优化 | Chain-of-thought、Few-shot、System prompt 优化 |
| `rag-implementation` | RAG 系统实现 | 向量数据库、语义搜索、混合搜索 |
| `llm-evaluation` | LLM 评估策略 | 自动指标、基准测试、A/B 测试 |
| `embedding-strategies` | Embedding 管道 | 文本/图像/多模态分块策略 |
| `similarity-search-patterns` | 相似性搜索 | ANN 算法、HNSW/IVF、距离度量 |
| `vector-index-tuning` | 向量索引优化 | HNSW、IVF、混合配置 |
| `hybrid-search-implementation` | 混合搜索 | 向量 + 关键词组合检索 |

### 1.3 LangGraph 架构（2026 标准）

**核心概念**：
```python
# LangGraph = StateGraph + 显式状态管理
from langgraph.graph import MessagesState

# Agent 模式：
# - ReAct: Reasoning + Acting
# - Plan-and-Execute: 分离规划和执行
# - Multi-Agent: 主管路由
# - Tool-Calling: 结构化工具调用 + Pydantic schemas
```

**LangGraph 的关键特性**：
- **StateGraph**：带类型状态的显式状态管理
- **Durable Execution**：Agent 持久化穿越故障
- **Human-in-the-Loop**：任意点检查和修改状态
- **Checkpointing**：保存和恢复 Agent 状态

### 1.4 RAG 实现模式

**标准 RAG 管道**：
```
用户查询 → Embedding → 向量数据库检索 → 上下文组装 → LLM 生成
```

**混合搜索**：
```python
# 组合向量相似度和 BM25 关键词分数
hybrid_score = alpha * vector_similarity + (1-alpha) * bm25_score
```

---

## 二、agent-orchestration — Agent 编排优化

### 2.1 插件概述

专注于**多 Agent 系统的性能优化**，提供 Agent 性能分析、瓶颈识别、自适应优化策略。

### 2.2 核心 Agent

| Agent | 职责 |
|-------|------|
| `context-manager` | 上下文管理专家 |

### 2.3 核心命令

| 命令 | 功能 |
|------|------|
| `improve-agent` | 分析并改进 Agent 定义 |
| `multi-agent-optimize` | 多 Agent 协调优化 |

### 2.4 多 Agent 性能优化框架

```markdown
## 性能优化维度

1. **Database Performance Agent** — 查询执行时间、索引利用率
2. **Application Performance Agent** — CPU/内存分析
3. **Network Performance Agent** — 延迟、吞吐量
4. **Cache Efficiency Agent** — 缓存命中率分析
```

---

## 三、agent-teams — 多 Agent 团队编排

### 3.1 核心创新

Agent Teams 是 Claude Code 的**实验性功能**，支持真正的并行多 Agent 工作流：

```bash
export CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1
```

**三种显示模式**：
- `tmux`：每个队友一个 tmux pane（推荐）
- `iterm2`：每个队友一个 iTerm2 tab
- `in-process`：同一进程（默认）

### 3.2 4 个专业 Agent

| Agent | 模型 | 角色颜色 | 职责 |
|-------|------|---------|------|
| `team-lead` | - | 蓝色 | 团队协调者，分解工作，管理生命周期 |
| `team-reviewer` | - | 绿色 | 多维代码审查者，按分配维度审查 |
| `team-debugger` | - | 红色 | 假设调查者，收集证据 |
| `team-implementer` | - | 黄色 | 并行构建者，文件所有权边界内实现 |

### 3.3 团队预设（7 种）

**review 预设**：
```
team-lead → team-reviewer (security)
         → team-reviewer (performance)
         → team-reviewer (architecture)
         → team-reviewer (testing)
         → team-reviewer (accessibility)
```

**debug 预设**（假设驱动调试）：
```
team-lead → team-debugger (假设 1)
         → team-debugger (假设 2)
         → team-debugger (假设 3)
```

**feature 预设**（并行功能开发）：
```
team-lead → team-implementer (组件 A)
         → team-implementer (组件 B)
         → team-implementer (组件 C)
```

### 3.4 文件所有权边界

Agent Teams 的关键设计：**并行构建时，team-implementer 被严格限制在文件所有权边界内**：

```markdown
## 文件所有权分配示例

Implementer 1: src/components/*      # 前端组件
Implementer 2: src/api/*            # API 端点
Implementer 3: src/db/*             # 数据库层

边界规则：
- 不修改他人所有权的文件
- 冲突时通过 team-lead 协调
- 依赖通过接口文件传递
```

### 3.5 6 个专业 Skill

| Skill | 描述 |
|-------|------|
| `team-composition-patterns` | 团队规模启发法、预设组合、Agent 类型选择 |
| `task-coordination-strategies` | 任务分解、依赖图、工作负载平衡 |
| `multi-reviewer-patterns` | 多审查者协调、维度分配 |
| `parallel-debugging` | 假设测试、证据收集 |
| `parallel-feature-development` | 文件所有权、合并策略 |
| `team-communication-protocols` | 团队消息模式 |

### 3.6 任务协调策略（task-coordination-strategies）

**4 种分解策略**：

| 策略 | 适用场景 |
|------|---------|
| **By Layer** | 前端/后端/数据库/测试分层 |
| **By Component** | 按功能组件（认证/通知/支付） |
| **By Concern** | 跨切面（安全/性能/架构审查） |
| **By File Ownership** | 按文件/目录边界分配给不同实现者 |

---

## 四、machine-learning-ops — MLOps

### 4.1 插件概述

端到端 MLOps 管道，从数据准备到部署的完整生命周期管理。

### 4.2 核心 Skill

| Skill | 描述 |
|-------|------|
| `ml-pipeline-workflow` | 端到端 MLOps 管道（数据→训练→部署） |

---

## 五、与 everything-claude-code 对比

| 维度 | agents_example | everything-claude-code |
|------|--------------|----------------------|
| 多 Agent 编排 | Agent Teams（实验性，真并行） | /orchestrate（命令式串联） |
| 持续学习 | 无 | 本能（Instinct）架构 |
| LLM 应用 | 8 个 Skill 覆盖全链路 | 无专门 LLM 插件 |
| Agent 协作 | 文件所有权边界 | 无正式边界机制 |
| 模型分配 | 4 层（+Inherit） | 3 层 |

---

## 六、核心设计亮点

### 6.1 渐进式 Skill 激活

LLM 应用开发插件完美展示了渐进式披露的价值：
- 用户请求"RAG 系统"→ 自动激活多个相关 Skill
- 每个 Skill 独立加载，不膨胀主上下文
- LangChain + RAG + Embedding + Evaluation 协同工作

### 6.2 Agent Teams 的并行安全性

文件所有权边界是 Agent Teams 最关键的设计：
- **物理隔离**：每个实现者只能修改自己负责的文件
- **接口协调**：通过 team-lead 协调跨边界依赖
- **冲突预防**：所有权规则从根本上避免 git 冲突

### 6.3 Agent + Skill 的职责分离

```
Agent → 高层推理 + 工作流编排
Skill → 具体领域知识 + 实现模式
```

这使 Agent 能专注于"做什么"，Skill 负责"怎么做"。

---

*基于 agents_example/plugins/llm-application-dev, agent-orchestration, agent-teams, machine-learning-ops 深度分析*
