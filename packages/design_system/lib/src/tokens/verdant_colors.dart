import 'package:flutter/material.dart';

/// Verdant's primitive color scales — Stone (neutral), Moss (brand/action/
/// growth/success), Ember (danger), Brass (warning), Mist (info). Not
/// consumed directly by components; [AppSemanticColors] and
/// [AppTheme]'s hand-authored `ColorScheme` are built from these (see
/// docs/VERDANT_DESIGN_SYSTEM.md §3 for the full reasoning per value —
/// every hex here traces to a specific natural reference and a specific
/// UI role, not a rounded-off convenient number).
///
/// Deliberately a plain namespaced class, not an enum or extension — these
/// are raw materials for token construction, not something component code
/// should ever reference directly (component code reads
/// `context.semanticColors`/`Theme.of(context).colorScheme`, never
/// `VerdantColors.moss60` — see VERDANT_DESIGN_SYSTEM.md's "cheap to
/// retheme vs needs code" note for why that boundary matters).
abstract final class VerdantColors {
  // ---------------------------------------------------------------------
  // Stone — neutral scale (limestone -> slate). Warm-cool balanced, never
  // clinical-cool (Material's neutral grays) or beige-cozy.
  // ---------------------------------------------------------------------
  static const stone0 = Color(0xFFFCFBF8);
  static const stone10 = Color(0xFFF5F3EE);
  static const stone20 = Color(0xFFEAE7DF);
  static const stone30 = Color(0xFFD9D5C9);
  static const stone40 = Color(0xFFC1BCAC);
  static const stone50 = Color(0xFFA39D8A);
  static const stone60 = Color(0xFF857F6C);
  static const stone70 = Color(0xFF665F4F);
  static const stone80 = Color(0xFF4A4438);
  static const stone90 = Color(0xFF302C24);
  static const stone95 = Color(0xFF201D18);
  static const stone98 = Color(0xFF17150F);
  static const stone100 = Color(0xFF0F0D09);

  // ---------------------------------------------------------------------
  // Moss — brand, primary action, growth, success. The one color allowed
  // to be confident; chroma stays restrained across the whole ramp.
  // ---------------------------------------------------------------------
  static const moss10 = Color(0xFFEAF2EC);
  static const moss20 = Color(0xFFC9DDD0);
  static const moss30 = Color(0xFF9EC0AB);
  static const moss40 = Color(0xFF6E9E7F);
  static const moss50 = Color(0xFF4C7F5D);
  static const moss60 = Color(0xFF35604A);
  static const moss70 = Color(0xFF274736);
  static const moss80 = Color(0xFF1B3226);
  static const moss90 = Color(0xFF10201A);

  // ---------------------------------------------------------------------
  // Ember — danger. Oxidized iron / aged clay roof tile, not a stop-sign
  // red. 10/20 (pale container washes) added for full ColorScheme role
  // coverage (errorContainer), following the same pattern Moss's 10/20
  // already establish.
  // ---------------------------------------------------------------------
  static const ember10 = Color(0xFFFBEEEA);
  static const ember20 = Color(0xFFF3D9CF);
  static const ember40 = Color(0xFFD98F78);
  static const ember50 = Color(0xFFC97A62);
  static const ember60 = Color(0xFFA34936);
  static const ember70 = Color(0xFF7D3527);
  static const ember90 = Color(0xFF2A1712);

  // ---------------------------------------------------------------------
  // Brass — warning. Aged brass fittings, not traffic-cone orange.
  // ---------------------------------------------------------------------
  static const brass10 = Color(0xFFFBF3E4);
  static const brass20 = Color(0xFFF0E0BE);
  static const brass40 = Color(0xFFD9B876);
  static const brass50 = Color(0xFFC9A054);
  static const brass60 = Color(0xFF93732E);
  static const brass70 = Color(0xFF6E5622);
  static const brass90 = Color(0xFF251C0C);

  // ---------------------------------------------------------------------
  // Mist — info. River water under fog; desaturated slate-blue, closer to
  // grey than "link blue."
  // ---------------------------------------------------------------------
  static const mist10 = Color(0xFFEEF4F6);
  static const mist20 = Color(0xFFD8E6EA);
  static const mist40 = Color(0xFF8CB4C4);
  static const mist50 = Color(0xFF9CB8C4);
  static const mist60 = Color(0xFF4F7A8C);
  static const mist70 = Color(0xFF3A5C6B);
  static const mist90 = Color(0xFF101E22);
}
