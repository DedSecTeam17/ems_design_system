import 'package:ems_design_system/ems_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'app_strings.dart';

/// One cell of the golden matrix: theme × text direction × text scale.
class GoldenVariant {
  const GoldenVariant({
    required this.dark,
    required this.rtl,
    required this.textScale,
  });

  final bool dark;

  /// RTL means the Arabic locale with the Arabic (Tajawal) theme, which is
  /// how the app renders right-to-left today.
  final bool rtl;
  final double textScale;

  String get id =>
      '${dark ? 'dark' : 'light'}.${rtl ? 'rtl' : 'ltr'}.ts$textScale';
}

/// light/dark × LTR/RTL × text scale 1.0/1.3.
final List<GoldenVariant> goldenVariants = [
  for (final dark in [false, true])
    for (final rtl in [false, true])
      for (final textScale in [1.0, 1.3])
        GoldenVariant(dark: dark, rtl: rtl, textScale: textScale),
];

/// The theme the app builds for this brightness and script.
ThemeData buildTestTheme({required bool dark, required bool rtl}) {
  final locale = Locale(rtl ? 'ar' : 'en');
  return dark ? EmsTheme.dark(locale: locale) : EmsTheme.light(locale: locale);
}

/// Wraps [child] the way `EmsApp` does: themes, locale, delegates and text
/// scale. The child sits at the top-start of a scaffold.
Widget emsTestApp({
  required Widget child,
  bool dark = false,
  bool rtl = false,
  double textScale = 1.0,
  Key? boundaryKey,
}) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: buildTestTheme(dark: false, rtl: rtl),
    darkTheme: buildTestTheme(dark: true, rtl: rtl),
    themeMode: dark ? ThemeMode.dark : ThemeMode.light,
    locale: Locale(rtl ? 'ar' : 'en'),
    supportedLocales: const [Locale('en'), Locale('ar')],
    localizationsDelegates: const [
      EmsLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    builder: (context, app) => MediaQuery(
      data: MediaQuery.of(
        context,
      ).copyWith(textScaler: TextScaler.linear(textScale)),
      child: app!,
    ),
    home: Scaffold(
      body: RepaintBoundary(
        key: boundaryKey,
        // The scaffold paints its background outside the boundary, so the
        // captured image would be transparent (white in viewers) and dark
        // goldens would show light text on white. Paint the theme background
        // inside the boundary so every golden shows the real surface.
        child: Builder(
          builder: (context) => ColoredBox(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Align(
              alignment: AlignmentDirectional.topStart,
              child: Padding(padding: const EdgeInsets.all(16), child: child),
            ),
          ),
        ),
      ),
    ),
  );
}

/// Returns a sample app label already localized for the ambient locale, the
/// way an app call site passes it in: Arabic from [sampleArabicStrings],
/// otherwise the key itself. Same output as the app's translator, so goldens
/// are unchanged by the extraction (step 2.11).
String t(BuildContext context, String key) =>
    Localizations.localeOf(context).languageCode == 'ar'
    ? sampleArabicStrings[key] ?? key
    : key;

const Key _goldenKey = ValueKey('ems-golden-boundary');

/// Declares one golden test per [goldenVariants] cell for [name].
///
/// Images are written to `goldens/images/<name>/<name>.<variant>.png`
/// relative to the calling test file. [act] runs after the first frame (for
/// example to expand a card or precache an image). Layout overflow is part of
/// today's look (DS-18), so overflow errors are recorded in the image (debug
/// stripes) instead of failing the test. Any other error fails the test.
void emsGolden(
  String name,
  WidgetBuilder builder, {
  Size size = const Size(480, 320),
  Future<void> Function(WidgetTester tester)? act,
  Duration settle = const Duration(milliseconds: 600),
  List<GoldenVariant>? variants,
}) {
  group('$name golden', () {
    for (final variant in variants ?? goldenVariants) {
      testWidgets(variant.id, (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          emsTestApp(
            dark: variant.dark,
            rtl: variant.rtl,
            textScale: variant.textScale,
            boundaryKey: _goldenKey,
            child: Builder(builder: builder),
          ),
        );
        await tester.pump();
        if (act != null) await act(tester);
        await tester.pump(settle);
        _allowOnlyOverflow(tester, '$name.${variant.id}');

        await expectLater(
          find.byKey(_goldenKey),
          matchesGoldenFile('images/$name/$name.${variant.id}.png'),
        );
      });
    }
  });
}

void _allowOnlyOverflow(WidgetTester tester, String golden) {
  for (;;) {
    final error = tester.takeException();
    if (error == null) return;
    final text = error.toString();
    if (error is FlutterError && text.contains('overflowed')) {
      // ignore: avoid_print
      print('golden-overflow: $golden');
      continue;
    }
    throw error as Object;
  }
}

/// Decodes images for real (outside the fake-async zone) so they show up in
/// goldens.
Future<void> precacheImages(
  WidgetTester tester,
  List<ImageProvider> images,
) async {
  final element = tester.element(find.byType(Scaffold).first);
  await tester.runAsync(() async {
    for (final image in images) {
      await precacheImage(image, element);
    }
  });
  await tester.pump();
}

/// Pumps [child] inside [emsTestApp] for behaviour tests.
Future<void> pumpEms(
  WidgetTester tester,
  Widget child, {
  bool dark = false,
  bool rtl = false,
  double textScale = 1.0,
  Size size = const Size(800, 1000),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    emsTestApp(dark: dark, rtl: rtl, textScale: textScale, child: child),
  );
  await tester.pump();
}
