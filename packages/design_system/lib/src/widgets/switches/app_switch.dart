import 'package:flutter/material.dart';

import '../../theme/app_theme_context.dart';

/// An instant, no-confirmation-needed on/off toggle (§10.9) — for settings
/// that take effect immediately, distinct from [AppCheckbox]'s "part of a
/// form, submitted later" context.
///
/// Track: `radius.pill`, the one other legitimate functional-pill
/// exception beyond Badge/Tag — modeled directly on a physical sliding
/// mechanism. Flush at rest: no border, no shadow on either track or
/// thumb, so the track's own fill color is the only state signal needed —
/// off: `colorScheme.outline`, on: `colorScheme.primary`. Thumb:
/// `colorScheme.surface` off, `colorScheme.onPrimary` on — always reached
/// through the theme rather than a hardcoded hex value, so the thumb
/// stays retheme-safe.
///
/// No hover state — §10.9 only lists off/on/disabled, unlike Checkbox and
/// Radio's explicit hover-darkens-the-border state — so this is a plain
/// [StatelessWidget], and deliberately has no ink/ripple overlay: "flush"
/// means the fill color alone carries every state signal.
///
/// Thumb slides via [AnimatedAlign] on `motion.micro` + Enter —
/// no spring, no overshoot, unlike Material's and iOS's own default
/// switch animation, which is why this is hand-built rather than
/// wrapping stock [Switch] (its default thumb-drag physics aren't
/// swappable for a flat slide via public API).
class AppSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;

  const AppSwitch({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final motion = context.motion;
    final disabled = onChanged == null;

    final Color trackColor;
    if (disabled) {
      trackColor = colorScheme.outlineVariant;
    } else if (value) {
      trackColor = colorScheme.primary;
    } else {
      trackColor = colorScheme.outline;
    }
    final thumbColor = value ? colorScheme.onPrimary : colorScheme.surface;

    return Semantics(
      toggled: value,
      child: GestureDetector(
        onTap: disabled ? null : () => onChanged!(!value),
        child: AnimatedContainer(
          duration: motion.durationMicro,
          curve: motion.curveEnter,
          width: 40,
          height: 24,
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: trackColor,
            borderRadius: BorderRadius.circular(context.shape.radiusPill),
          ),
          child: AnimatedAlign(
            duration: motion.durationMicro,
            curve: motion.curveEnter,
            alignment: value ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: thumbColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
