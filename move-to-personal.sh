#!/usr/bin/env bash
# Re-points this repo from your company GitHub account to your personal one.
# Run AFTER you've switched `gh` to your personal account (see instructions below).
# From inside the website folder: `bash move-to-personal.sh`

set -e

cd "$(dirname "$0")"

echo "--- Current state ---"
git remote -v || true
echo ""

# Check gh is authed and which account is active.
if ! gh auth status >/dev/null 2>&1; then
	echo "ERROR: gh is not authenticated. Run 'gh auth login' first."
	exit 1
fi

ACTIVE_USER=$(gh api user -q .login)
echo "Active gh account: $ACTIVE_USER"
echo ""

read -r -p "Create the new repo as $ACTIVE_USER/ktjandra.com? (y/n) " ANSWER
if [ "$ANSWER" != "y" ] && [ "$ANSWER" != "Y" ]; then
	echo "Aborted. Switch to your personal gh account and re-run."
	echo "  gh auth login        # if personal account isn't added yet"
	echo "  gh auth switch       # if it is, but isn't active"
	exit 1
fi

# Drop the old remote so we can re-create it cleanly.
if git remote get-url origin >/dev/null 2>&1; then
	OLD_REMOTE=$(git remote get-url origin)
	echo "Removing old origin: $OLD_REMOTE"
	git remote remove origin
fi

# Create the new repo under the active account and push main.
gh repo create ktjandra.com --public --source=. --remote=origin --push

echo ""
echo "--- New state ---"
git remote -v
echo ""
echo "New repo: $(gh repo view --json url -q .url)"
echo ""
echo "If you want to clean up the old repo on your company account:"
echo "  gh repo delete <company-org>/ktjandra.com --yes"
echo "  (run that AFTER switching gh back to the company account, or do it via the web UI)"
