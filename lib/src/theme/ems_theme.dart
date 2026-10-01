import 'package:flutter/material.dart';

import '../tokens/ems_colors.dart';
import '../tokens/ems_sizes.dart';
import '../tokens/ems_spacing.dart';
import '../tokens/ems_typography.dart';

/// Font family names used by the theme (decision D9).
///
/// Both families ship inside this package (weights 400/500/700), so they are
/// registered under the package prefix (`packages/ems_design_system/<family>`).
/// Use these constants, not the bare names, when a style needs an explicit
/// family:
///
/// ```dart
/// TextStyle(fontFamily: EmsFonts.arabic)
/// ```
abstract final class EmsFonts {
  /// The package that bundles the fonts.
  static const String package = 'ems_design_system';

  /// Roboto (Latin script), Apache-2.0.
  static const String latin = 'packages/$package/Roboto';

  /// Tajawal (Arabic script), SIL OFL 1.1.
  static const String arabic = 'packages/$package/Tajawal';
}

/// Builds the EMS Material 3 theme.
///
/// `locale` picks the script: Arabic (`ar`) uses Tajawal and
/// [EmsTypography.arabic]; other locales use Roboto and
/// [EmsTypography.latin]. Each family falls back to the other for mixed text
/// (an Arabic name in the English UI, Latin digits in Arabic).
///
/// Example:
/// ```dart
/// MaterialApp(
///   theme: EmsTheme.light(locale: locale),
///   darkTheme: EmsTheme.dark(locale: locale),
/// )
/// ```
abstract final class EmsTheme {
  /// The light theme. [colors] overrides the default light tokens.
  static ThemeData light({Locale? locale, EmsColors? colors}) => _buildTheme(
    Brightness.light,
    colors ?? EmsColors.light,
    fontFamily: _fontFamilyFor(locale),
  );

  /// The dark theme. [colors] overrides the default dark tokens.
  static ThemeData dark({Locale? locale, EmsColors? colors}) => _buildTheme(
    Brightness.dark,
    colors ?? EmsColors.dark,
    fontFamily: _fontFamilyFor(locale),
  );

  static String _fontFamilyFor(Locale? locale) =>
      locale?.languageCode == 'ar' ? EmsFonts.arabic : EmsFonts.latin;

  /// The full Material 3 colour scheme built from the semantic tokens
  /// (DS-15), so Material widgets (snackbars, pickers, dialogs, sheets,
  /// progress indicators) use the EMS palette instead of derived defaults.
  static ColorScheme colorScheme(Brightness brightness, EmsColors c) {
    final dark = brightness == Brightness.dark;
    return ColorScheme(
      brightness: brightness,
      primary: c.primary,
      onPrimary: c.onPrimary,
      primaryContainer: c.primaryContainer,
      onPrimaryContainer: c.onPrimaryContainer,
      secondary: c.textSecondary,
      onSecondary: dark ? c.background : c.surface,
      secondaryContainer: c.surfaceSunken,
      onSecondaryContainer: c.textPrimary,
      tertiary: c.accentViolet,
      onTertiary: dark ? c.background : c.surface,
      tertiaryContainer: c.infoContainer,
      onTertiaryContainer: c.onInfoContainer,
      error: c.danger,
      onError: c.onDanger,
      errorContainer: c.dangerContainer,
      onErrorContainer: c.onDangerContainer,
      surface: c.surface,
      onSurface: c.textPrimary,
      onSurfaceVariant: c.textSecondary,
      surfaceDim: c.background,
      surfaceBright: c.surfaceRaised,
      surfaceContainerLowest: c.surface,
      surfaceContainerLow: c.surface,
      surfaceContainer: c.surfaceRaised,
      surfaceContainerHigh: c.surfaceRaised,
      surfaceContainerHighest: dark ? c.surfaceRaised : c.surfaceSunken,
      outline: c.borderStrong,
      outlineVariant: c.borderSubtle,
      shadow: c.scrim,
      scrim: c.scrim,
      // Snackbars and tooltips: navy in light, pale slate in dark
      // (14.43 / 11.70:1). The action colour is the primary container
      // (pale blue on navy, deep blue on slate; both ≥ 7:1).
      inverseSurface: c.textPrimary,
      onInverseSurface: dark ? c.surfaceRaised : c.surface,
      inversePrimary: c.primaryContainer,
      // Flat surfaces: no M3 elevation tint.
      surfaceTint: Colors.transparent,
    );
  }

  static ThemeData _buildTheme(
    Brightness brightness,
    EmsColors colors, {
    required String fontFamily,
  }) {
    final isArabic = fontFamily == EmsFonts.arabic;
    final c = colors;
    final scheme = colorScheme(brightness, c);
    final type = isArabic ? EmsTypography.arabic : EmsTypography.latin;
    final fallback = [isArabic ? EmsFonts.latin : EmsFonts.arabic];
    TextStyle font(TextStyle style) =>
        style.copyWith(fontFamily: fontFamily, fontFamilyFallback: fallback);
    OutlineInputBorder outline(Color color, [double width = 1]) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(EmsRadius.md),
          borderSide: BorderSide(color: color, width: width),
        );
    // Buttons share the input radius (decision D8: 16 → 12).
    final buttonShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(EmsRadius.md),
    );

    final theme = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      fontFamily: fontFamily,
      fontFamilyFallback: fallback,
      colorScheme: scheme,
      // Material widgets read the EMS scale too (dialogs, snackbars, list
      // tiles, pickers). Tracking is 0 except Latin labelSmall.
      textTheme: _textTheme(type),
      materialTapTargetSize: MaterialTapTargetSize.padded,
      scaffoldBackgroundColor: c.background,
      canvasColor: c.surface,
      dividerColor: c.borderSubtle,
      focusColor: c.focusRing.withValues(alpha: 0.12),
      hoverColor: c.textPrimary.withValues(alpha: 0.04),
      splashColor: c.textPrimary.withValues(alpha: 0.12),
      highlightColor: c.textPrimary.withValues(alpha: 0.08),
      disabledColor: c.textDisabled,
      dividerTheme: DividerThemeData(color: c.borderSubtle, thickness: 1),
      // Flat cards with a 1 px subtle border (D5).
      cardTheme: CardThemeData(
        color: c.surface,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(EmsRadius.lg),
          side: BorderSide(color: c.borderSubtle),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: WidgetStateColor.resolveWith(
          (states) => states.contains(WidgetState.disabled)
              ? c.surfaceSunken
              : c.surface,
        ),
        // 56 dp minimum (D6); inputs grow with the text scale.
        constraints: const BoxConstraints(minHeight: EmsSizes.inputHeight),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: EmsSpacing.lg,
          vertical: EmsSpacing.lg,
        ),
        hintStyle: font(type.bodyMedium).copyWith(color: c.textHint),
        labelStyle: font(type.labelLarge).copyWith(color: c.textPrimary),
        prefixIconColor: c.textSecondary,
        suffixIconColor: c.textSecondary,
        border: outline(c.borderStrong),
        enabledBorder: outline(c.borderStrong),
        disabledBorder: outline(c.borderSubtle),
        focusedBorder: outline(c.primary, 2),
        errorBorder: outline(c.danger, 2),
        focusedErrorBorder: outline(c.danger, 2),
        // Error and helper text follow the locale font and never get Latin
        // tracking in Arabic (it breaks the joining of letters).
        errorStyle: font(type.bodySmall).copyWith(color: c.danger),
        helperStyle: font(type.bodySmall).copyWith(color: c.textSecondary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style:
            ElevatedButton.styleFrom(
              backgroundColor: c.primary,
              foregroundColor: c.onPrimary,
              // Disabled: a fill that differs from the page in both themes
              // plus a subtle edge, so the shape stays visible.
              disabledBackgroundColor: brightness == Brightness.dark
                  ? c.surfaceRaised
                  : c.surfaceSunken,
              disabledForegroundColor: c.textDisabled,
              minimumSize: const Size(double.infinity, EmsSizes.buttonHeight),
              padding: const EdgeInsets.symmetric(horizontal: EmsSpacing.xxl),
              shape: buttonShape,
              textStyle: font(type.titleMedium),
              elevation: 0,
            ).copyWith(
              side: WidgetStateProperty.resolveWith(
                (s) => s.contains(WidgetState.disabled)
                    ? BorderSide(color: c.borderSubtle)
                    : null,
              ),
            ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.disabled)
                ? c.textDisabled
                : c.textPrimary,
          ),
          minimumSize: const WidgetStatePropertyAll(
            Size(double.infinity, EmsSizes.buttonHeight),
          ),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: EmsSpacing.xxl),
          ),
          shape: WidgetStatePropertyAll(buttonShape),
          side: WidgetStateProperty.resolveWith(
            (s) => BorderSide(
              color: s.contains(WidgetState.disabled)
                  ? c.borderSubtle
                  : c.borderStrong,
            ),
          ),
          textStyle: WidgetStatePropertyAll(font(type.titleMedium)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: c.primary,
          disabledForegroundColor: c.textDisabled,
          minimumSize: const Size(EmsSizes.minTap, EmsSizes.minTap),
          shape: buttonShape,
          textStyle: font(type.labelLarge),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: c.textSecondary,
          disabledForegroundColor: c.textDisabled,
          minimumSize: const Size(EmsSizes.minTap, EmsSizes.minTap),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return states.contains(WidgetState.selected)
                ? c.textDisabled
                : Colors.transparent;
          }
          if (states.contains(WidgetState.selected)) return c.primary;
          return Colors.transparent;
        }),
        checkColor: WidgetStatePropertyAll(c.onPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(EmsRadius.xs),
        ),
        side: WidgetStateBorderSide.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? BorderSide(color: c.primary, width: 2)
              : BorderSide(color: c.borderStrong, width: 2),
        ),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return c.primary;
          return c.borderStrong;
        }),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          final on = states.contains(WidgetState.selected);
          if (states.contains(WidgetState.disabled)) {
            return on ? c.surface : c.textDisabled;
          }
          return on ? c.onPrimary : c.textHint;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          final on = states.contains(WidgetState.selected);
          if (states.contains(WidgetState.disabled)) {
            return on ? c.textDisabled : c.surfaceSunken;
          }
          return on ? c.primary : c.borderSubtle;
        }),
        trackOutlineColor: WidgetStateProperty.resolveWith((states) {
          final on = states.contains(WidgetState.selected);
          if (states.contains(WidgetState.disabled)) {
            return on ? c.textDisabled : c.borderSubtle;
          }
          return on ? c.primary : c.borderStrong;
        }),
        trackOutlineWidth: const WidgetStatePropertyAll(2),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: c.primary,
        inactiveTrackColor: c.borderStrong,
        thumbColor: c.primary,
        overlayColor: c.primary.withValues(alpha: 0.12),
        activeTickMarkColor: c.onPrimary,
        inactiveTickMarkColor: c.surface,
        valueIndicatorColor: c.primary,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: c.primary,
        linearTrackColor: c.borderSubtle,
        circularTrackColor: Colors.transparent,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: font(
          type.bodyMedium,
        ).copyWith(color: scheme.onInverseSurface),
        actionTextColor: scheme.inversePrimary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(EmsRadius.md),
        ),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: scheme.inverseSurface,
          borderRadius: BorderRadius.circular(EmsRadius.sm),
        ),
        textStyle: font(
          type.bodySmall,
        ).copyWith(color: scheme.onInverseSurface),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: c.surfaceRaised,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(EmsRadius.xl),
        ),
        titleTextStyle: font(type.headlineSmall).copyWith(color: c.textPrimary),
        contentTextStyle: font(
          type.bodyMedium,
        ).copyWith(color: c.textSecondary),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: c.surfaceRaised,
        modalBackgroundColor: c.surfaceRaised,
        surfaceTintColor: Colors.transparent,
        dragHandleColor: c.borderStrong,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(EmsRadius.xl),
          ),
        ),
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: c.surfaceRaised,
        surfaceTintColor: Colors.transparent,
        headerForegroundColor: c.textPrimary,
        dividerColor: c.borderSubtle,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(EmsRadius.xl),
        ),
      ),
      timePickerTheme: TimePickerThemeData(
        backgroundColor: c.surfaceRaised,
        dialBackgroundColor: c.surfaceSunken,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(EmsRadius.xl),
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: c.surfaceRaised,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(EmsRadius.md),
          side: BorderSide(color: c.borderSubtle),
        ),
      ),
      expansionTileTheme: ExpansionTileThemeData(
        iconColor: c.textSecondary,
        collapsedIconColor: c.textSecondary,
        textColor: c.textPrimary,
        collapsedTextColor: c.textPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: c.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),
      extensions: [colors, type],
    );
    if (!isArabic) return theme;
    // Arabic letters must join: no tracking anywhere, including M3's default
    // display styles and the primary text theme. Even leading keeps Tajawal
    // centred in its tall line boxes.
    return theme.copyWith(
      textTheme: _withoutTracking(theme.textTheme),
      primaryTextTheme: _withoutTracking(theme.primaryTextTheme),
    );
  }

  /// The M3 text theme mapped onto the EMS scale. Styles without an EMS
  /// equivalent (displayLarge/Medium) keep M3's sizes.
  static TextTheme _textTheme(EmsTypography t) {
    TextStyle z(TextStyle s) =>
        s.letterSpacing == null ? s.copyWith(letterSpacing: 0) : s;
    return TextTheme(
      displaySmall: z(t.displaySmall),
      headlineLarge: z(t.headlineLarge),
      headlineMedium: z(t.headlineMedium),
      headlineSmall: z(t.headlineSmall),
      titleLarge: z(t.titleLarge),
      titleMedium: z(t.titleMedium),
      titleSmall: z(t.labelLarge),
      bodyLarge: z(t.bodyLarge),
      bodyMedium: z(t.bodyMedium),
      bodySmall: z(t.bodySmall),
      labelLarge: z(t.labelLarge),
      labelMedium: z(t.labelMedium),
      labelSmall: z(t.labelSmall),
    );
  }

  static TextTheme _withoutTracking(TextTheme t) {
    TextStyle? z(TextStyle? s) => s?.copyWith(
      letterSpacing: 0,
      leadingDistribution: TextLeadingDistribution.even,
    );
    return t.copyWith(
      displayLarge: z(t.displayLarge),
      displayMedium: z(t.displayMedium),
      displaySmall: z(t.displaySmall),
      headlineLarge: z(t.headlineLarge),
      headlineMedium: z(t.headlineMedium),
      headlineSmall: z(t.headlineSmall),
      titleLarge: z(t.titleLarge),
      titleMedium: z(t.titleMedium),
      titleSmall: z(t.titleSmall),
      bodyLarge: z(t.bodyLarge),
      bodyMedium: z(t.bodyMedium),
      bodySmall: z(t.bodySmall),
      labelLarge: z(t.labelLarge),
      labelMedium: z(t.labelMedium),
      labelSmall: z(t.labelSmall),
    );
  }
}
