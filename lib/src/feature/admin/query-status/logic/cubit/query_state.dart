part of 'query_cubit.dart';

enum Status { initial, loading, loaded, error }

class QueryState extends Equatable {

  final List<String> dataColumn;
  final List<QueryModel>? dataRaw;
  final int? page;
  final int? limit;
  final Status status;

  const QueryState({required this.dataColumn, this.dataRaw, this.page, this.limit, required this.status});
  @override
  List<Object?> get props => [status, dataColumn, dataRaw, page, limit];

}

//models

