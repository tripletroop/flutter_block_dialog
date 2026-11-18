import 'dart:ui';

import 'package:block_dialog/src/animations/block_animation/block_animation.dart';
import 'package:block_dialog/src/animations/block_animation_utils.dart';
import 'package:block_dialog/src/layout/blocks/block.dart';
import 'package:material_ui/material_ui.dart';

class CinematicBlockAnimation extends BlockAnimation {
  /// Cinematic animation with blur, scale, translation, and perspective tilt.
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

  static final TweenSequence<double> _scaleTween = TweenSequence<double>([
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

  @override
  Widget build({
    required Widget child,
    required BlockPosition position,
    required Animation<double> animation,
  }) {
    final from = BlockAnimationUtils.offsetForPosition(
      position,
      _baseDistance * _distanceMultiplier,
    );

    // Tilt angles at the start of the animation. A horizontal entrance tilts
    // around the Y axis, a vertical one around X, so the perspective shows.
    // Blocks with no offset (middle/full) do not tilt.
    final horizontal = from.dx.abs() >= from.dy.abs();
    final hasOffset = from != Offset.zero;
    final tiltY = hasOffset && horizontal ? -from.dx.sign * _rotation : 0.0;
    final tiltX = hasOffset && !horizontal ? from.dy.sign * _rotation : 0.0;
    final tiltZ = hasOffset
        ? (horizontal
            ? from.dx.sign * _rotation
            : from.dy.sign * _rotation * 0.6)
        : 0.0;

    return AnimatedBuilder(
      animation: animation,
      child: child,
      builder: (_, child) {
        final t = BlockAnimationUtils.directionalCurve(animation);
        final remaining = 1 - t;
        final blur = _blurSigma * remaining;

        final transform = Matrix4.identity()
          ..setEntry(3, 2, _perspective)
          ..rotateX(tiltX * remaining)
          ..rotateY(tiltY * remaining)
          ..rotateZ(tiltZ * remaining);

        return Opacity(
          opacity: BlockAnimationUtils.fadeFor(animation),
          child: Transform(
            alignment: Alignment.center,
            transform: transform,
            child: Transform.translate(
              offset: from * remaining,
              child: Transform.scale(
                scale: _scaleTween.transform(t),
                child: ImageFiltered(
                  enabled: blur > 0.05,
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
