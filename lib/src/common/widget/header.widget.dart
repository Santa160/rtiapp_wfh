import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:rtiapp/src/core/kassets.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          children: [
            Image.asset(
              KASSETS.logo,
              scale: 1.5,
            ),
            const Gap(10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("RTI",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.bold)),
                Text(
                  "An Initiative of Department of \nPersonnel & Training, Government of India",
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
