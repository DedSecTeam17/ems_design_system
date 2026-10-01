import 'package:ems_design_system/ems_design_system.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../support.dart';

const _icons = <String, IconData?>{
  'none': null,
  'check': Icons.check_circle_outline,
  'arrow back': Icons.arrow_back,
  'logout': Icons.logout,
};

@widgetbook.UseCase(name: 'Playground', type: EmsButton, path: '[Buttons]')
Widget emsButtonPlayground(BuildContext context) {
  final k = context.knobs;
  final label = textKnob(context, 'Label', en: 'Sign In', ar: 'تسجيل الدخول');
  final variant = k.object.dropdown(
    label: 'Variant',
    options: EmsButtonVariant.values,
    labelBuilder: (v) => v.name,
  );
  final size = k.object.segmented(
    label: 'Size',
    options: EmsButtonSize.values,
    initialOption: EmsButtonSize.large,
    labelBuilder: (v) => v.name,
  );
  final icon = k.object.dropdown(
    label: 'Leading icon',
    options: _icons.keys.toList(),
  );
  final trailing = k.boolean(label: 'Trailing arrow');
  final loading = k.boolean(label: 'Loading');
  final enabled = k.boolean(label: 'Enabled', initialValue: true);
  final fullWidth = k.boolean(label: 'Full width', initialValue: true);
  return Showcase(
    child: Align(
      alignment: AlignmentDirectional.centerStart,
      child: EmsButton(
        label: label,
        variant: variant,
        size: size,
        icon: _icons[icon],
        trailingIcon: trailing ? Icons.arrow_forward : null,
        loading: loading,
        fullWidth: fullWidth,
        onPressed: enabled ? () {} : null,
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'All variants', type: EmsButton, path: '[Buttons]')
Widget emsButtonVariants(BuildContext context) {
  final enabled = context.knobs.boolean(label: 'Enabled', initialValue: true);
  return Showcase(
    child: Gap(
      children: [
        for (final v in EmsButtonVariant.values)
          EmsButton(
            label: l(context, 'Variant ${v.name}', 'النمط ${v.name}'),
            variant: v,
            onPressed: enabled ? () {} : null,
          ),
      ],
    ),
  );
}

@widgetbook.UseCase(name: 'Loading', type: EmsButton, path: '[Buttons]')
Widget emsButtonLoading(BuildContext context) {
  return Showcase(
    child: Gap(
      children: [
        EmsButton(
          label: l(context, 'Sign In', 'تسجيل الدخول'),
          loading: true,
          onPressed: () {},
        ),
        EmsButton(
          label: l(context, 'Cancel', 'إلغاء'),
          variant: EmsButtonVariant.secondary,
          loading: true,
          onPressed: () {},
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(name: 'Sizes', type: EmsButton, path: '[Buttons]')
Widget emsButtonSizes(BuildContext context) {
  return Showcase(
    child: Gap(
      children: [
        EmsButton(
          label: l(context, 'Large (56 dp)', 'كبير (56)'),
          onPressed: () {},
        ),
        EmsButton(
          label: l(context, 'Regular (48 dp)', 'عادي (48)'),
          size: EmsButtonSize.regular,
          onPressed: () {},
        ),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: EmsButton(
            label: l(context, 'Hugs its label', 'بعرض النص'),
            fullWidth: false,
            icon: Icons.check,
            onPressed: () {},
          ),
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Interactive',
  type: EmsBottomStepNav,
  path: '[Buttons]',
)
Widget emsBottomStepNav(BuildContext context) {
  final total = context.knobs.int.slider(
    label: 'Total steps',
    initialValue: 6,
    min: 2,
    max: 8,
  );
  final title = textKnob(
    context,
    'Step title',
    en: 'Clinical Assessment Details',
    ar: 'تفاصيل التقييم السريري',
  );
  return Stateful<int>(
    initial: 1,
    builder: (context, step, set) => Showcase(
      maxWidth: 900,
      child: EmsBottomStepNav(
        currentStep: step.clamp(1, total),
        totalSteps: total,
        stepLabel: title,
        onPrev: step > 1 ? () => set(step - 1) : null,
        onNext: step < total ? () => set(step + 1) : null,
      ),
    ),
  );
}
