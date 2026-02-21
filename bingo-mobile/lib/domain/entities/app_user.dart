import 'impact_stats.dart';

class AppUser {
  const AppUser({
    required this.id,
    required this.username,
    required this.email,
    required this.points,
    required this.badges,
    required this.impactStats,
  });

  final String id;
  final String username;
  final String email;
  final int points;
  final List<String> badges;
  final ImpactStats impactStats;
}
