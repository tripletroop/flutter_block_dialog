import 'package:block_dialog/src/layout/block_row.dart';
import 'package:block_dialog/src/models/blocks_result.dart';
import 'package:block_dialog/src/theme/dialog_config.dart';
import 'package:block_dialog/src/core/block_dialog_content.dart';
import 'package:block_dialog/src/core/block_dialog_controller.dart';
import 'package:block_dialog/src/widgets/dialog_error.dart';
import 'package:flutter/material.dart';

class BlockDialogHost extends StatefulWidget {
  /// Host widget that renders the dialog, dimmed barrier, and content.
  const BlockDialogHost({
    super.key,
    required this.rows,
    this.configs = const DialogConfig(),
    this.barrierDismissible = true,
  });

  /// Blocks laid out inside the dialog.
  final List<BlockRow> rows;

  /// Visual styling and animation configuration.
  final DialogConfig configs;

  /// Whether tapping the barrier should dismiss the dialog.
  final bool barrierDismissible;

  @override
  State<BlockDialogHost> createState() => _BlockDialogHostState();
}

class _BlockDialogHostState extends State<BlockDialogHost>
    with SingleTickerProviderStateMixin {
  late final BlockDialogController _controller = BlockDialogController(
    onError: showError,
    onAnimateOutComplete: (payload) {
      if (mounted) Navigator.of(context).pop(payload);
    },
  );
  late final AnimationController _animationController;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.configs.animationDuration,
    );
    _controller.initialize(
      rows: widget.rows,
      animationController: _animationController,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.animateIn();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void showError(Object? error) {
    setState(() {
      _errorMessage = error.toString();
    });
  }

  void clearError() {
    if (_errorMessage != null) {
      setState(() {
        _errorMessage = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final barrierColor = widget.configs.barrierColor;
    final barrierAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop || _controller.isAnimating) return;
        _controller.animateOut(
          BlocksResult(
            dismissReason: DismissReason.canceled,
            values: {},
            payload: result,
          ),
        );
      },
      child: Material(
        type: MaterialType.transparency,
        child: SizedBox.expand(
          child: Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: widget.barrierDismissible
                      ? () {
                          if (_controller.isAnimating) return;
                          _controller.animateOut(
                            BlocksResult(
                              dismissReason: DismissReason.canceled,
                              values: {},
                            ),
                          );
                        }
                      : () {},
                  child: AnimatedBuilder(
                    animation: barrierAnimation,
                    builder: (_, __) {
                      return Container(
                        color: Color.lerp(
                          Colors.transparent,
                          barrierColor,
                          barrierAnimation.value,
                        ),
                      );
                    },
                  ),
                ),
              ),
              Center(
                child: SafeArea(
                  minimum: const EdgeInsets.all(16),
                  child: Dialog(
                    backgroundColor: Colors.transparent,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        BlockDialogContent(
                          rows: widget.rows,
                          configs: widget.configs,
                          controller: _controller,
                        ),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          child: _errorMessage == null
                              ? SizedBox.shrink()
                              : DialogError(
                                  errorMessage: _errorMessage!,
                                  onClear: clearError,
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
