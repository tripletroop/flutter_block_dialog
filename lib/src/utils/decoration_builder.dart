import 'package:block_dialog/src/layout/blocks/block.dart';
import 'package:block_dialog/src/theme/dialog_config.dart';
import 'package:flutter/material.dart';

class DecorationBuilder {
  /// Build the default block decoration from [DialogConfig].
  static BoxDecoration build({
    required BorderRadiusGeometry borderRadius,
    DialogConfig configs = const DialogConfig(),
  }) {
    return BoxDecoration(
      color: configs.backgroundColor,
      borderRadius: borderRadius,
      border: Border.all(
        color: configs.strokeColor,
        width: configs.strokeWidth,
      ),
    );
  }

  /// Resolve the border radius for a block based on its position.
  static BorderRadius buildBorderRadius({
    BlockPosition? position,
    double radius = 20,
  }) {
    return BorderRadius.only(
      topLeft: [
        BlockPosition.full,
        BlockPosition.top,
        BlockPosition.topLeft,
      ].contains(position)
          ? Radius.circular(radius)
          : Radius.zero,
      topRight: [
        BlockPosition.full,
        BlockPosition.top,
        BlockPosition.topRight,
      ].contains(position)
          ? Radius.circular(radius)
          : Radius.zero,
      bottomLeft: [
        BlockPosition.full,
        BlockPosition.bottom,
        BlockPosition.bottomLeft,
      ].contains(position)
          ? Radius.circular(radius)
          : Radius.zero,
      bottomRight: [
        BlockPosition.full,
        BlockPosition.bottom,
        BlockPosition.bottomRight,
      ].contains(position)
          ? Radius.circular(radius)
          : Radius.zero,
    );
  }
}
