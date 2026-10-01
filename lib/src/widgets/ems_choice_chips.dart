import 'package:flutter/material.dart';

import '../tokens/tokens.dart';
import 'ems_tappable.dart';

/// One option of [EmsChoiceChips].
@immutable
class EmsChoice<T> {
  /// Creates an option.
  const EmsChoice({required this.value, required this.label});

  /// The value reported to [EmsChoiceChips.onChanged].
  final T value;

  /// Already-localized label.
  final String label;
}

/// A wrap of single-choice chips. Replaces `EmsStatusChipGroup` (DS-19).
///
/// Example:
/// ```dart
/// EmsChoiceChips<CaseStatus>(
///   items: [for (final s in CaseStatus.values) EmsChoice(value: s, label: s.label)],
///   selected: status,
///   onChanged: setStatus,
/// )
/// ```
class EmsChoiceChips<T> extends StatelessWidget {
  /// Creates choice chips.
  const EmsChoiceChips({
    super.key,
    required this.items,
    this.selected,
    this.onChanged,
  });

  /// The options.
  final List<EmsChoice<T>> items;

  /// The selected value, if any.
  final T? selected;

  /// Called with the tapped value. `null` disables the chips.
  final ValueChanged<T>? onChanged;

  @override
  Widget build(BuildContext context) {
    final c = EmsColors.of(context);
    final radius = BorderRadius.circular(EmsRadius.full);
    return Wrap(
      spacing: EmsSpacing.sm,
      runSpacing: EmsSpacing.sm,
      children: [
        for (final item in items)
          Builder(
            builder: (context) {
              final isSelected = item.value == selected;
              return AnimatedContainer(
                duration: EmsMotion.of(context).normal,
                decoration: BoxDecoration(
                  color: isSelected ? c.primaryContainer : c.surface,
                  borderRadius: radius,
                  border: Border.all(
                    color: isSelected ? c.primary : c.borderStrong,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                constraints: const BoxConstraints(
                  minHeight: EmsSizes.chipHeight,
                ),
                child: EmsTappable(
                  onTap: onChanged == null
                      ? null
                      : () => onChanged!(item.value),
                  selected: isSelected,
                  borderRadius: radius,
                  child: Padding(
                    // The 2 px selected outline is offset by 1 px less padding.
                    padding: EdgeInsets.symmetric(
                      horizontal: EmsSpacing.lg - (isSelected ? 1 : 0),
                      vertical: EmsSpacing.sm - (isSelected ? 1 : 0),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Selection is shown by a check, not colour alone.
                        if (isSelected) ...[
                          ExcludeSemantics(
                            child: Icon(
                              Icons.check_rounded,
                              size: EmsIconSize.xs,
                              color: c.onPrimaryContainer,
                            ),
                          ),
                          const SizedBox(width: EmsSpacing.xs),
                        ],
                        Text(
                          item.label,
                          style: EmsTypography.of(context).labelLarge.copyWith(
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
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}
