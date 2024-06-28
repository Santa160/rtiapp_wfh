import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:rtiapp/src/common/widget/footer.widget.dart';
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
  String? number;
  String? code;
  bool isOTPSent = false;

  var auth = OnboardingServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Gap(10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(KASSETS.logo),
              const AppText.display(
                "Manipur State Power Company Limited",
              ),
              const Gap(20),
              const AppText.heading(
                "RTI Online Application",
                color: KCOLOR.brand,
              ),
              const AppText.heading("Citizen Portal"),
              const Gap(10),
              const AppText.subheading(
                "Continue with your mobile number",
              ),
              const Gap(10),
              SizedBox(
                  width: 350,
                  child: TextFormField(
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                                EasyLoading.show(status: "Please wait");
                                //send to OTP
                                var res = await auth.sendOtp(number!);

                                // save the otp status
                                if (res["success"]) {
                                  isOTPSent = res["success"];
                                  EasyLoading.showSuccess(res["message"]);
                                  setState(() {});
                                }
                              }
                            },
                            child: Text(
                              isOTPSent ? 'OTP sent!' : "Send OTP",
                              style: const TextStyle(color: KCOLOR.brand),
                            ),
                          ),
                          hintText: "Enter Mobile Number"))),
              if (isOTPSent) ...[
                SizedBox(
                    width: 350,
                    child: TextFormField(
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
                                const WidgetStatePropertyAll(Colors.white),
                            backgroundColor: WidgetStatePropertyAll(
                                isOTPSent ? KCOLOR.brand : Colors.grey)),
                        onPressed: isOTPSent
                            ? () async {
                                // Verify OTP logic here
                                EasyLoading.show(status: "Verifing OTP");

                                var res = await auth.verifyOtp(number!, code!);
                                if (res["success"]) {
                                  await SharedPrefHelper.saveUserInfo(
                                      res["data"]["citizen_name"].toString(),
                                      '',
                                      0,
                                      '');
                                  await SharedPrefHelper.saveToken(
                                      "token", res["data"]["token"]);
                                  if (res["data"]["registrationCompleted"]) {
                                    context.replaceNamed(KRoutes.home);
                                  } else {
                                    context.goNamed(KRoutes.registration);
                                  }
                                  EasyLoading.showSuccess(res["message"]);
                                }
                              }
                            : null,
                        child: const Text("Verify OTP"))),
                const Gap(10),
              ]
            ],
          ),
          const FooterWidget()
        ],
      ),
    );
  }
}
