import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtiapp/src/routers/route_names.dart';

part 'citizen_tab_state.dart';

class CitizenTabCubit extends Cubit<CitizenTabState> {
  CitizenTabCubit() : super(const CitizenTabState(KRoutes.application)) {
    emit(const CitizenTabState(KRoutes.home));
  }
  Future activeTab(String tab) async {
    switch (tab) {
      case KRoutes.home:
        emit(const CitizenTabState(KRoutes.home));
      case KRoutes.submitRTI:
        emit(const CitizenTabState(KRoutes.submitRTI));
      // case Routes.complete:
      //   emit(const TabState(Routes.complete));
      // case Routes.reports:
      //   emit(const TabState(Routes.reports));
      // case Routes.archive:
      //   emit(const TabState(Routes.archive));
    }
  }
}
