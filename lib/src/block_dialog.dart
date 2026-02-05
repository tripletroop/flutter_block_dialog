import 'package:block_dialog/src/core/block_dialog_content.dart';
import 'package:block_dialog/src/core/block_dialog_controller.dart';
import 'package:block_dialog/src/core/block_dialog_host.dart';
import 'package:block_dialog/src/layout/block_row.dart';
import 'package:block_dialog/src/models/blocks_result.dart';
import 'package:block_dialog/src/theme/dialog_config.dart';
import 'package:flutter/material.dart';

/// Public API for showing block-based dialogs.
class BlockDialog {
  /// Show a block-based dialog and return its typed [BlocksResult].
  ///
  /// - [rows] define the layout (each row contains blocks).
  /// - [barrierDismissible] controls tap-outside dismissal.
  /// - [configs] customize styling, spacing, and animations.
  static Future<BlocksResult<T>?> show<T>(
    BuildContext context, {
    required List<BlockRow> rows,
    bool barrierDismissible = true,
    DialogConfig configs = const DialogConfig(),
  }) {
    return showDialog<BlocksResult<T>>(
      context: context,
      barrierColor: Colors.transparent,
      barrierDismissible: false,
      useSafeArea: false,
      builder: (_) => BlockDialogHost(
        rows: rows,
        configs: configs,
        barrierDismissible: barrierDismissible,
      ),
    );
  }

  /// Build dialog content without showing a route.
  ///
  /// Useful for embedding inside custom containers or bottom sheets.
  static Widget buildContent({
    Key? key,
    required List<BlockRow> rows,
    required BlockDialogController controller,
    DialogConfig configs = const DialogConfig(),
  }) {
    return BlockDialogContent(
      key: key,
      rows: rows,
      controller: controller,
      configs: configs,
    );
  }
}
