import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

import 'package:gap/gap.dart';

import 'package:rtiapp/src/common/widget/rich_text.dart';
import 'package:rtiapp/src/common/widget/title_style.dart';
import 'package:rtiapp/src/core/kcolors.dart';
import 'package:rtiapp/src/core/logger.dart';
// import 'package:rtiapp/src/core/shared_pref.dart';
import 'package:rtiapp/src/feature/admin/application/models/req-models/StringUnit8.model.dart';
import 'package:rtiapp/src/feature/admin/application/services/rti_staff.service.dart';
import 'package:rtiapp/src/feature/admin/application/widgets/dropdowns/application_status.dropdown.dart';
import 'package:rtiapp/src/feature/admin/application/widgets/dropdowns/query.status.dropdown.dart';
import 'package:rtiapp/src/feature/admin/application/widgets/image_picker.dart';
import 'package:rtiapp/src/feature/user/home/service/rti.service.dart';
import 'package:rtiapp/src/feature/user/home/widget/rti_status.widget.dart';
import 'package:rtiapp/src/initial-setup/models/query_status.dart';

class RTIStaffViewPage extends StatefulWidget {
  const RTIStaffViewPage(
      {super.key, required this.rtiId, required this.onBackTab});
  final String rtiId;
  final Function() onBackTab;

  @override
  State<RTIStaffViewPage> createState() => _RTIStaffViewPageState();
}

class _RTIStaffViewPageState extends State<RTIStaffViewPage> {
  Map<String, dynamic> data = {"status": " "};
  // List<QueryStatusModel>? _queryStatus;
  QueryStatusModel? _selectedQueryStatus;
  Map<String, dynamic> citizenDetails = {};
  String applicationNo = '';
  Map<String, dynamic> bplDetails = {};
  List queries = [];
  List<StringUint8ListModel> _files = [];
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    getRTIDetials();
    super.initState();
  }

  getRTIDetials() async {
    var res = await RTIService().fetchRTIDetails(widget.rtiId);
    // var queryStatus = await SharedPrefHelper.getQueryStatus();
    logger.d(res);
    setState(() {
      // _queryStatus = queryStatus;
      data = res["data"];
      citizenDetails = res["data"]["citizen_details"];
      applicationNo = res["data"]["rti_no"];
      queries = res["data"]["queries"];
      if (citizenDetails["bpl"] == "1") {
        bplDetails = res["data"]["bpl_details"];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // var mw = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        pageHeader(context),
        const Gap(20),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                pageData(),
                _queries(),
                SizedBox(
                  height: 500,
                  child: _tableData(),
                )
                // _tableData()
                //BPL
              ],
            ),
          ),
        ),
      ],
    );
  }

  _tableData() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: DataTable2(
          headingRowColor: const WidgetStatePropertyAll(KCOLOR.shade1),
          columns: const [
            DataColumn(label: Text("Sl")),
            DataColumn(label: Text("Status")),
            DataColumn(label: Text("Date")),
            DataColumn(label: Text("Action")),
          ],
          rows: const []),
    );
  }

  Column _queries() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Queries",
          style: style.copyWith(fontSize: 20),
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: queries.length,
          itemBuilder: (context, index) {
            var count = index + 1;
            return ListTile(
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Text(
                        "Status : ",
                        style: TextStyle(color: Colors.black),
                      ),
                      TextButton.icon(
                          onPressed: () {},
                          label: RTIStatusWidget(
                            id: int.parse(queries[index]["query_status_id"]),
                          )),
                    ],
                  ),
                  const Gap(10),
                  TextButton.icon(
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              actions: [
                                ElevatedButton(
                                    onPressed: () async {
                                      var service = ApplicationService();
                                      var res =
                                          await service.createQueryResponse({
                                        'rti_query_id': queries[index]["id"],
                                        'rti_query_status':
                                            _selectedQueryStatus!.id,
                                        'response': controller.text
                                      }, _files);
                                      if (res["success"]) {
                                        controller.clear();
                                        getRTIDetials();
                                      }
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Submit"))
                              ],
                              contentPadding: const EdgeInsets.all(30),
                              content: SizedBox(
                                height: 500,
                                width: 500,
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                        "Response",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const Gap(20),
                                      TextFormField(
                                        controller: controller,
                                        maxLines: 5,
                                        decoration: const InputDecoration(
                                          hintText:
                                              "Enter your response here...",
                                          label: Text("Response"),
                                        ),
                                      ),
                                      const Gap(20),
                                      QueryStatusDropdown(
                                          onChanged: (status) async {
                                            _selectedQueryStatus = status;
                                            setState(() {});
                                          },
                                          initialId: queries[index]
                                              ["query_status_id"]),
                                      const Gap(20),
                                      ImagePickerFormWidget(
                                        onPicked: (files) {
                                          _files = files;

                                          setState(() {});
                                        },
                                      ),
                                      const Gap(20)
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      label: const Text("Response")),
                ],
              ),
              title: Text(
                "Question $count",
                style: style,
              ),
              subtitle: Text(queries[index]["query"]),
            );
          },
        ),
      ],
    );
  }

  Column pageData() {
    return Column(
      children: [
        Row(
          children: [
            richText(
              "Name:",
              citizenDetails["name"].toString(),
            ),
            const Gap(30),
            richText(
              "email:",
              citizenDetails["email"].toString(),
            ),
          ],
        ),
        const Gap(10),
        Row(
          children: [
            richText(
              "Phone:",
              citizenDetails["mobile_no"].toString(),
            ),
            const Gap(30),
            richText(
              "Gender:",
              citizenDetails["gender"].toString(),
            ),
          ],
        ),
        const Gap(30),
        Row(
          children: [
            richText(
              "State:",
              citizenDetails["state"].toString(),
            ),
            const Gap(30),
            richText(
              "Status:",
              citizenDetails["rural_urban"].toString(),
            ),
          ],
        ),
        const Gap(10),
        Row(
          children: [
            richText(
              "Pincode",
              citizenDetails["pin_code"].toString(),
            ),
            const Gap(30),
            richText(
              "Address:",
              citizenDetails["address"].toString(),
            ),
          ],
        ),
        const Gap(30),
        Row(
          children: [
            richText(
              "Educational status:",
              citizenDetails["qualification"].toString(),
            ),
          ],
        ),
        const Gap(30),
        Visibility(
            visible: citizenDetails["bpl"] == "1",
            child: Column(
              children: [
                Row(
                  children: [
                    richText(
                      "BPL:",
                      "YES",
                    ),
                    const Gap(30),
                    richText(
                      "BPLCard Number:",
                      bplDetails["bpl_card_no"].toString(),
                    ),
                  ],
                ),
                const Gap(10),
                Row(
                  children: [
                    richText(
                      "Issued Year:",
                      bplDetails["year_of_issue"].toString(),
                    ),
                    const Gap(30),
                    richText(
                      "Issuing Authority: ",
                      bplDetails["issuing_authority"].toString(),
                    ),
                  ],
                ),
              ],
            )),
        const Gap(20),
      ],
    );
  }

  Row pageHeader(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextButton.icon(
            icon: const Icon(Icons.arrow_back),
            onPressed: widget.onBackTab,
            label: Text(
              "RTI Application no.  $applicationNo",
              style: const TextStyle(fontSize: 20),
            )),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("   Status:"),
            TextButton.icon(
                icon: const Icon(Icons.schedule),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        contentPadding: const EdgeInsets.all(30),
                        title: const Text(
                          "RTI Application Status Update",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ApplicationStatusDropdown(
                                onChanged: (status) async {
                                  var service = ApplicationService();
                                  var res =
                                      await service.updateRTIApplicationStatus(
                                          int.parse(data["id"]), status.id);
                                  if (res["success"]) {
                                    getRTIDetials();
                                  }
                                },
                                initialId: data["status"]),
                            const Gap(20)
                          ],
                        ),
                      );
                    },
                  );
                },
                label: Text(
                  data["status"],
                  style: const TextStyle(fontSize: 20),
                )),
          ],
        ),
      ],
    );
  }
}
