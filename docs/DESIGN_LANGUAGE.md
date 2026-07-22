# Design Language

> **ARCHIVED.** Kept in place as historical record (same pattern
> ARCHITECTURE.md's ADR log uses for superseded decisions — not deleted,
> not treated as current). This document briefly gave way to a fully
> custom visual identity ("Verdant") built directly on top of this
> package; that identity later outgrew being a starter kit's internal
> component library and was extracted to its own standalone project. This
> repo's `design_system` reverted to a plain, unbranded baseline
> (`ColorScheme.fromSeed`, standard Material icons) rather than returning
> to the specific "confident, warm, precise" personality described below —
> so neither this document nor its successor currently describes
> `design_system`'s actual palette/shape/motion. Treat both as history,
> not current spec.

This document is the character brief every `design_system` component inherits
from. It exists so future component decisions (Fase 1 anatomy, new widgets,
Widgetbook customization) have a consistent reference to check against instead
of being decided ad hoc, one component at a time.

It is derived from decisions already made and shipped in this codebase (seed
colors, the ThemeExtension token set, `AppExpressiveCard`'s shape/motion
choices — see [ARCHITECTURE.md §16](../ARCHITECTURE.md)) plus the real-world
domain the design system serves: an identity-verification, psychological
assessment, counseling, and payment flow (evidenced in `akujamin-v2` — KTP/
selfie registration, proctored testing, psychologist chat, payment). Every
claim below is grounded in one or the other; nothing here is invented from
scratch.

## 1. Personality

**Percaya diri, hangat, presisi** — confident, warm, precise.

Three words, each earning its place from a different part of what this system
already does or must do:

- **Confident** — the product asks users to hand over identity documents
  (KTP), a selfie, and payment details. A hesitant, timid visual language
  undermines trust exactly where trust matters most. Evidence this is already
  the direction: the seed color `0xFF2D6CDF` ([`app_theme.dart:20`](../packages/design_system/lib/src/theme/app_theme.dart:20))
  is a saturated, assertive mid-blue, not a pastel; the type scale already
  overrides M3's default weights upward — `headlineLarge` w700 vs M3's w400,
  `titleLarge` w600 vs M3's w400 ([`app_theme.dart:33-53`](../packages/design_system/lib/src/theme/app_theme.dart:33)) — a decision
  made before this brief existed, which this brief now makes intentional
  instead of incidental.
- **Warm** — the same product also carries a psychological-counseling flow
  (chat with a psychologist, results delivery) where a cold, purely clinical
  interface works against the product's purpose. Evidence: the radius scale
  is moderately rounded across the board (8/12/16px, see §4) rather than
  sharp M3-default corners; `AppSemanticColors` gives warning/success/info
  their own distinct hues rather than reusing raw `colorScheme.error`/
  `.tertiary` ([`app_semantic_colors.dart`](../packages/design_system/lib/src/tokens/app_semantic_colors.dart)) — a small
  but deliberate choice to speak to the user in specific, human terms instead
  of generic M3 roles.
- **Precise** — KTP data extraction, test scoring, and payment amounts all
  have zero tolerance for ambiguity. Evidence: `AppSemanticColors` is
  WCAG 2.1 AA-contrast-enforced by an actual test
  (`test/tokens/app_semantic_colors_test.dart`), and `AppMotionExtension`'s
  spring is explicitly tuned to not overshoot ("not too bouncy... a status
  badge or card shouldn't wobble", [`app_motion_extension.dart:29-31`](../packages/design_system/lib/src/tokens/app_motion_extension.dart:29)) —
  restraint is already a written design decision, not just an absence of
  effort.

Every subsequent decision in this document — and every component built after
it — should be checkable against these three words. If a choice doesn't serve
at least one of them, it doesn't belong.

## 2. Typography

**Plus Jakarta Sans** (variable), replacing the platform default.

This is the highest-visual-impact, lowest-cost change available: swapping the
font family changes the feel of every screen without touching a single
layout, spacing, or color decision already made.

### Candidates considered

| | Plus Jakarta Sans | Manrope |
|---|---|---|
| License | SIL Open Font License 1.1 | SIL Open Font License 1.1 |
| Variable axis | `wght` 200–800 (ExtraLight–ExtraBold) | `wght` 200–800 (ExtraLight–ExtraBold) |
| Italics | True italics, distinct design per weight | No italic family |
| Character | Geometric with warm, distinctive details (rounded terminals on `a`, `t`) | Purely geometric, semi-condensed, neutral/technical |
| Designer | Gumpita Rahayu / Tokotype (commissioned for Jakarta's city branding, 2020) | Mikhail Sharanda; variable conversion by Mirko Velimirovic (2019) |

Both are free, both are variable (so the existing 6 brand-weight overrides —
w400 through w700 — are all a single font file, not six static assets), both
are safe under the "no fragmented token-generator dependency" constraint
because this is just a font file, not a build-time tool.

**Chosen: Plus Jakarta Sans.** It scores on all three personality words at
once — geometric structure reads as *precise*, but the distinctive rounded
details keep it from feeling *cold*, closing the gap Manrope leaves on
*warm*. Manrope is the more purely technical/neutral choice of the two — a
reasonable pick if the brief had settled on "precise" alone, but this brief
didn't. True italics are a minor extra: not used anywhere in the app today,
but free future flexibility Manrope doesn't offer.

### Implementation (done, quick win)

- Added `google_fonts: ^8.2.0` to `packages/design_system/pubspec.yaml`.
- [`app_theme.dart`](../packages/design_system/lib/src/theme/app_theme.dart) now builds `_textTheme` via
  `GoogleFonts.plusJakartaSansTextTheme(_baseTextTheme)` — `_baseTextTheme` is
  the exact same 15-slot `TextTheme` as before (unchanged sizes/weights), the
  font family is the only thing that changed.
- **Disclosure**: `google_fonts` fetches the font file over the network on
  first use per device and caches it locally afterward. If the device is
  offline on first launch, the package falls back to the platform default
  font rather than failing — the app never crashes or blocks on this. If the
  team later wants a hard guarantee of zero network calls (e.g. for a
  fully-offline build), the same package supports bundling the `.ttf` as a
  static asset instead; that's a follow-up, not required for this change.

## 3. Color philosophy

**Moderately saturated, not muted/pastel and not neon/vibrant** — confident
enough to feel trustworthy, restrained enough to feel precise.

The seed colors already establish this: `0xFF2D6CDF` (light) and `0xFF9AB6FF`
(dark) are clearly-colored, medium-saturation blues — nowhere near a
desaturated "muted" palette (which would undercut *confident*), nowhere near
a neon/saturated-to-the-max palette (which would undercut *precise*).

**Light and dark share one hue family, but each mode has its own tonal
weight** — this is already the pattern `AppSemanticColors` set for
warning/success/info, and this brief makes it the explicit rule for all
current and future color tokens, not a one-off:

- **Light mode reads "grounded."** Semantic tones are deep and saturated —
  `success` `0xFF1B5E20`, `warning` `0xFF8A5300`, `info` `0xFF1565C0` — dark
  enough to sit confidently against a light surface.
- **Dark mode reads "lifted."** The same three roles become brighter,
  lighter tones — `success` `0xFF81C784`, `warning` `0xFFFFD54F`, `info`
  `0xFF90CAF9` — energized rather than washed out against a dark surface.
- Both modes use the *same hue* per role (green stays green, amber stays
  amber, blue stays blue) — so switching themes never feels like a different
  product, only a different lighting condition on the same one.

**Rule for future tokens**: any new color token must supply both a light and
a dark value that share hue but differ in the deep/lifted way above — never
reuse the exact same hex in both modes (that's how the existing tokens
already behave; this is just naming the rule so it survives past the people
who made the original choice).

## 4. Shape philosophy

**The radius scale is the consistent family resemblance; `expressive`
asymmetric shape stays a deliberate exception, not a default.**

Two shape tokens already exist in [`app_shape_extension.dart`](../packages/design_system/lib/src/tokens/app_shape_extension.dart) and this
brief keeps them doing two different jobs:

- **`radiusSm`/`radiusMd`/`radiusLg`/`radiusPill`** (8/12/16/999px) —
  moderate, uniform rounding. This is the *warm* signal that should show up
  everywhere: buttons, text fields, cards, dialogs, badges. Rounded enough to
  feel approachable, restrained enough (nowhere near a 24px+ "bubble" look)
  to stay *precise* and not read as playful/toy-like — a serious app about
  identity and psychological assessment shouldn't look like a children's app.
- **`expressive`** (asymmetric 24/8/8/24 corners) — reserved *only* for
  components where a user directly manipulates something and the shape-morph
  reinforces that physical feedback. This is already how it was scoped
  during the earlier audit: `AppExpressiveCard` earned it because it has a
  genuine interactive affordance; `HomeItemCard` was explicitly denied it
  because its tap does nothing yet, and applying the shape there would have
  been a *false affordance* — decoration promising interactivity that isn't
  there. This brief makes that precedent the permanent rule: **`expressive`
  requires a real, functioning interaction to justify it. It is not a
  "flagship card" decoration — it's a response to touch.** Every future
  component must pass that same test before reaching for `expressive`, not
  just be judged "important enough" to deserve it.

## 5. Motion character

**Rule: spring is for the user's finger, curves are for everything else.**

`AppMotionExtension` already has both a spring (mass 1, stiffness 300,
damping 20 — tuned deliberately non-bouncy, see [`app_motion_extension.dart:29-32`](../packages/design_system/lib/src/tokens/app_motion_extension.dart:29))
and two curves (`curveStandard` = `easeInOut`, `curveEmphasized` =
`easeInOutCubicEmphasized`). What was missing was a rule for which one a new
component should reach for — this brief sets it:

- **Use `spring`** when the animation is the direct, immediate consequence of
  a gesture still happening or just completed on that exact element — a tap
  feedback, a drag, a press-and-release shape/scale response. The physicality
  of a spring reads as "this object is responding to you," which only makes
  sense when there's a *you* to respond to in that instant. This is exactly
  how `AppExpressiveCard` already uses it (spring on tap).
- **Use `curveStandard`/`curveEmphasized`** for everything else: state
  changes the system initiates on its own timeline rather than the user's
  hand — content appearing after a loading state, a snackbar sliding in, a
  page transition, a dialog opening. A spring on these would look erratic
  rather than responsive, because there's no gesture for it to be a response
  *to*. `curveStandard` is the default; reach for `curveEmphasized` only when
  a transition specifically wants to draw attention (e.g. an error
  appearing) rather than pass by quietly.
- **Rule of thumb**: if the user's finger is still on the screen (or just
  left it) when the animation starts, use `spring`. Otherwise, use a curve.

This rule is what Fase 1's component anatomies will be checked against when
deciding each new component's motion behavior — not a case-by-case guess.
