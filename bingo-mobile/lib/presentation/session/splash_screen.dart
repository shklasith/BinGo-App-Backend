import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'session_controller.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(sessionControllerProvider, (previous, next) {
      next.whenData((String? userId) {
        if (!context.mounted) {
          return;
        }
        if (userId == null || userId.isEmpty) {
          context.go('/register');
        } else {
          context.go('/home');
        }
      });
    });

    final sessionState = ref.watch(sessionControllerProvider);

    return Scaffold(
      body: Center(
        child: sessionState.when(
          data: (_) => const CircularProgressIndicator(),
          loading: () => const CircularProgressIndicator(),
          error: (Object error, StackTrace stackTrace) => Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Failed to initialize session: $error'),
          ),
        ),
      ),
    );
  }
}
