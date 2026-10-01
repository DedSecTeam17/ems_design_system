// Phase 2.0 baseline goldens: selection components in their current look.
import 'package:ems_design_system/ems_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/ems_test_app.dart';

List<EmsSelectionOption> _crew(BuildContext context) => [
  EmsSelectionOption(value: 'driver', label: t(context, 'Driver')),
  EmsSelectionOption(value: 'paramedic', label: t(context, 'Paramedic')),
  EmsSelectionOption(value: 'emt', label: t(context, 'EMT')),
];

void main() {
  emsGolden('ems_grid_selector', size: const Size(460, 300), (context) {
    return SizedBox(
      width: 420,
      child: EmsTileSelector<String>(
        selected: 'v',
        onChanged: (_) {},
        items: [
          EmsTileItem(
            label: t(context, 'Alert'),
            icon: Icons.visibility_outlined,
            value: 'a',
          ),
          EmsTileItem(
            label: t(context, 'Verbal'),
            icon: Icons.record_voice_over_outlined,
            value: 'v',
          ),
          EmsTileItem(
            label: t(context, 'Pain'),
            icon: Icons.healing_outlined,
            value: 'p',
          ),
          EmsTileItem(
            label: t(context, 'Unresponsive'),
            icon: Icons.bedtime_outlined,
            value: 'u',
          ),
        ],
      ),
    );
  });

  emsGolden('ems_severity_selector', size: const Size(460, 320), (context) {
    return SizedBox(
      width: 420,
      child: Column(
        children: [
          EmsTileSelector.severity(
            lifeThreateningLabel: t(context, 'LifeThreatening'),
            urgentLabel: t(context, 'Urgent'),
            nonUrgentLabel: t(context, 'NonUrgent'),
            onChanged: (_) {},
          ),
          const SizedBox(height: 12),
          EmsTileSelector.severity(
            lifeThreateningLabel: t(context, 'LifeThreatening'),
            urgentLabel: t(context, 'Urgent'),
            nonUrgentLabel: t(context, 'NonUrgent'),
            selected: 'urgent',
            onChanged: (_) {},
          ),
        ],
      ),
    );
  });

  emsGolden('ems_segmented_control', size: const Size(460, 220), (context) {
    return SizedBox(
      width: 420,
      child: Column(
        children: [
          EmsSegmentedControl(
            segments: [
              t(context, 'During transport =1'),
              t(context, 'During Handover =2'),
            ],
            selectedIndex: 0,
            onChanged: (_) {},
          ),
          const SizedBox(height: 12),
          EmsSegmentedControl(
            segments: const ['EN', 'AR', 'FR'],
            selectedIndex: 2,
            onChanged: (_) {},
          ),
        ],
      ),
    );
  });

  emsGolden('ems_status_chip_group', size: const Size(460, 160), (context) {
    return SizedBox(
      width: 420,
      child: EmsChoiceChips<String>(
        items: [
          for (final status in ['Open', 'InProgress', 'Completed', 'Cancelled'])
            EmsChoice(value: status, label: t(context, status)),
        ],
        selected: 'InProgress',
        onChanged: (_) {},
      ),
    );
  });

  emsGolden('ems_step_indicator', size: const Size(900, 120), (context) {
    return SizedBox(
      width: 860,
      child: EmsStepIndicator(
        currentStep: 2,
        onStepTapped: (_) {},
        steps: [
          t(context, 'Case & Insurance'),
          t(context, 'Vital Signs'),
          t(context, 'Clinical Assessment'),
          t(context, 'Medical Intervention'),
          t(context, 'SBAR & Staff'),
          t(context, 'Handover & Closure'),
        ],
      ),
    );
  });

  emsGolden('ems_selection_card', size: const Size(460, 460), (context) {
    return SizedBox(
      width: 420,
      child: Column(
        children: [
          EmsSelectionCard(
            label: t(context, 'Select Crew'),
            icon: Icons.groups_outlined,
            options: _crew(context),
          ),
          const SizedBox(height: 12),
          EmsSelectionCard(
            label: t(context, 'Select Crew'),
            icon: Icons.groups_outlined,
            // Was the deprecated free colour (teal) until 2.11; the shim is
            // gone, so the second card covers a non-default accent.
            accent: EmsAccent.location,
            options: _crew(context),
            selectedValues: const ['driver', 'emt'],
          ),
          const SizedBox(height: 12),
          EmsSelectionCard(
            label: t(context, '2- Select Ambulance'),
            icon: Icons.local_shipping_outlined,
            isLoading: true,
          ),
        ],
      ),
    );
  });

  emsGolden(
    'ems_selection_card_expanded',
    size: const Size(460, 760),
    (context) {
      return SizedBox(
        width: 420,
        child: Column(
          children: [
            EmsSelectionCard(
              key: const Key('multi'),
              label: t(context, 'Select Crew'),
              icon: Icons.groups_outlined,
              options: _crew(context),
              selectedValues: const ['paramedic'],
            ),
            const SizedBox(height: 12),
            EmsSelectionCard(
              key: const Key('single'),
              label: t(context, '2- Select Ambulance'),
              icon: Icons.local_shipping_outlined,
              selectionMode: EmsSelectionMode.single,
              options: _crew(context),
              selectedValues: const ['emt'],
            ),
          ],
        ),
      );
    },
    act: (tester) async {
      await tester.tap(find.byIcon(Icons.groups_outlined));
      await tester.tap(find.byIcon(Icons.local_shipping_outlined));
      // Let the expansion and the ink feedback finish (resting state).
      await tester.pumpAndSettle();
    },
  );
}
