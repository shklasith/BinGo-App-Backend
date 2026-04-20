class AppSettings {
  const AppSettings({
    required this.darkMode,
    required this.scanReminders,
    required this.recyclingTips,
  });

  const AppSettings.defaults()
    : darkMode = false,
      scanReminders = true,
      recyclingTips = true;

  final bool darkMode;
  final bool scanReminders;
  final bool recyclingTips;

  AppSettings copyWith({
    bool? darkMode,
    bool? scanReminders,
    bool? recyclingTips,
  }) {
    return AppSettings(
      darkMode: darkMode ?? this.darkMode,
      scanReminders: scanReminders ?? this.scanReminders,
      recyclingTips: recyclingTips ?? this.recyclingTips,
    );
  }
}
