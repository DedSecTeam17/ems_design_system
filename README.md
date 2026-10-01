# ems_design_system

The EMS design system: design tokens, the Material 3 theme (light and dark,
English and Arabic), the design system's own strings, and the `Ems*` widgets
used by the EMS AI Mobile app. Ambulance crews use these screens on tablets, in
a moving vehicle, in sunlight or at night, often wearing gloves, in English or
Arabic. Legibility, contrast, tap targets and predictable behaviour come first.

- Version: `0.1.0` (pre-1.0: minor versions may change the API; see `CHANGELOG.md`)
- Toolchain: Flutter `3.35.3`, Dart `^3.9.2`
- Dependencies: Flutter only
- Licence: proprietary, source-visible, all rights reserved (`LICENSE`). Bundled
  fonts keep their own licences (below).

## Install

Depend on a tagged release over HTTPS (the repository is public, so no
credentials are needed):

```yaml
dependencies:
  ems_design_system:
    git:
      url: https://github.com/DedSecTeam17/ems_design_system.git
      ref: v0.1.0
```

To work on the package and the app together, clone this repository next to the
app and add a `pubspec_overrides.yaml` (git-ignored, never committed) in the app:

```yaml
dependency_overrides:
  ems_design_system:
    path: ../ems_design_system
```

Delete the override and run `flutter pub get` before committing the app's
`pubspec.lock`, so the lock file keeps pointing at the git tag.

Import the public API from the one barrel file. Never import `src/` files.

```dart
import 'package:ems_design_system/ems_design_system.dart';
```

## Set up the theme and localizations

```dart
MaterialApp(
  // The locale picks the script: Arabic gets Tajawal, Arabic line heights,
  // no letter spacing and 600 → 700; other locales get Roboto.
  theme: EmsTheme.light(locale: locale),
  darkTheme: EmsTheme.dark(locale: locale),
  themeMode: themeMode,
  locale: locale,
  supportedLocales: EmsLocalizations.supportedLocales, // en, ar
  localizationsDelegates: const [
    EmsLocalizations.delegate, // the design system's own strings
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
)
```

- Read colours with `EmsColors.of(context)` and text styles with
  `EmsTypography.of(context)`. Both are `ThemeExtension`s installed by
  `EmsTheme`; `EmsColors.of` throws a clear `FlutterError` if the theme is
  missing.
- Spacing, radius, sizes and icon sizes are `const` scales: `EmsSpacing`,
  `EmsRadius`, `EmsSizes`, `EmsIconSize`. Motion: `EmsMotion.of(context)`
  (zero durations when the platform asks for reduced motion). Depth:
  `EmsElevation`.
- Widgets take **already-localized** text. The design system never translates
  app strings. `EmsLocalizations` (English and Arabic) only holds the few
  labels a component owns: Prev/Next, "Step x of y", "n selected",
  Required, Show/Hide password, Loading, Search, Clear, No value, Completed,
  Selected, Expand/Collapse, Open.

### Fonts

The package bundles **Roboto** (Latin, Apache-2.0, `assets/fonts/latin/LICENSE.txt`)
and **Tajawal** (Arabic, SIL OFL 1.1, `assets/fonts/arabic/OFL.txt`), weights
400/500/700 only. Because they ship in a package, Flutter registers them as
`packages/ems_design_system/Roboto` and `packages/ems_design_system/Tajawal`.
`EmsTheme` names them for you. If a style needs an explicit family, use the
constants:

```dart
TextStyle(fontFamily: EmsFonts.arabic) // 'packages/ems_design_system/Tajawal'
```

The app doesn't declare these fonts in its own `pubspec.yaml`.

## Components

| Group | Widgets |
|---|---|
| Buttons | `EmsButton` (`EmsButtonVariant` primary/secondary/tertiary/success/danger, `EmsButtonSize` large 56 dp / regular 48 dp, loading, leading/trailing icon), `EmsBottomStepNav` |
| Inputs | `EmsTextField` (required, obscureText, error, helper, focus, input action, autofill), `EmsTextArea`, `EmsDateTimeField`, `EmsVitalSignCard`, `EmsSliderField`, `EmsSearchBar`, `EmsToggleRow`, `EmsInputDecoration` (the shared input look) |
| Selection | `EmsTileSelector<T>` (+ `EmsTileSelector.severity`), `EmsChoiceChips<T>`, `EmsSegmentedControl`, `EmsSelectionCard` (`EmsSelectionMode` single/multiple) |
| Feedback | `EmsAlertBanner`, `EmsLoadingOverlay`, `EmsShimmerBox` |
| Display | `EmsCard`, `EmsChip`, `EmsIconBadge`, `EmsAvatar`, `EmsMemberChip`, `EmsDataTable`, `EmsDividerWithText` |
| Navigation | `EmsTopBar` + `EmsTopBarAction`, `EmsStepIndicator`, `EmsSidebar` + `EmsSidebarItem`, `EmsNotificationItem` (`EmsNotificationStatus`) |
| Foundation | `EmsTappable` (ink, focus, keyboard and semantics for custom tappables) |
| Tokens | `EmsColors`, `EmsTypography`, `EmsTypeScale`, `EmsSpacing`, `EmsRadius`, `EmsSizes`, `EmsIconSize`, `EmsMotion`, `EmsElevation`, `EmsTone`, `EmsAccent`, `EmsFonts`, `EmsTheme` |

Semantic variants use enums: `EmsTone` (neutral, primary, success, warning,
danger, info) for chips, banners, badges, cards and tiles; `EmsAccent`
(location, vehicle, equipment, crew) for category colours.

## Accessibility guarantees

Each guarantee is covered by the package's tests.

- **Contrast:** every text/background pair the components use meets WCAG AA
  in both themes: 4.5:1 for body text, 3:1 for large text, icons, input
  borders and focus rings. `test/tokens/contrast_test.dart` checks 79 pairs ×
  2 themes. The lowest values are 4.59:1 (text) and 3.23:1 (non-text).
- **Tap targets:** every tappable part is at least 48 × 48 dp. Primary
  buttons and inputs are 56 dp (decision D6).
- **Screen readers:** icon-only buttons have labels and tooltips. Selected,
  checked, expanded and disabled states are announced. Decorative graphics
  (shimmer) are excluded, and loading is announced.
- **Text scale:** layouts hold at 1.3 with no clipping or overflow (every
  golden is recorded at 1.0 and 1.3).
- **RTL:** directional insets, alignment and icons. Every component is tested
  under Arabic/RTL with Tajawal, and Arabic text has no letter spacing.
- **Not colour alone:** selection and status also show a check icon, an
  outline or text.
- **Reduced motion:** animations stop when the platform disables them.

`EmsNotificationItem` keeps a long location to 2 lines, then an ellipsis,
and nothing in the row overflows up to text scale 2.0 (DS-36). One layout
improvement is open: **DS-37**, the row at text scale 2.0 in a narrow width
(`docs/design-system/AUDIT.md` in the EMS AI Mobile app repository).

## Tests

```bash
flutter pub get
flutter analyze
flutter test                 # behaviour, semantics, contrast, RTL, goldens
```

- Goldens (`test/goldens/`) cover light/dark × LTR/RTL × text scale 1.0/1.3.
  They were recorded on **macOS with Flutter 3.35.3**. Run them on the same
  setup, because text rasterization differs on Linux. `test/flutter_test_config.dart`
  loads the bundled fonts, so goldens show real glyphs.
- Golden comparison is **exact locally** (0% of pixels may differ). On CI
  (`CI=true`, set by GitHub Actions) up to **1.0%** of pixels may differ:
  the `macos-26` runner anti-aliases glyph edges (CoreText) slightly
  differently from the Mac the goldens were recorded on (observed at most
  0.46%, only along text edges). A real visual change, such as a 48×48 block
  on a 420×320 golden (≈ 1.7%), still fails. A pass within tolerance prints
  its diff percent, so drift shows in the CI log; a failure still writes
  `test/goldens/failures/`. The limit is `kCiGoldenTolerancePercent` in
  `test/helpers/ems_golden_comparator.dart`. To experiment, override it
  anywhere with a percent: `EMS_GOLDEN_TOLERANCE=0.5 flutter test`.
- Update goldens (`flutter test --update-goldens`) only for an approved visual
  change, and list the changed images in the handoff.
- `test/architecture_test.dart` fails if the package imports app code, GetIt,
  Provider, or the app translator.

## Widgetbook

A local catalog in `widgetbook/`: a separate Flutter app that depends on this
package by path. It uses Widgetbook 3.21 (the last line that supports Flutter
3.35). Generator telemetry is disabled in `widgetbook/build.yaml`.

```bash
cd widgetbook
flutter pub get
dart run build_runner build -d   # regenerates lib/main.directories.g.dart
flutter run -d chrome            # or: flutter build web --release
flutter test                     # opens every use case (en/light/1.0, ar/dark/2.0)
```

Addons: theme (EmsTheme light/dark, built for the selected locale), locale
(en/ar, which also switches the text direction), text scale (1.0–2.0 in 0.1
steps), and viewport (Android medium/large tablet, iPad). Each component has at
least one use case, with knobs for its content, variants and states.

## Versioning

The package follows semantic versioning. Until 1.0.0, a minor version may
contain breaking changes, and `CHANGELOG.md` lists them with migration notes.
