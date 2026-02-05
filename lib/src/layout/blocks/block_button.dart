import 'package:block_dialog/src/layout/blocks/block.dart';
import 'package:block_dialog/src/models/blocks_result.dart';
import 'package:block_dialog/src/theme/dialog_config.dart';
import 'package:block_dialog/src/core/block_dialog_controller.dart';
import 'package:flutter/material.dart';

typedef BlockValidation = Function(BlocksResult result);

class BlockButton extends Block {
  /// Button block that can close the dialog and return a payload.
  BlockButton({
    this.child,
    this.label,
    super.flex = 1,
    super.override,
    super.minHeight,
    this.payload,
    this.onPressed,
    this.onValidate,
    this.enabled = true,
    this.closeOnPress = true,
  }) {
    assert(
      label != null || child != null,
      'Either label or child must be provided',
    );
  }
  final String? label;
  final Widget? child;

  /// Optional payload passed back with the [BlocksResult].
  final Object? payload;

  /// Whether the button is interactable.
  final bool enabled;

  /// Whether to close the dialog when pressed.
  final bool closeOnPress;

  /// Called after validation when the button is pressed.
  final Function(BlocksResult result)? onPressed;

  /// Optional validation callback; return an error to show it.
  final BlockValidation? onValidate;

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
      valueListenable: _loading,
      builder: (_, loading, __) {
        return ValueListenableBuilder<bool>(
          valueListenable: _pressed,
          builder: (_, pressed, __) {
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
                  color: _backgroundColor(pressed: pressed, configs: configs),
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
                    : label != null
                        ? Text(label!, style: TextStyle(color: _getTextColor()))
                        : child,
              ),
            );
          },
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

  Color? _getTextColor() {
    if (_isDisabled) return Colors.grey.shade400;
    return null;
  }

  Future<void> _handleTap(BlockDialogController controller) async {
    final result = controller.collectResults(payload: payload);

    // Validation
    final error = await onValidate?.call(result);
    if (error != null) {
      controller.onError?.call(error);
      return;
    }
    _loading.value = true;
    await onPressed?.call(result);
    if (closeOnPress) {
      await controller.animateOut(result);
    }
    _loading.value = false;
  }
}
