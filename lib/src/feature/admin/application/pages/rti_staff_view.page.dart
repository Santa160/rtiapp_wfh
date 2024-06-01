import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:rtiapp/src/common/extentions/extention.dart';

import 'package:rtiapp/src/common/widget/rich_text.dart';
import 'package:rtiapp/src/common/widget/title_style.dart';
import 'package:rtiapp/src/core/kcolors.dart';
import 'package:rtiapp/src/core/logger.dart';
import 'package:rtiapp/src/core/shared_pref.dart';
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
  List<QueryStatusModel>? _queryStatus;
  Map<String, dynamic> citizenDetails = {};
  String applicationNo = '';
  Map<String, dynamic> bplDetails = {};
  List queries = [];

  @override
  void initState() {
    getRTIDetials();
    super.initState();
  }

  getRTIDetials() async {
    var res = await RTIService().fetchRTIDetails(widget.rtiId);
    var queryStatus = await SharedPrefHelper.getQueryStatus();
    logger.d(res);
    setState(() {
      _queryStatus = queryStatus;
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
    var mw = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton.icon(
                icon: const Icon(Icons.arrow_back),
                onPressed: widget.onBackTab,
                label: Text(
                  "RTI Application no. $applicationNo",
                  style: const TextStyle(fontSize: 20),
                )),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("   Status:"),
                TextButton.icon(
                    icon: const Icon(Icons.schedule),
                    onPressed: () {},
                    label: Text(
                      data["status"],
                      style: const TextStyle(fontSize: 20),
                    )),
              ],
            ),
          ],
        ),
        const Gap(30),
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
                      onPressed: () {},
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
        Expanded(
          child: ClipRRect(
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
          ),
        )
        //BPL
      ],
    );
  }
}
