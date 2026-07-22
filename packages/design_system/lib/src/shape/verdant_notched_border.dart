import 'dart:math' as math;

import 'package:flutter/material.dart';

/// "The Verdant Corner" — the system's one consistent, unmistakable shape
/// signature (docs/VERDANT_DESIGN_SYSTEM.md's post-launch visual-identity
/// revision): every bordered/filled container surface (buttons, cards,
/// dialogs, sheets, menus, tags, badges, snackbars, inputs) has its
/// top-right corner chamfered instead of rounded, while the other three
/// keep the existing radius scale untouched.
///
/// Deliberately **not** applied to inherently circular/pill controls
/// (`AppRadio`, `AppSwitch`'s track, `AppAvatar`) — those shapes are
/// near-universal affordance conventions (a toggle reads as a toggle
/// because it's a pill with a circular thumb, a radio reads as a radio
/// because it's a circle) and cutting a corner off one for novelty would
/// cost recognizability for no real identity gain; the notch only shows
/// up on rectangle-family surfaces, where it reads as deliberate rather
/// than accidental.
///
/// Two entry points share the same geometry (`_notchedPath` below):
/// [VerdantNotchedBorder] (an [OutlinedBorder], for anything that takes a
/// `ShapeBorder` — `ElevatedButton.style.shape`, `Card.shape`,
/// `DialogTheme.shape`, `PopupMenuTheme.shape`) and
/// [VerdantNotchedInputBorder] (an [InputBorder], for
/// `InputDecorationTheme` — a different class hierarchy Flutter uses
/// specifically for text fields). `AppTextField` renders its label as a
/// static `Text` above the field rather than `InputDecoration.labelText`
/// (docs/VERDANT_DESIGN_SYSTEM.md §10.3), so the floating-label
/// "gap" that `InputBorder.paint` supports is always zero-width here and
/// safely ignored.
Path _notchedPath(
  Rect rect, {
  required double radiusTopLeft,
  required double radiusBottomLeft,
  required double radiusBottomRight,
  required double notch,
}) {
  final w = rect.width;
  final h = rect.height;
  // Clamp so tiny surfaces (an 18px OTP box, a small tag) never produce a
  // self-intersecting path -- each corner feature is capped so no two
  // adjacent features can sum past the shorter side.
  final shortSide = math.min(w, h);
  final n = math.max(0.0, math.min(notch, shortSide * 0.9));
  final rTL = math.max(0.0, math.min(radiusTopLeft, shortSide / 2));
  final rBL = math.max(0.0, math.min(radiusBottomLeft, shortSide / 2));
  final rBR = math.max(0.0, math.min(radiusBottomRight, shortSide / 2));

  return Path()
    ..moveTo(rect.left + rTL, rect.top)
    ..lineTo(rect.right - n, rect.top)
    ..lineTo(rect.right, rect.top + n)
    ..lineTo(rect.right, rect.bottom - rBR)
    ..arcToPoint(
      Offset(rect.right - rBR, rect.bottom),
      radius: Radius.circular(rBR),
    )
    ..lineTo(rect.left + rBL, rect.bottom)
    ..arcToPoint(
      Offset(rect.left, rect.bottom - rBL),
      radius: Radius.circular(rBL),
    )
    ..lineTo(rect.left, rect.top + rTL)
    ..arcToPoint(
      Offset(rect.left + rTL, rect.top),
      radius: Radius.circular(rTL),
    )
    ..close();
}

/// Clips a child to a [ShapeBorder]'s outer silhouette — for content that
/// needs to be visually confined to a notched surface (a `ListView`
/// inside a menu/dropdown panel, for example), the same role `ClipRRect`
/// plays for a uniform rounded rect, since neither `ClipRRect` nor a
/// plain `BorderRadius` can express the notch's cut corner.
class VerdantShapeClipper extends CustomClipper<Path> {
  const VerdantShapeClipper(this.shape);

  final ShapeBorder shape;

  @override
  Path getClip(Size size) => shape.getOuterPath(Offset.zero & size);

  @override
  bool shouldReclip(covariant VerdantShapeClipper oldClipper) =>
      oldClipper.shape != shape;
}

Path _notchFillPath(Rect rect, double notch) {
  final n = math.max(
    0.0,
    math.min(notch, math.min(rect.width, rect.height) * 0.9),
  );
  return Path()
    ..moveTo(rect.right - n, rect.top)
    ..lineTo(rect.right, rect.top)
    ..lineTo(rect.right, rect.top + n)
    ..close();
}

/// [notchFill] paints a small triangular fill inside the cut corner —
/// `null` (the default) leaves it transparent, matching the ambient
/// background as a purely structural cut; passing a color (Brass, by
/// convention, reserved for emphasis surfaces — primary buttons, selected
/// tags, active menu/dropdown items) turns the same cut into a deliberate
/// color accent, so the shape signature is consistent everywhere but the
/// color signature stays earned rather than decorative noise.
@immutable
class VerdantNotchedBorder extends OutlinedBorder {
  const VerdantNotchedBorder({
    this.radiusTopLeft = 0,
    this.radiusBottomLeft = 0,
    this.radiusBottomRight = 0,
    this.notch = 8,
    this.notchFill,
    super.side,
  });

  final double radiusTopLeft;
  final double radiusBottomLeft;
  final double radiusBottomRight;
  final double notch;
  final Color? notchFill;

  @override
  VerdantNotchedBorder copyWith({
    BorderSide? side,
    double? radiusTopLeft,
    double? radiusBottomLeft,
    double? radiusBottomRight,
    double? notch,
    Color? notchFill,
  }) {
    return VerdantNotchedBorder(
      side: side ?? this.side,
      radiusTopLeft: radiusTopLeft ?? this.radiusTopLeft,
      radiusBottomLeft: radiusBottomLeft ?? this.radiusBottomLeft,
      radiusBottomRight: radiusBottomRight ?? this.radiusBottomRight,
      notch: notch ?? this.notch,
      notchFill: notchFill ?? this.notchFill,
    );
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) => _notchedPath(
    rect,
    radiusTopLeft: radiusTopLeft,
    radiusBottomLeft: radiusBottomLeft,
    radiusBottomRight: radiusBottomRight,
    notch: notch,
  );

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => _notchedPath(
    rect.deflate(side.width),
    radiusTopLeft: radiusTopLeft,
    radiusBottomLeft: radiusBottomLeft,
    radiusBottomRight: radiusBottomRight,
    notch: notch,
  );

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final fill = notchFill;
    if (fill != null) {
      canvas.drawPath(_notchFillPath(rect, notch), Paint()..color = fill);
    }
    if (side.style != BorderStyle.none && side.width > 0) {
      canvas.drawPath(
        _notchedPath(
          rect.deflate(side.width / 2),
          radiusTopLeft: radiusTopLeft,
          radiusBottomLeft: radiusBottomLeft,
          radiusBottomRight: radiusBottomRight,
          notch: notch,
        ),
        side.toPaint(),
      );
    }
  }

  @override
  ShapeBorder scale(double t) => VerdantNotchedBorder(
    side: side.scale(t),
    radiusTopLeft: radiusTopLeft * t,
    radiusBottomLeft: radiusBottomLeft * t,
    radiusBottomRight: radiusBottomRight * t,
    notch: notch * t,
    notchFill: notchFill,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VerdantNotchedBorder &&
        other.side == side &&
        other.radiusTopLeft == radiusTopLeft &&
        other.radiusBottomLeft == radiusBottomLeft &&
        other.radiusBottomRight == radiusBottomRight &&
        other.notch == notch &&
        other.notchFill == notchFill;
  }

  @override
  int get hashCode => Object.hash(
    side,
    radiusTopLeft,
    radiusBottomLeft,
    radiusBottomRight,
    notch,
    notchFill,
  );
}

/// `InputDecorationTheme`'s border hierarchy (`InputBorder`, not
/// `ShapeBorder`) — see the class-group doc comment above for why a
/// second entry point is needed for text fields specifically.
@immutable
class VerdantNotchedInputBorder extends InputBorder {
  const VerdantNotchedInputBorder({
    this.radiusTopLeft = 0,
    this.radiusBottomLeft = 0,
    this.radiusBottomRight = 0,
    this.notch = 8,
    this.notchFill,
    super.borderSide = BorderSide.none,
  });

  final double radiusTopLeft;
  final double radiusBottomLeft;
  final double radiusBottomRight;
  final double notch;
  final Color? notchFill;

  @override
  bool get isOutline => true;

  @override
  VerdantNotchedInputBorder copyWith({
    BorderSide? borderSide,
    double? radiusTopLeft,
    double? radiusBottomLeft,
    double? radiusBottomRight,
    double? notch,
    Color? notchFill,
  }) {
    return VerdantNotchedInputBorder(
      borderSide: borderSide ?? this.borderSide,
      radiusTopLeft: radiusTopLeft ?? this.radiusTopLeft,
      radiusBottomLeft: radiusBottomLeft ?? this.radiusBottomLeft,
      radiusBottomRight: radiusBottomRight ?? this.radiusBottomRight,
      notch: notch ?? this.notch,
      notchFill: notchFill ?? this.notchFill,
    );
  }

  @override
  EdgeInsetsGeometry get dimensions => const EdgeInsets.all(0);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) => _notchedPath(
    rect,
    radiusTopLeft: radiusTopLeft,
    radiusBottomLeft: radiusBottomLeft,
    radiusBottomRight: radiusBottomRight,
    notch: notch,
  );

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => _notchedPath(
    rect.deflate(borderSide.width),
    radiusTopLeft: radiusTopLeft,
    radiusBottomLeft: radiusBottomLeft,
    radiusBottomRight: radiusBottomRight,
    notch: notch,
  );

  @override
  InputBorder scale(double t) => VerdantNotchedInputBorder(
    borderSide: borderSide.scale(t),
    radiusTopLeft: radiusTopLeft * t,
    radiusBottomLeft: radiusBottomLeft * t,
    radiusBottomRight: radiusBottomRight * t,
    notch: notch * t,
    notchFill: notchFill,
  );

  // No floating label in Verdant's InputDecorationTheme (the label is a
  // static Text above the field, never InputDecoration.labelText) -- the
  // gap parameters this override receives are always zero-width and
  // safely ignored, unlike OutlineInputBorder's own implementation which
  // has to paint around a moving gap.
  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    double? gapStart,
    double gapExtent = 0.0,
    double gapPercentage = 0.0,
    TextDirection? textDirection,
  }) {
    final fill = notchFill;
    if (fill != null) {
      canvas.drawPath(_notchFillPath(rect, notch), Paint()..color = fill);
    }
    if (borderSide.style == BorderStyle.none || borderSide.width <= 0) return;
    canvas.drawPath(
      _notchedPath(
        rect.deflate(borderSide.width / 2),
        radiusTopLeft: radiusTopLeft,
        radiusBottomLeft: radiusBottomLeft,
        radiusBottomRight: radiusBottomRight,
        notch: notch,
      ),
      borderSide.toPaint(),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VerdantNotchedInputBorder &&
        other.borderSide == borderSide &&
        other.radiusTopLeft == radiusTopLeft &&
        other.radiusBottomLeft == radiusBottomLeft &&
        other.radiusBottomRight == radiusBottomRight &&
        other.notch == notch &&
        other.notchFill == notchFill;
  }

  @override
  int get hashCode => Object.hash(
    borderSide,
    radiusTopLeft,
    radiusBottomLeft,
    radiusBottomRight,
    notch,
    notchFill,
  );
}
