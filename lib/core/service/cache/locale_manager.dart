import 'package:shared_preferences/shared_preferences.dart';

class LocaleManager {
  static late LocaleManager _localeManager;
  LocaleManager._();

  static late SharedPreferences _preferences;
  static LocaleManager get instance => _localeManager;

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
    _localeManager = LocaleManager._();
  }

  String? getLocaleToken() => _preferences.getString("token");
  String? getCurrentUsername() => _preferences.getString("username");
  String? getCurrentUserId() => _preferences.getString("userId");

  Future<bool> setLocaleToken(String token) =>
      _preferences.setString("token", token);
  Future<bool> setCurrentUsername(String username) =>
      _preferences.setString("username", username);

  Future<bool> setCurrentUserId(String userId) =>
      _preferences.setString("userId", userId);
}
