# Creating New Skills

**必读**: [Skill authoring best practices](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices)

## 关键要求

| 要求 | 说明 |
|------|------|
| **目录位置** | 所有技能放在 `skills/<skill-name>/` 下 |
| **name 字段** | 最多 64 字符，仅小写字母/数字/连字符，不含 "anthropic"/"claude" |
| **description** | 最多 1024 字符，第三人称，包含功能 + 触发条件 |
| **SKILL.md 正文** | 控制在 500 行以内；额外内容放入 `references/` |
| **references** | 从 SKILL.md 算起仅一级深度，避免嵌套引用 |

## SKILL.md Frontmatter 模板

```yaml
---
name: <skill-name>
description: <第三人称描述。功能 + 触发条件。>
version: <语义化版本号，与 marketplace.json 一致>
metadata:
  homepage: https://github.com/your-username/SeanClickin-Skills#<skill-name>
---
```

## 创建步骤

1. 在 `skills/<skill-name>/` 下创建 `SKILL.md`（含 YAML front matter）
2. 如有脚本，放在 `skills/<skill-name>/scripts/` 下
3. 如有参考文档，放在 `skills/<skill-name>/references/` 下
4. 如有模板文件，放在 `skills/<skill-name>/assets/` 下
5. 在 `.claude-plugin/marketplace.json` 的 `skills` 数组中注册新技能路径
6. 更新 `README.md` 的技能清单

## 目录结构示例

```
skills/<skill-name>/
├── SKILL.md              # 主入口（<500行）
├── scripts/              # 可执行脚本（可选）
│   └── main.sh
├── references/           # 参考文档（按需加载）
│   ├── guide.md
│   └── examples.md
└── assets/               # 模板文件（可选）
    └── template.md
```

从 SKILL.md 引用（仅一级深度）：

```markdown
详细规范见 [references/guide.md](references/guide.md)
```

## 编写 description

**必须使用第三人称**：

```yaml
# 正确
description: Generates structured commit messages with Agent trailers. Use when an AI agent needs to commit code or create branches.

# 错误
description: I can help you create commit messages
```

## 技能自包含原则

每个技能必须可独立分发和使用：

- **禁止引用外部路径**：`SKILL.md` 及其 `references/` 不得链接到技能目录外的文件（包括 `docs/`、同级技能、仓库根目录）
- **内联共享约定**：如有通用规范，直接写入 SKILL.md，而非引用外部文档
- `docs/` 下的文档仅供仓库作者参考，不得被任何 `SKILL.md` 引用

## 技能分组

| 技能类型 | 分组 |
|---------|------|
| 认知思维、问题分析 | Cognitive Skills |
| Git 工作流、开发自动化 | Dev Workflow Skills |

如新增逻辑分组，需更新 `README.md` 和 `CLAUDE.md` 中的分组说明。

## 脚本规范

本仓库的脚本以 Bash 为主：

```bash
#!/usr/bin/env bash
set -euo pipefail

# 脚本说明
# 用法: script.sh <arg1> [arg2]
```

- POSIX 兼容优先
- 使用 `set -euo pipefail` 确保错误处理
- 脚本头部注明用法
