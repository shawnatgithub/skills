#!/bin/bash
set -e

ACTION=$1
BRANCH_NAME=$2
COMMIT_MSG=$3

if [ -z "$ACTION" ]; then
    echo "Usage: agent-gitbutler-integration.sh <action> [branch_name] [commit_msg]"
    echo "  action: create-virtual | assign | commit | create-stacked"
    echo "  branch_name: virtual branch name"
    echo "  commit_msg: commit message"
    exit 1
fi

if ! command -v but &> /dev/null; then
    echo "Error: GitButler CLI (but) is not installed. Install from https://gitbutler.com"
    exit 1
fi

case "$ACTION" in
    create-virtual)
        if [ -z "$BRANCH_NAME" ]; then
            echo "Error: branch_name required for create-virtual"
            exit 1
        fi
        but branch create "$BRANCH_NAME" --virtual
        echo "Created virtual branch: $BRANCH_NAME"
        ;;
    assign)
        if [ -z "$BRANCH_NAME" ]; then
            echo "Error: branch_name required for assign"
            exit 1
        fi
        but changes assign --branch "$BRANCH_NAME" --all
        echo "Assigned all changes to virtual branch: $BRANCH_NAME"
        ;;
    commit)
        if [ -z "$BRANCH_NAME" ] || [ -z "$COMMIT_MSG" ]; then
            echo "Error: branch_name and commit_msg required for commit"
            exit 1
        fi
        but commit "$BRANCH_NAME" -m "$COMMIT_MSG"
        echo "Committed to virtual branch: $BRANCH_NAME"
        ;;
    create-stacked)
        if [ -z "$BRANCH_NAME" ]; then
            echo "Error: branch_name required for create-stacked"
            exit 1
        fi
        PARENT_BRANCH=${3:-main}
        but branch -a "$PARENT_BRANCH" "$BRANCH_NAME"
        echo "Created stacked branch: $BRANCH_NAME (parent: $PARENT_BRANCH)"
        ;;
    *)
        echo "Unknown action: $ACTION"
        echo "Available actions: create-virtual, assign, commit, create-stacked"
        exit 1
        ;;
esac
