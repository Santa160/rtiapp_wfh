part of 'district_cubit.dart';

enum Status { initial, loading, loaded, error }

class DistrictState extends Equatable {

  final List<String> dataColumn;
  final List<DistrictModel>? dataRaw;
  final int? page;
  final int? limit;
  final Status status;

  const DistrictState({required this.dataColumn, this.dataRaw, this.page, this.limit, required this.status});
  @override
  List<Object?> get props => [status, dataColumn, dataRaw, page, limit];

}

//models

