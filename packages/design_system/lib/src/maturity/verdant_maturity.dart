/// Marks a `design_system` widget as **stable**: born from a real, cited
/// consumer need (VERDANT_DESIGN_SYSTEM.md §0.1/§13), the same evidence
/// bar Tahap 2's six components were held to — not just implemented from
/// the written specification. A stable widget's public API follows this
/// repo's normal "don't break existing callers" discipline like any other
/// public class in this kit.
///
/// See VERDANT_DESIGN_SYSTEM.md §15 ("Maturity levels") for the full
/// convention this annotation is half of.
class VerdantStable {
  const VerdantStable();
}

/// Marks a `design_system` widget as **preview**: implemented directly
/// from VERDANT_DESIGN_SYSTEM.md's specification (§10.7–§10.23) without a
/// real, cited consumer yet.
///
/// **What this means for a project built from this kit**: the widget is
/// fully implemented and golden-tested, not a stub — but its public API
/// may still change if the first real consumer surfaces a gap the
/// written spec didn't anticipate. This is not the same stability
/// promise [VerdantStable] carries; treat a breaking change to a preview
/// widget as expected maintenance, not a bug in this kit.
///
/// See VERDANT_DESIGN_SYSTEM.md §15 ("Maturity levels") for the full
/// convention this annotation is half of.
class VerdantPreview {
  const VerdantPreview();
}

/// Shorthand instance so call sites read `@verdantStable` rather than
/// `@VerdantStable()` — the same ergonomic pattern `package:meta` uses
/// for `@immutable`/`@internal`.
const verdantStable = VerdantStable();

/// Shorthand instance — see [verdantStable].
const verdantPreview = VerdantPreview();
