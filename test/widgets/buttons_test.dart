import 'package:ems_design_system/ems_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/ems_test_app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('EmsButton primary', () {
    testWidgets('calls onPressed when tapped', (tester) async {
      var taps = 0;
      await pumpEms(
        tester,
        EmsButton(label: 'Sign In', onPressed: () => taps++),
      );
      await tester.tap(find.text('Sign In'));
      expect(taps, 1);
    });

    testWidgets('ignores taps when onPressed is null', (tester) async {
      await pumpEms(tester, const EmsButton(label: 'Sign In'));
      await tester.tap(find.text('Sign In'));
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('shows a spinner and blocks taps when loading', (tester) async {
      var taps = 0;
      await pumpEms(
        tester,
        EmsButton(label: 'Sign In', loading: true, onPressed: () => taps++),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      // The label stays in the layout (same width) but isn't visible.
      final visibility = tester.widget<Visibility>(
        find.ancestor(
          of: find.text('Sign In'),
          matching: find.byType(Visibility),
        ),
      );
      expect(visibility.visible, isFalse);
      expect(visibility.maintainSize, isTrue);
      await tester.tap(find.byType(ElevatedButton));
      expect(taps, 0);
    });

    testWidgets('keeps its width and variant colour while loading (DS-23)', (
      tester,
    ) async {
      Future<(Size, Color?)> probe(bool loading) async {
        await pumpEms(
          tester,
          Center(
            child: EmsButton(
              label: 'Confirm handover',
              variant: EmsButtonVariant.success,
              width: null,
              loading: loading,
              onPressed: () {},
            ),
          ),
        );
        final material = tester.widget<Material>(
          find.descendant(
            of: find.byType(ElevatedButton),
            matching: find.byType(Material),
          ),
        );
        return (tester.getSize(find.byType(ElevatedButton)), material.color);
      }

      final idle = await probe(false);
      final busy = await probe(true);
      expect(busy.$1, idle.$1);
      expect(busy.$2, EmsColors.light.success);
    });

    testWidgets('renders the leading icon when given', (tester) async {
      await pumpEms(
        tester,
        EmsButton(label: 'Go', icon: Icons.check, onPressed: () {}),
      );
      expect(find.byIcon(Icons.check), findsOneWidget);
    });
  });

  group('EmsButton secondary', () {
    testWidgets('calls onPressed when tapped', (tester) async {
      var taps = 0;
      await pumpEms(
        tester,
        EmsButton(
          variant: EmsButtonVariant.secondary,
          label: 'Cancel',
          onPressed: () => taps++,
        ),
      );
      await tester.tap(find.text('Cancel'));
      expect(taps, 1);
    });

    testWidgets('is disabled when onPressed is null', (tester) async {
      await pumpEms(
        tester,
        const EmsButton(variant: EmsButtonVariant.secondary, label: 'Cancel'),
      );
      final button = tester.widget<OutlinedButton>(find.byType(OutlinedButton));
      expect(button.onPressed, isNull);
    });
  });

  group('EmsBottomStepNav', () {
    testWidgets('calls onPrev and onNext', (tester) async {
      var prev = 0;
      var next = 0;
      await pumpEms(
        tester,
        SizedBox(
          width: 700,
          child: EmsBottomStepNav(
            currentStep: 2,
            totalSteps: 6,
            stepLabel: 'Vital Signs',
            onPrev: () => prev++,
            onNext: () => next++,
          ),
        ),
      );
      await tester.tap(find.text('Prev'));
      await tester.tap(find.text('Next'));
      expect(prev, 1);
      expect(next, 1);
    });

    testWidgets('hides Prev when onPrev is null', (tester) async {
      await pumpEms(
        tester,
        SizedBox(
          width: 700,
          child: EmsBottomStepNav(
            currentStep: 1,
            totalSteps: 6,
            stepLabel: 'Vital Signs',
            onNext: () {},
          ),
        ),
      );
      // An invisible copy keeps the label centred; it can't be seen,
      // tapped or reached by a screen reader.
      expect(find.text('Prev').hitTestable(), findsNothing);
      final prev = tester.widget<Visibility>(
        find.ancestor(of: find.text('Prev'), matching: find.byType(Visibility)),
      );
      expect(prev.visible, isFalse);
      expect(prev.maintainSemantics, isFalse);
      expect(prev.maintainInteractivity, isFalse);
    });

    testWidgets('shows the step label in English', (tester) async {
      await pumpEms(
        tester,
        const SizedBox(
          width: 700,
          child: EmsBottomStepNav(
            currentStep: 3,
            totalSteps: 6,
            stepLabel: 'Vital Signs',
          ),
        ),
      );
      expect(find.text('Step 3 of 6 • Vital Signs'), findsOneWidget);
    });

    testWidgets('shows the step label in Arabic', (tester) async {
      await pumpEms(
        tester,
        SizedBox(
          width: 700,
          child: Builder(
            builder: (context) => EmsBottomStepNav(
              currentStep: 3,
              totalSteps: 6,
              stepLabel: t(context, 'Vital Signs'),
              onPrev: () {},
              onNext: () {},
            ),
          ),
        ),
        rtl: true,
      );
      expect(find.text('الخطوة 3 من 6 • العلامات الحيوية'), findsOneWidget);
      expect(find.text('السابق'), findsOneWidget);
      expect(find.text('التالي'), findsOneWidget);
    });
  });
}
