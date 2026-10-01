import 'package:flutter/material.dart';
import '../tokens/tokens.dart';

/// Slider with label, value badge, and min/max labels.
/// Used for Glasgow coma scale (Eyes Open, Verbal Response, Motor).
class EmsSliderField extends StatelessWidget {
  /// Already-localized label.
  final String label;

  /// Current value, shown in the badge.
  final double value;

  /// Lowest value.
  final double min;

  /// Highest value.
  final double max;

  /// Number of discrete steps between [min] and [max].
  final int divisions;

  /// Already-localized caption under the start of the track.
  final String? minLabel;

  /// Already-localized caption under the end of the track.
  final String? maxLabel;

  /// Called while dragging. `null` disables the slider.
  final ValueChanged<double>? onChanged;

  /// Creates a slider field.
  const EmsSliderField({
    super.key,
    required this.label,
    required this.value,
    this.min = 1,
    this.max = 6,
    this.divisions = 5,
    this.minLabel,
    this.maxLabel,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final c = EmsColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label + value badge
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                label,
                style: EmsTypography.of(
                  context,
                ).bodyLarge.copyWith(color: c.textPrimary),
              ),
            ),
            // Grows with the text scale instead of clipping (DS-18).
            Container(
              constraints: const BoxConstraints(
                minWidth: EmsSizes.sliderBadge,
                minHeight: EmsSizes.sliderBadge,
              ),
              padding: const EdgeInsets.symmetric(horizontal: EmsSpacing.sm),
              decoration: BoxDecoration(
                color: c.primaryContainer,
                borderRadius: BorderRadius.circular(EmsRadius.full),
              ),
              alignment: Alignment.center,
              child: Text(
                value.toInt().toString(),
                style: EmsTypography.of(
                  context,
                ).labelLarge.copyWith(color: c.onPrimaryContainer),
              ),
            ),
          ],
        ),
        const SizedBox(height: EmsSpacing.xs),
        // Slider
        SliderTheme(
          // Colours come from the theme's sliderTheme (inactive track
          // borderStrong, DS-06).
          data: SliderTheme.of(context).copyWith(
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
          ),
        ),
        // Min / Max labels
        if (minLabel != null || maxLabel != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: EmsSpacing.sm),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  minLabel ?? '',
                  style: EmsTypography.of(context).labelSmall.copyWith(
                    color: c.textSecondary,
                    letterSpacing: EmsTypography.letterSpacing(context, 0.5),
                  ),
                ),
                Text(
                  maxLabel ?? '',
                  style: EmsTypography.of(context).labelSmall.copyWith(
                    color: c.textSecondary,
                    letterSpacing: EmsTypography.letterSpacing(context, 0.5),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
