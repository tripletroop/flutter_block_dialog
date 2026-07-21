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
    this.loadingWidget,
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
  })  : assert(
          label != null || child != null,
          'Either label or child must be provided',
        ),
        assert(
          onPressed == null || onPressedWithError == null,
          'Cant provide both onPressed and onPressedWithError, only one is allowed',
        ),
        _notifier = ValueNotifier<ButtonChangeableValues>(
          ButtonChangeableValues(
            label: label,
            enabled: enabled,
          ),
        );

  final Widget? child;
  final Widget? loadingWidget;
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

  /// Called when the button is pressed.
  /// Supports both synchronous and asynchronous callbacks.
  /// If a Future is returned, a loading indicator is shown until completion.
  final BlockPressedVoidCallback? onPressed;

  final ValueNotifier<ButtonChangeableValues> _notifier;

  String? get label => _notifier.value.label;

  bool get enabled => _notifier.value.enabled;

  /// Update the button label and notify listeners.
  void setLabel(String? value) {
    if (_notifier.value.label == value) return;
    _notifier.value = _notifier.value.copyWith(label: value);
  }

  /// Enable or disable interaction for this button.
  void setEnabled(bool value) {
    if (_notifier.value.enabled == value) return;
    _notifier.value = _notifier.value.copyWith(enabled: value);
  }

  void _setPressed(bool value) {
    if (_notifier.value.pressed == value) return;
    _notifier.value = _notifier.value.copyWith(pressed: value);
  }

  void _setLoading(bool value) {
    if (_notifier.value.loading == value) return;
    _notifier.value = _notifier.value.copyWith(loading: value);
  }

  @override
  Widget buildContent(
    BuildContext context,
    BlockDialogController controller,
    DialogConfig configs,
  ) {
    return ValueListenableBuilder<ButtonChangeableValues>(
      valueListenable: _notifier,
      builder: (_, changeableValues, ___) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown:
              changeableValues.isDisabled ? null : (_) => _setPressed(true),
          onTapCancel: () => _setPressed(false),
          onTapUp: (_) => _setPressed(false),
          onTap:
              changeableValues.isDisabled ? null : () => _handleTap(controller),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            curve: Curves.easeOut,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _backgroundColor(
                  pressed: changeableValues.pressed, configs: configs),
              borderRadius: borderRadius.subtract(
                BorderRadius.circular(configs.strokeWidth),
              ),
            ),
            child: changeableValues.loading
                ? (loadingWidget ??
                    SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ))
                : child ??
                    (Text(
                      changeableValues.label ?? '',
                      style: (configs.textStyle ?? TextStyle()).merge(TextStyle(
                              fontWeight: isPositive ? FontWeight.bold : null,
                              color: changeableValues.isDisabled
                                  ? Colors.grey
                                  : null)
                          .merge(textStyle)),
                    )),
          ),
        );
      },
    );
  }

  Color _backgroundColor({
    required bool pressed,
    required DialogConfig configs,
  }) {
    if (pressed) return configs.backgroundColorPressed;
    return configs.backgroundColor;
  }

  Future<void> _handleTap(BlockDialogController controller) async {
    _setLoading(true);
    final result = controller.collectResults(payload: payload);
    String? error;
    if (onPressedWithError != null) {
      error = await onPressedWithError!(result, controller);
    } else {
      await onPressed?.call(result, controller);
    }
    _setLoading(false);
    if (error != null) {
      controller.onError?.call(error);
      return;
    }
    if (closeOnPress) {
      await controller.animateOut(result);
    }
  }
}

class ButtonChangeableValues {
  ButtonChangeableValues({
    required this.label,
    required this.enabled,
    this.loading = false,
    this.pressed = false,
  });

  final String? label;
  final bool enabled;
  final bool loading;
  final bool pressed;

  ButtonChangeableValues copyWith({
    String? label,
    bool? enabled,
    bool? loading,
    bool? pressed,
  }) {
    return ButtonChangeableValues(
      label: label ?? this.label,
      enabled: enabled ?? this.enabled,
      loading: loading ?? this.loading,
      pressed: pressed ?? this.pressed,
    );
  }

  bool get isDisabled => !enabled || loading;
}
