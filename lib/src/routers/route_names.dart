class KRoutes {
  static const String adminlogin = "Admin Login";
  static const String adminloginPath = "/admin-login";
  static const String stafflogin = "Login";
  static const String staffloginPath = "/login";
  static const String registration = "Registration";
  static const String registrationPath = "/registration";
  static const String home = "Home";
  static const String homePath = "/home";
  static const String rti = "RTI";
  static const String rtiPath = "/rti";

  //citizen
  static const String submitRTI = "Submit RTI";
  static const String submitRTIPath = "/submit-rti";

  //admin routes

  static const String application = "Application";
  static const String applicationPath = "/application";
  static const String setting = "Setting";
  static const String settingPath = "/setting";
  static const String querystatus = "Query Status";
  static const String querystatusPath = "/query-status";
  static const String rtiStatus = "RTI Status";
  static const String rtiStatusPath = "/rti-status";
  static const String qualification = "Qualification";
  static const String qualificationPath = "/qualification";
  static const String state = "State";
  static const String statePath = "/state";
  static const String district = "District";
  static const String districtPath = "/district";
  static List<String> routeNames = [
    application,
    setting,
    querystatus,
    rtiStatus,
    qualification,
    state,
    district
  ];
}
