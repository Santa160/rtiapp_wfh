import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:image_network/image_network.dart';
import 'package:rtiapp/src/core/app_config.dart';
import 'package:rtiapp/src/core/kcolors.dart';
import 'package:rtiapp/src/feature/admin/application/models/req-models/StringUnit8.model.dart';
import 'package:rtiapp/src/feature/admin/application/widgets/dropdowns/query.status.dropdown.dart';
import 'package:rtiapp/src/initial-setup/models/query_status.dart';
import 'package:rtiapp/src/service/helper/endpoints.dart';

class EditResponsePopup extends StatefulWidget {
  const EditResponsePopup({
    super.key,
    required this.response,
    required this.doc,
    required this.queryStatusId,
  });
  final Map<String, dynamic> response;
  final List<Map<String, dynamic>> doc;
  final String queryStatusId;

  @override
  State<EditResponsePopup> createState() => _EditResponsePopupState();
}

class _EditResponsePopupState extends State<EditResponsePopup> {
  late TextEditingController textEditingController;
  QueryStatusModel? _selectedStatus;
  List<Map<String, dynamic>> doc = [];
  Set<String> deletedIds = {};

  @override
  void initState() {
    doc = widget.doc;
    textEditingController =
        TextEditingController(text: widget.response['response']);
    super.initState();
  }

  List<StringUint8ListModel> data = [];

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      width: 500,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.response['id'].toString()),
          const Text(
            "Edit Response",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Gap(20),
          SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Resposne field can\'t be empty ';
                      }
                      return null;
                    },
                    controller: textEditingController,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      hintText: "Enter your response here...",
                      labelText: "Response",
                    ),
                  ),
                  const Gap(20),
                  QueryStatusDropdown(
                      onChanged: (status) async {
                        _selectedStatus = status;
                        setState(() {});
                      },
                      initialId: widget.queryStatusId),
                  const Gap(20),
                  const AppText.smallText("Uploaded Document"),
                  const Gap(10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      ...doc.map(
                        (e) {
                          return Stack(
                            children: [
                              InkWell(
                                onTap: () {
                                  EasyLoading.showToast("view press");
                                  // doc.remove(e);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: KCOLOR.shade1)),
                                  height: 80,
                                  width: 80,
                                  // child: SelectableText(
                                  //     '${EndPoint.baseUrl}/${e["document_url"]}'),
                                  child: ImageNetwork(
                                    image:
                                        '${EndPoint.baseUrl}/${e["document_url"]}',
                                    height: 80,
                                    width: 80,
                                  ),
                                ),
                              ),
                              CircleAvatar(
                                backgroundColor: Colors.black.withOpacity(0.2),
                                child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        deletedIds.add("${e['id']}");
                                        doc.remove(e);
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: KCOLOR.danger,
                                    )),
                              ),
                            ],
                          );
                        },
                      ),
                      ...data.map(
                        (e) {
                          return Stack(
                            children: [
                              InkWell(
                                onTap: () {
                                  EasyLoading.showToast("view press");
                                  // doc.remove(e);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: KCOLOR.shade1)),
                                  height: 80,
                                  width: 80,
                                  // child: SelectableText(
                                  //     '${EndPoint.baseUrl}/${e["document_url"]}'),
                                  child: Image.memory(
                                    e.uint8ListValue as Uint8List,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              CircleAvatar(
                                backgroundColor: Colors.black.withOpacity(0.2),
                                child: IconButton(
                                    onPressed: () {
                                      setState(() {});
                                      data.remove(e);
                                      setState(() {});
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: KCOLOR.danger,
                                    )),
                              ),
                            ],
                          );
                        },
                      ),
                      InkWell(
                        onTap: () async {
                          FilePickerResult? result =
                              await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ['jpg', 'png'],
                          );
                          var b = result?.files.first.bytes;
                          var name = result?.files.first.name;
                          data.add(StringUint8ListModel(
                              stringValue: name, uint8ListValue: b));
                          setState(() {});
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: KCOLOR.shade1)),
                            height: 80,
                            width: 80,
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add,
                                  color: KCOLOR.brand,
                                ),
                                AppText.smallText(
                                  "Add New",
                                  color: KCOLOR.brand,
                                ),
                              ],
                            )),
                      ),
                    ],
                  ),
                  const Gap(10)
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AppBtn.outline(
                "Cancel",
                onPressed: () {
                  deletedIds.clear();
                  Navigator.pop(context);
                },
                outlineColor: KCOLOR.danger,
              ),
              const Gap(10),
              AppBtn.fill(
                "Update",
                onPressed: () async {
                  EasyLoading.show(status: "Please wait..");
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
