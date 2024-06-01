import 'package:rtiapp/src/common/utils/type.dart';

class StateModel extends HasName {
  @override
  final int id;
  @override
  final String name;

  StateModel({required this.id, required this.name});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory StateModel.fromJson(Map<String, dynamic> json) {
    return StateModel(
      id: json['id'],
      name: json['name'],
    );
  }
}
