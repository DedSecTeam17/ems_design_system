// Phase 2.0 baseline goldens: input components in their current look.
import 'package:ems_design_system/ems_design_system.dart';
import 'package:flutter/material.dart';

import '../helpers/ems_test_app.dart';

void main() {
  emsGolden('ems_text_field', size: const Size(460, 620), (context) {
    return SizedBox(
      width: 420,
      child: Column(
        children: [
          EmsTextField(
            label: t(context, 'Email'),
            hintText: 'mail@simmmple.com',
            required: true,
          ),
          const SizedBox(height: 12),
          EmsTextField(
            label: t(context, 'Password'),
            required: true,
            obscureText: true,
            controller: TextEditingController(text: 'secret-123'),
          ),
          const SizedBox(height: 12),
          EmsTextField(
            label: t(context, 'Patient Name'),
            controller: TextEditingController(text: 'Test Patient'),
          ),
          const SizedBox(height: 12),
          EmsTextField(
            label: t(context, 'National ID'),
            autovalidateMode: AutovalidateMode.always,
            validator: (_) => t(context, 'This field is required'),
          ),
        ],
      ),
    );
  });

  emsGolden('ems_text_area', size: const Size(460, 480), (context) {
    return SizedBox(
      width: 420,
      child: Column(
        children: [
          EmsTextArea(
            label: t(context, 'Notes'),
            hintText: t(context, 'Enter notes...'),
            maxLines: 3,
          ),
          const SizedBox(height: 12),
          EmsTextArea(
            label: t(context, 'Precaution Notes'),
            controller: TextEditingController(text: 'Synthetic note text.'),
            maxLines: 2,
          ),
          const SizedBox(height: 12),
          EmsTextArea(
            hintText: t(context, 'Enter notes...'),
            readOnly: true,
            maxLines: 2,
          ),
        ],
      ),
    );
  });

  emsGolden('ems_date_time_field', size: const Size(460, 400), (context) {
    return SizedBox(
      width: 420,
      child: Column(
        children: [
          EmsDateTimeField(
            label: t(context, 'RecordedAt'),
            hintText: t(context, 'Select date and time...'),
            onTap: () {},
          ),
          const SizedBox(height: 12),
          EmsDateTimeField(
            label: t(context, 'RecordedAt'),
            value: '2026-01-15 10:30',
            onTap: () {},
          ),
          const SizedBox(height: 12),
          EmsDateTimeField(label: t(context, 'RecordedAt')),
        ],
      ),
    );
  });

  emsGolden('ems_vital_sign_card', size: const Size(640, 320), (context) {
    return SizedBox(
      width: 600,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: EmsVitalSignCard(
              label: t(context, 'Pulse'),
              typeLabel: 'INT',
              unit: t(context, 'bpm'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: EmsVitalSignCard(
              label: t(context, 'SPO2'),
              typeLabel: 'INT',
              unit: '%',
              controller: TextEditingController(text: '98'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: EmsVitalSignCard(
              label: t(context, 'Temperature'),
              typeLabel: 'DEC',
              unit: '°C',
              hintText: '36.6',
              errorText: t(context, 'This field is required'),
            ),
          ),
        ],
      ),
    );
  });

  emsGolden('ems_slider_field', size: const Size(460, 260), (context) {
    return SizedBox(
      width: 420,
      child: Column(
        children: [
          EmsSliderField(
            label: t(context, 'Eyes Open (E)'),
            value: 3,
            min: 1,
            max: 4,
            divisions: 3,
            minLabel: t(context, 'NONE'),
            maxLabel: t(context, 'SPONTANEOUS'),
            onChanged: (_) {},
          ),
          const SizedBox(height: 12),
          EmsSliderField(label: t(context, 'Motor Response (M)'), value: 6),
        ],
      ),
    );
  });

  emsGolden('ems_toggle_row', size: const Size(460, 260), (context) {
    return SizedBox(
      width: 420,
      child: Column(
        children: [
          EmsToggleRow(
            label: t(context, 'Dark Mode'),
            value: true,
            onChanged: (_) {},
          ),
          EmsToggleRow(
            label: t(context, 'Stroke'),
            value: false,
            onChanged: (_) {},
          ),
          EmsToggleRow(label: t(context, 'COPD'), value: false),
        ],
      ),
    );
  });

  emsGolden('ems_search_bar', size: const Size(460, 160), (context) {
    return SizedBox(
      width: 420,
      child: Column(
        children: [
          const EmsSearchBar(),
          const SizedBox(height: 12),
          EmsSearchBar(
            hintText: t(context, 'Search Medication'),
            controller: TextEditingController(text: 'Paracetamol'),
          ),
        ],
      ),
    );
  });
}
