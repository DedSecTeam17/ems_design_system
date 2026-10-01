// Phase 2.0 baseline goldens: top bar, sidebar and notification row in their
// current look.
import 'dart:io';

import 'package:ems_design_system/ems_design_system.dart';
import 'package:flutter/material.dart';

import '../helpers/ems_test_app.dart';

// A copy of the app logo (test fixture only; the package ships no images).
// One MemoryImage instance, so the precached image is the one painted.
final _logo = MemoryImage(File('test/fixtures/app_logo.png').readAsBytesSync());

void main() {
  emsGolden(
    'ems_top_bar',
    size: const Size(720, 260),
    (context) {
      return SizedBox(
        width: 680,
        child: Column(
          children: [
            EmsTopBar(
              actions: [
                EmsTopBarAction(icon: Icons.dark_mode, onPressed: () {}),
              ],
              logo: Image(image: _logo, width: 120, height: 120),
            ),
            EmsTopBar(
              leading: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_back),
                ),
              ],
              actions: [
                EmsTopBarAction(icon: Icons.light_mode, onPressed: () {}),
                const SizedBox(width: 12),
                EmsTopBarAction(icon: Icons.translate, onPressed: () {}),
              ],
            ),
            const EmsTopBar(logo: FlutterLogo(size: 40)),
          ],
        ),
      );
    },
    act: (tester) => precacheImages(tester, [_logo]),
  );

  emsGolden('ems_sidebar', size: const Size(300, 420), (context) {
    return SizedBox(
      height: 380,
      child: EmsSidebar(
        selectedIndex: 1,
        onItemTapped: (_) {},
        header: const Padding(
          padding: EdgeInsets.all(16),
          child: Text('EMS.AI'),
        ),
        items: [
          EmsSidebarItem(
            label: t(context, 'Dashboard'),
            icon: Icons.dashboard_outlined,
          ),
          EmsSidebarItem(
            label: t(context, 'Notifications'),
            icon: Icons.notifications_outlined,
          ),
          EmsSidebarItem(
            label: t(context, 'Settings'),
            icon: Icons.settings_outlined,
          ),
        ],
      ),
    );
  });

  emsGolden('ems_notification_item', size: const Size(860, 400), (context) {
    return SizedBox(
      width: 820,
      child: Column(
        children: [
          EmsNotificationItem(
            statusLabel: t(context, 'Dispatch'),
            followLabel: t(context, 'Follow Trip'),
            reportLabel: t(context, 'Report'),
            location: 'Downtown Station',
            region: 'Region A',
            timeAgo: '5 min',
            status: EmsNotificationStatus.now,
            isHighlighted: true,
            onTap: () {},
            onFollow: () {},
            onReport: () {},
          ),
          EmsNotificationItem(
            statusLabel: t(context, 'In Progress'),
            followLabel: t(context, 'Follow Trip'),
            reportLabel: t(context, 'Report'),
            location: 'North Hospital',
            region: 'Region B',
            timeAgo: '20 min',
            status: EmsNotificationStatus.inProgress,
          ),
          EmsNotificationItem(
            statusLabel: t(context, 'Done'),
            followLabel: t(context, 'Follow Trip'),
            reportLabel: t(context, 'Report'),
            location: 'East Clinic',
            region: 'Region C',
            timeAgo: '1 h',
            onTap: () {},
          ),
        ],
      ),
    );
  });

  // DS-36: a long address wraps to 2 lines, then ends with an ellipsis; a
  // long region is cut to 1 line. No overflow at any text scale.
  emsGolden('ems_notification_item_long_address', size: const Size(860, 340), (
    context,
  ) {
    final ar = Localizations.localeOf(context).languageCode == 'ar';
    return SizedBox(
      width: 820,
      child: Column(
        children: [
          EmsNotificationItem(
            statusLabel: t(context, 'Dispatch'),
            followLabel: t(context, 'Follow Trip'),
            reportLabel: t(context, 'Report'),
            location: ar
                ? 'طريق الملك فهد، تقاطع شارع العليا العام مع طريق '
                      'الأمير محمد بن عبدالعزيز، بجوار برج المملكة، '
                      'حي العليا، الرياض 12214'
                : 'King Fahd Road, intersection of Olaya Street and Prince '
                      'Mohammed bin Abdulaziz Road, next to Kingdom Tower, '
                      'Al Olaya District, Riyadh 12214',
            region: ar
                ? 'المنطقة الوسطى، قطاع شمال الرياض'
                : 'Central region, North Riyadh sector',
            timeAgo: '5 min',
            status: EmsNotificationStatus.now,
            isHighlighted: true,
            onTap: () {},
            onFollow: () {},
            onReport: () {},
          ),
          EmsNotificationItem(
            statusLabel: t(context, 'In Progress'),
            followLabel: t(context, 'Follow Trip'),
            reportLabel: t(context, 'Report'),
            location: ar
                ? 'مستشفى الملك فيصل التخصصي ومركز الأبحاث'
                : 'King Faisal Specialist Hospital and Research Centre',
            region: ar ? 'المنطقة ب' : 'Region B',
            timeAgo: '20 min',
            status: EmsNotificationStatus.inProgress,
          ),
        ],
      ),
    );
  });
}
