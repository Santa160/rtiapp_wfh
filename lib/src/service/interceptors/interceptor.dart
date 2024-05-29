import 'package:dio/dio.dart';
import 'package:rtiapp/src/core/shared_pref.dart';

import '../../core/logger.dart';

class DioInterceptors extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    String? token = SharedPrefHelper.getToken("token");
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';

      if (options.data == null) {
        logger.e({
          "method": options.method,
          "header": options.headers,
          "url": options.uri,
          "data": options.data,
        });
      } else {
        logger.i({
          "method": options.method,
          "header": options.headers,
          "url": options.uri,
          "data": options.data,
        });
      }
    }

    super.onRequest(options, handler);
  }
}
