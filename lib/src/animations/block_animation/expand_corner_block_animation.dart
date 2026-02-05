import 'package:block_dialog/src/animations/block_animation/block_animation.dart';
import 'package:block_dialog/src/layout/blocks/block.dart';
import 'package:flutter/material.dart';

class ExpandCornerBlockAnimation extends BlockAnimation {
  /// Expands from the corner aligned to the block position.
  final double startScale;
  final double overshoot;

  const ExpandCornerBlockAnimation({double? startScale, double? overshoot})
      : startScale = startScale ?? 0.1,
        overshoot = overshoot ?? 0.04;

  Alignment _alignmentForPosition(BlockPosition position) {
    switch (position) {
      case BlockPosition.topLeft:
        return Alignment.topLeft;
      case BlockPosition.top:
        return Alignment.topCenter;
      case BlockPosition.topRight:
        return Alignment.topRight;
      case BlockPosition.middleLeft:
        return Alignment.centerLeft;
      case BlockPosition.middle:
        return Alignment.center;
      case BlockPosition.middleRight:
        return Alignment.centerRight;
      case BlockPosition.bottomLeft:
        return Alignment.bottomLeft;
      case BlockPosition.bottom:
        return Alignment.bottomCenter;
      case BlockPosition.bottomRight:
        return Alignment.bottomRight;
      case BlockPosition.full:
        return Alignment.center;
    }
  }

  @override
  Widget build({
    required Widget child,
    required BlockPosition position,
    required Animation<double> animation,
  }) {
    final curved = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );

    final scaleTween = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: startScale, end: 1 + overshoot)
            .chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 70,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1 + overshoot, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOutCubic)),
        weight: 30,
      ),
    ]);

    final alignment = _alignmentForPosition(position);

    return AnimatedBuilder(
      animation: curved,
      builder: (_, __) {
        final t = curved.value;
        final scale = scaleTween.evaluate(curved);
        return Opacity(
          opacity: Curves.easeOutCubic.transform(t),
          child: Transform.scale(
            alignment: alignment,
            scale: scale,
            child: child,
          ),
        );
      },
    );
  }
}
