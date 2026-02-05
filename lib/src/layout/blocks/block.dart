import 'package:block_dialog/src/animations/block_animation_wrapper.dart';
import 'package:block_dialog/src/layout/blocks/block_custom.dart';
import 'package:block_dialog/src/layout/blocks/block_spacer.dart';
import 'package:block_dialog/src/models/block_override.dart';
import 'package:block_dialog/src/theme/dialog_config.dart';
import 'package:block_dialog/src/utils/decoration_builder.dart';
import 'package:block_dialog/src/core/block_dialog_controller.dart';
import 'package:flutter/material.dart';

/// Resolved position of a block inside the dialog grid.
enum BlockPosition {
  top,
  topLeft,
  topRight,
  middle,
  middleLeft,
  middleRight,
  bottom,
  bottomLeft,
  bottomRight,
  full,
}

abstract class Block {
  /// Flex factor when the block is laid out inside a [BlockRow].
  final int flex;

  /// Resolved position for border radius and animation direction.
  BlockPosition? _position;

  /// Optional overrides for position/animation on a per-block basis.
  BlockOverride? override;

  /// Minimum height for this block.
  final double minHeight;

  /// Optional key used to store this block's value in [BlocksResult.values].
  final String? resultId;

  Block({
    required this.flex,
    this.resultId,
    this.override,
    this.minHeight = 50,
  }) : _position = override?.position;

  /// Build the widget content for this block.
  @protected
  Widget buildContent(
    BuildContext context,
    BlockDialogController controller,
    DialogConfig configs,
  );

  /// Set the resolved [BlockPosition] if not already provided.
  void setPositionIfNotProvided({
    required BlockPosition resolvedPosition,
  }) {
    _position ??= resolvedPosition;
  }

  /// Read the value this block contributes to [BlocksResult.values].
  dynamic readValue() => const {};

  /// The resolved radius used for clipping and block decoration.
  BorderRadius get borderRadius => DecorationBuilder.buildBorderRadius(
        position: _position,
      );

  /// The resolved position for derived widgets that need it.
  @protected
  BlockPosition? get blockPosition => _position;

  /// Whether this block should use the dialog's background/stroke decoration.
  bool _shouldAddDecoration() {
    if (this is BlockCustom) {
      return !(this as BlockCustom).matchDialogTheme;
    }
    if (this is BlockSpacer) {
      return false;
    }
    return true;
  }

  /// Build the full block widget with decoration and animation.
  Widget build(
    BuildContext context,
    BlockDialogController controller,
    DialogConfig configs,
  ) {
    return AnimatedBlockWrapper(
      position: override?.animationPosition ?? _position,
      controller: controller.animation,
      animation: override?.customAnimation ?? configs.blockAnimation,
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(minHeight: minHeight),
        decoration: _shouldAddDecoration()
            ? DecorationBuilder.build(
                borderRadius: borderRadius,
                configs: configs,
              )
            : null,
        child: buildContent(context, controller, configs),
      ),
    ).build(context);
  }
}
