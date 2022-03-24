import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:module_flutter/common/utils/logger_util.dart';

class ErrorInterceptor extends InterceptorsWrapper {

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if(err.response!.statusCode == 401) {
      printErrorLog(err);
      BotToast.showSimpleNotification(title: '认证失败, 即将跳转到登陆页面');
      // TODO: do something.
      return;
    }
    handler.reject(err);
  }
}
