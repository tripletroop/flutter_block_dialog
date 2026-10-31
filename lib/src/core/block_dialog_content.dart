import 'dart:math';

import 'package:block_dialog/src/core/block_dialog_controller.dart';
import 'package:block_dialog/src/layout/block_row.dart';
import 'package:block_dialog/src/layout/blocks/block_button.dart';
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
    final frozenStates = _resolveFrozenStates(rows);
    if (!_hasValidFrozenRowsPlacement(frozenStates)) {
      throw FlutterError(
        'Frozen rows can only appear at the start and/or end of the rows list.',
      );
    }

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
      child: _buildDialogRows(context, frozenStates),
    );
  }

  Widget _buildDialogRows(BuildContext context, List<bool> frozenStates) {
    if (frozenStates.every((isFrozen) => !isFrozen)) {
      return SingleChildScrollView(
        child: _buildRowsColumn(context, rows),
      );
    }

    final topFrozenCount =
        frozenStates.takeWhile((isFrozen) => isFrozen).length;
    final bottomFrozenCount =
        frozenStates.reversed.takeWhile((isFrozen) => isFrozen).length;
    final middleEnd = rows.length - bottomFrozenCount;
    final middleStart = topFrozenCount > middleEnd ? middleEnd : topFrozenCount;
    final topFrozenRows = rows.take(topFrozenCount).toList(growable: false);
    final middleScrollableRows = rows.sublist(middleStart, middleEnd);
    final bottomFrozenRows =
        rows.skip(middleEnd > middleStart ? middleEnd : topFrozenCount).toList(
              growable: false,
            );

    final sections = <Widget>[];

    void addSection(Widget section) {
      if (sections.isNotEmpty) {
        sections.add(SizedBox(height: configs.blocksSpacing));
      }
      sections.add(section);
    }

    if (topFrozenRows.isNotEmpty) {
      addSection(_buildRowsColumn(context, topFrozenRows));
    }
    if (middleScrollableRows.isNotEmpty) {
      addSection(
        Flexible(
          child: SingleChildScrollView(
            child: _buildRowsColumn(context, middleScrollableRows),
          ),
        ),
      );
    }
    if (bottomFrozenRows.isNotEmpty) {
      addSection(_buildRowsColumn(context, bottomFrozenRows));
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: sections,
    );
  }

  Widget _buildRowsColumn(BuildContext context, List<BlockRow> rowsSection) {
    return Column(
      children: rowsSection
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
    );
  }

  bool _hasValidFrozenRowsPlacement(List<bool> frozenStates) {
    var seenNonFrozen = false;
    var seenFrozenAfterNonFrozen = false;
    for (final isFrozen in frozenStates) {
      if (isFrozen) {
        if (seenNonFrozen) {
          seenFrozenAfterNonFrozen = true;
        }
        continue;
      }
      seenNonFrozen = true;
      if (seenFrozenAfterNonFrozen) {
        return false;
      }
    }
    return true;
  }

  List<bool> _resolveFrozenStates(List<BlockRow> rows) {
    final lastIndex = rows.length - 1;
    return List<bool>.generate(rows.length, (index) {
      final row = rows[index];
      if (row.freeze != null) {
        return row.freeze!;
      }

      if (index == 0 &&
          row.blocks.length == 1 &&
          row.blocks.single is BlockText &&
          (row.blocks.single as BlockText).isDialogTitle) {
        return true;
      }

      if (index == lastIndex &&
          row.blocks.isNotEmpty &&
          row.blocks.every((block) => block is BlockButton)) {
        return true;
      }

      return false;
    });
  }

  Widget _buildRow(
      BuildContext context, BlockRow blocksRow, double blockMinHeight) {
    return Row(
      textDirection: configs.textDirection,
      crossAxisAlignment: blocksRow.matchBlocksHeight
          ? CrossAxisAlignment.stretch
          : CrossAxisAlignment.center,
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
