import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../shared/app_scaffold.dart';
import 'leaderboard_provider.dart';

class LeaderboardScreen extends ConsumerWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaderboardAsync = ref.watch(leaderboardProvider);

    return AppScaffold(
      title: 'Leaderboard',
      currentIndex: 2,
      body: leaderboardAsync.when(
        data: (users) {
          if (users.isEmpty) {
            return const Center(child: Text('No leaderboard data found.'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: users.length,
            separatorBuilder: (_, index) => const SizedBox(height: 8),
            itemBuilder: (BuildContext context, int index) {
              final user = users[index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(child: Text('${index + 1}')),
                  title: Text(user.username),
                  subtitle: Text('Badges: ${user.badges.join(', ')}'),
                  trailing: Text('${user.points} pts'),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (Object error, StackTrace stackTrace) =>
            Center(child: Text('Failed to load leaderboard: $error')),
      ),
    );
  }
}
