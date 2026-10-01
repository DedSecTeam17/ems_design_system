import 'package:ems_design_system/ems_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/ems_test_app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('RTL', () {
    testWidgets('avatar online dot sits at the end corner', (tester) async {
      for (final rtl in [false, true]) {
        await pumpEms(
          tester,
          const EmsAvatar(initials: 'AB', showOnlineIndicator: true),
          rtl: rtl,
        );
        final avatar = tester.getCenter(find.byType(CircleAvatar));
        final dot = tester.getCenter(find.byType(PositionedDirectional));
        expect(rtl ? dot.dx < avatar.dx : dot.dx > avatar.dx, isTrue);
      }
    });

    testWidgets('no letter spacing on Arabic text', (tester) async {
      Future<double?> spacing({required bool rtl}) async {
        await pumpEms(
          tester,
          const SizedBox(
            width: 400,
            child: EmsSliderField(
              label: 'L',
              value: 2,
              minLabel: 'min',
              maxLabel: 'max',
            ),
          ),
          rtl: rtl,
        );
        return tester.widget<Text>(find.text('min')).style!.letterSpacing;
      }

      expect(await spacing(rtl: false), 0.5);
      expect(await spacing(rtl: true), 0);
    });

    testWidgets('vital sign and table labels drop tracking in Arabic', (
      tester,
    ) async {
      await pumpEms(
        tester,
        const SizedBox(
          width: 400,
          child: Column(
            children: [
              EmsVitalSignCard(label: 'p', typeLabel: 'int', unit: 'u'),
              EmsDataTable(columns: ['c'], rows: []),
            ],
          ),
        ),
        rtl: true,
      );
      for (final text in ['P', 'INT', 'C']) {
        expect(
          tester.widget<Text>(find.text(text)).style!.letterSpacing,
          0,
          reason: text,
        );
      }
    });

    testWidgets(
      'field error and helper text use Tajawal without tracking in Arabic',
      (tester) async {
        await pumpEms(
          tester,
          SizedBox(
            width: 400,
            child: EmsTextField(
              label: 'الهوية الوطنية',
              helperText: 'مساعدة',
              autovalidateMode: AutovalidateMode.always,
              validator: (_) => 'هذا الحقل مطلوب',
            ),
          ),
          rtl: true,
        );
        for (final text in ['هذا الحقل مطلوب', 'الهوية الوطنية']) {
          final paragraph = tester.renderObject<RenderParagraph>(
            find.text(text, findRichText: true).last,
          );
          final style = paragraph.text.style!;
          expect(style.fontFamily, EmsFonts.arabic, reason: text);
          expect(style.letterSpacing ?? 0, 0, reason: text);
        }
      },
    );

    test('the Arabic text theme has no letter spacing', () {
      for (final theme in [
        EmsTheme.light(locale: const Locale('ar')),
        EmsTheme.dark(locale: const Locale('ar')),
      ]) {
        final t = theme.textTheme;
        for (final style in [
          t.bodySmall,
          t.bodyMedium,
          t.bodyLarge,
          t.labelSmall,
          t.labelMedium,
          t.labelLarge,
          t.titleMedium,
        ]) {
          expect(style!.letterSpacing, 0);
          expect(style.fontFamily, EmsFonts.arabic);
        }
      }
    });

    testWidgets('shimmer gradient is directional', (tester) async {
      await pumpEms(tester, const EmsShimmerBox(height: 10, width: 100));
      final box = tester.widget<Container>(
        find.descendant(
          of: find.byType(EmsShimmerBox),
          matching: find.byType(Container),
        ),
      );
      final gradient =
          (box.decoration! as BoxDecoration).gradient! as LinearGradient;
      expect(gradient.begin, isA<AlignmentDirectional>());
    });

    test('EmsTypography.letterSpacing has no context-free surprises', () {
      expect(EmsTypeScale.labelSmall.letterSpacing, isNull);
    });
  });
}
