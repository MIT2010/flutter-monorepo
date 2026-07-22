import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

const _items = [
  AppMenuItem(value: 'edit', label: 'Edit', icon: Icons.edit_outlined),
  AppMenuItem(
    value: 'duplicate',
    label: 'Duplicate',
    icon: Icons.copy_outlined,
  ),
  AppMenuItem(value: 'delete', label: 'Delete', icon: Icons.delete_outline),
];

@widgetbook.UseCase(name: 'Open on tap', type: AppMenu)
Widget appMenuOpenUseCase(BuildContext context) {
  return Center(
    child: Builder(
      builder: (context) => ElevatedButton(
        onPressed: () => AppMenu.show<String>(
          context,
          position: const Offset(120, 160),
          items: _items,
        ),
        child: const Text('Open menu'),
      ),
    ),
  );
}

/// **Per-instance knob — deliberately separate from Theme Studio**, same
/// pattern as the rest of this catalog. Selecting an item shows the
/// resolved value below the trigger, since [AppMenu.show] resolves a
/// `Future` rather than something a knob alone can display live.
@widgetbook.UseCase(name: 'Interactive', type: AppMenu)
Widget appMenuInteractiveUseCase(BuildContext context) {
  return const _InteractiveMenuDemo();
}

class _InteractiveMenuDemo extends StatefulWidget {
  const _InteractiveMenuDemo();

  @override
  State<_InteractiveMenuDemo> createState() => _InteractiveMenuDemoState();
}

class _InteractiveMenuDemoState extends State<_InteractiveMenuDemo> {
  String? _lastSelected;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                final selected = await AppMenu.show<String>(
                  context,
                  position: const Offset(120, 220),
                  items: _items,
                );
                setState(() => _lastSelected = selected);
              },
              child: const Text('Open menu'),
            ),
          ),
          const SizedBox(height: 16),
          Text('Last selected: ${_lastSelected ?? '(none)'}'),
        ],
      ),
    );
  }
}
