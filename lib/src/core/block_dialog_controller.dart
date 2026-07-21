import 'package:block_dialog/src/layout/blocks/block.dart';
import 'package:block_dialog/src/layout/blocks/block_button.dart';
import 'package:block_dialog/src/layout/blocks/block_checkbox.dart';
import 'package:block_dialog/src/layout/blocks/block_custom.dart';
import 'package:block_dialog/src/layout/blocks/block_input_field.dart';
import 'package:block_dialog/src/layout/blocks/block_radio_group.dart';
import 'package:block_dialog/src/layout/blocks/block_text.dart';
import 'package:block_dialog/src/layout/block_row.dart';
import 'package:block_dialog/src/models/blocks_result.dart';
import 'package:block_dialog/src/utils/position_resolver.dart';
import 'package:flutter/material.dart';

class BlockDialogController {
  /// Controller that coordinates block positions, values, and animations.
  BlockDialogController({this.onError, this.onAnimateOutComplete});

  AnimationController? _animation;

  /// Called after the dialog finishes its animate-out.
  final Function(Object? payload)? onAnimateOutComplete;

  /// Called when a block reports a validation error.
  final Function(Object? error)? onError;
  final List<Block> _blocks = [];
  bool isAnimating = false;

  void initialize({
    required AnimationController animationController,
    required List<BlockRow> rows,
    required TextDirection? textDirection,
  }) {
    _animation = animationController;
    final resolvableRows =
        rows.where((row) => !row.ignoreInPositionResolving).toList();
    for (var rowIndex = 0; rowIndex < resolvableRows.length; rowIndex++) {
      final row = resolvableRows[rowIndex];
      for (var columnIndex = 0;
          columnIndex < row.blocks.length;
          columnIndex++) {
        final block = row.blocks[columnIndex];
        final position = PositionResolvingData(
          rowIndex: rowIndex,
          rowCount: resolvableRows.length,
          columnIndex: columnIndex,
          columnCount: row.blocks.length,
        );
        block.setPositionIfNotProvided(
            resolvedPosition:
                PositionResolver.resolve(position, textDirection));
      }
    }
    for (final unresolvedBlock in rows
        .where((row) => row.ignoreInPositionResolving)
        .expand((row) => row.blocks)) {
      unresolvedBlock.setPositionIfNotProvided(
          resolvedPosition: BlockPosition.middle);
    }
    _blocks.addAll(rows.expand((row) => row.blocks));
    assert(
      _validateUniqueBlockTags(_blocks),
      'Duplicate Block tags detected. '
      'Each block must have a unique tag.',
    );
  }

  bool _validateUniqueBlockTags(List<Block> blocks) {
    final ids = <String>{};

    for (final block in blocks) {
      if (block.blockTag == null) continue;
      if (!ids.add(block.blockTag!)) return false;
    }

    return true;
  }

  BlocksResult collectResults({Object? payload}) {
    final values = <String, dynamic>{};
    for (final block in _blocks) {
      final id = block.blockTag;
      if (id == null || id.isEmpty) continue;

      final blockValue = block.readValue();
      if (blockValue == null) continue;

      values[id] = blockValue;
    }
    return BlocksResult(
      dismissReason: DismissReason.button,
      values: values,
      payload: payload,
    );
  }

  Block? getBlockByTag(String tag) {
    return _blocks.cast<Block?>().firstWhere(
          (block) => block!.blockTag == tag,
          orElse: () => null,
        );
  }

  /// Look up a block by tag and cast it to a specific type.
  T? getBlockByTagAs<T extends Block>(String tag) {
    final block = getBlockByTag(tag);
    return block is T ? block : null;
  }

  /// Update the text of a tagged [BlockText]. Returns true on success.
  bool setBlockText(String blockTag, String text) {
    final block = getBlockByTagAs<BlockText>(blockTag);
    if (block == null) return false;
    block.setText(text);
    return true;
  }

  /// Update the label of a tagged [BlockButton]. Returns true on success.
  bool setBlockButtonLabel(String blockTag, String? label) {
    final block = getBlockByTagAs<BlockButton>(blockTag);
    if (block == null) return false;
    block.setLabel(label);
    return true;
  }

  /// Enable or disable a tagged [BlockButton]. Returns true on success.
  bool setBlockButtonEnabled(String blockTag, bool enabled) {
    final block = getBlockByTagAs<BlockButton>(blockTag);
    if (block == null) return false;
    block.setEnabled(enabled);
    return true;
  }

  /// Update the checked value of a tagged [BlockCheckbox].
  /// Returns true on success.
  bool setBlockCheckboxValue(String blockTag, bool? value) {
    final block = getBlockByTagAs<BlockCheckbox>(blockTag);
    if (block == null) return false;
    block.setValue(value);
    return true;
  }

  /// Toggle the checked value of a tagged [BlockCheckbox].
  /// Returns true on success.
  bool toggleBlockCheckboxValue(String blockTag) {
    final block = getBlockByTagAs<BlockCheckbox>(blockTag);
    if (block == null) return false;
    block.toggleValue();
    return true;
  }

  /// Enable or disable a tagged [BlockCheckbox]. Returns true on success.
  bool setBlockCheckboxEnabled(String blockTag, bool? enabled) {
    final block = getBlockByTagAs<BlockCheckbox>(blockTag);
    if (block == null) return false;
    block.setEnabled(enabled);
    return true;
  }

  /// Update selected value of a tagged [BlockRadioGroup]. Returns true on success.
  bool setBlockRadioGroupValue<T>(String blockTag, T? value) {
    final block = getBlockByTagAs<BlockRadioGroup<T>>(blockTag);
    if (block == null) return false;
    return block.setSelectedValue(value);
  }

  /// Enable or disable one option of a tagged [BlockRadioGroup].
  /// Returns true on success.
  bool setBlockRadioGroupOptionEnabled<T>(
    String blockTag,
    T option,
    bool enabled,
  ) {
    final block = getBlockByTagAs<BlockRadioGroup<T>>(blockTag);
    if (block == null) return false;
    return block.setOptionEnabled(option, enabled);
  }

  /// Update the text of a tagged [BlockInputField]. Returns true on success.
  bool setBlockInputFieldText(String blockTag, String text) {
    final block = getBlockByTagAs<BlockInputField>(blockTag);
    if (block == null) return false;
    block.setText(text);
    return true;
  }

  /// Update the text of a tagged [BlockInputField]. Returns true on success.
  bool appendBlockInputFieldText(String blockTag, String text) {
    final block = getBlockByTagAs<BlockInputField>(blockTag);
    if (block == null) return false;
    block.appendText(text);
    return true;
  }

  /// Update the error text of a tagged [BlockInputField]. Returns true on success.
  bool setBlockInputFieldErrorText(String blockTag, String? errorText) {
    final block = getBlockByTagAs<BlockInputField>(blockTag);
    if (block == null) return false;
    block.setErrorText(errorText);
    return true;
  }

  /// Enable or disable a tagged [BlockInputField]. Returns true on success.
  bool setBlockInputFieldEnabled(String blockTag, bool enabled) {
    final block = getBlockByTagAs<BlockInputField>(blockTag);
    if (block == null) return false;
    block.setEnabled(enabled);
    return true;
  }

  /// Set read-only on a tagged [BlockInputField]. Returns true on success.
  bool setBlockInputFieldReadOnly(String blockTag, bool readOnly) {
    final block = getBlockByTagAs<BlockInputField>(blockTag);
    if (block == null) return false;
    block.setReadOnly(readOnly);
    return true;
  }

  /// Clear the text of a tagged [BlockInputField]. Returns true on success.
  bool clearBlockInputField(String blockTag) {
    final block = getBlockByTagAs<BlockInputField>(blockTag);
    if (block == null) return false;
    block.clear();
    return true;
  }

  /// Request focus on a tagged [BlockInputField]. Returns true on success.
  bool focusBlockInputField(String blockTag) {
    final block = getBlockByTagAs<BlockInputField>(blockTag);
    if (block == null) return false;
    block.focus();
    return true;
  }

  /// Unfocus a tagged [BlockInputField]. Returns true on success.
  bool unfocusBlockInputField(String blockTag) {
    final block = getBlockByTagAs<BlockInputField>(blockTag);
    if (block == null) return false;
    block.unfocus();
    return true;
  }

  BlockCustomController? getBlockCustomController(String blockTag) {
    final block = getBlockByTagAs<BlockCustom>(blockTag);
    return block?.blockController;
  }

  void shakeBlock(String blockTag) {
    getBlockByTag(blockTag)?.shake();
  }

  AnimationController? get animation => _animation;

  /// Play the animate-in sequence.
  void animateIn() {
    _animation?.forward();
  }

  /// Play the animate-out sequence and return results to the host.
  Future<void> animateOut(BlocksResult results) async {
    if (isAnimating) return;
    isAnimating = true;
    await _animation?.reverse();
    onAnimateOutComplete?.call(results);
    isAnimating = false;
  }

  /// Dispose the internal animation controller.
  void dispose() {
    _animation?.dispose();
  }
}
