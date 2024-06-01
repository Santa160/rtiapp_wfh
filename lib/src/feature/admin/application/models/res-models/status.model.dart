import 'package:rtiapp/src/common/utils/type.dart';

class ApplicationStatusModel extends HasName {
  @override
  final int id;
  @override
  final String name;

  ApplicationStatusModel({required this.id, required this.name});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory ApplicationStatusModel.fromJson(Map<String, dynamic> json) {
    return ApplicationStatusModel(
      id: json['id'],
      name: json['name'],
    );
  }
}
