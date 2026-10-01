import 'package:flutter/material.dart';

import '../tokens/tokens.dart';
import 'ems_tappable.dart';

/// One option of an [EmsTileSelector].
@immutable
class EmsTileItem<T> {
  /// Creates an option.
  const EmsTileItem({
    required this.value,
    required this.label,
    this.icon,
    this.tone,
  });

  /// The value reported to [EmsTileSelector.onChanged].
  final T value;

  /// Already-localized label.
  final String label;

  /// Icon shown above the label.
  final IconData? icon;

  /// Semantic colour of the tile (icon, selected fill and outline). Defaults
  /// to [EmsTone.primary].
  final EmsTone? tone;
}

/// Single-choice tile picker. Replaces `EmsGridSelector` and
/// `EmsSeveritySelector` (DS-19).
///
/// One look for every tile (DS-19, VISUAL_PROPOSAL §4.3):
/// - unselected: `surface`, 1 px `borderStrong`, `textSecondary` label;
/// - selected: the tone's container fill, a 2 px tone outline, on-container
///   text and a check icon, so selection is never shown by colour alone.
///
/// Tiles are at least [EmsSizes.tileMinHeight] tall and grow with the text
/// scale.
///
/// Example:
/// ```dart
/// EmsTileSelector<Avpu>(
///   items: [EmsTileItem(value: Avpu.alert, label: alertLabel, icon: Icons.visibility)],
///   selected: avpu,
///   onChanged: setAvpu,
/// )
/// ```
class EmsTileSelector<T> extends StatelessWidget {
  /// Creates a tile selector.
  const EmsTileSelector({
    super.key,
    required this.items,
    this.selected,
    this.onChanged,
    this.columns = 2,
  });

  /// The options.
  final List<EmsTileItem<T>> items;

  /// The selected value, if any.
  final T? selected;

  /// Called with the tapped value. `null` disables the tiles.
  final ValueChanged<T>? onChanged;

  /// Tiles per row.
  final int columns;

  /// The triage severity preset (values `life_threatening`, `urgent`,
  /// `non_urgent`) with danger / warning / success tones and icons. Labels
  /// are app strings, already localized.
  static EmsTileSelector<String> severity({
    Key? key,
    required String lifeThreateningLabel,
    required String urgentLabel,
    required String nonUrgentLabel,
    String? selected,
    ValueChanged<String>? onChanged,
  }) {
    return EmsTileSelector<String>(
      key: key,
      columns: 3,
      selected: selected,
      onChanged: onChanged,
      items: [
        EmsTileItem(
          value: 'life_threatening',
          label: lifeThreateningLabel,
          icon: Icons.priority_high_rounded,
          tone: EmsTone.danger,
        ),
        EmsTileItem(
          value: 'urgent',
          label: urgentLabel,
          icon: Icons.warning_amber_rounded,
          tone: EmsTone.warning,
        ),
        EmsTileItem(
          value: 'non_urgent',
          label: nonUrgentLabel,
          icon: Icons.check_circle_outline_rounded,
          tone: EmsTone.success,
        ),
      ],
    );
  }

  VoidCallback? _tap(T value) =>
      onChanged == null ? null : () => onChanged!(value);

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var start = 0; start < items.length; start += columns) {
      final rowItems = items.skip(start).take(columns).toList();
      rows.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < columns; i++) ...[
                if (i > 0) const SizedBox(width: EmsSpacing.md),
                Expanded(
                  child: i < rowItems.length
                      ? _EmsTile<T>(
                          item: rowItems[i],
                          selected: rowItems[i].value == selected,
                          onTap: _tap(rowItems[i].value),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ],
          ),
        ),
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < rows.length; i++) ...[
          if (i > 0) const SizedBox(height: EmsSpacing.md),
          rows[i],
        ],
      ],
    );
  }
}

class _EmsTile<T> extends StatelessWidget {
  const _EmsTile({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final EmsTileItem<T> item;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = EmsColors.of(context);
    final tone = item.tone ?? EmsTone.primary;
    final toneColor = c.tone(tone);
    final fill = c.toneContainer(tone);
    final onFill = c.onToneContainer(tone);

    final borderWidth = selected ? 2.0 : 1.0;
    final radius = BorderRadius.circular(EmsRadius.md);
    final iconColor = selected
        ? onFill
        : (item.tone != null ? toneColor : c.textSecondary);
    final labelColor = selected ? onFill : c.textSecondary;

    return AnimatedContainer(
      duration: EmsMotion.of(context).normal,
      constraints: const BoxConstraints(minHeight: EmsSizes.tileMinHeight),
      decoration: BoxDecoration(
        color: selected ? fill : c.surface,
        borderRadius: radius,
        border: Border.all(
          color: selected ? toneColor : c.borderStrong,
          width: borderWidth,
        ),
      ),
      child: EmsTappable(
        onTap: onTap,
        selected: selected,
        borderRadius: radius,
        child: Stack(
          children: [
            Padding(
              // Keeps the content still when the outline grows to 2 px.
              padding: EdgeInsets.all(EmsSpacing.md + 1 - borderWidth),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (item.icon != null) ...[
                      Icon(item.icon, size: EmsIconSize.lg, color: iconColor),
                      const SizedBox(height: EmsSpacing.sm),
                    ],
                    Text(
                      item.label,
                      textAlign: TextAlign.center,
                      style: EmsTypography.of(context).labelLarge.copyWith(
                        color: labelColor,
                        fontWeight: selected
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (selected)
              PositionedDirectional(
                top: EmsSpacing.xs,
                end: EmsSpacing.xs,
                child: ExcludeSemantics(
                  child: Icon(
                    Icons.check_circle,
                    size: EmsIconSize.sm,
                    color: toneColor,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
