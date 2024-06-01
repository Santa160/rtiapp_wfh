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
                    ? KRoutes.staffloginPath
                    : KRoutes.homePath;
              }
            }
            return null;
          },
        ),
        GoRoute(
          name: KRoutes.state,
          path: KRoutes.statePath,
          builder: (context, state) {
            return const StatePage();
          },
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
                    ? KRoutes.staffloginPath
                    : KRoutes.homePath;
              }
            }
            return null;
          },
        ),
        GoRoute(
          name: KRoutes.qualification,
          path: KRoutes.qualificationPath,
          builder: (context, state) {
            return const QualificationPage();
          },
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
                    ? KRoutes.staffloginPath
                    : KRoutes.homePath;
              }
            }
            return null;
          },
        ),
        GoRoute(
          name: KRoutes.district,
          path: KRoutes.districtPath,
          builder: (context, state) {
            return const DistrictPage();
          },
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
                    ? KRoutes.staffloginPath
                    : KRoutes.homePath;
              }
            }
            return null;
          },
        ),
        GoRoute(
          name: KRoutes.querystatus,
          path: KRoutes.querystatusPath,
          builder: (context, state) {
            return const QueryPage();
          },
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
                    ? KRoutes.staffloginPath
                    : KRoutes.homePath;
              }
            }
            return null;
          },
        ),
        GoRoute(
          name: KRoutes.rtiStatus,
          path: KRoutes.rtiStatusPath,
          builder: (context, state) {
            return const RTIStatusPage();
          },
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
                    ? KRoutes.staffloginPath
                    : KRoutes.homePath;
              }
            }
            return null;
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
                ? KRoutes.staffloginPath
                : KRoutes.homePath;
          }
        }
        return KRoutes.staffloginPath;
      },
    ),
    GoRoute(
      name: KRoutes.stafflogin,
      path: KRoutes.staffloginPath,
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
    )

//update
  ],
  redirect: (context, state) async {
    await SharedPrefHelper.init();
    var token = SharedPrefHelper.getToken("token");
    await InitialSetup.status();
    await InitialSetup.queryStatus();

    logger.f(state.uri.path);

    if (state.uri.path == KRoutes.adminloginPath) {
      return KRoutes.adminloginPath;
    } else if (token == null) {
      return KRoutes.staffloginPath;
    }
    return null;
  },
);
