import 'package:rtiapp/src/common/utils/type.dart';

class DistrictModel extends HasName {
  @override
  final int id;
  @override
  final String name;

  DistrictModel({required this.id, required this.name});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory DistrictModel.fromJson(Map<String, dynamic> json) {
    return DistrictModel(
      id: json['id'],
      name: json['name'],
    );
  }
}
