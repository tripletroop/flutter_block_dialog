import 'package:block_dialog/src/layout/blocks/block.dart';
import 'package:block_dialog/src/theme/dialog_config.dart';
import 'package:block_dialog/src/core/block_dialog_controller.dart';
import 'package:flutter/material.dart';

class BlockText extends Block {
  /// Text block for titles, body copy, or messages.
  BlockText({
    required this.text,
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
    super.minHeight = 100,
    super.blockTag,
    this.textAlign = TextAlign.center,
  });

  final String text;

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
      child: Text(
        text,
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
        style: style ?? const TextStyle(fontSize: 15),
      ),
    );
  }
}
