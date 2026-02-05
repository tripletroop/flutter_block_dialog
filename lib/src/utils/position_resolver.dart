import 'package:block_dialog/src/layout/blocks/block.dart';

class PositionResolvingData {
  /// Zero-based row index of the block.
  final int rowIndex;

  /// Total row count.
  final int rowCount;

  /// Zero-based column index of the block.
  final int columnIndex;

  /// Total column count for this row.
  final int columnCount;

  PositionResolvingData({
    required this.rowIndex,
    required this.rowCount,
    required this.columnIndex,
    required this.columnCount,
  });
}

class PositionResolver {
  /// Resolve the [BlockPosition] based on grid coordinates.
  static BlockPosition resolve(PositionResolvingData data) {
    // Single block
    if (data.rowCount == 1 && data.columnCount == 1) {
      return BlockPosition.full;
    }

    final isTop = data.rowIndex == 0;
    final isBottom = data.rowIndex == data.rowCount - 1;
    final isLeft = data.columnIndex == 0;
    final isRight = data.columnIndex == data.columnCount - 1;

    // Edges
    if (isTop && isLeft && isRight) return BlockPosition.top;
    if (isBottom && isLeft && isRight) return BlockPosition.bottom;

    // Corners
    if (isTop && isLeft) return BlockPosition.topLeft;
    if (isTop && isRight) return BlockPosition.topRight;
    if (isBottom && isLeft) return BlockPosition.bottomLeft;
    if (isBottom && isRight) return BlockPosition.bottomRight;

    if (data.columnCount > 1) {
      if (isLeft) return BlockPosition.middleLeft;
      if (isRight) return BlockPosition.middleRight;
    }
    return BlockPosition.middle;
  }
}
