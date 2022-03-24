import 'package:dio/dio.dart';
import 'package:module_flutter/common/http/base_http.dart';

final LoginHttp loginHttp = LoginHttp();

class LoginHttp extends BaseHttp {

  @override
  void init() {
    interceptors.addAll([AuthorizationApiInterceptor()]);
  }
}

/// App相关 API
class AuthorizationApiInterceptor extends InterceptorsWrapper {

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // TODO: do something.
    options.headers['content-type'] = Headers.jsonContentType;
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
      handler.resolve(response);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    handler.reject(err);
  }
}

final LogoutHttp logoutHttp = LogoutHttp();

class LogoutHttp extends BaseHttp {

  @override
  void init() {
    interceptors.addAll([AuthorizationDeleteApiInterceptor()]);
  }
}

class AuthorizationDeleteApiInterceptor extends InterceptorsWrapper {

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // TODO: do something.
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.resolve(response);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    handler.reject(err);
  }
}
