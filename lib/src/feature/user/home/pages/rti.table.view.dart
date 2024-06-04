import 'package:flutter/material.dart';

import 'package:rtiapp/src/feature/user/home/widget/datatable/rti.datatable.dart';

import 'package:rtiapp/src/feature/user/home/service/rti.service.dart';

class RTITableView extends StatefulWidget {
  const RTITableView({super.key, required this.onViewTab});

  final Function(dynamic) onViewTab;

  @override
  State<RTITableView> createState() => _RTITableViewState();
}

class _RTITableViewState extends State<RTITableView> {
  List<Map<String, dynamic>> data = [];
  @override
  void initState() {
    getTableData();
    super.initState();
  }

  getTableData() async {
    var service = RTIService();
    var res = await service.fetchRTIs();
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
        "",
      ],
      viewAction: (data) {
        widget.onViewTab(data);
      },
    );

    // return Text(data.toString());
  }
}
