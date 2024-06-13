import 'package:dio/dio.dart';
import 'package:rtiapp/src/common/exception/exception.dart';
import 'package:rtiapp/src/core/logger.dart';

import 'package:rtiapp/src/service/helper/endpoints.dart';
import 'package:rtiapp/src/service/part_of_service.dart';

class PiaService extends PiaInterface {
  @override
  Future createPia(String data) async {
    try {
      var res = await dio.post(EndPoint.pia, data: {"name": data});

      return res.data;
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      logger.e('Unexpected error: $e');
    }
  }

  @override
  Future deletePia(int piaId) async {
    try {
      var res = await dio.delete("${EndPoint.pia}/$piaId");

      return res.data;
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      logger.e('Unexpected error: $e');
    }
  }

  @override
  Future fetchPia() async {
    try {
      var res = await dio.get(
        EndPoint.pia,
      );

      return res.data;
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      logger.e('Unexpected error: $e');
    }
  }

  @override
  Future updatePia(int piaId, String newData) async {
    try {
      var res =
          await dio.put("${EndPoint.pia}/$piaId", data: {"name": newData});

      return res.data;
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      logger.e('Unexpected error: $e');
    }
  }
}
