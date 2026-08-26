---
name: create-issue
description: Quickly capture a bug, feature idea, or improvement to the project's backlog/tracker while mid-development. Use when the user mentions an idea or issue in passing while working on something else, without breaking their flow.
---

# Create Issue

User is mid-development and thought of a bug, feature, or improvement. Capture it fast so they can keep working.

**Where it goes:** check this project's `CLAUDE.md` for where the backlog/tracker lives — a markdown file in this repo, a doc in a sibling repo, Linear, Notion, whatever. If it's not documented there, ask the user once, then note it as something worth adding to `CLAUDE.md` so this doesn't need asking again. Append to the tracker's tickets/backlog section; don't restructure the rest of the doc.

## Goal

Add an entry with:
- Clear title
- TL;DR of what this is about
- Current state vs expected outcome
- Relevant files that need touching (this repo's paths)
- Risk/notes if applicable
- Type (bug / feature / improvement) and rough priority

## How to Get There

**Ask brief questions** to fill gaps — respect that the user is mid-flow.
Usually need:
- What's the issue or feature
- Current behavior vs desired behavior
- Type and priority if not obvious

Keep it to one message with 2–3 targeted questions max. Total exchange under 2 minutes.

**Search for context** only when helpful:
- Grep codebase to find relevant files
- Note any risks or dependencies

**Skip what's obvious** — if type and priority are clear, don't ask.

## Rules

- Conversational, not a checklist
- Default: priority normal, effort medium
- Max 3 files in context — most relevant only
- Bullet points over paragraphs
- Confirm the entry was appended and where, in one line — don't narrate the edit
