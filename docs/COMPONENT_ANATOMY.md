# Component Anatomy — Fase 1

Systematic anatomy for the three components the component-gap audit
justified (see `ARCHITECTURE.md` ADR-017 for the evidence each one is
grounded in). Each section covers every state/variant the component needs
and, explicitly, how it expresses the character named in
[docs/DESIGN_LANGUAGE.md](DESIGN_LANGUAGE.md) — **confident, warm,
precise** — not just its functional parameter list. `AppStateView` is
already implemented (its anatomy below documents what shipped, and why);
`AppLoadingIndicator` and `AppSnackBar` are anatomy-only, code pending a
separate confirmation before Fase 2.

## 1. `AppStateView` (implemented)

### States

| State | Trigger | Visual marker | Text color |
|---|---|---|---|
| Empty/neutral | `icon` set, `loading: false`, `tone: neutral` (default) | Static icon, `colorScheme.outline` | Default `bodyLarge` |
| Loading (labelled) | `loading: true` | `CircularProgressIndicator` in place of icon | Default `bodyLarge` |
| Error | `tone: error` | Icon (if set) tinted `colorScheme.error` | `colorScheme.error` |
| No marker | `icon: null`, `loading: false` | None — message (+ optional action) only | Per `tone` |

### Variants (orthogonal to state)

- **With action** — `actionLabel`+`onAction` both set → `AppButton` appended below the message.
- **Without action** — either omitted → no button, message is the last element.

Every state × both action variants is a valid, real combination (all 8 are
covered by golden tests: 2 action-variants × 2 tone/loading-relevant cases
× light/dark — see `test/golden/app_state_view_golden_test.dart`).

### Expressing "confident, warm, precise"

- **Confident**: the error variant doesn't hide behind a muted gray —
  it commits fully to `colorScheme.error` on both icon and message, the
  same assertive signal a user already sees on failed form fields
  elsewhere in Material 3. A wishy-washy "maybe something went wrong" gray
  state would undercut trust exactly where an identity/payment-adjacent
  app needs it most.
- **Warm**: the spinner and icon are never presented cold/bare — they're
  always paired with a plain-language message (`Text`, not an error code),
  and the layout is centered with generous `context.spacing.lg` padding
  around the whole block rather than packed to an edge. The action button,
  when present, uses `AppButton`'s already-rounded shape, not a flat
  system default.
- **Precise**: exactly one visual marker at a time (icon *or* spinner,
  never both, enforced by the `loading` bool taking precedence in `build`)
  — no ambiguity about what state is being shown. Color tinting is binary
  (`neutral`/`error`), not a gradient of severities that would need a
  legend to interpret.

## 2. `AppLoadingIndicator` (anatomy only — not yet built)

**Evidence**: `Center(child: CircularProgressIndicator())`, bare (no
label), repeated identically 17× across this kit (Home/Profile) and
`akujamin-v2` (about/history/certificate/counseling-list/chat/register/
otp-login/payment ×4/test/onboarding). See ADR-017.

### States

There is exactly one state — this component has no branching behavior.
That's the point: it's a *naming and consistency* device, not a
state-machine. (Contrast with `AppStateView`, which genuinely branches.)

### Variants

- **Default** — the only variant for the initial build. No size/color
  parameters, because no observed occurrence varies size or color; adding
  either now would be building for a hypothetical need the evidence
  doesn't support (same discipline `AppExpressiveCard` was held to for
  `HomeItemCard`).

### Expressing "confident, warm, precise"

Deliberately the *least* expressive of the three components — a loading
state is a passing moment, not a place to editorialize. Its contribution
to "confident" is negative-space: it doesn't jitter, doesn't resize, uses
the ambient `colorScheme.primary` (already assertive) without
embellishment. Motion character (docs/DESIGN_LANGUAGE.md §5) applies by
*omission* here too — a spinner is CircularProgressIndicator's own
built-in rotation, not something this component adds spring/curve
behavior to.

### Draft API

```dart
class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) =>
      const Center(child: CircularProgressIndicator());
}
```

## 3. `AppSnackBar` (anatomy only — not yet built)

**Evidence**: 6 raw `ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(...)))` call sites in `akujamin-v2` (login/register/payment/test ×2/payment_method_view), all visually identical regardless of whether the message was an error, a warning, or a copy-confirmation. This kit's own `login_page.dart` already hand-rolls `colorScheme.error`/`.onError` styling for its one failure snackbar — real precedent for tone-specific styling, just not reusable yet. See ADR-017.

### States

A `SnackBar` has no internal states of its own (it's a transient overlay,
not a persistent widget) — the "states" that matter here are which
**tone** was requested, since that's what determines styling.

### Variants (tone)

| Tone | Background | Text | When |
|---|---|---|---|
| `error` | `colorScheme.error` | `colorScheme.onError` | A request/action failed |
| `success` | `context.semanticColors.success` | `.onSuccess` | An action completed (e.g. "Nomor rekening berhasil disalin") |
| `info` (default/neutral) | Theme default (unstyled `SnackBar`) | Theme default | Anything that isn't success/failure — matches today's undifferentiated behavior for the non-error cases, so adopting this doesn't force every call site to pick a tone it doesn't have evidence for |

Only `error` and `success` get explicit color treatment — `warning` isn't
included because no evidenced snackbar occurrence used it (the pattern
found was binary: something failed, or something succeeded; nothing in
the audit showed a "heads up, non-blocking" snackbar case). Adding a
`warning` variant now would be speculative, not evidence-based.

### Expressing "confident, warm, precise"

- **Confident**: `error`'s full-`colorScheme.error` fill (not a subtle
  left-border accent) makes failure impossible to miss — a snackbar that
  undersells an error contradicts an app whose users need to trust it with
  identity documents and payments.
- **Warm**: `success` gets its own color (not just "not red"), so a
  completed action reads as a small, genuine acknowledgment rather than
  silence-by-default. This mirrors why `AppSemanticColors` gave
  warning/success/info distinct hues in the first place instead of
  reusing raw M3 roles (docs/DESIGN_LANGUAGE.md §1).
- **Precise**: exactly three tones, no ambiguity about which one to reach
  for (a request either failed, succeeded, or is neither — every call site
  in the evidence maps cleanly onto one of the three).

### Draft API

```dart
class AppSnackBar {
  const AppSnackBar._();

  static void showError(BuildContext context, String message) {
    final c = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: c.error,
        content: Text(message, style: TextStyle(color: c.onError)),
      ),
    );
  }

  static void showSuccess(BuildContext context, String message) {
    final c = context.semanticColors;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: c.success,
        content: Text(message, style: TextStyle(color: c.onSuccess)),
      ),
    );
  }

  static void showInfo(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
```

`login_page.dart`'s existing bespoke error-SnackBar styling becomes a
one-line `AppSnackBar.showError(context, failure.message)` call once this
lands — noted as a follow-up simplification, not a new obligation.

---

Anatomy only — no code from this document has been written yet for
`AppLoadingIndicator`/`AppSnackBar`. Waiting for confirmation before Fase
2 (implementation + golden tests + Widgetbook use-cases) for those two.
