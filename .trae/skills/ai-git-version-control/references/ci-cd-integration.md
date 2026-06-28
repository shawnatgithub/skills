# CI/CD Integration for Agent-Aware Git

## Table of Contents
- [GitHub Actions Compliance Check](#github-actions-compliance-check)
- [Commit Message Validation](#commit-message-validation)
- [Branch Naming Validation](#branch-naming-validation)
- [Agent Session Traceability](#agent-session-traceability)

## GitHub Actions Compliance Check

Add this workflow to enforce Agent-Aware Git standards on every PR:

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
          if [[ ! $BRANCH_NAME =~ ^agent/[A-Z0-9]+-[a-z0-9-]+$ ]] && \
             [[ ! $BRANCH_NAME =~ ^hotfix/[A-Z0-9]+-[a-z0-9-]+$ ]] && \
             [[ ! $BRANCH_NAME =~ ^stacked/[a-z0-9-]+$ ]]; then
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

## Commit Message Validation

### Required Trailers
Every commit in an agent PR must include:
- `Agent-Task:` - Task tracking ID
- `Agent-Decision:` - Key decision rationale

### Optional but Recommended
- `Agent-Model:` - AI model used
- `Agent-Limitation:` - Known limitations
- `Agent-Session:` - Traceability session UUID

### Validation Regex
```
Agent-Task: [A-Z]+-[0-9]+
Agent-Model: .+
Agent-Decision: .+
Agent-Limitation: .+
Agent-Session: [0-9a-f-]{36}
```

## Branch Naming Validation

### Allowed Patterns
| Pattern | Example | Use Case |
|---------|---------|----------|
| `agent/<ID>-<desc>` | `agent/PROJ-234-refresh-token` | Agent feature branches |
| `hotfix/<ID>-<desc>` | `hotfix/PROJ-999-auth-crash` | Urgent production fixes |
| `stacked/<desc>` | `stacked/auth-token-model` | Stacked PR branches |

### Validation Regex
```
^(agent|hotfix)/[A-Z]+-[0-9]+-[a-z0-9-]+$|^stacked/[a-z0-9-]+$
```

## Agent Session Traceability

### How It Works
1. Agent starts a task → `agent-traceability.sh` creates a session log
2. Session UUID is added to commit trailers
3. Session log records: task ID, model, prompt, branch, commit SHA, timestamp
4. CI can verify session UUID exists in `.agent-logs/`

### Session Log Format
```
Agent Session ID: <uuid>
Task ID: PROJ-234
Model: claude-3-opus
Prompt: <original task prompt>
Start Time: 2024-01-15T10:30:00Z
Git Branch: agent/PROJ-234-refresh-token
Git Commit: abc123def456
```

### .gitignore Addition
Add to `.gitignore`:
```
.agent-logs/
```

Session logs are for local traceability only and should not be committed.
