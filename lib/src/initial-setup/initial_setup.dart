import 'package:rtiapp/src/core/shared_pref.dart';
import 'package:rtiapp/src/feature/admin/query-status/services/query.service.dart';
import 'package:rtiapp/src/feature/admin/rti-status/services/rti.service.dart';
import 'package:rtiapp/src/initial-setup/models/query_status.dart';
import 'package:rtiapp/src/initial-setup/models/status.model.dart';

class InitialSetup {
  static status() async {
    var res = await RTIStatusService().fetchRTIstatus();
    if (res != null) {
      var raw = res["data"] as List;
      var list = raw.map((e) => StatusModel.fromJson(e)).toList();
      await SharedPrefHelper.saveStatus(list);
    }
  }

  static queryStatus() async {
    var res = await QueryService().fetchQuery();
    if (res != null) {
      var raw = res["data"] as List;
      var list = raw.map((e) => QueryStatusModel.fromJson(e)).toList();
      await SharedPrefHelper.saveQueryStatus(list);
    }
  }
}
