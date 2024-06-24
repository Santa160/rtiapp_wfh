import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:rtiapp/src/common/extentions/extention.dart';
import 'package:rtiapp/src/common/widget/pagination.widget.dart';
import 'package:rtiapp/src/common/widget/serial_number.dart';
import 'package:rtiapp/src/core/app_config.dart';
import 'package:rtiapp/src/core/kcolors.dart';
import 'package:rtiapp/src/feature/user/home/service/rti.service.dart';
import 'package:rtiapp/src/feature/user/home/widget/rti_status.widget.dart';

class RTIStatusLogsTableWidget extends StatefulWidget {
  const RTIStatusLogsTableWidget({super.key, required this.rtiId});
  final String rtiId;

  @override
  State<RTIStatusLogsTableWidget> createState() =>
      _RTIStatusLogsTableWidgetState();
}

class _RTIStatusLogsTableWidgetState extends State<RTIStatusLogsTableWidget> {
  List<Map<String, dynamic>> tableData = [];

//rti logs
  Map<String, dynamic> pagination = {};

  int initialPage = 1;
  int initialLimit = 5;
  @override
  void initState() {
    getRtiStatusLogs();
    super.initState();
  }

  

  getRtiStatusLogs() async {
    tableData.clear();
    var res = await RTIService()
        .fetchRTIStatusLogsByRTIID(widget.rtiId, initialPage, initialLimit);
    var list = res["data"] as List;
    pagination = res['pagination'] as Map<String, dynamic>;
    for (var element in list) {
      tableData.add(element as Map<String, dynamic>);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
                  getRtiStatusLogs();
                  setState(() {});
                }
              },
              previous: () {
                if (initialPage > 1) {
                  initialPage--;
                  getRtiStatusLogs();
                  setState(() {});
                }
              },
            ),
          ],
        ),
        const Gap(10),
        SizedBox(
          height: 200,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: DataTable2(
                minWidth: 900,
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
          ),
        ),
      ],
    );
  }
}
