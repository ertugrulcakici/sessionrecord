import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:sessionrecord/core/service/cache/locale_manager.dart';
import 'package:sessionrecord/core/service/firebase/firebase_service.dart';
import 'package:sessionrecord/product/model/user_model.dart';

class AuthService extends FirebaseService {
  static late UserModel _currentUser;
  static late AuthService _instance;
  static AuthService get instance => _instance;

  static UserModel get currentUser => _currentUser;

  AuthService._internal() : super();
  static init() {
    _instance = AuthService._internal();
    _currentUser = UserModel(
        id: LocaleManager.instance.getCurrentUserId(),
        username: LocaleManager.instance.getCurrentUsername(),
        token: LocaleManager.instance.getLocaleToken());
  }

  Future<bool> login(
      {required String username, required String password}) async {
    if (username == "" || password == "") return false;

    final _userReferance = await firestore
        .collection("users")
        .where("username", isEqualTo: username)
        .where("password", isEqualTo: password)
        .limit(1)
        .get();

    if (_userReferance.docs.isEmpty) {
      return false;
    } else {
      String _generatedToken = _generateToken;

      firestore
          .collection("users")
          .doc(_userReferance.docs.first.id)
          .update({"token": _generatedToken});

      _currentUser = UserModel(
          is_admin: _userReferance.docs.first.data()["is_admin"],
          id: _userReferance.docs.first.id,
          username: username,
          token: _generatedToken);

      await LocaleManager.instance.setLocaleToken(_currentUser.token ?? "");
      await LocaleManager.instance
          .setCurrentUsername(_currentUser.username ?? "");
      await LocaleManager.instance.setCurrentUserId(currentUser.id ?? "");

      return true;
    }
  }

  Future<bool> isLoggedIn() async {
    String? _localeToken = LocaleManager.instance.getLocaleToken();

    final _result = await firestore
        .collection("users")
        .where("token", isEqualTo: _localeToken)
        .limit(1)
        .get();

    if (_result.docs.isEmpty) return false;

    final _userData = _result.docs[0].data();

    if (_localeToken != null && _localeToken == _userData["token"]) {
      _currentUser = UserModel(
          id: _result.docs[0].id,
          username: _result.docs[0].data()["username"],
          token: _localeToken,
          is_admin: _result.docs[0].data()["is_admin"]);
      return true;
    } else {
      return false;
    }
  }

  static String get _generateToken =>
      sha256.convert(utf8.encode(DateTime.now().toString())).toString();
}
