# Rules 目录设计思路

## 一、概述

Rules（规则）是 Claude Code 在**所有会话中始终遵守**的行为指南，通过项目级 `.claude/rules/` 目录或个人级 `~/.claude/rules/` 目录实现。与 Skills 的"场景激活"不同，Rules 是**无条件的、默认启用的约束**。

ECC 的 Rules 覆盖 11 种编程语言，采用 `common/`（通用）+ 语言特定的两层结构。

---

## 二、目录结构

```
rules/
├── common/              # 所有语言通用的规则
│   ├── coding-style.md   # 编码风格（CRITICAL：不可变性）
│   ├── testing.md        # 测试要求（80% 覆盖率底线）
│   ├── security.md       # 安全规范
│   ├── agents.md        # Agent 编排策略
│   ├── performance.md    # 性能与模型选择
│   ├── patterns.md       # 代码模式
│   ├── git-workflow.md   # Git 提交规范
│   ├── hooks.md         # Hook 最佳实践
│   ├── code-review.md    # 代码审查流程
│   └── development-workflow.md
├── typescript/          # TypeScript 特定规则
│   ├── coding-style.md  # 无 any、Zod 验证
│   ├── patterns.md
│   ├── hooks.md
│   ├── testing.md
│   └── security.md
├── python/              # Python 特定规则
├── golang/              # Go 特定规则
├── rust/                # Rust 特定规则
├── cpp/                 # C++ 特定规则
├── java/
├── kotlin/
├── csharp/
├── php/
├── perl/
├── swift/
└── zh/                  # 中文规则集
    ├── coding-style.md
    ├── agents.md
    ├── performance.md
    ├── patterns.md
    ├── git-workflow.md
    ├── hooks.md
    ├── testing.md
    ├── security.md
    ├── code-review.md
    └── development-workflow.md
```

---

## 三、Common Rules 详解

### 3.1 Coding Style（编码风格）— 最核心的规则

**CRITICAL 级别要求**：

```markdown
## 不可变性（Immutability）

**CRITICAL** — 当存在可替换方案时，永远不要使用可变数据结构。
优先使用不可变模式：

✅ const actions = items.map(x => x * 2);  // 新数组，不修改原数组
❌ for (let i = 0; i < items.length; i++) { items[i] *= 2; }

✅ const updated = { ...user, name: 'new name' };  // 新对象
❌ user.name = 'new name';  // 修改原对象

✅ function process(items: readonly number[]): number[]  // 显式只读
```

**小文件原则**：
```markdown
## 文件大小限制

- 目标：每个文件 200-400 行
- 上限：800 行
- 超过 200 行：考虑拆分
- 超过 400 行：强烈建议拆分
- 超过 800 行：必须拆分

为什么？
- Token 优化：小文件 = 更少的上下文占用
- 可维护性：小文件 = 更清晰的关注点分离
- 复用性：小文件 = 更容易被其他模块引用
```

### 3.2 Testing（测试规则）

```markdown
## 覆盖率底线

**底线：80%**
- 任何 PR 不得将覆盖率降低到 80% 以下
- 新代码应该追求更高覆盖率
- 覆盖率下降 = 质量退步

## TDD 强制流程

**RED**: 写一个会失败的测试
**GREEN**: 写最少量代码让测试通过
**REFACTOR**: 重构代码，保持测试绿色

不要跳过任何步骤：
- 不写测试就实现 → 违反 TDD 原则
- 跳过 GREEN 直接 REFACTOR → 跳过步骤
```

### 3.3 Security（安全规则）

```markdown
## 安全检查表

### 强制检查
- [ ] 用户输入验证（永不信任）
- [ ] SQL 注入防护（参数化查询）
- [ ] XSS 防护（转义 HTML 输出）
- [ ] 秘密管理（不硬编码凭证）
- [ ] 最小权限原则

## 秘密管理

❌ 禁止：
API_KEY = "sk-1234567890"
PASSWORD = process.env.PASSWORD

✅ 正确：
- 环境变量注入
- 密钥管理服务（AWS Secrets Manager / HashiCorp Vault）
- .env 文件（添加到 .gitignore）

## 应急响应协议

如果发现秘密泄露：
1. 立即轮换相关密钥
2. 评估暴露范围
3. 更新所有使用该密钥的服务
4. 提交 Incident Report
```

### 3.4 Agents（Agent 编排规则）

```markdown
## 并行执行原则

**始终**对独立操作使用并行 Task 执行：

✅ 正确：
Launch 3 agents in parallel:
1. Agent 1: Security analysis of auth module
2. Agent 2: Performance review of cache system
3. Agent 3: Type checking of utilities

❌ 错误：
First agent 1, then agent 2, then agent 3  // 不必要的串行

## 立即调用 Agent 的场景

无需用户提示：
1. 复杂特性请求 → 使用 **planner** agent
2. 代码刚编写/修改 → 使用 **code-reviewer** agent
3. Bug 修复或新功能 → 使用 **tdd-guide** agent
4. 架构决策 → 使用 **architect** agent
```

### 3.5 Performance（性能规则）

```markdown
## 模型选择策略

**Haiku 4.5**（Sonnet 90% 能力，3x 成本节省）：
- 轻量级 Agent，频繁调用
- 结对编程和代码生成
- 多 Agent 系统中的 Worker Agent

**Sonnet 4.6**（最佳编码模型）：
- 主要开发工作
- 多 Agent 工作流编排
- 复杂编码任务

**Opus 4.5**（深度推理）：
- 复杂架构决策
- 最大推理需求
- 研究和分析任务

## 上下文窗口管理

避免在上下文窗口最后 20% 进行：
- 大规模重构
- 跨多文件的功能实现
- 复杂交互调试

低上下文敏感度任务（可稍后处理）：
- 单文件编辑
- 独立工具创建
- 文档更新
- 简单 Bug 修复
```

### 3.6 Git Workflow（Git 规范）

```markdown
## 提交格式（Conventional Commits）

<type>(<scope>): <subject>

类型：
- feat: 新功能
- fix: Bug 修复
- refactor: 重构（无功能变化）
- test: 测试相关
- docs: 文档
- chore: 维护任务

示例：
feat(auth): add OAuth2 login flow
fix(payment): resolve double-charge issue in checkout
refactor(api): extract response serializers
```

### 3.7 Patterns（代码模式）

```markdown
## Repository 模式

数据访问层应使用 Repository 模式：

interface UserRepository {
  findById(id: string): Promise<User | null>;
  findByEmail(email: string): Promise<User | null>;
  save(user: User): Promise<void>;
}

✅ 业务逻辑通过接口与数据层交互
✅ 易于测试（可 Mock Repository）
✅ 数据源可替换（内存/数据库/远程 API）
```

---

## 四、TypeScript 特定规则（示例）

```markdown
## 禁止使用 any

❌ 禁止：
function processData(data: any) { ... }

✅ 正确：
- 使用 unknown 配合类型守卫
- 定义具体类型
- 使用泛型约束

## Zod 验证

来自外部的数据必须经过 Zod 验证：

import { z } from 'zod';

const UserSchema = z.object({
  id: z.string().uuid(),
  email: z.string().email(),
  role: z.enum(['admin', 'user']),
});

const validated = UserSchema.parse(rawData);
```

---

## 五、设计亮点总结

### 5.1 CRITICAL 标记的分级制度

Coding Style 规则中使用 `**CRITICAL**` 标记最核心的要求，使 Claude 能够区分：
- 必须遵守的底线（CRITICAL）
- 强烈建议的一般规则

### 5.2 双语规则支持

`rules/zh/` 目录提供了完整的中文规则集，让非英语母语的开发者可以直接用母语理解规则要求，体现了项目的国际化思维。

### 5.3 小文件原则的 Token 经济考量

200-400 行的目标不是武断的限制，而是 **Token 经济优化的具体体现**：
- 小文件 = 读取时 Token 消耗少
- 小文件 = Claude 更容易理解全貌
- 小文件 = 并行处理时上下文占用更均匀

### 5.4 覆盖率底线的"底线"哲学

80% 不是目标而是**底线**——允许合理范围内的例外，但明确这是不可接受的下限。这与 TDD 的理念一脉相承：测试不是可选项，而是质量的基本保障。

---

*基于 everything-claude-code/rules/ 目录深度分析*
