import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

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

extension DateFormatting on String {
  String getFormattedDate() {
    DateTime dateTime = DateTime.parse(this);
    String formattedDate = DateFormat('d MMM yyyy').format(dateTime);
    return formattedDate; // Output: 23 November 2023
  }
}
