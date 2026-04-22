import '../session/session_store.dart';

class RegisterController {
  RegisterController({SessionStore? store}) : _store = store ?? SessionStore();

  final SessionStore _store;

  Future<void> register(String username, String email, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    await _store.saveSession();
  }
}
