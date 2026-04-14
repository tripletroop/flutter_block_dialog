import 'dart:math' as math;

import 'package:flutter/material.dart';

class BlockShakeWrapper extends StatelessWidget {
  const BlockShakeWrapper(
      {super.key, required this.shakeTick, required this.child});

  final ValueNotifier<int> shakeTick;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: shakeTick,
      builder: (_, shakeTick, child) {
        if (shakeTick == 0 || child == null) {
          return child ?? const SizedBox.shrink();
        }

        return TweenAnimationBuilder<double>(
          key: ValueKey<int>(shakeTick),
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(milliseconds: 420),
          curve: Curves.easeOut,
          child: child,
          builder: (context, value, child) {
            final wave = math.sin(value * math.pi * 6);
            final damping = 1 - value;
            final dx = wave * 12 * damping;
            return Transform.translate(
              offset: Offset(dx, 0),
              child: child,
            );
          },
        );
      },
      child: child,
    );
  }
}
