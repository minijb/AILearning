# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **Claude Code learning and exploration repository** — a personal study workspace containing:
- Forked/cloned Claude Code plugins under active study
- Chinese-language tutorials and study notes
- Custom agent definitions
- Build/concept documentation for referenced projects

The repository is **not itself a deployable application** — it contains study materials and the source code of external plugins.

## Repository Structure

```
ClaudeCodeLearning/
├── everything-claude-code/         # Primary study target: comprehensive CC plugin (72 plugins, 112 agents, 146 skills)
│   ├── agents/                      # 30 subagents (planner, tdd-guide, code-reviewer, etc.)
│   ├── skills/                      # Workflow definitions (TDD, security, backend-patterns, etc.)
│   ├── commands/                     # Slash commands (/tdd, /plan, /code-review, etc.)
│   ├── rules/                       # Always-follow guidelines (common/ + language-specific/)
│   ├── hooks/                       # Trigger-based automations (session lifecycle, formatting)
│   ├── scripts/                     # Node.js hook implementations
│   ├── tests/                       # Test suite (run via node tests/run-all.js)
│   ├── contexts/                    # Dynamic system prompt injection
│   ├── mcp-configs/                # MCP server configs
│   └── .cursor/                    # Cursor IDE adapter (DRY pattern)
├── superpowers/                     # Second CC plugin: structured development workflow
│   ├── commands/                    # brainstorm, write-plan, execute-plan
│   ├── agents/                      # code-reviewer
│   ├── hooks/                       # session-start, hooks.json
│   └── docs/                        # testing, opencode, codex docs
├── agents_example/                  # Example agent configs with Makefile + CLAUDE.md
├── agent_mine/                      # Custom game-analysis agents (game-orchestrator, game-architect, etc.)
├── everything-claude-code-构建思路/  # Design/concept docs for ECC components
├── superpowers-构建思路/            # Design docs for superpowers plugin
├── tutorial-*.md                    # Chinese-language CC tutorials (11 stages, from intro to Rule system)
└── Claude_Code_Learning_Outline.md  # English learning outline with stage-by-stage breakdown
```

## Key Concepts (for this repo)

### Everything Claude Code Architecture

- **Agents**: Markdown files with YAML frontmatter (`name`, `description`, `tools`, `model`). Delegate tasks with `Agent` tool.
- **Skills**: Workflow definitions in `skills/<name>/SKILL.md`. Triggered proactively by conditions.
- **Commands**: Slash commands in `commands/*.md` with `description:` frontmatter.
- **Rules**: Always-follow guidelines in `rules/common/` + `rules/<language>/`. Copy to `~/.claude/rules/`.
- **Hooks**: JSON triggers in `hooks/hooks.json` that fire on tool events.
- **Model tiers**: Opus (critical code/review), Inherit (user's choice), Sonnet (日常), Haiku (fast ops).

### Superpowers Architecture

- **Skills trigger automatically** — agent checks relevant skills before any task.
- Core workflow: brainstorm → using-git-worktrees → writing-plans → subagent-driven-development → test-driven-development → requesting-code-review → finishing-a-development-branch.
- TDD philosophy: RED-GREEN-REFACTOR, YAGNI, DRY.

### Game Analysis Agents (agent_mine/)

Specialized agents for game design analysis using a pipeline: game-type-architect → game-engagement-analyst → game-competitive-analyst → game-feature-planner → game-economy-designer → game-ux-designer → game-analysis-orchestrator.

## Development Notes

### everything-claude-code

- **Tests**: `node tests/run-all.js` (individual: `node tests/lib/utils.test.js`)
- **Linting**: `npx markdownlint-cli '**/*.md'` before committing
- **ESLint**: `npx eslint` (flat config at eslint.config.js)
- **Hooks**: All Node.js (CommonJS only, no ESM unless `.mjs`). Hook scripts must `exit 0` on non-critical errors.
- **Do NOT add `"hooks"` to `.claude-plugin/plugin.json`** — v2.1+ auto-loads `hooks/hooks.json`. Adding it explicitly causes duplicate detection errors.
- **Skill format**: `SKILL.md` with YAML frontmatter (`name`, `description`).
- **Package manager**: Auto-detects npm/pnpm/yarn/bun via `CLAUDE_PACKAGE_MANAGER` env var or lock files.
- **Hook runtime controls**: `ECC_HOOK_PROFILE` (minimal/standard/strict) and `ECC_DISABLED_HOOKS` env vars.

### superpowers

- Skills live directly in the repo root under `skills/`.
- Installation varies by platform (CC marketplace, Cursor, Codex, OpenCode, Gemini CLI).
- See `docs/README.codex.md` and `docs/README.opencode.md` for non-Claude Code platforms.

## Contributing to Studied Plugins

When contributing upstream to `everything-claude-code` or `superpowers`:
- Follow the CONTRIBUTING.md in each plugin
- Run tests before committing
- Keep hook scripts under 200 lines
- Use lowercase hyphenated filenames
- Don't duplicate — follow the DRY adapter pattern for cross-platform support
