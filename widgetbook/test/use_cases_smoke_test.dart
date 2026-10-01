// Opens every Widgetbook use case through the real catalog shell and its
// addons, in English/light/1.0 and in Arabic/dark/2.0, and fails on any
// framework error (overflow, missing theme extension or localization,
// assertion). It doesn't compare pixels: the package's golden tests do that.
import 'package:ems_widgetbook/main.dart';
import 'package:ems_widgetbook/main.directories.g.dart';
import 'package:ems_widgetbook/support.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widgetbook/widgetbook.dart';

/// Every use case with its Widgetbook path (`category/component/use-case`).
List<(String, String)> _useCases() {
  final out = <(String, String)>[];
  void walk(WidgetbookNode node, List<String> names) {
    final path = [...names, node.name];
    if (node is WidgetbookUseCase) {
      out.add((
        path.join('/').replaceAll(' ', '-').toLowerCase(),
        path.join(' / '),
      ));
      return;
    }
    for (final child in node.children ?? const <WidgetbookNode>[]) {
      walk(child, path);
    }
  }

  for (final node in directories) {
    walk(node, const []);
  }
  return out;
}

/// Use cases with a known defect, skipped with their DS finding ID (the
/// project's known-bug convention) until the fix is approved.
const _knownIssues = {
  'navigation/emsnotificationitem/playground':
      'DS-36 known issue — the location text is not flexible and overflows '
      'the row when it is long (needs-decision: ellipsis or wrap); '
      'docs/design-system/AUDIT.md',
};

void main() {
  final useCases = _useCases();

  test('the catalog has a use case for every component', () {
    expect(useCases.length, greaterThanOrEqualTo(30));
  });

  const settings = {
    'en, light, 1.0':
        '&locale={name:en}&theme={name:Light}'
        '&text-scale={factor:1.0}',
    'ar, dark, 2.0':
        '&locale={name:ar}&theme={name:Dark}'
        '&text-scale={factor:2.0}',
  };

  for (final (path, title) in useCases) {
    for (final entry in settings.entries) {
      testWidgets('$title (${entry.key})', skip: _knownIssues[path] != null, (
        tester,
      ) async {
        tester.view.physicalSize = const Size(1600, 1400);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          EmsWidgetbook(initialRoute: '/?path=$path${entry.value}'),
        );
        // Shimmers animate forever, so pump a fixed time instead of settling.
        await tester.pump(const Duration(milliseconds: 500));
        expect(tester.takeException(), isNull);
        // The use case really rendered (not the Widgetbook home page): an
        // Ems* widget, or the token showcases' frame.
        final useCase = find.byWidgetPredicate(
          (w) =>
              w is Showcase ||
              (w is! EmsWidgetbook &&
                  w.runtimeType.toString().startsWith('Ems')),
        );
        expect(useCase, findsWidgets);
        // The locale addon drives the text direction.
        expect(
          Directionality.of(tester.element(useCase.last)),
          entry.key.startsWith('ar') ? TextDirection.rtl : TextDirection.ltr,
        );
      });
    }
  }
}
