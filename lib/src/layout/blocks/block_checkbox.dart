import 'package:block_dialog/src/layout/blocks/block.dart';
import 'package:block_dialog/src/theme/dialog_config.dart';
import 'package:block_dialog/src/core/block_dialog_controller.dart';
import 'package:flutter/material.dart';

class BlockCheckbox extends Block {
  /// Checkbox block that stores a boolean value.
  BlockCheckbox({
    required String resultId,
    required this.label,
    super.override,
    bool initialValue = false,
    super.flex = 1,
    super.minHeight,
  })  : _notifier = ValueNotifier<bool>(initialValue),
        assert(resultId.isNotEmpty, 'resultId must not be empty'),
        super(resultId: resultId);

  final String label;
  final ValueNotifier<bool> _notifier;

  /// Returns the current checked state.
  @override
  dynamic readValue() => _notifier.value;

  @override
  Widget buildContent(
    BuildContext context,
    BlockDialogController controller,
    DialogConfig configs,
  ) {
    return ValueListenableBuilder<bool>(
      valueListenable: _notifier,
      builder: (context, value, _) => CheckboxListTile(
        value: value,
        onChanged: (v) => _notifier.value = v ?? false,
        dense: true,
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
        title: Text(label, style: const TextStyle(fontSize: 15)),
      ),
    );
  }
}
