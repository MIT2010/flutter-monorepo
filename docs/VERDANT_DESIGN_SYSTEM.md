# Verdant — Design System Specification v1.3

*Chief Design Officer's specification. This document is the source of truth for Verdant's visual identity.*

**Status: APPROVED as the new default visual identity for flutter_starter_kit**, superseding `docs/DESIGN_LANGUAGE.md` (archived, not deleted — see that file's own banner). All five §13 open decisions were resolved: `AppExpressiveCard`'s shape-morph/spring was retired in favor of a hairline border-shift-on-press redesign (§5.4); Plus Jakarta Sans retained; `DESIGN_LANGUAGE.md` archived as historical record; rollout scope is tokens (Tahap 1) + 6 detailed components (Tahap 2) + `AppExpressiveCard` (Tahap 3) first; the remaining component list stays build-on-demand, not built ahead of real need. **Tahap 1, 2, and 3 are all implemented, golden-verified, and CI-green as of this revision.**

**v1.1 revision note**: a systematic comparison against the original brief found this document under-covered two things the brief explicitly required — full Purpose/Shape/Depth/Motion/State specification for every named component (not just the 6 built in Tahap 2), and full treatment of every named Visual DNA/token category. That revision closed the gap **as specification only** — §10.7 onward, the expanded §4/§8 subsections, and the §9 token decisions are documentation, not implementation. The staged, build-on-demand code discipline established in §13 point 5 is unchanged: having a full spec for, say, a Calendar/Date Picker does not mean one gets built before a real screen needs it.

**v1.2 revision note**: a second full read caught what v1.1 missed — every reference to "Section 3's scale" for type (§8.3, former §10.1) pointed at Color, not Typography, because **no Typography section existed at all**, despite the brief naming type a primary design element on equal footing with color. §14 (appended at the end, same renumbering-avoidance reasoning as §10.7 onward) now covers the full 15-slot type scale pulled from the real, already-implemented `AppTheme._baseTextTheme` (not invented fresh), the checkable reasoning behind each brand-overridden slot, and an explicit answer on `MediaQuery.textScaler` interaction — including one honest, unverified gap (200% text-scaling hasn't actually been tested against the six implemented components yet). Also closes two smaller optional items: §12.1 (a consolidated non-framework anti-pattern checklist) and §14.4's explicit "no" on a separate Border token scale, both decided the same documented-reasoning way as §9's Opacity/Interaction/Focus/Responsive calls.

**v1.3 revision note**: closes v1.2's one self-acknowledged gap — §14.3 now reports a real, executed 200% `textScaler` verification (`test/accessibility/text_scaling_test.dart`) instead of an unverified claim. Five of the six Tahap 2 components passed outright; `AppNavigationBar` genuinely overflowed under a realistic-but-narrower adversarial case (four longer destination labels on a small-phone width) and has been fixed (fixed `SizedBox` height replaced with a `ConstrainedBox` minimum), golden-reverified, and is now guarded by a permanent regression test. This is code + test work, not documentation-only like v1.1/v1.2 — flagged here since this document's own status line otherwise implies everything below it is settled prose.

## 0.1 Token-cheap vs. code-required — the boundary a downstream project needs

Before any implementation: a future project built from this kit needs to know, without guessing, which Verdant changes are a **retheme** (adjust a value, zero widget code touched, safe to do live in Theme Studio) versus a **redesign** (requires editing a specific widget's build method, because the behavior itself — not just its color/size — is part of the identity).

**Cheap to retheme — token values only, zero code changes, live-previewable in Theme Studio:**
- Any hex in `VerdantColors` (Stone/Moss/Ember/Brass/Mist) — swap the palette, every component that reads `context.semanticColors`/`Theme.of(context).colorScheme` picks it up automatically.
- Any value in `AppSpacingExtension` (§4) — the whole point of `context.spacing.md` replacing hardcoded `EdgeInsets.all(16)` was exactly this: one number, cascades everywhere.
- Any value in `AppShapeExtension`'s `radiusNone`/`radiusXs`/`radiusSm`/`radiusMd`/`radiusPill` (§5) — same cascade, as long as the *rule* of which component uses which tier (§5.1–5.3) doesn't change.
- Any duration in `AppMotionExtension` (§7's `durationMicro`/`Standard`/`Panel`/`Page`) — timing is pure config.
- `AppTheme.light()`/`.dark()`'s `primaryColor`/`spacingMultiplier`/`radiusMultiplier`/`motionSpeedMultiplier` parameters — this is *precisely* what Theme Studio exercises live, with zero code deploy.

**Requires editing a specific widget — behavior, not just value, is the identity:**
- `TextField`'s static (never-floating) label placement (§10.3) — a layout decision inside the widget's build method, not a token.
- The "never spring, never bounce" rule (§7.1) — enforced by *not calling* `SpringSimulation` anywhere in component code; no token prevents a future contributor from reaching for `context.motion.spring` in a new widget. This is a code-review discipline, not a themeable value.
- Navigation's edge-bar selection language (§10.4/8.2) — a specific `Container`/`Positioned` decoration inside the nav widget, not expressible as a single color/radius swap.
- `AppElevationExtension`'s `border`/`shadow`/`surfaceColor` *combination* per level is a token (§6, cheap to retheme the exact colors/blur/opacity) — but *which level a given component uses* (e.g. "Card is `resting`, Dialog is `floating`") is a decision baked into that component's build method, not swappable without touching the widget.
- The static-label / no-floating-label TextField choice, the "buttons are `radius.xs` not pill" choice (§5.2), and any other **rule about which token a component reaches for** — the rule lives in code even though the values it reaches for are tokens.

**The test**: if changing something only requires editing a `VerdantColors`/`AppSpacingExtension`/`AppShapeExtension`/`AppElevationExtension`/`AppMotionExtension` value (or an `AppTheme.light()/.dark()` parameter) and every consumer picks it up automatically, it's a retheme. If it requires opening a specific widget's `.dart` file and changing what it *does*, it's a redesign — no matter how small the code change looks.

---

## 0. Relationship to what already exists

Being honest about this up front, because pretending Verdant starts from nothing would be dishonest and would also throw away real, working engineering.

**What survives:**
- The `ThemeExtension` delivery mechanism (`AppSpacingExtension`, `AppShapeExtension`, `AppElevationExtension`, `AppMotionExtension`, `AppSemanticColors`, read via `context.spacing`/`.shape`/`.elevation`/`.motion`/`.semanticColors`). This is sound Flutter architecture — not a Material problem. Verdant keeps the mechanism and changes the *values* and, in one case, the *meaning* of what a token represents.
- Plus Jakarta Sans as the workhorse UI typeface (SIL OFL 1.1, bundled, already wired through `flutter_test_config.dart`'s real-glyph golden tests). Section 3 explains why re-typefacing is not the lever that makes Verdant feel original, and what changes instead.
- `AppLoadingIndicator`, `AppStateView`, `AppSnackBar` — their *behavior* (states, when each fires) is sound. Their *rendering* (color, shape, motion) changes under Verdant's tokens automatically once those tokens change, with no API changes needed.
- Theme Studio (the Widgetbook live-customization addon) — becomes *more* valuable under Verdant, since hand-authored palettes benefit more from live preview than algorithmic ones (Section 3.4).

**What is explicitly retired:**
- `ColorScheme.fromSeed(seedColor: ...)`. This is the single biggest reason the kit currently "feels Material" no matter what tokens sit on top of it — `fromSeed` runs Material's own HCT (Hue-Chroma-Tone) algorithm to derive every role, and that algorithm has a recognizable signature (the same way a JPEG compression artifact is recognizable). Verdant hand-authors every `ColorScheme` role explicitly. See Section 3.
- The generously-rounded M3 default radius scale (8/12/16, pill-leaning). See Section 5.
- `AppExpressiveCard`'s asymmetric shape-morph-on-spring-tap. Its own code comments named its origin as "M3 Expressive" — under Verdant's own anti-pattern rule ("never mistaken for Material"), this component failed its own test and was retired in Tahap 3. See Section 5.4 and 11.2.
- Spring-physics motion as a *default* vocabulary item. "Lively" and "confident, never bouncy" are different instructions. See Section 7.
- `docs/DESIGN_LANGUAGE.md` (the earlier "confident, warm, precise" brief). Verdant supersedes it — that document is not deleted, but should be treated as historical once this spec is confirmed, the same way ARCHITECTURE.md's ADR log keeps superseded decisions visible rather than erasing them.

---

## 1. The soul of Verdant

Verdant is not a color. Verdant is a *posture*: growth without urgency, confidence without noise, precision without coldness.

The reference point named in the brief — "a peaceful modern library, not a colorful startup office" — is the single sentence every design decision below is checked against. A library doesn't compete for your attention. Its furniture, lighting, and signage exist so you forget they exist and focus on the book in front of you. Verdant's UI has the same job: disappear, so the user's content is the only thing that registers.

**Design manifesto, made operational:**
- Every spacing value in Section 4 has a named reason it exists, not a rounded-off convenient number.
- Every radius value in Section 5 has a stated emotional register (precise vs. lifted), not a single "looks nice" default reused everywhere.
- Every color in Section 3 is traced to a specific natural reference *and* a specific UI role — never "just because we needed another shade."
- Every motion timing in Section 7 has a stated reason for its duration, not a copy-pasted 300ms.

---

## 2. Emotional goals, and how the system is checked against them

The brief names five feelings: safe, focused, relaxed, organized, professional, in control. Each maps to a concrete, checkable design constraint, not a vibe:

| Feeling | Concrete constraint |
|---|---|
| Safe | Every interactive element has a visible, non-color-only focus/state indicator (Section 8.1) — never rely on color alone, which also serves accessibility. |
| Focused | Maximum of one saturated color on screen at a time in a resting state (the moss green, used for the single primary action). Everything else is neutral. |
| Relaxed | No motion plays without a reason (Section 7) — the interface never moves to get attention, only to explain a state change. |
| Organized | A single spacing grid (Section 4) and a single type scale (Section 14) are the *only* sources of vertical/horizontal rhythm anywhere in the app — no ad hoc values, enforced the same way `context.spacing.md` already replaced hardcoded `EdgeInsets.all(16)` in this kit's own screens. |
| Professional / in control | Depth communicates hierarchy without shouting (Section 6) — a resting card is *quieter*, not *flatter*, than an active overlay. |

**Fatigue test**: after several hours, the user's eyes should not tire. This rules out high-contrast pure black-on-white text, saturated large color fields, and any sustained animation (looping, pulsing, shimmering) as *default* UI states. Verdant's light-mode base surface is a warm off-white (not `#FFFFFF`), and its dark-mode base is a deep slate (not `#000000`) — full explanation in Section 3.1.

---

## 3. Color philosophy

**The rule stated first, because it's the one most often violated by accident: green is not decoration, green is the single unit of "this is where action or life is happening."** Everything else in the palette is neutral by design, so that when green appears, it means something.

### 3.1 Primitive scale — Stone (neutral)

Material's neutral scales are cool and clinical (`#FFFBFE`, `#1C1B1F`) — a fluorescent-lit office. Verdant's neutral scale is warm-cool *balanced*, like wet limestone or a granite counter under daylight — present, tactile, alive, but never beige-cozy and never sterile-cool. One neutral scale, thirteen steps, used for surfaces, text, borders, and disabled states everywhere in the system.

| Token | Hex | Reference | Primary role |
|---|---|---|---|
| `stone.0` | `#FCFBF8` | Limestone, fresh-cut | Light-mode page background |
| `stone.10` | `#F5F3EE` | Limestone, weathered | Light-mode raised surface (cards, sheets) |
| `stone.20` | `#EAE7DF` | Dry granite dust | Dividers, hairline borders (light) |
| `stone.30` | `#D9D5C9` | Overcast granite | Disabled surface, input borders (light) |
| `stone.40` | `#C1BCAC` | Morning mist over stone | Placeholder text, disabled text (light) |
| `stone.50` | `#A39D8A` | Mid-tone river stone | Secondary/muted text (both modes, adjusted) |
| `stone.60` | `#857F6C` | Wet slate | Icon default (light), secondary text (dark) |
| `stone.70` | `#665F4F` | Damp bark | Body text, low-emphasis (light) |
| `stone.80` | `#4A4438` | Wet soil | Body text, standard (light) / borders (dark) |
| `stone.90` | `#302C24` | Forest floor at dusk | Primary text (light) / raised surface (dark) |
| `stone.95` | `#201D18` | Riverbed at night | Dark-mode raised surface, elevated |
| `stone.98` | `#17150F` | Deep cave stone | Dark-mode page background |
| `stone.100` | `#0F0D09` | — | Reserved (true-black avoided as a default; see below) |

Note deliberately: `stone.98`, not `stone.100`, is the dark-mode page background. A true `#000000`/near-black background maximizes contrast in a way that reads as harsh under sustained reading — OLED-marketing black, not library-lamp black. `stone.98` (`#17150F`) has enough warmth to feel like a dim room, not a void.

### 3.2 Primitive scale — Moss (brand, action, growth, success)

The one color allowed to be confident. Deep, desaturated, forest-adjacent — never a "gaming RGB" or "eco-brand" green. Chroma is deliberately restrained across the whole ramp; nothing in this scale should look good on a neon sign.

| Token | Hex | Reference | Primary role |
|---|---|---|---|
| `moss.10` | `#EAF2EC` | Mist through leaves | Container background, light (success/primary washes) |
| `moss.20` | `#C9DDD0` | New growth, pale | Container background, hover state |
| `moss.30` | `#9EC0AB` | Young fern | Disabled-but-visible action state |
| `moss.40` | `#6E9E7F` | Moss in shade | Primary action, **dark mode** (needs to lift off `stone.98`) |
| `moss.50` | `#4C7F5D` | New leaf | Success indicator (both modes, adjusted for contrast) |
| `moss.60` | `#35604A` | Pine canopy | Primary action, **light mode** |
| `moss.70` | `#274736` | Forest interior | Primary action pressed/active state (light) |
| `moss.80` | `#1B3226` | Deep forest floor | Text-on-moss-container (light) |
| `moss.90` | `#10201A` | Night forest | Container background, dark mode |

### 3.3 Semantic status scales

Material's error/warning/info are saturated, generic, and identical across every Material app — one of the fastest visual "tells." Verdant's status colors are each traced to a distinct natural material, keeping the same restrained chroma discipline as Moss.

**Ember (danger)** — oxidized iron, aged clay roof tile. Warmer and more muted than a stop-sign red; still unambiguous.
- `ember.40` `#D98F78` (container, dark mode) · `ember.50` `#C97A62` (container, light mode) · `ember.60` `#A34936` (danger, light mode) · `ember.70` `#7D3527` (danger, pressed) · `ember.90` `#2A1712` (container, dark mode)

**Brass (warning)** — aged brass fittings, old leather-notebook hardware. Ochre-gold, not traffic-cone orange.
- `brass.40` `#D9B876` (container, dark) · `brass.50` `#C9A054` (container, light) · `brass.60` `#93732E` (warning, light mode) · `brass.70` `#6E5622` (warning, pressed) · `brass.90` `#251C0C` (container, dark)

**Mist (info)** — river water under fog. Desaturated slate-blue, closer to grey than to "link blue."
- `mist.40` `#8CB4C4` (container, dark) · `mist.50` `#9CB8C4` (container, light) · `mist.60` `#4F7A8C` (info, light mode) · `mist.70` `#3A5C6B` (info, pressed) · `mist.90` `#101E22` (container, dark)

Every `-60` "on-light" value above is WCAG 2.1 AA-verified (≥4.5:1) against `stone.0`; every "container, dark" value is verified against `stone.98`. This carries forward the exact discipline `AppSemanticColors` already established (`test/tokens/app_semantic_colors_test.dart`) — Verdant does not relax that bar, it just changes which hexes have to pass it.

### 3.4 Why hand-authored, not `ColorScheme.fromSeed`

This is the concrete engineering decision, stated plainly: **Verdant's `ColorScheme` is constructed with the plain `ColorScheme(...)` constructor, every role named explicitly, never `ColorScheme.fromSeed`.**

`fromSeed` is not "a seed color plus some math" in a neutral sense — it is *Material's specific* tonal-palette algorithm (HCT color space, fixed chroma curves per role). Two apps using `fromSeed` with completely different seed colors still both look like "a Material app," the same way two photos shot in the same film stock still both look like that film stock regardless of subject. Keeping `fromSeed` and only changing tokens on top of it is exactly the trap that produced the original complaint — it is why the kit could have a full `AppSpacingExtension`/`AppShapeExtension`/`AppSemanticColors` token layer already and still read as "Material UI" at a glance.

Hand-authoring means every one of `primary`/`onPrimary`/`primaryContainer`/`onPrimaryContainer`/`secondary`/.../`surface`/`surfaceContainerHighest`/`outline`/etc. is assigned directly from the Stone/Moss/Ember/Brass/Mist tables above, role by role, contrast-checked individually. More upfront work; the payoff is that the palette is *authored*, not *generated* — which is the whole point of Section 3.4 existing at all.

This is also why **Theme Studio becomes more valuable, not less**, under Verdant: a hand-authored palette has no algorithm to regenerate it from one seed, so a live tool for previewing hand-picked role combinations is doing real work instead of just re-running `fromSeed` with a different input.

---

## 4. Spacing system

*"Think like architecture, not mobile apps."* Material (and most mobile-app spacing scales) optimizes for density — fitting more on a small screen. Verdant optimizes for **composition** — every screen reads like a designed page, with room around ideas, not a checklist crammed into shipped px budget.

Base unit stays **4px** (subpixel-safe on every real device pixel density; a wider stride would fight Flutter's own layout arithmetic for no benefit). What changes is the *shape* of the scale: fine-grained at the bottom (precise micro-adjustments still need to exist — icon-to-label gaps, etc.), and deliberately generous jumps at the top (macro composition, page margins, section breaks) rather than Material's more linear progression.

| Token | Value | Used for |
|---|---|---|
| `space.3xs` | 2px | Icon-to-badge micro nudges only |
| `space.2xs` | 4px | Icon-to-label gap, tight inline groups |
| `space.xs` | 8px | Internal padding of small controls (chips, compact buttons) |
| `space.sm` | 12px | Internal padding of standard controls (text fields, list items) |
| `space.md` | 16px | Default component-to-component gap |
| `space.lg` | 24px | Card internal padding; gap between related groups |
| `space.xl` | 32px | Gap between unrelated sections on the same screen |
| `space.2xl` | 48px | Page-level top/bottom margin (mobile) |
| `space.3xl` | 64px | Page-level side margin (tablet/desktop); "chapter" breaks |
| `space.4xl` | 96px | Hero/landing composition breathing room (desktop/web only) |

**The rule, stated as a rule**: content margins on a Verdant screen should feel like a page in a printed book — real, generous margin the eye can rest in — not the edge-to-edge crowding typical of mobile-first Material layouts. `space.2xl`/`3xl` exist specifically so page margins have a name and a value, instead of being invented per screen the way `EdgeInsets.all(16)` used to be before this kit's own token migration.

### 4.1 Grid philosophy

Verdant does not use a numeric column grid (a 12-column Bootstrap-style system) as its primary composition tool — the `space` scale above *is* the grid, expressed as a rhythm of gaps rather than a count of columns. This is a deliberate choice, not an omission: a column-count grid optimizes for filling a canvas efficiently (the newspaper-layout problem Bootstrap's grid was built to solve); Verdant optimizes for restraint, where the more relevant question is "how much space surrounds this," not "how many columns wide is it."

On wider layouts (tablet/desktop, per `Breakpoints` — §8.8), content is constrained to a **maximum reading width** rather than stretched full-bleed: text-heavy screens (forms, articles, settings) cap around 720px; dashboard-style multi-column screens cap around 1200px. Both figures are bounded on either side by `space.3xl`/`4xl` margins (§4's own top-level table) — a specific, checkable decision, not "however wide the viewport happens to be." A narrow form on a wide monitor stays a narrow, centered column; it does not stretch its fields edge to edge just because room is available (elaborated further in §4.3, Negative space).

Where a screen genuinely needs multiple columns (a dashboard with side-by-side cards, a settings screen with a list-plus-detail split), the gutter between columns uses the *same* `space` tokens as everything else — `space.lg` (24px) for closely related columns, `space.xl` (32px) for columns that represent distinct concerns — never a separate "grid gutter" token invented in parallel. One spacing vocabulary, not two.

### 4.2 Component rhythm

Rhythm here means: within a repeated group of the same kind of element (a stack of form fields, a list of rows, a row of chips), the gap between adjacent instances uses **exactly one token, consistently, for that relationship** — never two different values doing the same job on the same screen. Concretely:

- Every field-to-field gap in a form is `space.md` (16px), full stop — not 16px in one form and 12px in another because it "looked a little tight."
- Every list row's internal padding is `space.sm` (12px) plus a hairline divider (§6's Level 1 border, not a manually-drawn line) — not a mix of padded rows and flush rows on the same list.
- Every icon-to-label gap, anywhere in the system (buttons, nav destinations, list leading icons), is `space.2xs` (4px) — this one relationship, one token, is what makes icon+label pairs read as a single family across completely different components.

This is the enforceable, checkable version of "consistent rhythm": a code reviewer can grep for a hardcoded `EdgeInsets`/`SizedBox` value inside a repeated-element widget and know it's wrong on sight, the same way this kit's own token migration already made ungapped/untokened spacing a visible smell.

### 4.3 Negative space

Negative space is not "the space left over once content is placed" — treated that way, it gets minimized for density, which is the mobile-app instinct §4's opening line explicitly rejects. In Verdant, negative space is an **active signal of hierarchy and confidence**, on equal footing with color and type as a design tool.

Concretely: a screen with generous unused space around its single primary action reads as "this is the one thing to do here" — the emptiness itself does communicative work, the same way a blank margin around a pull-quote in a printed book tells the reader "pay attention here" before they've read a word of it. Crowding controls edge-to-edge to "use the space efficiently" reads as anxious, not efficient — it signals the designer didn't trust the content to stand on its own.

This is the philosophical justification behind why `space.2xl`–`4xl` exist as named, generous top-of-scale values (§4) and why §4.1's reading-width cap exists at all: a short form on a wide desktop screen stays narrow and centered rather than stretching to fill the viewport, because filling the viewport would be treating negative space as failure rather than as one more instrument in the design. The test for any screen: could more space be removed without the layout looking broken? If yes and it wasn't, that's not efficiency, that's an oversight.

---

## 5. Radius / shape philosophy

This is the single fastest visual "is this Material" tell, and the one most worth getting exactly right. Material 3 — especially M3 Expressive — defaults to heavily rounded, soft, "friendly blob" shapes. Verdant's corners are **precise, not soft**, evoking joinery in stone and wood (a mortise-and-tenon joint is exact; it is not rounded off to feel approachable).

| Token | Value | Emotional register | Used for |
|---|---|---|---|
| `radius.none` | 0px | Absolute precision | Data tables, code/monospace blocks, dividers |
| `radius.xs` | 2px | Hairline-soft — barely perceptible | Default for inputs, list rows, small controls |
| `radius.sm` | 4px | Quiet, composed | Cards, containers, dialogs at rest |
| `radius.md` | 6px | Slightly lifted | Elevated/floating surfaces (menus, popovers) |
| `radius.pill` | 999px | Deliberate object-ness | **Only** true pill objects: tags, badges, avatar frames, filter chips — never buttons, never cards |

**5.1 The rule for when something gets rounded at all**: radius increases only when a surface visually *lifts off* the page (Section 6's depth levels). A resting card is `radius.sm`. A dialog floating above a scrim is `radius.md`. Nothing in Verdant's default vocabulary goes softer than that without a specific, nameable reason — the opposite of Material's default posture, where soft-rounded is the *baseline* and sharp is the exception.

**5.2 Buttons are `radius.xs`, not pill-shaped.** This is a deliberate, checkable departure from both Material (`AppButton` was pill-leaning via `radius.pill` before Tahap 2) and from most "modern SaaS" kits that default every button to a full pill. A button that looks like a precise, cut rectangle reads as *intentional* — a tool, not a bubble.

**5.3 Tags/badges (`AppStatusBadge`) keep the pill** — for those specifically, "object-like" is correct: a badge is meant to read as a small physical marker (a wax seal, a nameplate), and the brief's own "premium notebooks, luxury fountain pens" references support a pill there specifically, not everywhere. This same reasoning extends to a small, named set of other true "object" shapes documented in §10: the Switch track and thumb (10.9), a selected day cell in the Calendar (10.19), and the Avatar frame (10.20) — every one of them a literal physical-object metaphor, never a container.

**5.4 `AppExpressiveCard`'s shape-morph mechanic was retired in Tahap 3.** Its original design — asymmetric corner morph, spring-physics elevation lift on tap — was explicitly M3-Expressive-derived (the component's own doc comment said so). Under the "would someone mistake this for Material" critic-mode check, the honest answer was yes, immediately. The redesign expresses confidence through a *quieter* mechanism instead: a hairline border that shifts from `stone.20` to `moss.60` on press, no shape change, no spring — consistent with Section 7's motion rules. Implemented and golden-verified as of Tahap 3.

---

## 6. Depth philosophy (replacing Material shadows)

Material shadows are explicit, layered, and always-on: every elevated surface gets a visible drop shadow by default, at every elevation level, everywhere. Verdant's depth model is quieter by default and reserves shadow for the moments that actually need it — the same "interface disappears" principle from Section 1 applied to the z-axis.

Four levels, each with a **named reason** for existing:

| Level | Name | Visual treatment | Used for | Reason it exists |
|---|---|---|---|---|
| 0 | Flush | No border, no shadow, same surface tone as page | Page background itself | The baseline — everything else is judged relative to this |
| 1 | Resting | 1px hairline border (`stone.20` light / `stone.80` dark), **no shadow** | Cards, list items, containers at rest | Separation without weight — most of the screen lives here |
| 2 | Lifted | Border + barely-visible ambient shadow (black @ 4% opacity, 12px blur, 2px y-offset) | Hover/focus state on interactive containers | Depth as *feedback*, not decoration — only appears in response to interaction |
| 3 | Floating | No border; single soft ambient shadow (black @ 8% opacity, 24px blur, 8px y-offset) **plus** a surface-tone shift (`stone.10` on `stone.0` light; `stone.95` on `stone.98` dark) | Dialogs, bottom sheets, menus, tooltips — true overlays only | The one class of surface that genuinely floats above content, and should look like it |

**Explicitly avoided**: Material's multi-shadow stacking (key light + ambient light as two separate shadow layers), colored/tinted shadows, and shadow used as a *permanent* decorative state on resting surfaces. Level 1 — the level almost everything in a real screen actually uses — has **zero shadow**. Depth is communicated primarily through the *surface-tone step* at Level 3 and the *hairline border* at Level 1, with shadow reserved as a signal that something has genuinely detached from the page (Level 2 interaction feedback, Level 3 true overlays).

This maps onto the existing `AppElevationExtension` token class directly — the class survives, its meaning changes from "give me a Material elevation value" to "give me one of these four named, purpose-built depth treatments."

---

## 7. Motion system

*"Natural, confident, predictable, elegant. Never playful. Never bouncy."* This is an instruction to remove a mechanism, not just retune it: **no spring-physics overshoot anywhere in Verdant's default vocabulary.** The existing `AppMotionExtension.spring` was tuned "lively but not too bouncy" — under Verdant's own brief, "lively" is already the wrong adjective to be optimizing for. Confident motion doesn't overshoot and settle; it moves once, decisively, and stops.

**7.1 One curve family, two directions:**
- **Verdant Enter** — `Cubic(0.2, 0.0, 0.0, 1.0)`: decisive start (near-linear initial velocity), long gentle settle, zero overshoot. Used for anything appearing or growing.
- **Verdant Exit** — `Cubic(0.4, 0.0, 0.8, 1.0)`: quick departure, front-loaded. Attention should leave a screen faster than it arrived, so the next state can take over without a lingering half-second of "still watching the old thing disappear."

No spring curve is part of the default set. (The `SpringDescription`/`SpringSimulation` *capability* in the codebase doesn't need to be deleted — it's genuinely useful Flutter physics infrastructure — but nothing in Verdant's component vocabulary should reach for it as a default the way `AppExpressiveCard` used to.)

**7.2 Duration scale — hierarchy through time, not through curve shape:**

| Token | Duration | Used for |
|---|---|---|
| `motion.micro` | 120ms | Press/release state changes, checkbox/switch toggle, focus ring appearance |
| `motion.standard` | 220ms | Expand/collapse, tab switch, in-place content swap |
| `motion.panel` | 320ms | Bottom sheet / dialog entrance, dropdown/menu open |
| `motion.page` | 380ms | Full-screen/route transitions |

**7.3 Specific interaction language:**
- **Hover** (desktop/web): border color shift only (`stone.20` → `stone.40`), `motion.micro`, Verdant Enter. No scale, no shadow change at rest.
- **Press**: a single, subtle surface-tone darken (not a shadow lift, not a scale-down), `motion.micro`.
- **Focus**: a persistent 2px `moss.60` outline ring, offset 2px from the element edge — never color-only, always geometric, so it survives grayscale/colorblind viewing. Appears instantly (no animated fade-in on focus itself — focus should never feel delayed). Formalized as explicit tokens in §9.3.
- **Loading**: `AppLoadingIndicator`'s spinner keeps its native rotation (that's the platform's own continuous-motion primitive, not a Verdant-authored animation) — no additional pulsing/shimmer skeleton screens as a default, since a shimmering skeleton is itself a form of "attention-getting" motion the brief asks to avoid. A plain, still `AppStateView(loading: true)` label communicates "waiting" without visual noise.
- **Success/Failure feedback**: color + icon change only, `motion.standard`, no bounce, no confetti, no shake. `AppSnackBar`'s entrance uses `motion.panel` / Verdant Enter, its exit uses `motion.standard` / Verdant Exit.
- **Navigation / page transitions**: a plain cross-fade + slight vertical settle (8px), `motion.page`, Verdant Enter/Exit pair — no shared-element hero morphing as a default (that's an M3-Expressive-coded pattern in most Flutter implementations; reserved as a possible *rare*, deliberate flourish, never a default).
- **Drag/Drop**: the dragged element gets Level 2 depth (Section 6) for the duration of the drag only, reverting to Level 1 on drop — depth as literal, temporary feedback that something has been picked up.

---

## 8. Interaction & information language

**8.1 Focus indicators** — covered in 7.3; restated here because it's a hard rule, not a suggestion: every focusable element must show the `moss.60` geometric ring on keyboard focus, full stop, regardless of platform. This is both the accessibility floor and a deliberate identity marker — a visible, consistent focus ring is rare enough in consumer apps that it reads as "built by people who care," which is exactly the "craftsmanship" value named in Section 1.

**8.2 Selection language** — selected list items / selected tab get a `moss.10` background wash (light) / `moss.90` (dark) plus a 2px `moss.60` left-edge indicator bar (not a full-row color flood, which competes with content). Selected state never relies on the primary action's own button color — visually distinct roles stay visually distinct. Two named, deliberate exceptions exist, both documented at point of use rather than silently breaking the rule: Table rows (§10.13) use wash only, no edge bar, since a per-row bar in a dense grid reads as noise; Menu items (§10.23) use neither, since a menu item is a one-shot action, not a persisted selection.

**8.3 Information hierarchy** — achieved primarily through Section 14's typography weight/size/spacing, *not* through color. A screen should be scannable in grayscale. Color (moss) is reserved for: the single primary action, success/status indication, and the selection indicator above — never for arbitrary hierarchy ("make this text green because it's important").

**8.4 Density strategy** — one density per platform class, not a user-toggleable density slider. A compact/comfortable/spacious toggle is a professional-tool feature (spreadsheets, admin dashboards) that this kit's scope — consumer-facing screens — doesn't call for; adding one would be building for a hypothetical need, which this kit's own stated engineering discipline already argues against. Mobile uses the base `space` scale as-is (§4); desktop/tablet widens *margins* (`space.3xl`/`4xl`) without shrinking *component* internal padding — composition gets more generous, controls don't get cramped. Two concrete floors regardless of platform or breakpoint: touch/click targets never shrink below 44×44px (the accessibility floor, non-negotiable), and a given component's own internal padding token (e.g. a button's horizontal padding) is fixed across breakpoints — only the space *around* components changes as the viewport widens, never the space *inside* them. This is what makes "one density per platform class" a real constraint rather than a slogan: there is exactly one correct padding value for a button on any given platform, not a range a designer picks per screen.

**8.5 Scrolling behavior** — no artificial momentum tweaks, no custom overscroll glow/bounce recoloring as a default (leave platform-native scroll physics alone; a library doesn't add sound effects to turning pages). Extending this to cases the brief specifically calls out: no scroll-triggered decoration — no parallax headers, no sticky-header color-morph-on-scroll-position, no "shrinking app bar" effects as a default — motion in Verdant responds to *state changes* (Section 7), and scroll position is not a state change, it's a continuous input; tying decorative motion to it violates the "no motion without a reason" rule as surely as an unprompted animation would. Desktop/web scrollbars use the platform's own default rendering, not a custom-styled thin/colored/auto-hiding scrollbar — another common "modern SaaS kit" signature Verdant deliberately doesn't adopt. Infinite-scroll loading state (more content being fetched at the list's end) uses `AppLoadingIndicator`, not a skeleton-shimmer placeholder row — the same no-shimmer rule from §7.3, restated for the specific case of scroll-triggered loading rather than initial-page loading.

**8.6 Dark mode philosophy** — not an inverted palette; each Stone/Moss/Ember/Brass/Mist step was chosen independently for its mode (see Sections 3.1–3.3's explicit "light mode" / "dark mode" role assignments) so dark mode has its own considered "personality" rather than being a mechanical `Color.lerp` inversion. Both modes should feel like the *same* posture (calm, precise) under different lighting — the way the same room looks different but equally composed in daylight versus lamp-light. Expanded, since this is the single most common place a lazy dark-mode implementation gets it wrong:
  - **Not a formula.** Dark mode's role assignments were not derived by inverting or lightening the light-mode hex values — each was independently chosen and independently WCAG-verified (§3.3's own note on this). `moss.40` (dark-mode primary) is not "moss.60 with its lightness flipped"; it's a distinct value picked because it needs to read clearly against `stone.98`, a different legibility problem than `moss.60` solves against `stone.0`.
  - **Surfaces get lighter as they elevate, in both modes — but from different floors.** Light mode's stack runs `stone.0` (page) → `stone.10` (raised) → `stone.20` (higher); dark mode's stack runs `stone.98` (page) → `stone.95` (raised) → `stone.90` (higher) — in both cases, a surface *further from the page* is *closer to the middle of the neutral scale*, not simply "lighter" or "darker" as an absolute rule. This is why the four depth levels (§6) don't need a dark-mode-specific version of their own logic — only the specific Stone step each level resolves to differs.
  - **Shadow stays black-based in both modes.** A shadow is still "the absence of extra light" regardless of theme — Verdant does not invert to a white/light glow effect in dark mode, which is why §6's shadow tokens have no separate dark-mode color, only the Level 3 surface-tone step differs (`stone.10` light / `stone.95` dark).
  - **Content, not chrome, stays as-authored.** Photographic avatars, uploaded images, and chart *data* colors (§10.14) are not re-tinted for dark mode — only chrome (surfaces, text, borders, UI-authored icons) adapts. A user's profile photo should look the same regardless of which theme the app is in.

**8.7 Accessibility philosophy** — WCAG 2.1 AA is the floor, not the target, verified per-token the same way `AppSemanticColors` already enforces via test (Section 3.3). Focus indicators are geometric, never color-only (8.1). Motion respects `MediaQuery.disableAnimations` throughout (the `AppExpressiveCard` precedent of "shape/border change still happens, but jumps instead of animating" — carried forward through its own Tahap 3 redesign — is the pattern for every Verdant motion, not just the one component that originally established it).

**8.8 Responsive philosophy** — the `AdaptiveLayout`/`Breakpoints` infrastructure already in `design_system` survives unchanged; what changes under Verdant is *only* the margin/spacing values applied at each breakpoint (Section 4), not the breakpoint mechanism itself. Made fully explicit, since this needs a checkable answer, not a general gesture at the idea:
  - **The mechanism is three-tiered, not four** — `Breakpoints.mobile` = 600px, `Breakpoints.tablet` = 1024px, giving mobile (<600), tablet (600–1024), desktop (≥1024). (Correcting this document's own earlier wording, which said "four-level" — verified against `packages/design_system/lib/src/layout/breakpoints.dart` while writing this revision, not assumed.) `AdaptiveLayout` swaps between `mobile`/`tablet`/`desktop` builders, falling back to the next-smallest provided one — Verdant does not add a fourth tier (e.g. a distinct "wide desktop" breakpoint); §4.1's dashboard max-width (1200px) is handled as a content-width cap *within* the desktop tier, not a new structural breakpoint.
  - **What Verdant changes**: only which `space` token is used for page-level margins at each tier (mobile: `space.2xl`; tablet/desktop: `space.3xl`, or `space.4xl` for hero/landing composition per §4) and the reading-width cap from §4.1. The breakpoint *thresholds themselves* (600/1024) are treated as a structural/layout-mechanism constant, not a design token — changing them has real layout consequences beyond a simple retheme, so they are deliberately kept out of the `AppShapeExtension`-style live-retheme surface (§0.1's boundary rule applied to breakpoints specifically).
  - **What Verdant does not add**: a fourth breakpoint tier, a distinct "web" vs. "desktop" split, or per-breakpoint component-level padding overrides (§8.4 already establishes that component padding is fixed across breakpoints — only margins scale).

---

## 9. Token architecture

Maps directly onto Flutter's `ThemeExtension` mechanism already proven in this codebase — no new delivery mechanism needed, only new/changed extension classes and values.

```
Primitive tokens   → Stone/Moss/Ember/Brass/Mist scales (Section 3), raw Space/Radius/Duration
                      scalars (Sections 4/5/7). Not consumed directly by components.
        ↓
Semantic tokens    → AppSemanticColors (success/warning/info/danger, on-X pairs) +
                      hand-authored ColorScheme roles (Section 3.4) + AppSpacingExtension +
                      AppShapeExtension (renamed conceptually to radius roles per Section 5) +
                      AppElevationExtension (renamed conceptually to depth levels per Section 6) +
                      AppMotionExtension (curves + durations per Section 7). This is the layer
                      component code actually reads via context.spacing/.shape/.elevation/.motion/
                      .semanticColors.
        ↓
Component tokens   → Per-widget overrides only where a component's role genuinely differs from
                      its semantic default (e.g. AppStatusBadge staying pill-shaped, Section 5.3).
                      Kept minimal deliberately — most components should need zero component-level
                      tokens, inheriting semantic tokens directly, the same restraint already
                      practiced in the existing five original widgets.
```

Every token category from the brief maps onto an existing or lightly-renamed extension class — no proliferation of new token *kinds*, only new *values* and, for depth/shape, new *meanings* attached to the existing extension. This keeps the "extract once" principle (ARCHITECTURE.md §3) intact: one mechanism, evolved values.

The brief's full token list also named Opacity, Interaction, Focus, and Responsive as categories. Each is addressed below with an explicit decision — a new token, or a documented reason an existing mechanism already covers it — rather than silently omitted, matching the same "component tokens: most need none, and here's why" discipline already practiced above.

### 9.1 Opacity tokens — decision: no new token scale

Verdant deliberately does not communicate state through opacity. A disabled button (§10.1) is a distinct flat color (`stone.30` fill / `stone.50` text), not "the enabled color at 40% alpha" — a discrete color change says "this is a different, specific state"; a faded version of the same color says "this is a diminished version of the same state," which is a different semantic and, not coincidentally, a very common Material/web pattern (`opacity: 0.38` disabled buttons) Verdant is deliberately not adopting. The system's two genuine opacity *uses* are already fully specified elsewhere rather than needing a parallel scale:
- **Shadow alpha** is embedded directly in each depth level's `BoxShadow` (§6 — e.g. black @ 4% for Level 2, black @ 8% for Level 3) as part of that level's definition, not a separately swappable value; a shadow's opacity and its blur/offset are one design decision, not independently tunable.
- **Modal scrim** (the dimming layer behind a Level 3 floating surface — Dialog, Bottom Sheet) is set at black @ 54% — Flutter/Material's own long-established, well-tested legibility value. This is named here as a *considered* choice, not an oversight: 54% is a well-worn, non-brand-specific utility number (it dims content enough to signal "not interactive" without fully hiding it), and there's no Verdant-identity reason to invent a different one. Borrowing a well-tested utility constant is the right call precisely because a scrim is infrastructure, not an identity lever.

### 9.2 Interaction tokens — decision: no new token scale

"Interaction" is not a scalar value (unlike a duration or a hex code) — it's a *mapping* from state to treatment, which is exactly what §7.3 (Specific interaction language) and each component's own "States" subsection in §10 already are. Formalizing "interaction" as a token would mean inventing a numeric or enum encoding for something that is more legible, more maintainable, and more honest as the documented rules it already is. The interaction layer is real and load-bearing, it's just expressed as *rules bound to the Motion (§7) and Color (§3/§6) tokens* rather than as an independent scale — the cross-product of "which state" × "which existing token" is the interaction system.

### 9.3 Focus tokens — decision: yes, formalize as explicit tokens

Unlike Interaction, the focus ring is a literal, reusable, cross-component *value set* — currently described in prose in two places (§7.3 and §8.1: "2px `moss.60` outline ring, offset 2px") without a single themeable source. This is worth fixing: `focus.ringWidth` (2px) and `focus.ringOffset` (2px) are genuinely new token values, additive to `AppMotionExtension` or a small dedicated extension at implementation time. `focus.ringColor` is deliberately **not** a new independent color token — it should always equal `colorScheme.primary`, by identity rule: the focus ring is "the one active color" (§8.3), the same restraint that limits saturated color to a single meaning elsewhere in the system. Giving it its own independent hex would let a future contributor accidentally set it to something other than primary, quietly breaking the "one saturated color, one meaning" rule this whole spec is built on. This also means the focus ring automatically follows Theme Studio's `primaryColor` override (§0.1) with zero extra wiring — it already reads from the same `colorScheme.primary` every other primary-colored element does.

### 9.4 Responsive tokens — decision: no new token scale

"Responsive" in Verdant is the intersection of two things that already exist separately, not a third thing: `Breakpoints`' three fixed pixel thresholds (structural — §8.8) and the `space` scale's per-breakpoint margin assignment (aesthetic — §4/§8.8). The breakpoint thresholds themselves are deliberately kept *out* of the retheme-safe token surface (§0.1, §8.8) — changing where "tablet" starts is a layout-mechanism decision with real consequences, not a safe live-preview value the way a color or spacing number is. There is no separate "responsive" scalar to define; §8.8 above is the complete, explicit answer the brief asked for.

---

## 10. Component philosophy

Full philosophy-first treatment for every component named in the original brief. Sections 10.1–10.6 carry the most identity weight (the ones a user looks at in every session) and are **implemented, golden-tested, and CI-verified** as of Tahap 2. Sections 10.7–10.23 give every remaining named component the same Purpose/Shape/Depth/Motion/State treatment — **specification only**, per this revision's own stated scope (see the v1.1 revision note at the top of this document): none of them are implemented yet, and none should be built until a real screen needs them, per §13 point 5's unchanged staging discipline. §10.24 restates that boundary explicitly at the end of this section so it isn't lost after sixteen sections of detail.

### 10.1 Button
- **Purpose**: the single most common commitment point in the UI — deserves the most restraint, not the most decoration.
- **Shape**: `radius.xs` (2px) — a precise rectangle, not a pill (Section 5.2).
- **Depth**: Level 1 at rest (hairline `stone.20` border for secondary buttons; primary buttons are a filled `moss.60` surface with *no* border and *no* shadow — filled color alone is enough weight).
- **States**: rest → hover (border/fill darken one Stone/Moss step, `motion.micro`) → press (further one-step darken, `motion.micro`) → disabled (`stone.30` fill / `stone.50` text, no interaction affordance implied). Loading state reuses `AppLoadingIndicator`'s spinner inline, replacing the label, never both at once.
- **Typography**: label uses `labelLarge` (Section 14.1's scale — 14px/500 medium weight, never bold; a shouting button contradicts "quiet elegance"). Confirmed against the real implementation, not assumed: `ElevatedButton`'s own M3 default already resolves its label to `theme.textTheme.labelLarge` with no override needed (Tahap 2).
- **Performance implications**: state-driven `WidgetStateProperty.resolveWith` callbacks run only on hover/press/disabled transitions, not every frame. No spring/physics `Ticker` for the default button — strictly cheaper than the pattern `AppExpressiveCard` used before its Tahap 3 redesign.
- **Future scalability**: a documented-but-unbuilt secondary/outlined variant (the "hairline border" case named above) can be added as an additive `variant` parameter without changing `AppButton`'s existing public API.

### 10.2 Card
- **Purpose**: a container for related content, not a design flourish. Most of a Verdant screen is Level 1 cards.
- **Shape**: `radius.sm` (4px). **Depth**: Level 1 (hairline border, no shadow) at rest; Level 2 only if genuinely interactive (tappable card), never as decoration on a static content card.
- **No asymmetric/expressive variant survives as a default** (Section 5.4) — every card in Verdant uses the same quiet geometry; distinctiveness comes from restraint, not from one flagship component doing something structurally different from the rest.
- **Performance implications**: the hover-only Level 2 shadow is a single boolean plus an `AnimatedContainer` — cost is paid only on the two enter/exit transition frames, not continuously.
- **Future scalability**: a loading-skeleton card variant, if ever needed, should be a new, separate component rather than a mode flag on `AppCard` — keeps the base component's render path simple and avoids a card that has to justify every state combination against §12's anti-pattern checklist individually.

### 10.3 TextField
- **Purpose**: precision input — the closest digital analog to "writing in a premium notebook."
- **Shape**: `radius.xs`. **Depth**: Level 1 border (`stone.30`), shifting to a 2px `moss.60` border on focus (no glow, no shadow — the focus ring *is* the border, thickened and recolored, `motion.micro`).
- **Label behavior**: label sits above the field permanently (never a Material-style floating label that overlaps the border) — a static label reads as more precise and printed-page-like; a floating label is itself a small piece of "clever" motion the brief's restraint principle argues against by default.
- **Error state**: border becomes `ember.60`, helper text below in the same `ember.60`, no icon-in-field animation.
- **Performance implications**: border-color transitions run through Flutter's own `InputDecorator`/`InputDecorationTheme` machinery — Verdant supplies only which colors/radii populate that theme, no new runtime cost beyond stock Flutter.
- **Future scalability**: every text-input-shaped component in this spec (Search 10.16, OTP 10.17, Password 10.18) inherits this exact shape/depth/label/error treatment — a future contributor adding a new field-like input points back here rather than re-deriving a philosophy from scratch.

### 10.4 Navigation (bars, sidebars)
- **Purpose**: orientation, minimized. A navigation rail is signage, not a feature.
- **Depth**: Level 1 — a single hairline border separating it from content, never a shadow (navigation should never look like it's floating above the content it's meant to organize).
- **Selected state**: 8.2's selection language exactly — edge `moss.60` bar + `moss.10`/`moss.90` wash, not a filled pill/chip around the label (that reads as a Material "navigation indicator pill" immediately). The bottom-anchored `AppNavigationBar` (Tahap 2) adapts the edge to the *top* of each destination, since it sits below content rather than beside it — a dedicated vertical Sidebar (§10.11) uses the brief's literal left-edge orientation.
- **Icons**: outline-style, single-weight, never filled-when-selected/outline-when-not (that specific toggle is one of Material's most recognizable navigation-bar tells) — selection is communicated by the edge bar and wash, not by swapping icon style.
- **Performance implications**: a fixed, small destination count (typically 3–5) — no virtualization concern at this scale. A screen needing a much longer destination list is a Sidebar (10.11) or Menu (10.23) case, not a reason to add list-recycling to the bottom bar.
- **Future scalability**: a notification-dot/badge-count marker on a destination is a documented-but-unbuilt extension point — should attach as an additive optional field on the destination model, not require a second navigation-bar component.

### 10.5 Dialog / Bottom Sheet
- **Purpose**: genuine interruption — reserved for decisions that must be made before continuing, matching this kit's existing `AppDialog.confirm` discipline of "used sparingly."
- **Depth**: Level 3 (Section 6) — the one place shadow is fully deployed, because a dialog genuinely is detached from the page.
- **Shape**: `radius.md` (6px) — the *most* rounded any Verdant surface gets by default, marking it as the exceptional, floating case.
- **Motion**: entrance `motion.panel` + Verdant Enter (scrim fades in parallel, `motion.standard`), exit `motion.standard` + Verdant Exit. No slide-up-and-bounce.
- **Performance implications**: `AnimationStyle`-driven transitions reuse Flutter's own `RawDialogRoute`/`ModalBottomSheetRoute` machinery — no custom `Ticker`, no physics simulation. Cost is identical to Flutter's stock dialog/sheet routes; only the curve/duration values differ.
- **Future scalability**: Tahap 2's one honest implementation gap — exit currently plays over the same duration as entrance, since `showDialog`/`showModalBottomSheet`'s public API has no independent `reverseTransitionDuration` hook — has a known fix path (a small custom `RawDialogRoute` subclass overriding that getter) already scoped out and noted here, so it doesn't need to be rediscovered if it's ever worth the added complexity.

### 10.6 Snackbar / Badge (`AppSnackBar`, `AppStatusBadge`)
- Snackbar: Level 3 depth (it's a temporary overlay), `radius.sm`, tone colors exactly as already built (`AppSnackBar.showError`/`.showSuccess`/`.showInfo`) — Ember/Moss/default-neutral, hand-authored per Section 3.4.
- Badge: the one component that keeps `radius.pill` by design (Section 5.3) — a small, dense, object-like marker. Tone mapping unchanged (`success`/`warning`/`info` → Moss/Brass/Mist).
- **Performance implications**: both are simple, single-pass widget trees with no animation machinery beyond Flutter's own stock SnackBar entrance/exit — no measurable performance profile worth a deeper note.
- **Future scalability**: stacked/queued snackbars (multiple messages visible at once, beyond `ScaffoldMessenger`'s default one-at-a-time queue) would be a deliberate architectural decision to design explicitly if a real screen ever needs it — not a default Verdant behavior to silently grow into.

### 10.7 Checkbox
- **Purpose**: a binary, independent choice — one of possibly several selected at once (as opposed to Radio's mutually-exclusive single choice).
- **Shape**: `radius.xs` square, ~20×20px — square is the deliberate visual distinction from Radio's circle; the two controls must never be shape-ambiguous at a glance.
- **Depth**: Level 1 `stone.30` border, unchecked, no fill. Checked: filled `moss.60`, no border needed (filled color alone is enough weight — the same rule as a primary Button, §10.1). Indeterminate: filled `moss.60` with a horizontal dash glyph instead of a checkmark.
- **Motion**: the checkmark glyph appears via a quick fade/scale, `motion.micro`, Verdant Enter — never an animated stroke-draw-in (that reads as a small piece of M3-Expressive-coded cleverness, not restraint).
- **States**: rest → hover (border darkens one Stone step) → checked/indeterminate (filled `moss.60`) → disabled (`stone.30` fill, `stone.50` glyph, whatever its checked state).

### 10.8 Radio
- **Purpose**: a single, mutually-exclusive choice among a visible set of options.
- **Shape**: a true circle — exempt from the `radius` scale entirely (§5.3's note), the same way Switch (10.9) and a selected Calendar day (10.19) are: this is a functional shape distinction from Checkbox, not a "should this look like a physical object" decision.
- **Depth**: Level 1 `stone.30` outer-ring border, unselected. Selected: `moss.60` filled inner dot, `stone.30` (or `moss.60`, both acceptable — outer ring recolors to match) outer ring.
- **Motion**: the inner dot appears via `motion.micro` + Verdant Enter, same register as Checkbox's glyph — no scale-bounce.
- **States**: rest → hover (outer ring darkens) → selected (filled dot) → disabled (`stone.30` ring, `stone.50` dot if selected-and-disabled).

### 10.9 Switch
- **Purpose**: an instant, no-confirmation-needed on/off toggle — for settings that take effect immediately, distinct from Checkbox's "part of a form, submitted later" context.
- **Shape**: track is `radius.pill` — the one other legitimate functional-pill exception beyond Badge/Tag (§5.3): a switch track is modeled directly on a physical sliding mechanism, not a container pretending to be object-like. Thumb is a true circle, same exemption as Radio.
- **Depth**: flush at rest — no border, no shadow on either track or thumb; the track's own fill color is the only state signal needed. Off: track `stone.30`, thumb `stone.0`/`stone.98` (mode-appropriate contrast). On: track `moss.60`, thumb `stone.0`.
- **Motion**: thumb slides from off- to on-position via `motion.micro` + Verdant Enter — **no spring, no overshoot, no bounce**. This is worth stating explicitly because a sliding toggle is exactly the kind of control that gets a springy animation by default in both Material and iOS; Verdant deliberately does not follow either.
- **States**: off → on, plus disabled (`stone.20` track regardless of position, no interaction affordance).

### 10.10 Tabs
- **Purpose**: switching between parallel views at the same hierarchy level, in place, without navigating away.
- **Shape**: `radius.none` for the tab strip container — a precise, flush band, not a rounded container. Individual tab labels have no background shape at rest.
- **Depth**: Level 1 — a single hairline border along the bottom edge of the whole tab strip, separating it from the content below (mirrors §10.4's nav-bar treatment, oriented for a top-anchored control instead of a bottom-anchored one).
- **Selected state**: a 2px `moss.60` underline beneath the selected tab's label only — never a filled pill/chip background behind the label (Material's and most SaaS kits' default tab-indicator treatment, and exactly the tell §5.2 already rejects for buttons, extended here). Selected label color: `moss.60`/primary; unselected: `stone.60`/`onSurfaceVariant` — same tone mapping as Navigation's icon/label treatment (10.4).
- **Motion**: the underline slides to the newly-selected tab's position via `motion.standard` + Verdant Enter — a single, decisive slide, not a spring-driven one.

### 10.11 Sidebar
- **Purpose**: persistent navigation for wider viewports (tablet/desktop, per §8.8) — the vertical counterpart to the bottom-anchored `AppNavigationBar`, appearing at the breakpoint where a bottom bar stops being the right shape for the screen.
- **Shape**: `radius.none` — a full-height rectangular panel, flush against the window edge; nothing about a sidebar should look like a floating card.
- **Depth**: Level 1 — a single hairline border along the panel's *right* edge (the side facing content, mirroring nav bar's top-edge border for the same reason: separate from content without implying the sidebar floats above it).
- **Selected state**: this is the literal case §8.2's "left-edge `moss.60` bar" language was written for — vertically stacked destinations, so the edge bar sits at the true left edge of the selected row, plus the same `moss.10`/`moss.90` wash.
- **Collapsed/expanded**: a collapsed (icon-only) and expanded (icon+label) width state, transitioning via `motion.standard` + Verdant Enter/Exit; the text label fades out as the panel collapses rather than truncating mid-animation with an ellipsis, which would read as a layout glitch rather than an intentional state change.

### 10.12 List
- **Purpose**: the base scrollable unit almost every content screen is built from — a row representing one item in a collection.
- **Shape**: `radius.none` by default, rows presented edge-to-edge and separated by a hairline `stone.20` divider (Level 1's border, not a manually-drawn line) — the quiet, continuous-list posture. A "card list" variant (each row independently wrapped as its own Level 1 `AppCard`, §10.2) is available when rows need independent visual grouping, but is not the default.
- **Depth**: flush at rest; Level 2 only as tap/hover feedback on an interactive row (identical rule to Card's 10.2 hover-only Level 2 — depth as feedback, never decoration).
- **Selected state**: §8.2's edge-bar language, used only when a row represents a *persisted* current selection (e.g. "which settings screen is currently open") — a row that's merely tappable-to-navigate has no persistent wash at rest.
- **Motion**: swipe-to-reveal-actions, where used, animates via `motion.standard`; no rubber-band/bounce beyond whatever the platform's own native overscroll already provides (§8.5).

### 10.13 Table
- **Purpose**: dense, precise tabular data — the one place `radius.none` is not just permitted but required (§5's own table already names data tables as `radius.none`'s primary example).
- **Shape**: `radius.none` throughout — header, rows, and cells all flush and rectangular.
- **Depth**: Level 1 hairline borders between cells/rows (`stone.20`), no shadow; the table as a whole may sit inside its own Level 1 card container.
- **Row states — a named exception to §8.2**: hover is a flat background tint (`stone.10`/`stone.90`) rather than Card's shadow-based Level 2 — a per-row shadow inside a dense grid would look broken, not elegant, so the exception is stated here rather than silently deviating. Selected row: wash only, **no edge bar** — a persistent bar on every selected row in a dense table reads as visual noise; wash alone is sufficient because a table's own gridlines already provide enough structure that an extra indicator bar is redundant, unlike a sparser list.
- **Sort indicator**: a small, static geometric arrow (never an animated icon swap), recoloring on `motion.micro` when its column becomes the active sort.

### 10.14 Chart
- **Purpose**: data communication, not decoration — the single highest-risk component for accidentally introducing saturated, rainbow color where restraint should dominate.
- **Color**: multi-series charts use a controlled sequence built from the *existing* semantic palette — `moss.60`, `mist.60`, `brass.60`, `ember.60`, `stone.60` as the default five-series order — rather than inventing a separate eight-hue categorical chart palette. This extends the "one saturated color, rest neutral" restraint to multi-series data: each semantic color is used once, in its already-established role-adjacent hue, instead of Verdant maintaining two parallel color systems.
- **Shape**: `radius.none` for bars/containers; the chart canvas itself has no rounding.
- **Depth**: flush — a chart sits directly on its containing card's surface, with no separate elevation of its own.
- **Motion**: data enters via a single `motion.standard` + Verdant Enter grow-in (bars rising, a line drawing left-to-right) **once, on first load only** — never a looping or pulsing "live data" animation as a default, and never replayed on rebuild. Respects `disableAnimations` (§8.7) the same as every other Verdant motion: bars simply appear at final height.
- **Tooltip-on-hover** reuses the Tooltip component (§10.21) rather than a chart-specific popup treatment.

### 10.15 Tag
- **Purpose**: a user-manipulable label — filterable, removable, sometimes toggleable — distinct from Badge's read-only status marker. Stated explicitly since the two are easy to conflate: **Badge** = status, read-only, appears wherever a state needs a compact label (§10.6); **Tag** = input, interactive, appears in forms/filters/search contexts.
- **Shape**: `radius.pill` — the same object-like exemption as Badge (§5.3); a tag reads as a small physical token, same register as a badge.
- **Depth**: Level 1 hairline `stone.30` border, unselected/inactive. Selected/active (e.g. an active filter): `moss.10`/`moss.90` wash fill + `moss.60` border.
- **Remove affordance**: a small inline "×" icon; tapping it darkens on `motion.micro`, no swipe-to-dismiss gesture as a default (keeps removal a deliberate tap, not an easily-triggered accidental swipe).

### 10.16 Search
- **Purpose**: fast, low-friction query entry — inherits TextField (§10.3) for shape/depth/error, with one named, deliberate exception to its label rule.
- **Label exception, stated explicitly rather than silently inconsistent**: a search field does not need a persistent static label above it the way other TextFields do — "Search" as a standalone label above a search box is redundant once a leading magnifying-glass icon is present; the icon carries the labeling function instead. This is the one legitimate exception to §10.3's "always a static label" rule, named here so it doesn't read as an overlooked inconsistency.
- **Leading icon**: outline magnifying glass, `stone.60`/`stone.50` at rest, recoloring to `moss.60` on focus — matching the border's own focus recolor (§10.3), so the icon and border always agree about focus state.
- **Clear button**: a trailing "×" appears only once text is present, fading in/out via `motion.micro`.

### 10.17 OTP (one-time code entry)
- **Purpose**: a fixed-length numeric code, one digit per cell — the most literally "printed-form-like" input in the system, each cell a ruled box on a form.
- **Shape**: `radius.xs` per cell; cells arranged in a row with `space.xs` gaps between them, each independently bordered rather than one continuous field.
- **Depth**: Level 1 `stone.30` border per cell at rest; the *currently-focused* cell only gets the 2px `moss.60` focus border (§10.3's focus language, scoped to one cell at a time, never all cells simultaneously).
- **Motion**: auto-advance to the next cell on digit entry is instant, no transition — the digit's own appearance is the only feedback needed.
- **Error state**: all cells' borders shift to `ember.60` together, with one shared helper-text line below in the same `ember.60` — matching TextField's error language (§10.3) rather than inventing a separate one.

### 10.18 Password
- **Purpose**: secure entry with an optional reveal — inherits TextField (§10.3) exactly for shape/depth/label/error, with one addition.
- **Addition**: a trailing icon-button toggling obscured/visible text — an outline "eye"/"eye-off" glyph pair, never a filled-vs-outline toggle (extending §10.4's "never filled-when-active" rule to this control too, for the same reason: that toggle is a recognizable, avoidable tell).
- **States**: the icon briefly recolors to `moss.60` on tap (`motion.micro`) then returns to its `stone.60` rest tone — the icon's *color* does not persistently change to indicate "currently revealed"; the glyph swap (eye vs. eye-off) alone communicates the state, keeping color reserved for its established meanings (§8.3) rather than adding a new one.

### 10.19 Calendar / Date Picker
- **Purpose**: precise date selection — should read like flipping to a page in a physical planner, not a Material date-picker's heavy dialog chrome.
- **Shape**: `radius.md` for the outer floating container (it's a Level 3 popover, matching Dialog's §10.5 shape exactly). A *selected* day cell is `radius.pill` — the same object-like exemption as Switch/Avatar (§5.3): a selected day reads as a small token, unselected day cells have no shape or fill of their own, just text.
- **Depth**: Level 3 — presented as a popover/dialog, full shadow deployment per §6.
- **Today's date**: a `moss.60` **outline** ring (not filled) around the cell — geometrically distinct from a *selected* day's filled treatment, so "today" and "selected" never rely on color intensity alone to be told apart (extending §8.1's "never color-only" principle to this specific ambiguity).
- **Motion**: month navigation (previous/next) cross-fades via `motion.standard` + Verdant Enter/Exit — no horizontal slide-swipe, which would imply a "swipeable card deck" gesture language Verdant doesn't use anywhere else.

### 10.20 Avatar
- **Purpose**: compactly represent a person or entity — one of the few places a photographic image legitimately appears in an otherwise typography/geometry-driven system.
- **Shape**: `radius.pill` (a true circle) by default — the brief's own named example under §5.3's pill exemption.
- **Depth**: flush, no border by default. An optional 2px `stone.20` ring appears only when avatars are shown overlapping in a dense stack ("facepile") — a functional separator so individual avatars stay legible against each other, not decoration.
- **Fallback (no image)**: initials on a `moss.10`/`moss.90` background with `moss.80`/`moss.20` text — one of the few places besides the primary action itself where a moss container appears for a non-status, non-selection purpose, justified because it's functionally identifying "this specific person/entity," the same container role §3.2 already defines for Moss.
- **Sizing**: tied to existing `space` tokens (`space.lg`=24px small, `space.xl`=32px default, `space.2xl`=48px large) rather than a separate avatar-size scale.

### 10.21 Tooltip
- **Purpose**: supplementary, non-essential context on hover/long-press — must never carry information required to complete a task (an accessibility floor, stated as a hard rule, not a suggestion).
- **Shape**: `radius.xs` — a small, precise label, not a soft bubble.
- **Depth**: Level 3 (a true floating overlay), reusing the Level 3 shadow values exactly as defined in §6 rather than inventing a separately-scaled "smaller Level 3" — one treatment per level, system-wide.
- **Color — the one deliberate inversion in the system**: inverse surface (`stone.90` background / `stone.0` text in light mode, mirrored in dark) rather than the normal Stone register every other floating surface uses. A tooltip needs to visually separate from *whatever* surface it appears over, which the normal register can't guarantee; this is named explicitly as the system's one intentional exception, not an inconsistency.
- **Motion**: appears after a short, platform-standard hover delay (not Verdant-authored), then fades in via `motion.micro` + Verdant Enter — opacity only, no slide or scale, the fastest and quietest entrance in the system for its least-critical-information component.

### 10.22 Dropdown / Select
- **Purpose**: choose one value from a closed list, inline in a form — functionally a TextField (§10.3) that opens a Menu (§10.23) instead of accepting free text.
- **Shape / Depth / Label**: inherits TextField exactly for the closed-state trigger — same border, focus-recolor, and static label rules.
- **Open state**: the option list is a Menu (§10.23), anchored below the trigger.
- **Trailing icon**: a small outline chevron, rotating 180° on open via `motion.micro` + Verdant Enter/Exit — the one place a persistent rotation-based icon animation is sanctioned in this spec, because it communicates a literal, binary state (open/closed), not decoration.

### 10.23 Menu (context menu, overflow menu, dropdown options list)
- **Purpose**: a transient list of actions or choices, presented adjacent to whatever triggered it.
- **Shape**: `radius.md` — §5's own table already names "menus, popovers" as this tier's example use.
- **Depth**: Level 3 — floating, full shadow, the same `stone.10`/`stone.95` surface-tone shift as Dialog (§10.5), scaled down to menu size rather than treated as a separate level.
- **Item states — a named exception to §8.2, for the same reason as Table (§10.13)**: hover/focus is a flat background tint (`stone.10`/`stone.90`), no edge bar — a menu item represents a one-shot action, not a persisted selection, so the persistent-selection language doesn't apply here any more than it does in a table row.
- **Motion**: entrance `motion.panel` + Verdant Enter (matching Dialog/Bottom Sheet's overlay-entrance duration, §10.5), exit `motion.standard` + Verdant Exit. Anchored at its trigger point — a menu appears *at* an anchor, it does not slide in *from* a screen edge the way a bottom sheet does.

### 10.24 Scope boundary, restated

Everything in §10.7–§10.23 is **specification only**, matching the v1.1 revision note at the top of this document and §13 point 5's unchanged staging discipline: none of these seventeen components are implemented, and none should be built ahead of a real screen needing them. Building any of them follows the same Fase-1 (anatomy: states/variants) → Fase-2 (golden-tested implementation) process already used for `AppStateView`/`AppLoadingIndicator`/`AppSnackBar`, one component at a time, only when a concrete screen requires it — not as a batch, and not because a full spec now exists for all of them. A complete specification removes ambiguity about *what* to build when the time comes; it is not permission to start building now.

---

## 11. Flutter implementation strategy

- **`AppTheme.light()`/`.dark()`** keep their existing signature (including the `primaryColor`/`spacingMultiplier`/`radiusMultiplier`/`motionSpeedMultiplier` overrides Theme Studio depends on) — implemented in Tahap 1.
- **`ColorScheme` construction** uses the plain `ColorScheme(...)` constructor with every role assigned from Section 3's tables (Section 3.4) — implemented in Tahap 1.
- **`AppShapeExtension`** holds `radiusNone`/`radiusXs`/`radiusSm`/`radiusMd`/`radiusPill` — implemented in Tahap 1; the legacy `radiusLg`/`expressive` bridge fields were removed in Tahap 3 once `AppExpressiveCard` (their last consumer) was redesigned off them.
- **`AppElevationExtension`** exposes explicit named levels (`flush`/`resting`/`lifted`/`floating`) matching Section 6 — implemented in Tahap 1; the legacy numeric `level0`–`level5` bridge fields were removed in Tahap 3 for the same reason as above.
- **`AppMotionExtension`** curve fields hold Section 7's two cubic curves; the `spring` field's *capability* remains, unused by any default component, per §7.1 and §9.2's own reasoning for keeping useful infrastructure that nothing currently reaches for.
- **`AppExpressiveCard`**: redesigned per Section 5.4 in Tahap 3 — implemented and golden-verified.
- **Const widgets, composition over inheritance, adaptive/desktop/tablet/mobile/web, dynamic text scaling, localization, RTL** — none of these are affected by Verdant; they're implementation disciplines already correctly in place (the existing `AdaptiveLayout`/`Breakpoints` infrastructure, the pure-Dart token classes with no platform branches) and Verdant inherits them unchanged.

---

## 12. Anti-pattern critic pass (self-audit, as instructed)

Applying the brief's own three questions to the biggest identity levers in this spec — checked individually against each named kit from the brief's own anti-pattern list, not a single generic "another kit" column:

| Decision | Material? | Tailwind UI? | Bootstrap? | Ant Design? | Fluent? | Premium in 2035? |
|---|---|---|---|---|---|---|
| Hand-authored `ColorScheme`, no `fromSeed` | No — this is the specific mechanism that makes something read as Material | No — Tailwind UI's palette is a flat, generic slate/indigo/emerald set with no natural-material tracing | No — Bootstrap's palette is named by role only (primary/secondary/success/danger), no material reference at all | No — Ant Design's blue-dominant palette (`#1890ff`-adjacent) is a distinct, recognizable "enterprise dashboard" signature Verdant's green-restrained palette doesn't share | No — Fluent's Segoe-adjacent palette leans cool-blue/acrylic, the opposite of Stone's warm-neutral base | Yes — hand-authored, considered palettes don't date the way algorithmic ones tied to one era's color science do |
| `radius.xs` default, pill reserved for object-like cases only | No — opposite of M3's soft-default posture | No — Tailwind UI defaults to `rounded-lg`/`rounded-xl` (8–12px) almost everywhere, closer to Material's soft posture than Verdant's | No — Bootstrap's own default (0.375rem/6px) is closer, but most real Bootstrap themes trend pill/rounded on buttons specifically | No — Ant Design's ~6px default ships wrapped in heavier borders and default shadows Verdant doesn't use | No — Fluent's rounded-corner-plus-acrylic/reveal-highlight combination is a distinct, recognizable "Windows 11" signature | Yes — precise, architectural corners read as intentional regardless of trend cycles |
| No shadow at Level 1 (most of the screen) | No — Material shows a shadow by default at nearly every elevation | Partially close — Tailwind UI's minimal card variants also favor border-over-shadow at rest; acceptable, since restraint itself isn't ownable, only the specific palette/type/motion combination is | No — Bootstrap cards default to a shadow utility class in most real-world usage | No — Ant Design cards default to a visible `box-shadow` at rest | No — Fluent's "reveal" and acrylic effects are inherently shadow/blur-heavy | Yes — quiet depth ages better than trend-driven shadow styles (neumorphism, glassmorphism) |
| No spring/bounce as default motion | No — bounce-on-interaction is common in Material You | No | No | No | No — Fluent's "connected animations" and motion library lean toward physics-driven transitions | Yes — restrained motion doesn't feel dated the way a specific "spring feel" from one era of app design does |
| `AppExpressiveCard` as originally built (pre-Tahap-3) | **Yes — failed, retired and redesigned (5.4)** | — | — | — | — | — |

### 12.1 Non-framework anti-pattern checklist

The brief's own anti-pattern list also named a set of generic UI failure modes independent of any specific competitor kit — every one of them is already a rule stated somewhere else in this document; this table exists so a reviewer can check a new component against *one* scannable list instead of eight scattered sections individually. It consolidates, it doesn't introduce new decisions.

| Anti-pattern (brief's own list) | Verdant's rule | Where specified |
|---|---|---|
| Random/unnecessary gradients | None anywhere in the default vocabulary — every surface is a flat, single Stone/Moss/semantic-color fill; no gradient primitive exists in the palette at all | §3 |
| Oversized/decorative shadows | Shadow only at Level 2 (barely visible, interaction-feedback-only) and Level 3 (true overlays) — zero shadow at Level 1, where most of the screen lives | §6 |
| Inconsistent radius | Exactly five radius tiers, each with a stated rule for which components use it — no ad hoc per-screen radius values | §5, §5.1 |
| Visual noise (unnecessary borders/dividers/decoration) | A border exists only as a stated depth-level signal (§6) or a rhythm divider (§4.2) — never decoration for its own sake | §6, §8.3 |
| Decorative/attention-getting animations | Motion plays only in response to a state change, never to attract attention or as an idle/looping effect — no shimmer, no pulse, no scroll-triggered decoration | §7, §8.5 |
| Unnecessary colors ("rainbow" UI) | One saturated color (moss) for the single primary action; every other color has a specific semantic role (danger/warning/info) or is neutral | §3, §8.3 |
| Generic/inconsistent iconography | Outline-style, single-weight icons system-wide — never a filled/outline toggle for state (§10.4's own named anti-pattern), never mixed icon families on the same screen | §10.4 |
| Inconsistent spacing | A single `space` scale, one token per relationship, enforced as a rule, not an aspiration | §4, §4.2 |

---

## 13. Decisions log

All five original open decisions are now resolved; kept here as a record, matching how ARCHITECTURE.md's ADR log treats superseded/settled decisions rather than erasing them once closed.

1. **`AppExpressiveCard`** — ~~retire, or redesign under the quiet-border-shift mechanic sketched in 5.4?~~ **Resolved**: redesigned under the border-shift mechanic (§5.4), implemented and golden-verified in Tahap 3.
2. **Typeface** — ~~keep Plus Jakarta Sans, or revisit?~~ **Resolved**: kept (Section 0).
3. **`docs/DESIGN_LANGUAGE.md`** — ~~archive or remove?~~ **Resolved**: archived as historical record, not deleted.
4. **Rollout scope** — ~~tokens + 6 detailed components first, or something else?~~ **Resolved**: tokens (Tahap 1) + 6 components (Tahap 2) + `AppExpressiveCard` (Tahap 3), all now implemented.
5. **Component anatomy for the remaining components list** — ~~build ahead, or build-on-demand?~~ **Resolved**: build-on-demand only, per real screen need — unaffected by this revision's addition of full specifications for all of them (§10.24's own restated boundary).

**What this revision does not do**: it does not open new implementation decisions. The next decision — which, if any, of §10.7–§10.23's now-fully-specified components has real, evidenced demand in `flutter_starter_kit` or `akujamin-v2` today — is deliberately left for your review of this document in full, not pre-empted here.

---

## 14. Typography

**v1.2 revision note**: a full brief-vs-document comparison found this document had no Typography section at all — every existing reference to "Section 3's scale" (§8.3, former §10.1) was a broken cross-reference, since Section 3 is Color, not type. This is a genuine gap, not a stylistic choice: the brief named typography a *primary design element*, on equal footing with color, and restraint everywhere else in this system (one saturated color, minimal shadow, no spring motion) means typography has to carry *more* of the hierarchy-communication load than in a more decorated system, not less — §8.3 already assumed this section existed when it was written ("achieved primarily through Section 3's typography weight/size/spacing"). Placed here as a new top-level section rather than inserted between Color and Spacing, for the same reason ARCHITECTURE.md appends new sections at the end instead of renumbering: this document already has dozens of internal `§N`/`Section N` cross-references, and renumbering everything downstream of an inserted "new Section 3" risks silently breaking references the same way the ones this revision fixes were silently broken. Every stale "Section 3" typography reference elsewhere in this document now points here.

### 14.1 Type scale

The full 15-slot Material 3 type scale (Display/Headline/Title/Body/Label × Large/Medium/Small) — not designed fresh here, but pulled directly from `AppTheme._baseTextTheme` (`packages/design_system/lib/src/theme/app_theme.dart`), which already carries this exact scale forward from the pre-Verdant `AppTypography` class per that file's own doc comment. Four slots carry an explicit brand override (differing from M3's own 2021 baseline in size and/or weight); the other eleven use M3's baseline values as-is. Letter-spacing and line-height are **not** Verdant-authored at any slot — see the note after the table.

| Slot | Size | Weight | Letter-spacing | Line-height | Status | Primary use |
|---|---|---|---|---|---|---|
| `displayLarge` | 57px | 400 (regular) | −0.25 | 1.12× | M3 baseline | Reserved — largest hero text; rarely used in this kit's screen types |
| `displayMedium` | 45px | 400 | 0.0 | 1.16× | M3 baseline | Reserved — large hero text |
| `displaySmall` | 36px | 400 | 0.0 | 1.22× | M3 baseline | Reserved — landing/empty-state hero text |
| `headlineLarge` | 32px | **700 (bold)** | 0.0 | 1.25× | **Brand override** (M3: 400) | Page-level titles, on the rare screen that needs one |
| `headlineMedium` | **24px** | **600 (semibold)** | 0.0 | 1.29× | **Brand override** (M3: 28px/400) | Section headers |
| `headlineSmall` | 24px | 400 | 0.0 | 1.33× | M3 baseline | Secondary section headers |
| `titleLarge` | **20px** | **600** | 0.0 | 1.27× | **Brand override** (M3: 22px/400) | AppBar/screen titles, Dialog titles (§10.5) |
| `titleMedium` | 16px | 500 (medium) | 0.15 | 1.50× | M3 baseline | Card titles, list-item primary text |
| `titleSmall` | 14px | 500 | 0.1 | 1.43× | M3 baseline | Compact card/list titles |
| `bodyLarge` | 16px | 400 | 0.5 | 1.50× | M3 baseline | Primary reading text, form field content |
| `bodyMedium` | 14px | 400 | 0.25 | 1.43× | M3 baseline | Default body text — the most-used slot in the system |
| `bodySmall` | 12px | 400 | 0.4 | 1.33× | M3 baseline | Secondary/muted body text, helper text |
| `labelLarge` | 14px | 500 | 0.1 | 1.43× | M3 baseline | Button labels (§10.1 — confirmed via `ElevatedButton`'s own default `textTheme.labelLarge` resolution, Tahap 2) |
| `labelMedium` | 12px | 500 | 0.5 | 1.33× | M3 baseline | TextField static labels (§10.3), tab labels (§10.10) |
| `labelSmall` | **12px** | 500 | 0.5 | 1.45× | **Brand override** (M3: 11px) | Badge/Tag text (§10.6/10.15), timestamps, dense metadata |

**Letter-spacing and line-height are inherited from M3's `Typography.material2021()` defaults, not Verdant-authored, at every slot** — `_baseTextTheme` only ever sets `fontSize`/`fontWeight` per slot; Flutter's `ThemeData` construction merges an unset `TextTheme` field in from its Material default (`defaultTextTheme.merge(textTheme)`, verified directly in the Flutter SDK's `theme_data.dart` while writing this section, not assumed). §14.2 explains why this is a considered decision, not an oversight.

### 14.2 Why these specific weights, sizes, and tracking values

Each override (and each *non*-override) below is checked against the brief's own "premium book / financial report / technical documentation" reference — a checkable feel, not a vibe.

- **Display tier untouched.** This kit's actual screens (mobile-first app UI, not marketing/landing pages) rarely need 36–57px hero text. Keeping M3's own well-tested proportions here avoids inventing untested large-scale numbers for a tier that gets little real use — the same "don't build for hypothetical need" discipline §13 point 5 already applies to components, applied here to type sizes instead.
- **Headline tier bolder (700/600 vs. M3's uniform 400).** A page or section title needs to anchor the page the way a chapter heading anchors a page in a printed report. M3's uniform 400-weight headline reads as "big text," not "a considered heading" — the added weight, not just the size, is what makes the hierarchy legible; checkable by placing `headlineLarge` next to `bodyLarge` and confirming the weight difference alone communicates rank even if the size difference were somehow removed.
- **`headlineMedium` trades size for weight (24/600 vs. M3's 28/400).** The brief's "financial report" reference doesn't use oversized headers, it uses confident, well-weighted ones. A 28px/400 header consumes more vertical rhythm (§4.2) than a 24px/600 one for comparable visual presence — the same trade-off the radius scale makes (§5: precise and small over soft and generous), applied to type.
- **`titleLarge` makes the same trade one tier down (20/600 vs. M3's 22/400).** This is the slot AppBar and Dialog titles (§10.5) actually use in a real app — the size a user sees constantly — so "confident, not shouting" matters most here.
- **`labelSmall`'s single-point size increase (12px vs. M3's 11px) is the one override that goes the opposite direction — larger, not bolder or smaller.** M3's 11px is used for badges/tags/timestamps (§10.6/10.15), text small enough that legibility, not identity, is the binding constraint — 11px renders uncomfortably small for Plus Jakarta Sans (or most humanist sans faces) at typical mobile pixel densities. This override exists for **readability**, distinct from the other three, which exist for **identity**.
- **Every other slot (Body, `titleMedium`/`Small`, `labelLarge`/`Medium`) keeps M3's numbers exactly.** These are the tiers used most often and most invisibly — legibility and restraint are the goal, and M3's own figures (built on real accessibility/legibility research) already deliver that. Overriding them for the sake of having an override would be change for its own sake, contradicting §1's manifesto that every decision has a stated reason.
- **Letter-spacing and line-height stay M3's own curve, system-wide — a decision, not an omission.** M3's tracking already does the job the brief asks for: tighter (negative-to-zero) tracking on display/headline text reads as confident and editorial, the same convention real magazine mastheads and financial-report headers use; looser tracking (0.25–0.5) on small body/label text improves legibility at small sizes, the same convention fine print and dense data tables use. Verdant's identity problem was never in these numbers — the Material "tell" lives in color/shape/depth/motion (§0), not in a well-tested tracking curve — so there's no reason to replace it with an invented one. This is the same "borrow a well-tested utility constant" reasoning §9.1 already applied to the modal scrim's 54% opacity. A future revision proposing Verdant-specific tracking values should meet the same bar every other decision in this document does: a stated, checkable reason per value, not a default action taken here for its own sake.

### 14.3 WCAG and dynamic text scaling (`MediaQuery.textScaler`)

- **Line-height is scale-safe by construction.** Every value in §14.1's Line-height column is a unitless multiplier of that slot's own font size (Flutter's `TextStyle.height`), not a fixed pixel value — when `MediaQuery.textScaler` scales font size up (an OS-level "larger text" accessibility setting), line spacing scales proportionally with it automatically. This is true throughout the type scale by construction; it didn't need a separate decision.
- **The real, checkable risk is layout, not type.** Text scaling itself is already solved by Flutter/M3; what actually breaks under a large `textScaler` value is a component with a *hard-coded* height or width wrapped around text that doesn't grow with it — a button with a fixed-height box, an OTP cell (§10.17) with a fixed square size, a Badge (§10.6) with a fixed pill height. The rule, stated as a rule: **every Verdant component's dimensions around text must be intrinsic (grow with content) by default; a fixed dimension is acceptable only with an explicit, stated reason, and must be verified not to clip text at 200% `textScaler`** (the standard upper bound accessibility testing checks against, matching WCAG 2.1 success criterion 1.4.4 — "text can be resized up to 200% without loss of content or functionality").
- **Verified, not assumed — `packages/design_system/test/accessibility/text_scaling_test.dart`.** All six Tahap 2 components were pumped at `TextScaler.linear(2.0)` with realistic-to-adversarial content and checked for layout-overflow exceptions (Flutter's concrete clipping signal). Button, Card, TextField (both default and error state), Dialog, Bottom Sheet, SnackBar, and Badge all pass with no overflow. **One real bug was found and fixed in the process**: `AppNavigationBar`'s destination cells used a fixed `SizedBox(height: 64)` — safe for this kit's actual two short destination labels ("Home"/"Profile") even at 200% scale, but a genuine `RenderFlex overflowed by 34 pixels` at a narrower small-phone width (320px) with four longer destination labels ("Home"/"History"/"Settings"/"Profile"), a realistic near-future case. Fixed by replacing the fixed height with `ConstrainedBox(minHeight: 64)`, letting the bar grow taller instead of clipping when content needs more room — matching this section's own rule rather than being an exception to it. The fix is golden-verified (§14.1's identity is unaffected — same shape, same edge-bar/wash selection language, only the layout mechanism producing the height changed) and the regression is now guarded by a permanent test, not just a one-time finding.
- **This makes concrete, for typography specifically, the same floor §8.7 already set for color contrast**: WCAG 2.1 AA is the floor, not the target, throughout Verdant.
- **Minimum size**: `labelSmall`'s 12px (§14.1) is the smallest text size anywhere in the default scale. Verdant does not go below it for any real content — a legibility floor held consistently rather than letting individual components invent smaller ad hoc sizes.

### 14.4 Two related token questions, answered per the same pattern as §9

- **Border tokens as a scale separate from Radius — decision: no.** The system has exactly two border widths in use anywhere: 1px (hairline, Level 1/resting — §6) and 2px (emphasis — focus rings §9.3, TextField focus §10.3, OTP focus §10.17). Both are already fully specified inline at their point of use, and both are pinned to a specific structural meaning rather than being an independent design lever a future theme would plausibly want to retune the way a color or spacing value gets retuned. Inventing an `AppBorderExtension` for a two-value, already-fixed-meaning constant set would add indirection without a real retheming use case behind it — the same reasoning §9.2 already applied to Interaction tokens (not every repeated value needs its own scale; some are correctly expressed as documented constants at their point of use).
- **A dedicated non-framework anti-pattern checklist — decision: yes, worth building.** Unlike Border tokens, this doesn't invent new design decisions — every item below is already a rule stated somewhere else in this document. What's missing is a single, scannable checklist a reviewer can run a new component against, instead of checking it against eight scattered sections individually. Added as §12.1.

---
