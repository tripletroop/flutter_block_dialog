import 'package:block_dialog/src/animations/block_animation/block_animation.dart';
import 'package:block_dialog/src/layout/blocks/block.dart';
import 'package:flutter/material.dart';

class AnimatedBlockWrapper extends StatelessWidget {
  /// Wraps a block with the configured animation.
  final Widget child;
  final BlockPosition? position;
  final AnimationController? animationController;
  final BlockAnimation blockAnimation;

  const AnimatedBlockWrapper({
    super.key,
    required this.child,
    required this.blockAnimation,
    this.position,
    this.animationController,
  });

  @override
  Widget build(BuildContext context) {
    if (position == null || animationController == null) {
      return child;
    }

    final curved = CurvedAnimation(
      parent: animationController!,
      curve: Curves.linear,
      reverseCurve: Curves.linear,
    );

    return blockAnimation.build(
      child: child,
      position: position!,
      animation: curved,
    );
  }
}
