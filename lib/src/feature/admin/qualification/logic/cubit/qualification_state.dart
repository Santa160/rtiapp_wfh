part of 'qualification_cubit.dart';

enum Status { initial, loading, loaded, error }

class QualificationState extends Equatable {

  final List<String> dataColumn;
  final List<QualificationModel>? dataRaw;
  final int? page;
  final int? limit;
  final Status status;

  const QualificationState({required this.dataColumn, this.dataRaw, this.page, this.limit, required this.status});
  @override
  List<Object?> get props => [status, dataColumn, dataRaw, page, limit];

}

//models

