import 'package:ems_design_system/ems_design_system.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../support.dart';

@widgetbook.UseCase(
  name: 'Actions and logo',
  type: EmsTopBar,
  path: '[Navigation]',
)
Widget emsTopBar(BuildContext context) {
  final k = context.knobs;
  final leading = k.boolean(label: 'Back button', initialValue: true);
  final logo = k.boolean(label: 'Logo', initialValue: true);
  return Showcase(
    maxWidth: 900,
    child: EmsTopBar(
      leading: [
        if (leading)
          EmsTopBarAction(
            icon: Icons.arrow_back,
            tooltip: l(context, 'Back', 'رجوع'),
            onPressed: () {},
          ),
      ],
      actions: [
        EmsTopBarAction(
          icon: Icons.dark_mode,
          tooltip: l(context, 'Dark Mode', 'الوضع الداكن'),
          onPressed: () {},
        ),
        EmsTopBarAction(
          icon: Icons.translate,
          tooltip: l(context, 'Language', 'اللغة'),
          onPressed: () {},
        ),
      ],
      // The catalog has no app assets; the app passes its logo image.
      logo: logo ? const FlutterLogo(size: 40) : null,
    ),
  );
}

@widgetbook.UseCase(
  name: 'Interactive',
  type: EmsStepIndicator,
  path: '[Navigation]',
)
Widget emsStepIndicator(BuildContext context) {
  final steps = [
    l(context, 'Case & Insurance', 'الحالة والتأمين'),
    l(context, 'Vital Signs', 'العلامات الحيوية'),
    l(context, 'Clinical Assessment', 'التقييم السريري'),
    l(context, 'Medical Intervention', 'التدخل الطبي'),
    l(context, 'SBAR & Staff', 'SBAR والطاقم'),
    l(context, 'Handover & Closure', 'التسليم والإغلاق'),
  ];
  return Stateful<int>(
    initial: 2,
    builder: (context, step, set) => Showcase(
      maxWidth: 1000,
      child: EmsStepIndicator(
        steps: steps,
        currentStep: step,
        onStepTapped: set,
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Interactive', type: EmsSidebar, path: '[Navigation]')
Widget emsSidebar(BuildContext context) {
  return Stateful<int>(
    initial: 1,
    builder: (context, index, set) => Align(
      alignment: AlignmentDirectional.centerStart,
      child: SizedBox(
        height: 420,
        child: EmsSidebar(
          selectedIndex: index,
          onItemTapped: set,
          items: [
            EmsSidebarItem(
              label: l(context, 'Dashboard', 'لوحة التحكم'),
              icon: Icons.dashboard_outlined,
            ),
            EmsSidebarItem(
              label: l(context, 'Notifications', 'الإشعارات'),
              icon: Icons.notifications_outlined,
            ),
            EmsSidebarItem(
              label: l(context, 'Settings', 'الإعدادات'),
              icon: Icons.settings_outlined,
            ),
          ],
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Playground',
  type: EmsNotificationItem,
  path: '[Navigation]',
)
Widget emsNotificationItem(BuildContext context) {
  final k = context.knobs;
  final status = k.object.segmented(
    label: 'Status',
    options: EmsNotificationStatus.values,
    initialOption: EmsNotificationStatus.now,
    labelBuilder: (s) => s.name,
  );
  final statusLabel = switch (status) {
    EmsNotificationStatus.now => l(context, 'Dispatch', 'إرسال'),
    EmsNotificationStatus.inProgress => l(
      context,
      'In Progress',
      'قيد التنفيذ',
    ),
    EmsNotificationStatus.completed => l(context, 'Done', 'مكتمل'),
  };
  return Showcase(
    maxWidth: 900,
    child: EmsNotificationItem(
      location: l(context, 'King Fahd Road, Riyadh', 'طريق الملك فهد، الرياض'),
      region: l(context, 'Central region', 'المنطقة الوسطى'),
      timeAgo: l(context, '5 min ago', 'منذ 5 دقائق'),
      status: status,
      statusLabel: statusLabel,
      followLabel: l(context, 'Follow Trip', 'متابعة الرحلة'),
      reportLabel: l(context, 'Report', 'تقرير'),
      isHighlighted: k.boolean(label: 'Highlighted'),
      onTap: () {},
      onFollow: () {},
      onReport: () {},
    ),
  );
}
