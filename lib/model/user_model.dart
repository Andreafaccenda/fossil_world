import 'fossil.dart';

class UserModel {
  String? userId, nome, email, password;

  UserModel({required this.userId, required this.nome, required this.email, required this.password});

  UserModel.fromJson(Map<dynamic, dynamic> map) {
    if (map == null) {
      return;
    }
    userId = map['userId'];
    nome = map['nome'];
    email = map['email'];
    password=map['password'];
  }

  toJson() {
    return {
      'userId': userId,
      'nome': nome,
      'email': email,
      'password': password,
    };
  }
}
