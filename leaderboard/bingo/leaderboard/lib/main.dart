import 'package:flutter/material.dart';
import 'presentation/leaderboard/leaderboard_screen.dart';
import 'presentation/shared/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recycler App',
      theme: AppTheme.theme,
      home: const LeaderboardScreen(),
    );
  }
}
