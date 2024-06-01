import 'package:dio/dio.dart';
import 'package:rtiapp/src/common/exception/exception.dart';
import 'package:rtiapp/src/core/logger.dart';
import 'package:rtiapp/src/feature/admin/state/models/res_models/state.model.dart';

import 'package:rtiapp/src/service/helper/endpoints.dart';
import 'package:rtiapp/src/service/part_of_service.dart';

class QualificationService extends QualificationInterface {
  @override
  Future createQualification(String data) async {
    try {
      var res = await dio.post(EndPoint.eduQ, data: {"name": data});

      return res.data;
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      logger.e('Unexpected error: $e');
    }
  }

  @override
  Future deleteQualification(int qId) async{
    try {
      var res = await dio.delete("${EndPoint.eduQ}/delete?id=$qId");

      return res.data;
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      logger.e('Unexpected error: $e');
    }
  }

  @override
  Future fetchQualification() async {
    try {
      var res = await dio.get(
        EndPoint.eduQ,
      );

      return res.data;
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      logger.e('Unexpected error: $e');
    }
  }

  @override
  Future updateQualification(int qId,String newData)async {
     try {
      var res = await dio.put(
        "${EndPoint.eduQ}/update?id=$qId",
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
