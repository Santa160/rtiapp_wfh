import 'package:flutter/material.dart';

import 'package:rtiapp/src/core/kassets.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.network(
          KASSETS.logoVertical,
        ),
      ],
    );
  }
}
