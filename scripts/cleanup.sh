#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$REPO_ROOT"

SENSITIVE_FILES=(
  ".zshrc.secret"
  ".zshrc.secret.gpg"
  "ssh_keys.tar.gz.gpg"
)

for file in "${SENSITIVE_FILES[@]}"; do
  TARGET_PATH="$REPO_ROOT/$file"
  if [ -e "$TARGET_PATH" ]; then
    echo "🧹 Removing $file"
    rm -f "$TARGET_PATH"
  fi

  if [[ "$file" == *.gpg ]]; then
    PLAIN_NAME="${file%.gpg}"
    if [ -e "$REPO_ROOT/$PLAIN_NAME" ]; then
      echo "🧹 Removing decrypted copy $PLAIN_NAME"
      rm -f "$REPO_ROOT/$PLAIN_NAME"
    fi
  fi

  if git ls-files --error-unmatch "$file" >/dev/null 2>&1; then
    git rm --cached "$file"
  fi

done

echo "ℹ️  Sensitive archives removed from working tree."
echo "⚠️  Run ./scripts/repo_clean.sh to purge them from Git history and update the remote."
