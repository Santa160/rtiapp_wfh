import 'package:flutter/material.dart';

import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 350,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Image.asset(KASSETS.logo)],
                    ),
                    Text("RTI Online",
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(
                                color: KCOLOR.brand,
                                fontWeight: FontWeight.bold)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Gap(10),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Admin Login",
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        const Gap(10),
                        const Gap(10),
                        SizedBox(
                          width: 350,
                          child: TextFormField(
                            initialValue: "mspcl_admin",
                            onChanged: (value) {
                              setState(() {
                                _username = value;
                              });
                            },
                            decoration:
                                const InputDecoration(hintText: "Username"),
                          ),
                        ),
                        const Gap(10),
                        SizedBox(
                            width: 350,
                            child: TextFormField(
                                initialValue: "12345678",
                                onChanged: (value) {
                                  setState(() {
                                    _password = value;
                                  });
                                },
                                decoration: const InputDecoration(
                                    hintText: "Password"))),
                        const Gap(20),
                        SizedBox(
                            height: 50,
                            width: 350,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    foregroundColor:
                                        const WidgetStatePropertyAll(
                                            Colors.white),
                                    backgroundColor: WidgetStatePropertyAll(
                                        _username == null && _password == null
                                            ? Colors.grey
                                            : KCOLOR.brand)),
                                onPressed: _username == null &&
                                        _password == null
                                    ? null
                                    : () async {
                                        var auth = Auth();
                                        var res = await auth.login(
                                            _username!, _password!);
                                        await SharedPrefHelper.saveToken(
                                            "token",
                                            res["data"]["accessToken"]);

                                        context.goNamed(KRoutes.application);
                                      },
                                child: const Text("LOGIN"))),
                        const Gap(10),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bodyView() {
    return Container(
      height: 200,
      width: 200,
      color: Colors.green,
    );
  }
}
