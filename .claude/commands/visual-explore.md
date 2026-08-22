# Visual Explore

You are starting a visual exploration session in Claude Design (the `design` skill) before any code is written. Your goal is to validate layout, structure, and component decisions visually — and extract a `ui-spec-[feature].md` that will serve as input for `/create-plan` and `/execute`.

**When this command is used:**
- Any feature with a new screen or structural layout change
- When the user needs to see and iterate on UI before committing to code
- Skip for logic-only features, bug fixes, or minor visual adjustments

---

## Step 1 — Load context

Before touching the canvas:

1. Read `docs/design-guidelines.md` — this is the visual contract. You must follow it strictly.
2. Ask the user: **which feature or screen is this session for?**
3. Ask if there are additional files to load (data model, user journey, existing components, reference screenshots). Read whatever the user points to.
4. Ask: **what specific concerns do you have about this UI?** (layout scalability, states, interactions, open questions). This shapes what you explore.

Do not invoke the `design` skill until you have this context.

---

## Step 2 — Create initial artboards

Invoke the `design` skill (equivalent to running `/design`) and follow its workflow directly:

1. Author each screen as a `.dc.html` working file, named as the artboard (`Main.dc.html` for the entry screen, plus siblings for other states/screens). Keep these working files in a dedicated folder under `docs/design/[feature-name]/` — they are the source of truth for every later revision.
2. Build the default / happy path state first. Announce what you're building before you build it.
3. Use exact values from `design-guidelines.md` — typography, colors, spacing, component patterns.
4. Seed the payload with the skill's `seed-canvas.mjs` helper, run `--check`, then publish via the `Artifact` tool. Share the published link and describe what you built. Wait for user feedback before iterating.

---

## Step 3 — Iterate

This is a dialogue loop. The user is the architect — you execute.

- For direct instructions ("change this", "move that", "use this color"): edit the working `.dc.html` files, re-seed, re-check, and republish to the *same* artifact path (keeps the same URL) immediately. Don't explain before doing.
- For decisions that involve UX tradeoffs, business rules, or layout choices with non-obvious consequences: pause, surface the options briefly, and align before acting. Examples: two valid ways to represent a data model, a layout choice that affects a future state, a pattern that conflicts with how the engine works.
- After each meaningful change, describe what changed and republish. Let the user see and react on the live link.
- If a direction conflicts with `design-guidelines.md`, flag it briefly and ask how to proceed. Don't override silently.
- If a color/token choice is genuinely new (not yet in `design-guidelines.md`), track it — it gets promoted to the guidelines in Step 6 below, or during `/execute` if it only becomes clear once coding starts.
- Keep iterating until the user signals the structure is good.

---

## Step 4 — Validate states

Before extracting the spec, explicitly explore:

- **Empty state** — what does the screen look like with no data?
- **Status/attention states** — if the screen has flags or badges (e.g., "needs attention", "paused"), show each as its own artboard or a clearly labeled section
- **Error or conflict states** — if applicable to this feature
- **Scalability check** — show a version with more content than typical (e.g., long names, many items, a full list)

Add separate artboards (or clearly labeled sections within one) for each state that matters. Ask the user which states to explore — don't assume.

---

## Step 5 — Define scope boundary

Before writing the spec, confirm with the user:

- What is explicitly **in scope** for this build?
- What did we explore that is **out of scope** for now?

This prevents scope creep in `/execute` and makes the plan file more precise.

---

## Step 6 — Extract `ui-spec-[feature].md`

Save to `plans/ui-spec-[feature-name].md` using this structure:

```markdown
# UI Spec — [Feature Name]

> Generated from Claude Design iterations (session on [date]).
> Working artboards in `docs/design/[feature-name]/`. Published link: [artifact URL].
> Input for `/execute`. [Note any explicit out-of-scope items.]

---

## 1. Screen structure
ASCII wireframe of the main layout.

## 2. Information model
Key decisions about what data is shown, how it's labeled, and why.
Include any data model decisions that emerged from seeing the UI.

## 3. Component anatomy
For each main component: element-by-element spec with exact values
(font size, weight, color hex, padding, border-radius, etc.)

## 4. States
For each state: what changes visually (background, text color, sizing, labels).
Only document states that were explicitly explored and validated.

## 5. Real data / template
If applicable: the actual content that populates this screen (not lorem ipsum).

## 6. Color / token extensions
Any new tokens added in this session that extend design-guidelines.md.

## 7. Out of scope (next session)
Bulleted list of what was seen but deliberately left for later.
```

Use exact values throughout — no approximations. If a value wasn't defined during iteration, use the closest token from `design-guidelines.md` and note it as a default.

---

## Wrap-up

After saving the file:

1. Confirm the file path to the user: `plans/ui-spec-[feature-name].md`
2. List any divergences from `design-guidelines.md` found during this session (values that need to be reconciled)
3. Remind the user: run `/create-plan` next — the plan should reference this spec file
