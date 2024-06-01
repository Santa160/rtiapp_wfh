import 'package:rtiapp/src/common/utils/type.dart';

class QualificationModel extends HasName {
  @override
  final int id;
  @override
  final String name;
  final String isActive;

  QualificationModel({required this.id, required this.name, required this.isActive});

    Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'is_active': isActive,
    };
  }
  
  factory QualificationModel.fromJson(Map<String, dynamic> json) {
    return QualificationModel(
      id: json['id'],
      name: json['name'],
      isActive: json['is_active'],
    );
  }
}
