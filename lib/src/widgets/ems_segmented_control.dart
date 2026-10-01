import 'package:flutter/material.dart';
import '../tokens/tokens.dart';
import 'ems_tappable.dart';

/// Segmented tab control (e.g. "During transport =1" / "During Handover =2").
class EmsSegmentedControl extends StatelessWidget {
  /// Already-localized segment labels.
  final List<String> segments;

  /// Index of the selected segment.
  final int selectedIndex;

  /// Called with the tapped index. `null` disables the control.
  final ValueChanged<int>? onChanged;

  /// Creates a segmented control.
  const EmsSegmentedControl({
    super.key,
    required this.segments,
    required this.selectedIndex,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final c = EmsColors.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(EmsRadius.md),
        border: Border.all(color: c.borderStrong),
      ),
      child: Row(
        children: List.generate(segments.length, (index) {
          final isSelected = index == selectedIndex;

          // Inner radius of the 1 px outlined track.
          final radius = BorderRadius.circular(EmsRadius.md - 1);
          return Expanded(
            child: AnimatedContainer(
              duration: EmsMotion.of(context).normal,
              decoration: BoxDecoration(
                color: isSelected ? c.surface : Colors.transparent,
                borderRadius: radius,
                border: isSelected
                    ? Border.all(color: c.primary, width: 2)
                    : null,
              ),
              child: EmsTappable(
                onTap: onChanged == null ? null : () => onChanged!(index),
                selected: isSelected,
                borderRadius: radius,
                child: Container(
                  constraints: const BoxConstraints(
                    minHeight: EmsSizes.chipHeight,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: EmsSpacing.md),
                  alignment: Alignment.center,
                  child: Text(
                    segments[index],
                    // Selected: the label style (600, or 700 in Arabic).
                    style:
                        (isSelected
                                ? EmsTypography.of(context).labelLarge
                                : EmsTypography.of(context).bodyMedium)
                            .copyWith(
                              color: isSelected
                                  ? c.textPrimary
                                  : c.textSecondary,
                            ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
