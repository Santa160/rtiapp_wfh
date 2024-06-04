class EndPoint {
  static const baseUrl = "https://mspclrtiapi.globizsapp.com";
  // static const baseUrl = "https://664f0297fafad45dfae1e32d.mockapi.io";

  static const staffLogin = "/api/auth/login";
  static const sendOtp = "/api/sites/send-otp";
  static const verifyOtp = "/api/sites/verify-otp";
  static const state = "/api/states";
  static const district = "/api/districts";
  static const eduQ = "/api/education-qualifications";
  static const query = "/api/query-status";
  static const citizen = "/api/citizens";
  static const rti = "/api/rtis"; //GET POST
  static const rtistatus = "/api/status"; //GET
  static const termAndCondition = "/api/term-and-conditions";

  //https://mspclrtiapi.globizsapp.com/api/rtis/list-staff
  static const rtiStaff = "/api/rtis/list-staff"; //GET POST
  static const rtiStatusUpdate = "/api/rtis/status-update"; //GET POST
  static const queryResponse = "/api/rti-responses"; //GET POST
  static const rtiStatusLog = "/api//rti-status-logs"; //GET
}
