/// The EMS design system.
///
/// Tokens ([EmsColors], [EmsTypography], [EmsSpacing], [EmsRadius],
/// [EmsSizes], [EmsIconSize], [EmsMotion], [EmsElevation], [EmsTone],
/// [EmsAccent]), the theme ([EmsTheme], [EmsFonts], [EmsInputDecoration]),
/// the design system's own strings ([EmsLocalizations]) and the `Ems*`
/// widgets.
///
/// ```dart
/// MaterialApp(
///   theme: EmsTheme.light(locale: locale),
///   darkTheme: EmsTheme.dark(locale: locale),
///   localizationsDelegates: const [
///     EmsLocalizations.delegate,
///     GlobalMaterialLocalizations.delegate,
///     GlobalWidgetsLocalizations.delegate,
///     GlobalCupertinoLocalizations.delegate,
///   ],
///   supportedLocales: EmsLocalizations.supportedLocales,
/// )
/// ```
library;

// Tokens
export 'src/tokens/ems_colors.dart';
export 'src/tokens/ems_elevation.dart';
export 'src/tokens/ems_motion.dart';
export 'src/tokens/ems_sizes.dart';
export 'src/tokens/ems_spacing.dart';
export 'src/tokens/ems_tone.dart';
export 'src/tokens/ems_typography.dart';

// Theme
export 'src/theme/ems_input_decoration.dart';
export 'src/theme/ems_theme.dart';

// Localization (the design system's own strings only)
export 'src/l10n/ems_localizations.dart';

// Widgets
export 'src/widgets/ems_alert_banner.dart';
export 'src/widgets/ems_avatar.dart';
export 'src/widgets/ems_bottom_step_nav.dart';
export 'src/widgets/ems_button.dart';
export 'src/widgets/ems_card.dart';
export 'src/widgets/ems_chip.dart';
export 'src/widgets/ems_choice_chips.dart';
export 'src/widgets/ems_data_table.dart';
export 'src/widgets/ems_date_time_field.dart';
export 'src/widgets/ems_divider_with_text.dart';
export 'src/widgets/ems_icon_badge.dart';
export 'src/widgets/ems_loading_overlay.dart';
export 'src/widgets/ems_member_chip.dart';
export 'src/widgets/ems_notification_item.dart';
export 'src/widgets/ems_search_bar.dart';
export 'src/widgets/ems_segmented_control.dart';
export 'src/widgets/ems_selection_card.dart';
export 'src/widgets/ems_shimmer_box.dart';
export 'src/widgets/ems_sidebar.dart';
export 'src/widgets/ems_slider_field.dart';
export 'src/widgets/ems_step_indicator.dart';
export 'src/widgets/ems_tappable.dart';
export 'src/widgets/ems_text_area.dart';
export 'src/widgets/ems_text_field.dart';
export 'src/widgets/ems_tile_selector.dart';
export 'src/widgets/ems_toggle_row.dart';
export 'src/widgets/ems_top_bar.dart';
export 'src/widgets/ems_vital_sign_card.dart';
