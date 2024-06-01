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

abstract class RTIInterface extends ServiceIterface {
  Future<dynamic> createRTI(
      List<String> questions, FilePickerModel file, String piaId);
  Future<dynamic> fetchTermAndConditions();
  Future<dynamic> fetchRTIs();
  Future<dynamic> fetchRTIDetails(String id);
  Future<dynamic> fetchRTIStatus();
}

abstract class StaffAuthentication extends ServiceIterface {
  Future<dynamic> login(String username, String password);
}

abstract class StateInterface extends ServiceIterface {
  Future<dynamic> fetchState();
  Future<dynamic> createState(String data);
  Future<dynamic> deleteState(int stateId);
  Future<dynamic> updateState(int stateId, String newData);
}

abstract class QualificationInterface extends ServiceIterface {
  Future<dynamic> fetchQualification();
  Future<dynamic> createQualification(String data);
  Future<dynamic> deleteQualification(int qId);
  Future<dynamic> updateQualification(int qId, String newData);
}

abstract class DistrictInterface extends ServiceIterface {
  Future<dynamic> fetchDistrict();
  Future<dynamic> createDistrict(String stateId, String data);
  Future<dynamic> deleteDistrict(int id);
  Future<dynamic> updateDistrict(int id, String newData);
}

abstract class QueryInterface extends ServiceIterface {
  Future<dynamic> fetchQuery();
  Future<dynamic> createQuery(String data);
  Future<dynamic> deleteQuery(int id);
  Future<dynamic> updateQuery(int id, String newData);
}

abstract class RTIStatusInterface extends ServiceIterface {
  Future<dynamic> createRTIstatus(String data);
  Future<dynamic> deleteRTIstatus(int id);
  Future<dynamic> fetchRTIstatus();
  Future<dynamic> updateRTIstatus(int id, String newData);
}

abstract class RTIStaffInterface extends ServiceIterface {
  Future<dynamic> fetchRTIApplicationStaff();
}
