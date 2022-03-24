import 'package:dio/dio.dart';
import 'package:module_flutter/common/http/other_http.dart';
import 'package:module_flutter/common/utils/logger_util.dart';

class LoginDao {
  /// https://docs.github.com/cn/developers/apps/authorizing-oauth-apps
  static Future<dynamic> login(
      String? code) async {

    try {
      var response = await loginHttp.post(
        'your url',
      );
      return response.data;
    } on DioError catch (e) {
      printErrorLog(e);
    }

    return null;
  }
}
