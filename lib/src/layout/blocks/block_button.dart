import 'dart:async';

import 'package:block_dialog/src/layout/blocks/block.dart';
import 'package:block_dialog/src/models/blocks_result.dart';
import 'package:block_dialog/src/theme/dialog_config.dart';
import 'package:block_dialog/src/core/block_dialog_controller.dart';
import 'package:flutter/material.dart';

typedef BlockPressedCallback = FutureOr<String?> Function(
    BlocksResult result, BlockDialogController controller);

typedef BlockPressedVoidCallback = FutureOr<void> Function(
    BlocksResult result, BlockDialogController controller);

class BlockButton extends Block {
  /// Button block that can close the dialog and return a payload.
  BlockButton({
    this.child,
    String? label,
    super.flex = 1,
    super.override,
    super.minHeight,
    super.blockTag,
    this.payload,
    this.textStyle,
    this.onPressed,
    this.onPressedWithError,
    bool enabled = true,
    this.closeOnPress = true,
    this.isPositive = false,
  })  : _label = ValueNotifier<String?>(label),
        _enabled = ValueNotifier<bool>(enabled) {
    assert(
      label != null || child != null,
      'Either label or child must be provided',
    );
    assert(
      onPressed == null || onPressedWithError == null,
      'Cant provide both onPressed and onPressedWithError, only one is allowed',
    );
  }

  final ValueNotifier<String?> _label;
  final ValueNotifier<bool> _enabled;

  String? get label => _label.value;

  bool get enabled => _enabled.value;

  /// Update the button label and notify listeners.
  void setLabel(String? value) {
    if (_label.value == value) return;
    _label.value = value;
  }

  /// Enable or disable interaction for this button.
  void setEnabled(bool value) {
    if (_enabled.value == value) return;
    _enabled.value = value;
  }

  final Widget? child;
  final TextStyle? textStyle;

  /// Optional payload passed back with the [BlocksResult].
  final Object? payload;

  /// a dialog usually have positive and negative buttons
  /// positive buttons are usually styled differently to indicate that they are the primary action.
  /// default value is false, meaning the button is negative.
  final bool isPositive;

  /// Whether to close the dialog when pressed.
  final bool closeOnPress;

  /// Called when the button is pressed.
  /// Supports both synchronous and asynchronous callbacks.
  /// If a Future is returned, a loading indicator is shown until completion.
  /// if an error is returned, the dialog will not close and the error will be passed to the [BlockDialogController.onError] callback.
  final BlockPressedCallback? onPressedWithError;

  final BlockPressedVoidCallback? onPressed;

  final ValueNotifier<bool> _loading = ValueNotifier(false);
  final ValueNotifier<bool> _pressed = ValueNotifier(false);

  bool get _isDisabled => !enabled || _loading.value;

  @override
  Widget buildContent(
    BuildContext context,
    BlockDialogController controller,
    DialogConfig configs,
  ) {
    return ValueListenableBuilder<bool>(
      valueListenable: _enabled,
      builder: (_, __, ___) => ValueListenableBuilder<String?>(
        valueListenable: _label,
        builder: (_, currentLabel, ____) => ValueListenableBuilder<bool>(
          valueListenable: _loading,
          builder: (_, loading, _____) {
            return ValueListenableBuilder<bool>(
              valueListenable: _pressed,
              builder: (_, pressed, ______) {
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapDown: _isDisabled ? null : (_) => _pressed.value = true,
                  onTapCancel: () => _pressed.value = false,
                  onTapUp: (_) => _pressed.value = false,
                  onTap: _isDisabled ? null : () => _handleTap(controller),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 120),
                    curve: Curves.easeOut,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color:
                          _backgroundColor(pressed: pressed, configs: configs),
                      borderRadius: borderRadius.subtract(
                        BorderRadius.circular(configs.strokeWidth),
                      ),
                    ),
                    child: loading
                        ? SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: _getTextColor(),
                            ),
                          )
                        : currentLabel != null
                            ? Text(
                                currentLabel,
                                style: (configs.textStyle ?? TextStyle()).merge(
                                    TextStyle(
                                            fontWeight: isPositive
                                                ? FontWeight.bold
                                                : null,
                                            color: _isDisabled
                                                ? Colors.grey
                                                : null)
                                        .merge(textStyle)),
                              )
                            : child,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Color _backgroundColor({
    required bool pressed,
    required DialogConfig configs,
  }) {
    if (pressed) return configs.backgroundColorPressed;
    return configs.backgroundColor;
  }

  Color? _getTextColor() {
    if (_isDisabled) return Colors.grey.shade400;
    return null;
  }

  Future<void> _handleTap(BlockDialogController controller) async {
    _loading.value = true;
    final result = controller.collectResults(payload: payload);
    String? error;
    if (onPressedWithError != null) {
      error = await onPressedWithError!(result, controller);
    } else {
      await onPressed?.call(result, controller);
    }
    _loading.value = false;
    if (error != null) {
      controller.onError?.call(error);
      return;
    }
    if (closeOnPress) {
      await controller.animateOut(result);
    }
  }
}
