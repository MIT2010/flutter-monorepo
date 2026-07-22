import 'package:flutter/material.dart';

import '../../theme/app_theme_context.dart';

const _monthNames = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

const _weekdayLabels = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];

bool _isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

/// Precise date selection — reads like flipping to a page in a physical
/// planner, not Material's heavy date-picker dialog chrome (§10.19). This
/// is the inline month-grid content; [AppDatePicker.show] is the Level 3
/// popover wrapper around it, the same split [AppDialog]/[AppBottomSheet]
/// use between "the content" and "the static helper that presents it."
///
/// **Today** is a `moss.60` outline ring (unfilled) — geometrically
/// distinct from a **selected** day's filled treatment, so the two never
/// rely on color intensity alone to be told apart (§8.1's "never
/// color-only" principle, applied here). A day that's both today and
/// selected renders as selected (filled) — the chosen date is the more
/// important fact once one is chosen.
///
/// Month navigation cross-fades via `motion.standard` + Enter/Exit
/// — no horizontal slide, which would imply a "swipeable card deck"
/// gesture language this system doesn't use anywhere else.
class AppCalendar extends StatefulWidget {
  final DateTime? selectedDate;
  final ValueChanged<DateTime>? onDateSelected;
  final DateTime? firstDate;
  final DateTime? lastDate;

  /// Which month is shown first. Defaults to [selectedDate]'s month, or
  /// [today]'s, if neither [selectedDate] nor this is given.
  final DateTime? initialMonth;

  /// What counts as "today" for the outline-ring treatment. Defaults to
  /// the real `DateTime.now()` — overridable so a test (golden or
  /// otherwise) can pin it to a fixed date instead of asserting against
  /// whatever day the suite happens to run on. Found while writing this
  /// component's own golden test: hardcoding `DateTime.now()` with no
  /// override made the today-ring state — a named, spec'd feature
  /// (§10.19) — impossible to capture deterministically.
  final DateTime? today;

  const AppCalendar({
    super.key,
    this.selectedDate,
    this.onDateSelected,
    this.firstDate,
    this.lastDate,
    this.initialMonth,
    this.today,
  });

  @override
  State<AppCalendar> createState() => _AppCalendarState();
}

class _AppCalendarState extends State<AppCalendar> {
  late DateTime _visibleMonth;

  DateTime get _today {
    final t = widget.today ?? DateTime.now();
    return DateTime(t.year, t.month, t.day);
  }

  @override
  void initState() {
    super.initState();
    final base = widget.initialMonth ?? widget.selectedDate ?? _today;
    _visibleMonth = DateTime(base.year, base.month);
  }

  void _goToPreviousMonth() {
    setState(
      () =>
          _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month - 1),
    );
  }

  void _goToNextMonth() {
    setState(
      () =>
          _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month + 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    final motion = context.motion;

    return SizedBox(
      width: 288,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: context.spacing.xxxs),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.chevron_left,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  tooltip: 'Previous month',
                  onPressed: _goToPreviousMonth,
                ),
                Expanded(
                  child: Center(
                    child: AnimatedSwitcher(
                      duration: motion.durationStandard,
                      switchInCurve: motion.curveEnter,
                      switchOutCurve: motion.curveExit,
                      transitionBuilder: (child, animation) =>
                          FadeTransition(opacity: animation, child: child),
                      child: Text(
                        '${_monthNames[_visibleMonth.month - 1]} ${_visibleMonth.year}',
                        key: ValueKey(_visibleMonth),
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.chevron_right,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  tooltip: 'Next month',
                  onPressed: _goToNextMonth,
                ),
              ],
            ),
          ),
          const _WeekdayRow(),
          AnimatedSwitcher(
            duration: motion.durationStandard,
            switchInCurve: motion.curveEnter,
            switchOutCurve: motion.curveExit,
            transitionBuilder: (child, animation) =>
                FadeTransition(opacity: animation, child: child),
            child: _MonthGrid(
              key: ValueKey(_visibleMonth),
              month: _visibleMonth,
              today: _today,
              selectedDate: widget.selectedDate,
              firstDate: widget.firstDate,
              lastDate: widget.lastDate,
              onDateSelected: widget.onDateSelected,
            ),
          ),
        ],
      ),
    );
  }
}

class _WeekdayRow extends StatelessWidget {
  const _WeekdayRow();

  @override
  Widget build(BuildContext context) {
    final onSurfaceVariant = Theme.of(context).colorScheme.onSurfaceVariant;

    return Row(
      children: [
        for (final label in _weekdayLabels)
          Expanded(
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: onSurfaceVariant,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _MonthGrid extends StatelessWidget {
  final DateTime month;
  final DateTime today;
  final DateTime? selectedDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final ValueChanged<DateTime>? onDateSelected;

  const _MonthGrid({
    super.key,
    required this.month,
    required this.today,
    required this.selectedDate,
    required this.firstDate,
    required this.lastDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final firstOfMonth = DateTime(month.year, month.month);
    // DateTime.weekday: 1 = Monday .. 7 = Sunday. Weeks start on Monday
    // (_weekdayLabels), so a month starting on Monday needs zero leading
    // blanks.
    final leadingBlanks = (firstOfMonth.weekday - DateTime.monday) % 7;
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final totalCells = ((leadingBlanks + daysInMonth) / 7).ceil() * 7;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
      ),
      itemCount: totalCells,
      itemBuilder: (context, index) {
        final dayOfMonth = index - leadingBlanks + 1;
        if (dayOfMonth < 1 || dayOfMonth > daysInMonth) {
          return const SizedBox.shrink();
        }

        final date = DateTime(month.year, month.month, dayOfMonth);
        final selectable =
            (firstDate == null || !date.isBefore(firstDate!)) &&
            (lastDate == null || !date.isAfter(lastDate!));

        return _DayCell(
          date: date,
          isToday: _isSameDay(date, today),
          isSelected: selectedDate != null && _isSameDay(date, selectedDate!),
          isSelectable: selectable,
          onTap: selectable && onDateSelected != null
              ? () => onDateSelected!(date)
              : null,
        );
      },
    );
  }
}

class _DayCell extends StatelessWidget {
  final DateTime date;
  final bool isToday;
  final bool isSelected;
  final bool isSelectable;
  final VoidCallback? onTap;

  const _DayCell({
    required this.date,
    required this.isToday,
    required this.isSelected,
    required this.isSelectable,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final motion = context.motion;

    final Color? fill;
    final Color textColor;
    final Border? border;
    if (isSelected) {
      fill = colorScheme.primary;
      textColor = colorScheme.onPrimary;
      border = null;
    } else if (isToday) {
      fill = null;
      textColor = colorScheme.primary;
      border = Border.all(color: colorScheme.primary);
    } else if (!isSelectable) {
      fill = null;
      textColor = colorScheme.onSurfaceVariant.withValues(alpha: 0.38);
      border = null;
    } else {
      fill = null;
      textColor = colorScheme.onSurface;
      border = null;
    }

    return Padding(
      padding: const EdgeInsets.all(2),
      child: Material(
        type: MaterialType.transparency,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: AnimatedContainer(
            duration: motion.durationMicro,
            curve: motion.curveEnter,
            decoration: BoxDecoration(
              color: fill,
              shape: BoxShape.circle,
              border: border,
            ),
            alignment: Alignment.center,
            child: Text('${date.day}', style: TextStyle(color: textColor)),
          ),
        ),
      ),
    );
  }
}

/// The Level 3 popover wrapper around [AppCalendar] — `radius.md`, the
/// same shape tier as [AppDialog] (it's a Level 3 popover, matching
/// Dialog's shape exactly, §10.19). Builds its own [BoxDecoration] from
/// [AppElevationExtension.floating] rather than [Dialog]'s own `elevation`
/// number, the same reason [AppCard] does (Material's elevation curve
/// can't express this system's literal shadow-list spec, §6).
class AppDatePicker {
  const AppDatePicker._();

  /// [today] forwards straight to [AppCalendar.today] — see that
  /// parameter's own doc comment for why this needs to be overridable at
  /// all (a real bug this exact golden test caught: the popover's own
  /// golden was silently asserting against whichever real day the suite
  /// happened to run on, before this parameter existed).
  static Future<DateTime?> show(
    BuildContext context, {
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    DateTime? today,
  }) {
    final motion = context.motion;
    return showDialog<DateTime>(
      context: context,
      animationStyle: AnimationStyle(
        duration: motion.durationPanel,
        curve: motion.curveEnter,
        reverseCurve: motion.curveExit,
      ),
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Builder(
          builder: (context) {
            final depth = context.elevation.floating;
            final shape = context.shape;
            return Container(
              clipBehavior: Clip.antiAlias,
              padding: EdgeInsets.all(context.spacing.sm),
              decoration: BoxDecoration(
                color:
                    depth.surfaceColor ?? Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(shape.radiusMd),
                boxShadow: depth.shadow,
              ),
              child: AppCalendar(
                selectedDate: initialDate,
                firstDate: firstDate,
                lastDate: lastDate,
                today: today,
                onDateSelected: (date) => Navigator.of(dialogContext).pop(date),
              ),
            );
          },
        ),
      ),
    );
  }
}
