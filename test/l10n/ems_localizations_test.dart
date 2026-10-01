import 'package:ems_design_system/ems_design_system.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Future<EmsLocalizations> _lookup(
  WidgetTester tester, {
  required Locale locale,
  required bool withDelegate,
}) async {
  late EmsLocalizations result;
  await tester.pumpWidget(
    Localizations(
      locale: locale,
      delegates: [
        DefaultWidgetsLocalizations.delegate,
        if (withDelegate) EmsLocalizations.delegate,
      ],
      child: Builder(
        builder: (context) {
          result = EmsLocalizations.of(context);
          return const SizedBox();
        },
      ),
    ),
  );
  return result;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('EmsLocalizations', () {
    test('English strings match what the widgets showed before 2.3', () {
      const l = EmsLocalizationsEn();
      expect(l.previous, 'Prev');
      expect(l.next, 'Next');
      expect(l.stepOf(3, 6), 'Step 3 of 6');
      expect(l.selectedCount(2), '2 selected');
      expect(l.search, 'Search');
    });

    test('Arabic strings match what the widgets showed before 2.3', () {
      const l = EmsLocalizationsAr();
      expect(l.previous, 'السابق');
      expect(l.next, 'التالي');
      expect(l.stepOf(3, 6), 'الخطوة 3 من 6');
      expect(l.selectedCount(2), '2 مختار');
      expect(l.search, 'بحث');
    });

    test('supports en and ar only', () {
      expect(EmsLocalizations.delegate.isSupported(const Locale('en')), isTrue);
      expect(EmsLocalizations.delegate.isSupported(const Locale('ar')), isTrue);
      expect(
        EmsLocalizations.delegate.isSupported(const Locale('fr')),
        isFalse,
      );
    });

    testWidgets('loads Arabic through the delegate', (tester) async {
      final l = await _lookup(
        tester,
        locale: const Locale('ar'),
        withDelegate: true,
      );
      expect(l, isA<EmsLocalizationsAr>());
    });

    testWidgets('falls back to the locale when the delegate is missing', (
      tester,
    ) async {
      final ar = await _lookup(
        tester,
        locale: const Locale('ar'),
        withDelegate: false,
      );
      expect(ar, isA<EmsLocalizationsAr>());
      final en = await _lookup(
        tester,
        locale: const Locale('en'),
        withDelegate: false,
      );
      expect(en, isA<EmsLocalizationsEn>());
    });

    testWidgets('falls back to English without any Localizations', (
      tester,
    ) async {
      late EmsLocalizations l;
      await tester.pumpWidget(
        Builder(
          builder: (context) {
            l = EmsLocalizations.of(context);
            return const SizedBox();
          },
        ),
      );
      expect(l, isA<EmsLocalizationsEn>());
    });
  });
}
