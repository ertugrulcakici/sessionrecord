// ignore_for_file: non_constant_identifier_names

class UserModel {
  String? id;
  String? username;
  String? token;
  String? password;
  bool? is_admin;

  UserModel({
    this.id,
    this.username,
    this.token,
    this.password,
    this.is_admin,
  });

  @override
  String toString() {
    return 'User{id: $id, username: $username, token: $token, password: $password, is_admin: $is_admin}';
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id ?? "",
      "username": username ?? "",
      "password": password ?? "",
      "token": token ?? "",
      "is_admin": is_admin ?? false,
    };
  }
}
