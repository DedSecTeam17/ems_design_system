import 'package:ems_design_system/ems_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/ems_test_app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('EmsTopBar', () {
    testWidgets('calls the action callback', (tester) async {
      var taps = 0;
      await pumpEms(
        tester,
        SizedBox(
          width: 600,
          child: EmsTopBar(
            actions: [
              EmsTopBarAction(icon: Icons.translate, onPressed: () => taps++),
            ],
          ),
        ),
      );
      await tester.tap(find.byIcon(Icons.translate));
      expect(taps, 1);
    });

    testWidgets('places leading at the start and the logo at the end', (
      tester,
    ) async {
      for (final rtl in [false, true]) {
        await pumpEms(
          tester,
          const SizedBox(
            width: 600,
            child: EmsTopBar(
              leading: [Icon(Icons.arrow_back)],
              logo: Icon(Icons.star),
            ),
          ),
          rtl: rtl,
        );
        final back = tester.getCenter(find.byIcon(Icons.arrow_back)).dx;
        final logo = tester.getCenter(find.byIcon(Icons.star)).dx;
        expect(rtl ? back > logo : back < logo, isTrue, reason: 'rtl=$rtl');
      }
    });

    testWidgets('hides the action pill without actions', (tester) async {
      await pumpEms(
        tester,
        const SizedBox(width: 600, child: EmsTopBar(logo: Icon(Icons.star))),
      );
      expect(
        find.descendant(
          of: find.byType(EmsTopBar),
          matching: find.byType(Container),
        ),
        findsOneWidget,
      );
    });

    testWidgets('is 64 dp tall', (tester) async {
      expect(const EmsTopBar().preferredSize.height, 64);
    });
  });

  group('EmsSidebar', () {
    testWidgets('reports the tapped index', (tester) async {
      int? picked;
      await pumpEms(
        tester,
        SizedBox(
          height: 300,
          child: EmsSidebar(
            selectedIndex: 0,
            onItemTapped: (i) => picked = i,
            items: const [
              EmsSidebarItem(label: 'One', icon: Icons.home),
              EmsSidebarItem(label: 'Two', icon: Icons.settings),
            ],
          ),
        ),
      );
      await tester.tap(find.text('Two'));
      expect(picked, 1);
    });
  });

  group('EmsNotificationItem', () {
    Future<Map<String, int>> pumpItem(
      WidgetTester tester,
      EmsNotificationStatus status,
    ) async {
      final taps = {'open': 0, 'follow': 0, 'report': 0};
      await pumpEms(
        tester,
        SizedBox(
          width: 800,
          child: EmsNotificationItem(
            location: 'Loc',
            region: 'Reg',
            timeAgo: 'now',
            status: status,
            statusLabel: const {
              EmsNotificationStatus.now: 'Dispatch',
              EmsNotificationStatus.inProgress: 'In Progress',
              EmsNotificationStatus.completed: 'Done',
            }[status]!,
            followLabel: 'Follow Trip',
            reportLabel: 'Report',
            onTap: () => taps['open'] = taps['open']! + 1,
            onFollow: () => taps['follow'] = taps['follow']! + 1,
            onReport: () => taps['report'] = taps['report']! + 1,
          ),
        ),
      );
      return taps;
    }

    testWidgets('fires open, follow and report for a new dispatch', (
      tester,
    ) async {
      final taps = await pumpItem(tester, EmsNotificationStatus.now);
      await tester.tap(find.byIcon(Icons.arrow_back_ios_new));
      await tester.tap(find.text('Follow Trip'));
      await tester.tap(find.text('Report'));
      expect(taps, {'open': 1, 'follow': 1, 'report': 1});
      expect(find.text('Dispatch'), findsOneWidget);
    });

    testWidgets('disables report unless the status is now', (tester) async {
      final taps = await pumpItem(tester, EmsNotificationStatus.completed);
      await tester.tap(find.text('Report'));
      expect(taps['report'], 0);
      expect(find.text('Done'), findsOneWidget);
    });
  });
}
