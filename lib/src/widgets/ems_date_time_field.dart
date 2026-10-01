import 'package:flutter/material.dart';
import '../tokens/tokens.dart';
import 'ems_tappable.dart';

/// Tappable date/time field with a calendar icon at the end. The app opens
/// the picker in [onTap]; `null` disables the field. At least 56 dp tall and
/// grows with the text scale (DS-18). The placeholder uses `textHint`, a value
/// `textPrimary` (DS-22).
///
/// Example: `EmsDateTimeField(label: l, hintText: h, value: v, onTap: pick)`
class EmsDateTimeField extends StatelessWidget {
  /// Already-localized label above the field.
  final String label;

  /// The formatted value. `null` shows [hintText].
  final String? value;

  /// Already-localized placeholder.
  final String? hintText;

  /// Opens the picker. `null` disables the field.
  final VoidCallback? onTap;

  /// Creates a date/time field.
  const EmsDateTimeField({
    super.key,
    required this.label,
    this.value,
    this.hintText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = EmsColors.of(context);
    final radius = BorderRadius.circular(EmsRadius.md);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Announced once, as the field's label (below).
        ExcludeSemantics(
          child: Text(
            label,
            style: EmsTypography.of(
              context,
            ).labelLarge.copyWith(color: c.textPrimary),
          ),
        ),
        const SizedBox(height: EmsSpacing.sm),
        Container(
          constraints: const BoxConstraints(minHeight: EmsSizes.inputHeight),
          decoration: BoxDecoration(
            color: onTap == null ? c.surfaceSunken : c.surface,
            borderRadius: radius,
            border: Border.all(
              color: onTap == null ? c.borderSubtle : c.borderStrong,
            ),
          ),
          child: EmsTappable(
            onTap: onTap,
            semanticLabel: label,
            borderRadius: radius,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: EmsSpacing.lg,
                vertical: EmsSpacing.md,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      value ?? hintText ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      // The placeholder is visibly not a value (DS-22).
                      style: EmsTypography.of(context).bodyMedium.copyWith(
                        color: switch ((value != null, onTap != null)) {
                          (true, true) => c.textPrimary,
                          (true, false) => c.textSecondary,
                          (false, true) => c.textHint,
                          // Disabled placeholder (exempt; the field is
                          // announced as disabled).
                          (false, false) => c.textDisabled,
                        },
                      ),
                    ),
                  ),
                  Icon(
                    Icons.calendar_today_outlined,
                    color: onTap == null ? c.textDisabled : c.textSecondary,
                    size: EmsIconSize.md,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
