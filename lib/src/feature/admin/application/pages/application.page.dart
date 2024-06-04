import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:rtiapp/src/common/extentions/extention.dart';
import 'package:rtiapp/src/common/widget/header.widget.dart';
import 'package:rtiapp/src/core/app_config.dart';
import 'package:rtiapp/src/feature/admin/application/pages/rti-staf.table.view.dart';
import 'package:rtiapp/src/feature/admin/application/pages/rti_staff_view.page.dart';
import 'package:rtiapp/src/initial-setup/initial_setup.dart';

class ApplicationPage extends StatefulWidget {
  const ApplicationPage({super.key});

  @override
  State<ApplicationPage> createState() => _ApplicationPageState();
}

class _ApplicationPageState extends State<ApplicationPage> {
  String tab = "table";
  String _rtiId = "0";

  @override
  void initState() {
    InitialSetup.status();
    InitialSetup.queryStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HeaderWidget(),
        const Gap(20),
        if (tab == "table") ...[
          const AppText.heading("RTI Application"),
          Expanded(
            child: RTIStaffTableView(
              onViewTab: (v) {
                setState(() {
                  tab = "view";
                  _rtiId = v["id"];
                });
              },
            ),
          ),
        ],
        Visibility(
          visible: tab == "view",
          child: Expanded(
            child: RTIStaffViewPage(
              rtiId: _rtiId,
              onBackTab: () {
                setState(() {
                  tab = "table";
                  _rtiId = "0";
                });
              },
            ),
          ),
        ),
      ],
    ).addPadding(left: 50, right: 50));
  }
}
