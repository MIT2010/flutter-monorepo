import 'package:flutter/material.dart';

/// Verdant's own glyph set — hand-drawn `Path`s on a 24x24 grid, painted
/// directly rather than sourced from a font.
///
/// Two reasons this exists instead of reaching for `Icons.*`:
///
/// 1. **Identity** (docs/VERDANT_DESIGN_SYSTEM.md's post-launch visual
///    audit): every component that used a stock Material glyph was an
///    instant, unmistakable "this is Material" tell, independent of any
///    color or shape work elsewhere. This is the full set of glyphs
///    `design_system` draws internally — check, remove (indeterminate),
///    the four directional chevrons/arrows, eye/eye-off, search, close.
///    Consuming apps still choose their own icons for things like
///    `AppSidebar`'s nav items (a pass-through `IconData` field, out of
///    this package's scope) — this only covers glyphs the components
///    themselves own.
/// 2. **Golden-test reliability**: a font glyph needs the icon font
///    loaded in the `flutter_test` harness or it silently rasterizes as
///    an empty box ("tofu") — the whole `@verdantPreview` rollout's
///    golden PNGs had this happen without being caught, because the box
///    still looked plausibly icon-shaped at a glance. A `Path` painted
///    directly has no such failure mode — what renders in a golden is
///    exactly what renders in the app, always.
///
/// Deliberately plain geometric strokes, not an attempt to make each
/// individual 16-20px glyph "look distinctive" on its own — at that size
/// that reads as broken, not crafted. The identity signal is the system
/// (shape, color, motion) acting together; these icons just need to stop
/// being Material's.
enum VerdantGlyph {
  check,
  remove,
  chevronLeft,
  chevronRight,
  chevronDown,
  eye,
  eyeOff,
  search,
  close,
  arrowUp,
  arrowDown,
}

class VerdantIcon extends StatelessWidget {
  const VerdantIcon(
    this.glyph, {
    super.key,
    this.size = 20,
    required this.color,
    this.strokeWidth = 1.75,
  });

  final VerdantGlyph glyph;
  final double size;
  final Color color;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _VerdantGlyphPainter(
        glyph: glyph,
        color: color,
        strokeWidth: strokeWidth,
      ),
    );
  }
}

class _VerdantGlyphPainter extends CustomPainter {
  _VerdantGlyphPainter({
    required this.glyph,
    required this.color,
    required this.strokeWidth,
  });

  final VerdantGlyph glyph;
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    // Every path below is authored on a fixed 24x24 grid, then scaled to
    // the requested render size -- keeps the coordinates below readable
    // as plain numbers instead of pre-multiplied fractions.
    final scale = size.width / 24;
    canvas.save();
    canvas.scale(scale, scale);

    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth / scale
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    switch (glyph) {
      case VerdantGlyph.check:
        final path = Path()
          ..moveTo(5, 13)
          ..lineTo(10, 18)
          ..lineTo(19.5, 6.5);
        canvas.drawPath(path, stroke);
      case VerdantGlyph.remove:
        canvas.drawLine(const Offset(5, 12), const Offset(19, 12), stroke);
      case VerdantGlyph.chevronLeft:
        final path = Path()
          ..moveTo(15, 5)
          ..lineTo(8, 12)
          ..lineTo(15, 19);
        canvas.drawPath(path, stroke);
      case VerdantGlyph.chevronRight:
        final path = Path()
          ..moveTo(9, 5)
          ..lineTo(16, 12)
          ..lineTo(9, 19);
        canvas.drawPath(path, stroke);
      case VerdantGlyph.chevronDown:
        final path = Path()
          ..moveTo(5, 9)
          ..lineTo(12, 16)
          ..lineTo(19, 9);
        canvas.drawPath(path, stroke);
      case VerdantGlyph.eye:
        _drawEyeOutline(canvas, stroke);
        canvas.drawCircle(const Offset(12, 12), 3.4, Paint()..color = color);
      case VerdantGlyph.eyeOff:
        _drawEyeOutline(canvas, stroke);
        canvas.drawCircle(const Offset(12, 12), 3.4, stroke);
        canvas.drawLine(
          const Offset(3.5, 3.5),
          const Offset(20.5, 20.5),
          stroke,
        );
      case VerdantGlyph.search:
        canvas.drawCircle(const Offset(10.5, 10.5), 6, stroke);
        canvas.drawLine(const Offset(15, 15), const Offset(20.5, 20.5), stroke);
      case VerdantGlyph.close:
        canvas.drawLine(
          const Offset(5.5, 5.5),
          const Offset(18.5, 18.5),
          stroke,
        );
        canvas.drawLine(
          const Offset(18.5, 5.5),
          const Offset(5.5, 18.5),
          stroke,
        );
      case VerdantGlyph.arrowUp:
        canvas.drawLine(const Offset(12, 19), const Offset(12, 5), stroke);
        final head = Path()
          ..moveTo(6.5, 10.5)
          ..lineTo(12, 5)
          ..lineTo(17.5, 10.5);
        canvas.drawPath(head, stroke);
      case VerdantGlyph.arrowDown:
        canvas.drawLine(const Offset(12, 5), const Offset(12, 19), stroke);
        final head = Path()
          ..moveTo(6.5, 13.5)
          ..lineTo(12, 19)
          ..lineTo(17.5, 13.5);
        canvas.drawPath(head, stroke);
    }

    canvas.restore();
  }

  void _drawEyeOutline(Canvas canvas, Paint stroke) {
    final path = Path()
      ..moveTo(2, 12)
      ..quadraticBezierTo(12, 2.5, 22, 12)
      ..quadraticBezierTo(12, 21.5, 2, 12)
      ..close();
    canvas.drawPath(path, stroke);
  }

  @override
  bool shouldRepaint(covariant _VerdantGlyphPainter oldDelegate) {
    return oldDelegate.glyph != glyph ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
