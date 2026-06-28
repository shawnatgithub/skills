#!/bin/bash
set -e

TASK_ID=$1
DESCRIPTION=$2

if [ -z "$TASK_ID" ] || [ -z "$DESCRIPTION" ]; then
    echo "Usage: create-agent-branch.sh <task_id> <description>"
    echo "  task_id: agent task ID (e.g. PROJ-234)"
    echo "  description: brief task description"
    exit 1
fi

BRANCH_NAME="agent/${TASK_ID}-$(echo $DESCRIPTION | tr ' ' '-' | tr '[:upper:]' '[:lower:]')"

git checkout main
git pull origin main
git checkout -b "$BRANCH_NAME"

echo "Created agent branch: $BRANCH_NAME"
git branch -v | grep "$BRANCH_NAME" || true
