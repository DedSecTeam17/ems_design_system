import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../tokens/tokens.dart';
import 'ems_tappable.dart';
import 'ems_shimmer_box.dart';
import '../l10n/ems_localizations.dart';

/// How many options an [EmsSelectionCard] accepts.
enum EmsSelectionMode {
  /// One option (radio buttons); picking another replaces it.
  single,

  /// Any number of options (checkboxes).
  multiple,
}

/// One option of an [EmsSelectionCard].
class EmsSelectionOption {
  /// The value reported in [EmsSelectionCard.onSelectionChanged].
  final String value;

  /// Already-localized label.
  final String label;

  /// Creates an option.
  const EmsSelectionOption({required this.value, required this.label});
}

/// Expandable card that picks one or more options from a list (Team Setup:
/// crew, ambulance, equipment). The header shows the [icon] in its [accent],
/// the [label] and the selected count; the list shows checkboxes or radios,
/// and a shimmer while [isLoading].
///
/// Example:
/// ```dart
/// EmsSelectionCard(
///   label: crewLabel,
///   icon: Icons.groups_outlined,
///   accent: EmsAccent.crew,
///   options: crew,
///   selectedValues: selected,
///   onSelectionChanged: setCrew,
/// )
/// ```
class EmsSelectionCard extends StatefulWidget {
  /// Already-localized header label.
  final String label;

  /// Header icon.
  final IconData icon;

  /// Category colour of the icon, border and count.
  final EmsAccent? accent;

  /// The options.
  final List<EmsSelectionOption> options;

  /// Values of the selected options.
  final List<String> selectedValues;

  /// Called with the new selection.
  final ValueChanged<List<String>>? onSelectionChanged;

  /// One or many. Defaults to [EmsSelectionMode.multiple].
  final EmsSelectionMode selectionMode;

  /// Shows a shimmer instead of the options.
  final bool isLoading;

  /// Height cap of the option list; it scrolls beyond that.
  final double maxDropdownHeight;

  /// Creates a selection card.
  const EmsSelectionCard({
    super.key,
    required this.label,
    required this.icon,
    this.accent,
    this.options = const [],
    this.selectedValues = const [],
    this.onSelectionChanged,
    this.selectionMode = EmsSelectionMode.multiple,
    this.isLoading = false,
    this.maxDropdownHeight = 260,
  });

  /// Whether any option is selected.
  bool get hasSelection => selectedValues.isNotEmpty;

  @override
  State<EmsSelectionCard> createState() => _EmsSelectionCardState();
}

class _EmsSelectionCardState extends State<EmsSelectionCard>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late final AnimationController _animController;
  late final Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: EmsMotion.expandDuration,
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _animController.duration = EmsMotion.of(context).expand;
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _toggle() {
    if (widget.isLoading || widget.options.isEmpty) return;
    setState(() {
      _expanded = !_expanded;
      if (_expanded) {
        _animController.forward();
      } else {
        _animController.reverse();
      }
    });
  }

  void _onItemToggled(String value) {
    final current = List<String>.from(widget.selectedValues);
    if (widget.selectionMode == EmsSelectionMode.single) {
      if (current.contains(value)) {
        current.clear();
      } else {
        current
          ..clear()
          ..add(value);
      }
      widget.onSelectionChanged?.call(current);
      return;
    }

    if (current.contains(value)) {
      current.remove(value);
    } else {
      current.add(value);
    }
    widget.onSelectionChanged?.call(current);
  }

  double _resolvedDropdownHeight(BuildContext context) {
    // A row is its label line plus padding, at least 48 dp (DS-08), plus the
    // 1 dp divider. Measured from the real style so the list neither scrolls
    // early nor leaves an empty band at the bottom.
    final style = EmsTypography.of(context).bodyMedium;
    final line =
        MediaQuery.textScalerOf(context).scale(style.fontSize!) *
        (style.height ?? 1.2);
    final estimatedItemHeight =
        math.max(EmsSizes.minTap, line + 2 * EmsSpacing.sm) + 1;
    final contentHeight = widget.options.length * estimatedItemHeight;
    return contentHeight < widget.maxDropdownHeight
        ? contentHeight
        : widget.maxDropdownHeight;
  }

  Color _iconColor(EmsColors c) {
    // The default accent is the violet category colour, themed (D11).
    return c.accent(widget.accent ?? EmsAccent.vehicle);
  }

  @override
  Widget build(BuildContext context) {
    final c = EmsColors.of(context);
    final iconColor = _iconColor(c);
    final isActive = widget.hasSelection;
    final borderColor = isActive ? iconColor : c.borderSubtle;

    final motion = EmsMotion.of(context);
    final canExpand = !widget.isLoading && widget.options.isNotEmpty;
    const radius = Radius.circular(EmsRadius.md);

    return AnimatedContainer(
      duration: motion.normal,
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: const BorderRadius.all(radius),
        border: Border.all(color: borderColor, width: isActive ? 2 : 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          EmsTappable(
            onTap: canExpand ? _toggle : null,
            isButton: canExpand,
            expanded: canExpand ? _expanded : null,
            borderRadius: _expanded
                ? const BorderRadius.vertical(top: radius)
                : const BorderRadius.all(radius),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: EmsSpacing.lg,
                vertical: EmsSpacing.lg,
              ),
              child: Row(
                children: [
                  Container(
                    width: EmsSizes.iconBadge,
                    height: EmsSizes.iconBadge,
                    decoration: BoxDecoration(
                      color: iconColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(EmsRadius.sm),
                    ),
                    child: Icon(
                      widget.icon,
                      color: iconColor,
                      size: EmsIconSize.md,
                    ),
                  ),
                  const SizedBox(width: EmsSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.label,
                          style: EmsTypography.of(context).bodyMedium.copyWith(
                            fontWeight: FontWeight.w500,
                            color: c.textPrimary,
                          ),
                        ),
                        if (isActive)
                          Text(
                            EmsLocalizations.of(
                              context,
                            ).selectedCount(widget.selectedValues.length),
                            style: EmsTypography.of(
                              context,
                            ).caption.copyWith(color: iconColor),
                          ),
                      ],
                    ),
                  ),
                  if (!widget.isLoading && widget.options.isNotEmpty)
                    AnimatedRotation(
                      turns: _expanded ? 0.5 : 0,
                      duration: motion.expand,
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: isActive ? iconColor : c.textSecondary,
                        size: EmsIconSize.md,
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (widget.isLoading) _buildLoadingContent(c),
          if (!widget.isLoading)
            SizeTransition(
              sizeFactor: _expandAnimation,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Divider(height: 1, color: c.borderSubtle),
                  SizedBox(
                    height: _resolvedDropdownHeight(context),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      primary: false,
                      itemCount: widget.options.length,
                      itemBuilder: (context, index) {
                        final option = widget.options[index];
                        final isChecked = widget.selectedValues.contains(
                          option.value,
                        );
                        return Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: c.borderSubtle,
                                width: 1,
                              ),
                            ),
                          ),
                          child: EmsTappable(
                            onTap: () => _onItemToggled(option.value),
                            selected:
                                widget.selectionMode == EmsSelectionMode.single
                                ? isChecked
                                : null,
                            child: Container(
                              // 48 dp option rows (DS-08).
                              constraints: const BoxConstraints(
                                minHeight: EmsSizes.minTap,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: EmsSpacing.lg,
                                vertical: EmsSpacing.sm,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      option.label,
                                      style: EmsTypography.of(context)
                                          .bodyMedium
                                          .copyWith(
                                            color: isChecked
                                                ? c.textPrimary
                                                : c.textSecondary,
                                            fontWeight: isChecked
                                                ? FontWeight.w500
                                                : FontWeight.w400,
                                          ),
                                    ),
                                  ),
                                  if (widget.selectionMode ==
                                      EmsSelectionMode.multiple)
                                    SizedBox.square(
                                      dimension: EmsIconSize.md,
                                      child: Checkbox(
                                        value: isChecked,
                                        onChanged: (_) =>
                                            _onItemToggled(option.value),
                                      ),
                                    )
                                  else
                                    Icon(
                                      isChecked
                                          ? Icons.radio_button_checked
                                          : Icons.radio_button_off,
                                      color: isChecked
                                          ? iconColor
                                          : c.borderStrong,
                                      size: EmsIconSize.md,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLoadingContent(EmsColors c) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(
        EmsSpacing.lg,
        0,
        EmsSpacing.lg,
        EmsSpacing.lg,
      ),
      child: Column(
        children: [
          Divider(height: 1),
          SizedBox(height: EmsSpacing.md),
          EmsShimmerBox(height: EmsSpacing.lg),
          SizedBox(height: EmsSpacing.sm),
          EmsShimmerBox(height: EmsSpacing.lg),
          SizedBox(height: EmsSpacing.sm),
          EmsShimmerBox(height: EmsSpacing.lg),
        ],
      ),
    );
  }
}
