import 'package:rtiapp/src/common/utils/type.dart';

class StateModel extends HasName {
  @override
  final int id;
  @override
  final String name;
  final String isActive;

  StateModel({required this.id, required this.name, required this.isActive});

    Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'is_active': isActive,
    };
  }
  
  factory StateModel.fromJson(Map<String, dynamic> json) {
    return StateModel(
      id: json['id'],
      name: json['name'],
      isActive: json['is_active'],
    );
  }
}
