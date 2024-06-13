import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:rtiapp/src/core/logger.dart';
import 'package:rtiapp/src/feature/admin/pia/services/pia.service.dart';
import 'package:rtiapp/src/feature/admin/state/models/res_models/state.model.dart';

part 'pia_state.dart';

List<String> listColumn = ["Sl", "Name", "Action"];

class PiaCubit extends Cubit<PiaState> {
  PiaCubit() : super(PiaState(status: Status.initial, dataColumn: listColumn));
  bool get isLoading => state.status == Status.loading;

  getPiaTableData({required int page, required int limit}) async {
    if (isLoading) {
      return;
    }
    emit(PiaState(
        status: Status.loading, dataColumn: listColumn, page: 1, limit: 10));
    try {
      var res = await PiaService().fetchPia();

      var list = res["data"] as List;

      var loo = list.map(
        (e) {
          e as Map<String, dynamic>;
          return StateModel.fromJson(e);
        },
      ).toList();

      emit(PiaState(
          status: Status.loaded,
          dataColumn: listColumn,
          dataRaw: loo,
          page: page,
          limit: limit));
    } catch (e) {
      logger.e(e);
      emit(PiaState(status: Status.error, dataColumn: listColumn));
    }
  }

  //!! ====================== CUBIT CRUD ===========================
  Future addPia({required BuildContext context, required String name}) async {
    try {
      var res = await PiaService().createPia(name);

      EasyLoading.showSuccess(res["message"].toString());
      getPiaTableData(limit: state.limit ?? 10, page: state.page ?? 1);
    } catch (e) {
      EasyLoading.showError(e.toString());
    }
  }

  Future deletePia({required int id}) async {
    var res = await PiaService().deletePia(id);

    getPiaTableData(limit: state.limit ?? 10, page: state.page ?? 1);

    EasyLoading.showError(res["message"]);
  }

  Future updatedPia({required int id, required String newName}) async {
    var res = await PiaService().updatePia(id, newName);

    EasyLoading.showSuccess(res["message"]);
    getPiaTableData(limit: state.limit ?? 10, page: state.page ?? 1);
  }
}
