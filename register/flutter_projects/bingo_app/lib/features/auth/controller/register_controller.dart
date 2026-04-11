class RegisterController {
  Future<void> register(
    String username,
    String email,
    String password,
  ) async {
    await Future.delayed(const Duration(seconds: 2));

    // Fake validation
    if (email == "test@test.com") {
      throw Exception("Email already exists");
    }
  }
}