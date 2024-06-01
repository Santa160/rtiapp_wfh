class QueryStatusModel {
  final int id;

  final String name;

  QueryStatusModel({required this.id, required this.name});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory QueryStatusModel.fromJson(Map<String, dynamic> json) {
    return QueryStatusModel(
      id: json['id'],
      name: json['name'],
    );
  }
}
