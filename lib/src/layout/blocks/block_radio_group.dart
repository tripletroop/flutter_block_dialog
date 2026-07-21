import 'package:block_dialog/src/layout/blocks/block.dart';
import 'package:block_dialog/src/theme/dialog_config.dart';
import 'package:block_dialog/src/core/block_dialog_controller.dart';
import 'package:flutter/material.dart';

/// Radio group block that stores a single selected value of type [T].
class BlockRadioGroup<T> extends Block {
  BlockRadioGroup({
    /// Options to present in the group.
    required List<T> options,
    T? initialValue,
    this.onChanged,
    this.itemBuilder,
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
    this.textStyle,
    this.selectedStyle,
    super.flex = 1,
    super.blockTag,
    super.override,
    super.minHeight,
  })  : assert(options.contains(initialValue) || initialValue == null,
            'initialValue must be one of the options or null'),
        assert(options.length > 1, 'options must contain at least 2 items'),
        _options = options,
        _notifier = ValueNotifier(RadioGroupChangeableValues<T>(
          value: initialValue,
        ));

  final List<T> _options;

  final void Function(T? value, BlockDialogController controller)? onChanged;
  final Widget Function(T option, bool selected, DialogConfig configs)?
      itemBuilder;
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

  final TextStyle? textStyle;
  final TextStyle? selectedStyle;

  final ValueNotifier<RadioGroupChangeableValues<T>> _notifier;

  /// Current selected value.
  T? get selectedValue => _notifier.value.value;

  /// Update selected value at runtime.
  bool setSelectedValue(T? value) {
    if (value != null && !_options.contains(value)) return false;
    if (value != null && _notifier.value.disabledOptions.contains(value)) {
      return false;
    }
    if (_notifier.value.value == value) return true;
    _notifier.value = _notifier.value.copyWith(value: value);
    return true;
  }

  /// Enable or disable a specific option at runtime.
  bool setOptionEnabled(T option, bool enabled) {
    if (!_options.contains(option)) return false;
    final next = Set<T>.from(_notifier.value.disabledOptions);
    if (enabled) {
      next.remove(option);
    } else {
      next.add(option);
    }
    if (next.length == _notifier.value.disabledOptions.length &&
        next.containsAll(_notifier.value.disabledOptions)) {
      return true;
    }
    _notifier.value = _notifier.value.copyWith(disabledOptions: next);
    return true;
  }

  /// Whether a specific option is currently enabled.
  bool isOptionEnabled(T option) {
    if (!_options.contains(option)) return false;
    return !_notifier.value.disabledOptions.contains(option);
  }

  /// Returns the currently selected value.
  @override
  dynamic readValue() => _notifier.value.value;

  @override
  Widget buildContent(
    BuildContext context,
    BlockDialogController controller,
    DialogConfig configs,
  ) {
    return ValueListenableBuilder<RadioGroupChangeableValues>(
      valueListenable: _notifier,
      builder: (context, changeableValues, _) {
        return RadioGroup<T>(
          groupValue: changeableValues.value,
          onChanged: (v) {
            if (v != null && changeableValues.disabledOptions.contains(v)) {
              return;
            }
            setSelectedValue(v);
            onChanged?.call(v, controller);
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _options.map((option) {
              final selected = option == changeableValues.value;
              final optionEnabled =
                  !changeableValues.disabledOptions.contains(option);
              final label = labelBuilder?.call(option) ?? option.toString();
              return Material(
                color: Colors.transparent,
                child: RadioListTile<T>(
                  value: option,
                  enabled: optionEnabled,
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
                  title: itemBuilder != null
                      ? itemBuilder!(option, selected, configs)
                      : Text(label,
                          style: (configs.textStyle ?? TextStyle()).merge(
                              TextStyle(
                                      fontWeight:
                                          selected ? FontWeight.bold : null,
                                      color: optionEnabled == false
                                          ? Colors.grey
                                          : null)
                                  .merge(selectedStyle))),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

class RadioGroupChangeableValues<T> {
  RadioGroupChangeableValues({
    this.value,
    this.disabledOptions = const {},
  });

  final T? value;
  final Set<T> disabledOptions;

  RadioGroupChangeableValues<T> copyWith({
    T? value,
    Set<T>? disabledOptions,
  }) {
    return RadioGroupChangeableValues(
      value: value ?? this.value,
      disabledOptions: disabledOptions ?? this.disabledOptions,
    );
  }
}
