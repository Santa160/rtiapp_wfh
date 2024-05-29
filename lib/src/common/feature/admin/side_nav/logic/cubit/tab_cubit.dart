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
      // case Routes.complete:
      //   emit(const TabState(Routes.complete));
      // case Routes.reports:
      //   emit(const TabState(Routes.reports));
      // case Routes.archive:
      //   emit(const TabState(Routes.archive));
    }
  }
}
