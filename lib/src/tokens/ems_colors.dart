import 'package:flutter/material.dart';

import 'ems_tone.dart';

/// Semantic colour tokens of the EMS design system (a [ThemeExtension]).
///
/// Read them with `EmsColors.of(context)`; never use raw colours in widgets.
/// Every text/background pair the components use meets WCAG AA in both themes
/// (`test/tokens/contrast_test.dart`, VISUAL_PROPOSAL §1.4).
///
/// Example: `Text(title, style: TextStyle(color: EmsColors.of(context).textPrimary))`
@immutable
class EmsColors extends ThemeExtension<EmsColors> {
  /// Creates a colour set. Prefer [light] and [dark].
  const EmsColors({
    required this.background,
    required this.surface,
    required this.surfaceRaised,
    required this.surfaceSunken,
    required this.textPrimary,
    required this.textSecondary,
    required this.textHint,
    required this.textDisabled,
    required this.borderSubtle,
    required this.borderStrong,
    required this.focusRing,
    required this.scrim,
    required this.skeletonBase,
    required this.skeletonHighlight,
    required this.primary,
    required this.onPrimary,
    required this.primaryPressed,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.success,
    required this.onSuccess,
    required this.successContainer,
    required this.onSuccessContainer,
    required this.danger,
    required this.onDanger,
    required this.dangerContainer,
    required this.onDangerContainer,
    required this.warning,
    required this.onWarning,
    required this.warningContainer,
    required this.onWarningContainer,
    required this.info,
    required this.onInfo,
    required this.infoContainer,
    required this.onInfoContainer,
    required this.accentViolet,
    required this.accentCoral,
  });

  /// Page background.
  final Color background;

  /// Cards, inputs and sheets.
  final Color surface;

  /// Dialogs, menus and snackbars.
  final Color surfaceRaised;

  /// Chip and segmented fills, disabled field fill. Never put [textHint] on it (4.39:1 in light).
  final Color surfaceSunken;

  /// Body text and field labels.
  final Color textPrimary;

  /// Secondary text, unselected options.
  final Color textSecondary;

  /// Placeholders, timestamps, inactive labels (≥ 4.5:1 on surface and background).
  final Color textHint;

  /// Disabled text only (exempt from contrast; always paired with a non-colour cue).
  final Color textDisabled;

  /// Decorative card edges and dividers.
  final Color borderSubtle;

  /// Interactive outlines: inputs, checkboxes, radios, switch-off, segmented (≥ 3:1).
  final Color borderStrong;

  /// Keyboard focus ring.
  final Color focusRing;

  /// Overlays (40–60 %) and shadows.
  final Color scrim;

  /// Skeleton placeholder base.
  final Color skeletonBase;

  /// Skeleton placeholder sweep.
  final Color skeletonHighlight;

  /// Brand, links, focus, selected outline.
  final Color primary;

  /// Text and icons on [primary].
  final Color onPrimary;

  /// Pressed primary fill.
  final Color primaryPressed;

  /// Tinted fill: selected chip, badge.
  final Color primaryContainer;

  /// Text and icons on [primaryContainer].
  final Color onPrimaryContainer;

  /// Success text, icon and fill.
  final Color success;

  /// Text and icons on [success].
  final Color onSuccess;

  /// Success banner and chip fill.
  final Color successContainer;

  /// Text on [successContainer].
  final Color onSuccessContainer;

  /// Error and danger text, icon and fill.
  final Color danger;

  /// Text and icons on [danger].
  final Color onDanger;

  /// Error banner and chip fill.
  final Color dangerContainer;

  /// Text on [dangerContainer].
  final Color onDangerContainer;

  /// Warning text and icon (text-safe).
  final Color warning;

  /// Text and icons on [warning].
  final Color onWarning;

  /// Warning banner and chip fill.
  final Color warningContainer;

  /// Text on [warningContainer].
  final Color onWarningContainer;

  /// Info text and icon.
  final Color info;

  /// Text and icons on [info].
  final Color onInfo;

  /// Info banner fill.
  final Color infoContainer;

  /// Text on [infoContainer].
  final Color onInfoContainer;

  /// Category accent: vehicle and equipment.
  final Color accentViolet;

  /// Category accent: crew.
  final Color accentCoral;

  /// The colour tokens of the nearest theme.
  ///
  /// Throws a [FlutterError] that explains the fix when the theme wasn't
  /// built with [EmsTheme] (DS-32).
  static EmsColors of(BuildContext context) {
    final colors = Theme.of(context).extension<EmsColors>();
    if (colors == null) {
      throw FlutterError.fromParts([
        ErrorSummary(
          'EmsColors.of() called with a theme that has no EmsColors.',
        ),
        ErrorHint(
          'Build the app theme with EmsTheme.light() / EmsTheme.dark(), or add '
          'EmsColors.light / EmsColors.dark to ThemeData.extensions.',
        ),
      ]);
    }
    return colors;
  }

  /// The colour of a category [accent] (decision D11).
  Color accent(EmsAccent accent) => switch (accent) {
    EmsAccent.location => success,
    EmsAccent.vehicle => accentViolet,
    EmsAccent.equipment => accentViolet,
    EmsAccent.crew => accentCoral,
  };

  /// The base colour of a [tone] (text, icon and outline).
  Color tone(EmsTone tone) => switch (tone) {
    EmsTone.neutral => textSecondary,
    EmsTone.primary => primary,
    EmsTone.success => success,
    EmsTone.warning => warning,
    EmsTone.danger => danger,
    EmsTone.info => info,
  };

  /// The container fill of a [tone] (chips, banners, selected tiles).
  Color toneContainer(EmsTone tone) => switch (tone) {
    EmsTone.neutral => surfaceSunken,
    EmsTone.primary => primaryContainer,
    EmsTone.success => successContainer,
    EmsTone.warning => warningContainer,
    EmsTone.danger => dangerContainer,
    EmsTone.info => infoContainer,
  };

  /// Text and icons on [toneContainer] (≥ 7:1 in both themes).
  Color onToneContainer(EmsTone tone) => switch (tone) {
    EmsTone.neutral => textSecondary,
    EmsTone.primary => onPrimaryContainer,
    EmsTone.success => onSuccessContainer,
    EmsTone.warning => onWarningContainer,
    EmsTone.danger => onDangerContainer,
    EmsTone.info => onInfoContainer,
  };

  /// Text and icons on a filled [tone] background.
  Color onTone(EmsTone tone) => switch (tone) {
    EmsTone.neutral => textPrimary,
    EmsTone.primary => onPrimary,
    EmsTone.success => onSuccess,
    EmsTone.warning => onWarning,
    EmsTone.danger => onDanger,
    EmsTone.info => onInfo,
  };

  /// Light theme (decisions D1–D4, D11).
  static const light = EmsColors(
    background: Color(0xFFF4F7FE),
    surface: Color(0xFFFFFFFF),
    surfaceRaised: Color(0xFFFFFFFF),
    surfaceSunken: Color(0xFFEEF2FB),
    textPrimary: Color(0xFF1B2559),
    textSecondary: Color(0xFF56638B),
    textHint: Color(0xFF646F98),
    textDisabled: Color(0xFFA3AED0),
    borderSubtle: Color(0xFFE9EDF7),
    borderStrong: Color(0xFF7D89AE),
    focusRing: Color(0xFF2563EB),
    scrim: Color(0xFF0B1437),
    skeletonBase: Color(0xFFE9EDF7),
    skeletonHighlight: Color(0xFFF7F9FD),
    primary: Color(0xFF2563EB),
    onPrimary: Color(0xFFFFFFFF),
    primaryPressed: Color(0xFF1D4ED8),
    primaryContainer: Color(0xFFDBEAFE),
    onPrimaryContainer: Color(0xFF1E40AF),
    success: Color(0xFF047857),
    onSuccess: Color(0xFFFFFFFF),
    successContainer: Color(0xFFECFDF5),
    onSuccessContainer: Color(0xFF065F46),
    danger: Color(0xFFD41A1A),
    onDanger: Color(0xFFFFFFFF),
    dangerContainer: Color(0xFFFEF0F0),
    onDangerContainer: Color(0xFF991B1B),
    warning: Color(0xFFB45309),
    onWarning: Color(0xFFFFFFFF),
    warningContainer: Color(0xFFFFF4DE),
    onWarningContainer: Color(0xFF7C2D12),
    info: Color(0xFF2D5BD8),
    onInfo: Color(0xFFFFFFFF),
    infoContainer: Color(0xFFEBF0FF),
    onInfoContainer: Color(0xFF1E3A8A),
    accentViolet: Color(0xFF6440F5),
    accentCoral: Color(0xFFD93636),
  );

  /// Dark theme: designed, not inverted. Filled controls use light fills with navy text (D2).
  static const dark = EmsColors(
    background: Color(0xFF0B1437),
    surface: Color(0xFF111C44),
    surfaceRaised: Color(0xFF1B2559),
    surfaceSunken: Color(0xFF0B1437),
    textPrimary: Color(0xFFE2E8F0),
    textSecondary: Color(0xFFA0AEC0),
    textHint: Color(0xFF8F9BBA),
    textDisabled: Color(0xFF56649A),
    borderSubtle: Color(0xFF2B3674),
    borderStrong: Color(0xFF6B7AA8),
    focusRing: Color(0xFF93C5FD),
    scrim: Color(0xFF000000),
    skeletonBase: Color(0xFF1B2559),
    skeletonHighlight: Color(0xFF2B3674),
    primary: Color(0xFF6EA8FE),
    onPrimary: Color(0xFF0B1437),
    primaryPressed: Color(0xFF93C5FD),
    primaryContainer: Color(0xFF1E3A8A),
    onPrimaryContainer: Color(0xFFDBEAFE),
    success: Color(0xFF34D399),
    onSuccess: Color(0xFF0B1437),
    successContainer: Color(0xFF0B3B2A),
    onSuccessContainer: Color(0xFFA7F3D0),
    danger: Color(0xFFFF7A7A),
    onDanger: Color(0xFF0B1437),
    dangerContainer: Color(0xFF3B1520),
    onDangerContainer: Color(0xFFFECACA),
    warning: Color(0xFFFFB547),
    onWarning: Color(0xFF0B1437),
    warningContainer: Color(0xFF33260F),
    onWarningContainer: Color(0xFFFDE68A),
    info: Color(0xFF7DA2FF),
    onInfo: Color(0xFF0B1437),
    infoContainer: Color(0xFF15224D),
    onInfoContainer: Color(0xFFC7D7FF),
    accentViolet: Color(0xFFA78BFA),
    accentCoral: Color(0xFFFF8A80),
  );

  @override
  EmsColors copyWith({
    Color? background,
    Color? surface,
    Color? surfaceRaised,
    Color? surfaceSunken,
    Color? textPrimary,
    Color? textSecondary,
    Color? textHint,
    Color? textDisabled,
    Color? borderSubtle,
    Color? borderStrong,
    Color? focusRing,
    Color? scrim,
    Color? skeletonBase,
    Color? skeletonHighlight,
    Color? primary,
    Color? onPrimary,
    Color? primaryPressed,
    Color? primaryContainer,
    Color? onPrimaryContainer,
    Color? success,
    Color? onSuccess,
    Color? successContainer,
    Color? onSuccessContainer,
    Color? danger,
    Color? onDanger,
    Color? dangerContainer,
    Color? onDangerContainer,
    Color? warning,
    Color? onWarning,
    Color? warningContainer,
    Color? onWarningContainer,
    Color? info,
    Color? onInfo,
    Color? infoContainer,
    Color? onInfoContainer,
    Color? accentViolet,
    Color? accentCoral,
  }) {
    return EmsColors(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceRaised: surfaceRaised ?? this.surfaceRaised,
      surfaceSunken: surfaceSunken ?? this.surfaceSunken,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textHint: textHint ?? this.textHint,
      textDisabled: textDisabled ?? this.textDisabled,
      borderSubtle: borderSubtle ?? this.borderSubtle,
      borderStrong: borderStrong ?? this.borderStrong,
      focusRing: focusRing ?? this.focusRing,
      scrim: scrim ?? this.scrim,
      skeletonBase: skeletonBase ?? this.skeletonBase,
      skeletonHighlight: skeletonHighlight ?? this.skeletonHighlight,
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      primaryPressed: primaryPressed ?? this.primaryPressed,
      primaryContainer: primaryContainer ?? this.primaryContainer,
      onPrimaryContainer: onPrimaryContainer ?? this.onPrimaryContainer,
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      successContainer: successContainer ?? this.successContainer,
      onSuccessContainer: onSuccessContainer ?? this.onSuccessContainer,
      danger: danger ?? this.danger,
      onDanger: onDanger ?? this.onDanger,
      dangerContainer: dangerContainer ?? this.dangerContainer,
      onDangerContainer: onDangerContainer ?? this.onDangerContainer,
      warning: warning ?? this.warning,
      onWarning: onWarning ?? this.onWarning,
      warningContainer: warningContainer ?? this.warningContainer,
      onWarningContainer: onWarningContainer ?? this.onWarningContainer,
      info: info ?? this.info,
      onInfo: onInfo ?? this.onInfo,
      infoContainer: infoContainer ?? this.infoContainer,
      onInfoContainer: onInfoContainer ?? this.onInfoContainer,
      accentViolet: accentViolet ?? this.accentViolet,
      accentCoral: accentCoral ?? this.accentCoral,
    );
  }

  @override
  EmsColors lerp(EmsColors? other, double t) {
    if (other is! EmsColors) return this;
    return EmsColors(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceRaised: Color.lerp(surfaceRaised, other.surfaceRaised, t)!,
      surfaceSunken: Color.lerp(surfaceSunken, other.surfaceSunken, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textHint: Color.lerp(textHint, other.textHint, t)!,
      textDisabled: Color.lerp(textDisabled, other.textDisabled, t)!,
      borderSubtle: Color.lerp(borderSubtle, other.borderSubtle, t)!,
      borderStrong: Color.lerp(borderStrong, other.borderStrong, t)!,
      focusRing: Color.lerp(focusRing, other.focusRing, t)!,
      scrim: Color.lerp(scrim, other.scrim, t)!,
      skeletonBase: Color.lerp(skeletonBase, other.skeletonBase, t)!,
      skeletonHighlight: Color.lerp(
        skeletonHighlight,
        other.skeletonHighlight,
        t,
      )!,
      primary: Color.lerp(primary, other.primary, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      primaryPressed: Color.lerp(primaryPressed, other.primaryPressed, t)!,
      primaryContainer: Color.lerp(
        primaryContainer,
        other.primaryContainer,
        t,
      )!,
      onPrimaryContainer: Color.lerp(
        onPrimaryContainer,
        other.onPrimaryContainer,
        t,
      )!,
      success: Color.lerp(success, other.success, t)!,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,
      successContainer: Color.lerp(
        successContainer,
        other.successContainer,
        t,
      )!,
      onSuccessContainer: Color.lerp(
        onSuccessContainer,
        other.onSuccessContainer,
        t,
      )!,
      danger: Color.lerp(danger, other.danger, t)!,
      onDanger: Color.lerp(onDanger, other.onDanger, t)!,
      dangerContainer: Color.lerp(dangerContainer, other.dangerContainer, t)!,
      onDangerContainer: Color.lerp(
        onDangerContainer,
        other.onDangerContainer,
        t,
      )!,
      warning: Color.lerp(warning, other.warning, t)!,
      onWarning: Color.lerp(onWarning, other.onWarning, t)!,
      warningContainer: Color.lerp(
        warningContainer,
        other.warningContainer,
        t,
      )!,
      onWarningContainer: Color.lerp(
        onWarningContainer,
        other.onWarningContainer,
        t,
      )!,
      info: Color.lerp(info, other.info, t)!,
      onInfo: Color.lerp(onInfo, other.onInfo, t)!,
      infoContainer: Color.lerp(infoContainer, other.infoContainer, t)!,
      onInfoContainer: Color.lerp(onInfoContainer, other.onInfoContainer, t)!,
      accentViolet: Color.lerp(accentViolet, other.accentViolet, t)!,
      accentCoral: Color.lerp(accentCoral, other.accentCoral, t)!,
    );
  }
}
