import 'package:block_dialog/src/animations/block_animation/block_animation.dart';
import 'package:block_dialog/src/layout/blocks/block.dart';
import 'package:flutter/material.dart';

class DepthParallaxBlockAnimation extends BlockAnimation {
  /// Depth/parallax style scale with gentle tilt and lift.
  final double _lift;
  final double _rotation;

  const DepthParallaxBlockAnimation({double? lift, double? rotation})
      : _lift = lift ?? 18,
        _rotation = rotation ?? 0.03;

  double _zFor(BlockPosition pos) {
    switch (pos) {
      case BlockPosition.middle:
      case BlockPosition.full:
        return 0.85;
      default:
        return 0.92;
    }
  }

  @override
  Widget build({
    required Widget child,
    required BlockPosition position,
    required Animation<double> animation,
  }) {
    final startScale = _zFor(position);
    final curved = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutQuart,
      reverseCurve: Curves.easeInCubic,
    );

    return AnimatedBuilder(
      animation: curved,
      builder: (_, __) {
        final t = curved.value;
        final rotation = _rotation * (1 - t);
        return Opacity(
          opacity: Curves.easeOutCubic.transform(t),
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateX(rotation),
            child: Transform.translate(
              offset: Offset(0, _lift * (1 - t)),
              child: Transform.scale(
                scale: startScale + (1 - startScale) * t,
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }
}
