import '../../core/network/api_client.dart';
import '../notifications/push_notification_service.dart';
import '../session/session_store.dart';

class RegisterController {
  RegisterController({ApiClient? apiClient, SessionStore? store})
    : _apiClient = apiClient ?? ApiClient(sessionStore: store),
      _store = store ?? SessionStore();

  final ApiClient _apiClient;
  final SessionStore _store;

  Future<void> register(String username, String email, String password) async {
    final data = await _apiClient.post(
      '/api/users/register',
      body: <String, dynamic>{
        'username': username,
        'email': email,
        'password': password,
      },
    );

    final userId = data['_id']?.toString() ?? '';
    final token = data['token']?.toString() ?? '';
    if (userId.isEmpty || token.isEmpty) {
      throw const ApiException(
        'Registration response did not include a session.',
      );
    }

    await _store.saveSession(userId: userId, token: token);
    await PushNotificationService.registerForSignedInUser();
  }
}
