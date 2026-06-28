#!/bin/bash
set -e

MAIN_BRANCH=${1:-main}
COMMIT_COUNT=${2:-10}

echo "=== Agent Commit History Rebase Guide ==="
echo "1. Current commit history (last $COMMIT_COUNT commits):"
git log --oneline "$MAIN_BRANCH"..HEAD -n "$COMMIT_COUNT"

echo ""
echo "2. Recommended rebase operations:"
echo "   - squash [WIP] checkpoint commits into semantic commits"
echo "   - reword commits to follow Conventional Commits format"
echo "   - ensure all commits have Agent-Task/Model/Decision trailers"

echo ""
echo "3. Execute interactive rebase:"
echo "   git rebase -i $MAIN_BRANCH HEAD~$COMMIT_COUNT"

REBASE_TEMPLATE=$(mktemp)
cat > "$REBASE_TEMPLATE" <<'EOF'
# Agent Rebase Template - Follow these rules:
# 1. Keep one commit per logical change (atomic commit)
# 2. Squash all [WIP] commits into relevant semantic commits
# 3. Add Agent-Task/Model/Decision trailers to each commit
# 4. Use Conventional Commits format (feat/fix/refactor/test/docs)
#
# Operations: pick/p, squash/s, reword/r, fixup/f, drop/d
EOF

echo ""
echo "4. Rebase template saved to: $REBASE_TEMPLATE"
cat "$REBASE_TEMPLATE"
