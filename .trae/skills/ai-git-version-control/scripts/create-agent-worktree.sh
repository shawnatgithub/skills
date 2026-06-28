#!/bin/bash
set -e

TASK_ID=$1
DESCRIPTION=$2
BASE_DIR=${3:-.}

if [ -z "$TASK_ID" ] || [ -z "$DESCRIPTION" ]; then
    echo "Usage: create-agent-worktree.sh <task_id> <description> [base_dir]"
    echo "  task_id: agent task ID (e.g. PROJ-234)"
    echo "  description: brief task description"
    echo "  base_dir: base directory for worktree (default: current dir)"
    exit 1
fi

BRANCH_NAME="agent/${TASK_ID}-$(echo $DESCRIPTION | tr ' ' '-' | tr '[:upper:]' '[:lower:]')"
WORKTREE_PATH="${BASE_DIR}/agent-task-${TASK_ID}"

git worktree add "$WORKTREE_PATH" -b "$BRANCH_NAME"

echo "Created worktree for agent task:"
echo "  Path: $WORKTREE_PATH"
echo "  Branch: $BRANCH_NAME"
git worktree list | grep "$TASK_ID" || true
