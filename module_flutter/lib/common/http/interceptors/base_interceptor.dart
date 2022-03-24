import 'package:dio/dio.dart';
import 'package:module_flutter/common/constant/module_flutter_constants.dart';

class BaseInterceptor extends InterceptorsWrapper {
  final String baseUrl;

  BaseInterceptor(this.baseUrl);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options
      ..baseUrl = baseUrl
      ..connectTimeout = ModuleFlutterConstants.timeOut * 1000 //5s
      ..receiveTimeout = ModuleFlutterConstants.timeOut * 1000
      ..headers.addAll(ModuleFlutterConstants.headers);
    super.onRequest(options, handler);
  }
}
