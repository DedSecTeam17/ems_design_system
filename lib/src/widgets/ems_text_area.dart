import 'package:flutter/material.dart';
import '../tokens/tokens.dart';
import '../theme/ems_input_decoration.dart';

/// Multiline text area with an optional label (notes, chief complaint, status
/// during transport). The label is always `textPrimary`, like every input
/// label (decision D3).
///
/// Example: `EmsTextArea(label: notesLabel, hintText: hint, maxLines: 4)`
class EmsTextArea extends StatelessWidget {
  /// Already-localized label.
  final String? label;

  /// Already-localized placeholder.
  final String? hintText;

  /// Controls the text.
  final TextEditingController? controller;

  /// Visible lines. Defaults to 4.
  final int maxLines;

  /// Shows the text without allowing edits.
  final bool readOnly;

  /// Called on every edit.
  final ValueChanged<String>? onChanged;

  /// `false` greys the field out and ignores input.
  final bool enabled;

  /// Already-localized error shown under the field.
  final String? errorText;

  /// Focus node of the field.
  final FocusNode? focusNode;

  /// Creates a text area.
  const EmsTextArea({
    super.key,
    this.label,
    this.hintText,
    this.controller,
    this.maxLines = 4,
    this.readOnly = false,
    this.onChanged,
    this.enabled = true,
    this.errorText,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final c = EmsColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: EmsTypography.of(
              context,
            ).labelLarge.copyWith(color: c.textPrimary),
          ),
          const SizedBox(height: EmsSpacing.sm),
        ],
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          readOnly: readOnly,
          onChanged: onChanged,
          enabled: enabled,
          focusNode: focusNode,
          style: EmsTypography.of(
            context,
          ).bodyMedium.copyWith(color: c.textPrimary),
          decoration: EmsInputDecoration.of(
            context,
            hintText: hintText,
            errorText: errorText,
            contentPadding: const EdgeInsets.all(EmsSpacing.lg),
          ),
        ),
      ],
    );
  }
}
