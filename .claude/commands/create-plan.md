# Persist the Approved Plan

This command no longer generates a plan — it persists one that already exists.

By this point, the plan should already have been produced and approved through Claude Code's native Plan Mode (`EnterPlanMode` → codebase exploration and reasoning → `ExitPlanMode` for approval). That conversation is the actual due-diligence step. Do not re-derive, re-summarize, or re-decide anything here.

## What to do

Save the approved plan to `plans/[feature-name].md`, preserving the real reasoning:

- What we're building and why
- The key decisions made and the trade-offs behind them (not a one-line "choice — rationale", the actual reasoning that led there)
- The concrete steps, in the order they'll be implemented

This file exists so a future session — especially after a context compaction — can pick up the work without re-explaining requirements from scratch. It is not a progress dashboard: no emoji status tracking, no completion percentage, no checklist theater. Plain markdown, written to be read once by a human catching up, or by Claude resuming a session.

## When there's no Plan Mode output to persist

If you're being asked to run this without having gone through Plan Mode first — stop and go back. Enter Plan Mode (`EnterPlanMode`), do the exploration and reasoning there, get it approved via `ExitPlanMode`, and only then come back to persist it here.

ARGUMENTS: [feature-name]
