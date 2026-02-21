import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../session/session_controller.dart';
import '../shared/app_scaffold.dart';
import 'profile_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);

    return AppScaffold(
      title: 'Profile',
      currentIndex: 3,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          profileAsync.when(
            data: (user) => Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      user.username,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(user.email),
                    const Divider(height: 24),
                    Text('Points: ${user.points}'),
                    const SizedBox(height: 4),
                    Text(
                      'Badges: ${user.badges.isEmpty ? 'None' : user.badges.join(', ')}',
                    ),
                    const SizedBox(height: 8),
                    Text('Trees saved: ${user.impactStats.treesSaved}'),
                    Text(
                      'Plastic diverted: ${user.impactStats.plasticDiverted}',
                    ),
                    Text(
                      'CO2 reduced: ${user.impactStats.co2Reduced.toStringAsFixed(2)}',
                    ),
                  ],
                ),
              ),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (Object error, StackTrace stackTrace) =>
                Text('Failed to load profile: $error'),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () async {
              await ref.read(sessionControllerProvider.notifier).clear();
              if (context.mounted) {
                context.go('/register');
              }
            },
            icon: const Icon(Icons.logout),
            label: const Text('Clear session'),
          ),
        ],
      ),
    );
  }
}
