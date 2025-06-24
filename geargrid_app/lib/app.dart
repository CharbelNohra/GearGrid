import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'router/app_router.dart';
import 'core/theme/app_theme.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'My E-Commerce App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      // darkTheme: AppTheme.darkTheme,
      routerConfig: router,
    );
  }
}