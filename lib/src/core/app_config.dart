import 'package:flutter/material.dart';
import 'package:rtiapp/src/core/kcolors.dart';

class AppText extends StatelessWidget {
  const AppText(
    this.text,
    this.style, {
    super.key,
    this.color,
  });

  final String text;
  final TextStyle style;
  final Color? color;

  const AppText.display(this.text, {super.key, this.color})
      : style = const TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  const AppText.heading(this.text, {super.key, this.color})
      : style = const TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

  const AppText.subheading(this.text, {super.key, this.color})
      : style = const TextStyle(fontSize: 16);
  const AppText.smallText(this.text, {super.key, this.color})
      : style = const TextStyle(fontSize: 13);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style.copyWith(color: color),
    );
  }
}
//done

class AppBtn extends StatelessWidget {
  const AppBtn(
      {super.key,
      required this.text,
      required this.isOutline,
      required this.onPressed,
      this.outlineColor});

  final String text;
  final bool isOutline;
  final Function() onPressed;
  final Color? outlineColor;

  const AppBtn.outline(this.text,
      {super.key, required this.onPressed, this.outlineColor})
      : isOutline = true;
  const AppBtn.fill(this.text, {super.key, required this.onPressed})
      : isOutline = false,
        outlineColor = null;

  @override
  Widget build(BuildContext context) {
    return isOutline
        ? OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: outlineColor ?? KCOLOR.brand,
              side: BorderSide(
                color: outlineColor ??
                    KCOLOR
                        .brand, // Use the passed outline color or default to KCOLOR.brand
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    5), // Set your desired border radius here
              ),
            ),
            onPressed: onPressed,
            child: Text(text),
          )
        : ElevatedButton(
            style: ButtonStyle(
                foregroundColor: WidgetStateProperty.all(Colors.white),
                backgroundColor: WidgetStateProperty.all(KCOLOR.brand)),
            onPressed: onPressed,
            child: Text(text));
  }
}
