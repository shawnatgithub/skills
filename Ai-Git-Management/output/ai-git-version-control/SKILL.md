---
name: ai-git-version-control
description: "Agent-Aware Git version control for AI coding agents. Provides standardized commit messages with Agent trailers, branch isolation, checkpoint commits, PR templates, stacked PRs, history cleanup, and CI compliance checks. Invoke when an AI agent needs to commit code, create branches, open PRs, manage Git history, or enforce version control best practices in agentic coding workflows."
---

# AI Git Version Control

Agent-Aware Git version control for AI coding agents following best practices.

## Quick Reference

### Commit Message Format
```
<type>(<scope>): <summary>

<body>

Agent-Task: <task-id>
Agent-Model: <model>
Agent-Decision: <decision>
Agent-Limitation: <limitation>
```

### Branch Naming
```
agent/<task-id>-<description>    # Agent feature branches
hotfix/<task-id>-<description>   # Urgent fixes
stacked/<description>            # Stacked PR branches
```

### Commit Types
`feat` `fix` `refactor` `test` `docs` `chore` `perf` `ci` `build` `style`

## Scripts

| Script | Purpose | Usage |
|--------|---------|-------|
| `generate-agent-commit.sh` | Generate Agent-Aware commit message | `<type> <scope> <summary> [body] [task_id] [model] [decision] [limitation]` |
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

## Core Workflow

### 1. Start a Task
```bash
# Create an isolated branch
scripts/create-agent-branch.sh PROJ-234 "refresh-token-rotation"

# Or create a worktree for parallel work
scripts/create-agent-worktree.sh PROJ-234 "refresh-token-rotation" ../worktrees
```

### 2. Work and Checkpoint
```bash
# For long tasks, create checkpoint commits
scripts/agent-checkpoint-commit.sh "auth middleware scaffold complete" PROJ-234
```

### 3. Commit with Agent Trailers
```bash
# Generate a proper commit message
MSG=$(scripts/generate-agent-commit.sh feat auth "implement JWT refresh token rotation" \
  "Add sliding-window refresh token support" \
  "PROJ-234" "claude-3-opus" \
  "7-day sliding window over fixed expiry" \
  "Redis TTL not aligned with logout")

git commit -m "$MSG"
```

### 4. Clean Up History Before PR
```bash
# Review and get rebase guidance
scripts/agent-rebase-history.sh main 10

# Then interactive rebase to squash [WIP] commits
git rebase -i main HEAD~10
```

### 5. Create PR
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
gh pr create --base main --title "feat(auth): implement JWT refresh token rotation" \
  --body-file .github/pull_request_template/agent.md
```

### 6. Add Traceability
```bash
# Create session trace log
scripts/agent-traceability.sh PROJ-234 claude-3-opus "Implement refresh token rotation"
```

## Detailed References

- **Commit specification & examples**: See [references/commit-spec.md](references/commit-spec.md) for Agent-Aware commit format, trailer definitions, atomic commit strategy, and complete examples
- **Branch management & isolation**: See [references/branch-management.md](references/branch-management.md) for worktree setup, GitButler virtual branches, and branch lifecycle
- **PR management & templates**: See [references/pr-management.md](references/pr-management.md) for PR template details, stacked PRs, review guidance, and history cleanup
- **CI/CD integration**: See [references/ci-cd-integration.md](references/ci-cd-integration.md) for GitHub Actions compliance checks, validation rules, and traceability setup

## Templates

- **Agent PR template**: See [assets/agent-pr-template.md](assets/agent-pr-template.md) — copy to `.github/pull_request_template/agent.md`
- **AGENT.md spec template**: See [assets/agent-md-template.md](assets/agent-md-template.md) — place in project root to define agent Git rules

## Key Rules

1. **Never commit directly to `main`** — always use `agent/` branches
2. **Every commit must be atomic** — one logical change, independently buildable
3. **Include Agent trailers** — `Agent-Task` and `Agent-Decision` are required
4. **Squash [WIP] commits** before opening a PR
5. **Never merge your own PRs** — request human review
6. **Do not commit secrets** — use environment variables instead
7. **Use checkpoint commits** for tasks >15 minutes, clean up before PR
