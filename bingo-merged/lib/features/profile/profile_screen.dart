import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../session/session_store.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    await SessionStore().clearSession();
    if (!context.mounted) return;
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(radius: 34, child: Icon(Icons.person, size: 36)),
            const SizedBox(height: 16),
            const Text(
              'Profile',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Placeholder profile screen for the merged app.',
              style: TextStyle(color: Color(0xFF6B7280)),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => _logout(context),
              child: const Text('Log out'),
            ),
          ],
        ),
      ),
    );
  }
}
