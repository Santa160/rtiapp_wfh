import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:rtiapp/src/core/logger.dart';
import 'package:rtiapp/src/feature/admin/state/models/res_models/state.model.dart';

import 'package:rtiapp/src/feature/admin/state/services/state.service.dart';

part 'state_state.dart';

List<String> listColumn = ["Sl", "Name", "Action"];

class StateCubit extends Cubit<StateState> {
  StateCubit()
      : super(StateState(status: Status.initial, dataColumn: listColumn));
  bool get isLoading => state.status == Status.loading;

  getStateTableData({required int page, required int limit}) async {
    if (isLoading) {
      return;
    }
    emit(StateState(
        status: Status.loading, dataColumn: listColumn, page: 1, limit: 10));
    try {
      var res = await StateService().fetchState();

      var list = res["data"] as List;

      var loo = list.map(
        (e) {
          e as Map<String, dynamic>;
          return StateModel.fromJson(e);
        },
      ).toList();

      emit(StateState(
          status: Status.loaded,
          dataColumn: listColumn,
          dataRaw: loo,
          page: page,
          limit: limit));
    } catch (e) {
      logger.e(e);
      emit(StateState(status: Status.error, dataColumn: listColumn));
    }
  }

  //!! ====================== CUBIT CRUD ===========================
  Future addState({required BuildContext context, required String name}) async {
    try {
      var res = await StateService().createState(name);

      EasyLoading.showSuccess(res["message"].toString());
      getStateTableData(limit: state.limit ?? 10, page: state.page ?? 1);
    } catch (e) {
      EasyLoading.showError(e.toString());
    }
  }

  Future deleteState({required int id}) async {
    var res = await StateService().deleteState(id);

    getStateTableData(limit: state.limit ?? 10, page: state.page ?? 1);

    EasyLoading.showError(res["message"]);
  }

  Future updatedState({required int id, required String newName}) async {
    var res = await StateService().updateState(id, newName);

    EasyLoading.showSuccess(res["message"]);
    getStateTableData(limit: state.limit ?? 10, page: state.page ?? 1);
  }
}
