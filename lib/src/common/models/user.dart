// create a user model in dart;{
//     "id": 1,
//     "username": "mspcl_admin",
//     "email": "mail@domain.com",
//     "accessToken": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlblR5cGUiOiJhY2Nlc3NfdG9rZW4iLCJpc3MiOiJtc3BjbHJ0aWFwaS5nbG9iaXpzYXBwLmNvbSIsImlhdCI6MTcxNzM5OTU1MywiZXhwIjoxNzIzODc5NTUzLCJzdWIiOjEsInJvbGUiOiJzdGFmZiJ9.38Tt06bHR7h4lh5oT3_MWqqz1Uuvku4JxAJCGdaR1I4"
// }
class UserModel {
  final int id;
  final String username;
  final String email;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
    );
  }
}
