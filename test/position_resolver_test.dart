import 'package:block_dialog/src/utils/position_resolver.dart';
import 'package:block_dialog/src/layout/blocks/block.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('PositionResolver resolves full for a single block', () {
    final position = PositionResolver.resolve(
      PositionResolvingData(
        rowIndex: 0,
        rowCount: 1,
        columnIndex: 0,
        columnCount: 1,
      ),
    );
    expect(position, BlockPosition.full);
  });

  test('PositionResolver resolves corners and edges', () {
    expect(
      PositionResolver.resolve(
        PositionResolvingData(
          rowIndex: 0,
          rowCount: 2,
          columnIndex: 0,
          columnCount: 2,
        ),
      ),
      BlockPosition.topLeft,
    );

    expect(
      PositionResolver.resolve(
        PositionResolvingData(
          rowIndex: 0,
          rowCount: 2,
          columnIndex: 1,
          columnCount: 2,
        ),
      ),
      BlockPosition.topRight,
    );

    expect(
      PositionResolver.resolve(
        PositionResolvingData(
          rowIndex: 1,
          rowCount: 2,
          columnIndex: 0,
          columnCount: 2,
        ),
      ),
      BlockPosition.bottomLeft,
    );

    expect(
      PositionResolver.resolve(
        PositionResolvingData(
          rowIndex: 1,
          rowCount: 2,
          columnIndex: 1,
          columnCount: 2,
        ),
      ),
      BlockPosition.bottomRight,
    );
  });

  test('PositionResolver resolves middle variants', () {
    expect(
      PositionResolver.resolve(
        PositionResolvingData(
          rowIndex: 1,
          rowCount: 3,
          columnIndex: 1,
          columnCount: 3,
        ),
      ),
      BlockPosition.middle,
    );

    expect(
      PositionResolver.resolve(
        PositionResolvingData(
          rowIndex: 1,
          rowCount: 3,
          columnIndex: 0,
          columnCount: 3,
        ),
      ),
      BlockPosition.middleLeft,
    );

    expect(
      PositionResolver.resolve(
        PositionResolvingData(
          rowIndex: 1,
          rowCount: 3,
          columnIndex: 2,
          columnCount: 3,
        ),
      ),
      BlockPosition.middleRight,
    );
  });
}
