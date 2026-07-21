import 'package:flutter/material.dart';

import '../../maturity/verdant_maturity.dart';
import '../../theme/app_theme_context.dart';

/// A single, mutually-exclusive choice among a visible set of options
/// (§10.8) — a true circle, exempt from the `radius` scale entirely
/// (§5.3), the deliberate shape distinction from [AppCheckbox]'s square.
///
/// Unselected: Level 1 `stone.30`/`outlineVariant` outer ring, no dot.
/// Selected: `moss.60`/`primary` filled inner dot, and the outer ring
/// recolors to match — one of the two spec-acceptable treatments (§10.8
/// allows either an unchanged `stone.30` ring or a `moss.60` one; this
/// picks the latter for the same "filled color carries the weight" logic
/// [AppCheckbox] uses). Hover darkens the ring one Stone step:
/// `outlineVariant` → `outline`.
///
/// Hand-built rather than wrapping stock [Radio] for the same reason as
/// [AppCheckbox]: full control over the inner dot's fade/scale entrance
/// (`motion.micro`, Verdant Enter, no scale-bounce) that stock Flutter's
/// radio painter doesn't expose a way to configure.
@verdantPreview
class AppRadio<T> extends StatefulWidget {
  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;

  const AppRadio({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  State<AppRadio<T>> createState() => _AppRadioState<T>();
}

class _AppRadioState<T> extends State<AppRadio<T>> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final motion = context.motion;
    final disabled = widget.onChanged == null;
    final selected = widget.value == widget.groupValue;

    final Color ringColor;
    if (disabled) {
      ringColor = colorScheme.outlineVariant;
    } else if (selected) {
      ringColor = colorScheme.primary;
    } else {
      ringColor = _hovering ? colorScheme.outline : colorScheme.outlineVariant;
    }
    final dotColor = disabled
        ? colorScheme.onSurfaceVariant
        : colorScheme.primary;

    return Semantics(
      inMutuallyExclusiveGroup: true,
      checked: selected,
      child: Material(
        type: MaterialType.transparency,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: disabled ? null : () => widget.onChanged!(widget.value),
          onHover: disabled
              ? null
              : (hovering) => setState(() => _hovering = hovering),
          child: AnimatedContainer(
            duration: motion.durationMicro,
            curve: motion.curveEnter,
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: ringColor, width: 2),
            ),
            alignment: Alignment.center,
            child: AnimatedScale(
              scale: selected ? 1 : 0,
              duration: motion.durationMicro,
              curve: motion.curveEnter,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: dotColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
