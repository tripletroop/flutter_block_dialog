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
  final TextDirection? textDirection;

  /// Default padding for blocks without individual padding.
  /// doesn't affect BlockButton to not mess the pressed background color
  final EdgeInsetsGeometry childrenPadding;

  /// Optional fixed width for the dialog content. Default is screen width * 0.8
  final double? width;

  /// Optional fixed height for the dialog content. Default is screen height * 0.8
  final double? maxHeight;

  /// Optional default text style for all texts in all supported block types.
  final TextStyle? textStyle;

  /// Default minimum height for blocks. Default is 50.
  /// Default will be used for Block types except
  /// BlockText with isDialogTitle = false and it is the only block in its row
  ///  will have a default minimum height of (defaultMinBlockHeight * 2)
  final double defaultMinBlockHeight;

  /// Create a new configuration set for the dialog.
  const DialogConfig({
    this.backgroundColor = const Color(0xFFF8FAFC),
    this.backgroundColorPressed = const Color(0xFFE2E8F0),
    this.strokeColor = const Color(0xFFCBD5E1),
    this.strokeWidth = 1.0,
    this.borderRadius = 20.0,
    this.blocksSpacing = 2.0,
    this.width,
    this.textStyle,
    this.maxHeight,
    this.textDirection,
    this.defaultMinBlockHeight = 50.0,
    this.childrenPadding = const EdgeInsets.all(5),
    this.animationDuration = const Duration(milliseconds: 400),
    this.blockAnimation = const SlideBlockAnimation(),
    this.barrierColor = const Color(0xB3000000),
  });
}
