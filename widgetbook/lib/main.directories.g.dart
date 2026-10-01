// dart format width=80
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_import, prefer_relative_imports, directives_ordering

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AppGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:ems_widgetbook/use_cases/buttons.dart'
    as _ems_widgetbook_use_cases_buttons;
import 'package:ems_widgetbook/use_cases/display.dart'
    as _ems_widgetbook_use_cases_display;
import 'package:ems_widgetbook/use_cases/feedback.dart'
    as _ems_widgetbook_use_cases_feedback;
import 'package:ems_widgetbook/use_cases/foundation.dart'
    as _ems_widgetbook_use_cases_foundation;
import 'package:ems_widgetbook/use_cases/inputs.dart'
    as _ems_widgetbook_use_cases_inputs;
import 'package:ems_widgetbook/use_cases/navigation.dart'
    as _ems_widgetbook_use_cases_navigation;
import 'package:ems_widgetbook/use_cases/selection.dart'
    as _ems_widgetbook_use_cases_selection;
import 'package:widgetbook/widgetbook.dart' as _widgetbook;

final directories = <_widgetbook.WidgetbookNode>[
  _widgetbook.WidgetbookCategory(
    name: 'Buttons',
    children: [
      _widgetbook.WidgetbookComponent(
        name: 'EmsBottomStepNav',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Interactive',
            builder: _ems_widgetbook_use_cases_buttons.emsBottomStepNav,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'EmsButton',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'All variants',
            builder: _ems_widgetbook_use_cases_buttons.emsButtonVariants,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'Loading',
            builder: _ems_widgetbook_use_cases_buttons.emsButtonLoading,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'Playground',
            builder: _ems_widgetbook_use_cases_buttons.emsButtonPlayground,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'Sizes',
            builder: _ems_widgetbook_use_cases_buttons.emsButtonSizes,
          ),
        ],
      ),
    ],
  ),
  _widgetbook.WidgetbookCategory(
    name: 'Display',
    children: [
      _widgetbook.WidgetbookComponent(
        name: 'EmsAvatar',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Playground',
            builder: _ems_widgetbook_use_cases_display.emsAvatar,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'EmsCard',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Playground',
            builder: _ems_widgetbook_use_cases_display.emsCard,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'EmsChip',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'All tones',
            builder: _ems_widgetbook_use_cases_display.emsChipTones,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'Playground',
            builder: _ems_widgetbook_use_cases_display.emsChip,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'EmsDataTable',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Medications',
            builder: _ems_widgetbook_use_cases_display.emsDataTable,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'EmsDividerWithText',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Default',
            builder: _ems_widgetbook_use_cases_display.emsDividerWithText,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'EmsIconBadge',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Categories and tones',
            builder: _ems_widgetbook_use_cases_display.emsIconBadge,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'EmsMemberChip',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Crew',
            builder: _ems_widgetbook_use_cases_display.emsMemberChip,
          ),
        ],
      ),
    ],
  ),
  _widgetbook.WidgetbookCategory(
    name: 'Feedback',
    children: [
      _widgetbook.WidgetbookComponent(
        name: 'EmsAlertBanner',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'All tones',
            builder: _ems_widgetbook_use_cases_feedback.emsAlertBannerTones,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'Playground',
            builder: _ems_widgetbook_use_cases_feedback.emsAlertBanner,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'EmsLoadingOverlay',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Over a form',
            builder: _ems_widgetbook_use_cases_feedback.emsLoadingOverlay,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'EmsShimmerBox',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Skeleton lines',
            builder: _ems_widgetbook_use_cases_feedback.emsShimmerBox,
          ),
        ],
      ),
    ],
  ),
  _widgetbook.WidgetbookCategory(
    name: 'Foundation',
    children: [
      _widgetbook.WidgetbookComponent(
        name: 'EmsColors',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Semantic tokens',
            builder: _ems_widgetbook_use_cases_foundation.emsColorTokens,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'EmsTappable',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'List row',
            builder: _ems_widgetbook_use_cases_foundation.emsTappable,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'EmsTypography',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Type scale',
            builder: _ems_widgetbook_use_cases_foundation.emsTypeScale,
          ),
        ],
      ),
    ],
  ),
  _widgetbook.WidgetbookCategory(
    name: 'Inputs',
    children: [
      _widgetbook.WidgetbookComponent(
        name: 'EmsDateTimeField',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Playground',
            builder: _ems_widgetbook_use_cases_inputs.emsDateTimeField,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'EmsSearchBar',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Default',
            builder: _ems_widgetbook_use_cases_inputs.emsSearchBar,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'EmsSliderField',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Interactive',
            builder: _ems_widgetbook_use_cases_inputs.emsSliderField,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'EmsTextArea',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Playground',
            builder: _ems_widgetbook_use_cases_inputs.emsTextArea,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'EmsTextField',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Playground',
            builder: _ems_widgetbook_use_cases_inputs.emsTextFieldPlayground,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'States',
            builder: _ems_widgetbook_use_cases_inputs.emsTextFieldStates,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'EmsToggleRow',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Interactive',
            builder: _ems_widgetbook_use_cases_inputs.emsToggleRow,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'EmsVitalSignCard',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Playground',
            builder: _ems_widgetbook_use_cases_inputs.emsVitalSignCard,
          ),
        ],
      ),
    ],
  ),
  _widgetbook.WidgetbookCategory(
    name: 'Navigation',
    children: [
      _widgetbook.WidgetbookComponent(
        name: 'EmsNotificationItem',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Playground',
            builder: _ems_widgetbook_use_cases_navigation.emsNotificationItem,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'EmsSidebar',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Interactive',
            builder: _ems_widgetbook_use_cases_navigation.emsSidebar,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'EmsStepIndicator',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Interactive',
            builder: _ems_widgetbook_use_cases_navigation.emsStepIndicator,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'EmsTopBar',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Actions and logo',
            builder: _ems_widgetbook_use_cases_navigation.emsTopBar,
          ),
        ],
      ),
    ],
  ),
  _widgetbook.WidgetbookCategory(
    name: 'Selection',
    children: [
      _widgetbook.WidgetbookComponent(
        name: 'EmsChoiceChips',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Statuses',
            builder: _ems_widgetbook_use_cases_selection.emsChoiceChips,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'EmsSegmentedControl',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Interactive',
            builder: _ems_widgetbook_use_cases_selection.emsSegmentedControl,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'EmsSelectionCard',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Interactive',
            builder: _ems_widgetbook_use_cases_selection.emsSelectionCard,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'EmsTileSelector',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Grid',
            builder: _ems_widgetbook_use_cases_selection.emsTileSelectorGrid,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'Severity preset',
            builder:
                _ems_widgetbook_use_cases_selection.emsTileSelectorSeverity,
          ),
        ],
      ),
    ],
  ),
];
