# AI Development Pulse

Jekyll blog deployed on GitHub Pages.

## Canonical Daily Publish Flow (single source of truth)

Run all publishing from this repo only:

```bash
cd /workspace/ai-pulse-feed
scripts/validate-post-v2.sh _posts/YYYY-MM-DD-your-slug.md
scripts/publish-daily.sh YYYY-MM-DD
node scripts/prepare-slack-share.js YYYY-MM-DD "Fresh daily headline"
```

**Hard rule:** never send a “Done” delivery update (or Slack share) until `prepare-slack-share.js` passes and returns a hyperlink payload.

### Required quality gate file
Before publish, create:

`daily-blog/quality-checks/YYYY-MM-DD.md`

with this block:

```md
Quality Check (v2)
- Original Insight: X/5
- Evidence & Traceability: X/5
- Structure & Readability: X/5
- Practical Value: X/5
- Trust, Risk, and Quality Control: X/5
- Novelty & Continuity: X/5
- Total: XX/30
- Gate: PASS
```

Publish is blocked unless:
- total >= 25/30
- no category below 4
- required post sections exist

## Schedule
Daily scheduled run target: **6:00 AM Pacific**.

## Deprecated paths
`/workspace/ai-blog-automation` and legacy root-level publish scripts are deprecated and fail-fast to avoid accidental usage.
