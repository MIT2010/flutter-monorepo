import 'package:flutter/material.dart';

import '../../theme/app_theme_context.dart';
import '../inputs/app_text_field.dart';

/// Secure entry with an optional reveal (§10.18) — inherits [AppTextField]
/// exactly for shape/depth/label/error, built as a thin composition over
/// it rather than a parallel implementation, plus one addition: a
/// trailing icon-button toggling obscured/visible text.
///
/// The glyph itself swaps (outline eye ↔ eye-off) to communicate state —
/// **never** a filled-vs-outline toggle, extending §10.4's
/// "never filled-when-active" rule to this control for the same reason:
/// that toggle is a recognizable, avoidable tell. The icon's *color* only
/// flashes to `moss.60` briefly on tap (`motion.micro`) and always
/// returns to its `stone.60` rest tone — color doesn't persistently
/// encode "currently revealed" (§8.3's reserved-meanings principle),
/// only the glyph swap does. `TweenAnimationBuilder` keyed on a tap
/// counter replays that flash-then-settle on every tap, including
/// repeated ones.
class AppPasswordField extends StatefulWidget {
  final String label;
  final TextEditingController? controller;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  const AppPasswordField({
    super.key,
    required this.label,
    this.controller,
    this.errorText,
    this.onChanged,
  });

  @override
  State<AppPasswordField> createState() => _AppPasswordFieldState();
}

class _AppPasswordFieldState extends State<AppPasswordField> {
  bool _obscured = true;
  int _flashCount = 0;

  void _toggle() {
    setState(() {
      _obscured = !_obscured;
      _flashCount++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final motion = context.motion;

    return AppTextField(
      label: widget.label,
      controller: widget.controller,
      obscure: _obscured,
      errorText: widget.errorText,
      onChanged: widget.onChanged,
      suffixIcon: IconButton(
        tooltip: _obscured ? 'Show password' : 'Hide password',
        onPressed: _toggle,
        icon: TweenAnimationBuilder<double>(
          key: ValueKey(_flashCount),
          tween: Tween(begin: 1, end: 0),
          duration: motion.durationMicro,
          curve: motion.curveExit,
          builder: (context, t, _) => Icon(
            _obscured
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color:
                Color.lerp(
                  colorScheme.onSurfaceVariant,
                  colorScheme.primary,
                  t,
                ) ??
                colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
