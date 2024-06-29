class EndPoint {
  static const baseUrl = "https://mspclrtiapi.globizsapp.com";

  // staff apis
  static const staffLogin = "/api/auth/login";
  static const state = "/api/states";
  static const district = "/api/districts";
  static const eduQ = "/api/education-qualifications";
  static const query = "/api/query-status";
  static const rtiStaff = "/api/rtis/list-staff"; //GET POST
  static const rtiStatusUpdate = "/api/rtis/status-update"; //GET POST
  static const queryResponse = "/api/rti-responses"; //GET POST
  static const updateResponse =
      "/api/rti-responses/update-rti-response"; //GET POST
  static const deleteDocs =
      "/api/rti-responses/delete-response-document"; //GET POST
  static const rtiStatusLog = "/api/rti-status-logs"; //GET
  static const paymentConfirmation = "/api/payments/confirm"; //GET
  static const responsePaymentConfirmation =
      "/api/response-payments/confirm"; //GET
  static const pay = "/api//rti-response-payments/pay"; //GET
  static const rtistatus = "/api/status"; //GET

  //citizen apis
  static const sendOtp = "/api/sites/send-otp";
  static const verifyOtp = "/api/sites/verify-otp";
  static const termAndCondition = "/api/term-and-conditions";
  static const citizen = "/api/citizens";
  static const rti = "/api/rtis"; //GET POST
  static const pia = "/api/pia";
  static const fee = "/api/fee";

  //common apis
}
