import 'package:flutter/material.dart';

import '../../shared/theme/app_theme.dart';
import 'domain/leaderboard_entry.dart';
import 'leaderboard_repository.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  late Future<List<LeaderboardEntry>> _leaderboardFuture;

  @override
  void initState() {
    super.initState();
    _leaderboardFuture = LeaderboardRepository().fetchLeaderboard();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder<List<LeaderboardEntry>>(
        future: _leaderboardFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Failed to load leaderboard: ${snapshot.error}'),
            );
          }

          final users = snapshot.data ?? [];
          if (users.isEmpty) {
            return const Center(child: Text('No leaderboard data found.'));
          }

          return ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.primary, Color(0xFF16A34A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(36),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                child: Column(
                  children: [
                    const Text(
                      'Leaderboard',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Top recyclers in your area',
                      style: TextStyle(color: Color(0xFFD1FAE5)),
                    ),
                    const SizedBox(height: 22),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: const [
                        _Podium(
                          rank: '2',
                          points: '3.9k',
                          height: 94,
                          borderColor: Color(0xFFD1D5DB),
                        ),
                        SizedBox(width: 10),
                        _Podium(
                          rank: '1',
                          points: '4.2k',
                          height: 122,
                          borderColor: Color(0xFFFACC15),
                        ),
                        SizedBox(width: 10),
                        _Podium(
                          rank: '3',
                          points: '3.1k',
                          height: 78,
                          borderColor: Color(0xFFD97706),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Transform.translate(
                offset: const Offset(0, -20),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x14000000),
                        blurRadius: 20,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: List.generate(
                      users.length,
                      (index) => _RankRow(
                        user: users[index],
                        rank: index + 1,
                        last: index == users.length - 1,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Podium extends StatelessWidget {
  const _Podium({
    required this.rank,
    required this.points,
    required this.height,
    required this.borderColor,
  });

  final String rank;
  final String points;
  final double height;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: rank == '1' ? 62 : 48,
          height: rank == '1' ? 62 : 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: borderColor, width: 4),
          ),
          child: Center(
            child: rank == '1'
                ? const Icon(
                    Icons.emoji_events,
                    color: Color(0xFFEAB308),
                    size: 28,
                  )
                : Text(
                    rank,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: borderColor == const Color(0xFFD1D5DB)
                          ? const Color(0xFF6B7280)
                          : const Color(0xFF92400E),
                    ),
                  ),
          ),
        ),
        Container(
          width: 78,
          height: height,
          margin: const EdgeInsets.only(top: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: rank == '1' ? 0.35 : 0.2),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
          ),
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            points,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _RankRow extends StatelessWidget {
  const _RankRow({required this.user, required this.rank, required this.last});

  final LeaderboardEntry user;
  final int rank;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        border: last
            ? null
            : const Border(bottom: BorderSide(color: Color(0xFFF3F4F6))),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 26,
            child: Text(
              '$rank',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: rank <= 3 ? AppTheme.text : const Color(0xFF9CA3AF),
              ),
            ),
          ),
          const SizedBox(width: 10),
          CircleAvatar(
            radius: 20,
            backgroundColor: rank == 1
                ? const Color(0xFFFEF3C7)
                : const Color(0xFFF3F4F6),
            child: Text(
              user.username.isEmpty ? '?' : user.username[0].toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: rank == 1
                    ? const Color(0xFFB45309)
                    : const Color(0xFF6B7280),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              user.username,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          Text(
            '${user.points} pts',
            style: const TextStyle(
              color: AppTheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
