import 'package:flutter/material.dart';
import '../tokens/tokens.dart';
import 'ems_tappable.dart';
import '../l10n/ems_localizations.dart';

/// Horizontal numbered step tabs (the 6 clinical-assessment steps).
///
/// - Active: `primary` circle with `onPrimary` number, bold label and a
///   `primary` underline.
/// - Completed: `primaryContainer` circle with a check icon (so state is not
///   colour-only, DS-07), announced as "Completed".
/// - Upcoming: `surfaceSunken` circle with a `borderStrong` outline.
///
/// Each tab is at least 48 dp tall (DS-08); the number circle grows with the
/// text scale instead of clipping (DS-18).
///
/// Example:
/// ```dart
/// EmsStepIndicator(steps: titles, currentStep: 2, onStepTapped: goTo)
/// ```
class EmsStepIndicator extends StatelessWidget {
  /// Already-localized step titles.
  final List<String> steps;

  /// Zero-based index of the active step.
  final int currentStep;

  /// Called with the tapped step index. `null` makes the tabs read-only.
  final ValueChanged<int>? onStepTapped;

  /// Creates step tabs.
  const EmsStepIndicator({
    super.key,
    required this.steps,
    required this.currentStep,
    this.onStepTapped,
  });

  @override
  Widget build(BuildContext context) {
    final c = EmsColors.of(context);
    final type = EmsTypography.of(context);
    final l10n = EmsLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: EmsSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(steps.length, (index) {
          final isActive = index == currentStep;
          final isCompleted = index < currentStep;

          final circle = Container(
            constraints: const BoxConstraints(
              minWidth: EmsSizes.stepCircle,
              minHeight: EmsSizes.stepCircle,
            ),
            padding: const EdgeInsets.symmetric(horizontal: EmsSpacing.xs),
            decoration: BoxDecoration(
              color: isActive
                  ? c.primary
                  : isCompleted
                  ? c.primaryContainer
                  : c.surfaceSunken,
              borderRadius: BorderRadius.circular(EmsRadius.full),
              border: Border.all(
                color: isActive || isCompleted ? c.primary : c.borderStrong,
                width: 1.5,
              ),
            ),
            alignment: Alignment.center,
            child: isCompleted
                ? Icon(
                    Icons.check_rounded,
                    size: EmsIconSize.xs,
                    color: c.onPrimaryContainer,
                  )
                : Text(
                    '${index + 1}',
                    style: type.labelMedium.copyWith(
                      color: isActive ? c.onPrimary : c.textSecondary,
                      height: 1.2,
                    ),
                  ),
          );

          return Expanded(
            child: EmsTappable(
              onTap: onStepTapped != null ? () => onStepTapped!(index) : null,
              isButton: onStepTapped != null,
              selected: isActive,
              semanticValue: isCompleted ? l10n.completed : null,
              borderRadius: BorderRadius.circular(EmsRadius.sm),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: EmsSizes.minTap),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: EmsSpacing.xs,
                        vertical: EmsSpacing.sm,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          circle,
                          const SizedBox(width: EmsSpacing.sm),
                          Flexible(
                            child: Text(
                              steps[index],
                              style: type.labelLarge.copyWith(
                                fontWeight: isActive
                                    ? type.labelLarge.fontWeight
                                    : FontWeight.w400,
                                color: isActive
                                    ? c.textPrimary
                                    : c.textSecondary,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Active underline
                    Container(
                      height: 3,
                      margin: const EdgeInsets.symmetric(
                        horizontal: EmsSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: isActive ? c.primary : Colors.transparent,
                        borderRadius: BorderRadius.circular(EmsRadius.full),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
