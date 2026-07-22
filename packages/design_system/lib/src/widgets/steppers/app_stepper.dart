import 'package:flutter/material.dart';

import '../../icons/verdant_icons.dart';
import '../../maturity/verdant_maturity.dart';
import '../../theme/app_theme_context.dart';

/// Where you are in a fixed, linear, multi-step flow — step 2 of 4 (§10.25).
/// Distinct from [AppTabs]: a Tab switches between peer views with no
/// inherent order or completion state; a Stepper's steps are ordered and
/// (generally) completed in sequence.
///
/// **Shape**: each step is a small circle (`radius.pill`, the same "true
/// pill/circle objects" family as Radio/Switch/Avatar, §5.3) connected by
/// a straight `radius.none` line — no card, no container chrome around
/// the whole strip.
///
/// **Color**: a completed step fills `colorScheme.primary` with a
/// checkmark ([VerdantGlyph.check]); the current step is an outlined
/// `colorScheme.primary` ring around its own number; a future step is a
/// flat `colorScheme.outlineVariant` circle with a muted number. The
/// connecting line recolors to `primary` behind completed steps and stays
/// `outlineVariant` ahead of them — redundant with the markers, not
/// decorative.
///
/// **Motion**: a step transitioning current → completed animates its
/// fill/checkmark via `motion.micro` + Verdant Enter; the connecting
/// line's color sweeps over the same duration rather than snapping.
/// Respects `disableAnimations` (§8.7) by jumping to final state instead.
///
/// **State is purely presentational** ([currentStep]/[stepCount]/
/// [labels]) — no built-in tap-to-navigate affordance, since not every
/// consuming flow allows jumping steps out of order. A consumer that
/// wants that wraps each marker in its own `GestureDetector`/`InkWell`
/// rather than this component assuming it's always safe.
@verdantPreview
class AppStepper extends StatelessWidget {
  /// 0-indexed — `0` means "on step 1 of [stepCount]".
  final int currentStep;
  final int stepCount;

  /// One label per step, shown centered beneath its marker. `null` omits
  /// the label row entirely (a compact, marker-only strip).
  final List<String>? labels;

  const AppStepper({
    super.key,
    required this.currentStep,
    required this.stepCount,
    this.labels,
  }) : assert(stepCount > 0, 'stepCount must be at least 1'),
       assert(
         currentStep >= 0 && currentStep < stepCount,
         'currentStep must be within [0, stepCount)',
       );

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final motion = context.motion;
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    final duration = reduceMotion ? Duration.zero : motion.durationMicro;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            for (var i = 0; i < stepCount; i++) ...[
              _StepMarker(
                index: i,
                currentStep: currentStep,
                colorScheme: colorScheme,
                duration: duration,
                curve: motion.curveEnter,
              ),
              if (i < stepCount - 1)
                Expanded(
                  child: _StepConnector(
                    completed: i < currentStep,
                    colorScheme: colorScheme,
                    duration: duration,
                    curve: motion.curveEnter,
                  ),
                ),
            ],
          ],
        ),
        if (labels != null) ...[
          SizedBox(height: context.spacing.xxs),
          Row(
            children: [
              for (var i = 0; i < stepCount; i++)
                Expanded(
                  child: Text(
                    labels![i],
                    textAlign: i == 0
                        ? TextAlign.left
                        : (i == stepCount - 1
                              ? TextAlign.right
                              : TextAlign.center),
                    style: TextStyle(
                      fontSize: 12,
                      color: i <= currentStep
                          ? colorScheme.onSurface
                          : colorScheme.onSurfaceVariant,
                      fontWeight: i == currentStep
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

class _StepMarker extends StatelessWidget {
  final int index;
  final int currentStep;
  final ColorScheme colorScheme;
  final Duration duration;
  final Curve curve;

  const _StepMarker({
    required this.index,
    required this.currentStep,
    required this.colorScheme,
    required this.duration,
    required this.curve,
  });

  @override
  Widget build(BuildContext context) {
    const size = 28.0;
    final completed = index < currentStep;
    final current = index == currentStep;

    final Color fill;
    final Color border;
    final Color content;
    if (completed) {
      fill = colorScheme.primary;
      border = colorScheme.primary;
      content = colorScheme.onPrimary;
    } else if (current) {
      fill = colorScheme.surface;
      border = colorScheme.primary;
      content = colorScheme.primary;
    } else {
      fill = colorScheme.surface;
      border = colorScheme.outlineVariant;
      content = colorScheme.onSurfaceVariant;
    }

    return AnimatedContainer(
      duration: duration,
      curve: curve,
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: fill,
        border: Border.all(color: border, width: current ? 2 : 1),
      ),
      alignment: Alignment.center,
      child: AnimatedSwitcher(
        duration: duration,
        switchInCurve: curve,
        child: completed
            ? VerdantIcon(
                VerdantGlyph.check,
                key: const ValueKey('completed'),
                size: 14,
                color: content,
                strokeWidth: 2,
              )
            : Text(
                '${index + 1}',
                key: ValueKey('number-$index'),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: content,
                ),
              ),
      ),
    );
  }
}

class _StepConnector extends StatelessWidget {
  final bool completed;
  final ColorScheme colorScheme;
  final Duration duration;
  final Curve curve;

  const _StepConnector({
    required this.completed,
    required this.colorScheme,
    required this.duration,
    required this.curve,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: duration,
      curve: curve,
      height: 2,
      color: completed ? colorScheme.primary : colorScheme.outlineVariant,
    );
  }
}
