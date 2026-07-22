import 'package:flutter/material.dart';

import '../../theme/app_theme_context.dart';

/// Switching between parallel views at the same hierarchy level, in place
/// (§10.10). `radius.none` tab strip, Level 1 hairline border along the
/// bottom edge, a 2px `moss.60`/`primary` underline beneath the *selected
/// tab's label only* — never a filled pill/chip background, the same tell
/// §5.2 already rejects for buttons.
///
/// Wraps stock [TabBar]/[TabController] rather than hand-building, the
/// opposite call from [AppCheckbox]/[AppRadio]/[AppSwitch]: those wrapped
/// stock widgets baked in an animation the spec explicitly rejects with no
/// way to swap it out, but `TabBar`'s indicator-sliding logic already
/// solves the genuinely fiddly part of this component — measuring and
/// animating between *variable-width* label positions — correctly, and
/// [TabController.animateTo] exposes real `duration`/`curve` control.
///
/// **Disclosed gap**: `TabBar` has no public hook for the *curve* its own
/// internal tap handler uses when calling `animateTo` (only
/// `animationDuration`, which this widget does set to `motion.standard`).
/// The slide plays on Material's own `Curves.ease` rather than literal
/// Enter — both are decisive-start/no-overshoot curves, close in
/// character, but not byte-identical. Rebuilding tap handling from scratch
/// just to swap a curve on a ~220ms underline slide wasn't worth
/// reimplementing `TabBar`'s label-measurement logic to get there.
class AppTabs extends StatefulWidget {
  final List<String> labels;
  final int initialIndex;
  final ValueChanged<int>? onChanged;

  const AppTabs({
    super.key,
    required this.labels,
    this.initialIndex = 0,
    this.onChanged,
  });

  @override
  State<AppTabs> createState() => _AppTabsState();
}

class _AppTabsState extends State<AppTabs> with SingleTickerProviderStateMixin {
  TabController? _controller;

  // `Theme.of(context)` (which `context.motion` calls into) can't be read
  // in `initState` -- it needs a live inherited-widget dependency, which
  // isn't established until the element has finished mounting. Caught by
  // this widget's own test suite: "dependOnInheritedWidgetOfExactType...
  // called before initState() completed." `didChangeDependencies` is the
  // correct lifecycle hook; the null-check guards it to run only once,
  // since `TabController.animationDuration` has no setter to update later.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller ??= TabController(
      length: widget.labels.length,
      initialIndex: widget.initialIndex,
      // `TabController` (not `TabBar`, which has no duration/curve params
      // of its own) is what actually owns the indicator's animation
      // timing -- `TabBar`'s internal tap handler just calls
      // `animateTo(index)` on this controller with no curve override, so
      // the slide plays on `animateTo`'s own default `Curves.ease`.
      animationDuration: context.motion.durationStandard,
      vsync: this,
    )..addListener(_handleIndexChange);
  }

  void _handleIndexChange() {
    final controller = _controller!;
    if (!controller.indexIsChanging) {
      widget.onChanged?.call(controller.index);
    }
  }

  @override
  void dispose() {
    _controller
      ?..removeListener(_handleIndexChange)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colorScheme.outlineVariant)),
      ),
      child: TabBar(
        controller: _controller,
        indicatorSize: TabBarIndicatorSize.label,
        indicatorColor: colorScheme.primary,
        indicatorWeight: 2,
        dividerColor: Colors.transparent,
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        labelColor: colorScheme.primary,
        unselectedLabelColor: colorScheme.onSurfaceVariant,
        tabs: [for (final label in widget.labels) Tab(text: label)],
      ),
    );
  }
}
