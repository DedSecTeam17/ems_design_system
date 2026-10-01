import 'package:ems_design_system/ems_design_system.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../support.dart';

@widgetbook.UseCase(name: 'Grid', type: EmsTileSelector, path: '[Selection]')
Widget emsTileSelectorGrid(BuildContext context) {
  final k = context.knobs;
  final columns = k.int.slider(
    label: 'Columns',
    initialValue: 2,
    min: 1,
    max: 4,
  );
  final tone = k.object.dropdown(
    label: 'Tone',
    options: EmsTone.values,
    initialOption: EmsTone.primary,
    labelBuilder: (t) => t.name,
  );
  final enabled = k.boolean(label: 'Enabled', initialValue: true);
  return Stateful<String?>(
    initial: 'alert',
    builder: (context, selected, set) => Showcase(
      child: EmsTileSelector<String>(
        columns: columns,
        selected: selected,
        onChanged: enabled ? set : null,
        items: [
          EmsTileItem(
            value: 'alert',
            label: l(context, 'Alert', 'تنبيه'),
            icon: Icons.visibility_outlined,
            tone: tone,
          ),
          EmsTileItem(
            value: 'verbal',
            label: l(context, 'Verbal', 'استجابة لفظية'),
            icon: Icons.record_voice_over_outlined,
            tone: tone,
          ),
          EmsTileItem(
            value: 'pain',
            label: l(context, 'Pain', 'استجابة للألم'),
            icon: Icons.healing_outlined,
            tone: tone,
          ),
          EmsTileItem(
            value: 'unresponsive',
            label: l(context, 'Unresponsive', 'غير مستجيب'),
            icon: Icons.do_not_disturb_on_outlined,
            tone: tone,
          ),
        ],
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Severity preset',
  type: EmsTileSelector,
  path: '[Selection]',
)
Widget emsTileSelectorSeverity(BuildContext context) {
  return Stateful<String?>(
    initial: null,
    builder: (context, selected, set) => Showcase(
      child: EmsTileSelector.severity(
        lifeThreateningLabel: l(context, 'Life threatening', 'مهدد للحياة'),
        urgentLabel: l(context, 'Urgent', 'طارئ'),
        nonUrgentLabel: l(context, 'Non urgent', 'غير طارئ'),
        selected: selected,
        onChanged: set,
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Statuses', type: EmsChoiceChips, path: '[Selection]')
Widget emsChoiceChips(BuildContext context) {
  final enabled = context.knobs.boolean(label: 'Enabled', initialValue: true);
  final statuses = {
    'open': l(context, 'Open', 'مفتوح'),
    'in_progress': l(context, 'In Progress', 'قيد التنفيذ'),
    'completed': l(context, 'Completed', 'مكتمل'),
    'cancelled': l(context, 'Cancelled', 'ملغي'),
  };
  return Stateful<String?>(
    initial: 'open',
    builder: (context, selected, set) => Showcase(
      child: EmsChoiceChips<String>(
        items: [
          for (final e in statuses.entries)
            EmsChoice(value: e.key, label: e.value),
        ],
        selected: selected,
        onChanged: enabled ? set : null,
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Interactive',
  type: EmsSegmentedControl,
  path: '[Selection]',
)
Widget emsSegmentedControl(BuildContext context) {
  final enabled = context.knobs.boolean(label: 'Enabled', initialValue: true);
  return Stateful<int>(
    initial: 0,
    builder: (context, index, set) => Showcase(
      child: EmsSegmentedControl(
        segments: [
          l(context, 'During transport =1', 'أثناء النقل =1'),
          l(context, 'During Handover =2', 'أثناء التسليم =2'),
        ],
        selectedIndex: index,
        onChanged: enabled ? set : null,
      ),
    ),
  );
}

List<EmsSelectionOption> _crew(BuildContext context) => [
  EmsSelectionOption(value: 'driver', label: l(context, 'Driver', 'سائق')),
  EmsSelectionOption(
    value: 'paramedic',
    label: l(context, 'Paramedic', 'مسعف'),
  ),
  EmsSelectionOption(value: 'emt', label: l(context, 'EMT', 'فني طوارئ طبية')),
  EmsSelectionOption(
    value: 'supervisor',
    label: l(context, 'Supervisor', 'مشرف'),
  ),
];

@widgetbook.UseCase(
  name: 'Interactive',
  type: EmsSelectionCard,
  path: '[Selection]',
)
Widget emsSelectionCard(BuildContext context) {
  final k = context.knobs;
  final mode = k.object.segmented(
    label: 'Mode',
    options: EmsSelectionMode.values,
    initialOption: EmsSelectionMode.multiple,
    labelBuilder: (m) => m.name,
  );
  final accent = k.object.dropdown(
    label: 'Accent',
    options: EmsAccent.values,
    initialOption: EmsAccent.crew,
    labelBuilder: (a) => a.name,
  );
  final loading = k.boolean(label: 'Loading');
  return Stateful<List<String>>(
    initial: const ['driver'],
    builder: (context, selected, set) => Showcase(
      child: EmsSelectionCard(
        label: l(context, 'Select Crew', 'اختر الطاقم'),
        icon: Icons.groups_outlined,
        accent: accent,
        selectionMode: mode,
        isLoading: loading,
        options: _crew(context),
        selectedValues: selected,
        onSelectionChanged: set,
      ),
    ),
  );
}
