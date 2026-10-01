// Guards the design system's independence from the app (DS-01, DS-10): the
// package must build on its own once it moves to its own repository.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

const _libDir = 'lib';

final _forbidden = <String, RegExp>{
  'the app package': RegExp(r"import 'package:ems_mobile_app/"),
  'app entry point (main.dart)': RegExp(r"import '[^']*main\.dart'"),
  'app features': RegExp(r"import '[^']*features/"),
  'app navigation / GetIt': RegExp(r"import '[^']*navigation/"),
  'app localization (.tr)': RegExp(r"import '[^']*localization/"),
  'state management': RegExp(r"import 'package:(provider|get_it)/"),
  'files outside the package': RegExp(r"import '(\.\./){3,}"),
};

void main() {
  final files = Directory(_libDir)
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'))
      .toList();

  test('finds the design-system sources', () {
    expect(files, isNotEmpty);
  });

  for (final entry in _forbidden.entries) {
    test('design system does not import ${entry.key}', () {
      final offenders = [
        for (final f in files)
          if (entry.value.hasMatch(f.readAsStringSync())) f.path,
      ];
      expect(offenders, isEmpty);
    });
  }

  test('design system does not call the app translator', () {
    final offenders = [
      for (final f in files)
        if (RegExp(r'\.tr\(context').hasMatch(f.readAsStringSync())) f.path,
    ];
    expect(offenders, isEmpty);
  });
}
