import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavShell extends StatelessWidget {
  final Widget child;

  const BottomNavShell({super.key, required this.child});

  // ✅ Get current index based on route
  int _getIndex(String location) {
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/leaderboard')) return 1;
    if (location.startsWith('/centers')) return 2;
    if (location.startsWith('/profile')) return 3;
    return 0;
  }



  @override
  Widget build(BuildContext context) {
    // ✅ FIX: use GoRouter.of(context)
    // ignore: deprecated_member_use
    final location = GoRouter.of(context)..uri.toString();
    var uri = Uri.parse(location.uri.toString());
    final currentIndex = _getIndex(uri.toString());

    return Scaffold(
      body: child,

      // 📷 Camera FAB
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/scan'),
        backgroundColor: Colors.green,
        elevation: 6,
        child: const Icon(Icons.camera_alt, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // 🔥 Bottom Navigation
      bottomNavigationBar: SafeArea(
        child: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 8,
          child: SizedBox(
            height: 65,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _navItem(context, Icons.home, 0, "Home", currentIndex),
                _navItem(context, Icons.emoji_events, 1, "Leaderboard", currentIndex),

                const SizedBox(width: 50), // space for FAB

                _navItem(context, Icons.location_on, 2, "Centers", currentIndex),
                _navItem(context, Icons.person, 3, "Profile", currentIndex),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(
    BuildContext context,
    IconData icon,
    int index,
    String label,
    int currentIndex,
  ) {
    final routes = [
      '/home',
      '/leaderboard',
      
      '/centers',
      '/profile',
    ];

    final isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => context.go(routes[index]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.green : Colors.grey,
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isSelected ? Colors.green : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

extension on GoRouter {
  get uri => null;
}
