// Accessibility expectations for the design system. Known gaps are skipped
// with their DS finding ID and the step that fixes them.
import 'package:ems_design_system/ems_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/ems_test_app.dart';

SemanticsNode _node(WidgetTester tester, Finder finder) =>
    tester.getSemantics(finder);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('semantics', () {
    testWidgets('EmsCard with onTap is a button (DS-07)', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpEms(tester, EmsCard(onTap: () {}, child: const Text('Card')));
      expect(
        _node(tester, find.text('Card')),
        containsSemantics(isButton: true),
      );
      handle.dispose();
    });

    testWidgets('selected grid tile announces selected state (DS-07)', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await pumpEms(
        tester,
        SizedBox(
          width: 400,
          child: EmsTileSelector<String>(
            selected: 'a',
            onChanged: (_) {},
            items: const [
              EmsTileItem(label: 'Alert', icon: Icons.add, value: 'a'),
              EmsTileItem(label: 'Pain', icon: Icons.remove, value: 'p'),
            ],
          ),
        ),
      );
      final alert = _node(tester, find.text('Alert'));
      expect(alert, containsSemantics(isSelected: true));
      expect(alert, containsSemantics(isButton: true));
      expect(
        _node(tester, find.text('Pain')),
        containsSemantics(isSelected: false),
      );
      handle.dispose();
    });

    testWidgets('selected segment and status chip announce selection (DS-07)', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await pumpEms(
        tester,
        SizedBox(
          width: 400,
          child: Column(
            children: [
              EmsSegmentedControl(
                segments: const ['EN', 'AR'],
                selectedIndex: 1,
                onChanged: (_) {},
              ),
              EmsChoiceChips<String>(
                items: [
                  for (final status in ['Open', 'Closed'])
                    EmsChoice(value: status, label: status),
                ],
                selected: 'Open',
                onChanged: (_) {},
              ),
            ],
          ),
        ),
      );
      expect(
        _node(tester, find.text('AR')),
        containsSemantics(isSelected: true),
      );
      expect(
        _node(tester, find.text('Open')),
        containsSemantics(isSelected: true),
      );
      handle.dispose();
    });

    testWidgets('password toggle has a label (DS-07)', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpEms(
        tester,
        const SizedBox(
          width: 400,
          child: EmsTextField(label: 'Password', obscureText: true),
        ),
      );
      expect(
        tester.getSemantics(find.byType(IconButton)).tooltip,
        'Show password',
      );
      await tester.tap(find.byType(IconButton));
      await tester.pump();
      expect(
        tester.getSemantics(find.byType(IconButton)).tooltip,
        'Hide password',
      );
      handle.dispose();
    });

    testWidgets('toggle row merges label and switch (DS-07)', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpEms(
        tester,
        SizedBox(
          width: 400,
          child: EmsToggleRow(label: 'COPD', value: true, onChanged: (_) {}),
        ),
      );
      final node = _node(tester, find.byType(Switch));
      expect(node.label, contains('COPD'));
      handle.dispose();
    });

    testWidgets('loading overlay announces loading (DS-07)', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpEms(
        tester,
        const SizedBox(
          width: 200,
          height: 100,
          child: EmsLoadingOverlay(isLoading: true, child: Text('Content')),
        ),
      );
      expect(find.bySemanticsLabel('Loading'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('loading primary button announces loading (DS-07)', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await pumpEms(
        tester,
        EmsButton(label: 'Sign In', loading: true, onPressed: () {}),
      );
      expect(find.bySemanticsLabel(RegExp('Loading')), findsOneWidget);
      handle.dispose();
    });
  });

  group('text scaling', () {
    testWidgets('field label grows with the text scale (DS-09)', (
      tester,
    ) async {
      Future<double> labelHeight(double scale) async {
        await pumpEms(
          tester,
          const SizedBox(width: 400, child: EmsTextField(label: 'Email')),
          textScale: scale,
        );
        return tester
            .getSize(find.text('Email', findRichText: true).first)
            .height;
      }

      final normal = await labelHeight(1.0);
      final large = await labelHeight(1.3);
      expect(large, greaterThan(normal));
    });
  });

  group('tap targets', () {
    testWidgets('status chips are at least 48 dp tall (DS-08)', (tester) async {
      await pumpEms(
        tester,
        EmsChoiceChips<String>(
          items: [
            for (final status in ['Open'])
              EmsChoice(value: status, label: status),
          ],
          onChanged: (_) {},
        ),
      );
      expect(
        tester.getSize(find.byType(AnimatedContainer)).height,
        greaterThanOrEqualTo(48),
      );
    });

    testWidgets('step tabs are at least 48 dp tall (DS-08)', (tester) async {
      await pumpEms(
        tester,
        SizedBox(
          width: 600,
          child: EmsStepIndicator(
            steps: const ['One', 'Two'],
            currentStep: 0,
            onStepTapped: (_) {},
          ),
        ),
      );
      expect(
        tester.getSize(find.byType(GestureDetector).first).height,
        greaterThanOrEqualTo(48),
      );
    });

    testWidgets('primary actions are 56 dp, regular buttons 48 dp (D6)', (
      tester,
    ) async {
      await pumpEms(
        tester,
        Column(
          children: [
            EmsButton(label: 'Go', onPressed: () {}),
            EmsButton(
              label: 'Back',
              variant: EmsButtonVariant.secondary,
              onPressed: () {},
            ),
            Row(
              children: [
                EmsButton(
                  label: 'Next',
                  size: EmsButtonSize.regular,
                  fullWidth: false,
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      );
      expect(tester.getSize(find.byType(ElevatedButton).first).height, 56);
      expect(tester.getSize(find.byType(OutlinedButton)).height, 56);
      expect(tester.getSize(find.byType(ElevatedButton).last).height, 48);
    });

    testWidgets('inputs and the date field are at least 56 dp tall (D6)', (
      tester,
    ) async {
      await pumpEms(
        tester,
        SizedBox(
          width: 400,
          child: Column(
            children: [
              const EmsTextField(label: 'Email'),
              EmsDateTimeField(label: 'Date', hintText: 'Pick', onTap: () {}),
            ],
          ),
        ),
      );
      expect(
        tester.getSize(find.byType(TextFormField)).height,
        greaterThanOrEqualTo(56),
      );
      // The decorated box (border included) of the date field.
      expect(
        tester
            .getSize(
              find
                  .ancestor(
                    of: find.byType(InkWell),
                    matching: find.byType(Container),
                  )
                  .first,
            )
            .height,
        greaterThanOrEqualTo(56),
      );
    });

    testWidgets('top-bar action and notification open are 48 dp (DS-08)', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await pumpEms(
        tester,
        SizedBox(
          width: 800,
          child: Column(
            children: [
              EmsTopBar(
                actions: [
                  EmsTopBarAction(
                    icon: Icons.dark_mode,
                    tooltip: 'Dark Mode',
                    onPressed: () {},
                  ),
                ],
              ),
              EmsNotificationItem(
                location: 'L',
                region: 'R',
                timeAgo: '1m',
                status: EmsNotificationStatus.now,
                statusLabel: 'Now',
                followLabel: 'Follow',
                reportLabel: 'Report',
                onTap: () {},
                onFollow: () {},
                onReport: () {},
              ),
            ],
          ),
        ),
      );
      final targets = {
        'theme toggle': find.byIcon(Icons.dark_mode),
        'open': find.byIcon(Icons.arrow_back_ios_new),
        'follow': find.text('Follow'),
        'report': find.text('Report'),
      };
      for (final MapEntry(key: name, value: finder) in targets.entries) {
        final size = tester.getSize(
          find.ancestor(of: finder, matching: find.byType(InkWell)).first,
        );
        expect(size.height, greaterThanOrEqualTo(48), reason: name);
        expect(size.width, greaterThanOrEqualTo(48), reason: name);
      }
      handle.dispose();
    });

    testWidgets('sidebar rows, option rows, segments and search are 48 dp', (
      tester,
    ) async {
      await pumpEms(
        tester,
        SizedBox(
          width: 400,
          height: 900,
          child: Column(
            children: [
              SizedBox(
                height: 200,
                child: EmsSidebar(
                  items: const [
                    EmsSidebarItem(label: 'Home', icon: Icons.home),
                  ],
                  selectedIndex: 0,
                  onItemTapped: (_) {},
                ),
              ),
              EmsSegmentedControl(
                segments: const ['A', 'B'],
                selectedIndex: 0,
                onChanged: (_) {},
              ),
              const EmsSearchBar(),
            ],
          ),
        ),
      );
      double inkHeight(String text) => tester
          .getSize(
            find
                .ancestor(of: find.text(text), matching: find.byType(InkWell))
                .first,
          )
          .height;
      expect(inkHeight('Home'), greaterThanOrEqualTo(48));
      expect(inkHeight('A'), greaterThanOrEqualTo(48));
      expect(
        tester.getSize(find.byType(TextField)).height,
        greaterThanOrEqualTo(48),
      );
    });
  });
}
