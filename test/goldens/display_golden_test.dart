// Phase 2.0 baseline goldens: display and feedback components in their
// current look.
import 'package:ems_design_system/ems_design_system.dart';
import 'package:flutter/material.dart';

import '../helpers/ems_test_app.dart';

void main() {
  emsGolden('ems_alert_banner', size: const Size(560, 420), (context) {
    return SizedBox(
      width: 520,
      child: Column(
        children: [
          // Same order as the old AlertBannerType.values, so the images match.
          for (final type in const [
            EmsTone.info,
            EmsTone.warning,
            EmsTone.danger,
            EmsTone.success,
          ]) ...[
            EmsAlertBanner(
              title: t(context, 'Notification Alert:'),
              message: t(context, 'Night shift handover starts in 20 minutes.'),
              tone: type,
            ),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  });

  emsGolden('ems_avatar', size: const Size(260, 100), (context) {
    return const Row(
      children: [
        EmsAvatar(initials: 'TP'),
        SizedBox(width: 16),
        EmsAvatar(initials: 'AB', showOnlineIndicator: true),
        SizedBox(width: 16),
        EmsAvatar(initials: 'CD', radius: 28, showOnlineIndicator: true),
      ],
    );
  });

  emsGolden('ems_card', size: const Size(460, 420), (context) {
    return SizedBox(
      width: 420,
      child: Column(
        children: [
          EmsCard(child: Text(t(context, 'Readiness Overview'))),
          const SizedBox(height: 12),
          EmsCard(
            selected: true,
            onTap: () {},
            child: Text(t(context, 'Advanced')),
          ),
          const SizedBox(height: 12),
          EmsCard(
            selected: true,
            tone: EmsTone.success,
            child: Text(t(context, 'Basic')),
          ),
          const SizedBox(height: 12),
          EmsCard(
            padding: const EdgeInsets.all(8),
            child: Text(t(context, 'Notes')),
          ),
        ],
      ),
    );
  });

  emsGolden('ems_chip', size: const Size(560, 160), (context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        EmsChip(label: t(context, 'Location')),
        EmsChip(
          tone: EmsTone.success,
          label: t(context, 'Completed'),
          icon: Icons.check_circle_outline,
        ),
        EmsChip(tone: EmsTone.danger, label: t(context, 'Cancelled')),
        EmsChip(
          tone: EmsTone.primary,
          label: t(context, 'Vehicle'),
          icon: Icons.local_shipping_outlined,
        ),
        EmsChip(label: t(context, 'Equipment')),
        EmsChip(
          label: t(context, 'Inspected'),
          backgroundColor: Colors.teal.shade50,
          textColor: Colors.teal.shade800,
          borderColor: Colors.teal,
          icon: Icons.verified_outlined,
        ),
      ],
    );
  });

  emsGolden('ems_icon_badge', size: const Size(360, 100), (context) {
    return const Row(
      children: [
        EmsIconBadge.location(),
        SizedBox(width: 12),
        EmsIconBadge.vehicle(),
        SizedBox(width: 12),
        EmsIconBadge.equipment(),
        SizedBox(width: 12),
        EmsIconBadge.crew(),
        SizedBox(width: 12),
        // Was the deprecated free colour (pink) until 2.11; the shim is gone,
        // so the fifth badge now covers `tone` at a custom size.
        EmsIconBadge(
          icon: Icons.favorite_outline,
          tone: EmsTone.danger,
          size: 56,
        ),
      ],
    );
  });

  emsGolden('ems_member_chip', size: const Size(560, 120), (context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        EmsMemberChip(name: 'Test Medic', role: t(context, 'Paramedic')),
        const EmsMemberChip(name: 'Test Driver', initials: 'TD'),
        EmsMemberChip(
          name: 'Test Lead',
          role: t(context, 'Supervisor'),
          avatarIcon: Icons.star_outline,
        ),
      ],
    );
  });

  emsGolden('ems_divider_with_text', size: const Size(460, 80), (context) {
    return SizedBox(
      width: 420,
      child: EmsDividerWithText(text: t(context, 'or')),
    );
  });

  emsGolden('ems_shimmer_box', size: const Size(460, 160), (context) {
    return SizedBox(
      width: 420,
      child: Column(
        children: [
          const EmsShimmerBox(height: 14),
          const SizedBox(height: 8),
          const EmsShimmerBox(height: 40, width: 200),
          const SizedBox(height: 8),
          EmsShimmerBox(height: 24, borderRadius: BorderRadius.circular(4)),
        ],
      ),
    );
  });

  emsGolden('ems_loading_overlay', size: const Size(460, 260), (context) {
    return SizedBox(
      width: 420,
      height: 200,
      child: Row(
        children: [
          Expanded(
            child: EmsLoadingOverlay(
              isLoading: true,
              child: EmsCard(child: Text(t(context, 'Loading...'))),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: EmsLoadingOverlay(
              isLoading: false,
              child: EmsCard(child: Text(t(context, 'Ready'))),
            ),
          ),
        ],
      ),
    );
  });

  emsGolden('ems_data_table', size: const Size(560, 240), (context) {
    return SizedBox(
      width: 520,
      child: EmsDataTable(
        columns: [
          t(context, 'Medication Name'),
          t(context, 'Dose'),
          t(context, 'Route'),
        ],
        rows: const [
          ['Paracetamol', '500 mg', 'Oral'],
          ['Saline', '500 mL', 'IV'],
        ],
      ),
    );
  });

  // New in step 2.6, so there is no earlier look to preserve.
  emsGolden('ems_chip_tones', size: const Size(560, 120), (context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final tone in EmsTone.values)
          EmsChip(label: t(context, 'Status'), tone: tone),
      ],
    );
  });
}
