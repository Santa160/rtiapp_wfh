import 'package:rtiapp/src/common/utils/type.dart';

class DistrictModel extends HasName {
  @override
  final int id;
  @override
  final String name;
  final String isActive;

  DistrictModel({required this.id, required this.name, required this.isActive});

    Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'is_active': isActive,
    };
  }
  
  factory DistrictModel.fromJson(Map<String, dynamic> json) {
    return DistrictModel(
      id: json['id'],
      name: json['name'],
      isActive: json['is_active'],
    );
  }
}
