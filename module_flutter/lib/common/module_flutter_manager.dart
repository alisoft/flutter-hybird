
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/widgets.dart';

class ModuleFlutterManager {
  String? version;
  String? buildNumber;
  BuildContext? context;
  FirebaseAnalytics? analytics;
  FirebaseAnalyticsObserver? observer;

  // 单例公开访问点
  factory ModuleFlutterManager() => _gitterManager()!;

  // 静态私有成员，没有初始化
  static ModuleFlutterManager? _instance;

  // 私有构造函数
  ModuleFlutterManager._() {
    // 具体初始化代码
  }

  // 静态、同步、私有访问点
  static ModuleFlutterManager? _gitterManager() {
    _instance ??= ModuleFlutterManager._();
    return _instance;
  }

}
