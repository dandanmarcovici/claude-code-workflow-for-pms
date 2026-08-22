# Peer Review Reconciliation

**Opt-in, not routine.** Same bar as before: non-trivial architecture, security-sensitive code, something you're unsure about. `/code-review` (native) is enough for most sessions.

This command reconciles **real PR comments** — from Codex and/or `/code-review ultra` (run with `--comment`) — not feedback pasted in manually.

Codex's "on PR open" auto-trigger isn't reliable — it can silently not fire. `WORKFLOW.md` has commenting `@codex review` right after opening the PR as its own step, always, so don't assume Codex has reviewed by the time this command runs. If step 2 below comes back empty, that step was probably skipped — go comment `@codex review` and wait before concluding there's nothing to reconcile.

## What to do

1. Identify the PR for the current branch. If ambiguous, ask — or take a PR number as an argument.
2. Fetch the PR's review comments via GitHub (`mcp__github__get_pull_request_comments` / `get_pull_request_reviews`). Ignore plain discussion replies — only findings.
3. For EACH finding:
   - **Verify it exists** — check the actual code. Don't take it at face value.
   - **They have less context than you** on this project's history and decisions (Codex, and `/code-review ultra`'s cloud agents alike) — **you are the dev lead**.
   - **If it doesn't hold up** — reply on that PR thread explaining why (already handled, misunderstood architecture, by design).
   - **If it does hold up** — assess severity, add to a fix plan.
4. After analysis, report:
   - Summary of **valid findings** (confirmed, worth fixing)
   - Summary of **invalid findings** (with brief why, already posted as replies)
   - **Prioritized action plan** for confirmed issues
5. Once fixes are implemented and pushed, reply on the resolved threads so the PR history reflects what actually happened — don't fix silently and merge over it.

ARGUMENTS: [PR number, optional — infer from the current branch if omitted]
