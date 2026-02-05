import 'package:block_dialog/src/core/block_dialog_controller.dart';
import 'package:block_dialog/src/layout/blocks/block.dart';
import 'package:block_dialog/src/theme/dialog_config.dart';
import 'package:flutter/material.dart';

class BlockSpacer extends Block {
  /// Spacer block for vertical gaps inside dialogs.
  BlockSpacer({super.flex = 1, super.override, required double height})
      : super(minHeight: height);

  /// Builds an empty box with the configured height.
  @override
  Widget buildContent(
    BuildContext context,
    BlockDialogController controller,
    DialogConfig configs,
  ) {
    return SizedBox(height: minHeight);
  }
}
