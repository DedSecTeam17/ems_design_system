import 'package:flutter/material.dart';
import '../tokens/tokens.dart';
import '../theme/ems_input_decoration.dart';
import '../l10n/ems_localizations.dart';

/// Pill search input with a magnifying-glass icon. It uses the shared input
/// states (1 px `borderStrong`, 2 px `primary` when focused), so it has a
/// visible focus indicator.
///
/// Example: `EmsSearchBar(hintText: searchLabel, onChanged: filter)`
class EmsSearchBar extends StatelessWidget {
  /// Already-localized hint. Defaults to [EmsLocalizations.search].
  final String? hintText;

  /// Controls the query text.
  final TextEditingController? controller;

  /// Called on every edit.
  final ValueChanged<String>? onChanged;

  /// Creates a search bar.
  const EmsSearchBar({
    super.key,
    this.hintText,
    this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final c = EmsColors.of(context);
    OutlineInputBorder pill(Color color, double width) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(EmsRadius.full),
      borderSide: BorderSide(color: color, width: width),
    );
    return SizedBox(
      height: EmsSizes.searchBarHeight,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: EmsTypography.of(
          context,
        ).bodyMedium.copyWith(color: c.textPrimary),
        textAlignVertical: TextAlignVertical.center,
        decoration:
            EmsInputDecoration.of(
              context,
              hintText: hintText ?? EmsLocalizations.of(context).search,
              prefixIcon: Icon(
                Icons.search,
                color: c.textSecondary,
                size: EmsIconSize.md,
              ),
              contentPadding: EdgeInsets.zero,
            ).copyWith(
              border: pill(c.borderStrong, 1),
              enabledBorder: pill(c.borderStrong, 1),
              focusedBorder: pill(c.primary, 2),
            ),
      ),
    );
  }
}
