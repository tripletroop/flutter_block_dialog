import 'package:block_dialog/src/animations/block_animation/block_animation.dart';
import 'package:block_dialog/src/layout/blocks/block.dart';

class BlockOverride {
  /// Override the block position used for border radius.
  BlockPosition? position;

  /// Override the position used for animation direction.
  BlockPosition? animationPosition;

  /// Use a custom animation for this block.
  BlockAnimation? customAnimation;

  /// Construct a block override.
  BlockOverride({
    this.position,
    this.animationPosition,
    this.customAnimation,
  });
}
