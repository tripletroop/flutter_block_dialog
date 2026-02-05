import 'package:block_dialog/src/animations/block_animation/block_animation.dart';
import 'package:block_dialog/src/layout/blocks/block.dart';
import 'package:flutter/material.dart';

class AnimatedBlockWrapper extends StatelessWidget {
  /// Wraps a block with the configured animation.
  final Widget child;
  final BlockPosition? position;
  final AnimationController? controller;
  final BlockAnimation animation;

  const AnimatedBlockWrapper({
    super.key,
    required this.child,
    required this.animation,
    this.position,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    if (position == null || controller == null) {
      return child;
    }

    final curved = CurvedAnimation(
      parent: controller!,
      curve: Curves.linear,
      reverseCurve: Curves.linear,
    );

    return animation.build(
      child: child,
      position: position!,
      animation: curved,
    );
  }
}
