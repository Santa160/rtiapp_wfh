import 'package:rtiapp/src/common/utils/type.dart';

class PiaModel extends HasName {
  @override
  final int id;
  @override
  final String name;

  PiaModel({required this.id, required this.name});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory PiaModel.fromJson(Map<String, dynamic> json) {
    return PiaModel(
      id: json['id'],
      name: json['name'],
    );
  }
}
