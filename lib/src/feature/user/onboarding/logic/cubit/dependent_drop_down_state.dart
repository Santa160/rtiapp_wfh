part of 'dependent_drop_down_cubit.dart';

class DependentDropDownState extends Equatable {
  final List<Map<String, dynamic>> data;

  const DependentDropDownState({required this.data});
  @override
  List<Object?> get props => [data];
}
