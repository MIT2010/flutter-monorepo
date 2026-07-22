import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../addons/theme_studio_addon.dart';

@widgetbook.UseCase(name: 'Sizes', type: AppAvatar)
Widget appAvatarSizesUseCase(BuildContext context) {
  return const Center(
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppAvatar(initials: 'A', size: AppAvatarSize.small),
        SizedBox(width: 16),
        AppAvatar(initials: 'MI', size: AppAvatarSize.medium),
        SizedBox(width: 16),
        AppAvatar(initials: 'MI', size: AppAvatarSize.large),
      ],
    ),
  );
}

@widgetbook.UseCase(name: 'Ringed facepile', type: AppAvatar)
Widget appAvatarRingedUseCase(BuildContext context) {
  return const Center(
    child: SizedBox(
      width: 80,
      height: 48,
      child: Stack(
        children: [
          AppAvatar(initials: 'AB', ringed: true),
          Positioned(left: 24, child: AppAvatar(initials: 'CD', ringed: true)),
          Positioned(left: 48, child: AppAvatar(initials: 'EF', ringed: true)),
        ],
      ),
    ),
  );
}

/// **Per-instance knobs — deliberately separate from Theme Studio**, same
/// pattern as the rest of this catalog.
@widgetbook.UseCase(name: 'Interactive', type: AppAvatar)
Widget appAvatarInteractiveUseCase(BuildContext context) {
  final initials = context.knobs.string(label: 'Initials', initialValue: 'MI');
  final size = context.knobs.object.dropdown<AppAvatarSize>(
    label: 'Size',
    options: AppAvatarSize.values,
    labelBuilder: (s) => s.name,
  );
  final ringed = context.knobs.boolean(label: 'Ringed', initialValue: false);

  final primaryColor = context.knobs.color(
    label: 'Primary color (moss — initials fallback wash)',
    initialValue: ThemeStudioSettings.defaultPrimaryLight,
  );

  return Theme(
    data: AppTheme.light(primaryColor: primaryColor),
    child: Center(
      child: AppAvatar(initials: initials, size: size, ringed: ringed),
    ),
  );
}
