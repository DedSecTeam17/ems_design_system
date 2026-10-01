import 'package:flutter/material.dart';
import '../tokens/tokens.dart';
import 'ems_button.dart';
import '../l10n/ems_localizations.dart';

/// Wizard footer: Previous / Next ([EmsButton], regular size) and the step
/// label (e.g. "Step 3 of 6 • Clinical Assessment Details").
///
/// Example:
/// ```dart
/// EmsBottomStepNav(currentStep: 3, totalSteps: 6, stepLabel: title,
///     onPrev: back, onNext: next)
/// ```
class EmsBottomStepNav extends StatelessWidget {
  /// The current step, 1-based.
  final int currentStep;

  /// Number of steps in the wizard.
  final int totalSteps;

  /// Already-localized title of the current step.
  final String stepLabel;

  /// Goes back a step. `null` hides the Previous button (its space is kept).
  final VoidCallback? onPrev;

  /// Goes forward a step. `null` disables the Next button.
  final VoidCallback? onNext;

  /// Creates the wizard footer.
  const EmsBottomStepNav({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.stepLabel,
    this.onPrev,
    this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final c = EmsColors.of(context);
    final l10n = EmsLocalizations.of(context);
    final stepText = '${l10n.stepOf(currentStep, totalSteps)} • $stepLabel';
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: EmsSpacing.xxl,
        vertical: EmsSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: c.surface,
        border: Border(top: BorderSide(color: c.borderSubtle)),
      ),
      child: Row(
        children: [
          // Prev. When there is no previous step an invisible copy keeps the
          // label centred at any text scale (was a fixed 100 dp box, DS-18).
          Visibility(
            visible: onPrev != null,
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            child: EmsButton(
              label: l10n.previous,
              icon: Icons.arrow_back,
              variant: EmsButtonVariant.secondary,
              size: EmsButtonSize.regular,
              fullWidth: false,
              onPressed: onPrev,
            ),
          ),
          const SizedBox(width: EmsSpacing.md),
          // Center step label
          Expanded(
            child: Text(
              stepText,
              style: EmsTypography.of(
                context,
              ).bodyMedium.copyWith(color: c.textSecondary),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: EmsSpacing.md),
          EmsButton(
            label: l10n.next,
            trailingIcon: Icons.arrow_forward,
            size: EmsButtonSize.regular,
            fullWidth: false,
            onPressed: onNext,
          ),
        ],
      ),
    );
  }
}
