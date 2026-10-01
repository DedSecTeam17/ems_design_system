import 'package:flutter/material.dart';
import '../tokens/tokens.dart';

/// Skeleton placeholder with a shimmer that sweeps in the reading direction.
/// It is excluded from semantics and stops when animations are disabled.
///
/// Example: `EmsShimmerBox(width: 120, height: 16)`
class EmsShimmerBox extends StatefulWidget {
  /// Width of the box.
  final double width;

  /// Height of the box.
  final double height;

  /// Corner radius.
  final BorderRadius borderRadius;

  /// Creates a shimmer box.
  const EmsShimmerBox({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(EmsRadius.sm)),
  });

  @override
  State<EmsShimmerBox> createState() => _EmsShimmerBoxState();
}

class _EmsShimmerBoxState extends State<EmsShimmerBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: EmsMotion.shimmerDuration,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reduced motion: a still placeholder instead of a sweeping one (DS-30).
    if (EmsMotion.of(context).enabled) {
      if (!_controller.isAnimating) _controller.repeat();
    } else {
      _controller
        ..stop()
        ..value = 0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = EmsColors.of(context);
    // Skeleton tokens are visible in both themes (DS-29).
    final base = c.skeletonBase;
    final highlight = c.skeletonHighlight;

    // Decorative: nothing to announce.
    return ExcludeSemantics(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {
          final t = _controller.value;
          return Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              borderRadius: widget.borderRadius,
              gradient: LinearGradient(
                // Directional: the sweep follows the reading direction.
                begin: AlignmentDirectional(-1.0 + (2.0 * t), -0.25),
                end: AlignmentDirectional(1.0 + (2.0 * t), 0.25),
                colors: [base, highlight, base],
                stops: const [0.2, 0.5, 0.8],
              ),
            ),
          );
        },
      ),
    );
  }
}
