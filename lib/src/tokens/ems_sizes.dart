/// Component sizes (decision D6: gloved use in a moving vehicle).
///
/// Example: `const SizedBox(height: EmsSizes.inputHeight)`
abstract final class EmsSizes {
  /// Minimum touch target for every interactive element.
  static const double minTap = 48;

  /// Primary and success screen actions (and inputs).
  static const double primaryTap = 56;

  /// Height of large buttons (`EmsButtonSize.large`, the default).
  static const double buttonHeight = 56;

  /// Height of regular buttons (`EmsButtonSize.regular`, e.g. wizard nav).
  static const double buttonHeightRegular = 48;

  /// Minimum height of single-line inputs and the date/time field. Inputs
  /// grow with the text scale.
  static const double inputHeight = 56;

  /// Minimum height of chips, tabs, sidebar rows and option rows.
  static const double chipHeight = 48;

  /// Height of the top bar.
  static const double topBarHeight = 64;

  /// Side of `EmsIconBadge`'s square.
  static const double iconBadge = 44;

  /// Default avatar radius (40 dp avatar).
  static const double avatarRadius = 20;

  /// Width of the sidebar.
  static const double sidebarWidth = 220;

  /// Minimum diameter of a step-indicator number circle (it grows with the
  /// text scale).
  static const double stepCircle = 28;

  /// Minimum diameter of the slider value badge (grows with the text scale).
  static const double sliderBadge = 36;

  /// Minimum height of an `EmsTileSelector` tile.
  static const double tileMinHeight = 72;

  /// Minimum height of the search bar.
  static const double searchBarHeight = 48;
}

/// Icon sizes on Material's grid (16/20/24/32/40).
abstract final class EmsIconSize {
  /// 16 dp: inside chips and pills.
  static const double xs = 16;

  /// 20 dp: inside buttons and list rows.
  static const double sm = 20;

  /// 24 dp: default.
  static const double md = 24;

  /// 32 dp: tiles.
  static const double lg = 32;

  /// 40 dp: empty states.
  static const double xl = 40;
}
