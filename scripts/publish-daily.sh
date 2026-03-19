#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_DIR"

TARGET_DATE="${1:-$(date +%Y-%m-%d)}"
POST_FILE=$(ls -1 _posts/${TARGET_DATE}*.md 2>/dev/null | head -1 || true)

if [[ -z "$POST_FILE" ]]; then
  echo "❌ No post found for ${TARGET_DATE} in _posts/"
  exit 1
fi

scripts/validate-post-v2.sh "$POST_FILE"

git add "$POST_FILE" daily-blog/quality-checks/${TARGET_DATE}.md
if [[ -d "assets/images/${TARGET_DATE}" ]]; then
  git add "assets/images/${TARGET_DATE}" || true
fi

if git diff --cached --quiet; then
  echo "ℹ️ Nothing to commit"
  exit 0
fi

git commit -m "Publish daily post for ${TARGET_DATE}"
git push origin master

echo "✅ Published ${POST_FILE}"
