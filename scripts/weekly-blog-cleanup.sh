#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="$SCRIPT_DIR/../logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/cleanup-$(date +%Y%m%d-%H%M%S).log"

{
  echo "[weekly-cleanup] start $(date -Is)"
  "$SCRIPT_DIR/cleanup-blog-workspace.sh" --apply
  echo "[weekly-cleanup] done $(date -Is)"
} | tee -a "$LOG_FILE"

# Optional Slack notification via webhook (if configured)
CONFIG_FILE="/workspace/ai-blog-automation/config.env"
if [[ -f "$CONFIG_FILE" ]]; then
  # shellcheck disable=SC1090
  source "$CONFIG_FILE"
  if [[ -n "${SLACK_WEBHOOK:-}" ]]; then
    summary=$(tail -n 20 "$LOG_FILE" | sed 's/"/\\"/g')
    payload=$(cat <<JSON
{"text":"🧹 Weekly blog cleanup completed.\n\n
action log (tail):\n$summary"}
JSON
)
    curl -s -X POST -H 'Content-type: application/json' --data "$payload" "$SLACK_WEBHOOK" >/dev/null || true
  fi
fi
