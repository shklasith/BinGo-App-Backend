import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Bottom Nav Shell
import 'bottom_nav_shell.dart';


// Screens
import '../ui/screens/centers/centers_screen.dart';

// ─────────────────────────────────────────
// Temporary Screens (replace later)
// ─────────────────────────────────────────

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Home Screen"));
  }
}

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Leaderboard Screen"));
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Profile Screen"));
  }
}

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Menu Screen")),
    );
  }
}

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Search Screen")),
    );
  }
}

// 📷 Camera Screen (no navbar)
class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Camera Screen")),
    );
  }
}

// ─────────────────────────────────────────
// ✅ GoRouter
// ─────────────────────────────────────────

final GoRouter appRouter = GoRouter(
  initialLocation: '/home',

  routes: [
    // 🔥 Bottom Navigation Wrapper
    ShellRoute(
      builder: (context, state, child) {
        return BottomNavShell(child: child);
      },
      routes: [
        // 🏠 Home
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
        ),

        // 🏆 Leaderboard
        GoRoute(
          path: '/leaderboard',
          builder: (context, state) => const LeaderboardScreen(),
        ),

        // 📍 Centers
        GoRoute(
          path: '/centers',
          builder: (context, state) => const CentersScreen(),
        ),

        // 👤 Profile
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),

    // 🔍 Search (no navbar)
    GoRoute(
      path: '/search',
      builder: (context, state) => const SearchScreen(),
    ),

    // ☰ Menu (no navbar)
    GoRoute(
      path: '/menu',
      builder: (context, state) => const MenuScreen(),
    ),

    // 📷 Camera (FULL SCREEN)
    GoRoute(
      path: '/scan',
      builder: (context, state) => const ScanScreen(),
    ),
  ],

  // ❌ Error Page
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Page not found: ${state.uri}'),
    ),
  ),
);