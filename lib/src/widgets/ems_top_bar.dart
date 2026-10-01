import 'package:flutter/material.dart';

import '../tokens/tokens.dart';
import 'ems_tappable.dart';

/// Top bar of the EMS shell: [leading] widgets, a pill with [actions], and a
/// [logo] at the end. It has no behaviour of its own; the app passes the
/// actions (for example the theme toggle) and the logo.
///
/// Example:
/// ```dart
/// EmsTopBar(
///   leading: [BackButton(onPressed: onBack)],
///   actions: [EmsTopBarAction(icon: Icons.dark_mode, onPressed: toggle)],
///   logo: Image.asset('assets/images/app_logo.png', width: 120, height: 120),
/// )
/// ```
class EmsTopBar extends StatelessWidget implements PreferredSizeWidget {
  /// Creates a top bar.
  const EmsTopBar({
    super.key,
    this.leading = const [],
    this.actions = const [],
    this.logo,
  });

  /// Widgets at the start (left in LTR, right in RTL), e.g. back buttons.
  final List<Widget> leading;

  /// Small actions shown together in a pill after [leading], usually
  /// [EmsTopBarAction]s. The pill is hidden when this is empty.
  final List<Widget> actions;

  /// Brand mark shown at the end of the bar.
  final Widget? logo;

  /// The bar's height.
  static const double height = EmsSizes.topBarHeight;

  @override
  Size get preferredSize => const Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    final c = EmsColors.of(context);
    return SafeArea(
      bottom: false,
      child: Container(
        height: preferredSize.height,
        padding: const EdgeInsets.symmetric(horizontal: EmsSpacing.lg),
        child: Row(
          children: [
            if (leading.isNotEmpty) ...[
              ...leading,
              const SizedBox(width: EmsSpacing.sm),
            ],
            if (actions.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: EmsSpacing.xs),
                decoration: BoxDecoration(
                  color: c.surface,
                  borderRadius: BorderRadius.circular(EmsRadius.full),
                  border: Border.all(color: c.borderSubtle),
                  boxShadow: EmsElevation.level1(c),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: actions),
              ),
            const Spacer(),
            ?logo,
          ],
        ),
      ),
    );
  }
}

/// An icon action for [EmsTopBar.actions].
///
/// Example: `EmsTopBarAction(icon: Icons.dark_mode, onPressed: toggleTheme)`
class EmsTopBarAction extends StatelessWidget {
  /// Creates a top-bar action.
  const EmsTopBarAction({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
  });

  /// The icon to show.
  final IconData icon;

  /// Called when the action is tapped.
  final VoidCallback? onPressed;

  /// Already-localized description of the action.
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final c = EmsColors.of(context);
    // 48 dp hit area (DS-08; was the 20 dp icon only).
    final action = SizedBox.square(
      dimension: EmsSizes.minTap,
      child: EmsTappable(
        onTap: onPressed,
        semanticLabel: tooltip,
        customBorder: const CircleBorder(),
        // Full primary: the 50 % tint was 1.85:1 (C17).
        child: Icon(icon, color: c.primary, size: EmsIconSize.md),
      ),
    );
    return tooltip == null
        ? action
        : Tooltip(message: tooltip, excludeFromSemantics: true, child: action);
  }
}
