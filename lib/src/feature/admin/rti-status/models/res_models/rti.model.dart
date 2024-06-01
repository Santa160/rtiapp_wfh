import 'package:rtiapp/src/common/utils/type.dart';

class RTIStatusModel extends HasName {
  @override
  final int id;
  @override
  final String name;


  RTIStatusModel({required this.id, required this.name});

    Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      
    };
  }
  
  factory RTIStatusModel.fromJson(Map<String, dynamic> json) {
    return RTIStatusModel(
      id: json['id'],
      name: json['name'],
    
    );
  }
}
