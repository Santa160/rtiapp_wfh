import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:rtiapp/src/core/app_config.dart';

import 'package:rtiapp/src/core/kassets.dart';
import 'package:rtiapp/src/core/shared_pref.dart';
import 'package:rtiapp/src/routers/route_names.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Image.asset(
            KASSETS.logoVertical,
          ),
        ),
        Expanded(
          flex: 5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              PopupMenuButton(
                onSelected: (value) async {
                  if (value == "Logout") {
                    await SharedPrefHelper.removeToken("token");
                    context.goNamed(KRoutes.adminlogin);
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
          ),
        ),
      ],
    );
  }
}
