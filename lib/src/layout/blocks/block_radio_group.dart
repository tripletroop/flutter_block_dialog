import 'package:block_dialog/src/layout/blocks/block.dart';
import 'package:block_dialog/src/theme/dialog_config.dart';
import 'package:block_dialog/src/core/block_dialog_controller.dart';
import 'package:flutter/material.dart';

/// Radio group block that stores a single selected value of type [T].
class BlockRadioGroup<T> extends Block {
  BlockRadioGroup({
    required String resultId,

    /// Options to present in the group.
    required List<T> options,
    T? initialValue,

    /// Called when the selected value changes.
    this.onChanged,

    /// Custom row builder without the built-in radio widget.
    this.itemBuilder,

    /// Provides a label string when not using a custom builder.
    this.labelBuilder,
    this.mouseCursor,
    this.activeColor,
    this.fillColor,
    this.hoverColor,
    this.overlayColor,
    this.splashRadius,
    this.materialTapTargetSize,
    this.visualDensity = VisualDensity.compact,
    this.focusNode,
    this.autofocus = false,
    this.tileColor,
    this.selectedTileColor,
    this.enableFeedback,
    this.isThreeLine = false,
    this.dense = true,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 12.0),
    this.shape,
    this.controlAffinity = ListTileControlAffinity.platform,
    this.titleAlignment,
    super.flex = 1,
    super.blockTag,
    super.override,
    super.minHeight,
  })  : _options = options,
        _notifier = ValueNotifier<T?>(initialValue),
        assert(options.contains(initialValue) || initialValue == null,
            'initialValue must be one of the options or null'),
        assert(resultId.isNotEmpty, 'resultId must not be empty'),
        assert(options.length > 1, 'options must contain at least 2 items'),
        super(resultId: resultId);

  final List<T> _options;
  final ValueNotifier<T?> _notifier;
  final ValueChanged<T?>? onChanged;
  final Widget Function(T option, bool selected)? itemBuilder;
  final String Function(T option)? labelBuilder;

  /// Optional mouse cursor for the radio tile.
  final MouseCursor? mouseCursor;

  /// Optional active color for selected radio.
  final Color? activeColor;

  /// Optional fill color based on material state.
  final WidgetStateProperty<Color?>? fillColor;

  /// Optional hover color.
  final Color? hoverColor;

  /// Optional overlay color based on material state.
  final WidgetStateProperty<Color?>? overlayColor;

  /// Optional splash radius.
  final double? splashRadius;

  /// Optional tap target size behavior.
  final MaterialTapTargetSize? materialTapTargetSize;

  /// Optional visual density.
  final VisualDensity? visualDensity;

  /// Optional focus node.
  final FocusNode? focusNode;

  /// Whether this tile should autofocus.
  final bool autofocus;

  /// Optional tile background color.
  final Color? tileColor;

  /// Optional selected tile background color.
  final Color? selectedTileColor;

  /// Optional haptic/acoustic feedback behavior.
  final bool? enableFeedback;

  /// Whether subtitle takes up three lines of height.
  final bool isThreeLine;

  /// Optional dense layout flag.
  final bool? dense;

  /// Optional padding around tile content.
  final EdgeInsetsGeometry? contentPadding;

  /// Optional tile shape.
  final ShapeBorder? shape;

  /// Control position relative to title.
  final ListTileControlAffinity controlAffinity;

  /// Optional title vertical alignment inside tile.
  final ListTileTitleAlignment? titleAlignment;

  /// Returns the currently selected value.
  @override
  dynamic readValue() => _notifier.value;

  @override
  Widget buildContent(
    BuildContext context,
    BlockDialogController controller,
    DialogConfig configs,
  ) {
    return ValueListenableBuilder<T?>(
      valueListenable: _notifier,
      builder: (context, value, _) {
        return RadioGroup<T>(
          groupValue: value,
          onChanged: (v) {
            _notifier.value = v;
            onChanged?.call(v);
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _options.map((option) {
              final selected = option == value;
              final label = labelBuilder?.call(option) ?? option.toString();
              return RadioListTile<T>(
                value: option,
                mouseCursor: mouseCursor,
                activeColor: activeColor,
                fillColor: fillColor,
                hoverColor: hoverColor,
                overlayColor: overlayColor,
                splashRadius: splashRadius,
                materialTapTargetSize: materialTapTargetSize,
                visualDensity: visualDensity,
                focusNode: focusNode,
                autofocus: autofocus,
                tileColor: tileColor,
                selectedTileColor: selectedTileColor,
                enableFeedback: enableFeedback,
                isThreeLine: isThreeLine,
                dense: dense,
                contentPadding: contentPadding,
                shape: shape,
                controlAffinity: controlAffinity,
                titleAlignment: titleAlignment,
                selected: selected,
                title: itemBuilder != null
                    ? itemBuilder!(option, selected)
                    : Text(label,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: selected
                                ? FontWeight.w500
                                : FontWeight.normal)),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
