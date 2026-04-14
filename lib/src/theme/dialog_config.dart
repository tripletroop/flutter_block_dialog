import 'package:block_dialog/src/animations/block_animation/block_animation.dart';
import 'package:block_dialog/src/animations/block_animation/slide_block_animation.dart';
import 'package:flutter/material.dart';

class DialogConfig {
  /// Default block background color.
  final Color backgroundColor;

  /// Background color when a block is pressed.
  final Color backgroundColorPressed;

  /// Stroke/border color for blocks.
  final Color strokeColor;

  /// Stroke/border width for blocks.
  final double strokeWidth;

  /// Corner radius for blocks.
  final double borderRadius;

  /// Space between blocks in rows/columns.
  final double blocksSpacing;

  /// Animation applied to blocks on show/hide.
  final BlockAnimation blockAnimation;

  /// Duration of block show/hide animations.
  final Duration animationDuration;

  /// Dimmed background color behind the dialog.
  final Color barrierColor;

  /// Text direction for block content (LTR or RTL).
  final TextDirection textDirection;

  /// Default padding for blocks without individual padding.
  final EdgeInsetsGeometry childsPadding;

  /// Optional fixed width for the dialog content. Default is double.infinity (match parent).
  final double? maxWidth;

  /// Optional fixed height for the dialog content. Default is screen height * 0.8
  final double? maxHeight;

  /// Create a new configuration set for the dialog.
  const DialogConfig({
    this.backgroundColor = const Color(0xFFF8FAFC),
    this.backgroundColorPressed = const Color(0xFFE2E8F0),
    this.strokeColor = const Color(0xFFCBD5E1),
    this.strokeWidth = 1.0,
    this.borderRadius = 20.0,
    this.blocksSpacing = 2.0,
    this.maxWidth,
    this.maxHeight,
    this.textDirection = TextDirection.ltr,
    this.childsPadding = const EdgeInsets.all(5),
    this.animationDuration = const Duration(milliseconds: 400),
    this.blockAnimation = const SlideBlockAnimation(),
    this.barrierColor = const Color(0xB3000000),
  });
}
