// Helpers shared by the use cases.
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

/// Lays a use case out the way a tablet form shows it: centred, with a
/// readable maximum width and page padding.
class Showcase extends StatelessWidget {
  /// Creates a showcase frame.
  const Showcase({super.key, required this.child, this.maxWidth = 560});

  /// The component(s) on show.
  final Widget child;

  /// Maximum width of the content.
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: child,
        ),
      ),
    );
  }
}

/// A column with a fixed gap between [children].
class Gap extends StatelessWidget {
  /// Creates a spaced column.
  const Gap({super.key, required this.children, this.gap = 16});

  /// The items.
  final List<Widget> children;

  /// Space between items.
  final double gap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) SizedBox(height: gap),
          children[i],
        ],
      ],
    );
  }
}

/// Whether the locale addon is on Arabic.
bool isArabic(BuildContext context) =>
    Localizations.localeOf(context).languageCode == 'ar';

/// Sample app text in the active locale.
///
/// The design system never translates app strings, so the catalog passes
/// already-localized samples, like the app does.
String l(BuildContext context, String en, String ar) =>
    isArabic(context) ? ar : en;

/// A text knob whose English default shows as [ar] while the locale addon is
/// on Arabic. Text typed into the knob is shown as is.
String textKnob(
  BuildContext context,
  String label, {
  required String en,
  required String ar,
}) {
  final value = context.knobs.string(label: label, initialValue: en);
  return isArabic(context) && value == en ? ar : value;
}

/// Holds one piece of state for an interactive use case.
class Stateful<T> extends StatefulWidget {
  /// Creates a state holder starting at [initial].
  const Stateful({super.key, required this.initial, required this.builder});

  /// The starting value.
  final T initial;

  /// Builds the use case with the current value and a setter.
  final Widget Function(BuildContext context, T value, ValueChanged<T> set)
  builder;

  @override
  State<Stateful<T>> createState() => _StatefulState<T>();
}

class _StatefulState<T> extends State<Stateful<T>> {
  late T _value = widget.initial;

  @override
  void didUpdateWidget(Stateful<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // A knob changed the starting value: follow it.
    if (oldWidget.initial != widget.initial) _value = widget.initial;
  }

  @override
  Widget build(BuildContext context) =>
      widget.builder(context, _value, (v) => setState(() => _value = v));
}
