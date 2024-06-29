class KRoutes {
  static const String adminlogin = "Admin Login";
  static const String adminloginPath = "/admin-login";
  static const String stafflogin = "Login";
  static const String citizenloginPath = "/login";
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
  static const String pia = "PIA";
  static const String piaPath = "/pia";
  static const String fee = "Fee";
  static const String feePath = "/fee";
  static List<String> routeNames = [
    application,
    querystatus,
    rtiStatus,
    qualification,
    state,
    district,
    pia,
    setting,
  ];
}

class NavTab {
  final String title;
  final String route;
  final List<NavTab>? subRoute;

  NavTab({
    required this.title,
    required this.route,
    this.subRoute,
  });
}

List<NavTab> sideNavItesm = [
  NavTab(title: KRoutes.application, route: KRoutes.applicationPath),
  NavTab(title: KRoutes.rtiStatus, route: KRoutes.rtiStatusPath),
  NavTab(title: KRoutes.querystatus, route: KRoutes.querystatusPath),
  NavTab(
    title: KRoutes.setting,
    route: KRoutes.settingPath,
    subRoute: [
      NavTab(title: KRoutes.qualification, route: KRoutes.qualificationPath),
      NavTab(title: KRoutes.fee, route: KRoutes.feePath),
      NavTab(title: KRoutes.state, route: KRoutes.statePath),
      NavTab(title: KRoutes.district, route: KRoutes.districtPath),
      NavTab(title: KRoutes.pia, route: KRoutes.piaPath),
    ],
  ),
];
