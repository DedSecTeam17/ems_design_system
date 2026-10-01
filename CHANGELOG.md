# Changelog

All notable changes to `ems_design_system`. The package follows semantic
versioning; before 1.0.0 a minor version may contain breaking changes.

## 0.1.0 — 2026-10-01

First version as a package. The design system was extracted from the EMS AI
Mobile app (`lib/core/theme`, `lib/core/widgets`) after design-system Phase 2
(steps 2.0–2.10: tokens, approved palette, sizes, type, accessibility and RTL).

### Added

- Tokens: `EmsColors` (37 semantic tokens, light and dark),
  `EmsTypography`/`EmsTypeScale` (Latin and Arabic metrics), `EmsSpacing`,
  `EmsRadius`, `EmsSizes`, `EmsIconSize`, `EmsMotion`, `EmsElevation`,
  `EmsTone`, `EmsAccent`.
- `EmsTheme.light/dark({Locale? locale, EmsColors? colors})`: a full Material 3
  theme built from the tokens, with component themes.
- `EmsLocalizations` (English, Arabic) for the design system's own strings.
- Widgets: `EmsButton`, `EmsBottomStepNav`, `EmsTextField`, `EmsTextArea`,
  `EmsDateTimeField`, `EmsVitalSignCard`, `EmsSliderField`, `EmsSearchBar`,
  `EmsToggleRow`, `EmsTileSelector`, `EmsChoiceChips`, `EmsSegmentedControl`,
  `EmsSelectionCard`, `EmsAlertBanner`, `EmsLoadingOverlay`, `EmsShimmerBox`,
  `EmsCard`, `EmsChip`, `EmsIconBadge`, `EmsAvatar`, `EmsMemberChip`,
  `EmsDataTable`, `EmsDividerWithText`, `EmsTopBar`, `EmsStepIndicator`,
  `EmsSidebar`, `EmsNotificationItem`, `EmsTappable`, `EmsInputDecoration`.
- Bundled fonts: Roboto and Tajawal, weights 400/500/700, registered as
  `packages/ems_design_system/<family>` (`EmsFonts.latin`, `EmsFonts.arabic`).
- Widgetbook catalog (`widgetbook/`), golden, contrast, behaviour and RTL
  tests.

### Breaking changes (relative to the in-app design system)

The deprecated APIs from steps 2.6–2.10 have been removed:

| Removed | Use instead |
|---|---|
| `AppSpacing` | `EmsSpacing`, `EmsRadius`, `EmsSizes`, `EmsIconSize` |
| `AppTextStyles` | `EmsTypeScale` (const) or `EmsTypography.of(context)` |
| 19 legacy `EmsColors` getters (`error`, `errorSurface`, `primarySurface`, `border`, `divider`, `cardBackground`, `iconCrew`, …) | the semantic tokens (`danger`, `dangerContainer`, `primaryContainer`, `borderSubtle`, `surface`, `accent(EmsAccent.crew)`, …) |
| `EmsPrimaryButton`, `EmsOutlinedButton` | `EmsButton(variant: …)` |
| `EmsChip.neutral/success/error/primary(context, …)` | `EmsChip(label: …, tone: EmsTone.…)` |
| `EmsGridSelector`, `EmsGridSelectorItem` | `EmsTileSelector<T>`, `EmsTileItem<T>` |
| `EmsSeveritySelector` (+ `.standard`), `SeverityOption` | `EmsTileSelector.severity(...)` |
| `EmsStatusChipGroup` | `EmsChoiceChips<T>` |
| `EmsTileStyle`, `EmsTileSelector.style`, `EmsTileItem.color` | one tile look; `EmsTileItem.tone` |
| `EmsIconBadge.color` | `accent:` or `tone:` |
| `EmsSelectionCard.iconColor` | `accent:` |
| `EmsTextField.isRequired` / `isPassword` | `required` / `obscureText` |
| `EmsTextArea.labelColor` | none (labels are always `textPrimary`) |
| `EmsCard.borderColor` / `borderRadius` | `tone:`; the radius is always `EmsRadius.lg` |

Renamed (DS-20): `NotificationStatus` → `EmsNotificationStatus`.

`EmsFonts.latin`/`EmsFonts.arabic` are now the package-qualified family names
(`packages/ems_design_system/Roboto` / `.../Tajawal`) instead of the bare
names. Use the constants, never the literal strings.

### Fixed

- `EmsNotificationItem` no longer overflows with a long location or at a large
  text scale (DS-36). Decision: wrap to 2 lines, then ellipsis (product owner,
  2026-10-01). The location wraps to 2 lines then ends with an ellipsis; the
  region (at most a third of the line) and the time are 1 line + ellipsis; the
  Follow Trip/Report pills and the status badge are capped at a share of the
  row and their labels wrap to 2 lines + ellipsis. Short content looks the
  same as before. Covered by the `ems_notification_item_long_address` goldens
  and text scale 2.0 tests (LTR and RTL).
