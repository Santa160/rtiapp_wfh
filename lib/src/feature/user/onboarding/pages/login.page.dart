import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:rtiapp/src/core/app_config.dart';

import 'package:rtiapp/src/core/kassets.dart';

import 'package:rtiapp/src/core/kcolors.dart';

import 'package:rtiapp/src/core/logger.dart';
import 'package:rtiapp/src/core/shared_pref.dart';
import 'package:rtiapp/src/feature/user/onboarding/service/onboarding.service.dart';
import 'package:rtiapp/src/routers/route_names.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? number = "9501179924";
  String? code = "123456";
  bool isOTPSent = false;

  var auth = OnboardingServices();

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
                              "Login",
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        const Gap(10),
                        SizedBox(
                            width: 350,
                            child: TextFormField(
                                initialValue: "9501179924",
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                maxLength: 10,
                                onChanged: (value) {
                                  if (value.length == 10) {
                                    number = value;

                                    setState(() {});
                                    logger.d(value);
                                  } else {
                                    number = null;
                                    isOTPSent = false;
                                    setState(() {});
                                  }
                                },
                                decoration: InputDecoration(
                                    counter: const Text(""),
                                    suffix: InkWell(
                                      onTap: () async {
                                        //check if the mobile nummber has 10 digit
                                        if (number!.length == 10) {
                                          //send to OTP
                                          var res = await auth.sendOtp(number!);

                                          // save the otp status
                                          isOTPSent = res["success"];
                                          setState(() {});
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(res["message"]
                                                      .toString())));
                                        }
                                      },
                                      child: Text(
                                        isOTPSent ? 'OTP sent!' : "Send OTP",
                                        style: const TextStyle(
                                            color: KCOLOR.brand),
                                      ),
                                    ),
                                    hintText: "Enter Mobile Number"))),
                        SizedBox(
                            width: 350,
                            child: TextFormField(
                                initialValue: "123456",
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                onChanged: (value) {
                                  if (value.length == 6) {
                                    code = value;
                                    setState(() {});
                                  }
                                },
                                maxLength: 6,
                                enabled: isOTPSent,
                                decoration: const InputDecoration(
                                    counter: Text(""), hintText: "Enter OTP"))),
                        SizedBox(
                            height: 50,
                            width: 350,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    foregroundColor:
                                        const WidgetStatePropertyAll(
                                            Colors.white),
                                    backgroundColor: WidgetStatePropertyAll(
                                        isOTPSent
                                            ? KCOLOR.brand
                                            : Colors.grey)),
                                onPressed: isOTPSent
                                    ? () async {
                                        // Verify OTP logic here

                                        var res = await auth.verifyOtp(
                                            number!, code!);
                                        await SharedPrefHelper.saveToken(
                                            "token", res["data"]["token"]);
                                        if (res["data"]
                                            ["registrationCompleted"]) {
                                          context.replaceNamed(KRoutes.home);
                                        } else {
                                          context.goNamed(KRoutes.registration);
                                        }
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(res["message"]
                                                    .toString())));
                                      }
                                    : null,
                                child: const Text("Verify OTP"))),
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
}
