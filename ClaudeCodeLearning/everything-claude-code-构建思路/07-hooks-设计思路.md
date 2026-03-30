# Hooks 系统设计思路

## 一、概述

Hooks（钩子）是 ECC **自动化护栏体系**的核心，通过在 Claude Code 生命周期关键节点自动执行脚本，实现无需用户介入的质量保障、安全检查和状态持久化。

ECC 的 Hooks 系统是目前见过的**最完整的 Claude Code Hooks 实现**，覆盖 PreToolUse → PostToolUse → PreCompact → SessionStart → Stop → SessionEnd 的完整生命周期。

---

## 二、完整 Hook 生命周期

```
用户消息
    ↓
SessionStart Hook（加载前序上下文、检测包管理器）
    ↓
Claude 推理...
    ↓
PreToolUse Hook（工具执行前拦截）
    ↓
[工具执行：Bash/Edit/Write/Grep...]
    ↓
PostToolUse Hook（工具执行后处理）
    ↓
Claude 继续推理...
    ↓
[可能触发 PreCompact Hook（上下文压缩前保存状态）]
    ↓
Stop Hook（响应结束时自动化）
    ↓
SessionEnd Hook（会话结束时标记）
```

---

## 三、PreToolUse — 工具执行前的守门员

PreToolUse 是在**任何工具执行前**触发的 Hook，是安全和质量的第一道防线。

### 3.1 安全类 Hook

```javascript
// 1. 禁止 git --no-verify（保护 git hooks）
matcher: "Bash"
hooks: [{ type: "command", command: "npx block-no-verify@1.1.2" }]
// 阻断 --no-verify 标志，防止跳过 pre-commit/commit-msg/pre-push hooks

// 2. AI 安全监控（可选，需要 pip install insa-its）
matcher: "Bash|Write|Edit|MultiEdit"
ECC_ENABLE_INSAITS=1 时启用
// 23 种异常类型，OWASP MCP Top 10 覆盖

// 3. 配置保护（防止修改 linter/formatter 配置）
// 引导 Agent 修复代码而非削弱配置
```

### 3.2 开发体验类 Hook

```javascript
// 4. 自动 tmux 开发服务器启动
matcher: "Bash"
hooks: [{ type: "command", command: "auto-tmux-dev.js" }]
// 目录名自动命名 tmux session

// 5. tmux 提醒（长时间运行的命令）
// 命令包含 npm/pnpm/yarn/cargo/pytest → 提醒使用 tmux

// 6. git push 提醒
// 推送前提醒审查变更

// 7. 提交前质量检查
// lint staged files → 验证 commit message 格式
// 检测 console.log/debugger/secrets
```

### 3.3 格式与质量类 Hook

```javascript
// 8. 文档文件警告（检查非标准文档）
// 非 README/CLAUDE 的 .md 文件写入 → 警告

// 9. 建议手动压缩（当变更量大时）
// 提示用户手动触发 /compact

// 10. 持续学习观察（100% 捕获所有工具调用）
matcher: "*"
async: true, timeout: 10
// Bash "${CLAUDE_PLUGIN_ROOT}/skills/continuous-learning-v2/hooks/observe.sh"
```

### 3.4 MCP 类 Hook

```javascript
// 11. MCP 健康检查（工具执行前）
// 检查 MCP 服务器状态
// 阻塞不健康服务器的调用
```

---

## 四、PostToolUse — 工具执行后的质量门禁

PostToolUse 在**工具执行后**触发，用于验证、自动格式化和追踪。

### 4.1 格式化类 Hook

```javascript
// 1. 自动格式化 JS/TS 文件（Biome 或 Prettier）
matcher: "Edit"
hooks: [{ type: "command", command: "post-edit-format.js" }]
// 执行 prettier --write 或 biome format

// 2. TypeScript 类型检查
matcher: "Edit"
hooks: [{ type: "command", command: "post-edit-typecheck.js" }]
// 执行 tsc --noEmit，检查 .ts/.tsx 文件变更
```

### 4.2 质量门禁类 Hook

```javascript
// 3. 质量门禁检查（异步，不阻塞）
matcher: "Edit|Write|MultiEdit"
async: true, timeout: 30
// 运行 lint/typecheck/coverage 检查

// 4. console.log 警告
matcher: "Edit"
hooks: [{ type: "command", command: "post-edit-console-warn.js" }]
// Edit .ts/.tsx/.js/.jsx 文件后警告 console.log

// 5. PR 创建后记录
// 记录 PR URL，提供审查命令

// 6. 构建完成分析（异步）
matcher: "Bash"
async: true, timeout: 30
// 构建完成后分析输出
```

### 4.3 观察类 Hook

```javascript
// 7. 持续学习结果捕获（PostToolUse 端）
matcher: "*"
async: true, timeout: 10
// 捕获工具执行结果（与 PreToolUse 配对）
```

---

## 五、PreCompact — 上下文压缩前的状态保存

```javascript
// 在上下文压缩前保存状态
matcher: "*"
hooks: [{ type: "command", command: "pre-compact.js" }]
// 将当前工作进度保存到文件
// 确保压缩后能恢复关键状态
```

---

## 六、SessionStart — 新会话初始化

```javascript
// 1. 加载前序上下文
// 读取上次会话的 .session 文件
// 恢复工作进度、待办事项

// 2. 检测包管理器
// 自动检测 npm/pnpm/yarn/bun
// 为后续 Bash 命令提供上下文
```

---

## 七、Stop — 响应结束的收尾工作

Stop Hooks 在每次 Claude 响应结束时触发（比 SessionEnd 触发更频繁）。

```javascript
// 1. console.log 检查
// 检查修改的文件中是否有 console.log
// 提醒用户清理

// 2. 会话状态持久化（异步）
// 将当前进度写入 session 文件
// 保存待办、决策、待处理事项

// 3. 会话评估
// 检查是否有可提取的模式
// 触发本能进化分析

// 4. 成本追踪
// 记录本次响应的 Token 使用量
// 汇总到成本仪表板

// 5. 桌面通知（macOS/WSL）
// 发送任务摘要通知
```

---

## 八、SessionEnd — 会话真正结束

```javascript
// 生命周期标记
matcher: "*"
async: true, timeout: 10
// 标记会话正式结束
// 触发清理、资源释放
```

---

## 九、PostToolUseFailure — 失败追踪

```javascript
// MCP 健康追踪
matcher: "*"
// 追踪失败的 MCP 调用
// 标记不健康的服务器
// 尝试自动重连
```

---

## 十、核心技术架构

### 10.1 run-with-flags.js 统一封装

所有 Hook 脚本都通过 `scripts/hooks/run-with-flags.js` 统一封装：

```javascript
// 运行时门控标志
ECC_HOOK_PROFILE=minimal,standard,strict
ECC_DISABLED_HOOKS=post:edit:format,pre:bash:git-push-reminder

// 三种配置文件级别
// minimal: 最小化 hooks（仅核心）
// standard: 标准 hooks（推荐）
// strict: 严格 hooks（全部）
```

**优势**：
- 环境变量控制，无需修改 JSON 配置
- 支持部分禁用（如只禁用 format hook）
- 支持配置文件级别切换

### 10.2 退出码原则

```markdown
## Hook 错误处理原则

所有 Hook 在**非关键错误**时必须 exit 0：

✅ 正确：
- 解析错误 → 输出警告到 stderr → exit 0
- 格式检查失败 → 提醒但不阻断

❌ 错误：
- Hook 执行失败 → exit 1 → 阻断所有工具执行

为什么？
- Hook 是护栏，不是阻断墙
- 非关键错误不应阻止用户工作
- 阻断仅用于真正的安全风险（如 --no-verify）
```

### 10.3 异步 Hook 设计

```javascript
// 异步 Hook 不阻塞主流程
async: true, timeout: 30

// 适用场景：
// - 构建分析（耗时长）
// - 质量门禁（可延后）
// - 持续学习观察（不影响主流程）
// - 成本追踪（记录即可）

// 同步 Hook 用于：
// - 安全检查（必须立即阻断）
// - 格式化（需等待完成）
```

### 10.4 插件根路径解析

ECC 需要在多个可能的路径中找到自己：

```javascript
// 优先级：
1. CLAUDE_PLUGIN_ROOT 环境变量
2. ~/.claude/plugins/everything-claude-code
3. ~/.claude/plugins/everything-claude-code@everything-claude-code
4. ~/.claude/plugins/marketplace/everything-claude-code
5. ~/.claude/plugins/cache/<org>/<version>/... (npm 包缓存)
```

这确保插件无论通过哪种方式安装都能正常工作。

---

## 十一、设计亮点总结

### 11.1 Hook > Prompt 的可靠性

这是 ECC 最核心的设计洞察：

> "LLMs forget instructions ~20% of the time. PostToolUse hooks enforce checklists at the tool level — the LLM physically cannot skip them."

**概率性触发（Prompt/Skill）vs 确定性触发（Hook）**：
- Skill 在 ~50-80% 的情况下激活（取决于 LLM 判断）
- Hook 在 100% 的情况下激活（事件驱动）

### 11.2 分层防护设计

ECC 的 Hook 不是单一防线，而是**多层防护**：
- **PreToolUse**：进入前检查（防止问题发生）
- **PostToolUse**：执行后验证（发现并提醒问题）
- **Stop**：会话结束汇总（全局视角检查）

### 11.3 "永远 exit 0" 的容错哲学

Hook 系统的容错哲学：非关键错误不阻断，只提醒。这使用户体验更加流畅，同时保持了必要的安全防护。

### 11.4 异步不意味着不可靠

ECC 的异步 Hook 并不意味着不可靠——关键检查（安全、配置保护）是同步且立即的，而非关键检查（质量门禁、成本追踪）是异步的。**关键性检查同步阻塞，非关键性检查异步并行**。

---

*基于 everything-claude-code/hooks/hooks.json 及 scripts/hooks/ 深度分析*
