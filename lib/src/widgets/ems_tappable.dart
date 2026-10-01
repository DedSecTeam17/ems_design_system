import 'package:flutter/material.dart';

/// The shared tap surface of the design system: ink feedback, keyboard focus
/// and activation, and button / selected / enabled semantics, without changing
/// the look of its [child].
///
/// Put it *inside* the decorated container so the ink draws over the
/// container's fill and under the content:
/// ```dart
/// AnimatedContainer(
///   decoration: BoxDecoration(color: c.surface, borderRadius: radius),
///   child: EmsTappable(
///     onTap: onTap,
///     selected: isSelected,
///     borderRadius: radius,
///     child: Padding(padding: insets, child: Text(label)),
///   ),
/// )
/// ```
class EmsTappable extends StatelessWidget {
  /// Creates a tap surface.
  const EmsTappable({
    super.key,
    required this.child,
    this.onTap,
    this.selected,
    this.semanticLabel,
    this.semanticValue,
    this.expanded,
    this.isButton = true,
    this.borderRadius,
    this.customBorder,
  });

  /// The content. Its layout and look are unchanged.
  final Widget child;

  /// Called on tap or keyboard activation. `null` disables the surface.
  final VoidCallback? onTap;

  /// Announced selected state (`null` = not selectable).
  final bool? selected;

  /// Already-localized label. Defaults to the text inside [child].
  final String? semanticLabel;

  /// Already-localized state description (e.g. "Completed").
  final String? semanticValue;

  /// Announced expanded state of a collapsible header.
  final bool? expanded;

  /// Whether to announce a button. Set to false for read-only indicators.
  final bool isButton;

  /// Clips the ink to this radius.
  final BorderRadius? borderRadius;

  /// Clips the ink to this shape (e.g. `CircleBorder()`).
  final ShapeBorder? customBorder;

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: Semantics(
        button: isButton,
        enabled: isButton ? onTap != null : null,
        selected: selected,
        expanded: expanded,
        label: semanticLabel,
        value: semanticValue,
        child: Material(
          type: MaterialType.transparency,
          // Keep the ambient text style; Material would reset it.
          textStyle: DefaultTextStyle.of(context).style,
          child: InkWell(
            onTap: onTap,
            borderRadius: borderRadius,
            customBorder: customBorder,
            child: child,
          ),
        ),
      ),
    );
  }
}
