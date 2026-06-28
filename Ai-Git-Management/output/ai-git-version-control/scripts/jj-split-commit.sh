#!/bin/bash
set -e

CHANGE_ID=$1
SPLIT_DESCRIPTION=$2

if [ -z "$CHANGE_ID" ]; then
    echo "Usage: jj-split-commit.sh <change_id> [split_description]"
    echo "  change_id: jj change ID to split"
    echo "  split_description: description for the new split commit"
    exit 1
fi

if ! command -v jj &> /dev/null; then
    echo "Error: jj (Jujutsu) is not installed. Install with: cargo install jj"
    exit 1
fi

jj split "$CHANGE_ID"

if [ -n "$SPLIT_DESCRIPTION" ]; then
    jj describe -m "$SPLIT_DESCRIPTION"
fi

echo "Split completed for change ID: $CHANGE_ID"
jj log --no-graph -n 3
