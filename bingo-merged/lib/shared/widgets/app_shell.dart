import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  static const List<_NavItem> _items = [
    _NavItem(label: 'Home', icon: Icons.home, route: '/home'),
    _NavItem(
      label: 'Leaderboard',
      icon: Icons.emoji_events,
      route: '/leaderboard',
    ),
    _NavItem(label: 'Centers', icon: Icons.location_on, route: '/centers'),
    _NavItem(label: 'Profile', icon: Icons.person, route: '/profile'),
  ];

  int _currentIndex(String location) {
    for (var index = 0; index < _items.length; index++) {
      if (location.startsWith(_items[index].route)) {
        return index;
      }
    }

    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = _currentIndex(location);

    return Scaffold(
      body: child,
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/scan'),
        backgroundColor: Colors.green,
        child: const Icon(Icons.camera_alt, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: SafeArea(
        top: false,
        child: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 8,
          child: SizedBox(
            height: 65,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _navButton(context, 0, currentIndex),
                _navButton(context, 1, currentIndex),
                const SizedBox(width: 50),
                _navButton(context, 2, currentIndex),
                _navButton(context, 3, currentIndex),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navButton(BuildContext context, int index, int currentIndex) {
    final item = _items[index];
    final isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => context.go(item.route),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(item.icon, color: isSelected ? Colors.green : Colors.grey),
          Text(
            item.label,
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

class _NavItem {
  const _NavItem({
    required this.label,
    required this.icon,
    required this.route,
  });

  final String label;
  final IconData icon;
  final String route;
}
