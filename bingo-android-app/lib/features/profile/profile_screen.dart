import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/network/api_client.dart';
import '../session/session_store.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final ApiClient _apiClient = ApiClient();

  Future<void> _logout(BuildContext context) async {
    await SessionStore().clearSession();
    if (!context.mounted) return;
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder<Map<String, dynamic>>(
        future: _apiClient.get('/api/users/profile', authenticated: true),
        builder: (context, snapshot) {
          final user = snapshot.data;
          final username = user?['username']?.toString() ?? 'Profile';
          final email = user?['email']?.toString() ?? '';
          final points = user?['points']?.toString() ?? '0';

          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 34,
                  child: Icon(Icons.person, size: 36),
                ),
                const SizedBox(height: 16),
                Text(
                  username,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                if (snapshot.connectionState == ConnectionState.waiting)
                  const Text(
                    'Loading profile...',
                    style: TextStyle(color: Color(0xFF6B7280)),
                  )
                else if (snapshot.hasError)
                  Text(
                    'Failed to load profile: ${snapshot.error}',
                    style: const TextStyle(color: Color(0xFFB91C1C)),
                  )
                else
                  Text(
                    '$email\n$points points',
                    style: const TextStyle(color: Color(0xFF6B7280)),
                  ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => _logout(context),
                  child: const Text('Log out'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
