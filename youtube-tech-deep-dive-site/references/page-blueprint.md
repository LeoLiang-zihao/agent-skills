# Page Blueprint

Use this as a default shape for transcript-backed HTML study sites. Keep or drop sections based on the source material; do not force every page to use all blocks.

## Recommended order

1. **Hero**
   - Video/topic title
   - One-sentence thesis
   - Source link
   - 3-5 ultra-short “what this page teaches” chips

2. **Executive Overview**
   - What changed
   - Why this matters
   - One paragraph on the speaker's overall engineering posture

3. **Interactive Breakdown**
   - For stack videos: per layer (`client`, `DB`, `auth`, `payments`, etc.)
   - For architecture videos: per subsystem or decision area
   - Each item should answer:
     - What is the pick?
     - Why this pick?
     - When does it apply?
     - What is the cost or tradeoff?

4. **Migration / Before vs After**
   - Useful when the speaker contrasts an old workflow with a new one
   - Show what complexity got removed, not just what product got swapped

5. **Timestamped Timeline**
   - Re-entry points for rewatching
   - Each chapter should explain why the segment matters

6. **Underlying Principles**
   - Distill the speaker's decision framework into reusable rules
   - These are often more valuable than the named tools

7. **Skeptical Reading**
   - Where the advice is workload-specific
   - Where sponsorship, team size, or bias may shape the recommendation
   - Where the speaker leaves clear uncertainty

8. **Scenario Mapping**
   - “If you are building X, take Y from this”
   - “If your constraints are different, do not copy this literally”

9. **Study Path / Quiz**
   - Short prompts or collapsible cards
   - Best for helping the user revisit the page later without re-reading everything

## Page behavior

- Prefer a standalone single-file HTML deliverable by default.
- Use anchor navigation for longer pages.
- Interactive sections should be lightweight and inspectable.
- Default to responsive layout; do not assume desktop only.

## Tone rules

- Write like an engineering editor, not a hype account.
- Be specific where the transcript is specific.
- Mark inference as inference.
- Keep conclusions sharper than the transcript, but not less honest than it.
