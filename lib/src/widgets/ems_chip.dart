import 'package:flutter/material.dart';
import '../tokens/tokens.dart';

/// Small static tag (e.g. "Location", "Vehicle", "Completed").
///
/// Example: `EmsChip(label: completedLabel, tone: EmsTone.success)`
class EmsChip extends StatelessWidget {
  /// Already-localized label.
  final String label;

  /// Semantic colour of the chip. Defaults to [EmsTone.neutral].
  final EmsTone tone;

  /// Overrides the tone's fill. Prefer [tone].
  final Color? backgroundColor;

  /// Overrides the tone's text and icon colour. Prefer [tone].
  final Color? textColor;

  /// Overrides the tone's outline. Prefer [tone].
  final Color? borderColor;

  /// Optional leading icon.
  final IconData? icon;

  /// Creates a chip.
  const EmsChip({
    super.key,
    required this.label,
    this.tone = EmsTone.neutral,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.icon,
  });

  /// Fill, foreground and outline of each tone: the tone's container with
  /// its on-container text (≥ 7:1 in both themes).
  static (Color, Color, Color) _toneColors(EmsColors c, EmsTone tone) => (
    c.toneContainer(tone),
    c.onToneContainer(tone),
    tone == EmsTone.neutral
        ? c.borderSubtle
        : c.tone(tone).withValues(alpha: 0.4),
  );

  @override
  Widget build(BuildContext context) {
    final c = EmsColors.of(context);
    final (fill, foreground, outline) = _toneColors(c, tone);
    final fg = textColor ?? foreground;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: EmsSpacing.md,
        vertical: EmsSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? fill,
        borderRadius: BorderRadius.circular(EmsRadius.full),
        border: Border.all(color: borderColor ?? outline, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: EmsIconSize.xs, color: fg),
            const SizedBox(width: EmsSpacing.xs),
          ],
          Text(
            label,
            style: EmsTypography.of(context).chip.copyWith(color: fg),
          ),
        ],
      ),
    );
  }
}
