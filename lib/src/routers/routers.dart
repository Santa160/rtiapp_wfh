part of 'routers_import.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final _staffShellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter routerConfig = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: "/",
  routes: [
    ShellRoute(
      navigatorKey: _staffShellNavigatorKey,
      builder: (context, state, child) {
        return SideNavPage(child: child);
      },
      routes: [
        GoRoute(
          name: KRoutes.application,
          path: KRoutes.applicationPath,
          builder: (context, state) {
            return const ApplicationPage();
          },
          redirect: (context, state) async {
            var isStaff = SharedPrefHelper.isStaff();
            if (isStaff != null && isStaff) {
              return null;
            }
            return KRoutes.homePath;
          },
        ),
        GoRoute(
          name: KRoutes.state,
          path: KRoutes.statePath,
          builder: (context, state) {
            return const StatePage();
          },
          redirect: (context, state) async {
            var isStaff = SharedPrefHelper.isStaff();
            if (isStaff != null && isStaff) {
              return null;
            }
            return KRoutes.homePath;
          },
        ),
        GoRoute(
          name: KRoutes.pia,
          path: KRoutes.piaPath,
          builder: (context, state) {
            return const PiaPage();
          },
          redirect: (context, state) async {
            var isStaff = SharedPrefHelper.isStaff();
            if (isStaff != null && isStaff) {
              return null;
            }
            return KRoutes.homePath;
          },
        ),
        GoRoute(
          name: KRoutes.qualification,
          path: KRoutes.qualificationPath,
          builder: (context, state) {
            return const QualificationPage();
          },
          redirect: (context, state) async {
            var isStaff = SharedPrefHelper.isStaff();
            if (isStaff != null && isStaff) {
              return null;
            }
            return KRoutes.homePath;
          },
        ),
        GoRoute(
          name: KRoutes.district,
          path: KRoutes.districtPath,
          builder: (context, state) {
            return const DistrictPage();
          },
          redirect: (context, state) async {
            var isStaff = SharedPrefHelper.isStaff();
            if (isStaff != null && isStaff) {
              return null;
            }
            return KRoutes.homePath;
          },
        ),
        GoRoute(
          name: KRoutes.querystatus,
          path: KRoutes.querystatusPath,
          builder: (context, state) {
            return const QueryPage();
          },
          redirect: (context, state) async {
            var isStaff = SharedPrefHelper.isStaff();
            if (isStaff != null && isStaff) {
              return null;
            }
            return KRoutes.homePath;
          },
        ),
        GoRoute(
          name: KRoutes.rtiStatus,
          path: KRoutes.rtiStatusPath,
          builder: (context, state) {
            return const RTIStatusPage();
          },
          redirect: (context, state) async {
            var isStaff = SharedPrefHelper.isStaff();
            if (isStaff != null && isStaff) {
              return null;
            }
            return KRoutes.homePath;
          },
        ),
      ],
    ),

    GoRoute(
      name: KRoutes.home,
      path: KRoutes.homePath,
      builder: (context, state) {
        return const HomePage();
      },
      redirect: (context, state) async {
        var isStaff = SharedPrefHelper.isStaff();
        if (isStaff != null && !isStaff) {
          return null;
        }
        return KRoutes.citizenloginPath;
      },
    ),

    GoRoute(
      path: "/",
      redirect: (context, state) async {
        await SharedPrefHelper.init();

        var token = SharedPrefHelper.getToken("token");
        if (token != null) {
          var decoded = JwtDecoder.decode(token);

          if (decoded["role"] == "staff") {
            return JwtDecoder.isExpired(token)
                ? KRoutes.adminloginPath
                : KRoutes.applicationPath;
          } else {
            return JwtDecoder.isExpired(token)
                ? KRoutes.citizenloginPath
                : KRoutes.homePath;
          }
        }
        return KRoutes.adminloginPath;
      },
    ),
    GoRoute(
      name: KRoutes.stafflogin,
      path: KRoutes.citizenloginPath,
      builder: (context, state) {
        return const LoginPage();
      },
    ),
    GoRoute(
      name: KRoutes.adminlogin,
      path: KRoutes.adminloginPath,
      builder: (context, state) {
        return const AdminLoginPage();
      },
    ),
    GoRoute(
      name: KRoutes.registration,
      path: KRoutes.registrationPath,
      builder: (context, state) {
        return const ResgistrationPage();
      },
      redirect: (context, state) async {
        var isStaff = SharedPrefHelper.isStaff();
        if (isStaff != null && !isStaff) {
          return null;
        }
        return KRoutes.adminloginPath;
      },
    )

//update
  ],
  redirect: (context, state) async {
    await SharedPrefHelper.init();
    var token = SharedPrefHelper.getToken("token");

    if (state.uri.path == KRoutes.adminloginPath) {
      return KRoutes.adminloginPath;
    } else if (token == null) {
      return KRoutes.citizenloginPath;
    }
    return null;
  },
);
