import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'BinGo',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          const Text(
            'One merged app for register, scan, centers, and leaderboard flows.',
            style: TextStyle(color: Color(0xFF6B7280), fontSize: 16),
          ),
          const SizedBox(height: 24),
          _FeatureCard(
            title: 'Scan Materials',
            description: 'Use the preserved camera-style scan UI.',
            buttonLabel: 'Open Scan',
            onTap: () => context.go('/scan'),
          ),
          const SizedBox(height: 16),
          _FeatureCard(
            title: 'Find Recycling Centers',
            description: 'View the map-style nearby center experience.',
            buttonLabel: 'Open Centers',
            onTap: () => context.go('/centers'),
          ),
          const SizedBox(height: 16),
          _FeatureCard(
            title: 'View Leaderboard',
            description: 'See the preserved leaderboard UI and ranking cards.',
            buttonLabel: 'Open Leaderboard',
            onTap: () => context.go('/leaderboard'),
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.title,
    required this.description,
    required this.buttonLabel,
    required this.onTap,
  });

  final String title;
  final String description;
  final String buttonLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(description),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: onTap, child: Text(buttonLabel)),
        ],
      ),
    );
  }
}
