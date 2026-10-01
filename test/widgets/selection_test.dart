import 'package:ems_design_system/ems_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/ems_test_app.dart';

const _options = [
  EmsSelectionOption(value: 'a', label: 'Driver'),
  EmsSelectionOption(value: 'b', label: 'Paramedic'),
  EmsSelectionOption(value: 'c', label: 'EMT'),
];

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('EmsTileSelector grid', () {
    testWidgets('reports the tapped value', (tester) async {
      String? picked;
      await pumpEms(
        tester,
        SizedBox(
          width: 400,
          child: EmsTileSelector<String>(
            onChanged: (v) => picked = v,
            items: const [
              EmsTileItem(label: 'Alert', icon: Icons.add, value: 'a'),
              EmsTileItem(label: 'Pain', icon: Icons.remove, value: 'p'),
            ],
          ),
        ),
      );
      await tester.tap(find.text('Pain'));
      expect(picked, 'p');
    });
  });

  group('EmsTileSelector.severity', () {
    testWidgets('standard reports the severity value', (tester) async {
      String? picked;
      await pumpEms(
        tester,
        SizedBox(
          width: 400,
          child: EmsTileSelector.severity(
            lifeThreateningLabel: 'LifeThreatening',
            urgentLabel: 'Urgent',
            nonUrgentLabel: 'NonUrgent',
            onChanged: (v) => picked = v,
          ),
        ),
      );
      await tester.tap(find.text('Urgent'));
      expect(picked, 'urgent');
      await tester.tap(find.text('LifeThreatening'));
      expect(picked, 'life_threatening');
    });

    testWidgets('standard shows Arabic labels in Arabic', (tester) async {
      await pumpEms(
        tester,
        Builder(
          builder: (context) => SizedBox(
            width: 400,
            child: EmsTileSelector.severity(
              lifeThreateningLabel: t(context, 'LifeThreatening'),
              urgentLabel: t(context, 'Urgent'),
              nonUrgentLabel: t(context, 'NonUrgent'),
            ),
          ),
        ),
        rtl: true,
      );
      expect(find.text('مهدد للحياة'), findsOneWidget);
      expect(find.text('طارئ'), findsOneWidget);
      expect(find.text('غير طارئ'), findsOneWidget);
    });
  });

  group('EmsSegmentedControl', () {
    testWidgets('reports the tapped index', (tester) async {
      int? picked;
      await pumpEms(
        tester,
        SizedBox(
          width: 400,
          child: EmsSegmentedControl(
            segments: const ['EN', 'AR'],
            selectedIndex: 0,
            onChanged: (i) => picked = i,
          ),
        ),
      );
      await tester.tap(find.text('AR'));
      expect(picked, 1);
    });
  });

  group('EmsChoiceChips statuses', () {
    testWidgets('reports the status value, not the label', (tester) async {
      String? picked;
      await pumpEms(
        tester,
        Builder(
          builder: (context) => EmsChoiceChips<String>(
            items: [
              for (final status in ['Open', 'Completed'])
                EmsChoice(value: status, label: t(context, status)),
            ],
            onChanged: (v) => picked = v,
          ),
        ),
        rtl: true,
      );
      expect(find.text('Completed'), findsNothing);
      await tester.tap(find.text('مكتمل'));
      expect(picked, 'Completed');
    });
  });

  group('EmsStepIndicator', () {
    testWidgets('reports the tapped step index', (tester) async {
      int? picked;
      await pumpEms(
        tester,
        SizedBox(
          width: 700,
          child: EmsStepIndicator(
            steps: const ['One', 'Two', 'Three'],
            currentStep: 0,
            onStepTapped: (i) => picked = i,
          ),
        ),
      );
      await tester.tap(find.text('Three'));
      expect(picked, 2);
    });

    testWidgets('ignores taps without a callback', (tester) async {
      await pumpEms(
        tester,
        const SizedBox(
          width: 700,
          child: EmsStepIndicator(steps: ['One', 'Two'], currentStep: 1),
        ),
      );
      await tester.tap(find.text('One'));
      expect(tester.takeException(), isNull);
    });
  });

  group('EmsSelectionCard', () {
    Future<List<List<String>>> pumpCard(
      WidgetTester tester, {
      EmsSelectionMode mode = EmsSelectionMode.multiple,
      List<String> selected = const [],
      bool loading = false,
      List<EmsSelectionOption> options = _options,
    }) async {
      final changes = <List<String>>[];
      await pumpEms(
        tester,
        SizedBox(
          width: 400,
          child: EmsSelectionCard(
            label: 'Select Crew',
            icon: Icons.groups_outlined,
            options: options,
            selectedValues: selected,
            selectionMode: mode,
            isLoading: loading,
            onSelectionChanged: changes.add,
          ),
        ),
      );
      return changes;
    }

    testWidgets('expands when the header is tapped', (tester) async {
      await pumpCard(tester);
      await tester.tap(find.text('Select Crew'));
      await tester.pumpAndSettle();
      expect(find.text('Paramedic').hitTestable(), findsOneWidget);
    });

    testWidgets('adds and removes values in multiple mode', (tester) async {
      final changes = await pumpCard(tester, selected: const ['a']);
      await tester.tap(find.text('Select Crew'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Paramedic'));
      await tester.tap(find.text('Driver'));
      expect(changes, [
        ['a', 'b'],
        <String>[],
      ]);
    });

    testWidgets('replaces or clears the value in single mode', (tester) async {
      final changes = await pumpCard(
        tester,
        mode: EmsSelectionMode.single,
        selected: const ['a'],
      );
      await tester.tap(find.text('Select Crew'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('EMT'));
      await tester.tap(find.text('Driver'));
      expect(changes, [
        ['c'],
        <String>[],
      ]);
    });

    testWidgets('shows the selected count', (tester) async {
      await pumpCard(tester, selected: const ['a', 'b']);
      expect(find.text('2 selected'), findsOneWidget);
    });

    testWidgets('does not expand while loading', (tester) async {
      await pumpCard(tester, loading: true);
      await tester.tap(find.text('Select Crew'));
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.text('Paramedic'), findsNothing);
      expect(find.byType(EmsShimmerBox), findsNWidgets(3));
    });

    testWidgets('does not expand without options', (tester) async {
      await pumpCard(tester, options: const []);
      await tester.tap(find.text('Select Crew'));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.keyboard_arrow_down), findsNothing);
    });
  });
}
