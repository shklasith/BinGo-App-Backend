import 'domain/leaderboard_entry.dart';

class LeaderboardRepository {
  Future<List<LeaderboardEntry>> fetchLeaderboard() async {
    await Future<void>.delayed(const Duration(seconds: 1));
    return const [
      LeaderboardEntry(username: 'Alice', points: 4200),
      LeaderboardEntry(username: 'Bob', points: 3900),
      LeaderboardEntry(username: 'Carol', points: 3100),
      LeaderboardEntry(username: 'David', points: 2800),
      LeaderboardEntry(username: 'Eve', points: 2400),
    ];
  }
}
