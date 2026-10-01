import 'package:flutter/material.dart';
import '../tokens/tokens.dart';

/// Row with label + toggle switch (e.g. medical history conditions).
class EmsToggleRow extends StatelessWidget {
  /// Already-localized label.
  final String label;

  /// Whether the switch is on.
  final bool value;

  /// Called with the new value. `null` disables the switch.
  final ValueChanged<bool>? onChanged;

  /// Creates a toggle row.
  const EmsToggleRow({
    super.key,
    required this.label,
    required this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // One node: the label is read with the switch's state.
    return MergeSemantics(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: EmsSpacing.sm),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                label,
                style: EmsTypography.of(context).bodyLarge.copyWith(
                  color: onChanged == null
                      ? EmsColors.of(context).textSecondary
                      : EmsColors.of(context).textPrimary,
                ),
              ),
            ),
            // Colours come from the theme's switchTheme: the off state has a
            // 2 px borderStrong outline (DS-06).
            Switch(value: value, onChanged: onChanged),
          ],
        ),
      ),
    );
  }
}
