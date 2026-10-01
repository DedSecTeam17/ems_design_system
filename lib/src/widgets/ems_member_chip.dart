import 'package:flutter/material.dart';
import '../tokens/tokens.dart';

/// Crew member chip with avatar, name and an optional role (Ready State).
///
/// The role is its own text slot in `textSecondary`; the chip no longer
/// builds `'name (role)'`, which couldn't be localized (DS-33).
///
/// Example: `EmsMemberChip(name: name, role: roleLabel, initials: 'AB')`
class EmsMemberChip extends StatelessWidget {
  /// The member's name.
  final String name;

  /// Already-localized role, shown after the name in `textSecondary`.
  final String? role;

  /// Initials in the avatar. Take precedence over [avatarIcon].
  final String? initials;

  /// Icon in the avatar when [initials] is null. Defaults to a person icon.
  final IconData? avatarIcon;

  /// Creates a member chip.
  const EmsMemberChip({
    super.key,
    required this.name,
    this.role,
    this.initials,
    this.avatarIcon,
  });

  @override
  Widget build(BuildContext context) {
    final c = EmsColors.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: EmsSpacing.md,
        vertical: EmsSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(EmsRadius.full),
        border: Border.all(color: c.borderSubtle),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Avatar
          CircleAvatar(
            radius: 14,
            backgroundColor: c.primaryContainer,
            child: initials != null
                ? Text(
                    initials!,
                    style: EmsTypography.of(
                      context,
                    ).labelMedium.copyWith(color: c.onPrimaryContainer),
                  )
                : Icon(
                    avatarIcon ?? Icons.person_outline,
                    size: EmsIconSize.xs,
                    color: c.onPrimaryContainer,
                  ),
          ),
          const SizedBox(width: EmsSpacing.sm),
          Text(
            name,
            style: EmsTypography.of(context).bodySmall.copyWith(
              color: c.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (role != null) ...[
            const SizedBox(width: EmsSpacing.xs),
            Text(
              role!,
              style: EmsTypography.of(
                context,
              ).bodySmall.copyWith(color: c.textSecondary),
            ),
          ],
        ],
      ),
    );
  }
}
