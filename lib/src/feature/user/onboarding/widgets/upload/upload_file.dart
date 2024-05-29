import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:rtiapp/src/common/utils/filepicker.helper.dart';
import 'package:rtiapp/src/core/kcolors.dart';

class UploadFileWidget extends StatefulWidget {
  const UploadFileWidget({super.key, required this.onFilePicked});
  final Function(FilePickerModel?) onFilePicked;

  @override
  State<UploadFileWidget> createState() => _UploadFileWidgetState();
}

class _UploadFileWidgetState extends State<UploadFileWidget> {
  String _fileName = '';

  late FilePickerModel filePickerModel;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 50,
            width: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              shape: BoxShape.rectangle,
              color: Colors.white,
              border: Border.all(color: Colors.grey),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      _fileName.isEmpty ? "No File" : _fileName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: KCOLOR.brand,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(5),
                      topLeft: Radius.circular(0),
                      topRight: Radius.circular(5),
                    ),
                  ),
                  height: 50,
                  child: InkWell(
                    onTap: () async {
                      FilePickerResult? result =
                          await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['jpg', 'jpeg', 'png'],
                      );

                      var byte = result?.files.first.bytes;
                      var name = result?.files.first.name;

                      _fileName = name ?? 'No File';

                      var fileModel =
                          FilePickerModel(fileName: name, bytes: byte);
                      widget.onFilePicked(fileModel);
                      setState(() {});
                    },
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          _fileName.isNotEmpty ? "Uploaded" : "Choose File",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
