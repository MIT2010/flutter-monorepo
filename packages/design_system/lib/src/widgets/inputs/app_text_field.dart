import 'package:flutter/material.dart';

import '../../theme/app_theme_context.dart';

/// Precision input — the closest digital analog to "writing in a premium
/// notebook." [label] sits above the field permanently, never as a
/// Material-style floating label that overlaps the border on focus — a
/// static label reads as more precise and printed-page-like, and avoids
/// that "clever" floating-label motion by default. Border/focus/error
/// colors come from the app-wide `InputDecorationTheme` (`AppTheme`), so
/// this widget stays a thin wrapper with the same named-parameter shape
/// as its Material counterpart.
class AppTextField extends StatelessWidget {
  /// Nullable so composite fields built on top of this one can opt out of
  /// the persistent label entirely — [AppSearchField] is the named §10.16
  /// exception to "always a static label," not a silently-inconsistent
  /// omission (see that widget's own doc comment).
  final String? label;
  final TextEditingController? controller;
  final bool obscure;
  final String? errorText;
  final String? hintText;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;

  /// Threaded straight through to [InputDecoration] — [AppSearchField]'s
  /// leading magnifying glass and trailing clear button, and
  /// [AppPasswordField]'s trailing reveal toggle, are both built as
  /// `prefixIcon`/`suffixIcon` rather than duplicating this whole wrapper,
  /// so shape/depth/label/error stay defined in exactly one place per
  /// §10.16/§10.18's own "inherits TextField" language.
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  /// [AppDropdown]'s closed-state trigger is this widget in `readOnly`
  /// mode with an [onTap] that opens the option list — §10.22 calls for
  /// "the same border, focus-recolor, and static label rules" as a plain
  /// TextField, and reusing this widget in read-only mode is the most
  /// direct way to guarantee that rather than hand-rolling a look-alike.
  final bool readOnly;
  final VoidCallback? onTap;

  const AppTextField({
    super.key,
    this.label,
    this.controller,
    this.obscure = false,
    this.errorText,
    this.hintText,
    this.keyboardType,
    this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(label!, style: Theme.of(context).textTheme.labelMedium),
          SizedBox(height: context.spacing.xxs),
        ],
        TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          onChanged: onChanged,
          readOnly: readOnly,
          onTap: onTap,
          decoration: InputDecoration(
            errorText: errorText,
            hintText: hintText,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}
