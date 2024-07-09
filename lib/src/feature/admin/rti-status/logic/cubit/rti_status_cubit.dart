import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:rtiapp/src/core/logger.dart';
import 'package:rtiapp/src/core/shared_pref.dart';
import 'package:rtiapp/src/feature/admin/rti-status/models/res_models/rti.model.dart';

import 'package:rtiapp/src/feature/admin/rti-status/services/rti.service.dart';
import 'package:rtiapp/src/initial-setup/models/status.model.dart';

part 'rti_status_state.dart';

List<String> listColumn = ["Sl", "Name", "Action"];

class RTIStatusCubit extends Cubit<RTIStatusState> {
  RTIStatusCubit()
      : super(RTIStatusState(status: Status.initial, dataColumn: listColumn));
  bool get isLoading => state.status == Status.loading;

  getRTIStatusTableData({required int page, required int limit}) async {
    if (isLoading) {
      return;
    }
    emit(RTIStatusState(
        status: Status.loading, dataColumn: listColumn, page: 1, limit: 10));
    try {
      var res = await RTIStatusService().fetchRTIstatus();

      var list = res["data"] as List;

      var loo = list.map(
        (e) {
          e as Map<String, dynamic>;
          return RTIStatusModel.fromJson(e);
        },
      ).toList();

      emit(RTIStatusState(
          status: Status.loaded,
          dataColumn: listColumn,
          dataRaw: loo,
          page: page,
          limit: limit));
    } catch (e) {
      logger.e(e);
      emit(RTIStatusState(status: Status.error, dataColumn: listColumn));
    }
  }

  //!! ====================== CUBIT CRUD ===========================
  Future addRTIStatus(
      {required BuildContext context, required String name}) async {
    try {
      var res = await RTIStatusService().createRTIstatus(name);

      EasyLoading.showSuccess(res["message"].toString());
      getRTIStatusTableData(limit: state.limit ?? 10, page: state.page ?? 1);
    } catch (e) {
      EasyLoading.showError(e.toString());
    }
  }

  Future deleteRTIStatus({required int id}) async {
    var res = await RTIStatusService().deleteRTIstatus(id);

    getRTIStatusTableData(limit: state.limit ?? 10, page: state.page ?? 1);

    EasyLoading.showError(res["message"]);
  }

  Future updatedRTIStatus({required int id, required String newName}) async {
    var res = await RTIStatusService().updateRTIstatus(id, newName);

    if (res['success']) {
      EasyLoading.showSuccess(res["message"].toString());
      var ress = await RTIStatusService().fetchRTIstatus();
      if (ress['success']) {
        var raw = ress["data"] as List;
        var list = raw.map((e) => StatusModel.fromJson(e)).toList();
        await SharedPrefHelper.saveStatus(list);
      }

      getRTIStatusTableData(limit: state.limit ?? 10, page: state.page ?? 1);
    }
  }
}
