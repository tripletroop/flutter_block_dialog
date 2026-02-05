import 'package:block_dialog/src/layout/blocks/block.dart';
import 'package:block_dialog/src/theme/dialog_config.dart';
import 'package:block_dialog/src/core/block_dialog_controller.dart';
import 'package:flutter/material.dart';

class BlockText extends Block {
  /// Text block for titles, body copy, or messages.
  BlockText({
    required this.text,
    super.flex = 1,
    super.override,
    this.style,
    super.minHeight = 100,
    this.textAlign = TextAlign.center,
  });

  final String text;
  /// Optional text style.
  final TextStyle? style;
  /// Text alignment inside the block.
  final TextAlign textAlign;

  @override
  Widget buildContent(
    BuildContext context,
    BlockDialogController controller,
    DialogConfig configs,
  ) {
    return Center(
      child: Text(
        text,
        textAlign: textAlign,
        style: style ?? const TextStyle(fontSize: 15),
      ),
    );
  }
}
