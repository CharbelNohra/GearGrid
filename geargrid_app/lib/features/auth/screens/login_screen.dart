import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../main.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: SwitchListTile(
          title: const Text("Dark Mode"),
          value: themeProvider.themeMode == ThemeMode.dark,
          onChanged: (value) {
            ref.read(themeModeProvider).toggleTheme(value);
          },
        ),
      ),
    );
  }
}