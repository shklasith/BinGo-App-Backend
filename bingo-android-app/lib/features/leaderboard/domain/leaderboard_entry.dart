class LeaderboardEntry {
  const LeaderboardEntry({required this.username, required this.points});

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      username: json['username']?.toString() ?? 'Unknown',
      points: _toInt(json['points']),
    );
  }

  final String username;
  final int points;
}

int _toInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}
