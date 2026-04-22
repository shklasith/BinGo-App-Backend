import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/login_screen.dart';
import '../features/centers/centers_screen.dart';
import '../features/home/home_screen.dart';
import '../features/leaderboard/leaderboard_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/register/register_screen.dart';
import '../features/scan/domain/scan_result.dart';
import '../features/scan/scan_result_screen.dart';
import '../features/scan/scan_screen.dart';
import '../features/session/splash_screen.dart';
import '../shared/widgets/app_shell.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
        GoRoute(
          path: '/leaderboard',
          builder: (context, state) => const LeaderboardScreen(),
        ),
        GoRoute(
          path: '/centers',
          builder: (context, state) => const CentersScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
    GoRoute(path: '/scan', builder: (context, state) => const ScanScreen()),
    GoRoute(
      path: '/scan-result',
      builder: (context, state) {
        final extra = state.extra;
        if (extra is! ScanResultRouteData) {
          return const _MissingScanResultScreen();
        }

        return ScanResultScreen(
          result: extra.result,
          imagePath: extra.imagePath,
        );
      },
    ),
  ],
);

class _MissingScanResultScreen extends StatelessWidget {
  const _MissingScanResultScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Result')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.info_outline, size: 40),
              const SizedBox(height: 16),
              const Text(
                'No scan result was provided.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => context.go('/scan'),
                child: const Text('Back to Scan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
