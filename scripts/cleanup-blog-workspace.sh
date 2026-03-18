#!/usr/bin/env bash
set -euo pipefail

MODE="dry-run"
if [[ "${1:-}" == "--apply" ]]; then
  MODE="apply"
elif [[ "${1:-}" == "--dry-run" || -z "${1:-}" ]]; then
  MODE="dry-run"
else
  echo "Usage: $0 [--dry-run|--apply]" >&2
  exit 2
fi

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
WORKSPACE_ROOT="$(cd "$ROOT/.." && pwd)"

# Approved remove targets (rebuildable/temp only)
TARGETS=(
  "$ROOT/_site"
  "$ROOT/.jekyll-cache"
  "$ROOT/.sass-cache"
  "$ROOT/.jekyll-metadata"
  "$WORKSPACE_ROOT/daily-blog/tmp"
)

# Approved temp patterns under workspace root
PATTERNS=(
  "*.tmp"
  "*.temp"
  "*.swp"
  "*~"
  ".DS_Store"
)

found=0
removed=0

echo "[cleanup] mode=$MODE"
echo "[cleanup] repo=$ROOT"

action_remove() {
  local p="$1"
  if [[ "$MODE" == "apply" ]]; then
    rm -rf -- "$p"
    echo "REMOVE $p"
    removed=$((removed+1))
  else
    echo "WOULD_REMOVE $p"
  fi
  found=$((found+1))
}

for t in "${TARGETS[@]}"; do
  if [[ -e "$t" ]]; then
    action_remove "$t"
  fi
done

for pat in "${PATTERNS[@]}"; do
  while IFS= read -r path; do
    [[ -n "$path" ]] || continue
    action_remove "$path"
  done < <(find "$WORKSPACE_ROOT" -type f -name "$pat" 2>/dev/null || true)
done

echo "[cleanup] candidates=$found"
if [[ "$MODE" == "apply" ]]; then
  echo "[cleanup] removed=$removed"
else
  echo "[cleanup] dry-run only; no files removed"
fi
