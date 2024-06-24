import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:rtiapp/src/core/logger.dart';
import 'package:rtiapp/src/core/shared_pref.dart';

import 'package:rtiapp/src/feature/admin/query-status/models/res_models/query.model.dart';
import 'package:rtiapp/src/feature/admin/query-status/services/query.service.dart';
import 'package:rtiapp/src/initial-setup/models/query_status.dart';

part 'query_state.dart';

List<String> listColumn = ["Sl", "Name", "Action"];

class QueryCubit extends Cubit<QueryState> {
  QueryCubit()
      : super(QueryState(status: Status.initial, dataColumn: listColumn));
  bool get isLoading => state.status == Status.loading;

  getQueryTableData({required int page, required int limit}) async {
    if (isLoading) {
      return;
    }
    emit(QueryState(
        status: Status.loading, dataColumn: listColumn, page: 1, limit: 10));
    try {
      var res = await QueryService().fetchQuery();

      var list = res["data"] as List;

      var loo = list.map(
        (e) {
          e as Map<String, dynamic>;
          return QueryModel.fromJson(e);
        },
      ).toList();

      emit(QueryState(
          status: Status.loaded,
          dataColumn: listColumn,
          dataRaw: loo,
          page: page,
          limit: limit));
    } catch (e) {
      logger.e(e);
      emit(QueryState(status: Status.error, dataColumn: listColumn));
    }
  }

  //!! ====================== CUBIT CRUD ===========================
  Future addQuery({required BuildContext context, required String name}) async {
    try {
      var res = await QueryService().createQuery(name);

      EasyLoading.showSuccess(res["message"].toString());
      getQueryTableData(limit: state.limit ?? 10, page: state.page ?? 1);
    } catch (e) {
      EasyLoading.showError(e.toString());
    }
  }

  Future deleteQuery({required int id}) async {
    var res = await QueryService().deleteQuery(id);

    getQueryTableData(limit: state.limit ?? 10, page: state.page ?? 1);

    EasyLoading.showError(res["message"]);
  }

  Future updatedQuery({required int id, required String newName}) async {
    var res = await QueryService().updateQuery(id, newName);

    if (res['success']) {
      EasyLoading.showSuccess(res["message"]);

      var resq = await QueryService().fetchQuery();

      if (resq['success']) {
        var raw = resq["data"] as List;
        var list = raw.map((e) => QueryStatusModel.fromJson(e)).toList();
        await SharedPrefHelper.saveQueryStatus(list);
      }
    }
    getQueryTableData(limit: state.limit ?? 10, page: state.page ?? 1);
  }
}
