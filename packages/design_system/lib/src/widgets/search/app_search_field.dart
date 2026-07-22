import 'package:flutter/material.dart';

import '../../theme/app_theme_context.dart';
import '../inputs/app_text_field.dart';

/// Fast, low-friction query entry (§10.16) — inherits [AppTextField]
/// exactly for shape/depth/error, built as a thin composition over it
/// rather than a parallel implementation.
///
/// **The one named exception to §10.3's "always a static label" rule**:
/// a leading magnifying-glass icon already carries the labeling function,
/// so a persistent "Search" label above the box would be redundant. This
/// is why [AppTextField.label] is nullable at all — this widget is the
/// reason that parameter exists, not an afterthought. [hintText] fills
/// the resulting gap with a placeholder instead (a judgment call beyond
/// what §10.16 specifies: an entirely unlabeled, empty-looking field
/// reads as broken, not restrained).
///
/// The leading icon recolors `stone.60`/`stone.50` → `moss.60` on focus
/// via `AppTheme`'s `InputDecorationTheme.prefixIconColor`, matching the
/// border's own focus recolor. The trailing "×" fades in/out
/// (`motion.micro`) only once text is present.
class AppSearchField extends StatefulWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String hintText;

  const AppSearchField({
    super.key,
    this.controller,
    this.onChanged,
    this.hintText = 'Search',
  });

  @override
  State<AppSearchField> createState() => _AppSearchFieldState();
}

class _AppSearchFieldState extends State<AppSearchField> {
  late final TextEditingController _controller;
  late final bool _ownsController;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_handleTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_handleTextChanged);
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  void _handleTextChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final motion = context.motion;
    final hasText = _controller.text.isNotEmpty;

    return AppTextField(
      controller: _controller,
      onChanged: widget.onChanged,
      hintText: widget.hintText,
      prefixIcon: Icon(
        Icons.search,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      suffixIcon: AnimatedSwitcher(
        duration: motion.durationMicro,
        switchInCurve: motion.curveEnter,
        switchOutCurve: motion.curveExit,
        transitionBuilder: (child, animation) =>
            FadeTransition(opacity: animation, child: child),
        child: hasText
            ? IconButton(
                key: const ValueKey('clear'),
                icon: Icon(
                  Icons.close,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                tooltip: 'Clear',
                onPressed: _controller.clear,
              )
            : const SizedBox.shrink(key: ValueKey('empty')),
      ),
    );
  }
}
