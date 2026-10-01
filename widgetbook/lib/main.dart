// Widgetbook catalog of the EMS design system (decision D12: local only).
//
// Run:   flutter run -d chrome          (from this folder)
// Build: dart run build_runner build -d && flutter build web --release
//
// Code generation writes `main.directories.g.dart` from the @UseCase
// annotations in lib/use_cases/. The generator's telemetry builder is
// disabled in build.yaml.
import 'package:ems_design_system/ems_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'main.directories.g.dart';

void main() => runApp(const EmsWidgetbook());

/// The catalog app.
@widgetbook.App()
class EmsWidgetbook extends StatelessWidget {
  /// Creates the catalog. [initialRoute] opens a use case with addon
  /// settings, e.g. `/?path=buttons/emsbutton/playground&locale={name:ar}`.
  const EmsWidgetbook({super.key, this.initialRoute = '/'});

  /// The route to open first.
  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      initialRoute: initialRoute,
      directories: directories,
      // Addons wrap the use case from the first (outermost) to the last.
      addons: [
        // Tablet viewports: the app's primary target is Android tablets.
        // (DeviceFrameAddon is deprecated in 3.21 in favour of this addon.)
        // "None" first, so components render at the canvas size by default.
        ViewportAddon([
          Viewports.none,
          AndroidViewports.mediumTablet,
          AndroidViewports.largeTablet,
          IosViewports.iPad,
        ]),
        // English (LTR) / Arabic (RTL). Localizations also sets the text
        // direction, so Arabic renders right-to-left.
        LocalizationAddon(
          locales: EmsLocalizations.supportedLocales,
          localizationsDelegates: const [
            EmsLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          initialLocale: const Locale('en'),
        ),
        // EmsTheme light/dark. The theme is built for the selected locale,
        // exactly like the app: Arabic gets Tajawal and the Arabic metrics.
        ThemeAddon<Brightness>(
          themes: const [
            WidgetbookTheme(name: 'Light', data: Brightness.light),
            WidgetbookTheme(name: 'Dark', data: Brightness.dark),
          ],
          themeBuilder: (context, brightness, child) {
            final locale = Localizations.localeOf(context);
            final theme = brightness == Brightness.dark
                ? EmsTheme.dark(locale: locale)
                : EmsTheme.light(locale: locale);
            return Theme(
              data: theme,
              child: Material(
                color: theme.scaffoldBackgroundColor,
                child: child,
              ),
            );
          },
        ),
        // 1.0 (default), 1.3 (the accessibility target) and 2.0 (the
        // stress check): a 0.1 step slider from 1.0 to 2.0.
        TextScaleAddon(min: 1.0, max: 2.0, divisions: 10, initialScale: 1.0),
      ],
    );
  }
}
