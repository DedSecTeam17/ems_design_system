import 'package:flutter/material.dart';

import '../tokens/tokens.dart';
import '../l10n/ems_localizations.dart';

/// Visual role of an [EmsButton].
enum EmsButtonVariant {
  /// Filled brand button: the main action of a screen.
  primary,

  /// Outlined button: Cancel, Back, secondary actions.
  secondary,

  /// Text-only button: inline or low-emphasis actions.
  tertiary,

  /// Filled success button: Ready, Confirm, Finish.
  success,

  /// Filled danger button: Sign out, Cancel case.
  danger,
}

/// Height and padding of an [EmsButton] (decision D6).
enum EmsButtonSize {
  /// 48 dp high, 20 dp side padding, 20 dp icon (wizard navigation, dense
  /// rows).
  regular,

  /// 56 dp high, 24 dp side padding, 24 dp icon: primary screen actions.
  large,
}

/// The design-system button. Replaces `EmsPrimaryButton`,
/// `EmsOutlinedButton` and the free `backgroundColor` override (DS-20).
///
/// Example:
/// ```dart
/// EmsButton(
///   label: confirmLabel,
///   variant: EmsButtonVariant.success,
///   icon: Icons.check,
///   loading: isSaving,
///   onPressed: onConfirm,
/// )
/// ```
class EmsButton extends StatelessWidget {
  /// Creates a button.
  const EmsButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = EmsButtonVariant.primary,
    this.icon,
    this.loading = false,
    this.width,
    this.size = EmsButtonSize.large,
    this.fullWidth = true,
    this.trailingIcon,
  });

  /// Already-localized label.
  final String label;

  /// Called on tap. `null` disables the button.
  final VoidCallback? onPressed;

  /// The visual role.
  final EmsButtonVariant variant;

  /// Optional leading icon (directional icons mirror in RTL).
  final IconData? icon;

  /// Shows a spinner, ignores taps and announces "Loading, [label]".
  final bool loading;

  /// Fixed width. Overrides [fullWidth].
  final double? width;

  /// Height, padding and icon size.
  final EmsButtonSize size;

  /// Fills the available width (default). `false` sizes the button to its
  /// label, for use in a [Row].
  final bool fullWidth;

  /// Optional trailing icon, e.g. a forward arrow on "Next" (mirrors in RTL).
  final IconData? trailingIcon;

  /// (fill, on-colour) of the variant. Fill is null for unfilled variants.
  (Color?, Color) _colors(EmsColors c) => switch (variant) {
    EmsButtonVariant.primary => (c.primary, c.onPrimary),
    EmsButtonVariant.success => (c.success, c.onSuccess),
    EmsButtonVariant.danger => (c.danger, c.onDanger),
    EmsButtonVariant.secondary => (null, c.textPrimary),
    EmsButtonVariant.tertiary => (null, c.primary),
  };

  @override
  Widget build(BuildContext context) {
    final c = EmsColors.of(context);
    final callback = loading ? null : onPressed;
    final (fill, onFill) = _colors(c);

    final large = size == EmsButtonSize.large;
    final iconSize = large ? EmsIconSize.md : EmsIconSize.sm;
    final label = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: iconSize),
          const SizedBox(width: EmsSpacing.sm),
        ],
        Flexible(child: Text(this.label, overflow: TextOverflow.ellipsis)),
        if (trailingIcon != null) ...[
          const SizedBox(width: EmsSpacing.sm),
          Icon(trailingIcon, size: iconSize),
        ],
      ],
    );

    // Loading keeps the label in the layout (invisible) so the button keeps
    // its width, shows a spinner in the on-colour and announces
    // "Loading, <label>" (DS-23).
    final Widget content = loading
        ? Semantics(
            label: '${EmsLocalizations.of(context).loading}, ${this.label}',
            excludeSemantics: true,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Visibility(
                  visible: false,
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  child: label,
                ),
                SizedBox.square(
                  dimension: iconSize,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(onFill),
                  ),
                ),
              ],
            ),
          )
        : label;

    // Size: large uses the theme (56 dp, full width); regular and
    // label-width buttons override the minimum size and padding.
    final sizeStyle = ButtonStyle(
      minimumSize: WidgetStatePropertyAll(
        Size(
          fullWidth || width != null ? double.infinity : EmsSizes.minTap,
          large ? EmsSizes.buttonHeight : EmsSizes.buttonHeightRegular,
        ),
      ),
      padding: WidgetStatePropertyAll(
        EdgeInsets.symmetric(
          horizontal: large ? EmsSpacing.xxl : EmsSpacing.xl,
        ),
      ),
    );

    // While loading, the (technically disabled) button keeps its variant
    // colours instead of the disabled look.
    ButtonStyle? style;
    if (fill != null) {
      style = ElevatedButton.styleFrom(
        backgroundColor: fill,
        foregroundColor: onFill,
        disabledBackgroundColor: loading ? fill : null,
        disabledForegroundColor: loading ? onFill : null,
      );
      if (loading) {
        style = style.copyWith(
          side: const WidgetStatePropertyAll(BorderSide.none),
        );
      }
    } else if (loading) {
      style = variant == EmsButtonVariant.secondary
          ? OutlinedButton.styleFrom(
              disabledForegroundColor: onFill,
              side: BorderSide(color: c.borderStrong),
            )
          : TextButton.styleFrom(disabledForegroundColor: onFill);
    }

    style = style == null ? sizeStyle : sizeStyle.merge(style);

    final Widget button = switch (variant) {
      EmsButtonVariant.primary ||
      EmsButtonVariant.success ||
      EmsButtonVariant.danger => ElevatedButton(
        onPressed: callback,
        style: style,
        child: content,
      ),
      EmsButtonVariant.secondary => OutlinedButton(
        onPressed: callback,
        style: style,
        child: content,
      ),
      EmsButtonVariant.tertiary => TextButton(
        onPressed: callback,
        style: style,
        child: content,
      ),
    };

    return SizedBox(width: width, child: button);
  }
}
