import 'session_store.dart';

class SessionController {
  SessionController({SessionStore? store}) : _store = store ?? SessionStore();

  final SessionStore _store;

  Future<String?> getCurrentUserId() async {
    await Future<void>.delayed(const Duration(seconds: 2));
    return await _store.hasSession() ? 'demo-user' : null;
  }
}
