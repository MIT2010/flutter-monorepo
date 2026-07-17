import 'package:flutter/material.dart';

import '../../theme/app_theme_context.dart';

/// Wraps [showModalBottomSheet] with a consistent rounded-top shape (§16).
class AppBottomSheet {
  const AppBottomSheet._();

  static Future<T?> show<T>(
    BuildContext context, {
    required WidgetBuilder builder,
    bool isScrollControlled = true,
  }) {
    final radius = context.shape.radiusLg;
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(radius)),
      ),
      builder: builder,
    );
  }
}
