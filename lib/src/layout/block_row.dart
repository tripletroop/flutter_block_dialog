import 'package:block_dialog/src/layout/blocks/block.dart';

class BlockRow {
  /// Controls whether this row stays outside the scrollable area.
  ///
  /// - `true`: always frozen.
  /// - `false`: never frozen.
  /// - `null`: use default behavior:
  ///   - first row is frozen when it contains a single [BlockText]
  ///     with `isDialogTitle = true`
  ///   - last row is frozen when it contains only [BlockButton] blocks
  ///
  /// Frozen rows can be placed only at the beginning and/or the end of
  /// the dialog rows list.
  final bool? freeze;

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
    this.freeze,
    this.ignoreInPositionResolving = false,
    this.matchBlocksHeight = false,
    this.width,
  });

  BlockRow copyWith({
    List<Block>? blocks,
    bool? freeze,
    bool? ignoreInPositionResolving,
    bool? matchBlocksHeight,
    double? width,
  }) {
    return BlockRow(
      blocks: blocks ?? this.blocks,
      freeze: freeze ?? this.freeze,
      ignoreInPositionResolving:
          ignoreInPositionResolving ?? this.ignoreInPositionResolving,
      matchBlocksHeight: matchBlocksHeight ?? this.matchBlocksHeight,
      width: width ?? this.width,
    );
  }
}
