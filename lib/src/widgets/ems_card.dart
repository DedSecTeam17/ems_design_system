import 'package:flutter/material.dart';
import '../tokens/tokens.dart';
import 'ems_tappable.dart';

/// Flat card: `surface` with a 1 px `borderSubtle` edge and the `lg` radius
/// (decision D5). Tappable when [onTap] is set; a [selected] card gets a 2 px
/// outline in its [tone] (primary by default).
///
/// Example:
/// ```dart
/// EmsCard(selected: isSelected, onTap: select, child: Text(teamName))
/// ```
class EmsCard extends StatelessWidget {
  /// The content.
  final Widget child;

  /// Inner padding. Defaults to 20 dp.
  final EdgeInsetsGeometry? padding;

  /// Colour of the selected outline. Defaults to [EmsTone.primary].
  final EmsTone? tone;

  /// Called on tap. Makes the card a button for screen readers.
  final VoidCallback? onTap;

  /// Shows the selected outline and announces the selected state.
  final bool selected;

  /// Creates a card.
  const EmsCard({
    super.key,
    required this.child,
    this.padding,
    this.tone,
    this.onTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final c = EmsColors.of(context);
    final selectedColor = c.tone(tone ?? EmsTone.primary);
    final radius = BorderRadius.circular(EmsRadius.lg);
    final content = Padding(
      padding: padding ?? const EdgeInsets.all(EmsSpacing.xl),
      child: child,
    );

    return AnimatedContainer(
      duration: EmsMotion.of(context).normal,
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: radius,
        border: Border.all(
          color: selected ? selectedColor : c.borderSubtle,
          width: selected ? 2 : 1,
        ),
      ),
      child: onTap == null
          ? content
          : EmsTappable(
              onTap: onTap,
              selected: selected,
              borderRadius: radius,
              child: content,
            ),
    );
  }
}
