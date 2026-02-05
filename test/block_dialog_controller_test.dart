import 'package:block_dialog/src/core/block_dialog_controller.dart';
import 'package:block_dialog/src/layout/block_row.dart';
import 'package:block_dialog/src/layout/blocks/block.dart';
import 'package:block_dialog/src/theme/dialog_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _ValueBlock extends Block {
  _ValueBlock({required super.resultId, required this.value}) : super(flex: 1);

  final Object? value;

  @override
  dynamic readValue() => value;

  @override
  Widget buildContent(
    BuildContext context,
    BlockDialogController controller,
    DialogConfig configs,
  ) {
    return const SizedBox();
  }
}

void main() {
  test('BlockDialogController collects results from blocks', () {
    final controller = BlockDialogController();
    final animation = AnimationController(
      vsync: const TestVSync(),
      duration: const Duration(milliseconds: 200),
    );

    controller.initialize(
      animationController: animation,
      rows: [
        BlockRow(blocks: [
          _ValueBlock(resultId: 'name', value: 'John'),
          _ValueBlock(resultId: 'age', value: 21),
        ]),
      ],
    );

    final result = controller.collectResults(payload: 'ok');
    expect(result.values['name'], 'John');
    expect(result.values['age'], 21);
    expect(result.payload, 'ok');
  });

  test('BlockDialogController asserts on duplicate resultIds', () {
    final controller = BlockDialogController();
    final animation = AnimationController(
      vsync: const TestVSync(),
      duration: const Duration(milliseconds: 200),
    );

    expect(
      () => controller.initialize(
        animationController: animation,
        rows: [
          BlockRow(blocks: [
            _ValueBlock(resultId: 'dup', value: 1),
            _ValueBlock(resultId: 'dup', value: 2),
          ]),
        ],
      ),
      throwsA(isA<AssertionError>()),
    );
  });
}
