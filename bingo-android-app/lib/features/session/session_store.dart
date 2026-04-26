import 'package:shared_preferences/shared_preferences.dart';

class SessionStore {
  static const _sessionKey = 'bingo_merged_has_session';
  static const _userIdKey = 'bingo_merged_user_id';
  static const _tokenKey = 'bingo_merged_token';

  Future<bool> hasSession() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> saveSession({
    required String userId,
    required String token,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_sessionKey, true);
    await prefs.setString(_userIdKey, userId);
    await prefs.setString(_tokenKey, token);
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_tokenKey);
  }
}
