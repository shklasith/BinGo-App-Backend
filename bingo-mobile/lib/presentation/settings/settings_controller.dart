import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/repository_providers.dart';
import '../../domain/entities/app_settings.dart';

final settingsControllerProvider =
    AsyncNotifierProvider<SettingsController, AppSettings>(
      SettingsController.new,
    );

final appThemeModeProvider = Provider<ThemeMode>((ref) {
  final settings = ref.watch(settingsControllerProvider);
  return settings.maybeWhen(
    data: (AppSettings value) =>
        value.darkMode ? ThemeMode.dark : ThemeMode.light,
    orElse: () => ThemeMode.light,
  );
});

class SettingsController extends AsyncNotifier<AppSettings> {
  @override
  Future<AppSettings> build() async {
    final repository = ref.read(settingsRepositoryProvider);
    return repository.loadSettings();
  }

  Future<void> setDarkMode(bool enabled) =>
      _save((AppSettings settings) => settings.copyWith(darkMode: enabled));

  Future<void> setScanReminders(bool enabled) => _save(
    (AppSettings settings) => settings.copyWith(scanReminders: enabled),
  );

  Future<void> setRecyclingTips(bool enabled) => _save(
    (AppSettings settings) => settings.copyWith(recyclingTips: enabled),
  );

  Future<void> _save(AppSettings Function(AppSettings settings) update) async {
    final previous = state.valueOrNull ?? const AppSettings.defaults();
    final next = update(previous);
    state = AsyncData(next);

    final repository = ref.read(settingsRepositoryProvider);
    try {
      await repository.saveSettings(next);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      state = AsyncData(previous);
    }
  }
}
