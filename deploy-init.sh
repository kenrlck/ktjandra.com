#!/usr/bin/env bash
# One-shot script to init the git repo, create the GitHub repo, and push.
# Run from inside this folder: `bash deploy-init.sh`
# Requires: gh CLI authenticated (`gh auth status` should show a green check).

set -e

REPO_NAME="ktjandra.com"
COMMIT_MSG="Initial commit: editorial Astro site"

cd "$(dirname "$0")"

if [ -d ".git" ]; then
	echo "git is already initialised in this folder. Skipping init."
else
	git init -b main
	echo "git initialised."
fi

git add .
if git diff --cached --quiet; then
	echo "Nothing to commit (working tree matches index)."
else
	git commit -m "$COMMIT_MSG"
	echo "First commit recorded."
fi

if git remote get-url origin >/dev/null 2>&1; then
	echo "Remote 'origin' already exists. Pushing to existing repo."
	git push -u origin main
else
	echo "Creating GitHub repo '$REPO_NAME' (public) and pushing main..."
	gh repo create "$REPO_NAME" --public --source=. --remote=origin --push
fi

REPO_URL=$(gh repo view --json url -q .url)
echo ""
echo "Done. Repo at: $REPO_URL"
echo "Next: connect this repo to Cloudflare Pages."
