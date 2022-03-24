
import 'package:flutter/widgets.dart';

class IconFont extends IconData {
  const IconFont(int codePoint, { matchTextDirection = false })
      : super(
    codePoint,
    fontFamily: 'iconfont',
    matchTextDirection: matchTextDirection
  );
}

class IconFonts {
  static const IconData home = IconFont(0xe89a);
  static const IconData store = IconFont(0xe7f6);
  static const IconData search = IconFont(0xe8aa);
  static const IconData cart = IconFont(0xe760);
  static const IconData account = IconFont(0xe8a5);
  static const IconData scanning = IconFont(0xe7c9);
  static const IconData lights = IconFont(0xe79b);
  static const IconData dayTimeMode = IconFont(0xe7ff);
}
