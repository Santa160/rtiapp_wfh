import 'package:dio/dio.dart';
import 'package:rtiapp/src/common/exception/exception.dart';
import 'package:rtiapp/src/core/logger.dart';

import 'package:rtiapp/src/service/helper/endpoints.dart';
import 'package:rtiapp/src/service/part_of_service.dart';

class PioService extends PioInterface {
  @override
  Future createPia(String data) async {
    try {
      var res = await dio.post(EndPoint.pio, data: {"name": data});

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
      var res = await dio.delete("${EndPoint.pio}/$piaId");

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
        EndPoint.pio,
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
          await dio.put("${EndPoint.pio}/$piaId", data: {"name": newData});

      return res.data;
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      logger.e('Unexpected error: $e');
    }
  }
}
