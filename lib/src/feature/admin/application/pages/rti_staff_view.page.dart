import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:gap/gap.dart';
import 'package:image_network/image_network.dart';
import 'package:rtiapp/src/common/extentions/extention.dart';

import 'package:rtiapp/src/common/widget/serial_number.dart';
import 'package:rtiapp/src/common/widget/title_style.dart';
import 'package:rtiapp/src/core/app_config.dart';
import 'package:rtiapp/src/core/kcolors.dart';
import 'package:rtiapp/src/core/logger.dart';
// import 'package:rtiapp/src/core/shared_pref.dart';
import 'package:rtiapp/src/feature/admin/application/models/req-models/StringUnit8.model.dart';
import 'package:rtiapp/src/feature/admin/application/services/rti_staff.service.dart';
import 'package:rtiapp/src/feature/admin/application/widgets/dropdowns/application_status.dropdown.dart';
import 'package:rtiapp/src/feature/admin/application/widgets/dropdowns/query.status.dropdown.dart';
import 'package:rtiapp/src/feature/admin/application/widgets/image_picker.dart';
import 'package:rtiapp/src/feature/admin/application/widgets/popups/view_responses.popup.dart';
import 'package:rtiapp/src/feature/user/home/service/rti.service.dart';
import 'package:rtiapp/src/feature/user/home/widget/rti_status.widget.dart';
import 'package:rtiapp/src/initial-setup/models/query_status.dart';
import 'package:rtiapp/src/service/helper/endpoints.dart';


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
  List<Map<String, dynamic>> tableData = [];
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
      tableData.clear();
      var list = res["data"]["rti_status_log"] as List;
      for (var element in list) {
        tableData.add(element as Map<String, dynamic>);
      }
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
                const AppText.heading(
                  "Citizen Profile",
                  color: KCOLOR.brand,
                ),
                const Gap(10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(child: userProfile()),
                    Expanded(child: userAddress()),
                  ],
                ),
                const Gap(20),
                const AppText.heading(
                  "Education",
                  color: KCOLOR.brand,
                ),
                const Gap(10),
                _education(),

                if (citizenDetails["bpl"] == "1") ...[
                  const Gap(20),
                  const AppText.heading(
                    "BPL",
                    color: KCOLOR.brand,
                  ),
                  const Gap(10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(child: _bpl()),
                      Expanded(
                          child: Stack(
                        children: [
                          SizedBox(
                            height: 80,
                            width: 80,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Container(
                                  color: Colors.grey,
                                  width: 80,
                                  child: Visibility(
                                    visible: bplDetails["bpl_card_url"] != null,
                                    child: ImageNetwork(
                                        height: 80,
                                        width: 80,
                                        image:
                                            "${EndPoint.baseUrl}/${bplDetails["bpl_card_url"]}"),
                                  )),
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Container(
                              color: Colors.black.withOpacity(0.5),
                              height: 80,
                              width: 80,
                              child: const Center(
                                child: Icon(
                                  Icons.remove_red_eye,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                    ],
                  ),
                ],
                const Gap(20),
                _queries(),
                const Gap(10),
                Container(
                  color: KCOLOR.shade3,
                  height: (55 * tableData.length).toDouble(),
                  child: _tableData(),
                ),
                const Gap(10),
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
            DataColumn(label: Text("Action By")),
          ],
          rows: tableData.map(
            (e) {
              return DataRow(
                cells: [
                  DataCell(
                    Text(getSerialNumber(page: 1, index: tableData.indexOf(e))
                        .toString()),
                  ),
                  DataCell(RTIStatusWidget(
                    id: e["status_id"],
                  )),
                  DataCell(
                    Text(e["created_at"].toString().getFormattedDate()),
                  ),
                  DataCell(
                    Text(e["username"]),
                  ),
                ],
              );
            },
          ).toList()),
    );
  }

  Column _queries() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Gap(10),
        const AppText.heading("Queries", color: KCOLOR.brand),
        const Gap(5),
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
                                AppBtn.outline(
                                  "Cancel",
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  outlineColor: KCOLOR.danger,
                                ),
                                AppBtn.fill(
                                  "Submit",
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
                                )
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
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.subheading(queries[index]["query"]),
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Responses"),
                            content: ViewResponsePopup(
                              data: queries[index],
                            ),
                          );
                        },
                      );
                    },
                    child: const AppText.smallText(
                      "view response",
                      color: KCOLOR.brand,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Table _education() {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(1.5),
        1: FlexColumnWidth(0.2),
        2: FlexColumnWidth(5),
      },
      children: [
        TableRow(
          children: [
            const TableCell(
                child: AppText.subheading(
              "Highest Qualification",
            )),
            const TableCell(child: Text(":")),
            TableCell(child: Text(citizenDetails["qualification"].toString())),
          ],
        ),
      ],
    );
  }

  Table _bpl() {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(2.1),
        1: FlexColumnWidth(0.2),
        2: FlexColumnWidth(5),
      },
      children: [
        TableRow(
          children: [
            const TableCell(
                child: AppText.subheading(
              "BPL Card No",
            )),
            const TableCell(child: Text(":")),
            TableCell(child: Text(bplDetails["bpl_card_no"].toString())),
          ],
        ),
        TableRow(
          children: [
            const TableCell(
                child: AppText.subheading(
              "Issued",
            )),
            const TableCell(child: Text(":")),
            TableCell(child: Text(bplDetails["year_of_issue"].toString())),
          ],
        ),
        TableRow(
          children: [
            const TableCell(
                child: AppText.subheading(
              "Issuing Authority",
            )),
            const TableCell(child: Text(":")),
            TableCell(child: Text(bplDetails["issuing_authority"].toString())),
          ],
        ),

        // Add more rows for additional user profile fields
      ],
    );
  }

  Table userProfile() {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(0.2),
        2: FlexColumnWidth(5),
      },
      children: [
        TableRow(
          children: [
            const TableCell(
                child: AppText.subheading(
              "Name",
            )),
            const TableCell(child: Text(":")),
            TableCell(child: Text(citizenDetails["name"].toString())),
          ],
        ),
        TableRow(
          children: [
            const TableCell(
                child: AppText.subheading(
              "Email",
            )),
            const TableCell(child: Text(":")),
            TableCell(child: Text(citizenDetails["email"].toString())),
          ],
        ),
        TableRow(
          children: [
            const TableCell(
                child: AppText.subheading(
              "Phone",
            )),
            const TableCell(child: Text(":")),
            TableCell(child: Text(citizenDetails["mobile_no"].toString())),
          ],
        ),
        TableRow(
          children: [
            const TableCell(
                child: AppText.subheading(
              "Gender",
            )),
            const TableCell(child: Text(":")),
            TableCell(child: Text(citizenDetails["gender"].toString())),
          ],
        ),
        TableRow(
          children: [
            const TableCell(
                child: AppText.subheading(
              "Status",
            )),
            const TableCell(child: Text(":")),
            TableCell(child: Text(citizenDetails["marital_status"].toString())),
          ],
        ),

        // Add more rows for additional user profile fields
      ],
    );
  }

  Table userAddress() {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(0.2),
        2: FlexColumnWidth(5),
      },
      children: [
        TableRow(
          children: [
            const TableCell(
                child: AppText.subheading(
              "State",
            )),
            const TableCell(child: Text(":")),
            TableCell(child: Text(citizenDetails["state"].toString())),
          ],
        ),

        TableRow(
          children: [
            const TableCell(
                child: AppText.subheading(
              "District",
            )),
            const TableCell(child: Text(":")),
            TableCell(child: Text(citizenDetails["district"].toString())),
          ],
        ),
        TableRow(
          children: [
            const TableCell(
                child: AppText.subheading(
              "Rural/Urban",
            )),
            const TableCell(child: Text(":")),
            TableCell(child: Text(citizenDetails["rural_urban"].toString())),
          ],
        ),
        TableRow(
          children: [
            const TableCell(
                child: AppText.subheading(
              "Address",
            )),
            const TableCell(child: Text(":")),
            TableCell(child: Text(citizenDetails["address"].toString())),
          ],
        ),

        TableRow(
          children: [
            const TableCell(
                child: AppText.subheading(
              "Pincode",
            )),
            const TableCell(child: Text(":")),
            TableCell(child: Text(citizenDetails["pin_code"].toString())),
          ],
        ),

        // Add more rows for additional user profile fields
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
                        actions: [
                          AppBtn.fill(
                            "Okay",
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          )
                        ],
                        contentPadding: const EdgeInsets.all(30),
                        title: const AppText.heading(
                          "Status Update",
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
                                    EasyLoading.showSuccess(res["message"]);
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
