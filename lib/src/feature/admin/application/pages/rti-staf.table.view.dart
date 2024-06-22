import 'package:flutter/material.dart';
import 'package:rtiapp/src/feature/admin/application/services/rti_staff.service.dart';

import 'package:rtiapp/src/feature/user/home/widget/datatable/rti.datatable.dart';

class RTIStaffTableView extends StatefulWidget {
  const RTIStaffTableView({super.key, required this.onViewTab});

  final Function(dynamic) onViewTab;

  @override
  State<RTIStaffTableView> createState() => _RTIStaffTableViewState();
}

class _RTIStaffTableViewState extends State<RTIStaffTableView> {
  List<Map<String, dynamic>> data = [];
  Map<String, dynamic> pagination = {};
  int initialPage = 1;
  int initialLimit = 10;
  @override
  void initState() {
    getTableData();
    super.initState();
  }

  getTableData() async {
    var service = ApplicationService();
    var res = await service.fetchRTIApplicationStaff(initialPage, initialLimit);
    pagination = res['pagination'] as Map<String, dynamic>;
    var l = res["data"] as List;

    l.map(
      (e) {
        data.add(e);
      },
    ).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return RTIDataTableWidget(
      initialLimit: 1,
      initialPage: 1,
      loading: false,
      row: data,
      fetchData: (limit, page) async {},
      editAction: (data) {},
      column: const [
        "Sl no",
        "Application No",
        "Date",
        "Status",
        "Action",
      ],
      viewAction: (data) {
        widget.onViewTab(data);
      },
    );

    // return Text(data.toString());
  }
}
