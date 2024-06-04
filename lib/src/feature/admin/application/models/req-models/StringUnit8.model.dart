import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class StringUint8ListModel {
  String? stringValue;
  Uint8List? uint8ListValue;
  bool? status;
  String? key;

  StringUint8ListModel({this.stringValue, this.uint8ListValue, this.key});

  // Constructor for creating an instance from a String
  StringUint8ListModel.fromString(String stringValue) {
    stringValue = stringValue;
    uint8ListValue = Uint8List.fromList(utf8.encode(stringValue));
  }

  // Constructor for creating an instance from a Uint8List
  StringUint8ListModel.fromUint8List(Uint8List uint8ListValue) {
    uint8ListValue = uint8ListValue;
    stringValue = utf8.decode(uint8ListValue);
  }
}

status(bool? status) {
  if (status != null && !status) {
    return Colors.red;
  } else if (status != null && status) {
    return const Color(0xFF1C315E);
  } else {
    return const Color(0xFF1C315E);
  }
}
