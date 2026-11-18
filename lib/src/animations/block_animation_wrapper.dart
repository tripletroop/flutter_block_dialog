import 'package:block_dialog/src/animations/block_animation/block_animation.dart';
import 'package:block_dialog/src/layout/blocks/block.dart';
import 'package:material_ui/material_ui.dart';

class AnimatedBlockWrapper extends StatelessWidget {
  /// Wraps a block with the configured animation.
  final Widget child;
  final BlockPosition? position;
  final AnimationController? animationController;
  final BlockAnimation blockAnimation;

  /// Point (0..1) of the shared animation at which this block starts moving.
  final double staggerStart;

  const AnimatedBlockWrapper({
    super.key,
    required this.child,
    required this.blockAnimation,
    this.position,
    this.animationController,
    this.staggerStart = 0,
  });

  @override
  Widget build(BuildContext context) {
    final controller = animationController;
    if (position == null || controller == null) return child;

    if (MediaQuery.disableAnimationsOf(context)) {
      return FadeTransition(opacity: controller, child: child);
    }

    final Animation<double> driven = staggerStart == 0
        ? controller
        : controller.drive(CurveTween(curve: Interval(staggerStart, 1.0)));

    return blockAnimation.build(
      child: child,
      position: position!,
      animation: driven,
    );
  }
}
