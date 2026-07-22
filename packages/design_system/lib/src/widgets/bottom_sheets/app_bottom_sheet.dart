import 'package:flutter/material.dart';

import '../../maturity/verdant_maturity.dart';
import '../../shape/verdant_notched_border.dart';
import '../../theme/app_theme_context.dart';

/// Wraps [showModalBottomSheet] with a consistent rounded-top shape (§16).
///
/// Genuine interruption, same register as [AppDialog] — Level 3 depth and
/// `radius.md` (6px), the most rounded any Verdant surface gets by default,
/// marking it as the exceptional floating case (§10.5). `elevation: 8`
/// approximates Level 3's register; Material's `elevation` draws its own
/// built-in shadow curve, not the literal shadow spec in
/// docs/VERDANT_DESIGN_SYSTEM.md §6, since `showModalBottomSheet` doesn't
/// expose a raw `BoxShadow` list. Motion uses `motion.panel` with Verdant
/// Enter/Exit via [AnimationStyle], same single-duration caveat as
/// [AppDialog.confirm].
///
/// Top-left carries the normal `radius.md` rounding, top-right carries
/// "the Verdant Corner" notch instead — the bottom two corners stay
/// perfectly square (`radiusBottomLeft`/`radiusBottomRight: 0`), since a
/// sheet anchored to the bottom of the screen has to stay flush with its
/// edges there; the shape signature only shows up where the sheet is
/// actually free to have one.
@verdantStable
class AppBottomSheet {
  const AppBottomSheet._();

  static Future<T?> show<T>(
    BuildContext context, {
    required WidgetBuilder builder,
    bool isScrollControlled = true,
  }) {
    final shape = context.shape;
    final motion = context.motion;
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      elevation: 8,
      shape: VerdantNotchedBorder(
        radiusTopLeft: shape.radiusMd,
        notch: shape.notchMd,
      ),
      sheetAnimationStyle: AnimationStyle(
        duration: motion.durationPanel,
        curve: motion.curveEnter,
        reverseCurve: motion.curveExit,
      ),
      builder: builder,
    );
  }
}
