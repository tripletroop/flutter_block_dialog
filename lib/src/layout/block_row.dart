import 'package:block_dialog/src/layout/blocks/block.dart';

class BlockRow {
  /// If true, skip auto position resolving for these blocks.
  final bool ignoreInPositionResolving;

  /// Blocks displayed in this row.
  List<Block> blocks;

  /// Create a row of blocks.
  BlockRow({
    required this.blocks,
    this.ignoreInPositionResolving = false,
  });
}
