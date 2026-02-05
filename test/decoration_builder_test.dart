import 'package:block_dialog/src/utils/decoration_builder.dart';
import 'package:block_dialog/src/layout/blocks/block.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('DecorationBuilder sets radius for top-left position', () {
    final radius = DecorationBuilder.buildBorderRadius(
      position: BlockPosition.topLeft,
      radius: 12,
    );

    expect(radius.topLeft, const Radius.circular(12));
    expect(radius.topRight, Radius.zero);
    expect(radius.bottomLeft, Radius.zero);
    expect(radius.bottomRight, Radius.zero);
  });

  test('DecorationBuilder sets radius for full position', () {
    final radius = DecorationBuilder.buildBorderRadius(
      position: BlockPosition.full,
      radius: 16,
    );

    expect(radius.topLeft, const Radius.circular(16));
    expect(radius.topRight, const Radius.circular(16));
    expect(radius.bottomLeft, const Radius.circular(16));
    expect(radius.bottomRight, const Radius.circular(16));
  });
}
