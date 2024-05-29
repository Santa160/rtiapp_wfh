import 'package:flutter/widgets.dart';

extension PaddingExtension on Widget {
  Widget addPadding({
    double left = 20,
    double top = 20,
    double right = 20,
    double bottom = 0.0,
  }) {
    return Padding(
      padding: EdgeInsets.fromLTRB(left, top, right, bottom),
      child:
          this, // 'this' refers to the widget to which the extension is applied
    );
  }
}
