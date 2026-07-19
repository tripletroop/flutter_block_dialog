import 'package:block_dialog/src/layout/blocks/block.dart';

class BlockRow {
  /// If true, skip auto position resolving for these blocks.
  final bool ignoreInPositionResolving;

  /// Blocks displayed in this row.
  List<Block> blocks;
  double? width;

  /// if true then the blocks in this row will have the same height, which is the height of the tallest block in the row.
  /// only set this to true when you cant calculate and set the height of the blocks in the row, otherwise leave it false and let the blocks calculate their own height.
  /// because it will use class [IntrinsicHeight] which is relatively expensive. and we should avoid using it where possible
  bool matchBlocksHeight;

  /// Create a row of blocks.
  BlockRow({
    required this.blocks,
    this.ignoreInPositionResolving = false,
    this.matchBlocksHeight = false,
    this.width,
  });
}
