# AI Git Version Control

> Agent-Aware Git version control for AI coding agents. Standardized commit messages with Agent trailers, branch isolation, checkpoint commits, PR templates, stacked PRs, history cleanup, and CI compliance checks.

## Why This Skill Exists

AI coding agents fundamentally break traditional Git assumptions:

- **Autonomous execution**: Agents modify dozens of files over minutes to hours without human supervision
- **Concurrent collaboration**: Multiple agent instances work in the same repo simultaneously
- **Task granularity mismatch**: A single natural language task may span hundreds of file operations, but agents have no innate sense of how to split commits
- **Decision black box**: Agent reasoning processes are invisible in Git history — only final code changes remain

These characteristics create four critical pain points that traditional Git workflows cannot handle:

| Pain Point | Description | This Skill's Solution |
|------------|-------------|----------------------|
| **Intent loss** | Git records *what* changed, not *why* or *how* the agent decided | Agent trailers (`Agent-Task`, `Agent-Decision`, `Agent-Model`) in every commit |
| **Dirty worktree** | Uncommitted temp files, formatting changes, and real business logic mixed together | Git worktree isolation + checkpoint commit strategy |
| **Semantic merge risk** | Text-level merge success != semantic correctness | Atomic commits + branch protection + CI guardrails |
| **Mega-commits** | Giant diffs break review, revert, and `git bisect` | Atomic commit discipline + interactive rebase cleanup |

## Core Principles

This skill is built on three pillars:

- **Isolation**: Branch protection + worktree isolation gives each agent task an independent, protected workspace
- **Transparency**: Atomic commits + commit trailers + structured PR templates make agent decision processes visible in version history
- **Automation**: CI guardrails + branch protection required checks enforce quality through tools, not manual review

## Quick Start

### 1. Install the Skill

Clone this repository into your Claude Code skills directory:

```bash
git clone https://github.com/your-username/ai-git-version-control.git ~/.trae/skills/ai-git-version-control
```

Or for Claude Code:
```bash
/plugin install ai-git-version-control
```

### 2. Generate Your First Agent Commit

```bash
# Generate a commit message with Agent trailers
MSG=$(scripts/generate-agent-commit.sh \
  feat \
  auth \
  "implement JWT refresh token rotation" \
  "Add sliding-window refresh token support to reduce re-login friction" \
  "PROJ-234" \
  "claude-3-opus" \
  "Used 7-day sliding window over fixed expiry for better UX" \
  "Redis TTL not yet aligned with token expiry on logout")

git commit -m "$MSG"
```

### 3. Create an Agent Branch

```bash
scripts/create-agent-branch.sh PROJ-234 "refresh-token-rotation"
# Creates: agent/PROJ-234-refresh-token-rotation
```

### 4. Set Up Your Project's AGENT.md

```bash
scripts/generate-agent-md.sh .
# Generates AGENT.md with team VCS conventions
```

## Agent-Aware Commit Format

Every agent-generated commit follows this structure:

```
<type>(<scope>): <summary>

<body>

Agent-Task: <task-id>
Agent-Model: <model-name>
Agent-Decision: <key-decision>
Agent-Limitation: <known-limitation>
```

### Commit Types

| Type | Usage |
|------|-------|
| `feat` | New feature |
| `fix` | Bug fix |
| `refactor` | Code restructuring |
| `test` | Adding/updating tests |
| `docs` | Documentation only |
| `chore` | Maintenance tasks |
| `perf` | Performance improvement |
| `ci` | CI/CD changes |
| `build` | Build system changes |
| `style` | Code style (formatting) |

### Example Commit

```
feat(auth): implement JWT refresh token rotation

Add sliding-window refresh token support to reduce re-login friction
while maintaining session security.

Agent-Task: PROJ-234
Agent-Model: gpt-4o
Agent-Decision: Used 7-day sliding window over fixed expiry for better UX
Agent-Limitation: Redis TTL not yet aligned with token expiry on logout
```

## Scripts Reference

| Script | Purpose | Usage |
|--------|---------|-------|
| `generate-agent-commit.sh` | Generate commit with Agent trailers | `<type> <scope> <summary> [body] [task_id] [model] [decision] [limitation]` |
| `agent-checkpoint-commit.sh` | Create [WIP] checkpoint commit | `<stage> [task_id]` |
| `create-agent-branch.sh` | Create agent branch from main | `<task_id> <description>` |
| `create-agent-worktree.sh` | Create isolated Git worktree | `<task_id> <description> [base_dir]` |
| `agent-rebase-history.sh` | Generate rebase guide for history cleanup | `[main_branch] [commit_count]` |
| `jj-split-commit.sh` | Split commit using Jujutsu (jj) | `<change_id> [split_description]` |
| `generate-agent-pr-template.sh` | Generate agent PR template | `<task_id> <task_description> [changes] [decisions] [alternatives] [tests] [limitations] [review_guidance]` |
| `create-stacked-prs.sh` | Create stacked PRs via gh CLI | `<base_branch> <pr_titles_file>` |
| `generate-agent-md.sh` | Generate AGENT.md spec file | `[target_dir]` |
| `agent-gitbutler-integration.sh` | GitButler virtual branch operations | `<action> [branch_name] [commit_msg]` |
| `agent-traceability.sh` | Create traceability session log | `<task_id> [model] [prompt]` |

## Complete Agent Workflow

### Step 1: Start a Task

```bash
# Create an isolated branch
scripts/create-agent-branch.sh PROJ-234 "refresh-token-rotation"

# Or create a worktree for parallel work
scripts/create-agent-worktree.sh PROJ-234 "refresh-token-rotation" ../worktrees
```

### Step 2: Work and Checkpoint

For tasks taking >15 minutes, create checkpoint commits after each major logical unit:

```bash
scripts/agent-checkpoint-commit.sh "auth middleware scaffold complete" PROJ-234
```

### Step 3: Commit with Agent Trailers

```bash
MSG=$(scripts/generate-agent-commit.sh feat auth \
  "implement JWT refresh token rotation" \
  "Add sliding-window refresh token support" \
  "PROJ-234" "claude-3-opus" \
  "7-day sliding window over fixed expiry" \
  "Redis TTL not aligned with logout")

git commit -m "$MSG"
```

### Step 4: Clean Up History Before PR

```bash
# Review and get rebase guidance
scripts/agent-rebase-history.sh main 10

# Then interactive rebase to squash [WIP] commits
git rebase -i main HEAD~10
```

### Step 5: Create PR

```bash
# Generate PR template
scripts/generate-agent-pr-template.sh PROJ-234 \
  "Implement JWT refresh token rotation" \
  "Added refresh token model and rotation endpoint" \
  "Sliding window approach for better UX" \
  "Fixed expiry, session-based rotation" \
  "Unit tests for token model and endpoint" \
  "Redis TTL alignment pending" \
  "Focus on token security in auth/refresh.py"

# Push and create PR
git push origin agent/PROJ-234-refresh-token-rotation
gh pr create --base main \
  --title "feat(auth): implement JWT refresh token rotation" \
  --body-file .github/pull_request_template/agent.md
```

### Step 6: Add Traceability

```bash
scripts/agent-traceability.sh PROJ-234 claude-3-opus \
  "Implement refresh token rotation"
```

## Key Rules

1. **Never commit directly to `main`** — always use `agent/` branches
2. **Every commit must be atomic** — one logical change, independently buildable
3. **Include Agent trailers** — `Agent-Task` and `Agent-Decision` are required
4. **Squash [WIP] commits** before opening a PR
5. **Never merge your own PRs** — request human review
6. **Do not commit secrets** — use environment variables instead
7. **Use checkpoint commits** for tasks >15 minutes, clean up before PR

## CI/CD Integration

Add this GitHub Actions workflow to enforce Agent-Aware Git standards:

```yaml
# .github/workflows/agent-git-check.yml
name: Agent Git Compliance Check
on:
  pull_request:
    branches: [main]
    types: [opened, synchronize]

jobs:
  check-agent-commit:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Check commit message format
        run: |
          COMMIT_MSG=$(git log -1 --pretty=format:%B)
          if ! echo "$COMMIT_MSG" | grep -q "Agent-Task:"; then
            echo "::error::Commit message missing Agent-Task trailer"
            exit 1
          fi
          if ! echo "$COMMIT_MSG" | grep -q "Agent-Decision:"; then
            echo "::error::Commit message missing Agent-Decision trailer"
            exit 1
          fi
          echo "Commit message complies with Agent-Aware standards"

      - name: Check branch naming
        run: |
          BRANCH_NAME=${GITHUB_HEAD_REF#refs/heads/}
          if [[ ! $BRANCH_NAME =~ ^agent/[A-Z0-9]+-[a-z0-9-]+$ ]]; then
            echo "::error::Branch '$BRANCH_NAME' does not follow agent/<task-id>-<desc> format"
            exit 1
          fi
          echo "Branch name complies with standards"

      - name: Check for WIP commits
        run: |
          WIP_COMMITS=$(git log --oneline origin/main..HEAD | grep -c "\[WIP\]" || true)
          if [ "$WIP_COMMITS" -gt 0 ]; then
            echo "::error::Found $WIP_COMMITS [WIP] commits - squash before merging"
            exit 1
          fi
          echo "No WIP commits found"
```

## Skill Structure

```
ai-git-version-control/
├── SKILL.md                              # Core skill entry point
├── scripts/                              # Executable scripts
│   ├── generate-agent-commit.sh
│   ├── agent-checkpoint-commit.sh
│   ├── create-agent-branch.sh
│   ├── create-agent-worktree.sh
│   ├── agent-rebase-history.sh
│   ├── jj-split-commit.sh
│   ├── generate-agent-pr-template.sh
│   ├── create-stacked-prs.sh
│   ├── generate-agent-md.sh
│   ├── agent-gitbutler-integration.sh
│   └── agent-traceability.sh
├── references/                           # Detailed reference docs
│   ├── commit-spec.md                    # Commit format & examples
│   ├── branch-management.md              # Worktree & GitButler
│   ├── pr-management.md                  # PR templates & stacked PRs
│   └── ci-cd-integration.md              # CI compliance checks
└── assets/                               # Templates
    ├── agent-pr-template.md
    └── agent-md-template.md
```

## Advanced: Next-Gen VCS Tools

This skill is designed to work with traditional Git while remaining compatible with emerging tools:

- **[Jujutsu (jj)](https://github.com/martinvonz/jj)**: Change-centric VCS with automatic rebase, conflict-as-first-class-citizen, and operation log for unlimited undo. Use `jj-split-commit.sh` for commit splitting.
- **[GitButler](https://gitbutler.com)**: Virtual branches for concurrent agent workflows, hunk-level assignment, and stacked branch management. Use `agent-gitbutler-integration.sh` for virtual branch operations.

Both tools use Git as their storage backend and are fully compatible with GitHub, GitLab, and existing CI/CD pipelines.

## License

MIT

## Contributing

Contributions are welcome! Please follow the Agent-Aware commit format when submitting PRs.

---

*Built with the principles from [AI 时代的 Git 版本管理](https://mp.weixin.qq.com/s/...) — making version history a trustworthy knowledge base, whether code is written by humans or agents.*

---

# AI Git Version Control（中文版）

> 让 AI 编程 Agent 也能用好 Git。规范提交、分支隔离、Checkpoint 策略、PR 模板、Stacked PR、历史整理、CI 合规检查——这些都能搞定。

## 为什么需要这个技能

AI 编程 Agent 的工作方式和传统 Git 的假设不太匹配：

- **自主执行**：Agent 能自己连续改几十个文件，一干就是几十分钟甚至几个小时
- **并发协作**：多个 Agent 同时在同一个仓库里干活
- **任务粒度不匹配**：一句话交代的任务可能对应上百次文件操作，但 Agent 不知道该怎么拆成合适的 commit
- **决策黑盒**：Agent 中间怎么想的不会留在 Git 历史里，只能看到最终改了什么

传统 Git 工作流有四个搞不定的问题：

| 痛点 | 描述 | 本技能的解决方案 |
|------|------|-----------------|
| **意图丢失** | Git 只记录"改了什么"，不记录"为什么改"和"怎么决定的" | 在每个 commit 中嵌入 Agent trailers（`Agent-Task`、`Agent-Decision`、`Agent-Model`） |
| **脏工作区** | 未提交的临时文件、格式化变更和真实业务修改混在一起 | Git worktree 隔离 + Checkpoint commit 策略 |
| **语义合并风险** | 文本层面无冲突 ≠ 语义正确 | Atomic commit + 分支保护 + CI 护栏 |
| **巨型提交** | 巨型 diff 让审查、回滚和 `git bisect` 全部失效 | Atomic commit 纪律 + Interactive rebase 整理 |

## 三大核心原则

- **隔离**：分支保护加 worktree 隔离，每个 Agent 任务都有自己的独立工作空间
- **透明**：Atomic commit 加 commit trailer 加结构化 PR 模板，Agent 的决策过程在版本历史里都能看到
- **自动化**：CI 护栏加分支保护规则，靠工具不靠人来卡质量

## 快速上手

### 1. 安装技能

```bash
git clone https://github.com/your-username/ai-git-version-control.git ~/.trae/skills/ai-git-version-control
```

### 2. 生成第一个 Agent Commit

```bash
MSG=$(scripts/generate-agent-commit.sh \
  feat \
  auth \
  "implement JWT refresh token rotation" \
  "Add sliding-window refresh token support to reduce re-login friction" \
  "PROJ-234" \
  "claude-3-opus" \
  "Used 7-day sliding window over fixed expiry for better UX" \
  "Redis TTL not yet aligned with token expiry on logout")

git commit -m "$MSG"
```

### 3. 创建 Agent 分支

```bash
scripts/create-agent-branch.sh PROJ-234 "refresh-token-rotation"
```

### 4. 生成 AGENT.md 规范文件

```bash
scripts/generate-agent-md.sh .
```

## Agent-Aware Commit 规范

每个 Agent 生成的 commit 格式如下：

```
<type>(<scope>): <summary>

<body>

Agent-Task: <task-id>
Agent-Model: <model-name>
Agent-Decision: <key-decision>
Agent-Limitation: <known-limitation>
```

### 关于 Git Commit Trailer

`Agent-Task:`、`Agent-Model:` 这些字段用的是 Git 自带的 commit trailer 机制。Trailer 就是贴在 commit message 末尾的键值对，格式是 `Key: Value`，Git 原生就能解析，不需要额外工具。Git 生态里已经有不少用 trailer 的例子：

```
Signed-off-by: Alice <alice@example.com>
Co-authored-by: Bob <bob@example.com>
Fixes: #1234
```

查询 trailer 的标准 Git 命令：

```bash
# 列出所有包含 Agent-Task trailer 的提交
git log --format='%(trailers:key=Agent-Task,valueonly)'

# 按 trailer 过滤提交历史
git log --grep="^Agent-Task:" --all
```

### 完整示例

```
feat(auth): implement JWT refresh token rotation

Add sliding-window refresh token support to reduce re-login friction
while maintaining session security.

Agent-Task: PROJ-234
Agent-Model: gpt-4o
Agent-Decision: Used 7-day sliding window over fixed expiry for better UX
Agent-Limitation: Redis TTL not yet aligned with token expiry on logout
```

## 脚本速查

| 脚本 | 用途 | 参数 |
|------|------|------|
| `generate-agent-commit.sh` | 生成带 Agent trailers 的 commit message | `<type> <scope> <summary> [body] [task_id] [model] [decision] [limitation]` |
| `agent-checkpoint-commit.sh` | 创建 [WIP] 检查点提交 | `<stage> [task_id]` |
| `create-agent-branch.sh` | 从 main 创建 Agent 分支 | `<task_id> <description>` |
| `create-agent-worktree.sh` | 创建隔离的 Git worktree | `<task_id> <description> [base_dir]` |
| `agent-rebase-history.sh` | 生成历史整理指南 | `[main_branch] [commit_count]` |
| `jj-split-commit.sh` | 使用 Jujutsu 拆分提交 | `<change_id> [split_description]` |
| `generate-agent-pr-template.sh` | 生成 Agent PR 模板 | `<task_id> <task_description> [changes] [decisions] [alternatives] [tests] [limitations] [review_guidance]` |
| `create-stacked-prs.sh` | 通过 gh CLI 创建堆叠 PR | `<base_branch> <pr_titles_file>` |
| `generate-agent-md.sh` | 生成 AGENT.md 规范文件 | `[target_dir]` |
| `agent-gitbutler-integration.sh` | GitButler 虚拟分支操作 | `<action> [branch_name] [commit_msg]` |
| `agent-traceability.sh` | 创建可追溯性会话日志 | `<task_id> [model] [prompt]` |

## 完整 Agent 工作流

### 第 1 步：启动任务

```bash
scripts/create-agent-branch.sh PROJ-234 "refresh-token-rotation"

# 或使用 worktree 实现并行工作
scripts/create-agent-worktree.sh PROJ-234 "refresh-token-rotation" ../worktrees
```

### 第 2 步：工作与 Checkpoint

任务预计超过 15 分钟的，在每个关键节点做一次 checkpoint commit：

```bash
scripts/agent-checkpoint-commit.sh "auth middleware scaffold complete" PROJ-234
```

### 第 3 步：提交并附加 Agent Trailers

```bash
MSG=$(scripts/generate-agent-commit.sh feat auth \
  "implement JWT refresh token rotation" \
  "Add sliding-window refresh token support" \
  "PROJ-234" "claude-3-opus" \
  "7-day sliding window over fixed expiry" \
  "Redis TTL not aligned with logout")

git commit -m "$MSG"
```

### 第 4 步：开 PR 前整理历史

```bash
scripts/agent-rebase-history.sh main 10

# 交互式 rebase 合并 [WIP] 提交
git rebase -i main HEAD~10
```

### 第 5 步：创建 PR

```bash
scripts/generate-agent-pr-template.sh PROJ-234 \
  "Implement JWT refresh token rotation" \
  "Added refresh token model and rotation endpoint" \
  "Sliding window approach for better UX" \
  "Fixed expiry, session-based rotation" \
  "Unit tests for token model and endpoint" \
  "Redis TTL alignment pending" \
  "Focus on token security in auth/refresh.py"

git push origin agent/PROJ-234-refresh-token-rotation
gh pr create --base main \
  --title "feat(auth): implement JWT refresh token rotation" \
  --body-file .github/pull_request_template/agent.md
```

### 第 6 步：添加可追溯性

```bash
scripts/agent-traceability.sh PROJ-234 claude-3-opus \
  "Implement refresh token rotation"
```

## 关键规则

1. **永远不要直接提交到 `main`**，始终用 `agent/` 分支
2. **每个 commit 必须是原子的**，一个逻辑变更，独立可构建
3. **必须包含 Agent trailers**，`Agent-Task` 和 `Agent-Decision` 是必需的
4. **开 PR 前必须 squash [WIP] 提交**
5. **不要合自己的 PR**，找人来审查
6. **别提交密钥**，用环境变量代替
7. **长任务用 checkpoint commit**，超过 15 分钟的任务，开 PR 前清理

## 最佳实践详解

### Checkpoint Commit 策略

任务比较长的时候，不要等全干完再提交。在关键节点做"检查点提交"：

```bash
# 在以下节点各做一次 git commit：
# 1. 数据模型/接口定义写完
# 2. 核心逻辑实现完
# 3. 测试写完
# 4. 文档更新完

scripts/agent-checkpoint-commit.sh "data model and interface defined" PROJ-234
scripts/agent-checkpoint-commit.sh "core logic implemented" PROJ-234
scripts/agent-checkpoint-commit.sh "tests written" PROJ-234
```

### Atomic Commit 实践

Atomic commit 说白了就是：一个 commit 只干一件事。这个事说得清楚、能回滚、能验证，而且在这个节点上代码能编译、测试能过。

好的拆法：

```bash
# 每个 commit 对应一个独立关注点
git commit -m "feat(auth): add RefreshToken domain model and repository interface"
git commit -m "feat(auth): implement JWT refresh token issuance in AuthService"
git commit -m "feat(auth): expose POST /auth/refresh endpoint"
git commit -m "test(auth): add unit tests for refresh token rotation logic"
```

反例，所有改动压成一个 commit：

```bash
git commit -m "feat(auth): implement refresh token"
```

### 使用 Interactive Rebase 整理历史

```bash
# 查看当前分支的提交历史
git log --oneline main..HEAD

# 交互式 rebase 整理
git rebase -i main

# 常用操作：
# pick    - 保留该提交
# squash  - 合并到上一个提交
# reword  - 修改 commit message
# drop    - 删除该提交
# fixup   - 合并到上一个提交，丢弃本提交 message
```

### 使用 git worktree 隔离并发 Agent

```bash
# 为每个 Agent 任务创建独立 worktree
git worktree add ../agent-task-234 -b agent/PROJ-234-refresh-token
git worktree add ../agent-task-301 -b agent/PROJ-301-pg-migration

# 查看当前所有 worktree
git worktree list

# 任务完成后清理
git worktree remove ../agent-task-234
```

### Stacked PR：把大任务拆成可审查的小块

```
main
└── PR #1：feat(auth): add RefreshToken domain model
    └── PR #2：feat(auth): implement token rotation in AuthService
        └── PR #3：feat(auth): expose POST /auth/refresh endpoint
            └── PR #4：test(auth): add integration tests
```

```bash
# 创建 PR 标题文件（每行一个）
echo "feat(auth): add RefreshToken domain model" > pr-titles.txt
echo "feat(auth): implement token rotation in AuthService" >> pr-titles.txt
echo "feat(auth): expose POST /auth/refresh endpoint" >> pr-titles.txt

# 创建堆叠 PR
scripts/create-stacked-prs.sh main pr-titles.txt
```

### 建立 Agent 任务的可追溯性链路

```
任务系统（Jira/Linear）
    ↓ task-id
Git Branch / PR
    ↓ commit message 中的 Agent-Task trailer
Agent Session Log（.agent-logs/ 目录，已加入 .gitignore）
    ↓ 包含完整的 prompt 和 agent reasoning
代码变更
```

```bash
scripts/agent-traceability.sh PROJ-234 claude-3-opus \
  "Implement refresh token rotation"
```

## CI/CD 集成

把下面这个 GitHub Actions 工作流加到仓库里，就能自动检查 Agent 提交合不合规：

```yaml
# .github/workflows/agent-git-check.yml
name: Agent Git Compliance Check
on:
  pull_request:
    branches: [main]
    types: [opened, synchronize]

jobs:
  check-agent-commit:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Check commit message format
        run: |
          COMMIT_MSG=$(git log -1 --pretty=format:%B)
          if ! echo "$COMMIT_MSG" | grep -q "Agent-Task:"; then
            echo "::error::Commit message missing Agent-Task trailer"
            exit 1
          fi
          if ! echo "$COMMIT_MSG" | grep -q "Agent-Decision:"; then
            echo "::error::Commit message missing Agent-Decision trailer"
            exit 1
          fi
          echo "Commit message complies with Agent-Aware standards"

      - name: Check branch naming
        run: |
          BRANCH_NAME=${GITHUB_HEAD_REF#refs/heads/}
          if [[ ! $BRANCH_NAME =~ ^agent/[A-Z0-9]+-[a-z0-9-]+$ ]]; then
            echo "::error::Branch '$BRANCH_NAME' does not follow agent/<task-id>-<desc> format"
            exit 1
          fi
          echo "Branch name complies with standards"

      - name: Check for WIP commits
        run: |
          WIP_COMMITS=$(git log --oneline origin/main..HEAD | grep -c "\[WIP\]" || true)
          if [ "$WIP_COMMITS" -gt 0 ]; then
            echo "::error::Found $WIP_COMMITS [WIP] commits - squash before merging"
            exit 1
          fi
          echo "No WIP commits found"
```

## 技能目录结构

```
ai-git-version-control/
├── SKILL.md                              # 技能核心入口
├── scripts/                              # 可执行脚本
│   ├── generate-agent-commit.sh          # 生成 Agent-Aware 提交信息
│   ├── agent-checkpoint-commit.sh        # 创建 [WIP] 检查点提交
│   ├── create-agent-branch.sh            # 创建 agent/ 分支
│   ├── create-agent-worktree.sh          # 创建隔离的 Git worktree
│   ├── agent-rebase-history.sh           # 生成交互式 rebase 指南
│   ├── jj-split-commit.sh               # 使用 Jujutsu 拆分提交
│   ├── generate-agent-pr-template.sh     # 生成 Agent PR 模板
│   ├── create-stacked-prs.sh            # 创建堆叠 PR
│   ├── generate-agent-md.sh             # 生成 AGENT.md 规范文件
│   ├── agent-gitbutler-integration.sh   # GitButler 虚拟分支操作
│   └── agent-traceability.sh            # 创建可追溯性会话日志
├── references/                           # 参考文档（按需加载）
│   ├── commit-spec.md                    # 提交规范、Trailer 定义、示例
│   ├── branch-management.md              # 分支管理、Worktree、GitButler
│   ├── pr-management.md                  # PR 模板、Stacked PR、审查指南
│   └── ci-cd-integration.md              # GitHub Actions 合规检查
└── assets/                               # 输出模板
    ├── agent-pr-template.md              # PR 模板
    └── agent-md-template.md              # AGENT.md 规范模板
```

## 进阶：新一代 VCS 工具

这套技能兼容传统 Git，也支持新一代版本控制工具：

- **[Jujutsu (jj)](https://github.com/martinvonz/jj)**：把变更当核心，工作区本身就是提交（working copy as a commit），不会丢未保存的工作。Change ID 给变更一个稳定的引用句柄，冲突在提交对象里是头等公民，不会卡住操作。操作日志支持无限 undo。用 `jj-split-commit.sh` 来拆分提交。
- **[GitButler](https://gitbutler.com)**：虚拟分支（Virtual Branches）让多个分支同时处于活跃状态，共享同一个工作目录。Agent 直接改文件，然后把每个 hunk 分到对应的虚拟分支，脏工作区的问题就解决了。用 `agent-gitbutler-integration.sh` 操作虚拟分支。

两个工具都用 Git 仓库做存储后端，和 GitHub、GitLab 以及现有 CI/CD 管道完全兼容。

## 关于 Monorepo

Monorepo 把所有代码放一个仓库，Agent 在单次 context 窗口里就能从头到尾追踪一个用户操作。在 Agentic Coding 场景下，Monorepo 的好处包括：

- **完整的跨服务上下文**：Agent 不用在多个仓库之间来回跳
- **大规模重构与迁移**：Agent 能可靠地执行影响面大的重构
- **依赖图可见性**：配合 Nx/Turborepo 决定哪些测试需要跑

Monorepo 下的 VCS 挑战可以用这套技能的工具来应对：worktree 隔离解决并发冲突，Stacked PR 控制 diff 范围，`nx affected --target=test` 缩小 CI 范围。

## 背景文章

这套技能的设计思路来自微信公众号文章《[万字干货｜AI 时代的 Git 版本管理，你用对了吗？](https://mp.weixin.qq.com/s/...)》（作者：小夏，TRAE 技术专家，2026 年 4 月）。

文章系统讲了 AI Agentic Coding 场景下的 Git 版本管理挑战和最佳实践，包括 Agent-Aware 的 Commit 规范、Checkpoint Commit 策略、Interactive Rebase 整理历史、Atomic Commit 原则、Feature Branch 与分支保护、Git Worktree 隔离、结构化 PR 模板、AGENT.md 规范文件、可追溯性链路、Monorepo 策略、Stacked PR 工作流，以及 Jujutsu 与 GitButler 等新一代 VCS 工具。

## 许可证

MIT

## 贡献

欢迎贡献！提交 PR 时请遵循 Agent-Aware commit 格式。
