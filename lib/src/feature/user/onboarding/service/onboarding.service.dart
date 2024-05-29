import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:rtiapp/src/common/exception/exception.dart';
import 'package:rtiapp/src/common/utils/filepicker.helper.dart';
import 'package:rtiapp/src/core/logger.dart';
import 'package:rtiapp/src/service/helper/endpoints.dart';
import 'package:rtiapp/src/service/part_of_service.dart';

class OnboardingServices extends CitizenOnboardingInterface {
  // Send OTP
  @override
  Future sendOtp(String mobile) async {
    try {
      var res = await dio.post(EndPoint.sendOtp, data: {"mobile_no": mobile});

      return res.data;
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      logger.e('Unexpected error: $e');
    }
  }

// Verify OTP
  @override
  Future verifyOtp(String mobile, String code) async {
    try {
      var res = await dio
          .post(EndPoint.verifyOtp, data: {"mobile_no": mobile, "code": code});
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
      var res = await dio.get(EndPoint.state);

      return res.data;
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      logger.e('Unexpected error: $e');
    }
  }

  @override
  Future fetchEduQ() async {
    try {
      var res = await dio.get(EndPoint.eduQ);
      return res.data;
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      logger.e('Unexpected error: $e');
    }
  }

  @override
  Future fetchDisctrict({String? id}) async {
    try {
      var res = await dio.get("${EndPoint.district}?state_id=$id");

      return res.data;
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      logger.e('Unexpected error: $e');
    }
  }

  @override
  Future createCitizen(
      Map<String, dynamic> citizenDto, FilePickerModel? file) async {
    var data = FormData.fromMap({
      if (file != null)
        'bpl_document': MultipartFile.fromBytes(
          file.bytes as List<int>,
          filename: file.fileName,
          contentType: MediaType(
            "jpg",
            "jpeg",
          ),
        ),
      ...citizenDto
    });
    try {
      var res = await dio.post(EndPoint.citizen, data: data);

      return res.data;
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      logger.e('Unexpected error: $e');
    }
  }
}
