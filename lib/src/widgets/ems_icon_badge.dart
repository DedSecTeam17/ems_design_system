import 'package:flutter/material.dart';
import '../tokens/tokens.dart';

/// Coloured icon in a rounded square (Ready State cards: location, vehicle,
/// equipment, crew).
///
/// Example: `EmsIconBadge(icon: Icons.groups_outlined, accent: EmsAccent.crew)`
class EmsIconBadge extends StatelessWidget {
  /// The icon.
  final IconData icon;

  /// Category colour. Takes precedence over [tone].
  final EmsAccent? accent;

  /// Semantic colour, used when [accent] is null. Defaults to primary.
  final EmsTone? tone;

  /// Side of the square.
  final double size;

  /// Creates a badge.
  const EmsIconBadge({
    super.key,
    required this.icon,
    this.accent,
    this.tone,
    this.size = EmsSizes.iconBadge,
  });

  /// Location badge.
  const EmsIconBadge.location({super.key, this.size = EmsSizes.iconBadge})
    : icon = Icons.location_on_outlined,
      accent = EmsAccent.location,
      tone = null;

  /// Vehicle badge.
  const EmsIconBadge.vehicle({super.key, this.size = EmsSizes.iconBadge})
    : icon = Icons.local_shipping_outlined,
      accent = EmsAccent.vehicle,
      tone = null;

  /// Equipment badge.
  const EmsIconBadge.equipment({super.key, this.size = EmsSizes.iconBadge})
    : icon = Icons.medical_services_outlined,
      accent = EmsAccent.equipment,
      tone = null;

  /// Crew badge.
  const EmsIconBadge.crew({super.key, this.size = EmsSizes.iconBadge})
    : icon = Icons.groups_outlined,
      accent = EmsAccent.crew,
      tone = null;

  Color _resolveColor(EmsColors c) {
    if (accent != null) return c.accent(accent!);
    return c.tone(tone ?? EmsTone.primary);
  }

  @override
  Widget build(BuildContext context) {
    final c = EmsColors.of(context);
    final resolvedColor = _resolveColor(c);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        // A 12 % tint keeps the icon ≥ 3:1 against its fill in both themes.
        color: resolvedColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(EmsRadius.md),
      ),
      child: Icon(icon, color: resolvedColor, size: size * 0.5),
    );
  }
}
