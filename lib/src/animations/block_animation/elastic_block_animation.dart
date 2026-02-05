import 'package:block_dialog/src/animations/block_animation/block_animation.dart';
import 'package:block_dialog/src/layout/blocks/block.dart';
import 'package:flutter/material.dart';

class ElasticSlideBlockAnimation extends BlockAnimation {
  /// Elastic slide animation with optional scale.
  final double baseDistance;
  final double _startScale;

  const ElasticSlideBlockAnimation({this.baseDistance = 100, double? startScale})
      : _startScale = startScale ?? 0.94;

  Offset _offset(BlockPosition pos, double d) {
    switch (pos) {
      case BlockPosition.top:
        return Offset(0, -d);
      case BlockPosition.bottom:
        return Offset(0, d);
      case BlockPosition.middleLeft:
        return Offset(-d, 0);
      case BlockPosition.middleRight:
        return Offset(d, 0);
      default:
        return Offset.zero;
    }
  }

  @override
  Widget build({
    required Widget child,
    required BlockPosition position,
    required Animation<double> animation,
  }) {
    final elastic = CurvedAnimation(
      parent: animation,
      curve: Curves.linear,
      reverseCurve: Curves.linear,
    );

    final from = _offset(position, baseDistance);

    return AnimatedBuilder(
      animation: elastic,
      builder: (_, __) {
        final t = elastic.value;
        final scale = _startScale + (1 - _startScale) * t;
        return Opacity(
          opacity: Curves.linear.transform(t),
          child: Transform.translate(
            offset: from * (1 - t),
            child: Transform.scale(
              scale: scale,
              child: child,
            ),
          ),
        );
      },
    );
  }
}
