import 'package:ems_design_system/ems_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/ems_test_app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('EmsTextField', () {
    testWidgets('toggles password visibility', (tester) async {
      await pumpEms(
        tester,
        const SizedBox(
          width: 400,
          child: EmsTextField(label: 'Password', obscureText: true),
        ),
      );
      EditableText editable() =>
          tester.widget<EditableText>(find.byType(EditableText));
      expect(editable().obscureText, isTrue);
      await tester.tap(find.byIcon(Icons.visibility_off_outlined));
      await tester.pump();
      expect(editable().obscureText, isFalse);
      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
    });

    testWidgets('does not obscure plain fields', (tester) async {
      await pumpEms(
        tester,
        const SizedBox(width: 400, child: EmsTextField(label: 'Email')),
      );
      expect(
        tester.widget<EditableText>(find.byType(EditableText)).obscureText,
        isFalse,
      );
      expect(find.byType(IconButton), findsNothing);
    });

    testWidgets('reports typed text and shows validator errors', (
      tester,
    ) async {
      final typed = <String>[];
      await pumpEms(
        tester,
        SizedBox(
          width: 400,
          child: EmsTextField(
            label: 'Email',
            onChanged: typed.add,
            autovalidateMode: AutovalidateMode.always,
            validator: (v) => (v ?? '').isEmpty ? 'Required!' : null,
          ),
        ),
      );
      expect(find.text('Required!'), findsOneWidget);
      await tester.enterText(find.byType(TextFormField), 'a@b.c');
      await tester.pump();
      expect(typed, ['a@b.c']);
      expect(find.text('Required!'), findsNothing);
    });

    testWidgets('marks required fields with an asterisk', (tester) async {
      await pumpEms(
        tester,
        const SizedBox(
          width: 400,
          child: EmsTextField(label: 'Email', required: true),
        ),
      );
      final label = tester.widget<RichText>(
        find
            .descendant(
              of: find.byType(EmsTextField),
              matching: find.byType(RichText),
            )
            .first,
      );
      expect(label.text.toPlainText(includeSemanticsLabels: false), 'Email *');
      expect(label.text.toPlainText(), 'Email, Required');
    });
  });

  group('EmsTextArea', () {
    testWidgets('reports typed text', (tester) async {
      final typed = <String>[];
      await pumpEms(
        tester,
        SizedBox(
          width: 400,
          child: EmsTextArea(label: 'Notes', onChanged: typed.add),
        ),
      );
      await tester.enterText(find.byType(TextFormField), 'hello');
      expect(typed, ['hello']);
    });

    testWidgets('is read-only when requested', (tester) async {
      await pumpEms(
        tester,
        const SizedBox(width: 400, child: EmsTextArea(readOnly: true)),
      );
      expect(
        tester.widget<EditableText>(find.byType(EditableText)).readOnly,
        isTrue,
      );
    });
  });

  group('EmsDateTimeField', () {
    testWidgets('calls onTap', (tester) async {
      var taps = 0;
      await pumpEms(
        tester,
        SizedBox(
          width: 400,
          child: EmsDateTimeField(
            label: 'RecordedAt',
            hintText: 'Pick',
            onTap: () => taps++,
          ),
        ),
      );
      await tester.tap(find.text('Pick'));
      expect(taps, 1);
    });

    testWidgets('shows the value instead of the hint', (tester) async {
      await pumpEms(
        tester,
        const SizedBox(
          width: 400,
          child: EmsDateTimeField(
            label: 'RecordedAt',
            hintText: 'Pick',
            value: '10:30',
          ),
        ),
      );
      expect(find.text('10:30'), findsOneWidget);
      expect(find.text('Pick'), findsNothing);
    });
  });

  group('EmsToggleRow', () {
    testWidgets('reports the new value', (tester) async {
      bool? value;
      await pumpEms(
        tester,
        SizedBox(
          width: 400,
          child: EmsToggleRow(
            label: 'COPD',
            value: false,
            onChanged: (v) => value = v,
          ),
        ),
      );
      await tester.tap(find.byType(Switch));
      expect(value, isTrue);
    });
  });

  group('EmsSliderField', () {
    testWidgets('shows the value and reports changes', (tester) async {
      final values = <double>[];
      await pumpEms(
        tester,
        SizedBox(
          width: 400,
          child: EmsSliderField(
            label: 'Eyes Open (E)',
            value: 2,
            min: 1,
            max: 4,
            divisions: 3,
            onChanged: values.add,
          ),
        ),
      );
      expect(find.text('2'), findsOneWidget);
      await tester.tap(find.byType(Slider));
      expect(values, isNotEmpty);
    });

    testWidgets('is disabled without onChanged', (tester) async {
      await pumpEms(
        tester,
        const SizedBox(
          width: 400,
          child: EmsSliderField(label: 'Eyes Open (E)', value: 2),
        ),
      );
      expect(tester.widget<Slider>(find.byType(Slider)).onChanged, isNull);
    });
  });

  group('EmsVitalSignCard', () {
    testWidgets('reports typed values and shows the error', (tester) async {
      final typed = <String>[];
      await pumpEms(
        tester,
        SizedBox(
          width: 300,
          child: EmsVitalSignCard(
            label: 'Pulse',
            typeLabel: 'int',
            unit: 'bpm',
            errorText: 'This field is required',
            onChanged: typed.add,
          ),
        ),
      );
      expect(find.text('PULSE'), findsOneWidget);
      expect(find.text('INT'), findsOneWidget);
      expect(find.text('—'), findsOneWidget);
      expect(find.text('This field is required'), findsOneWidget);
      await tester.enterText(find.byType(TextFormField), '80');
      expect(typed, ['80']);
    });
  });

  group('EmsSearchBar', () {
    testWidgets('shows the default hint and reports typed text', (
      tester,
    ) async {
      final typed = <String>[];
      await pumpEms(
        tester,
        SizedBox(width: 400, child: EmsSearchBar(onChanged: typed.add)),
      );
      expect(find.text('Search'), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'abc');
      expect(typed, ['abc']);
    });
  });
}
