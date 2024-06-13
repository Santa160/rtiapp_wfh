part of 'pia_cubit.dart';

enum Status { initial, loading, loaded, error }

class PiaState extends Equatable {

  final List<String> dataColumn;
  final List<StateModel>? dataRaw;
  final int? page;
  final int? limit;
  final Status status;

  const PiaState({required this.dataColumn, this.dataRaw, this.page, this.limit, required this.status});
  @override
  List<Object?> get props => [status, dataColumn, dataRaw, page, limit];

}

//models

