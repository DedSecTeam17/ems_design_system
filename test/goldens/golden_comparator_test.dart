// Tests the golden comparator itself (test/helpers/ems_golden_comparator.dart)
// with synthetic in-memory images; no real golden file is read.
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/ems_golden_comparator.dart';

const _width = 420;
const _height = 320;
const _ciTolerance = kCiGoldenTolerancePercent / 100;

/// Renders a 420×320 PNG: a light background with a dark "glyph" bar, plus
/// optional single-pixel [noise] and an optional 48×48 [block].
Future<Uint8List> _png({
  Iterable<(int, int)> noise = const [],
  ui.Rect? block,
}) async {
  final recorder = ui.PictureRecorder();
  final canvas = ui.Canvas(recorder);
  ui.Paint paint(int argb) => ui.Paint()
    ..color = ui.Color(argb)
    ..isAntiAlias = false;

  canvas
    ..drawRect(
      ui.Rect.fromLTWH(0, 0, _width.toDouble(), _height.toDouble()),
      paint(0xFFF5F7FA),
    )
    ..drawRect(const ui.Rect.fromLTWH(40, 100, 300, 24), paint(0xFF1B2533));
  for (final (x, y) in noise) {
    canvas.drawRect(
      ui.Rect.fromLTWH(x.toDouble(), y.toDouble(), 1, 1),
      paint(0xFF8A939E),
    );
  }
  if (block != null) canvas.drawRect(block, paint(0xFFD32F2F));

  final picture = recorder.endRecording();
  final image = await picture.toImage(_width, _height);
  final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
  image.dispose();
  picture.dispose();
  return bytes!.buffer.asUint8List();
}

/// 200 pixels along the bar's top and bottom edges (≈ 0.15%), the shape of
/// the CoreText anti-aliasing drift seen on CI.
final _edgeNoise = [
  for (var x = 40; x < 340; x += 3) (x, 99),
  for (var x = 41; x < 341; x += 3) (x, 124),
].take(200);

/// A 48×48 colour block (2304 px ≈ 1.71%): a real visual change.
const _block = ui.Rect.fromLTWH(200, 200, 48, 48);

Future<ComparisonResult> _diff(Uint8List test, Uint8List master) =>
    GoldenFileComparator.compareLists(test, master);

void main() {
  late Uint8List master;
  late Uint8List noisy;
  late Uint8List changed;

  setUpAll(() async {
    master = await _png();
    noisy = await _png(noise: _edgeNoise);
    changed = await _png(block: _block);
  });

  EmsGoldenFileComparator comparator(double tolerance, [Directory? dir]) =>
      EmsGoldenFileComparator(
        (dir ?? Directory.systemTemp).uri.resolve('golden_test.dart'),
        tolerance: tolerance,
      );

  group('accepts', () {
    test('passes identical images at any tolerance', () async {
      final result = await _diff(master, master);
      addTearDown(result.dispose);
      expect(result.passed, isTrue);
      expect(comparator(0).accepts(result), isTrue);
    });

    test('passes edge noise under the CI tolerance', () async {
      final result = await _diff(noisy, master);
      addTearDown(result.dispose);
      expect(result.passed, isFalse);
      expect(result.diffPercent, closeTo(200 / (_width * _height), 1e-9));
      expect(comparator(_ciTolerance).accepts(result), isTrue);
    });

    test('fails edge noise when exact (0%)', () async {
      final result = await _diff(noisy, master);
      addTearDown(result.dispose);
      expect(comparator(0).accepts(result), isFalse);
    });

    test('fails a 48×48 block change even under the CI tolerance', () async {
      final result = await _diff(changed, master);
      addTearDown(result.dispose);
      expect(result.diffPercent, closeTo(48 * 48 / (_width * _height), 1e-9));
      expect(result.diffPercent, greaterThan(_ciTolerance));
      expect(comparator(_ciTolerance).accepts(result), isFalse);
    });

    test('fails images of a different size under the CI tolerance', () async {
      final recorder = ui.PictureRecorder();
      ui.Canvas(
        recorder,
      ).drawColor(const ui.Color(0xFFF5F7FA), ui.BlendMode.src);
      final picture = recorder.endRecording();
      final image = await picture.toImage(_width, _height + 1);
      final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      image.dispose();
      picture.dispose();

      final result = await _diff(bytes!.buffer.asUint8List(), master);
      addTearDown(result.dispose);
      expect(comparator(_ciTolerance).accepts(result), isFalse);
    });
  });

  group('compare', () {
    late Directory dir;
    final golden = Uri.parse('images/sample.png');

    setUp(() async {
      dir = await Directory.systemTemp.createTemp('ems_golden_comparator');
      await File.fromUri(
        dir.uri.resolve('images/sample.png'),
      ).create(recursive: true).then((f) => f.writeAsBytes(master));
    });

    tearDown(() => dir.delete(recursive: true));

    test('resolves goldens next to the test file, like the base', () {
      final base = LocalFileComparator(dir.uri.resolve('some_test.dart'));
      final wrapped = EmsGoldenFileComparator.wrap(base, tolerance: 0);
      expect(wrapped.basedir, base.basedir);
    });

    test(
      'passes edge noise under the CI tolerance and logs the diff',
      () async {
        final logs = <String>[];
        final previous = debugPrint;
        debugPrint = (message, {wrapWidth}) => logs.add(message ?? '');
        addTearDown(() => debugPrint = previous);

        expect(
          await comparator(_ciTolerance, dir).compare(noisy, golden),
          isTrue,
        );
        expect(logs.single, contains('0.15% of pixels differ (limit 1.00%)'));
      },
    );

    test('throws and writes failure images when exact (0%)', () async {
      await expectLater(
        comparator(0, dir).compare(noisy, golden),
        throwsA(isA<FlutterError>()),
      );
      final failures = Directory.fromUri(dir.uri.resolve('failures/'));
      expect(failures.listSync(), isNotEmpty);
    });

    test('throws on a real change under the CI tolerance', () async {
      await expectLater(
        comparator(_ciTolerance, dir).compare(changed, golden),
        throwsA(
          isA<FlutterError>().having(
            (e) => e.message,
            'message',
            contains('Golden tolerance: 1.00%'),
          ),
        ),
      );
    });
  });

  group('goldenToleranceFor', () {
    test('is exact (0) when CI is not set', () {
      expect(goldenToleranceFor({}), 0);
      expect(goldenToleranceFor({'CI': 'false'}), 0);
    });

    test('is the CI tolerance when CI=true', () {
      expect(goldenToleranceFor({'CI': 'true'}), _ciTolerance);
    });

    test('uses EMS_GOLDEN_TOLERANCE (a percent) when set', () {
      expect(
        goldenToleranceFor({'CI': 'true', kGoldenToleranceEnvVar: '0.5'}),
        0.005,
      );
      expect(goldenToleranceFor({kGoldenToleranceEnvVar: '2'}), 0.02);
    });

    test('rejects an invalid EMS_GOLDEN_TOLERANCE', () {
      for (final value in ['abc', '-1', '100']) {
        expect(
          () => goldenToleranceFor({kGoldenToleranceEnvVar: value}),
          throwsStateError,
          reason: value,
        );
      }
    });
  });
}
