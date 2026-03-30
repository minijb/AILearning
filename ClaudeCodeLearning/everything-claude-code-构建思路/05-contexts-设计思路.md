# Contexts 目录设计思路

## 一、概述

Contexts（上下文）是 ECC 的**动态系统提示注入**机制。与其将所有规则和指南全部加载（浪费 Token），不如根据当前场景**选择性注入**最相关的上下文。

ECC 提供了三种开箱即用的上下文模式：开发（dev）、审查（review）、研究（research）。

---

## 二、三种上下文模式

### 2.1 dev.md — 开发模式

```markdown
# Development Context

Mode: Active development
Focus: Implementation, coding, building features

## Behavior
- Write code first, explain after
- Prefer working solutions over perfect solutions
- Run tests after changes
- Keep commits atomic

## Priorities
1. Get it working      # 第一：让它工作
2. Get it right         # 第二：让它正确
3. Get it clean         # 第三：让它干净

## Tools to favor
- Edit, Write for code changes
- Bash for running tests/builds
- Grep, Glob for finding code
```

**核心理念**：先让它工作 → 再让它正确 → 最后让它干净。这是敏捷开发的经典哲学。

### 2.2 review.md — 审查模式

```markdown
# Code Review Context

Mode: PR review, code analysis
Focus: Quality, security, maintainability

## Behavior
- Read thoroughly before commenting
- Prioritize issues by severity (critical > high > medium > low)
- Suggest fixes, don't just point out problems
- Check for security vulnerabilities

## Review Checklist
- [ ] Logic errors
- [ ] Edge cases
- [ ] Error handling
- [ ] Security (injection, auth, secrets)
- [ ] Performance
- [ ] Readability
- [ ] Test coverage

## Output Format
Group findings by file, severity first
```

**核心理念**：按严重性分级，不仅指出问题，还提供修复建议。

### 2.3 research.md — 研究模式

```markdown
# Research Context

Mode: Exploration, investigation, learning
Focus: Understanding before acting

## Behavior
- Read widely before concluding
- Ask clarifying questions
- Document findings as you go
- Don't write code until understanding is clear

## Research Process
1. Understand the question
2. Explore relevant code/docs
3. Form hypothesis
4. Verify with evidence
5. Summarize findings

## Tools to favor
- Read for understanding code
- Grep, Glob for finding patterns
- WebSearch, WebFetch for external docs
- Task with Explore agent for codebase questions

## Output
Findings first, recommendations second
```

**核心理念**：广泛探索后再下结论，不急于写代码。

---

## 三、高级用法：动态注入

### 3.1 基础用法

```bash
# 开发模式
claude --system-prompt "$(cat ~/.claude/contexts/dev.md)"

# 审查模式
claude --system-prompt "$(cat ~/.claude/contexts/review.md)"

# 研究模式
claude --system-prompt "$(cat ~/.claude/contexts/research.md)"
```

### 3.2 Shell 别名配置

```bash
# ~/.bashrc 或 ~/.zshrc

alias claude-dev='claude --system-prompt "$(cat ~/.claude/contexts/dev.md)"'
alias claude-review='claude --system-prompt "$(cat ~/.claude/contexts/review.md)"'
alias claude-research='claude --system-prompt "$(cat ~/.claude/contexts/research.md)"'
```

### 3.3 权限层级理解

系统提示注入的优先级：
```
System Prompt（--system-prompt）> User Messages > Tool Results
```

这意味着动态注入的上下文比普通用户消息具有更高的权威性。

---

## 四、上下文组合策略

### 4.1 临时组合

可以组合多个上下文：

```bash
# 开发 + 性能关注
cat ~/.claude/contexts/dev.md ~/.claude/contexts/performance.md > /tmp/hybrid.md
claude --system-prompt "$(cat /tmp/hybrid.md)"
```

### 4.2 项目特定上下文

在项目目录中创建专用上下文：

```markdown
# .claude/contexts/api-project.md

## Project-Specific Context
- This is a REST API project
- Use repository pattern for all data access
- Error responses must follow { error: { code, message } } format
```

---

## 五、设计亮点总结

### 5.1 场景驱动的上下文切换

dev/review/research 三种模式对应了软件开发的三个核心场景，每个场景有完全不同的行为准则：

| 维度 | dev | review | research |
|------|-----|--------|---------|
| **核心理念** | 边做边想 | 先思后言 | 先思后做 |
| **执行顺序** | Code → Test → Explain | Read → Analyze → Suggest | Explore → Hypothesize → Verify |
| **输出优先级** | 交付物优先 | 质量优先 | 理解优先 |
| **关注点** | 功能实现 | 问题发现 | 知识获取 |
| **工具倾向** | Edit/Bash | Read/Grep | WebSearch/Explore |

### 5.2 Token 经济优化的具体体现

不是把所有规则都加载，而是**按需注入**，这是 Token 经济最直接的实践：
- 开发任务 → dev 上下文（简洁）
- 代码审查 → review 上下文（结构化清单）
- 架构调研 → research 上下文（探索性）

### 5.3 权限层级的巧妙运用

系统提示 > 用户消息的优先级设计，使得动态注入的上下文即使在长对话的后期仍然保持权威性，不会被普通消息覆盖。

---

*基于 everything-claude-code/contexts/ 目录深度分析*
