#!/bin/bash
set -e

TARGET_DIR=${1:-.}

AGENT_MD='# AGENT.md - AI Agent Version Control Spec

## Git Workflow

### Branch Naming
- Use `agent/<task-id>-<description>` for all agent-initiated branches
- Never commit directly to `main` or `develop`

### Commit Guidelines
- Follow Conventional Commits: https://www.conventionalcommits.org
- Each commit must be atomic: one logical change, buildable and testable in isolation
- Include Agent-Task, Agent-Decision trailers in commit body

### PR Process
- Open PR against `main` using the agent PR template
- Ensure all CI checks pass before requesting review
- Do not merge your own PRs

### What NOT to Commit
- API keys, tokens, passwords (use environment variables)
- Build artifacts, `node_modules`, `__pycache__`
- Local config files (`.env`, `*.local`)
- Large binary files (use Git LFS if necessary)

### Checkpoint Commits
For tasks expected to take more than 15 minutes:
- Commit after completing each major logical unit
- Use `[WIP]` prefix in message
- Clean up history with interactive rebase before opening PR

### CI Commands for Agents
```bash
# Run only affected package tests (requires Nx or Turborepo)
nx affected --target=test
turbo run test --filter='\''[HEAD^1]'\''

# Full check (run by CI before merge, not recommended for local agent)
# npm run test:all
```'

echo "$AGENT_MD" > "${TARGET_DIR}/AGENT.md"
echo "Generated AGENT.md at ${TARGET_DIR}/AGENT.md"
