import 'package:ems_design_system/ems_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/ems_test_app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('EmsCard', () {
    testWidgets('calls onTap', (tester) async {
      var taps = 0;
      await pumpEms(
        tester,
        EmsCard(onTap: () => taps++, child: const Text('Card')),
      );
      await tester.tap(find.text('Card'));
      expect(taps, 1);
    });
  });

  group('EmsChip', () {
    testWidgets('factories render the label and icon', (tester) async {
      await pumpEms(
        tester,
        Builder(
          builder: (context) => const Column(
            children: [
              EmsChip(label: 'N'),
              EmsChip(tone: EmsTone.success, label: 'S', icon: Icons.check),
              EmsChip(tone: EmsTone.danger, label: 'E'),
              EmsChip(tone: EmsTone.primary, label: 'P'),
            ],
          ),
        ),
      );
      for (final label in ['N', 'S', 'E', 'P']) {
        expect(find.text(label), findsOneWidget);
      }
      expect(find.byIcon(Icons.check), findsOneWidget);
    });
  });

  group('EmsIconBadge', () {
    // Covered the free `color` override until 2.11 (removed); the badge's
    // colour now always comes from a tone or an accent.
    testWidgets('uses the tone colour for the icon', (tester) async {
      await pumpEms(
        tester,
        const EmsIconBadge(icon: Icons.favorite, tone: EmsTone.danger),
      );
      expect(
        tester.widget<Icon>(find.byIcon(Icons.favorite)).color,
        EmsColors.light.danger,
      );
    });

    testWidgets('category factories render their icons', (tester) async {
      await pumpEms(
        tester,
        const Row(
          children: [
            EmsIconBadge.location(),
            EmsIconBadge.vehicle(),
            EmsIconBadge.equipment(),
            EmsIconBadge.crew(),
          ],
        ),
      );
      expect(find.byIcon(Icons.location_on_outlined), findsOneWidget);
      expect(find.byIcon(Icons.local_shipping_outlined), findsOneWidget);
      expect(find.byIcon(Icons.medical_services_outlined), findsOneWidget);
      expect(find.byIcon(Icons.groups_outlined), findsOneWidget);
    });
  });

  group('EmsLoadingOverlay', () {
    testWidgets('blocks taps on the content while loading', (tester) async {
      var taps = 0;
      await pumpEms(
        tester,
        SizedBox(
          width: 200,
          height: 100,
          child: EmsLoadingOverlay(
            isLoading: true,
            child: TextButton(onPressed: () => taps++, child: const Text('Go')),
          ),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.tap(find.text('Go'), warnIfMissed: false);
      expect(taps, 0);
    });

    testWidgets('lets taps through when not loading', (tester) async {
      var taps = 0;
      await pumpEms(
        tester,
        EmsLoadingOverlay(
          isLoading: false,
          child: TextButton(onPressed: () => taps++, child: const Text('Go')),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsNothing);
      await tester.tap(find.text('Go'));
      expect(taps, 1);
    });
  });

  group('EmsMemberChip', () {
    testWidgets('shows name and role as separate slots (DS-33)', (
      tester,
    ) async {
      await pumpEms(
        tester,
        const EmsMemberChip(name: 'Test Medic', role: 'Paramedic'),
      );
      expect(find.text('Test Medic'), findsOneWidget);
      expect(find.text('Paramedic'), findsOneWidget);
      expect(find.textContaining('('), findsNothing);
    });
  });

  group('EmsAlertBanner', () {
    testWidgets('shows title and message', (tester) async {
      await pumpEms(
        tester,
        const SizedBox(
          width: 400,
          child: EmsAlertBanner(title: 'Title', message: 'Body'),
        ),
      );
      expect(find.text('Title Body', findRichText: true), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });
  });

  group('EmsDividerWithText', () {
    testWidgets('shows the translated text', (tester) async {
      await pumpEms(
        tester,
        Builder(
          builder: (context) => SizedBox(
            width: 300,
            child: EmsDividerWithText(text: t(context, 'or')),
          ),
        ),
        rtl: true,
      );
      expect(find.text('أو'), findsOneWidget);
    });
  });

  group('EmsDataTable', () {
    testWidgets('renders headers in upper case and every cell', (tester) async {
      await pumpEms(
        tester,
        const SizedBox(
          width: 400,
          child: EmsDataTable(
            columns: ['Name', 'Dose'],
            rows: [
              ['A', '1'],
              ['B', '2'],
            ],
          ),
        ),
      );
      expect(find.text('NAME'), findsOneWidget);
      expect(find.text('DOSE'), findsOneWidget);
      for (final cell in ['A', '1', 'B', '2']) {
        expect(find.text(cell), findsOneWidget);
      }
    });
  });
}
