import 'package:flutter/material.dart';
import '../tokens/tokens.dart';
import 'ems_tappable.dart';
import '../l10n/ems_localizations.dart';

/// Status of an [EmsNotificationItem]. Renamed from `NotificationStatus` in
/// 0.1.0 (DS-20) so it can't clash with app models.
enum EmsNotificationStatus {
  /// A new dispatch: danger tone, Report enabled.
  now,

  /// Under way: warning tone.
  inProgress,

  /// Finished: neutral tone.
  completed,
}

/// Notification list row with status badge, location, time, and actions.
class EmsNotificationItem extends StatelessWidget {
  /// Primary line: the incident location.
  final String location;

  /// Secondary line: the region.
  final String region;

  /// Already-localized relative time (e.g. "5 min ago").
  final String timeAgo;

  /// Status; picks the badge tone and enables Report for [EmsNotificationStatus.now].
  final EmsNotificationStatus status;

  /// Already-localized label of [status] (e.g. "Dispatch", "In Progress").
  final String statusLabel;

  /// Already-localized label of the follow-trip action.
  final String followLabel;

  /// Already-localized label of the report action.
  final String reportLabel;

  /// Gives the row a 2 dp primary outline (e.g. an unread item).
  final bool isHighlighted;

  /// Opens the item.
  final VoidCallback? onTap;

  /// The follow-trip action.
  final VoidCallback? onFollow;

  /// The report action (enabled only while [status] is `now`).
  final VoidCallback? onReport;

  /// Creates a notification row.
  const EmsNotificationItem({
    super.key,
    required this.location,
    required this.region,
    required this.timeAgo,
    this.status = EmsNotificationStatus.completed,
    required this.statusLabel,
    required this.followLabel,
    required this.reportLabel,
    this.isHighlighted = false,
    this.onTap,
    this.onFollow,
    this.onReport,
  });

  @override
  Widget build(BuildContext context) {
    final c = EmsColors.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: EmsSpacing.xl,
        vertical: EmsSpacing.lg,
      ),
      margin: const EdgeInsets.only(bottom: EmsSpacing.sm),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(EmsRadius.lg),
        border: Border.all(
          color: isHighlighted ? c.primary : c.borderSubtle,
          width: isHighlighted ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          // ── Left: back arrow + actions ──
          _CircleIconButton(icon: Icons.arrow_back_ios_new, onTap: onTap),
          const SizedBox(width: EmsSpacing.md),
          _FollowTripChip(label: followLabel, onTap: onFollow),
          const SizedBox(width: EmsSpacing.sm),
          _ReportsButton(
            label: reportLabel,
            onTap: onReport,
            isEnabled: status == EmsNotificationStatus.now && onReport != null,
          ),

          // ── Center: location info (takes remaining space) ──
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Text(
                        region,
                        style: EmsTypography.of(
                          context,
                        ).bodySmall.copyWith(color: c.textSecondary),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: EmsSpacing.xs),
                    Text(
                      location,
                      style: EmsTypography.of(context).bodyMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: c.textPrimary,
                      ),
                    ),
                    const SizedBox(width: EmsSpacing.sm),
                    Icon(
                      Icons.location_on,
                      size: EmsIconSize.sm,
                      color: c.accent(EmsAccent.location),
                    ),
                  ],
                ),
                const SizedBox(height: EmsSpacing.xs),
                Text(
                  timeAgo,
                  style: EmsTypography.of(
                    context,
                  ).caption.copyWith(color: c.textHint),
                ),
              ],
            ),
          ),
          const SizedBox(width: EmsSpacing.xl),

          // ── Right: status badge (pinned to end) ──
          _StatusBadge(status: status, label: statusLabel),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// Status badge: tone container + on-container text (≥ 7:1).
// Now = danger, In Progress = warning, Done = neutral.
// ═══════════════════════════════════════════════════════════════
class _StatusBadge extends StatelessWidget {
  final EmsNotificationStatus status;
  final String label;

  const _StatusBadge({required this.status, required this.label});

  @override
  Widget build(BuildContext context) {
    final c = EmsColors.of(context);
    final tone = switch (status) {
      EmsNotificationStatus.now => EmsTone.danger,
      EmsNotificationStatus.inProgress => EmsTone.warning,
      EmsNotificationStatus.completed => EmsTone.neutral,
    };

    return Container(
      constraints: const BoxConstraints(minWidth: 100),
      padding: const EdgeInsets.symmetric(
        horizontal: EmsSpacing.lg,
        vertical: EmsSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: c.toneContainer(tone),
        borderRadius: BorderRadius.circular(EmsRadius.full),
        border: Border.all(
          color: tone == EmsTone.neutral
              ? c.borderSubtle
              : c.tone(tone).withValues(alpha: 0.4),
        ),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: EmsTypography.of(
          context,
        ).labelLarge.copyWith(color: c.onToneContainer(tone)),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// Back arrow circle button
// ═══════════════════════════════════════════════════════════════
class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _CircleIconButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = EmsColors.of(context);
    // 48 dp hit area (DS-08) around a 40 dp circle.
    return SizedBox.square(
      dimension: EmsSizes.minTap,
      child: EmsTappable(
        onTap: onTap,
        semanticLabel: EmsLocalizations.of(context).open,
        customBorder: const CircleBorder(),
        child: Center(
          child: Container(
            width: EmsSizes.avatarRadius * 2,
            height: EmsSizes.avatarRadius * 2,
            decoration: BoxDecoration(
              color: c.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: EmsIconSize.xs,
              color: c.onPrimaryContainer,
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// "Follow Trip" action chip (for active/Now items)
// ═══════════════════════════════════════════════════════════════
class _FollowTripChip extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const _FollowTripChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = EmsColors.of(context);
    final enabled = onTap != null;
    final radius = BorderRadius.circular(EmsRadius.full);
    return Container(
      decoration: BoxDecoration(
        color: enabled ? c.primaryContainer : c.surfaceSunken,
        borderRadius: BorderRadius.circular(EmsRadius.full),
        border: Border.all(
          color: enabled ? c.primary.withValues(alpha: 0.4) : c.borderSubtle,
        ),
      ),
      child: EmsTappable(
        onTap: onTap,
        borderRadius: radius,
        child: Container(
          constraints: const BoxConstraints(minHeight: EmsSizes.chipHeight),
          padding: const EdgeInsets.symmetric(
            horizontal: EmsSpacing.lg,
            vertical: EmsSpacing.sm,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.location_on,
                size: EmsIconSize.xs,
                color: enabled ? c.onPrimaryContainer : c.textDisabled,
              ),
              const SizedBox(width: EmsSpacing.sm),
              Text(
                label,
                style: EmsTypography.of(context).labelLarge.copyWith(
                  color: enabled ? c.onPrimaryContainer : c.textDisabled,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// "Reports" action button (for completed items)
// ═══════════════════════════════════════════════════════════════
class _ReportsButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isEnabled;

  const _ReportsButton({
    required this.label,
    required this.onTap,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final c = EmsColors.of(context);
    final radius = BorderRadius.circular(EmsRadius.full);
    return Container(
      decoration: BoxDecoration(
        color: isEnabled ? c.infoContainer : c.surfaceSunken,
        borderRadius: BorderRadius.circular(EmsRadius.full),
        border: Border.all(
          color: isEnabled ? c.info.withValues(alpha: 0.4) : c.borderSubtle,
        ),
      ),
      child: EmsTappable(
        onTap: isEnabled ? onTap : null,
        borderRadius: radius,
        child: Container(
          constraints: const BoxConstraints(minHeight: EmsSizes.chipHeight),
          padding: const EdgeInsets.symmetric(
            horizontal: EmsSpacing.lg,
            vertical: EmsSpacing.sm,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.description_outlined,
                size: EmsIconSize.xs,
                color: isEnabled ? c.onInfoContainer : c.textDisabled,
              ),
              const SizedBox(width: EmsSpacing.sm),
              Text(
                label,
                style: EmsTypography.of(context).labelLarge.copyWith(
                  color: isEnabled ? c.onInfoContainer : c.textDisabled,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
