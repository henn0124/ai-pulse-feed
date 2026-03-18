#!/usr/bin/env bash
set -euo pipefail

openclaw cron add \
  --name "Weekly blog cleanup" \
  --cron "30 6 * * 0" \
  --tz "America/Los_Angeles" \
  --session isolated \
  --message "Run /workspace/ai-pulse-feed/scripts/cleanup-blog-workspace.sh --apply, summarize deleted paths and counts, and report completion status." \
  --announce \
  --channel slack \
  --to "user:U02LU8SG61K"

echo "Created. Current jobs:"
openclaw cron list
