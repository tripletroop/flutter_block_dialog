import 'package:block_dialog/src/animations/block_animation/block_animation.dart';
import 'package:block_dialog/src/layout/blocks/block.dart';
import 'package:flutter/material.dart';

class ScaleBlockAnimation extends BlockAnimation {
  /// Scale + fade with a small upward lift.
  final double _lift;

  const ScaleBlockAnimation({double? lift}) : _lift = lift ?? 12;

  double _scaleFor(BlockPosition pos) {
    switch (pos) {
      case BlockPosition.middle:
      case BlockPosition.full:
        return 0.12;
      default:
        return 0.25;
    }
  }

  @override
  Widget build({
    required Widget child,
    required BlockPosition position,
    required Animation<double> animation,
  }) {
    final startScale = _scaleFor(position);
    final curved = CurvedAnimation(
      parent: animation,
      curve: Curves.linear,
      reverseCurve: Curves.linear,
    );

    final scaleTween = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: startScale, end: 1.04)
            .chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 70,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.04, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOutCubic)),
        weight: 30,
      ),
    ]);

    return AnimatedBuilder(
      animation: curved,
      builder: (_, __) {
        final t = curved.value;
        final scale = scaleTween.evaluate(curved);
        return Opacity(
          opacity: Curves.linear.transform(t),
          child: Transform.scale(
            scale: scale,
            child: Transform.translate(
              offset: Offset(0, _lift * (1 - t)),
              child: child,
            ),
          ),
        );
      },
    );
  }
}
