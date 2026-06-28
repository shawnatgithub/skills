#!/bin/bash
set -e

BASE_BRANCH=$1
PR_TITLES_FILE=$2

if [ -z "$BASE_BRANCH" ] || [ -z "$PR_TITLES_FILE" ]; then
    echo "Usage: create-stacked-prs.sh <base_branch> <pr_titles_file>"
    echo "  base_branch: base branch for the first PR (e.g. main)"
    echo "  pr_titles_file: file containing PR titles, one per line"
    exit 1
fi

if ! command -v gh &> /dev/null; then
    echo "Error: GitHub CLI (gh) is required - install from https://cli.github.com"
    exit 1
fi

PR_NUMBERS=()
CURRENT_BRANCH="$BASE_BRANCH"

while IFS= read -r title; do
    [ -z "$title" ] && continue

    BRANCH_NAME="stacked/$(echo "$title" | tr ' ' '-' | tr '[:upper:]' '[:lower:]' | cut -c1-50)"
    git checkout -b "$BRANCH_NAME" "$CURRENT_BRANCH"

    git commit --allow-empty -m "$title"

    git push origin "$BRANCH_NAME"
    PR_NUMBER=$(gh pr create --base "$CURRENT_BRANCH" --head "$BRANCH_NAME" --title "$title" --body "Stacked PR for: $title" --json number --jq '.number')
    PR_NUMBERS+=("$PR_NUMBER")

    CURRENT_BRANCH="$BRANCH_NAME"

    echo "Created stacked PR #$PR_NUMBER: $title"
done < "$PR_TITLES_FILE"

echo ""
echo "Created stacked PRs (bottom to top):"
for i in "${!PR_NUMBERS[@]}"; do
    echo "$((i+1)). PR #${PR_NUMBERS[$i]}"
done

if command -v gh-stack &> /dev/null; then
    gh stack sync
    echo "Stacked PRs synchronized with gh-stack"
fi
