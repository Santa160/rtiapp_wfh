import 'package:dio/dio.dart';
import 'package:rtiapp/src/common/exception/exception.dart';
import 'package:rtiapp/src/core/logger.dart';
import 'package:rtiapp/src/service/helper/endpoints.dart';
import 'package:rtiapp/src/service/part_of_service.dart';

class FeeService extends FeeInterface {
  @override
  Future createFeeAmount(String amount) async {
    try {
      var res = await dio.get(EndPoint.fee);
      return res.data;
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      logger.e('Unexpected error: $e');
    }
  }

  @override
  Future fetchFeeAmount() async {
    try {
      var res = await dio.get(EndPoint.fee);
      return res.data;
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      logger.e('Unexpected error: $e');
    }
  }

  // @override
  // Future updateFeesAndChargesAmount(
  //     {required int feeid,
  //     required String newfeeAmount,
  //     required int chargeId,
  //     required String newChrageAmount}) async {
  //   try {
  //     var res = await dio.get("${EndPoint.fee}/per-page-amount");
  //     return res.data;
  //   } on DioException catch (e) {
  //     handleDioException(e);
  //   } catch (e) {
  //     logger.e('Unexpected error: $e');
  //   }
  // }

  @override
  Future fetchPerPageFeeAmount() async {
    try {
      var res = await dio.get("${EndPoint.fee}/per-page-amount");
      return res.data;
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      logger.e('Unexpected error: $e');
    }
  }

  @override
  Future updateFeesAndChargesAmount(String id,
      {String? newFeeAmount, String? newChargeAmount}) async {
    try {
      var res = await dio.put("${EndPoint.fee}/$id", data: {
        "amount": newFeeAmount,
        "amount_per_page": newChargeAmount,
      });
      return res.data;
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      logger.e('Unexpected error: $e');
    }
  }
}
