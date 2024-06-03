import 'package:flutter/material.dart';
import 'package:rtiapp/src/core/kcolors.dart';

class AppText extends StatelessWidget {
  const AppText({super.key, required this.text, required this.style});
  final String text;
  final TextStyle style;

  const AppText.heading(this.text, {super.key})
      : style = const TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  //
  const AppText.subheading(this.text, {super.key})
      : style = const TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style,
    );
  }
}

class AppBtn extends StatelessWidget {
  const AppBtn(
      {super.key,
      required this.label,
      required this.isOutline,
      required this.onPressed});
  final String label;
  final bool isOutline;
  final Function() onPressed;

  const AppBtn.outline(this.label, {super.key, required this.onPressed})
      : isOutline = true;
  const AppBtn.fill(this.label, {super.key, required this.onPressed})
      : isOutline = false;

  @override
  Widget build(BuildContext context) {
    return isOutline
        ? OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(
                color: KCOLOR.brand, // Set your desired outline color here
       
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    5), // Set your desired border radius here
              ),
            ),
            onPressed: onPressed,
            child: Text(label),
          )
        : ElevatedButton(
            style: const ButtonStyle(
                foregroundColor: WidgetStatePropertyAll(Colors.white),
                backgroundColor: WidgetStatePropertyAll(KCOLOR.brand)),
            onPressed: onPressed,
            child: Text(label));
  }
}
