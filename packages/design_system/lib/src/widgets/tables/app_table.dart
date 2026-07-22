import 'package:flutter/material.dart';

import '../../theme/app_theme_context.dart';

/// One column definition for [AppTable] — label plus a flex weight
/// governing its share of the table's width (matching [Expanded]'s own
/// `flex` semantics, since that's what lays out each cell).
class AppTableColumn {
  final String label;
  final int flex;

  const AppTableColumn({required this.label, this.flex = 1});
}

/// Dense, precise tabular data (§10.13) — the one place `radius.none` is
/// required, not just permitted.
///
/// **Performance is part of this spec, not an afterthought**: this is a
/// hand-built table, not a wrapper around stock [DataTable] — `DataTable`
/// builds every row into a single [Table] widget eagerly with no
/// virtualization, a well-documented Flutter performance trap for
/// anything beyond a couple hundred rows. This widget instead runs its
/// body through [ListView.builder], so a 20-row settings table and a
/// 20,000-row transaction export both only ever build the rows actually
/// scrolled into view.
///
/// **Disclosed scope gaps**, both deliberate, not oversights:
/// - Only *row* virtualization. Column count is assumed small/bounded
///   (typical for dense tabular data); there's no horizontal scroll or
///   column virtualization, which would need syncing the header's and
///   body's horizontal scroll offsets — a materially bigger feature.
/// - Cell content is supplied per-row via [rowBuilder], not virtualized
///   *within* a row — reasonable since a row's own cell count is fixed
///   and small by construction (it's [columns.length]).
///
/// Row states are a **named exception to §8.2** (documented in the spec
/// itself, not invented here): hover is a flat `stone.10`/`stone.90`
/// tint rather than Card's shadow-based Level 2 (a per-row shadow inside
/// a dense grid would look broken), and a selected row gets wash only,
/// **no edge bar** — the table's own gridlines already provide enough
/// structure that a bar would be redundant. The sort indicator is a
/// static geometric arrow (never an animated icon-swap between ascending
/// and descending); only its *color* eases in on `motion.micro` when its
/// column becomes the active sort.
class AppTable extends StatelessWidget {
  final List<AppTableColumn> columns;
  final int rowCount;
  final List<Widget> Function(BuildContext context, int rowIndex) rowBuilder;
  final int? sortColumnIndex;
  final bool sortAscending;
  final ValueChanged<int>? onSort;
  final int? selectedRowIndex;
  final ValueChanged<int>? onRowTap;

  const AppTable({
    super.key,
    required this.columns,
    required this.rowCount,
    required this.rowBuilder,
    this.sortColumnIndex,
    this.sortAscending = true,
    this.onSort,
    this.selectedRowIndex,
    this.onRowTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final divider = Divider(
      height: 1,
      thickness: 1,
      color: colorScheme.outlineVariant,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _HeaderRow(
          columns: columns,
          sortColumnIndex: sortColumnIndex,
          sortAscending: sortAscending,
          onSort: onSort,
        ),
        divider,
        Expanded(
          child: ListView.separated(
            itemCount: rowCount,
            separatorBuilder: (context, index) => divider,
            itemBuilder: (context, index) => _BodyRow(
              columns: columns,
              cells: rowBuilder(context, index),
              selected: index == selectedRowIndex,
              onTap: onRowTap == null ? null : () => onRowTap!(index),
            ),
          ),
        ),
      ],
    );
  }
}

class _HeaderRow extends StatelessWidget {
  final List<AppTableColumn> columns;
  final int? sortColumnIndex;
  final bool sortAscending;
  final ValueChanged<int>? onSort;

  const _HeaderRow({
    required this.columns,
    required this.sortColumnIndex,
    required this.sortAscending,
    required this.onSort,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.spacing.sm,
        vertical: context.spacing.xs,
      ),
      child: Row(
        children: [
          for (var i = 0; i < columns.length; i++)
            Expanded(
              flex: columns[i].flex,
              child: InkWell(
                onTap: onSort == null ? null : () => onSort!(i),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: context.spacing.xs),
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          columns[i].label,
                          style: Theme.of(context).textTheme.labelMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: context.spacing.xxxs),
                      _SortIndicator(
                        active: i == sortColumnIndex,
                        ascending: sortAscending,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SortIndicator extends StatelessWidget {
  final bool active;
  final bool ascending;

  const _SortIndicator({required this.active, required this.ascending});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final motion = context.motion;
    final targetColor = active ? colorScheme.primary : Colors.transparent;

    return TweenAnimationBuilder<Color?>(
      tween: ColorTween(end: targetColor),
      duration: motion.durationMicro,
      builder: (context, color, _) => Icon(
        ascending ? Icons.arrow_upward : Icons.arrow_downward,
        size: 14,
        color: color ?? Colors.transparent,
      ),
    );
  }
}

class _BodyRow extends StatefulWidget {
  final List<AppTableColumn> columns;
  final List<Widget> cells;
  final bool selected;
  final VoidCallback? onTap;

  const _BodyRow({
    required this.columns,
    required this.cells,
    required this.selected,
    required this.onTap,
  });

  @override
  State<_BodyRow> createState() => _BodyRowState();
}

class _BodyRowState extends State<_BodyRow> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final Color? fill;
    if (widget.selected) {
      fill = colorScheme.primaryContainer;
    } else if (_hovering) {
      fill = colorScheme.surfaceContainerHighest;
    } else {
      fill = null;
    }

    // `Material(type: transparency)` paints nothing for its own bounds
    // regardless of `color` -- that property is silently ignored on a
    // transparency-type Material. Caught by pixel-comparing the
    // "selected" and "default" goldens: they came back byte-identical
    // until this ColoredBox was added. The wash fill has to come from an
    // actual painted box; Material stays transparency-type purely for
    // InkWell's splash mechanics, same division of labor as AppCard/
    // AppListRow.
    return ColoredBox(
      color: fill ?? Colors.transparent,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: widget.onTap,
          onHover: widget.onTap == null
              ? null
              : (hovering) => setState(() => _hovering = hovering),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.spacing.sm,
              vertical: context.spacing.xs,
            ),
            child: Row(
              children: [
                for (var i = 0; i < widget.cells.length; i++)
                  Expanded(
                    flex: widget.columns[i].flex,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.spacing.xs,
                      ),
                      child: widget.cells[i],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
