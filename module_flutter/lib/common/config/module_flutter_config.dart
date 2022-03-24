import 'dart:io';
import 'package:module_flutter/common/utils/string_util.dart';

class ModuleFlutterConfig {
  static final bannerAppUnitId = Platform.isAndroid
      ? 'ca-app-pub-3943836014370168/3197070448'
      : 'ca-app-pub-3943836014370168/3232729466';

  static String apiKey = 'AIzaSyBAsdeEOZ3M7NosZwyddfOhNxt52TQfXVE';

  static final appId = Platform.isAndroid
      ? '1:505805882405:android:dd96d014114f0211a5abcc'
      : '1:505805882405:ios:b4af75d49876cefca5abcc';

  static String afDevKey = StringUtil.empty;

  static final afAppId = Platform.isAndroid
      ? "com.upcwangying.apps.flutter.boilerplate"
      : "1591788003";

  static const iCloudContainerId =
      'iCloud.com.upcwangying.apps.flutter.boilerplate';

  static String sentryDSN = StringUtil.empty;
}
