import 'package:flutter/widgets.dart';
import 'package:rtiapp/src/core/kcolors.dart';

Widget hintText(String text, String? text2) {
  return RichText(
    text: TextSpan(
      children: [
        TextSpan(
          text: text,
        ),
        const TextSpan(
          text: "*",
          style: TextStyle(
            // Add desired styles here
            color: KCOLOR.danger, // You can customize the color
          ),
        ),
        if (text2 != null)
          TextSpan(
            text: text2,
          ),
      ],
    ),
  );
}
