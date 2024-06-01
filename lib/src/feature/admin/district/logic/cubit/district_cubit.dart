import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:rtiapp/src/core/logger.dart';
import 'package:rtiapp/src/feature/admin/district/models/res_models/district.model.dart';
import 'package:rtiapp/src/feature/admin/district/services/district.service.dart';



part 'district_state.dart';

List<String> listColumn = ["Sl", "Name", "Action"];

class DistrictCubit extends Cubit<DistrictState> {
  DistrictCubit()
      : super(DistrictState(status: Status.initial, dataColumn: listColumn));
  bool get isLoading => state.status == Status.loading;

  getDistrictTableData({required int page, required int limit}) async {
    if (isLoading) {
      return;
    }
    emit(DistrictState(
        status: Status.loading, dataColumn: listColumn, page: 1, limit: 10));
    try {
      var res = await DistrictService().fetchDistrict();

      var list = res["data"] as List;

      var loo = list.map(
        (e) {
          e as Map<String, dynamic>;
          return DistrictModel.fromJson(e);
        },
      ).toList();

      emit(DistrictState(
          status: Status.loaded,
          dataColumn: listColumn,
          dataRaw: loo,
          page: page,
          limit: limit));
    } catch (e) {
      logger.e(e);
      emit(DistrictState(status: Status.error, dataColumn: listColumn));
    }
  }

  //!! ====================== CUBIT CRUD ===========================
  Future addDistrict({required BuildContext context,required String stateId, required String name}) async {
    try {
      var res = await DistrictService().createDistrict(stateId,name);

      EasyLoading.showSuccess(res["message"].toString());
      getDistrictTableData(limit: state.limit ?? 10, page: state.page ?? 1);
    } catch (e) {
      EasyLoading.showError(e.toString());
    }
  }

  Future deleteDistrict({required int id}) async {
    var res = await DistrictService().deleteDistrict(id);

    getDistrictTableData(limit: state.limit ?? 10, page: state.page ?? 1);

    EasyLoading.showError(res["message"]);
  }

  Future updatedDistrict({required int id, required String newName}) async {
    var res = await DistrictService().updateDistrict(id, newName);

    EasyLoading.showSuccess(res["message"]);
    getDistrictTableData(limit: state.limit ?? 10, page: state.page ?? 1);
  }
}
