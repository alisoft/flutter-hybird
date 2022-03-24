import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio/native_imp.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter/foundation.dart';
import 'package:module_flutter/common/constant/module_flutter_constants.dart';
import 'package:module_flutter/common/http/interceptors/base_interceptor.dart';
import 'package:module_flutter/common/http/interceptors/error_interceptor.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

var dio = Dio();

// 必须是顶层函数
dynamic _parseAndDecode(String response) {
  return jsonDecode(response);
}

Future parseJson(String text) {
  return compute(_parseAndDecode, text);
}

abstract class BaseHttp extends DioForNative {
  BaseHttp({baseUrl = ModuleFlutterConstants.baseUrl}) {
    /// 初始化 加入app通用处理
    (transformer as DefaultTransformer).jsonDecodeCallback = parseJson;
    interceptors.addAll([
      ErrorInterceptor(),
      BaseInterceptor(baseUrl),
      DioCacheManager(
        CacheConfig(
          baseUrl: baseUrl,
          databaseName: 'GitterCache',
          defaultMaxStale: const Duration(days: 10),
        ),
      ).interceptor, if (!kReleaseMode) ...[
            PrettyDioLogger(
              requestHeader: true,
              requestBody: true,
              responseBody: true,
              responseHeader: false,
              error: true,
              compact: true,
              maxWidth: 90,
            )
          ],
    ]);
    init();
  }

  void init();
}
