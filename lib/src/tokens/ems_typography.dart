import 'package:flutter/material.dart';

/// The type scale (Latin metrics; no colour, no font family: both come from
/// the theme). 12 px is the smallest size (decision D9a).
///
/// These `const` styles are script-neutral. Inside the design system, and
/// wherever Arabic should get its own metrics, use [EmsTypography.of]: it
/// returns [EmsTypography.arabic] for the `ar` theme (taller line heights,
/// +1 px body and labels, w600 → w700, no tracking).
///
/// Example: `Text(title, style: EmsTypeScale.titleLarge)`
abstract final class EmsTypeScale {
  /// Hero numbers and titles. 36 / w700 / 1.25.
  static const TextStyle displaySmall = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w700,
    height: 1.25,
  );

  /// Page titles. 28 / w700 / 1.3.
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.3,
  );

  /// Section titles. 24 / w700 / 1.3.
  static const TextStyle headlineMedium = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.3,
  );

  /// Card titles. 20 / w600 / 1.35.
  static const TextStyle headlineSmall = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.35,
  );

  /// Group titles. 18 / w600 / 1.4.
  static const TextStyle titleLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  /// Button labels. 16 / w600 / 1.4.
  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  /// Large body text. 16 / w400 / 1.5.
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  /// Default body text and placeholders. 14 / w400 / 1.5.
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  /// Small body text and captions. 12 / w400 / 1.5.
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  /// Field labels, chip, tab and step labels. 14 / w600 / 1.4.
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  /// Small labels, step numbers. 12 / w600 / 1.4.
  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  /// Tiny labels (was 10 px). 12 / w500 / 1.4. Latin tracking +0.4 comes
  /// from [EmsTypography.latin].
  static const TextStyle labelSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  /// Vital-sign values: tabular figures so digits don't jump.
  /// 28 / w700 / 1.2.
  static const TextStyle numericLarge = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.2,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  /// Captions: same as [bodySmall] since step 2.9.
  static const TextStyle caption = bodySmall;

  /// Chip labels: same as [labelMedium] since step 2.9.
  static const TextStyle chip = labelMedium;

  /// Inline links. 14 / w500 / 1.5, underlined.
  static const TextStyle link = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.5,
    decoration: TextDecoration.underline,
  );
}

/// Theme extension carrying the type scale for the theme's script.
///
/// `EmsTheme` installs [latin] or [arabic] depending on the locale.
///
/// Example: `Text(label, style: EmsTypography.of(context).labelLarge)`
@immutable
class EmsTypography extends ThemeExtension<EmsTypography> {
  /// Creates a type scale.
  const EmsTypography({
    required this.displaySmall,
    required this.headlineLarge,
    required this.headlineMedium,
    required this.headlineSmall,
    required this.titleLarge,
    required this.titleMedium,
    required this.bodyLarge,
    required this.bodyMedium,
    required this.bodySmall,
    required this.labelLarge,
    required this.labelMedium,
    required this.labelSmall,
    required this.numericLarge,
    required this.caption,
    required this.chip,
    required this.link,
  });

  /// Latin (Roboto): [EmsTypeScale] plus +0.4 tracking on [labelSmall].
  static const EmsTypography latin = EmsTypography(
    displaySmall: EmsTypeScale.displaySmall,
    headlineLarge: EmsTypeScale.headlineLarge,
    headlineMedium: EmsTypeScale.headlineMedium,
    headlineSmall: EmsTypeScale.headlineSmall,
    titleLarge: EmsTypeScale.titleLarge,
    titleMedium: EmsTypeScale.titleMedium,
    bodyLarge: EmsTypeScale.bodyLarge,
    bodyMedium: EmsTypeScale.bodyMedium,
    bodySmall: EmsTypeScale.bodySmall,
    labelLarge: EmsTypeScale.labelLarge,
    labelMedium: EmsTypeScale.labelMedium,
    labelSmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      height: 1.4,
      letterSpacing: 0.4,
    ),
    numericLarge: EmsTypeScale.numericLarge,
    caption: EmsTypeScale.caption,
    chip: EmsTypeScale.chip,
    link: EmsTypeScale.link,
  );

  /// The default scale: [latin].
  static const EmsTypography base = latin;

  /// Arabic (Tajawal), VISUAL_PROPOSAL §3:
  /// - line height ≥ 1.5 for headings and 1.65–1.75 for body and labels,
  ///   because Tajawal's glyphs reach 1.39–1.48 em;
  /// - +1 px on body and label sizes (decision D9b);
  /// - Tajawal has no 600 weight, so 600 is mapped to 700 explicitly
  ///   (DS-35) instead of being left to font matching;
  /// - no letter spacing (it breaks the joining of Arabic letters);
  /// - even leading, so the extra line height sits equally above and below
  ///   the glyphs and labels stay vertically centred.
  static const EmsTypography arabic = EmsTypography(
    displaySmall: TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.w700,
      height: 1.5,
      letterSpacing: 0,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    headlineLarge: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w700,
      height: 1.5,
      letterSpacing: 0,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    headlineMedium: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      height: 1.5,
      letterSpacing: 0,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    headlineSmall: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      height: 1.55,
      letterSpacing: 0,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    titleLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      height: 1.6,
      letterSpacing: 0,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      height: 1.6,
      letterSpacing: 0,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    bodyLarge: TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w400,
      height: 1.75,
      letterSpacing: 0,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    bodyMedium: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      height: 1.75,
      letterSpacing: 0,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    bodySmall: TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      height: 1.7,
      letterSpacing: 0,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    labelLarge: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w700,
      height: 1.65,
      letterSpacing: 0,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    labelMedium: TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w700,
      height: 1.65,
      letterSpacing: 0,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    labelSmall: TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      height: 1.65,
      letterSpacing: 0,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    numericLarge: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w700,
      height: 1.4,
      letterSpacing: 0,
      leadingDistribution: TextLeadingDistribution.even,
      fontFeatures: [FontFeature.tabularFigures()],
    ),
    caption: TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      height: 1.7,
      letterSpacing: 0,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    chip: TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w700,
      height: 1.65,
      letterSpacing: 0,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    link: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w500,
      height: 1.75,
      letterSpacing: 0,
      leadingDistribution: TextLeadingDistribution.even,
      decoration: TextDecoration.underline,
    ),
  );

  /// [latin] tracking for Latin scripts, 0 for Arabic: letter spacing breaks
  /// the joining of Arabic letters (DS-16).
  static double letterSpacing(BuildContext context, double latin) =>
      Localizations.maybeLocaleOf(context)?.languageCode == 'ar' ? 0 : latin;

  /// The scale of the nearest theme, or [base] when the theme has none.
  static EmsTypography of(BuildContext context) =>
      Theme.of(context).extension<EmsTypography>() ?? base;

  /// Hero numbers and titles.
  final TextStyle displaySmall;

  /// Page titles.
  final TextStyle headlineLarge;

  /// Section titles.
  final TextStyle headlineMedium;

  /// Card titles.
  final TextStyle headlineSmall;

  /// Group titles.
  final TextStyle titleLarge;

  /// Button labels.
  final TextStyle titleMedium;

  /// Large body text.
  final TextStyle bodyLarge;

  /// Default body text and placeholders.
  final TextStyle bodyMedium;

  /// Small body text and captions.
  final TextStyle bodySmall;

  /// Field labels; chip, tab and step labels.
  final TextStyle labelLarge;

  /// Small labels, step numbers.
  final TextStyle labelMedium;

  /// Tiny labels (12 px minimum).
  final TextStyle labelSmall;

  /// Vital-sign values (tabular figures).
  final TextStyle numericLarge;

  /// Captions (same as [bodySmall]).
  final TextStyle caption;

  /// Chip labels (same as [labelMedium]).
  final TextStyle chip;

  /// Inline links.
  final TextStyle link;

  @override
  EmsTypography copyWith({
    TextStyle? displaySmall,
    TextStyle? headlineLarge,
    TextStyle? headlineMedium,
    TextStyle? headlineSmall,
    TextStyle? titleLarge,
    TextStyle? titleMedium,
    TextStyle? bodyLarge,
    TextStyle? bodyMedium,
    TextStyle? bodySmall,
    TextStyle? labelLarge,
    TextStyle? labelMedium,
    TextStyle? labelSmall,
    TextStyle? numericLarge,
    TextStyle? caption,
    TextStyle? chip,
    TextStyle? link,
  }) {
    return EmsTypography(
      displaySmall: displaySmall ?? this.displaySmall,
      headlineLarge: headlineLarge ?? this.headlineLarge,
      headlineMedium: headlineMedium ?? this.headlineMedium,
      headlineSmall: headlineSmall ?? this.headlineSmall,
      titleLarge: titleLarge ?? this.titleLarge,
      titleMedium: titleMedium ?? this.titleMedium,
      bodyLarge: bodyLarge ?? this.bodyLarge,
      bodyMedium: bodyMedium ?? this.bodyMedium,
      bodySmall: bodySmall ?? this.bodySmall,
      labelLarge: labelLarge ?? this.labelLarge,
      labelMedium: labelMedium ?? this.labelMedium,
      labelSmall: labelSmall ?? this.labelSmall,
      numericLarge: numericLarge ?? this.numericLarge,
      caption: caption ?? this.caption,
      chip: chip ?? this.chip,
      link: link ?? this.link,
    );
  }

  @override
  EmsTypography lerp(EmsTypography? other, double t) {
    if (other is! EmsTypography) return this;
    return EmsTypography(
      displaySmall: TextStyle.lerp(displaySmall, other.displaySmall, t)!,
      headlineLarge: TextStyle.lerp(headlineLarge, other.headlineLarge, t)!,
      headlineMedium: TextStyle.lerp(headlineMedium, other.headlineMedium, t)!,
      headlineSmall: TextStyle.lerp(headlineSmall, other.headlineSmall, t)!,
      titleLarge: TextStyle.lerp(titleLarge, other.titleLarge, t)!,
      titleMedium: TextStyle.lerp(titleMedium, other.titleMedium, t)!,
      bodyLarge: TextStyle.lerp(bodyLarge, other.bodyLarge, t)!,
      bodyMedium: TextStyle.lerp(bodyMedium, other.bodyMedium, t)!,
      bodySmall: TextStyle.lerp(bodySmall, other.bodySmall, t)!,
      labelLarge: TextStyle.lerp(labelLarge, other.labelLarge, t)!,
      labelMedium: TextStyle.lerp(labelMedium, other.labelMedium, t)!,
      labelSmall: TextStyle.lerp(labelSmall, other.labelSmall, t)!,
      numericLarge: TextStyle.lerp(numericLarge, other.numericLarge, t)!,
      caption: TextStyle.lerp(caption, other.caption, t)!,
      chip: TextStyle.lerp(chip, other.chip, t)!,
      link: TextStyle.lerp(link, other.link, t)!,
    );
  }
}
