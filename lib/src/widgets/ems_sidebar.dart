import 'package:flutter/material.dart';
import '../tokens/tokens.dart';
import 'ems_tappable.dart';

/// Sidebar navigation item model.
class EmsSidebarItem {
  /// Already-localized label.
  final String label;

  /// Leading icon.
  final IconData icon;

  /// Creates a sidebar item.
  const EmsSidebarItem({required this.label, required this.icon});
}

/// Vertical sidebar navigation (from Notifications screen).
class EmsSidebar extends StatelessWidget {
  /// The rows.
  final List<EmsSidebarItem> items;

  /// Index of the selected row.
  final int selectedIndex;

  /// Called with the tapped index.
  final ValueChanged<int>? onItemTapped;

  /// Shown above the rows.
  final Widget? header;

  /// Shown below the rows.
  final Widget? footer;

  /// Creates a sidebar.
  const EmsSidebar({
    super.key,
    required this.items,
    required this.selectedIndex,
    this.onItemTapped,
    this.header,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    final c = EmsColors.of(context);
    return Container(
      width: EmsSizes.sidebarWidth,
      decoration: BoxDecoration(
        color: c.surface,
        border: BorderDirectional(start: BorderSide(color: c.borderSubtle)),
      ),
      child: Column(
        children: [
          if (header != null) header!,
          const SizedBox(height: EmsSpacing.lg),
          // Nav items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: EmsSpacing.md),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final isSelected = index == selectedIndex;

                final radius = BorderRadius.circular(EmsRadius.sm);
                return Container(
                  margin: const EdgeInsets.only(bottom: EmsSpacing.xs),
                  decoration: BoxDecoration(
                    color: isSelected ? c.primaryContainer : Colors.transparent,
                    borderRadius: radius,
                  ),
                  child: EmsTappable(
                    onTap: onItemTapped == null
                        ? null
                        : () => onItemTapped!(index),
                    selected: isSelected,
                    borderRadius: radius,
                    child: Container(
                      constraints: const BoxConstraints(
                        minHeight: EmsSizes.minTap,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: EmsSpacing.md,
                        vertical: EmsSpacing.sm,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            item.icon,
                            size: EmsIconSize.sm,
                            color: isSelected
                                ? c.onPrimaryContainer
                                : c.textSecondary,
                          ),
                          const SizedBox(width: EmsSpacing.md),
                          Expanded(
                            child: Text(
                              item.label,
                              style: EmsTypography.of(context).labelLarge
                                  .copyWith(
                                    fontWeight: isSelected
                                        ? EmsTypography.of(
                                            context,
                                          ).labelLarge.fontWeight
                                        : FontWeight.w400,
                                    color: isSelected
                                        ? c.onPrimaryContainer
                                        : c.textSecondary,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (footer != null) footer!,
          const SizedBox(height: EmsSpacing.lg),
        ],
      ),
    );
  }
}
