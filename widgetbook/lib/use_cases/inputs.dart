import 'package:ems_design_system/ems_design_system.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../support.dart';

@widgetbook.UseCase(name: 'Playground', type: EmsTextField, path: '[Inputs]')
Widget emsTextFieldPlayground(BuildContext context) {
  final k = context.knobs;
  final label = textKnob(
    context,
    'Label',
    en: 'Email',
    ar: 'البريد الإلكتروني',
  );
  final hint = textKnob(
    context,
    'Hint',
    en: 'name@example.com',
    ar: 'name@example.com',
  );
  final error = textKnob(context, 'Error (empty = none)', en: '', ar: '');
  final helper = textKnob(context, 'Helper (empty = none)', en: '', ar: '');
  return Showcase(
    child: EmsTextField(
      label: label,
      hintText: hint,
      required: k.boolean(label: 'Required', initialValue: true),
      obscureText: k.boolean(label: 'Obscure (password)'),
      enabled: k.boolean(label: 'Enabled', initialValue: true),
      errorText: error.isEmpty ? null : error,
      helperText: helper.isEmpty ? null : helper,
      prefixIcon: k.boolean(label: 'Prefix icon')
          ? const Icon(Icons.mail_outline)
          : null,
    ),
  );
}

@widgetbook.UseCase(name: 'States', type: EmsTextField, path: '[Inputs]')
Widget emsTextFieldStates(BuildContext context) {
  return Showcase(
    child: Gap(
      children: [
        EmsTextField(
          label: l(context, 'Email', 'البريد الإلكتروني'),
          hintText: 'name@example.com',
          required: true,
        ),
        EmsTextField(
          label: l(context, 'Password', 'كلمة المرور'),
          required: true,
          obscureText: true,
        ),
        EmsTextField(
          label: l(context, 'National ID', 'الهوية الوطنية'),
          errorText: l(context, 'This field is required', 'هذا الحقل مطلوب'),
        ),
        EmsTextField(
          label: l(context, 'Patient Name', 'اسم المريض'),
          helperText: l(context, 'As on the ID card', 'كما في بطاقة الهوية'),
        ),
        EmsTextField(
          label: l(context, 'Medication Name', 'اسم الدواء'),
          enabled: false,
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(name: 'Playground', type: EmsTextArea, path: '[Inputs]')
Widget emsTextArea(BuildContext context) {
  final k = context.knobs;
  final error = textKnob(context, 'Error (empty = none)', en: '', ar: '');
  return Showcase(
    child: EmsTextArea(
      label: textKnob(context, 'Label', en: 'Notes', ar: 'ملاحظات'),
      hintText: textKnob(
        context,
        'Hint',
        en: 'Enter notes...',
        ar: 'أدخل الملاحظات...',
      ),
      maxLines: k.int.slider(
        label: 'Max lines',
        initialValue: 4,
        min: 2,
        max: 8,
      ),
      enabled: k.boolean(label: 'Enabled', initialValue: true),
      readOnly: k.boolean(label: 'Read only'),
      errorText: error.isEmpty ? null : error,
    ),
  );
}

@widgetbook.UseCase(
  name: 'Playground',
  type: EmsDateTimeField,
  path: '[Inputs]',
)
Widget emsDateTimeField(BuildContext context) {
  final k = context.knobs;
  final hasValue = k.boolean(label: 'Has value');
  return Showcase(
    child: EmsDateTimeField(
      label: textKnob(context, 'Label', en: 'Recorded At', ar: 'وقت التسجيل'),
      hintText: l(context, 'Select date and time...', 'اختر التاريخ والوقت...'),
      value: hasValue ? '2026-10-01  14:30' : null,
      onTap: k.boolean(label: 'Enabled', initialValue: true) ? () {} : null,
    ),
  );
}

@widgetbook.UseCase(
  name: 'Playground',
  type: EmsVitalSignCard,
  path: '[Inputs]',
)
Widget emsVitalSignCard(BuildContext context) {
  final error = textKnob(context, 'Error (empty = none)', en: '', ar: '');
  return Showcase(
    child: EmsVitalSignCard(
      label: textKnob(context, 'Label', en: 'Pulse', ar: 'النبض'),
      typeLabel: 'INT',
      unit: context.knobs.string(label: 'Unit', initialValue: 'bpm'),
      hintText: '72',
      errorText: error.isEmpty ? null : error,
    ),
  );
}

@widgetbook.UseCase(name: 'Interactive', type: EmsSliderField, path: '[Inputs]')
Widget emsSliderField(BuildContext context) {
  final enabled = context.knobs.boolean(label: 'Enabled', initialValue: true);
  return Stateful<double>(
    initial: 4,
    builder: (context, value, set) => Showcase(
      child: EmsSliderField(
        label: l(context, 'Eyes Open (E)', 'فتح العينين (E)'),
        value: value,
        min: 1,
        max: 4,
        divisions: 3,
        minLabel: l(context, 'None', 'لا يوجد'),
        maxLabel: l(context, 'Spontaneous', 'تلقائي'),
        onChanged: enabled ? set : null,
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Default', type: EmsSearchBar, path: '[Inputs]')
Widget emsSearchBar(BuildContext context) {
  final hint = context.knobs.string(label: 'Hint (empty = built-in "Search")');
  return Showcase(child: EmsSearchBar(hintText: hint.isEmpty ? null : hint));
}

@widgetbook.UseCase(name: 'Interactive', type: EmsToggleRow, path: '[Inputs]')
Widget emsToggleRow(BuildContext context) {
  final enabled = context.knobs.boolean(label: 'Enabled', initialValue: true);
  return Stateful<bool>(
    initial: true,
    builder: (context, value, set) => Showcase(
      child: Gap(
        children: [
          EmsToggleRow(
            label: l(context, 'COPD', 'الانسداد الرئوي المزمن'),
            value: value,
            onChanged: enabled ? set : null,
          ),
          EmsToggleRow(
            label: l(context, 'Stroke', 'السكتة الدماغية'),
            value: !value,
            onChanged: enabled ? (v) => set(!v) : null,
          ),
        ],
      ),
    ),
  );
}
