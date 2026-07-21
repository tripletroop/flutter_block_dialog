import 'package:block_dialog/src/layout/blocks/block.dart';
import 'package:block_dialog/src/theme/dialog_config.dart';
import 'package:block_dialog/src/core/block_dialog_controller.dart';
import 'package:flutter/material.dart';

class BlockCheckbox extends Block {
  /// Checkbox block that stores a boolean value.
  BlockCheckbox({
    this.label,
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
    bool enabled = true,
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
    this.textStyle,
    super.override,
    super.blockTag,
    bool? initialValue = false,
    super.flex = 1,
    super.minHeight,
  })  : _notifier = ValueNotifier(CheckBoxChangeableValues(
          value: initialValue,
          enabled: enabled,
        )),
        assert(tristate || initialValue != null,
            'initialValue cannot be null when tristate is false'),
        assert(title != null || label != null,
            'Either title or label must be provided');

  final String? label;

  final void Function(bool? value, BlockDialogController controller)? onChanged;
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
  final TextStyle? textStyle;

  final ValueNotifier<CheckBoxChangeableValues> _notifier;

  /// Current checked value.
  bool? get value => _notifier.value.value;

  /// Current enabled value. Null means default platform behavior.
  bool? get enabled => _notifier.value.enabled;

  /// Update checked value and notify listeners.
  void setValue(bool? value) {
    if (!tristate && value == null) return;
    if (_notifier.value.value == value) return;
    _notifier.value = _notifier.value.copyWith(value: value);
  }

  /// Toggle the checked value and notify listeners.
  void toggleValue() {
    setValue(!(value ?? false));
  }

  /// Enable or disable this checkbox.
  void setEnabled(bool? value) {
    if (_notifier.value.enabled == value) return;
    _notifier.value = _notifier.value.copyWith(enabled: value);
  }

  /// Returns the current checked state.
  @override
  dynamic readValue() => _notifier.value;

  @override
  Widget buildContent(
    BuildContext context,
    BlockDialogController controller,
    DialogConfig configs,
  ) {
    return ValueListenableBuilder<CheckBoxChangeableValues>(
      valueListenable: _notifier,
      builder: (context, changeableValues, _) {
        return CheckboxListTile(
          value: changeableValues.value,
          onChanged: (v) {
            setValue(v);
            onChanged?.call(v, controller);
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
          enabled: changeableValues.enabled,
          tileColor: tileColor,
          title: title ??
              Text(
                label!,
                style: (configs.textStyle ?? TextStyle()).merge(TextStyle(
                        color: changeableValues.enabled == false
                            ? Colors.grey
                            : null)
                    .merge(textStyle)),
              ),
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
        );
      },
    );
  }
}

class CheckBoxChangeableValues {
  CheckBoxChangeableValues({
    required this.value,
    required this.enabled,
  });

  // to support tristate, value can be null
  final bool? value;
  final bool enabled;

  CheckBoxChangeableValues copyWith({
    bool? value,
    bool? enabled,
  }) {
    return CheckBoxChangeableValues(
      value: value ?? this.value,
      enabled: enabled ?? this.enabled,
    );
  }
}
