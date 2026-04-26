import 'package:flutter/material.dart';

import '../shared/theme/app_theme.dart';
import 'router.dart';

class BingoMergedApp extends StatelessWidget {
  const BingoMergedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'BinGo Merged',
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
    );
  }
}
