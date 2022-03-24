import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:module_flutter/common/http/base_http.dart';

final OtherHttp loginHttp = OtherHttp('https://github.com');

class OtherHttp extends BaseHttp {
  OtherHttp(baseUrl) : super(baseUrl: baseUrl);

  @override
  void init() {
    // do something
  }
}

Options buildOptions(bool? forceRefresh) {
  return buildCacheOptions(const Duration(days: 7), forceRefresh: forceRefresh);
}
