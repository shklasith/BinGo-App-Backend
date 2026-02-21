import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../domain/repositories/session_repository.dart';

const _userIdKey = 'bingo_user_id';

final secureStorageProvider = Provider<FlutterSecureStorage>(
  (ref) => const FlutterSecureStorage(),
);

class SessionRepositoryImpl implements SessionRepository {
  SessionRepositoryImpl(this._storage);

  final FlutterSecureStorage _storage;

  @override
  Future<void> clear() => _storage.delete(key: _userIdKey);

  @override
  Future<String?> getUserId() => _storage.read(key: _userIdKey);

  @override
  Future<void> setUserId(String userId) =>
      _storage.write(key: _userIdKey, value: userId);
}
