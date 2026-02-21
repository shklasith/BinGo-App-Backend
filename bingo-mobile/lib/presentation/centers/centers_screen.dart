import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../shared/app_scaffold.dart';
import 'centers_controller.dart';

class CentersScreen extends ConsumerStatefulWidget {
  const CentersScreen({super.key});

  @override
  ConsumerState<CentersScreen> createState() => _CentersScreenState();
}

class _CentersScreenState extends ConsumerState<CentersScreen> {
  Future<void> _loadNearby() async {
    final locationPermission = await Permission.locationWhenInUse.request();
    if (!locationPermission.isGranted) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permission is required.')),
      );
      return;
    }

    final position = await Geolocator.getCurrentPosition();
    await ref
        .read(centersControllerProvider.notifier)
        .loadNearby(position.latitude, position.longitude);
  }

  @override
  Widget build(BuildContext context) {
    final centersAsync = ref.watch(centersControllerProvider);

    return AppScaffold(
      title: 'Nearby Centers',
      currentIndex: 1,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          ElevatedButton.icon(
            onPressed: _loadNearby,
            icon: const Icon(Icons.my_location_outlined),
            label: const Text('Find nearby centers'),
          ),
          const SizedBox(height: 12),
          centersAsync.when(
            data: (centers) {
              if (centers.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'No centers loaded yet or none found for this area.',
                  ),
                );
              }

              return Column(
                children: centers
                    .map(
                      (center) => Card(
                        child: ListTile(
                          title: Text(center.name),
                          subtitle: Text(
                            '${center.address}\n${center.operatingHours}',
                          ),
                          isThreeLine: true,
                          trailing: const Icon(Icons.chevron_right),
                        ),
                      ),
                    )
                    .toList(),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (Object error, StackTrace stackTrace) =>
                Text('Failed to load centers: $error'),
          ),
        ],
      ),
    );
  }
}
