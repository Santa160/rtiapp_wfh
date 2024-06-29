import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:rtiapp/src/common/widget/footer.widget.dart';
import 'package:rtiapp/src/core/app_config.dart';

import 'package:rtiapp/src/core/kassets.dart';

import 'package:rtiapp/src/core/kcolors.dart';
import 'package:rtiapp/src/core/shared_pref.dart';
import 'package:rtiapp/src/feature/admin/authentication/service/login.service.dart';
import 'package:rtiapp/src/routers/route_names.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  String? _username = 'mspcl_admin';
  String? _password = "12345678";
  int otpStatus = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(KASSETS.logo),
              const AppText.display(
                "Manipur State Power Company Limited",
                color: KCOLOR.brand,
              ),
              const AppText.heading(
                "RTI Application Online",
              ),
              const AppText.heading(
                "Admin Login",
              ),
              const Gap(10),
              SizedBox(
                width: 350,
                child: TextFormField(
                  initialValue: kReleaseMode ? '' : "mspcl_admin",
                  onChanged: (value) {
                    setState(() {
                      _username = value;
                    });
                  },
                  decoration: const InputDecoration(hintText: "Username"),
                ),
              ),
              const Gap(10),
              SizedBox(
                  width: 350,
                  child: TextFormField(
                      initialValue: kReleaseMode ? '' : "12345678",
                      onChanged: (value) {
                        setState(() {
                          _password = value;
                        });
                      },
                      decoration: const InputDecoration(hintText: "Password"))),
              const Gap(20),
              SizedBox(
                  height: 50,
                  width: 350,
                  child: ElevatedButton(
                      style: ButtonStyle(
                          foregroundColor:
                              const WidgetStatePropertyAll(Colors.white),
                          backgroundColor: WidgetStatePropertyAll(
                              _username == null && _password == null
                                  ? Colors.grey
                                  : KCOLOR.brand)),
                      onPressed: _username == null && _password == null
                          ? null
                          : () async {
                              EasyLoading.show(status: "Please wait");
                              var auth = Auth();
                              var res =
                                  await auth.login(_username!, _password!);

                              if (res["success"]) {
                                await SharedPrefHelper.saveUserInfo(
                                    res["data"]["username"],
                                    res["data"]["email"],
                                    res["data"]["id"],
                                    res["data"]["accessToken"]);
                                await SharedPrefHelper.saveToken(
                                    "token", res["data"]["accessToken"]);
                                EasyLoading.showSuccess("Login Succesfull");
                                context.goNamed(KRoutes.application);
                              } else {
                                EasyLoading.showError(res["message"]);
                              }
                            },
                      child: const Text("LOGIN"))),
            ],
          )),
          const FooterWidget()
        ],
      ),
    );
  }
}
