import 'package:block_dialog/src/animations/block_animation/depth_parallax_block_animation.dart';
import 'package:block_dialog/src/animations/block_animation/elastic_block_animation.dart';
import 'package:block_dialog/src/animations/block_animation/scale_block_animation.dart';
import 'package:block_dialog/src/animations/block_animation/slide_block_animation.dart';
import 'package:block_dialog/src/animations/block_animation/cinematic_block_animation.dart';
import 'package:block_dialog/src/animations/block_animation/expand_corner_block_animation.dart';
import 'package:block_dialog/src/layout/blocks/block.dart';
import 'package:flutter/material.dart';

abstract class BlockAnimation {
  /// Base class for block entrance/exit animations.
  const BlockAnimation();

  /// Build the animated widget based on [position] and [animation] progress.
  Widget build({
    required Widget child,
    required BlockPosition position,
    required Animation<double> animation,
  });

  /// Slide + fade with optional distance tuning.
  static SlideBlockAnimation slide(
      {double? baseDistance, double? distanceMultiplier}) {
    return SlideBlockAnimation(
        baseDistance: baseDistance, distanceMultiplier: distanceMultiplier);
  }

  /// Scale + fade animation.
  static ScaleBlockAnimation get scale => ScaleBlockAnimation();

  /// Elastic slide animation.
  static ElasticSlideBlockAnimation get elastic => ElasticSlideBlockAnimation();

  /// Depth/parallax scale animation.
  static DepthParallaxBlockAnimation get depth => DepthParallaxBlockAnimation();

  /// Cinematic animation with blur, scale, and perspective.
  static CinematicBlockAnimation cinematic(
      {double? baseDistance,
      double? distanceMultiplier,
      double? rotation,
      double? blurSigma,
      double? perspective}) {
    return CinematicBlockAnimation(
      baseDistance: baseDistance,
      distanceMultiplier: distanceMultiplier,
      rotation: rotation,
      blurSigma: blurSigma,
      perspective: perspective,
    );
  }

  static ExpandCornerBlockAnimation expandFromCorner(
      {double? startScale, double? overshoot}) {
    return ExpandCornerBlockAnimation(
      startScale: startScale,
      overshoot: overshoot,
    );
  }
}
