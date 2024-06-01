import 'package:rtiapp/src/common/utils/type.dart';

class DistrictModel extends HasName {
  @override
  final int id;
  @override
  final String name;
  final int stateId;

  DistrictModel({required this.id, required this.name, required this.stateId});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'state_id': stateId,
    };
  }

  factory DistrictModel.fromJson(Map<String, dynamic> json) {
    return DistrictModel(
      id: json['id'],
      name: json['name'],
      stateId: json['state_id'],
    );
  }
}
