import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../main.dart';

class LightDark extends ConsumerWidget {
  const LightDark({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeProvider = ref.watch(themeModeProvider);

    // Return just a Switch widget since it's used as trailing in a ListTile
    return Switch(
      value: themeProvider.themeMode == ThemeMode.dark,
      onChanged: (value) {
        ref.read(themeModeProvider).toggleTheme(value);
      },
    );
  }
}