import 'package:block_dialog/src/layout/blocks/block.dart';
import 'package:block_dialog/src/theme/dialog_config.dart';
import 'package:block_dialog/src/core/block_dialog_controller.dart';
import 'package:material_ui/material_ui.dart';

/// Dropdown block that stores a single selected value of type [T].
class BlockDropdown<T> extends Block {
  BlockDropdown({
    /// Options to present in the dropdown.
    required List<T> options,
    T? initialValue,
    this.onChanged,
    this.itemBuilder,
    this.labelBuilder,
    this.hintText,
    this.hintStyle,
    String? title,
    this.titleBuilder,
    this.titleStyle,
    this.titlePadding = const EdgeInsets.fromLTRB(12, 0, 12, 4),
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 12.0),
    this.isExpanded = true,
    this.isDense = true,
    this.icon,
    this.iconEnabledColor,
    this.iconDisabledColor,
    this.iconSize = 24.0,
    this.dropdownColor,
    this.buttonBorderRadius,
    this.elevation = 8,
    this.menuMaxHeight,
    this.itemHeight = kMinInteractiveDimension,
    this.underline,
    this.focusColor,
    this.enableFeedback,
    this.focusNode,
    this.autofocus = false,
    this.textStyle,
    this.selectedStyle,
    super.flex = 1,
    super.blockTag,
    super.override,
    super.minHeight,
  })  : assert(options.contains(initialValue) || initialValue == null,
            'initialValue must be one of the options or null'),
        assert(options.isNotEmpty, 'options must contain at least 1 element'),
        _options = options,
        _notifier = ValueNotifier(DropdownChangeableValues<T>(
          value: initialValue,
          title: title,
        ));

  final List<T> _options;

  /// Called after the user picks an option.
  final void Function(T? value, BlockDialogController controller)? onChanged;

  /// Custom widget for an option. Used both in the open menu and as the
  /// closed display of the selected option.
  final Widget Function(T option, bool selected, DialogConfig configs,
      BlockDialogController controller)? itemBuilder;

  /// Text for an option when [itemBuilder] is not provided.
  /// Defaults to `option.toString()`.
  final String Function(T option)? labelBuilder;

  /// Text shown when nothing is selected.
  final String? hintText;
  final TextStyle? hintStyle;

  /// Current title shown above the options, or null if none.
  String? get title => _notifier.value.title;

  /// Optional custom title widget; takes precedence over the built-in title
  /// text. Always called, even when the current title is null, so the builder
  /// must handle null (e.g. return `SizedBox.shrink()`).
  final Widget Function(String? title, DialogConfig configs,
      BlockDialogController controller)? titleBuilder;

  final TextStyle? titleStyle;
  final EdgeInsetsGeometry titlePadding;

  /// Padding around the dropdown button itself.
  final EdgeInsetsGeometry? contentPadding;

  /// Whether the dropdown fills the available width.
  final bool isExpanded;

  /// Whether to reduce the height of the dropdown button.
  final bool isDense;

  /// Optional custom dropdown arrow icon.
  final Widget? icon;

  /// Optional arrow color while enabled.
  final Color? iconEnabledColor;

  /// Optional arrow color while disabled.
  final Color? iconDisabledColor;

  /// Arrow icon size.
  final double iconSize;

  /// Optional background color of the open menu.
  final Color? dropdownColor;

  /// Optional corner radius of the open menu.
  final BorderRadius? buttonBorderRadius;

  /// Elevation of the open menu.
  final int elevation;

  /// Optional maximum height of the open menu.
  final double? menuMaxHeight;

  /// Height of each menu item.
  final double? itemHeight;

  /// Optional widget drawn below the button. Pass `SizedBox.shrink()` to
  /// hide the default underline.
  final Widget? underline;

  /// Optional focus highlight color.
  final Color? focusColor;

  /// Optional haptic/acoustic feedback behavior.
  final bool? enableFeedback;

  /// Optional focus node for the dropdown button.
  ///
  /// The caller owns the node and is responsible for disposing it.
  final FocusNode? focusNode;

  /// Whether the dropdown should request focus when first shown.
  final bool autofocus;

  final TextStyle? textStyle;
  final TextStyle? selectedStyle;

  final ValueNotifier<DropdownChangeableValues<T>> _notifier;

  /// Current selected value.
  T? get selectedValue => _notifier.value.value;

  /// Update selected value at runtime. Pass null to clear the selection.
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
    return ValueListenableBuilder<DropdownChangeableValues<T>>(
      valueListenable: _notifier,
      builder: (context, changeableValues, _) {
        final baseStyle =
            DefaultTextStyle.of(context).style.merge(configs.textStyle);
        return Column(
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
                  style: baseStyle
                      .merge(const TextStyle(fontWeight: FontWeight.w600))
                      .merge(titleStyle),
                ),
              ),
            Padding(
              padding: contentPadding ?? EdgeInsets.zero,
              child: DropdownButton<T>(
                value: changeableValues.value,
                hint: hintText == null
                    ? null
                    : Text(
                        hintText!,
                        style: baseStyle
                            .merge(const TextStyle(color: Colors.grey))
                            .merge(hintStyle),
                      ),
                isExpanded: isExpanded,
                isDense: isDense,
                icon: icon,
                iconEnabledColor: iconEnabledColor,
                iconDisabledColor: iconDisabledColor,
                iconSize: iconSize,
                dropdownColor: dropdownColor,
                borderRadius: buttonBorderRadius,
                elevation: elevation,
                menuMaxHeight: menuMaxHeight,
                itemHeight: itemHeight,
                underline: underline,
                focusColor: focusColor,
                enableFeedback: enableFeedback,
                focusNode: focusNode,
                autofocus: autofocus,
                style: baseStyle,
                onChanged: (v) {
                  if (v != null &&
                      changeableValues.disabledOptions.contains(v)) {
                    return;
                  }
                  setSelectedValue(v);
                  onChanged?.call(v, controller);
                },
                items: _options.map((option) {
                  final selected = option == changeableValues.value;
                  final optionEnabled =
                      !changeableValues.disabledOptions.contains(option);
                  final label = labelBuilder?.call(option) ?? option.toString();
                  return DropdownMenuItem<T>(
                    value: option,
                    enabled: optionEnabled,
                    child: itemBuilder != null
                        ? itemBuilder!(option, selected, configs, controller)
                        : Text(
                            label,
                            overflow: TextOverflow.ellipsis,
                            style: baseStyle.merge(TextStyle(
                              fontWeight: selected ? FontWeight.bold : null,
                              color: optionEnabled ? null : Colors.grey,
                            ).merge(selectedStyle)),
                          ),
                  );
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
  }
}

class DropdownChangeableValues<T> {
  DropdownChangeableValues({
    this.value,
    this.title,
    this.disabledOptions = const {},
  });

  final T? value;
  final String? title;
  final Set<T> disabledOptions;

  DropdownChangeableValues<T> copyWith({
    T? value,
    bool clearValue = false,
    String? title,
    bool clearTitle = false,
    Set<T>? disabledOptions,
  }) {
    return DropdownChangeableValues<T>(
      value: clearValue ? null : (value ?? this.value),
      title: clearTitle ? null : (title ?? this.title),
      disabledOptions: disabledOptions ?? this.disabledOptions,
    );
  }
}
