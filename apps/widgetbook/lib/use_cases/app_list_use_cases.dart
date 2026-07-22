import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../addons/theme_studio_addon.dart';

const _labels = ['Overview', 'Billing', 'Notifications', 'Security'];

@widgetbook.UseCase(name: 'Default', type: AppList)
Widget appListDefaultUseCase(BuildContext context) {
  return SizedBox(
    width: 320,
    height: 260,
    child: AppList(
      itemCount: _labels.length,
      itemBuilder: (context, index) => AppListRow(
        selected: index == 1,
        onTap: () {},
        child: Text(_labels[index]),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Card style', type: AppList)
Widget appListCardStyleUseCase(BuildContext context) {
  return SizedBox(
    width: 320,
    height: 320,
    child: AppList(
      itemCount: _labels.length,
      cardStyle: true,
      itemBuilder: (context, index) => Text(_labels[index]),
    ),
  );
}

/// **Per-instance knobs — deliberately separate from Theme Studio**, same
/// pattern as the rest of this catalog. `itemCount` is knob-driven up to
/// 5,000 specifically to make the "this is virtualized, not a Column of
/// widgets" point tangible in the catalog itself, not just in the test
/// suite's own perf-sanity assertion.
@widgetbook.UseCase(name: 'Interactive', type: AppList)
Widget appListInteractiveUseCase(BuildContext context) {
  final itemCount = context.knobs.int.slider(
    label: 'Item count (virtualized -- try a large number)',
    initialValue: 20,
    min: 3,
    max: 5000,
  );
  final cardStyle = context.knobs.boolean(
    label: 'Card style',
    initialValue: false,
  );

  final primaryColor = context.knobs.color(
    label: 'Primary color (moss — selected-row edge bar/wash)',
    initialValue: ThemeStudioSettings.defaultPrimaryLight,
  );

  return Theme(
    data: AppTheme.light(primaryColor: primaryColor),
    child: SizedBox(
      width: 320,
      height: 320,
      child: AppList(
        itemCount: itemCount,
        cardStyle: cardStyle,
        itemBuilder: (context, index) => cardStyle
            ? Text('Item $index')
            : AppListRow(
                selected: index == 1,
                onTap: () {},
                child: Text('Item $index'),
              ),
      ),
    ),
  );
}
