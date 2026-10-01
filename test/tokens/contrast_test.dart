// WCAG 2.1 contrast of every token pair the design system uses, in both
// themes. No pair is skipped: the palette refresh (step 2.8, decisions D1–D4)
// makes all of them pass.
//
// - P01–P37: the contrast proof of VISUAL_PROPOSAL §1.4.
// - Cxx: the component pairs of AUDIT §4.1, re-pointed to the tokens the
//   components use since step 2.8 (for example the Done badge is now
//   textSecondary on surfaceSunken, the severity tiles use status tokens).
// - Material roles from EmsTheme.colorScheme (snackbars, tooltips).
//
// Exempt and not tested: textDisabled (disabled only, always paired with a
// non-colour cue), borderSubtle (decorative), skeleton tokens, the card edge
// against the page, and the logo asset (D13). Known rule: never put textHint
// on surfaceSunken (4.39:1 in light); disabled fields use textDisabled.
import 'dart:math' as math;

import 'package:ems_design_system/ems_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

double _channel(double c) =>
    c <= 0.04045 ? c / 12.92 : math.pow((c + 0.055) / 1.055, 2.4).toDouble();

double _luminance(Color c) =>
    0.2126 * _channel(c.r) + 0.7152 * _channel(c.g) + 0.0722 * _channel(c.b);

/// WCAG 2.1 contrast ratio between two opaque colours.
double contrastRatio(Color a, Color b) {
  final la = _luminance(a);
  final lb = _luminance(b);
  return (math.max(la, lb) + 0.05) / (math.min(la, lb) + 0.05);
}

/// [fg] at [alpha] composited over [bg].
Color over(Color fg, double alpha, Color bg) =>
    Color.alphaBlend(fg.withValues(alpha: alpha), bg);

const _text = 4.5;
const _nonText = 3.0;

class _Pair {
  const _Pair(this.id, this.name, this.fg, this.bg, this.min);
  final String id;
  final String name;
  final Color Function(EmsColors c) fg;
  final Color Function(EmsColors c) bg;
  final double min;
}

final List<_Pair> _pairs = [
  _Pair(
    'P01',
    'textPrimary / surface',
    (c) => c.textPrimary,
    (c) => c.surface,
    _text,
  ),
  _Pair(
    'P02',
    'textPrimary / background',
    (c) => c.textPrimary,
    (c) => c.background,
    _text,
  ),
  _Pair(
    'P03',
    'textPrimary / surfaceRaised',
    (c) => c.textPrimary,
    (c) => c.surfaceRaised,
    _text,
  ),
  _Pair(
    'P04',
    'textSecondary / surface',
    (c) => c.textSecondary,
    (c) => c.surface,
    _text,
  ),
  _Pair(
    'P05',
    'textSecondary / background',
    (c) => c.textSecondary,
    (c) => c.background,
    _text,
  ),
  _Pair(
    'P06',
    'textHint / surface',
    (c) => c.textHint,
    (c) => c.surface,
    _text,
  ),
  _Pair(
    'P07',
    'textHint / background',
    (c) => c.textHint,
    (c) => c.background,
    _text,
  ),
  _Pair(
    'P08',
    'borderStrong / surface',
    (c) => c.borderStrong,
    (c) => c.surface,
    _nonText,
  ),
  _Pair(
    'P09',
    'borderStrong / background',
    (c) => c.borderStrong,
    (c) => c.background,
    _nonText,
  ),
  _Pair(
    'P10',
    'onPrimary / primary',
    (c) => c.onPrimary,
    (c) => c.primary,
    _text,
  ),
  _Pair(
    'P11',
    'onPrimary / primaryPressed',
    (c) => c.onPrimary,
    (c) => c.primaryPressed,
    _text,
  ),
  _Pair('P12', 'primary / surface', (c) => c.primary, (c) => c.surface, _text),
  _Pair(
    'P13',
    'primary / background',
    (c) => c.primary,
    (c) => c.background,
    _text,
  ),
  _Pair(
    'P14',
    'onPrimaryContainer / primaryContainer',
    (c) => c.onPrimaryContainer,
    (c) => c.primaryContainer,
    _text,
  ),
  _Pair(
    'P15',
    'focusRing / surface',
    (c) => c.focusRing,
    (c) => c.surface,
    _nonText,
  ),
  _Pair(
    'P16',
    'onSuccess / success',
    (c) => c.onSuccess,
    (c) => c.success,
    _text,
  ),
  _Pair('P17', 'success / surface', (c) => c.success, (c) => c.surface, _text),
  _Pair(
    'P18',
    'success / background',
    (c) => c.success,
    (c) => c.background,
    _text,
  ),
  _Pair(
    'P19',
    'onSuccessContainer / successContainer',
    (c) => c.onSuccessContainer,
    (c) => c.successContainer,
    _text,
  ),
  _Pair(
    'P20',
    'success / successContainer (icon)',
    (c) => c.success,
    (c) => c.successContainer,
    _nonText,
  ),
  _Pair('P21', 'onDanger / danger', (c) => c.onDanger, (c) => c.danger, _text),
  _Pair('P22', 'danger / surface', (c) => c.danger, (c) => c.surface, _text),
  _Pair(
    'P23',
    'danger / background',
    (c) => c.danger,
    (c) => c.background,
    _text,
  ),
  _Pair(
    'P24',
    'onDangerContainer / dangerContainer',
    (c) => c.onDangerContainer,
    (c) => c.dangerContainer,
    _text,
  ),
  _Pair(
    'P25',
    'danger / dangerContainer (icon)',
    (c) => c.danger,
    (c) => c.dangerContainer,
    _nonText,
  ),
  _Pair(
    'P26',
    'onWarning / warning',
    (c) => c.onWarning,
    (c) => c.warning,
    _text,
  ),
  _Pair('P27', 'warning / surface', (c) => c.warning, (c) => c.surface, _text),
  _Pair(
    'P28',
    'warning / background',
    (c) => c.warning,
    (c) => c.background,
    _text,
  ),
  _Pair(
    'P29',
    'onWarningContainer / warningContainer',
    (c) => c.onWarningContainer,
    (c) => c.warningContainer,
    _text,
  ),
  _Pair(
    'P30',
    'warning / warningContainer (icon)',
    (c) => c.warning,
    (c) => c.warningContainer,
    _nonText,
  ),
  _Pair('P31', 'onInfo / info', (c) => c.onInfo, (c) => c.info, _text),
  _Pair('P32', 'info / surface', (c) => c.info, (c) => c.surface, _text),
  _Pair('P33', 'info / background', (c) => c.info, (c) => c.background, _text),
  _Pair(
    'P34',
    'onInfoContainer / infoContainer',
    (c) => c.onInfoContainer,
    (c) => c.infoContainer,
    _text,
  ),
  _Pair(
    'P35',
    'info / infoContainer (icon)',
    (c) => c.info,
    (c) => c.infoContainer,
    _nonText,
  ),
  _Pair(
    'P36',
    'accentViolet / surface',
    (c) => c.accentViolet,
    (c) => c.surface,
    _nonText,
  ),
  _Pair(
    'P37',
    'accentCoral / surface',
    (c) => c.accentCoral,
    (c) => c.surface,
    _nonText,
  ),
  _Pair(
    'C03',
    'textSecondary / surface (selection options, neutral chip)',
    (c) => c.textSecondary,
    (c) => c.surface,
    _text,
  ),
  _Pair(
    'C04',
    'textSecondary / surfaceSunken (neutral chip, Done badge)',
    (c) => c.textSecondary,
    (c) => c.surfaceSunken,
    _text,
  ),
  _Pair(
    'C05',
    'textHint / surface (placeholders)',
    (c) => c.textHint,
    (c) => c.surface,
    _text,
  ),
  _Pair(
    'C06',
    'textHint / background (timestamps)',
    (c) => c.textHint,
    (c) => c.background,
    _text,
  ),
  _Pair(
    'C07',
    'textSecondary / surface (field icons)',
    (c) => c.textSecondary,
    (c) => c.surface,
    _nonText,
  ),
  _Pair(
    'C09',
    'onPrimary / primary (button label)',
    (c) => c.onPrimary,
    (c) => c.primary,
    _text,
  ),
  _Pair(
    'C11',
    'primary / surface (tertiary button, links)',
    (c) => c.primary,
    (c) => c.surface,
    _text,
  ),
  _Pair(
    'C13',
    'onPrimaryContainer / primaryContainer (primary chip)',
    (c) => c.onPrimaryContainer,
    (c) => c.primaryContainer,
    _text,
  ),
  _Pair(
    'C14',
    'onPrimaryContainer / primaryContainer (selected choice chip)',
    (c) => c.onPrimaryContainer,
    (c) => c.primaryContainer,
    _text,
  ),
  _Pair(
    'C14b',
    'primary outline / primaryContainer (selected choice chip)',
    (c) => c.primary,
    (c) => c.primaryContainer,
    _nonText,
  ),
  _Pair(
    'C15',
    'onPrimaryContainer / primaryContainer (slider badge, avatar)',
    (c) => c.onPrimaryContainer,
    (c) => c.primaryContainer,
    _text,
  ),
  _Pair(
    'C16',
    'completed-step check / primaryContainer',
    (c) => c.onPrimaryContainer,
    (c) => c.primaryContainer,
    _nonText,
  ),
  _Pair(
    'C17',
    'primary / surface (top-bar action icon)',
    (c) => c.primary,
    (c) => c.surface,
    _nonText,
  ),
  _Pair(
    'C18',
    'focusRing / surface',
    (c) => c.focusRing,
    (c) => c.surface,
    _nonText,
  ),
  _Pair(
    'C19',
    'onSuccessContainer / successContainer (success chip, banner)',
    (c) => c.onSuccessContainer,
    (c) => c.successContainer,
    _text,
  ),
  _Pair('C20', 'success / surface', (c) => c.success, (c) => c.surface, _text),
  _Pair(
    'C21',
    'danger / surface (required marker, field error)',
    (c) => c.danger,
    (c) => c.surface,
    _text,
  ),
  _Pair(
    'C22',
    'onDangerContainer / dangerContainer (danger chip)',
    (c) => c.onDangerContainer,
    (c) => c.dangerContainer,
    _text,
  ),
  _Pair(
    'C24',
    'onDangerContainer / dangerContainer (Now badge)',
    (c) => c.onDangerContainer,
    (c) => c.dangerContainer,
    _text,
  ),
  _Pair(
    'C25',
    'onWarningContainer / warningContainer (warning banner)',
    (c) => c.onWarningContainer,
    (c) => c.warningContainer,
    _text,
  ),
  _Pair('C27', 'warning / surface', (c) => c.warning, (c) => c.surface, _text),
  _Pair(
    'C28',
    'onInfoContainer / infoContainer (info banner, Report)',
    (c) => c.onInfoContainer,
    (c) => c.infoContainer,
    _text,
  ),
  _Pair(
    'C30',
    'location accent / its 12 % tint',
    (c) => c.accent(EmsAccent.location),
    (c) => over(c.accent(EmsAccent.location), 0.12, c.surface),
    _nonText,
  ),
  _Pair(
    'C31',
    'vehicle accent / its 12 % tint',
    (c) => c.accent(EmsAccent.vehicle),
    (c) => over(c.accent(EmsAccent.vehicle), 0.12, c.surface),
    _nonText,
  ),
  _Pair(
    'C32',
    'crew accent / its 12 % tint',
    (c) => c.accent(EmsAccent.crew),
    (c) => over(c.accent(EmsAccent.crew), 0.12, c.surface),
    _nonText,
  ),
  _Pair(
    'C32b',
    'danger / its 12 % tint (badge)',
    (c) => c.danger,
    (c) => over(c.danger, 0.12, c.surface),
    _nonText,
  ),
  _Pair(
    'C32c',
    'warning / its 12 % tint (badge)',
    (c) => c.warning,
    (c) => over(c.warning, 0.12, c.surface),
    _nonText,
  ),
  _Pair(
    'C32d',
    'info / its 12 % tint (badge)',
    (c) => c.info,
    (c) => over(c.info, 0.12, c.surface),
    _nonText,
  ),
  _Pair(
    'C32e',
    'primary / its 12 % tint (badge)',
    (c) => c.primary,
    (c) => over(c.primary, 0.12, c.surface),
    _nonText,
  ),
  _Pair(
    'C33',
    'borderStrong / surface (input outline)',
    (c) => c.borderStrong,
    (c) => c.surface,
    _nonText,
  ),
  _Pair(
    'C34',
    'borderStrong / background (chip, segmented outline)',
    (c) => c.borderStrong,
    (c) => c.background,
    _nonText,
  ),
  _Pair(
    'C35',
    'textHint thumb / borderSubtle track (switch off)',
    (c) => c.textHint,
    (c) => c.borderSubtle,
    _nonText,
  ),
  _Pair(
    'C36',
    'borderStrong / surface (switch-off outline, slider track)',
    (c) => c.borderStrong,
    (c) => c.surface,
    _nonText,
  ),
  _Pair(
    'C37',
    'danger / surface (life-threatening tile icon)',
    (c) => c.danger,
    (c) => c.surface,
    _nonText,
  ),
  _Pair(
    'C37b',
    'onDangerContainer / dangerContainer (selected life-threatening)',
    (c) => c.onDangerContainer,
    (c) => c.dangerContainer,
    _text,
  ),
  _Pair(
    'C38',
    'warning / surface (urgent tile icon)',
    (c) => c.warning,
    (c) => c.surface,
    _nonText,
  ),
  _Pair(
    'C38b',
    'onWarningContainer / warningContainer (selected urgent)',
    (c) => c.onWarningContainer,
    (c) => c.warningContainer,
    _text,
  ),
  _Pair(
    'C39',
    'success / surface (non-urgent tile icon)',
    (c) => c.success,
    (c) => c.surface,
    _nonText,
  ),
  _Pair(
    'C39b',
    'onSuccessContainer / successContainer (selected non-urgent)',
    (c) => c.onSuccessContainer,
    (c) => c.successContainer,
    _text,
  ),
  _Pair(
    'C40',
    'onSuccess / success (success button)',
    (c) => c.onSuccess,
    (c) => c.success,
    _text,
  ),
  _Pair(
    'C43',
    'completed-step outline / background',
    (c) => c.primary,
    (c) => c.background,
    _nonText,
  ),
  _Pair(
    'C43b',
    'upcoming-step outline / background',
    (c) => c.borderStrong,
    (c) => c.background,
    _nonText,
  ),
];

void main() {
  for (final dark in [false, true]) {
    final colors = dark ? EmsColors.dark : EmsColors.light;
    group(dark ? 'dark theme' : 'light theme', () {
      for (final pair in _pairs) {
        test('${pair.id} ${pair.name} meets ${pair.min}:1', () {
          final ratio = contrastRatio(pair.fg(colors), pair.bg(colors));
          expect(
            ratio,
            greaterThanOrEqualTo(pair.min),
            reason: '${pair.id} is ${ratio.toStringAsFixed(2)}:1',
          );
        });
      }

      test('snackbar and tooltip text on inverseSurface meets 4.5:1', () {
        final scheme = (dark ? EmsTheme.dark() : EmsTheme.light()).colorScheme;
        expect(
          contrastRatio(scheme.onInverseSurface, scheme.inverseSurface),
          greaterThanOrEqualTo(_text),
        );
        expect(
          contrastRatio(scheme.inversePrimary, scheme.inverseSurface),
          greaterThanOrEqualTo(_text),
        );
      });

      test('every ColorScheme on-role meets 4.5:1 on its role', () {
        final s = (dark ? EmsTheme.dark() : EmsTheme.light()).colorScheme;
        for (final (fg, bg) in [
          (s.onPrimary, s.primary),
          (s.onPrimaryContainer, s.primaryContainer),
          (s.onSecondary, s.secondary),
          (s.onSecondaryContainer, s.secondaryContainer),
          (s.onTertiary, s.tertiary),
          (s.onTertiaryContainer, s.tertiaryContainer),
          (s.onError, s.error),
          (s.onErrorContainer, s.errorContainer),
          (s.onSurface, s.surface),
          (s.onSurfaceVariant, s.surface),
          (s.onSurface, s.surfaceContainerHighest),
        ]) {
          expect(contrastRatio(fg, bg), greaterThanOrEqualTo(_text));
        }
      });
    });
  }

  group('contrastRatio', () {
    test('is 21:1 for black on white', () {
      expect(
        contrastRatio(const Color(0xFF000000), const Color(0xFFFFFFFF)),
        closeTo(21, 0.001),
      );
    });

    test('matches VISUAL_PROPOSAL §1.4 for onPrimary on primary', () {
      expect(
        contrastRatio(EmsColors.light.onPrimary, EmsColors.light.primary),
        closeTo(5.17, 0.01),
      );
      expect(
        contrastRatio(EmsColors.dark.onPrimary, EmsColors.dark.primary),
        closeTo(7.44, 0.01),
      );
    });
  });
}
