import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../shared/app_scaffold.dart';
import 'home_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dailyTipAsync = ref.watch(dailyTipProvider);
    final searchResultsAsync = ref.watch(tipSearchProvider);
    final query = ref.watch(tipSearchQueryProvider);

    return AppScaffold(
      title: 'BinGo Home',
      currentIndex: 0,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/scan'),
        icon: const Icon(Icons.camera_alt_outlined),
        label: const Text('Scan'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(dailyTipProvider);
          ref.invalidate(tipSearchProvider);
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: dailyTipAsync.when(
                  data: (tip) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'Daily Tip',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        tip.title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(tip.content),
                    ],
                  ),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (Object error, StackTrace stackTrace) =>
                      Text('Tip failed: $error'),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Search recycling tips',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (String value) =>
                  ref.read(tipSearchQueryProvider.notifier).state = value,
            ),
            const SizedBox(height: 12),
            if (query.trim().isNotEmpty)
              searchResultsAsync.when(
                data: (results) {
                  if (results.isEmpty) {
                    return const Text('No tips found for this query.');
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: results
                        .map(
                          (tip) => ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(tip.title),
                            subtitle: Text(tip.content),
                          ),
                        )
                        .toList(),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (Object error, StackTrace stackTrace) =>
                    Text('Search failed: $error'),
              ),
          ],
        ),
      ),
    );
  }
}
