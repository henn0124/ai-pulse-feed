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

git add "$POST_FILE" "daily-blog/quality-checks/${TARGET_DATE}.md"
if [[ -d "assets/images/${TARGET_DATE}" ]]; then
  git add "assets/images/${TARGET_DATE}" || true
fi

if git diff --cached --quiet; then
  echo "ℹ️ Nothing to commit"
else
  git commit -m "Publish daily post for ${TARGET_DATE}"
  git push origin master
fi

# Verify canonical URL is live (HTTP 200 required) before deleting local draft copy.
CANONICAL_URL=$(node - "$POST_FILE" <<'NODE'
const fs = require('fs');
const path = require('path');

const siteBase = 'https://henn0124.github.io/ai-pulse-feed';
const postRel = process.argv[2];
if (!postRel) process.exit(2);

const postPath = path.resolve(postRel);
const raw = fs.readFileSync(postPath, 'utf8');

function parseFrontmatter(txt) {
  if (!txt.startsWith('---\n')) return {};
  const end = txt.indexOf('\n---\n', 4);
  if (end === -1) return {};
  const lines = txt.slice(4, end).split('\n');
  const out = {};
  for (const line of lines) {
    const i = line.indexOf(':');
    if (i === -1) continue;
    out[line.slice(0, i).trim()] = line.slice(i + 1).trim().replace(/^"|"$/g, '');
  }
  return out;
}

async function urlReturns200(url) {
  try {
    const head = await fetch(url, { method: 'HEAD', redirect: 'follow' });
    if (head.status === 200) return true;
  } catch (_) {}
  try {
    const get = await fetch(url, { method: 'GET', redirect: 'follow' });
    return get.status === 200;
  } catch (_) {
    return false;
  }
}

function candidatesFromPost(rel, fm) {
  if (fm.permalink) {
    const p = fm.permalink.startsWith('/') ? fm.permalink : `/${fm.permalink}`;
    const clean = `${siteBase}${p}`.replace(/([^:])\/\//g, '$1/').replace(/\/$/, '');
    return [clean, `${clean}/`];
  }

  const base = path.basename(rel, '.md');
  const m = base.match(/^(\d{4})-(\d{2})-(\d{2})-(.+)$/);
  if (!m) return [];
  const [, y, mo, d, slug] = m;
  return [
    `${siteBase}/${y}/${mo}/${d}/${slug}.html`,
    `${siteBase}/${y}/${mo}/${d}/${slug}/`,
    `${siteBase}/${slug}/`,
  ];
}

(async () => {
  const fm = parseFrontmatter(raw);
  const candidates = candidatesFromPost(postRel, fm);
  for (const u of candidates) {
    if (await urlReturns200(u)) {
      process.stdout.write(u);
      process.exit(0);
    }
  }
  process.exit(1);
})();
NODE
)

if [[ -z "${CANONICAL_URL:-}" ]]; then
  echo "⚠️ Canonical URL is not live (HTTP 200), skipping local draft deletion for ${TARGET_DATE}."
else
  DRAFT_FILE="$REPO_DIR/../daily-blog/${TARGET_DATE}.md"
  if [[ -f "$DRAFT_FILE" ]]; then
    rm -f -- "$DRAFT_FILE"
    echo "🧹 Deleted local draft: $DRAFT_FILE"
  fi
  echo "✅ Canonical URL live: ${CANONICAL_URL}"
fi

# local hygiene cleanup (temp/rebuildable only)
if [[ -x scripts/cleanup-blog-workspace.sh ]]; then
  scripts/cleanup-blog-workspace.sh --apply || true
fi

echo "✅ Published ${POST_FILE}"
