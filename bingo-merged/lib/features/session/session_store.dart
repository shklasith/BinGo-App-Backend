import 'package:shared_preferences/shared_preferences.dart';

class SessionStore {
  static const _sessionKey = 'bingo_merged_has_session';

  Future<bool> hasSession() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_sessionKey) ?? false;
  }

  Future<void> saveSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_sessionKey, true);
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_sessionKey, false);
  }
}
