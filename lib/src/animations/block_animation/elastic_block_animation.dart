import 'package:block_dialog/src/animations/block_animation/block_animation.dart';
import 'package:block_dialog/src/animations/block_animation_utils.dart';
import 'package:block_dialog/src/layout/blocks/block.dart';
import 'package:material_ui/material_ui.dart';

class ElasticSlideBlockAnimation extends BlockAnimation {
  /// Elastic slide animation with optional scale.
  final double baseDistance;
  final double _startScale;

  const ElasticSlideBlockAnimation(
      {this.baseDistance = 100, double? startScale})
      : _startScale = startScale ?? 0.94;

  @override
  Widget build({
    required Widget child,
    required BlockPosition position,
    required Animation<double> animation,
  }) {
    final from = BlockAnimationUtils.offsetForPosition(position, baseDistance);
    return AnimatedBuilder(
      animation: animation,
      builder: (_, __) {
        final t = BlockAnimationUtils.directionalCurve(
          animation,
          forward: const ElasticOutCurve(0.9),
          reverse: Curves.easeInCubic,
        );
        return Opacity(
          opacity: BlockAnimationUtils.fadeFor(animation),
          child: Transform.translate(
            offset: from * (1 - t),
            child: Transform.scale(
              scale: _startScale + (1 - _startScale) * t,
              child: child,
            ),
          ),
        );
      },
    );
  }
}
