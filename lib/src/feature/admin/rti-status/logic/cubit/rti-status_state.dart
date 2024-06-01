part of 'rti-status_cubit.dart';

enum Status { initial, loading, loaded, error }

class RTIStatusState extends Equatable {

  final List<String> dataColumn;
  final List<RTIStatusModel>? dataRaw;
  final int? page;
  final int? limit;
  final Status status;

  const RTIStatusState({required this.dataColumn, this.dataRaw, this.page, this.limit, required this.status});
  @override
  List<Object?> get props => [status, dataColumn, dataRaw, page, limit];

}

//models

