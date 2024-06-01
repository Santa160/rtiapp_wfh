import 'package:dio/dio.dart';
import 'package:rtiapp/src/common/exception/exception.dart';
import 'package:rtiapp/src/core/logger.dart';

import 'package:rtiapp/src/service/helper/endpoints.dart';
import 'package:rtiapp/src/service/part_of_service.dart';

class StateService extends StateInterface {
  @override
  Future createState(String data) async {
    try {
      var res = await dio.post(EndPoint.state, data: {"name": data});

      return res.data;
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      logger.e('Unexpected error: $e');
    }
  }

  @override
  Future deleteState(int stateId) async{
    try {
      var res = await dio.delete("${EndPoint.state}/delete?id=$stateId");

      return res.data;
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      logger.e('Unexpected error: $e');
    }
  }

  @override
  Future fetchState() async {
    try {
      var res = await dio.get(
        EndPoint.state,
      );

      return res.data;
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      logger.e('Unexpected error: $e');
    }
  }

  @override
  Future updateState(int stateId,String newData)async {
     try {
      var res = await dio.put(
        "${EndPoint.state}/update?id=$stateId",
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
