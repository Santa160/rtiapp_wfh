part of 'part_of_service.dart';

abstract class ServiceIterface {
  late final Dio _dio;
  ServiceIterface() {
    _dio = Dio(BaseOptions(baseUrl: EndPoint.baseUrl));
    _dio.interceptors.add(DioInterceptors());
  }
  Dio get dio => _dio;
}

abstract class CitizenOnboardingInterface extends ServiceIterface {
  Future<dynamic> sendOtp(String mobile);
  Future<dynamic> verifyOtp(String mobile, String code);
  //new registration
  Future<dynamic> fetchState();
  Future<dynamic> fetchDisctrict({String? id});
  Future<dynamic> fetchEduQ();
  Future<dynamic> createCitizen(
      Map<String, dynamic> citizenDto, FilePickerModel? file);
  //RTI Resquest submit

}

abstract class RTIInterface extends ServiceIterface{
  Future<dynamic> createRTI(List<String> questions,FilePickerModel file,String piaId);

}

abstract class StaffAuthentication extends ServiceIterface {
  Future<dynamic> login(String username, String password);
}
