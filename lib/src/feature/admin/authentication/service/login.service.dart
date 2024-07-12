import 'package:dio/dio.dart';
import 'package:rtiapp/src/common/exception/exception.dart';
import 'package:rtiapp/src/core/logger.dart';
import 'package:rtiapp/src/service/helper/endpoints.dart';
import 'package:rtiapp/src/service/part_of_service.dart';

class Auth extends StaffAuthentication {
  @override
  Future login(String username, String password) async {
    try {
      var res = await dio.post(EndPoint.staffLogin,
          data: {"username": username, "password": password});

      return res.data;
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      logger.e('Unexpected error: $e');
    }
  }

  @override
  Future changePassword(
      String oldpassword, String newPassword) async {
    try {
      var res = await dio.put(EndPoint.changePassword, data: {
        "new_password": newPassword,
        "old_password": oldpassword,
      });

      return res.data;
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      logger.e('Unexpected error: $e');
    }
  }
}
