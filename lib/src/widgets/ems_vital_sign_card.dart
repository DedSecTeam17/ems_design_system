import 'package:flutter/material.dart';
import '../tokens/tokens.dart';
import '../theme/ems_input_decoration.dart';

/// Vital sign display card showing label, type, value input, and unit.
/// (e.g. Pulse: INT → [editable] bpm)
class EmsVitalSignCard extends StatelessWidget {
  /// Already-localized vital name (e.g. "Pulse").
  final String label;

  /// Already-localized value type (e.g. "INT").
  final String typeLabel;

  /// Already-localized placeholder.
  final String? hintText;

  /// Unit shown after the field (e.g. "bpm").
  final String unit;

  /// Controls the value text.
  final TextEditingController? controller;

  /// Keyboard for the value. Defaults to numbers.
  final TextInputType keyboardType;

  /// Already-localized error shown under the field (announced).
  final String? errorText;

  /// Called on every edit.
  final ValueChanged<String>? onChanged;

  /// Creates a vital-sign card.
  const EmsVitalSignCard({
    super.key,
    required this.label,
    required this.typeLabel,
    this.hintText,
    required this.unit,
    this.controller,
    this.keyboardType = TextInputType.number,
    this.errorText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final c = EmsColors.of(context);
    return Container(
      padding: const EdgeInsets.all(EmsSpacing.lg),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(EmsRadius.md),
        border: Border.all(color: c.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Text(
            label.toUpperCase(),
            style: EmsTypography.of(context).labelLarge.copyWith(
              color: c.textPrimary,
              letterSpacing: EmsTypography.letterSpacing(context, 0.3),
            ),
          ),
          const SizedBox(height: EmsSpacing.xs),
          // Type tag
          Text(
            typeLabel.toUpperCase(),
            style: EmsTypography.of(context).labelSmall.copyWith(
              color: c.textHint,
              letterSpacing: EmsTypography.letterSpacing(context, 0.5),
            ),
          ),
          const SizedBox(height: EmsSpacing.sm),
          // Editable value: a real input, so the error is drawn as a 2 px
          // danger outline and announced with the field (DS-22).
          TextFormField(
            controller: controller,
            style: EmsTypography.of(
              context,
            ).numericLarge.copyWith(color: c.textPrimary),
            keyboardType: keyboardType,
            onChanged: onChanged,
            decoration: EmsInputDecoration.of(
              context,
              hintText: hintText ?? '—',
              errorText: errorText,
              hintStyle: EmsTypography.of(context).numericLarge,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: EmsSpacing.md,
                vertical: EmsSpacing.sm,
              ),
            ),
          ),
          const SizedBox(height: EmsSpacing.xs),
          // Unit
          Text(
            unit,
            style: EmsTypography.of(
              context,
            ).bodySmall.copyWith(color: c.textSecondary),
          ),
        ],
      ),
    );
  }
}
