import 'package:flutter/material.dart';
import '../tokens/tokens.dart';

/// Simple data table with header row and data rows.
/// Used for medications list, etc.
class EmsDataTable extends StatelessWidget {
  /// Already-localized column headers.
  final List<String> columns;

  /// Cell values, one list per row, in [columns] order.
  final List<List<String>> rows;

  /// Creates a table.
  const EmsDataTable({super.key, required this.columns, required this.rows});

  @override
  Widget build(BuildContext context) {
    final c = EmsColors.of(context);
    return Column(
      children: [
        // Header row
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: EmsSpacing.lg,
            vertical: EmsSpacing.md,
          ),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: c.borderStrong, width: 1)),
          ),
          child: Row(
            children: columns.map((col) {
              return Expanded(
                child: Text(
                  col.toUpperCase(),
                  style: EmsTypography.of(context).labelMedium.copyWith(
                    color: c.textSecondary,
                    letterSpacing: EmsTypography.letterSpacing(context, 0.5),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        // Data rows
        ...List.generate(rows.length, (rowIndex) {
          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: EmsSpacing.lg,
              vertical: EmsSpacing.lg,
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: c.borderSubtle, width: 1),
              ),
            ),
            child: Row(
              children: List.generate(rows[rowIndex].length, (colIndex) {
                return Expanded(
                  child: Text(
                    rows[rowIndex][colIndex],
                    style: EmsTypography.of(
                      context,
                    ).bodyMedium.copyWith(color: c.textPrimary),
                  ),
                );
              }),
            ),
          );
        }),
      ],
    );
  }
}
