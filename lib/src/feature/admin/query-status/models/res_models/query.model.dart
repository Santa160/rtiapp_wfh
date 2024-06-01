import 'package:rtiapp/src/common/utils/type.dart';

class QueryModel extends HasName {
  @override
  final int id;
  @override
  final String name;


  QueryModel({required this.id, required this.name});

    Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      
    };
  }
  
  factory QueryModel.fromJson(Map<String, dynamic> json) {
    return QueryModel(
      id: json['id'],
      name: json['name'],
    
    );
  }
}
