import 'package:block_dialog/src/layout/blocks/block.dart';
import 'package:block_dialog/src/theme/dialog_config.dart';
import 'package:block_dialog/src/core/block_dialog_controller.dart';
import 'package:flutter/material.dart';

typedef BlockCustomBuilder = Widget Function(
  BuildContext context,
  BlockDialogController dialogController,
  BlockCustomController? blockController,
  DialogConfig configs,
);

/// Abstract base class for custom block controllers.
/// Extend this class to create a controller for your BlockCustom widget.
abstract class BlockCustomController extends ChangeNotifier {
  bool _attached = false;

  /// Build the result value for this custom block.
  /// This is called when the dialog collects results.
  dynamic buildResult();

  late final BlockDialogController dialogController;
  late final BuildContext context;

  void _attachedDialogController(
      BuildContext context, BlockDialogController dialogController) {
    if (_attached) return;
    this.dialogController = dialogController;
    this.context = context;
    _attached = true;
  }
}

class BlockCustom extends Block {
  /// Custom block for embedding any widget with a custom controller.
  /// The blockController must extend [BlockCustomController] and implement [buildResult].
  /// This allows you to:
  /// - Manage custom state in your controller
  /// - React to state changes with ValueListenableBuilder
  /// - Access other blocks via the dialog controller
  BlockCustom({
    this.blockController,
    required this.builder,
    super.flex = 1,
    super.override,
    super.minHeight,
    super.resultId,
    super.blockTag,
    this.matchDialogTheme = true,
  }) : assert(
          resultId == null || resultId.isEmpty || resultId.isNotEmpty,
          'resultId must not be empty if provided.',
        );

  /// The custom controller instance for this block.
  /// Must extend [BlockCustomController] and implement [buildResult].
  final BlockCustomController? blockController;

  /// Builder function that creates the widget for this block.
  /// Receives the controller and dialog config for customization.
  final BlockCustomBuilder builder;

  /// Whether to apply dialog background/stroke decoration to this block.
  final bool matchDialogTheme;

  /// Returns the result value by calling the blockController's buildResult method.
  @override
  dynamic readValue() {
    if (resultId == null || resultId!.isEmpty) {
      return null;
    }
    return blockController?.buildResult();
  }

  @override
  Widget buildContent(
    BuildContext context,
    BlockDialogController dialogController,
    DialogConfig configs,
  ) {
    if (blockController == null) {
      return builder(context, dialogController, blockController, configs);
    } else {
      blockController!._attachedDialogController(context, dialogController);
      return ListenableBuilder(
        listenable: blockController!,
        builder: (context, child) =>
            builder(context, dialogController, blockController, configs),
      );
    }
  }
}
