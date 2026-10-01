// Golden comparator for the package's tests: exact locally, a small pixel
// tolerance on CI. Installed for every test file by
// `test/flutter_test_config.dart`.
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

/// Largest share of pixels, in percent, that may differ from a golden when
/// the tests run on CI.
///
/// The goldens are recorded on a developer Mac. The CI runner (GitHub Actions
/// `macos-26`) runs a different macOS version, and CoreText anti-aliases glyph
/// edges slightly differently there, even with the same Flutter (3.35.3) and
/// the same bundled fonts. The first CI run showed only scattered pixels along
/// glyph edges, at most 0.46% of an image. 1.0% absorbs that drift, while a
/// real visual change (a recoloured icon, a moved label, a 48×48 block on a
/// 420×320 golden ≈ 1.7%) still fails.
///
/// Locally the comparison stays exact (0%). Set `EMS_GOLDEN_TOLERANCE` (a
/// percent, e.g. `0.5`) to override the tolerance anywhere, for experiments.
const double kCiGoldenTolerancePercent = 1.0;

/// Environment variable that overrides the tolerance, in percent.
const String kGoldenToleranceEnvVar = 'EMS_GOLDEN_TOLERANCE';

/// Returns the golden tolerance, as a fraction of pixels (0.01 = 1%), for
/// the given environment:
/// - `EMS_GOLDEN_TOLERANCE` set: that percent (must be 0 ≤ p < 100);
/// - `CI=true` (set by GitHub Actions): [kCiGoldenTolerancePercent];
/// - otherwise: 0, an exact comparison.
double goldenToleranceFor(Map<String, String> environment) {
  final override = environment[kGoldenToleranceEnvVar];
  if (override != null && override.trim().isNotEmpty) {
    final percent = double.tryParse(override.trim());
    if (percent == null || percent.isNaN || percent < 0 || percent >= 100) {
      throw StateError(
        '$kGoldenToleranceEnvVar must be a percent in [0, 100), '
        'got "$override".',
      );
    }
    return percent / 100;
  }
  if (environment['CI'] == 'true') return kCiGoldenTolerancePercent / 100;
  return 0;
}

/// A [LocalFileComparator] that accepts a golden when at most [tolerance] of
/// its pixels differ.
///
/// Paths resolve exactly as with the comparator `flutter test` installs
/// (relative to the test file's directory). Failures still write the
/// `failures/` images. A pass within a non-zero tolerance is printed, so
/// rasterization drift stays visible in CI logs.
class EmsGoldenFileComparator extends LocalFileComparator {
  /// Creates a comparator for goldens next to [testFile].
  EmsGoldenFileComparator(super.testFile, {required this.tolerance})
    : assert(tolerance >= 0 && tolerance < 1);

  /// Replaces [base] (the comparator `flutter test` installs per test file),
  /// keeping its [LocalFileComparator.basedir].
  EmsGoldenFileComparator.wrap(
    LocalFileComparator base, {
    required double tolerance,
  }) : this(base.basedir.resolve('golden_test.dart'), tolerance: tolerance);

  /// Largest accepted share of differing pixels (0.01 = 1%).
  final double tolerance;

  /// Whether [result] is accepted under [tolerance]. Images of a different
  /// size, or that can't be decoded, report a 100% diff and always fail.
  bool accepts(ComparisonResult result) =>
      result.passed || result.diffPercent <= tolerance;

  @override
  Future<bool> compare(Uint8List imageBytes, Uri golden) async {
    final result = await GoldenFileComparator.compareLists(
      imageBytes,
      await getGoldenBytes(golden),
    );
    try {
      if (accepts(result)) {
        if (!result.passed) {
          debugPrint(
            'Golden "$golden" matched within tolerance: '
            '${_percent(result.diffPercent)} of pixels differ '
            '(limit ${_percent(tolerance)}).',
          );
        }
        return true;
      }
      final error = await generateFailureOutput(result, golden, basedir);
      throw FlutterError(
        tolerance == 0
            ? error
            : '$error\nGolden tolerance: ${_percent(tolerance)}.',
      );
    } finally {
      result.dispose();
    }
  }

  static String _percent(double fraction) =>
      '${(fraction * 100).toStringAsFixed(2)}%';
}

/// Installs [EmsGoldenFileComparator] in place of the per-file
/// [LocalFileComparator], with the tolerance for the current environment.
void installEmsGoldenComparator() {
  final current = goldenFileComparator;
  if (current is! LocalFileComparator) return;
  goldenFileComparator = EmsGoldenFileComparator.wrap(
    current,
    tolerance: goldenToleranceFor(Platform.environment),
  );
}
