import 'package:flutter/material.dart';
import 'package:rtiapp/src/core/app_config.dart';
import 'package:rtiapp/src/core/kcolors.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
            color: KCOLOR.brand.withOpacity(0.05),
            height: 80,
            width: double.infinity,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppText.smallText(
                  "© 2024 Manipur State Power Company Ltd. All rights reserved. All contents are provided by MSPCL",
                  color: Colors.black,
                ),
                AppText.smallText(
                  "Powered by: Globizs Web Solutions Pvt Ltd",
                  color: Colors.black,
                )
              ],
            )),
      ],
    );
  }
}
