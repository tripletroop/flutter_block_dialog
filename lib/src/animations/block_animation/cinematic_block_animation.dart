import 'dart:ui';

import 'package:block_dialog/src/animations/block_animation/block_animation.dart';
import 'package:block_dialog/src/layout/blocks/block.dart';
import 'package:flutter/material.dart';

class CinematicBlockAnimation extends BlockAnimation {
  /// Cinematic animation with blur, scale, translation, and perspective.
  final double _baseDistance;
  final double _distanceMultiplier;
  final double _rotation;
  final double _blurSigma;
  final double _perspective;

  const CinematicBlockAnimation({
    double? baseDistance,
    double? distanceMultiplier,
    double? rotation,
    double? blurSigma,
    double? perspective,
  })  : _perspective = perspective ?? 0.0015,
        _blurSigma = blurSigma ?? 6,
        _distanceMultiplier = distanceMultiplier ?? 1.0,
        _rotation = rotation ?? 0.06,
        _baseDistance = baseDistance ?? 90;

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

  double _rotationForOffset(Offset from) {
    if (from.dx == 0 && from.dy == 0) return 0;
    if (from.dx.abs() >= from.dy.abs()) {
      return from.dx.sign * _rotation;
    }
    return from.dy.sign * _rotation * 0.6;
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

    final from =
        _offsetForPosition(position, _baseDistance * _distanceMultiplier);
    final rotationZ = _rotationForOffset(from);

    final scaleTween = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.92, end: 1.02)
            .chain(CurveTween(curve: Curves.easeOutQuad)),
        weight: 65,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.02, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOutCubic)),
        weight: 35,
      ),
    ]);

    return AnimatedBuilder(
      animation: curved,
      builder: (_, __) {
        final t = curved.value;
        final scale = scaleTween.evaluate(curved);
        final blur = _blurSigma * (1 - t);
        final translate = Offset(from.dx * (1 - t), from.dy * (1 - t));

        final transform = Matrix4.identity()
          ..setEntry(3, 2, _perspective)
          ..rotateZ(rotationZ * (1 - t));

        return Opacity(
          opacity: t,
          child: Transform(
            alignment: Alignment.center,
            transform: transform,
            child: Transform.translate(
              offset: translate,
              child: Transform.scale(
                scale: scale,
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
                  child: child,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
