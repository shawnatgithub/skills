skill

# AI 时代 Git 版本管理 - Anthropic Skills 规范实现
## 技能元信息
```json
{
  "name": "ai-git-version-control",
  "description": "为 AI 编程 Agent 提供符合最佳实践的 Git 版本管理能力，包括规范提交、分支管理、PR 处理等全流程支持",
  "author": "资深开发者",
  "version": "1.0.0",
  "anthropic_version": "1.0",
  "tools": ["git", "jj", "gitbutler"],
  "tags": ["git", "ai", "version control", "agentic coding", "best practices"],
  "requirements": ["git >= 2.40.0", "jj >= 0.14.0", "gitbutler >= 0.18.0", "gh cli >= 2.40.0"]
}
```

## 技能核心能力
### 1. Git 提交规范管理
#### 1.1 生成符合 Agent-Aware 规范的 Commit Message
**技能实现代码**
```bash
#!/bin/bash
# 文件名: generate-agent-commit.sh
set -e

# 接收参数: type scope summary body task_id model decision limitation
TYPE=$1
SCOPE=$2
SUMMARY=$3
BODY=$4
TASK_ID=$5
MODEL=$6
DECISION=$7
LIMITATION=$8

# 生成符合规范的 commit message
COMMIT_MSG=$(cat <<EOF
$TYPE($SCOPE): $SUMMARY
$BODY

Agent-Task: $TASK_ID
Agent-Model: $MODEL
Agent-Decision: $DECISION
Agent-Limitation: $LIMITATION
EOF
)

# 输出 commit message (供 Agent 调用)
echo "$COMMIT_MSG"

# 可选: 直接执行提交
# git commit -m "$COMMIT_MSG"
```

**Skill 调用示例 (Claude Messages 格式)**
```json
{
  "role": "user",
  "content": "使用 generate-agent-commit 工具生成提交信息，类型feat，作用域auth，摘要实现JWT刷新令牌轮转，正文添加滑动窗口刷新令牌支持以减少重新登录摩擦，任务ID PROJ-234，模型gpt-4o，决策使用7天滑动窗口而非固定过期时间，局限Redis TTL未与登出时的令牌过期对齐",
  "anthropic_tool_request": {
    "name": "generate-agent-commit",
    "parameters": {
      "type": "feat",
      "scope": "auth",
      "summary": "implement JWT refresh token rotation",
      "body": "Add sliding-window refresh token support to reduce re-login friction while maintaining session security.",
      "task_id": "PROJ-234",
      "model": "gpt-4o",
      "decision": "Used 7-day sliding window over fixed expiry for better UX; refresh tokens stored in httpOnly cookie to prevent XSS access",
      "limitation": "Redis TTL not yet aligned with token expiry on logout"
    }
  }
}
```

#### 1.2 Checkpoint Commit 自动化
**技能实现代码**
```bash
#!/bin/bash
# 文件名: agent-checkpoint-commit.sh
set -e

# 接收参数: checkpoint_stage task_id
STAGE=$1
TASK_ID=$2

# 生成 checkpoint commit message
CHECKPOINT_MSG="[WIP] Checkpoint: $STAGE | Agent-Task: $TASK_ID"

# 暂存所有变更并提交
git add -A
git commit -m "$CHECKPOINT_MSG"

# 输出提交结果
echo "Checkpoint commit completed for stage: $STAGE"
git log -1 --oneline
```

### 2. 分支管理与隔离
#### 2.1 Agent 功能分支创建
**技能实现代码**
```bash
#!/bin/bash
# 文件名: create-agent-branch.sh
set -e

# 接收参数: task_id description
TASK_ID=$1
DESCRIPTION=$2

# 标准化分支名称
BRANCH_NAME="agent/${TASK_ID}-$(echo $DESCRIPTION | tr ' ' '-' | tr '[:upper:]' '[:lower:]')"

# 从最新 main 创建分支
git checkout main
git pull origin main
git checkout -b $BRANCH_NAME

# 输出分支信息
echo "Created agent branch: $BRANCH_NAME"
echo "Branch details:"
git branch -v | grep $BRANCH_NAME
```

#### 2.2 Git Worktree 隔离创建
**技能实现代码**
```bash
#!/bin/bash
# 文件名: create-agent-worktree.sh
set -e

# 接收参数: task_id description base_dir
TASK_ID=$1
DESCRIPTION=$2
BASE_DIR=$3

# 生成工作区路径和分支名
BRANCH_NAME="agent/${TASK_ID}-$(echo $DESCRIPTION | tr ' ' '-' | tr '[:lower:]' '[:upper:]')"
WORKTREE_PATH="${BASE_DIR}/agent-task-${TASK_ID}"

# 创建 worktree
git worktree add $WORKTREE_PATH -b $BRANCH_NAME

# 输出 worktree 信息
echo "Created worktree for agent task:"
echo "Path: $WORKTREE_PATH"
echo "Branch: $BRANCH_NAME"
git worktree list | grep $TASK_ID
```

### 3. 提交历史整理
#### 3.1 交互式 Rebase 辅助脚本
**技能实现代码**
```bash
#!/bin/bash
# 文件名: agent-rebase-history.sh
set -e

# 接收参数: main_branch commit_count
MAIN_BRANCH=${1:-main}
COMMIT_COUNT=${2:-10}

# 生成 rebase 整理建议
echo "=== Agent Commit History Rebase Guide ==="
echo "1. Current commit history (last $COMMIT_COUNT commits):"
git log --oneline $MAIN_BRANCH..HEAD -n $COMMIT_COUNT

echo -e "\n2. Recommended rebase operations:"
echo "   - squash [WIP] checkpoint commits into semantic commits"
echo "   - reword commits to follow Conventional Commits format"
echo "   - ensure all commits have Agent-Task/Model/Decision trailers"

echo -e "\n3. Execute interactive rebase:"
echo "git rebase -i $MAIN_BRANCH HEAD~$COMMIT_COUNT"

# 生成 rebase 操作模板
REBASE_TEMPLATE=$(mktemp)
cat > $REBASE_TEMPLATE <<EOF
# Agent Rebase Template - Follow these rules:
# 1. Keep one commit per logical change (atomic commit)
# 2. Squash all [WIP] commits into relevant semantic commits
# 3. Add Agent-Task/Model/Decision trailers to each commit
# 4. Use Conventional Commits format (feat/fix/refactor/test/docs)
#
# Operations: pick/p, squash/s, reword/r, fixup/f, drop/d
EOF

echo -e "\n4. Rebase template saved to: $REBASE_TEMPLATE"
cat $REBASE_TEMPLATE
```

#### 3.2 JJ 工具提交拆分 (替代 Git Rebase)
**技能实现代码**
```bash
#!/bin/bash
# 文件名: jj-split-commit.sh
set -e

# 接收参数: change_id split_description
CHANGE_ID=$1
SPLIT_DESCRIPTION=$2

# 使用 jj 拆分提交
jj split $CHANGE_ID

# 为新拆分的提交设置描述
jj describe -m "$SPLIT_DESCRIPTION"

# 输出拆分结果
echo "Split completed for change ID: $CHANGE_ID"
jj log --no-graph -n 3
```

### 4. PR 管理与模板
#### 4.1 Agent PR 模板生成
**技能实现代码**
```bash
#!/bin/bash
# 文件名: generate-agent-pr-template.sh
set -e

# 接收参数: task_id task_description changes decisions alternatives tests limitations review_guidance
TASK_ID=$1
TASK_DESCRIPTION=$2
CHANGES=$3
DECISIONS=$4
ALTERNATIVES=$5
TESTS=$6
LIMITATIONS=$7
REVIEW_GUIDANCE=$8

# 生成 PR 模板
PR_TEMPLATE=$(cat <<EOF
## Task Description
$TASK_DESCRIPTION (ID: $TASK_ID)

## What Changed
$CHANGES

## Key Design Decisions
$DECISIONS

## Alternatives Considered
$ALTERNATIVES

## Test Coverage
$TESTS

## Known Limitations / Follow-up Tasks
$LIMITATIONS

## Review Guidance
$REVIEW_GUIDANCE

---
*This PR was generated by AI agent following Agent-Aware Git best practices*
EOF
)

# 输出 PR 模板
echo "$PR_TEMPLATE"

# 可选: 保存到 .github/pull_request_template/agent.md
mkdir -p .github/pull_request_template
echo "$PR_TEMPLATE" > .github/pull_request_template/agent.md
echo "PR template saved to .github/pull_request_template/agent.md"
```

#### 4.2 Stacked PR 创建 (使用 gh-stack)
**技能实现代码**
```bash
#!/bin/bash
# 文件名: create-stacked-prs.sh
set -e

# 接收参数: base_branch pr_titles_file
BASE_BRANCH=$1
PR_TITLES_FILE=$2

# 检查 gh cli 和 gh-stack 是否安装
if ! command -v gh &> /dev/null; then
    echo "GitHub CLI (gh) is required - please install it first"
    exit 1
fi

# 读取 PR 标题列表并创建堆叠 PR
PR_NUMBERS=()
CURRENT_BRANCH=$BASE_BRANCH

while IFS= read -r title; do
    # 创建新分支
    BRANCH_NAME="stacked/$(echo $title | tr ' ' '-' | tr '[:upper:]' '[:lower:]' | cut -c1-50)"
    git checkout -b $BRANCH_NAME $CURRENT_BRANCH
    
    # 创建空提交 (示例)
    git commit --allow-empty -m "$title"
    
    # 推送分支并创建 PR
    git push origin $BRANCH_NAME
    PR_NUMBER=$(gh pr create --base $CURRENT_BRANCH --head $BRANCH_NAME --title "$title" --body "Stacked PR for: $title" --json number --jq '.number')
    PR_NUMBERS+=($PR_NUMBER)
    
    # 更新当前分支为新创建的分支
    CURRENT_BRANCH=$BRANCH_NAME
    
    echo "Created stacked PR #$PR_NUMBER: $title"
done < "$PR_TITLES_FILE"

# 输出堆叠 PR 信息
echo -e "\nCreated stacked PRs (bottom to top):"
for i in "${!PR_NUMBERS[@]}"; do
    echo "$((i+1)). PR #${PR_NUMBERS[$i]}"
done

# 使用 gh-stack 同步堆叠关系
gh stack sync
echo "Stacked PRs synchronized with gh-stack"
```

### 5. AGENT.md 规范文件生成
**技能实现代码**
```bash
#!/bin/bash
# 文件名: generate-agent-md.sh
set -e

# 生成 AGENT.md 规范文件
AGENT_MD=$(cat <<EOF
# AGENT.md - AI 编程 Agent 版本控制规范

## Git Workflow
### Branch Naming
- Use \`agent/<task-id>-<description>\` for all agent-initiated branches
- Never commit directly to \`main\` or \`develop\`

### Commit Guidelines
- Follow Conventional Commits: https://www.conventionalcommits.org
- Each commit must be atomic: one logical change, buildable and testable in isolation
- Include Agent-Task, Agent-Decision trailers in commit body

### PR Process
- Open PR against \`main\` using the agent PR template
- Ensure all CI checks pass before requesting review
- Do not merge your own PRs

### What NOT to Commit
- API keys, tokens, passwords (use environment variables)
- Build artifacts, \`node_modules\`, \`__pycache__\`
- Local config files(\`.env\`, \`*.local\`)
- Large binary files(use Git LFS if necessary)

### Checkpoint Commits
For tasks expected to take more than 15 minutes:
- Commit after completing each major logical unit
- Use \`[WIP]\` prefix in message
- Clean up history with interactive rebase before opening PR

### CI Commands for Agents
# 只运行受当前变更影响的 package 的测试（需要 Nx 或 Turborepo）
nx affected --target=test
turbo run test --filter='[HEAD^1]'

# 全量检查（在 PR 合并前由 CI 执行，不建议 agent 本地全量运行）
# npm run test:all
EOF
)

# 保存 AGENT.md 文件
echo "$AGENT_MD" > AGENT.md
echo "Generated AGENT.md with AI Git best practices"

# 输出文件内容预览
echo -e "\nAGENT.md preview:"
head -20 AGENT.md
```

## 技能集成配置 (Skill Manifest)
```yaml
# skill.yaml
name: ai-git-version-control
display_name: AI Git Version Control
description: Comprehensive Git version control for AI coding agents following best practices
version: 1.0.0
runtime: bash
entry_points:
  - name: generate-agent-commit
    command: ./generate-agent-commit.sh
    parameters:
      - name: type
        type: string
        required: true
        description: Commit type (feat/fix/refactor/test/docs)
      - name: scope
        type: string
        required: true
        description: Commit scope (auth/api/db etc.)
      - name: summary
        type: string
        required: true
        description: Short commit summary
      - name: body
        type: string
        required: true
        description: Detailed commit body
      - name: task_id
        type: string
        required: true
        description: Agent task ID (PROJ-XXX)
      - name: model
        type: string
        required: true
        description: AI model used (gpt-4o/gemini-2.5-pro etc.)
      - name: decision
        type: string
        required: true
        description: Key design decisions
      - name: limitation
        type: string
        required: true
        description: Known limitations/TODOs

  - name: create-agent-branch
    command: ./create-agent-branch.sh
    parameters:
      - name: task_id
        type: string
        required: true
        description: Agent task ID
      - name: description
        type: string
        required: true
        description: Brief task description

  - name: generate-agent-pr-template
    command: ./generate-agent-pr-template.sh
    parameters:
      - name: task_id
        type: string
        required: true
        description: Agent task ID
      - name: task_description
        type: string
        required: true
        description: Original task description
      - name: changes
        type: string
        required: true
        description: Core changes summary
      - name: decisions
        type: string
        required: true
        description: Key design decisions
      - name: alternatives
        type: string
        required: true
        description: Alternatives considered
      - name: tests
        type: string
        required: true
        description: Test coverage details
      - name: limitations
        type: string
        required: true
        description: Known limitations
      - name: review_guidance
        type: string
        required: true
        description: Review guidance for humans

dependencies:
  - git >= 2.40.0
  - gh cli >= 2.40.0
  - jj >= 0.14.0 (optional)
  - gitbutler >= 0.18.0 (optional)

permissions:
  - filesystem:write
  - git:all
  - network:outbound (for gh cli)
```

## 使用指南
### 1. 技能安装
```bash
# 克隆技能仓库
git clone https://github.com/your-username/ai-git-version-control.git
cd ai-git-version-control

# 赋予脚本执行权限
chmod +x *.sh

# 安装依赖
brew install git gh jj gitbutler  # macOS
# 或
apt install git gh jj gitbutler    # Ubuntu/Debian
```

### 2. Agent 调用示例 (Claude Prompt)
```
你现在需要使用提供的 AI Git Version Control 技能完成以下任务：

1. 创建一个新的 agent 分支，任务ID: PROJ-456，描述: implement user profile API
2. 生成符合规范的 commit message，类型: feat，作用域: api，摘要: add user profile endpoints，正文: Implement GET/PUT /api/v1/users/profile endpoints with proper authentication and validation，任务ID: PROJ-456，模型: claude-3-opus，决策: 使用JWT验证用户身份，返回标准化的用户资料响应格式，局限: 尚未实现头像上传功能
3. 生成对应的 PR 模板内容

请调用对应的技能工具完成以上操作，并输出执行结果。
```

### 3. 与 CI/CD 集成
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
          
      - name: Install dependencies
        run: |
          apt update && apt install -y git jq
          
      - name: Check commit message format
        run: |
          # 检查最新提交是否符合 Agent-Aware 规范
          COMMIT_MSG=$(git log -1 --pretty=format:%B)
          if ! echo "$COMMIT_MSG" | grep -q "Agent-Task:"; then
            echo "❌ Commit message missing Agent-Task trailer"
            exit 1
          fi
          if ! echo "$COMMIT_MSG" | grep -q "Agent-Decision:"; then
            echo "❌ Commit message missing Agent-Decision trailer"
            exit 1
          fi
          echo "✅ Commit message complies with Agent-Aware standards"
          
      - name: Check branch naming
        run: |
          BRANCH_NAME=${GITHUB_HEAD_REF#refs/heads/}
          if [[ ! $BRANCH_NAME =~ ^agent/[A-Z0-9]+-[a-z0-9-]+$ ]]; then
            echo "❌ Branch name '$BRANCH_NAME' does not follow agent/<task-id>-<description> format"
            exit 1
          fi
          echo "✅ Branch name complies with standards"
```

## 扩展能力
### 1. GitButler 虚拟分支集成
```bash
#!/bin/bash
# 文件名: agent-gitbutler-integration.sh
set -e

# 为 Agent 任务创建虚拟分支
but branch create "agent/PROJ-234-refresh-token" --virtual
# 将当前变更分配到虚拟分支
but changes assign --branch "agent/PROJ-234-refresh-token" --all
# 提交变更
but commit "agent/PROJ-234-refresh-token" -m "$(./generate-agent-commit.sh feat auth "implement JWT refresh token" "Add refresh token support" "PROJ-234" "claude-3-opus" "Sliding window approach" "Redis TTL not aligned")"
# 创建堆叠分支
but branch -a "agent/PROJ-234-refresh-token" "agent/PROJ-234-token-revocation"
```

### 2. 可追溯性链路实现
```bash
#!/bin/bash
# 文件名: agent-traceability.sh
set -e

# 记录 Agent 会话日志
mkdir -p .agent-logs
SESSION_ID=$(uuidgen)
TRACE_LOG=".agent-logs/${SESSION_ID}.log"

# 写入追踪信息
cat > $TRACE_LOG <<EOF
Agent Session ID: $SESSION_ID
Task ID: $1
Model: $2
Prompt: $3
Start Time: $(date -u +"%Y-%m-%dT%H:%M:%SZ")
Git Branch: $(git rev-parse --abbrev-ref HEAD)
Git Commit: $(git rev-parse HEAD)
EOF

# 将会话 ID 添加到 commit trailer
git commit --amend --no-edit -m "" -m "Agent-Session: $SESSION_ID"

echo "Traceability log created: $TRACE_LOG"
echo "Session ID added to commit: $SESSION_ID"
```

## 总结
这套 Anthropic Skill 实现了原文中所有核心的 AI Git 版本管理最佳实践，包括：
- ✅ Agent-Aware 的 Commit 规范与模板
- ✅ Checkpoint Commit 与 Atomic Commit 策略
- ✅ 分支隔离 (Worktree/GitButler 虚拟分支)
- ✅ Stacked PR 管理
- ✅ 完整的可追溯性链路
- ✅ 与 JJ/GitButler 等新一代 VCS 工具集成
- ✅ CI/CD 合规性检查

所有脚本均遵循 Anthropic Skills 规范，可直接集成到 Claude 等 AI Agent 中，为 AI 编程提供标准化、可审计、易维护的 Git 版本管理能力。