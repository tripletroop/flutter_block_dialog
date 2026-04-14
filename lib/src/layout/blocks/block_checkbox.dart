import 'package:block_dialog/src/layout/blocks/block.dart';
import 'package:block_dialog/src/theme/dialog_config.dart';
import 'package:block_dialog/src/core/block_dialog_controller.dart';
import 'package:flutter/material.dart';

class BlockCheckbox extends Block {
  /// Checkbox block that stores a boolean value.
  BlockCheckbox({
    required String resultId,
    required this.label,
    this.onChanged,
    this.mouseCursor,
    this.activeColor,
    this.fillColor,
    this.checkColor,
    this.hoverColor,
    this.overlayColor,
    this.splashRadius,
    this.materialTapTargetSize,
    this.visualDensity,
    this.focusNode,
    this.autofocus = false,
    this.shape,
    this.side,
    this.isError = false,
    this.enabled,
    this.tileColor,
    this.title,
    this.subtitle,
    this.isThreeLine,
    this.dense = true,
    this.secondary,
    this.selected = false,
    this.controlAffinity = ListTileControlAffinity.leading,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 12.0),
    this.tristate = false,
    this.checkboxShape,
    this.selectedTileColor,
    this.onFocusChange,
    this.enableFeedback,
    this.horizontalTitleGap,
    this.minVerticalPadding,
    this.minLeadingWidth,
    this.minTileHeight,
    this.checkboxSemanticLabel,
    this.checkboxScaleFactor = 1.0,
    this.titleAlignment,
    this.internalAddSemanticForOnTap = false,
    super.override,
    super.blockTag,
    bool? initialValue = false,
    super.flex = 1,
    super.minHeight,
  })  : _notifier = ValueNotifier<bool?>(initialValue),
        assert(tristate || initialValue != null,
            'initialValue cannot be null when tristate is false'),
        assert(resultId.isNotEmpty, 'resultId must not be empty'),
        super(resultId: resultId);

  final String label;
  final ValueNotifier<bool?> _notifier;

  final ValueChanged<bool?>? onChanged;
  final MouseCursor? mouseCursor;
  final Color? activeColor;
  final WidgetStateProperty<Color?>? fillColor;
  final Color? checkColor;
  final Color? hoverColor;
  final WidgetStateProperty<Color?>? overlayColor;
  final double? splashRadius;
  final MaterialTapTargetSize? materialTapTargetSize;
  final VisualDensity? visualDensity;
  final FocusNode? focusNode;
  final bool autofocus;
  final ShapeBorder? shape;
  final BorderSide? side;
  final bool isError;
  final bool? enabled;
  final Color? tileColor;
  final Widget? title;
  final Widget? subtitle;
  final bool? isThreeLine;
  final bool? dense;
  final Widget? secondary;
  final bool selected;
  final ListTileControlAffinity? controlAffinity;
  final EdgeInsetsGeometry? contentPadding;
  final bool tristate;
  final OutlinedBorder? checkboxShape;
  final Color? selectedTileColor;
  final ValueChanged<bool>? onFocusChange;
  final bool? enableFeedback;
  final double? horizontalTitleGap;
  final double? minVerticalPadding;
  final double? minLeadingWidth;
  final double? minTileHeight;
  final String? checkboxSemanticLabel;
  final double checkboxScaleFactor;
  final ListTileTitleAlignment? titleAlignment;
  final bool internalAddSemanticForOnTap;

  /// Returns the current checked state.
  @override
  dynamic readValue() => _notifier.value;

  @override
  Widget buildContent(
    BuildContext context,
    BlockDialogController controller,
    DialogConfig configs,
  ) {
    return ValueListenableBuilder<bool?>(
      valueListenable: _notifier,
      builder: (context, value, _) => CheckboxListTile(
        value: value,
        onChanged: (v) {
          _notifier.value = v;
          onChanged?.call(v);
        },
        mouseCursor: mouseCursor,
        activeColor: activeColor,
        fillColor: fillColor,
        checkColor: checkColor,
        hoverColor: hoverColor,
        overlayColor: overlayColor,
        splashRadius: splashRadius,
        materialTapTargetSize: materialTapTargetSize,
        visualDensity: visualDensity,
        focusNode: focusNode,
        autofocus: autofocus,
        shape: shape,
        side: side,
        isError: isError,
        enabled: enabled,
        tileColor: tileColor,
        title: title ?? Text(label, style: const TextStyle(fontSize: 15)),
        subtitle: subtitle,
        isThreeLine: isThreeLine,
        dense: dense,
        secondary: secondary,
        selected: selected,
        controlAffinity: controlAffinity,
        contentPadding: contentPadding,
        tristate: tristate,
        checkboxShape: checkboxShape,
        selectedTileColor: selectedTileColor,
        onFocusChange: onFocusChange,
        enableFeedback: enableFeedback,
        horizontalTitleGap: horizontalTitleGap,
        minVerticalPadding: minVerticalPadding,
        minLeadingWidth: minLeadingWidth,
        minTileHeight: minTileHeight,
        checkboxSemanticLabel: checkboxSemanticLabel,
        checkboxScaleFactor: checkboxScaleFactor,
        titleAlignment: titleAlignment,
        internalAddSemanticForOnTap: internalAddSemanticForOnTap,
      ),
    );
  }
}
