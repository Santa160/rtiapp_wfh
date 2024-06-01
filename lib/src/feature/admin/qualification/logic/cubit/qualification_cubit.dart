import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:rtiapp/src/core/logger.dart';
import 'package:rtiapp/src/feature/admin/qualification/models/res_models/qualification.model.dart';
import 'package:rtiapp/src/feature/admin/qualification/services/qualification.service.dart';
import 'package:rtiapp/src/feature/admin/state/models/res_models/state.model.dart';

import 'package:rtiapp/src/feature/admin/state/services/state.service.dart';


part 'qualification_state.dart';

List<String> listColumn = ["Sl", "Name", "Action"];

class QualificationCubit extends Cubit<QualificationState> {
  QualificationCubit()
      : super(QualificationState(status: Status.initial, dataColumn: listColumn));
  bool get isLoading => state.status == Status.loading;

  getQualificationTableData({required int page, required int limit}) async {
    if (isLoading) {
      return;
    }
    emit(QualificationState(
        status: Status.loading, dataColumn: listColumn, page: 1, limit: 10));
    try {
      var res = await QualificationService().fetchQualification();

      var list = res["data"] as List;

      var loo = list.map(
        (e) {
          e as Map<String, dynamic>;
          return QualificationModel.fromJson(e);
        },
      ).toList();

      emit(QualificationState(
          status: Status.loaded,
          dataColumn: listColumn,
          dataRaw: loo,
          page: page,
          limit: limit));
    } catch (e) {
      logger.e(e);
      emit(QualificationState(status: Status.error, dataColumn: listColumn));
    }
  }

  //!! ====================== CUBIT CRUD ===========================
  Future addQualification({required BuildContext context, required String name}) async {
    try {
      var res = await QualificationService().createQualification(name);

      EasyLoading.showSuccess(res["message"].toString());
      getQualificationTableData(limit: state.limit ?? 10, page: state.page ?? 1);
    } catch (e) {
      EasyLoading.showError(e.toString());
    }
  }

  Future deleteQualification({required int id}) async {
    var res = await QualificationService().deleteQualification(id);

    getQualificationTableData(limit: state.limit ?? 10, page: state.page ?? 1);

    EasyLoading.showError(res["message"]);
  }

  Future updatedQualification({required int id, required String newName}) async {
    var res = await QualificationService().updateQualification(id, newName);

    EasyLoading.showSuccess(res["message"]);
    getQualificationTableData(limit: state.limit ?? 10, page: state.page ?? 1);
  }
}
