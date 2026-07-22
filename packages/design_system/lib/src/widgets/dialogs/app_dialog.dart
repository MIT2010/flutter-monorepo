import 'package:flutter/material.dart';

import '../../theme/app_theme_context.dart';

/// Wraps [AlertDialog] behind a single static helper so confirm dialogs
/// look identical everywhere in the app. Form validation errors are
/// shown inline, never through this dialog.
///
/// Genuine interruption — Level 3 depth, the one place shadow is fully
/// deployed, since a dialog is truly detached from the page. Motion uses
/// `motion.panel` (320ms) with Enter on the way in and Exit on the way
/// out via [AnimationStyle] — `showDialog`'s public API only exposes one
/// [Duration] for both directions (no `reverseTransitionDuration` hook),
/// so the exit plays over the same 320ms; the front-loaded Exit curve
/// still reads as a quicker departure than the entrance despite sharing
/// the numeric duration.
class AppDialog {
  const AppDialog._();

  static Future<bool?> confirm(
    BuildContext context, {
    required String title,
    required String message,
    String confirmLabel = 'OK',
    String cancelLabel = 'Cancel',
  }) {
    final motion = context.motion;
    return showDialog<bool>(
      context: context,
      animationStyle: AnimationStyle(
        duration: motion.durationPanel,
        curve: motion.curveEnter,
        reverseCurve: motion.curveExit,
      ),
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelLabel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
  }
}
