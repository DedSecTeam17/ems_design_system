import 'package:flutter/material.dart';
import '../tokens/tokens.dart';

/// Profile avatar with optional online indicator.
class EmsAvatar extends StatelessWidget {
  /// Network image URL. When null the avatar shows [initials].
  final String? imageUrl;

  /// Initials shown when there is no image (e.g. `AB`).
  final String? initials;

  /// Radius of the circle. Defaults to [EmsSizes.avatarRadius].
  final double radius;

  /// Shows a success-coloured dot at the end corner (mirrors in RTL).
  final bool showOnlineIndicator;

  /// Creates an avatar.
  const EmsAvatar({
    super.key,
    this.imageUrl,
    this.initials,
    this.radius = EmsSizes.avatarRadius,
    this.showOnlineIndicator = false,
  });

  @override
  Widget build(BuildContext context) {
    final c = EmsColors.of(context);
    return Stack(
      children: [
        CircleAvatar(
          radius: radius,
          backgroundColor: c.primaryContainer,
          backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
          child: imageUrl == null
              ? Text(
                  initials ?? '',
                  // Initials scale with the avatar, not with the text scale.
                  textScaler: TextScaler.noScaling,
                  style: EmsTypography.of(context).labelLarge.copyWith(
                    fontSize: radius * 0.7,
                    height: 1,
                    color: c.onPrimaryContainer,
                  ),
                )
              : null,
        ),
        if (showOnlineIndicator)
          PositionedDirectional(
            end: 0,
            bottom: 0,
            child: Container(
              width: radius * 0.5,
              height: radius * 0.5,
              decoration: BoxDecoration(
                color: c.success,
                shape: BoxShape.circle,
                border: Border.all(color: c.surface, width: 2),
              ),
            ),
          ),
      ],
    );
  }
}
