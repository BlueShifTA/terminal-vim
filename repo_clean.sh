#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

if ! command -v bfg >/dev/null 2>&1; then
  echo "❌ BFG Repo-Cleaner is not installed (try 'brew install bfg')."
  exit 1
fi

echo "🧼 Removing encrypted archives from git history..."
BFG_ARGS=(
  "--delete-files" ".zshrc.secret.gpg"
  "--delete-files" "ssh_keys.tar.gz.gpg"
)

bfg "${BFG_ARGS[@]}" "$SCRIPT_DIR" .

echo "🗑️  Expiring reflog and pruning old objects..."
git reflog expire --expire=now --all
git gc --prune=now --aggressive

echo "🚀 Force pushing rewritten history..."
if git remote get-url origin >/dev/null 2>&1; then
  git push --force
else
  echo "⚠️  No 'origin' remote configured. Add it back (e.g. 'git remote add origin <url>') before pushing."
fi

echo "✅ Repository history cleaned."
