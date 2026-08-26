---
name: design-brief
description: Discovery session that defines a project's visual/design direction and produces docs/design-guidelines.md. Use once per product or UI foundation, or for a deliberate direction change — not per feature or per screen.
---

# Design Brief

You are starting a design discovery session. Your goal is to produce or update `docs/design-guidelines.md` with concrete, actionable visual direction.

**When to run this skill:**
- **Bootstrap** — `docs/design-guidelines.md` doesn't exist yet for this product/module. Not per-epic, not per-screen — once a foundation exists, it grows incrementally (see below).
- **Deliberate direction change** — a rebrand, or a screen so unlike anything the current guidelines cover that they genuinely don't answer the question. Rare, and a judgment call — not triggered automatically by "new screen."

A new screen or a new token on its own is **not** a reason to re-run this. `visual-explore` promotes new color/token decisions into `docs/design-guidelines.md` as part of its own Step 6, and `execute` promotes anything that surfaces mid-implementation — both incrementally extend the same file without reopening a full discovery session.

---

## Step 1 — Understand the context

Ask the user:

1. **Which screen or epic is this brief for?** (e.g., Dashboard, Onboarding, Settings)
2. **Who uses it and in what context?** (e.g., an ops team on a desktop during work hours, a customer on their phone on the go)
3. **Does the user have visual references?** Apps, sites, screenshots — anything with the right feel. Doesn't need to be from the same domain.
4. **Are there technical constraints?** (e.g., must work offline, must be accessible, fixed color palette)

Do not proceed to Step 2 without these answers. If the user has no references yet, suggest exploring the direction directly in Claude Design (`/design`) — mock a couple of quick static directions and pick from there rather than deciding blind.

---

## Step 2 — Analyze references

For each reference the user provides (link, screenshot, or description):

- Identify structural patterns: typography, spacing, information hierarchy, density
- Identify what specifically the user likes — don't assume, ask if unclear
- Extract concrete values where possible: font sizes, spacing, approximate colors

If the user provides a link, use WebFetch to scan the visual structure of the page.

---

## Step 3 — Define direction

Based on references and context, propose a clear aesthetic direction:

- **Tone**: one word or phrase that captures the essence (e.g., "functional minimalism", "clean with weight")
- **Typography**: primary font family + secondary (avoid Inter, Roboto, Arial — see the `frontend-design` skill for why)
- **Palette**: background, primary, accent, text — with hex values when possible
- **Layout pattern**: how information is organized (e.g., card-based, list-heavy, full-bleed)
- **Motion**: whether animations exist and what role they play (e.g., only action feedback, no decoration)
- **What to avoid**: specific generic patterns for this project

Present the direction to the user and wait for approval before writing the file.

---

## Step 4 — Write or update `docs/design-guidelines.md`

After user approval, create or update `docs/design-guidelines.md` with:

```markdown
# Design Guidelines — [Project Name]

## Aesthetic direction
[One sentence capturing the tone]

## Usage context
[Who uses it, how, when — to anchor future decisions]

## Typography
- Display: [font + use]
- Body: [font + use]
- Avoid: [banned fonts]

## Color palette
- Background: [hex]
- Primary: [hex]
- Accent: [hex]
- Text: [hex]
- [others if needed]

## Layout and spacing
[Grid patterns, density, spacing between elements]

## Components
[Patterns for cards, buttons, inputs, states — with specific descriptions]

## Motion
[When to use animation, when not to, concrete examples]

## What to avoid
[List of generic patterns or wrong choices for this project]

## References
[Links or descriptions of references that validated this direction]
```

---

## Wrap-up

After writing the file, confirm with the user:
- The file was created/updated at `docs/design-guidelines.md`
- The product/module now has clear visual direction to build against
- Remind the user that `execute` will load this file automatically for UI tasks
