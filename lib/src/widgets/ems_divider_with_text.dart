import 'package:flutter/material.dart';
import '../tokens/tokens.dart';

/// Horizontal divider with centered text (e.g. "or" on Sign In screen).
class EmsDividerWithText extends StatelessWidget {
  /// Already-localized text in the middle (e.g. "or").
  final String text;

  /// Creates a divider with text.
  const EmsDividerWithText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final c = EmsColors.of(context);
    return Row(
      children: [
        Expanded(child: Divider(color: c.borderSubtle)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: EmsSpacing.lg),
          child: Text(
            text,
            style: EmsTypography.of(
              context,
            ).bodyMedium.copyWith(color: c.textSecondary),
          ),
        ),
        Expanded(child: Divider(color: c.borderSubtle)),
      ],
    );
  }
}
