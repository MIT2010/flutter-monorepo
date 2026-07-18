import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:widgetbook/widgetbook.dart';

/// Mutable token values [ThemeStudioAddon] drives live. Defaults match
/// `AppTheme`'s own hardcoded values exactly, so an untouched Theme Studio
/// renders the catalog identically to how it looks without the addon.
class ThemeStudioSettings {
  const ThemeStudioSettings({
    required this.seedColor,
    required this.spacingMultiplier,
    required this.radiusMultiplier,
    required this.motionSpeedMultiplier,
  });

  static const defaultSeedLight = Color(0xFF2D6CDF);

  final Color seedColor;
  final double spacingMultiplier;
  final double radiusMultiplier;
  final double motionSpeedMultiplier;
}

/// Live design-token customization for the whole Widgetbook catalog --
/// seed color, spacing/radius/motion scale -- regenerated through
/// [AppTheme.light]/[AppTheme.dark]'s own optional overrides (not a
/// separate theme-construction recipe, see `app_theme.dart`'s "extract
/// once" note) so a preview here matches what shipping the same values
/// for real would actually look like.
///
/// State lives only in Widgetbook's own per-addon query params (the same
/// mechanism every built-in addon, e.g. the Light/Dark [MaterialThemeAddon]
/// toggle, already uses) -- no separate persistence layer. A fresh
/// Widgetbook load with no Theme Studio query params present always starts
/// from [ThemeStudioSettings]'s defaults, i.e. `AppTheme`'s real, shipped
/// values -- deliberate, so nobody mistakes a leftover experiment for
/// what's actually in the codebase (see docs/DESIGN_LANGUAGE.md and
/// ARCHITECTURE.md §16's Theme Studio design notes).
///
/// Must be listed *after* [MaterialThemeAddon] in `addons: [...]` --
/// addons nest in list order (first = outermost), and this addon reads
/// `Theme.of(context).brightness` to know whether to regenerate the light
/// or dark base, which only works once the brightness addon has already
/// wrapped the tree.
class ThemeStudioAddon extends WidgetbookAddon<ThemeStudioSettings> {
  ThemeStudioAddon() : super(name: 'Theme Studio');

  @override
  List<Field> get fields => [
    ColorField(
      name: 'seedColor',
      initialValue: ThemeStudioSettings.defaultSeedLight,
    ),
    DoubleSliderField(
      name: 'spacingMultiplier',
      initialValue: 1,
      min: 0.5,
      max: 2,
      divisions: 30,
      precision: 2,
    ),
    DoubleSliderField(
      name: 'radiusMultiplier',
      initialValue: 1,
      min: 0.5,
      max: 2,
      divisions: 30,
      precision: 2,
    ),
    DoubleSliderField(
      name: 'motionSpeedMultiplier',
      initialValue: 1,
      min: 0.5,
      max: 2,
      divisions: 30,
      precision: 2,
    ),
  ];

  @override
  ThemeStudioSettings valueFromQueryGroup(Map<String, String> group) {
    return ThemeStudioSettings(
      seedColor:
          valueOf<Color>('seedColor', group) ??
          ThemeStudioSettings.defaultSeedLight,
      spacingMultiplier: valueOf<double>('spacingMultiplier', group) ?? 1,
      radiusMultiplier: valueOf<double>('radiusMultiplier', group) ?? 1,
      motionSpeedMultiplier:
          valueOf<double>('motionSpeedMultiplier', group) ?? 1,
    );
  }

  @override
  Widget buildUseCase(
    BuildContext context,
    Widget child,
    ThemeStudioSettings setting,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = isDark
        ? AppTheme.dark(
            seedColor: setting.seedColor,
            spacingMultiplier: setting.spacingMultiplier,
            radiusMultiplier: setting.radiusMultiplier,
            motionSpeedMultiplier: setting.motionSpeedMultiplier,
          )
        : AppTheme.light(
            seedColor: setting.seedColor,
            spacingMultiplier: setting.spacingMultiplier,
            radiusMultiplier: setting.radiusMultiplier,
            motionSpeedMultiplier: setting.motionSpeedMultiplier,
          );

    return Theme(
      data: theme,
      child: DefaultTextStyle(style: theme.textTheme.bodyMedium!, child: child),
    );
  }

  /// Adds a read-only, copy-pasteable export snippet below the normal
  /// slider/color controls -- reads this addon's own current query-param
  /// group the same way [buildUseCase] would, since [buildFields] only
  /// gets a [BuildContext], not the resolved [ThemeStudioSettings].
  @override
  Widget buildFields(BuildContext context) {
    final state = WidgetbookState.of(context);
    final group = FieldCodec.decodeQueryGroup(state.queryParams[groupName]);
    final settings = valueFromQueryGroup(group);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        super.buildFields(context),
        const Divider(),
        _ExportPanel(settings: settings),
      ],
    );
  }
}

class _ExportPanel extends StatelessWidget {
  const _ExportPanel({required this.settings});

  final ThemeStudioSettings settings;

  String get _snippet {
    final hex = settings.seedColor.toARGB32().toRadixString(16).padLeft(8, '0');
    return '''
AppTheme.light(
  seedColor: const Color(0x$hex),
  spacingMultiplier: ${settings.spacingMultiplier.toStringAsFixed(2)},
  radiusMultiplier: ${settings.radiusMultiplier.toStringAsFixed(2)},
  motionSpeedMultiplier: ${settings.motionSpeedMultiplier.toStringAsFixed(2)},
)''';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Export', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(4),
            ),
            child: SelectableText(
              _snippet,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
          ),
          const SizedBox(height: 4),
          TextButton.icon(
            onPressed: () => Clipboard.setData(ClipboardData(text: _snippet)),
            icon: const Icon(Icons.copy, size: 16),
            label: const Text('Copy code'),
          ),
        ],
      ),
    );
  }
}
