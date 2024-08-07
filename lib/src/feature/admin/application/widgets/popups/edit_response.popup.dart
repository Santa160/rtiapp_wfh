
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:rtiapp/src/core/app_config.dart';
import 'package:rtiapp/src/core/kcolors.dart';
import 'package:rtiapp/src/core/shared_pref.dart';
import 'package:rtiapp/src/feature/admin/application/models/req-models/StringUnit8.model.dart';
import 'package:rtiapp/src/feature/admin/application/services/rti_staff.service.dart';
import 'package:rtiapp/src/feature/admin/application/widgets/dropdowns/query.status.dropdown.dart';
import 'package:rtiapp/src/initial-setup/models/query_status.dart';
import 'package:rtiapp/src/service/helper/endpoints.dart';
import 'package:url_launcher/url_launcher.dart';

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
  var service = ApplicationService();

  late TextEditingController responseTextController;
  QueryStatusModel? _selectedStatus;
  List<Map<String, dynamic>> doc = [];
  Set<String> deletedIds = {};

  @override
  void initState() {
    initial();
    super.initState();
  }

  initial() async {
    doc = widget.doc;
    responseTextController =
        TextEditingController(text: widget.response['response']);
    var l = await SharedPrefHelper.getQueryStatus();
    _selectedStatus = l
        ?.where(
          (element) => element.id.toString() == widget.queryStatusId,
        )
        .first;
    setState(() {});
  }

  List<StringUint8ListModel> files = [];

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
          const Text(
            "Edit Response",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Gap(20),
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // AppText.heading(widget.response.toString()),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Resposne field can\'t be empty ';
                        }
                        return null;
                      },
                      controller: responseTextController,
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
                              key: UniqueKey(),
                              children: [
                                InkWell(
                                  onTap: () {
                                    launchUrl(Uri.parse(
                                        '${EndPoint.baseUrl}/${e["document_url"]}'));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border:
                                            Border.all(color: KCOLOR.shade1)),
                                    height: 80,
                                    width: 80,

                                    // child: SelectableText(
                                    //     '${EndPoint.baseUrl}/${e["document_url"]}'),
                                    child: const Icon(
                                      Icons.file_present,
                                      color: KCOLOR.warning,
                                    ),
                                  ),
                                ),
                                CircleAvatar(
                                  backgroundColor:
                                      Colors.black.withOpacity(0.2),
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
                        ...files.map(
                          (e) {
                            return Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: KCOLOR.shade1)),
                                  height: 80,
                                  width: 80,
                                  // child: SelectableText(
                                  //     '${EndPoint.baseUrl}/${e["document_url"]}'),
                                  child: const Icon(
                                    Icons.file_present,
                                    color: KCOLOR.warning,
                                  ),
                                ),
                                CircleAvatar(
                                  backgroundColor:
                                      Colors.black.withOpacity(0.2),
                                  child: IconButton(
                                      onPressed: () {
                                        files.remove(e);
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
                              allowedExtensions: ['pdf'],
                            );
                            var b = result?.files.first.bytes;
                            var name = result?.files.first.name;
                            files.add(StringUint8ListModel(
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
                  if (_formKey.currentState!.validate()) {
                    EasyLoading.show(
                        status: "Please wait...\nWhile updating response");

                    try {
                      if (deletedIds.isNotEmpty) {
                        var deleteResponse = await service.deleteImages(
                          deletedIds.map(int.parse).toList(),
                        );

                        if (!deleteResponse['success']) {
                          EasyLoading.showError("Failed to delete images");
                          return;
                        }
                      }

                      var updateResponse = await service.updateResponse(
                          widget.response['id'],
                          responseTextController.text,
                          files,
                          "${_selectedStatus!.id}");

                      if (updateResponse['success']) {
                        Navigator.pop(context);
                      } else {
                        EasyLoading.showError("Failed to update response");
                      }
                    } catch (error) {
                      EasyLoading.showError("An error occurred: $error");
                    } finally {
                      EasyLoading.dismiss();
                    }
                  }
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
