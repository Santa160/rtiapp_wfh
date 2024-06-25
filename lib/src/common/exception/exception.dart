import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:rtiapp/src/core/logger.dart';

void handleDioException(DioException e) {
  if (e.type == DioExceptionType.connectionTimeout) {
    logger.e('Connection timeout');
  } else if (e.type == DioExceptionType.sendTimeout) {
    logger.e('Send timeout');
  } else if (e.type == DioExceptionType.receiveTimeout) {
    logger.e('Receive timeout');
  } else if (e.type == DioExceptionType.badResponse) {
    logger.e('Response error: ${e.response?.statusCode}');
    EasyLoading.showError('${e.response?.data['message']}');
  } else if (e.type == DioExceptionType.cancel) {
    logger.e('Request canceled');
  } else {
    logger.e('Other error: ${e.message}');
  }
}
