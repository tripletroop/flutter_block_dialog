import 'package:block_dialog/src/layout/blocks/block.dart';
import 'package:material_ui/material_ui.dart';

class BlockAnimationUtils {
  // animation_utils.dart
  static Offset offsetForPosition(BlockPosition position, double d) {
    switch (position) {
      case BlockPosition.top:
        return Offset(0, -d);
      case BlockPosition.bottom:
        return Offset(0, d);
      case BlockPosition.topLeft:
        return Offset(-d, -d);
      case BlockPosition.topRight:
        return Offset(d, -d);
      case BlockPosition.bottomLeft:
        return Offset(-d, d);
      case BlockPosition.bottomRight:
        return Offset(d, d);
      case BlockPosition.middleLeft:
        return Offset(-d, 0);
      case BlockPosition.middleRight:
        return Offset(d, 0);
      case BlockPosition.middle:
      case BlockPosition.full:
        return Offset.zero;
    }
  }

  /// Eased progress: [forward] while animating in, [reverse] while out.
  /// Reads the controller's status, so there is no CurvedAnimation to dispose.
  static double directionalCurve(
    Animation<double> a, {
    Curve forward = Curves.easeOutCubic,
    Curve reverse = Curves.easeInCubic,
  }) =>
      (a.status == AnimationStatus.reverse ? reverse : forward)
          .transform(a.value);

  /// Opacity that finishes before the motion does. Always within 0..1, so it
  /// stays safe with overshooting curves (Opacity asserts outside 0..1).
  static double fadeFor(Animation<double> a) {
    final out = a.status == AnimationStatus.reverse;
    return (out
            ? const Interval(0.2, 1.0, curve: Curves.easeIn)
            : const Interval(0.0, 0.6, curve: Curves.easeOut))
        .transform(a.value);
  }
}
