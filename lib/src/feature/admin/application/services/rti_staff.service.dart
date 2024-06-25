import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:rtiapp/src/common/exception/exception.dart';
import 'package:rtiapp/src/core/logger.dart';
import 'package:rtiapp/src/core/shared_pref.dart';
import 'package:rtiapp/src/feature/admin/application/models/req-models/StringUnit8.model.dart';
import 'package:rtiapp/src/service/helper/endpoints.dart';
import 'package:rtiapp/src/service/part_of_service.dart';
import 'package:http_parser/http_parser.dart';

class ApplicationService extends RTIStaffInterface {
  @override
  Future fetchRTIApplicationStaff(int page, int limit) async {
    try {
      var res = await dio.get("${EndPoint.rtiStaff}?page=$page&limit=$limit");
      return res.data;
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      logger.e('Unexpected error: $e');
    }
  }

  @override
  Future updateRTIApplicationStatus(int rtiId, int statusId) async {
    var userinfo = SharedPrefHelper.getUserInfo();

    if (userinfo != null) {
      try {
        var res = await dio.post(EndPoint.rtiStatusUpdate, data: {
          "rti_id": rtiId,
          "status_id": statusId,
          "staff_id": userinfo.id
        });
        return res.data;
      } on DioException catch (e) {
        handleDioException(e);
      } catch (e) {
        logger.e('Unexpected error: $e');
      }
    }
  }

  @override
  Future createQueryResponse(
      Map<String, dynamic> data, List<StringUint8ListModel> files) async {
    List<MultipartFile> f = [];

    for (var element in files) {
      f.add(MultipartFile.fromBytes(
        element.uint8ListValue as List<int>,
        filename: element.stringValue,
        contentType: MediaType("pdf", "jpg"),
      ));
    }

    var formdata = FormData.fromMap({
      "document[]": f,
      ...data,
    });
    try {
      var res = await dio.post(EndPoint.queryResponse, data: formdata);
      return res.data;
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      logger.e('Unexpected error: $e');
    }
  }

  @override
  Future fetchResponseById(String id) async {
    try {
      var res = await dio.get("${EndPoint.queryResponse}/$id");
      return res.data;
    } on DioException catch (e) {
      EasyLoading.showInfo("No Response!");
      handleDioException(e);
      return 'No Response';
    } catch (e) {
      logger.e('Unexpected error: $e');
    }
  }

  @override
  Future deleteImages(List<int> ids) async {
    var data = FormData.fromMap({
      "rti_response_id[]": ids,
    });
    try {
      var res = await dio.post(EndPoint.deleteDocs, data: data);
      return res.data;
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      logger.e('Unexpected error: $e');
    }
  }

  @override
  Future updateResponse(String rtiResId, String responseText,
      List<StringUint8ListModel> files) async {
    List<MultipartFile> f = [];

    for (var element in files) {
      f.add(MultipartFile.fromBytes(
        element.uint8ListValue as List<int>,
        filename: element.stringValue,
        contentType: MediaType("png", "jpg"),
      ));
    }
    var formdata = FormData.fromMap({
      "document[]": f,
      "rti_response_id": rtiResId,
      "response": responseText
    });
    try {
      var res = await dio.post(EndPoint.updateResponse, data: formdata);
      return res.data;
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      logger.e('Unexpected error: $e');
    }
  }
}
