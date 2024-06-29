import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:image_network/image_network.dart';
import 'package:rtiapp/src/common/extentions/extention.dart';
import 'package:rtiapp/src/common/widget/pagination.widget.dart';
import 'package:rtiapp/src/common/widget/serial_number.dart';
import 'package:rtiapp/src/core/app_config.dart';
import 'package:rtiapp/src/core/kcolors.dart';
import 'package:rtiapp/src/core/logger.dart';
import 'package:rtiapp/src/core/shared_pref.dart';
import 'package:rtiapp/src/feature/admin/application/models/req-models/StringUnit8.model.dart';
import 'package:rtiapp/src/feature/admin/application/services/fees.service.dart';
import 'package:rtiapp/src/feature/admin/application/services/rti_staff.service.dart';
import 'package:rtiapp/src/feature/admin/application/widgets/dropdowns/application_status.dropdown.dart';
import 'package:rtiapp/src/feature/admin/application/widgets/dropdowns/query.status.dropdown.dart';
import 'package:rtiapp/src/feature/admin/application/widgets/image_picker.dart';
import 'package:rtiapp/src/feature/admin/application/widgets/popups/view_responses.popup.dart';
import 'package:rtiapp/src/feature/user/home/service/rti.service.dart';
import 'package:rtiapp/src/feature/user/home/widget/query_status.widget.dart';
import 'package:rtiapp/src/feature/user/home/widget/rti_status.widget.dart';
import 'package:rtiapp/src/initial-setup/models/query_status.dart';
import 'package:rtiapp/src/initial-setup/models/status.model.dart';
import 'package:rtiapp/src/service/helper/endpoints.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:url_launcher/url_launcher.dart';

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

  var number = 0;

//rti logs
  List<Map<String, dynamic>> logsData = [];

  Map<String, dynamic> pagination = {};

  int initialPage = 1;
  int initialLimit = 5;

  int? statusId;

  int pageCount = 0;

  getRTIDetials() async {
    var res = await RTIService()
        .fetchRTIDetails(widget.rtiId, initialPage, initialLimit);
    // var queryStatus = await SharedPrefHelper.getQueryStatus();

    setState(() {
      // _queryStatus = queryStatus;
      data = res["data"];
      citizenDetails = res["data"]["citizen_details"];
      applicationNo = res["data"]["rti_no"];
      queries = res["data"]["queries"];
      tableData.clear();
      var list = res["data"]["rti_status_log"] as List;
      pagination = res["data"]["pagination"];
      for (var element in list) {
        tableData.add(element as Map<String, dynamic>);
      }
      if (citizenDetails["bpl"] == "1") {
        bplDetails = res["data"]["bpl_details"];
      }
    });
  }

  @override
  void initState() {
    getRTIDetials();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // var mw = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(initialPage.toString()),
        pageHeader(context),
        const Gap(20),
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppText.heading(
                "Citizen Profile",
                color: KCOLOR.brand,
              ),
              const Gap(10),
              citizenDetails.isEmpty
                  ? _loader(height: 110)
                  : Row(
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
              citizenDetails.isEmpty ? _loader(height: 40) : _education(),

              if (citizenDetails["bpl"] == "1") ...[
                const Gap(20),
                const AppText.heading(
                  "BPL",
                  color: KCOLOR.brand,
                ),
                const Gap(10),
                citizenDetails.isEmpty
                    ? _loader(height: 110)
                    : Row(
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
                                        visible:
                                            bplDetails["bpl_card_url"] != null,
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
                                child: InkWell(
                                  onTap: () async {
                                    launchUrl(Uri.parse(
                                        "${EndPoint.baseUrl}/${bplDetails["bpl_card_url"]}"));
                                  },
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
                              ),
                            ],
                          )),
                        ],
                      ),
              ],
              const Gap(20),
              _queries(),
              const Gap(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const AppText.heading(
                    "RTI Status logs",
                    color: KCOLOR.brand,
                  ),
                  PaginationBtn(
                    initialPage: initialPage,
                    next: () {
                      if (initialPage < pagination['pageCount']) {
                        initialPage++;
                        setState(() {
                          getRTIDetials();
                        });
                      }
                    },
                    previous: () {
                      if (initialPage > 1) {
                        initialPage--;
                        setState(() {
                          getRTIDetials();
                        });
                      }
                    },
                  ),
                ],
              ),
              const Gap(10),
              Container(
                color: KCOLOR.shade3,
                height: 200,
                child: _logsTableData(),
              ),
              const Gap(10),
              // _tableData()
              //BPL
            ],
          ),
        ),
      ],
    );
  }

  _loader({double? height}) {
    return Shimmer(
      color: Colors.white,
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: const BoxDecoration(
            color: KCOLOR.shade1,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        height: height ?? 110,
      ),
    );
  }

  _logsTableData() {
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
                    Text(getSerialNumber(
                            page: initialPage,
                            limit: initialLimit,
                            index: tableData.indexOf(e))
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
        citizenDetails.isEmpty
            ? _loader(height: 80)
            : ListView.builder(
                shrinkWrap: true,
                itemCount: queries.length,
                itemBuilder: (context, index) {
                  // var count = index + 1;
                  return Container(
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: KCOLOR.brand.withOpacity(0.03),
                      border: const Border(
                        left: BorderSide(color: KCOLOR.brand, width: 2),
                      ),
                    ),
                    child: ListTile(
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Gap(10),
                          Visibility(
                            visible:
                                queries[index]['response'].toString() == 'null',
                            child: TextButton.icon(
                                icon: const Icon(Icons.send),
                                onPressed: () async {
                                  var l =
                                      await SharedPrefHelper.getQueryStatus();
                                  _selectedQueryStatus = l
                                      ?.where(
                                        (element) =>
                                            element.id.toString() ==
                                            queries[index]["query_status_id"],
                                      )
                                      .first;
                                  createResponseDialog(context, index);
                                },
                                label: const Text("Response")),
                          ),
                        ],
                      ),
                      title: AppText.subheading(
                          "Query : ${queries[index]["query"]}"),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const AppText.smallText(
                                "Status : ",
                              ),
                              QueryStatusWidget(
                                id: int.parse(
                                    queries[index]["query_status_id"]),
                              ),
                            ],
                          ),
                          Visibility(
                            visible:
                                queries[index]['response'].toString() != 'null',
                            child: InkWell(
                              onTap: () {
                                viewResponseDialog(context, index);
                              },
                              child: const AppText.smallText(
                                "View response",
                                color: KCOLOR.brand,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ],
    );
  }

  Future<dynamic> viewResponseDialog(BuildContext context, int index) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          actions: [
            AppBtn.outline(
              "Okay",
              onPressed: () {
                getRTIDetials();
                Navigator.pop(context);
              },
            )
          ],
          title: const Text("Response"),
          content: ViewResponsePopup(
            data: queries[index],
          ),
        );
      },
    );
  }

  Future<dynamic> createResponseDialog(BuildContext context, int index) {
    return showDialog(
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
                var res = await service.createQueryResponse({
                  'rti_query_id': queries[index]["id"],
                  'rti_query_status': _selectedQueryStatus!.id,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Response",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Gap(20),
                  TextFormField(
                    controller: controller,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      hintText: "Enter your response here...",
                      label: Text("Response"),
                    ),
                  ),
                  const Gap(20),
                  QueryStatusDropdown(
                      onChanged: (status) async {
                        _selectedQueryStatus = status;
                        setState(() {});
                      },
                      initialId: queries[index]["query_status_id"]),
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

  userProfile() {
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
                onPressed: () async {
                  EasyLoading.show(status: "Please wait");

                  var service = FeeService();
                  var res = await service.fetchPerPageFeeAmount();
                  if (res != null) {
                    EasyLoading.dismiss();
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                            actions: [
                              AppBtn.fill(
                                "Update",
                                onPressed: () async {
                                  try {
                                    var service = ApplicationService();
                                    var res = await service
                                        .updateRTIApplicationStatus(
                                            int.parse(data["id"]),
                                            statusId ??
                                                int.parse(data['status_id']),
                                            pageCount);
                                    if (res["success"]) {
                                      EasyLoading.showSuccess(res["message"]);
                                      Navigator.pop(context);
                                      getRTIDetials();
                                    }
                                  } catch (e) {
                                    EasyLoading.showError(e.toString());
                                  }
                                },
                              )
                            ],
                            contentPadding: const EdgeInsets.all(30),
                            title: const AppText.heading(
                              "Status Update",
                            ),
                            content: RTIStatusUpdatePopup(
                              onStatusUpdate: (status) {
                                statusId = status.id;
                                setState(() {});
                              },
                              onPageCount: (v) {
                                pageCount = v;
                                setState(() {});
                              },
                              statuId: data['status'],
                            ));
                      },
                    );
                  }
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

class RTIStatusUpdatePopup extends StatefulWidget {
  const RTIStatusUpdatePopup(
      {super.key,
      required this.statuId,
      required this.onPageCount,
      required this.onStatusUpdate});
  final String statuId;
  final Function(int) onPageCount;
  final Function(StatusModel) onStatusUpdate;

  @override
  State<RTIStatusUpdatePopup> createState() => _RTIStatusUpdatePopupState();
}

class _RTIStatusUpdatePopupState extends State<RTIStatusUpdatePopup> {
  var data = {};

  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    getFee();
    super.initState();
  }

  int amountToPay = 0;

  getFee() async {
    var service = FeeService();
    var res = await service.fetchPerPageFeeAmount();
    if (res["success"]) {
      setState(() {
        data = res;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ApplicationStatusDropdown(
          onChanged: (status) async {
            widget.onStatusUpdate(status);
          },

          // initialId: data["status"],
          initialId: widget.statuId,
        ),
        const Gap(10),
        const AppText.subheading("Enter the number of extra pages"),
        const Gap(10),
        Form(
          key: _formKey,
          child: TextFormField(
            keyboardType: TextInputType.number,
            initialValue: "0",
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9999999]'))
            ],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter number";
              }
              return null;
            },
            onChanged: (value) {
              if (value.isEmpty) {
                amountToPay = 0;
                widget.onPageCount(0);
                setState(() {});
              } else {
                setState(() {
                  amountToPay = int.parse(value);
                  widget.onPageCount(amountToPay);
                });
              }
            },
            // controller: pageCountController,
            decoration: const InputDecoration(
                label: Text("Page"), hintText: "number of extra pages"),
          ),
        ),
        const Gap(10),
        if (amountToPay > 0)
          AppText.smallText(
            "Citizen has to pay of ₹${amountToPay * data["data"]['amount_per_page']} for extra pages",
            color: KCOLOR.danger,
          ),
      ],
    );
  }
}
