import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../presentation/settings/settings_controller.dart';
import '../presentation/shared/app_theme.dart';
import 'router.dart';

class BingoApp extends ConsumerWidget {
  const BingoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    final themeMode = ref.watch(appThemeModeProvider);
    return MaterialApp.router(
      title: 'BinGo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.buildTheme(),
      darkTheme: AppTheme.buildDarkTheme(),
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
