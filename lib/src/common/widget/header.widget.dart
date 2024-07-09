import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:rtiapp/src/core/app_config.dart';
import 'package:rtiapp/src/core/kassets.dart';
import 'package:rtiapp/src/core/kcolors.dart';
import 'package:rtiapp/src/core/shared_pref.dart';
import 'package:rtiapp/src/routers/route_names.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({
    super.key,
    this.height,
  });
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      height: height ?? 100,
      color: KCOLOR.brand.withOpacity(0.05),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                KASSETS.logoVertical,
                scale: 1.5,
              ),
              const Gap(10),
            ],
          ),
          Row(
            children: [
              PopupMenuButton(
                onSelected: (value) async {
                  if (value == "Logout") {
                    var isAdmin = SharedPrefHelper.isStaff();
                    if (isAdmin ?? false) {
                      context.goNamed(KRoutes.adminlogin);
                    } else {
                      context.goNamed(KRoutes.citizenLogin);
                    }
                    await SharedPrefHelper.reset();
                  }
                },
                tooltip: '',
                child: Row(
                  children: [
                    AppText.heading(
                        "${SharedPrefHelper.getUserInfo()?.username}"),
                    const Gap(10),
                    const CircleAvatar(
                      child: Icon(
                        Icons.account_circle,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                itemBuilder: (context) {
                  return [
                    const PopupMenuItem(
                      value: "Logout",
                      child: Text('Logout'),
                    )
                  ];
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
