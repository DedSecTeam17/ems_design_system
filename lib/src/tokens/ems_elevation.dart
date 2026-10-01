import 'package:flutter/painting.dart';

import 'ems_colors.dart';

/// Shadow tokens. Cards stay flat with borders (decision D5); shadows are for
/// floating layers only (top-bar pill, sheets, snackbars, map overlays). Every
/// shadow is built from the theme's [EmsColors.scrim], so dark mode gets a dark
/// shadow instead of a light glow (DS-13).
///
/// Example: `BoxDecoration(boxShadow: EmsElevation.level1(EmsColors.of(context)))`
abstract final class EmsElevation {
  /// No shadow.
  static const List<BoxShadow> level0 = [];

  /// Small floating elements (top-bar pill, menus): scrim 8 %, blur 16, y 4.
  static List<BoxShadow> level1(EmsColors colors) => [
    BoxShadow(
      color: colors.scrim.withValues(alpha: 0.08),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];

  /// Sheets, snackbars and map controls: scrim 12 %, blur 24, y 8.
  static List<BoxShadow> level2(EmsColors colors) => [
    BoxShadow(
      color: colors.scrim.withValues(alpha: 0.12),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ];
}
