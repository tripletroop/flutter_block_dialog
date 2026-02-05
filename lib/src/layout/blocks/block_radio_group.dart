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
    super.flex = 1,
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
                dense: true,
                visualDensity: VisualDensity.compact,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
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
