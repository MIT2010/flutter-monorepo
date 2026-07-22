import 'package:flutter/material.dart';

import '../../theme/app_theme_context.dart';
import '../accents/app_edge_accent.dart';
import '../inputs/app_text_field.dart';

/// One choice in an [AppDropdown]'s option list.
class AppDropdownItem<T> {
  final T value;
  final String label;

  const AppDropdownItem({required this.value, required this.label});
}

/// Choosing one value from a closed list, inline in a form (§10.22) —
/// functionally a TextField that opens a Menu instead of accepting free
/// text. The closed-state trigger is [AppTextField] itself in `readOnly`
/// mode (same border/focus-recolor/static-label rules, by construction
/// rather than by copying them), with a trailing chevron that rotates
/// 180° on open via `motion.micro` — the one sanctioned persistent
/// rotation animation in this spec, because it communicates a literal
/// open/closed state rather than decoration (§10.22).
///
/// The open option list is styled directly to §10.23's Menu spec
/// (`radius.md`, Level 3 floating depth via `AppElevationExtension`,
/// flat hover tint with no edge bar — a menu item is a one-shot choice,
/// not a persisted selection) rather than delegating to a shared
/// `AppMenu` component, since that's a later, separate batch item; this
/// mirrors how [AppDatePicker]'s popover already paints its own Level 3
/// chrome without a shared "AppPopover" existing either.
///
/// **Disclosed gaps**, both scope decisions rather than oversights:
/// - The overlay always opens *below* the trigger — no flip-to-above
///   when the screen doesn't have room below. Real positioning logic
///   (`CompositedTransformFollower`) is used for the common case; full
///   screen-edge avoidance is a separate, larger problem than this
///   batch's scope.
/// - Entrance is animated (`motion.panel` + Enter); exit is
///   instant. Animating a raw `OverlayEntry`'s removal needs deferring
///   the actual `remove()` call until a reverse animation finishes —
///   the same class of gap [AppDialog]'s own doc comment already
///   discloses for its exit duration.
class AppDropdown<T> extends StatefulWidget {
  final String? label;
  final T? value;
  final List<AppDropdownItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? errorText;
  final String? hintText;

  const AppDropdown({
    super.key,
    this.label,
    required this.value,
    required this.items,
    this.onChanged,
    this.errorText,
    this.hintText,
  });

  @override
  State<AppDropdown<T>> createState() => _AppDropdownState<T>();
}

class _AppDropdownState<T> extends State<AppDropdown<T>> {
  final _layerLink = LayerLink();
  final _fieldKey = GlobalKey();
  late final TextEditingController _controller;
  OverlayEntry? _overlayEntry;
  bool _open = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _labelFor(widget.value));
  }

  @override
  void didUpdateWidget(covariant AppDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _controller.text = _labelFor(widget.value) ?? '';
    }
  }

  @override
  void dispose() {
    // Not `_removeOverlay()` -- that calls `setState`, which crashes with
    // "_lifecycleState != _ElementLifecycle.defunct" here, since `dispose`
    // only ever runs while this element is unmounting and can never
    // legally trigger a rebuild of itself. Caught by this widget's own
    // test suite tearing down a still-open dropdown between tests, which
    // is exactly the real scenario this guards against: a page navigated
    // away from while its own dropdown is still open.
    _overlayEntry?.remove();
    _overlayEntry = null;
    _controller.dispose();
    super.dispose();
  }

  String? _labelFor(T? value) {
    for (final item in widget.items) {
      if (item.value == value) return item.label;
    }
    return null;
  }

  void _toggle() {
    if (_open) {
      _removeOverlay();
    } else {
      _showOverlay();
    }
  }

  void _showOverlay() {
    final renderBox = _fieldKey.currentContext!.findRenderObject() as RenderBox;
    final width = renderBox.size.width;
    // Captured explicitly rather than relying on ambient inheritance --
    // `Overlay.of(context)` finds the nearest ancestor Overlay, which in
    // a plain single-theme app happens to already sit inside the one
    // theme everything uses, but isn't guaranteed to if this widget is
    // rendered under a *nested* Theme override (a theme-preview tool with
    // a live color knob does exactly this). Without this, the overlay's
    // own BuildContext resolves against whatever theme sits at the
    // Overlay's actual position in the tree, not this widget's — same
    // class of bug AppMenu.show's own doc comment explains in more
    // detail.
    final theme = Theme.of(context);

    _overlayEntry = OverlayEntry(
      builder: (overlayContext) => Positioned(
        width: width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, renderBox.size.height + 4),
          child: Theme(
            data: theme,
            child: _DropdownMenu<T>(
              items: widget.items,
              selectedValue: widget.value,
              onSelected: (item) {
                widget.onChanged?.call(item.value);
                _removeOverlay();
              },
            ),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _open = true);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (_open) setState(() => _open = false);
  }

  @override
  Widget build(BuildContext context) {
    final motion = context.motion;

    return CompositedTransformTarget(
      link: _layerLink,
      child: AppTextField(
        key: _fieldKey,
        label: widget.label,
        controller: _controller,
        errorText: widget.errorText,
        hintText: widget.hintText,
        readOnly: true,
        onTap: _toggle,
        suffixIcon: AnimatedRotation(
          turns: _open ? 0.5 : 0,
          duration: motion.durationMicro,
          curve: _open ? motion.curveEnter : motion.curveExit,
          child: Icon(
            Icons.keyboard_arrow_down,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class _DropdownMenu<T> extends StatelessWidget {
  final List<AppDropdownItem<T>> items;
  final T? selectedValue;
  final ValueChanged<AppDropdownItem<T>> onSelected;

  const _DropdownMenu({
    required this.items,
    required this.selectedValue,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final motion = context.motion;
    final depth = context.elevation.floating;
    final shape = context.shape;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: motion.durationPanel,
      curve: motion.curveEnter,
      builder: (context, t, child) => Opacity(
        opacity: t,
        child: Align(
          alignment: Alignment.topCenter,
          heightFactor: t,
          child: child,
        ),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: Builder(
          builder: (context) {
            final radius = BorderRadius.circular(shape.radiusMd);
            return Container(
              constraints: const BoxConstraints(maxHeight: 300),
              decoration: BoxDecoration(
                color: depth.surfaceColor ?? colorScheme.surface,
                borderRadius: radius,
                boxShadow: depth.shadow,
              ),
              child: ClipRRect(
                borderRadius: radius,
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(vertical: context.spacing.xxs),
                  children: [
                    for (final item in items)
                      _DropdownOptionRow(
                        label: item.label,
                        selected: item.value == selectedValue,
                        onTap: () => onSelected(item),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _DropdownOptionRow extends StatefulWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _DropdownOptionRow({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  State<_DropdownOptionRow> createState() => _DropdownOptionRowState();
}

class _DropdownOptionRowState extends State<_DropdownOptionRow> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: widget.onTap,
        onHover: (hovering) => setState(() => _hovering = hovering),
        child: AppEdgeAccent(
          selected: widget.selected,
          color: colorScheme.primary,
          width: 3,
          child: Container(
            color: _hovering ? colorScheme.surfaceContainerHighest : null,
            padding: EdgeInsets.symmetric(
              horizontal: context.spacing.sm,
              vertical: context.spacing.xs,
            ),
            child: Text(
              widget.label,
              style: TextStyle(
                color: widget.selected
                    ? colorScheme.primary
                    : colorScheme.onSurface,
                fontWeight: widget.selected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
