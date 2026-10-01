import 'package:flutter/material.dart';

import '../tokens/tokens.dart';

/// The one [InputDecoration] shared by every design-system input
/// (DS-22). Borders, fill and error/helper styles come from the theme's
/// `inputDecorationTheme`; this adds the placeholder style and the
/// per-field slots.
///
/// States: default 1 px `borderStrong` on `surface`; focused 2 px `primary`;
/// error 2 px `danger` with the message announced through
/// [InputDecoration.errorText]; disabled 1 px `borderSubtle` on
/// `surfaceSunken`.
///
/// Example:
/// ```dart
/// TextFormField(decoration: EmsInputDecoration.of(context, hintText: hint))
/// ```
abstract final class EmsInputDecoration {
  /// A decoration for an input in [context].
  static InputDecoration of(
    BuildContext context, {
    String? hintText,
    String? errorText,
    String? helperText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    TextStyle? hintStyle,
    EdgeInsetsGeometry? contentPadding,
    bool isDense = false,
  }) {
    final c = EmsColors.of(context);
    return InputDecoration(
      hintText: hintText,
      errorText: errorText,
      helperText: helperText,
      errorMaxLines: 3,
      helperMaxLines: 3,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      isDense: isDense,
      contentPadding: contentPadding,
      hintStyle: (hintStyle ?? EmsTypography.of(context).bodyMedium).copyWith(
        color: c.textHint,
      ),
    );
  }
}
