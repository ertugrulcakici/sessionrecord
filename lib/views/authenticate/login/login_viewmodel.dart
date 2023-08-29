import 'package:flutter/material.dart';
import 'package:sessionrecord/core/service/firebase/auth_service.dart';

class LoginViewModel extends ChangeNotifier {
  Future<bool> login(String username, String password) async {
    return await AuthService.instance
        .login(username: username, password: password);
  }
}
