import 'package:block_dialog/src/layout/blocks/block.dart';
import 'package:block_dialog/src/theme/dialog_config.dart';
import 'package:block_dialog/src/core/block_dialog_controller.dart';
import 'package:flutter/material.dart';

typedef BlockCustomBuilder = Widget Function(
  BuildContext context,
  BlockDialogController controller,
  DialogConfig configs,
);

class BlockCustom extends Block {
  /// Custom block for embedding any widget, with optional result capture.
  BlockCustom({
    required this.builder,
    super.flex = 1,
    super.override,
    super.minHeight,
    super.resultId,
    this.resultBuilder,
    this.matchDialogTheme = true,
  }) : assert(
          resultBuilder == null || (resultId != null && resultId.isNotEmpty),
          'BlockCustom with a resultBuilder must have a non-empty resultId.',
        );

  final BlockCustomBuilder builder;

  /// Whether to apply dialog background/stroke decoration to this block.
  final bool matchDialogTheme;

  /// Optional callback to read a result value from your custom widget.
  final dynamic Function()? resultBuilder;

  /// Returns the custom value if provided.
  @override
  dynamic readValue() => resultBuilder != null ? resultBuilder!() : const {};

  @override
  Widget buildContent(
    BuildContext context,
    BlockDialogController controller,
    DialogConfig configs,
  ) {
    return builder(context, controller, configs);
  }
}
