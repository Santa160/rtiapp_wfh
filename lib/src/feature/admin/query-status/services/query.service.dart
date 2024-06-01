import 'package:dio/dio.dart';
import 'package:rtiapp/src/common/exception/exception.dart';
import 'package:rtiapp/src/core/logger.dart';

import 'package:rtiapp/src/service/helper/endpoints.dart';
import 'package:rtiapp/src/service/part_of_service.dart';

class QueryService extends QueryInterface {
  @override
  Future createQuery(String data) async {
    try {
      var res = await dio.post(EndPoint.query, data: {"name": data});

      return res.data;
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      logger.e('Unexpected error: $e');
    }
  }

  @override
  Future deleteQuery(int id) async{
    try {
      var res = await dio.delete("${EndPoint.query}/$id");

      return res.data;
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      logger.e('Unexpected error: $e');
    }
  }

  @override
  Future fetchQuery() async {
    try {
      var res = await dio.get(
        EndPoint.query,
      );

      return res.data;
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      logger.e('Unexpected error: $e');
    }
  }

  @override
  Future updateQuery(int id,String newData)async {
     try {
      var res = await dio.put(
        "${EndPoint.query}/$id",
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
