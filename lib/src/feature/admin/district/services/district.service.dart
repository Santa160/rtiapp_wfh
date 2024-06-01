import 'package:dio/dio.dart';
import 'package:rtiapp/src/common/exception/exception.dart';
import 'package:rtiapp/src/core/logger.dart';

import 'package:rtiapp/src/service/helper/endpoints.dart';
import 'package:rtiapp/src/service/part_of_service.dart';

class DistrictService extends DistrictInterface {
  @override
  Future createDistrict(String stateId, String data) async {
    try {
      var res = await dio.post(EndPoint.district, data: {
        "name": data,
        "state_id": int.parse(stateId),
      });

      return res.data;
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      logger.e('Unexpected error: $e');
    }
  }

  @override
  Future deleteDistrict(int id) async {
    try {
      var res = await dio.delete("${EndPoint.district}/delete?id=$id");

      return res.data;
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      logger.e('Unexpected error: $e');
    }
  }

  @override
  Future fetchDistrict() async {
    try {
      var res = await dio.get(
        EndPoint.district,
      );

      return res.data;
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      logger.e('Unexpected error: $e');
    }
  }

  @override
  Future updateDistrict(int id, String newData) async {
    try {
      var res = await dio
          .put("${EndPoint.district}/update?id=$id", data: {"name": newData});

      return res.data;
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      logger.e('Unexpected error: $e');
    }
  }
}
