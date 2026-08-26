---
name: execute
description: Implement an approved plan precisely, in full — loading design guidelines and the ui-spec when UI is involved. Use after Plan Mode has produced an approved plan, to start writing code.
---

# Execute Plan

Now implement precisely as planned, in full.

## Before writing any code

If the current task involves UI components or pages:
1. Read `docs/design-guidelines.md` — this is the visual contract for the project. Follow it strictly.
2. Check if a `plans/ui-spec-[feature].md` exists for this feature. If it does, read it and treat it as the authoritative source for this screen's layout, component anatomy, states, and values. Where ui-spec and design-guidelines conflict, ui-spec wins — it was validated visually and is more specific.
3. Apply the `frontend-design` skill principles when making any aesthetic decision not already covered by the above files.
4. If `docs/design-guidelines.md` does not exist, stop and ask the user to run `design-brief` first.
5. If the feature has significant UI and no ui-spec exists, flag it to the user — they may want to run `visual-explore` before proceeding.

## Implementation Requirements

- Write elegant, minimal, modular code.
- Adhere strictly to existing code patterns, conventions, and best practices already established in this codebase.
- Include clear comments within the code where logic is non-obvious.
- Do not add scope beyond what the plan describes. If you spot something worth adding, note it but do not implement it.
- If implementation surfaces a genuinely new color/token or component pattern not yet in `docs/design-guidelines.md`, promote it there directly once confirmed working — don't leave it undocumented for a later cleanup pass that may never happen.
