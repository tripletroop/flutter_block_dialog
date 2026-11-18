import 'package:block_dialog/src/layout/blocks/block.dart';
import 'package:block_dialog/src/theme/dialog_config.dart';
import 'package:block_dialog/src/core/block_dialog_controller.dart';
import 'package:material_ui/material_ui.dart';

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
    this.focusNodeBuilder,
    this.autofocus = false,
    this.tileColor,
    this.selectedTileColor,
    this.enableFeedback,
    this.isThreeLine = false,
    this.dense = true,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 12.0),
    this.shape,
    this.controlAffinity = ListTileControlAffinity.platform,
    this.tileTitleAlignment,
    this.textStyle,
    this.selectedStyle,
    String? title,
    this.titleBuilder,
    this.titleStyle,
    this.titlePadding = const EdgeInsets.fromLTRB(12, 0, 12, 4),
    super.flex = 1,
    super.blockTag,
    super.override,
    super.minHeight,
  })  : assert(options.contains(initialValue) || initialValue == null,
            'initialValue must be one of the options or null'),
        assert(options.length > 1, 'options must contain at least 2 elements'),
        _options = options,
        _notifier = ValueNotifier(RadioGroupChangeableValues<T>(
          value: initialValue,
          title: title,
        )),
        _autofocusTarget = autofocus ? (initialValue ?? options.first) : null;

  final List<T> _options;

  final void Function(T? value, BlockDialogController controller)? onChanged;
  final Widget Function(T option, bool selected, DialogConfig configs,
      BlockDialogController controller)? itemBuilder;
  final String Function(T option)? labelBuilder;

  /// Current title shown above the options, or null if none.
  String? get title => _notifier.value.title;

  /// Optional custom title widget; takes precedence over the built-in title
  /// text. Always called, even when the current title is null, so the builder
  /// must handle null (e.g. return `SizedBox.shrink()`).
  final Widget Function(String? title, DialogConfig configs,
      BlockDialogController controller)? titleBuilder;

  final TextStyle? titleStyle;
  final EdgeInsetsGeometry titlePadding;

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

  /// Returns the [FocusNode] for an option's tile.
  ///
  /// Must return the same instance for the same option on every call
  /// (e.g. from a map the caller owns). The caller is responsible for
  /// disposing the nodes.
  final FocusNode Function(T option)? focusNodeBuilder;

  /// Whether the group should request focus when first shown.
  ///
  /// Focus goes to the option matching `initialValue`, or the first option
  /// if no initial value is given. If false, no option is focused
  /// automatically. The target is fixed at construction and does not follow
  /// later selection changes.
  final bool autofocus;

  final T? _autofocusTarget;

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
  final ListTileTitleAlignment? tileTitleAlignment;

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
    _notifier.value = _notifier.value.copyWith(
      value: value,
      clearValue: value == null,
    );
    return true;
  }

  /// Update the title at runtime. Pass null to remove it.
  void setTitle(String? title) {
    if (_notifier.value.title == title) return;
    _notifier.value = _notifier.value.copyWith(
      title: title,
      clearTitle: title == null,
    );
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
    return ValueListenableBuilder<RadioGroupChangeableValues<T>>(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (titleBuilder != null)
                  titleBuilder!(changeableValues.title, configs, controller)
                else if (changeableValues.title != null)
                  Padding(
                    padding: titlePadding,
                    child: Text(
                      changeableValues.title!,
                      style: DefaultTextStyle.of(context)
                          .style
                          .merge(configs.textStyle)
                          .merge(const TextStyle(fontWeight: FontWeight.w600))
                          .merge(titleStyle),
                    ),
                  ),
                ..._options.map((option) {
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
                      focusNode: focusNodeBuilder?.call(option),
                      autofocus: autofocus && option == _autofocusTarget,
                      tileColor: tileColor,
                      selectedTileColor: selectedTileColor,
                      enableFeedback: enableFeedback,
                      isThreeLine: isThreeLine,
                      dense: dense,
                      contentPadding: contentPadding,
                      shape: shape,
                      controlAffinity: controlAffinity,
                      titleAlignment: tileTitleAlignment,
                      title: itemBuilder != null
                          ? itemBuilder!(option, selected, configs, controller)
                          : Text(label,
                              style: (configs.textStyle ?? const TextStyle())
                                  .merge(TextStyle(
                                          fontWeight:
                                              selected ? FontWeight.bold : null,
                                          color: optionEnabled == false
                                              ? Colors.grey
                                              : null)
                                      .merge(selectedStyle))),
                    ),
                  );
                }),
              ]),
        );
      },
    );
  }
}

class RadioGroupChangeableValues<T> {
  RadioGroupChangeableValues({
    this.value,
    this.title,
    this.disabledOptions = const {},
  });

  final T? value;
  final String? title;
  final Set<T> disabledOptions;

  RadioGroupChangeableValues<T> copyWith({
    T? value,
    bool clearValue = false,
    String? title,
    bool clearTitle = false,
    Set<T>? disabledOptions,
  }) {
    return RadioGroupChangeableValues<T>(
      value: clearValue ? null : (value ?? this.value),
      title: clearTitle ? null : (title ?? this.title),
      disabledOptions: disabledOptions ?? this.disabledOptions,
    );
  }
}
