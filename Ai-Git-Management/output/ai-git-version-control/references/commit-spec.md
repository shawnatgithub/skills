# Agent-Aware Commit Specification

## Table of Contents
- [Conventional Commits Format](#conventional-commits-format)
- [Agent Trailers](#agent-trailers)
- [Commit Types Reference](#commit-types-reference)
- [Checkpoint Commits](#checkpoint-commits)
- [Atomic Commit Strategy](#atomic-commit-strategy)
- [Examples](#examples)

## Conventional Commits Format

```
<type>(<scope>): <summary>

<body>

Agent-Task: <task-id>
Agent-Model: <model-name>
Agent-Decision: <key-decision>
Agent-Limitation: <known-limitation>
```

### Rules
- `summary`: imperative mood, lowercase, no period, ≤50 chars
- `scope`: module or component name
- `body`: explain WHAT and WHY, not HOW
- One logical change per commit (atomic)

## Agent Trailers

| Trailer | Required | Description |
|---------|----------|-------------|
| `Agent-Task` | Yes | Task tracking ID (e.g. PROJ-234) |
| `Agent-Model` | Yes | AI model that generated the change |
| `Agent-Decision` | Recommended | Key design decision rationale |
| `Agent-Limitation` | Recommended | Known limitations or follow-up TODOs |
| `Agent-Session` | Optional | Traceability session UUID |

## Commit Types Reference

| Type | Usage | Example |
|------|-------|---------|
| `feat` | New feature | `feat(auth): implement JWT refresh token rotation` |
| `fix` | Bug fix | `fix(api): handle null response in user endpoint` |
| `refactor` | Code restructuring | `refactor(db): extract connection pool logic` |
| `test` | Adding/updating tests | `test(auth): add unit tests for token refresh` |
| `docs` | Documentation only | `docs(api): update endpoint response schemas` |
| `chore` | Maintenance tasks | `chore(deps): upgrade express to 4.18.2` |
| `perf` | Performance improvement | `perf(query): add index on users.email` |
| `ci` | CI/CD changes | `ci: add agent commit compliance check` |
| `build` | Build system changes | `build: update webpack config for tree-shaking` |
| `style` | Code style (formatting) | `style: fix linting warnings in auth module` |

## Checkpoint Commits

For tasks taking >15 minutes, create checkpoint commits:

```
[WIP] Checkpoint: <stage-description> | Agent-Task: <task-id>
```

**Rules:**
- Commit after each major logical unit completes
- Always use `[WIP]` prefix
- Must be squashed into semantic commits before PR (use `agent-rebase-history.sh`)

## Atomic Commit Strategy

Each commit must be:
1. **Buildable**: project compiles after this commit
2. **Testable**: existing tests pass after this commit
3. **Self-contained**: one logical change only
4. **Revertable**: safe to `git revert` without breaking other features

**Anti-patterns to avoid:**
- Mixing refactoring with feature changes
- Committing unrelated files together
- Mega-commits spanning multiple features
- Committing broken code (even with [WIP])

## Examples

### Feature Commit
```
feat(auth): implement JWT refresh token rotation

Add sliding-window refresh token support to reduce re-login friction
while maintaining session security.

Agent-Task: PROJ-234
Agent-Model: gpt-4o
Agent-Decision: Used 7-day sliding window over fixed expiry for better UX
Agent-Limitation: Redis TTL not yet aligned with token expiry on logout
```

### Bug Fix Commit
```
fix(api): handle null response in user profile endpoint

Add null check for user.profile field before accessing nested
properties to prevent TypeError on incomplete user records.

Agent-Task: PROJ-567
Agent-Model: claude-3-opus
Agent-Decision: Return default profile object instead of throwing error
Agent-Limitation: None
```

### Checkpoint Commit
```
[WIP] Checkpoint: auth middleware scaffold complete | Agent-Task: PROJ-234
```
