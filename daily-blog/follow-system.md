# Daily Follow Learning Loop

Goal: continuously improve who we follow on X by adding high-signal builders and removing low-value accounts.

## Operating Cadence

- **Daily (15 min):** discover candidates, score, and add up to 1–2 new candidates
- **Every 3 days (10 min):** reassess `probation` accounts
- **Weekly (20–30 min):** score all `following` accounts, relabel value tier, and prune low-value accounts

---

## 1) Discovery + Intake (Daily)

Search from:
- Existing high-signal follows (reply graph + quote graph)
- Recent topic queries:
  - `coding agents`
  - `agentic engineering`
  - `llm evals`
  - `security review`
  - `devtools`

### Candidate Score (0–10)

- +3 Original technical insight
- +2 Experiments / benchmarks / postmortems
- +2 Discussion quality (builders in replies)
- +1 Low hype ratio
- +1 Consistency (>=3 solid posts/week)
- +1 Relevance to AI coding / engineering execution

Promotion:
- `candidate` -> `probation` when score >=6
- `probation` -> `following` after 14 days of consistent signal

Intake guardrails:
- Max 1–2 candidates/day
- Prefer individuals over brand accounts unless primary-source technical signal
- Never add based on a single viral post

---

## 2) Value Labeling (Weekly)

Each followed account gets a **value label** based on the most recent 7 days:

- **A — Core Signal:** frequent actionable insight; should definitely stay followed
- **B — Useful:** occasional but meaningful technical value
- **C — Watchlist:** weak recent value; keep short-term only
- **D — Drop:** low signal/noise heavy; remove

### Weekly Value Score (0–10)

- +4 Actionable engineering insight
- +2 Originality (not repetitive reposts)
- +2 Relevance to current focus
- +1 Consistency this week
- +1 Credibility (evidence, code, demos, real outcomes)

Suggested mapping:
- 8–10 => A
- 6–7 => B
- 4–5 => C
- 0–3 => D

---

## 3) Prune Rules (Learning Loop)

Demote or remove accounts using explicit rules:

1. If weekly score <=5 for **2 consecutive weeks** -> mark `at_risk`
2. If score <=4 for the next weekly review -> move to `drop`
3. If `drop` persists for 7 days with no recovery evidence -> unfollow and archive row

Recovery condition:
- If an `at_risk`/`drop` account posts >=2 high-signal technical posts in a week, restore to `following` and relabel.

---

## 4) Tracker Fields

`daily-blog/follow-tracker.csv` is the source of truth.

Fields:
- `date_added`
- `handle`
- `status` (`candidate|probation|following|at_risk|drop|archived`)
- `intake_score`
- `weekly_value_score`
- `value_label` (`A|B|C|D`)
- `topic_fit`
- `evidence_1`
- `evidence_2`
- `last_review`
- `next_review`
- `notes`

---

## 5) Output in Daily Brief

Always include:
- Direct links for all claims
- `Follow Candidates` section (new additions)
- `Follow Review` section:
  - promotions/demotions
  - new `at_risk` accounts
  - accounts dropped this week
  - one-line reason for each change
