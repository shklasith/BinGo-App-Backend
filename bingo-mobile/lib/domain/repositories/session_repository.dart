abstract class SessionRepository {
  Future<String?> getUserId();
  Future<void> setUserId(String userId);
  Future<void> clear();
}
