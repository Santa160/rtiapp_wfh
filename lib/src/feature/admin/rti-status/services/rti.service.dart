import 'package:dio/dio.dart';
import 'package:rtiapp/src/common/exception/exception.dart';
import 'package:rtiapp/src/core/logger.dart';

import 'package:rtiapp/src/service/helper/endpoints.dart';
import 'package:rtiapp/src/service/part_of_service.dart';

class RTIStatusService extends RTIStatusInterface {
  @override
  Future createRTIstatus(String data) async {
    try {
      var res = await dio.post(EndPoint.rtistatus, data: {"name": data});

      return res.data;
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      logger.e('Unexpected error: $e');
    }
  }

  @override
  Future deleteRTIstatus(int id) async{
    try {
      var res = await dio.delete("${EndPoint.rtistatus}/$id");

      return res.data;
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      logger.e('Unexpected error: $e');
    }
  }

  @override
  Future fetchRTIstatus() async {
    try {
      var res = await dio.get(
        EndPoint.rtistatus,
      );

      return res.data;
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      logger.e('Unexpected error: $e');
    }
  }

  @override
  Future updateRTIstatus(int id,String newData)async {
     try {
      var res = await dio.put(
        "${EndPoint.rtistatus}/$id",
        data: {
          "name":newData
        }
      );

      return res.data;
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      logger.e('Unexpected error: $e');
    }
  }
}
