import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:rtiapp/src/common/extentions/extention.dart';

import 'package:rtiapp/src/common/widget/rich_text.dart';
import 'package:rtiapp/src/common/widget/title_style.dart';
import 'package:rtiapp/src/core/kcolors.dart';
import 'package:rtiapp/src/core/logger.dart';
import 'package:rtiapp/src/feature/user/home/service/rti.service.dart';

class RTIViewPage extends StatefulWidget {
  const RTIViewPage({super.key, required this.rtiId, required this.onBackTab});
  final String rtiId;
  final Function() onBackTab;

  @override
  State<RTIViewPage> createState() => _RTIViewPageState();
}

class _RTIViewPageState extends State<RTIViewPage> {
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
    logger.d(res);
    setState(() {
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
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton.icon(
              icon: const Icon(Icons.arrow_back),
              onPressed: widget.onBackTab,
              label: Text(
                "RTI Application no. $applicationNo",
                style: const TextStyle(fontSize: 20),
              )),
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
                citizenDetails["state_id"].toString(),
              ),
              const Gap(30),
              richText(
                "Status:",
                "missing from api",
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
                citizenDetails["qualification_id"].toString(),
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
              // return const Text("sdasd");
              var count = index + 1;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Question $count",
                    style: style,
                  ),
                  Text(queries[index]["query"]),
                  const Gap(20),
                ],
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
      ).addPadding(left: mw > 650 ? 150 : 50, right: mw > 650 ? 150 : 50),
    );
  }
}
