#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
POST_REL="${1:-}"

if [[ -z "$POST_REL" ]]; then
  echo "Usage: $0 _posts/YYYY-MM-DD-title.md" >&2
  exit 2
fi

POST_PATH="$REPO_DIR/$POST_REL"
if [[ ! -f "$POST_PATH" ]]; then
  echo "❌ Post not found: $POST_REL" >&2
  exit 1
fi

DATE_PREFIX="$(basename "$POST_REL" | cut -d- -f1-3)"
QUALITY_FILE="$REPO_DIR/daily-blog/quality-checks/${DATE_PREFIX}.md"

required_sections=(
  "## What’s New Since Yesterday"
  "## Claim Strength Ledger"
  "## What Could Make This Wrong"
  "## Builder Action Block"
)

for sec in "${required_sections[@]}"; do
  grep -qF "$sec" "$POST_PATH" || { echo "❌ Missing required section: $sec"; exit 1; }
done

# At least 3 https links overall
link_count=$(grep -oE 'https://[^)[:space:]]+' "$POST_PATH" | wc -l | tr -d ' ')
if [[ "$link_count" -lt 3 ]]; then
  echo "❌ Requires at least 3 source links, found $link_count"
  exit 1
fi

# Block obvious placeholder/template artifacts
grep -q '\[Short chunk title\]' "$POST_PATH" && { echo "❌ Placeholder found: [Short chunk title]"; exit 1; }
grep -q 'https://\.\.\.' "$POST_PATH" && { echo "❌ Placeholder source URL found"; exit 1; }

# Title guardrail: avoid generic recurring headline
if grep -qE '^title:\s*"?Daily AI (Development )?Insights' "$POST_PATH"; then
  echo "❌ Title is generic recurring template; use daily-specific headline"
  exit 1
fi

# Quality gate file required
if [[ ! -f "$QUALITY_FILE" ]]; then
  echo "❌ Missing quality gate file: daily-blog/quality-checks/${DATE_PREFIX}.md"
  exit 1
fi

# Parse numeric total and pass/fail
TOTAL=$(grep -E '^- Total: ' "$QUALITY_FILE" | tail -1 | sed -E 's/^- Total: ([0-9]+)\/30/\1/')
GATE=$(grep -E '^- Gate: ' "$QUALITY_FILE" | tail -1 | awk '{print $3}')

if [[ -z "${TOTAL:-}" || -z "${GATE:-}" ]]; then
  echo "❌ Quality gate file missing Total and/or Gate fields"
  exit 1
fi

if (( TOTAL < 25 )); then
  echo "❌ Quality total below threshold: ${TOTAL}/30"
  exit 1
fi

if [[ "$GATE" != "PASS" ]]; then
  echo "❌ Quality gate is not PASS (found: $GATE)"
  exit 1
fi

# Ensure no category below 4
while IFS= read -r line; do
  score=$(echo "$line" | sed -E 's#.*: ([0-9]+)/5#\1#')
  if [[ -n "$score" ]] && (( score < 4 )); then
    echo "❌ Category score below 4: $line"
    exit 1
  fi
done < <(grep -E '^- .*: [0-9]+/5$' "$QUALITY_FILE")

echo "✅ Validation passed for $POST_REL"
