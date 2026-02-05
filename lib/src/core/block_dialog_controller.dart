import 'package:block_dialog/src/layout/blocks/block.dart';
import 'package:block_dialog/src/layout/block_row.dart';
import 'package:block_dialog/src/models/blocks_result.dart';
import 'package:block_dialog/src/utils/position_resolver.dart';
import 'package:flutter/material.dart';

class BlockDialogController {
  /// Controller that coordinates block positions, values, and animations.
  BlockDialogController({this.onError, this.onAnimateOutComplete});

  AnimationController? _animation;

  /// Called after the dialog finishes its animate-out.
  final Function(Object? payload)? onAnimateOutComplete;

  /// Called when a block reports a validation error.
  final Function(Object? error)? onError;
  final List<Block> _blocks = [];
  bool isAnimating = false;

  void initialize({
    required AnimationController animationController,
    required List<BlockRow> rows,
  }) {
    _animation = animationController;
    final resolvableRows =
        rows.where((row) => !row.ignoreInPositionResolving).toList();
    for (var rowIndex = 0; rowIndex < resolvableRows.length; rowIndex++) {
      final row = resolvableRows[rowIndex];
      for (var columnIndex = 0;
          columnIndex < row.blocks.length;
          columnIndex++) {
        final block = row.blocks[columnIndex];
        final position = PositionResolvingData(
          rowIndex: rowIndex,
          rowCount: resolvableRows.length,
          columnIndex: columnIndex,
          columnCount: row.blocks.length,
        );
        block.setPositionIfNotProvided(
            resolvedPosition: PositionResolver.resolve(position));
      }
    }
    for (final unresolvedBlock in rows
        .where((row) => row.ignoreInPositionResolving)
        .expand((row) => row.blocks)) {
      unresolvedBlock.setPositionIfNotProvided(
          resolvedPosition: BlockPosition.middle);
    }
    _blocks.addAll(rows.expand((row) => row.blocks));
    assert(
      _validateUniqueResultIds(_blocks),
      'Duplicate Block IDs detected. '
      'Each result-producing block must have a unique id.',
    );
  }

  bool _validateUniqueResultIds(List<Block> blocks) {
    final ids = <String>{};

    for (final block in blocks) {
      if (block.resultId == null) continue;
      if (!ids.add(block.resultId!)) return false;
    }

    return true;
  }

  BlocksResult collectResults({Object? payload}) {
    final values = <String, dynamic>{};
    for (final block in _blocks) {
      final id = block.resultId;
      if (id == null) continue;

      final blockValue = block.readValue();
      if (blockValue == null) continue;

      values[id] = blockValue;
    }
    return BlocksResult(
      dismissReason: DismissReason.button,
      values: values,
      payload: payload,
    );
  }

  AnimationController? get animation => _animation;

  /// Play the animate-in sequence.
  void animateIn() {
    _animation?.forward();
  }

  /// Play the animate-out sequence and return results to the host.
  Future<void> animateOut(BlocksResult results) async {
    if (isAnimating) return;
    isAnimating = true;
    await _animation?.reverse();
    onAnimateOutComplete?.call(results);
  }

  /// Dispose the internal animation controller.
  void dispose() {
    _animation?.dispose();
  }
}
