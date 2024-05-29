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
        )
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

    if (token == null) {
      return KRoutes.staffloginPath;
    }
    return null;
  },
);
