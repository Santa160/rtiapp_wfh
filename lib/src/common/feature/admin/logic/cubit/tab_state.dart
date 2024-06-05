part of 'tab_cubit.dart';

class TabState extends Equatable {
  const TabState(this.tabName);

  final String tabName;

  @override
  List<Object> get props => [tabName];
}


