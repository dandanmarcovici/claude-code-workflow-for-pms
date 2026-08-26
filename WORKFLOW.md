# Development Workflow

Quick reference for feature development with Claude Code as the primary driver, Codex as an automated PR reviewer, and Claude Design for UI exploration before code is written.

This is extracted from a real, live project — the commands and rules below reflect actual decisions made (and reversed) while building it, not a theoretical ideal.

---

## The Sequence

```
NO design-guidelines.md YET (new product / new UI foundation) — rare, not per-epic
      ↓
  /design-brief     ← define visual direction, produce design-guidelines.md
      ↓
NEW FEATURE / BUG
      ↓
  /explore          ← understand before building
      ↓
  /visual-explore   ← (UI features only) iterate in Claude Design before coding
      ↓               produces plans/ui-spec-[feature].md
  Plan Mode         ← Claude enters Plan Mode itself (EnterPlanMode), explores the
      ↓               code, reasons through the approach and trade-offs, presents
      ↓               it for approval (ExitPlanMode) — this is where due diligence
      ↓               actually happens, not in /create-plan
  /create-plan      ← persists the already-approved plan to plans/[feature].md
      ↓               (plain text, no status tracking — see Rules)
  git: branch out   ← feature/short-name, from main
      ↓
  /execute          ← implement the plan (loads design-guidelines.md + ui-spec if exists)
      ↓
  /code-review      ← native, local, free — Claude reviews its own diff
      ↓               effort: low (1 file/small diff) → medium (multi-file, new pattern)
      ↓               → high/max (architecture, security-sensitive, schema changes).
      ↓               Default to low, don't let it silently default to high.
  git: push → PR    ← opened via GitHub, targets main
      ↓
  comment "@codex review" on the PR   ← always, immediately — GitHub's auto-trigger on PR
      ↓                                 open isn't reliable in practice, don't wait/hope for it
      ↓
  arm the Codex watch  ← Monitor + .claude/scripts/wait-for-codex.sh <PR>
      ↓                Claude gets pinged the moment Codex answers (~3min) instead
      ↓                of anyone refreshing the PR page. Silent until then, and it
      ↓                always ends by saying something — answer or deadline.
      ↓
  [optional, complex or risky changes only]
      ↓
  /code-review ultra   ← cloud multi-agent fleet, deeper pass on the branch/PR
      ↓
  /peer-review      ← reconciles the PR's real comments (Codex + /code-review ultra)
   merge → main
```

Not every step runs every time. `/design-brief` only when there's no `design-guidelines.md` yet or the direction is changing. `/visual-explore` only for new screens or structural layout changes — skip for logic-only features, bug fixes, or minor visual tweaks. Plan Mode is skipped only for the same bar — small, self-contained fixes; everything else gets it by default (see Rules). `/code-review` runs every session after `/execute` — it's free and local, no reason to skip it. The `@codex review` comment runs every time too — it's free, and only guarantees the review exists, not that anyone reads it deeply. `/code-review ultra` and `/peer-review` only run when a change is complex or risky enough to warrant a second opinion beyond your own review.

---

## When to Use Each Command

| Command | When | What it does |
|---|---|---|
| `/design-brief` | Bootstrap only — `docs/design-guidelines.md` doesn't exist yet, or a deliberate direction change | Discovery session: references → aesthetic direction → produces `docs/design-guidelines.md`. New screens/tokens extend the file incrementally via `/visual-explore` and `/execute` instead of re-running this. |
| `/explore` | Before writing any code | Reads codebase, asks clarifying questions, surfaces ambiguities |
| `/visual-explore` | After `/explore`, for UI features with new screens or structural layout changes | Iterates on artboards in Claude Design → produces `plans/ui-spec-[feature].md` |
| Plan Mode (native) | After `/explore` (and `/visual-explore` if applicable), for anything beyond a small self-contained fix | Claude explores the code, reasons about architecture/trade-offs, and presents a plan for approval before writing any code — this is the actual due-diligence step |
| `/create-plan` | After Plan Mode is approved | Persists the approved plan verbatim to `plans/[feature-name].md` for cross-session continuity — plain text, no status tracking (see Rules) |
| `/execute` | After plan is approved | Implements step by step; loads `design-guidelines.md` + `ui-spec` if exists + the `frontend-design` skill |
| `frontend-design` (skill) | Applied automatically during `/execute` for UI | Enforces aesthetic guidelines: typography, color, motion, layout — avoids generic AI defaults. Anthropic's official skill — see [anthropics/skills](https://github.com/anthropics/skills/tree/main/skills/frontend-design). |
| `/code-review` (native) | After `/execute`, every session | Free, local — reviews the branch's diff, structured findings at effort `low`→`max`. `--comment` posts inline on an open PR, `--fix` applies fixes directly. **Pass effort explicitly** — see "Choosing `/code-review` effort" below; don't let it default to `high`. |
| `@codex review` (PR comment) | Always, immediately after opening the PR | Manually triggers Codex's GitHub review. Its "on PR open" auto-trigger isn't reliable — don't depend on it firing by itself. |
| Codex watch (Monitor) | Right after the `@codex review` comment | Runs `.claude/scripts/wait-for-codex.sh <PR>` as a background Monitor. Polls the PR every 60s and notifies Claude the moment Codex answers, so nobody sits refreshing GitHub. Emits nothing while waiting; after 15min with no answer it says so rather than going quiet. Codex usually answers in about three minutes. |
| `/code-review ultra` (native) | Opt-in, complex or risky changes only, before merging | Uploads the branch/PR to a cloud sandbox; a fleet of specialist agents (security, correctness, architecture, perf, tests) cross-verify findings. Costs usage credits. |
| `/peer-review` | Opt-in, after a PR has real comments to reconcile | Reads the PR's actual comments (from Codex and/or `/code-review ultra`) via GitHub, verifies each against the code, decides what's worth fixing. |
| `/product-sense` | Before a significant product decision | 5-question stress-test (empathy, simulation, strategy, taste, creativity) — Go / Reconsider / Stop verdict |
| `/create-issue` | Mid-development, idea or bug surfaces | Captures fast to your backlog — point it at wherever that lives (see "Adapting this to your project") |

---

## Choosing `/code-review` effort

Pass effort explicitly — don't let it silently default to `high`:

- **`low`** — single component/file, isolated bug fix, small CSS/copy change.
- **`medium`** — multi-file feature, a pattern reused across components, first use of a new hook/abstraction.
- **`high`/`max`** — architecture changes, security-sensitive code (auth, payments, permissions), data model/schema changes, or anything touching multiple modules at once.

Default to `low` unless the change clearly crosses into `medium`/`high`. Running `high` on a one-file CSS tweak wastes time and buries the real findings in noise.

---

## Adapting this to your project

This workflow was built and iterated on inside a real production codebase — a solo, non-developer PM running the whole dev process through Claude Code. A few things to point at your own setup before it works out of the box:

- **`docs/design-guidelines.md`** — created automatically the first time you run `/design-brief`. Nothing to set up in advance.
- **Your backlog/tracker** — `/create-issue` needs a target. Edit `.claude/commands/create-issue.md` to point at wherever your backlog actually lives — a markdown file in-repo, Linear, Notion, whatever.
- **Codex + GitHub** — `@codex review` assumes Codex's GitHub app is connected to your repo, and needs at least a ChatGPT Plus plan (the free tier excludes GitHub PR review). If you don't use Codex, drop that step from the sequence and rely on `/code-review` + `/code-review ultra` instead.
- **Claude Design** — `/visual-explore` invokes the bundled `design` skill (Claude Design's editor running inside a published Artifact). Ships with Claude Code — nothing to install.
- **`frontend-design` skill** — used automatically during `/execute` for UI work. Anthropic's official skill, not duplicated in this repo — see [anthropics/skills](https://github.com/anthropics/skills/tree/main/skills/frontend-design).

---

## Git — Session Habit

**End of every session** (code or docs changed):
```bash
git add .
git commit -m "short description of what changed"
git push
```

**Start of session** (if working across machines):
```bash
git pull
```

Claude can run these commands for you — just ask. The important thing is not forgetting to push at the end.

---

## Git Workflow (per feature)

```
1. Note the feature/fix in your backlog if not already there
2. Create branch from main: feature/short-name
3. Work on branch using the command sequence above
4. /code-review before pushing — every time, it's free (pick effort by change size — see "Choosing /code-review effort")
5. Push, open PR (even solo — build the habit)
6. Comment "@codex review" on the PR immediately — always, don't rely on auto-trigger
7. Arm the Codex watch: Monitor running .claude/scripts/wait-for-codex.sh <PR>
8. If complex/risky: /code-review ultra
9. /peer-review when the watch fires, to reconcile what Codex posted
10. Merge to main
11. Delete branch
```

---

## Rules

- **Act as senior engineer / lead, not just an implementer.** If your product owner isn't a developer, they're relying on Claude to catch scalable/systemic fixes without being asked. When a bug or request has an obvious cross-cutting solution (e.g., a global CSS rule vs. repeating a class on every element; a shared helper vs. copy-pasted logic), default to that solution — or at minimum, surface it as the recommended option before implementing the narrow fix. Don't silently pattern-match to the one existing example in the codebase and assume that's "the convention" without asking whether it's actually the right one. If in doubt whether something is a one-off vs. a systemic decision, treat it as systemic.
- **Never code before exploring.** `/explore` first, always.
- **Never build UI without `docs/design-guidelines.md` existing.** Run `/design-brief` to bootstrap it — but only as a bootstrap or for a deliberate direction change, not per-epic or per-screen. Once it exists, `/visual-explore` and `/execute` extend it incrementally.
- **Run `/visual-explore` before implementing new screens or structural layout changes.** Skip only for logic-only features, bug fixes, or minor visual adjustments.
- **Default to Plan Mode after exploring, for anything beyond a small self-contained fix.** Claude enters Plan Mode itself (`EnterPlanMode`) rather than waiting to be asked, explores the code, and presents the approach — with trade-offs and the "why" behind each decision — for approval via `ExitPlanMode` before writing code. A non-developer product owner typically doesn't watch execution live or reopen a plan file afterward, so a checklist artifact nobody rereads is worthless — the reasoning has to actually surface in the conversation instead. Skip only for the same bar as `/visual-explore`: small, self-contained bug fixes or cosmetic tweaks. If you're not a developer, err toward more rigor, not less — time and tokens aren't the constraint, product quality is.
- **Never accept code blindly.** Run `/code-review` (native) every time before pushing — it's free and local, no reason to skip it. Pick effort by change size (see "Choosing `/code-review` effort") — don't let it default to `high`. Comment `@codex review` on every PR immediately after opening it — the GitHub app's auto-trigger isn't reliable; don't wait and hope it fires. For complex or risky changes, escalate to `/code-review ultra`, then `/peer-review` to reconcile whatever Codex and/or ultra posted.
- **Prefer a native Claude Code command/skill over a hand-rolled one.** Before building a custom slash command for a workflow step (planning, review, etc.), check whether Claude Code already has one — it's maintained, tested at scale, and usually does the job better than something copied from a blog post or another PM's setup. Plan Mode replacing a custom "plan" command, and `/code-review` replacing a custom "review" command, are both instances of this in the commands here. If in doubt, ask/search before building.
- **No changelog file, no automated "update docs" step.** If you're using proper PR review, `git log` and PR history already give more detail than a changelog ever will — and unless someone is actually reading it live, it's ceremony, not documentation. Don't recreate this without a real, currently-unmet reader.
- **When AI makes a mistake:** ask "what in your instructions made you make this mistake?" → fix the source (`CLAUDE.md` or the command prompt), not just the immediate output.
- **When context gets too long:** start a fresh session, reference the plan file.
- **Models by task:** Claude → logic, architecture, planning, UI. Codex → gnarly bugs, opt-in second opinion — connect it to your repo via GitHub so it reviews PRs in place, no manual copy-paste.

---

## Files Reference

| File | Purpose |
|---|---|
| `CLAUDE.md` | System prompt — loaded in every session (not included here — write your own; see [`pm-second-brain`](https://github.com/dandanmarcovici/pm-second-brain) for a starting structure) |
| `WORKFLOW.md` | This file — development process reference |
| `docs/design-guidelines.md` | Visual contract — read by `/execute` before any UI task (created by `/design-brief`) |
| `.claude/commands/` | All slash commands in this repo |
| `.claude/skills/frontend-design/` | Anthropic's official frontend design skill — not duplicated here, see [anthropics/skills](https://github.com/anthropics/skills/tree/main/skills/frontend-design) |
| `.claude/scripts/wait-for-codex.sh` | Polls a PR for Codex's answer; run as a Monitor so Claude is notified instead of anyone having to check |
| `plans/` | Plan Mode output, persisted per feature (plain reasoning, no status tracking) + ui-specs |
| `docs/design/[feature]/` | Working `.dc.html` source files for Claude Design canvases |
