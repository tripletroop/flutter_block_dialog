import 'package:block_dialog/src/layout/blocks/block.dart';
import 'package:block_dialog/src/theme/dialog_config.dart';
import 'package:block_dialog/src/core/block_dialog_controller.dart';
import 'package:flutter/material.dart';

class BlockInputField extends Block {
  /// Text input block that stores the current text value.
  BlockInputField({
    required String resultId,
    super.flex = 1,
    super.override,
    super.minHeight,
    this.hintText,
    this.keyboardType,
  })  : assert(resultId.isNotEmpty, 'resultId must not be empty'),
        super(resultId: resultId);

  final TextEditingController editingController = TextEditingController();

  /// Placeholder text.
  final String? hintText;

  /// Input keyboard type.
  final TextInputType? keyboardType;

  /// Returns the current text value.
  @override
  dynamic readValue() => editingController.text;

  @override
  Widget buildContent(
    BuildContext context,
    BlockDialogController controller,
    DialogConfig configs,
  ) {
    return TextField(
      controller: editingController,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        border: InputBorder.none,
        isDense: true,
        contentPadding: const EdgeInsets.all(8.0),
      ),
    );
  }
}
