// Step 2.6 API: EmsButton, EmsChip(tone), EmsTileSelector, EmsChoiceChips,
// input additions, tones and accents. The tests of the deprecated shims were
// removed with the shims in step 2.11.
import 'package:ems_design_system/ems_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/ems_test_app.dart';

enum _Avpu { alert, pain }

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('EmsButton', () {
    testWidgets('renders each variant with the right Material button', (
      tester,
    ) async {
      await pumpEms(
        tester,
        Column(
          children: [
            for (final v in EmsButtonVariant.values)
              EmsButton(label: v.name, variant: v, onPressed: () {}),
          ],
        ),
      );
      expect(find.byType(ElevatedButton), findsNWidgets(3));
      expect(find.byType(OutlinedButton), findsOneWidget);
      expect(find.byType(TextButton), findsOneWidget);
    });

    testWidgets('success and danger fill with their status colour', (
      tester,
    ) async {
      await pumpEms(
        tester,
        Column(
          children: [
            EmsButton(
              label: 'ok',
              variant: EmsButtonVariant.success,
              onPressed: () {},
            ),
            EmsButton(
              label: 'no',
              variant: EmsButtonVariant.danger,
              onPressed: () {},
            ),
          ],
        ),
      );
      Color? fill(String label) {
        final button = tester.widget<ElevatedButton>(
          find.ancestor(
            of: find.text(label),
            matching: find.byType(ElevatedButton),
          ),
        );
        return button.style!.backgroundColor!.resolve({});
      }

      expect(fill('ok'), EmsColors.light.success);
      expect(fill('no'), EmsColors.light.danger);
    });

    testWidgets('blocks taps while loading in every variant', (tester) async {
      var taps = 0;
      await pumpEms(
        tester,
        Column(
          children: [
            for (final v in EmsButtonVariant.values)
              EmsButton(
                label: v.name,
                variant: v,
                loading: true,
                onPressed: () => taps++,
              ),
          ],
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsNWidgets(5));
      for (final b in find.byType(ButtonStyleButton).evaluate()) {
        expect((b.widget as ButtonStyleButton).onPressed, isNull);
      }
      expect(taps, 0);
    });

    testWidgets('respects a fixed width', (tester) async {
      await pumpEms(
        tester,
        EmsButton(label: 'w', width: 180, onPressed: () {}),
      );
      expect(tester.getSize(find.byType(ElevatedButton)).width, 180);
    });
  });

  group('EmsChip', () {
    testWidgets('tone sets the colours', (tester) async {
      await pumpEms(
        tester,
        const Column(
          children: [
            EmsChip(label: 'ok', tone: EmsTone.success),
            EmsChip(label: 'warn', tone: EmsTone.warning),
            EmsChip(label: 'info', tone: EmsTone.info),
          ],
        ),
      );
      Color? color(String t) => tester.widget<Text>(find.text(t)).style!.color;
      // On-container text (≥ 7:1) since the palette refresh (step 2.8).
      expect(color('ok'), EmsColors.light.onSuccessContainer);
      expect(color('warn'), EmsColors.light.onWarningContainer);
      expect(color('info'), EmsColors.light.onInfoContainer);
    });
  });

  group('EmsTileSelector', () {
    testWidgets('reports typed values', (tester) async {
      _Avpu? picked;
      await pumpEms(
        tester,
        SizedBox(
          width: 400,
          child: EmsTileSelector<_Avpu>(
            items: const [
              EmsTileItem(value: _Avpu.alert, label: 'A', icon: Icons.add),
              EmsTileItem(value: _Avpu.pain, label: 'P', icon: Icons.remove),
            ],
            selected: _Avpu.alert,
            onChanged: (v) => picked = v,
          ),
        ),
      );
      await tester.tap(find.text('P'));
      expect(picked, _Avpu.pain);
    });

    testWidgets('severity preset reports the standard values', (tester) async {
      String? picked;
      await pumpEms(
        tester,
        SizedBox(
          width: 400,
          child: EmsTileSelector.severity(
            lifeThreateningLabel: 'L',
            urgentLabel: 'U',
            nonUrgentLabel: 'N',
            onChanged: (v) => picked = v,
          ),
        ),
      );
      await tester.tap(find.text('N'));
      expect(picked, 'non_urgent');
    });

    testWidgets('is disabled without onChanged', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpEms(
        tester,
        const SizedBox(
          width: 400,
          child: EmsTileSelector<int>(
            items: [EmsTileItem(value: 1, label: 'One')],
          ),
        ),
      );
      expect(
        tester.getSemantics(find.text('One')),
        containsSemantics(isEnabled: false),
      );
      handle.dispose();
    });
  });

  group('EmsChoiceChips', () {
    testWidgets('reports typed values and announces selection', (tester) async {
      final handle = tester.ensureSemantics();
      int? picked;
      await pumpEms(
        tester,
        EmsChoiceChips<int>(
          items: const [
            EmsChoice(value: 1, label: 'One'),
            EmsChoice(value: 2, label: 'Two'),
          ],
          selected: 1,
          onChanged: (v) => picked = v,
        ),
      );
      expect(
        tester.getSemantics(find.text('One')),
        containsSemantics(isSelected: true),
      );
      await tester.tap(find.text('Two'));
      expect(picked, 2);
      handle.dispose();
    });
  });

  group('EmsTextField additions', () {
    testWidgets('shows errorText and helperText', (tester) async {
      await pumpEms(
        tester,
        const SizedBox(
          width: 400,
          child: Column(
            children: [
              EmsTextField(label: 'A', errorText: 'Bad'),
              EmsTextField(label: 'B', helperText: 'Help'),
            ],
          ),
        ),
      );
      expect(find.text('Bad'), findsOneWidget);
      expect(find.text('Help'), findsOneWidget);
    });

    testWidgets('passes enabled, focus and input options through', (
      tester,
    ) async {
      final focus = FocusNode();
      addTearDown(focus.dispose);
      await pumpEms(
        tester,
        SizedBox(
          width: 400,
          child: EmsTextField(
            label: 'Email',
            enabled: false,
            focusNode: focus,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.email],
          ),
        ),
      );
      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.enabled, isFalse);
      expect(field.focusNode, same(focus));
      expect(field.textInputAction, TextInputAction.next);
      expect(field.autofillHints, [AutofillHints.email]);
    });

    // Was the test of the old isPassword / isRequired names (removed in
    // 2.11); it now covers the same behaviour through the current names.
    testWidgets('obscureText / required hide the text and mark the label', (
      tester,
    ) async {
      await pumpEms(
        tester,
        const SizedBox(
          width: 400,
          child: EmsTextField(label: 'P', obscureText: true, required: true),
        ),
      );
      expect(
        tester.widget<EditableText>(find.byType(EditableText)).obscureText,
        isTrue,
      );
      final label = tester.widget<RichText>(find.byType(RichText).first);
      expect(label.text.toPlainText(includeSemanticsLabels: false), 'P *');
    });
  });

  group('EmsTextArea additions', () {
    testWidgets('shows errorText and can be disabled', (tester) async {
      await pumpEms(
        tester,
        const SizedBox(
          width: 400,
          child: EmsTextArea(label: 'Notes', errorText: 'Bad', enabled: false),
        ),
      );
      expect(find.text('Bad'), findsOneWidget);
      expect(tester.widget<TextField>(find.byType(TextField)).enabled, isFalse);
    });
  });

  group('tones and accents', () {
    testWidgets('EmsAlertBanner icon follows the tone', (tester) async {
      await pumpEms(
        tester,
        const SizedBox(
          width: 400,
          child: Column(
            children: [
              EmsAlertBanner(title: 'a', message: 'b', tone: EmsTone.success),
              EmsAlertBanner(title: 'a', message: 'b', tone: EmsTone.warning),
              EmsAlertBanner(title: 'a', message: 'b'),
            ],
          ),
        ),
      );
      expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);
      expect(find.byIcon(Icons.warning_amber_outlined), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('EmsIconBadge resolves accent, tone and the default', (
      tester,
    ) async {
      await pumpEms(
        tester,
        const Row(
          children: [
            EmsIconBadge(icon: Icons.groups, accent: EmsAccent.crew),
            EmsIconBadge(icon: Icons.check, tone: EmsTone.success),
            EmsIconBadge(icon: Icons.star),
          ],
        ),
      );
      Color? color(IconData i) => tester.widget<Icon>(find.byIcon(i)).color;
      expect(color(Icons.groups), EmsColors.light.accentCoral);
      expect(color(Icons.check), EmsColors.light.success);
      expect(color(Icons.star), EmsColors.light.primary);
    });

    testWidgets('EmsSelectionCard accent colours the icon', (tester) async {
      await pumpEms(
        tester,
        const SizedBox(
          width: 400,
          child: EmsSelectionCard(
            label: 'Crew',
            icon: Icons.groups,
            accent: EmsAccent.location,
          ),
        ),
      );
      expect(
        tester.widget<Icon>(find.byIcon(Icons.groups)).color,
        EmsColors.light.success,
      );
    });

    // Compared with the legacy getters until 2.11; now with the D11 colours
    // they forwarded to.
    test('EmsColors.accent maps every category (D11)', () {
      for (final c in [EmsColors.light, EmsColors.dark]) {
        expect(c.accent(EmsAccent.location), c.success);
        expect(c.accent(EmsAccent.vehicle), c.accentViolet);
        expect(c.accent(EmsAccent.equipment), c.accentViolet);
        expect(c.accent(EmsAccent.crew), c.accentCoral);
      }
    });
  });
}
