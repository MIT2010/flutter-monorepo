import 'package:flutter/material.dart';

import '../../maturity/verdant_maturity.dart';
import '../../theme/app_theme_context.dart';

/// A bank/payment card visual (§10.26) — the one UI element real banking
/// apps treat as their most recognizable artifact, and the piece
/// `apps/fintech_demo`'s Cards screen was missing entirely: before this,
/// a card was represented as a flat data row (a tiny network badge + two
/// lines of text inside [AppCard]), which reads as a table, not a card.
///
/// **Fill, not gradient**: solid `color` (defaults to
/// `colorScheme.primary`) rather than a gradient — Tahap 3's
/// [AppExpressiveCard] rewrite already retired gradient/color-block
/// "expressive" surface treatments as an anti-pattern for this system
/// (§5.4); a solid brand-color fill gives the card real visual weight
/// without reintroducing that. Passing a different `color` (e.g.
/// `colorScheme.tertiary`) lets a multi-card list read as visually
/// distinct entries instead of every card defaulting to the same primary
/// tone — the caller's choice, not a hardcoded per-network palette.
///
/// **Shape**: standard ISO/IEC 7810 ID-1 card proportions (1.586:1) via
/// [AspectRatio], `radius.sm` corners — the same tier [AppCard] uses,
/// keeping this consistent with Verdant's "precise, not soft" corner
/// posture (§5) rather than the more rounded corners a literal plastic
/// card has.
///
/// **Depth**: no border, no shadow — the solid fill itself is what
/// separates this from the page, consistent with §6's "shadow only for
/// true overlays" rule; a payment card at rest is still page content, not
/// a floating surface.
///
/// **Frozen state**: the fill desaturates toward
/// `colorScheme.surfaceContainerHighest` (a theme-safe neutral, not a raw
/// [VerdantColors] value) and a small "Frozen" tag appears top-right using
/// `colorScheme.error`/`.onError` — the same role Cards page already used
/// for its own "Card frozen" text before this component existed, reused
/// here rather than inventing a second danger-adjacent color.
@verdantPreview
class AppPaymentCard extends StatelessWidget {
  /// Already-masked, e.g. `'•••• •••• •••• 4821'` — this component never
  /// receives or renders a full card number.
  final String maskedNumber;
  final String holderName;
  final String networkLabel;
  final bool frozen;

  /// Fill color. Defaults to `colorScheme.primary`; pass
  /// `colorScheme.tertiary` (or another role) to visually distinguish a
  /// second card in the same list. Must pair with a light-on-dark or
  /// dark-on-light role the way `primary`/`onPrimary` do -- this
  /// component always renders its text in `colorScheme.onPrimary` and
  /// does not derive a contrasting foreground from an arbitrary `color`.
  final Color? color;

  const AppPaymentCard({
    super.key,
    required this.maskedNumber,
    required this.holderName,
    required this.networkLabel,
    this.frozen = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final baseFill = color ?? colorScheme.primary;
    final fill = frozen
        ? Color.lerp(baseFill, colorScheme.surfaceContainerHighest, 0.6)!
        : baseFill;
    final foreground = colorScheme.onPrimary;

    return AspectRatio(
      aspectRatio: 1.586,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: fill,
          borderRadius: BorderRadius.circular(context.shape.radiusSm),
        ),
        child: Padding(
          padding: EdgeInsets.all(context.spacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _Chip(color: foreground),
                  if (frozen)
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: colorScheme.error,
                        borderRadius: BorderRadius.circular(
                          context.shape.radiusPill,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.spacing.sm,
                          vertical: context.spacing.xxs,
                        ),
                        child: Text(
                          'Frozen',
                          style: TextStyle(
                            color: colorScheme.onError,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const Spacer(),
              Text(
                maskedNumber,
                style: TextStyle(
                  color: foreground,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                ),
              ),
              SizedBox(height: context.spacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    holderName.toUpperCase(),
                    style: TextStyle(
                      color: foreground,
                      fontSize: 12,
                      letterSpacing: 1,
                    ),
                  ),
                  Text(
                    networkLabel,
                    style: TextStyle(
                      color: foreground,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The card chip -- a small rounded rect with two horizontal divider
/// lines, the universally-recognized flat glyph for a payment chip. Drawn
/// locally rather than added to [VerdantGlyph]: that enum is scoped to
/// glyphs the design system's own components render internally, not a
/// one-off decorative shape a single component owns.
class _Chip extends StatelessWidget {
  final Color color;

  const _Chip({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 22,
      decoration: BoxDecoration(
        border: Border.all(color: color.withValues(alpha: 0.7)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(height: 1, color: color.withValues(alpha: 0.7)),
          const SizedBox(height: 6),
          Container(height: 1, color: color.withValues(alpha: 0.7)),
        ],
      ),
    );
  }
}
