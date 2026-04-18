import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final int currentIndex;

  const AppScaffold({
    super.key,
    required this.body,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,

      // 📷 FAB for Scan screen
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/scan'),
        backgroundColor: Colors.green,
        child: const Icon(Icons.camera_alt),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color.fromARGB(255, 240, 237, 237),
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,

        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/home');
              break;
            case 1:
              context.go('/leaderboard');
              break;
            case 2:
              context.go('/centers');
              break;
            case 3:
              context.go('/profile');
              break;
          }
        },

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events_outlined),
            label: 'Leaderboard',
          ),

          
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on_outlined),
            label: 'Centers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}