import 'package:block_dialog/src/animations/block_animation/block_animation.dart';
import 'package:block_dialog/src/animations/block_animation_utils.dart';
import 'package:block_dialog/src/layout/blocks/block.dart';
import 'package:material_ui/material_ui.dart';

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

  @override
  Widget build({
    required Widget child,
    required BlockPosition position,
    required Animation<double> animation,
  }) {
    final from = BlockAnimationUtils.offsetForPosition(
        position, _baseDistance * _distanceMultiplier);
    final tilt =
        (from.dx.abs() >= from.dy.abs() ? from.dx : from.dy).sign * _rotation;

    return AnimatedBuilder(
      animation: animation,
      child: child,
      builder: (_, child) {
        final t = BlockAnimationUtils.directionalCurve(animation);
        return Opacity(
          opacity: BlockAnimationUtils.fadeFor(animation),
          child: Transform.translate(
            offset: from * (1 - t),
            child: Transform.rotate(
              angle: tilt * (1 - t),
              child: Transform.scale(
                scale: _startScale + (1 - _startScale) * t,
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }
}
