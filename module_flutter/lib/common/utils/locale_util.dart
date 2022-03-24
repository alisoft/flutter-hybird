import 'package:flutter/material.dart';

class LocaleUtil {
  static String localeToString(Locale locale) {
    return _rawToString(locale, '_');
  }

  static String localeToLanguageTag(Locale locale) {
    return _rawToString(locale, '-');
  }

  static String _rawToString(Locale locale, String separator) {
    final StringBuffer out = StringBuffer(locale.languageCode);
    if (locale.countryCode != null && locale.countryCode!.isNotEmpty) {
      out.write('$separator${locale.countryCode}');
    }
    return out.toString();
  }
}
