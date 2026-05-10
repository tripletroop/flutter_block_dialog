import 'package:block_dialog/src/utils/intersperse_extension.dart';
import 'package:block_dialog/src/layout/block_row.dart';
import 'package:block_dialog/src/theme/dialog_config.dart';
import 'package:block_dialog/src/core/block_dialog_controller.dart';
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
        maxWidth: configs.maxWidth ?? double.infinity,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: rows
              .map((blocksRow) {
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
                          ),
                        );
                      })
                      .cast<Widget>()
                      .intersperse(SizedBox(width: configs.blocksSpacing))
                      .toList(),
                );
              })
              .cast<Widget>()
              .intersperse(SizedBox(height: configs.blocksSpacing))
              .toList(),
        ),
      ),
    );
  }
}
