import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../core/settings/settings_keys.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl(this._storage);

  final FlutterSecureStorage _storage;

  @override
  Future<AppSettings> loadSettings() async {
    final darkMode = await _storage.read(key: settingsDarkModeKey);
    final scanReminders = await _storage.read(key: settingsScanRemindersKey);
    final recyclingTips = await _storage.read(key: settingsRecyclingTipsKey);

    return AppSettings(
      darkMode: _parseBool(darkMode, fallback: false),
      scanReminders: _parseBool(scanReminders, fallback: true),
      recyclingTips: _parseBool(recyclingTips, fallback: true),
    );
  }

  @override
  Future<void> saveSettings(AppSettings settings) async {
    await _storage.write(
      key: settingsDarkModeKey,
      value: settings.darkMode.toString(),
    );
    await _storage.write(
      key: settingsScanRemindersKey,
      value: settings.scanReminders.toString(),
    );
    await _storage.write(
      key: settingsRecyclingTipsKey,
      value: settings.recyclingTips.toString(),
    );
  }

  bool _parseBool(String? value, {required bool fallback}) {
    if (value == null) {
      return fallback;
    }

    return value.toLowerCase() == 'true';
  }
}
