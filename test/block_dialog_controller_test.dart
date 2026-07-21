import 'package:block_dialog/src/core/block_dialog_controller.dart';
import 'package:block_dialog/src/layout/block_row.dart';
import 'package:block_dialog/src/layout/blocks/block.dart';
import 'package:block_dialog/src/layout/blocks/block_button.dart';
import 'package:block_dialog/src/layout/blocks/block_checkbox.dart';
import 'package:block_dialog/src/layout/blocks/block_input_field.dart';
import 'package:block_dialog/src/layout/blocks/block_radio_group.dart';
import 'package:block_dialog/src/layout/blocks/block_text.dart';
import 'package:block_dialog/src/theme/dialog_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _ValueBlock extends Block {
  _ValueBlock({required super.blockTag, required this.value}) : super(flex: 1);

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
      textDirection: TextDirection.ltr,
      rows: [
        BlockRow(blocks: [
          _ValueBlock(blockTag: 'name', value: 'John'),
          _ValueBlock(blockTag: 'age', value: 21),
        ]),
      ],
    );

    final result = controller.collectResults(payload: 'ok');
    expect(result.values['name'], 'John');
    expect(result.values['age'], 21);
    expect(result.payload, 'ok');
  });

  test('BlockDialogController asserts on duplicate blockTags', () {
    final controller = BlockDialogController();
    final animation = AnimationController(
      vsync: const TestVSync(),
      duration: const Duration(milliseconds: 200),
    );

    expect(
      () => controller.initialize(
        animationController: animation,
        textDirection: TextDirection.ltr,
        rows: [
          BlockRow(blocks: [
            _ValueBlock(blockTag: 'dup', value: 1),
            _ValueBlock(blockTag: 'dup', value: 2),
          ]),
        ],
      ),
      throwsA(isA<AssertionError>()),
    );
  });

  test('BlockDialogController can get typed block by tag', () {
    final controller = BlockDialogController();
    final animation = AnimationController(
      vsync: const TestVSync(),
      duration: const Duration(milliseconds: 200),
    );

    controller.initialize(
      animationController: animation,
      textDirection: TextDirection.ltr,
      rows: [
        BlockRow(blocks: [
          BlockText('hello', blockTag: 'title'),
        ]),
      ],
    );

    final textBlock = controller.getBlockByTagAs<BlockText>('title');
    expect(textBlock, isNotNull);
    expect(textBlock!.text, 'hello');
  });

  test('BlockDialogController can set BlockText text by tag', () {
    final controller = BlockDialogController();
    final animation = AnimationController(
      vsync: const TestVSync(),
      duration: const Duration(milliseconds: 200),
    );

    controller.initialize(
      animationController: animation,
      textDirection: TextDirection.ltr,
      rows: [
        BlockRow(blocks: [
          BlockText('before', blockTag: 'status'),
        ]),
      ],
    );

    final updated = controller.setBlockText('status', 'after');

    expect(updated, isTrue);
    expect(controller.getBlockByTagAs<BlockText>('status')!.text, 'after');
  });

  test('BlockDialogController can set BlockButton label by tag', () {
    final controller = BlockDialogController();
    final animation = AnimationController(
      vsync: const TestVSync(),
      duration: const Duration(milliseconds: 200),
    );

    controller.initialize(
      animationController: animation,
      textDirection: TextDirection.ltr,
      rows: [
        BlockRow(blocks: [
          BlockButton(
            label: 'before',
            blockTag: 'action',
            closeOnPress: false,
            onPressed: (_, __) {},
          ),
        ]),
      ],
    );

    final updated = controller.setBlockButtonLabel('action', 'after');

    expect(updated, isTrue);
    expect(controller.getBlockByTagAs<BlockButton>('action')!.label, 'after');
  });

  test('BlockDialogController can set BlockButton enabled by tag', () {
    final controller = BlockDialogController();
    final animation = AnimationController(
      vsync: const TestVSync(),
      duration: const Duration(milliseconds: 200),
    );

    controller.initialize(
      animationController: animation,
      textDirection: TextDirection.ltr,
      rows: [
        BlockRow(blocks: [
          BlockButton(
            label: 'action',
            blockTag: 'action',
            closeOnPress: false,
            onPressed: (_, __) {},
          ),
        ]),
      ],
    );

    final disabled = controller.setBlockButtonEnabled('action', false);
    expect(disabled, isTrue);
    expect(controller.getBlockByTagAs<BlockButton>('action')!.enabled, isFalse);

    final enabled = controller.setBlockButtonEnabled('action', true);
    expect(enabled, isTrue);
    expect(controller.getBlockByTagAs<BlockButton>('action')!.enabled, isTrue);
  });

  test('BlockDialogController can set BlockCheckbox value by tag', () {
    final controller = BlockDialogController();
    final animation = AnimationController(
      vsync: const TestVSync(),
      duration: const Duration(milliseconds: 200),
    );

    controller.initialize(
      animationController: animation,
      textDirection: TextDirection.ltr,
      rows: [
        BlockRow(blocks: [
          BlockCheckbox(
            blockTag: 'accept_cb',
            label: 'Accept',
            initialValue: false,
          ),
        ]),
      ],
    );

    final updated = controller.setBlockCheckboxValue('accept_cb', true);

    expect(updated, isTrue);
    expect(
        controller.getBlockByTagAs<BlockCheckbox>('accept_cb')!.value, isTrue);
  });

  test('BlockDialogController can set BlockCheckbox enabled by tag', () {
    final controller = BlockDialogController();
    final animation = AnimationController(
      vsync: const TestVSync(),
      duration: const Duration(milliseconds: 200),
    );

    controller.initialize(
      animationController: animation,
      textDirection: TextDirection.ltr,
      rows: [
        BlockRow(blocks: [
          BlockCheckbox(
            label: 'Accept',
            blockTag: 'accept_cb',
            initialValue: false,
          ),
        ]),
      ],
    );

    final disabled = controller.setBlockCheckboxEnabled('accept_cb', false);
    expect(disabled, isTrue);
    expect(
      controller.getBlockByTagAs<BlockCheckbox>('accept_cb')!.enabled,
      isFalse,
    );

    final enabled = controller.setBlockCheckboxEnabled('accept_cb', true);
    expect(enabled, isTrue);
    expect(
      controller.getBlockByTagAs<BlockCheckbox>('accept_cb')!.enabled,
      isTrue,
    );
  });

  test('BlockDialogController can set BlockRadioGroup value by tag', () {
    final controller = BlockDialogController();
    final animation = AnimationController(
      vsync: const TestVSync(),
      duration: const Duration(milliseconds: 200),
    );

    controller.initialize(
      animationController: animation,
      textDirection: TextDirection.ltr,
      rows: [
        BlockRow(blocks: [
          BlockRadioGroup<String>(
            blockTag: 'choice_group',
            options: const ['A', 'B', 'C'],
            initialValue: 'A',
          ),
        ]),
      ],
    );

    final updated =
        controller.setBlockRadioGroupValue<String>('choice_group', 'C');

    expect(updated, isTrue);
    expect(
      controller
          .getBlockByTagAs<BlockRadioGroup<String>>('choice_group')!
          .selectedValue,
      'C',
    );
  });

  test('BlockDialogController can enable/disable radio option by tag', () {
    final controller = BlockDialogController();
    final animation = AnimationController(
      vsync: const TestVSync(),
      duration: const Duration(milliseconds: 200),
    );

    controller.initialize(
      animationController: animation,
      textDirection: TextDirection.ltr,
      rows: [
        BlockRow(blocks: [
          BlockRadioGroup<String>(
            blockTag: 'choice_group',
            options: const ['A', 'B', 'C'],
            initialValue: 'A',
          ),
        ]),
      ],
    );

    final disabled = controller.setBlockRadioGroupOptionEnabled<String>(
      'choice_group',
      'B',
      false,
    );
    expect(disabled, isTrue);
    expect(
      controller
          .getBlockByTagAs<BlockRadioGroup<String>>('choice_group')!
          .isOptionEnabled('B'),
      isFalse,
    );

    final enabled = controller.setBlockRadioGroupOptionEnabled<String>(
      'choice_group',
      'B',
      true,
    );
    expect(enabled, isTrue);
    expect(
      controller
          .getBlockByTagAs<BlockRadioGroup<String>>('choice_group')!
          .isOptionEnabled('B'),
      isTrue,
    );
  });

  test('BlockDialogController sets input field text by tag', () {
    final controller = BlockDialogController();
    final animation = AnimationController(
      vsync: const TestVSync(),
      duration: const Duration(milliseconds: 200),
    );

    controller.initialize(
      animationController: animation,
      textDirection: TextDirection.ltr,
      rows: [
        BlockRow(blocks: [
          BlockInputField(
            blockTag: 'input_username',
          ),
        ]),
      ],
    );

    final result = controller.setBlockInputFieldText('input_username', 'Alice');
    expect(result, isTrue);
    expect(
      controller.getBlockByTagAs<BlockInputField>('input_username')!.text,
      'Alice',
    );
  });

  test('BlockDialogController sets input field enabled by tag', () {
    final controller = BlockDialogController();
    final animation = AnimationController(
      vsync: const TestVSync(),
      duration: const Duration(milliseconds: 200),
    );

    controller.initialize(
      animationController: animation,
      textDirection: TextDirection.ltr,
      rows: [
        BlockRow(blocks: [
          BlockInputField(
            blockTag: 'input_password',
          ),
        ]),
      ],
    );

    final disabled =
        controller.setBlockInputFieldEnabled('input_password', false);
    expect(disabled, isTrue);
    expect(
      controller.getBlockByTagAs<BlockInputField>('input_password')!.enabled,
      isFalse,
    );

    final enabled =
        controller.setBlockInputFieldEnabled('input_password', true);
    expect(enabled, isTrue);
    expect(
      controller.getBlockByTagAs<BlockInputField>('input_password')!.enabled,
      isTrue,
    );
  });

  test('BlockDialogController sets input field read-only by tag', () {
    final controller = BlockDialogController();
    final animation = AnimationController(
      vsync: const TestVSync(),
      duration: const Duration(milliseconds: 200),
    );

    controller.initialize(
      animationController: animation,
      textDirection: TextDirection.ltr,
      rows: [
        BlockRow(blocks: [
          BlockInputField(
            blockTag: 'input_email',
          ),
        ]),
      ],
    );

    final readOnly = controller.setBlockInputFieldReadOnly('input_email', true);
    expect(readOnly, isTrue);
    expect(
      controller.getBlockByTagAs<BlockInputField>('input_email')!.readOnly,
      isTrue,
    );

    final editable =
        controller.setBlockInputFieldReadOnly('input_email', false);
    expect(editable, isTrue);
    expect(
      controller.getBlockByTagAs<BlockInputField>('input_email')!.readOnly,
      isFalse,
    );
  });

  test('BlockDialogController clears input field by tag', () {
    final controller = BlockDialogController();
    final animation = AnimationController(
      vsync: const TestVSync(),
      duration: const Duration(milliseconds: 200),
    );

    controller.initialize(
      animationController: animation,
      textDirection: TextDirection.ltr,
      rows: [
        BlockRow(blocks: [
          BlockInputField(
            blockTag: 'input_search',
            initialText: 'initial value',
          ),
        ]),
      ],
    );

    expect(
      controller.getBlockByTagAs<BlockInputField>('input_search')!.text,
      'initial value',
    );

    final cleared = controller.clearBlockInputField('input_search');
    expect(cleared, isTrue);
    expect(
      controller.getBlockByTagAs<BlockInputField>('input_search')!.text,
      isEmpty,
    );
  });

  test('BlockDialogController returns false for non-existent input field', () {
    final controller = BlockDialogController();
    final animation = AnimationController(
      vsync: const TestVSync(),
      duration: const Duration(milliseconds: 200),
    );

    controller.initialize(
      animationController: animation,
      textDirection: TextDirection.ltr,
      rows: [
        BlockRow(blocks: [
          BlockInputField(
            blockTag: 'input_test',
          ),
        ]),
      ],
    );

    expect(controller.setBlockInputFieldText('nonexistent', 'text'), isFalse);
    expect(controller.setBlockInputFieldEnabled('nonexistent', false), isFalse);
    expect(controller.setBlockInputFieldReadOnly('nonexistent', true), isFalse);
    expect(controller.clearBlockInputField('nonexistent'), isFalse);
    expect(controller.focusBlockInputField('nonexistent'), isFalse);
    expect(controller.unfocusBlockInputField('nonexistent'), isFalse);
  });
}
