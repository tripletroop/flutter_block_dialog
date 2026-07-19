import 'package:block_dialog/src/layout/blocks/block.dart';
import 'package:block_dialog/src/theme/dialog_config.dart';
import 'package:block_dialog/src/core/block_dialog_controller.dart';
import 'package:flutter/material.dart';

class BlockText extends Block {
  /// Text block for titles, body copy, or messages.
  BlockText(
    String text, {
    super.flex = 1,
    super.override,
    this.strutStyle,
    this.style,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaler,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
    this.isDialogTitle = false,
    this.dontExpand = false,
    super.minHeight,
    super.blockTag,
    this.textAlign = TextAlign.center,
  }) : _text = ValueNotifier<String>(text);

  final ValueNotifier<String> _text;

  /// Current text value displayed by this block.
  String get text => _text.value;

  /// Update the displayed text and notify listeners.
  void setText(String value) {
    if (_text.value == value) return;
    _text.value = value;
  }

  /// Whether this text block is the dialog title, which will affect affect default styling. and min height
  final bool isDialogTitle;

  /// we expand min height of the BlockText that follow below conditions
  /// isDialogTitle is false and the row has only one block, then we expand the min height to 2x defaultMinBlockHeight
  /// if dontExpand is true, then we don't expand the min height even if the above conditions are met
  final bool dontExpand;

  /// Optional text style.
  final TextStyle? style;

  /// Optional strut style.
  final StrutStyle? strutStyle;

  /// Text alignment inside the block.
  final TextAlign textAlign;

  /// Optional text direction.
  final TextDirection? textDirection;

  /// Optional locale used for text shaping.
  final Locale? locale;

  /// Optional soft wrap behavior.
  final bool? softWrap;

  /// Optional overflow behavior.
  final TextOverflow? overflow;

  /// Optional text scaling configuration.
  final TextScaler? textScaler;

  /// Optional maximum number of lines.
  final int? maxLines;

  /// Optional semantic label.
  final String? semanticsLabel;

  /// Optional text width basis.
  final TextWidthBasis? textWidthBasis;

  /// Optional text height behavior.
  final TextHeightBehavior? textHeightBehavior;

  /// Optional text selection color.
  final Color? selectionColor;

  @override
  Widget buildContent(
    BuildContext context,
    BlockDialogController controller,
    DialogConfig configs,
  ) {
    return Center(
      child: ValueListenableBuilder<String>(
        valueListenable: _text,
        builder: (context, value, _) => Text(
          value,
          strutStyle: strutStyle,
          textAlign: textAlign,
          textDirection: textDirection,
          locale: locale,
          softWrap: softWrap,
          overflow: overflow,
          textScaler: textScaler,
          maxLines: maxLines,
          semanticsLabel: semanticsLabel,
          textWidthBasis: textWidthBasis,
          textHeightBehavior: textHeightBehavior,
          selectionColor: selectionColor,
          style: (configs.textStyle ?? TextStyle()).merge(isDialogTitle
              ? (TextStyle(fontWeight: FontWeight.bold).merge(style))
              : style),
        ),
      ),
    );
  }
}
