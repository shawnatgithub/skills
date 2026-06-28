#!/bin/bash
set -e

TYPE=$1
SCOPE=$2
SUMMARY=$3
BODY=$4
TASK_ID=$5
MODEL=$6
DECISION=$7
LIMITATION=$8

if [ -z "$TYPE" ] || [ -z "$SCOPE" ] || [ -z "$SUMMARY" ]; then
    echo "Usage: generate-agent-commit.sh <type> <scope> <summary> [body] [task_id] [model] [decision] [limitation]"
    echo "  type: feat|fix|refactor|test|docs|chore|perf|ci|build|style"
    echo "  scope: module or component name"
    echo "  summary: short imperative description"
    exit 1
fi

COMMIT_MSG="${TYPE}(${SCOPE}): ${SUMMARY}"

if [ -n "$BODY" ]; then
    COMMIT_MSG="${COMMIT_MSG}

${BODY}"
fi

TRAILERS=""
if [ -n "$TASK_ID" ]; then
    TRAILERS="${TRAILERS}
Agent-Task: ${TASK_ID}"
fi
if [ -n "$MODEL" ]; then
    TRAILERS="${TRAILERS}
Agent-Model: ${MODEL}"
fi
if [ -n "$DECISION" ]; then
    TRAILERS="${TRAILERS}
Agent-Decision: ${DECISION}"
fi
if [ -n "$LIMITATION" ]; then
    TRAILERS="${TRAILERS}
Agent-Limitation: ${LIMITATION}"
fi

if [ -n "$TRAILERS" ]; then
    COMMIT_MSG="${COMMIT_MSG}
${TRAILERS}"
fi

echo "$COMMIT_MSG"
