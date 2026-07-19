import 'dart:math';

import 'package:block_dialog/src/core/block_dialog_controller.dart';
import 'package:block_dialog/src/layout/block_row.dart';
import 'package:block_dialog/src/layout/blocks/block_text.dart';
import 'package:block_dialog/src/theme/dialog_config.dart';
import 'package:block_dialog/src/utils/intersperse_extension.dart';
import 'package:flutter/material.dart';

class BlockDialogContent extends StatelessWidget {
  /// Pure widget that lays out the rows of blocks.
  const BlockDialogContent({
    super.key,
    required this.rows,
    required this.controller,
    this.configs = const DialogConfig(),
  });

  /// Rows displayed in order.
  final List<BlockRow> rows;

  /// Controller used for block interactions/animations.
  final BlockDialogController controller;

  /// Visual styling and animation configuration for the dialog and all the children blocks.
  final DialogConfig configs;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final availableHeight =
        (mediaQuery.size.height - mediaQuery.viewInsets.bottom)
            .clamp(0.0, double.infinity);
    final maxHeight = availableHeight * 0.8;
    final effectiveMaxHeight =
        (configs.maxHeight ?? maxHeight).clamp(0.0, availableHeight);
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: effectiveMaxHeight,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: rows
              .map((blocksRow) {
                final rowMinHeight = blocksRow.blocks.map<double>((block) {
                  if (block.minHeight != null) {
                    return block.minHeight!;
                  }
                  if (block is BlockText &&
                      !block.isDialogTitle &&
                      !block.dontExpand &&
                      blocksRow.blocks.length == 1) {
                    return configs.defaultMinBlockHeight * 2;
                  }
                  return configs.defaultMinBlockHeight;
                }).reduce(max);
                return ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: blocksRow.width ??
                          configs.width ??
                          MediaQuery.of(context).size.width * 0.8,
                      minHeight: rowMinHeight),
                  child: blocksRow.matchBlocksHeight
                      ? IntrinsicHeight(
                          child: _buildRow(context, blocksRow, rowMinHeight),
                        )
                      : _buildRow(context, blocksRow, rowMinHeight),
                );
              })
              .cast<Widget>()
              .intersperse(SizedBox(height: configs.blocksSpacing))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildRow(
      BuildContext context, BlockRow blocksRow, double blockMinHeight) {
    return Row(
      textDirection: configs.textDirection,
      children: blocksRow.blocks
          .map((block) {
            return Flexible(
              flex: block.flex,
              child: block.build(
                context,
                controller,
                configs,
                blockMinHeight,
              ),
            );
          })
          .cast<Widget>()
          .intersperse(SizedBox(width: configs.blocksSpacing))
          .toList(),
    );
  }
}
