---
name: peer-review
description: Reconcile a PR's real review comments from Codex and/or /code-review ultra — verify each finding against the code before acting, don't accept them at face value. Use after a PR has actual review comments to process, not routinely.
argument-hint: "[PR number]"
---

# Peer Review Reconciliation

**Opt-in, not routine.** Same bar as before: non-trivial architecture, security-sensitive code, something you're unsure about. `/code-review` (native) is enough for most sessions.

This skill reconciles **real PR comments** — from Codex and/or `/code-review ultra` (run with `--comment`) — not feedback pasted in manually.

Codex's "on PR open" auto-trigger isn't reliable — it can silently not fire. The `dev-workflow` skill has commenting `@codex review` right after opening the PR as its own step, always. **Once tagged, Codex reliably answers**, typically within a few minutes — the unreliability is in the auto-trigger, not in Codex.

`dev-workflow` also has arming `.claude/scripts/wait-for-codex.sh <PR>` as a Monitor immediately after the tag, so this skill normally runs *because* the watch fired — not on a guess about whether Codex is done. If it's being run without that, confirm the `@codex review` comment actually exists before concluding anything.

## What to do

1. Identify the PR for the current branch. If ambiguous, ask — or take a PR number as an argument.
2. Fetch what Codex posted. **Check all three surfaces** — which one it uses depends on the outcome:
   - **Found nothing** → a plain **issue comment** ("Codex Review: Didn't find any major issues"), and *no review at all*: `gh api repos/{owner}/{repo}/issues/<PR>/comments`
   - **Found something** → a **review** plus **inline comments** on the diff, and *no issue comment*: `mcp__github__get_pull_request_reviews` / `get_pull_request_comments`

   This is why an empty result is ambiguous and must not be read as "nobody reviewed": querying only the review endpoints comes back empty on every clean review, which is the common case. Filter to `chatgpt-codex-connector[bot]`, and to comments newer than the `@codex review` tag: after a follow-up push, an older answer refers to a commit that no longer exists. Ignore plain discussion replies — only findings.
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
