import 'package:flutter/widgets.dart';

/// Animation durations. Read them through [of] in widgets so they collapse to
/// [Duration.zero] when the platform asks for reduced motion
/// (`MediaQuery.disableAnimations`).
///
/// Example: `AnimatedContainer(duration: EmsMotion.of(context).normal)`
@immutable
class EmsMotion {
  const EmsMotion._(this._enabled);

  final bool _enabled;

  /// Default motion (animations enabled).
  static const EmsMotion standard = EmsMotion._(true);

  /// Reduced motion: every duration is zero.
  static const EmsMotion reduced = EmsMotion._(false);

  /// State changes (selection, borders): 200 ms.
  static const Duration normalDuration = Duration(milliseconds: 200);

  /// Expand / collapse: 250 ms.
  static const Duration expandDuration = Duration(milliseconds: 250);

  /// One shimmer sweep: 1,300 ms.
  static const Duration shimmerDuration = Duration(milliseconds: 1300);

  /// The motion settings for [context].
  static EmsMotion of(BuildContext context) =>
      (MediaQuery.maybeDisableAnimationsOf(context) ?? false)
      ? reduced
      : standard;

  /// Whether animations should run.
  bool get enabled => _enabled;

  Duration _d(Duration d) => _enabled ? d : Duration.zero;

  /// State changes (selection, borders).
  Duration get normal => _d(normalDuration);

  /// Expand / collapse.
  Duration get expand => _d(expandDuration);

  /// Shimmer sweep.
  Duration get shimmer => _d(shimmerDuration);
}
