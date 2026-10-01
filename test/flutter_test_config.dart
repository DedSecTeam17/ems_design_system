// Loads real fonts for every test in the package, so goldens show real glyphs
// instead of the test font's boxes.
//
// The package bundles both families, weights 400/500/700 (decision D9):
// - Latin: Roboto (assets/fonts/latin, Apache-2.0).
// - Arabic: Tajawal (assets/fonts/arabic, SIL OFL 1.1).
// - Icons: MaterialIcons (`uses-material-design: true`).
//
// The theme names the fonts with the package prefix
// (`packages/ems_design_system/Roboto`, see EmsFonts), which is how an app
// that depends on the package registers them. When the package's own tests
// run, the package is the root project and its manifest lists the bare names
// (`Roboto`, `Tajawal`). Each family is therefore registered under the name
// the theme uses, from exactly the files the package ships.
import 'dart:async';
import 'dart:convert';

import 'package:ems_design_system/ems_design_system.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await loadDesignSystemTestFonts();
  await testMain();
}

bool _fontsLoaded = false;

/// Manifest family (bare or package-prefixed) -> the family the theme uses.
const _families = {
  'Roboto': EmsFonts.latin,
  EmsFonts.latin: EmsFonts.latin,
  'Tajawal': EmsFonts.arabic,
  EmsFonts.arabic: EmsFonts.arabic,
  'MaterialIcons': 'MaterialIcons',
};

/// Loads Roboto, Tajawal and MaterialIcons from the font manifest.
/// Safe to call more than once. Fails loudly if a family is missing.
Future<void> loadDesignSystemTestFonts() async {
  if (_fontsLoaded) return;
  _fontsLoaded = true;

  final manifest =
      json.decode(await rootBundle.loadString('FontManifest.json'))
          as List<dynamic>;
  final loaded = <String>{};
  for (final entry in manifest.cast<Map<String, dynamic>>()) {
    final family = _families[entry['family'] as String];
    if (family == null) continue;
    final loader = FontLoader(family);
    for (final font in (entry['fonts'] as List).cast<Map<String, dynamic>>()) {
      loader.addFont(rootBundle.load(font['asset'] as String));
    }
    await loader.load();
    loaded.add(family);
  }
  final missing = _families.values.toSet().difference(loaded);
  if (missing.isNotEmpty) {
    throw StateError(
      'Design-system test fonts missing from FontManifest.json: $missing. '
      'Check the `fonts:` section of the package pubspec.yaml.',
    );
  }
}
