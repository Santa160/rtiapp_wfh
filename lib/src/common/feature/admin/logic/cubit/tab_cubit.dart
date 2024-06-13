import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtiapp/src/routers/route_names.dart';

part 'tab_state.dart';

class TabCubit extends Cubit<TabState> {
  TabCubit() : super(const TabState(KRoutes.application)) {
    emit(const TabState(KRoutes.application));
  }
  Future activeTab(String tab) async {
    switch (tab) {
      case KRoutes.application:
        emit(const TabState(KRoutes.application));
      case KRoutes.setting:
        emit(const TabState(KRoutes.setting));
      case KRoutes.querystatus:
        emit(const TabState(KRoutes.querystatus));
      case KRoutes.rtiStatus:
        emit(const TabState(KRoutes.rtiStatus));
      case KRoutes.qualification:
        emit(const TabState(KRoutes.qualification));
      case KRoutes.state:
        emit(const TabState(KRoutes.state));
      case KRoutes.district:
        emit(const TabState(KRoutes.district));
      case KRoutes.pia:
        emit(const TabState(KRoutes.pia));
    }
  }
}
