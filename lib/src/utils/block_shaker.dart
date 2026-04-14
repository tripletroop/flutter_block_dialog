import 'package:block_dialog/src/layout/blocks/block.dart';

class BlockShaker {
  final List<Block> _blocks;

  BlockShaker(this._blocks);

  void shakeBlock(String blockTag) {
    final block = _blocks
        .cast<Block?>()
        .firstWhere((b) => b?.blockTag == blockTag, orElse: () => null);
    block?.shake();
  }
}
