import 'package:ems_design_system/ems_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/ems_test_app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('EmsTappable', () {
    testWidgets('calls onTap and shows ink', (tester) async {
      var taps = 0;
      await pumpEms(
        tester,
        EmsTappable(onTap: () => taps++, child: const Text('Tap me')),
      );
      expect(find.byType(InkWell), findsOneWidget);
      await tester.tap(find.text('Tap me'));
      expect(taps, 1);
    });

    testWidgets('announces a disabled button without onTap', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpEms(tester, const EmsTappable(child: Text('Off')));
      expect(
        tester.getSemantics(find.text('Off')),
        containsSemantics(isButton: true, isEnabled: false),
      );
      handle.dispose();
    });

    testWidgets('announces selected, value and expanded state', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpEms(
        tester,
        EmsTappable(
          onTap: () {},
          selected: true,
          expanded: true,
          semanticValue: 'Completed',
          child: const Text('Step'),
        ),
      );
      expect(
        tester.getSemantics(find.text('Step')),
        containsSemantics(
          isSelected: true,
          isExpanded: true,
          value: 'Completed',
        ),
      );
      handle.dispose();
    });

    testWidgets('can be activated from the keyboard', (tester) async {
      var taps = 0;
      await pumpEms(
        tester,
        EmsTappable(onTap: () => taps++, child: const Text('Key')),
      );
      final inkWell = tester.widget<InkWell>(find.byType(InkWell));
      expect(inkWell.canRequestFocus, isTrue);
      Focus.of(tester.element(find.text('Key'))).requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      expect(taps, 1);
    });

    testWidgets('keeps the ambient text style', (tester) async {
      await pumpEms(
        tester,
        DefaultTextStyle(
          style: const TextStyle(fontSize: 31),
          child: EmsTappable(onTap: () {}, child: const Text('Big')),
        ),
      );
      final style = DefaultTextStyle.of(tester.element(find.text('Big'))).style;
      expect(style.fontSize, 31);
    });

    testWidgets('lets interactive children receive their own taps', (
      tester,
    ) async {
      var outer = 0;
      var inner = 0;
      await pumpEms(
        tester,
        EmsCard(
          onTap: () => outer++,
          child: TextButton(onPressed: () => inner++, child: const Text('In')),
        ),
      );
      await tester.tap(find.text('In'));
      expect(inner, 1);
      expect(outer, 0);
    });
  });

  group('reduced motion', () {
    Future<void> pumpReduced(WidgetTester tester, Widget child) async {
      await pumpEms(
        tester,
        Builder(
          builder: (context) => MediaQuery(
            data: MediaQuery.of(context).copyWith(disableAnimations: true),
            child: child,
          ),
        ),
      );
    }

    testWidgets('shimmer stands still when animations are disabled', (
      tester,
    ) async {
      await pumpReduced(tester, const EmsShimmerBox(height: 10, width: 100));
      expect(tester.hasRunningAnimations, isFalse);
    });

    testWidgets('shimmer animates by default', (tester) async {
      await pumpEms(tester, const EmsShimmerBox(height: 10, width: 100));
      expect(tester.hasRunningAnimations, isTrue);
    });

    testWidgets('selection card expands instantly when animations are '
        'disabled', (tester) async {
      await pumpReduced(
        tester,
        const SizedBox(
          width: 300,
          child: EmsSelectionCard(
            label: 'Crew',
            icon: Icons.groups,
            options: [EmsSelectionOption(value: 'a', label: 'A')],
          ),
        ),
      );
      await tester.tap(find.text('Crew'));
      // One frame for the tap, one for the zero-length expansion.
      await tester.pump();
      await tester.pump();
      expect(
        tester
            .widget<SizeTransition>(find.byType(SizeTransition))
            .sizeFactor
            .value,
        1.0,
      );
      expect(find.text('A').hitTestable(), findsOneWidget);
    });
  });

  group('loading semantics', () {
    testWidgets('overlay hides the content from screen readers', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await pumpEms(
        tester,
        const SizedBox(
          width: 200,
          height: 100,
          child: EmsLoadingOverlay(isLoading: true, child: Text('Hidden')),
        ),
      );
      expect(find.bySemanticsLabel('Hidden'), findsNothing);
      handle.dispose();
    });

    testWidgets('overlay keeps the content state when loading toggles', (
      tester,
    ) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      Widget build(bool loading) => SizedBox(
        width: 300,
        height: 100,
        child: EmsLoadingOverlay(
          isLoading: loading,
          child: _Counter(controller: controller),
        ),
      );
      await pumpEms(tester, build(false));
      await tester.tap(find.text('0'));
      await tester.pump();
      await pumpEms(tester, build(true));
      await pumpEms(tester, build(false));
      expect(find.text('1'), findsOneWidget);
    });
  });
}

class _Counter extends StatefulWidget {
  const _Counter({required this.controller});
  final TextEditingController controller;

  @override
  State<_Counter> createState() => _CounterState();
}

class _CounterState extends State<_Counter> {
  int _count = 0;

  @override
  Widget build(BuildContext context) => TextButton(
    onPressed: () => setState(() => _count++),
    child: Text('$_count'),
  );
}
