#!/bin/bash
set -e

TASK_ID=$1
MODEL=$2
PROMPT=$3

if [ -z "$TASK_ID" ]; then
    echo "Usage: agent-traceability.sh <task_id> [model] [prompt]"
    echo "  task_id: agent task ID (e.g. PROJ-234)"
    echo "  model: AI model used (e.g. claude-3-opus)"
    echo "  prompt: original task prompt"
    exit 1
fi

mkdir -p .agent-logs
SESSION_ID=$(uuidgen 2>/dev/null || python3 -c "import uuid; print(uuid.uuid4())")
TRACE_LOG=".agent-logs/${SESSION_ID}.log"

cat > "$TRACE_LOG" <<EOF
Agent Session ID: $SESSION_ID
Task ID: $TASK_ID
Model: ${MODEL:-unknown}
Prompt: ${PROMPT:-N/A}
Start Time: $(date -u +"%Y-%m-%dT%H:%M:%SZ" 2>/dev/null || date)"
Git Branch: $(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo 'N/A')
Git Commit: $(git rev-parse HEAD 2>/dev/null || echo 'N/A')
EOF

if git rev-parse --is-inside-work-tree &>/dev/null; then
    git commit --amend --no-edit -m "" -m "Agent-Session: $SESSION_ID" 2>/dev/null || true
fi

echo "Traceability log created: $TRACE_LOG"
echo "Session ID: $SESSION_ID"
