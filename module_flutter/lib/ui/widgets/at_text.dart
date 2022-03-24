import 'package:extended_text/extended_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class AtText extends SpecialText {
  static const String flag = '@';
  final int? start;

  final bool showAtBackground;

  AtText(TextStyle textStyle, SpecialTextGestureTapCallback? onTap,
      {this.showAtBackground = false, this.start})
      : super(
          flag,
          ' ',
          textStyle,
        );

  @override
  InlineSpan finishText() {
    TextStyle? textStyle =
        this.textStyle?.copyWith(color: Colors.blue, fontSize: 16.0);

    final atText = toString();

    return showAtBackground
        ? BackgroundTextSpan(
            background: Paint()..color = Colors.blue.withOpacity(0.15),
            text: atText,
            actualText: atText,
            start: start!,

            ///caret can move into special text
            deleteAll: true,
            style: textStyle,
            recognizer: (TapGestureRecognizer()
              ..onTap = () {
                if (onTap != null) onTap!(atText);
              }),
          )
        : SpecialTextSpan(
            text: atText,
            actualText: atText,
            start: start!,
            style: textStyle,
            recognizer: (TapGestureRecognizer()
              ..onTap = () {
                if (onTap != null) onTap!(atText);
              }),
          );
  }
}

class GitterSpecialTextSpanBuilder extends SpecialTextSpanBuilder {
  GitterSpecialTextSpanBuilder({this.showAtBackground = false});

  final bool showAtBackground;
  @override
  TextSpan build(String data,
      {TextStyle? textStyle, SpecialTextGestureTapCallback? onTap}) {
    if (kIsWeb) {
      return TextSpan(text: data, style: textStyle);
    }

    return super.build(data, textStyle: textStyle, onTap: onTap);
  }

  @override
  SpecialText? createSpecialText(String flag,
      {TextStyle? textStyle,
        SpecialTextGestureTapCallback? onTap,
        int? index}) {
    if (flag == '') {
      return null;
    }

    ///index is end index of start flag, so text start index should be index-(flag.length-1)
    if (isStart(flag, AtText.flag)) {
      return AtText(
        textStyle!,
        onTap,
        start: index! - (AtText.flag.length - 1),
        showAtBackground: showAtBackground,
      );
    }
    return null;
  }
}
