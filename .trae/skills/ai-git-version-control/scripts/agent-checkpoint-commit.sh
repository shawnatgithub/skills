#!/bin/bash
set -e

STAGE=$1
TASK_ID=$2

if [ -z "$STAGE" ]; then
    echo "Usage: agent-checkpoint-commit.sh <checkpoint_stage> [task_id]"
    echo "  checkpoint_stage: description of current progress stage"
    echo "  task_id: agent task ID (optional)"
    exit 1
fi

CHECKPOINT_MSG="[WIP] Checkpoint: ${STAGE}"
if [ -n "$TASK_ID" ]; then
    CHECKPOINT_MSG="${CHECKPOINT_MSG} | Agent-Task: ${TASK_ID}"
fi

git add -A
git commit -m "$CHECKPOINT_MSG"

echo "Checkpoint commit completed for stage: $STAGE"
git log -1 --oneline
