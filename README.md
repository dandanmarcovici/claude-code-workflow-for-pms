# claude-code-workflow-for-pms

*A structured, end-to-end development workflow for building real software with Claude Code — as a non-developer PM.*

## What this is

This is the actual process I use to design, build, review, and ship features in a production app, running Claude Code as the primary driver. I'm a PM, not a developer — everything here exists so that rigor and quality checks happen automatically, without me having to read code or catch mistakes myself.

It's not a theory. It's extracted directly from a real, live project — a Next.js app I've been building end-to-end through Claude Code sessions, iterated and corrected repeatedly as things broke, turned out to be overkill, or just never got used.

## What's inside

- **`WORKFLOW.md`** — the process itself: the full sequence (explore → design → plan → build → review → ship), when each step runs and when it's skippable, and the reasoning behind each decision.
- **`.claude/commands/`** — 8 slash commands that implement the workflow:
  - `/explore` — understand before building, surface ambiguity
  - `/design-brief` — bootstrap visual direction (once per product, not per screen)
  - `/visual-explore` — iterate on UI in Claude Design before writing code
  - `/create-plan` — persist an approved Plan Mode session to a plan file
  - `/execute` — implement the plan
  - `/peer-review` — reconcile real PR review comments (Codex, `/code-review ultra`)
  - `/product-sense` — a 5-question stress test for product decisions before you commit to them
  - `/create-issue` — fast capture of a bug/idea mid-flow to your backlog

## Tools this assumes

- **Claude Code** — the whole thing runs through it. Plan Mode, `/code-review`, `/code-review ultra`, and the `design` skill (Claude Design) are all native — nothing to install.
- **GitHub** — for PRs, and for Codex's automated review (`@codex review` as a PR comment). If you don't use Codex, drop that step and lean on `/code-review` + `/code-review ultra` instead.

That's it. No paid plugins, no separate design tool license.

## How to use it

1. Copy `WORKFLOW.md` and `.claude/commands/` into the root of your project.
2. Read the "Adapting this to your project" section in `WORKFLOW.md` — a few things (where your backlog lives, whether you use Codex) need pointing at your own setup.
3. Start a session with `/explore` on your first feature.

No install step beyond that — Claude Code picks up `.claude/commands/` automatically.

## The core lessons, if you read nothing else

- **Prefer Claude Code's native features over hand-rolled prompts.** A custom "plan" command lost to native Plan Mode. A custom "review" command lost to native `/code-review`. Check before you build.
- **Don't build process artifacts nobody reads.** A changelog, a progress-percentage checklist on plan files — both got cut here because nobody, including me, ever read them live. If a doc doesn't have a real reader, it's ceremony.
- **Automated review triggers aren't reliable — verify, don't hope.** GitHub's "review on PR open" integrations can silently not fire. Make the trigger an explicit step instead of an assumption.
- **A design system is a bootstrap step, not a per-screen ritual.** Run the discovery session once; extend it incrementally afterward.
- **Match review effort to change size.** Defaulting every review to maximum effort is expensive and, past a point, buries real findings in noise.

## Companion repos

- [`pm-second-brain`](https://github.com/dandanmarcovici/pm-second-brain) — the context system this workflow's product decisions live inside.
- [`claude-skills-for-pms`](https://github.com/dandanmarcovici/claude-skills-for-pms) — general-purpose PM skills, frameworks, and templates. This repo is the dev-specific counterpart.

## License

MIT

---

Daniel Marcovici, PM.
