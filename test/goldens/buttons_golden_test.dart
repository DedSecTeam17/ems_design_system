// Phase 2.0 baseline goldens: buttons and the wizard bottom bar, in their
// current look. They change on purpose only in 2.8/2.9.
import 'package:ems_design_system/ems_design_system.dart';
import 'package:flutter/material.dart';

import '../helpers/ems_test_app.dart';

void main() {
  emsGolden('ems_primary_button', size: const Size(420, 380), (context) {
    return SizedBox(
      width: 380,
      child: Column(
        children: [
          EmsButton(label: t(context, 'Sign In'), onPressed: () {}),
          const SizedBox(height: 12),
          EmsButton(
            label: t(context, 'Ready State'),
            icon: Icons.check_circle_outline,
            onPressed: () {},
          ),
          const SizedBox(height: 12),
          EmsButton(label: t(context, 'Next'), onPressed: null),
          const SizedBox(height: 12),
          EmsButton(
            label: t(context, 'Sign In'),
            loading: true,
            onPressed: () {},
          ),
          const SizedBox(height: 12),
          EmsButton(
            label: t(context, 'Finish'),
            variant: EmsButtonVariant.success,
            width: 200,
            onPressed: () {},
          ),
        ],
      ),
    );
  });

  emsGolden('ems_outlined_button', size: const Size(420, 260), (context) {
    return SizedBox(
      width: 380,
      child: Column(
        children: [
          EmsButton(
            variant: EmsButtonVariant.secondary,
            label: t(context, 'Cancel'),
            onPressed: () {},
          ),
          const SizedBox(height: 12),
          EmsButton(
            variant: EmsButtonVariant.secondary,
            label: t(context, 'Back'),
            icon: Icons.arrow_back,
            onPressed: () {},
          ),
          const SizedBox(height: 12),
          EmsButton(
            variant: EmsButtonVariant.secondary,
            label: t(context, 'Cancel'),
            width: 200,
            onPressed: null,
          ),
        ],
      ),
    );
  });

  emsGolden('ems_bottom_step_nav', size: const Size(760, 360), (context) {
    return SizedBox(
      width: 720,
      child: Column(
        children: [
          EmsBottomStepNav(
            currentStep: 1,
            totalSteps: 6,
            stepLabel: t(context, 'Case & Insurance'),
            onNext: () {},
          ),
          const SizedBox(height: 12),
          EmsBottomStepNav(
            currentStep: 3,
            totalSteps: 6,
            stepLabel: t(context, 'Clinical Assessment Details'),
            onPrev: () {},
            onNext: () {},
          ),
          const SizedBox(height: 12),
          EmsBottomStepNav(
            currentStep: 6,
            totalSteps: 6,
            stepLabel: t(context, 'Handover & Closure'),
            onPrev: () {},
          ),
        ],
      ),
    );
  });

  // New in step 2.6, so there is no earlier look to preserve.
  emsGolden('ems_button_variants', size: const Size(420, 320), (context) {
    return SizedBox(
      width: 380,
      child: Column(
        children: [
          EmsButton(
            label: t(context, 'Cancel'),
            variant: EmsButtonVariant.tertiary,
            onPressed: () {},
          ),
          const SizedBox(height: 12),
          EmsButton(
            label: t(context, 'Sign Out'),
            variant: EmsButtonVariant.danger,
            icon: Icons.logout,
            onPressed: () {},
          ),
          const SizedBox(height: 12),
          EmsButton(
            label: t(context, 'Cancel'),
            variant: EmsButtonVariant.secondary,
            loading: true,
            onPressed: () {},
          ),
          const SizedBox(height: 12),
          EmsButton(
            label: t(context, 'Finish'),
            variant: EmsButtonVariant.success,
            onPressed: null,
          ),
        ],
      ),
    );
  });
}
