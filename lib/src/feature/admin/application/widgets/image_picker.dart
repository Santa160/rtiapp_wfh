import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import 'package:rtiapp/src/core/kcolors.dart';

import 'package:rtiapp/src/feature/admin/application/models/req-models/StringUnit8.model.dart';

class ImagePickerFormWidget extends StatefulWidget {
  const ImagePickerFormWidget({
    super.key,
    required this.onPicked,
  });
  final Function(List<StringUint8ListModel>) onPicked;

  @override
  State<ImagePickerFormWidget> createState() => _ImagePickerFormWidgetState();
}

class _ImagePickerFormWidgetState extends State<ImagePickerFormWidget> {
  List<StringUint8ListModel> data = [StringUint8ListModel()];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: data.length,
      itemBuilder: (c, index) {
        return Row(
          children: [
            Expanded(
              child: Container(
                height: 50,
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  shape: BoxShape.rectangle,
                  border: Border.all(
                      // color: status(data[index].status),
                      color: Colors.grey),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(data[index].stringValue == null
                          ? "No File"
                          : data[index].stringValue.toString()),
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
                            allowedExtensions: ['jpg', 'png', 'pdf'],
                          );
                          var b = result?.files.first.bytes;
                          var name = result?.files.first.name;

                          data[index].stringValue = name;
                          data[index].uint8ListValue = b;
                          widget.onPicked(data);

                          setState(() {});
                        },
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              data.isNotEmpty && data[index].stringValue != null
                                  ? "Uploaded"
                                  : "Choose File",
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
      },
    );
  }
}
