---
layout: post
title: "Noise Is Cheap. Review Loops Are the Moat."
date: 2026-03-23 06:00:00 -0700
author: Aaron Henningsgaard
tags: [AI development, coding agents, engineering workflow, reliability, developer productivity]
excerpt: "The strongest signal this cycle is operational: teams are discovering that durable advantage comes from review design, data boundaries, and repeatable handoffs—not raw model novelty."
---

The Tier 1 signal is increasingly clear: model capability is not the bottleneck for serious teams anymore. The bottleneck is whether output can survive branching, review, and ownership transfer without creating hidden risk.

## What’s New Since Yesterday

- **Operational constraints are the conversation, not just capability demos.** The highest-signal updates this cycle center on Git workflows, trust boundaries, and agent handoff friction.
- **Security and privacy concerns are moving into daily engineering practice.** Practical examples of profiling and repo-access constraints are forcing teams to tighten data and auth assumptions.
- **Leadership framing is converging with implementation reality.** “Anyone can ship” narratives are being countered by who can actually maintain and govern AI-assisted systems at quality.

## Claim Strength Ledger

- **Verified**
  - Simon Willison published concrete guidance around using Git with coding agents, reinforcing that production value depends on reviewable workflows, not prompt cleverness alone ([https://x.com/simonw/status/2035482121037635798](https://x.com/simonw/status/2035482121037635798)).
  - Simon also highlighted a practical privacy risk: LLMs can infer sensitive user profile traits from public text, which has direct implications for internal copilots and retrieval scope ([https://x.com/simonw/status/2035509993664127455](https://x.com/simonw/status/2035509993664127455)).
  - Tooling limitations around private repo access continue to shape real-world agent ergonomics and deployment constraints ([https://x.com/simonw/status/2035448423986659684](https://x.com/simonw/status/2035448423986659684)).
- **Supported**
  - Karpathy’s ongoing coding-agent framing continues to emphasize second-order workflow and labor effects beyond raw model benchmarks ([https://x.com/karpathy/status/2035158351357911527](https://x.com/karpathy/status/2035158351357911527)).
  - Milan Milanović’s recent leadership commentary reinforces that broad tool access does not remove the need for engineering ownership and quality discipline ([https://x.com/milan_milanovic/status/2035299984384377259](https://x.com/milan_milanovic/status/2035299984384377259)).
  - Cursor’s recent product direction still points toward tighter orchestration and workflow surfaces, even when day-to-day post velocity varies ([https://x.com/cursor_ai/status/2034668943676244133](https://x.com/cursor_ai/status/2034668943676244133)).
- **Hypothesis**
  - Over the next month, team performance spread will be explained more by review-loop design (risk tiers, escalation policy, explicit ownership) than by marginal model upgrades.

## What Could Make This Wrong

If foundation models materially reduce error rates on real production tasks (not just eval suites), heavy review structures may become less decisive for low/medium-risk work. This thesis also weakens if platforms abstract auth, provenance, and governance so effectively that workflow design becomes commoditized.

## Builder Action Block

- **Do now (this week):** Add explicit AI review checkpoints by risk tier (low/medium/high) and require named owners for merge accountability.
- **Watch next (1–2 weeks):** Track “agent-produced, human-accepted without rework” as a reliability metric; optimize that before chasing higher output volume.
- **Reference stack (required):**
  - https://x.com/simonw/status/2035482121037635798
  - https://x.com/simonw/status/2035509993664127455
  - https://x.com/simonw/status/2035448423986659684
  - https://x.com/karpathy/status/2035158351357911527
  - https://x.com/milan_milanovic/status/2035299984384377259
- **What success looks like (required):** Faster merges with fewer rollback-worthy surprises, clearer ownership boundaries, and lower review churn.
- **Ignore for now (required):** Benchmark-leaderboard swings without workflow evidence, “ship faster” claims lacking defect/rework context, and one-off demo virality.

## Bottom Line

The edge is shifting from model novelty to execution quality. In this phase, teams that can turn agent output into trustworthy, reviewable, repeatable delivery will compound faster than teams that only optimize for generation speed.
