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
              blockTag: 'accept_cb',
              label: 'Accept terms',
              initialValue: false,
            ),
          ],
        ),
      ],
    );
    final unchecked = controller.setBlockCheckboxValue('accept_cb', false);
    expect(unchecked, isTrue);

    final checked = controller.setBlockCheckboxValue('accept_cb', true);
    expect(checked, isTrue);
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
              blockTag: 'accept_cb',
              label: 'Accept terms',
              initialValue: false,
            ),
          ],
        ),
      ],
    );
    final disabled = controller.setBlockCheckboxEnabled('accept_cb', false);
    expect(disabled, isTrue);

    final enabled = controller.setBlockCheckboxEnabled('accept_cb', true);
    expect(enabled, isTrue);
  });
}
