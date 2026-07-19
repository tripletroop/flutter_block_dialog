import 'package:block_dialog/block_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('BlockCheckbox value can be updated by tag through controller', () {
    final controller = BlockDialogController();
    final animation = AnimationController(
      vsync: const TestVSync(),
      duration: const Duration(milliseconds: 200),
    );

    controller.initialize(
      animationController: animation,
      textDirection: TextDirection.ltr,
      rows: [
        BlockRow(
          blocks: [
            BlockCheckbox(
              resultId: 'accept',
              label: 'Accept terms',
              blockTag: 'accept_cb',
              initialValue: false,
            ),
          ],
        ),
      ],
    );

    expect(
        controller.getBlockByTagAs<BlockCheckbox>('accept_cb')!.value, isFalse);

    final updated = controller.setBlockCheckboxValue('accept_cb', true);

    expect(updated, isTrue);
    expect(
        controller.getBlockByTagAs<BlockCheckbox>('accept_cb')!.value, isTrue);
  });

  test('BlockCheckbox enabled can be updated by tag through controller', () {
    final controller = BlockDialogController();
    final animation = AnimationController(
      vsync: const TestVSync(),
      duration: const Duration(milliseconds: 200),
    );

    controller.initialize(
      animationController: animation,
      textDirection: TextDirection.ltr,
      rows: [
        BlockRow(
          blocks: [
            BlockCheckbox(
              resultId: 'accept',
              label: 'Accept terms',
              blockTag: 'accept_cb',
              initialValue: false,
            ),
          ],
        ),
      ],
    );

    expect(controller.getBlockByTagAs<BlockCheckbox>('accept_cb')!.enabled,
        isNull);

    final disabled = controller.setBlockCheckboxEnabled('accept_cb', false);
    expect(disabled, isTrue);
    expect(controller.getBlockByTagAs<BlockCheckbox>('accept_cb')!.enabled,
        isFalse);

    final enabled = controller.setBlockCheckboxEnabled('accept_cb', true);
    expect(enabled, isTrue);
    expect(controller.getBlockByTagAs<BlockCheckbox>('accept_cb')!.enabled,
        isTrue);
  });
}
