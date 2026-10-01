import 'package:ems_design_system/ems_design_system.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../support.dart';

@widgetbook.UseCase(name: 'List row', type: EmsTappable, path: '[Foundation]')
Widget emsTappable(BuildContext context) {
  final enabled = context.knobs.boolean(label: 'Enabled', initialValue: true);
  final c = EmsColors.of(context);
  return Stateful<bool>(
    initial: false,
    builder: (context, selected, set) => Showcase(
      child: EmsTappable(
        selected: selected,
        semanticLabel: l(
          context,
          'Readiness Overview',
          'نظرة عامة على الجاهزية',
        ),
        borderRadius: BorderRadius.circular(EmsRadius.md),
        onTap: enabled ? () => set(!selected) : null,
        child: Container(
          constraints: const BoxConstraints(minHeight: EmsSizes.minTap),
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: EmsSpacing.lg,
            vertical: EmsSpacing.md,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(EmsRadius.md),
            border: Border.all(
              color: selected ? c.primary : c.borderSubtle,
              width: selected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.speed, color: c.primary),
              const SizedBox(width: EmsSpacing.md),
              Expanded(
                child: Text(
                  l(context, 'Readiness Overview', 'نظرة عامة على الجاهزية'),
                  style: EmsTypography.of(context).bodyLarge,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Semantic tokens',
  type: EmsColors,
  path: '[Foundation]',
)
Widget emsColorTokens(BuildContext context) {
  final c = EmsColors.of(context);
  final tokens = <String, (Color, Color)>{
    'background / textPrimary': (c.background, c.textPrimary),
    'surface / textSecondary': (c.surface, c.textSecondary),
    'surfaceSunken / textPrimary': (c.surfaceSunken, c.textPrimary),
    'primary / onPrimary': (c.primary, c.onPrimary),
    'primaryContainer / onPrimaryContainer': (
      c.primaryContainer,
      c.onPrimaryContainer,
    ),
    'success / onSuccess': (c.success, c.onSuccess),
    'successContainer / onSuccessContainer': (
      c.successContainer,
      c.onSuccessContainer,
    ),
    'warning / onWarning': (c.warning, c.onWarning),
    'warningContainer / onWarningContainer': (
      c.warningContainer,
      c.onWarningContainer,
    ),
    'danger / onDanger': (c.danger, c.onDanger),
    'dangerContainer / onDangerContainer': (
      c.dangerContainer,
      c.onDangerContainer,
    ),
    'info / onInfo': (c.info, c.onInfo),
    'infoContainer / onInfoContainer': (c.infoContainer, c.onInfoContainer),
  };
  return Showcase(
    maxWidth: 720,
    child: Gap(
      gap: 8,
      children: [
        for (final e in tokens.entries)
          Container(
            padding: const EdgeInsets.all(EmsSpacing.lg),
            decoration: BoxDecoration(
              color: e.value.$1,
              borderRadius: BorderRadius.circular(EmsRadius.md),
              border: Border.all(color: c.borderSubtle),
            ),
            child: Text(
              e.key,
              style: EmsTypography.of(
                context,
              ).labelLarge.copyWith(color: e.value.$2),
            ),
          ),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Type scale',
  type: EmsTypography,
  path: '[Foundation]',
)
Widget emsTypeScale(BuildContext context) {
  final t = EmsTypography.of(context);
  final sampleText = textKnob(
    context,
    'Sample',
    en: 'Patient handover',
    ar: 'تسليم المريض',
  );
  final styles = <String, TextStyle>{
    'displaySmall': t.displaySmall,
    'headlineLarge': t.headlineLarge,
    'headlineMedium': t.headlineMedium,
    'headlineSmall': t.headlineSmall,
    'titleLarge': t.titleLarge,
    'titleMedium': t.titleMedium,
    'bodyLarge': t.bodyLarge,
    'bodyMedium': t.bodyMedium,
    'bodySmall': t.bodySmall,
    'labelLarge': t.labelLarge,
    'labelMedium': t.labelMedium,
    'labelSmall': t.labelSmall,
  };
  final c = EmsColors.of(context);
  return Showcase(
    maxWidth: 720,
    child: Gap(
      gap: 12,
      children: [
        for (final e in styles.entries)
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              SizedBox(
                width: 140,
                child: Text(
                  e.key,
                  style: t.labelMedium.copyWith(color: c.textSecondary),
                ),
              ),
              Expanded(
                child: Text(
                  sampleText,
                  style: e.value.copyWith(color: c.textPrimary),
                ),
              ),
            ],
          ),
      ],
    ),
  );
}
