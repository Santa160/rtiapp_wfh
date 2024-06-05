import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:gap/gap.dart';

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
      itemCount: data.length + 1,
      itemBuilder: (c, index) {
        if (index == data.length) {
          // Last item: ElevatedButton
          return Column(
            children: [
              const Gap(10),
              Center(
                child: TextButton.icon(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    data.add(StringUint8ListModel());
                    setState(() {});
                  },
                  label: const Text('Add More'),
                ),
              ),
            ],
          );
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                data.isNotEmpty &&
                                        data[index].stringValue != null
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
              IconButton(
                  onPressed: () {
                    data.removeAt(index);
                    setState(() {});
                  },
                  icon: const Icon(
                    Icons.delete_forever,
                    color: KCOLOR.danger,
                  ))
            ],
          ),
        );
      },
    );
  }
}
