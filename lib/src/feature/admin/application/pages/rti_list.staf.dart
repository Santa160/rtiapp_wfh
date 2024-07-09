import 'package:flutter/material.dart';

import 'package:rtiapp/src/common/widget/pagination.widget.dart';
import 'package:rtiapp/src/core/app_config.dart';
import 'package:rtiapp/src/core/kcolors.dart';
import 'package:rtiapp/src/core/shared_pref.dart';
import 'package:rtiapp/src/feature/admin/application/services/rti_staff.service.dart';

import 'package:rtiapp/src/feature/user/home/widget/datatable/rti.datatable.dart';
import 'package:rtiapp/src/feature/user/home/widget/search.widget.dart';

class RTITable extends StatefulWidget {
  const RTITable({super.key, required this.onViewTab});

  final Function(dynamic) onViewTab;

  @override
  State<RTITable> createState() => _RTITableState();
}

class _RTITableState extends State<RTITable> {
  List<Map<String, dynamic>> data = [];
  Map<String, dynamic> pagination = {};
  int initialPage = 1;
  int initialLimit = 10;
  String msg = '';
  @override
  void initState() {
    getTableData();
    super.initState();
  }

  getTableData({String? rtiNo, String? statusId}) async {
    data.clear();
    pagination.clear();
    var service = ApplicationService();
    var res = await service.fetchRTIApplicationStaff(initialPage, initialLimit,
        rtiid: rtiNo ?? '', statusid: statusId ?? '');
    pagination = res['pagination'] as Map<String, dynamic>;
    var l = res["data"] as List;

    l.map(
      (e) {
        data.add(e);
      },
    ).toList();
    if (l.isEmpty) {
      msg = "No Record";
    } else {
      msg = '';
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppText.heading("RTI Application"),
                AppText.smallText(
                  msg,
                  color: KCOLOR.danger,
                )
              ],
            ),
            Row(
              children: [
                SearchWidget(
                  onTab: (value) {
                    getTableData(rtiNo: value);
                  },
                ),
                FutureBuilder(
                  future: SharedPrefHelper.getStatus(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var d = snapshot.data;
                      return PopupMenuButton(
                        icon: const Icon(Icons.filter_alt_outlined),
                        onSelected: (value) {
                          initialPage = 1;
                          getTableData(statusId: value.toString());
                        },
                        tooltip: '',
                        itemBuilder: (context) {
                          return [
                            const PopupMenuItem(value: 0, child: Text("All")),
                            ...d!.map(
                              (e) {
                                return PopupMenuItem(
                                    value: e.id, child: Text(e.name));
                              },
                            )
                          ];
                        },
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
                PaginationBtn(
                  initialPage: initialPage,
                  next: () {
                    if (initialPage < pagination['pageCount']) {
                      initialPage++;
                      getTableData();
                      setState(() {});
                    }
                  },
                  previous: () {
                    if (initialPage > 1) {
                      initialPage--;
                      getTableData();
                      setState(() {});
                    }
                  },
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          width: double.maxFinite,
          child: RTIDataTableWidget(
            initialLimit: initialLimit,
            initialPage: initialPage,
            loading: false,
            row: data,
            fetchData: (limit, page) async {},
            editAction: (data) {},
            column: const [
              "Sl no",
              "Application No",
              "Date",
              "Days Pending",
              "Status",
              "Action",
            ],
            viewAction: (data) {
              getTableData();
              widget.onViewTab(data);
            },
          ),
        ),
      ],
    );

    // return Text(data.toString());
  }
}
