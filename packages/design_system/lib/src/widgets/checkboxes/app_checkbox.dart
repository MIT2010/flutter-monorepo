import 'package:flutter/material.dart';

import '../../icons/verdant_icons.dart';
import '../../maturity/verdant_maturity.dart';
import '../../shape/verdant_notched_border.dart';
import '../../theme/app_theme_context.dart';

/// A binary, independent choice — one of possibly several selected at once,
/// as opposed to [AppRadio]'s mutually-exclusive single choice (§10.7).
///
/// `radius.xs` square — the deliberate shape distinction from Radio's
/// circle, so the two are never shape-ambiguous at a glance. Unselected:
/// Level 1 `stone.30`/`outlineVariant` border, no fill (same "stone.30 ==
/// outlineVariant" mapping [AppTag] already established). Checked/
/// indeterminate: filled `moss.60`/`primary`, no border — filled color
/// alone carries enough weight, the same rule as a primary Button (§10.1).
/// Hover darkens the border one Stone step: `outlineVariant` → `outline`,
/// the standard M3 role pairing for "subtle" vs. "prominent" border.
///
/// The glyph appears via a quick fade/scale (`motion.micro`, Verdant
/// Enter) through [AnimatedSwitcher] — never an animated stroke-draw-in,
/// which is why this is hand-built rather than wrapping stock [Checkbox]:
/// Flutter's own `_CheckboxPainter` bakes in exactly the stroke-draw
/// animation §10.7 explicitly rejects, with no public API to swap it out.
@verdantPreview
class AppCheckbox extends StatefulWidget {
  final bool? value;
  final ValueChanged<bool?>? onChanged;

  /// When true, tapping cycles false → true → null → false instead of
  /// just false ↔ true, matching stock [Checkbox]'s own tristate contract.
  final bool tristate;

  const AppCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.tristate = false,
  }) : assert(
         tristate || value != null,
         'value can only be null if tristate is true',
       );

  @override
  State<AppCheckbox> createState() => _AppCheckboxState();
}

class _AppCheckboxState extends State<AppCheckbox> {
  bool _hovering = false;

  void _handleTap() {
    final onChanged = widget.onChanged;
    if (onChanged == null) return;
    switch (widget.value) {
      case false:
        onChanged(true);
      case true:
        onChanged(widget.tristate ? null : false);
      case null:
        onChanged(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final motion = context.motion;
    final disabled = widget.onChanged == null;
    final checked = widget.value == true;
    final indeterminate = widget.value == null;
    final selected = checked || indeterminate;
    final shape = context.shape;

    final Color? fill;
    final Color borderColor;
    if (disabled) {
      fill = selected ? colorScheme.outlineVariant : null;
      borderColor = colorScheme.outlineVariant;
    } else if (selected) {
      fill = colorScheme.primary;
      borderColor = colorScheme.primary;
    } else {
      fill = null;
      borderColor = _hovering
          ? colorScheme.outline
          : colorScheme.outlineVariant;
    }
    final glyphColor = disabled
        ? colorScheme.onSurfaceVariant
        : colorScheme.onPrimary;
    final border = VerdantNotchedBorder(
      radiusTopLeft: shape.radiusXs,
      radiusBottomLeft: shape.radiusXs,
      radiusBottomRight: shape.radiusXs,
      notch: shape.notchXs,
      side: BorderSide(color: borderColor),
    );

    return Semantics(
      checked: checked,
      mixed: indeterminate,
      child: Material(
        type: MaterialType.transparency,
        shape: border,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: disabled ? null : _handleTap,
          onHover: disabled
              ? null
              : (hovering) => setState(() => _hovering = hovering),
          child: AnimatedContainer(
            duration: motion.durationMicro,
            curve: motion.curveEnter,
            width: 20,
            height: 20,
            decoration: ShapeDecoration(color: fill, shape: border),
            child: Center(
              child: AnimatedSwitcher(
                duration: motion.durationMicro,
                switchInCurve: motion.curveEnter,
                switchOutCurve: motion.curveExit,
                transitionBuilder: (child, animation) => ScaleTransition(
                  scale: animation,
                  child: FadeTransition(opacity: animation, child: child),
                ),
                child: selected
                    ? VerdantIcon(
                        indeterminate
                            ? VerdantGlyph.remove
                            : VerdantGlyph.check,
                        key: ValueKey(
                          indeterminate ? 'indeterminate' : 'checked',
                        ),
                        size: 14,
                        color: glyphColor,
                        strokeWidth: 2,
                      )
                    : const SizedBox.shrink(key: ValueKey('empty')),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
