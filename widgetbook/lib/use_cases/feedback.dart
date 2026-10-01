import 'package:ems_design_system/ems_design_system.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../support.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: EmsAlertBanner,
  path: '[Feedback]',
)
Widget emsAlertBanner(BuildContext context) {
  final tone = context.knobs.object.dropdown(
    label: 'Tone',
    options: EmsTone.values,
    initialOption: EmsTone.danger,
    labelBuilder: (t) => t.name,
  );
  return Showcase(
    child: EmsAlertBanner(
      tone: tone,
      title: textKnob(
        context,
        'Title',
        en: 'Notification Alert:',
        ar: 'تنبيه إشعار:',
      ),
      message: textKnob(
        context,
        'Message',
        en: 'Night shift handover starts in 20 minutes.',
        ar: 'يبدأ تسليم مناوبة الليل خلال 20 دقيقة.',
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'All tones', type: EmsAlertBanner, path: '[Feedback]')
Widget emsAlertBannerTones(BuildContext context) {
  return Showcase(
    child: Gap(
      children: [
        for (final tone in EmsTone.values)
          EmsAlertBanner(
            tone: tone,
            title: tone.name,
            message: l(
              context,
              'The tone sets the container and its on-container text.',
              'يحدد النمط لون الخلفية ولون النص عليها.',
            ),
          ),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Over a form',
  type: EmsLoadingOverlay,
  path: '[Feedback]',
)
Widget emsLoadingOverlay(BuildContext context) {
  final loading = context.knobs.boolean(label: 'Loading', initialValue: true);
  return Showcase(
    child: EmsLoadingOverlay(
      isLoading: loading,
      child: Gap(
        children: [
          EmsTextField(label: l(context, 'Email', 'البريد الإلكتروني')),
          EmsTextField(
            label: l(context, 'Password', 'كلمة المرور'),
            obscureText: true,
          ),
          EmsButton(
            label: l(context, 'Sign In', 'تسجيل الدخول'),
            onPressed: () {},
          ),
        ],
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Skeleton lines',
  type: EmsShimmerBox,
  path: '[Feedback]',
)
Widget emsShimmerBox(BuildContext context) {
  final height = context.knobs.double.slider(
    label: 'Line height',
    initialValue: 16,
    min: 8,
    max: 48,
  );
  return Showcase(
    child: Gap(
      gap: 12,
      children: [
        EmsShimmerBox(height: height),
        EmsShimmerBox(height: height, width: 280),
        EmsShimmerBox(height: height, width: 180),
      ],
    ),
  );
}
