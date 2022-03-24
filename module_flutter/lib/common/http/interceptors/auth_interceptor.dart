import 'package:dio/dio.dart';

class AuthorizationInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Authorization'] = 'your token';
    super.onRequest(options, handler);
  }
}
