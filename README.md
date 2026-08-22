# claude-code-workflow-for-pms

*A structured, end-to-end development workflow for building real software with Claude Code, run by a non-developer PM.*

## What this is

This is the actual process I use to design, build, review, and ship features in a production app, running Claude Code as the primary driver. I'm a PM, not a developer, so everything here exists to catch mistakes automatically, without me having to read code or catch them myself.

It's extracted directly from a real, live project: a Next.js app I've been building end-to-end through Claude Code sessions, iterated and corrected repeatedly as things broke, turned out to be overkill, or just never got used.

## The flow

```
/explore
    ↓
/visual-explore     (UI features only)
    ↓
Plan Mode           (native, the real due-diligence step)
    ↓
/create-plan
    ↓
/execute
    ↓
/code-review        (native, every session before pushing)
    ↓
push, open PR
    ↓
@codex review       (comment, every time)
    ↓
/peer-review        (optional, reconciles findings before merging)
    ↓
merge
```

Full sequence, including the one-time design-brief bootstrap and the optional deep-review escalation, is in `WORKFLOW.md`.

## What's inside

- **`WORKFLOW.md`**: the process itself. The full sequence (explore → design → plan → build → review → ship), when each step runs and when it's skippable, and the reasoning behind each decision.
- **`.claude/commands/`**: 8 slash commands that implement the workflow.
  - `/explore`: understand before building, surface ambiguity
  - `/design-brief`: bootstrap visual direction (once per product, not per screen)
  - `/visual-explore`: iterate on UI in Claude Design before writing code
  - `/create-plan`: persist an approved Plan Mode session to a plan file
  - `/execute`: implement the plan
  - `/peer-review`: reconcile real PR review comments (Codex, `/code-review ultra`)
  - `/product-sense`: a 5-question stress test for product decisions before you commit to them
  - `/create-issue`: fast capture of a bug/idea mid-flow to your backlog

## Requirements

- **Claude Code**, on at least a Claude Pro plan ($20/month) or API credits. It's not included in Claude's free tier. Plan Mode, `/code-review`, `/code-review ultra`, and the `design` skill (Claude Design) all come with it, nothing extra to install.
- **A GitHub repo**, for PRs and for connecting Codex.
- **Codex**, on at least a ChatGPT Plus plan, if you want the `@codex review` step. Codex's free tier gives limited local access but excludes cloud-based GitHub code review, which is exactly what that step relies on. Comment `@codex review` on a PR without it, and nothing happens.

No Codex, no Plus plan? Drop that step. `/code-review` and `/code-review ultra` still cover you, see "Adapting this to your project" in `WORKFLOW.md`.

## Setup

1. Copy `WORKFLOW.md` and `.claude/commands/` into the root of your project.
2. Read "Adapting this to your project" in `WORKFLOW.md`. A few things (where your backlog lives, whether you use Codex) need pointing at your own setup.
3. Start a session with `/explore` on your first feature.

That's the whole install. Claude Code picks up `.claude/commands/` automatically, no build step, no package.

## The core lessons, if you read nothing else

- **Prefer Claude Code's native features over hand-rolled prompts.** A custom "plan" command and a custom "review" command both lost out to what's already native: Plan Mode and `/code-review`. Check before you build.
- **Don't build process artifacts nobody reads.** A changelog, a progress-percentage checklist on plan files: both got cut here because nobody, including me, ever read them live. A doc with no real reader is ceremony, not documentation.
- **Automated review triggers aren't reliable: verify, don't hope.** GitHub's "review on PR open" integrations can silently not fire. Make the trigger an explicit step instead of an assumption.
- **A design system is a bootstrap step, not a per-screen ritual.** Run the discovery session once, then extend it incrementally.
- **Match review effort to change size.** Defaulting every review to maximum effort is expensive and, past a point, buries the real findings in noise.

## Companion repos

- [`pm-second-brain`](https://github.com/dandanmarcovici/pm-second-brain): the context system this workflow's product decisions live inside.
- [`claude-skills-for-pms`](https://github.com/dandanmarcovici/claude-skills-for-pms): general-purpose PM skills, frameworks, and templates. This repo is the dev-specific counterpart.

## License

MIT

---

Daniel Marcovici, PM.
