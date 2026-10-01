import 'package:ems_design_system/ems_design_system.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../support.dart';

@widgetbook.UseCase(name: 'Playground', type: EmsCard, path: '[Display]')
Widget emsCard(BuildContext context) {
  final k = context.knobs;
  final tone = k.object.dropdown(
    label: 'Selected tone',
    options: EmsTone.values,
    initialOption: EmsTone.primary,
    labelBuilder: (t) => t.name,
  );
  final tappable = k.boolean(label: 'Tappable', initialValue: true);
  return Stateful<bool>(
    initial: false,
    builder: (context, selected, set) => Showcase(
      child: EmsCard(
        tone: tone,
        selected: selected,
        onTap: tappable ? () => set(!selected) : null,
        child: Text(
          l(context, 'Team A: tap to select', 'الفريق أ: اضغط للاختيار'),
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Playground', type: EmsChip, path: '[Display]')
Widget emsChip(BuildContext context) {
  final k = context.knobs;
  return Showcase(
    child: Align(
      alignment: AlignmentDirectional.centerStart,
      child: EmsChip(
        label: textKnob(context, 'Label', en: 'Completed', ar: 'مكتمل'),
        tone: k.object.dropdown(
          label: 'Tone',
          options: EmsTone.values,
          initialOption: EmsTone.success,
          labelBuilder: (t) => t.name,
        ),
        icon: k.boolean(label: 'Icon') ? Icons.check : null,
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'All tones', type: EmsChip, path: '[Display]')
Widget emsChipTones(BuildContext context) {
  return Showcase(
    child: Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final tone in EmsTone.values)
          EmsChip(label: tone.name, tone: tone),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Categories and tones',
  type: EmsIconBadge,
  path: '[Display]',
)
Widget emsIconBadge(BuildContext context) {
  final size = context.knobs.double.slider(
    label: 'Size',
    initialValue: EmsSizes.iconBadge,
    min: 32,
    max: 72,
  );
  return Showcase(
    child: Gap(
      children: [
        Wrap(
          spacing: 12,
          children: [
            EmsIconBadge.location(size: size),
            EmsIconBadge.vehicle(size: size),
            EmsIconBadge.equipment(size: size),
            EmsIconBadge.crew(size: size),
          ],
        ),
        Wrap(
          spacing: 12,
          children: [
            for (final tone in EmsTone.values)
              EmsIconBadge(
                icon: Icons.favorite_outline,
                tone: tone,
                size: size,
              ),
          ],
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(name: 'Playground', type: EmsAvatar, path: '[Display]')
Widget emsAvatar(BuildContext context) {
  final k = context.knobs;
  return Showcase(
    child: Align(
      alignment: AlignmentDirectional.centerStart,
      child: EmsAvatar(
        initials: k.string(label: 'Initials', initialValue: 'AB'),
        radius: k.double.slider(
          label: 'Radius',
          initialValue: EmsSizes.avatarRadius,
          min: 16,
          max: 48,
        ),
        showOnlineIndicator: k.boolean(label: 'Online', initialValue: true),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Crew', type: EmsMemberChip, path: '[Display]')
Widget emsMemberChip(BuildContext context) {
  final showRole = context.knobs.boolean(label: 'Role', initialValue: true);
  return Showcase(
    child: Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        EmsMemberChip(
          name: l(context, 'Ahmed Saleh', 'أحمد صالح'),
          role: showRole ? l(context, 'Paramedic', 'مسعف') : null,
          initials: 'AS',
        ),
        EmsMemberChip(
          name: l(context, 'Sara Ali', 'سارة علي'),
          role: showRole ? l(context, 'Driver', 'سائق') : null,
          avatarIcon: Icons.local_shipping_outlined,
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(name: 'Medications', type: EmsDataTable, path: '[Display]')
Widget emsDataTable(BuildContext context) {
  return Showcase(
    maxWidth: 720,
    child: EmsDataTable(
      columns: [
        l(context, 'Medication Name', 'اسم الدواء'),
        l(context, 'Dose', 'الجرعة'),
        l(context, 'Route', 'طريقة الإعطاء'),
      ],
      rows: [
        ['Paracetamol', '1 g', 'IV'],
        ['Adrenaline', '1 mg', 'IV'],
        ['Salbutamol', '5 mg', l(context, 'Nebuliser', 'بخاخ')],
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Default',
  type: EmsDividerWithText,
  path: '[Display]',
)
Widget emsDividerWithText(BuildContext context) {
  return Showcase(
    child: EmsDividerWithText(
      text: textKnob(context, 'Text', en: 'or', ar: 'أو'),
    ),
  );
}
