import 'package:flutter/material.dart';

import '../../maturity/verdant_maturity.dart';
import '../../theme/app_theme_context.dart';

/// Sizing tiers tied to existing `space` tokens rather than a separate
/// avatar-size scale (§10.20): `space.lg`=24px small, `space.xl`=32px
/// default, `space.2xl`=48px large.
enum AppAvatarSize { small, medium, large }

/// Compactly representing a person or entity (§10.20) — one of the few
/// places a photographic image legitimately appears in an otherwise
/// typography/geometry-driven system. `radius.pill` (a true circle) by
/// default, flush with no border.
///
/// Wraps stock [CircleAvatar] rather than hand-building — its shape/
/// sizing/image-vs-child fallback slot is already exactly what's needed,
/// and it carries no objectionable default animation or Material "tell"
/// to work around (unlike [AppCheckbox]/[AppRadio]/[AppSwitch]'s stock
/// widgets). If [image] fails to load, this widget falls back to
/// [initials] automatically (tracked locally via [onBackgroundImageError]
/// rather than left to the caller) — the fallback isn't just for when no
/// image was ever provided.
///
/// **Fallback (no image / image failed)**: initials on `moss.10`/`moss.90`
/// background with `moss.80`/`moss.20` text — exactly
/// `colorScheme.primaryContainer`/`onPrimaryContainer`, the identical
/// pairing already established for "moss container, non-status meaning"
/// elsewhere (e.g. [AppTag]'s selected wash), not a new token.
///
/// [ringed] adds the optional 2px `stone.20`/`outlineVariant` ring named
/// in §10.20 for dense overlapping stacks ("facepiles") — a functional
/// separator between avatars, not decoration, so it's off by default.
/// The ring is inset (the avatar image shrinks slightly to keep the
/// overall bounding circle the same size as an unringed avatar of the
/// same [size]), not an addition drawn outside those bounds — otherwise
/// a facepile's per-avatar spacing math would need to account for two
/// different avatar diameters depending on whether each one is ringed.
@verdantPreview
class AppAvatar extends StatefulWidget {
  final ImageProvider? image;
  final String initials;
  final AppAvatarSize size;
  final bool ringed;

  const AppAvatar({
    super.key,
    this.image,
    required this.initials,
    this.size = AppAvatarSize.medium,
    this.ringed = false,
  });

  @override
  State<AppAvatar> createState() => _AppAvatarState();
}

class _AppAvatarState extends State<AppAvatar> {
  bool _imageFailed = false;

  @override
  void didUpdateWidget(covariant AppAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.image != widget.image) {
      _imageFailed = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final diameter = switch (widget.size) {
      AppAvatarSize.small => context.spacing.lg,
      AppAvatarSize.medium => context.spacing.xl,
      AppAvatarSize.large => context.spacing.xxl,
    };
    // Both the border stroke and the gap between it and the avatar are
    // 2px, so the ring consumes 4px of inset on each side.
    const ringInset = 4.0;
    final innerDiameter = widget.ringed ? diameter - ringInset * 2 : diameter;
    final showImage = widget.image != null && !_imageFailed;

    final circle = CircleAvatar(
      radius: innerDiameter / 2,
      backgroundColor: colorScheme.primaryContainer,
      backgroundImage: showImage ? widget.image : null,
      onBackgroundImageError: showImage
          ? (_, _) => setState(() => _imageFailed = true)
          : null,
      child: showImage
          ? null
          : Text(
              widget.initials,
              style: TextStyle(
                color: colorScheme.onPrimaryContainer,
                fontSize: innerDiameter * 0.4,
                fontWeight: FontWeight.w600,
              ),
            ),
    );

    if (!widget.ringed) return circle;

    // Explicit width/height rather than letting Container derive its
    // size from child + padding + border -- BoxDecoration's border
    // reserves its own space in addition to any explicit padding, which
    // silently inflated the overall bounds past `diameter` (36px instead
    // of 32px for a ringed medium avatar) until this widget's own test
    // caught the mismatch by comparing ringed vs. unringed bounding
    // boxes directly.
    return Container(
      width: diameter,
      height: diameter,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: colorScheme.outlineVariant, width: 2),
      ),
      child: circle,
    );
  }
}
