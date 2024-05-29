import 'dart:convert';
import 'dart:typed_data';

class FilePickerModel {
  String? fileName;
  Uint8List? bytes;

  FilePickerModel({this.fileName, this.bytes});

  // Constructor for creating an instance from a String
  FilePickerModel.fromString(String fileName) {
    fileName = fileName;
    bytes = Uint8List.fromList(utf8.encode(fileName));
  }

  // Constructor for creating an instance from a Uint8List
  FilePickerModel.fromUint8List(Uint8List bytes) {
    bytes = bytes;
    fileName = utf8.decode(bytes);
  }
}
