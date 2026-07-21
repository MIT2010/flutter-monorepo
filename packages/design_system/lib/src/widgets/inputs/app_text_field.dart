import 'package:flutter/material.dart';

import '../../maturity/verdant_maturity.dart';
import '../../theme/app_theme_context.dart';

/// Precision input — the closest digital analog to "writing in a premium
/// notebook" (§10.3). [label] sits above the field permanently, never as a
/// Material-style floating label that overlaps the border on focus — a
/// static label reads as more precise and printed-page-like, and avoids
/// the "clever" floating-label motion Verdant's restraint principle argues
/// against by default. Border/focus/error colors come from the app-wide
/// `InputDecorationTheme` (`AppTheme`), so this widget stays a thin wrapper
/// with the same named-parameter shape as its Material counterpart (§16).
@verdantStable
class AppTextField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final bool obscure;
  final String? errorText;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;

  const AppTextField({
    super.key,
    required this.label,
    this.controller,
    this.obscure = false,
    this.errorText,
    this.keyboardType,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelMedium),
        SizedBox(height: context.spacing.xxs),
        TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          onChanged: onChanged,
          decoration: InputDecoration(errorText: errorText),
        ),
      ],
    );
  }
}
