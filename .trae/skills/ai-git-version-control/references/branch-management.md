# Branch Management & Isolation

## Table of Contents
- [Branch Naming Convention](#branch-naming-convention)
- [Branch Creation Workflow](#branch-creation-workflow)
- [Git Worktree Isolation](#git-worktree-isolation)
- [GitButler Virtual Branches](#gitbutler-virtual-branches)
- [Branch Lifecycle](#branch-lifecycle)

## Branch Naming Convention

All agent-initiated branches MUST follow:

```
agent/<task-id>-<description>
```

| Part | Format | Example |
|------|--------|---------|
| `agent/` | Fixed prefix | `agent/` |
| `<task-id>` | Project tracker ID | `PROJ-234` |
| `<description>` | Lowercase, hyphenated | `refresh-token-rotation` |

**Full example:** `agent/PROJ-234-refresh-token-rotation`

### Rules
- Never commit directly to `main` or `develop`
- Use `stacked/` prefix for stacked PR branches: `stacked/<description>`
- Use `hotfix/` prefix for urgent fixes: `hotfix/PROJ-999-critical-auth-bug`

## Branch Creation Workflow

```
1. git checkout main
2. git pull origin main
3. git checkout -b agent/<task-id>-<description>
4. ... work on the branch ...
5. Push and create PR when ready
```

**Script:** `scripts/create-agent-branch.sh <task_id> <description>`

## Git Worktree Isolation

Use worktrees when an agent needs to work on multiple tasks simultaneously without context switching.

### When to Use Worktrees
- Multiple concurrent agent tasks
- Need to reference one branch while working on another
- Parallel development with isolated build environments

### Workflow
```
1. git worktree add <path> -b agent/<task-id>-<description>
2. cd <path>
3. ... work in isolated directory ...
4. When done: git worktree remove <path>
```

**Script:** `scripts/create-agent-worktree.sh <task_id> <description> [base_dir]`

### Worktree Best Practices
- Place worktrees outside the main project directory
- Name worktree directories: `agent-task-<TASK-ID>`
- Clean up worktrees after PR merge: `git worktree remove <path>`

## GitButler Virtual Branches

GitButler provides virtual branch support for managing multiple logical changes within a single working directory.

### Prerequisites
- GitButler >= 0.18.0 installed
- GitButler CLI (`but`) available in PATH

### Operations

| Action | Command |
|--------|---------|
| Create virtual branch | `but branch create <name> --virtual` |
| Assign changes to branch | `but changes assign --branch <name> --all` |
| Commit on virtual branch | `but commit <branch> -m "<message>"` |
| Create stacked branch | `but branch -a <parent> <child>` |

**Script:** `scripts/agent-gitbutler-integration.sh <action> [branch_name] [commit_msg]`

## Branch Lifecycle

```
main ──────────────────────────────────────────
  │
  ├── agent/PROJ-234-feature-a ──→ PR #1 ──→ merge ──→ delete branch
  │
  ├── agent/PROJ-567-feature-b ──→ PR #2 ──→ merge ──→ delete branch
  │
  └── stacked/feature-c-part1 ──→ PR #3
       └── stacked/feature-c-part2 ──→ PR #4
```

### Cleanup Rules
- Delete branch after PR merge
- Remove worktrees after branch deletion
- Prune remote-tracking references: `git remote prune origin`
