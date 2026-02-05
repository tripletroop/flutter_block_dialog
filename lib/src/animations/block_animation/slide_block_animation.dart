import 'package:block_dialog/src/animations/block_animation/block_animation.dart';
import 'package:block_dialog/src/layout/blocks/block.dart';
import 'package:flutter/material.dart';

class SlideBlockAnimation extends BlockAnimation {
  /// Slide + fade + subtle scale/rotation.
  final double _baseDistance;
  final double _distanceMultiplier;
  final double _startScale;
  final double _rotation;

  const SlideBlockAnimation({
    double? baseDistance,
    double? distanceMultiplier,
    double? startScale,
    double? rotation,
  })  : _baseDistance = baseDistance ?? 100.0,
        _distanceMultiplier = distanceMultiplier ?? 1.0,
        _startScale = startScale ?? 0.96,
        _rotation = rotation ?? 0.05;

  Offset _offsetForPosition(BlockPosition position, double distance) {
    switch (position) {
      case BlockPosition.top:
        return Offset(0, -distance);
      case BlockPosition.bottom:
        return Offset(0, distance);
      case BlockPosition.topLeft:
        return Offset(-distance, -distance);
      case BlockPosition.topRight:
        return Offset(distance, -distance);
      case BlockPosition.bottomLeft:
        return Offset(-distance, distance);
      case BlockPosition.bottomRight:
        return Offset(distance, distance);
      case BlockPosition.middleLeft:
        return Offset(-distance, 0);
      case BlockPosition.middleRight:
        return Offset(distance, 0);
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
    final fromOffset =
        _offsetForPosition(position, _baseDistance * _distanceMultiplier);
    final curved = CurvedAnimation(
      parent: animation,
      curve: Curves.linear,
      reverseCurve: Curves.linear,
    );

    final scaleTween = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: _startScale, end: 1.02)
            .chain(CurveTween(curve: Curves.linear)),
        weight: 60,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.02, end: 1.0)
            .chain(CurveTween(curve: Curves.linear)),
        weight: 40,
      ),
    ]);

    final rotation = (fromOffset.dx.abs() >= fromOffset.dy.abs()
                ? fromOffset.dx
                : fromOffset.dy)
            .sign *
        _rotation;

    return AnimatedBuilder(
      animation: curved,
      builder: (_, __) {
        final value = curved.value;
        final scale = scaleTween.evaluate(curved);
        final transform = Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateZ(rotation * (1 - value));
        return Opacity(
          opacity: value,
          child: Transform(
            alignment: Alignment.center,
            transform: transform,
            child: Transform.translate(
              offset: Offset(
                fromOffset.dx * (1 - value),
                fromOffset.dy * (1 - value),
              ),
              child: Transform.scale(
                scale: scale,
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }
}
