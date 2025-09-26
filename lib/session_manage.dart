import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const _loggedInKey = 'isLoggedIn';

  static Future<void> saveLoginSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loggedInKey, true);
  }

  static Future<void> clearLoginSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_loggedInKey);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_loggedInKey) ?? false;
  }
}
