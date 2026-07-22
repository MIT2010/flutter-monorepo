import 'package:flutter/material.dart';

import '../../theme/app_theme_context.dart';

/// Wraps [showModalBottomSheet] with a consistent rounded-top shape.
///
/// Genuine interruption, same register as [AppDialog] — Level 3 depth and
/// `radius.md` (6px), the most rounded any surface gets by default,
/// marking it as the exceptional floating case. `elevation: 8`
/// approximates Level 3's register; Material's `elevation` draws its own
/// built-in shadow curve since `showModalBottomSheet` doesn't expose a
/// raw `BoxShadow` list. Motion uses `motion.panel` with Enter/Exit via
/// [AnimationStyle], same single-duration caveat as [AppDialog.confirm].
///
/// Both top corners carry the normal `radius.md` rounding — the bottom two
/// stay perfectly square, since a sheet anchored to the bottom of the
/// screen has to stay flush with its edges there.
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(shape.radiusMd),
          topRight: Radius.circular(shape.radiusMd),
        ),
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
