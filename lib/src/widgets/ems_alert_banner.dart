import 'package:flutter/material.dart';
import '../tokens/tokens.dart';

/// Horizontal alert / info banner (e.g. notification warning on Team Setup).
///
/// Example: `EmsAlertBanner(title: t, message: m, tone: EmsTone.warning)`
class EmsAlertBanner extends StatelessWidget {
  /// Already-localized bold lead-in.
  final String title;

  /// Already-localized message.
  final String message;

  /// Semantic colour and icon. Defaults to [EmsTone.danger].
  final EmsTone tone;

  /// Creates a banner.
  const EmsAlertBanner({
    super.key,
    required this.title,
    required this.message,
    this.tone = EmsTone.danger,
  });

  IconData get _icon => switch (tone) {
    EmsTone.neutral || EmsTone.primary || EmsTone.info => Icons.info_outline,
    EmsTone.warning => Icons.warning_amber_outlined,
    EmsTone.danger => Icons.error_outline,
    EmsTone.success => Icons.check_circle_outline,
  };

  @override
  Widget build(BuildContext context) {
    final c = EmsColors.of(context);
    final bg = c.toneContainer(tone);
    final iconColor = c.tone(tone);
    final textColor = c.onToneContainer(tone);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: EmsSpacing.lg,
        vertical: EmsSpacing.md,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(EmsRadius.md),
        border: Border.all(color: iconColor.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Icon(_icon, color: iconColor, size: EmsIconSize.md),
          const SizedBox(width: EmsSpacing.md),
          Expanded(
            // Text.rich follows the text scale and theme font (DS-09).
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '$title ',
                    style: EmsTypography.of(
                      context,
                    ).labelLarge.copyWith(color: textColor),
                  ),
                  TextSpan(
                    text: message,
                    style: EmsTypography.of(
                      context,
                    ).bodySmall.copyWith(color: textColor),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
