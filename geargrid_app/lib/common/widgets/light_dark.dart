import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../main.dart';

class LightDark extends ConsumerWidget {
  const LightDark({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeProvider = ref.watch(themeModeProvider);

    return SwitchListTile(
      title: const Text("Dark/Light"),
      subtitle: Text(
        themeProvider.themeMode == ThemeMode.dark ? "Dark Mode" : "Light Mode",
      ),
      secondary: Icon(
        themeProvider.themeMode == ThemeMode.dark
            ? Icons.dark_mode
            : Icons.light_mode,
      ),
      value: themeProvider.themeMode == ThemeMode.dark,
      onChanged: (value) {
        ref.read(themeModeProvider).toggleTheme(value);
      },
    );
  }
}
