import '../../core/network/api_client.dart';
import 'domain/leaderboard_entry.dart';

class LeaderboardRepository {
  LeaderboardRepository({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<List<LeaderboardEntry>> fetchLeaderboard() async {
    final data = await _apiClient.get('/api/users/leaderboard');
    final users = data['data'];

    if (users is! List) {
      return const <LeaderboardEntry>[];
    }

    return users
        .map((user) => LeaderboardEntry.fromJson(user as Map<String, dynamic>))
        .toList();
  }
}
