import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// The design system's own built-in strings (English and Arabic).
///
/// App and domain strings are never translated by the design system: widgets
/// take already-localized `String`s. Only the few labels a component owns
/// (wizard "Prev"/"Next", "Step x of y", "n selected", accessibility labels)
/// come from here.
///
/// Register [delegate] next to the Material delegates:
/// ```dart
/// MaterialApp(
///   localizationsDelegates: const [
///     EmsLocalizations.delegate,
///     GlobalMaterialLocalizations.delegate,
///     GlobalWidgetsLocalizations.delegate,
///   ],
/// )
/// ```
/// If the delegate is missing, [of] falls back to the strings for the
/// ambient locale (Arabic for `ar`, otherwise English).
abstract class EmsLocalizations {
  /// Creates the strings for one language.
  const EmsLocalizations();

  /// Loads [EmsLocalizations] for `en` and `ar`.
  static const LocalizationsDelegate<EmsLocalizations> delegate =
      _EmsLocalizationsDelegate();

  /// Locales with built-in strings.
  static const List<Locale> supportedLocales = [Locale('en'), Locale('ar')];

  /// The strings for [context]'s locale.
  static EmsLocalizations of(BuildContext context) {
    return Localizations.of<EmsLocalizations>(context, EmsLocalizations) ??
        forLocale(Localizations.maybeLocaleOf(context));
  }

  /// The strings for [locale] (English for anything but Arabic).
  static EmsLocalizations forLocale(Locale? locale) =>
      locale?.languageCode == 'ar'
      ? const EmsLocalizationsAr()
      : const EmsLocalizationsEn();

  /// Wizard back button.
  String get previous;

  /// Wizard forward button.
  String get next;

  /// "Step [current] of [total]".
  String stepOf(int current, int total);

  /// "[count] selected".
  String selectedCount(int count);

  /// Default search hint.
  String get search;

  /// Semantics hint for the required-field marker.
  String get required;

  /// Password visibility toggle, while the text is hidden.
  String get showPassword;

  /// Password visibility toggle, while the text is shown.
  String get hidePassword;

  /// Busy state of buttons and overlays.
  String get loading;

  /// Clear action.
  String get clear;

  /// Semantics label for the empty-value placeholder.
  String get noValue;

  /// Completed step.
  String get completed;

  /// Selected item.
  String get selected;

  /// Expand a collapsible section.
  String get expand;

  /// Collapse an expandable section.
  String get collapse;

  /// Open an item's details.
  String get open;
}

/// English design-system strings.
class EmsLocalizationsEn extends EmsLocalizations {
  /// Creates the English strings.
  const EmsLocalizationsEn();

  @override
  String get previous => 'Prev';
  @override
  String get next => 'Next';
  @override
  String stepOf(int current, int total) => 'Step $current of $total';
  @override
  String selectedCount(int count) => '$count selected';
  @override
  String get search => 'Search';
  @override
  String get required => 'Required';
  @override
  String get showPassword => 'Show password';
  @override
  String get hidePassword => 'Hide password';
  @override
  String get loading => 'Loading';
  @override
  String get clear => 'Clear';
  @override
  String get noValue => 'No value';
  @override
  String get completed => 'Completed';
  @override
  String get selected => 'Selected';
  @override
  String get expand => 'Expand';
  @override
  String get collapse => 'Collapse';
  @override
  String get open => 'Open';
}

/// Arabic design-system strings.
class EmsLocalizationsAr extends EmsLocalizations {
  /// Creates the Arabic strings.
  const EmsLocalizationsAr();

  @override
  String get previous => 'السابق';
  @override
  String get next => 'التالي';
  @override
  String stepOf(int current, int total) => 'الخطوة $current من $total';
  @override
  String selectedCount(int count) => '$count مختار';
  @override
  String get search => 'بحث';
  @override
  String get required => 'مطلوب';
  @override
  String get showPassword => 'إظهار كلمة المرور';
  @override
  String get hidePassword => 'إخفاء كلمة المرور';
  @override
  String get loading => 'جارٍ التحميل';
  @override
  String get clear => 'مسح';
  @override
  String get noValue => 'لا توجد قيمة';
  @override
  String get completed => 'مكتمل';
  @override
  String get selected => 'محدد';
  @override
  String get expand => 'توسيع';
  @override
  String get collapse => 'طي';
  @override
  String get open => 'فتح';
}

class _EmsLocalizationsDelegate
    extends LocalizationsDelegate<EmsLocalizations> {
  const _EmsLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      locale.languageCode == 'en' || locale.languageCode == 'ar';

  @override
  Future<EmsLocalizations> load(Locale locale) =>
      SynchronousFuture<EmsLocalizations>(EmsLocalizations.forLocale(locale));

  @override
  bool shouldReload(_EmsLocalizationsDelegate old) => false;
}
