import 'package:flutter/material.dart';
import 'package:rtiapp/src/common/widget/title_style.dart';

RichText richText(String lable,String value){
  return RichText(text:  TextSpan(
    children: [
      TextSpan(text: lable, style: style),
      const TextSpan(text: " "),
      TextSpan(text: value),
    ]
  ));
}