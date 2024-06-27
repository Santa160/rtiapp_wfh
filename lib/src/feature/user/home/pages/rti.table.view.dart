import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:rtiapp/src/common/widget/pagination.widget.dart';
import 'package:rtiapp/src/core/app_config.dart';
import 'package:rtiapp/src/core/kcolors.dart';

import 'package:rtiapp/src/feature/user/home/widget/datatable/rti.datatable.dart';

import 'package:rtiapp/src/feature/user/home/service/rti.service.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class RTITableView extends StatefulWidget {
  const RTITableView({super.key, required this.onViewTab});

  final Function(dynamic) onViewTab;

  @override
  State<RTITableView> createState() => _RTITableViewState();
}

class _RTITableViewState extends State<RTITableView> {
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

  getTableData() async {
    data.clear();
    pagination.clear();
    var service = RTIService();
    var res = await service.fetchRTIs(initialPage, initialLimit);
    pagination = res['pagination'] as Map<String, dynamic>;
    var l = res["data"] as List;

    l.map(
      (e) {
        data.add(e);
      },
    ).toList();
    if (l.isEmpty) {
      msg = "You have no rti application applied";
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
            Row(
              children: [
                const AppText.heading("RTI Application"),
                const Gap(10),
                AppBtn.outline(
                  "Apply RTI",
                  onPressed: () {},
                )
              ],
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
        if (msg.isNotEmpty) AppText.heading(msg),
        const Gap(10),
        if (data.isEmpty)
          Shimmer(
            child: const Placeholder(
              color: Colors.transparent,
            ),
          ),
        if (data.isNotEmpty)
          SizedBox(
            height: data.isEmpty || data.length < 5
                ? 400
                : 55 * data.length.toDouble(),
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
                "Status",
                "",
              ],
              viewAction: (data) {
                widget.onViewTab(data);
              },
            ),
          ),
      ],
    );

    // return Text(data.toString());
  }
}
