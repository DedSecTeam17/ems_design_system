/// Spacing scale (4-pt). Use these for padding, gaps and margins.
///
/// Example: `const EdgeInsets.all(EmsSpacing.lg)`
abstract final class EmsSpacing {
  /// 0 dp.
  static const double none = 0;

  /// 4 dp.
  static const double xs = 4;

  /// 8 dp.
  static const double sm = 8;

  /// 12 dp.
  static const double md = 12;

  /// 16 dp.
  static const double lg = 16;

  /// 20 dp.
  static const double xl = 20;

  /// 24 dp.
  static const double xxl = 24;

  /// 32 dp.
  static const double xxxl = 32;

  /// 40 dp.
  static const double huge = 40;

  /// 48 dp.
  static const double massive = 48;
}

/// Corner radius scale.
///
/// Example: `BorderRadius.circular(EmsRadius.md)`
abstract final class EmsRadius {
  /// 0 dp, for full-bleed bars.
  static const double none = 0;

  /// 4 dp: checkboxes, small marks.
  static const double xs = 4;

  /// 8 dp: icon badges, sidebar items.
  static const double sm = 8;

  /// 12 dp: inputs, buttons (decision D8), banners, selector tiles.
  static const double md = 12;

  /// 16 dp: cards and notification rows.
  static const double lg = 16;

  /// 20 dp: dialogs, sheets.
  static const double xl = 20;

  /// Pill shape for chips, avatars and the search bar.
  static const double full = 100;
}
