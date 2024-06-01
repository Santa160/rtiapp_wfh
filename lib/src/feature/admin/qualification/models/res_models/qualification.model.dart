import 'package:rtiapp/src/common/utils/type.dart';

class QualificationModel extends HasName {
  @override
  final int id;
  @override
  final String name;

  QualificationModel({required this.id, required this.name});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory QualificationModel.fromJson(Map<String, dynamic> json) {
    return QualificationModel(
      id: json['id'],
      name: json['name'],
    );
  }
}
