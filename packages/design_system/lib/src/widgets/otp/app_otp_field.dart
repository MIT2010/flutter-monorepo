import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../maturity/verdant_maturity.dart';
import '../../shape/verdant_notched_border.dart';
import '../../theme/app_theme_context.dart';

/// A fixed-length numeric code, one digit per cell (§10.17) — the most
/// literally "printed-form-like" input in the system, each cell an
/// independently-bordered ruled box rather than one continuous field.
///
/// Auto-advances to the next cell the instant a digit is entered, and
/// moving *backward* mirrors it: backspacing an already-empty cell
/// clears the previous cell and moves focus there, rather than sitting
/// inert — the common native-OTP-autofill convention, not explicitly
/// spec'd but the only behavior that makes backspace fully symmetric
/// with auto-advance.
///
/// **Deliberately out of scope**: splitting a multi-digit paste across
/// cells. §10.17 doesn't call for it, and the state involved (parsing +
/// redistributing pasted text across N controllers while respecting
/// per-cell `maxLength`) is exactly the kind of edge case that invites a
/// subtle bug for a feature nobody asked for — a paste still lands in
/// whichever single cell received it, same as typing. Disclosed here
/// rather than silently omitted.
///
/// Error state (§10.17): every cell's border shifts to `ember.60`/
/// `colorScheme.error` together, with one shared helper-text line below
/// — matching [AppTextField]'s error language rather than inventing a
/// separate one.
@verdantPreview
class AppOtpField extends StatefulWidget {
  final int length;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onCompleted;
  final String? errorText;

  const AppOtpField({
    super.key,
    this.length = 6,
    this.onChanged,
    this.onCompleted,
    this.errorText,
  });

  @override
  State<AppOtpField> createState() => _AppOtpFieldState();
}

class _AppOtpFieldState extends State<AppOtpField> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  String get _code => _controllers.map((c) => c.text).join();

  void _handleChanged(int index, String value) {
    if (value.isNotEmpty && index < widget.length - 1) {
      _focusNodes[index + 1].requestFocus();
    }
    final code = _code;
    widget.onChanged?.call(code);
    if (code.length == widget.length) {
      widget.onCompleted?.call(code);
    }
  }

  void _handleBackspaceOnEmpty(int index) {
    if (index == 0) return;
    _controllers[index - 1].clear();
    _focusNodes[index - 1].requestFocus();
    widget.onChanged?.call(_code);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasError = widget.errorText != null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < widget.length; i++) ...[
              if (i > 0) SizedBox(width: context.spacing.xs),
              _OtpCell(
                controller: _controllers[i],
                focusNode: _focusNodes[i],
                hasError: hasError,
                onChanged: (value) => _handleChanged(i, value),
                onBackspaceOnEmpty: () => _handleBackspaceOnEmpty(i),
              ),
            ],
          ],
        ),
        if (widget.errorText != null) ...[
          SizedBox(height: context.spacing.xxs),
          Text(widget.errorText!, style: TextStyle(color: colorScheme.error)),
        ],
      ],
    );
  }
}

class _OtpCell extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool hasError;
  final ValueChanged<String> onChanged;
  final VoidCallback onBackspaceOnEmpty;

  const _OtpCell({
    required this.controller,
    required this.focusNode,
    required this.hasError,
    required this.onChanged,
    required this.onBackspaceOnEmpty,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final shape = context.shape;

    VerdantNotchedInputBorder border(Color color, {double width = 1}) =>
        VerdantNotchedInputBorder(
          radiusTopLeft: shape.radiusXs,
          radiusBottomLeft: shape.radiusXs,
          radiusBottomRight: shape.radiusXs,
          notch: shape.notchXs,
          borderSide: BorderSide(color: color, width: width),
        );

    final restColor = hasError ? colorScheme.error : colorScheme.outlineVariant;
    final focusColor = hasError ? colorScheme.error : colorScheme.primary;

    return SizedBox(
      width: 44,
      height: 52,
      // A *separate*, auto-created ancestor node -- not `focusNode` itself.
      // Reusing the same FocusNode for both this wrapper and the TextField
      // below crashes with "Tried to make a child into a parent of
      // itself" (FocusNode._reparent), caught by this widget's own test
      // suite before it ever reached a golden or a real screen. `skipTraversal`
      // keeps it out of Tab order; it exists purely so a raw backspace key
      // event has an ancestor to bubble up to once EditableText's own
      // handling ignores it (nothing to delete).
      child: Focus(
        skipTraversal: true,
        onKeyEvent: (node, event) {
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.backspace &&
              controller.text.isEmpty) {
            onBackspaceOnEmpty();
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          onChanged: onChanged,
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          maxLength: 1,
          decoration: InputDecoration(
            counterText: '',
            contentPadding: EdgeInsets.zero,
            border: border(restColor),
            enabledBorder: border(restColor),
            focusedBorder: border(focusColor, width: 2),
          ),
        ),
      ),
    );
  }
}
