import 'package:ems_design_system/ems_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Until 0.1.0 these tests checked the deprecated AppSpacing / AppTextStyles
  // shims. The shims are gone (step 2.11); the same values are now checked
  // on the Ems scales directly.
  group('step 2.9 scales', () {
    test('spacing, radius, size and icon scales (D6, D8, D10)', () {
      expect(
        [
          EmsSpacing.xs,
          EmsSpacing.sm,
          EmsSpacing.md,
          EmsSpacing.lg,
          EmsSpacing.xl,
          EmsSpacing.xxl,
          EmsSpacing.xxxl,
          EmsSpacing.huge,
          EmsSpacing.massive,
        ],
        [4, 8, 12, 16, 20, 24, 32, 40, 48],
      );
      expect(
        [
          EmsRadius.sm,
          EmsRadius.md,
          EmsRadius.lg,
          EmsRadius.xl,
          EmsRadius.full,
        ],
        [8, 12, 16, 20, 100],
      );
      expect(EmsSizes.buttonHeight, 56);
      expect(EmsSizes.inputHeight, 56);
      expect(
        [EmsIconSize.sm, EmsIconSize.md, EmsIconSize.lg, EmsIconSize.xl],
        [20, 24, 32, 40],
      );
    });

    test('EmsTypeScale (D9)', () {
      void check(TextStyle s, double size, FontWeight w, double h) {
        expect([s.fontSize, s.fontWeight, s.height], [size, w, h]);
        expect(s.fontFamily, isNull);
        expect(s.color, isNull);
      }

      check(EmsTypeScale.displaySmall, 36, FontWeight.w700, 1.25);
      check(EmsTypeScale.headlineLarge, 28, FontWeight.w700, 1.3);
      check(EmsTypeScale.headlineMedium, 24, FontWeight.w700, 1.3);
      check(EmsTypeScale.headlineSmall, 20, FontWeight.w600, 1.35);
      check(EmsTypeScale.titleLarge, 18, FontWeight.w600, 1.4);
      check(EmsTypeScale.titleMedium, 16, FontWeight.w600, 1.4);
      check(EmsTypeScale.bodyLarge, 16, FontWeight.w400, 1.5);
      check(EmsTypeScale.bodyMedium, 14, FontWeight.w400, 1.5);
      check(EmsTypeScale.bodySmall, 12, FontWeight.w400, 1.5);
      check(EmsTypeScale.labelLarge, 14, FontWeight.w600, 1.4);
      check(EmsTypeScale.labelMedium, 12, FontWeight.w600, 1.4);
      check(EmsTypeScale.labelSmall, 12, FontWeight.w500, 1.4);
      check(EmsTypeScale.caption, 12, FontWeight.w400, 1.5);
      check(EmsTypeScale.chip, 12, FontWeight.w600, 1.4);
      check(EmsTypeScale.link, 14, FontWeight.w500, 1.5);
    });
  });

  group('EmsTheme', () {
    test('names Tajawal for Arabic and Roboto otherwise (D9)', () {
      // The fonts ship with the package, so their families carry the
      // package prefix (step 2.11).
      expect(EmsFonts.latin, 'packages/ems_design_system/Roboto');
      expect(EmsFonts.arabic, 'packages/ems_design_system/Tajawal');
      expect(
        EmsTheme.light(
          locale: const Locale('ar'),
        ).textTheme.bodyMedium!.fontFamily,
        EmsFonts.arabic,
      );
      expect(
        EmsTheme.dark(
          locale: const Locale('ar'),
        ).textTheme.bodyMedium!.fontFamily,
        EmsFonts.arabic,
      );
      for (final theme in [
        EmsTheme.light(locale: const Locale('en')),
        EmsTheme.dark(),
      ]) {
        expect(theme.textTheme.bodyMedium!.fontFamily, EmsFonts.latin);
        expect(theme.textTheme.labelLarge!.fontFamily, EmsFonts.latin);
        // Material buttons name the family too, so goldens and devices
        // don't fall back to a platform or test font.
        final button = theme.elevatedButtonTheme.style!.textStyle!.resolve({});
        expect(button!.fontFamily, EmsFonts.latin);
        expect(button.fontFamilyFallback, [EmsFonts.arabic]);
      }
      expect(EmsTheme.light().brightness, Brightness.light);
      expect(EmsTheme.dark().brightness, Brightness.dark);
    });

    test('carries the colour and type extensions', () {
      final theme = EmsTheme.dark();
      expect(theme.extension<EmsColors>(), same(EmsColors.dark));
      expect(theme.extension<EmsTypography>(), same(EmsTypography.latin));
      expect(
        EmsTheme.light(locale: const Locale('ar')).extension<EmsTypography>(),
        same(EmsTypography.arabic),
      );
    });

    test('the type scale has a 12 px minimum (D9a)', () {
      for (final t in [EmsTypography.latin, EmsTypography.arabic]) {
        for (final s in [
          t.bodySmall,
          t.labelMedium,
          t.labelSmall,
          t.caption,
          t.chip,
        ]) {
          expect(s.fontSize, greaterThanOrEqualTo(12));
        }
      }
    });

    test('Arabic: +1 px body/labels, tall lines, no 600, no tracking', () {
      const l = EmsTypography.latin;
      const a = EmsTypography.arabic;
      final pairs = [
        (l.bodyLarge, a.bodyLarge),
        (l.bodyMedium, a.bodyMedium),
        (l.bodySmall, a.bodySmall),
        (l.labelLarge, a.labelLarge),
        (l.labelMedium, a.labelMedium),
        (l.labelSmall, a.labelSmall),
      ];
      for (final (latin, arabic) in pairs) {
        expect(arabic.fontSize, latin.fontSize! + 1);
        expect(arabic.height, greaterThanOrEqualTo(1.65));
      }
      for (final s in [
        a.displaySmall,
        a.headlineLarge,
        a.headlineMedium,
        a.headlineSmall,
        a.titleLarge,
        a.titleMedium,
        a.bodyLarge,
        a.bodyMedium,
        a.bodySmall,
        a.labelLarge,
        a.labelMedium,
        a.labelSmall,
        a.numericLarge,
      ]) {
        expect(s.fontWeight, isNot(FontWeight.w600), reason: '$s');
        expect(s.letterSpacing, 0);
        expect(s.height, greaterThanOrEqualTo(1.4));
      }
    });

    test('accepts custom colours', () {
      final custom = EmsColors.light.copyWith(primary: Colors.teal);
      final theme = EmsTheme.light(colors: custom);
      expect(theme.colorScheme.primary, Colors.teal);
    });
  });

  group('EmsColors.of', () {
    testWidgets('throws a FlutterError that explains the fix', (tester) async {
      Object? error;
      await tester.pumpWidget(
        Theme(
          data: ThemeData(),
          child: Builder(
            builder: (context) {
              try {
                EmsColors.of(context);
              } catch (e) {
                error = e;
              }
              return const SizedBox();
            },
          ),
        ),
      );
      expect(error, isA<FlutterError>());
      expect(error.toString(), contains('EmsTheme'));
    });
  });

  group('EmsMotion', () {
    testWidgets('collapses durations when animations are disabled', (
      tester,
    ) async {
      late EmsMotion motion;
      Widget probe(bool disable) => MediaQuery(
        data: MediaQueryData(disableAnimations: disable),
        child: Builder(
          builder: (context) {
            motion = EmsMotion.of(context);
            return const SizedBox();
          },
        ),
      );
      await tester.pumpWidget(probe(false));
      expect(motion.normal, const Duration(milliseconds: 200));
      expect(motion.expand, const Duration(milliseconds: 250));
      expect(motion.shimmer, const Duration(milliseconds: 1300));
      await tester.pumpWidget(probe(true));
      expect(motion.enabled, isFalse);
      expect(motion.normal, Duration.zero);
      expect(motion.shimmer, Duration.zero);
    });
  });

  group('EmsTypography', () {
    testWidgets('of falls back to the base scale', (tester) async {
      late EmsTypography typography;
      await tester.pumpWidget(
        Theme(
          data: ThemeData(),
          child: Builder(
            builder: (context) {
              typography = EmsTypography.of(context);
              return const SizedBox();
            },
          ),
        ),
      );
      expect(typography, same(EmsTypography.latin));
    });

    test('lerp and copyWith keep every style', () {
      final bigger = EmsTypography.base.copyWith(
        bodyMedium: EmsTypeScale.bodyMedium.copyWith(fontSize: 20),
      );
      expect(bigger.bodyMedium.fontSize, 20);
      expect(bigger.labelLarge, EmsTypeScale.labelLarge);
      expect(EmsTypography.base.lerp(bigger, 0.5).bodyMedium.fontSize, 17);
    });
  });

  group('EmsElevation', () {
    test('shadows are built from the scrim token (DS-13)', () {
      for (final c in [EmsColors.light, EmsColors.dark]) {
        final l1 = EmsElevation.level1(c).single;
        expect([l1.blurRadius, l1.offset], [16, const Offset(0, 4)]);
        expect(l1.color, c.scrim.withValues(alpha: 0.08));
        final l2 = EmsElevation.level2(c).single;
        expect([l2.blurRadius, l2.offset], [24, const Offset(0, 8)]);
        expect(l2.color, c.scrim.withValues(alpha: 0.12));
      }
      expect(EmsElevation.level0, isEmpty);
    });
  });

  group('EmsColors (step 2.8 palette, D1–D4)', () {
    test('primary is one blue family in both themes (DS-11)', () {
      expect(EmsColors.light.primary, const Color(0xFF2563EB));
      expect(EmsColors.dark.primary, const Color(0xFF6EA8FE));
      expect(EmsColors.dark.onPrimary, const Color(0xFF0B1437));
    });

    test('copyWith and lerp keep every token', () {
      final custom = EmsColors.light.copyWith(scrim: Colors.teal);
      expect(custom.scrim, Colors.teal);
      expect(custom.primary, EmsColors.light.primary);
      final mid = EmsColors.light.lerp(EmsColors.dark, 1);
      expect(mid.onDangerContainer, EmsColors.dark.onDangerContainer);
      expect(mid.skeletonHighlight, EmsColors.dark.skeletonHighlight);
    });

    test('the ColorScheme is built from the tokens (DS-15)', () {
      final scheme = EmsTheme.dark().colorScheme;
      final c = EmsColors.dark;
      expect(scheme.primaryContainer, c.primaryContainer);
      expect(scheme.error, c.danger);
      expect(scheme.outline, c.borderStrong);
      expect(scheme.outlineVariant, c.borderSubtle);
      expect(scheme.scrim, c.scrim);
      expect(scheme.surfaceTint, Colors.transparent);
    });
  });
}
