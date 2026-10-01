import 'package:flutter/material.dart';
import '../tokens/tokens.dart';
import '../l10n/ems_localizations.dart';

/// Blocks [child] with a scrim and a spinner while [isLoading], and announces
/// "Loading" (DS-31).
///
/// Example: `EmsLoadingOverlay(isLoading: vm.busy, child: form)`
class EmsLoadingOverlay extends StatelessWidget {
  /// The content under the overlay.
  final Widget child;

  /// Shows the scrim and spinner and blocks input to [child].
  final bool isLoading;

  /// Scrim colour. Defaults to `scrim` at 40 %.
  final Color? overlayColor;

  /// Replaces the default spinner.
  final Widget? indicator;

  /// Creates a loading overlay.
  const EmsLoadingOverlay({
    super.key,
    required this.child,
    required this.isLoading,
    this.overlayColor,
    this.indicator,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Hidden from screen readers while it can't be used (DS-31). The
        // wrapper is always present so the child keeps its state.
        ExcludeSemantics(excluding: isLoading, child: child),
        if (isLoading)
          Positioned.fill(
            child: Semantics(
              liveRegion: true,
              label: EmsLocalizations.of(context).loading,
              child: ColoredBox(
                color:
                    overlayColor ??
                    EmsColors.of(context).scrim.withValues(alpha: 0.4),
                child: Center(
                  child: indicator ?? const CircularProgressIndicator(),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
