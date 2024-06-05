import 'package:dio/dio.dart';
import 'package:rtiapp/src/common/exception/exception.dart';
import 'package:rtiapp/src/core/logger.dart';
import 'package:rtiapp/src/core/shared_pref.dart';
import 'package:rtiapp/src/feature/admin/application/models/req-models/StringUnit8.model.dart';
import 'package:rtiapp/src/service/helper/endpoints.dart';
import 'package:rtiapp/src/service/part_of_service.dart';
import 'package:http_parser/http_parser.dart';

class ApplicationService extends RTIStaffInterface {
  @override
  Future fetchRTIApplicationStaff() async {
    try {
      var res = await dio.get(EndPoint.rtiStaff);
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
      var res = await dio.get("${EndPoint.queryResponse}?rti_query_id=$id");
      return res.data;
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      logger.e('Unexpected error: $e');
    }
  }
}
