import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geargrid/core/theme/theme_mode_provider.dart';
import 'app.dart';

final themeModeProvider = ChangeNotifierProvider<ThemeModeProvider>((ref) {
  return ThemeModeProvider();
});

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}