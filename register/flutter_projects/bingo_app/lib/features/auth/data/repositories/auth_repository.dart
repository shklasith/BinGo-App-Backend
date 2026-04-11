import '../models/user_model.dart';
import '../../../../core/services/api_service.dart';

class AuthRepository {
  final ApiService _apiService = ApiService();

  // REGISTER USER
  Future<UserModel> registerUser(
    String username,
    String email,
    String password,
  ) async {
    final response = await _apiService.post(
      'register',
      {
        'username': username,
        'email': email,
        'password': password,
      },
    );

    // Example response handling
    return UserModel.fromMap(response['user']);
  }

  // LOGIN USER (future use)
  Future<UserModel> loginUser(
    String email,
    String password,
  ) async {
    final response = await _apiService.post(
      'login',
      {
        'email': email,
        'password': password,
      },
    );

    return UserModel.fromMap(response['user']);
  }
}