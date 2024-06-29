import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:rtiapp/src/common/extentions/extention.dart';
import 'package:rtiapp/src/common/widget/footer.widget.dart';
import 'package:rtiapp/src/common/widget/header.widget.dart';
import 'package:rtiapp/src/feature/admin/application/pages/rti_list.staf.dart';
import 'package:rtiapp/src/feature/admin/application/pages/rti_detail_staff.dart';
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
        body: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeaderWidget(),
              if (tab == 'table') ...[
                const Gap(10),
                SizedBox(
                  height: 600,
                  child: RTIListStaff(
                    onViewTab: (v) {
                      setState(() {
                        tab = "view";
                        _rtiId = v["id"];
                      });
                    },
                  ),
                )
              ],
              Visibility(
                visible: tab == "view",
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
            ],
          ).addPadding(left: 50, right: 50),
          const FooterWidget()
        ],
      ),
    ));
  }
}
