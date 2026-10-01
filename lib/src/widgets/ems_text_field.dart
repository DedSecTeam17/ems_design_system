import 'package:flutter/material.dart';
import '../tokens/tokens.dart';
import '../theme/ems_input_decoration.dart';
import '../l10n/ems_localizations.dart';

/// Labelled text input (e.g. Email*, Password*).
///
/// Example:
/// ```dart
/// EmsTextField(
///   label: passwordLabel,
///   required: true,
///   obscureText: true,
///   textInputAction: TextInputAction.done,
///   autofillHints: const [AutofillHints.password],
/// )
/// ```
class EmsTextField extends StatefulWidget {
  /// Already-localized label.
  final String label;

  /// Already-localized placeholder.
  final String? hintText;

  /// Shows the required marker (announced as "Required").
  final bool required;

  /// Hides the text and shows a show/hide toggle (passwords).
  final bool obscureText;

  /// Controls the text.
  final TextEditingController? controller;

  /// Form validator; its message shows under the field.
  final String? Function(String?)? validator;

  /// Keyboard type.
  final TextInputType keyboardType;

  /// Leading icon inside the field.
  final Widget? prefixIcon;

  /// Called on every edit.
  final ValueChanged<String>? onChanged;

  /// When [validator] runs.
  final AutovalidateMode autovalidateMode;

  /// `false` greys the field out and ignores input.
  final bool enabled;

  /// Already-localized error shown under the field (in addition to
  /// [validator]).
  final String? errorText;

  /// Already-localized help text shown under the field.
  final String? helperText;

  /// Focus node of the field.
  final FocusNode? focusNode;

  /// Keyboard action button (next, done).
  final TextInputAction? textInputAction;

  /// Autofill hints (e.g. [AutofillHints.password]).
  final Iterable<String>? autofillHints;

  /// Creates a text field.
  const EmsTextField({
    super.key,
    required this.label,
    this.hintText,
    this.required = false,
    this.obscureText = false,
    this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.onChanged,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.enabled = true,
    this.errorText,
    this.helperText,
    this.focusNode,
    this.textInputAction,
    this.autofillHints,
  });

  @override
  State<EmsTextField> createState() => _EmsTextFieldState();
}

class _EmsTextFieldState extends State<EmsTextField> {
  bool _obscured = true;

  @override
  Widget build(BuildContext context) {
    final c = EmsColors.of(context);
    final l10n = EmsLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label row. Text.rich (not RichText) so the label follows the text
        // scale and the theme font (DS-09).
        Text.rich(
          TextSpan(
            text: widget.label,
            style: EmsTypography.of(
              context,
            ).labelLarge.copyWith(color: c.textPrimary),
            children: widget.required
                ? [
                    TextSpan(
                      text: ' *',
                      semanticsLabel: ', ${l10n.required}',
                      style: EmsTypography.of(
                        context,
                      ).labelLarge.copyWith(color: c.danger),
                    ),
                  ]
                : null,
          ),
        ),
        const SizedBox(height: EmsSpacing.sm),
        // Input
        TextFormField(
          controller: widget.controller,
          obscureText: widget.obscureText ? _obscured : false,
          enabled: widget.enabled,
          focusNode: widget.focusNode,
          textInputAction: widget.textInputAction,
          autofillHints: widget.autofillHints,
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          onChanged: widget.onChanged,
          autovalidateMode: widget.autovalidateMode,
          style: EmsTypography.of(
            context,
          ).bodyMedium.copyWith(color: c.textPrimary),
          decoration: EmsInputDecoration.of(
            context,
            hintText: widget.hintText,
            errorText: widget.errorText,
            helperText: widget.helperText,
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.obscureText
                ? IconButton(
                    tooltip: _obscured ? l10n.showPassword : l10n.hidePassword,
                    icon: Icon(
                      _obscured
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: c.textSecondary,
                      size: EmsIconSize.md,
                    ),
                    onPressed: () => setState(() => _obscured = !_obscured),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
