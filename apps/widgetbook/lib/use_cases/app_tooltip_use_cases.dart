import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Default (long-press or hover to reveal)',
  type: AppTooltip,
)
Widget appTooltipDefaultUseCase(BuildContext context) {
  return const Center(
    child: AppTooltip(
      message: 'Delete this item',
      child: Icon(Icons.delete_outline),
    ),
  );
}

/// **Per-instance knob — deliberately separate from Theme Studio**, same
/// pattern as the rest of this catalog. No color knob here: the whole
/// point of §10.21's one deliberate inversion is that it does *not*
/// track `primaryColor` the way most components do.
@widgetbook.UseCase(name: 'Interactive', type: AppTooltip)
Widget appTooltipInteractiveUseCase(BuildContext context) {
  final message = context.knobs.string(
    label: 'Message',
    initialValue: 'Supplementary context, never required to complete a task',
  );

  return Center(
    child: AppTooltip(message: message, child: const Icon(Icons.info_outline)),
  );
}
