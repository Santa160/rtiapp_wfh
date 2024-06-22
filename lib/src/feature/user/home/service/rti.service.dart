import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:rtiapp/src/common/exception/exception.dart';
import 'package:rtiapp/src/common/utils/filepicker.helper.dart';
import 'package:rtiapp/src/core/logger.dart';
import 'package:rtiapp/src/service/helper/endpoints.dart';
import 'package:rtiapp/src/service/part_of_service.dart';

class RTIService extends RTIInterface {
  @override
  Future createRTI(
      List<String> questions, FilePickerModel file, String piaId) async {
    var data = FormData.fromMap({
      'document': MultipartFile.fromBytes(
        file.bytes as List<int>,
        filename: file.fileName,
        contentType: MediaType(
          "jpg",
          "png",
        ),
      ),
      "pia_id": piaId,
      'question[]': questions,
    });
    try {
      var res = await dio.post(EndPoint.rti, data: data);

      return res.data;
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      logger.e('Unexpected error: $e');
    }
  }

  @override
  Future fetchTermAndConditions() async {
    try {
      var res = await dio.get(EndPoint.termAndCondition);

      return res.data;
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      logger.e('Unexpected error: $e');
    }
  }

  @override
  Future fetchRTIs(int page, int limit) async {
    try {
      var res = await dio.get("${EndPoint.rti}?page=$page&limit=$limit");

      return res.data;
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      logger.e('Unexpected error: $e');
    }
  }

  @override
  Future fetchRTIStatus() async {
    try {
      var res = await dio.get(EndPoint.rtistatus);

      return res.data;
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      logger.e('Unexpected error: $e');
    }
  }

  @override
  Future fetchRTIDetails(String id) async {
    try {
      var res = await dio.get("${EndPoint.rti}/$id");

      var data = res.data;

      return data;
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      logger.e('Unexpected error: $e');
    }
  }

  @override
  Future fetchPia() async {
    try {
      var res = await dio.get(EndPoint.pia);

      return res.data;
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      logger.e('Unexpected error: $e');
    }
  }

  @override
  Future fetchRTIStatusLogsByRTIID(String rtiId, int page, int limit) async {
    try {
      var res = await dio
          .get("${EndPoint.rtiStatusLog}/$rtiId?page=$page&limit=$limit");

      var data = res.data;

      return data;
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      logger.e('Unexpected error: $e');
    }
  }
}
