import '../../domain/entities/leaderboard_entry.dart';


class LeaderboardRepository {
  Future<List<LeaderboardEntry>> fetchLeaderboard() async {
    // Replace with your real API / Firestore / local DB call
    // Example mock data:
    await Future.delayed(const Duration(seconds: 1));
    return [
      const LeaderboardEntry(username: 'Alice', points: 4200),
      const LeaderboardEntry(username: 'Bob', points: 3900),
      const LeaderboardEntry(username: 'Carol', points: 3100),
      const LeaderboardEntry(username: 'David', points: 2800),
      const LeaderboardEntry(username: 'Eve', points: 2400),
    ];
  }
}
