part of 'citizen_tab_cubit.dart';

class CitizenTabState extends Equatable {
  const CitizenTabState(this.tabName);

  final String tabName;

  @override
  List<Object> get props => [tabName];
}
