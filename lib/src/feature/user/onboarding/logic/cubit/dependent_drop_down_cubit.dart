

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtiapp/src/core/logger.dart';
import 'package:rtiapp/src/feature/user/onboarding/service/onboarding.service.dart';

part 'dependent_drop_down_state.dart';

class DependentDropDownCubit extends Cubit<DependentDropDownState> {
  DependentDropDownCubit() : super(const DependentDropDownState(data: []));

  getDistrictByStateId(String id) async {
    var dis = OnboardingServices();
    try {
      var res = await dis.fetchDisctrict(id: id);
      var ls = res["data"] as List;
      var data = ls
          .map(
            (e) => e as Map<String, dynamic>,
          )
          .toList();

      emit(DependentDropDownState(data: data));
    } catch (e) {
      logger.e(e);
    }
  }
}
